Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:23574
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379Ab2KTHAY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 02:00:24 -0500
From: Scott Jiang <scott.jiang.linux@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	<linux-media@vger.kernel.org>,
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: [PATCH 2/2] v4l2: blackfin: add EPPI3 support
Date: Tue, 20 Nov 2012 14:49:36 -0500
Message-ID: <1353440976-1112-2-git-send-email-scott.jiang.linux@gmail.com>
In-Reply-To: <1353440976-1112-1-git-send-email-scott.jiang.linux@gmail.com>
References: <1353440976-1112-1-git-send-email-scott.jiang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bf60x soc has a new PPI called Enhanced PPI version 3.
HD video is supported now. To achieve this, we redesign
ppi params and add dv timings feature.

Signed-off-by: Scott Jiang <scott.jiang.linux@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c |  148 +++++++++++++++++++++---
 drivers/media/platform/blackfin/ppi.c          |   72 +++++++++---
 include/media/blackfin/bfin_capture.h          |    5 +-
 include/media/blackfin/ppi.h                   |   33 +++++-
 4 files changed, 222 insertions(+), 36 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index ec476ef..a0e3d73 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -52,6 +52,7 @@ struct bcap_format {
 	u32 pixelformat;
 	enum v4l2_mbus_pixelcode mbus_code;
 	int bpp; /* bits per pixel */
+	int dlen; /* data length for ppi in bits */
 };
 
 struct bcap_buffer {
@@ -76,10 +77,14 @@ struct bcap_device {
 	unsigned int cur_input;
 	/* current selected standard */
 	v4l2_std_id std;
+	/* current selected dv_timings */
+	struct v4l2_dv_timings dv_timings;
 	/* used to store pixel format */
 	struct v4l2_pix_format fmt;
 	/* bits per pixel*/
 	int bpp;
+	/* data length for ppi in bits */
+	int dlen;
 	/* used to store sensor supported format */
 	struct bcap_format *sensor_formats;
 	/* number of sensor formats array */
@@ -116,24 +121,35 @@ static const struct bcap_format bcap_formats[] = {
 		.pixelformat = V4L2_PIX_FMT_UYVY,
 		.mbus_code   = V4L2_MBUS_FMT_UYVY8_2X8,
 		.bpp         = 16,
+		.dlen        = 8,
 	},
 	{
 		.desc        = "YCbCr 4:2:2 Interleaved YUYV",
 		.pixelformat = V4L2_PIX_FMT_YUYV,
 		.mbus_code   = V4L2_MBUS_FMT_YUYV8_2X8,
 		.bpp         = 16,
+		.dlen        = 8,
+	},
+	{
+		.desc        = "YCbCr 4:2:2 Interleaved UYVY",
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+		.mbus_code   = V4L2_MBUS_FMT_UYVY8_1X16,
+		.bpp         = 16,
+		.dlen        = 16,
 	},
 	{
 		.desc        = "RGB 565",
 		.pixelformat = V4L2_PIX_FMT_RGB565,
 		.mbus_code   = V4L2_MBUS_FMT_RGB565_2X8_LE,
 		.bpp         = 16,
+		.dlen        = 8,
 	},
 	{
 		.desc        = "RGB 444",
 		.pixelformat = V4L2_PIX_FMT_RGB444,
 		.mbus_code   = V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE,
 		.bpp         = 16,
+		.dlen        = 8,
 	},
 
 };
@@ -366,9 +382,39 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	params.width = bcap_dev->fmt.width;
 	params.height = bcap_dev->fmt.height;
 	params.bpp = bcap_dev->bpp;
+	params.dlen = bcap_dev->dlen;
 	params.ppi_control = bcap_dev->cfg->ppi_control;
 	params.int_mask = bcap_dev->cfg->int_mask;
-	params.blank_clocks = bcap_dev->cfg->blank_clocks;
+	if (bcap_dev->cfg->inputs[bcap_dev->cur_input].capabilities
+			& V4L2_IN_CAP_CUSTOM_TIMINGS) {
+		struct v4l2_bt_timings *bt = &bcap_dev->dv_timings.bt;
+
+		params.hdelay = bt->hsync + bt->hbackporch;
+		params.vdelay = bt->vsync + bt->vbackporch;
+		params.line = bt->hfrontporch + bt->hsync
+				+ bt->hbackporch + bt->width;
+		params.frame = bt->vfrontporch + bt->vsync
+				+ bt->vbackporch + bt->height;
+		if (bt->interlaced)
+			params.frame += bt->il_vfrontporch + bt->il_vsync
+					+ bt->il_vbackporch;
+	} else if (bcap_dev->cfg->inputs[bcap_dev->cur_input].capabilities
+			& V4L2_IN_CAP_STD) {
+		params.hdelay = 0;
+		params.vdelay = 0;
+		if (bcap_dev->std & V4L2_STD_525_60) {
+			params.line = 858;
+			params.frame = 525;
+		} else {
+			params.line = 864;
+			params.frame = 625;
+		}
+	} else {
+		params.hdelay = 0;
+		params.vdelay = 0;
+		params.line = params.width + bcap_dev->cfg->blank_pixels;
+		params.frame = params.height;
+	}
 	ret = ppi->ops->set_params(ppi, &params);
 	if (ret < 0) {
 		v4l2_err(&bcap_dev->v4l2_dev,
@@ -602,6 +648,37 @@ static int bcap_s_std(struct file *file, void *priv, v4l2_std_id *std)
 	return 0;
 }
 
+static int bcap_g_dv_timings(struct file *file, void *priv,
+				struct v4l2_dv_timings *timings)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	int ret;
+
+	ret = v4l2_subdev_call(bcap_dev->sd, video,
+				g_dv_timings, timings);
+	if (ret < 0)
+		return ret;
+
+	bcap_dev->dv_timings = *timings;
+	return 0;
+}
+
+static int bcap_s_dv_timings(struct file *file, void *priv,
+				struct v4l2_dv_timings *timings)
+{
+	struct bcap_device *bcap_dev = video_drvdata(file);
+	int ret;
+	if (vb2_is_busy(&bcap_dev->buffer_queue))
+		return -EBUSY;
+
+	ret = v4l2_subdev_call(bcap_dev->sd, video, s_dv_timings, timings);
+	if (ret < 0)
+		return ret;
+
+	bcap_dev->dv_timings = *timings;
+	return 0;
+}
+
 static int bcap_enum_input(struct file *file, void *priv,
 				struct v4l2_input *input)
 {
@@ -650,13 +727,15 @@ static int bcap_s_input(struct file *file, void *priv, unsigned int index)
 		return ret;
 	}
 	bcap_dev->cur_input = index;
+	/* if this route has specific config, update ppi control */
+	if (route->ppi_control)
+		config->ppi_control = route->ppi_control;
 	return 0;
 }
 
 static int bcap_try_format(struct bcap_device *bcap,
 				struct v4l2_pix_format *pixfmt,
-				enum v4l2_mbus_pixelcode *mbus_code,
-				int *bpp)
+				struct bcap_format *bcap_fmt)
 {
 	struct bcap_format *sf = bcap->sensor_formats;
 	struct bcap_format *fmt = NULL;
@@ -671,16 +750,20 @@ static int bcap_try_format(struct bcap_device *bcap,
 	if (i == bcap->num_sensor_formats)
 		fmt = &sf[0];
 
-	if (mbus_code)
-		*mbus_code = fmt->mbus_code;
-	if (bpp)
-		*bpp = fmt->bpp;
 	v4l2_fill_mbus_format(&mbus_fmt, pixfmt, fmt->mbus_code);
 	ret = v4l2_subdev_call(bcap->sd, video,
 				try_mbus_fmt, &mbus_fmt);
 	if (ret < 0)
 		return ret;
 	v4l2_fill_pix_format(pixfmt, &mbus_fmt);
+	if (bcap_fmt) {
+		for (i = 0; i < bcap->num_sensor_formats; i++) {
+			fmt = &sf[i];
+			if (mbus_fmt.code == fmt->mbus_code)
+				break;
+		}
+		*bcap_fmt = *fmt;
+	}
 	pixfmt->bytesperline = pixfmt->width * fmt->bpp / 8;
 	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
 	return 0;
@@ -709,7 +792,7 @@ static int bcap_try_fmt_vid_cap(struct file *file, void *priv,
 	struct bcap_device *bcap_dev = video_drvdata(file);
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
 
-	return bcap_try_format(bcap_dev, pixfmt, NULL, NULL);
+	return bcap_try_format(bcap_dev, pixfmt, NULL);
 }
 
 static int bcap_g_fmt_vid_cap(struct file *file, void *priv,
@@ -726,24 +809,25 @@ static int bcap_s_fmt_vid_cap(struct file *file, void *priv,
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 	struct v4l2_mbus_framefmt mbus_fmt;
-	enum v4l2_mbus_pixelcode mbus_code;
+	struct bcap_format bcap_fmt;
 	struct v4l2_pix_format *pixfmt = &fmt->fmt.pix;
-	int ret, bpp;
+	int ret;
 
 	if (vb2_is_busy(&bcap_dev->buffer_queue))
 		return -EBUSY;
 
 	/* see if format works */
-	ret = bcap_try_format(bcap_dev, pixfmt, &mbus_code, &bpp);
+	ret = bcap_try_format(bcap_dev, pixfmt, &bcap_fmt);
 	if (ret < 0)
 		return ret;
 
-	v4l2_fill_mbus_format(&mbus_fmt, pixfmt, mbus_code);
+	v4l2_fill_mbus_format(&mbus_fmt, pixfmt, bcap_fmt.mbus_code);
 	ret = v4l2_subdev_call(bcap_dev->sd, video, s_mbus_fmt, &mbus_fmt);
 	if (ret < 0)
 		return ret;
 	bcap_dev->fmt = *pixfmt;
-	bcap_dev->bpp = bpp;
+	bcap_dev->bpp = bcap_fmt.bpp;
+	bcap_dev->dlen = bcap_fmt.dlen;
 	return 0;
 }
 
@@ -834,6 +918,8 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 	.vidioc_querystd         = bcap_querystd,
 	.vidioc_s_std            = bcap_s_std,
 	.vidioc_g_std            = bcap_g_std,
+	.vidioc_s_dv_timings     = bcap_s_dv_timings,
+	.vidioc_g_dv_timings     = bcap_g_dv_timings,
 	.vidioc_reqbufs          = bcap_reqbufs,
 	.vidioc_querybuf         = bcap_querybuf,
 	.vidioc_qbuf             = bcap_qbuf,
@@ -869,6 +955,7 @@ static int __devinit bcap_probe(struct platform_device *pdev)
 	struct i2c_adapter *i2c_adap;
 	struct bfin_capture_config *config;
 	struct vb2_queue *q;
+	struct bcap_route *route;
 	int ret;
 
 	config = pdev->dev.platform_data;
@@ -978,6 +1065,12 @@ static int __devinit bcap_probe(struct platform_device *pdev)
 						 NULL);
 	if (bcap_dev->sd) {
 		int i;
+		if (!config->num_inputs) {
+			v4l2_err(&bcap_dev->v4l2_dev,
+					"Unable to work without input\n");
+			goto err_unreg_vdev;
+		}
+
 		/* update tvnorms from the sub devices */
 		for (i = 0; i < config->num_inputs; i++)
 			vfd->tvnorms |= config->inputs[i].std;
@@ -989,8 +1082,24 @@ static int __devinit bcap_probe(struct platform_device *pdev)
 
 	v4l2_info(&bcap_dev->v4l2_dev, "v4l2 sub device registered\n");
 
+	/*
+	 * explicitly set input, otherwise some boards
+	 * may not work at the state as we expected
+	 */
+	route = &config->routes[0];
+	ret = v4l2_subdev_call(bcap_dev->sd, video, s_routing,
+				route->input, route->output, 0);
+	if ((ret < 0) && (ret != -ENOIOCTLCMD)) {
+		v4l2_err(&bcap_dev->v4l2_dev, "Failed to set input\n");
+		goto err_unreg_vdev;
+	}
+	bcap_dev->cur_input = 0;
+	/* if this route has specific config, update ppi control */
+	if (route->ppi_control)
+		config->ppi_control = route->ppi_control;
+
 	/* now we can probe the default state */
-	if (vfd->tvnorms) {
+	if (config->inputs[0].capabilities & V4L2_IN_CAP_STD) {
 		v4l2_std_id std;
 		ret = v4l2_subdev_call(bcap_dev->sd, core, g_std, &std);
 		if (ret) {
@@ -1000,6 +1109,17 @@ static int __devinit bcap_probe(struct platform_device *pdev)
 		}
 		bcap_dev->std = std;
 	}
+	if (config->inputs[0].capabilities & V4L2_IN_CAP_CUSTOM_TIMINGS) {
+		struct v4l2_dv_timings dv_timings;
+		ret = v4l2_subdev_call(bcap_dev->sd, video,
+				g_dv_timings, &dv_timings);
+		if (ret) {
+			v4l2_err(&bcap_dev->v4l2_dev,
+					"Unable to get dv timings\n");
+			goto err_unreg_vdev;
+		}
+		bcap_dev->dv_timings = dv_timings;
+	}
 	ret = bcap_init_sensor_formats(bcap_dev);
 	if (ret) {
 		v4l2_err(&bcap_dev->v4l2_dev,
diff --git a/drivers/media/platform/blackfin/ppi.c b/drivers/media/platform/blackfin/ppi.c
index 9374d67..1e24584 100644
--- a/drivers/media/platform/blackfin/ppi.c
+++ b/drivers/media/platform/blackfin/ppi.c
@@ -68,6 +68,13 @@ static irqreturn_t ppi_irq_err(int irq, void *dev_id)
 		bfin_write16(&reg->status, 0xffff);
 		break;
 	}
+	case PPI_TYPE_EPPI3:
+	{
+		struct bfin_eppi3_regs *reg = info->base;
+
+		bfin_write32(&reg->stat, 0xc0ff);
+		break;
+	}
 	default:
 		break;
 	}
@@ -129,6 +136,12 @@ static int ppi_start(struct ppi_if *ppi)
 		bfin_write32(&reg->control, ppi->ppi_control);
 		break;
 	}
+	case PPI_TYPE_EPPI3:
+	{
+		struct bfin_eppi3_regs *reg = info->base;
+		bfin_write32(&reg->ctl, ppi->ppi_control);
+		break;
+	}
 	default:
 		return -EINVAL;
 	}
@@ -156,6 +169,12 @@ static int ppi_stop(struct ppi_if *ppi)
 		bfin_write32(&reg->control, ppi->ppi_control);
 		break;
 	}
+	case PPI_TYPE_EPPI3:
+	{
+		struct bfin_eppi3_regs *reg = info->base;
+		bfin_write32(&reg->ctl, ppi->ppi_control);
+		break;
+	}
 	default:
 		return -EINVAL;
 	}
