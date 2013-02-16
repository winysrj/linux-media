Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1947 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3BPJ24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 04:28:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/18] s5p-tv: add dv_timings support for hdmiphy.
Date: Sat, 16 Feb 2013 10:28:13 +0100
Message-Id: <c1ace44350055629138909c9a16a566f36add130.1361006882.git.hans.verkuil@cisco.com>
In-Reply-To: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
References: <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This just adds dv_timings support without modifying existing dv_preset
support, although I had to refactor a little bit in order to share
hdmiphy_find_conf() between the preset and timings code.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmiphy_drv.c |   48 ++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index 80717ce..85b4211 100644
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
@@ -271,6 +300,7 @@ static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
 
 static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
 	.s_dv_preset = hdmiphy_s_dv_preset,
+	.s_dv_timings = hdmiphy_s_dv_timings,
 	.s_stream =  hdmiphy_s_stream,
 };
 
-- 
1.7.10.4

