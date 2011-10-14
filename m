Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:56212 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1JNWk5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 18:40:57 -0400
Date: Sat, 15 Oct 2011 01:40:46 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/1] ARM: EXYNOS4: JPEG: driver initial release
Message-ID: <20111014224046.GH10001@valkosipuli.localdomain>
References: <1318337492-21354-1-git-send-email-andrzej.p@samsung.com>
 <1318337492-21354-2-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318337492-21354-2-git-send-email-andrzej.p@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andrzej,

Thanks for the patch! Interesting to see a hardware jpeg encoder using V4L2!

I have a few comments below. As a whole, this driver looks quite good to me.

On Tue, Oct 11, 2011 at 02:51:32PM +0200, Andrzej Pietrasiewicz wrote:
> Exynos4 JPEG IP driver
> 
> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/Kconfig              |    8 +
>  drivers/media/video/Makefile             |    1 +
>  drivers/media/video/s5p-jpeg/Makefile    |    3 +
>  drivers/media/video/s5p-jpeg/jpeg-core.c | 1380 ++++++++++++++++++++++++++++++
>  drivers/media/video/s5p-jpeg/jpeg-core.h |  116 +++
>  drivers/media/video/s5p-jpeg/jpeg-hw.h   |  766 +++++++++++++++++
>  drivers/media/video/s5p-jpeg/jpeg-regs.h |  280 ++++++
>  7 files changed, 2554 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/s5p-jpeg/Makefile
>  create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.c
>  create mode 100644 drivers/media/video/s5p-jpeg/jpeg-core.h
>  create mode 100644 drivers/media/video/s5p-jpeg/jpeg-hw.h
>  create mode 100644 drivers/media/video/s5p-jpeg/jpeg-regs.h
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index ebd00cc..ca5ad2c 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1098,6 +1098,14 @@ config VIDEO_SAMSUNG_S5P_G2D
>  	  This is a v4l2 driver for Samsung S5P and EXYNOS4 G2D
>  	  2d graphics accelerator.
>  
> +config VIDEO_SAMSUNG_S5P_JPEG
> +	tristate "Samsung S5P JPEG codec driver"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	---help---
> +	  This is a v4l2 driver for Samsung S5P and EXYNOS4 JPEG codec.
> +
>  config VIDEO_SAMSUNG_S5P_MFC
>  	tristate "Samsung S5P MFC 5.1 Video Codec"
>  	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> index 8dac72b..f973001 100644
> --- a/drivers/media/video/Makefile
> +++ b/drivers/media/video/Makefile
> @@ -174,6 +174,7 @@ obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
>  obj-$(CONFIG_VIDEO_ATMEL_ISI)		+= atmel-isi.o
>  
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
>  
> diff --git a/drivers/media/video/s5p-jpeg/Makefile b/drivers/media/video/s5p-jpeg/Makefile
> new file mode 100644
> index 0000000..a96992f
> --- /dev/null
> +++ b/drivers/media/video/s5p-jpeg/Makefile
> @@ -0,0 +1,3 @@
> +
> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG) := s5p-jpeg.o
> +s5p-jpeg-y := jpeg-core.o

Is the above line required?

> diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.c b/drivers/media/video/s5p-jpeg/jpeg-core.c
> new file mode 100644
> index 0000000..5d4c4d9
> --- /dev/null
> +++ b/drivers/media/video/s5p-jpeg/jpeg-core.c
> @@ -0,0 +1,1380 @@
> +/* linux/drivers/media/video/s5p-jpeg/jpeg-core.c
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/gfp.h>
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +#include <linux/string.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/spinlock.h>
> +#include <linux/module.h>
> +#include <linux/clk.h>
> +#include <linux/pm_runtime.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "jpeg-core.h"
> +#include "jpeg-hw.h"
> +
> +#define S5P_JPEG_M2M_NAME	"s5p-jpeg"
> +
> +/* Flags that indicate a format can be used for capture/output */
> +#define MEM2MEM_CAPTURE	(1 << 0)
> +#define MEM2MEM_OUTPUT	(1 << 1)
> +
> +/* a selection of JPEG markers */
> +#define TEM  0x01
> +#define SOF0 0xc0
> +#define RST  0xd0
> +#define SOI  0xd8
> +#define EOI  0xd9
> +#define DHP  0xde
> +
> +static struct s5p_jpeg_fmt formats_enc[] = {
> +	{
> +		.name	= "YUV 4:2:0, YCbCr",
> +		.fourcc = V4L2_PIX_FMT_YUV420,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE,
> +	},
> +	{
> +		.name	= "YUV 4:2:2, YCbYCr",
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.depth	= 16,
> +		.types	= MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +	},
> +	{
> +		.name	= "RGB565",
> +		.fourcc	= V4L2_PIX_FMT_RGB565X,
> +		.depth	= 16,
> +		.types	= MEM2MEM_OUTPUT,
> +	},
> +};
> +
> +#define NUM_FORMATS_ENC ARRAY_SIZE(formats_enc)
> +
> +static struct s5p_jpeg_fmt formats_dec[] = {
> +	{
> +		.name		= "YUV 4:2:0, YCbCr",
> +		.fourcc		= V4L2_PIX_FMT_YUV420,
> +		.depth		= 16,
> +		.h_align	= 4,
> +		.v_align	= 4,
> +		.types		= MEM2MEM_CAPTURE,
> +	},
> +	{
> +		.name		= "YUV 4:2:2, YCbYCr",
> +		.fourcc		= V4L2_PIX_FMT_YUYV,
> +		.depth		= 16,
> +		.h_align	= 4,
> +		.v_align	= 3,
> +		.types		= MEM2MEM_CAPTURE,
> +	},
> +	{
> +		.name		= "JPEG JFIF",
> +		.fourcc		= V4L2_PIX_FMT_JPEG,
> +		.depth		= 0,
> +		.types		= MEM2MEM_OUTPUT,
> +	},
> +};
> +
> +#define NUM_FORMATS_DEC ARRAY_SIZE(formats_dec)
> +
> +struct s5p_jpeg_buffer {
> +	unsigned long size;
> +	unsigned long curr;
> +	unsigned long data;
> +};
> +
> +/*
> + * ============================================================================
> + * Device file operations
> + * ============================================================================
> + */
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq);
> +static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_fmt *formats,
> +						 int n, struct v4l2_format *f);
> +
> +static int s5p_jpeg_open(struct file *file)
> +{
> +	struct s5p_jpeg *jpeg = video_drvdata(file);
> +	struct video_device *vfd = video_devdata(file);
> +	struct s5p_jpeg_fmt *fmt;
> +	struct v4l2_format f;
> +	struct s5p_jpeg_ctx *ctx = NULL;

No need to initialise ctx above.

> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	file->private_data = ctx;
> +	ctx->jpeg = jpeg;
> +	if (vfd == jpeg->vfd_encoder)
> +		ctx->mode = S5P_JPEG_ENCODE;
> +	else if (vfd == jpeg->vfd_decoder)
> +		ctx->mode = S5P_JPEG_DECODE;

The second if is unnecessary.

> +	ctx->m2m_ctx = v4l2_m2m_ctx_init(jpeg->m2m_dev, ctx, queue_init);
> +	if (ctx->mode == S5P_JPEG_ENCODE) {
> +		f.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565X;
> +		fmt = s5p_jpeg_find_format(formats_enc, NUM_FORMATS_ENC, &f);
> +		ctx->out_q.fmt = fmt;

fmt is unnecessary.

> +
> +		f.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> +		fmt = s5p_jpeg_find_format(formats_enc, NUM_FORMATS_ENC, &f);
> +		ctx->cap_q.fmt = fmt;
> +	} else if (ctx->mode == S5P_JPEG_DECODE) {

Here as well.

> +		f.fmt.pix.pixelformat = V4L2_PIX_FMT_JPEG;
> +		fmt = s5p_jpeg_find_format(formats_dec, NUM_FORMATS_DEC, &f);
> +		ctx->out_q.fmt = fmt;
> +
> +		f.fmt.pix.pixelformat = V4L2_PIX_FMT_YUYV;
> +		fmt = s5p_jpeg_find_format(formats_dec, NUM_FORMATS_DEC, &f);
> +		ctx->cap_q.fmt = fmt;
> +	}
> +
> +	if (IS_ERR_OR_NULL(ctx->m2m_ctx)) {

This can and should be checked earlier on.

> +		int err = PTR_ERR(ctx->m2m_ctx);
> +		kfree(ctx);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static int s5p_jpeg_release(struct file *file)
> +{
> +	struct s5p_jpeg_ctx *ctx = file->private_data;
> +
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	kfree(ctx);
> +
> +	return 0;
> +}
> +
> +static unsigned int s5p_jpeg_poll(struct file *file,
> +				 struct poll_table_struct *wait)
> +{
> +	struct s5p_jpeg_ctx *ctx = file->private_data;
> +
> +	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +}
> +
> +static int s5p_jpeg_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct s5p_jpeg_ctx *ctx = file->private_data;
> +
> +	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +}
> +
> +static const struct v4l2_file_operations s5p_jpeg_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= s5p_jpeg_open,
> +	.release	= s5p_jpeg_release,
> +	.poll		= s5p_jpeg_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= s5p_jpeg_mmap,
> +};
> +
> +/*
> + * ============================================================================
> + * video ioctl operations
> + * ============================================================================
> + */
> +
> +static int get_byte(struct s5p_jpeg_buffer *buf)
> +{
> +	if (buf->curr >= buf->size)
> +		return -1;
> +
> +	return ((unsigned char *)buf->data)[buf->curr++];
> +}
> +
> +static unsigned int get_word_be(struct s5p_jpeg_buffer *buf)
> +{
> +	register unsigned int temp;
> +
> +	temp = (unsigned int)(get_byte(buf) << 8);

Casting won't do anything here.

> +	return (unsigned int)get_byte(buf) | temp;
> +}

Do errors returned by get_byte() get proper handling above?

