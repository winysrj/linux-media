Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:53714 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932184AbcHXNfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 09:35:48 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] doc-rst:sphinx-extensions: add metadata parallel-safe
Date: Wed, 24 Aug 2016 15:35:24 +0200
Message-Id: <1472045724-14559-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

The setup() function of a Sphinx-extension can return a dictionary. This
is treated by Sphinx as metadata of the extension [1].

With metadata "parallel_read_safe = True" a extension is marked as
save for "parallel reading of source". This is needed if you want
build in parallel with N processes. E.g.:

  make SPHINXOPTS=-j4 htmldocs

will no longer log warnings like:

  WARNING: the foobar extension does not declare if it is safe for
  parallel reading, assuming it isn't - please ask the extension author
  to check and make it explicit.

Add metadata to extensions:

* kernel-doc
* flat-table
* kernel-include

[1] http://www.sphinx-doc.org/en/stable/extdev/#extension-metadata

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/sphinx/kernel-doc.py     | 8 ++++++++
 Documentation/sphinx/kernel_include.py | 7 +++++++
 Documentation/sphinx/rstFlatTable.py   | 6 ++++++
 3 files changed, 21 insertions(+)
 mode change 100644 => 100755 Documentation/sphinx/rstFlatTable.py

diff --git a/Documentation/sphinx/kernel-doc.py b/Documentation/sphinx/kernel-doc.py
index f6920c0..d15e07f 100644
--- a/Documentation/sphinx/kernel-doc.py
+++ b/Documentation/sphinx/kernel-doc.py
@@ -39,6 +39,8 @@ from docutils.parsers.rst import directives
 from sphinx.util.compat import Directive
 from sphinx.ext.autodoc import AutodocReporter
 
+__version__  = '1.0'
+
 class KernelDocDirective(Directive):
     """Extract kernel-doc comments from the specified file"""
     required_argument = 1
@@ -139,3 +141,9 @@ def setup(app):
     app.add_config_value('kerneldoc_verbosity', 1, 'env')
 
     app.add_directive('kernel-doc', KernelDocDirective)
+
+    return dict(
+        version = __version__,
+        parallel_read_safe = True,
+        parallel_write_safe = True
+    )
diff --git a/Documentation/sphinx/kernel_include.py b/Documentation/sphinx/kernel_include.py
index db57382..f523aa6 100755
--- a/Documentation/sphinx/kernel_include.py
+++ b/Documentation/sphinx/kernel_include.py
@@ -39,11 +39,18 @@ from docutils.parsers.rst import directives
 from docutils.parsers.rst.directives.body import CodeBlock, NumberLines
 from docutils.parsers.rst.directives.misc import Include
 
+__version__  = '1.0'
+
 # ==============================================================================
 def setup(app):
 # ==============================================================================
 
     app.add_directive("kernel-include", KernelInclude)
+    return dict(
+        version = __version__,
+        parallel_read_safe = True,
+        parallel_write_safe = True
+    )
 
 # ==============================================================================
 class KernelInclude(Include):
diff --git a/Documentation/sphinx/rstFlatTable.py b/Documentation/sphinx/rstFlatTable.py
old mode 100644
new mode 100755
index 26db852..55f2757
--- a/Documentation/sphinx/rstFlatTable.py
+++ b/Documentation/sphinx/rstFlatTable.py
@@ -73,6 +73,12 @@ def setup(app):
     roles.register_local_role('cspan', c_span)
     roles.register_local_role('rspan', r_span)
 
+    return dict(
+        version = __version__,
+        parallel_read_safe = True,
+        parallel_write_safe = True
+    )
+
 # ==============================================================================
 def c_span(name, rawtext, text, lineno, inliner, options=None, content=None):
 # ==============================================================================
-- 
2.7.4

