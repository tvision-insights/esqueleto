{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies      #-}

module ReadWrite.ShouldNotTypeCheck.Common
  ( module ReadWrite.ShouldNotTypeCheck.Common
  , module Export
  ) where

import Control.Monad as Export (void)
import Control.Monad.IO.Class as Export
import Control.Monad.Logger as Export
import Control.Monad.Trans.Reader as Export
import Database.Esqueleto as Export hiding (random_)
import Database.Persist.Postgresql as Export (withPostgresqlConn)
import Test.Hspec as Export
import Control.Monad.Trans.Resource as Export

import Common.Test as Export

type DBM = NoLoggingT (ResourceT IO)

runRead :: ReaderT SqlReadBackend DBM a
        -> IO a
runRead act = run_worker act

-- runRead act = runNoLoggingT $ run_worker act

runWrite :: ReaderT SqlWriteBackend DBM a -> IO a
runWrite act = run_worker act

migrateIt :: ReaderT SqlBackend DBM ()
migrateIt = do
  void $ runMigrationSilent migrateAll

run_worker
  :: ( -- RunDbMonad m
     -- , LogIO m
       IsSqlBackend backend
     , BackendCompatible SqlBackend backend
     )
  => ReaderT backend DBM a
  -> IO a
run_worker act = do
  runDB $ do
    withReaderT projectBackend migrateIt
    act

runDB
  :: ( -- RunDbMonad m
     -- , LogIO m
       IsSqlBackend backend
     )
  => ReaderT backend DBM a
  -> IO a
runDB action = runResourceT $ runNoLoggingT $
  withPostgresqlConn "host=localhost port=5432 user=esqutest password=esqutest dbname=esqutest" $ runReaderT action