> +
> +static long skip(struct s5p_jpeg_buffer *buf, long len)
> +{
> +	int c;
> +	long delta = 0;
> +
> +	while (len > 0L) {

L is unnecessary, the same goes for other uses of it.

> +		c = get_byte(buf);
> +		delta++;
> +		len--;
> +	}
> +
> +	return delta;
> +}
> +
> +static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
> +			       unsigned long buffer, unsigned long size)
> +{
> +	int c, components, notfound;
> +	unsigned int height, width;
> +	long length;
> +	long bytes_read = 0L;
> +	struct s5p_jpeg_buffer jpeg_buffer;
> +
> +	jpeg_buffer.size = size;
> +	jpeg_buffer.data = buffer;
> +	jpeg_buffer.curr = 0;
> +
> +	notfound = 1;
> +	while (notfound) {
> +		c = get_byte(&jpeg_buffer);
> +		if (c == -1)
> +			break;
> +		bytes_read++;
> +		if (c != 0xff)
> +			continue;
> +		do {
> +			c = get_byte(&jpeg_buffer);
> +			bytes_read++;
> +		} while (c == 0xff);
> +		if (c == -1)
> +			break;
> +		if (c == 0)
> +			continue;
> +		length = 0L;
> +		switch (c) {
> +		/* SOF0: baseline JPEG */
> +		case SOF0:
> +			length = (long) get_word_be(&jpeg_buffer);
> +			bytes_read += 2L;
> +			length -= 2L;
> +
> +			c = get_byte(&jpeg_buffer);
> +			if (c == -1)
> +				break;
> +			height = get_word_be(&jpeg_buffer);
> +			width = get_word_be(&jpeg_buffer);
> +			components = get_byte(&jpeg_buffer);
> +			if (components == -1)
> +				break;
> +			notfound = 0;
> +
> +			bytes_read += 6L;
> +			length -= 6L;
> +			bytes_read += skip(&jpeg_buffer, components * 3);
> +			break;

length is useless here.

> +		/* skip payload-less markers */
> +		case SOI:
> +		case RST+0:
> +		case RST+1:
> +		case RST+2:
> +		case RST+3:
> +		case RST+4:
> +		case RST+5:
> +		case RST+6:
> +		case RST+7:
> +		case EOI:
> +		case TEM:
> +			break;
> +
> +		/* skip uninteresting payload markers */
> +		default:
> +			length = (long)get_word_be(&jpeg_buffer);
> +			bytes_read += 2L;
> +			length -= 2L;
> +			bytes_read += skip(&jpeg_buffer, length);
> +			break;
> +		}
> +	}
> +	result->w = width;
> +	result->h = height;
> +	result->size = components;
> +	return !notfound;
> +}
> +
> +static int s5p_jpeg_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	if (ctx->mode == S5P_JPEG_ENCODE) {
> +		strncpy(cap->driver, S5P_JPEG_M2M_NAME " encoder",
> +			sizeof(cap->driver) - 1);

I suggest strlcpy and removeing - 1.

> +		strncpy(cap->card, S5P_JPEG_M2M_NAME " encoder",
> +			sizeof(cap->card) - 1);
> +	} else if (ctx->mode == S5P_JPEG_DECODE) {
> +		strncpy(cap->driver, S5P_JPEG_M2M_NAME " decoder",
> +			sizeof(cap->driver) - 1);
> +		strncpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
> +			sizeof(cap->card) - 1);
> +	}
> +	cap->bus_info[0] = 0;
> +	cap->version = KERNEL_VERSION(1, 0, 0);
> +	cap->capabilities = V4L2_CAP_STREAMING |
> +			    V4L2_CAP_VIDEO_CAPTURE |
> +			    V4L2_CAP_VIDEO_OUTPUT;
> +	return 0;
> +}
> +
> +static int enum_fmt(struct s5p_jpeg_fmt *formats, int n,
> +		    struct v4l2_fmtdesc *f, u32 type)
> +{
> +	int i, num;
> +	struct s5p_jpeg_fmt *fmt;
> +
> +	num = 0;
> +
> +	for (i = 0; i < n; ++i) {
> +		if (formats[i].types & type) {
> +			/* index-th format of type type found ? */
> +			if (num == f->index)
> +				break;
> +			/* Correct type but haven't reached our index yet,
> +			 * just increment per-type index */
> +			++num;
> +		}
> +	}
> +
> +	if (i < n) {

You should define fmt here.

> +		/* Format found */
> +		fmt = &formats[i];
> +		strncpy(f->description, fmt->name, sizeof(f->description) - 1);

strlcpy.

> +		f->pixelformat = fmt->fourcc;
> +		return 0;
> +	}
> +
> +	/* Format not found */
> +	return -EINVAL;
> +}
> +
> +static int s5p_jpeg_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	struct s5p_jpeg_ctx *ctx;
> +
> +	ctx = priv;
> +
> +	if (ctx->mode == S5P_JPEG_ENCODE)
> +		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
> +				MEM2MEM_CAPTURE);
> +
> +	return enum_fmt(formats_dec, NUM_FORMATS_DEC, f, MEM2MEM_CAPTURE);
> +}
> +
> +static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	struct s5p_jpeg_ctx *ctx;
> +
> +	ctx = priv;
> +
> +	if (ctx->mode == S5P_JPEG_ENCODE)
> +		return enum_fmt(formats_enc, NUM_FORMATS_ENC, f,
> +				MEM2MEM_OUTPUT);
> +
> +	return enum_fmt(formats_dec, NUM_FORMATS_DEC, f, MEM2MEM_OUTPUT);
> +}
> +
> +static int vidioc_g_fmt(struct s5p_jpeg_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct s5p_jpeg_q_data *q_data;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	switch (f->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		q_data = &ctx->out_q;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		if (ctx->mode == S5P_JPEG_DECODE && !ctx->hdr_parsed)
> +			return -EINVAL;
> +		q_data = &ctx->cap_q;
> +		break;
> +	default:
> +		BUG();
> +	}
> +	f->fmt.pix.width	= q_data->w;
> +	f->fmt.pix.height	= q_data->h;
> +	f->fmt.pix.field	= V4L2_FIELD_NONE;
> +	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
> +	if (V4L2_PIX_FMT_JPEG != q_data->fmt->fourcc)
> +		f->fmt.pix.bytesperline	= (q_data->w * q_data->fmt->depth) >> 3;
> +	else
> +		f->fmt.pix.bytesperline	= 0;
> +	f->fmt.pix.sizeimage	= q_data->size;
> +
> +	return 0;
> +}
> +
> +static int s5p_jpeg_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(priv, f);
> +}
> +
> +static int s5p_jpeg_g_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(priv, f);
> +}
> +
> +static struct s5p_jpeg_fmt *s5p_jpeg_find_format(struct s5p_jpeg_fmt *formats,
> +						 int n, struct v4l2_format *f)
> +{
> +	struct s5p_jpeg_fmt *fmt;
> +	unsigned int k;
> +	for (k = 0; k < n; k++) {

You can define fmt here.

> +		fmt = &formats[k];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)

If you're only interested in pixelformat then you should pass that to the
function, not v4l2_format.

> +			break;

And return fmt here instead of break.

> +	}
> +
> +	if (k == n)
> +		return NULL;
> +
> +	return &formats[k];
> +}
> +
> +static void jpeg_bound_align_image(u32 *w, unsigned int wmin, unsigned int wmax,
> +				   unsigned int walign,
> +				   u32 *h, unsigned int hmin, unsigned int hmax,
> +				   unsigned int halign)
> +{
> +	int width, height, w_step, h_step;
> +
> +	width = *w;
> +	height = *h;
> +
> +	w_step = 1 << walign;
> +	h_step = 1 << halign;
> +	v4l_bound_align_image(w, wmin, wmax, walign, h, hmin, hmax, halign, 0);
> +
> +	if (*w < width && (*w + w_step) < wmax)
> +		*w += w_step;
> +	if (*h < height && (*h + h_step) < hmax)
> +		*h += h_step;
> +
> +}
> +
> +static int vidioc_try_fmt(struct v4l2_format *f, struct s5p_jpeg_fmt *fmt,
> +			  struct s5p_jpeg_ctx *ctx, int q_type)
> +{
> +	enum v4l2_field field;
> +
> +	field = f->fmt.pix.field;
> +
> +	if (field == V4L2_FIELD_ANY)
> +		field = V4L2_FIELD_NONE;
> +	else if (V4L2_FIELD_NONE != field)
> +		return -EINVAL;
> +
> +	/* V4L2 specification suggests the driver corrects the format struct
> +	 * if any of the dimensions is unsupported */
> +	f->fmt.pix.field = field;
> +
> +	if (q_type == MEM2MEM_OUTPUT)
> +		jpeg_bound_align_image(&f->fmt.pix.width, S5P_JPEG_MIN_WIDTH,
> +				       S5P_JPEG_MAX_WIDTH, 0,
> +				       &f->fmt.pix.height, S5P_JPEG_MIN_HEIGHT,
> +				       S5P_JPEG_MAX_HEIGHT, 0);
> +	else
> +		jpeg_bound_align_image(&f->fmt.pix.width, S5P_JPEG_MIN_WIDTH,
> +				       S5P_JPEG_MAX_WIDTH, fmt->h_align,
> +				       &f->fmt.pix.height, S5P_JPEG_MIN_HEIGHT,
> +				       S5P_JPEG_MAX_HEIGHT, fmt->v_align);
> +
> +	if (fmt->fourcc == V4L2_PIX_FMT_JPEG) {
> +		if (f->fmt.pix.sizeimage <= 0)
> +			return -EINVAL;
> +		f->fmt.pix.bytesperline = 0;
> +	} else {
> +		f->fmt.pix.bytesperline = (f->fmt.pix.width * fmt->depth) >> 3;
> +		f->fmt.pix.sizeimage = f->fmt.pix.height *
> +				       f->fmt.pix.bytesperline;
> +	}
> +
> +	return 0;
> +}
> +
> +static int s5p_jpeg_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct s5p_jpeg_fmt *fmt;
> +	struct s5p_jpeg_ctx *ctx = priv;
> +	if (ctx->mode == S5P_JPEG_ENCODE)
> +

I suggest no empty line above.

> +		fmt = s5p_jpeg_find_format(formats_enc, NUM_FORMATS_ENC, f);
> +	else
> +		fmt = s5p_jpeg_find_format(formats_dec, NUM_FORMATS_DEC, f);
> +	if (!fmt || !(fmt->types & MEM2MEM_CAPTURE)) {
> +		v4l2_err(&ctx->jpeg->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return vidioc_try_fmt(f, fmt, ctx, MEM2MEM_CAPTURE);
> +}
> +
> +static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct s5p_jpeg_fmt *fmt;
> +	struct s5p_jpeg_ctx *ctx = priv;
> +	if (ctx->mode == S5P_JPEG_ENCODE)
> +		fmt = s5p_jpeg_find_format(formats_enc, NUM_FORMATS_ENC, f);
> +	else
> +		fmt = s5p_jpeg_find_format(formats_dec, NUM_FORMATS_DEC, f);
> +	if (!fmt || !(fmt->types & MEM2MEM_OUTPUT)) {
> +		v4l2_err(&ctx->jpeg->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return vidioc_try_fmt(f, fmt, ctx, MEM2MEM_OUTPUT);
> +}
> +
> +static int vidioc_s_fmt(struct s5p_jpeg_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct s5p_jpeg_q_data *q_data;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	switch (f->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		q_data = &ctx->out_q;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		q_data = &ctx->cap_q;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&ctx->jpeg->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	if (ctx->mode == S5P_JPEG_ENCODE)
> +		q_data->fmt = s5p_jpeg_find_format(formats_enc,
> +						   NUM_FORMATS_ENC, f);
> +	else
> +		q_data->fmt = s5p_jpeg_find_format(formats_dec,
> +						   NUM_FORMATS_DEC, f);
> +	q_data->w = f->fmt.pix.width;
> +	q_data->h = f->fmt.pix.height;
> +	if (V4L2_PIX_FMT_JPEG != q_data->fmt->fourcc)
> +		q_data->size = q_data->w * q_data->h * q_data->fmt->depth >> 3;
> +	else
> +		q_data->size = f->fmt.pix.sizeimage;
> +
> +	return 0;
> +}
> +
> +static int s5p_jpeg_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	int ret;
> +
> +	ret = s5p_jpeg_try_fmt_vid_cap(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	return vidioc_s_fmt(priv, f);
> +}
> +
> +static int s5p_jpeg_s_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	int ret;
> +
> +	ret = s5p_jpeg_try_fmt_vid_out(file, priv, f);
> +	if (ret)
> +		return ret;
> +
> +	return vidioc_s_fmt(priv, f);
> +}
> +
> +static int s5p_jpeg_reqbufs(struct file *file, void *priv,
> +			  struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> +}
> +
> +static int s5p_jpeg_querybuf(struct file *file, void *priv,
> +			   struct v4l2_buffer *buf)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int s5p_jpeg_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int s5p_jpeg_dqbuf(struct file *file, void *priv,
> +			  struct v4l2_buffer *buf)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int s5p_jpeg_streamon(struct file *file, void *priv,
> +			   enum v4l2_buf_type type)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> +}
> +
> +static int s5p_jpeg_streamoff(struct file *file, void *priv,
> +			    enum v4l2_buf_type type)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> +}
> +
> +int s5p_jpeg_g_selection(struct file *file, void *priv,
> +			 struct v4l2_selection *s)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	switch (s->target) {
> +	case V4L2_SEL_COMPOSE_ACTIVE:
> +	case V4L2_SEL_CROP_ACTIVE:
> +		s->r.width = ctx->out_q.w;
> +		s->r.height = ctx->out_q.h;
> +		break;
> +	case V4L2_SEL_CROP_DEFAULT:
> +	case V4L2_SEL_CROP_BOUNDS:
> +	case V4L2_SEL_COMPOSE_DEFAULT:
> +	case V4L2_SEL_COMPOSE_BOUNDS:
> +	case V4L2_SEL_COMPOSE_PADDED:
> +		s->r.width = ctx->cap_q.w;
> +		s->r.height = ctx->cap_q.w;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	s->r.left = 0;
> +	s->r.top = 0;
> +	return 0;
> +}
> +
> +static int s5p_jpeg_g_jpegcomp(struct file *file, void *priv,
> +			       struct v4l2_jpegcompression *compr)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	if (ctx->mode == S5P_JPEG_DECODE)
> +		return -ENOTTY;
> +
> +	memset(compr, 0, sizeof(*compr));
> +	compr->quality = ctx->compr_quality;
> +
> +	return 0;
> +}
> +
> +static int s5p_jpeg_s_jpegcomp(struct file *file, void *priv,
> +			       struct v4l2_jpegcompression *compr)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	if (ctx->mode == S5P_JPEG_DECODE)
> +		return -ENOTTY;
> +
> +	if (compr->quality < S5P_JPEG_COMPR_QUAL_BEST ||
> +	    compr->quality > S5P_JPEG_COMPR_QUAL_WORST)
> +		return -EINVAL;

