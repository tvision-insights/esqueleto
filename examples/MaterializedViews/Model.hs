{-# LANGUAGE FlexibleContexts              #-}
{-# LANGUAGE FlexibleInstances             #-}
{-# LANGUAGE GADTs                         #-}
{-# LANGUAGE GeneralizedNewtypeDeriving    #-}
{-# LANGUAGE MultiParamTypeClasses         #-}
{-# LANGUAGE OverloadedStrings             #-}
{-# LANGUAGE QuasiQuotes                   #-}
{-# LANGUAGE ScopedTypeVariables           #-}
{-# LANGUAGE StandaloneDeriving            #-}
{-# LANGUAGE TemplateHaskell               #-}
{-# LANGUAGE TypeFamilies                  #-}
{-# OPTIONS_GHC -fno-warn-unused-top-binds #-}

module MaterializedViews.Model where

import           Control.Monad               (void)
import           Control.Monad               (forM_)
import           Control.Monad.IO.Class      (MonadIO, liftIO)
import           Control.Monad.Logger        (MonadLogger)
import           Control.Monad.Reader        (MonadReader (..), runReaderT)
import           Control.Monad.Trans.Control (MonadBaseControl)
import           Data.Monoid                 ((<>))
import           Database.Esqueleto
import           Database.Persist.Postgresql (ConnectionString,
                                              withPostgresqlConn)
import           Database.Persist.TH         (mkDeleteCascade, mkMigrate,
                                              mkPersist, persistLowerCase,
                                              share, sqlSettings)

share [ mkPersist sqlSettings
      , mkDeleteCascade sqlSettings
      , mkMigrate "migrateAll"] [persistLowerCase|
Person
  name String
  age Int Maybe
  deriving Eq Show
BlogPost
  title String
  authorId PersonId
  deriving Eq Show
Follow
  follower PersonId
  followed PersonId
  deriving Eq Show
|]
