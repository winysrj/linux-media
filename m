Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59061 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab2INJSQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 05:18:16 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: <linux-doc@vger.kernel.org>, linux-kernel@vger.kernel.org,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Rob Landley <rob@landley.net>
Subject: [PATCH] v4l: change path of video drivers
Date: Fri, 14 Sep 2012 14:47:52 +0530
Message-Id: <1347614272-24878-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Lad, Prabhakar <prabhakar.lad@ti.com>

due to structure change for video drivers, change the
description with correct path.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/video4linux/CQcam.txt           |    2 +-
 Documentation/video4linux/README.davinci-vpbe |   20 ++++++++++----------
 Documentation/video4linux/fimc.txt            |   16 ++++++++--------
 Documentation/video4linux/omap3isp.txt        |    2 +-
 Documentation/video4linux/v4l2-framework.txt  |    2 +-
 Documentation/video4linux/videobuf            |    2 +-
 6 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/Documentation/video4linux/CQcam.txt b/Documentation/video4linux/CQcam.txt
index 6e680fe..0b69e4e 100644
--- a/Documentation/video4linux/CQcam.txt
+++ b/Documentation/video4linux/CQcam.txt
@@ -18,7 +18,7 @@ Table of Contents
 
 1.0 Introduction
 
-  The file ../../drivers/media/video/c-qcam.c is a device driver for
+  The file ../../drivers/media/parport/c-qcam.c is a device driver for
 the Logitech (nee Connectix) parallel port interface color CCD camera.
 This is a fairly inexpensive device for capturing images.  Logitech
 does not currently provide information for developers, but many people
diff --git a/Documentation/video4linux/README.davinci-vpbe b/Documentation/video4linux/README.davinci-vpbe
index 7a460b0..dc9a297 100644
--- a/Documentation/video4linux/README.davinci-vpbe
+++ b/Documentation/video4linux/README.davinci-vpbe
@@ -5,22 +5,22 @@
  File partitioning
  -----------------
  V4L2 display device driver
-         drivers/media/video/davinci/vpbe_display.c
-         drivers/media/video/davinci/vpbe_display.h
+         drivers/media/platform/davinci/vpbe_display.c
+         drivers/media/platform/davinci/vpbe_display.h
 
  VPBE display controller
-         drivers/media/video/davinci/vpbe.c
-         drivers/media/video/davinci/vpbe.h
+         drivers/media/platform/davinci/vpbe.c
+         drivers/media/platform/davinci/vpbe.h
 
  VPBE venc sub device driver
-         drivers/media/video/davinci/vpbe_venc.c
-         drivers/media/video/davinci/vpbe_venc.h
-         drivers/media/video/davinci/vpbe_venc_regs.h
+         drivers/media/platform/davinci/vpbe_venc.c
+         drivers/media/platform/davinci/vpbe_venc.h
+         drivers/media/platform/davinci/vpbe_venc_regs.h
 
  VPBE osd driver
-         drivers/media/video/davinci/vpbe_osd.c
-         drivers/media/video/davinci/vpbe_osd.h
-         drivers/media/video/davinci/vpbe_osd_regs.h
+         drivers/media/platform/davinci/vpbe_osd.c
+         drivers/media/platform/davinci/vpbe_osd.h
+         drivers/media/platform/davinci/vpbe_osd_regs.h
 
  Functional partitioning
  -----------------------
diff --git a/Documentation/video4linux/fimc.txt b/Documentation/video4linux/fimc.txt
index eb04970..fd02d9a 100644
--- a/Documentation/video4linux/fimc.txt
+++ b/Documentation/video4linux/fimc.txt
@@ -10,7 +10,7 @@ data from LCD controller (FIMD) through the SoC internal writeback data
 path.  There are multiple FIMC instances in the SoCs (up to 4), having
 slightly different capabilities, like pixel alignment constraints, rotator
 availability, LCD writeback support, etc. The driver is located at
-drivers/media/video/s5p-fimc directory.
+drivers/media/platform/s5p-fimc directory.
 
 1. Supported SoCs
 =================
@@ -36,21 +36,21 @@ Not currently supported:
 =====================
 
 - media device driver
-  drivers/media/video/s5p-fimc/fimc-mdevice.[ch]
+  drivers/media/platform/s5p-fimc/fimc-mdevice.[ch]
 
  - camera capture video device driver
-  drivers/media/video/s5p-fimc/fimc-capture.c
+  drivers/media/platform/s5p-fimc/fimc-capture.c
 
  - MIPI-CSI2 receiver subdev
-  drivers/media/video/s5p-fimc/mipi-csis.[ch]
+  drivers/media/platform/s5p-fimc/mipi-csis.[ch]
 
  - video post-processor (mem-to-mem)
-  drivers/media/video/s5p-fimc/fimc-core.c
+  drivers/media/platform/s5p-fimc/fimc-core.c
 
  - common files
-  drivers/media/video/s5p-fimc/fimc-core.h
-  drivers/media/video/s5p-fimc/fimc-reg.h
-  drivers/media/video/s5p-fimc/regs-fimc.h
+  drivers/media/platform/s5p-fimc/fimc-core.h
+  drivers/media/platform/s5p-fimc/fimc-reg.h
+  drivers/media/platform/s5p-fimc/regs-fimc.h
 
 4. User space interfaces
 ========================
diff --git a/Documentation/video4linux/omap3isp.txt b/Documentation/video4linux/omap3isp.txt
index 5dd1439..b9a9f83 100644
--- a/Documentation/video4linux/omap3isp.txt
+++ b/Documentation/video4linux/omap3isp.txt
@@ -12,7 +12,7 @@ Introduction
 ============
 
 This file documents the Texas Instruments OMAP 3 Image Signal Processor (ISP)
-driver located under drivers/media/video/omap3isp. The original driver was
+driver located under drivers/media/platform/omap3isp. The original driver was
 written by Texas Instruments but since that it has been rewritten (twice) at
 Nokia.
 
diff --git a/Documentation/video4linux/v4l2-framework.txt b/Documentation/video4linux/v4l2-framework.txt
index 89318be..e7006ca 100644
--- a/Documentation/video4linux/v4l2-framework.txt
+++ b/Documentation/video4linux/v4l2-framework.txt
@@ -1054,4 +1054,4 @@ The first event type in the class is reserved for future use, so the first
 available event type is 'class base + 1'.
 
 An example on how the V4L2 events may be used can be found in the OMAP
-3 ISP driver (drivers/media/video/omap3isp).
+3 ISP driver (drivers/media/platform/omap3isp).
diff --git a/Documentation/video4linux/videobuf b/Documentation/video4linux/videobuf
index 1d00d7f..3ffe9e9 100644
--- a/Documentation/video4linux/videobuf
+++ b/Documentation/video4linux/videobuf
@@ -349,7 +349,7 @@ again.
 Developers who are interested in more information can go into the relevant
 header files; there are a few low-level functions declared there which have
 not been talked about here.  Also worthwhile is the vivi driver
-(drivers/media/video/vivi.c), which is maintained as an example of how V4L2
+(drivers/media/platform/vivi.c), which is maintained as an example of how V4L2
 drivers should be written.  Vivi only uses the vmalloc() API, but it's good
 enough to get started with.  Note also that all of these calls are exported
 GPL-only, so they will not be available to non-GPL kernel modules.
-- 
1.7.4.1

