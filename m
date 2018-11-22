Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39206 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437582AbeKWB7I (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Nov 2018 20:59:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id t27so1664094wra.6
        for <linux-media@vger.kernel.org>; Thu, 22 Nov 2018 07:19:19 -0800 (PST)
From: Rui Miguel Silva <rui.silva@linaro.org>
To: sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rui Miguel Silva <rui.silva@linaro.org>
Subject: [PATCH v9 12/13] media: video-mux: add bayer formats
Date: Thu, 22 Nov 2018 15:18:33 +0000
Message-Id: <20181122151834.6194-13-rui.silva@linaro.org>
In-Reply-To: <20181122151834.6194-1-rui.silva@linaro.org>
References: <20181122151834.6194-1-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add non vendor bayer formats to the  allowed format array.

Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
---
 drivers/media/platform/video-mux.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/media/platform/video-mux.c b/drivers/media/platform/video-mux.c
index c33900e3c23e..0ba30756e1e4 100644
--- a/drivers/media/platform/video-mux.c
+++ b/drivers/media/platform/video-mux.c
@@ -263,6 +263,26 @@ static int video_mux_set_format(struct v4l2_subdev *sd,
 	case MEDIA_BUS_FMT_UYYVYY16_0_5X48:
 	case MEDIA_BUS_FMT_JPEG_1X8:
 	case MEDIA_BUS_FMT_AHSV8888_1X32:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SBGGR12_1X12:
+	case MEDIA_BUS_FMT_SGBRG12_1X12:
+	case MEDIA_BUS_FMT_SGRBG12_1X12:
+	case MEDIA_BUS_FMT_SRGGB12_1X12:
+	case MEDIA_BUS_FMT_SBGGR14_1X14:
+	case MEDIA_BUS_FMT_SGBRG14_1X14:
+	case MEDIA_BUS_FMT_SGRBG14_1X14:
+	case MEDIA_BUS_FMT_SRGGB14_1X14:
+	case MEDIA_BUS_FMT_SBGGR16_1X16:
+	case MEDIA_BUS_FMT_SGBRG16_1X16:
+	case MEDIA_BUS_FMT_SGRBG16_1X16:
+	case MEDIA_BUS_FMT_SRGGB16_1X16:
 		break;
 	default:
 		sdformat->format.code = MEDIA_BUS_FMT_Y8_1X8;
-- 
2.19.1
