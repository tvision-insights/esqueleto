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

module MaterializedViews.Model.NoMigration where


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


import MaterializedViews.Model

share [ mkPersist sqlSettings ] [persistLowerCase|
MyMaterializedView
  person PersonId
  name String
  age Int Maybe
  blog BlogPostId
  title String
  deriving Eq Show
|]
