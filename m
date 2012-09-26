Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53226 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab2IZJsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Sep 2012 05:48:15 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so357301wgb.1
        for <linux-media@vger.kernel.org>; Wed, 26 Sep 2012 02:48:14 -0700 (PDT)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: corbet@lwn.net, mchehab@infradead.org, hverkuil@xs4all.nl,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/5] media: ov7670: add support for ov7675.
Date: Wed, 26 Sep 2012 11:47:53 +0200
Message-Id: <1348652877-25816-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
References: <1348652877-25816-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ov7675 and ov7670 share the same registers but there is no way
to distinguish them at runtime. However, they require different
tweaks to achieve the desired resolution. For this reason this
patch adds a new ov7675 entry to the ov7670_id table.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/i2c/ov7670.c |  164 ++++++++++++++++++++++++++++++--------------
 1 file changed, 111 insertions(+), 53 deletions(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index e7c82b2..0478a7b 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -183,6 +183,10 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define REG_HAECC7	0xaa	/* Hist AEC/AGC control 7 */
 #define REG_BD60MAX	0xab	/* 60hz banding step limit */
 
+enum ov7670_model {
+	MODEL_OV7670 = 0,
+	MODEL_OV7675,
+};
 
 /*
  * Information we maintain about a known sensor.
@@ -198,6 +202,7 @@ struct ov7670_info {
 	int clock_speed;		/* External clock speed (MHz) */
 	u8 clkrc;			/* Clock divider value */
 	bool use_smbus;			/* Use smbus I/O instead of I2C */
+	enum ov7670_model model;
 };
 
 static inline struct ov7670_info *to_state(struct v4l2_subdev *sd)
@@ -652,7 +657,7 @@ static struct regval_list ov7670_qcif_regs[] = {
 	{ 0xff, 0xff },
 };
 
