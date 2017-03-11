Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:36539 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755626AbdCKLXf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Mar 2017 06:23:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        Songjun Wu <songjun.wu@microchip.com>,
        Sakari Ailus <sakari.ailus@iki.fi>, devicetree@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv5 09/16] ov2640: fix colorspace handling
Date: Sat, 11 Mar 2017 12:23:21 +0100
Message-Id: <20170311112328.11802-10-hverkuil@xs4all.nl>
In-Reply-To: <20170311112328.11802-1-hverkuil@xs4all.nl>
References: <20170311112328.11802-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The colorspace is independent of whether YUV or RGB is sent to the SoC.
Fix this.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/soc_camera/ov2640.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/soc_camera/ov2640.c b/drivers/media/i2c/soc_camera/ov2640.c
index 56de18263359..b9a0069f5b33 100644
--- a/drivers/media/i2c/soc_camera/ov2640.c
+++ b/drivers/media/i2c/soc_camera/ov2640.c
@@ -794,10 +794,11 @@ static int ov2640_set_params(struct i2c_client *client, u32 *width, u32 *height,
 		dev_dbg(&client->dev, "%s: Selected cfmt YUYV (YUV422)", __func__);
 		selected_cfmt_regs = ov2640_yuyv_regs;
 		break;
-	default:
 	case MEDIA_BUS_FMT_UYVY8_2X8:
+	default:
 		dev_dbg(&client->dev, "%s: Selected cfmt UYVY", __func__);
 		selected_cfmt_regs = ov2640_uyvy_regs;
+		break;
 	}
 
 	/* reset hardware */
@@ -865,17 +866,7 @@ static int ov2640_get_fmt(struct v4l2_subdev *sd,
 	mf->width	= priv->win->width;
 	mf->height	= priv->win->height;
 	mf->code	= priv->cfmt_code;
-
-	switch (mf->code) {
-	case MEDIA_BUS_FMT_RGB565_2X8_BE:
-	case MEDIA_BUS_FMT_RGB565_2X8_LE:
-		mf->colorspace = V4L2_COLORSPACE_SRGB;
-		break;
-	default:
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-		mf->colorspace = V4L2_COLORSPACE_JPEG;
-	}
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 	mf->field	= V4L2_FIELD_NONE;
 
 	return 0;
@@ -897,17 +888,17 @@ static int ov2640_set_fmt(struct v4l2_subdev *sd,
 	ov2640_select_win(&mf->width, &mf->height);
 
 	mf->field	= V4L2_FIELD_NONE;
+	mf->colorspace	= V4L2_COLORSPACE_SRGB;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_RGB565_2X8_BE:
 	case MEDIA_BUS_FMT_RGB565_2X8_LE:
-		mf->colorspace = V4L2_COLORSPACE_SRGB;
+	case MEDIA_BUS_FMT_YUYV8_2X8:
+	case MEDIA_BUS_FMT_UYVY8_2X8:
 		break;
 	default:
 		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
-	case MEDIA_BUS_FMT_YUYV8_2X8:
-	case MEDIA_BUS_FMT_UYVY8_2X8:
-		mf->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
 	}
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-- 
2.11.0
