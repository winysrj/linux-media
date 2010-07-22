Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:38167 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752067Ab0GVTw5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jul 2010 15:52:57 -0400
Date: Thu, 22 Jul 2010 21:52:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH] mediabus: fix ambiguous pixel code names
Message-ID: <Pine.LNX.4.64.1007222139140.3918@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Endianness notation is meaningless for 8 bit YUYV codes. Switch pixel code 
names to explicitly state the order of colour components in the data 
stream.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/arch/sh/boards/mach-ap325rxa/setup.c b/arch/sh/boards/mach-ap325rxa/setup.c
index 3a170bd..de375b6 100644
--- a/arch/sh/boards/mach-ap325rxa/setup.c
+++ b/arch/sh/boards/mach-ap325rxa/setup.c
@@ -316,7 +316,7 @@ static struct soc_camera_platform_info camera_info = {
 	.format_name = "UYVY",
 	.format_depth = 16,
 	.format = {
-		.code = V4L2_MBUS_FMT_YUYV8_2X8_BE,
+		.code = V4L2_MBUS_FMT_UYVY8_2X8,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 		.field = V4L2_FIELD_NONE,
 		.width = 640,
diff --git a/drivers/media/video/ak881x.c b/drivers/media/video/ak881x.c
index 1573392..b388654 100644
--- a/drivers/media/video/ak881x.c
+++ b/drivers/media/video/ak881x.c
@@ -126,7 +126,7 @@ static int ak881x_try_g_mbus_fmt(struct v4l2_subdev *sd,
 	v4l_bound_align_image(&mf->width, 0, 720, 2,
 			      &mf->height, 0, ak881x->lines, 1, 0);
 	mf->field	= V4L2_FIELD_INTERLACED;
-	mf->code	= V4L2_MBUS_FMT_YUYV8_2X8_LE;
+	mf->code	= V4L2_MBUS_FMT_YUYV8_2X8;
 	mf->colorspace	= V4L2_COLORSPACE_SMPTE170M;
 
 	return 0;
@@ -136,7 +136,7 @@ static int ak881x_s_mbus_fmt(struct v4l2_subdev *sd,
 			     struct v4l2_mbus_framefmt *mf)
 {
 	if (mf->field != V4L2_FIELD_INTERLACED ||
-	    mf->code != V4L2_MBUS_FMT_YUYV8_2X8_LE)
+	    mf->code != V4L2_MBUS_FMT_YUYV8_2X8)
 		return -EINVAL;
 
 	return ak881x_try_g_mbus_fmt(sd, mf);
@@ -148,7 +148,7 @@ static int ak881x_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned int index,
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8_LE;
+	*code = V4L2_MBUS_FMT_YUYV8_2X8;
 	return 0;
 }
 
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index fbd0fc7..31cc3d0 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -143,10 +143,10 @@ static const struct mt9m111_datafmt *mt9m111_find_datafmt(
 }
 
 static const struct mt9m111_datafmt mt9m111_colour_fmts[] = {
-	{V4L2_MBUS_FMT_YUYV8_2X8_LE, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_YVYU8_2X8_LE, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_YUYV8_2X8_BE, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_YVYU8_2X8_BE, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_UYVY8_2X8, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_VYUY8_2X8, V4L2_COLORSPACE_JPEG},
 	{V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
 	{V4L2_MBUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
 	{V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_COLORSPACE_SRGB},
@@ -505,22 +505,22 @@ static int mt9m111_set_pixfmt(struct i2c_client *client,
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
 		ret = mt9m111_setfmt_rgb565(client);
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 0;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8_BE:
+	case V4L2_MBUS_FMT_VYUY8_2X8:
 		mt9m111->swap_yuv_y_chromas = 0;
 		mt9m111->swap_yuv_cb_cr = 1;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
 		mt9m111->swap_yuv_y_chromas = 1;
 		mt9m111->swap_yuv_cb_cr = 0;
 		ret = mt9m111_setfmt_yuv(client);
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
 		mt9m111->swap_yuv_y_chromas = 1;
 		mt9m111->swap_yuv_cb_cr = 1;
 		ret = mt9m111_setfmt_yuv(client);
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index e4bf1db..8ec47e4 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -121,22 +121,22 @@ struct mt9t112_priv {
 
 static const struct mt9t112_format mt9t112_cfmts[] = {
 	{
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8_BE,
+		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 0,
 	}, {
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8_BE,
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 1,
 	}, {
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8_LE,
+		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 2,
 	}, {
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8_LE,
+		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.fmt		= 1,
 		.order		= 3,
@@ -972,7 +972,7 @@ static int mt9t112_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
 	struct v4l2_rect *rect = &a->c;
 
 	return mt9t112_set_params(client, rect->width, rect->height,
-				 V4L2_MBUS_FMT_YUYV8_2X8_BE);
+				 V4L2_MBUS_FMT_UYVY8_2X8);
 }
 
 static int mt9t112_g_fmt(struct v4l2_subdev *sd,
@@ -983,7 +983,7 @@ static int mt9t112_g_fmt(struct v4l2_subdev *sd,
 
 	if (!priv->format) {
 		int ret = mt9t112_set_params(client, VGA_WIDTH, VGA_HEIGHT,
-					     V4L2_MBUS_FMT_YUYV8_2X8_BE);
+					     V4L2_MBUS_FMT_UYVY8_2X8);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 34034a7..25eb5d6 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -440,21 +440,21 @@ static const struct regval_list ov772x_vga_regs[] = {
  */
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8_LE,
+		.code		= V4L2_MBUS_FMT_YUYV8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= 0x0,
 		.com3		= SWAP_YUV,
 		.com7		= OFMT_YUV,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_YVYU8_2X8_LE,
+		.code		= V4L2_MBUS_FMT_YVYU8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= UV_ON,
 		.com3		= SWAP_YUV,
 		.com7		= OFMT_YUV,
 	},
 	{
-		.code		= V4L2_MBUS_FMT_YUYV8_2X8_BE,
+		.code		= V4L2_MBUS_FMT_UYVY8_2X8,
 		.colorspace	= V4L2_COLORSPACE_JPEG,
 		.dsp3		= 0x0,
 		.com3		= 0x0,
@@ -960,7 +960,7 @@ static int ov772x_g_fmt(struct v4l2_subdev *sd,
 	if (!priv->win || !priv->cfmt) {
 		u32 width = VGA_WIDTH, height = VGA_HEIGHT;
 		int ret = ov772x_set_params(client, &width, &height,
-					    V4L2_MBUS_FMT_YUYV8_2X8_LE);
+					    V4L2_MBUS_FMT_YUYV8_2X8);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index 7ce9e05..40cdfab 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -155,7 +155,7 @@ static const struct ov9640_reg ov9640_regs_rgb[] = {
 };
 
 static enum v4l2_mbus_pixelcode ov9640_codes[] = {
-	V4L2_MBUS_FMT_YUYV8_2X8_BE,
+	V4L2_MBUS_FMT_UYVY8_2X8,
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
 	V4L2_MBUS_FMT_RGB565_2X8_LE,
 };
@@ -430,7 +430,7 @@ static void ov9640_alter_regs(enum v4l2_mbus_pixelcode code,
 {
 	switch (code) {
 	default:
-	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
 		alt->com12	= OV9640_COM12_YUV_AVG;
 		alt->com13	= OV9640_COM13_Y_DELAY_EN |
 					OV9640_COM13_YUV_DLY(0x01);
@@ -493,7 +493,7 @@ static int ov9640_write_regs(struct i2c_client *client, u32 width,
 	}
 
 	/* select color matrix configuration for given color encoding */
-	if (code == V4L2_MBUS_FMT_YUYV8_2X8_BE) {
+	if (code == V4L2_MBUS_FMT_UYVY8_2X8) {
 		matrix_regs	= ov9640_regs_yuv;
 		matrix_regs_len	= ARRAY_SIZE(ov9640_regs_yuv);
 	} else {
@@ -579,8 +579,8 @@ static int ov9640_s_fmt(struct v4l2_subdev *sd,
 		cspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
-		code = V4L2_MBUS_FMT_YUYV8_2X8_BE;
-	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
+		code = V4L2_MBUS_FMT_UYVY8_2X8;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
 		cspace = V4L2_COLORSPACE_JPEG;
 	}
 
@@ -606,8 +606,8 @@ static int ov9640_try_fmt(struct v4l2_subdev *sd,
 		mf->colorspace = V4L2_COLORSPACE_SRGB;
 		break;
 	default:
-		mf->code = V4L2_MBUS_FMT_YUYV8_2X8_BE;
-	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
+		mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
+	case V4L2_MBUS_FMT_UYVY8_2X8:
 		mf->colorspace = V4L2_COLORSPACE_JPEG;
 	}
 
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 5835acf..9de7d59 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1284,7 +1284,7 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 	}
 
 	switch (code) {
-	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
 		formats++;
 		if (xlate) {
 			xlate->host_fmt	= &pxa_camera_formats[0];
@@ -1293,9 +1293,9 @@ static int pxa_camera_get_formats(struct soc_camera_device *icd, unsigned int id
 			dev_dbg(dev, "Providing format %s using code %d\n",
 				pxa_camera_formats[0].name, code);
 		}
-	case V4L2_MBUS_FMT_YVYU8_2X8_BE:
-	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
-	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
+	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
 	case V4L2_MBUS_FMT_RGB565_2X8_LE:
 	case V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE:
 		if (xlate)
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 47fd207..d319aef 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -127,8 +127,8 @@ static const struct rj54n1_datafmt *rj54n1_find_datafmt(
 }
 
 static const struct rj54n1_datafmt rj54n1_colour_fmts[] = {
-	{V4L2_MBUS_FMT_YUYV8_2X8_LE, V4L2_COLORSPACE_JPEG},
-	{V4L2_MBUS_FMT_YVYU8_2X8_LE, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_YUYV8_2X8, V4L2_COLORSPACE_JPEG},
+	{V4L2_MBUS_FMT_YVYU8_2X8, V4L2_COLORSPACE_JPEG},
 	{V4L2_MBUS_FMT_RGB565_2X8_LE, V4L2_COLORSPACE_SRGB},
 	{V4L2_MBUS_FMT_RGB565_2X8_BE, V4L2_COLORSPACE_SRGB},
 	{V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE, V4L2_COLORSPACE_SRGB},
@@ -1046,12 +1046,12 @@ static int rj54n1_s_fmt(struct v4l2_subdev *sd,
 
 	/* RA_SEL_UL is only relevant for raw modes, ignored otherwise. */
 	switch (mf->code) {
-	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 8, 8);
 		break;
-	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
 		ret = reg_write(client, RJ54N1_OUT_SEL, 0);
 		if (!ret)
 			ret = reg_set(client, RJ54N1_BYTE_SWAP, 0, 8);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 961bfa2..f4e6a3f 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -743,16 +743,16 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
 		switch (cam->code) {
-		case V4L2_MBUS_FMT_YUYV8_2X8_BE:
+		case V4L2_MBUS_FMT_UYVY8_2X8:
 			value = 0x00000000; /* Cb0, Y0, Cr0, Y1 */
 			break;
-		case V4L2_MBUS_FMT_YVYU8_2X8_BE:
+		case V4L2_MBUS_FMT_VYUY8_2X8:
 			value = 0x00000100; /* Cr0, Y0, Cb0, Y1 */
 			break;
-		case V4L2_MBUS_FMT_YUYV8_2X8_LE:
+		case V4L2_MBUS_FMT_YUYV8_2X8:
 			value = 0x00000200; /* Y0, Cb0, Y1, Cr0 */
 			break;
-		case V4L2_MBUS_FMT_YVYU8_2X8_LE:
+		case V4L2_MBUS_FMT_YVYU8_2X8:
 			value = 0x00000300; /* Y0, Cr0, Y1, Cb0 */
 			break;
 		default:
@@ -965,10 +965,10 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, unsigned int
 		cam->extra_fmt = NULL;
 
 	switch (code) {
-	case V4L2_MBUS_FMT_YUYV8_2X8_BE:
-	case V4L2_MBUS_FMT_YVYU8_2X8_BE:
-	case V4L2_MBUS_FMT_YUYV8_2X8_LE:
-	case V4L2_MBUS_FMT_YVYU8_2X8_LE:
+	case V4L2_MBUS_FMT_UYVY8_2X8:
+	case V4L2_MBUS_FMT_VYUY8_2X8:
+	case V4L2_MBUS_FMT_YUYV8_2X8:
+	case V4L2_MBUS_FMT_YVYU8_2X8:
 		if (cam->extra_fmt)
 			break;
 
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index f5b892a..e9d5e6a 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -677,7 +677,7 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	struct sh_vou_geometry geo;
 	struct v4l2_mbus_framefmt mbfmt = {
 		/* Revisit: is this the correct code? */
-		.code = V4L2_MBUS_FMT_YUYV8_2X8_LE,
+		.code = V4L2_MBUS_FMT_YUYV8_2X8,
 		.field = V4L2_FIELD_INTERLACED,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
@@ -725,7 +725,7 @@ static int sh_vou_s_fmt_vid_out(struct file *file, void *priv,
 	/* Sanity checks */
 	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
 	    (unsigned)mbfmt.height > VOU_MAX_IMAGE_HEIGHT ||
-	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8_LE)
+	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8)
 		return -EIO;
 
 	if (mbfmt.width != geo.output.width ||
@@ -936,7 +936,7 @@ static int sh_vou_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
 	struct sh_vou_geometry geo;
 	struct v4l2_mbus_framefmt mbfmt = {
 		/* Revisit: is this the correct code? */
-		.code = V4L2_MBUS_FMT_YUYV8_2X8_LE,
+		.code = V4L2_MBUS_FMT_YUYV8_2X8,
 		.field = V4L2_FIELD_INTERLACED,
 		.colorspace = V4L2_COLORSPACE_SMPTE170M,
 	};
@@ -981,7 +981,7 @@ static int sh_vou_s_crop(struct file *file, void *fh, struct v4l2_crop *a)
 	/* Sanity checks */
 	if ((unsigned)mbfmt.width > VOU_MAX_IMAGE_WIDTH ||
 	    (unsigned)mbfmt.height > VOU_MAX_IMAGE_HEIGHT ||
-	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8_LE)
+	    mbfmt.code != V4L2_MBUS_FMT_YUYV8_2X8)
 		return -EIO;
 
 	geo.output.width = mbfmt.width;
diff --git a/drivers/media/video/soc_mediabus.c b/drivers/media/video/soc_mediabus.c
index 8b63b65..9139121 100644
--- a/drivers/media/video/soc_mediabus.c
+++ b/drivers/media/video/soc_mediabus.c
@@ -18,28 +18,28 @@
 #define MBUS_IDX(f) (V4L2_MBUS_FMT_ ## f - V4L2_MBUS_FMT_FIXED - 1)
 
 static const struct soc_mbus_pixelfmt mbus_fmt[] = {
-	[MBUS_IDX(YUYV8_2X8_LE)] = {
+	[MBUS_IDX(YUYV8_2X8)] = {
 		.fourcc			= V4L2_PIX_FMT_YUYV,
 		.name			= "YUYV",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(YVYU8_2X8_LE)] = {
+	[MBUS_IDX(YVYU8_2X8)] = {
 		.fourcc			= V4L2_PIX_FMT_YVYU,
 		.name			= "YVYU",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(YUYV8_2X8_BE)] = {
+	[MBUS_IDX(UYVY8_2X8)] = {
 		.fourcc			= V4L2_PIX_FMT_UYVY,
 		.name			= "UYVY",
 		.bits_per_sample	= 8,
 		.packing		= SOC_MBUS_PACKING_2X8_PADHI,
 		.order			= SOC_MBUS_ORDER_LE,
 	},
-	[MBUS_IDX(YVYU8_2X8_BE)] = {
+	[MBUS_IDX(VYUY8_2X8)] = {
 		.fourcc			= V4L2_PIX_FMT_VYUY,
 		.name			= "VYUY",
 		.bits_per_sample	= 8,
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index 445dc93..a727962 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -768,7 +768,7 @@ static int tw9910_g_fmt(struct v4l2_subdev *sd,
 
 	mf->width	= priv->scale->width;
 	mf->height	= priv->scale->height;
-	mf->code	= V4L2_MBUS_FMT_YUYV8_2X8_BE;
+	mf->code	= V4L2_MBUS_FMT_UYVY8_2X8;
 	mf->colorspace	= V4L2_COLORSPACE_JPEG;
 	mf->field	= V4L2_FIELD_INTERLACED_BT;
 
@@ -797,7 +797,7 @@ static int tw9910_s_fmt(struct v4l2_subdev *sd,
 	/*
 	 * check color format
 	 */
-	if (mf->code != V4L2_MBUS_FMT_YUYV8_2X8_BE)
+	if (mf->code != V4L2_MBUS_FMT_UYVY8_2X8)
 		return -EINVAL;
 
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
@@ -824,7 +824,7 @@ static int tw9910_try_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 
-	mf->code = V4L2_MBUS_FMT_YUYV8_2X8_BE;
+	mf->code = V4L2_MBUS_FMT_UYVY8_2X8;
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
 	/*
@@ -909,7 +909,7 @@ static int tw9910_enum_fmt(struct v4l2_subdev *sd, unsigned int index,
 	if (index)
 		return -EINVAL;
 
-	*code = V4L2_MBUS_FMT_YUYV8_2X8_BE;
+	*code = V4L2_MBUS_FMT_UYVY8_2X8;
 	return 0;
 }
 
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 865cda7..a870965 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -24,10 +24,10 @@
  */
 enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_FIXED = 1,
-	V4L2_MBUS_FMT_YUYV8_2X8_LE,
-	V4L2_MBUS_FMT_YVYU8_2X8_LE,
-	V4L2_MBUS_FMT_YUYV8_2X8_BE,
-	V4L2_MBUS_FMT_YVYU8_2X8_BE,
+	V4L2_MBUS_FMT_YUYV8_2X8,
+	V4L2_MBUS_FMT_YVYU8_2X8,
+	V4L2_MBUS_FMT_UYVY8_2X8,
+	V4L2_MBUS_FMT_VYUY8_2X8,
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE,
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE,
 	V4L2_MBUS_FMT_RGB565_2X8_LE,
