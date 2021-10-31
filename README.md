hxt-xinclude
===============

XInclude support for Haskell XML Toolbox (HXT).

## NOTE

* This library is not feature complete.
* Prefix is fixed to `"xi"`.
  * Namespace URI is `"http://www.w3.org/2001/XInclude"` ([XML Inclusions (XInclude) Version 1.0 (Second Edition) > 3 Syntax](https://www.w3.org/TR/2006/REC-xinclude-20061115/#syntax)).

## Example usage

Create `cabal.project`:

```text
packages: .
 
source-repository-package
  type: git
  location: {{REPOSITORY_URL}}
```

Add to `build-depends` to `*.cabal` (NOTE: specify version correctly):

```cabal
...

executable {{EXECUTABLE_NAME}}
  ...

  build-depends:
    ...
    hxt-xinclude,
    ...

  ...

...
```

Then use it in the code:

```haskell
...

import qualified Text.XML.HXT.XInclude as XInclude (extract)

something :: IOSArrow XmlTree XmlTree
something = processThese >>> propagateNamespaces >>> XInclude.extract >>> processThose

...
```
