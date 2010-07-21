Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:46861 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab0GUOmF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 10:42:05 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [SAMPLE v2 02/12] v4l: Add 16 bit YUYV and SGRBG10 media bus format codes
Date: Wed, 21 Jul 2010 16:41:49 +0200
Message-Id: <1279723318-28943-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1279722935-28493-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the following media bus format code definitions:

- V4L2_MBUS_FMT_SGRBG10_1X10 for 10-bit GRBG Bayer
- V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8 for 10-bit DPCM compressed GRBG Bayer
- V4L2_MBUS_FMT_YUYV16_1X16 for 16-bit YUYV
- V4L2_MBUS_FMT_UYVY16_1X16 for 16-bit UYVY
- V4L2_MBUS_FMT_YVYU16_1X16 for 16-bit YVYU
- V4L2_MBUS_FMT_VYUY16_1X16 for 16-bit VYUY

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 include/linux/v4l2-mediabus.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 17219c3..34dd708 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -43,6 +43,12 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE,
 	V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE,
 	V4L2_MBUS_FMT_SGRBG8_1X8,
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8,
+	V4L2_MBUS_FMT_YUYV16_1X16,
+	V4L2_MBUS_FMT_UYVY16_1X16,
+	V4L2_MBUS_FMT_YVYU16_1X16,
+	V4L2_MBUS_FMT_VYUY16_1X16,
 };
 
 /**
-- 
1.7.1

