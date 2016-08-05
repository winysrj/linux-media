Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:47191 "EHLO smtp3-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759915AbcHEPOp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Aug 2016 11:14:45 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	linux-media@vger.kernel.org
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Jani Nikula <jani.nikula@intel.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH] doc-rst: support *sphinx build themes*
Date: Fri,  5 Aug 2016 17:14:07 +0200
Message-Id: <1470410047-9911-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Load an additional configuration file into conf.py namespace.

The name of the configuration file is taken from the environment
SPHINX_CONF. The external configuration file extends (or overwrites) the
configuration values from the origin conf.py.  With this you are
able to maintain *build themes*.

E.g. to create your own nit-picking *build theme*, create a file
Documentation/conf_nitpick.py::

  nitpicky=True
  nitpick_ignore = [
      ("c:func", "clock_gettime"),
      ...
      ]

and run make with SPHINX_CONF environment::

  make SPHINX_CONF=conf_nitpick.py htmldocs

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/conf.py               |  9 +++++++++
 Documentation/sphinx/load_config.py | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)
 create mode 100644 Documentation/sphinx/load_config.py

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 96b7aa6..d502775 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -20,6 +20,8 @@ import os
 # documentation root, use os.path.abspath to make it absolute, like shown here.
 sys.path.insert(0, os.path.abspath('sphinx'))
 
+from load_config import loadConfig
+
 # -- General configuration ------------------------------------------------
 
 # If your documentation needs a minimal Sphinx version, state it here.
@@ -419,3 +421,10 @@ pdf_documents = [
 # line arguments.
 kerneldoc_bin = '../scripts/kernel-doc'
 kerneldoc_srctree = '..'
+
+
+# ------------------------------------------------------------------------------
+# Since loadConfig overwrites settings from the global namespace, it has to be
+# the last statement in the conf.py file
+# ------------------------------------------------------------------------------
+loadConfig(globals())
diff --git a/Documentation/sphinx/load_config.py b/Documentation/sphinx/load_config.py
new file mode 100644
index 0000000..44bdd22
--- /dev/null
+++ b/Documentation/sphinx/load_config.py
@@ -0,0 +1,25 @@
+# -*- coding: utf-8; mode: python -*-
+# pylint: disable=R0903, C0330, R0914, R0912, E0401
+
+import os
+from sphinx.util.pycompat import execfile_
+
+# ------------------------------------------------------------------------------
+def loadConfig(namespace):
+# ------------------------------------------------------------------------------
+
+    u"""Load an additional configuration file into *namespace*.
+
+    The name of the configuration file is taken from the environment
+    ``SPHINX_CONF``. The external configuration file extends (or overwrites) the
+    configuration values from the origin ``conf.py``.  With this you are able to
+    maintain *build themes*.  """
+
+    config_file = os.environ.get("SPHINX_CONF", None)
+    if config_file is not None and os.path.exists(config_file):
+        config_file = os.path.abspath(config_file)
+        config = namespace.copy()
+        config['__file__'] = config_file
+        execfile_(config_file, config)
+        del config['__file__']
+        namespace.update(config)
-- 
2.7.4