Would it make sense to clamp the value rather than return an error?

> +	ctx->compr_quality = compr->quality;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops s5p_jpeg_ioctl_ops = {
> +	.vidioc_querycap		= s5p_jpeg_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap	= s5p_jpeg_enum_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_out	= s5p_jpeg_enum_fmt_vid_out,
> +
> +	.vidioc_g_fmt_vid_cap		= s5p_jpeg_g_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_out		= s5p_jpeg_g_fmt_vid_out,
> +
> +	.vidioc_try_fmt_vid_cap		= s5p_jpeg_try_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_out		= s5p_jpeg_try_fmt_vid_out,
> +
> +	.vidioc_s_fmt_vid_cap		= s5p_jpeg_s_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_out		= s5p_jpeg_s_fmt_vid_out,
> +
> +	.vidioc_reqbufs			= s5p_jpeg_reqbufs,
> +	.vidioc_querybuf		= s5p_jpeg_querybuf,
> +
> +	.vidioc_qbuf			= s5p_jpeg_qbuf,
> +	.vidioc_dqbuf			= s5p_jpeg_dqbuf,
> +
> +	.vidioc_streamon		= s5p_jpeg_streamon,
> +	.vidioc_streamoff		= s5p_jpeg_streamoff,
> +
> +	.vidioc_g_selection		= s5p_jpeg_g_selection,
> +
> +	.vidioc_g_jpegcomp		= s5p_jpeg_g_jpegcomp,
> +	.vidioc_s_jpegcomp		= s5p_jpeg_s_jpegcomp,
> +};
> +
> +/*
> + * ============================================================================
> + * mem2mem callbacks
> + * ============================================================================
> + */
> +
> +static void s5p_jpeg_device_run(void *priv)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +	struct s5p_jpeg *jpeg = ctx->jpeg;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned long src_addr, dst_addr;
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	src_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	dst_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +
> +	pm_runtime_get_sync(jpeg->dev);
> +
> +	jpeg_reset(jpeg->regs);
> +	jpeg_poweron(jpeg->regs);
> +	jpeg_proc_mode(jpeg->regs, ctx->mode);
> +	if (ctx->mode == S5P_JPEG_ENCODE) {
> +		if (ctx->out_q.fmt->fourcc == V4L2_PIX_FMT_RGB565X)
> +			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_565);
> +		else
> +			jpeg_input_raw_mode(jpeg->regs, S5P_JPEG_RAW_IN_422);
> +		if (ctx->cap_q.fmt->fourcc == V4L2_PIX_FMT_YUYV)
> +			jpeg_subsampling_mode(jpeg->regs,
> +					      S5P_JPEG_SUBSAMPLING_422);
> +		else
> +			jpeg_subsampling_mode(jpeg->regs,
> +					      S5P_JPEG_SUBSAMPLING_420);
> +		jpeg_dri(jpeg->regs, 0);
> +		jpeg_x(jpeg->regs, ctx->out_q.w);
> +		jpeg_y(jpeg->regs, ctx->out_q.h);
> +		jpeg_imgadr(jpeg->regs, src_addr);
> +		jpeg_jpgadr(jpeg->regs, dst_addr);
> +
> +		/* ultimately comes from sizeimage from userspace */
> +		jpeg_enc_stream_int(jpeg->regs, ctx->cap_q.size);
> +
> +		/* JPEG RGB to YCbCr conversion matrix */
> +		jpeg_coef11(jpeg->regs, S5P_JPEG_COEF11);
> +		jpeg_coef12(jpeg->regs, S5P_JPEG_COEF12);
> +		jpeg_coef13(jpeg->regs, S5P_JPEG_COEF13);
> +		jpeg_coef21(jpeg->regs, S5P_JPEG_COEF21);
> +		jpeg_coef22(jpeg->regs, S5P_JPEG_COEF22);
> +		jpeg_coef23(jpeg->regs, S5P_JPEG_COEF23);
> +		jpeg_coef31(jpeg->regs, S5P_JPEG_COEF31);
> +		jpeg_coef32(jpeg->regs, S5P_JPEG_COEF32);
> +		jpeg_coef33(jpeg->regs, S5P_JPEG_COEF33);
> +
> +		/*
> +		 * JPEG IP allows storing 4 quantization tables
> +		 * We fill table 0 for luma and table 1 for chroma
> +		 */
> +		jpeg_set_qtbl_lum(jpeg->regs, 0, ctx->compr_quality);
> +		jpeg_set_qtbl_chr(jpeg->regs, 1, ctx->compr_quality);
> +		/* use table 0 for Y */
> +		jpeg_qtbl1(jpeg->regs, 0);
> +		/* use table 1 for Cb and Cr*/
> +		jpeg_qtbl2(jpeg->regs, 1);
> +		jpeg_qtbl3(jpeg->regs, 1);
> +
> +		/* Y, Cb, Cr use Huffman table 0 */
> +		jpeg_htbl1_ac(jpeg->regs, 0);
> +		jpeg_htbl1_dc(jpeg->regs, 0);
> +		jpeg_htbl2_ac(jpeg->regs, 0);
> +		jpeg_htbl2_dc(jpeg->regs, 0);
> +		jpeg_htbl3_ac(jpeg->regs, 0);
> +		jpeg_htbl3_dc(jpeg->regs, 0);
> +	} else {
> +		jpeg_rst_int_enable(jpeg->regs, true);
> +		jpeg_data_num_int_enable(jpeg->regs, true);
> +		jpeg_final_mcu_num_int_enable(jpeg->regs, true);
> +		jpeg_outform_raw(jpeg->regs, S5P_JPEG_RAW_OUT_422);
> +		jpeg_jpgadr(jpeg->regs, src_addr);
> +		jpeg_imgadr(jpeg->regs, dst_addr);
> +	}
> +	jpeg_start(jpeg->regs);
> +}
> +
> +static int s5p_jpeg_job_ready(void *priv)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +
> +	if (ctx->mode == S5P_JPEG_DECODE)
> +		return ctx->hdr_parsed;
> +	return 1;
> +}
> +
> +static void s5p_jpeg_job_abort(void *priv)
> +{
> +}
> +
> +static struct v4l2_m2m_ops s5p_jpeg_m2m_ops = {
> +	.device_run	= s5p_jpeg_device_run,
> +	.job_ready	= s5p_jpeg_job_ready,
> +	.job_abort	= s5p_jpeg_job_abort,
> +};
> +
> +/*
> + * ============================================================================
> + * Queue operations
> + * ============================================================================
> + */
> +
> +static int s5p_jpeg_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +				unsigned int *nplanes, unsigned int sizes[],
> +				void *alloc_ctxs[])
> +{
> +	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
> +	struct s5p_jpeg_q_data *q_data;
> +	unsigned int size, count = *nbuffers;
> +
> +	switch (vq->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		q_data = &ctx->out_q;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		q_data = &ctx->cap_q;
> +		break;
> +	default:
> +		BUG();
> +	}
> +
> +	size = q_data->size;
> +
> +	/*
> +	 * header is parsed during decoding and parsed information stored
> +	 * in the context so we do not allow another buffer to overwrite it
> +	 */
> +	if (ctx->mode == S5P_JPEG_DECODE)
> +		count = 1;
> +
> +	*nbuffers = count;
> +	*nplanes = 1;
> +	sizes[0] = size;
> +	alloc_ctxs[0] = ctx->jpeg->alloc_ctx;
> +
> +	return 0;
> +}
> +
> +static int s5p_jpeg_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct s5p_jpeg_q_data *q_data;
> +
> +	switch (vb->vb2_queue->type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		q_data = &ctx->out_q;
> +		break;
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		q_data = &ctx->cap_q;
> +		break;
> +	default:
> +		BUG();
> +	}
> +	if (vb2_plane_size(vb, 0) < q_data->size) {
> +		printk(KERN_ERR "%s data will not fit into plane (%lu < %lu)\n",
> +				__func__, vb2_plane_size(vb, 0),
> +				(long)q_data->size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, q_data->size);
> +
> +	return 0;
> +}
> +
> +static void s5p_jpeg_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +
> +	if (ctx->mode == S5P_JPEG_DECODE &&
> +	    vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		struct s5p_jpeg_q_data tmp;
> +		ctx->hdr_parsed = s5p_jpeg_parse_hdr(&tmp,
> +		     (unsigned long)vb2_plane_vaddr(vb, 0),
> +		     ctx->out_q.size);
> +		if (ctx->hdr_parsed) {
> +			struct s5p_jpeg_q_data *q_data;
> +
> +			q_data = &ctx->out_q;
> +			q_data->w = tmp.w;
> +			q_data->h = tmp.h;
> +
> +			q_data = &ctx->cap_q;
> +			q_data->w = tmp.w;
> +			q_data->h = tmp.h;
> +
> +			jpeg_bound_align_image(&q_data->w,
> +					       S5P_JPEG_MIN_WIDTH,
> +					       S5P_JPEG_MAX_WIDTH,
> +					       q_data->fmt->h_align,
> +					       &q_data->h,
> +					       S5P_JPEG_MIN_HEIGHT,
> +					       S5P_JPEG_MAX_HEIGHT,
> +					       q_data->fmt->v_align);
> +			ctx->parsed_w = tmp.w;
> +			ctx->parsed_h = tmp.h;
> +		}
> +	}
> +	if (ctx->m2m_ctx)
> +		v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> +}
> +
> +static void s5p_jpeg_wait_prepare(struct vb2_queue *vq)
> +{
> +	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
> +
> +	mutex_unlock(&ctx->jpeg->lock);
> +}
> +
> +static void s5p_jpeg_wait_finish(struct vb2_queue *vq)
> +{
> +	struct s5p_jpeg_ctx *ctx = vb2_get_drv_priv(vq);
> +
> +	mutex_lock(&ctx->jpeg->lock);
> +}
> +
> +static struct vb2_ops s5p_jpeg_qops = {
> +	.queue_setup		= s5p_jpeg_queue_setup,
> +	.buf_prepare		= s5p_jpeg_buf_prepare,
> +	.buf_queue		= s5p_jpeg_buf_queue,
> +	.wait_prepare		= s5p_jpeg_wait_prepare,
> +	.wait_finish		= s5p_jpeg_wait_finish,
> +};
> +
> +static int queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct s5p_jpeg_ctx *ctx = priv;
> +	int ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	src_vq->ops = &s5p_jpeg_qops;
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP | VB2_USERPTR;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	dst_vq->ops = &s5p_jpeg_qops;
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +/*
> + * ============================================================================
> + * ISR
> + * ============================================================================
> + */
> +
> +static irqreturn_t s5p_jpeg_irq(int irq, void *dev_id)
> +{
> +	struct s5p_jpeg *jpeg = dev_id;
> +	struct s5p_jpeg_ctx *curr_ctx;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	unsigned long payload_size = 0;
> +	enum vb2_buffer_state state = VB2_BUF_STATE_DONE;
> +	bool enc_jpeg_too_large = false;
> +	bool timer_elapsed = false;
> +	bool op_completed = false;
> +
> +	curr_ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
> +
> +	src_buf = v4l2_m2m_src_buf_remove(curr_ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_dst_buf_remove(curr_ctx->m2m_ctx);
> +
> +	if (curr_ctx->mode == S5P_JPEG_ENCODE)
> +		enc_jpeg_too_large = jpeg_enc_stream_stat(jpeg->regs);
> +	timer_elapsed = jpeg_timer_stat(jpeg->regs);
> +	op_completed = jpeg_result_stat_ok(jpeg->regs);
> +	if (curr_ctx->mode == S5P_JPEG_DECODE)
> +		op_completed = op_completed && jpeg_stream_stat_ok(jpeg->regs);
> +
> +	if (enc_jpeg_too_large) {
> +		state = VB2_BUF_STATE_ERROR;
> +		jpeg_clear_enc_stream_stat(jpeg->regs);
> +	} else if (timer_elapsed) {
> +		state = VB2_BUF_STATE_ERROR;
> +		jpeg_clear_timer_stat(jpeg->regs);
> +	} else if (!op_completed) {
> +		state = VB2_BUF_STATE_ERROR;
> +	} else {
> +		payload_size = jpeg_compressed_size(jpeg->regs);
> +	}
> +
> +	v4l2_m2m_buf_done(src_buf, state);
> +	if (curr_ctx->mode == S5P_JPEG_ENCODE)
> +		vb2_set_plane_payload(dst_buf, 0, payload_size);
> +	v4l2_m2m_buf_done(dst_buf, state);
> +	v4l2_m2m_job_finish(jpeg->m2m_dev, curr_ctx->m2m_ctx);
> +
> +	jpeg_clear_int(jpeg->regs);
> +
> +	pm_runtime_put_sync(jpeg->dev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +/*
> + * ============================================================================
> + * Driver basic infrastructure
> + * ============================================================================
> + */
> +
> +static struct video_device s5p_jpeg_videodev = {
> +	.name		= S5P_JPEG_M2M_NAME,
> +	.fops		= &s5p_jpeg_fops,
> +	.ioctl_ops	= &s5p_jpeg_ioctl_ops,
> +	.minor		= -1,
> +	.release	= video_device_release,
> +};
> +
> +static int s5p_jpeg_probe(struct platform_device *pdev)
> +{
> +	struct s5p_jpeg *jpeg;
> +	struct resource *res;
> +	int ret;
> +
> +	/* JPEG IP abstraction struct */
> +	jpeg = kzalloc(sizeof(struct s5p_jpeg), GFP_KERNEL);
> +	if (!jpeg) {
> +		dev_err(&pdev->dev, "no memory for state\n");
> +		return -ENOMEM;
> +	}
> +	mutex_init(&jpeg->lock);
> +	jpeg->dev = &pdev->dev;
> +
> +	/* memory-mapped registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (NULL == res) {
> +		dev_err(&pdev->dev, "cannot find IO resource\n");
> +		ret = -ENOENT;
> +		goto jpeg_alloc_rollback;
> +	}
> +
> +	jpeg->ioarea = request_mem_region(res->start, resource_size(res),
> +					  pdev->name);
> +
> +	if (NULL == jpeg->ioarea) {
> +		dev_err(&pdev->dev, "cannot request IO\n");
> +		ret = -ENXIO;
> +		goto jpeg_alloc_rollback;
> +	}
> +
> +	jpeg->regs = ioremap(res->start, resource_size(res));
> +
> +	if (NULL == jpeg->regs) {
> +		dev_err(&pdev->dev, "cannot map IO\n");
> +		ret = -ENXIO;
> +		goto mem_region_rollback;
> +	}
> +
> +	dev_dbg(&pdev->dev, "registers %p (%p, %p)\n",
> +		jpeg->regs, jpeg->ioarea, res);
> +
> +	/* interrupt service routine registration */
> +	jpeg->irq = ret = platform_get_irq(pdev, 0);
> +	if (ret <= 0) {
> +		dev_err(&pdev->dev, "cannot find IRQ\n");
> +		goto ioremap_rollback;
> +	}
> +
> +	ret = request_irq(jpeg->irq, s5p_jpeg_irq, 0,
> +			  dev_name(&pdev->dev), jpeg);
> +
> +	if (ret != 0) {
> +		dev_err(&pdev->dev, "cannot claim IRQ %d\n", jpeg->irq);
> +		goto ioremap_rollback;
> +	}
> +
> +	/* clocks */
> +	jpeg->clk = clk_get(&pdev->dev, "jpeg");
> +	if (IS_ERR_OR_NULL(jpeg->clk)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		ret = -ENOENT;
> +		goto request_irq_rollback;
> +	}
> +	dev_dbg(&pdev->dev, "clock source %p\n", jpeg->clk);
> +	clk_enable(jpeg->clk);
> +
> +	/* v4l2 device */
> +	ret = v4l2_device_register(&pdev->dev, &jpeg->v4l2_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to register v4l2 device\n");
> +		goto clk_get_rollback;
> +	}
> +
> +	/* JPEG encoder /dev/videoX node */
> +	jpeg->vfd_encoder = video_device_alloc();
> +	if (!jpeg->vfd_encoder) {
> +		v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto device_register_rollback;
> +	}
> +	*(jpeg->vfd_encoder) = s5p_jpeg_videodev;

No parenthesis required.

> +	jpeg->vfd_encoder->lock = &jpeg->lock;
> +
> +	ret = video_register_device(jpeg->vfd_encoder, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
> +		goto enc_vdev_alloc_rollback;
> +	}
> +
> +	video_set_drvdata(jpeg->vfd_encoder, jpeg);
> +	v4l2_info(&jpeg->v4l2_dev, S5P_JPEG_M2M_NAME
> +		  " encoder device registered as /dev/video%d\n",
> +		  jpeg->vfd_encoder->num);
> +
> +	/* JPEG decoder /dev/videoX node */
> +	jpeg->vfd_decoder = video_device_alloc();
> +	if (!jpeg->vfd_decoder) {
> +		v4l2_err(&jpeg->v4l2_dev, "Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto enc_vdev_register_rollback;
> +	}
> +	*(jpeg->vfd_decoder) = s5p_jpeg_videodev;

Same here.

> +	jpeg->vfd_decoder->lock = &jpeg->lock;
> +
> +	ret = video_register_device(jpeg->vfd_decoder, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		v4l2_err(&jpeg->v4l2_dev, "Failed to register video device\n");
> +		goto dec_vdev_alloc_rollback;
> +	}
> +
> +	video_set_drvdata(jpeg->vfd_decoder, jpeg);
> +	v4l2_info(&jpeg->v4l2_dev, S5P_JPEG_M2M_NAME
> +		  " decoder device registered as /dev/video%d\n",
> +		  jpeg->vfd_decoder->num);
> +
> +	/* mem2mem device */
> +	jpeg->m2m_dev = v4l2_m2m_init(&s5p_jpeg_m2m_ops);
> +	if (IS_ERR_OR_NULL(jpeg->m2m_dev)) {
> +		v4l2_err(&jpeg->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(jpeg->m2m_dev);
> +		goto dec_vdev_register_rollback;
> +	}
> +
> +	jpeg->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR_OR_NULL(jpeg->alloc_ctx)) {
> +		v4l2_err(&jpeg->v4l2_dev, "Failed to init memory allocator\n");
> +		ret = PTR_ERR(jpeg->alloc_ctx);
> +		goto m2m_init_rollback;
> +	}
> +
> +	/* final statements & power management */
> +	platform_set_drvdata(pdev, jpeg);
> +
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	dev_info(&pdev->dev, "Samsung S5P JPEG codec\n");
> +
> +	return 0;
> +
> +	/* vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx); */

I wonder if this is leftover from something. :)

> +m2m_init_rollback:
> +	v4l2_m2m_release(jpeg->m2m_dev);
> +
> +dec_vdev_register_rollback:
> +	video_unregister_device(jpeg->vfd_decoder);
> +
> +dec_vdev_alloc_rollback:
> +	video_device_release(jpeg->vfd_decoder);
> +
> +enc_vdev_register_rollback:
> +	video_unregister_device(jpeg->vfd_encoder);
> +
> +enc_vdev_alloc_rollback:
> +	video_device_release(jpeg->vfd_encoder);

You don't need that many labels. video_device_release and
video_unregister_device can be safely called if the corresponding setup
function failed.

Not sure if removing them now makes the code more readable, though.

> +device_register_rollback:
> +	v4l2_device_unregister(&jpeg->v4l2_dev);
> +
> +clk_get_rollback:
> +	clk_disable(jpeg->clk);
> +	clk_put(jpeg->clk);
> +
> +request_irq_rollback:
> +	free_irq(jpeg->irq, jpeg);
> +
> +ioremap_rollback:
> +	iounmap(jpeg->regs);
> +
> +mem_region_rollback:
> +	release_resource(jpeg->ioarea);
> +	kfree(jpeg->ioarea);
> +
> +jpeg_alloc_rollback:
> +	kfree(jpeg);
> +	return ret;
> +}
> +
> +static int s5p_jpeg_remove(struct platform_device *pdev)
> +{
> +	struct s5p_jpeg *jpeg = platform_get_drvdata(pdev);
> +
> +	pm_runtime_disable(jpeg->dev);
> +
> +	vb2_dma_contig_cleanup_ctx(jpeg->alloc_ctx);
> +	v4l2_m2m_release(jpeg->m2m_dev);
> +	video_unregister_device(jpeg->vfd_decoder);
> +	video_device_release(jpeg->vfd_decoder);
> +	video_unregister_device(jpeg->vfd_encoder);
> +	video_device_release(jpeg->vfd_encoder);
> +	v4l2_device_unregister(&jpeg->v4l2_dev);
> +
> +	clk_disable(jpeg->clk);
> +	clk_put(jpeg->clk);
> +
> +	free_irq(jpeg->irq, jpeg);
> +
> +	iounmap(jpeg->regs);
> +
> +	release_resource(jpeg->ioarea);
> +	kfree(jpeg->ioarea);
> +	kfree(jpeg);
> +
> +	return 0;
> +}
> +
> +static int
> +s5p_jpeg_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	int ret = 0;
> +
> +	return ret;
> +}

You may just return 0.

> +static int s5p_jpeg_resume(struct platform_device *pdev)
> +{
> +	int ret = 0;
> +
> +	return ret;
> +}
> +
> +static int s5p_jpeg_runtime_suspend(struct device *dev)
> +{
> +	return 0;
> +}
> +
> +static int s5p_jpeg_runtime_resume(struct device *dev)
> +{
> +	struct platform_device *pdev;
> +	struct s5p_jpeg *jpeg;
> +
> +	pdev = container_of(dev, struct platform_device, dev);
> +	jpeg = platform_get_drvdata(pdev);
> +	/*
> +	 * JPEG IP allows storing two Huffman tables for each component
> +	 * We fill table 0 for each component
> +	 */
> +	jpeg_set_hdctbl(jpeg->regs, 0);
> +	jpeg_set_hdctblg(jpeg->regs, 0);
> +	jpeg_set_hactbl(jpeg->regs, 0);
> +	jpeg_set_hactblg(jpeg->regs, 0);
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops s5p_jpeg_pm_ops = {
> +	.runtime_suspend = s5p_jpeg_runtime_suspend,
> +	.runtime_resume	 = s5p_jpeg_runtime_resume,
> +};
> +
> +static struct platform_driver s5p_jpeg_driver = {
> +	.probe = s5p_jpeg_probe,
> +	.remove = s5p_jpeg_remove,
> +	.suspend = s5p_jpeg_suspend,
> +	.resume = s5p_jpeg_resume,
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.name = S5P_JPEG_M2M_NAME,
> +		.pm = &s5p_jpeg_pm_ops,
> +	},
> +};
> +
> +static int __init
> +s5p_jpeg_register(void)
> +{
> +	int ret;
> +
> +	printk(KERN_INFO "S5P JPEG V4L2 Driver, (c) 2011 Samsung Electronics\n");
> +
> +	ret = platform_driver_register(&s5p_jpeg_driver);
> +
> +	if (ret) {
> +		printk(KERN_ERR
> +			"%s: failed to register jpeg driver\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	return ret;
> +}
> +
> +static void __exit
> +s5p_jpeg_unregister(void)
> +{
> +	platform_driver_unregister(&s5p_jpeg_driver);
> +}
> +
> +module_init(s5p_jpeg_register);
> +module_exit(s5p_jpeg_unregister);
> +
> +MODULE_AUTHOR("Andrzej Pietrasiewicz <andrzej.p@samsung.com>");
> +MODULE_DESCRIPTION("Samsung JPEG codec driver");
> +MODULE_LICENSE("GPL");
> +
> diff --git a/drivers/media/video/s5p-jpeg/jpeg-core.h b/drivers/media/video/s5p-jpeg/jpeg-core.h
> new file mode 100644
> index 0000000..ed3d66f
> --- /dev/null
> +++ b/drivers/media/video/s5p-jpeg/jpeg-core.h
> @@ -0,0 +1,116 @@
> +/* linux/drivers/media/video/s5p-jpeg/jpeg-core.h
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef JPEG_CORE_H_
> +#define JPEG_CORE_H_
> +
> +#include <media/v4l2-device.h>
> +
> +#define S5P_JPEG_COMPR_QUAL_BEST	0
> +#define S5P_JPEG_COMPR_QUAL_WORST	3
> +#define S5P_JPEG_COEF11			0x4D
> +#define S5P_JPEG_COEF12			0x97
> +#define S5P_JPEG_COEF13			0x1E
> +#define S5P_JPEG_COEF21			0x2C
> +#define S5P_JPEG_COEF22			0x57
> +#define S5P_JPEG_COEF23			0x83
> +#define S5P_JPEG_COEF31			0x83
> +#define S5P_JPEG_COEF32			0x6e
> +#define S5P_JPEG_COEF33			0x13
> +
> +/**
> + * struct s5p_jpeg - JPEG IP abstraction
> + * @lock:		the mutex protecting this structure
> + * @v4l2_dev:		v4l2 device for mem2mem mode
> + * @vfd_encoder:	video device node for encoder mem2mem mode
> + * @vfd_decoder:	video device node for decoder mem2mem mode
> + * @m2m_dev:		v4l2 mem2mem device data
> + * @ioarea:		JPEG IP memory region
> + * @regs:		JPEG IP registers mapping
> + * @irq:		JPEG IP irq
> + * @clk:		JPEG IP clock
> + * @dev:		JPEG IP struct device
> + * @alloc_ctx:		videobuf2 memory allocator's context
> + */
> +struct s5p_jpeg {
> +	struct mutex		lock;
> +
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	*vfd_encoder;
> +	struct video_device	*vfd_decoder;
> +	struct v4l2_m2m_dev	*m2m_dev;
> +
> +	struct resource		*ioarea;
> +	void __iomem		*regs;
> +	unsigned int		irq;
> +	struct clk		*clk;
> +	struct device		*dev;
> +	void			*alloc_ctx;
> +};
> +
> +/**
> + * struct jpeg_fmt - driver's internal color format data
> + * @name:	format descritpion
> + * @fourcc:	the fourcc code, 0 if not applicable
> + * @depth:	number of bits per pixel
> + * @h_align:	horizontal alignment order (align to 2^h_align)
> + * @v_align:	vertical alignment order (align to 2^v_align)
> + * @types:	types of queue this format is applicable to
> + */
> +struct s5p_jpeg_fmt {
> +	char	*name;
> +	u32	fourcc;
> +	int	depth;
> +	int	h_align;
> +	int	v_align;
> +	u32	types;
> +};
> +
> +/**
> + * s5p_jpeg_q_data - parameters of one queue
> + * @fmt:	driver-specific format of this queue
> + * @w:		image width
> + * @h:		image height
> + * @size:	image buffer size in bytes
> + */
> +struct s5p_jpeg_q_data {
> +	struct s5p_jpeg_fmt	*fmt;
> +	u32			w;
> +	u32			h;
> +	u32			size;
> +};
> +
> +/**
> + * s5p_jpeg_ctx - the device context data
> + * @jpeg:		JPEG IP device for this context
> + * @mode:		compression (encode) operation or decompression (decode)
> + * @compr_quality:	compression quality in compression (encode) mode
> + * @m2m_ctx:		mem2mem device context
> + * @out_q:		source (output) queue information
> + * @cap_fmt:		destination (capture) queue queue information
> + * @hdr_parsed:		set if header has been parsed during decompression
> + * parsed_w:		image width parsed during decompression
> + * parsed_h:		image height parsed during decompression
> + */
> +struct s5p_jpeg_ctx {
> +	struct s5p_jpeg		*jpeg;
> +	unsigned int		mode;
> +	unsigned int		compr_quality;
> +	struct v4l2_m2m_ctx	*m2m_ctx;
> +	struct s5p_jpeg_q_data	out_q;
> +	struct s5p_jpeg_q_data	cap_q;
> +	bool			hdr_parsed;
> +	u32			parsed_w;
> +	u32			parsed_h;
> +};
> +
> +#endif /* JPEG_CORE_H */
> diff --git a/drivers/media/video/s5p-jpeg/jpeg-hw.h b/drivers/media/video/s5p-jpeg/jpeg-hw.h
> new file mode 100644
> index 0000000..ae2b9ac
> --- /dev/null
> +++ b/drivers/media/video/s5p-jpeg/jpeg-hw.h
> @@ -0,0 +1,766 @@
> +/* linux/drivers/media/video/s5p-jpeg/jpeg-hw.h
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef JPEG_HW_H_
> +#define JPEG_HW_H_
> +
> +#include <linux/io.h>
> +
> +#include "jpeg-hw.h"
> +#include "jpeg-regs.h"
> +
> +#define w(x, a)		writel((x), (regs) + (a))

I would suggest using just writel as such. The macro assumes variable reg
holds a pointer and it's not obvious from its arguments.

> +#define r(a)		readl((regs) + (a))
> +#define ARR_SIZE(a)	(sizeof(a) / sizeof(*(a)))

Use ARRAY_SIZE instead.

> +
> +#define S5P_JPEG_MIN_WIDTH		32
> +#define S5P_JPEG_MIN_HEIGHT		32
> +#define S5P_JPEG_MAX_WIDTH		8192
> +#define S5P_JPEG_MAX_HEIGHT		8192
> +#define S5P_JPEG_ENCODE			0
> +#define S5P_JPEG_DECODE			1
> +#define S5P_JPEG_RAW_IN_565		0
> +#define S5P_JPEG_RAW_IN_422		1
> +#define S5P_JPEG_SUBSAMPLING_422	0
> +#define S5P_JPEG_SUBSAMPLING_420	1
> +#define S5P_JPEG_RAW_OUT_422		0
> +#define S5P_JPEG_RAW_OUT_420		1
> +
> +static const unsigned char qtbl_luminance[4][64] = {
> +	{/* level 1 - high quality */
> +		 8,  6,  6,  8, 12, 14, 16, 17,
> +		 6,  6,  6,  8, 10, 13, 12, 15,
> +		 6,  6,  7,  8, 13, 14, 18, 24,
> +		 8,  8,  8, 14, 13, 19, 24, 35,
> +		12, 10, 13, 13, 20, 26, 34, 39,
> +		14, 13, 14, 19, 26, 34, 39, 39,
> +		16, 12, 18, 24, 34, 39, 39, 39,
> +		17, 15, 24, 35, 39, 39, 39, 39
> +	},
> +	{/* level 2 */
> +		12,  8,  8, 12, 17, 21, 24, 23,
> +		 8,  9,  9, 11, 15, 19, 18, 23,
> +		 8,  9, 10, 12, 19, 20, 27, 36,
> +		12, 11, 12, 21, 20, 28, 36, 53,
> +		17, 15, 19, 20, 30, 39, 51, 59,
> +		21, 19, 20, 28, 39, 51, 59, 59,
> +		24, 18, 27, 36, 51, 59, 59, 59,
> +		23, 23, 36, 53, 59, 59, 59, 59
> +	},
> +	{/* level 3 */
> +		16, 11, 11, 16, 23, 27, 31, 30,
> +		11, 12, 12, 15, 20, 23, 23, 30,
> +		11, 12, 13, 16, 23, 26, 35, 47,
> +		16, 15, 16, 23, 26, 37, 47, 64,
> +		23, 20, 23, 26, 39, 51, 64, 64,
> +		27, 23, 26, 37, 51, 64, 64, 64,
> +		31, 23, 35, 47, 64, 64, 64, 64,
> +		30, 30, 47, 64, 64, 64, 64, 64
> +	},
> +	{/*level 4 - low quality */
> +		20, 16, 25, 39, 50, 46, 62, 68,
> +		16, 18, 23, 38, 38, 53, 65, 68,
> +		25, 23, 31, 38, 53, 65, 68, 68,
> +		39, 38, 38, 53, 65, 68, 68, 68,
> +		50, 38, 53, 65, 68, 68, 68, 68,
> +		46, 53, 65, 68, 68, 68, 68, 68,
> +		62, 65, 68, 68, 68, 68, 68, 68,
> +		68, 68, 68, 68, 68, 68, 68, 68
> +	}
> +};
> +
> +static const unsigned char qtbl_chrominance[4][64] = {
> +	{/* level 1 - high quality */
> +		 9,  8,  9, 11, 14, 17, 19, 24,
> +		 8, 10,  9, 11, 14, 13, 17, 22,
> +		 9,  9, 13, 14, 13, 15, 23, 26,
> +		11, 11, 14, 14, 15, 20, 26, 33,
> +		14, 14, 13, 15, 20, 24, 33, 39,
> +		17, 13, 15, 20, 24, 32, 39, 39,
> +		19, 17, 23, 26, 33, 39, 39, 39,
> +		24, 22, 26, 33, 39, 39, 39, 39
> +	},
> +	{/* level 2 */
> +		13, 11, 13, 16, 20, 20, 29, 37,
> +		11, 14, 14, 14, 16, 20, 26, 32,
> +		13, 14, 15, 17, 20, 23, 35, 40,
> +		16, 14, 17, 21, 23, 30, 40, 50,
> +		20, 16, 20, 23, 30, 37, 50, 59,
> +		20, 20, 23, 30, 37, 48, 59, 59,
> +		29, 26, 35, 40, 50, 59, 59, 59,
> +		37, 32, 40, 50, 59, 59, 59, 59
> +	},
> +	{/* level 3 */
> +		17, 15, 17, 21, 20, 26, 38, 48,
> +		15, 19, 18, 17, 20, 26, 35, 43,
> +		17, 18, 20, 22, 26, 30, 46, 53,
> +		21, 17, 22, 28, 30, 39, 53, 64,
> +		20, 20, 26, 30, 39, 48, 64, 64,
> +		26, 26, 30, 39, 48, 63, 64, 64,
> +		38, 35, 46, 53, 64, 64, 64, 64,
> +		48, 43, 53, 64, 64, 64, 64, 64
> +	},
> +	{/*level 4 - low quality */
> +		21, 25, 32, 38, 54, 68, 68, 68,
> +		25, 28, 24, 38, 54, 68, 68, 68,
> +		32, 24, 32, 43, 66, 68, 68, 68,
> +		38, 38, 43, 53, 68, 68, 68, 68,
> +		54, 54, 66, 68, 68, 68, 68, 68,
> +		68, 68, 68, 68, 68, 68, 68, 68,
> +		68, 68, 68, 68, 68, 68, 68, 68,
> +		68, 68, 68, 68, 68, 68, 68, 68
> +	}
> +};
> +
> +static const unsigned char hdctbl0[16] = {
> +	0, 1, 5, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0
> +};
> +
> +static const unsigned char hdctblg0[12] = {
> +	0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0xa, 0xb
> +};
> +static const unsigned char hactbl0[16] = {
> +	0, 2, 1, 3, 3, 2, 4, 3, 5, 5, 4, 4, 0, 0, 1, 0x7d
> +};
> +static const unsigned char hactblg0[162] = {
> +	0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
> +	0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
> +	0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
> +	0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
> +	0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
> +	0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
> +	0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
> +	0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
> +	0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
> +	0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
> +	0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
> +	0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
> +	0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
> +	0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
> +	0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
> +	0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
> +	0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
> +	0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
> +	0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
> +	0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
> +	0xf9, 0xfa
> +};
> +
> +static inline void jpeg_reset(void __iomem *regs)
> +{
> +	unsigned long reg;
> +
> +	w(1, S5P_JPG_SW_RESET);
> +	/* no other way but polling for when JPEG IP becomes operational */
> +	do
> +		reg = r(S5P_JPG_SW_RESET);
> +	while (reg != 0);
> +}
> +
> +static inline void jpeg_poweron(void __iomem *regs)
> +{
> +	w(S5P_POWER_ON, S5P_JPGCLKCON);
> +}
> +
> +static inline void jpeg_input_raw_mode(void __iomem *regs, unsigned long mode)
> +{
> +	unsigned long reg, m;
> +
> +	m = S5P_MOD_SEL_565;
> +	if (mode == S5P_JPEG_RAW_IN_565)
> +		m = S5P_MOD_SEL_565;
> +	else if (mode == S5P_JPEG_RAW_IN_422)
> +		m = S5P_MOD_SEL_422;
> +
> +	reg = r(S5P_JPGCMOD);
> +	reg &= S5P_MOD_SEL_CLR;
> +	reg |= m;
> +	w(reg, S5P_JPGCMOD);
> +}
> +
> +static inline void jpeg_input_raw_y16(void __iomem *regs, bool y16)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGCMOD);
> +	if (y16)
> +		reg |= S5P_MODE_Y16;
> +	else
> +		reg &= S5P_MODE_Y16_CLR;
> +	w(reg, S5P_JPGCMOD);
> +}
> +
> +static inline void jpeg_proc_mode(void __iomem *regs, unsigned long mode)
> +{
> +	unsigned long reg, m;
> +
> +	m = S5P_PROC_MODE_DECOMPR;
> +	if (mode == S5P_JPEG_ENCODE)
> +		m = S5P_PROC_MODE_COMPR;
> +	else
> +		m = S5P_PROC_MODE_DECOMPR;
> +	reg = r(S5P_JPGMOD);
> +	reg &= S5P_PROC_MODE_CLR;
> +	reg |= m;
> +	w(reg, S5P_JPGMOD);
> +}
> +
> +static inline void jpeg_subsampling_mode(void __iomem *regs, unsigned long mode)
> +{
> +	unsigned long reg, m;
> +
> +	m = S5P_SUBSAMPLING_MODE_422;
> +	if (mode == S5P_JPEG_SUBSAMPLING_422)
> +		m = S5P_SUBSAMPLING_MODE_422;
> +	else if (mode == S5P_JPEG_SUBSAMPLING_420)
> +		m = S5P_SUBSAMPLING_MODE_420;
> +	reg = r(S5P_JPGMOD);
> +	reg &= S5P_SUBSAMPLING_MODE_CLR;
> +	reg |= m;
> +	w(reg, S5P_JPGMOD);
> +}
> +
> +static inline void jpeg_dri(void __iomem *regs, unsigned short dri)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGDRI_U);
> +	reg &= S5P_JPGDRI_U_CLR;
> +	reg |= S5P_JPGDRI_U_W(dri);
> +	w(reg, S5P_JPGDRI_U);
> +
> +	reg = r(S5P_JPGDRI_L);
> +	reg &= S5P_JPGDRI_L_CLR;
> +	reg |= S5P_JPGDRI_L_W(dri);
> +	w(reg, S5P_JPGDRI_L);
> +}
> +
> +static inline void jpeg_qtbl4(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_QTBL);
> +	reg &= S5P_QT_NUM4_CLR;
> +	reg |= S5P_QT_NUM4_W(n);
> +	w(reg, S5P_JPG_QTBL);
> +}

