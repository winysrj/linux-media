Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:36174 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab0IZQN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 12:13:27 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
Subject: [RFC/PATCH 4/9] v4l: Add remaining RAW10 patterns w DPCM pixel code variants
Date: Sun, 26 Sep 2010 18:13:27 +0200
Message-Id: <1285517612-20230-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This adds following formats:
- V4L2_MBUS_FMT_SRGGB10_1X10
- V4L2_MBUS_FMT_SGBRG10_1X10
- V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8
- V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8
- V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 9096ef0..110db35 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -55,16 +55,21 @@ enum v4l2_mbus_pixelcode {
 	/* Bayer */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 10,
 	V4L2_MBUS_FMT_SBGGR10_1X10 = 11,
+	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 30,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 16,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 14,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 17,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 15,
 	V4L2_MBUS_FMT_SBGGR12_1X12 = 19,
+	V4L2_MBUS_FMT_SGBRG10_1X10 = 31,
+	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 32,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 18,
 	V4L2_MBUS_FMT_SGRBG10_1X10 = 28,
 	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 29,
+	V4L2_MBUS_FMT_SRGGB10_1X10 = 33,
+	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 = 34,
 	/* Last - Update this when adding a new pixel code */
-	V4L2_MBUS_FMT_LAST = 30,
+	V4L2_MBUS_FMT_LAST = 35,
 };
 
 /**
-- 
1.7.2.2

