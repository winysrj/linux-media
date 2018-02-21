Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57792 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754991AbeBURsv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 12:48:51 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, hverkuil@xs4all.nl, mchehab@kernel.org,
        festevam@gmail.com, sakari.ailus@iki.fi, robh+dt@kernel.org,
        mark.rutland@arm.com, pombredanne@nexb.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v10 07/10] media: i2c: ov772x: Support frame interval handling
Date: Wed, 21 Feb 2018 18:48:01 +0100
Message-Id: <1519235284-32286-8-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1519235284-32286-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1519235284-32286-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support to ov772x driver for frame intervals handling and enumeration.
Tested with 10MHz and 24MHz input clock at VGA and QVGA resolutions for
10, 15 and 30 frame per second rates.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ov772x.c | 213 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 196 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 23106d7..3edf0cb 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -250,6 +250,7 @@
 #define AEC_1p2         0x10	/*  01: 1/2  window */
 #define AEC_1p4         0x20	/*  10: 1/4  window */
 #define AEC_2p3         0x30	/*  11: Low 2/3 window */
+#define COM4_RESERVED   0x01	/* Reserved bit */

 /* COM5 */
 #define AFR_ON_OFF      0x80	/* Auto frame rate control ON/OFF selection */
@@ -267,6 +268,10 @@
 				/* AEC max step control */
 #define AEC_NO_LIMIT    0x01	/*   0 : AEC incease step has limit */
 				/*   1 : No limit to AEC increase step */
+/* CLKRC */
+				/* Input clock divider register */
+#define CLKRC_RESERVED  0x80	/* Reserved bit */
+#define CLKRC_DIV(n)    ((n) - 1)

 /* COM7 */
 				/* SCCB Register Reset */
@@ -373,6 +378,19 @@
 #define VERSION(pid, ver) ((pid<<8)|(ver&0xFF))

 /*
+ * PLL multipliers
+ */
+static struct {
+	unsigned int mult;
+	u8 com4;
+} ov772x_pll[] = {
+	{ 1, PLL_BYPASS, },
+	{ 4, PLL_4x, },
+	{ 6, PLL_6x, },
+	{ 8, PLL_8x, },
+};
+
+/*
  * struct
  */

@@ -388,6 +406,7 @@ struct ov772x_color_format {
 struct ov772x_win_size {
 	char                     *name;
 	unsigned char             com7_bit;
+	unsigned int		  sizeimage;
 	struct v4l2_rect	  rect;
 };

@@ -404,6 +423,7 @@ struct ov772x_priv {
 	unsigned short                    flag_hflip:1;
 	/* band_filter = COM8[5] ? 256 - BDBASE : 0 */
 	unsigned short                    band_filter;
+	unsigned int			  fps;
 };

 /*
@@ -487,27 +507,34 @@ static const struct ov772x_color_format ov772x_cfmts[] = {

 static const struct ov772x_win_size ov772x_win_sizes[] = {
 	{
-		.name     = "VGA",
-		.com7_bit = SLCT_VGA,
+		.name		= "VGA",
+		.com7_bit	= SLCT_VGA,
+		.sizeimage	= 510 * 748,
 		.rect = {
-			.left = 140,
-			.top = 14,
-			.width = VGA_WIDTH,
-			.height = VGA_HEIGHT,
+			.left	= 140,
+			.top	= 14,
+			.width	= VGA_WIDTH,
+			.height	= VGA_HEIGHT,
 		},
 	}, {
-		.name     = "QVGA",
-		.com7_bit = SLCT_QVGA,
+		.name		= "QVGA",
+		.com7_bit	= SLCT_QVGA,
+		.sizeimage	= 278 * 576,
 		.rect = {
-			.left = 252,
-			.top = 6,
-			.width = QVGA_WIDTH,
-			.height = QVGA_HEIGHT,
+			.left	= 252,
+			.top	= 6,
+			.width	= QVGA_WIDTH,
+			.height	= QVGA_HEIGHT,
 		},
 	},
 };

 /*
+ * frame rate settings lists
+ */
+static unsigned int ov772x_frame_intervals[] = { 5, 10, 15, 20, 30, 60 };
+
+/*
  * general function
  */

@@ -574,6 +601,128 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }

+static int ov772x_set_frame_rate(struct ov772x_priv *priv,
+				 struct v4l2_fract *tpf,
+				 const struct ov772x_color_format *cfmt,
+				 const struct ov772x_win_size *win)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	unsigned long fin = clk_get_rate(priv->clk);
+	unsigned int fps = tpf->numerator ?
+			   tpf->denominator / tpf->numerator :
+			   tpf->denominator;
+	unsigned int best_diff;
+	unsigned int fsize;
+	unsigned int pclk;
+	unsigned int diff;
+	unsigned int idx;
+	unsigned int i;
+	u8 clkrc = 0;
+	u8 com4 = 0;
+	int ret;
+
+	/* Approximate to the closest supported frame interval. */
+	best_diff = ~0L;
+	for (i = 0, idx = 0; i < ARRAY_SIZE(ov772x_frame_intervals); i++) {
+		diff = abs(fps - ov772x_frame_intervals[i]);
+		if (diff < best_diff) {
+			idx = i;
+			best_diff = diff;
+		}
+	}
+	fps = ov772x_frame_intervals[idx];
+
+	/* Use image size (with blankings) to calculate desired pixel clock. */
+	switch (cfmt->com7 & OFMT_MASK) {
+	case OFMT_BRAW:
+		fsize = win->sizeimage;
+		break;
+	case OFMT_RGB:
+	case OFMT_YUV:
+	default:
+		fsize = win->sizeimage * 2;
+		break;
+	}
+
+	pclk = fps * fsize;
+
+	/*
+	 * Pixel clock generation circuit is pretty simple:
+	 *
+	 * Fin -> [ / CLKRC_div] -> [ * PLL_mult] -> pclk
+	 *
+	 * Try to approximate the desired pixel clock testing all available
+	 * PLL multipliers (1x, 4x, 6x, 8x) and calculate corresponding
+	 * divisor with:
+	 *
+	 * div = PLL_mult * Fin / pclk
+	 *
+	 * and re-calculate the pixel clock using it:
+	 *
+	 * pclk = Fin * PLL_mult / CLKRC_div
+	 *
+	 * Choose the PLL_mult and CLKRC_div pair that gives a pixel clock
+	 * closer to the desired one.
+	 *
+	 * The desired pixel clock is calculated using a known frame size
+	 * (blanking included) and FPS.
+	 */
+	best_diff = ~0L;
+	for (i = 0; i < ARRAY_SIZE(ov772x_pll); i++) {
+		unsigned int pll_mult = ov772x_pll[i].mult;
+		unsigned int pll_out = pll_mult * fin;
+		unsigned int t_pclk;
+		unsigned int div;
+
+		if (pll_out < pclk)
+			continue;
+
+		div = DIV_ROUND_CLOSEST(pll_out, pclk);
+		t_pclk = DIV_ROUND_CLOSEST(fin * pll_mult, div);
+		diff = abs(pclk - t_pclk);
+		if (diff < best_diff) {
+			best_diff = diff;
+			clkrc = CLKRC_DIV(div);
+			com4 = ov772x_pll[i].com4;
+		}
+	}
+
+	ret = ov772x_write(client, COM4, com4 | COM4_RESERVED);
+	if (ret < 0)
+		return ret;
+
+	ret = ov772x_write(client, CLKRC, clkrc | CLKRC_RESERVED);
+	if (ret < 0)
+		return ret;
+
+	tpf->numerator = 1;
+	tpf->denominator = fps;
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
+	return ov772x_set_frame_rate(priv, tpf, priv->cfmt, priv->win);
+}
+
 static int ov772x_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct ov772x_priv *priv = container_of(ctrl->handler,
@@ -757,6 +906,7 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 			     const struct ov772x_win_size *win)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
+	struct v4l2_fract tpf;
 	int ret;
 	u8  val;

@@ -885,6 +1035,13 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 	if (ret < 0)
 		goto ov772x_set_fmt_error;

+	/* COM4, CLKRC: Set pixel clock and framerate. */
+	tpf.numerator = 1;
+	tpf.denominator = priv->fps;
+	ret = ov772x_set_frame_rate(priv, &tpf, cfmt, win);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+
 	/*
 	 * set COM8
 	 */
@@ -1043,6 +1200,24 @@ static const struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 	.s_power	= ov772x_s_power,
 };

+static int ov772x_enum_frame_interval(struct v4l2_subdev *sd,
+				      struct v4l2_subdev_pad_config *cfg,
+				      struct v4l2_subdev_frame_interval_enum *fie)
+{
+	if (fie->pad || fie->index >= ARRAY_SIZE(ov772x_frame_intervals))
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
@@ -1055,14 +1230,17 @@ static int ov772x_enum_mbus_code(struct v4l2_subdev *sd,
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
@@ -1134,6 +1312,7 @@ static int ov772x_probe(struct i2c_client *client,

 	priv->cfmt = &ov772x_cfmts[0];
 	priv->win = &ov772x_win_sizes[0];
+	priv->fps = 15;

 	ret = v4l2_async_register_subdev(&priv->subdev);
 	if (ret)
--
2.7.4