You don't need such a huge number of almost similar functions. You may e.g.
create one function which takes the mask and value as inputs along with the
rst of parameters.

> +static inline void jpeg_qtbl3(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_QTBL);
> +	reg &= S5P_QT_NUM3_CLR;
> +	reg |= S5P_QT_NUM3_W(n);
> +	w(reg, S5P_JPG_QTBL);
> +}
> +
> +static inline void jpeg_qtbl2(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_QTBL);
> +	reg &= S5P_QT_NUM2_CLR;
> +	reg |= S5P_QT_NUM2_W(n);
> +	w(reg, S5P_JPG_QTBL);
> +}
> +
> +static inline void jpeg_qtbl1(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_QTBL);
> +	reg &= S5P_QT_NUM1_CLR;
> +	reg |= S5P_QT_NUM1_W(n);
> +	w(reg, S5P_JPG_QTBL);
> +}
> +
> +static inline void jpeg_htbl4_ac(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM4_AC_CLR;
> +	reg |= S5P_HT_NUM4_AC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_htbl4_dc(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM4_DC_CLR;
> +	reg |= S5P_HT_NUM4_DC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_htbl3_ac(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM3_AC_CLR;
> +	reg |= S5P_HT_NUM3_AC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_htbl3_dc(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM3_DC_CLR;
> +	reg |= S5P_HT_NUM3_DC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_htbl2_ac(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM2_AC_CLR;
> +	reg |= S5P_HT_NUM2_AC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_htbl2_dc(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM2_DC_CLR;
> +	reg |= S5P_HT_NUM2_DC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_htbl1_ac(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM1_AC_CLR;
> +	reg |= S5P_HT_NUM1_AC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_htbl1_dc(void __iomem *regs, unsigned short n)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_HTBL);
> +	reg &= S5P_HT_NUM1_DC_CLR;
> +	reg |= S5P_HT_NUM1_DC_W(n);
> +	w(reg, S5P_JPG_HTBL);
> +}
> +
> +static inline void jpeg_y(void __iomem *regs, unsigned short y)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGY_U);
> +	reg &= S5P_VER_RES_U_CLR;
> +	reg |= S5P_VER_RES_U_W(y);
> +	w(reg, S5P_JPGY_U);
> +
> +	reg = r(S5P_JPGY_L);
> +	reg &= S5P_VER_RES_L_CLR;
> +	reg |= S5P_VER_RES_L_W(y);
> +	w(reg, S5P_JPGY_L);
> +}
> +
> +static inline void jpeg_x(void __iomem *regs, unsigned short x)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGX_U);
> +	reg &= S5P_HOR_RES_U_CLR;
> +	reg |= S5P_HOR_RES_U_W(x);
> +	w(reg, S5P_JPGX_U);
> +
> +	reg = r(S5P_JPGX_L);
> +	reg &= S5P_HOR_RES_L_CLR;
> +	reg |= S5P_HOR_RES_L_W(x);
> +	w(reg, S5P_JPGX_L);
> +}
> +
> +static inline void jpeg_rst_int_enable(void __iomem *regs, bool enable)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGINTSE);
> +	reg &= S5P_RSTm_INT_EN_CLR;
> +	if (enable)
> +		reg |= S5P_RSTm_INT_EN;
> +	w(reg, S5P_JPGINTSE);
> +}
> +
> +static inline void jpeg_data_num_int_enable(void __iomem *regs, bool enable)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGINTSE);
> +	reg &= S5P_DATA_NUM_INT_EN_CLR;
> +	if (enable)
> +		reg |= S5P_DATA_NUM_INT_EN;
> +	w(reg, S5P_JPGINTSE);
> +}
> +
> +static inline void jpeg_final_mcu_num_int_enable(void __iomem *regs, bool enbl)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGINTSE);
> +	reg &= S5P_FINAL_MCU_NUM_INT_EN_CLR;
> +	if (enbl)
> +		reg |= S5P_FINAL_MCU_NUM_INT_EN;
> +	w(reg, S5P_JPGINTSE);
> +}
> +
> +static inline void jpeg_timer_enable(void __iomem *regs, unsigned long val)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_TIMER_SE);
> +	reg |= S5P_TIMER_INT_EN;
> +	reg &= S5P_TIMER_INIT_CLR;
> +	reg |= S5P_TIMER_INIT_W(val);
> +	w(reg, S5P_JPG_TIMER_SE);
> +}
> +
> +static inline void jpeg_timer_disable(void __iomem *regs)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_TIMER_SE);
> +	reg &= S5P_TIMER_INT_EN_CLR;
> +	w(reg, S5P_JPG_TIMER_SE);
> +}
> +
> +static inline int jpeg_timer_stat(void __iomem *regs)
> +{
> +	return (int)S5P_TIMER_INT_STAT_R(r(S5P_JPG_TIMER_ST));
> +}
> +
> +static inline void jpeg_clear_timer_stat(void __iomem *regs)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_TIMER_SE);
> +	reg &= S5P_TIMER_INT_STAT_CLR;
> +	w(reg, S5P_JPG_TIMER_SE);
> +}
> +
> +static inline void jpeg_enc_stream_int(void __iomem *regs, unsigned long size)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_ENC_STREAM_INTSE);
> +	reg &= S5P_ENC_STREAM_BOUND_CLR;
> +	reg |= S5P_ENC_STREAM_INT_EN;
> +	reg |= S5P_ENC_STREAM_BOUND_W(size);
> +	w(reg, S5P_JPG_ENC_STREAM_INTSE);
> +}
> +
> +static inline int jpeg_enc_stream_stat(void __iomem *regs)
> +{
> +	return (int)S5P_ENC_STREAM_INT_STAT_R(r(S5P_JPG_ENC_STREAM_INTST));
> +}
> +
> +static inline void jpeg_clear_enc_stream_stat(void __iomem *regs)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_ENC_STREAM_INTSE);
> +	reg &= S5P_ENC_STREAM_INT_CLR;
> +	w(reg, S5P_JPG_ENC_STREAM_INTSE);
> +}
> +
> +static inline void jpeg_outform_raw(void __iomem *regs, unsigned long format)
> +{
> +	unsigned long reg, f;
> +
> +	f = S5P_DEC_OUT_FORMAT_422;
> +	if (format == S5P_JPEG_RAW_OUT_422)
> +		f = S5P_DEC_OUT_FORMAT_422;
> +	else if (format == S5P_JPEG_RAW_OUT_420)
> +		f = S5P_DEC_OUT_FORMAT_420;
> +	reg = r(S5P_JPG_OUTFORM);
> +	reg &= S5P_DEC_OUT_FORMAT_CLR;
> +	reg |= f;
> +	w(reg, S5P_JPG_OUTFORM);
> +}
> +
> +static inline void jpeg_jpgadr(void __iomem *regs, unsigned long addr)
> +{
> +	w(addr, S5P_JPG_JPGADR);
> +}
> +
> +static inline void jpeg_imgadr(void __iomem *regs, unsigned long addr)
> +{
> +	w(addr, S5P_JPG_IMGADR);
> +}
> +
> +static inline void jpeg_coef11(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF1);
> +	reg &= S5P_COEF11_CLR;
> +	reg |= S5P_COEF11_W(coef);
> +	w(reg, S5P_JPG_COEF1);
> +}
> +
> +static inline void jpeg_coef12(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF1);
> +	reg &= S5P_COEF12_CLR;
> +	reg |= S5P_COEF12_W(coef);
> +	w(reg, S5P_JPG_COEF1);
> +}
> +
> +static inline void jpeg_coef13(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF1);
> +	reg &= S5P_COEF13_CLR;
> +	reg |= S5P_COEF13_W(coef);
> +	w(reg, S5P_JPG_COEF1);
> +}
> +
> +static inline void jpeg_coef21(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF2);
> +	reg &= S5P_COEF21_CLR;
> +	reg |= S5P_COEF21_W(coef);
> +	w(reg, S5P_JPG_COEF2);
> +}
> +
> +static inline void jpeg_coef22(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF2);
> +	reg &= S5P_COEF22_CLR;
> +	reg |= S5P_COEF22_W(coef);
> +	w(reg, S5P_JPG_COEF2);
> +}
> +
> +static inline void jpeg_coef23(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF2);
> +	reg &= S5P_COEF23_CLR;
> +	reg |= S5P_COEF23_W(coef);
> +	w(reg, S5P_JPG_COEF2);
> +}
> +
> +static inline void jpeg_coef31(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF3);
> +	reg &= S5P_COEF31_CLR;
> +	reg |= S5P_COEF31_W(coef);
> +	w(reg, S5P_JPG_COEF3);
> +}
> +
> +static inline void jpeg_coef32(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF3);
> +	reg &= S5P_COEF32_CLR;
> +	reg |= S5P_COEF32_W(coef);
> +	w(reg, S5P_JPG_COEF3);
> +}
> +
> +static inline void jpeg_coef33(void __iomem *regs, unsigned short coef)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPG_COEF3);
> +	reg &= S5P_COEF33_CLR;
> +	reg |= S5P_COEF33_W(coef);
> +	w(reg, S5P_JPG_COEF3);
> +}
> +
> +static inline void jpeg_start(void __iomem *regs)
> +{
> +	w(1, S5P_JSTART);
> +}
> +
> +static inline int jpeg_result_stat_ok(void __iomem *regs)
> +{
> +	return (int)S5P_RESULT_STAT_R(r(S5P_JPGINTST));
> +}
> +
> +static inline int jpeg_stream_stat_ok(void __iomem *regs)
> +{
> +	return !(int)S5P_STREAM_STAT_R(r(S5P_JPGINTST));
> +}
> +
> +static inline void jpeg_clear_int(void __iomem *regs)
> +{
> +	unsigned long reg;
> +
> +	reg = r(S5P_JPGINTST);
> +	w(S5P_INT_RELEASE, S5P_JPGCOM);
> +	reg = r(S5P_JPGOPR);
> +}
> +
> +static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
> +		   unsigned long tab, int len)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++)
> +		w((unsigned int)qtbl[i], tab + (i * 0x04));
> +}
> +
> +static inline void jpeg_set_qtbl_lum(void __iomem *regs, int tab, int quality)
> +{
> +	unsigned long t = 0;
> +
> +	switch (tab) {
> +	case 0:
> +		t = S5P_JPG_QTBL0;
> +		break;
> +	case 1:
> +		t = S5P_JPG_QTBL1;
> +		break;
> +	case 2:
> +		t = S5P_JPG_QTBL2;
> +		break;
> +	case 3:
> +		t = S5P_JPG_QTBL3;
> +		break;
> +	}
> +
> +	jpeg_set_qtbl(regs, qtbl_luminance[quality], t,
> +		      ARR_SIZE(qtbl_luminance[quality]));
> +}
> +
> +static inline void jpeg_set_qtbl_chr(void __iomem *regs, int tab, int quality)
> +{
> +	unsigned long t = 0;
> +
> +	switch (tab) {
> +	case 0:
> +		t = S5P_JPG_QTBL0;
> +		break;
> +	case 1:
> +		t = S5P_JPG_QTBL1;
> +		break;
> +	case 2:
> +		t = S5P_JPG_QTBL2;
> +		break;
> +	case 3:
> +		t = S5P_JPG_QTBL3;
> +		break;
> +	}
> +
> +	jpeg_set_qtbl(regs, qtbl_chrominance[quality], t,
> +		      ARR_SIZE(qtbl_chrominance[quality]));
> +}
> +
> +static inline void jpeg_set_htbl(void __iomem *regs, const unsigned char *htbl,
> +		   unsigned long tab, int len)
> +{
> +	int i;
> +
> +	for (i = 0; i < len; i++)
> +		w((unsigned int)htbl[i], tab + (i * 0x04));
> +}
> +
> +static inline void jpeg_set_hdctbl(void __iomem *regs, int tab)
> +{
> +	unsigned long t = 0;
> +
> +	switch (tab) {
> +	case 0:
> +		t = S5P_JPG_HDCTBL0;
> +		break;
> +	case 1:
> +		t = S5P_JPG_HDCTBL1;
> +		break;
> +	}
> +
> +	jpeg_set_htbl(regs, hdctbl0, t, ARR_SIZE(hdctbl0));
> +}
> +
> +static inline void jpeg_set_hdctblg(void __iomem *regs, int tab)
> +{
> +	unsigned long t = 0;
> +
> +	switch (tab) {
> +	case 0:
> +		t = S5P_JPG_HDCTBLG0;
> +		break;
> +	case 1:
> +		t = S5P_JPG_HDCTBLG1;
> +		break;
> +	}
> +
> +	jpeg_set_htbl(regs, hdctblg0, t, ARR_SIZE(hdctblg0));
> +}
> +
> +static inline void jpeg_set_hactbl(void __iomem *regs, int tab)
> +{
> +	unsigned long t = 0;
> +
> +	switch (tab) {
> +	case 0:
> +		t = S5P_JPG_HACTBL0;
> +		break;
> +	case 1:
> +		t = S5P_JPG_HACTBL1;
> +		break;
> +	}
> +
> +	jpeg_set_htbl(regs, hactbl0, t, ARR_SIZE(hactbl0));
> +}