@@ -172,17 +191,23 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 {
 	const struct ppi_info *info = ppi->info;
 	int dma32 = 0;
-	int dma_config, bytes_per_line, lines_per_frame;
+	int dma_config, bytes_per_line;
+	int hcount, hdelay, samples_per_line;
 
 	bytes_per_line = params->width * params->bpp / 8;
-	lines_per_frame = params->height;
+	/* convert parameters unit from pixels to samples */
+	hcount = params->width * params->bpp / params->dlen;
+	hdelay = params->hdelay * params->bpp / params->dlen;
+	samples_per_line = params->line * params->bpp / params->dlen;
 	if (params->int_mask == 0xFFFFFFFF)
 		ppi->err_int = false;
 	else
 		ppi->err_int = true;
 
-	dma_config = (DMA_FLOW_STOP | WNR | RESTART | DMA2D | DI_EN);
+	dma_config = (DMA_FLOW_STOP | RESTART | DMA2D | DI_EN_Y);
 	ppi->ppi_control = params->ppi_control & ~PORT_EN;
+	if (!(ppi->ppi_control & PORT_DIR))
+		dma_config |= WNR;
 	switch (info->type) {
 	case PPI_TYPE_PPI:
 	{
@@ -192,8 +217,8 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 			dma32 = 1;
 
 		bfin_write16(&reg->control, ppi->ppi_control);
-		bfin_write16(&reg->count, bytes_per_line - 1);
-		bfin_write16(&reg->frame, lines_per_frame);
+		bfin_write16(&reg->count, samples_per_line - 1);
+		bfin_write16(&reg->frame, params->frame);
 		break;
 	}
 	case PPI_TYPE_EPPI:
@@ -205,12 +230,31 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 			dma32 = 1;
 
 		bfin_write32(&reg->control, ppi->ppi_control);
-		bfin_write16(&reg->line, bytes_per_line + params->blank_clocks);
-		bfin_write16(&reg->frame, lines_per_frame);
-		bfin_write16(&reg->hdelay, 0);
-		bfin_write16(&reg->vdelay, 0);
-		bfin_write16(&reg->hcount, bytes_per_line);
-		bfin_write16(&reg->vcount, lines_per_frame);
+		bfin_write16(&reg->line, samples_per_line);
+		bfin_write16(&reg->frame, params->frame);
+		bfin_write16(&reg->hdelay, hdelay);
+		bfin_write16(&reg->vdelay, params->vdelay);
+		bfin_write16(&reg->hcount, hcount);
+		bfin_write16(&reg->vcount, params->height);
+		break;
+	}
+	case PPI_TYPE_EPPI3:
+	{
+		struct bfin_eppi3_regs *reg = info->base;
+
+		if ((params->ppi_control & PACK_EN)
+			|| (params->ppi_control & 0x70000) > DLEN_16)
+			dma32 = 1;
+
+		bfin_write32(&reg->ctl, ppi->ppi_control);
+		bfin_write32(&reg->line, samples_per_line);
+		bfin_write32(&reg->frame, params->frame);
+		bfin_write32(&reg->hdly, hdelay);
+		bfin_write32(&reg->vdly, params->vdelay);
+		bfin_write32(&reg->hcnt, hcount);
+		bfin_write32(&reg->vcnt, params->height);
+		if (params->int_mask)
+			bfin_write32(&reg->imsk, params->int_mask & 0xFF);
 		break;
 	}
 	default:
@@ -218,17 +262,17 @@ static int ppi_set_params(struct ppi_if *ppi, struct ppi_params *params)
 	}
 
 	if (dma32) {
-		dma_config |= WDSIZE_32;
+		dma_config |= WDSIZE_32 | PSIZE_32;
 		set_dma_x_count(info->dma_ch, bytes_per_line >> 2);
 		set_dma_x_modify(info->dma_ch, 4);
 		set_dma_y_modify(info->dma_ch, 4);
 	} else {
-		dma_config |= WDSIZE_16;
+		dma_config |= WDSIZE_16 | PSIZE_16;
 		set_dma_x_count(info->dma_ch, bytes_per_line >> 1);
 		set_dma_x_modify(info->dma_ch, 2);
 		set_dma_y_modify(info->dma_ch, 2);
 	}
