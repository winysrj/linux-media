Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37282 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2FSSR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 14:17:27 -0400
Date: Tue, 19 Jun 2012 20:17:17 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de, fabio.estevam@freescale.com,
	shawn.guo@linaro.org, dirk.behme@googlemail.com,
	r.schwebel@pengutronix.de
Subject: Re: [RFC] Support for 'Coda' video codec IP.
Message-ID: <20120619181717.GE28394@pengutronix.de>
References: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340115094-859-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, Jun 19, 2012 at 04:11:34PM +0200, Javier Martin wrote:
> This patch adds support for the video encoder present
> in the i.MX27. It currently support encoding in H.264 and
> in MPEG4 SP. It's working properly in a Visstrim SM10 platform.
> It uses V4L2-mem2mem framework.
> 
> A public git repository is available too:
> git://github.com/jmartinc/video_visstrim.git
> 
> The current approach assumes two separate files for both encoding
> and decoding, but only the former has been implemented. We have no
> intention to implement decoding but it shouldn't be difficult to 
> integrate by a third party.
> 
> A generic 'coda' name has been chosen so that it can implement all
> models used in i.MX27, i.MX51... chips. [1].
> 
> TODO:
>  - Get rid of 'runtime' structure.
>  - Prepare a generic layer to make easy the access to different models
>  of 'Coda' as discussed here[2].
>  - Remove IDR frame bugfix as long as Freescale provides an update for
>  the coda embedded in the i.MX27.
> 
> 

The patch adds several trailing whitespaces, please remove.

