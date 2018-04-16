Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:53177 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753744AbeDPMhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 08:37:24 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v2 05/12] media: ov5640: Change horizontal and vertical resolutions name
Date: Mon, 16 Apr 2018 14:36:54 +0200
Message-Id: <20180416123701.15901-6-maxime.ripard@bootlin.com>
In-Reply-To: <20180416123701.15901-1-maxime.ripard@bootlin.com>
References: <20180416123701.15901-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current width and height parameters in the struct ov5640_mode_info are
actually the active horizontal and vertical resolutions.

Since we're going to add a few other parameters, let's pick a better, more
precise name for these values.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 drivers/media/i2c/ov5640.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 5b7995abc0e6..a8158ea9da67 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -169,8 +169,8 @@ struct reg_value {
 struct ov5640_mode_info {
 	enum ov5640_mode_id id;
 	enum ov5640_downsize_mode dn_mode;
-	u32 width;
-	u32 height;
+	u32 hact;
+	u32 vact;
 	const struct reg_value *reg_data;
 	u32 reg_data_size;
 };
@@ -1396,10 +1396,10 @@ ov5640_find_mode(struct ov5640_dev *sensor, enum ov5640_frame_rate fr,
 		if (!mode->reg_data)
 			continue;
 
-		if ((nearest && mode->width <= width &&
-		     mode->height <= height) ||
-		    (!nearest && mode->width == width &&
-		     mode->height == height))
+		if ((nearest && mode->hact <= width &&
+		     mode->vact <= height) ||
+		    (!nearest && mode->hact == width &&
+		     mode->vact == height))
 			break;
 	}
 
@@ -1888,8 +1888,8 @@ static int ov5640_try_fmt_internal(struct v4l2_subdev *sd,
 	mode = ov5640_find_mode(sensor, fr, fmt->width, fmt->height, true);
 	if (!mode)
 		return -EINVAL;
-	fmt->width = mode->width;
-	fmt->height = mode->height;
+	fmt->width = mode->hact;
+	fmt->height = mode->vact;
 
 	if (new_mode)
 		*new_mode = mode;
@@ -2367,10 +2367,10 @@ static int ov5640_enum_frame_size(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	fse->min_width =
-		ov5640_mode_data[0][fse->index].width;
+		ov5640_mode_data[0][fse->index].hact;
 	fse->max_width = fse->min_width;
 	fse->min_height =
-		ov5640_mode_data[0][fse->index].height;
+		ov5640_mode_data[0][fse->index].vact;
 	fse->max_height = fse->min_height;
 
 	return 0;
@@ -2434,14 +2434,14 @@ static int ov5640_s_frame_interval(struct v4l2_subdev *sd,
 	mode = sensor->current_mode;
 
 	frame_rate = ov5640_try_frame_interval(sensor, &fi->interval,
-					       mode->width, mode->height);
+					       mode->hact, mode->vact);
 	if (frame_rate < 0)
 		frame_rate = OV5640_15_FPS;
 
 	sensor->current_fr = frame_rate;
 	sensor->frame_interval = fi->interval;
-	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->width,
-						mode->height, true);
+	sensor->current_mode = ov5640_find_mode(sensor, frame_rate, mode->hact,
+						mode->vact, true);
 	sensor->pending_mode_change = true;
 out:
 	mutex_unlock(&sensor->lock);
-- 
2.17.0
