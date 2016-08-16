Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49447 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbcHPQZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 12:25:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH 9/9] docs-rst: enable the Sphinx math extension
Date: Tue, 16 Aug 2016 13:25:43 -0300
Message-Id: <660237156fd29fa764d83f0f341c51795cbd7bbf.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This extension will be used by the media books.

The name of the math image extension changed on Sphinx 1.4.x,
according with:
	http://www.sphinx-doc.org/en/stable/ext/math.html#module-sphinx.ext.imgmath

Let's autodetect, to keep building with versions < 1.4.

Suggested-by: Markus Heiser <markus.heiser@darmarit.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index ac5230fcda4d..39b9c4a26f6e 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -14,6 +14,11 @@
 
 import sys
 import os
+import sphinx
+
+# Get Sphinx version
+major, minor, patch = map(int, sphinx.__version__.split("."))
+
 
 # If extensions (or modules to document with autodoc) are in another directory,
 # add these directories to sys.path here. If the directory is relative to the
@@ -31,6 +36,12 @@ from load_config import loadConfig
 # ones.
 extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include']
 
+# The name of the math extension changed on Sphinx 1.4
+if minor > 3:
+    extensions.append("sphinx.ext.imgmath")
+else:
+    extensions.append("sphinx.ext.pngmath")
+
 # Add any paths that contain templates here, relative to this directory.
 templates_path = ['_templates']
 
-- 
2.7.4


