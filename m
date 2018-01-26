Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51770 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752188AbeAZN4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 08:56:19 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/11] media: i2c: ov772x: Support frame interval handling
Date: Fri, 26 Jan 2018 14:55:26 +0100
Message-Id: <1516974930-11713-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1516974930-11713-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1516974930-11713-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support to ov772x driver for frame intervals handling and enumeration.
Tested with 10MHz and 24MHz input clock at VGA and QVGA resolutions for
10, 15 and 30 frame per second rates.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 drivers/media/i2c/ov772x.c | 315 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 310 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 912b1b9..6d46748 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -250,6 +250,7 @@
 #define AEC_1p2         0x10	/*  01: 1/2  window */
 #define AEC_1p4         0x20	/*  10: 1/4  window */
 #define AEC_2p3         0x30	/*  11: Low 2/3 window */
+#define COM4_RESERVED   0x01	/* Reserved value */
 
 /* COM5 */
 #define AFR_ON_OFF      0x80	/* Auto frame rate control ON/OFF selection */
@@ -267,6 +268,19 @@
 				/* AEC max step control */
 #define AEC_NO_LIMIT    0x01	/*   0 : AEC incease step has limit */
 				/*   1 : No limit to AEC increase step */
+/* CLKRC */
+				/* Input clock divider register */
+#define CLKRC_RESERVED  0x80	/* Reserved value */
+#define CLKRC_BYPASS    0x40	/* Bypass input clock divider */
+#define CLKRC_DIV2      0x01	/* Divide input clock by 2 */
+#define CLKRC_DIV3      0x02	/* Divide input clock by 3 */
+#define CLKRC_DIV4      0x03	/* Divide input clock by 4 */
+#define CLKRC_DIV5      0x04	/* Divide input clock by 5 */
+#define CLKRC_DIV6      0x05	/* Divide input clock by 6 */
+#define CLKRC_DIV8      0x07	/* Divide input clock by 8 */
+#define CLKRC_DIV10     0x09	/* Divide input clock by 10 */
+#define CLKRC_DIV16     0x0f	/* Divide input clock by 16 */
+#define CLKRC_DIV20     0x13	/* Divide input clock by 20 */
 
 /* COM7 */
 				/* SCCB Register Reset */
@@ -373,6 +387,12 @@
 #define VERSION(pid, ver) ((pid<<8)|(ver&0xFF))
 
 /*
+ * Input clock frequencies
+ */
+enum { OV772X_FIN_10MHz, OV772X_FIN_24MHz, OV772X_FIN_48MHz, OV772X_FIN_N, };
+static unsigned int ov772x_fin_vals[] = { 10000000, 24000000, 48000000 };
+
+/*
  * struct
  */
 
@@ -391,6 +411,16 @@ struct ov772x_win_size {
 	struct v4l2_rect	  rect;
 };
 