-	set_dma_y_count(info->dma_ch, lines_per_frame);
+	set_dma_y_count(info->dma_ch, params->height);
 	set_dma_config(info->dma_ch, dma_config);
 
 	SSYNC();
diff --git a/include/media/blackfin/bfin_capture.h b/include/media/blackfin/bfin_capture.h
index 2038a8a..56b9ce4 100644
--- a/include/media/blackfin/bfin_capture.h
+++ b/include/media/blackfin/bfin_capture.h
@@ -9,6 +9,7 @@ struct ppi_info;
 struct bcap_route {
 	u32 input;
 	u32 output;
+	u32 ppi_control;
 };
 
 struct bfin_capture_config {
@@ -30,8 +31,8 @@ struct bfin_capture_config {
 	unsigned long ppi_control;
 	/* ppi interrupt mask */
 	u32 int_mask;
-	/* horizontal blanking clocks */
-	int blank_clocks;
+	/* horizontal blanking pixels */
+	int blank_pixels;
 };
 
 #endif
diff --git a/include/media/blackfin/ppi.h b/include/media/blackfin/ppi.h
index 8f72f8a..65c4675 100644
--- a/include/media/blackfin/ppi.h
+++ b/include/media/blackfin/ppi.h
@@ -21,22 +21,42 @@
 #define _PPI_H_
 
 #include <linux/interrupt.h>
+#include <asm/blackfin.h>
+#include <asm/bfin_ppi.h>
 
+/* EPPI */
 #ifdef EPPI_EN
 #define PORT_EN EPPI_EN
+#define PORT_DIR EPPI_DIR
 #define DMA32 0
 #define PACK_EN PACKEN
 #endif
 
+/* EPPI3 */
+#ifdef EPPI0_CTL2
+#define PORT_EN EPPI_CTL_EN
+#define PORT_DIR EPPI_CTL_DIR
+#define PACK_EN EPPI_CTL_PACKEN
+#define DMA32 0
+#define DLEN_8 EPPI_CTL_DLEN08
+#define DLEN_16 EPPI_CTL_DLEN16
+#endif
+
 struct ppi_if;
 
 struct ppi_params {
-	int width;
-	int height;
-	int bpp;
-	unsigned long ppi_control;
-	u32 int_mask;
-	int blank_clocks;
+	u32 width;              /* width in pixels */
+	u32 height;             /* height in lines */
+	u32 hdelay;             /* delay after the HSYNC in pixels */
+	u32 vdelay;             /* delay after the VSYNC in lines */
+	u32 line;               /* total pixels per line */
+	u32 frame;              /* total lines per frame */
+	u32 hsync;              /* HSYNC length in pixels */
+	u32 vsync;              /* VSYNC length in lines */
+	int bpp;                /* bits per pixel */
+	int dlen;               /* data length for ppi in bits */
+	u32 ppi_control;        /* ppi configuration */
+	u32 int_mask;           /* interrupt mask */
 };
 
 struct ppi_ops {
@@ -51,6 +71,7 @@ struct ppi_ops {
 enum ppi_type {
 	PPI_TYPE_PPI,
 	PPI_TYPE_EPPI,
+	PPI_TYPE_EPPI3,
 };
 
 struct ppi_info {
-- 
1.7.0.4


