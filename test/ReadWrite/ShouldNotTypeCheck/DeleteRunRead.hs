module ReadWrite.ShouldNotTypeCheck.DeleteRunRead where

import ReadWrite.ShouldNotTypeCheck.Common

testWriteFailsInRead :: Spec
testWriteFailsInRead = do
  it "Should not typecheck when we delete under a `RunRead`" $
      runRead $ do
        void $ delete $
                 from $ \person ->
                 where_ (person ^. PersonId ==. val (toSqlKey 1))
