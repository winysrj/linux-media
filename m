Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56C9C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C01E21773
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 15:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfBIPcG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 10:32:06 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54026 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726880AbfBIPcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Feb 2019 10:32:06 -0500
Received: from lanttu.localdomain (lanttu.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::c1:2])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 0D891634C7B;
        Sat,  9 Feb 2019 17:31:48 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Cc:     Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/1] soc_camera: Remove Kconfig leftovers from mt9m111 driver
Date:   Sat,  9 Feb 2019 17:32:02 +0200
Message-Id: <20190209153202.7194-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The mt9m111 SoC camera driver has been removed, remove its Kconfig
leftovers as well.

Reported-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
This goes on top of my set moving the SoC camera to staging.

 drivers/staging/media/soc_camera/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/media/soc_camera/Kconfig b/drivers/staging/media/soc_camera/Kconfig
index bacd30f0348d..0edc1346d4fd 100644
--- a/drivers/staging/media/soc_camera/Kconfig
+++ b/drivers/staging/media/soc_camera/Kconfig
@@ -9,16 +9,6 @@ config SOC_CAMERA
 
 comment "soc_camera sensor drivers"
 
-config SOC_CAMERA_MT9M111
-	tristate "legacy soc_camera mt9m111, mt9m112 and mt9m131 support"
-	depends on SOC_CAMERA && I2C
-	select VIDEO_MT9M111
-	help
-	  This driver supports MT9M111, MT9M112 and MT9M131 cameras from
-	  Micron/Aptina.
-	  This is the legacy configuration which shouldn't be used anymore,
-	  while VIDEO_MT9M111 should be used instead.
-
 config SOC_CAMERA_MT9V022
 	tristate "mt9v022 and mt9v024 support"
 	depends on SOC_CAMERA && I2C
-- 
2.11.0

