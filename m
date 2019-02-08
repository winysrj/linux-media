Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966EDC282CC
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AB642147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfBHImk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:42:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:51145 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfBHImk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:42:40 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 00:42:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="scan'208";a="122935582"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga008.fm.intel.com with ESMTP; 08 Feb 2019 00:42:39 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id 2955C20849;
        Fri,  8 Feb 2019 10:42:38 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gs1jI-0002bh-Li; Fri, 08 Feb 2019 10:41:48 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 2/4] soc_camera: Move the imx074 under soc_camera directory
Date:   Fri,  8 Feb 2019 10:41:45 +0200
Message-Id: <20190208084147.9973-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
References: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move the imx074 driver to the soc_camera directory in the media staging
tree.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/Kconfig                         | 2 --
 drivers/staging/media/Makefile                        | 1 -
 drivers/staging/media/imx074/Kconfig                  | 5 -----
 drivers/staging/media/imx074/Makefile                 | 1 -
 drivers/staging/media/imx074/TODO                     | 5 -----
 drivers/staging/media/soc_camera/Kconfig              | 7 +++++++
 drivers/staging/media/soc_camera/Makefile             | 1 +
 drivers/staging/media/{imx074 => soc_camera}/imx074.c | 0
 8 files changed, 8 insertions(+), 14 deletions(-)
 delete mode 100644 drivers/staging/media/imx074/Kconfig
 delete mode 100644 drivers/staging/media/imx074/Makefile
 delete mode 100644 drivers/staging/media/imx074/TODO
 rename drivers/staging/media/{imx074 => soc_camera}/imx074.c (100%)

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 7c3f443f27358..fce8933216241 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -25,8 +25,6 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/imx/Kconfig"
 
-source "drivers/staging/media/imx074/Kconfig"
-
 source "drivers/staging/media/mt9t031/Kconfig"
 
 source "drivers/staging/media/omap4iss/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 9c1bb862f5c92..74920289b0d94 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
-obj-$(CONFIG_SOC_CAMERA_IMX074)	+= imx074/
 obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
diff --git a/drivers/staging/media/imx074/Kconfig b/drivers/staging/media/imx074/Kconfig
deleted file mode 100644
index 229cbeea580b0..0000000000000
--- a/drivers/staging/media/imx074/Kconfig
+++ /dev/null
@@ -1,5 +0,0 @@
-config SOC_CAMERA_IMX074
-	tristate "imx074 support (DEPRECATED)"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports IMX074 cameras from Sony
diff --git a/drivers/staging/media/imx074/Makefile b/drivers/staging/media/imx074/Makefile
deleted file mode 100644
index 7d183574aa840..0000000000000
--- a/drivers/staging/media/imx074/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
diff --git a/drivers/staging/media/imx074/TODO b/drivers/staging/media/imx074/TODO
deleted file mode 100644
index 15580a4f950c5..0000000000000
--- a/drivers/staging/media/imx074/TODO
+++ /dev/null
@@ -1,5 +0,0 @@
-This sensor driver needs to be converted to a regular
-v4l2 subdev driver. The soc_camera framework is deprecated and
-will be removed in the future. Unless someone does this work this
-sensor driver will be deleted when the soc_camera framework is
-deleted.
diff --git a/drivers/staging/media/soc_camera/Kconfig b/drivers/staging/media/soc_camera/Kconfig
index ebd78cebd4ecb..e6bd04840971c 100644
--- a/drivers/staging/media/soc_camera/Kconfig
+++ b/drivers/staging/media/soc_camera/Kconfig
@@ -6,6 +6,7 @@ config SOC_CAMERA
 	  SoC Camera is a common API to several cameras, not connecting
 	  over a bus like PCI or USB. For example some i2c camera connected
 	  directly to the data bus of an SoC.
+
 comment "soc_camera sensor drivers"
 
 config SOC_CAMERA_MT9M111
@@ -35,3 +36,9 @@ config SOC_CAMERA_OV9740
 	depends on SOC_CAMERA && I2C
 	help
 	  This is a ov9740 camera driver
+
+config SOC_CAMERA_IMX074
+	tristate "imx074 support (DEPRECATED)"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports IMX074 cameras from Sony
diff --git a/drivers/staging/media/soc_camera/Makefile b/drivers/staging/media/soc_camera/Makefile
index e03450cee5249..09560dc32c4c7 100644
--- a/drivers/staging/media/soc_camera/Makefile
+++ b/drivers/staging/media/soc_camera/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= soc_mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= soc_ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= soc_ov9740.o
+obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
diff --git a/drivers/staging/media/imx074/imx074.c b/drivers/staging/media/soc_camera/imx074.c
similarity index 100%
rename from drivers/staging/media/imx074/imx074.c
rename to drivers/staging/media/soc_camera/imx074.c
-- 
2.11.0

