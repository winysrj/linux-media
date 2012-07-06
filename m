Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab2GFOe7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jul 2012 10:34:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 09/10] ov772x: Compute window size registers at runtime
Date: Fri,  6 Jul 2012 16:35:00 +0200
Message-Id: <1341585301-1003-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341585301-1003-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of hardcoding register arrays, compute the values at runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/ov772x.c |  149 ++++++++++++++++-------------------------
 1 files changed, 58 insertions(+), 91 deletions(-)

diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 07ff709..98b1bdf 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -317,8 +317,15 @@
 #define SGLF_ON_OFF     0x02	/* Single frame ON/OFF selection */
 #define SGLF_TRIG       0x01	/* Single frame transfer trigger */
 
+/* HREF */
+#define HREF_VSTART_SHIFT	6	/* VSTART LSB */
+#define HREF_HSTART_SHIFT	4	/* HSTART 2 LSBs */
+#define HREF_VSIZE_SHIFT	2	/* VSIZE LSB */
+#define HREF_HSIZE_SHIFT	0	/* HSIZE 2 LSBs */
+
 /* EXHCH */
-#define VSIZE_LSB       0x04	/* Vertical data output size LSB */
+#define EXHCH_VSIZE_SHIFT	2	/* VOUTSIZE LSB */
+#define EXHCH_HSIZE_SHIFT	0	/* HOUTSIZE 2 LSBs */
 
 /* DSP_CTRL1 */
 #define FIFO_ON         0x80	/* FIFO enable/disable selection */
@@ -344,30 +351,6 @@
 #define DSP_OFMT_RAW8	0x02
 #define DSP_OFMT_RAW10	0x03
 
-/* HSTART */
-#define HST_VGA         0x23
-#define HST_QVGA        0x3F
-
-/* HSIZE */
-#define HSZ_VGA         0xA0
-#define HSZ_QVGA        0x50
-
-/* VSTART */
-#define VST_VGA         0x07
-#define VST_QVGA        0x03
-
-/* VSIZE */
-#define VSZ_VGA         0xF0
-#define VSZ_QVGA        0x78
-
-/* HOUTSIZE */
-#define HOSZ_VGA        0xA0
-#define HOSZ_QVGA       0x50
-
-/* VOUTSIZE */
-#define VOSZ_VGA        0xF0
-#define VOSZ_QVGA       0x78
-
 /* DSPAUTO (DSP Auto Function ON/OFF Control) */
 #define AWB_ACTRL       0x80 /* AWB auto threshold control */
 #define DENOISE_ACTRL   0x40 /* De-noise auto threshold control */
@@ -386,10 +369,6 @@
 /*
  * struct
  */
