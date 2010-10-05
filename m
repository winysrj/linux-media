Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:55203 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab0JENMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Oct 2010 09:12:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v2 05/10] v4l: Add remaining RAW10 patterns w DPCM pixel code variants
Date: Tue,  5 Oct 2010 15:12:51 +0200
Message-Id: <1286284376-12217-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1286284376-12217-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index 897c13a..9c972ec 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -59,7 +59,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YVYU8_2X8 = 0x2009,
 	V4L2_MBUS_FMT_Y10_1X10 = 0x200a,
 
-	/* Bayer - next is 0x300b */
+	/* Bayer - next is 0x3010 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
 	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3003,
@@ -67,8 +67,13 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3005,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3006,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3007,
+	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
+	V4L2_MBUS_FMT_SGBRG10_1X10 = 0x300c,
+	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300d,
 	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x3009,
 	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x300a,
+	V4L2_MBUS_FMT_SRGGB10_1X10 = 0x300e,
+	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 = 0x300f,
 	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
 };
 
-- 
1.7.2.2

