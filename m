Return-path: <linux-media-owner@vger.kernel.org>
Received: from av11-2-sn2.hy.skanova.net ([81.228.8.184]:53089 "EHLO
	av11-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbZIVJFo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2009 05:05:44 -0400
Message-ID: <4AB89366.9030305@mocean-labs.com>
Date: Tue, 22 Sep 2009 11:05:42 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors@mocean-labs.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>
Subject: [PATCH 1/4] adv7180: Support for getting input status
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds support to the ADV7180 driver to check the input
status.

Since the status is held in the same register as the input standard
a small restructuring of the code is done to reuse the code for
reading the register

Signed-off-by: Richard Röjfors <richard.rojfors@mocean-labs.com>
---
diff --git a/drivers/media/video/adv7180.c b/drivers/media/video/adv7180.c
index 1b3cbd0..f3fce39 100644
--- a/drivers/media/video/adv7180.c
+++ b/drivers/media/video/adv7180.c
@@ -30,14 +30,31 @@

 #define DRIVER_NAME "adv7180"

-#define ADV7180_INPUT_CONTROL_REG	0x00
-#define ADV7180_INPUT_CONTROL_PAL_BG_NTSC_J_SECAM	0x00
+#define ADV7180_INPUT_CONTROL_REG			0x00
+#define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM	0x00
+#define ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM_PED 0x10
+#define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_J_SECAM	0x20
+#define ADV7180_INPUT_CONTROL_AD_PAL_N_NTSC_M_SECAM	0x30
+#define ADV7180_INPUT_CONTROL_NTSC_J			0x40
+#define ADV7180_INPUT_CONTROL_NTSC_M			0x50
+#define ADV7180_INPUT_CONTROL_PAL60			0x60
+#define ADV7180_INPUT_CONTROL_NTSC_443			0x70
+#define ADV7180_INPUT_CONTROL_PAL_BG			0x80
+#define ADV7180_INPUT_CONTROL_PAL_N			0x90
+#define ADV7180_INPUT_CONTROL_PAL_M			0xa0
+#define ADV7180_INPUT_CONTROL_PAL_M_PED			0xb0
+#define ADV7180_INPUT_CONTROL_PAL_COMB_N		0xc0
+#define ADV7180_INPUT_CONTROL_PAL_COMB_N_PED		0xd0
+#define ADV7180_INPUT_CONTROL_PAL_SECAM			0xe0
+#define ADV7180_INPUT_CONTROL_PAL_SECAM_PED		0xf0
+
 #define ADV7180_AUTODETECT_ENABLE_REG	0x07
 #define ADV7180_AUTODETECT_DEFAULT	0x7f


-#define ADV7180_STATUS1_REG 0x10
-#define ADV7180_STATUS1_AUTOD_MASK 0x70
+#define ADV7180_STATUS1_REG				0x10
+#define ADV7180_STATUS1_IN_LOCK		0x01
+#define ADV7180_STATUS1_AUTOD_MASK	0x70
 #define ADV7180_STATUS1_AUTOD_NTSM_M_J	0x00
 #define ADV7180_STATUS1_AUTOD_NTSC_4_43 0x10
 #define ADV7180_STATUS1_AUTOD_PAL_M	0x20
@@ -55,13 +72,11 @@ struct adv7180_state {
 	struct v4l2_subdev sd;
 };

-static v4l2_std_id determine_norm(struct i2c_client *client)
+static v4l2_std_id adv7180_std_to_v4l2(u8 status1)
 {
-	u8 status1 = i2c_smbus_read_byte_data(client, ADV7180_STATUS1_REG);
-
 	switch (status1 & ADV7180_STATUS1_AUTOD_MASK) {
 	case ADV7180_STATUS1_AUTOD_NTSM_M_J:
-		return V4L2_STD_NTSC_M_JP;
+		return V4L2_STD_NTSC;
 	case ADV7180_STATUS1_AUTOD_NTSC_4_43:
 		return V4L2_STD_NTSC_443;
 	case ADV7180_STATUS1_AUTOD_PAL_M:
@@ -81,6 +96,30 @@ static v4l2_std_id determine_norm(struct i2c_client *client)
 	}
 }

+static u32 adv7180_status_to_v4l2(u8 status1)
+{
+	if (!(status1 & ADV7180_STATUS1_IN_LOCK))
+		return V4L2_IN_ST_NO_SIGNAL;
+
+	return 0;
+}
+
+static int __adv7180_status(struct i2c_client *client, u32 *status,
+	v4l2_std_id *std)
+{
+	int status1 = i2c_smbus_read_byte_data(client, ADV7180_STATUS1_REG);
+
+	if (status1 < 0)
+		return status1;
+
+	if (status)
+		*status = adv7180_status_to_v4l2(status1);
+	if (std)
+		*std = adv7180_std_to_v4l2(status1);
+
+	return 0;
+}
+
 static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)
 {
 	return container_of(sd, struct adv7180_state, sd);
@@ -88,10 +127,12 @@ static inline struct adv7180_state *to_state(struct v4l2_subdev *sd)

 static int adv7180_querystd(struct v4l2_subdev *sd, v4l2_std_id *std)
 {
-	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	return __adv7180_status(v4l2_get_subdevdata(sd), NULL, std);
+}

-	*std = determine_norm(client);
-	return 0;
+static int adv7180_g_input_status(struct v4l2_subdev *sd, u32 *status)
+{
+	return __adv7180_status(v4l2_get_subdevdata(sd), status, NULL);
 }

 static int adv7180_g_chip_ident(struct v4l2_subdev *sd,
@@ -104,6 +145,7 @@ static int adv7180_g_chip_ident(struct v4l2_subdev *sd,

 static const struct v4l2_subdev_video_ops adv7180_video_ops = {
 	.querystd = adv7180_querystd,
+	.g_input_status = adv7180_g_input_status,
 };

 static const struct v4l2_subdev_core_ops adv7180_core_ops = {
@@ -143,7 +185,7 @@ static int adv7180_probe(struct i2c_client *client,
 	/* Initialize adv7180 */
 	/* enable autodetection */
 	ret = i2c_smbus_write_byte_data(client, ADV7180_INPUT_CONTROL_REG,
-		ADV7180_INPUT_CONTROL_PAL_BG_NTSC_J_SECAM);
+		ADV7180_INPUT_CONTROL_AD_PAL_BG_NTSC_J_SECAM);
 	if (ret > 0)
 		ret = i2c_smbus_write_byte_data(client,
 			ADV7180_AUTODETECT_ENABLE_REG,
