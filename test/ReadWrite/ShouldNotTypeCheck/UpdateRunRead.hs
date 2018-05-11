module ReadWrite.ShouldNotTypeCheck.UpdateRunRead where

import ReadWrite.ShouldNotTypeCheck.Common

testWriteFailsInRead :: Spec
testWriteFailsInRead = do
  it "Should not typecheck when we update under a `RunRead`" $
      runRead $ do
        update $ \person -> do
                  set person [ PersonName =. val "João" ]
                  where_ (person ^. PersonId ==. val (toSqlKey 1))
