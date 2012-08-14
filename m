Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757557Ab2HNUzh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 16:55:37 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7EKtbmG018731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 16:55:37 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 09/12] [media] reorganize the API core items
Date: Tue, 14 Aug 2012 17:55:24 -0300
Message-Id: <1344977727-16319-10-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
References: <1344977727-16319-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reorganize the API core changes for them to appear closer to
the items that enable them, and not at the drivers part of
the menu.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/Kconfig           |  6 ++++--
 drivers/media/v4l2-core/Kconfig | 32 ++++++++++++++++++++++++--------
 drivers/media/video/Kconfig     | 17 -----------------
 3 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
index c6d8658..c9cdc61 100644
--- a/drivers/media/Kconfig
+++ b/drivers/media/Kconfig
@@ -113,6 +113,8 @@ config VIDEO_V4L2_SUBDEV_API
 
 	  This API is mostly used by camera interfaces in embedded platforms.
 
+source "drivers/media/v4l2-core/Kconfig"
+
 #
 # DVB Core
 #	Only enables if one of DTV is selected
@@ -138,6 +140,8 @@ config DVB_NET
 	  You may want to disable the network support on embedded devices. If
 	  unsure say Y.
 
+source "drivers/media/dvb-core/Kconfig"
+
 comment "Media drivers"
 source "drivers/media/rc/Kconfig"
 
@@ -151,7 +155,6 @@ source "drivers/media/tuners/Kconfig"
 # Video/Radio/Hybrid adapters
 #
 
-source "drivers/media/v4l2-core/Kconfig"
 source "drivers/media/video/Kconfig"
 
 source "drivers/media/radio/Kconfig"
@@ -160,7 +163,6 @@ source "drivers/media/radio/Kconfig"
 # DVB adapters
 #
 
-source "drivers/media/dvb-core/Kconfig"
 source "drivers/media/pci/Kconfig"
 source "drivers/media/usb/Kconfig"
 source "drivers/media/mmc/Kconfig"
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 6f53337..05e530c 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -2,27 +2,44 @@
 # Generic video config states
 #
 
+config VIDEO_ADV_DEBUG
+	bool "Enable advanced debug functionality on V4L2 drivers"
+	default n
+	---help---
+	  Say Y here to enable advanced debugging functionality on some
+	  V4L devices.
+	  In doubt, say N.
+
+config VIDEO_FIXED_MINOR_RANGES
+	bool "Enable old-style fixed minor ranges on drivers/video devices"
+	default n
+	---help---
+	  Say Y here to enable the old-style fixed-range minor assignments.
+	  Only useful if you rely on the old behavior and use mknod instead of udev.
+
+	  When in doubt, say N.
+
 config VIDEO_V4L2
 	tristate
-	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
+	depends on VIDEO_V4L2_COMMON
 	default y
 
 config VIDEOBUF_GEN
 	tristate
 
 config VIDEOBUF_DMA_SG
+	tristate
 	depends on HAS_DMA
 	select VIDEOBUF_GEN
-	tristate
 
 config VIDEOBUF_VMALLOC
-	select VIDEOBUF_GEN
 	tristate
+	select VIDEOBUF_GEN
 
 config VIDEOBUF_DMA_CONTIG
+	tristate
 	depends on HAS_DMA
 	select VIDEOBUF_GEN
-	tristate
 
 config VIDEOBUF_DVB
 	tristate
@@ -43,18 +60,17 @@ config VIDEOBUF2_MEMOPS
 	tristate
 
 config VIDEOBUF2_DMA_CONTIG
+	tristate
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
-	tristate
 
 config VIDEOBUF2_VMALLOC
+	tristate
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
-	tristate
 
 config VIDEOBUF2_DMA_SG
+	tristate
 	#depends on HAS_DMA
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
-	tristate
-
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index f9703a0..a7bd9576c 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -26,23 +26,6 @@ menuconfig VIDEO_CAPTURE_DRIVERS
 
 if VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2
 
-config VIDEO_ADV_DEBUG
-	bool "Enable advanced debug functionality"
-	default n
-	---help---
-	  Say Y here to enable advanced debugging functionality on some
-	  V4L devices.
-	  In doubt, say N.
-
-config VIDEO_FIXED_MINOR_RANGES
-	bool "Enable old-style fixed minor ranges for video devices"
-	default n
-	---help---
-	  Say Y here to enable the old-style fixed-range minor assignments.
-	  Only useful if you rely on the old behavior and use mknod instead of udev.
-
-	  When in doubt, say N.
-
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
 	default y if !EXPERT
-- 
1.7.11.2