> +#include <mach/hardware.h>
> +#include <mach/devices-common.h>
> +#include <linux/coda_codec.h>
> +
> +#ifdef CONFIG_SOC_IMX27
> +const struct imx_imx27_coda_data imx27_coda_data __initconst = {
> +	.iobase = MX27_VPU_BASE_ADDR,
> +	.iosize = SZ_512,
> +	.irq = MX27_INT_VPU,
> +};
> +#endif
> +
> +struct platform_device *__init imx_add_imx27_coda(
> +		const struct imx_imx27_coda_data *data,
> +		const struct coda_platform_data *pdata)
> +{
> +	struct resource res[] = {
> +		{
> +			.start = data->iobase,
> +			.end = data->iobase + data->iosize - 1,
> +			.flags = IORESOURCE_MEM,
> +		}, {
> +			.start = data->irq,
> +			.end = data->irq,
> +			.flags = IORESOURCE_IRQ,
> +		},
> +	};
> +	return imx_add_platform_device_dmamask("coda", 0, res, 2, pdata,
> +					sizeof(*pdata), DMA_BIT_MASK(32));

Since we all move to devicetree shouldn't we stop adding new
platform devices?

> +
> +struct coda_aux_buf {
> +	void			*vaddr;
> +	dma_addr_t		paddr;
> +};
> +
> +struct coda_dev {
> +	struct v4l2_device	v4l2_dev;
> +	struct video_device	*vfd_enc;
> +	struct platform_device	*plat_dev;
> +
> +	void __iomem		*regs_base;
> +	struct clk		*clk;
> +	int			irq;
> +
> +	struct coda_aux_buf	enc_codebuf;
> +	struct coda_aux_buf	enc_workbuf;
> +	struct coda_aux_buf	enc_parabuf;
> +
> +	spinlock_t		irqlock;
> +	struct mutex		dev_mutex;
> +	struct v4l2_m2m_dev	*m2m_enc_dev;
> +	struct vb2_alloc_ctx	*alloc_enc_ctx;
> +};
> +
> +struct coda_enc_params {
> +	u8			h264_intra_qp;
> +	u8			h264_inter_qp;
> +	u8			mpeg4_intra_qp;
> +	u8			mpeg4_inter_qp;
> +	u8			gop_size;
> +	int			codec_mode;
> +	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
> +	u32			framerate;
> +	u16			bitrate;
> +	u32			slice_max_mb;
> +};
> +
> +struct framebuffer {
> +	u32	y;
> +	u32	cb;
> +	u32	cr;
> +};
> +
> +#define CODA_ENC_OUTPUT_BUFS	4
> +#define CODA_ENC_CAPTURE_BUFS	2
> +
> +/* TODO: some data of this structure can be removed */
> +struct coda_enc_runtime {
> +	/* old EncOpenParam vpuParams */
> +	unsigned int	pic_width;
> +	unsigned int	pic_height;
> +	u32		bitstream_buf;	/* Seems to be pointer to compressed buffer */
> +	u32		bitstream_buf_size;
> +	u32		bitstream_format; /* This is probably redundant (q_data->fmt->fourcc) */
> +	int		initial_delay;	/* This is fixed to 0 */
> +	int		vbv_buffer_size; /* This is fixed to 0 */
> +	int		enable_autoskip; /* This is fixed to 1 */
> +	int		intra_refresh; /* This is fixed to 0 */
> +	int		gamma; /* This is fixed to 4096 */
> +	int		maxqp; /* This is fixed to 0 */
> +	/* old EncInfo structure inside dev->encInfo (pEncInfo->openParam = *pop) */
> +	u32		stream_rd_ptr; /* This can be safely removed (use bitstream_buf instead) */
> +	u32		stream_buf_start_addr; /* This can be removed (use bitstream_buf instead) */
> +	u32		stream_buf_size; /* This can be removed (use bitstream_buf_size) instead */
> +	u32		stream_buf_end_addr; /* This can be just dropped */
> +	struct framebuffer frame_buf_pool[CODA_ENC_OUTPUT_BUFS]; /* Can be removed if we write to parabuf directly */
> +	int		initial_info_obtained; /* This probably can be removed (framework protects) */
> +	int		num_frame_buffers; /* This can be removed */
> +	int		stride; /* This can be removed later */
> +	struct framebuffer source_frame; /* This is only used to pass data to 'encoder_submit' */
> +	int		quant_param; /* idem */
> +	int		force_ipicture; /* idem */
> +	int		skip_picture; /* idem */
> +	int		all_inter_mb; /* idem */
> +	u32		pic_stream_buffer_addr; /* idem */
> +	int		pic_stream_buffer_size; /* idem */
> +	/* headers */
> +	char		vpu_header[3][64];
> +	int		vpu_header_size[3];
> +};
> +
> +struct coda_ctx {
> +	struct coda_dev		*dev;
> +	int				aborting;
> +	int				rawstreamon;
> +	int				compstreamon;
> +	u32				isequence;
> +	struct coda_q_data		q_data[2];
> +	enum coda_inst_type		inst_type;
> +	struct coda_enc_params	enc_params;
> +	struct coda_enc_runtime	runtime;
> +	struct v4l2_m2m_ctx		*m2m_ctx;
> +	struct v4l2_ctrl_handler	ctrls;
> +	struct v4l2_fh			fh;
> +	struct vb2_buffer		*reference;
> +	int				gopcounter;
> +};
> +
> +static inline void coda_write(struct coda_dev *dev, u32 data, u32 reg)
> +{
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
> +		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
> +	writel(data, dev->regs_base + reg);
> +}
> +
> +static inline unsigned int coda_read(struct coda_dev *dev, u32 reg)
> +{
> +	u32 data;
> +	data = readl(dev->regs_base + reg);
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
> +		 "%s: data=0x%x, reg=0x%x\n", __func__, data, reg);
> +	return data;
> +}
> +
> +static inline unsigned long coda_isbusy(struct coda_dev *dev) {
> +	return coda_read(dev, CODA_REG_BIT_BUSY);
> +}
> +
> +static inline int coda_is_initialized(struct coda_dev *dev) {
> +	return (coda_read(dev, CODA_REG_BIT_CUR_PC) != 0);
> +}
> +
> +static void coda_command_async(struct coda_dev *dev, int codec_mode,
> +				  int cmd)
> +{
> +	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
> +	/* TODO: 0 for the first instance of (encoder-decoder), 1 for the second one
> +	 *(except firmware which is always 0) */
> +	coda_write(dev, 0, CODA_REG_BIT_RUN_INDEX);
> +	coda_write(dev, codec_mode, CODA_REG_BIT_RUN_COD_STD);
> +	coda_write(dev, cmd, CODA_REG_BIT_RUN_COMMAND);
> +}
> +
> +static int coda_command_sync(struct coda_dev *dev, int codec_mode,
> +				int cmd)
> +{
> +	unsigned int timeout = 100000;
> +
> +	coda_command_async(dev, codec_mode, cmd);
> +	while (coda_isbusy(dev)) {
> +	if (timeout-- == 0)
> +		return -ETIMEDOUT;

Missing indention. Also, this should be converted to some deterministic
timeout value.

> +	};
> +	return 0;
> +}
> +
> +struct coda_q_data *get_q_data(struct coda_ctx *ctx,
> +					 enum v4l2_buf_type type);
> +
> +#define fh_to_ctx(__fh) container_of(__fh, struct coda_ctx, fh)
> +
> +#endif
> diff --git a/drivers/media/video/coda/coda_enc.c b/drivers/media/video/coda/coda_enc.c
> new file mode 100644
> index 0000000..a280839
> --- /dev/null
> +++ b/drivers/media/video/coda/coda_enc.c
> @@ -0,0 +1,1130 @@
> +/*
> + * CodaDx6 multi-standard codec IP
> + *
> + * Copyright (C) 2012 Vista Silicon S.L.
> + *    Javier Martin, <javier.martin@vista-silicon.com>
> + *    Xavier Duret
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/irq.h>
> +
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "coda_common.h"
> +#include "coda_enc.h"
> +
> +#define CODA_ENC_MAX_WIDTH		720
> +#define CODA_ENC_MAX_HEIGHT		576
> +#define CODA_ENC_MAX_FRAME_SIZE	0x90000
> +#define FMO_SLICE_SAVE_BUF_SIZE         (32)
> +
> +#define MIN_W 176
> +#define MIN_H 144
> +#define MAX_W 720
> +#define MAX_H 576
> +
> +#define S_ALIGN		1 /* multiple of 2 */
> +#define W_ALIGN		1 /* multiple of 2 */
> +#define H_ALIGN		1 /* multiple of 2 */
> +
> +static struct coda_fmt formats[] = {
> +        {
> +                .name = "YUV 4:2:0 Planar",
> +                .fourcc = V4L2_PIX_FMT_YUV420,
> +                .type = CODA_FMT_RAW,
> +        },
> +        {
> +                .name = "H264 Encoded Stream",
> +                .fourcc = V4L2_PIX_FMT_H264,
> +                .type = CODA_FMT_ENC,
> +        },
> +        {
> +                .name = "MPEG4 Encoded Stream",
> +                .fourcc = V4L2_PIX_FMT_MPEG4,
> +                .type = CODA_FMT_ENC,
> +        },
> +};
> +
> +#define NUM_FORMATS ARRAY_SIZE(formats)
> +
> +static struct coda_fmt *find_format(struct v4l2_format *f)
> +{
> +	struct coda_fmt *fmt;
> +	unsigned int k;
> +
> +	for (k = 0; k < NUM_FORMATS; k++) {
> +		fmt = &formats[k];
> +		if (fmt->fourcc == f->fmt.pix.pixelformat)
> +			break;
> +	}
> +
> +	if (k == NUM_FORMATS)
> +		return NULL;
> +
> +	return &formats[k];
> +}
> +
> +/*
> + * V4L2 ioctl() operations.
> + */
> +static int vidioc_querycap(struct file *file, void *priv,
> +			   struct v4l2_capability *cap)
> +{
> +	strncpy(cap->driver, CODA_ENC_NAME, sizeof(cap->driver) - 1);
> +	strncpy(cap->card, CODA_ENC_NAME, sizeof(cap->card) - 1);
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
> +			  | V4L2_CAP_STREAMING;
> +
> +	return 0;
> +}
> +
> +static int enum_fmt(struct v4l2_fmtdesc *f, enum coda_fmt_type type)
> +{
> +	struct coda_fmt *fmt;
> +	int i, num = 0;
> +	
> +	for (i = 0; i < NUM_FORMATS; i++) {
> +		if (formats[i].type == type) {
> +			if (num == f->index)
> +				break;
> +			++num;
> +		}
> +	}
> +
> +	if (i < NUM_FORMATS) {
> +		fmt = &formats[i];
> +		strlcpy(f->description, fmt->name, sizeof(f->description) - 1);
> +		f->pixelformat = fmt->fourcc;
> +		return 0;
> +	}
> +
> +	/* Format not found */
> +	return -EINVAL;
> +}
> +
> +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	return enum_fmt(f, CODA_FMT_ENC);
> +}
> +
> +static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
> +				   struct v4l2_fmtdesc *f)
> +{
> +	return enum_fmt(f, CODA_FMT_RAW);
> +}
> +
> +static int vidioc_g_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct vb2_queue *vq;
> +	struct coda_q_data *q_data;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, f->type);
> +
> +	f->fmt.pix.field	= V4L2_FIELD_NONE;
> +	f->fmt.pix.pixelformat	= q_data->fmt->fourcc;
> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
> +		f->fmt.pix.width	= q_data->width;
> +		f->fmt.pix.height	= q_data->height;
> +		f->fmt.pix.bytesperline = q_data->width * 3 / 2;
> +	} else { /* encoded formats h.264/mpeg4 */
> +		f->fmt.pix.width	= 0;
> +		f->fmt.pix.height	= 0;
> +		f->fmt.pix.bytesperline = q_data->sizeimage;
> +	}
> +	f->fmt.pix.sizeimage	= q_data->sizeimage;
> +
> +	return 0;
> +}
> +
> +static int vidioc_g_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(fh_to_ctx(priv), f);
> +}
> +
> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	return vidioc_g_fmt(fh_to_ctx(priv), f);
> +}
> +
> +static int vidioc_try_fmt(struct v4l2_format *f)
> +{
> +	enum v4l2_field field;
> +
> +	if (!find_format(f))
> +		return -EINVAL;
> +
> +	field = f->fmt.pix.field;
> +	if (field == V4L2_FIELD_ANY)
> +		field = V4L2_FIELD_NONE;
> +	else if (V4L2_FIELD_NONE != field)
> +		return -EINVAL;
> +
> +	/* V4L2 specification suggests the driver corrects the format struct
> +	 * if any of the dimensions is unsupported */
> +	f->fmt.pix.field = field;
> +
> +	if (f->fmt.pix.pixelformat == V4L2_PIX_FMT_YUV420) {
> +		v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
> +				      W_ALIGN, &f->fmt.pix.height,
> +				      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
> +		f->fmt.pix.bytesperline = f->fmt.pix.width * 3 / 2;
> +		f->fmt.pix.sizeimage = f->fmt.pix.height *
> +					f->fmt.pix.bytesperline;
> +	} else { /*encoded formats h.264/mpeg4 */
> +		f->fmt.pix.bytesperline = CODA_ENC_MAX_FRAME_SIZE;
> +		f->fmt.pix.sizeimage = CODA_ENC_MAX_FRAME_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct coda_fmt *fmt;
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	fmt = find_format(f);
> +	if (!fmt || !(fmt->type == CODA_FMT_ENC)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return vidioc_try_fmt(f);
> +}
> +
> +static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct coda_fmt *fmt;
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	fmt = find_format(f);
> +	if (!fmt || !(fmt->type == CODA_FMT_RAW)) {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Fourcc format (0x%08x) invalid.\n",
> +			 f->fmt.pix.pixelformat);
> +		return -EINVAL;
> +	}
> +
> +	return vidioc_try_fmt(f);
> +}
> +
> +static int vidioc_s_fmt(struct coda_ctx *ctx, struct v4l2_format *f)
> +{
> +	struct coda_q_data *q_data;
> +	struct vb2_queue *vq;
> +	int ret;
> +
> +	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
> +	if (!vq)
> +		return -EINVAL;
> +
> +	q_data = get_q_data(ctx, f->type);
> +	if (!q_data)
> +		return -EINVAL;
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&ctx->dev->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	ret = vidioc_try_fmt(f);
> +	if (ret)
> +		return ret;
> +
> +	q_data->fmt		= find_format(f);
> +	if (q_data->fmt->fourcc == V4L2_PIX_FMT_YUV420) {
> +		q_data->width		= f->fmt.pix.width;
> +		q_data->height		= f->fmt.pix.height;
> +		q_data->sizeimage = q_data->width * q_data->height * 3 / 2;
> +	} else { /* encoded format h.264/mpeg-4 */
> +		q_data->sizeimage = CODA_ENC_MAX_FRAME_SIZE;
> +	}
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +		"Setting format for type %d, wxh: %dx%d, fmt: %d\n",
> +		f->type, q_data->width, q_data->height, q_data->fmt->fourcc);
> +
> +	return 0;
> +}
> +
> +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	int ret;
> +
> +	ret = vidioc_try_fmt_vid_cap(file, fh_to_ctx(priv), f);
> +	if (ret)
> +		return ret;
> +
> +	return vidioc_s_fmt(fh_to_ctx(priv), f);
> +}
> +
> +static int vidioc_s_fmt_vid_out(struct file *file, void *priv,
> +				struct v4l2_format *f)
> +{
> +	int ret;
> +
> +	ret = vidioc_try_fmt_vid_out(file, fh_to_ctx(priv), f);
> +	if (ret)
> +		return ret;
> +
> +	return vidioc_s_fmt(fh_to_ctx(priv), f);
> +}
> +
> +static int vidioc_reqbufs(struct file *file, void *priv,
> +			  struct v4l2_requestbuffers *reqbufs)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_reqbufs(file, ctx->m2m_ctx, reqbufs);
> +}
> +
> +static int vidioc_querybuf(struct file *file, void *priv,
> +			   struct v4l2_buffer *buf)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_querybuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	int ret;
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +	
> +	ret = v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> +	return ret;
> +}
> +
> +static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_dqbuf(file, ctx->m2m_ctx, buf);
> +}
> +
> +static int vidioc_streamon(struct file *file, void *priv,
> +			   enum v4l2_buf_type type)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
> +}
> +
> +static int vidioc_streamoff(struct file *file, void *priv,
> +			    enum v4l2_buf_type type)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	return v4l2_m2m_streamoff(file, ctx->m2m_ctx, type);
> +}
> +
> +int vidioc_s_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
> +{

static

> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		if (a->parm.output.timeperframe.numerator != 1) {
> +			v4l2_err(&ctx->dev->v4l2_dev,
> +				 "FPS numerator must be 1\n");
> +			return -EINVAL;
> +		}
> +		ctx->enc_params.framerate =
> +					a->parm.output.timeperframe.denominator;
> +	} else {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Setting FPS is only possible for the output queue\n");
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +int vidioc_g_parm(struct file *file, void *priv, struct v4l2_streamparm *a)
> +{

static

> +	struct coda_ctx *ctx = fh_to_ctx(priv);
> +
> +	if (a->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		a->parm.output.timeperframe.denominator =
> +					ctx->enc_params.framerate;
> +		a->parm.output.timeperframe.numerator = 1;
> +	} else {
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			 "Getting FPS is only possible for the output queue\n");
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops coda_enc_ioctl_ops = {
> +	.vidioc_querycap	= vidioc_querycap,
> +
> +	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
> +	.vidioc_g_fmt_vid_cap	= vidioc_g_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap	= vidioc_try_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap	= vidioc_s_fmt_vid_cap,
> +
> +	.vidioc_enum_fmt_vid_out = vidioc_enum_fmt_vid_out,
> +	.vidioc_g_fmt_vid_out	= vidioc_g_fmt_vid_out,
> +	.vidioc_try_fmt_vid_out	= vidioc_try_fmt_vid_out,
> +	.vidioc_s_fmt_vid_out	= vidioc_s_fmt_vid_out,
> +
> +	.vidioc_reqbufs		= vidioc_reqbufs,
> +	.vidioc_querybuf	= vidioc_querybuf,
> +
> +	.vidioc_qbuf		= vidioc_qbuf,
> +	.vidioc_dqbuf		= vidioc_dqbuf,
> +
> +	.vidioc_streamon	= vidioc_streamon,
> +	.vidioc_streamoff	= vidioc_streamoff,
> +
> +	.vidioc_s_parm		= vidioc_s_parm,
> +	.vidioc_g_parm		= vidioc_g_parm,
> +};
> +
> +const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void)
> +{
> +	return &coda_enc_ioctl_ops;
> +}
> +
> +/*
> + * Mem-to-mem operations.
> + */
> +
> +int coda_enc_isr(struct coda_dev *dev)
> +{
> +	struct coda_ctx *ctx;
> +	struct vb2_buffer *src_buf, *dst_buf, *tmp_buf;
> +
> +	ctx = v4l2_m2m_get_curr_priv(dev->m2m_enc_dev);
> +	if (ctx == NULL) {
> +		v4l2_err(&dev->v4l2_dev, "Instance released before the end of transaction\n");
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (ctx->aborting) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "task has been aborted\n");
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (coda_isbusy(ctx->dev)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "coda is still busy!!!!\n");
> +		return IRQ_NONE;
> +	}
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +
> +
> +	/* coda_encoder_get_results */
> +	{
> +	u32 tmp1, tmp2;
> +
> +	coda_read(dev, CODA_RET_ENC_PIC_TYPE);
> +	tmp1 = coda_read(dev, CODA_CMD_ENC_PIC_BB_START);
> +	tmp2 = coda_read(dev, CODA_REG_BIT_WR_PTR_0);
> +	/* Calculate bytesused field */
> +	if (dst_buf->v4l2_buf.sequence == 0) {
> +		dst_buf->v4l2_planes[0].bytesused = (tmp2 - tmp1) + ctx->runtime.vpu_header_size[0] +
> +							ctx->runtime.vpu_header_size[1] +
> +							ctx->runtime.vpu_header_size[2];
> +	} else {
> +		dst_buf->v4l2_planes[0].bytesused = (tmp2 - tmp1);
> +	}
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "frame size = %u\n", tmp2-tmp1);
> +	coda_read(dev, CODA_RET_ENC_PIC_SLICE_NUM);
> +	coda_read(dev, CODA_RET_ENC_PIC_FLAG);
> +	}
> +
> +	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
> +		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
> +		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
> +	} else {
> +		dst_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
> +		dst_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
> +	}
> +
> +	/* Free previous reference picture if available */
> +	if (ctx->reference) {
> +		v4l2_m2m_buf_done(ctx->reference, VB2_BUF_STATE_DONE);
> +		ctx->reference = NULL;
> +	}
> +
> +	/* 
> +	 * For the last frame of the gop we don't need to save
> +	 * a reference picture.
> +	 */
> +	v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
> +	tmp_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
> +	if (ctx->gopcounter == 0) {
> +		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +	} else {
> +		ctx->reference = tmp_buf;
> +	}
> +
> +	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
> +
> +	ctx->gopcounter--;
> +	if (ctx->gopcounter < 0)
> +		ctx->gopcounter = ctx->enc_params.gop_size - 1;
> +
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
> +		"job finished: encoding frame (%d) (%s)\n",
> +		dst_buf->v4l2_buf.sequence,
> +		(dst_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) ?
> +		"KEYFRAME" : "PFRAME");
> +
> +	v4l2_m2m_job_finish(ctx->dev->m2m_enc_dev, ctx->m2m_ctx);
> +	
> +	return IRQ_HANDLED;
> +}
> +
> +static void coda_device_run(void *m2m_priv)
> +{
> +	struct coda_ctx *ctx = m2m_priv;
> +	struct coda_q_data *q_data_src, *q_data_dst;
> +	struct vb2_buffer *src_buf, *dst_buf;
> +	struct coda_dev *dev = ctx->dev;
> +
> +	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
> +	dst_buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +	q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +	q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +
> +
> +	src_buf->v4l2_buf.sequence = ctx->isequence;
> +	dst_buf->v4l2_buf.sequence = ctx->isequence;
> +	ctx->isequence++;
> +
> +	/* 
> +	 * Workaround coda firmware BUG that only marks the first
> +	 * frame as IDR. This is a problem for some decoders that can't
> +	 * recover when a frame is lost.
> +	 */
> +	if (src_buf->v4l2_buf.sequence % ctx->enc_params.gop_size) {
> +		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_PFRAME;
> +		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_KEYFRAME;
> +	} else {
> +		src_buf->v4l2_buf.flags |= V4L2_BUF_FLAG_KEYFRAME;
> +		src_buf->v4l2_buf.flags &= ~V4L2_BUF_FLAG_PFRAME;
> +	}
> +
> +	ctx->runtime.source_frame.y = vb2_dma_contig_plane_dma_addr(src_buf, 0);
> +	ctx->runtime.source_frame.cb = ctx->runtime.source_frame.y +
> +				q_data_src->width * q_data_src->height;
> +	ctx->runtime.source_frame.cr = ctx->runtime.source_frame.cb +
> +				q_data_src->width / 2 * q_data_src->height / 2;
> +
> +	if (src_buf->v4l2_buf.flags & V4L2_BUF_FLAG_KEYFRAME) {
> +		ctx->runtime.force_ipicture = 1;
> +		if (ctx->enc_params.codec_mode == CODA_MODE_ENCODE_H264) {
> +			ctx->runtime.quant_param = ctx->enc_params.h264_intra_qp;
> +		} else {
> +			ctx->runtime.quant_param = ctx->enc_params.mpeg4_intra_qp;
> +		}
> +	} else {
> +		ctx->runtime.force_ipicture = 0;
> +		if (ctx->enc_params.codec_mode == CODA_MODE_ENCODE_H264) {
> +			ctx->runtime.quant_param = ctx->enc_params.h264_inter_qp;
> +		} else {
> +			ctx->runtime.quant_param = ctx->enc_params.mpeg4_inter_qp;
> +		}
> +	}
> +	ctx->runtime.skip_picture = 0;
> +	ctx->runtime.all_inter_mb = 0;
> +
> +	/*
> +	 * Copy headers at the beginning of the first frame for H.264 only.
> +	 * In MPEG4 they are already copied by the coda.
> +	 */
> +	if (src_buf->v4l2_buf.sequence == 0) {
> +		ctx->runtime.pic_stream_buffer_addr =
> +			vb2_dma_contig_plane_dma_addr(dst_buf, 0) +
> +			ctx->runtime.vpu_header_size[0] +
> +			ctx->runtime.vpu_header_size[1] +
> +			ctx->runtime.vpu_header_size[2];
> +		ctx->runtime.pic_stream_buffer_size = CODA_ENC_MAX_FRAME_SIZE -
> +			ctx->runtime.vpu_header_size[0] -
> +			ctx->runtime.vpu_header_size[1] -
> +			ctx->runtime.vpu_header_size[2];
> +		memcpy(vb2_plane_vaddr(dst_buf, 0),
> +		       &ctx->runtime.vpu_header[0][0], ctx->runtime.vpu_header_size[0]);
> +		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->runtime.vpu_header_size[0],
> +		       &ctx->runtime.vpu_header[1][0], ctx->runtime.vpu_header_size[1]);
> +		memcpy(vb2_plane_vaddr(dst_buf, 0) + ctx->runtime.vpu_header_size[0] + ctx->runtime.vpu_header_size[1],
> +		       &ctx->runtime.vpu_header[2][0], ctx->runtime.vpu_header_size[2]);
> +	} else {
> +		ctx->runtime.pic_stream_buffer_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
> +		ctx->runtime.pic_stream_buffer_size = CODA_ENC_MAX_FRAME_SIZE;
> +	}
> +	
> +	/* coda_encoder_submit */
> +	{
> +		coda_write(dev, 0, CODA_CMD_ENC_PIC_ROT_MODE);
> +		coda_write(dev, ctx->runtime.quant_param, CODA_CMD_ENC_PIC_QS);
> +		
> +		if (ctx->runtime.skip_picture) {
> +			coda_write(dev, 1, CODA_CMD_ENC_PIC_OPTION);
> +		} else {
> +			coda_write(dev, ctx->runtime.source_frame.y, CODA_CMD_ENC_PIC_SRC_ADDR_Y);
> +			coda_write(dev, ctx->runtime.source_frame.cb, CODA_CMD_ENC_PIC_SRC_ADDR_CB);
> +			coda_write(dev, ctx->runtime.source_frame.cr, CODA_CMD_ENC_PIC_SRC_ADDR_CR);
> +			coda_write(dev, (ctx->runtime.all_inter_mb << 5) | (ctx->runtime.force_ipicture << 1 & 0x2), CODA_CMD_ENC_PIC_OPTION);
> +		}
> +
> +		coda_write(dev, ctx->runtime.pic_stream_buffer_addr, CODA_CMD_ENC_PIC_BB_START);
> +		coda_write(dev, ctx->runtime.pic_stream_buffer_size / 1024, CODA_CMD_ENC_PIC_BB_SIZE);
> +		coda_command_async(dev, ctx->enc_params.codec_mode, CODA_COMMAND_PIC_RUN);
> +	}
> +}
> +
> +static int coda_job_ready(void *m2m_priv)
> +{
> +	struct coda_ctx *ctx = m2m_priv;
> +
> +	/* 
> +	 * For both 'P' and 'key' frame cases 1 picture
> +	 * and 1 frame are needed.
> +	 */
> +	if (!(v4l2_m2m_num_src_bufs_ready(ctx->m2m_ctx) >= 1) ||
> +		!(v4l2_m2m_num_dst_bufs_ready(ctx->m2m_ctx) >= 1)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "not ready: not enough video buffers.\n");
> +		return 0;
> +	}
> +
> +	/* For P frames a reference picture is needed too */
> +	if ((ctx->gopcounter != (ctx->enc_params.gop_size - 1)) && (!ctx->reference)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "not ready: reference picture not available.\n");
> +		return 0;
> +	}
> +
> +	if (coda_isbusy(ctx->dev)) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			 "not ready: coda is still busy.\n");
> +		return 0;
> +	}
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +			"job ready\n");
> +	return 1;
> +}
> +
> +static void coda_job_abort(void *priv)
> +{
> +	struct coda_ctx *ctx = priv;
> +	struct coda_dev *dev = ctx->dev;
> +
> +	ctx->aborting = 1;
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +		 "Aborting task\n");
> +	
> +	v4l2_m2m_job_finish(dev->m2m_enc_dev, ctx->m2m_ctx);
> +}
> +
> +static void coda_lock(void *m2m_priv)
> +{
> +	struct coda_ctx *ctx = m2m_priv;
> +	struct coda_dev *pcdev = ctx->dev;
> +	mutex_lock(&pcdev->dev_mutex);
> +}
> +
> +static void coda_unlock(void *m2m_priv)
> +{
> +	struct coda_ctx *ctx = m2m_priv;
> +	struct coda_dev *pcdev = ctx->dev;
> +	mutex_unlock(&pcdev->dev_mutex);
> +}
> +
> +static struct v4l2_m2m_ops coda_enc_m2m_ops = {
> +	.device_run	= coda_device_run,
> +	.job_ready	= coda_job_ready,
> +	.job_abort	= coda_job_abort,
> +	.lock		= coda_lock,
> +	.unlock		= coda_unlock,
> +};
> +
> +struct v4l2_m2m_ops *get_enc_m2m_ops(void)
> +{
> +	return &coda_enc_m2m_ops;
> +}
> +
> +void set_enc_default_params(struct coda_ctx *ctx) {
> +	ctx->enc_params.codec_mode = CODA_MODE_INVALID;
> +	ctx->enc_params.framerate = 30;
> +	ctx->reference = NULL;
> +	ctx->aborting = 0;
> +
> +	/* Default formats for output and input queues */
> +	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[0];
> +	ctx->q_data[V4L2_M2M_DST].fmt = &formats[1];
> +}
> +
> +/*
> + * Queue operations
> + */
> +static int coda_enc_queue_setup(struct vb2_queue *vq,
> +				const struct v4l2_format *fmt,
> +				unsigned int *nbuffers, unsigned int *nplanes,
> +				unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(vq);
> +	unsigned int size;
> +
> +	if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		*nbuffers = CODA_ENC_OUTPUT_BUFS;
> +		if (fmt)
> +			size = fmt->fmt.pix.width *
> +				fmt->fmt.pix.height * 3 / 2;
> +		else
> +			size = CODA_ENC_MAX_WIDTH *
> +				CODA_ENC_MAX_HEIGHT * 3 / 2;
> +	} else {
> +		*nbuffers = CODA_ENC_CAPTURE_BUFS;
> +		size = CODA_ENC_MAX_FRAME_SIZE;
> +	}
> +	
> +	*nplanes = 1;
> +	sizes[0] = size;
> +
> +	alloc_ctxs[0] = ctx->dev->alloc_enc_ctx;
> +
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +		 "get %d buffer(s) of size %d each.\n", *nbuffers, size);
> +
> +	return 0;
> +}
> +
> +static int coda_enc_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	struct coda_q_data *q_data;
> +
> +	q_data = get_q_data(ctx, vb->vb2_queue->type);
> +
> +	if (vb2_plane_size(vb, 0) < q_data->sizeimage) {
> +		v4l2_warn(&ctx->dev->v4l2_dev, "%s data will not fit into"
> +			"plane (%lu < %lu)\n", __func__, vb2_plane_size(vb, 0),
> +			(long)q_data->sizeimage);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, q_data->sizeimage);
> +
> +	return 0;
> +}
> +
> +static void coda_enc_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
> +	v4l2_m2m_buf_queue(ctx->m2m_ctx, vb);
> +}
> +
> +static void coda_wait_prepare(struct vb2_queue *q)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +	coda_unlock(ctx);
> +}
> +
> +static void coda_wait_finish(struct vb2_queue *q)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +	coda_lock(ctx);
> +}
> +
> +static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +	struct coda_dev *dev = ctx->dev;
> +
> +	if (count < 1)
> +		return -EINVAL;
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		ctx->rawstreamon = 1;
> +	} else {
> +		ctx->compstreamon = 1;
> +	}
> +
> +	if (ctx->rawstreamon & ctx->compstreamon) {
> +		struct coda_q_data *q_data_src, *q_data_dst;
> +		struct vb2_buffer *buf;
> +		struct vb2_queue *vq;
> +		u32 value;
> +		int i = 0;
> +
> +		ctx->gopcounter = ctx->enc_params.gop_size - 1;
> +
> +		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +		ctx->runtime.pic_width = q_data_src->width;
> +		ctx->runtime.pic_height = q_data_src->height;
> +		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +		ctx->runtime.bitstream_buf = vb2_dma_contig_plane_dma_addr(buf, 0);
> +		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> +		ctx->runtime.bitstream_buf_size = q_data_dst->sizeimage;
> +		ctx->runtime.bitstream_format = q_data_dst->fmt->fourcc;
> +		ctx->runtime.initial_delay = 0;
> +		ctx->runtime.vbv_buffer_size = 0;
> +		ctx->runtime.enable_autoskip = 1;
> +		ctx->runtime.intra_refresh = 0;
> +		ctx->runtime.gamma = 4096;
> +		ctx->runtime.maxqp = 0;
> +
> +		if (!coda_is_initialized(dev)) {
> +			v4l2_err(&ctx->dev->v4l2_dev, "coda is not initialized.\n");
> +			return -EFAULT;
> +		}
> +
> +		/* coda_encoder_init */
> +		{

Why this '{'? Without indention this looks even more strange.

> +		
> +		if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) {
> +			ctx->enc_params.codec_mode = CODA_MODE_ENCODE_H264;
> +		} else if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_MPEG4) {
> +			ctx->enc_params.codec_mode = CODA_MODE_ENCODE_M4S2;
> +		}
> +
> +		ctx->runtime.stream_rd_ptr = ctx->runtime.bitstream_buf;
> +		ctx->runtime.stream_buf_start_addr = ctx->runtime.bitstream_buf;
> +		ctx->runtime.stream_buf_size = ctx->runtime.bitstream_buf_size;
> +		ctx->runtime.stream_buf_end_addr = ctx->runtime.bitstream_buf +
> +						ctx->runtime.bitstream_buf_size;
> +		ctx->runtime.initial_info_obtained = 0;
> +
> +		coda_write(dev, ctx->runtime.stream_rd_ptr, CODA_REG_BIT_RD_PTR_0);
> +		coda_write(dev, ctx->runtime.stream_buf_start_addr, CODA_REG_BIT_WR_PTR_0);
> +		value = coda_read(dev, CODA_REG_BIT_STREAM_CTRL);
> +		value &= 0xffe7;

