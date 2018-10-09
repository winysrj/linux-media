Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42541 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIODy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2018 10:03:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id c8-v6so315327plo.9
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2018 23:48:29 -0700 (PDT)
From: Sam Bobrowicz <sam@elite-embedded.com>
To: linux-media@vger.kernel.org
Cc: Sam Bobrowicz <sam@elite-embedded.com>
Subject: [PATCH 4/4] media: ov5640: Add additional media bus formats
Date: Mon,  8 Oct 2018 23:48:02 -0700
Message-Id: <1539067682-60604-5-git-send-email-sam@elite-embedded.com>
In-Reply-To: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
References: <1539067682-60604-1-git-send-email-sam@elite-embedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for 1X16 yuv media bus formats (v4l2_mbus_framefmt).
These formats are equivalent to the 2X8 formats that are already
supported, both of which accurately describe the data present on
the CSI2 interface. This change will increase compatibility with
CSI2 RX drivers that only advertise support for the 1X16 formats.

Signed-off-by: Sam Bobrowicz <sam@elite-embedded.com>
---
 drivers/media/i2c/ov5640.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index a50d884..ca9de56 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -125,6 +125,8 @@ static const struct ov5640_pixfmt ov5640_formats[] = {
 	{ MEDIA_BUS_FMT_JPEG_1X8, V4L2_COLORSPACE_JPEG, },
 	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_SRGB, },
 	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_SRGB, },
+	{ MEDIA_BUS_FMT_UYVY8_1X16, V4L2_COLORSPACE_SRGB, },
+	{ MEDIA_BUS_FMT_YUYV8_1X16, V4L2_COLORSPACE_SRGB, },
 	{ MEDIA_BUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB, },
 	{ MEDIA_BUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB, },
 };
@@ -2069,10 +2071,12 @@ static int ov5640_set_framefmt(struct ov5640_dev *sensor,
 
 	switch (format->code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
 		/* YUV422, UYVY */
 		val = 0x3f;
 		break;
 	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_YUYV8_1X16:
 		/* YUV422, YUYV */
 		val = 0x30;
 		break;
-- 
2.7.4