This function is always called with tab == 0. The same goes for at least
part of very similar functions around this one.

> +static inline void jpeg_set_hactblg(void __iomem *regs, int tab)
> +{
> +	unsigned long t = 0;
> +
> +	switch (tab) {
> +	case 0:
> +		t = S5P_JPG_HACTBLG0;
> +		break;
> +	case 1:
> +		t = S5P_JPG_HACTBLG1;
> +		break;
> +	}
> +
> +	jpeg_set_htbl(regs, hactblg0, t, ARRAY_SIZE(hactblg0));
> +}
> +
> +static inline int jpeg_compressed_size(void __iomem *regs)
> +{
> +	unsigned long jpeg_size = 0;
> +
> +	jpeg_size |= S5P_BYTE_CNT_U_R(r(S5P_JPGCNT_U));
> +	jpeg_size |= S5P_BYTE_CNT_M_R(r(S5P_JPGCNT_M));
> +	jpeg_size |= S5P_BYTE_CNT_L_R(r(S5P_JPGCNT_L));
> +
> +	return (int)jpeg_size;
> +}
> +
> +#endif /* JPEG_HW_H_ */
> diff --git a/drivers/media/video/s5p-jpeg/jpeg-regs.h b/drivers/media/video/s5p-jpeg/jpeg-regs.h
> new file mode 100644
> index 0000000..119219f
> --- /dev/null
> +++ b/drivers/media/video/s5p-jpeg/jpeg-regs.h
> @@ -0,0 +1,280 @@
> +/* linux/drivers/media/video/s5p-jpeg/jpeg-regs.c
> + *
> + * Register definition file for Samsung JPEG codec driver
> + *
> + * Copyright (c) 2011 Samsung Electronics Co., Ltd.
> + *		http://www.samsung.com
> + *
> + * Author: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef JPEG_REGS_H_
> +#define JPEG_REGS_H_
> +
> +/* JPEG mode register */
> +#define S5P_JPGMOD			0x00
> +#define S5P_PROC_MODE_CLR		(~(0x1 << 3))
> +#define S5P_PROC_MODE_DECOMPR		(0x1 << 3)
> +#define S5P_PROC_MODE_COMPR		(0x0 << 3)
> +#define S5P_SUBSAMPLING_MODE_CLR	(~0x7)
> +#define S5P_SUBSAMPLING_MODE_444	(0x0 << 0)
> +#define S5P_SUBSAMPLING_MODE_422	(0x1 << 0)
> +#define S5P_SUBSAMPLING_MODE_420	(0x2 << 0)
> +#define S5P_SUBSAMPLING_MODE_GRAY	(0x3 << 0)
> +
> +/* JPEG operation status register */
> +#define S5P_JPGOPR			0x04
> +
> +/* Quantization tables*/
> +#define S5P_JPG_QTBL			0x08
> +#define S5P_QT_NUM4_CLR			(~(0x3 << 6))
> +#define S5P_QT_NUM3_CLR			(~(0x3 << 4))
> +#define S5P_QT_NUM2_CLR			(~(0x3 << 2))
> +#define S5P_QT_NUM1_CLR			(~(0x3 << 0))
> +#define S5P_QT_NUM4_W(x)		(((x) & 0x3) << 6)
> +#define S5P_QT_NUM3_W(x)		(((x) & 0x3) << 4)
> +#define S5P_QT_NUM2_W(x)		(((x) & 0x3) << 2)
> +#define S5P_QT_NUM1_W(x)		(((x) & 0x3) << 0)
> +#define S5P_QT_NUM4_R(x)		(((x) >> 6) & 0x3)
> +#define S5P_QT_NUM3_R(x)		(((x) >> 4) & 0x3)
> +#define S5P_QT_NUM2_R(x)		(((x) >> 2) & 0x3)
> +#define S5P_QT_NUM1_R(x)		(((x) >> 0) & 0x3)
> +
> +/* Huffman tables */
> +#define S5P_JPG_HTBL			0x0C
> +#define S5P_HT_NUM4_AC_CLR		(~(0x1 << 7))
> +#define S5P_HT_NUM4_DC_CLR		(~(0x1 << 6))
> +#define S5P_HT_NUM3_AC_CLR		(~(0x1 << 5))
> +#define S5P_HT_NUM3_DC_CLR		(~(0x1 << 4))
> +#define S5P_HT_NUM2_AC_CLR		(~(0x1 << 3))
> +#define S5P_HT_NUM2_DC_CLR		(~(0x1 << 2))
> +#define S5P_HT_NUM1_AC_CLR		(~(0x1 << 1))
> +#define S5P_HT_NUM1_DC_CLR		(~(0x1 << 0))
> +#define S5P_HT_NUM4_AC_W(x)		(((x) & 0x1) << 7)
> +#define S5P_HT_NUM4_DC_W(x)		(((x) & 0x1) << 6)
> +#define S5P_HT_NUM3_AC_W(x)		(((x) & 0x1) << 5)
> +#define S5P_HT_NUM3_DC_W(x)		(((x) & 0x1) << 4)
> +#define S5P_HT_NUM2_AC_W(x)		(((x) & 0x1) << 3)
> +#define S5P_HT_NUM2_DC_W(x)		(((x) & 0x1) << 2)
> +#define S5P_HT_NUM1_AC_W(x)		(((x) & 0x1) << 1)
> +#define S5P_HT_NUM1_DC_W(x)		(((x) & 0x1) << 0)
> +#define S5P_HT_NUM4_AC_R(x)		(((x) >> 7) & 0x1)
> +#define S5P_HT_NUM4_DC_R(x)		(((x) >> 6) & 0x1)
> +#define S5P_HT_NUM3_AC_R(x)		(((x) >> 5) & 0x1)
> +#define S5P_HT_NUM3_DC_R(x)		(((x) >> 4) & 0x1)
> +#define S5P_HT_NUM2_AC_R(x)		(((x) >> 3) & 0x1)
> +#define S5P_HT_NUM2_DC_R(x)		(((x) >> 2) & 0x1)
> +#define S5P_HT_NUM1_AC_R(x)		(((x) >> 1) & 0x1)
> +#define S5P_HT_NUM1_DC_R(x)		(((x) >> 0) & 0x1)
> +
> +
> +/* JPEG restart interval register upper byte */
> +#define S5P_JPGDRI_U			0x10
> +#define S5P_JPGDRI_U_CLR		(~0xff)
> +#define S5P_JPGDRI_U_W(x)		(((x) >> 8) & 0xff)
> +#define S5P_JPGDRI_U_R(x)		(((x) & 0xff) << 8)
> +
> +/* JPEG restart interval register lower byte */
> +#define S5P_JPGDRI_L			0x14
> +#define S5P_JPGDRI_L_CLR		(~0xff)
> +#define S5P_JPGDRI_L_W(x)		(((x) >> 0) & 0xff)
> +#define S5P_JPGDRI_L_R(x)		(((x) & 0xff) << 0)
> +
> +/* JPEG vertical resolution register upper byte */
> +#define S5P_JPGY_U			0x18
> +#define S5P_VER_RES_U_CLR		(~0xff)
> +#define S5P_VER_RES_U_W(x)		(((x) >> 8) & 0xff)
> +#define S5P_VER_RES_U_R(x)		(((x) & 0xff) << 8)
> +
> +/* JPEG vertical resolution register lower byte */
> +#define S5P_JPGY_L			0x1C
> +#define S5P_VER_RES_L_CLR		(~0xff)
> +#define S5P_VER_RES_L_W(x)		(((x) >> 0) & 0xff)
> +#define S5P_VER_RES_L_R(x)		(((x) & 0xff) << 0)
> +
> +/* JPEG horizontal resolution register upper byte */
> +#define S5P_JPGX_U			0x20
> +#define S5P_HOR_RES_U_CLR		(~0xff)
> +#define S5P_HOR_RES_U_W(x)		(((x) >> 8) & 0xff)
> +#define S5P_HOR_RES_U_R(x)		(((x) & 0xff) << 8)
> +
> +/* JPEG horizontal resolution register lower byte */
> +#define S5P_JPGX_L			0x24
> +#define S5P_HOR_RES_L_CLR		(~0xff)
> +#define S5P_HOR_RES_L_W(x)		(((x) >> 0) & 0xff)
> +#define S5P_HOR_RES_L_R(x)		(((x) & 0xff) << 0)
> +
> +/* JPEG byte count register upper byte */
> +#define S5P_JPGCNT_U			0x28
> +#define S5P_BYTE_CNT_U_CLR		(~0xff)
> +#define S5P_BYTE_CNT_U_W(x)		(((x) >> 16) & 0xff)
> +#define S5P_BYTE_CNT_U_R(x)		(((x) & 0xff) << 16)
> +
> +/* JPEG byte count register middle byte */
> +#define S5P_JPGCNT_M			0x2C
> +#define S5P_BYTE_CNT_M_CLR		(~0xff)
> +#define S5P_BYTE_CNT_M_W(x)		(((x) >> 8) & 0xff)
> +#define S5P_BYTE_CNT_M_R(x)		(((x) & 0xff) << 8)
> +
> +/* JPEG byte count register lower byte */
> +#define S5P_JPGCNT_L			0x30
> +#define S5P_BYTE_CNT_L_CLR		(~0xff)
> +#define S5P_BYTE_CNT_L_W(x)		(((x) >> 0) & 0xff)
> +#define S5P_BYTE_CNT_L_R(x)		(((x) & 0xff) << 0)
> +
> +/* JPEG interrupt setting register */
> +#define S5P_JPGINTSE			0x34
> +#define S5P_RSTm_INT_EN_CLR		(~(0x1 << 7))
> +#define S5P_RSTm_INT_EN			(0x1 << 7)
> +#define S5P_DATA_NUM_INT_EN_CLR		(~(0x1 << 6))
> +#define S5P_DATA_NUM_INT_EN		(0x1 << 6)
> +#define S5P_FINAL_MCU_NUM_INT_EN_CLR	(~(0x1 << 5))
> +#define S5P_FINAL_MCU_NUM_INT_EN	(0x1 << 5)
> +
> +/* JPEG interrupt status register */
> +#define S5P_JPGINTST			0x38
> +#define S5P_RESULT_STAT_R(x)		(((x) >> 6) & 0x1)
> +#define S5P_STREAM_STAT_R(x)		(((x) >> 5) & 0x1)
> +
> +/* JPEG command resgister */
> +#define S5P_JPGCOM			0x4C
> +#define S5P_INT_RELEASE			(0x1 << 2)
> +
> +/* Raw image data r/w address register */
> +#define S5P_JPG_IMGADR			0x50
> +
> +/* JPEG file r/w address register */
> +#define S5P_JPG_JPGADR			0x58
> +
> +/* Coefficient for RGB-to-YCbCr converter register */
> +#define S5P_JPG_COEF1			0x5C
> +#define S5P_COEF11_CLR			(~0xff0000)
> +#define S5P_COEF11_W(x)			(((x) & 0xff) << 16)
> +#define S5P_COEF11_R(x)			(((x) >> 16) & 0xff)
> +#define S5P_COEF12_CLR			(~0xff00)
> +#define S5P_COEF12_W(x)			(((x) & 0xff) << 8)
> +#define S5P_COEF12_R(x)			(((x) >> 8) & 0xff)
> +#define S5P_COEF13_CLR			(~0xff)
> +#define S5P_COEF13_W(x)			(((x) & 0xff) << 0)
> +#define S5P_COEF13_R(x)			(((x) >> 0) & 0xff)
> +
> +/* Coefficient for RGB-to-YCbCr converter register */
> +#define S5P_JPG_COEF2			0x60
> +#define S5P_COEF21_CLR			(~0xff0000)
> +#define S5P_COEF21_W(x)			(((x) & 0xff) << 16)
> +#define S5P_COEF21_R(x)			(((x) >> 16) & 0xff)
> +#define S5P_COEF22_CLR			(~0xff00)
> +#define S5P_COEF22_W(x)			(((x) & 0xff) << 8)
> +#define S5P_COEF22_R(x)			(((x) >> 8) & 0xff)
> +#define S5P_COEF23_CLR			(~0xff)
> +#define S5P_COEF23_W(x)			(((x) & 0xff) << 0)
> +#define S5P_COEF23_R(x)			(((x) >> 0) & 0xff)
> +
> +/* Coefficient for RGB-to-YCbCr converter register */
> +#define S5P_JPG_COEF3			0x64
> +#define S5P_COEF31_CLR			(~0xff0000)
> +#define S5P_COEF31_W(x)			(((x) & 0xff) << 16)
> +#define S5P_COEF31_R(x)			(((x) >> 16) & 0xff)
> +#define S5P_COEF32_CLR			(~0xff00)
> +#define S5P_COEF32_W(x)			(((x) & 0xff) << 8)
> +#define S5P_COEF32_R(x)			(((x) >> 8) & 0xff)
> +#define S5P_COEF33_CLR			(~0xff)
> +#define S5P_COEF33_W(x)			(((x) & 0xff) << 0)
> +#define S5P_COEF33_R(x)			(((x) >> 0) & 0xff)
> +
> +/* JPEG color mode register */
> +#define S5P_JPGCMOD			0x68
> +#define S5P_MOD_SEL_CLR			(~(0x7 << 5))
> +#define S5P_MOD_SEL_422			(0x1 << 5)
> +#define S5P_MOD_SEL_565			(0x2 << 5)
> +#define S5P_MODE_Y16_CLR		(~(0x1 << 1))
> +#define S5P_MODE_Y16			(0x1 << 1)
> +
> +/* JPEG clock control register */
> +#define S5P_JPGCLKCON			0x6C
> +#define S5P_CLK_DOWN_READY		(0x1 << 1)
> +#define S5P_POWER_ON			(0x1 << 0)
> +
> +/* JPEG start register */
> +#define S5P_JSTART			0x70
> +
> +/* JPEG SW reset register */
> +#define S5P_JPG_SW_RESET		0x78
> +
> +/* JPEG timer setting register */
> +#define S5P_JPG_TIMER_SE		0x7C
> +#define S5P_TIMER_INT_EN		(0x1 << 31)
> +#define S5P_TIMER_INT_EN_CLR		(~(0x1 << 31))
> +#define S5P_TIMER_INIT_CLR		(~0x7fffffff)
> +#define S5P_TIMER_INIT_W(x)		(((x) & 0x7fffffff) << 0)
> +#define S5P_TIMER_INIT_R(x)		(((x) >> 0) & 0x7fffffff)

