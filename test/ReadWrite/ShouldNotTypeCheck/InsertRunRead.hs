module ReadWrite.ShouldNotTypeCheck.InsertRunRead where

import ReadWrite.ShouldNotTypeCheck.Common

testWriteFailsInRead :: Spec
testWriteFailsInRead = do
  it "Should not typecheck when we insert under a `RunRead`" $ do
    runRead $ do
      void $ insert p1
