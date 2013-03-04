Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2753 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758112Ab3CDNCX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2013 08:02:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/6] s5p-tv: add dv_timings support for hdmiphy.
Date: Mon,  4 Mar 2013 14:02:01 +0100
Message-Id: <2b361dfb4359134806e6b6d741d9286968c49df6.1362401530.git.hans.verkuil@cisco.com>
In-Reply-To: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
References: <1362402126-13149-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This just adds dv_timings support without modifying existing dv_preset
support, although I had to refactor a little bit in order to share
hdmiphy_find_conf() between the preset and timings code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmiphy_drv.c |   60 +++++++++++++++++++++++----
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index 80717ce..ef0d812 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -197,14 +197,9 @@ static unsigned long hdmiphy_preset_to_pixclk(u32 preset)
 		return 0;
 }
 
-static const u8 *hdmiphy_find_conf(u32 preset, const struct hdmiphy_conf *conf)
+static const u8 *hdmiphy_find_conf(unsigned long pixclk,
+		const struct hdmiphy_conf *conf)
 {
-	unsigned long pixclk;
-
-	pixclk = hdmiphy_preset_to_pixclk(preset);
-	if (!pixclk)
-		return NULL;
-
 	for (; conf->pixclk; ++conf)
 		if (conf->pixclk == pixclk)
 			return conf->data;
@@ -220,15 +215,49 @@ static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
 static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
 	struct v4l2_dv_preset *preset)
 {
-	const u8 *data;
+	const u8 *data = NULL;
 	u8 buffer[32];
 	int ret;
 	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	unsigned long pixclk;
 	struct device *dev = &client->dev;
 
 	dev_info(dev, "s_dv_preset(preset = %d)\n", preset->preset);
-	data = hdmiphy_find_conf(preset->preset, ctx->conf_tab);
+
+	pixclk = hdmiphy_preset_to_pixclk(preset->preset);
+	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
+	if (!data) {
+		dev_err(dev, "format not supported\n");
+		return -EINVAL;
+	}
+
+	/* storing configuration to the device */
+	memcpy(buffer, data, 32);
+	ret = i2c_master_send(client, buffer, 32);
+	if (ret != 32) {
+		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int hdmiphy_s_dv_timings(struct v4l2_subdev *sd,
+	struct v4l2_dv_timings *timings)
+{
+	const u8 *data;
+	u8 buffer[32];
+	int ret;
+	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	unsigned long pixclk = timings->bt.pixelclock;
+
+	dev_info(dev, "s_dv_timings\n");
+	if ((timings->bt.flags & V4L2_DV_FL_REDUCED_FPS) && pixclk == 74250000)
+		pixclk = 74176000;
+	data = hdmiphy_find_conf(pixclk, ctx->conf_tab);
 	if (!data) {
 		dev_err(dev, "format not supported\n");
 		return -EINVAL;
@@ -245,6 +274,17 @@ static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int hdmiphy_dv_timings_cap(struct v4l2_subdev *sd,
+	struct v4l2_dv_timings_cap *cap)
+{
+	cap->type = V4L2_DV_BT_656_1120;
+	/* The phy only determines the pixelclock, leave the other values
+	 * at 0 to signify that we have no information for them. */
+	cap->bt.min_pixelclock = 27000000;
+	cap->bt.max_pixelclock = 148500000;
+	return 0;
+}
+
 static int hdmiphy_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -271,6 +311,8 @@ static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
 
 static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
 	.s_dv_preset = hdmiphy_s_dv_preset,
+	.s_dv_timings = hdmiphy_s_dv_timings,
+	.dv_timings_cap = hdmiphy_dv_timings_cap,
 	.s_stream =  hdmiphy_s_stream,
 };
 
-- 
1.7.10.4

