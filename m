Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41933 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbcGESkr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 14:40:47 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Markus Heiser <markus.heiser@darmarIT.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 05/12] doc-rst: boilerplate HTML theme customization
Date: Tue,  5 Jul 2016 14:59:21 -0300
Message-Id: <bc21467114b03ce47317cce9a49f0a46cdde50ca.1467743704.git.mchehab@s-opensource.com>
In-Reply-To: <47d23e363fb034f32551f5fe85add77ceba98d3b.1467740686.git.mchehab@s-opensource.com>
References: <47d23e363fb034f32551f5fe85add77ceba98d3b.1467740686.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467743704.git.mchehab@s-opensource.com>
References: <cover.1467743704.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Heiser <markus.heiser@darmarIT.de>

Implements the minimal boilerplate for Sphinx HTML theme customization.

Signed-off-by: Markus Heiser <markus.heiser@darmarIT.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py                           | 9 ++++++++-
 Documentation/sphinx-static/theme_overrides.css | 9 +++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/sphinx-static/theme_overrides.css

diff --git a/Documentation/conf.py b/Documentation/conf.py
index 792b6338ef19..f35748b4bc26 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -176,7 +176,14 @@ except ImportError:
 # Add any paths that contain custom static files (such as style sheets) here,
 # relative to this directory. They are copied after the builtin static files,
 # so a file named "default.css" will overwrite the builtin "default.css".
-#html_static_path = ['_static']
+
+html_static_path = ['sphinx-static']
+
+html_context = {
+    'css_files': [
+        '_static/theme_overrides.css',
+    ],
+}
 
 # Add any extra paths that contain custom files (such as robots.txt or
 # .htaccess) here, relative to this directory. These files are copied
diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
new file mode 100644
index 000000000000..4d670dbf7ffa
--- /dev/null
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -0,0 +1,9 @@
+/* -*- coding: utf-8; mode: css -*-
+ *
+ * Sphinx HTML theme customization
+ *
+ */
+
+@media screen {
+
+}
-- 
2.7.4