This would be easier if you only defined a shift and mask for the setting.
OMAP 3 ISP driver serves as an example. Just an idea.

> +
> +/* JPEG timer status register */
> +#define S5P_JPG_TIMER_ST		0x80
> +#define S5P_TIMER_INT_STAT_R(x)		(((x) >> 31) & 0x1)
> +#define S5P_TIMER_INT_STAT_CLR		(~(0x1 << 31))
> +#define S5P_TIMER_CNT_R(x)		(((x) >> 0) & 0x7fffffff)
> +
> +/* JPEG decompression output format register */
> +#define S5P_JPG_OUTFORM			0x88
> +#define S5P_DEC_OUT_FORMAT_CLR		(~(0x1 << 0))
> +#define S5P_DEC_OUT_FORMAT_422		(0x0 << 0)
> +#define S5P_DEC_OUT_FORMAT_420		(0x1 << 0)
> +
> +/* JPEG version resgister */
> +#define S5P_JPG_VERSION			0x8C
> +
> +/* JPEG compressed stream size interrupt setting register */
> +#define S5P_JPG_ENC_STREAM_INTSE	0x98
> +#define S5P_ENC_STREAM_INT_CLR		(~(0x1 << 24))
> +#define S5P_ENC_STREAM_INT_EN		(0x1 << 24)
> +#define S5P_ENC_STREAM_BOUND_CLR	(~0xffffff)
> +#define S5P_ENC_STREAM_BOUND_W(x)	(((x) & 0xffffff) << 0)
> +#define S5P_ENC_STREAM_BOUND_R(x)	(((x) >> 0) & 0xffffff)
> +
> +/* JPEG compressed stream size interrupt status register */
> +#define S5P_JPG_ENC_STREAM_INTST	0x9C
> +#define S5P_ENC_STREAM_INT_STAT_R(x)	((x) & (0x1 << 0))
> +
> +/* JPEG quantizer table 0 register */
> +#define S5P_JPG_QTBL0			0x400
> +
> +/* JPEG quantizer table 1 register */
> +#define S5P_JPG_QTBL1			0x500
> +
> +/* JPEG quantizer table 2 register */
> +#define S5P_JPG_QTBL2			0x600
> +
> +/* JPEG quantizer table 3 register */
> +#define S5P_JPG_QTBL3			0x700
> +
> +/* JPEG DC Huffman table 0 register */
> +#define S5P_JPG_HDCTBL0			0x800
> +
> +/* JPEG DC Huffman table 0 register */
> +#define S5P_JPG_HDCTBLG0		0x840
> +
> +/* JPEG AC Huffman table 0 register */
> +#define S5P_JPG_HACTBL0			0x880
> +
> +/* JPEG AC Huffman table 0 register */
> +#define S5P_JPG_HACTBLG0		0x8C0
> +
> +/* JPEG DC Huffman table 1 register */
> +#define S5P_JPG_HDCTBL1			0xC00
> +
> +/* JPEG DC Huffman table 1 register */
> +#define S5P_JPG_HDCTBLG1		0xC40
> +
> +/* JPEG AC Huffman table 1 register */
> +#define S5P_JPG_HACTBL1			0xC80
> +
> +/* JPEG AC Huffman table 1 register */
> +#define S5P_JPG_HACTBLG1		0xCC0
> +
> +#endif /* JPEG_REGS_H_ */
> +
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
