Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323EAC282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 19:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08219217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 19:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfBITBD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 14:01:03 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55382 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727130AbfBITBD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Feb 2019 14:01:03 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 12DAB634C7B
        for <linux-media@vger.kernel.org>; Sat,  9 Feb 2019 21:00:44 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Subject: [PATCH 1/1] soc_camera: Rename files for mt9t031 and imx074
Date:   Sat,  9 Feb 2019 21:00:58 +0200
Message-Id: <20190209190058.13890-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Rename files (as well as modules) of the mt9t031 and imx074 SoC camera
drivers to align with the rest of them, i.e. adding the "soc_" prefix.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
This goes on top of my previous SoC camera patches.

 drivers/staging/media/soc_camera/Makefile                     | 4 ++--
 drivers/staging/media/soc_camera/{imx074.c => soc_imx074.c}   | 0
 drivers/staging/media/soc_camera/{mt9t031.c => soc_mt9t031.c} | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename drivers/staging/media/soc_camera/{imx074.c => soc_imx074.c} (100%)
 rename drivers/staging/media/soc_camera/{mt9t031.c => soc_mt9t031.c} (100%)

diff --git a/drivers/staging/media/soc_camera/Makefile b/drivers/staging/media/soc_camera/Makefile
index 3a351bd629f5..e3a1f0504f04 100644
--- a/drivers/staging/media/soc_camera/Makefile
+++ b/drivers/staging/media/soc_camera/Makefile
@@ -3,5 +3,5 @@ obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o soc_mediabus.o
 obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= soc_mt9v022.o
 obj-$(CONFIG_SOC_CAMERA_OV5642)		+= soc_ov5642.o
 obj-$(CONFIG_SOC_CAMERA_OV9740)		+= soc_ov9740.o
-obj-$(CONFIG_SOC_CAMERA_IMX074)		+= imx074.o
-obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
+obj-$(CONFIG_SOC_CAMERA_IMX074)		+= soc_imx074.o
+obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= soc_mt9t031.o
diff --git a/drivers/staging/media/soc_camera/imx074.c b/drivers/staging/media/soc_camera/soc_imx074.c
similarity index 100%
rename from drivers/staging/media/soc_camera/imx074.c
rename to drivers/staging/media/soc_camera/soc_imx074.c
diff --git a/drivers/staging/media/soc_camera/mt9t031.c b/drivers/staging/media/soc_camera/soc_mt9t031.c
similarity index 100%
rename from drivers/staging/media/soc_camera/mt9t031.c
rename to drivers/staging/media/soc_camera/soc_mt9t031.c
-- 
2.11.0

