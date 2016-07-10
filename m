Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60611 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbcGJKsC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jul 2016 06:48:02 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 1/6] [media] doc-rst: Group function references together for MC
Date: Sun, 10 Jul 2016 07:47:40 -0300
Message-Id: <ac525448abfe5b4eb7dc3f06397f5feaa9be6d76.1468147615.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just like the other parts of the media book, group the MC
functions together on one chapter.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../media/uapi/mediactl/media-controller.rst         | 20 +-------------------
 Documentation/media/uapi/mediactl/media-funcs.rst    | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 19 deletions(-)
 create mode 100644 Documentation/media/uapi/mediactl/media-funcs.rst

diff --git a/Documentation/media/uapi/mediactl/media-controller.rst b/Documentation/media/uapi/mediactl/media-controller.rst
index 0c1296c59571..7e08c93a15ab 100644
--- a/Documentation/media/uapi/mediactl/media-controller.rst
+++ b/Documentation/media/uapi/mediactl/media-controller.rst
@@ -22,27 +22,9 @@ Media Controller
     media-controller-intro
     media-controller-model
     media-types
+    media-funcs
     media-header
 
-.. _media-user-func:
-
-******************
-Function Reference
-******************
-
-
-.. toctree::
-    :maxdepth: 1
-
-    media-func-open
-    media-func-close
-    media-func-ioctl
-    media-ioc-device-info
-    media-ioc-g-topology
-    media-ioc-enum-entities
-    media-ioc-enum-links
-    media-ioc-setup-link
-
 
 **********************
 Revision and Copyright
diff --git a/Documentation/media/uapi/mediactl/media-funcs.rst b/Documentation/media/uapi/mediactl/media-funcs.rst
new file mode 100644
index 000000000000..076856501cdb
--- /dev/null
+++ b/Documentation/media/uapi/mediactl/media-funcs.rst
@@ -0,0 +1,18 @@
+.. _media-user-func:
+
+******************
+Function Reference
+******************
+
+
+.. toctree::
+    :maxdepth: 1
+
+    media-func-open
+    media-func-close
+    media-func-ioctl
+    media-ioc-device-info
+    media-ioc-g-topology
+    media-ioc-enum-entities
+    media-ioc-enum-links
+    media-ioc-setup-link
-- 
2.7.4

