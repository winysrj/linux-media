Return-path: <linux-media-owner@vger.kernel.org>
Received: from av10-1-sn2.hy.skanova.net ([81.228.8.181]:49948 "EHLO
	av10-1-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbZIVJIH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 05:08:07 -0400
Message-ID: <4AB8939A.3050508@mocean-labs.com>
Date: Tue, 22 Sep 2009 11:06:34 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: [PATCH 2/4] adv7180: Support for setting input status
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Support for settings the input standard of the ADV7180.

When the input standard is set there is no use to ask the
chip for standard, therefore it is cached in the driver.

Signed-off-by: Richard Röjfors <richard.rojfors@mocean-labs.com>
---
diff --git a/drivers/media/video/adv7180.c b/drivers/media/video/adv7180.c
index f3fce39..8b199a8 100644
--- a/drivers/media/video/adv7180.c
+++ b/drivers/media/video/adv7180.c
@@ -69,7 +69,9 @@


 struct adv7180_state {
-	struct v4l2_subdev sd;
+	struct v4l2_subdev	sd;
+	v4l2_std_id		curr_norm;
+	bool			autodetect;
 };

 static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
@@ -96,6 +98,29 @@ static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 	}
 }

+static int v4l2_std_to_adv7180(v4l2_std_id std)
+{
+	if (std == V4L2_STD_PAL_60)
+		return ADV7180_INPUT_CONTROL_PAL60;
+	if (std == V4L2_STD_NTSC_443)
+		return ADV7180_INPUT_CONTROL_NTSC_443;
+	if (std == V4L2_STD_PAL_N)
+		return ADV7180_INPUT_CONTROL_PAL_N;
+	if (std == V4L2_STD_PAL_M)
+		return ADV7180_INPUT_CONTROL_PAL_M;
+	if (std == V4L2_STD_PAL_Nc)
+		return ADV7180_INPUT_CONTROL_PAL_COMB_N;
+
+	if (std & V4L2_STD_PAL)
+		return ADV7180_INPUT_CONTROL_PAL_BG;
+	if (std & V4L2_STD_NTSC)
+		return ADV7180_INPUT_CONTROL_NTSC_M;
+	if (std & V4L2_STD_SECAM)
+		return ADV7180_INPUT_CONTROL_PAL_SECAM;
+
+	return -EINVAL;
+}
+
 static u32 adv7180_status_to_v4l2(u8 status1)
 {
 	if (!(status1 & ADV7180_STATUS1_IN_LOCK))
@@ -127,7 +152,15 @@ static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)

 static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
-	return __adv7180_status(v4l2_get_subdevdata(sd), NULL, std);
+	struct adv7180_state *state = to_state(sd);
+	int err = 0;
+
+	if (!state->autodetect)
+		*std = state->curr_norm;
+	else
+		err = __adv7180_status(v4l2_get_subdevdata(sd), NULL, std);
+
+	return err;
 }

 static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
@@ -143,6 +176,39 @@ static int adv7180_g_chip_ident(struct v4l2_subdev *sd,
 	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_ADV7180, 0);
 }

+static int adv7180_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct adv7180_state *state = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int ret;
+
+	/* all standards -> autodetect */
+	if (std == V4L2_STD_ALL) {
+		ret = i2c_smbus_write_byte_data(client,
+			ADV7180_INPUT_CONTROL_REG,
+			ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM);
+		if (ret < 0)
+			goto out;
+
+		state->autodetect = true;
+	} else {
+		ret = v4l2_std_to_adv7180(std);
+		if (ret < 0)
+			goto out;
+
+		ret = i2c_smbus_write_byte_data(client,
+			ADV7180_INPUT_CONTROL_REG, ret);
+		if (ret < 0)
+			goto out;
+
+		state->curr_norm = std;
+		state->autodetect = false;
+	}
+	ret = 0;
+out:
+	return ret;
+}
+
 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.querystd = adv7180_querystd,
 	.g_input_status = adv7180_g_input_status,
@@ -150,6 +216,7 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {

 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
 	.g_chip_ident = adv7180_g_chip_ident,
+	.s_std = adv7180_s_std,
 };

 static const struct v4l2_subdev_ops adv7180_ops = {
@@ -179,6 +246,7 @@ static int adv7180_probe(struct i2c_client *client,
 	state = kzalloc(sizeof(struct adv7180_state), GFP_KERNEL);
 	if (state == NULL)
 		return -ENOMEM;
+	state->autodetect = true;
 	sd = &state->sd;
 	v4l2_i2c_subdev_init(sd, client, &adv7180_ops);

