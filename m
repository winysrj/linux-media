Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D287AC169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC45F2147C
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 08:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbfBHImm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:42:42 -0500
Received: from mga04.intel.com ([192.55.52.120]:39292 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfBHIml (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Feb 2019 03:42:41 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Feb 2019 00:42:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,347,1544515200"; 
   d="scan'208";a="298176583"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by orsmga005.jf.intel.com with ESMTP; 08 Feb 2019 00:42:39 -0800
Received: from punajuuri.localdomain (punajuuri.localdomain [192.168.240.130])
        by paasikivi.fi.intel.com (Postfix) with ESMTPS id A5E5D208D4;
        Fri,  8 Feb 2019 10:42:38 +0200 (EET)
Received: from sailus by punajuuri.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@linux.intel.com>)
        id 1gs1jJ-0002bk-6A; Fri, 08 Feb 2019 10:41:49 +0200
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 3/4] soc_camera: Move the mt9t031 under soc_camera directory
Date:   Fri,  8 Feb 2019 10:41:46 +0200
Message-Id: <20190208084147.9973-4-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
References: <20190208084147.9973-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Move the mt9t031 driver to the soc_camera directory in the media staging
tree.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/staging/media/Kconfig                           | 2 --
 drivers/staging/media/Makefile                          | 1 -
 drivers/staging/media/soc_camera/Kconfig                | 6 ++++++
 drivers/staging/media/soc_camera/Makefile               | 1 +
 drivers/staging/media/{mt9t031 => soc_camera}/mt9t031.c | 0
 5 files changed, 7 insertions(+), 3 deletions(-)
 rename drivers/staging/media/{mt9t031 => soc_camera}/mt9t031.c (100%)

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index fce8933216241..1da5c20d65c04 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -25,8 +25,6 @@ source "drivers/staging/media/davinci_vpfe/Kconfig"
 
 source "drivers/staging/media/imx/Kconfig"
 
-source "drivers/staging/media/mt9t031/Kconfig"
-
 source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/rockchip/vpu/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 74920289b0d94..0355e3030504d 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_VIDEO_IMX_MEDIA)	+= imx/
-obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_VIDEO_SUNXI)	+= sunxi/
diff --git a/drivers/staging/media/soc_camera/Kconfig b/drivers/staging/media/soc_camera/Kconfig
index e6bd04840971c..6a6aa6d2d150e 100644
--- a/drivers/staging/media/soc_camera/Kconfig
+++ b/drivers/staging/media/soc_camera/Kconfig
@@ -42,3 +42,9 @@ config SOC_CAMERA_IMX074
 	depends on SOC_CAMERA && I2C
 	help
 	  This driver supports IMX074 cameras from Sony
+
+config SOC_CAMERA_MT9T031
+	tristate "mt9t031 support (DEPRECATED)"
+	depends on SOC_CAMERA && I2C
+	help
+	  This driver supports MT9T031 cameras from Micron.
diff --git a/drivers/staging/media/soc_camera/Makefile b/drivers/staging/media/soc_camera/Makefile
index 09560dc32c4c7..3a351bd629f59 100644
--- a/drivers/staging/media/soc_camera/Makefile
+++ b/drivers/staging/media/soc_camera/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= soc_mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= soc_ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= soc_ov9740.o
 obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
+obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
diff --git a/drivers/staging/media/mt9t031/mt9t031.c b/drivers/staging/media/soc_camera/mt9t031.c
similarity index 100%
rename from drivers/staging/media/mt9t031/mt9t031.c
rename to drivers/staging/media/soc_camera/mt9t031.c
-- 
2.11.0

