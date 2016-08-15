Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:33598 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbcHOOIv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 10:08:51 -0400
From: Markus Heiser <markus.heiser@darmarit.de>
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/5] doc-rst: add boilerplate to customize c-domain
Date: Mon, 15 Aug 2016 16:08:24 +0200
Message-Id: <1471270108-29314-2-git-send-email-markus.heiser@darmarit.de>
In-Reply-To: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
References: <1471270108-29314-1-git-send-email-markus.heiser@darmarit.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Add a sphinx-extension to customize the sphinx c-domain.  No functional
changes right yet, just the boilerplate code.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
---
 Documentation/conf.py           |  2 +-
 Documentation/sphinx/cdomain.py | 44 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/sphinx/cdomain.py

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 5c06b01..dc46d23 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -29,7 +29,7 @@ from load_config import loadConfig
 # Add any Sphinx extension module names here, as strings. They can be
 # extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
 # ones.
-extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include']
+extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include', 'cdomain']
 
 # Gracefully handle missing rst2pdf.
 try:
diff --git a/Documentation/sphinx/cdomain.py b/Documentation/sphinx/cdomain.py
new file mode 100644
index 0000000..c32387a
--- /dev/null
+++ b/Documentation/sphinx/cdomain.py
@@ -0,0 +1,44 @@
+# -*- coding: utf-8; mode: python -*-
+u"""
+    cdomain
+    ~~~~~~~
+
+    Replacement for the sphinx c-domain.
+
+    :copyright:  Copyright (C) 2016  Markus Heiser
+    :license:    GPL Version 2, June 1991 see Linux/COPYING for details.
+"""
+
+from sphinx.domains.c import CObject as Base_CObject
+from sphinx.domains.c import CDomain as Base_CDomain
+
+__version__  = '1.0'
+
+def setup(app):
+
+    app.override_domain(CDomain)
+
+    return dict(
+        version = __version__
+        , parallel_read_safe = True
+        , parallel_write_safe = True
+    )
+
+class CObject(Base_CObject):
+
+    """
+    Description of a C language object.
+    """
+
+class CDomain(Base_CDomain):
+
+    """C language domain."""
+    name = 'c'
+    label = 'C'
+    directives = {
+        'function': CObject,
+        'member':   CObject,
+        'macro':    CObject,
+        'type':     CObject,
+        'var':      CObject,
+    }
-- 
2.7.4

