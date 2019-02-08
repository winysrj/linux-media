Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA2CC282CC
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C8122147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfBHImm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:42:42 -0500
Received: from mga06.intel.com ([134.134.136.31]:21748 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727260AbfBHIml (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:42:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 00:42:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="scan'208";a="273445210"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga004.jf.intel.com with ESMTP; 08 Feb 2019 00:42:38 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id A0A3F20736;
        Fri,  8 Feb 2019 10:42:37 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gs1jI-0002be-41; Fri, 08 Feb 2019 10:41:48 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 1/4] soc_camera: Move to the staging tree
Date:   Fri,  8 Feb 2019 10:41:44 +0200
Message-Id: <20190208084147.9973-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
References: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The SoC camera framework has no functional drivers left, something that
has not changed for years. Move the leftovers to the staging tree.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/Kconfig                                         | 8 --------
 drivers/media/i2c/Makefile                                        | 1 -
 drivers/media/platform/Kconfig                                    | 1 -
 drivers/media/platform/Makefile                                   | 2 --
 drivers/media/platform/soc_camera/Kconfig                         | 8 --------
 drivers/media/platform/soc_camera/Makefile                        | 1 -
 drivers/staging/media/Kconfig                                     | 2 ++
 drivers/staging/media/Makefile                                    | 1 +
 drivers/{media/i2c => staging/media}/soc_camera/Kconfig           | 8 ++++++++
 drivers/{media/i2c => staging/media}/soc_camera/Makefile          | 1 +
 drivers/{media/platform => staging/media}/soc_camera/soc_camera.c | 0
 .../{media/platform => staging/media}/soc_camera/soc_mediabus.c   | 0
 drivers/{media/i2c => staging/media}/soc_camera/soc_mt9v022.c     | 0
 drivers/{media/i2c => staging/media}/soc_camera/soc_ov5642.c      | 0
 drivers/{media/i2c => staging/media}/soc_camera/soc_ov9740.c      | 0
 15 files changed, 12 insertions(+), 21 deletions(-)
 delete mode 100644 drivers/media/platform/soc_camera/Kconfig
 delete mode 100644 drivers/media/platform/soc_camera/Makefile
 rename drivers/{media/i2c => staging/media}/soc_camera/Kconfig (74%)
 rename drivers/{media/i2c => staging/media}/soc_camera/Makefile (76%)
 rename drivers/{media/platform => staging/media}/soc_camera/soc_camera.c (100%)
 rename drivers/{media/platform => staging/media}/soc_camera/soc_mediabus.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_mt9v022.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov5642.c (100%)
 rename drivers/{media/i2c => staging/media}/soc_camera/soc_ov9740.c (100%)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 19c112cda0786..6d32f8dcf83b2 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1134,12 +1134,4 @@ config VIDEO_I2C
 
 endmenu
 
-menu "Sensors used on soc_camera driver"
-
-if SOC_CAMERA
-	source "drivers/media/i2c/soc_camera/Kconfig"
-endif
-
-endmenu
-
 endif
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 2e5e4b0bf7f3e..a64fca82e0c4b 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -6,7 +6,6 @@ obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
 obj-$(CONFIG_VIDEO_ET8EK8)	+= et8ek8/
 obj-$(CONFIG_VIDEO_CX25840) += cx25840/
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
-obj-y				+= soc_camera/
 
 obj-$(CONFIG_VIDEO_APTINA_PLL) += aptina-pll.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index b5ccb60cf664b..6cff26b29a38f 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -141,7 +141,6 @@ config VIDEO_RENESAS_CEU
 	---help---
 	  This is a v4l2 driver for the Renesas CEU Interface
 
-source "drivers/media/platform/soc_camera/Kconfig"
 source "drivers/media/platform/exynos4-is/Kconfig"
 source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index e6deb25977380..7cbbd925124cf 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -62,8 +62,6 @@ obj-y					+= davinci/
 
 obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
-
 obj-$(CONFIG_VIDEO_RCAR_DRIF)		+= rcar_drif.o
 obj-$(CONFIG_VIDEO_RENESAS_CEU)		+= renesas-ceu.o
 obj-$(CONFIG_VIDEO_RENESAS_FCP)		+= rcar-fcp.o
diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
deleted file mode 100644
index 8f9b3bac5450d..0000000000000
--- a/drivers/media/platform/soc_camera/Kconfig
+++ /dev/null
@@ -1,8 +0,0 @@
-config SOC_CAMERA
-	tristate "SoC camera support"
-	depends on VIDEO_V4L2 && HAS_DMA && I2C
-	select VIDEOBUF2_CORE
-	help
-	  SoC Camera is a common API to several cameras, not connecting
-	  over a bus like PCI or USB. For example some i2c camera connected
-	  directly to the data bus of an SoC.
diff --git a/drivers/media/platform/soc_camera/Makefile b/drivers/media/platform/soc_camera/Makefile
deleted file mode 100644
index 85d5e74f3b2b2..0000000000000
--- a/drivers/media/platform/soc_camera/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 19cadd17e542a..7c3f443f27358 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -41,4 +41,6 @@ source "drivers/staging/media/zoran/Kconfig"
 
 source "drivers/staging/media/ipu3/Kconfig"
 
+source "drivers/staging/media/soc_camera/Kconfig"
+
 endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index edde1960b030d..9c1bb862f5c92 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_TEGRA_VDE)		+= tegra-vde/
 obj-$(CONFIG_VIDEO_ZORAN)	+= zoran/
 obj-$(CONFIG_VIDEO_ROCKCHIP_VPU) += rockchip/vpu/
 obj-$(CONFIG_VIDEO_IPU3_IMGU)	+= ipu3/