This is equivalent to value &= ~(3 << 3) which is more readable.


> +		value |= 3 << 3;
> +		coda_write(dev, value, CODA_REG_BIT_STREAM_CTRL);
> +		}
> +
> +		/* walk the src ready list and store buffer phys addresses  */
> +		vq = v4l2_m2m_get_vq(ctx->m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> +		for (i = 0; i < vq->num_buffers; i++) {
> +			buf = vq->bufs[i];
> +			ctx->runtime.frame_buf_pool[i].y = vb2_dma_contig_plane_dma_addr(buf, 0);
> +			ctx->runtime.frame_buf_pool[i].cb = ctx->runtime.frame_buf_pool[i].y +
> +				q_data_src->width * q_data_src->height;
> +			ctx->runtime.frame_buf_pool[i].cr = ctx->runtime.frame_buf_pool[i].cb +
> +				q_data_src->width / 2 * q_data_src->height / 2;
> +		}
> +		ctx->runtime.num_frame_buffers = vq->num_buffers;
> +		ctx->runtime.stride = q_data_src->width;
> +		
> +		/* coda_encoder_configure */
> +		{
> +		u32 data;
> +
> +		coda_write(dev, 0xFFFF4C00, CODA_REG_BIT_SEARCH_RAM_BASE_ADDR);
> +
> +		/* Could set rotation here if needed */
> +		data = (ctx->runtime.pic_width & CODA_PICWIDTH_MASK) << CODA_PICWIDTH_OFFSET;
> +		data |= (ctx->runtime.pic_height & CODA_PICHEIGHT_MASK) << CODA_PICHEIGHT_OFFSET;
> +		coda_write(dev, data, CODA_CMD_ENC_SEQ_SRC_SIZE);
> +		coda_write(dev, ctx->enc_params.framerate, CODA_CMD_ENC_SEQ_SRC_F_RATE);
> +
> +		if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_MPEG4) {
> +			coda_write(dev, CODA_ENCODE_MPEG4, CODA_CMD_ENC_SEQ_COD_STD);
> +			data  = (0 & CODA_MP4PARAM_VERID_MASK) << CODA_MP4PARAM_VERID_OFFSET;
> +			data |= (0 & CODA_MP4PARAM_INTRADCVLCTHR_MASK) << CODA_MP4PARAM_INTRADCVLCTHR_OFFSET;
> +			data |= (0 & CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK) << CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET;
> +			data |=  0 & CODA_MP4PARAM_DATAPARTITIONENABLE_MASK;
> +			coda_write(dev, data, CODA_CMD_ENC_SEQ_MP4_PARA);
> +		} else if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) {
> +			coda_write(dev, CODA_ENCODE_H264, CODA_CMD_ENC_SEQ_COD_STD);
> +			data  = (0 & CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET;
> +			data |= (0 & CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK) << CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET;
> +			data |= (0 & CODA_264PARAM_DISABLEDEBLK_MASK) << CODA_264PARAM_DISABLEDEBLK_OFFSET;
> +			data |= (0 & CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK) << CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET;
> +			data |=  0 & CODA_264PARAM_CHROMAQPOFFSET_MASK;
> +			coda_write(dev, data, CODA_CMD_ENC_SEQ_264_PARA);
> +		}

Since the device has more supported formats can we do a switch/case here
from the start? Also, default: is missing.

> +
> +		data  = (ctx->enc_params.slice_max_mb & CODA_SLICING_SIZE_MASK) << CODA_SLICING_SIZE_OFFSET;
> +		data |= (1 & CODA_SLICING_UNIT_MASK) << CODA_SLICING_UNIT_OFFSET;
> +		if (ctx->enc_params.slice_mode == V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB)
> +			data |=  1 & CODA_SLICING_MODE_MASK;
> +		coda_write(dev, data, CODA_CMD_ENC_SEQ_SLICE_MODE);
> +		data  =  ctx->enc_params.gop_size & CODA_GOP_SIZE_MASK;
> +		coda_write(dev, data, CODA_CMD_ENC_SEQ_GOP_SIZE);
> +		
> +		if (ctx->enc_params.bitrate) {
> +			/* Rate control enabled */
> +			data  = ((!ctx->runtime.enable_autoskip) & CODA_RATECONTROL_AUTOSKIP_MASK) << CODA_RATECONTROL_AUTOSKIP_OFFSET;
> +			data |= (ctx->runtime.initial_delay & CODA_RATECONTROL_INITIALDELAY_MASK) << CODA_RATECONTROL_INITIALDELAY_OFFSET;
> +			data |= (ctx->enc_params.bitrate & CODA_RATECONTROL_BITRATE_MASK) << CODA_RATECONTROL_BITRATE_OFFSET;
> +			data |=  1 & CODA_RATECONTROL_ENABLE_MASK;
> +		} else {
> +			data = 0;
> +		}
> +		coda_write(dev, data, CODA_CMD_ENC_SEQ_RC_PARA);
> +
> +		coda_write(dev, ctx->runtime.vbv_buffer_size, CODA_CMD_ENC_SEQ_RC_BUF_SIZE);
> +		coda_write(dev, ctx->runtime.intra_refresh, CODA_CMD_ENC_SEQ_INTRA_REFRESH);
> +
> +		coda_write(dev, ctx->runtime.stream_buf_start_addr, CODA_CMD_ENC_SEQ_BB_START);
> +		coda_write(dev, ctx->runtime.stream_buf_size / 1024, CODA_CMD_ENC_SEQ_BB_SIZE);
> +
> +		if (ctx->runtime.maxqp) {
> +			/* adjust qp if they are above the maximum */
> +			if ((ctx->runtime.bitstream_format == V4L2_PIX_FMT_MPEG4) && (ctx->runtime.maxqp > 31)) ctx->runtime.maxqp = 31;  
> +			if ((ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) && (ctx->runtime.maxqp > 51)) ctx->runtime.maxqp = 51;
> +			data = (ctx->runtime.maxqp & CODA_QPMAX_MASK) << CODA_QPMAX_OFFSET;
> +			coda_write(dev, data, CODA_CMD_ENC_SEQ_RC_QP_MAX);
> +		}
> +    
> +		if (ctx->runtime.gamma) {
> +			/* set default gamma if not set */
> +			if (ctx->runtime.gamma > 32768) ctx->runtime.gamma = 32768;
> +			data = (ctx->runtime.gamma & CODA_GAMMA_MASK) << CODA_GAMMA_OFFSET;
> +			coda_write(dev, data, CODA_CMD_ENC_SEQ_RC_GAMMA);
> +		}
> +
> +		data  = (ctx->runtime.gamma > 0) << CODA_OPTION_GAMMA_OFFSET;
> +		data |= (ctx->runtime.maxqp > 0) << CODA_OPTION_LIMITQP_OFFSET;
> +		data |= (0 & CODA_OPTION_SLICEREPORT_MASK) << CODA_OPTION_SLICEREPORT_OFFSET;
> +		coda_write(dev, data, CODA_CMD_ENC_SEQ_OPTION);
> +
> +		if (ctx->enc_params.codec_mode == CODA_MODE_ENCODE_H264) {
> +			data  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
> +			data |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
> +			data |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
> +			coda_write(dev, data, CODA_CMD_ENC_SEQ_FMO);
> +		}
> +
> +		if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_SEQ_INIT)) {
> +			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SEQ_INIT timeout\n");
> +			return -ETIMEDOUT;
> +		}
> +
> +		if (coda_read(dev, CODA_RET_ENC_SEQ_SUCCESS) == 0)
> +			return -EFAULT;
> +
> +		/* Let the codec know the addresses of the frame buffers */
> +		for (i = 0; i < ctx->runtime.num_frame_buffers; i++) {
> +			u32 *p;
> +
> +			p = ctx->dev->enc_parabuf.vaddr;
> +			p[i * 3] = ctx->runtime.frame_buf_pool[i].y;
> +			p[i * 3 + 1] = ctx->runtime.frame_buf_pool[i].cb;
> +			p[i * 3 + 2] = ctx->runtime.frame_buf_pool[i].cr;
> +		}
> +		coda_write(dev, ctx->runtime.num_frame_buffers, CODA_CMD_SET_FRAME_BUF_NUM);
> +		coda_write(dev, ctx->runtime.stride, CODA_CMD_SET_FRAME_BUF_STRIDE);
> +		if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_SET_FRAME_BUF)) {
> +			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SET_FRAME_BUF timeout\n");
> +			return -ETIMEDOUT;
> +		}
> +
> +		ctx->runtime.initial_info_obtained = 1;
> +		}
> +
> +		/* Save stream headers */
> +		buf = v4l2_m2m_next_dst_buf(ctx->m2m_ctx);
> +		if (ctx->runtime.bitstream_format == V4L2_PIX_FMT_H264) {
> +			/* Get SPS in the first frame and copy it to an intermediate buffer TODO: copy directly */
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_H264_SPS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->runtime.vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) - 
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->runtime.vpu_header[0][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[0]);
> +
> +			/* Get PPS in the first frame and copy it to an intermediate buffer TODO: copy directly*/
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_H264_PPS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->runtime.vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) - 
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->runtime.vpu_header[1][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[1]);
> +			ctx->runtime.vpu_header_size[2] = 0;
> +		} else { /* MPEG4 */
> +			/* Get VOS in the first frame and copy it to an intermediate buffer TODO: copy directly */
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev,  ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_MP4V_VOS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER timeout\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->runtime.vpu_header_size[0] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) - 
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->runtime.vpu_header[0][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[0]);
> +
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_MP4V_VIS, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->runtime.vpu_header_size[1] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) -
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->runtime.vpu_header[1][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[1]);
> +
> +			coda_write(dev, vb2_dma_contig_plane_dma_addr(buf, 0), CODA_CMD_ENC_HEADER_BB_START);
> +			coda_write(dev, ctx->runtime.bitstream_buf_size, CODA_CMD_ENC_HEADER_BB_SIZE);
> +			coda_write(dev, CODA_HEADER_MP4V_VOL, CODA_CMD_ENC_HEADER_CODE);
> +			if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_ENCODE_HEADER)) {
> +				v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_ENCODE_HEADER failed\n");
> +				return -ETIMEDOUT;
> +			}
> +			ctx->runtime.vpu_header_size[2] = coda_read(dev, CODA_REG_BIT_WR_PTR_0) -
> +					coda_read(dev, CODA_CMD_ENC_HEADER_BB_START);
> +			memcpy(&ctx->runtime.vpu_header[2][0], vb2_plane_vaddr(buf, 0), ctx->runtime.vpu_header_size[2]);
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int coda_stop_streaming(struct vb2_queue *q)
> +{
> +	struct coda_ctx *ctx = vb2_get_drv_priv(q);
> +	struct coda_dev *dev = ctx->dev;
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "%s: output\n", __func__);
> +		ctx->rawstreamon = 0;
> +	} else {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "%s: capture\n", __func__);
> +		ctx->compstreamon = 0;
> +	}
> +
> +	if (!ctx->rawstreamon & !ctx->compstreamon) {
> +		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev, "%s: sent command 'SEQ_END' to coda\n", __func__);
> +		if (coda_command_sync(dev, ctx->enc_params.codec_mode, CODA_COMMAND_SEQ_END)) {
> +			v4l2_err(&ctx->dev->v4l2_dev, "CODA_COMMAND_SEQ_END failed\n");
> +			return -ETIMEDOUT;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static struct vb2_ops coda_enc_qops = {
> +	.queue_setup		= coda_enc_queue_setup,
> +	.buf_prepare		= coda_enc_buf_prepare,
> +	.buf_queue		= coda_enc_buf_queue,
> +	.wait_prepare		= coda_wait_prepare,
> +	.wait_finish		= coda_wait_finish,
> +	.start_streaming	= coda_start_streaming,
> +	.stop_streaming		= coda_stop_streaming,
> +};
> +
> +struct vb2_ops *get_enc_qops(void)
> +{
> +	return &coda_enc_qops;
> +}
> +
> +static int coda_enc_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct coda_ctx *ctx =
> +			container_of(ctrl->handler, struct coda_ctx, ctrls);
> +	
> +	v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
> +		 "s_ctrl: id = %d, val = %d\n", ctrl->id, ctrl->val);
> +
> +	switch (ctrl->id) {
> +	case V4L2_CID_MPEG_VIDEO_BITRATE:
> +		ctx->enc_params.bitrate = ctrl->val / 1000;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
> +		ctx->enc_params.gop_size = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP:
> +		ctx->enc_params.h264_intra_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP:
> +		ctx->enc_params.h264_inter_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:
> +		ctx->enc_params.mpeg4_intra_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:
> +		ctx->enc_params.mpeg4_inter_qp = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE:
> +		ctx->enc_params.slice_mode = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB:
> +		ctx->enc_params.slice_max_mb = ctrl->val;
> +		break;
> +	case V4L2_CID_MPEG_VIDEO_HEADER_MODE:
> +		break;
> +	default:
> +		v4l2_err(&ctx->dev->v4l2_dev,
> +			"Invalid control, id=%d, val=%d\n",
> +			ctrl->id, ctrl->val);

Should probably be a v4l2_dbg.

> +		return -EINVAL;
> +	}
> +	
> +	return 0;
> +}
> +
> +static struct v4l2_ctrl_ops coda_enc_ctrl_ops = {
> +	.s_ctrl = coda_enc_s_ctrl,
> +};
> +
> +int coda_enc_ctrls_setup(struct coda_ctx *ctx)
> +{
> +	v4l2_ctrl_handler_init(&ctx->ctrls, 9);
> +
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_BITRATE, 0, 32767000, 1, 0);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 60, 1, 16);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_H264_I_FRAME_QP, 1, 51, 1, 25);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_H264_P_FRAME_QP, 1, 51, 1, 25);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP, 1, 31, 1, 2);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
> +	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
> +		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB, 0,
> +		V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB);
> +	v4l2_ctrl_new_std(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MAX_MB, 1, 0x3fffffff, 1, 1);
> +	v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_enc_ctrl_ops,
> +		V4L2_CID_MPEG_VIDEO_HEADER_MODE,
> +		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME,
> +		(1 << V4L2_MPEG_VIDEO_HEADER_MODE_SEPARATE),
> +		V4L2_MPEG_VIDEO_HEADER_MODE_JOINED_WITH_1ST_FRAME);
> +
> +	return v4l2_ctrl_handler_setup(&ctx->ctrls);
> +}
> diff --git a/drivers/media/video/coda/coda_enc.h b/drivers/media/video/coda/coda_enc.h
> new file mode 100644
> index 0000000..09b61f4
> --- /dev/null
> +++ b/drivers/media/video/coda/coda_enc.h
> @@ -0,0 +1,26 @@
> +/*
> + * linux/drivers/media/video/coda/coda_enc.h
> + *
> + * Copyright (C) 2012 Vista Silicon SL
> + *    Javier Martin <javier.martin@vista-silicon.com>
> + *    Xavier Duret
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef _CODA_ENC_H_
> +#define _CODA_ENC_H_
> +
> +#define CODA_ENC_NAME	"coda-enc"
> +
> +const struct v4l2_ioctl_ops *get_enc_v4l2_ioctl_ops(void);
> +struct v4l2_m2m_ops *get_enc_m2m_ops(void);
> +void set_enc_default_params(struct coda_ctx *ctx);
> +struct vb2_ops *get_enc_qops(void);
> +int coda_enc_ctrls_setup(struct coda_ctx *ctx);
> +int coda_enc_isr(struct coda_dev *dev);
> +
> +#endif
> diff --git a/drivers/media/video/coda/coda_main.c b/drivers/media/video/coda/coda_main.c
> new file mode 100644
> index 0000000..6d0b403
> --- /dev/null
> +++ b/drivers/media/video/coda/coda_main.c
> @@ -0,0 +1,513 @@
> +/*
> + * CodaDx6 multi-standard codec IP
> + *
> + * Copyright (C) 2012 Vista Silicon S.L.
> + *    Javier Martin, <javier.martin@vista-silicon.com>
> + *    Xavier Duret
> + * 
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/coda_codec.h>
> +#include <linux/delay.h>
> +#include <linux/firmware.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "coda_common.h"
> +#include "coda_regs.h"
> +#include "coda_enc.h"
> +
> +#define CODA_NAME		"coda"
> +
> +#define CODA_FMO_BUF_SIZE	32
> +#define CODA_CODE_BUF_SIZE	(64 * 1024)
> +#define CODA_WORK_BUF_SIZE	(288 * 1024 + CODA_FMO_BUF_SIZE * 8 * 1024)
> +#define CODA_PARA_BUF_SIZE	(10 * 1024)
> +#define CODA_ISRAM_SIZE	(2048 * 2)
> +
> +#define CODA_SUPPORTED_PRODUCT_ID	0xf001
> +#define CODA_SUPPORTED_MAJOR		2
> +#define CODA_SUPPORTED_MINOR		2
> +#define CODA_SUPPORTED_RELEASE	5
> +
> +int coda_debug = 3;
> +module_param(coda_debug, int, 0);
> +MODULE_PARM_DESC(coda_debug, "Debug level (0-1)");
> +
> +struct coda_q_data *get_q_data(struct coda_ctx *ctx,
> +					 enum v4l2_buf_type type)
> +{
> +	switch (type) {
> +	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> +		return &(ctx->q_data[V4L2_M2M_SRC]);
> +	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> +		return &(ctx->q_data[V4L2_M2M_DST]);
> +	default:
> +		BUG();
> +	}
> +	return NULL;
> +}
> +
> +static enum coda_node_type coda_get_node_type(struct file *file)
> +{
> +	struct video_device *vfd = video_devdata(file);
> +
> +	if (vfd->index == 0)
> +		return CODA_NODE_ENCODER;
> +	else /* decoder not supported */
> +		return CODA_NODE_INVALID;
> +}
> +
> +static int coda_queue_init(void *priv, struct vb2_queue *src_vq,
> +		      struct vb2_queue *dst_vq)
> +{
> +	struct coda_ctx *ctx = priv;
> +	int ret;
> +
> +	memset(src_vq, 0, sizeof(*src_vq));
> +	src_vq->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	src_vq->io_modes = VB2_MMAP;
> +	src_vq->drv_priv = ctx;
> +	src_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	if (ctx->inst_type == CODA_INST_ENCODER) {
> +		src_vq->ops = get_enc_qops();
> +	} else {
> +		v4l2_err(&ctx->dev->v4l2_dev, "Instance not supported\n");
> +		return -EINVAL;
> +	}
> +	src_vq->mem_ops = &vb2_dma_contig_memops;
> +
> +	ret = vb2_queue_init(src_vq);
> +	if (ret)
> +		return ret;
> +
> +	memset(dst_vq, 0, sizeof(*dst_vq));
> +	dst_vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	dst_vq->io_modes = VB2_MMAP;
> +	dst_vq->drv_priv = ctx;
> +	dst_vq->buf_struct_size = sizeof(struct v4l2_m2m_buffer);
> +	if (ctx->inst_type == CODA_INST_ENCODER) {
> +		dst_vq->ops = get_enc_qops();
> +	} else {
> +		v4l2_err(&ctx->dev->v4l2_dev, "Instance not supported\n");
> +		return -EINVAL;
> +	}
> +	dst_vq->mem_ops = &vb2_dma_contig_memops;
> +
> +	return vb2_queue_init(dst_vq);
> +}
> +
> +static int coda_open(struct file *file)
> +{
> +	struct coda_dev *dev = video_drvdata(file);
> +	struct coda_ctx *ctx = NULL;
> +	int ret = 0;
> +
> +	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +

The Coda device supports four instances. In this patch you only use
instance 0, but you do not protect this function from being opened
multiple times. Does this work with multiple opens?

Can we do this driver multiple instance from the start? This could be
done more easily if we do not create seperate device nodes for
encoding/decoding, but when we create a single device node which can be
opened exactly 4 times. The decision whether we do encoder or decoder
can then be done in set_fmt.

> +	v4l2_fh_init(&ctx->fh, video_devdata(file));
> +	file->private_data = &ctx->fh;
> +	v4l2_fh_add(&ctx->fh);
> +	ctx->dev = dev;
> +
> +	if (coda_get_node_type(file) == CODA_NODE_ENCODER) {
> +		ctx->inst_type = CODA_INST_ENCODER;
> +		set_enc_default_params(ctx);
> +		ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_enc_dev, ctx,
> +						 &coda_queue_init);
> +		if (IS_ERR(ctx->m2m_ctx)) {
> +			int ret = PTR_ERR(ctx->m2m_ctx);
> +			
> +			printk("%s return error (%d)\n", __func__, ret);
> +			goto err;
> +		}
> +		ret = coda_enc_ctrls_setup(ctx);
> +		if (ret) {
> +			v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
> +
> +			goto err;
> +		}
> +	} else {
> +		v4l2_err(&dev->v4l2_dev, "node type not supported\n");
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	ctx->fh.ctrl_handler = &ctx->ctrls;
> +
> +	clk_enable(dev->clk);
> +
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %p\n",
> +		 ctx);
> +
> +	return 0;
> +
> +err:
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +	return ret;
> +}
> +
> +static int coda_release(struct file *file)
> +{
> +	struct coda_dev *dev = video_drvdata(file);
> +	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Releasing instance %p\n",
> +		 ctx);
> +
> +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> +	v4l2_ctrl_handler_free(&ctx->ctrls);
> +	clk_disable(dev->clk);
> +	v4l2_fh_del(&ctx->fh);
> +	v4l2_fh_exit(&ctx->fh);
> +	kfree(ctx);
> +
> +	return 0;
> +}
> +
> +static unsigned int coda_poll(struct file *file,
> +				 struct poll_table_struct *wait)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +}
> +
> +static int coda_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct coda_ctx *ctx = fh_to_ctx(file->private_data);
> +
> +	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +}
> +
> +static const struct v4l2_file_operations coda_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= coda_open,
> +	.release	= coda_release,
> +	.poll		= coda_poll,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.mmap		= coda_mmap,
> +};
> +
> +static irqreturn_t coda_irq_handler(int irq, void *data)
> +{
> +	struct coda_dev *dev = data;
> +
> +	printk("%s!!\n", __func__);
> +
> +	/* read status register to attend the IRQ */
> +	coda_read(dev, CODA_REG_BIT_INT_STATUS);
> +	coda_write(dev, CODA_REG_BIT_INT_CLEAR_SET,
> +		      CODA_REG_BIT_INT_CLEAR);
> +
> +	return coda_enc_isr(dev);
> +}
> +
> +static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
> +{
> +	u16 product, major, minor, release;
> +	u32 data;
> +	u16 *p;
> +	int i;
> +
> +	clk_enable(dev->clk);
> +
> +	/* Copy the whole firmware image to the code buffer */
> +	memcpy(dev->enc_codebuf.vaddr, fw->data, fw->size);
> +	/*
> +	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
> +	 * This memory seems to be big-endian here, which is weird, since
> +	 * the internal ARM processor of the coda is little endian.
> +	 * Data in this SRAM survives a reboot.
> +	 */
> +	p = (u16 *)fw->data;
> +	for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
> +		data = CODA_DOWN_ADDRESS_SET(i) |
> +			CODA_DOWN_DATA_SET(p[i ^ 1]);
> +		coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
> +	}
> +	release_firmware(fw);
> +
> +	/* Tell the BIT where to find everything it needs */
> +	coda_write(dev, dev->enc_workbuf.paddr,
> +		      CODA_REG_BIT_WORK_BUF_ADDR);
> +	coda_write(dev, dev->enc_parabuf.paddr,
> +		      CODA_REG_BIT_PARA_BUF_ADDR);
> +	coda_write(dev, dev->enc_codebuf.paddr,
> +		      CODA_REG_BIT_CODE_BUF_ADDR);
> +	coda_write(dev, 0, CODA_REG_BIT_CODE_RUN);
> +
> +	/* Set default values */
> +	coda_write(dev, CODA_STREAM_UNDOCUMENTED,
> +		      CODA_REG_BIT_STREAM_CTRL);
> +	coda_write(dev, 0, CODA_REG_BIT_FRAME_MEM_CTRL);
> +	coda_write(dev, CODA_INT_INTERRUPT_ENABLE,
> +		      CODA_REG_BIT_INT_ENABLE);
> +
> +	/* Reset VPU and start processor */
> +	data = coda_read(dev, CODA_REG_BIT_CODE_RESET);
> +	data |= CODA_REG_RESET_ENABLE;
> +	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
> +	udelay(10);
> +	data &= ~CODA_REG_RESET_ENABLE;
> +	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
> +	coda_write(dev, CODA_REG_RUN_ENABLE, CODA_REG_BIT_CODE_RUN);
> +
> +	/* Load firmware */
> +	coda_write(dev, 0, CODA_CMD_FIRMWARE_VERNUM);
> +	if (coda_command_sync(dev, 0, CODA_COMMAND_FIRMWARE_GET)) {
> +		v4l2_err(&dev->v4l2_dev, "firmware get command error\n");
> +		return -EIO;

You leave the clock enabled here.

> +	}
> +
> +	/* Check we are compatible with the loaded firmware */
> +	data = coda_read(dev, CODA_CMD_FIRMWARE_VERNUM);
> +	product = CODA_FIRMWARE_PRODUCT(data);
> +	major = CODA_FIRMWARE_MAJOR(data);
> +	minor = CODA_FIRMWARE_MINOR(data);
> +	release = CODA_FIRMWARE_RELEASE(data);
> +
> +	if ((product != CODA_SUPPORTED_PRODUCT_ID) ||
> +	    (major != CODA_SUPPORTED_MAJOR) ||
> +	    (minor != CODA_SUPPORTED_MINOR) ||
> +	    (release != CODA_SUPPORTED_RELEASE)) {
> +		v4l2_err(&dev->v4l2_dev, "Wrong firmware:\n product = 0x%04X\n"
> +			" major = %d\n minor = %d\n release = %d\n",
> +			product, major, minor, release);
> +		return -EINVAL;

ditto

> +	}
> +
> +	clk_disable(dev->clk);
> +
> +	v4l2_info(&dev->v4l2_dev, "Initialized. Fw version: %u.%u.%u.%u", product, major, minor, release);
> +
> +	return 0;
> +}
> +
> +static void coda_fw_callback(const struct firmware *fw, void *context)
> +{
> +	struct coda_dev *dev = context;
> +	struct platform_device *pdev = dev->plat_dev;
> +	struct coda_platform_data *pdata = pdev->dev.platform_data;
> +	struct video_device *vfd;
> +	int ret;
> +
> +	if (!fw) {
> +		v4l2_err(&dev->v4l2_dev, "firmware request '%s' failed\n",
> +			 pdata->firmware);
> +		return;
> +	}
> +
> +	ret = coda_hw_init(dev, fw);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
> +		return;
> +	}
> +
> +	/* Encoder device */
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
> +		return;
> +	}
> +
> +	vfd->fops	= &coda_fops,
> +	vfd->ioctl_ops	= get_enc_v4l2_ioctl_ops();
> +	vfd->release	= video_device_release,
> +	vfd->lock	= &dev->dev_mutex;
> +	vfd->v4l2_dev	= &dev->v4l2_dev;
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", CODA_ENC_NAME);
> +	dev->vfd_enc = vfd;
> +	video_set_drvdata(vfd, dev);
> +
> +	dev->alloc_enc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(dev->alloc_enc_ctx)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to alloc vb2 context\n");
> +		goto rel_vdev;
> +	}
> +
> +	dev->m2m_enc_dev = v4l2_m2m_init(get_enc_m2m_ops());
> +	if (IS_ERR(dev->m2m_enc_dev)) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to init mem2mem device\n");
> +		goto rel_ctx;
> +	}
> +
> +	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
> +	if (ret) {
> +		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
> +		goto rel_m2m_enc;
> +	}
> +	v4l2_info(&dev->v4l2_dev, "encoder registered as /dev/video%d\n", vfd->num);
> +
> +	return;
> +
> +rel_m2m_enc:
> +	v4l2_m2m_release(dev->m2m_enc_dev);
> +rel_ctx:
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_enc_ctx);
> +rel_vdev:
> +	video_device_release(vfd);
> +
> +	return;
> +}
> +
> +static int __devinit coda_probe(struct platform_device *pdev)
> +{
> +	struct coda_platform_data *pdata;
> +	struct coda_dev *dev;
> +	struct resource *res;
> +	unsigned int bufsize;
> +	int ret;
> +
> +	pdata = pdev->dev.platform_data;
> +	if (!pdata) {
> +		dev_err(&pdev->dev, "Invalid platform data\n");

s/Invalid/No/

> +		return -EINVAL;
> +	}
> +
> +	dev = kzalloc(sizeof *dev, GFP_KERNEL);

devm_kzalloc?

> +	if (!dev) {
> +		dev_err(&pdev->dev, "Not enough memory for %s\n",
> +			CODA_NAME);
> +		return -ENOMEM;
> +	}
> +
> +	spin_lock_init(&dev->irqlock);
> +
> +	dev->plat_dev = pdev;
> +	if (!dev->plat_dev) {

pdev always is a valid pointer.

> +		dev_err(&pdev->dev, "No platform data specified\n");

You tested for pdev, not for platform data.

> +		ret = -ENODEV;
> +		goto free_dev;
> +	}
> +
> +	dev->clk = clk_get(&pdev->dev, "vpu");

devm_clk_get? Also, please use NULL instead of "vpu". The vpu context is
already contained in &pdev->dev.
There is no clk_prepare in this driver. This won't work on current
kernels.

> +	if (IS_ERR(dev->clk)) {
> +		ret = PTR_ERR(dev->clk);
> +		goto free_dev;
> +	}
> +
> +	/* Get  memory for physical registers */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL) {
> +		dev_err(&pdev->dev, "failed to get memory region resource\n");
> +		ret = -ENOENT;
> +		goto free_clk;
> +	}
> +
> +	if (devm_request_mem_region(&pdev->dev, res->start,
> +			resource_size(res), CODA_NAME) == NULL) {
> +		dev_err(&pdev->dev, "failed to request memory region\n");
> +		ret = -ENOENT;
> +		goto free_clk;
> +	}
> +	dev->regs_base = devm_ioremap(&pdev->dev, res->start,
> +				      resource_size(res));
> +	if (!dev->regs_base) {
> +		dev_err(&pdev->dev, "failed to ioremap address region\n");
> +		ret = -ENOENT;
> +		goto free_clk;
> +	}
> +
> +	/* IRQ */
> +	dev->irq = platform_get_irq(pdev, 0);
> +	if (dev->irq < 0) {
> +		dev_err(&pdev->dev, "failed to get irq resource\n");
> +		ret = -ENOENT;
> +		goto free_clk;
> +	}
> +
> +	if (devm_request_irq(&pdev->dev, dev->irq, coda_irq_handler,
> +		0, CODA_NAME, dev) < 0) {
> +		dev_err(&pdev->dev, "failed to request irq\n");
> +		ret = -ENOENT;
> +		goto free_clk;
> +	}
> +
> +	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
> +	if (ret)
> +		goto free_clk;
> +
> +	mutex_init(&dev->dev_mutex);
> +
> +	/* Encoder */
> +	/* allocate auxiliary buffers for the BIT processor */
> +	bufsize = CODA_CODE_BUF_SIZE + CODA_WORK_BUF_SIZE +
> +		CODA_PARA_BUF_SIZE;
> +	dev->enc_codebuf.vaddr = dma_alloc_coherent(&pdev->dev, bufsize,
> +						    &dev->enc_codebuf.paddr,
> +						    GFP_KERNEL);
> +	if (!dev->enc_codebuf.vaddr) {
> +		dev_err(&pdev->dev, "failed to allocate aux buffers\n");
> +		ret = -ENOMEM;
> +		goto free_clk;
> +	}
> +
> +	dev->enc_workbuf.vaddr = dev->enc_codebuf.vaddr + CODA_CODE_BUF_SIZE;
> +	dev->enc_workbuf.paddr = dev->enc_codebuf.paddr + CODA_CODE_BUF_SIZE;
> +	dev->enc_parabuf.vaddr = dev->enc_workbuf.vaddr + CODA_WORK_BUF_SIZE;
> +	dev->enc_parabuf.paddr = dev->enc_workbuf.paddr + CODA_WORK_BUF_SIZE;
> +
> +
> +	return request_firmware_nowait(THIS_MODULE, true, pdata->firmware,
> +			&pdev->dev, GFP_KERNEL, dev, coda_fw_callback);
> +
> +free_clk:
> +	clk_put(dev->clk);
> +free_dev:
> +	kfree(dev);
> +	return ret;
> +}
> +
> +static int coda_remove(struct platform_device *pdev)
> +{
> +	struct coda_dev *dev = platform_get_drvdata(pdev);
> +	unsigned int bufsize = CODA_CODE_BUF_SIZE + CODA_WORK_BUF_SIZE +
> +				CODA_PARA_BUF_SIZE;
> +
> +	video_unregister_device(dev->vfd_enc);
> +	v4l2_m2m_release(dev->m2m_enc_dev);
> +	vb2_dma_contig_cleanup_ctx(dev->alloc_enc_ctx);
> +	video_device_release(dev->vfd_enc);
> +	dma_free_coherent(&pdev->dev, bufsize, &dev->enc_codebuf.vaddr,
> +			  dev->enc_codebuf.paddr);
> +	clk_put(dev->clk);
> +	kfree(dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver coda_driver = {
> +	.probe	= coda_probe,
> +	.remove	= __devexit_p(coda_remove),
> +	.driver	= {
> +		.name	= CODA_NAME,
> +		.owner	= THIS_MODULE,
> +		/* TODO: pm ops? */
> +	},
> +};
> +
> +module_platform_driver(coda_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Javier Martin <javier.martin@vista-silicon.com>");
> +MODULE_DESCRIPTION("CodaDx6 multi-standard codec V4L2 driver");
> diff --git a/drivers/media/video/coda/coda_regs.h b/drivers/media/video/coda/coda_regs.h
> new file mode 100644
> index 0000000..f6442c4
> --- /dev/null
> +++ b/drivers/media/video/coda/coda_regs.h
> @@ -0,0 +1,223 @@
> +/*
> + * linux/drivers/media/video/coda/coda_regs.h
> + *
> + * Copyright (C) 2012 Vista Silicon SL
> + *    Javier Martin <javier.martin@vista-silicon.com>
> + *    Xavier Duret
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#ifndef _REGS_CODA_H_
> +#define _REGS_CODA_H_
> +
> +/* HW registers */
> +#define CODA_REG_BIT_CODE_RUN		0x000
> +#define		CODA_REG_RUN_ENABLE		(1 << 0)
> +#define CODA_REG_BIT_CODE_DOWN		0x004
> +/* Internal SRAM short address in the BIT */
> +#define 	CODA_DOWN_ADDRESS_SET(x)	(((x) & 0xffff) << 16)
> +#define		CODA_DOWN_DATA_SET(x)	((x) & 0xffff)
> +#define CODA_REG_BIT_HOST_IN_REQ		0x008
> +#define CODA_REG_BIT_INT_CLEAR		0x00C
> +#define		CODA_REG_BIT_INT_CLEAR_SET	0x1
> +#define CODA_REG_BIT_INT_STATUS		0x010
> +#define CODA_REG_BIT_CODE_RESET		0x014
> +#define		CODA_REG_RESET_ENABLE	(1 << 0)
> +#define CODA_REG_BIT_CUR_PC			0x018
> +
> +/* Static SW registers */
> +#define CODA_REG_BIT_CODE_BUF_ADDR		0x100
> +#define CODA_REG_BIT_WORK_BUF_ADDR		0x104
> +#define CODA_REG_BIT_PARA_BUF_ADDR		0x108
> +#define CODA_REG_BIT_STREAM_CTRL		0x10C
> +#define		CODA_STREAM_UNDOCUMENTED	(1 << 2)
> +		/* Stream Full Empty Check Disable */
> +#define 	CODA_STREAM_CHKDIS_OFFSET	(1 << 1)
> +		/* Stream Endianess */
> +#define		CODA_STREAM_ENDIAN_SELECT	(1 << 0)
> +#define CODA_REG_BIT_FRAME_MEM_CTRL		0x110
> +		/* Image Endianess */
> +#define 	CODA_IMAGE_ENDIAN_SELECT	(1 << 0)
> +#define CODA_REG_BIT_RD_PTR_0              0x120
> +#define CODA_REG_BIT_WR_PTR_0              0x124
> +#define CODA_REG_BIT_SEARCH_RAM_BASE_ADDR  0x140
> +#define CODA_REG_BIT_BUSY			0x160
> +#define 	CODA_REG_BIT_BUSY_FLAG	1
> +#define CODA_REG_BIT_RUN_COMMAND           0x164
> +#define 	CODA_COMMAND_SEQ_INIT                         1
> +#define 	CODA_COMMAND_SEQ_END                          2
> +#define 	CODA_COMMAND_PIC_RUN                          3
> +#define 	CODA_COMMAND_SET_FRAME_BUF                    4
> +#define 	CODA_COMMAND_ENCODE_HEADER                    5
> +#define 	CODA_COMMAND_ENC_PARA_SET                     6
> +#define 	CODA_COMMAND_DEC_PARA_SET                     7
> +#define 	CODA_COMMAND_DEC_BUF_FLUSH                    8
> +#define 	CODA_COMMAND_RC_CHANGE_PARAMETER              9
> +#define 	CODA_COMMAND_FIRMWARE_GET                     0xf
> +#define CODA_REG_BIT_RUN_INDEX		0x168
> +#define		CODA_INDEX_SET(x)		((x) & 0x3)
> +#define CODA_REG_BIT_RUN_COD_STD		0x16C
> +#define 	CODA_MODE_DECODE_M4S2	0
> +#define 	CODA_MODE_ENCODE_M4S2	1
> +#define 	CODA_MODE_DECODE_H264	2
> +#define 	CODA_MODE_ENCODE_H264	3
> +#define 	CODA_MODE_DECODE_WVC1	4
> +#define 	CODA_MODE_INVALID		0xffff
> +#define CODA_REG_BIT_INT_ENABLE		0x170
> +#define		CODA_INT_INTERRUPT_ENABLE	(1 << 3)
> +
> +/*
> + * Commands' mailbox:
> + * registers with offsets in the range 0x180-0x1D0
> + * have different meaning depending on the command being
> + * issued.
> + */
> +/* Encoder Sequence Initialization */
> +#define CODA_CMD_ENC_SEQ_BB_START          0x180
> +#define CODA_CMD_ENC_SEQ_BB_SIZE           0x184
> +#define CODA_CMD_ENC_SEQ_OPTION            0x188
> +#define 	CODA_OPTION_GAMMA_OFFSET                      7
> +#define 	CODA_OPTION_GAMMA_MASK                        0x01
> +#define 	CODA_OPTION_LIMITQP_OFFSET                    6
> +#define 	CODA_OPTION_LIMITQP_MASK                      0x01
> +#define 	CODA_OPTION_RCINTRAQP_OFFSET                  5
> +#define 	CODA_OPTION_RCINTRAQP_MASK                    0x01
> +#define 	CODA_OPTION_FMO_OFFSET                        4
> +#define 	CODA_OPTION_FMO_MASK                          0x01
> +// /* There is no bit 3 */
> +// #define 	CODA_OPTION_AUD_OFFSET                        2
> +// #define 	CODA_OPTION_AUD_MASK                          0x01
> +#define 	CODA_OPTION_SLICEREPORT_OFFSET                1
> +#define 	CODA_OPTION_SLICEREPORT_MASK                  0x01
> +// /* There is no bit 0 */
> +#define CODA_CMD_ENC_SEQ_COD_STD           0x18C
> +#define 	CODA_ENCODE_MPEG4                             0
> +#define 	CODA_ENCODE_H263                              1
> +#define 	CODA_ENCODE_H264                              2
> +#define CODA_CMD_ENC_SEQ_SRC_SIZE          0x190
> +#define 	CODA_PICWIDTH_OFFSET                          10
> +#define 	CODA_PICWIDTH_MASK                            0x3ff
> +#define 	CODA_PICHEIGHT_OFFSET                         0
> +#define 	CODA_PICHEIGHT_MASK                           0x3ff
> +#define CODA_CMD_ENC_SEQ_SRC_F_RATE        0x194
> +#define CODA_CMD_ENC_SEQ_MP4_PARA          0x198
> +#define 	CODA_MP4PARAM_VERID_OFFSET                    6
> +#define 	CODA_MP4PARAM_VERID_MASK                      0x01
> +/* intra_dc_vlc_thr in MPEG-4 part 2 standard: unsigned [0:7] */
> +#define 	CODA_MP4PARAM_INTRADCVLCTHR_OFFSET            2
> +#define 	CODA_MP4PARAM_INTRADCVLCTHR_MASK              0x07
> +#define 	CODA_MP4PARAM_REVERSIBLEVLCENABLE_OFFSET      1
> +#define 	CODA_MP4PARAM_REVERSIBLEVLCENABLE_MASK        0x01
> +#define 	CODA_MP4PARAM_DATAPARTITIONENABLE_OFFSET      0
> +#define 	CODA_MP4PARAM_DATAPARTITIONENABLE_MASK        0x01
> +// #define CODA_CMD_ENC_SEQ_263_PARA          0x19C
> +// #define 	CODA_263PARAM_ANNEXJENABLE_OFFSET             2
> +// #define 	CODA_263PARAM_ANNEXJENABLE_MASK               0x01
> +// #define 	CODA_263PARAM_ANNEXKENABLE_OFFSET             1
> +// #define 	CODA_263PARAM_ANNEXKENABLE_MASK               0x01
> +// #define 	CODA_263PARAM_ANNEXTENABLE_OFFSET             0
> +// #define 	CODA_263PARAM_ANNEXTENABLE_MASK               0x01
> +#define CODA_CMD_ENC_SEQ_264_PARA          0x1A0
> +/* deblk_filter_offset_alpha: signed [-6:6] */
> +#define 	CODA_264PARAM_DEBLKFILTEROFFSETBETA_OFFSET    12
> +#define 	CODA_264PARAM_DEBLKFILTEROFFSETBETA_MASK      0x0f
> +/* deblk_filter_offset_beta: signed [-6:6] */
> +#define 	CODA_264PARAM_DEBLKFILTEROFFSETALPHA_OFFSET   8
> +#define 	CODA_264PARAM_DEBLKFILTEROFFSETALPHA_MASK     0x0f
> +#define 	CODA_264PARAM_DISABLEDEBLK_OFFSET             6
> +#define 	CODA_264PARAM_DISABLEDEBLK_MASK               0x01
> +#define 	CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_OFFSET 5
> +#define 	CODA_264PARAM_CONSTRAINEDINTRAPREDFLAG_MASK   0x01
> +/* chroma_qp_offset: signed [-12:12] */
> +#define 	CODA_264PARAM_CHROMAQPOFFSET_OFFSET           0
> +#define 	CODA_264PARAM_CHROMAQPOFFSET_MASK             0x1f
> +#define CODA_CMD_ENC_SEQ_SLICE_MODE        0x1A4
> +/* Slice size */
> +#define 	CODA_SLICING_SIZE_OFFSET                      2
> +#define 	CODA_SLICING_SIZE_MASK                        0x3fffffff
> +/* Unit used for slice size: 0 = bits per slice, 1 = Macroblocks per slice */
> +#define 	CODA_SLICING_UNIT_OFFSET                      1
> +#define 	CODA_SLICING_UNIT_MASK                        0x01
> +/* Slicing mode: 0 = One slice per picture, 1 = Multiple slices per picture */
> +#define 	CODA_SLICING_MODE_OFFSET                      0
> +#define 	CODA_SLICING_MODE_MASK                        0x01
> +#define CODA_CMD_ENC_SEQ_GOP_SIZE          0x1A8
> +/* GOP Size: 0 = Only first picture is Intra, 1 = All pictures are Intra
> +             n from 2 to 60 = One picture out of n is Intra */
> +#define 	CODA_GOP_SIZE_OFFSET                          0
> +#define 	CODA_GOP_SIZE_MASK                            0x3f
> +#define CODA_CMD_ENC_SEQ_RC_PARA           0x1AC
> +/* Disable autoskip: 1 = Do not skip a frame if bitstream is bigger than specified */
> +#define 	CODA_RATECONTROL_AUTOSKIP_OFFSET              31
> +#define 	CODA_RATECONTROL_AUTOSKIP_MASK                0x01
> +/* Initial delay: time in ms to fill the VBV buffer */
> +#define 	CODA_RATECONTROL_INITIALDELAY_OFFSET          16
> +#define 	CODA_RATECONTROL_INITIALDELAY_MASK            0x7f
> +/* Bitrate: in kilobits per seconds */
> +#define 	CODA_RATECONTROL_BITRATE_OFFSET               1
> +#define 	CODA_RATECONTROL_BITRATE_MASK                 0x7f
> +#define 	CODA_RATECONTROL_ENABLE_OFFSET                0
> +#define 	CODA_RATECONTROL_ENABLE_MASK                  0x01
> +#define CODA_CMD_ENC_SEQ_RC_BUF_SIZE       0x1B0
> +#define CODA_CMD_ENC_SEQ_INTRA_REFRESH     0x1B4
> +#define CODA_CMD_ENC_SEQ_FMO               0x1B8
> +/* Flexible Macroblock Ordering type: 0 = interleaved, 1 = dispersed */
> +#define 	CODA_FMOPARAM_TYPE_OFFSET                     4
> +#define 	CODA_FMOPARAM_TYPE_MASK                       1
> +/* Flexible Macroblock Ordering Slice Number: unsigned [2:8] */
> +#define 	CODA_FMOPARAM_SLICENUM_OFFSET                 0
> +#define 	CODA_FMOPARAM_SLICENUM_MASK                   0x0f
> +// #define CODA_CMD_ENC_SEQ_INTRA_QP          0x1BC
> +#define CODA_CMD_ENC_SEQ_RC_QP_MAX         0x1C8
> +/* QP: from 1 to 51 in H.264 */
> +#define 	CODA_QPMAX_OFFSET                             0
> +#define 	CODA_QPMAX_MASK                               0x3f
> +#define CODA_CMD_ENC_SEQ_RC_GAMMA          0x1CC
> +#define 	CODA_GAMMA_OFFSET                             0
> +#define 	CODA_GAMMA_MASK                               0xffff
> +#define CODA_RET_ENC_SEQ_SUCCESS           0x1C0
> +
> +// /* Encoder Picture Run */
> +#define CODA_CMD_ENC_PIC_SRC_ADDR_Y        0x180
> +#define CODA_CMD_ENC_PIC_SRC_ADDR_CB       0x184
> +#define CODA_CMD_ENC_PIC_SRC_ADDR_CR       0x188
> +#define CODA_CMD_ENC_PIC_QS                0x18C
> +#define CODA_CMD_ENC_PIC_ROT_MODE          0x190
> +#define CODA_CMD_ENC_PIC_OPTION            0x194
> +#define CODA_CMD_ENC_PIC_BB_START          0x198
> +#define CODA_CMD_ENC_PIC_BB_SIZE           0x19C
> +#define CODA_RET_ENC_PIC_TYPE              0x1C4
> +#define CODA_RET_ENC_PIC_SLICE_NUM         0x1CC
> +#define CODA_RET_ENC_PIC_FLAG              0x1D0
> +
> +/* Set Frame Buffer */
> +#define CODA_CMD_SET_FRAME_BUF_NUM         0x180
> +#define CODA_CMD_SET_FRAME_BUF_STRIDE      0x184
> +
> +/* Encoder Header */
> +#define CODA_CMD_ENC_HEADER_CODE           0x180
> +#define 	CODA_GAMMA_OFFSET                             0
> +#define 	CODA_HEADER_H264_SPS                          0
> +#define 	CODA_HEADER_H264_PPS                          1
> +#define 	CODA_HEADER_MP4V_VOL                          0
> +#define 	CODA_HEADER_MP4V_VOS                          1
> +#define 	CODA_HEADER_MP4V_VIS                          2
> +#define CODA_CMD_ENC_HEADER_BB_START       0x184
> +#define CODA_CMD_ENC_HEADER_BB_SIZE        0x188
> +
> +// /* Set Encoder Parameter */
> +// #define CODA_CMD_ENC_PARA_SET_TYPE         0x180
> +// #define CODA_RET_ENC_PARA_SET_SIZE         0x1c0
> +// 
> +/* Get Version */
> +#define CODA_CMD_FIRMWARE_VERNUM		0x1c0
> +#define		CODA_FIRMWARE_PRODUCT(x)	(((x) >> 16) & 0xffff)
> +#define		CODA_FIRMWARE_MAJOR(x)	(((x) >> 12) & 0x0f)
> +#define		CODA_FIRMWARE_MINOR(x)	(((x) >> 8) & 0x0f)
> +#define		CODA_FIRMWARE_RELEASE(x)	((x) & 0xff)
> +
> +#endif
> diff --git a/drivers/media/video/m2m-deinterlace.c b/drivers/media/video/m2m-deinterlace.c

This seems to be a completely different driver, probably accidently.

> diff --git a/include/linux/coda_codec.h b/include/linux/coda_codec.h
> new file mode 100644
> index 0000000..8093b22
> --- /dev/null
> +++ b/include/linux/coda_codec.h
> @@ -0,0 +1,9 @@
> +
> +#ifndef _CODA_CODEC_H
> +#define _CODA_CODEC_H
> +
> +struct coda_platform_data {
> +	char	*firmware;
> +};
> +
> +#endif
> \ No newline at end of file
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
