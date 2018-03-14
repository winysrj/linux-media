Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:44511 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751695AbeCNPo7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Mar 2018 11:44:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 21/47] media: platform: remove m32r specific arv driver
Date: Wed, 14 Mar 2018 16:35:34 +0100
Message-Id: <20180314153603.3127932-22-arnd@arndb.de>
In-Reply-To: <20180314153603.3127932-1-arnd@arndb.de>
References: <20180314153603.3127932-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The m32r architecture is getting removed, so this one is no longer needed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/Kconfig  |  20 -
 drivers/media/platform/Makefile |   2 -
 drivers/media/platform/arv.c    | 884 ----------------------------------------
 3 files changed, 906 deletions(-)
 delete mode 100644 drivers/media/platform/arv.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2136702c95fc..c7a1cf8a1b01 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -52,26 +52,6 @@ config VIDEO_VIU
 	  Say Y here if you want to enable VIU device on MPC5121e Rev2+.
 	  In doubt, say N.
 
-config VIDEO_M32R_AR
-	tristate "AR devices"
-	depends on VIDEO_V4L2
-	depends on M32R || COMPILE_TEST
-	---help---
-	  This is a video4linux driver for the Renesas AR (Artificial Retina)
-	  camera module.
-
-config VIDEO_M32R_AR_M64278
-	tristate "AR device with color module M64278(VGA)"
-	depends on PLAT_M32700UT
-	select VIDEO_M32R_AR
-	---help---
-	  This is a video4linux driver for the Renesas AR (Artificial
-	  Retina) with M64278E-800 camera module.
-	  This module supports VGA(640x480 pixels) resolutions.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called arv.
-
 config VIDEO_MUX
 	tristate "Video Multiplexer"
 	select MULTIPLEXER
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 2b07f2e2fca6..932515df4477 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -3,8 +3,6 @@
 # Makefile for the video capture/playback device drivers.
 #
 
-obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
-
 obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
 obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
diff --git a/drivers/media/platform/arv.c b/drivers/media/platform/arv.c
deleted file mode 100644
index 1e865fea803c..000000000000
-- 
2.9.0