-struct regval_list {
-	unsigned char reg_num;
-	unsigned char value;
-};
 
 struct ov772x_color_format {
 	enum v4l2_mbus_pixelcode code;
@@ -402,10 +381,8 @@ struct ov772x_color_format {
 
 struct ov772x_win_size {
 	char                     *name;
-	__u32                     width;
-	__u32                     height;
 	unsigned char             com7_bit;
-	const struct regval_list *regs;
+	struct v4l2_rect	  rect;
 };
 
 struct ov772x_priv {
@@ -421,31 +398,6 @@ struct ov772x_priv {
 	unsigned short                    band_filter;
 };
 
-#define ENDMARKER { 0xff, 0xff }
-
-/*
- * register setting for window size
- */
-static const struct regval_list ov772x_qvga_regs[] = {
-	{ HSTART,   HST_QVGA },
-	{ HSIZE,    HSZ_QVGA },
-	{ VSTART,   VST_QVGA },
-	{ VSIZE,    VSZ_QVGA  },
-	{ HOUTSIZE, HOSZ_QVGA },
-	{ VOUTSIZE, VOSZ_QVGA },
-	ENDMARKER,
-};
-
-static const struct regval_list ov772x_vga_regs[] = {
-	{ HSTART,   HST_VGA },
-	{ HSIZE,    HSZ_VGA },
-	{ VSTART,   VST_VGA },
-	{ VSIZE,    VSZ_VGA },
-	{ HOUTSIZE, HOSZ_VGA },
-	{ VOUTSIZE, VOSZ_VGA },
-	ENDMARKER,
-};
-
 /*
  * general function
  */
@@ -465,18 +417,6 @@ static inline int ov772x_write(struct i2c_client *client, u8 addr, u8 value)
 	return i2c_smbus_write_byte_data(client, addr, value);
 }
 
-static int ov772x_write_array(struct i2c_client        *client,
-			      const struct regval_list *vals)
-{
-	while (vals->reg_num != 0xff) {
-		int ret = ov772x_write(client, vals->reg_num, vals->value);
-		if (ret < 0)
-			return ret;
-		vals++;
-	}
-	return 0;
-}
-
 static int ov772x_mask_set(struct i2c_client *client, u8  command, u8  mask,
 			   u8  set)
 {
@@ -574,24 +514,26 @@ static const struct ov772x_color_format ov772x_cfmts[] = {
 
 #define VGA_WIDTH   640
 #define VGA_HEIGHT  480
-#define QVGA_WIDTH  320
-#define QVGA_HEIGHT 240
-#define MAX_WIDTH   VGA_WIDTH
-#define MAX_HEIGHT  VGA_HEIGHT
 
 static const struct ov772x_win_size ov772x_win_sizes[] = {
 	{
 		.name     = "VGA",
-		.width    = VGA_WIDTH,
-		.height   = VGA_HEIGHT,
 		.com7_bit = SLCT_VGA,
-		.regs     = ov772x_vga_regs,
+		.rect = {
+			.left = 140,
+			.top = 14,
+			.width = 640,
+			.height = 480,
+		},
 	}, {
 		.name     = "QVGA",
-		.width    = QVGA_WIDTH,
-		.height   = QVGA_HEIGHT,
 		.com7_bit = SLCT_QVGA,
-		.regs     = ov772x_qvga_regs,
+		.rect = {
+			.left = 252,
+			.top = 6,
+			.width = 320,
+			.height = 240,
+		},
 	},
 };
 
@@ -602,8 +544,8 @@ static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 	u32 best_diff = (u32)-1;
 
 	for (i = 0; i < ARRAY_SIZE(ov772x_win_sizes); ++i) {
-		u32 diff = abs(width - ov772x_win_sizes[i].width)
-			 + abs(height - ov772x_win_sizes[i].height);
+		u32 diff = abs(width - ov772x_win_sizes[i].rect.width)
+			 + abs(height - ov772x_win_sizes[i].rect.height);
 		if (diff < best_diff) {
 			best_diff = diff;
 			win = &ov772x_win_sizes[i];
@@ -693,10 +635,35 @@ static int ov772x_set_params(struct ov772x_priv *priv,
 			goto ov772x_set_fmt_error;
 	}
 
-	/*
-	 * set size format
-	 */
-	ret = ov772x_write_array(client, win->regs);
+	/* Format and window size */
+	ret = ov772x_write(client, HSTART, win->rect.left >> 2);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+	ret = ov772x_write(client, HSIZE, win->rect.width >> 2);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+	ret = ov772x_write(client, VSTART, win->rect.top >> 1);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+	ret = ov772x_write(client, VSIZE, win->rect.height >> 1);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+	ret = ov772x_write(client, HOUTSIZE, win->rect.width >> 2);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+	ret = ov772x_write(client, VOUTSIZE, win->rect.height >> 1);
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+	ret = ov772x_write(client, HREF,
+			   ((win->rect.top & 1) << HREF_VSTART_SHIFT) |
+			   ((win->rect.left & 3) << HREF_HSTART_SHIFT) |
+			   ((win->rect.height & 1) << HREF_VSIZE_SHIFT) |
+			   ((win->rect.width & 3) << HREF_HSIZE_SHIFT));
+	if (ret < 0)
+		goto ov772x_set_fmt_error;
+	ret = ov772x_write(client, EXHCH,
+			   ((win->rect.height & 1) << EXHCH_VSIZE_SHIFT) |
+			   ((win->rect.width & 3) << EXHCH_HSIZE_SHIFT));
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
 
@@ -899,8 +866,8 @@ static int ov772x_g_fmt(struct v4l2_subdev *sd,
 {
 	struct ov772x_priv *priv = to_ov772x(sd);
 
-	mf->width	= priv->win->width;
-	mf->height	= priv->win->height;
+	mf->width	= priv->win->rect.width;
+	mf->height	= priv->win->rect.height;
 	mf->code	= priv->cfmt->code;
 	mf->colorspace	= priv->cfmt->colorspace;
 	mf->field	= V4L2_FIELD_NONE;
@@ -925,8 +892,8 @@ static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
 	priv->cfmt = cfmt;
 
 	mf->code = cfmt->code;
-	mf->width = win->width;
-	mf->height = win->height;
+	mf->width = win->rect.width;
+	mf->height = win->rect.height;
 	mf->field = V4L2_FIELD_NONE;
 	mf->colorspace = cfmt->colorspace;
 
@@ -942,8 +909,8 @@ static int ov772x_try_fmt(struct v4l2_subdev *sd,
 	ov772x_select_params(mf, &cfmt, &win);
 
 	mf->code = cfmt->code;
-	mf->width = win->width;
-	mf->height = win->height;
+	mf->width = win->rect.width;
+	mf->height = win->rect.height;
 	mf->field = V4L2_FIELD_NONE;
 	mf->colorspace = cfmt->colorspace;
 
-- 
1.7.8.6

