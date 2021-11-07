module Text.XML.HXT.XInclude (extract) where

import System.FilePath (takeDirectory, (</>))
import Text.XML.HXT.Core

extract :: IOSArrow XmlTree XmlTree
extract = propagateNamespaces >>> (processWithSourcePath $< getAttrValue "source")

processWithSourcePath :: FilePath -> IOSArrow XmlTree XmlTree
processWithSourcePath s =
  processBottomUp $
    (extractedChildren s $< getAttrValue "href" &&& getAttrValue "parse")
      `when` hasQName (mkQName "xi" "include" "http://www.w3.org/2001/XInclude")

extractedChildren ::
  -- | File path of parent document
  FilePath ->
  -- | XInclude's @href@ and @parse@ attribute values
  (String, String) ->
  -- | Arrow to read file
  IOSArrow XmlTree XmlTree
extractedChildren s (h, p) =
  let h' :: FilePath
      h' = takeDirectory s </> h
   in choiceA
        [ isA (const $ p == "text") :-> (txt $< arrIO0 (readFile h')),
          isA (const $ p == "xml" || p == "")
            :-> ( readDocument [] h'
                    >>> propagateNamespaces
                    >>> extract
                    >>> getChildren
                )
        ]
