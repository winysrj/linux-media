Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45794 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3AOIBD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jan 2013 03:01:03 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Lad, Prabhakar" <prabhakar.lad@ti.com>
Subject: [PATCH] media: adv7343: accept configuration through platform data
Date: Tue, 15 Jan 2013 13:30:53 +0530
Message-Id: <1358236853-2467-1-git-send-email-prabhakar.lad@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current code was implemented with some default configurations,
this default configuration works on board and doesn't work on other.

This patch accepts the configuration through platform data and configures
the encoder depending on the data set.

Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
---
 drivers/media/i2c/adv7343.c |   36 +++++++++++++++++++++++++++++++-----
 include/media/adv7343.h     |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
index 2b5aa67..a058058 100644
--- a/drivers/media/i2c/adv7343.c
+++ b/drivers/media/i2c/adv7343.c
@@ -43,6 +43,7 @@ MODULE_PARM_DESC(debug, "Debug level 0-1");
 struct adv7343_state {
 	struct v4l2_subdev sd;
 	struct v4l2_ctrl_handler hdl;
+	const struct adv7343_platform_data *pdata;
 	u8 reg00;
 	u8 reg01;
 	u8 reg02;
@@ -215,12 +216,23 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 	/* Enable Appropriate DAC */
 	val = state->reg00 & 0x03;
 
-	if (output_type == ADV7343_COMPOSITE_ID)
-		val |= ADV7343_COMPOSITE_POWER_VALUE;
-	else if (output_type == ADV7343_COMPONENT_ID)
-		val |= ADV7343_COMPONENT_POWER_VALUE;
+	/* configure default configuration */
+	if (!state->pdata)
+		if (output_type == ADV7343_COMPOSITE_ID)
+			val |= ADV7343_COMPOSITE_POWER_VALUE;
+		else if (output_type == ADV7343_COMPONENT_ID)
+			val |= ADV7343_COMPONENT_POWER_VALUE;
+		else
+			val |= ADV7343_SVIDEO_POWER_VALUE;
 	else
-		val |= ADV7343_SVIDEO_POWER_VALUE;
+		val = state->pdata->mode_config.sleep_mode << 0 |
+		      state->pdata->mode_config.pll_control << 1 |
+		      state->pdata->mode_config.dac_3 << 2 |
+		      state->pdata->mode_config.dac_2 << 3 |
+		      state->pdata->mode_config.dac_1 << 4 |
+		      state->pdata->mode_config.dac_6 << 5 |
+		      state->pdata->mode_config.dac_5 << 6 |
+		      state->pdata->mode_config.dac_4 << 7;
 
 	err = adv7343_write(sd, ADV7343_POWER_MODE_REG, val);
 	if (err < 0)
@@ -238,6 +250,17 @@ static int adv7343_setoutput(struct v4l2_subdev *sd, u32 output_type)
 
 	/* configure SD DAC Output 2 and SD DAC Output 1 bit to zero */
 	val = state->reg82 & (SD_DAC_1_DI & SD_DAC_2_DI);
+
+	if (state->pdata && state->pdata->sd_config.sd_dac_out1)
+		val = val | (state->pdata->sd_config.sd_dac_out1 << 1);
+	else if (state->pdata && !state->pdata->sd_config.sd_dac_out1)
+		val = val & ~(state->pdata->sd_config.sd_dac_out1 << 1);
+
+	if (state->pdata && state->pdata->sd_config.sd_dac_out2)
+		val = val | (state->pdata->sd_config.sd_dac_out2 << 2);
+	else if (state->pdata && !state->pdata->sd_config.sd_dac_out2)
+		val = val & ~(state->pdata->sd_config.sd_dac_out2 << 2);
+
 	err = adv7343_write(sd, ADV7343_SD_MODE_REG2, val);
 	if (err < 0)
 		goto setoutput_exit;
@@ -401,6 +424,9 @@ static int adv7343_probe(struct i2c_client *client,
 	if (state == NULL)
 		return -ENOMEM;
 
+	/* Copy board specific information here */
+	state->pdata = client->dev.platform_data;
+
 	state->reg00	= 0x80;
 	state->reg01	= 0x00;
 	state->reg02	= 0x20;
diff --git a/include/media/adv7343.h b/include/media/adv7343.h
index d6f8a4e..8086e46 100644
--- a/include/media/adv7343.h
+++ b/include/media/adv7343.h
@@ -20,4 +20,36 @@
 #define ADV7343_COMPONENT_ID	(1)
 #define ADV7343_SVIDEO_ID	(2)
 
+struct adv7343_power_mode {
+	bool sleep_mode;
+	bool pll_control;
+	bool dac_1;
+	bool dac_2;
+	bool dac_3;
+	bool dac_4;
+	bool dac_5;
+	bool dac_6;
+};
+
+/**
+ * struct adv7343_sd_config - SD Only Output Configuration.
+ * @sd_dac_out1: Configure SD DAC Output 1.
+ * @sd_dac_out2: Configure SD DAC Output 2.
+ */
+struct adv7343_sd_config {
+	/* SD only Output Configuration */
+	bool sd_dac_out1;
+	bool sd_dac_out2;
+};
+
+/**
+ * struct adv7343_platform_data - Platform data values and access functions.
+ * @mode_config: Configuration for power mode.
+ * @sd_config: SD Only Configuration.
+ */
+struct adv7343_platform_data {
+	struct adv7343_power_mode mode_config;
+	struct adv7343_sd_config sd_config;
+};
+
 #endif				/* End of #ifndef ADV7343_H */
-- 
1.7.4.1

