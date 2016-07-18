Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59569 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbcGRSau (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 14:30:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH 18/18] [media] doc-rst: better name the media books
Date: Mon, 18 Jul 2016 15:30:40 -0300
Message-Id: <e1813eda8e7fdacd992224b79102925cf134be8b.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1468865380.git.mchehab@s-opensource.com>
References: <cover.1468865380.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The titles at the media books were misleading, and some books
were not numbered.

Rename the kAPI book to better reflect its contents, be more
consistent on the initial rst file for each book and better
name them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/index.rst                                   |  2 +-
 Documentation/media/dvb-drivers/index.rst                 |  9 ++++++---
 Documentation/media/{media_drivers.rst => media_kapi.rst} |  9 ++++++---
 Documentation/media/media_uapi.rst                        | 10 +++++-----
 Documentation/media/v4l-drivers/index.rst                 |  8 +++++---
 5 files changed, 23 insertions(+), 15 deletions(-)
 rename Documentation/media/{media_drivers.rst => media_kapi.rst} (76%)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 31273cc2e0bc..43c722f15292 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -15,7 +15,7 @@ Contents:
 
    kernel-documentation
    media/media_uapi
-   media/media_drivers
+   media/media_kapi
    media/dvb-drivers/index
    media/v4l-drivers/index
 
diff --git a/Documentation/media/dvb-drivers/index.rst b/Documentation/media/dvb-drivers/index.rst
index 14da36fe4d01..e1d4d87f2a47 100644
--- a/Documentation/media/dvb-drivers/index.rst
+++ b/Documentation/media/dvb-drivers/index.rst
@@ -2,9 +2,9 @@
 
 .. include:: <isonum.txt>
 
-#############################################
-Linux Digital Video Broadcast (DVB) subsystem
-#############################################
+##############################################
+Linux Digital TV driver-specific documentation
+##############################################
 
 **Copyright** |copy| 2001-2016 : LinuxTV Developers
 
@@ -17,6 +17,9 @@ License".
 
 .. toctree::
 	:maxdepth: 5
+	:numbered:
+	:caption: Table of Contents
+	:name: dvb_mastertoc
 
 	intro
 	avermedia
diff --git a/Documentation/media/media_drivers.rst b/Documentation/media/media_kapi.rst
similarity index 76%
rename from Documentation/media/media_drivers.rst
rename to Documentation/media/media_kapi.rst
index 8e0f455ff6e0..0af80e90b7b5 100644
--- a/Documentation/media/media_drivers.rst
+++ b/Documentation/media/media_kapi.rst
@@ -2,9 +2,9 @@
 
 .. include:: <isonum.txt>
 
-=========================
-Media subsystem core kAPI
-=========================
+===================================
+Media subsystem kernel internal API
+===================================
 
 **Copyright** |copy| 2009-2016 : LinuxTV Developers
 
@@ -16,6 +16,9 @@ License".
 
 .. toctree::
     :maxdepth: 5
+    :numbered:
+    :caption: Table of Contents
+    :name: kapi_mastertoc
 
     kapi/v4l2-framework
     kapi/v4l2-controls
diff --git a/Documentation/media/media_uapi.rst b/Documentation/media/media_uapi.rst
index 5e872c8297b0..debe4531040b 100644
--- a/Documentation/media/media_uapi.rst
+++ b/Documentation/media/media_uapi.rst
@@ -2,9 +2,9 @@
 
 .. include:: <isonum.txt>
 
-##############################
-Linux Media Infrastructure API
-##############################
+########################################
+Linux Media Infrastructure userspace API
+########################################
 
 **Copyright** |copy| 2009-2016 : LinuxTV Developers
 
@@ -15,10 +15,10 @@ the license is included in the chapter entitled "GNU Free Documentation
 License".
 
 
-.. contents::
-
 .. toctree::
     :maxdepth: 5
+    :caption: Table of Contents
+    :name: uapi_mastertoc
 
     intro
     uapi/v4l/v4l2
diff --git a/Documentation/media/v4l-drivers/index.rst b/Documentation/media/v4l-drivers/index.rst
index 34990b536d39..8d1710234e5a 100644
--- a/Documentation/media/v4l-drivers/index.rst
+++ b/Documentation/media/v4l-drivers/index.rst
@@ -2,9 +2,9 @@
 
 .. include:: <isonum.txt>
 
-###########################
-Video4Linux (V4L) subsystem
-###########################
+################################################
+Video4Linux (V4L)  driver-specific documentation
+################################################
 
 **Copyright** |copy| 1999-2016 : LinuxTV Developers
 
@@ -18,6 +18,8 @@ License".
 .. toctree::
 	:maxdepth: 5
 	:numbered:
+	:caption: Table of Contents
+	:name: v4l_mastertoc
 
 	fourcc
 	v4l-with-ir
-- 
2.7.4


