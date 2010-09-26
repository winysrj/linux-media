Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36175 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757322Ab0IZQN0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 12:13:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
Subject: [RFC/PATCH 3/9] v4l: Add 8-bit YUYV on 16-bit bus and SGRBG10 media bus pixel codes
Date: Sun, 26 Sep 2010 18:13:26 +0200
Message-Id: <1285517612-20230-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add the following media bus format code definitions:

- V4L2_MBUS_FMT_SGRBG10_1X10 for 10-bit GRBG Bayer
- V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 for 10-bit DPCM compressed GRBG Bayer
- V4L2_MBUS_FMT_YUYV16_1X16 for 8-bit YUYV on 16-bit bus
- V4L2_MBUS_FMT_UYVY16_1X16 for 8-bit UYVY on 16-bit bus
- V4L2_MBUS_FMT_YVYU16_1X16 for 8-bit YVYU on 16-bit bus
- V4L2_MBUS_FMT_VYUY16_1X16 for 8-bit VYUY on 16-bit bus

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index bc637a5..9096ef0 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -48,6 +48,10 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_UYVY8_2X8 = 4,
 	V4L2_MBUS_FMT_YVYU8_2X8 = 3,
 	V4L2_MBUS_FMT_VYUY8_2X8 = 5,
+	V4L2_MBUS_FMT_YUYV8_1X16 = 24,
+	V4L2_MBUS_FMT_UYVY8_1X16 = 25,
+	V4L2_MBUS_FMT_YVYU8_1X16 = 26,
+	V4L2_MBUS_FMT_VYUY8_1X16 = 27,
 	/* Bayer */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 10,
 	V4L2_MBUS_FMT_SBGGR10_1X10 = 11,
@@ -57,8 +61,10 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 15,
 	V4L2_MBUS_FMT_SBGGR12_1X12 = 19,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 18,
+	V4L2_MBUS_FMT_SGRBG10_1X10 = 28,
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 29,
 	/* Last - Update this when adding a new pixel code */
-	V4L2_MBUS_FMT_LAST = 24,
+	V4L2_MBUS_FMT_LAST = 30,
 };
 
 /**
-- 
1.7.2.2

