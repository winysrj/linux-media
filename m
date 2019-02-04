Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F69FC282CC
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 15:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30ABF2082E
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 15:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfBDPnL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:43:11 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59258 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729355AbfBDPnL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Feb 2019 10:43:11 -0500
Received: from lanttu.localdomain (unknown [IPv6:2001:1bc8:1a6:d3d5::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 9E472634C7F;
        Mon,  4 Feb 2019 17:41:54 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl
Subject: [PATCH 1/2] soc_camera: Remove the mt9m001 SoC camera sensor driver
Date:   Mon,  4 Feb 2019 17:42:06 +0200
Message-Id: <20190204154207.9120-2-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190204154207.9120-1-sakari.ailus@linux.intel.com>
References: <20190204154207.9120-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

There is a V4L2 sub-device sensor driver for the mt9m001. Remove the SoC
camera one.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/soc_camera/Kconfig       |   7 -
 drivers/media/i2c/soc_camera/Makefile      |   1 -
 drivers/media/i2c/soc_camera/soc_mt9m001.c | 757 -----------------------------
 3 files changed, 765 deletions(-)
 delete mode 100644 drivers/media/i2c/soc_camera/soc_mt9m001.c

diff --git a/drivers/media/i2c/soc_camera/Kconfig b/drivers/media/i2c/soc_camera/Kconfig
index dea66ef1394d..5dcb93c0a902 100644
--- a/drivers/media/i2c/soc_camera/Kconfig
+++ b/drivers/media/i2c/soc_camera/Kconfig
@@ -1,12 +1,5 @@
 comment "soc_camera sensor drivers"
 
-config SOC_CAMERA_MT9M001
-	tristate "mt9m001 support"
-	depends on SOC_CAMERA && I2C
-	help
-	  This driver supports MT9M001 cameras from Micron, monochrome
-	  and colour models.
-
 config SOC_CAMERA_MT9M111
 	tristate "legacy soc_camera mt9m111, mt9m112 and mt9m131 support"
 	depends on SOC_CAMERA && I2C
diff --git a/drivers/media/i2c/soc_camera/Makefile b/drivers/media/i2c/soc_camera/Makefile
index 94659f7aa195..a215d8b095d9 100644
--- a/drivers/media/i2c/soc_camera/Makefile
+++ b/drivers/media/i2c/soc_camera/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= soc_mt9m001.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= soc_mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= soc_ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= soc_ov9740.o
diff --git a/drivers/media/i2c/soc_camera/soc_mt9m001.c b/drivers/media/i2c/soc_camera/soc_mt9m001.c
deleted file mode 100644
index a1a85ff838c5..000000000000
-- 
2.11.0