-static struct ov7670_win_size {
+struct ov7670_win_size {
 	int	width;
 	int	height;
 	unsigned char com7_bit;
@@ -661,57 +666,105 @@ static struct ov7670_win_size {
 	int	vstart;		/* sense to humans, but evidently the sensor */
 	int	vstop;		/* will do the right thing... */
 	struct regval_list *regs; /* Regs to tweak */
-/* h/vref stuff */
-} ov7670_win_sizes[] = {
-	/* VGA */
-	{
-		.width		= VGA_WIDTH,
-		.height		= VGA_HEIGHT,
-		.com7_bit	= COM7_FMT_VGA,
-		.hstart		= 158,		/* These values from */
-		.hstop		=  14,		/* Omnivision */
-		.vstart		=  10,
-		.vstop		= 490,
-		.regs 		= NULL,
-	},
-	/* CIF */
-	{
-		.width		= CIF_WIDTH,
-		.height		= CIF_HEIGHT,
-		.com7_bit	= COM7_FMT_CIF,
-		.hstart		= 170,		/* Empirically determined */
-		.hstop		=  90,
-		.vstart		=  14,
-		.vstop		= 494,
-		.regs 		= NULL,
-	},
-	/* QVGA */
+};
+
+static struct ov7670_win_size ov7670_win_sizes[2][4] = {
+	/* ov7670 */
 	{
-		.width		= QVGA_WIDTH,
-		.height		= QVGA_HEIGHT,
-		.com7_bit	= COM7_FMT_QVGA,
-		.hstart		= 168,		/* Empirically determined */
-		.hstop		=  24,
-		.vstart		=  12,
-		.vstop		= 492,
-		.regs 		= NULL,
+		/* VGA */
+		{
+			.width		= VGA_WIDTH,
+			.height		= VGA_HEIGHT,
+			.com7_bit	= COM7_FMT_VGA,
+			.hstart		= 158,	/* These values from */
+			.hstop		=  14,	/* Omnivision */
+			.vstart		=  10,
+			.vstop		= 490,
+			.regs		= NULL,
+		},
+		/* CIF */
+		{
+			.width		= CIF_WIDTH,
+			.height		= CIF_HEIGHT,
+			.com7_bit	= COM7_FMT_CIF,
+			.hstart		= 170,	/* Empirically determined */
+			.hstop		=  90,
+			.vstart		=  14,
+			.vstop		= 494,
+			.regs		= NULL,
+		},
+		/* QVGA */
+		{
+			.width		= QVGA_WIDTH,
+			.height		= QVGA_HEIGHT,
+			.com7_bit	= COM7_FMT_QVGA,
+			.hstart		= 168,	/* Empirically determined */
+			.hstop		=  24,
+			.vstart		=  12,
+			.vstop		= 492,
+			.regs		= NULL,
+		},
+		/* QCIF */
+		{
+			.width		= QCIF_WIDTH,
+			.height		= QCIF_HEIGHT,
+			.com7_bit	= COM7_FMT_VGA, /* see comment above */
+			.hstart		= 456,	/* Empirically determined */
+			.hstop		=  24,
+			.vstart		=  14,
+			.vstop		= 494,
+			.regs 		= ov7670_qcif_regs,
+		}
 	},
-	/* QCIF */
+	/* ov7675 */
 	{
-		.width		= QCIF_WIDTH,
-		.height		= QCIF_HEIGHT,
-		.com7_bit	= COM7_FMT_VGA, /* see comment above */
-		.hstart		= 456,		/* Empirically determined */
-		.hstop		=  24,
-		.vstart		=  14,
-		.vstop		= 494,
-		.regs 		= ov7670_qcif_regs,
-	},
+		/* VGA */
+		{
+			.width		= VGA_WIDTH,
+			.height		= VGA_HEIGHT,
+			.com7_bit	= COM7_FMT_VGA,
+			.hstart		= 158,	/* These values from */
+			.hstop		=  14,	/* Omnivision */
+			.vstart		=  14,
+			.vstop		= 494,
+			.regs		= NULL,
+		},
+		/* CIF - WARNING: not tested for ov7675 */
+		{
+			.width		= CIF_WIDTH,
+			.height		= CIF_HEIGHT,
+			.com7_bit	= COM7_FMT_CIF,
+			.hstart		= 170,	/* Empirically determined */
+			.hstop		=  90,
+			.vstart		=  14,
+			.vstop		= 494,
+			.regs		= NULL,
+		},
+		/* QVGA - WARNING: not tested for ov7675 */
+		{
+			.width		= QVGA_WIDTH,
+			.height		= QVGA_HEIGHT,
+			.com7_bit	= COM7_FMT_QVGA,
+			.hstart		= 168,	/* Empirically determined */
+			.hstop		=  24,
+			.vstart		=  12,
+			.vstop		= 492,
+			.regs		= NULL,
+		},
+		/* QCIF - WARNING: not tested for ov7675 */
+		{
+			.width		= QCIF_WIDTH,
+			.height		= QCIF_HEIGHT,
+			.com7_bit	= COM7_FMT_VGA, /* see comment above */
+			.hstart		= 456,	/* Empirically determined */
+			.hstop		=  24,
+			.vstart		=  14,
+			.vstop		= 494,
+			.regs		= ov7670_qcif_regs,
+		}
+	}
 };
 
-#define N_WIN_SIZES (ARRAY_SIZE(ov7670_win_sizes))
-
-
 /*
  * Store a set of start/stop values into the camera.
  */
@@ -761,6 +814,8 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
 {
 	int index;
 	struct ov7670_win_size *wsize;
+	struct ov7670_info *info = to_state(sd);
+	int n_win_sizes = ARRAY_SIZE(ov7670_win_sizes[info->model]);
 
 	for (index = 0; index < N_OV7670_FMTS; index++)
 		if (ov7670_formats[index].mbus_code == fmt->code)
@@ -780,11 +835,11 @@ static int ov7670_try_fmt_internal(struct v4l2_subdev *sd,
 	 * Round requested image size down to the nearest
 	 * we support, but not below the smallest.
 	 */
-	for (wsize = ov7670_win_sizes; wsize < ov7670_win_sizes + N_WIN_SIZES;
-	     wsize++)
+	for (wsize = ov7670_win_sizes[info->model];
+	     wsize < ov7670_win_sizes[info->model] + n_win_sizes; wsize++)
 		if (fmt->width >= wsize->width && fmt->height >= wsize->height)
 			break;
-	if (wsize >= ov7670_win_sizes + N_WIN_SIZES)
+	if (wsize >= ov7670_win_sizes[info->model] + n_win_sizes)
 		wsize--;   /* Take the smallest one */
 	if (ret_wsize != NULL)
 		*ret_wsize = wsize;
@@ -931,13 +986,14 @@ static int ov7670_enum_framesizes(struct v4l2_subdev *sd,
 	int i;
 	int num_valid = -1;
 	__u32 index = fsize->index;
+	int n_win_sizes = ARRAY_SIZE(ov7670_win_sizes[info->model]);
 
 	/*
 	 * If a minimum width/height was requested, filter out the capture
 	 * windows that fall outside that.
 	 */
-	for (i = 0; i < N_WIN_SIZES; i++) {
-		struct ov7670_win_size *win = &ov7670_win_sizes[index];
+	for (i = 0; i < n_win_sizes; i++) {
+		struct ov7670_win_size *win = &ov7670_win_sizes[info->model][index];
 		if (info->min_width && win->width < info->min_width)
 			continue;
 		if (info->min_height && win->height < info->min_height)
@@ -1551,6 +1607,7 @@ static int ov7670_probe(struct i2c_client *client,
 	v4l_info(client, "chip found @ 0x%02x (%s)\n",
 			client->addr << 1, client->adapter->name);
 
+	info->model = id->driver_data;
 	info->fmt = &ov7670_formats[0];
 	info->sat = 128;	/* Review this */
 	info->clkrc = info->clock_speed / 30;
@@ -1568,7 +1625,8 @@ static int ov7670_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id ov7670_id[] = {
-	{ "ov7670", 0 },
+	{ "ov7670", MODEL_OV7670 },
+	{ "ov7675", MODEL_OV7675 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, ov7670_id);
-- 
1.7.9.5

