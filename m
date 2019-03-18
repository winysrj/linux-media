Return-Path: <SRS0=vX6K=RV=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB128C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 90F7A20863
	for <linux-media@archiver.kernel.org>; Mon, 18 Mar 2019 15:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfCRPch (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Mar 2019 11:32:37 -0400
Received: from retiisi.org.uk ([95.216.213.190]:53210 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726678AbfCRPch (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Mar 2019 11:32:37 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2019 11:32:35 EDT
Received: from lanttu.localdomain (unknown [IPv6:2a01:4f9:c010:4572::e1:1001])
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTP id 19469634C7B
        for <linux-media@vger.kernel.org>; Mon, 18 Mar 2019 17:23:38 +0200 (EET)
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     linux-media@vger.kernel.org
Subject: [PATCH 1/1] v4l: i2c: Regroup lens drivers under their own section
Date:   Mon, 18 Mar 2019 17:25:28 +0200
Message-Id: <20190318152528.31822-1-sakari.ailus@linux.intel.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The lens drivers had ended up under the video decoder section; add a new
one just for them, between the camera sensors and flash drivers.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/i2c/Kconfig | 76 ++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 6d32f8dcf83b..76151cb54ca8 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -320,43 +320,6 @@ config VIDEO_ML86V7667
 	  To compile this driver as a module, choose M here: the
 	  module will be called ml86v7667.
 
-config VIDEO_AD5820
-	tristate "AD5820 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	---help---
-	  This is a driver for the AD5820 camera lens voice coil.
-	  It is used for example in Nokia N900 (RX-51).
-
-config VIDEO_AK7375
-	tristate "AK7375 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on VIDEO_V4L2_SUBDEV_API
-	help
-	  This is a driver for the AK7375 camera lens voice coil.
-	  AK7375 is a 12 bit DAC with 120mA output current sink
-	  capability. This is designed for linear control of
-	  voice coil motors, controlled via I2C serial interface.
-
-config VIDEO_DW9714
-	tristate "DW9714 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on VIDEO_V4L2_SUBDEV_API
-	---help---
-	  This is a driver for the DW9714 camera lens voice coil.
-	  DW9714 is a 10 bit DAC with 120mA output current sink
-	  capability. This is designed for linear control of
-	  voice coil motors, controlled via I2C serial interface.
-
-config VIDEO_DW9807_VCM
-	tristate "DW9807 lens voice coil support"
-	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
-	depends on VIDEO_V4L2_SUBDEV_API
-	---help---
-	  This is a driver for the DW9807 camera lens voice coil.
-	  DW9807 is a 10 bit DAC with 100mA output current sink
-	  capability. This is designed for linear control of
-	  voice coil motors, controlled via I2C serial interface.
-
 config VIDEO_SAA7110
 	tristate "Philips SAA7110 video decoder"
 	depends on VIDEO_V4L2 && I2C
@@ -1020,6 +983,45 @@ config VIDEO_S5C73M3
 	  This is a V4L2 sensor driver for Samsung S5C73M3
 	  8 Mpixel camera.
 
+comment "Lens drivers"
+
+config VIDEO_AD5820
+	tristate "AD5820 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	---help---
+	  This is a driver for the AD5820 camera lens voice coil.
+	  It is used for example in Nokia N900 (RX-51).
+
+config VIDEO_AK7375
+	tristate "AK7375 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2_SUBDEV_API
+	help
+	  This is a driver for the AK7375 camera lens voice coil.
+	  AK7375 is a 12 bit DAC with 120mA output current sink
+	  capability. This is designed for linear control of
+	  voice coil motors, controlled via I2C serial interface.
+
+config VIDEO_DW9714
+	tristate "DW9714 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a driver for the DW9714 camera lens voice coil.
+	  DW9714 is a 10 bit DAC with 120mA output current sink
+	  capability. This is designed for linear control of
+	  voice coil motors, controlled via I2C serial interface.
+
+config VIDEO_DW9807_VCM
+	tristate "DW9807 lens voice coil support"
+	depends on I2C && VIDEO_V4L2 && MEDIA_CONTROLLER
+	depends on VIDEO_V4L2_SUBDEV_API
+	---help---
+	  This is a driver for the DW9807 camera lens voice coil.
+	  DW9807 is a 10 bit DAC with 100mA output current sink
+	  capability. This is designed for linear control of
+	  voice coil motors, controlled via I2C serial interface.
+
 comment "Flash devices"
 
 config VIDEO_ADP1653
-- 
2.11.0

