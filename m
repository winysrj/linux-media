Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57577 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752270AbZH1IKS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2009 04:10:18 -0400
Date: Fri, 28 Aug 2009 10:10:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans de Goede <j.w.r.degoede@hhs.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC] Pixel format definition on the "image" bus
In-Reply-To: <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
Message-ID: <Pine.LNX.4.64.0908281006350.4462@axis700.grange>
References: <Pine.LNX.4.64.0908261452460.7670@axis700.grange>   
 <200908270851.27073.hverkuil@xs4all.nl>    <Pine.LNX.4.64.0908270857230.4808@axis700.grange>
    <6d6c955a28219f061dd31af4e0473415.squirrel@webmail.xs4all.nl>   
 <Pine.LNX.4.64.0908271017280.4808@axis700.grange>
 <2b7b07f52f0ab6fa4d3f1cacc19bf31f.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi again

below is the current patch porting sh and ov772x to the new imagebus API. 
It seems to work, I'll be porting further drivers too, then test more 
intensively, then we shall decide how to bring all other users of .s_fmt, 
.g_fmt, .try_fmt, .enum_fmt over to this API.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 00fb23e..9b7446a 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -10,7 +10,7 @@ stkwebcam-objs	:=	stk-webcam.o stk-sensor.o
 
 omap2cam-objs	:=	omap24xxcam.o omap24xxcam-dma.o
 
-videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
+videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-imagebus.o
 
 # V4L2 core modules
 
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index eccb40a..3adceaf 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -382,7 +382,7 @@ struct regval_list {
 };
 
 struct ov772x_color_format {
-	const struct soc_camera_data_format *format;
+	const enum v4l2_imgbus_pixelcode code;
 	u8 dsp3;
 	u8 com3;
 	u8 com7;
@@ -434,93 +434,50 @@ static const struct regval_list ov772x_vga_regs[] = {
 };
 
 /*
- * supported format list
- */
-
-#define SETFOURCC(type) .name = (#type), .fourcc = (V4L2_PIX_FMT_ ## type)
-static const struct soc_camera_data_format ov772x_fmt_lists[] = {
-	{
-		SETFOURCC(YUYV),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-	},
-	{
-		SETFOURCC(YVYU),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-	},
-	{
-		SETFOURCC(UYVY),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_JPEG,
-	},
-	{
-		SETFOURCC(RGB555),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-	{
-		SETFOURCC(RGB555X),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-	{
-		SETFOURCC(RGB565),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-	{
-		SETFOURCC(RGB565X),
-		.depth      = 16,
-		.colorspace = V4L2_COLORSPACE_SRGB,
-	},
-};
-
-/*
- * color format list
+ * supported color format list
  */
 static const struct ov772x_color_format ov772x_cfmts[] = {
 	{
-		.format = &ov772x_fmt_lists[0],
-		.dsp3   = 0x0,
-		.com3   = SWAP_YUV,
-		.com7   = OFMT_YUV,
+		.code	= V4L2_IMGBUS_FMT_YUYV,
+		.dsp3	= 0x0,
+		.com3	= SWAP_YUV,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[1],
-		.dsp3   = UV_ON,
-		.com3   = SWAP_YUV,
-		.com7   = OFMT_YUV,
+		.code	= V4L2_IMGBUS_FMT_YVYU,
+		.dsp3	= UV_ON,
+		.com3	= SWAP_YUV,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[2],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = OFMT_YUV,
+		.code	= V4L2_IMGBUS_FMT_UYVY,
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= OFMT_YUV,
 	},
 	{
-		.format = &ov772x_fmt_lists[3],
-		.dsp3   = 0x0,
-		.com3   = SWAP_RGB,
-		.com7   = FMT_RGB555 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB555,
+		.dsp3	= 0x0,
+		.com3	= SWAP_RGB,
+		.com7	= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[4],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = FMT_RGB555 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB555X,
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= FMT_RGB555 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[5],
-		.dsp3   = 0x0,
-		.com3   = SWAP_RGB,
-		.com7   = FMT_RGB565 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB565,
+		.dsp3	= 0x0,
+		.com3	= SWAP_RGB,
+		.com7	= FMT_RGB565 | OFMT_RGB,
 	},
 	{
-		.format = &ov772x_fmt_lists[6],
-		.dsp3   = 0x0,
-		.com3   = 0x0,
-		.com7   = FMT_RGB565 | OFMT_RGB,
+		.code	= V4L2_IMGBUS_FMT_RGB565X,
+		.dsp3	= 0x0,
+		.com3	= 0x0,
+		.com7	= FMT_RGB565 | OFMT_RGB,
 	},
 };
 
@@ -649,8 +606,8 @@ static int ov772x_s_stream(struct v4l2_subdev *sd, int enable)
 
 	ov772x_mask_set(client, COM2, SOFT_SLEEP_MODE, 0);
 
-	dev_dbg(&client->dev, "format %s, win %s\n",
-		priv->fmt->format->name, priv->win->name);
+	dev_dbg(&client->dev, "format %d, win %s\n",
+		priv->fmt->code, priv->win->name);
 
 	return 0;
 }
@@ -806,8 +763,8 @@ static const struct ov772x_win_size *ov772x_select_win(u32 width, u32 height)
 	return win;
 }
 
-static int ov772x_set_params(struct i2c_client *client,
-			     u32 *width, u32 *height, u32 pixfmt)
+static int ov772x_set_params(struct i2c_client *client, u32 *width, u32 *height,
+			     enum v4l2_imgbus_pixelcode code)
 {
 	struct ov772x_priv *priv = to_ov772x(client);
 	int ret = -EINVAL;
@@ -819,7 +776,7 @@ static int ov772x_set_params(struct i2c_client *client,
 	 */
 	priv->fmt = NULL;
 	for (i = 0; i < ARRAY_SIZE(ov772x_cfmts); i++) {
-		if (pixfmt == ov772x_cfmts[i].format->fourcc) {
+		if (code == ov772x_cfmts[i].code) {
 			priv->fmt = ov772x_cfmts + i;
 			break;
 		}
@@ -925,7 +882,7 @@ static int ov772x_set_params(struct i2c_client *client,
 	 */
 	val = priv->win->com7_bit | priv->fmt->com7;
 	ret = ov772x_mask_set(client,
-			      COM7, (SLCT_MASK | FMT_MASK | OFMT_MASK),
+			      COM7, SLCT_MASK | FMT_MASK | OFMT_MASK,
 			      val);
 	if (ret < 0)
 		goto ov772x_set_fmt_error;
@@ -981,54 +938,50 @@ static int ov772x_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
 	return 0;
 }
 
-static int ov772x_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov772x_g_imgbus_fmt(struct v4l2_subdev *sd,
+			       struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
 	struct ov772x_priv *priv = to_ov772x(client);
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	if (!priv->win || !priv->fmt) {
 		u32 width = VGA_WIDTH, height = VGA_HEIGHT;
 		int ret = ov772x_set_params(client, &width, &height,
-					    V4L2_PIX_FMT_YUYV);
+					    V4L2_IMGBUS_FMT_YUYV);
 		if (ret < 0)
 			return ret;
 	}
 
-	f->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	pix->width		= priv->win->width;
-	pix->height		= priv->win->height;
-	pix->pixelformat	= priv->fmt->format->fourcc;
-	pix->colorspace		= priv->fmt->format->colorspace;
-	pix->field		= V4L2_FIELD_NONE;
+	imgf->width	= priv->win->width;
+	imgf->height	= priv->win->height;
+	imgf->code	= priv->fmt->code;
+	imgf->field	= V4L2_FIELD_NONE;
 
 	return 0;
 }
 
-static int ov772x_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+static int ov772x_s_imgbus_fmt(struct v4l2_subdev *sd,
+			       struct v4l2_imgbus_framefmt *imgf)
 {
 	struct i2c_client *client = sd->priv;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 
-	return ov772x_set_params(client, &pix->width, &pix->height,
-				 pix->pixelformat);
+	return ov772x_set_params(client, &imgf->width, &imgf->height,
+				 imgf->code);
 }
 
-static int ov772x_try_fmt(struct v4l2_subdev *sd,
-			  struct v4l2_format *f)
+static int ov772x_try_imgbus_fmt(struct v4l2_subdev *sd,
+				 struct v4l2_imgbus_framefmt *imgf)
 {
-	struct v4l2_pix_format *pix = &f->fmt.pix;
 	const struct ov772x_win_size *win;
 
 	/*
 	 * select suitable win
 	 */
-	win = ov772x_select_win(pix->width, pix->height);
+	win = ov772x_select_win(imgf->width, imgf->height);
 
-	pix->width  = win->width;
-	pix->height = win->height;
-	pix->field  = V4L2_FIELD_NONE;
+	imgf->width  = win->width;
+	imgf->height = win->height;
+	imgf->field  = V4L2_FIELD_NONE;
 
 	return 0;
 }
@@ -1057,9 +1010,6 @@ static int ov772x_video_probe(struct soc_camera_device *icd,
 		return -ENODEV;
 	}
 
-	icd->formats     = ov772x_fmt_lists;
-	icd->num_formats = ARRAY_SIZE(ov772x_fmt_lists);
-
 	/*
 	 * check and show product ID and manufacturer ID
 	 */
@@ -1109,13 +1059,24 @@ static struct v4l2_subdev_core_ops ov772x_subdev_core_ops = {
 #endif
 };
 
+static int ov772x_enum_imgbus_fmt(struct v4l2_subdev *sd, int index,
+				  enum v4l2_imgbus_pixelcode *code)
+{
+	if ((unsigned int)index >= ARRAY_SIZE(ov772x_cfmts))
+		return -EINVAL;
+
+	*code = ov772x_cfmts[index].code;
+	return 0;
+}
+
 static struct v4l2_subdev_video_ops ov772x_subdev_video_ops = {
-	.s_stream	= ov772x_s_stream,
-	.g_fmt		= ov772x_g_fmt,
-	.s_fmt		= ov772x_s_fmt,
-	.try_fmt	= ov772x_try_fmt,
-	.cropcap	= ov772x_cropcap,
-	.g_crop		= ov772x_g_crop,
+	.s_stream		= ov772x_s_stream,
+	.g_imgbus_fmt		= ov772x_g_imgbus_fmt,
+	.s_imgbus_fmt		= ov772x_s_imgbus_fmt,
+	.try_imgbus_fmt		= ov772x_try_imgbus_fmt,
+	.cropcap		= ov772x_cropcap,
+	.g_crop			= ov772x_g_crop,
+	.enum_imgbus_fmt	= ov772x_enum_imgbus_fmt,
 };
 
 static struct v4l2_subdev_ops ov772x_subdev_ops = {
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2f7e988..3e4f68d 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -37,6 +37,7 @@
 #include <media/soc_camera.h>
 #include <media/sh_mobile_ceu.h>
 #include <media/videobuf-dma-contig.h>
+#include <media/v4l2-imagebus.h>
 
 /* register offsets for sh7722 / sh7723 */
 
@@ -84,7 +85,7 @@
 /* per video frame buffer */
 struct sh_mobile_ceu_buffer {
 	struct videobuf_buffer vb; /* v4l buffer must be first */
-	const struct soc_camera_data_format *fmt;
+	enum v4l2_imgbus_pixelcode code;
 };
 
 struct sh_mobile_ceu_dev {
@@ -114,8 +115,8 @@ struct sh_mobile_ceu_cam {
 	struct v4l2_rect ceu_rect;
 	unsigned int cam_width;
 	unsigned int cam_height;
-	const struct soc_camera_data_format *extra_fmt;
-	const struct soc_camera_data_format *camera_fmt;
+	const struct v4l2_imgbus_pixelfmt *extra_fmt;
+	enum v4l2_imgbus_pixelcode code;
 };
 
 static unsigned long make_bus_param(struct sh_mobile_ceu_dev *pcdev)
@@ -196,10 +197,13 @@ static int sh_mobile_ceu_videobuf_setup(struct videobuf_queue *vq,
 	struct soc_camera_device *icd = vq->priv_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	int bytes_per_pixel = (icd->current_fmt->depth + 7) >> 3;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 
-	*size = PAGE_ALIGN(icd->user_width * icd->user_height *
-			   bytes_per_pixel);
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
+	*size = PAGE_ALIGN(bytes_per_line * icd->user_height);
 
 	if (0 == *count)
 		*count = 2;
@@ -283,7 +287,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		ceu_write(pcdev, CDBYR, phys_addr_bottom);
 	}
 
-	switch (icd->current_fmt->fourcc) {
+	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 	case V4L2_PIX_FMT_NV16:
@@ -310,8 +314,13 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 {
 	struct soc_camera_device *icd = vq->priv_data;
 	struct sh_mobile_ceu_buffer *buf;
+	int bytes_per_line = v4l2_imgbus_bytes_per_line(icd->user_width,
+						icd->current_fmt->host_fmt);
 	int ret;
 
+	if (bytes_per_line < 0)
+		return bytes_per_line;
+
 	buf = container_of(vb, struct sh_mobile_ceu_buffer, vb);
 
 	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
@@ -330,18 +339,18 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
 
 	BUG_ON(NULL == icd->current_fmt);
 
-	if (buf->fmt	!= icd->current_fmt ||
+	if (buf->code	!= icd->current_fmt->code ||
 	    vb->width	!= icd->user_width ||
 	    vb->height	!= icd->user_height ||
 	    vb->field	!= field) {
-		buf->fmt	= icd->current_fmt;
+		buf->code	= icd->current_fmt->code;
 		vb->width	= icd->user_width;
 		vb->height	= icd->user_height;
 		vb->field	= field;
 		vb->state	= VIDEOBUF_NEEDS_INIT;
 	}
 
-	vb->size = vb->width * vb->height * ((buf->fmt->depth + 7) >> 3);
+	vb->size = vb->height * bytes_per_line;
 	if (0 != vb->baddr && vb->bsize < vb->size) {
 		ret = -EINVAL;
 		goto out;
@@ -565,7 +574,8 @@ static void sh_mobile_ceu_set_rect(struct soc_camera_device *icd,
 		}
 		width = cdwdr_width = out_width;
 	} else {
-		unsigned int w_factor = (icd->current_fmt->depth + 7) >> 3;
+		unsigned int w_factor = (7 +
+			icd->current_fmt->host_fmt->bits_per_sample) >> 3;
 
 		width = out_width * w_factor / 2;
 
@@ -672,24 +682,24 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 	value = 0x00000010; /* data fetch by default */
 	yuv_lineskip = 0;
 
-	switch (icd->current_fmt->fourcc) {
+	switch (icd->current_fmt->host_fmt->fourcc) {
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV21:
 		yuv_lineskip = 1; /* skip for NV12/21, no skip for NV16/61 */
 		/* fall-through */
 	case V4L2_PIX_FMT_NV16:
 	case V4L2_PIX_FMT_NV61:
-		switch (cam->camera_fmt->fourcc) {
-		case V4L2_PIX_FMT_UYVY:
+		switch (cam->code) {
+		case V4L2_IMGBUS_FMT_UYVY:
 			value = 0x00000000; /* Cb0, Y0, Cr0, Y1 */
 			break;
-		case V4L2_PIX_FMT_VYUY:
+		case V4L2_IMGBUS_FMT_VYUY:
 			value = 0x00000100; /* Cr0, Y0, Cb0, Y1 */
 			break;
-		case V4L2_PIX_FMT_YUYV:
+		case V4L2_IMGBUS_FMT_YUYV:
 			value = 0x00000200; /* Y0, Cb0, Y1, Cr0 */
 			break;
-		case V4L2_PIX_FMT_YVYU:
+		case V4L2_IMGBUS_FMT_YVYU:
 			value = 0x00000300; /* Y0, Cr0, Y1, Cb0 */
 			break;
 		default:
@@ -697,8 +707,8 @@ static int sh_mobile_ceu_set_bus_param(struct soc_camera_device *icd,
 		}
 	}
 
-	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_NV21 ||
-	    icd->current_fmt->fourcc == V4L2_PIX_FMT_NV61)
+	if (icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV21 ||
+	    icd->current_fmt->host_fmt->fourcc == V4L2_PIX_FMT_NV61)
 		value ^= 0x00000100; /* swap U, V to change from NV1x->NVx1 */
 
 	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
@@ -760,40 +770,47 @@ static int sh_mobile_ceu_try_bus_param(struct soc_camera_device *icd)
 	return 0;
 }
 
-static const struct soc_camera_data_format sh_mobile_ceu_formats[] = {
+static const struct v4l2_imgbus_pixelfmt sh_mobile_ceu_formats[] = {
 	{
-		.name		= "NV12",
-		.depth		= 12,
-		.fourcc		= V4L2_PIX_FMT_NV12,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	},
-	{
-		.name		= "NV21",
-		.depth		= 12,
-		.fourcc		= V4L2_PIX_FMT_NV21,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	},
-	{
-		.name		= "NV16",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_NV16,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
-	},
-	{
-		.name		= "NV61",
-		.depth		= 16,
-		.fourcc		= V4L2_PIX_FMT_NV61,
-		.colorspace	= V4L2_COLORSPACE_JPEG,
+		.fourcc			= V4L2_PIX_FMT_NV12,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV12",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV21,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV21",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV16,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV16",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, {
+		.fourcc			= V4L2_PIX_FMT_NV61,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "NV61",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
 	},
 };
 
 static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 				     struct soc_camera_format_xlate *xlate)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	int ret, k, n;
 	int formats = 0;
 	struct sh_mobile_ceu_cam *cam;
+	enum v4l2_imgbus_pixelcode code;
 
 	ret = sh_mobile_ceu_try_bus_param(icd);
 	if (ret < 0)
@@ -813,11 +830,16 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 	if (!idx)
 		cam->extra_fmt = NULL;
 
-	switch (icd->formats[idx].fourcc) {
-	case V4L2_PIX_FMT_UYVY:
-	case V4L2_PIX_FMT_VYUY:
-	case V4L2_PIX_FMT_YUYV:
-	case V4L2_PIX_FMT_YVYU:
+	ret = v4l2_subdev_call(sd, video, enum_imgbus_fmt, idx, &code);
+	if (ret < 0)
+		/* No more formats */
+		return 0;
+
+	switch (code) {
+	case V4L2_IMGBUS_FMT_UYVY:
+	case V4L2_IMGBUS_FMT_VYUY:
+	case V4L2_IMGBUS_FMT_YUYV:
+	case V4L2_IMGBUS_FMT_YVYU:
 		if (cam->extra_fmt)
 			goto add_single_format;
 
@@ -830,31 +852,29 @@ static int sh_mobile_ceu_get_formats(struct soc_camera_device *icd, int idx,
 		 * the host_priv pointer and check whether the format you're
 		 * going to add now is already there.
 		 */
-		cam->extra_fmt = (void *)sh_mobile_ceu_formats;
+		cam->extra_fmt = sh_mobile_ceu_formats;
 
 		n = ARRAY_SIZE(sh_mobile_ceu_formats);
 		formats += n;
 		for (k = 0; xlate && k < n; k++) {
-			xlate->host_fmt = &sh_mobile_ceu_formats[k];
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = icd->formats[idx].depth;
+			xlate->host_fmt	= &sh_mobile_ceu_formats[k];
+			xlate->code	= code;
 			xlate++;
-			dev_dbg(dev, "Providing format %s using %s\n",
-				sh_mobile_ceu_formats[k].name,
-				icd->formats[idx].name);
+			dev_dbg(dev, "Providing format %x using #%d\n",
+				sh_mobile_ceu_formats[k].fourcc,
+				code);
 		}
 	default:
 add_single_format:
 		/* Generic pass-through */
 		formats++;
 		if (xlate) {
-			xlate->host_fmt = icd->formats + idx;
-			xlate->cam_fmt = icd->formats + idx;
-			xlate->buswidth = icd->formats[idx].depth;
+			xlate->host_fmt = v4l2_imgbus_get_fmtdesc(code);
+			xlate->code = code;
 			xlate++;
 			dev_dbg(dev,
-				"Providing format %s in pass-through mode\n",
-				icd->formats[idx].name);
+				"Providing format %x in pass-through mode\n",
+				xlate->host_fmt->fourcc);
 		}
 	}
 
@@ -1035,17 +1055,15 @@ static int client_s_crop(struct v4l2_subdev *sd, struct v4l2_crop *crop,
 static int get_camera_scales(struct v4l2_subdev *sd, struct v4l2_rect *rect,
 			     unsigned int *scale_h, unsigned int *scale_v)
 {
-	struct v4l2_format f;
+	struct v4l2_imgbus_framefmt imgf;
 	int ret;
 
-	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+	ret = v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf);
 	if (ret < 0)
 		return ret;
 
-	*scale_h = calc_generic_scale(rect->width, f.fmt.pix.width);
-	*scale_v = calc_generic_scale(rect->height, f.fmt.pix.height);
+	*scale_h = calc_generic_scale(rect->width, imgf.width);
+	*scale_v = calc_generic_scale(rect->height, imgf.height);
 
 	return 0;
 }
@@ -1060,32 +1078,29 @@ static int get_camera_subwin(struct soc_camera_device *icd,
 	if (!ceu_rect->width) {
 		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 		struct device *dev = icd->dev.parent;
-		struct v4l2_format f;
-		struct v4l2_pix_format *pix = &f.fmt.pix;
+		struct v4l2_imgbus_framefmt imgf;
 		int ret;
 		/* First time */
 
-		f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-		ret = v4l2_subdev_call(sd, video, g_fmt, &f);
+		ret = v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf);
 		if (ret < 0)
 			return ret;
 
-		dev_geo(dev, "camera fmt %ux%u\n", pix->width, pix->height);
+		dev_geo(dev, "camera fmt %ux%u\n", imgf.width, imgf.height);
 
-		if (pix->width > 2560) {
+		if (imgf.width > 2560) {
 			ceu_rect->width	 = 2560;
-			ceu_rect->left	 = (pix->width - 2560) / 2;
+			ceu_rect->left	 = (imgf.width - 2560) / 2;
 		} else {
-			ceu_rect->width	 = pix->width;
+			ceu_rect->width	 = imgf.width;
 			ceu_rect->left	 = 0;
 		}
 
-		if (pix->height > 1920) {
+		if (imgf.height > 1920) {
 			ceu_rect->height = 1920;
-			ceu_rect->top	 = (pix->height - 1920) / 2;
+			ceu_rect->top	 = (imgf.height - 1920) / 2;
 		} else {
-			ceu_rect->height = pix->height;
+			ceu_rect->height = imgf.height;
 			ceu_rect->top	 = 0;
 		}
 
@@ -1102,13 +1117,12 @@ static int get_camera_subwin(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
-			bool ceu_can_scale)
+static int client_s_fmt(struct soc_camera_device *icd,
+			struct v4l2_imgbus_framefmt *imgf, bool ceu_can_scale)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	struct v4l2_pix_format *pix = &f->fmt.pix;
-	unsigned int width = pix->width, height = pix->height, tmp_w, tmp_h;
+	unsigned int width = imgf->width, height = imgf->height, tmp_w, tmp_h;
 	unsigned int max_width, max_height;
 	struct v4l2_cropcap cap;
 	int ret;
@@ -1122,29 +1136,29 @@ static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
 	max_width = min(cap.bounds.width, 2560);
 	max_height = min(cap.bounds.height, 1920);
 
-	ret = v4l2_subdev_call(sd, video, s_fmt, f);
+	ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, imgf);
 	if (ret < 0)
 		return ret;
 
-	dev_geo(dev, "camera scaled to %ux%u\n", pix->width, pix->height);
+	dev_geo(dev, "camera scaled to %ux%u\n", imgf->width, imgf->height);
 
-	if ((width == pix->width && height == pix->height) || !ceu_can_scale)
+	if ((width == imgf->width && height == imgf->height) || !ceu_can_scale)
 		return 0;
 
 	/* Camera set a format, but geometry is not precise, try to improve */
-	tmp_w = pix->width;
-	tmp_h = pix->height;
+	tmp_w = imgf->width;
+	tmp_h = imgf->height;
 
 	/* width <= max_width && height <= max_height - guaranteed by try_fmt */
 	while ((width > tmp_w || height > tmp_h) &&
 	       tmp_w < max_width && tmp_h < max_height) {
 		tmp_w = min(2 * tmp_w, max_width);
 		tmp_h = min(2 * tmp_h, max_height);
-		pix->width = tmp_w;
-		pix->height = tmp_h;
-		ret = v4l2_subdev_call(sd, video, s_fmt, f);
+		imgf->width = tmp_w;
+		imgf->height = tmp_h;
+		ret = v4l2_subdev_call(sd, video, s_imgbus_fmt, imgf);
 		dev_geo(dev, "Camera scaled to %ux%u\n",
-			pix->width, pix->height);
+			imgf->width, imgf->height);
 		if (ret < 0) {
 			/* This shouldn't happen */
 			dev_err(dev, "Client failed to set format: %d\n", ret);
@@ -1162,27 +1176,26 @@ static int client_s_fmt(struct soc_camera_device *icd, struct v4l2_format *f,
  */
 static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
 			struct v4l2_rect *sub_rect, struct v4l2_rect *ceu_rect,
-			struct v4l2_format *f, bool ceu_can_scale)
+			struct v4l2_imgbus_framefmt *imgf, bool ceu_can_scale)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct device *dev = icd->dev.parent;
-	struct v4l2_format f_tmp = *f;
-	struct v4l2_pix_format *pix_tmp = &f_tmp.fmt.pix;
+	struct v4l2_imgbus_framefmt imgf_tmp = *imgf;
 	unsigned int scale_h, scale_v;
 	int ret;
 
 	/* 5. Apply iterative camera S_FMT for camera user window. */
-	ret = client_s_fmt(icd, &f_tmp, ceu_can_scale);
+	ret = client_s_fmt(icd, &imgf_tmp, ceu_can_scale);
 	if (ret < 0)
 		return ret;
 
 	dev_geo(dev, "5: camera scaled to %ux%u\n",
-		pix_tmp->width, pix_tmp->height);
+		imgf_tmp.width, imgf_tmp.height);
 
 	/* 6. Retrieve camera output window (g_fmt) */
 
-	/* unneeded - it is already in "f_tmp" */
+	/* unneeded - it is already in "imgf_tmp" */
 
 	/* 7. Calculate new camera scales. */
 	ret = get_camera_scales(sd, rect, &scale_h, &scale_v);
@@ -1191,10 +1204,10 @@ static int client_scale(struct soc_camera_device *icd, struct v4l2_rect *rect,
 
 	dev_geo(dev, "7: camera scales %u:%u\n", scale_h, scale_v);
 
-	cam->cam_width		= pix_tmp->width;
-	cam->cam_height		= pix_tmp->height;
-	f->fmt.pix.width	= pix_tmp->width;
-	f->fmt.pix.height	= pix_tmp->height;
+	cam->cam_width	= imgf_tmp.width;
+	cam->cam_height	= imgf_tmp.height;
+	imgf->width	= imgf_tmp.width;
+	imgf->height	= imgf_tmp.height;
 
 	/*
 	 * 8. Calculate new CEU crop - apply camera scales to previously
@@ -1258,8 +1271,7 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	struct v4l2_rect *cam_rect = &cam_crop.c, *ceu_rect = &cam->ceu_rect;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
-	struct v4l2_format f;
-	struct v4l2_pix_format *pix = &f.fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	unsigned int scale_comb_h, scale_comb_v, scale_ceu_h, scale_ceu_v,
 		out_width, out_height;
 	u32 capsr, cflcr;
@@ -1308,25 +1320,24 @@ static int sh_mobile_ceu_set_crop(struct soc_camera_device *icd,
 	 * 5. Using actual input window and calculated combined scales calculate
 	 *    camera target output window.
 	 */
-	pix->width		= scale_down(cam_rect->width, scale_comb_h);
-	pix->height		= scale_down(cam_rect->height, scale_comb_v);
+	imgf.width	= scale_down(cam_rect->width, scale_comb_h);
+	imgf.height	= scale_down(cam_rect->height, scale_comb_v);
 
-	dev_geo(dev, "5: camera target %ux%u\n", pix->width, pix->height);
+	dev_geo(dev, "5: camera target %ux%u\n", imgf.width, imgf.height);
 
 	/* 6. - 9. */
-	pix->pixelformat	= cam->camera_fmt->fourcc;
-	pix->colorspace		= cam->camera_fmt->colorspace;
+	imgf.code	= cam->code;
+	imgf.field	= pcdev->is_interlaced ? V4L2_FIELD_INTERLACED :
+						V4L2_FIELD_NONE;
 
 	capsr = capture_save_reset(pcdev);
 	dev_dbg(dev, "CAPSR 0x%x, CFLCR 0x%x\n", capsr, pcdev->cflcr);
 
 	/* Make relative to camera rectangle */
-	rect->left		-= cam_rect->left;
-	rect->top		-= cam_rect->top;
+	rect->left	-= cam_rect->left;
+	rect->top	-= cam_rect->top;
 
-	f.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-
-	ret = client_scale(icd, cam_rect, rect, ceu_rect, &f,
+	ret = client_scale(icd, cam_rect, rect, ceu_rect, &imgf,
 			   pcdev->image_mode && !pcdev->is_interlaced);
 
 	dev_geo(dev, "6-9: %d\n", ret);
@@ -1374,8 +1385,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct sh_mobile_ceu_cam *cam = icd->host_priv;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
-	struct v4l2_format cam_f = *f;
-	struct v4l2_pix_format *cam_pix = &cam_f.fmt.pix;
+	struct v4l2_imgbus_framefmt imgf;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct device *dev = icd->dev.parent;
 	__u32 pixfmt = pix->pixelformat;
@@ -1444,9 +1454,10 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	 * 4. Calculate camera output window by applying combined scales to real
 	 *    input window.
 	 */
-	cam_pix->width = scale_down(cam_rect->width, scale_h);
-	cam_pix->height = scale_down(cam_rect->height, scale_v);
-	cam_pix->pixelformat = xlate->cam_fmt->fourcc;
+	imgf.width	= scale_down(cam_rect->width, scale_h);
+	imgf.height	= scale_down(cam_rect->height, scale_v);
+	imgf.code	= xlate->code;
+	imgf.field	= pix->field;
 
 	switch (pixfmt) {
 	case V4L2_PIX_FMT_NV12:
@@ -1459,11 +1470,10 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 		image_mode = false;
 	}
 
-	dev_geo(dev, "4: camera output %ux%u\n",
-		cam_pix->width, cam_pix->height);
+	dev_geo(dev, "4: camera output %ux%u\n", imgf.width, imgf.height);
 
 	/* 5. - 9. */
-	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &cam_f,
+	ret = client_scale(icd, cam_rect, &cam_subrect, &ceu_rect, &imgf,
 			   image_mode && !is_interlaced);
 
 	dev_geo(dev, "5-9: client scale %d\n", ret);
@@ -1471,20 +1481,20 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 	/* Done with the camera. Now see if we can improve the result */
 
 	dev_dbg(dev, "Camera %d fmt %ux%u, requested %ux%u\n",
-		ret, cam_pix->width, cam_pix->height, pix->width, pix->height);
+		ret, imgf.width, imgf.height, pix->width, pix->height);
 	if (ret < 0)
 		return ret;
 
 	/* 10. Use CEU scaling to scale to the requested user window. */
 
 	/* We cannot scale up */
-	if (pix->width > cam_pix->width)
-		pix->width = cam_pix->width;
+	if (pix->width > imgf.width)
+		pix->width = imgf.width;
 	if (pix->width > ceu_rect.width)
 		pix->width = ceu_rect.width;
 
-	if (pix->height > cam_pix->height)
-		pix->height = cam_pix->height;
+	if (pix->height > imgf.height)
+		pix->height = imgf.height;
 	if (pix->height > ceu_rect.height)
 		pix->height = ceu_rect.height;
 
@@ -1498,9 +1508,8 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
 
 	pcdev->cflcr = scale_h | (scale_v << 16);
 
-	icd->buswidth = xlate->buswidth;
-	icd->current_fmt = xlate->host_fmt;
-	cam->camera_fmt = xlate->cam_fmt;
+	icd->current_fmt = xlate;
+	cam->code = xlate->code;
 	cam->ceu_rect = ceu_rect;
 
 	pcdev->is_interlaced = is_interlaced;
@@ -1515,6 +1524,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	const struct soc_camera_format_xlate *xlate;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+	struct v4l2_imgbus_framefmt imgf;
 	__u32 pixfmt = pix->pixelformat;
 	int width, height;
 	int ret;
@@ -1533,15 +1543,17 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	width = pix->width;
 	height = pix->height;
 
-	pix->bytesperline = pix->width *
-		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
-	pix->sizeimage = pix->height * pix->bytesperline;
-
-	pix->pixelformat = xlate->cam_fmt->fourcc;
+	pix->bytesperline = v4l2_imgbus_bytes_per_line(width, xlate->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
+	pix->sizeimage = height * pix->bytesperline;
 
 	/* limit to sensor capabilities */
-	ret = v4l2_subdev_call(sd, video, try_fmt, f);
-	pix->pixelformat = pixfmt;
+	imgf.width	= pix->width;
+	imgf.height	= pix->height;
+	imgf.field	= pix->field;
+	imgf.code	= xlate->code;
+	ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
 	if (ret < 0)
 		return ret;
 
@@ -1556,7 +1568,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 			int tmp_w = pix->width, tmp_h = pix->height;
 			pix->width = 2560;
 			pix->height = 1920;
-			ret = v4l2_subdev_call(sd, video, try_fmt, f);
+			ret = v4l2_subdev_call(sd, video, try_imgbus_fmt, &imgf);
 			if (ret < 0) {
 				/* Shouldn't actually happen... */
 				dev_err(icd->dev.parent,
@@ -1662,7 +1674,7 @@ static int sh_mobile_ceu_set_ctrl(struct soc_camera_device *icd,
 
 	switch (ctrl->id) {
 	case V4L2_CID_SHARPNESS:
-		switch (icd->current_fmt->fourcc) {
+		switch (icd->current_fmt->host_fmt->fourcc) {
 		case V4L2_PIX_FMT_NV12:
 		case V4L2_PIX_FMT_NV21:
 		case V4L2_PIX_FMT_NV16:
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 0ebd72d..38b63db 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -40,18 +40,6 @@ static LIST_HEAD(hosts);
 static LIST_HEAD(devices);
 static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
 
-const struct soc_camera_data_format *soc_camera_format_by_fourcc(
-	struct soc_camera_device *icd, unsigned int fourcc)
-{
-	unsigned int i;
-
-	for (i = 0; i < icd->num_formats; i++)
-		if (icd->formats[i].fourcc == fourcc)
-			return icd->formats + i;
-	return NULL;
-}
-EXPORT_SYMBOL(soc_camera_format_by_fourcc);
-
 const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
 	struct soc_camera_device *icd, unsigned int fourcc)
 {
@@ -207,21 +195,26 @@ static int soc_camera_dqbuf(struct file *file, void *priv,
 /* Always entered with .video_lock held */
 static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 {
+	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	int i, fmts = 0, ret;
+	int i, fmts = 0, raw_fmts = 0, ret;
+	enum v4l2_imgbus_pixelcode code;
+
+	while (!v4l2_subdev_call(sd, video, enum_imgbus_fmt, raw_fmts, &code))
+		raw_fmts++;
 
 	if (!ici->ops->get_formats)
 		/*
 		 * Fallback mode - the host will have to serve all
 		 * sensor-provided formats one-to-one to the user
 		 */
-		fmts = icd->num_formats;
+		fmts = raw_fmts;
 	else
 		/*
 		 * First pass - only count formats this host-sensor
 		 * configuration can provide
 		 */
-		for (i = 0; i < icd->num_formats; i++) {
+		for (i = 0; i < raw_fmts; i++) {
 			ret = ici->ops->get_formats(icd, i, NULL);
 			if (ret < 0)
 				return ret;
@@ -242,11 +235,11 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 
 	/* Second pass - actually fill data formats */
 	fmts = 0;
-	for (i = 0; i < icd->num_formats; i++)
+	for (i = 0; i < raw_fmts; i++)
 		if (!ici->ops->get_formats) {
-			icd->user_formats[i].host_fmt = icd->formats + i;
-			icd->user_formats[i].cam_fmt = icd->formats + i;
-			icd->user_formats[i].buswidth = icd->formats[i].depth;
+			v4l2_subdev_call(sd, video, enum_imgbus_fmt, i, &code);
+			icd->user_formats[i].host_fmt = v4l2_imgbus_get_fmtdesc(code);
+			icd->user_formats[i].code = code;
 		} else {
 			ret = ici->ops->get_formats(icd, i,
 						    &icd->user_formats[fmts]);
@@ -255,7 +248,7 @@ static int soc_camera_init_user_formats(struct soc_camera_device *icd)
 			fmts += ret;
 		}
 
-	icd->current_fmt = icd->user_formats[0].host_fmt;
+	icd->current_fmt = &icd->user_formats[0];
 
 	return 0;
 
@@ -302,7 +295,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 	if (ret < 0) {
 		return ret;
 	} else if (!icd->current_fmt ||
-		   icd->current_fmt->fourcc != pix->pixelformat) {
+		   icd->current_fmt->host_fmt->fourcc != pix->pixelformat) {
 		dev_err(&icd->dev,
 			"Host driver hasn't set up current format correctly!\n");
 		return -EINVAL;
@@ -369,8 +362,8 @@ static int soc_camera_open(struct file *file)
 				.width		= icd->user_width,
 				.height		= icd->user_height,
 				.field		= icd->field,
-				.pixelformat	= icd->current_fmt->fourcc,
-				.colorspace	= icd->current_fmt->colorspace,
+				.pixelformat	= icd->current_fmt->host_fmt->fourcc,
+				.colorspace	= icd->current_fmt->host_fmt->colorspace,
 			},
 		};
 
@@ -534,7 +527,7 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 {
 	struct soc_camera_file *icf = file->private_data;
 	struct soc_camera_device *icd = icf->icd;
-	const struct soc_camera_data_format *format;
+	const struct v4l2_imgbus_pixelfmt *format;
 
 	WARN_ON(priv != file->private_data);
 
@@ -543,7 +536,8 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 
 	format = icd->user_formats[f->index].host_fmt;
 
-	strlcpy(f->description, format->name, sizeof(f->description));
+	if (format->name)
+		strlcpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
 	return 0;
 }
@@ -560,12 +554,14 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 	pix->width		= icd->user_width;
 	pix->height		= icd->user_height;
 	pix->field		= icf->vb_vidq.field;
-	pix->pixelformat	= icd->current_fmt->fourcc;
-	pix->bytesperline	= pix->width *
-		DIV_ROUND_UP(icd->current_fmt->depth, 8);
+	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
+	pix->bytesperline	= v4l2_imgbus_bytes_per_line(pix->width,
+						icd->current_fmt->host_fmt);
+	if (pix->bytesperline < 0)
+		return pix->bytesperline;
 	pix->sizeimage		= pix->height * pix->bytesperline;
 	dev_dbg(&icd->dev, "current_fmt->fourcc: 0x%08x\n",
-		icd->current_fmt->fourcc);
+		icd->current_fmt->host_fmt->fourcc);
 	return 0;
 }
 
@@ -894,7 +890,7 @@ static int soc_camera_probe(struct device *dev)
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct device *control = NULL;
 	struct v4l2_subdev *sd;
-	struct v4l2_format f = {.type = V4L2_BUF_TYPE_VIDEO_CAPTURE};
+	struct v4l2_imgbus_framefmt imgf;
 	int ret;
 
 	dev_info(dev, "Probing %s\n", dev_name(dev));
@@ -965,9 +961,9 @@ static int soc_camera_probe(struct device *dev)
 
 	/* Try to improve our guess of a reasonable window format */
 	sd = soc_camera_to_subdev(icd);
-	if (!v4l2_subdev_call(sd, video, g_fmt, &f)) {
-		icd->user_width		= f.fmt.pix.width;
-		icd->user_height	= f.fmt.pix.height;
+	if (!v4l2_subdev_call(sd, video, g_imgbus_fmt, &imgf)) {
+		icd->user_width		= imgf.width;
+		icd->user_height	= imgf.height;
 	}
 
 	/* Do we have to sysfs_remove_link() before device_unregister()? */
diff --git a/drivers/media/video/v4l2-imagebus.c b/drivers/media/video/v4l2-imagebus.c
new file mode 100644
index 0000000..677778e
--- /dev/null
+++ b/drivers/media/video/v4l2-imagebus.c
@@ -0,0 +1,175 @@
+/*
+ * Image Bus API
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-imagebus.h>
+
+static const struct v4l2_imgbus_pixelfmt imgbus_fmt[] = {
+	[V4L2_IMGBUS_FMT_YUYV] = {
+		.fourcc			= V4L2_PIX_FMT_YUYV,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "YUYV",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_YVYU] = {
+		.fourcc			= V4L2_PIX_FMT_YVYU,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "YVYU",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_UYVY] = {
+		.fourcc			= V4L2_PIX_FMT_UYVY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "UYVY",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "VYUY",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
+		.name			= "VYUY in SMPTE170M",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16] = {
+		.fourcc			= V4L2_PIX_FMT_VYUY,
+		.colorspace		= V4L2_COLORSPACE_SMPTE170M,
+		.name			= "VYUY in SMPTE170M, 16bit",
+		.bits_per_sample	= 16,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB555] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB555",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB555X] = {
+		.fourcc			= V4L2_PIX_FMT_RGB555X,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB555X",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB565] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB565",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_RGB565X] = {
+		.fourcc			= V4L2_PIX_FMT_RGB565X,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "RGB565X",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_2X8,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SBGGR8] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 BGGR",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGBRG8] = {
+		.fourcc			= V4L2_PIX_FMT_SGBRG8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 GBRG",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGRBG8] = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 GRBG",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SRGGB8] = {
+		.fourcc			= V4L2_PIX_FMT_SRGGB8,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 8 RGGB",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SGRBG10] = {
+		.fourcc			= V4L2_PIX_FMT_SGRBG10,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 10",
+		.bits_per_sample	= 10,
+		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_SBGGR16] = {
+		.fourcc			= V4L2_PIX_FMT_SBGGR16,
+		.colorspace		= V4L2_COLORSPACE_SRGB,
+		.name			= "Bayer 16",
+		.bits_per_sample	= 16,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_GREY] = {
+		.fourcc			= V4L2_PIX_FMT_GREY,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Grey",
+		.bits_per_sample	= 8,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_Y16] = {
+		.fourcc			= V4L2_PIX_FMT_Y16,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Grey 16bit",
+		.bits_per_sample	= 16,
+		.packing		= V4L2_IMGBUS_PACKING_NONE,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	}, [V4L2_IMGBUS_FMT_Y10] = {
+		.fourcc			= V4L2_PIX_FMT_Y10,
+		.colorspace		= V4L2_COLORSPACE_JPEG,
+		.name			= "Grey 10bit",
+		.bits_per_sample	= 10,
+		.packing		= V4L2_IMGBUS_PACKING_EXTEND16,
+		.order			= V4L2_IMGBUS_ORDER_LE,
+	},
+};
+
+const struct v4l2_imgbus_pixelfmt *v4l2_imgbus_get_fmtdesc(
+	enum v4l2_imgbus_pixelcode code)
+{
+	if ((unsigned int)code > ARRAY_SIZE(imgbus_fmt))
+		return NULL;
+	return imgbus_fmt + code;
+}
+EXPORT_SYMBOL(v4l2_imgbus_get_fmtdesc);
+
+s32 v4l2_imgbus_bytes_per_line(u32 width,
+			       const struct v4l2_imgbus_pixelfmt *imgf)
+{
+	switch (imgf->packing) {
+	case V4L2_IMGBUS_PACKING_NONE:
+		return width * imgf->bits_per_sample / 8;
+	case V4L2_IMGBUS_PACKING_2X8:
+	case V4L2_IMGBUS_PACKING_EXTEND16:
+		return width * 2;
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL(v4l2_imgbus_bytes_per_line);
diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
index 9d9a615..70e53c8 100644
--- a/include/linux/videodev2.h
+++ b/include/linux/videodev2.h
@@ -293,6 +293,7 @@ struct v4l2_pix_format {
 
 /* Grey formats */
 #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
+#define V4L2_PIX_FMT_Y10     v4l2_fourcc('Y', '1', '0', ' ') /* 10  Greyscale     */
 #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
 
 /* Palette formats */
@@ -328,6 +329,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_SBGGR8  v4l2_fourcc('B', 'A', '8', '1') /*  8  BGBG.. GRGR.. */
 #define V4L2_PIX_FMT_SGBRG8  v4l2_fourcc('G', 'B', 'R', 'G') /*  8  GBGB.. RGRG.. */
 #define V4L2_PIX_FMT_SGRBG8  v4l2_fourcc('G', 'R', 'B', 'G') /*  8  GRGR.. BGBG.. */
+#define V4L2_PIX_FMT_SRGGB8  v4l2_fourcc('R', 'G', 'G', 'B') /*  8  RGRG.. GBGB.. */
 #define V4L2_PIX_FMT_SGRBG10 v4l2_fourcc('B', 'A', '1', '0') /* 10bit raw bayer */
 	/* 10bit raw bayer DPCM compressed to 8 bits */
 #define V4L2_PIX_FMT_SGRBG10DPCM8 v4l2_fourcc('B', 'D', '1', '0')
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 218639f..0ce4dfd 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -26,13 +26,10 @@ struct soc_camera_device {
 	s32 user_height;
 	unsigned char iface;		/* Host number */
 	unsigned char devnum;		/* Device number per host */
-	unsigned char buswidth;		/* See comment in .c */
 	struct soc_camera_sense *sense;	/* See comment in struct definition */
 	struct soc_camera_ops *ops;
 	struct video_device *vdev;
-	const struct soc_camera_data_format *current_fmt;
-	const struct soc_camera_data_format *formats;
-	int num_formats;
+	const struct soc_camera_format_xlate *current_fmt;
 	struct soc_camera_format_xlate *user_formats;
 	int num_user_formats;
 	enum v4l2_field field;		/* Preserve field over close() */
@@ -173,9 +170,8 @@ struct soc_camera_data_format {
 
 /**
  * struct soc_camera_format_xlate - match between host and sensor formats
- * @cam_fmt: sensor format provided by the sensor
- * @host_fmt: host format after host translation from cam_fmt
- * @buswidth: bus width for this format
+ * @code: code of a sensor provided format
+ * @host_fmt: host format after host translation from code
  *
  * Host and sensor translation structure. Used in table of host and sensor
  * formats matchings in soc_camera_device. A host can override the generic list
@@ -183,9 +179,8 @@ struct soc_camera_data_format {
  * format setup.
  */
 struct soc_camera_format_xlate {
-	const struct soc_camera_data_format *cam_fmt;
-	const struct soc_camera_data_format *host_fmt;
-	unsigned char buswidth;
+	enum v4l2_imgbus_pixelcode code;
+	const struct v4l2_imgbus_pixelfmt *host_fmt;
 };
 
 struct soc_camera_ops {
diff --git a/include/media/v4l2-imagebus.h b/include/media/v4l2-imagebus.h
new file mode 100644
index 0000000..7b36536
--- /dev/null
+++ b/include/media/v4l2-imagebus.h
@@ -0,0 +1,77 @@
+/*
+ * Image Bus API header
+ *
+ * Copyright (C) 2009, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef V4L2_IMGBUS_H
+#define V4L2_IMGBUS_H
+
+enum v4l2_imgbus_packing {
+	V4L2_IMGBUS_PACKING_NONE,
+	V4L2_IMGBUS_PACKING_2X8,
+	V4L2_IMGBUS_PACKING_EXTEND16,
+};
+
+enum v4l2_imgbus_order {
+	V4L2_IMGBUS_ORDER_LE,
+	V4L2_IMGBUS_ORDER_BE,
+};
+
+enum v4l2_imgbus_pixelcode {
+	V4L2_IMGBUS_FMT_YUYV,
+	V4L2_IMGBUS_FMT_YVYU,
+	V4L2_IMGBUS_FMT_UYVY,
+	V4L2_IMGBUS_FMT_VYUY,
+	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_8,
+	V4L2_IMGBUS_FMT_VYUY_SMPTE170M_16,
+	V4L2_IMGBUS_FMT_RGB555,
+	V4L2_IMGBUS_FMT_RGB555X,
+	V4L2_IMGBUS_FMT_RGB565,
+	V4L2_IMGBUS_FMT_RGB565X,
+	V4L2_IMGBUS_FMT_SBGGR8,
+	V4L2_IMGBUS_FMT_SGBRG8,
+	V4L2_IMGBUS_FMT_SGRBG8,
+	V4L2_IMGBUS_FMT_SRGGB8,
+	V4L2_IMGBUS_FMT_SGRBG10,
+	V4L2_IMGBUS_FMT_SBGGR16,
+	V4L2_IMGBUS_FMT_GREY,
+	V4L2_IMGBUS_FMT_Y16,
+	V4L2_IMGBUS_FMT_Y10,
+};
+
+/**
+ * struct v4l2_imgbus_pixelfmt - Data format on the image bus
+ * @fourcc:		Fourcc code...
+ * @colorspace:		and colorspace, that will be obtained if the data is
+ *			stored in memory in the following way:
+ * @bits_per_sample:	How many bits the bridge has to sample
+ * @packing:		Type of sample-packing, that has to be used
+ * @order:		Sample order when storing in memory
+ */
+struct v4l2_imgbus_pixelfmt {
+	u32				fourcc;
+	enum v4l2_colorspace		colorspace;
+	const char			*name;
+	enum v4l2_imgbus_packing	packing;
+	enum v4l2_imgbus_order		order;
+	u8				bits_per_sample;
+};
+
+struct v4l2_imgbus_framefmt {
+	__u32				width;
+	__u32				height;
+	enum v4l2_imgbus_pixelcode	code;
+	enum v4l2_field			field;
+};
+
+const struct v4l2_imgbus_pixelfmt *v4l2_imgbus_get_fmtdesc(
+	enum v4l2_imgbus_pixelcode code);
+s32 v4l2_imgbus_bytes_per_line(u32 width,
+			       const struct v4l2_imgbus_pixelfmt *imgf);
+
+#endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 81b90d2..daf8620 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -22,6 +22,7 @@
 #define _V4L2_SUBDEV_H
 
 #include <media/v4l2-common.h>
+#include <media/v4l2-imagebus.h>
 
 struct v4l2_device;
 struct v4l2_subdev;
@@ -194,7 +195,7 @@ struct v4l2_subdev_audio_ops {
    s_std_output: set v4l2_std_id for video OUTPUT devices. This is ignored by
 	video input devices.
 
-  s_crystal_freq: sets the frequency of the crystal used to generate the
+   s_crystal_freq: sets the frequency of the crystal used to generate the
 	clocks in Hz. An extra flags field allows device specific configuration
 	regarding clock frequency dividers, etc. If not used, then set flags
 	to 0. If the frequency is not supported, then -EINVAL is returned.
@@ -204,6 +205,8 @@ struct v4l2_subdev_audio_ops {
 
    s_routing: see s_routing in audio_ops, except this version is for video
 	devices.
+
+   enum_imgbus_fmt: enumerate pixel formats provided by a video data source
  */
 struct v4l2_subdev_video_ops {
 	int (*s_routing)(struct v4l2_subdev *sd, u32 input, u32 output, u32 config);
@@ -225,6 +228,11 @@ struct v4l2_subdev_video_ops {
 	int (*s_crop)(struct v4l2_subdev *sd, struct v4l2_crop *crop);
 	int (*g_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
 	int (*s_parm)(struct v4l2_subdev *sd, struct v4l2_streamparm *param);
+	int (*enum_imgbus_fmt)(struct v4l2_subdev *sd, int index,
+			       enum v4l2_imgbus_pixelcode *code);
+	int (*g_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
+	int (*try_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
+	int (*s_imgbus_fmt)(struct v4l2_subdev *sd, struct v4l2_imgbus_framefmt *fmt);
 };
 
 /**
