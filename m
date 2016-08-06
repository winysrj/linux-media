Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51086 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbcHFVBG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Aug 2016 17:01:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 1/3] doc-rst: support additional Sphinx build config override
Date: Sat,  6 Aug 2016 09:00:32 -0300
Message-Id: <59ea63bcd09224709a43db9cdb261f658d4a90e5.1470484077.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1470484077.git.mchehab@s-opensource.com>
References: <cover.1470484077.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1470484077.git.mchehab@s-opensource.com>
References: <cover.1470484077.git.mchehab@s-opensource.com>
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
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py               |  9 +++++++++
 Documentation/sphinx/load_config.py | 25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+)
 create mode 100644 Documentation/sphinx/load_config.py

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 96b7aa66c89c..d5027750503a 100644
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
index 000000000000..44bdd2271d13
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