+struct ov772x_pclk_config {
+	u8 com4;
+	u8 clkrc;
+};
+
+struct ov772x_frame_rate {
+	unsigned int fps;
+	const struct ov772x_pclk_config pclk[OV772X_FIN_N];
+};
+
 struct ov772x_priv {
 	struct v4l2_subdev                subdev;
 	struct v4l2_ctrl_handler	  hdl;
@@ -404,6 +434,7 @@ struct ov772x_priv {
 	unsigned short                    flag_hflip:1;
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
 	unsigned short                    band_filter;
+	unsigned int			  fps;
 };
 
 /*
@@ -508,6 +539,154 @@ static const struct ov772x_win_size ov772x_win_sizes[] = {
 };
 
 /*
+ * frame rate settings lists
+ */
+unsigned int ov772x_frame_intervals[] = {10, 15, 30, 60};
+#define OV772X_N_FRAME_INTERVALS ARRAY_SIZE(ov772x_frame_intervals)
+
+static const struct ov772x_frame_rate vga_frame_rates[] = {
+	{	/* PCLK = 7,5 MHz */
+		.fps		= 10,
+		.pclk = {
+			[OV772X_FIN_10MHz] = {
+				.com4	= PLL_6x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV8 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz] = {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV3 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz] = {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV6 | CLKRC_RESERVED,
+			},
+		},
+	},
+	{	/* PCLK = 12 MHz */
+		.fps		= 15,
+		.pclk = {
+			[OV772X_FIN_10MHz]	= {
+				.com4	= PLL_4x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV3 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV2 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV4 | CLKRC_RESERVED,
+			},
+		},
+	},
+	{	/* PCLK = 24 MHz */
+		.fps		= 30,
+		.pclk = {
+			[OV772X_FIN_10MHz]	= {
+				.com4	= PLL_8x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV3 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_BYPASS | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV2 | CLKRC_RESERVED,
+			},
+		},
+	},
+	{	/* PCLK = 48 MHz */
+		.fps		= 60,
+		.pclk = {
+			[OV772X_FIN_10MHz]	= {
+				.com4	= PLL_8x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV2 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz]	= {
+				.com4	= PLL_4x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV2 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_BYPASS | CLKRC_RESERVED,
+			},
+		},
+	},
+};
+
+static const struct ov772x_frame_rate qvga_frame_rates[] = {
+	{	/* PCLK = 3,2 MHz */
+		.fps		= 10,
+		.pclk = {
+			[OV772X_FIN_10MHz] = {
+				.com4	= PLL_6x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV16 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz] = {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV8 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz] = {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV16 | CLKRC_RESERVED,
+			},
+		},
+	},
+	{	/* PCLK = 4,8 MHz */
+		.fps		= 15,
+		.pclk = {
+			[OV772X_FIN_10MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV2 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV5 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV10 | CLKRC_RESERVED,
+			},
+		},
+	},
+	{	/* PCLK = 9,6 MHz */
+		.fps		= 30,
+		.pclk = {
+			[OV772X_FIN_10MHz]	= {
+				.com4	= PLL_BYPASS | COM4_RESERVED,
+				.clkrc	= CLKRC_BYPASS | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz]	= {
+				.com4	= PLL_4x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV10 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz]	= {
+				.com4	= PLL_4x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV20 | CLKRC_RESERVED,
+			},
+		},
+	},
+	{	/* PCLK = 19 MHz */
+		.fps		= 60,
+		.pclk = {
+			[OV772X_FIN_10MHz]	= {
+				.com4	= PLL_4x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV2 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_24MHz]	= {
+				.com4	= PLL_6x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV8 | CLKRC_RESERVED,
+			},
+			[OV772X_FIN_48MHz]	= {
+				.com4	= PLL_6x | COM4_RESERVED,
+				.clkrc	= CLKRC_DIV16 | CLKRC_RESERVED,
+			},
+		},
+	},
+};
+
+/*
  * general function
  */
 
@@ -574,6 +753,102 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
+/*
+ * Approximate input clock frequency to the closes possible one used to
+ * calculate pixel clock settings.
+ */
+static int ov772x_get_fin(struct ov772x_priv *priv)
+{
+	unsigned int clk_rate = clk_get_rate(priv->clk);
+	unsigned int rate_prev = ~0L;
+	unsigned int rate;
+	unsigned int idx;
+	unsigned int i;
+
+	for (i = 0, idx = 0; i < OV772X_FIN_N; i++) {
+		rate = abs(ov772x_fin_vals[i] - clk_rate);
+		if (rate < rate_prev) {
+			rate_prev = rate;
+			idx = i;
+		}
+	}
+
+	return idx;
+}
+
+static int ov772x_set_frame_rate(struct ov772x_priv *priv,
+				 struct v4l2_fract *tpf, unsigned int fin,
+				 const struct ov772x_win_size *win)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	unsigned int fps = tpf->denominator / tpf->numerator;
+	const struct ov772x_frame_rate *frate;
+	const struct ov772x_pclk_config *pclk;
+	unsigned int rate_prev = ~0L;
+	unsigned int rate;
+	unsigned int idx;
+	unsigned int i;
+	int ret;
+
+	if (win->rect.width == VGA_WIDTH &&
+	    win->rect.height == VGA_HEIGHT)
+		frate = vga_frame_rates;
+	else if (win->rect.width == QVGA_WIDTH &&
+		 win->rect.height == QVGA_HEIGHT)
+		frate = qvga_frame_rates;
+	else
+		return -EINVAL;
+
+	/* Approximate to the closest possible frame interval. */
+	for (i = 0, idx = 0; i < OV772X_N_FRAME_INTERVALS; i++) {
+		rate = abs(fps - frate[i].fps);
+		if (rate < rate_prev) {
+			idx = i;
+			rate_prev = rate;
+		}
+	}
+
+	pclk = &frate[idx].pclk[fin];
+
+	ret = ov772x_write(client, COM4, pclk->com4);
+	if (ret < 0)
+		return ret;
+
+	ret = ov772x_write(client, CLKRC, pclk->clkrc);
+	if (ret < 0)
+		return ret;
+
+	tpf->numerator = 1;
+	tpf->denominator = frate[idx].fps;
+	priv->fps = tpf->denominator;
+
+	return 0;
+}
+
+static int ov772x_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
+{
+	struct ov772x_priv *priv = to_ov772x(sd);
+	struct v4l2_fract *tpf = &ival->interval;
+
+	memset(ival->reserved, 0, sizeof(ival->reserved));
+	tpf->numerator = 1;
+	tpf->denominator = priv->fps;
+
+	return 0;
+}
+
+static int ov772x_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
+{
+	struct ov772x_priv *priv = to_ov772x(sd);
+	struct v4l2_fract *tpf = &ival->interval;
+
+	memset(ival->reserved, 0, sizeof(ival->reserved));
+
+	return ov772x_set_frame_rate(priv, tpf,
+				     ov772x_get_fin(priv), priv->win);
+}
 static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct ov772x_priv *priv = container_of(ctrl->handler,
@@ -757,6 +1032,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 			     const struct ov772x_win_size *win)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	struct v4l2_fract tpf;
 	int ret;
 	u8  val;
 
