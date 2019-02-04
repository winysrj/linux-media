Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF6A4C282C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 15:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2322082E
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 15:43:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbfBDPnL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:43:11 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59264 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729348AbfBDPnL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 10:43:11 -0500
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id C36E3634C80;
        Mon,  4 Feb 2019 17:41:54 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 2/2] soc_camera: Remove the rj45n1 SoC camera sensor driver
Date:   Mon,  4 Feb 2019 17:42:07 +0200
Message-Id: <20190204154207.9120-3-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190204154207.9120-1-sakari.ailus@linux.intel.com>
References: <20190204154207.9120-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is a V4L2 sub-device sensor driver for the rj45n1. Remove the SoC
camera one.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/soc_camera/Kconfig          |    6 -
 drivers/media/i2c/soc_camera/Makefile         |    1 -
 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c | 1415 -------------------------
 3 files changed, 1422 deletions(-)
 delete mode 100644 drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c

diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index 5dcb93c0a902..bcd9ef86f40b 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -27,9 +27,3 @@ config SOC_CAMERA_OV9740
 	depends on SOC_CAMERA && I2C
 	help
 	  This is a ov9740 camera driver
-
-config SOC_CAMERA_RJ54N1
-	tristate "rj54n1cb0c support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This is a rj54n1cb0c video driver
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index a215d8b095d9..6d63eb31c3b7 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -2,4 +2,3 @@
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= soc_mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= soc_ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= soc_ov9740.o
-obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= soc_rj54n1cb0c.o
diff --git a/drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c b/drivers/media/i2c/soc_camera/soc_rj54n1cb0c.c
deleted file mode 100644
index f0cb49a6167b..000000000000
-- 
2.11.0

