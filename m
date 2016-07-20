Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbcGTOlk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:41:40 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/5] [media] doc-rst: backward compatibility with older Sphinx versions
Date: Wed, 20 Jul 2016 11:41:31 -0300
Message-Id: <ef88f10eb877c427a61c3aacc7ed08ffed0712ab.1469025360.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx is really evil when an older version finds an extra
attribute for the :toctree: tag: it simply ignores everything
and produce documents without any chapter inside!

As we're now using tags available only on Sphinx 1.4.x, we
need to use some creative ways to add a title before the
table of contents. Do that by using a css class.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/dvb-drivers/index.rst       | 5 +++--
 Documentation/media/media_kapi.rst              | 6 ++++--
 Documentation/media/media_uapi.rst              | 5 +++--
 Documentation/media/v4l-drivers/index.rst       | 5 +++--
 Documentation/sphinx-static/theme_overrides.css | 5 +++++
 5 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index e1d4d87f2a47..e4c2e74db9dc 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -14,12 +14,13 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+	Table of Contents
 
 .. toctree::
 	:maxdepth: 5
 	:numbered:
-	:caption: Table of Contents
-	:name: dvb_mastertoc
 
 	intro
 	avermedia
diff --git a/Documentation/media/media_kapi.rst b/Documentation/media/media_kapi.rst
index 0af80e90b7b5..5414d2a7dfb8 100644
--- a/Documentation/media/media_kapi.rst
+++ b/Documentation/media/media_kapi.rst
@@ -14,11 +14,13 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+        Table of Contents
+
 .. toctree::
     :maxdepth: 5
     :numbered:
-    :caption: Table of Contents
-    :name: kapi_mastertoc
 
     kapi/v4l2-framework
     kapi/v4l2-controls
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index debe4531040b..aaa9a0e387c4 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -14,11 +14,12 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+        Table of Contents
 
 .. toctree::
     :maxdepth: 5
-    :caption: Table of Contents
-    :name: uapi_mastertoc
 
     intro
     uapi/v4l/v4l2
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 8d1710234e5a..2aab653905ce 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -14,12 +14,13 @@ any later version published by the Free Software Foundation. A copy of
 the license is included in the chapter entitled "GNU Free Documentation
 License".
 
+.. class:: toc-title
+
+        Table of Contents
 
 .. toctree::
 	:maxdepth: 5
 	:numbered:
-	:caption: Table of Contents
-	:name: v4l_mastertoc
 
 	fourcc
 	v4l-with-ir
diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index c97d8428302d..3a2ac4bcfd78 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -31,6 +31,11 @@
      *   - hide the permalink symbol as long as link is not hovered
      */
 
+    .toc-title {
+        font-size: 150%;
+	font-weight: bold;
+    }
+
     caption, .wy-table caption, .rst-content table.field-list caption {
         font-size: 100%;
     }
-- 
2.7.4