@@ -885,6 +1161,13 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
+	/* COM4, CLKRC: Set pixel clock and framerate. */
+	tpf.numerator = 1;
+	tpf.denominator = priv->fps;
+	ret = ov772x_set_frame_rate(priv, &tpf, ov772x_get_fin(priv), win);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+
 	/*
 	 * set COM8
 	 */
@@ -1040,6 +1323,24 @@ static const struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 	.s_power	= ov772x_s_power,
 };
 
+static int ov772x_enum_frame_interval(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_pad_config *cfg,
+				      struct v4l2_subdev_frame_interval_enum *fie)
+{
+	if (fie->pad || fie->index >= OV772X_N_FRAME_INTERVALS)
+		return -EINVAL;
+
+	if (fie->width != VGA_WIDTH && fie->width != QVGA_WIDTH)
+		return -EINVAL;
+	if (fie->height != VGA_HEIGHT && fie->height != QVGA_HEIGHT)
+		return -EINVAL;
+
+	fie->interval.numerator = 1;
+	fie->interval.denominator = ov772x_frame_intervals[fie->index];
+
+	return 0;
+}
+
 static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
 		struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_mbus_code_enum *code)
@@ -1052,14 +1353,17 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static const struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
-	.s_stream	= ov772x_s_stream,
+	.s_stream		= ov772x_s_stream,
+	.s_frame_interval	= ov772x_s_frame_interval,
+	.g_frame_interval	= ov772x_g_frame_interval,
 };
 
 static const struct v4l2_subdev_pad_ops ov772x_subdev_pad_ops = {
-	.enum_mbus_code = ov772x_enum_mbus_code,
-	.get_selection	= ov772x_get_selection,
-	.get_fmt	= ov772x_get_fmt,
-	.set_fmt	= ov772x_set_fmt,
+	.enum_frame_interval	= ov772x_enum_frame_interval,
+	.enum_mbus_code		= ov772x_enum_mbus_code,
+	.get_selection		= ov772x_get_selection,
+	.get_fmt		= ov772x_get_fmt,
+	.set_fmt		= ov772x_set_fmt,
 };
 
 static const struct v4l2_subdev_ops ov772x_subdev_ops = {
@@ -1131,6 +1435,7 @@ static int ov772x_probe(struct i2c_client *client,
 
 	priv->cfmt = &ov772x_cfmts[0];
 	priv->win = &ov772x_win_sizes[0];
+	priv->fps = 15;
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret)
-- 
2.7.4
