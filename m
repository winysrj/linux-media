Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1769 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab3CDNC3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 08:02:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 6/6] s5p-tv: remove the dv_preset API from hdmiphy.
Date: Mon,  4 Mar 2013 14:02:06 +0100
Message-Id: <b2ffe6ec68735b6f75066d1f346ee5c8bb8bc2c5.1362401530.git.hans.verkuil@cisco.com>
In-Reply-To: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
References: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
References: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The dv_preset API is deprecated and is replaced by the much improved dv_timings
API. Remove the dv_preset support from this driver as this will allow us to
remove the dv_preset API altogether (s5p-tv being the last user of this code).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmiphy_drv.c |   53 ---------------------------
 1 file changed, 53 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index ef0d812..e19a0af 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -176,27 +176,6 @@ static inline struct hdmiphy_ctx *sd_to_ctx(struct v4l2_subdev *sd)
 	return container_of(sd, struct hdmiphy_ctx, sd);
 }
 
-static unsigned long hdmiphy_preset_to_pixclk(u32 preset)
-{
-	static const unsigned long pixclk[] = {
-		[V4L2_DV_480P59_94] =  27000000,
-		[V4L2_DV_576P50]    =  27000000,
-		[V4L2_DV_720P59_94] =  74176000,
-		[V4L2_DV_720P50]    =  74250000,
-		[V4L2_DV_720P60]    =  74250000,
-		[V4L2_DV_1080P24]   =  74250000,
-		[V4L2_DV_1080P30]   =  74250000,
-		[V4L2_DV_1080I50]   =  74250000,
-		[V4L2_DV_1080I60]   =  74250000,
-		[V4L2_DV_1080P50]   = 148500000,
-		[V4L2_DV_1080P60]   = 148500000,
-	};
-	if (preset < ARRAY_SIZE(pixclk))
-		return pixclk[preset];
-	else
-		return 0;
-}
-
 static const u8 *hdmiphy_find_conf(unsigned long pixclk,
 		const struct hdmiphy_conf *conf)
 {
@@ -212,37 +191,6 @@ static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
 	return 0;
 }
 
-static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
-	struct v4l2_dv_preset *preset)
-{
-	const u8 *data = NULL;
-	u8 buffer[32];
-	int ret;
-	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
-	unsigned long pixclk;
-	struct device *dev = &client->dev;
-
-	dev_info(dev, "s_dv_preset(preset = %d)\n", preset->preset);
-
-	pixclk = hdmiphy_preset_to_pixclk(preset->preset);
-	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
-	if (!data) {
-		dev_err(dev, "format not supported\n");
-		return -EINVAL;
-	}
-
-	/* storing configuration to the device */
-	memcpy(buffer, data, 32);
-	ret = i2c_master_send(client, buffer, 32);
-	if (ret != 32) {
-		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static int hdmiphy_s_dv_timings(struct v4l2_subdev *sd,
 	struct v4l2_dv_timings *timings)
 {
@@ -310,7 +258,6 @@ static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
-	.s_dv_preset = hdmiphy_s_dv_preset,
 	.s_dv_timings = hdmiphy_s_dv_timings,
 	.dv_timings_cap = hdmiphy_dv_timings_cap,
 	.s_stream =  hdmiphy_s_stream,
-- 
1.7.10.4

