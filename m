Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:36987 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936682AbeCBQg2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 11:36:28 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
        sakari.ailus@iki.fi, mchehab@kernel.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5]  media: i2c: mt9t112: Fix code style issues
Date: Fri,  2 Mar 2018 17:35:39 +0100
Message-Id: <1520008541-3961-4-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1520008541-3961-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix code style issues reported by checkpatch run with --strict
options. Also fix other non reported style issues manually.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/mt9t112.c | 256 ++++++++++++++++++++------------------------
 1 file changed, 118 insertions(+), 138 deletions(-)

diff --git a/drivers/media/i2c/mt9t112.c b/drivers/media/i2c/mt9t112.c
index 6b77dff..6eaf3c6 100644
--- a/drivers/media/i2c/mt9t112.c
+++ b/drivers/media/i2c/mt9t112.c
@@ -35,8 +35,8 @@
 /* #define EXT_CLOCK 24000000 */
 
 /************************************************************************
-			macro
-************************************************************************/
+ *			macro
+ ***********************************************************************/
 /*
  * frame size
  */
@@ -74,8 +74,8 @@
 #define VAR8(id, offset) _VAR(id, offset, 0x8000)
 
 /************************************************************************
-			struct
-************************************************************************/
+ *			struct
+ ***********************************************************************/
 struct mt9t112_format {
 	u32 code;
 	enum v4l2_colorspace colorspace;
@@ -96,8 +96,8 @@ struct mt9t112_priv {
 };
 
 /************************************************************************
-			supported format
-************************************************************************/
+ *			supported format
+ ***********************************************************************/
 
 static const struct mt9t112_format mt9t112_cfmts[] = {
 	{
@@ -134,8 +134,8 @@ static const struct mt9t112_format mt9t112_cfmts[] = {
 };
 
 /************************************************************************
-			general function
-************************************************************************/
+ *			general function
+ ***********************************************************************/
 static struct mt9t112_priv *to_mt9t112(const struct i2c_client *client)
 {
 	return container_of(i2c_get_clientdata(client),
@@ -162,15 +162,15 @@ static int __mt9t112_reg_read(const struct i2c_client *client, u16 command)
 	msg[1].buf   = buf;
 
 	/*
-	 * if return value of this function is < 0,
-	 * it mean error.
-	 * else, under 16bit is valid data.
+	 * If return value of this function is < 0, it means error, else,
+	 * below 16bit is valid data.
 	 */
 	ret = i2c_transfer(client->adapter, msg, 2);
 	if (ret < 0)
 		return ret;
 
 	memcpy(&ret, buf, 2);
+
 	return swab16(ret);
 }
 
@@ -193,22 +193,19 @@ static int __mt9t112_reg_write(const struct i2c_client *client,
 	msg.buf   = buf;
 
 	/*
-	 * i2c_transfer return message length,
-	 * but this function should return 0 if correct case
+	 * i2c_transfer return message length, but this function should
+	 * return 0 if correct case.
 	 */
 	ret = i2c_transfer(client->adapter, &msg, 1);
-	if (ret >= 0)
-		ret = 0;
 
-	return ret;
+	return ret >= 0 ? 0 : ret;
 }
 
 static int __mt9t112_reg_mask_set(const struct i2c_client *client,
-				  u16  command,
-				  u16  mask,
-				  u16  set)
+				  u16  command, u16  mask, u16  set)
 {
 	int val = __mt9t112_reg_read(client, command);
+
 	if (val < 0)
 		return val;
 
@@ -243,11 +240,10 @@ static int __mt9t112_mcu_write(const struct i2c_client *client,
 }
 
 static int __mt9t112_mcu_mask_set(const struct i2c_client *client,
-				  u16  command,
-				  u16  mask,
-				  u16  set)
+				  u16  command, u16  mask, u16  set)
 {
 	int val = __mt9t112_mcu_read(client, command);
+
 	if (val < 0)
 		return val;
 
@@ -262,7 +258,7 @@ static int mt9t112_reset(const struct i2c_client *client)
 	int ret;
 
 	mt9t112_reg_mask_set(ret, client, 0x001a, 0x0001, 0x0001);
-	msleep(1);
+	usleep_range(1000, 5000);
 	mt9t112_reg_mask_set(ret, client, 0x001a, 0x0001, 0x0000);
 
 	return ret;
@@ -301,38 +297,38 @@ static int mt9t112_clock_info(const struct i2c_client *client, u32 ext)
 	m = n & 0x00ff;
 	n = (n >> 8) & 0x003f;
 
-	enable = ((6000 > ext) || (54000 < ext)) ? "X" : "";
+	enable = ((ext < 6000) || (ext > 54000)) ? "X" : "";
 	dev_dbg(&client->dev, "EXTCLK          : %10u K %s\n", ext, enable);
 
-	vco = 2 * m * ext / (n+1);
-	enable = ((384000 > vco) || (768000 < vco)) ? "X" : "";
+	vco = 2 * m * ext / (n + 1);
+	enable = ((vco < 384000) || (vco > 768000)) ? "X" : "";
 	dev_dbg(&client->dev, "VCO             : %10u K %s\n", vco, enable);
 
-	clk = vco / (p1+1) / (p2+1);
-	enable = (96000 < clk) ? "X" : "";
+	clk = vco / (p1 + 1) / (p2 + 1);
+	enable = (clk > 96000) ? "X" : "";
 	dev_dbg(&client->dev, "PIXCLK          : %10u K %s\n", clk, enable);
 
-	clk = vco / (p3+1);
-	enable = (768000 < clk) ? "X" : "";
+	clk = vco / (p3 + 1);
+	enable = (clk > 768000) ? "X" : "";
 	dev_dbg(&client->dev, "MIPICLK         : %10u K %s\n", clk, enable);
 
-	clk = vco / (p6+1);
-	enable = (96000 < clk) ? "X" : "";
+	clk = vco / (p6 + 1);
+	enable = (clk > 96000) ? "X" : "";
 	dev_dbg(&client->dev, "MCU CLK         : %10u K %s\n", clk, enable);
 
-	clk = vco / (p5+1);
-	enable = (54000 < clk) ? "X" : "";
+	clk = vco / (p5 + 1);
+	enable = (clk > 54000) ? "X" : "";
 	dev_dbg(&client->dev, "SOC CLK         : %10u K %s\n", clk, enable);
 
-	clk = vco / (p4+1);
-	enable = (70000 < clk) ? "X" : "";
+	clk = vco / (p4 + 1);
+	enable = (clk > 70000) ? "X" : "";
 	dev_dbg(&client->dev, "Sensor CLK      : %10u K %s\n", clk, enable);
 
-	clk = vco / (p7+1);
+	clk = vco / (p7 + 1);
 	dev_dbg(&client->dev, "External sensor : %10u K\n", clk);
 
-	clk = ext / (n+1);
-	enable = ((2000 > clk) || (24000 < clk)) ? "X" : "";
+	clk = ext / (n + 1);
+	enable = ((clk < 2000) || (clk > 24000)) ? "X" : "";
 	dev_dbg(&client->dev, "PFD             : %10u K %s\n", clk, enable);
 
 	return 0;
@@ -340,26 +336,25 @@ static int mt9t112_clock_info(const struct i2c_client *client, u32 ext)
 #endif
 
 static int mt9t112_set_a_frame_size(const struct i2c_client *client,
-				   u16 width,
-				   u16 height)
+				    u16 width, u16 height)
 {
 	int ret;
 	u16 wstart = (MAX_WIDTH - width) / 2;
 	u16 hstart = (MAX_HEIGHT - height) / 2;
 
-	/* (Context A) Image Width/Height */
+	/* (Context A) Image Width/Height. */
 	mt9t112_mcu_write(ret, client, VAR(26, 0), width);
 	mt9t112_mcu_write(ret, client, VAR(26, 2), height);
 
-	/* (Context A) Output Width/Height */
+	/* (Context A) Output Width/Height. */
 	mt9t112_mcu_write(ret, client, VAR(18, 43), 8 + width);
 	mt9t112_mcu_write(ret, client, VAR(18, 45), 8 + height);
 
-	/* (Context A) Start Row/Column */
+	/* (Context A) Start Row/Column. */
 	mt9t112_mcu_write(ret, client, VAR(18, 2), 4 + hstart);
 	mt9t112_mcu_write(ret, client, VAR(18, 4), 4 + wstart);
 
-	/* (Context A) End Row/Column */
+	/* (Context A) End Row/Column. */
 	mt9t112_mcu_write(ret, client, VAR(18, 6), 11 + height + hstart);
 	mt9t112_mcu_write(ret, client, VAR(18, 8), 11 + width  + wstart);
 
@@ -369,35 +364,27 @@ static int mt9t112_set_a_frame_size(const struct i2c_client *client,
 }
 
 static int mt9t112_set_pll_dividers(const struct i2c_client *client,
-				    u8 m, u8 n,
-				    u8 p1, u8 p2, u8 p3,
-				    u8 p4, u8 p5, u8 p6,
-				    u8 p7)
+				    u8 m, u8 n, u8 p1, u8 p2, u8 p3, u8 p4,
+				    u8 p5, u8 p6, u8 p7)
 {
 	int ret;
 	u16 val;
 
 	/* N/M */
-	val = (n << 8) |
-	      (m << 0);
+	val = (n << 8) | (m << 0);
 	mt9t112_reg_mask_set(ret, client, 0x0010, 0x3fff, val);
 
 	/* P1/P2/P3 */
-	val = ((p3 & 0x0F) << 8) |
-	      ((p2 & 0x0F) << 4) |
-	      ((p1 & 0x0F) << 0);
+	val = ((p3 & 0x0F) << 8) | ((p2 & 0x0F) << 4) | ((p1 & 0x0F) << 0);
 	mt9t112_reg_mask_set(ret, client, 0x0012, 0x0fff, val);
 
 	/* P4/P5/P6 */
-	val = (0x7         << 12) |
-	      ((p6 & 0x0F) <<  8) |
-	      ((p5 & 0x0F) <<  4) |
+	val = (0x7 << 12) | ((p6 & 0x0F) <<  8) | ((p5 & 0x0F) <<  4) |
 	      ((p4 & 0x0F) <<  0);
 	mt9t112_reg_mask_set(ret, client, 0x002A, 0x7fff, val);
 
 	/* P7 */
-	val = (0x1         << 12) |
-	      ((p7 & 0x0F) <<  0);
+	val = (0x1 << 12) | ((p7 & 0x0F) <<  0);
 	mt9t112_reg_mask_set(ret, client, 0x002C, 0x100f, val);
 
 	return ret;
@@ -410,19 +397,15 @@ static int mt9t112_init_pll(const struct i2c_client *client)
 
 	mt9t112_reg_mask_set(ret, client, 0x0014, 0x003, 0x0001);
 
-	/* PLL control: BYPASS PLL = 8517 */
+	/* PLL control: BYPASS PLL = 8517. */
 	mt9t112_reg_write(ret, client, 0x0014, 0x2145);
 
-	/* Replace these registers when new timing parameters are generated */
+	/* Replace these registers when new timing parameters are generated. */
 	mt9t112_set_pll_dividers(client,
-				 priv->info->divider.m,
-				 priv->info->divider.n,
-				 priv->info->divider.p1,
-				 priv->info->divider.p2,
-				 priv->info->divider.p3,
-				 priv->info->divider.p4,
-				 priv->info->divider.p5,
-				 priv->info->divider.p6,
+				 priv->info->divider.m, priv->info->divider.n,
+				 priv->info->divider.p1, priv->info->divider.p2,
+				 priv->info->divider.p3, priv->info->divider.p4,
+				 priv->info->divider.p5, priv->info->divider.p6,
 				 priv->info->divider.p7);
 
 	/*
@@ -444,20 +427,21 @@ static int mt9t112_init_pll(const struct i2c_client *client)
 	 * I2C Master Clock Divider
 	 */
 	mt9t112_reg_write(ret, client, 0x0014, 0x3046);
-	mt9t112_reg_write(ret, client, 0x0016, 0x0400); /* JPEG initialization workaround */
+	/* JPEG initialization workaround */
+	mt9t112_reg_write(ret, client, 0x0016, 0x0400);
 	mt9t112_reg_write(ret, client, 0x0022, 0x0190);
 	mt9t112_reg_write(ret, client, 0x3B84, 0x0212);
 
-	/* External sensor clock is PLL bypass */
+	/* External sensor clock is PLL bypass. */
 	mt9t112_reg_write(ret, client, 0x002E, 0x0500);
 
 	mt9t112_reg_mask_set(ret, client, 0x0018, 0x0002, 0x0002);
 	mt9t112_reg_mask_set(ret, client, 0x3B82, 0x0004, 0x0004);
 
-	/* MCU disabled */
+	/* MCU disabled. */
 	mt9t112_reg_mask_set(ret, client, 0x0018, 0x0004, 0x0004);
 
-	/* out of standby */
+	/* Out of standby. */
 	mt9t112_reg_mask_set(ret, client, 0x0018, 0x0001, 0);
 
 	mdelay(50);
@@ -479,10 +463,10 @@ static int mt9t112_init_pll(const struct i2c_client *client)
 	mt9t112_reg_write(ret, client, 0x0614, 0x0001);
 	mdelay(1);
 
-	/* poll to verify out of standby. Must Poll this bit */
+	/* Poll to verify out of standby. Must Poll this bit. */
 	for (i = 0; i < 100; i++) {
 		mt9t112_reg_read(data, client, 0x0018);
-		if (!(0x4000 & data))
+		if (!(data & 0x4000))
 			break;
 
 		mdelay(10);
@@ -493,7 +477,6 @@ static int mt9t112_init_pll(const struct i2c_client *client)
 
 static int mt9t112_init_setting(const struct i2c_client *client)
 {
-
 	int ret;
 
 	/* Adaptive Output Clock (A) */
@@ -554,11 +537,11 @@ static int mt9t112_init_setting(const struct i2c_client *client)
 	mt9t112_mcu_write(ret, client, VAR(18, 109), 0x0AF0);
 
 	/*
-	 * Flicker Dectection registers
-	 * This section should be replaced whenever new Timing file is generated
-	 * All the following registers need to be replaced
+	 * Flicker Dectection registers.
+	 * This section should be replaced whenever new timing file is
+	 * generated. All the following registers need to be replaced.
 	 * Following registers are generated from Register Wizard but user can
-	 * modify them. For detail see auto flicker detection tuning
+	 * modify them. For detail see auto flicker detection tuning.
 	 */
 
 	/* FD_FDPERIOD_SELECT */
@@ -571,47 +554,47 @@ static int mt9t112_init_setting(const struct i2c_client *client)
 	mt9t112_mcu_write(ret, client, VAR(26, 17), 0x0003);
 
 	/*
-	 * AFD range detection tuning registers
+	 * AFD range detection tuning registers.
 	 */
 
-	/* search_f1_50 */
+	/* Search_f1_50 */
 	mt9t112_mcu_write(ret, client, VAR8(18, 165), 0x25);
 
-	/* search_f2_50 */
+	/* Search_f2_50 */
 	mt9t112_mcu_write(ret, client, VAR8(18, 166), 0x28);
 
-	/* search_f1_60 */
+	/* Search_f1_60 */
 	mt9t112_mcu_write(ret, client, VAR8(18, 167), 0x2C);
 
-	/* search_f2_60 */
+	/* Search_f2_60 */
 	mt9t112_mcu_write(ret, client, VAR8(18, 168), 0x2F);
 
-	/* period_50Hz (A) */
+	/* Period_50Hz (A) */
 	mt9t112_mcu_write(ret, client, VAR8(18, 68), 0xBA);
 
-	/* secret register by aptina */
-	/* period_50Hz (A MSB) */
+	/* Secret register by Aptina. */
+	/* Period_50Hz (A MSB) */
 	mt9t112_mcu_write(ret, client, VAR8(18, 303), 0x00);
 
-	/* period_60Hz (A) */
+	/* Period_60Hz (A) */
 	mt9t112_mcu_write(ret, client, VAR8(18, 69), 0x9B);
 
-	/* secret register by aptina */
-	/* period_60Hz (A MSB) */
+	/* Secret register by Aptina. */
+	/* Period_60Hz (A MSB) */
 	mt9t112_mcu_write(ret, client, VAR8(18, 301), 0x00);
 
-	/* period_50Hz (B) */
+	/* Period_50Hz (B) */
 	mt9t112_mcu_write(ret, client, VAR8(18, 140), 0x82);
 
-	/* secret register by aptina */
-	/* period_50Hz (B) MSB */
+	/* Secret register by Aptina. */
+	/* Period_50Hz (B) MSB */
 	mt9t112_mcu_write(ret, client, VAR8(18, 304), 0x00);
 
-	/* period_60Hz (B) */
+	/* Period_60Hz (B) */
 	mt9t112_mcu_write(ret, client, VAR8(18, 141), 0x6D);
 
-	/* secret register by aptina */
-	/* period_60Hz (B) MSB */
+	/* Secret register by Aptina. */
+	/* Period_60Hz (B) MSB */
 	mt9t112_mcu_write(ret, client, VAR8(18, 302), 0x00);
 
 	/* FD Mode */
@@ -685,49 +668,50 @@ static int mt9t112_init_camera(const struct i2c_client *client)
 	int ret;
 
 	ECHECKER(ret, mt9t112_reset(client));
-
 	ECHECKER(ret, mt9t112_init_pll(client));
-
 	ECHECKER(ret, mt9t112_init_setting(client));
-
 	ECHECKER(ret, mt9t112_auto_focus_setting(client));
 
 	mt9t112_reg_mask_set(ret, client, 0x0018, 0x0004, 0);
 
-	/* Analog setting B */
+	/* Analog setting B.*/
 	mt9t112_reg_write(ret, client, 0x3084, 0x2409);
 	mt9t112_reg_write(ret, client, 0x3092, 0x0A49);
 	mt9t112_reg_write(ret, client, 0x3094, 0x4949);
 	mt9t112_reg_write(ret, client, 0x3096, 0x4950);
 
 	/*
-	 * Disable adaptive clock
+	 * Disable adaptive clock.
 	 * PRI_A_CONFIG_JPEG_OB_TX_CONTROL_VAR
 	 * PRI_B_CONFIG_JPEG_OB_TX_CONTROL_VAR
 	 */
 	mt9t112_mcu_write(ret, client, VAR(26, 160), 0x0A2E);
 	mt9t112_mcu_write(ret, client, VAR(27, 160), 0x0A2E);
 
-	/* Configure STatus in Status_before_length Format and enable header */
-	/* PRI_B_CONFIG_JPEG_OB_TX_CONTROL_VAR */
+	/*
+	 * Configure Status in Status_before_length Format and enable header.
+	 * PRI_B_CONFIG_JPEG_OB_TX_CONTROL_VAR
+	 */
 	mt9t112_mcu_write(ret, client, VAR(27, 144), 0x0CB4);
 
-	/* Enable JPEG in context B */
-	/* PRI_B_CONFIG_JPEG_OB_TX_CONTROL_VAR */
+	/*
+	 * Enable JPEG in context B.
+	 * PRI_B_CONFIG_JPEG_OB_TX_CONTROL_VAR
+	 */
 	mt9t112_mcu_write(ret, client, VAR8(27, 142), 0x01);
 
-	/* Disable Dac_TXLO */
+	/* Disable Dac_TXLO. */
 	mt9t112_reg_write(ret, client, 0x316C, 0x350F);
 
-	/* Set max slew rates */
+	/* Set max slew rates. */
 	mt9t112_reg_write(ret, client, 0x1E, 0x777);
 
 	return ret;
 }
 
 /************************************************************************
-			v4l2_subdev_core_ops
-************************************************************************/
+ *			v4l2_subdev_core_ops
+ ***********************************************************************/
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int mt9t112_g_register(struct v4l2_subdev *sd,
@@ -800,10 +784,9 @@ static const struct v4l2_subdev_core_ops mt9t112_subdev_core_ops = {
 	.s_power	= mt9t112_s_power,
 };
 
-
 /************************************************************************
-			v4l2_subdev_video_ops
-************************************************************************/
+ *			v4l2_subdev_video_ops
+ **********************************************************************/
 static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -813,8 +796,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 	if (!enable) {
 		/* FIXME
 		 *
-		 * If user selected large output size,
-		 * and used it long time,
+		 * If user selected large output size, and used it long time,
 		 * mt9t112 camera will be very warm.
 		 *
 		 * But current driver can not stop mt9t112 camera.
@@ -830,7 +812,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 
 		ECHECKER(ret, mt9t112_init_camera(client));
 
-		/* Invert PCLK (Data sampled on falling edge of pixclk) */
+		/* Invert PCLK (Data sampled on falling edge of pixclk). */
 		mt9t112_reg_write(ret, client, 0x3C20, param);
 
 		mdelay(5);
@@ -842,9 +824,7 @@ static int mt9t112_s_stream(struct v4l2_subdev *sd, int enable)
 	mt9t112_mcu_write(ret, client, VAR(26, 9), priv->format->order);
 	mt9t112_mcu_write(ret, client, VAR8(1, 0), 0x06);
 
-	mt9t112_set_a_frame_size(client,
-				 priv->frame.width,
-				 priv->frame.height);
+	mt9t112_set_a_frame_size(client, priv->frame.width, priv->frame.height);
 
 	ECHECKER(ret, mt9t112_auto_focus_trigger(client));
 
@@ -874,7 +854,7 @@ static int mt9t112_set_params(struct mt9t112_priv *priv,
 	if (i == priv->num_formats)
 		return -EINVAL;
 
-	priv->frame  = *rect;
+	priv->frame = *rect;
 
 	/*
 	 * frame size check
@@ -888,7 +868,7 @@ static int mt9t112_set_params(struct mt9t112_priv *priv,
 }
 
 static int mt9t112_get_selection(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -919,8 +899,8 @@ static int mt9t112_get_selection(struct v4l2_subdev *sd,
 }
 
 static int mt9t112_set_selection(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_selection *sel)
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_selection *sel)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
@@ -934,8 +914,8 @@ static int mt9t112_set_selection(struct v4l2_subdev *sd,
 }
 
 static int mt9t112_get_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *format)
 {
 	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
@@ -975,11 +955,11 @@ static int mt9t112_s_fmt(struct v4l2_subdev *sd,
 }
 
 static int mt9t112_set_fmt(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_format *format)
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *format)
 {
-	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	struct mt9t112_priv *priv = to_mt9t112(client);
 	int i;
 
@@ -994,7 +974,7 @@ static int mt9t112_set_fmt(struct v4l2_subdev *sd,
 		mf->code = MEDIA_BUS_FMT_UYVY8_2X8;
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	} else {
-		mf->colorspace	= mt9t112_cfmts[i].colorspace;
+		mf->colorspace = mt9t112_cfmts[i].colorspace;
 	}
 
 	v4l_bound_align_image(&mf->width, 0, MAX_WIDTH, 0,
@@ -1005,12 +985,13 @@ static int mt9t112_set_fmt(struct v4l2_subdev *sd,
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return mt9t112_s_fmt(sd, mf);
 	cfg->try_fmt = *mf;
+
 	return 0;
 }
 
 static int mt9t112_enum_mbus_code(struct v4l2_subdev *sd,
-		struct v4l2_subdev_pad_config *cfg,
-		struct v4l2_subdev_mbus_code_enum *code)
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct mt9t112_priv *priv = to_mt9t112(client);
@@ -1028,7 +1009,7 @@ static const struct v4l2_subdev_video_ops mt9t112_subdev_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
-	.enum_mbus_code = mt9t112_enum_mbus_code,
+	.enum_mbus_code	= mt9t112_enum_mbus_code,
 	.get_selection	= mt9t112_get_selection,
 	.set_selection	= mt9t112_set_selection,
 	.get_fmt	= mt9t112_get_fmt,
@@ -1036,8 +1017,8 @@ static const struct v4l2_subdev_pad_ops mt9t112_subdev_pad_ops = {
 };
 
 /************************************************************************
-			i2c driver
-************************************************************************/
+ *			i2c driver
+ ***********************************************************************/
 static const struct v4l2_subdev_ops mt9t112_subdev_ops = {
 	.core	= &mt9t112_subdev_core_ops,
 	.video	= &mt9t112_subdev_video_ops,
@@ -1055,9 +1036,7 @@ static int mt9t112_camera_probe(struct i2c_client *client)
 	if (ret < 0)
 		return ret;
 
-	/*
-	 * check and show chip ID
-	 */
+	/* Check and show chip ID. */
 	mt9t112_reg_read(chipid, client, 0x0000);
 
 	switch (chipid) {
@@ -1079,6 +1058,7 @@ static int mt9t112_camera_probe(struct i2c_client *client)
 
 done:
 	mt9t112_s_power(&priv->subdev, 0);
+
 	return ret;
 }
 
@@ -1121,7 +1101,7 @@ static int mt9t112_probe(struct i2c_client *client,
 	if (ret)
 		return ret;
 
-	return  v4l2_async_register_subdev(&priv->subdev);
+	return v4l2_async_register_subdev(&priv->subdev);
 }
 
 static int mt9t112_remove(struct i2c_client *client)
-- 
2.7.4