+obj-$(CONFIG_SOC_CAMERA)	+= soc_camera/
diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/staging/media/soc_camera/Kconfig
similarity index 74%
rename from drivers/media/i2c/soc_camera/Kconfig
rename to drivers/staging/media/soc_camera/Kconfig
index bcd9ef86f40b7..ebd78cebd4ecb 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/staging/media/soc_camera/Kconfig
@@ -1,3 +1,11 @@
+config SOC_CAMERA
+	tristate "SoC camera support"
+	depends on VIDEO_V4L2 && HAS_DMA && I2C
+	select VIDEOBUF2_CORE
+	help
+	  SoC Camera is a common API to several cameras, not connecting
+	  over a bus like PCI or USB. For example some i2c camera connected
+	  directly to the data bus of an SoC.
 comment "soc_camera sensor drivers"
 
 config SOC_CAMERA_MT9M111
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/staging/media/soc_camera/Makefile
similarity index 76%
rename from drivers/media/i2c/soc_camera/Makefile
rename to drivers/staging/media/soc_camera/Makefile
index 6d63eb31c3b7f..e03450cee5249 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/staging/media/soc_camera/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= soc_mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= soc_ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= soc_ov9740.o
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/staging/media/soc_camera/soc_camera.c
similarity index 100%
rename from drivers/media/platform/soc_camera/soc_camera.c
rename to drivers/staging/media/soc_camera/soc_camera.c
diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/staging/media/soc_camera/soc_mediabus.c
similarity index 100%
rename from drivers/media/platform/soc_camera/soc_mediabus.c
rename to drivers/staging/media/soc_camera/soc_mediabus.c
diff --git a/drivers/media/i2c/soc_camera/soc_mt9v022.c b/drivers/staging/media/soc_camera/soc_mt9v022.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/soc_mt9v022.c
rename to drivers/staging/media/soc_camera/soc_mt9v022.c
diff --git a/drivers/media/i2c/soc_camera/soc_ov5642.c b/drivers/staging/media/soc_camera/soc_ov5642.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/soc_ov5642.c
rename to drivers/staging/media/soc_camera/soc_ov5642.c
diff --git a/drivers/media/i2c/soc_camera/soc_ov9740.c b/drivers/staging/media/soc_camera/soc_ov9740.c
similarity index 100%
rename from drivers/media/i2c/soc_camera/soc_ov9740.c
rename to drivers/staging/media/soc_camera/soc_ov9740.c
-- 
2.11.0

