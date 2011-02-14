Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab1BNMVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v2 4/6] v4l: Add remaining RAW10 patterns w DPCM pixel code variants
Date: Mon, 14 Feb 2011 13:21:28 +0100
Message-Id: <1297686090-9762-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
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
index c4caca3..5c64924 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -67,16 +67,21 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 
-	/* Bayer - next is 0x300b */
+	/* Bayer - next is 0x3010 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
+	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
+	V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8 = 0x300c,
 	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 = 0x3009,
+	V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8 = 0x300d,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE = 0x3003,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE = 0x3004,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE = 0x3005,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE = 0x3006,
 	V4L2_MBUS_FMT_SBGGR10_1X10 = 0x3007,
+	V4L2_MBUS_FMT_SGBRG10_1X10 = 0x300e,
 	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x300a,
+	V4L2_MBUS_FMT_SRGGB10_1X10 = 0x300f,
 	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
 };
 
-- 
1.7.3.4

