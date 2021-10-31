module Text.XML.HXT.XInclude (extract) where

import System.FilePath (takeDirectory, (</>))
import Text.XML.HXT.Core

extract :: IOSArrow XmlTree XmlTree
extract =
  ( \s ->
      processBottomUp
        ( ( ( \(h, p) ->
                let h' :: String
                    h' = takeDirectory s </> h
                 in choiceA
                      [ isA (\_ -> p == "text") :-> (txt $< arrIO (\_ -> readFile h')),
                        isA (\_ -> p == "xml" || p == "")
                          :-> ( readDocument [] h'
                                  >>> extract
                                  >>> getChildren
                              )
                      ]
            )
              $< (getAttrValue "href" &&& getAttrValue "parse")
          )
            `when` hasQName (mkQName "xi" "include" "http://www.w3.org/2001/XInclude")
        )
  )
    $< getAttrValue "source"
