Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:59383 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1K1Lmb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 06:42:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 2/2] s5p-fimc: Add support for alpha component configuration
Date: Mon, 28 Nov 2011 12:42:17 +0100
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com> <1322235572-22016-3-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1322235572-22016-3-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111281242.17246.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 25 November 2011 16:39:32 Sylwester Nawrocki wrote:
> On Exynos SoCs the FIMC IP allows to configure globally the alpha
> component of all pixels for V4L2_PIX_FMT_RGB32, V4L2_PIX_FMT_RGB555
> and V4L2_PIX_FMT_RGB444 image formats. This patch adds a v4l2 control
> in order to let the applications control the alpha component value.
> 
> The alpha value range depends on the pixel format, for RGB32 it's
> 0..255 (8-bits), for RGB555 - 0..1 (1-bit) and for RGB444 - 0..15
> (4-bits). The v4l2 control range is always 0..255 and the alpha
> component data width is determined by currently set format on the
> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE buffer queue. The applications
> need to match the alpha channel data width and the pixel format
> since the driver will ignore the alpha component bits that are not
> applicable to the configured pixel format.

Will the driver ignore the least significant bits or the most significant 
bits?

Regards,

	Hans

> 
> A new entry is added in the variant description data structure
> so an additional control is created only where really supported
> by the hardware.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/s5p-fimc/fimc-capture.c |    4 ++
>  drivers/media/video/s5p-fimc/fimc-core.c    |   49
> ++++++++++++++++++++++--- drivers/media/video/s5p-fimc/fimc-core.h    |  
> 13 ++++++-
>  drivers/media/video/s5p-fimc/fimc-reg.c     |   53
> +++++++++++++++++++++------ drivers/media/video/s5p-fimc/regs-fimc.h    | 
>   5 +++
>  5 files changed, 105 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c
> b/drivers/media/video/s5p-fimc/fimc-capture.c index 82d9ab6..70176e5
> 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -63,6 +63,8 @@ static int fimc_init_capture(struct fimc_dev *fimc)
>  		fimc_hw_set_effect(ctx, false);
>  		fimc_hw_set_output_path(ctx);
>  		fimc_hw_set_out_dma(ctx);
> +		if (fimc->variant->has_alpha)
> +			fimc_hw_set_rgb_alpha(ctx);
>  		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
>  	}
>  	spin_unlock_irqrestore(&fimc->slock, flags);
> @@ -154,6 +156,8 @@ int fimc_capture_config_update(struct fimc_ctx *ctx)
>  		fimc_hw_set_rotation(ctx);
>  		fimc_prepare_dma_offset(ctx, &ctx->d_frame);
>  		fimc_hw_set_out_dma(ctx);
> +		if (fimc->variant->has_alpha)
> +			fimc_hw_set_rgb_alpha(ctx);
>  		clear_bit(ST_CAPT_APPLY_CFG, &fimc->state);
>  	}
>  	spin_unlock(&ctx->slock);
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c
> b/drivers/media/video/s5p-fimc/fimc-core.c index 567e9ea..5fe9aeb 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -52,13 +52,29 @@ static struct fimc_fmt fimc_formats[] = {
>  		.colplanes	= 1,
>  		.flags		= FMT_FLAGS_M2M,
>  	}, {
> -		.name		= "XRGB-8-8-8-8, 32 bpp",
> +		.name		= "ARGB8888, 32 bpp",
>  		.fourcc		= V4L2_PIX_FMT_RGB32,
>  		.depth		= { 32 },
>  		.color		= S5P_FIMC_RGB888,
>  		.memplanes	= 1,
>  		.colplanes	= 1,
> -		.flags		= FMT_FLAGS_M2M,
> +		.flags		= FMT_FLAGS_M2M | FMT_HAS_ALPHA,
> +	}, {
> +		.name		= "ARGB1555",
> +		.fourcc		= V4L2_PIX_FMT_RGB555,
> +		.depth		= { 16 },
> +		.color		= S5P_FIMC_RGB555,
> +		.memplanes	= 1,
> +		.colplanes	= 1,
> +		.flags		= FMT_FLAGS_M2M | FMT_HAS_ALPHA,
> +	}, {
> +		.name		= "ARGB4444",
> +		.fourcc		= V4L2_PIX_FMT_RGB444,
> +		.depth		= { 16 },
> +		.color		= S5P_FIMC_RGB444,
> +		.memplanes	= 1,
> +		.colplanes	= 1,
> +		.flags		= FMT_FLAGS_M2M | FMT_HAS_ALPHA,
>  	}, {
>  		.name		= "YUV 4:2:2 packed, YCbYCr",
>  		.fourcc		= V4L2_PIX_FMT_YUYV,
> @@ -652,8 +668,11 @@ static void fimc_dma_run(void *priv)
>  	if (ctx->state & (FIMC_DST_ADDR | FIMC_PARAMS))
>  		fimc_hw_set_output_addr(fimc, &ctx->d_frame.paddr, -1);
> 
> -	if (ctx->state & FIMC_PARAMS)
> +	if (ctx->state & FIMC_PARAMS) {
>  		fimc_hw_set_out_dma(ctx);
> +		if (fimc->variant->has_alpha)
> +			fimc_hw_set_rgb_alpha(ctx);
> +	}
> 
>  	fimc_activate_capture(ctx);
> 
> @@ -790,6 +809,11 @@ static int fimc_s_ctrl(struct v4l2_ctrl *ctrl)
>  		ctx->rotation = ctrl->val;
>  		break;
> 
> +	case V4L2_CID_ALPHA_COMPONENT:
> +		spin_lock_irqsave(&ctx->slock, flags);
> +		ctx->d_frame.alpha = ctrl->val;
> +		break;
> +
>  	default:
>  		v4l2_err(fimc->v4l2_dev, "Invalid control: 0x%X\n", ctrl->id);
>  		return -EINVAL;
> @@ -806,9 +830,11 @@ static const struct v4l2_ctrl_ops fimc_ctrl_ops = {
> 
>  int fimc_ctrls_create(struct fimc_ctx *ctx)
>  {
> +	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
> +
>  	if (ctx->ctrls_rdy)
>  		return 0;
> -	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 3);
> +	v4l2_ctrl_handler_init(&ctx->ctrl_handler, 4);
> 
>  	ctx->ctrl_rotate = v4l2_ctrl_new_std(&ctx->ctrl_handler, 
&fimc_ctrl_ops,
>  				     V4L2_CID_HFLIP, 0, 1, 1, 0);
> @@ -816,6 +842,14 @@ int fimc_ctrls_create(struct fimc_ctx *ctx)
>  				    V4L2_CID_VFLIP, 0, 1, 1, 0);
>  	ctx->ctrl_vflip = v4l2_ctrl_new_std(&ctx->ctrl_handler, 
&fimc_ctrl_ops,
>  				    V4L2_CID_ROTATE, 0, 270, 90, 0);
> +
> +	if (variant->has_alpha)
> +		ctx->ctrl_alpha = v4l2_ctrl_new_std(&ctx->ctrl_handler,
> +				    &fimc_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
> +				    0, 0xff, 1, 0);
> +	else
> +		ctx->ctrl_alpha = NULL;
> +
>  	ctx->ctrls_rdy = ctx->ctrl_handler.error == 0;
> 
>  	return ctx->ctrl_handler.error;
> @@ -838,6 +872,8 @@ void fimc_ctrls_activate(struct fimc_ctx *ctx, bool
> active) v4l2_ctrl_activate(ctx->ctrl_rotate, active);
>  	v4l2_ctrl_activate(ctx->ctrl_hflip, active);
>  	v4l2_ctrl_activate(ctx->ctrl_vflip, active);
> +	if (ctx->ctrl_alpha)
> +		v4l2_ctrl_activate(ctx->ctrl_alpha, active);
> 
>  	if (active) {
>  		ctx->rotation = ctx->ctrl_rotate->val;
> @@ -1374,6 +1410,8 @@ static int fimc_m2m_open(struct file *file)
>  	if (!ctx)
>  		return -ENOMEM;
>  	v4l2_fh_init(&ctx->fh, fimc->m2m.vfd);
> +	ctx->fimc_dev = fimc;
> +
>  	ret = fimc_ctrls_create(ctx);
>  	if (ret)
>  		goto error_fh;
> @@ -1383,7 +1421,6 @@ static int fimc_m2m_open(struct file *file)
>  	file->private_data = &ctx->fh;
>  	v4l2_fh_add(&ctx->fh);
> 
> -	ctx->fimc_dev = fimc;
>  	/* Default color format */
>  	ctx->s_frame.fmt = &fimc_formats[0];
>  	ctx->d_frame.fmt = &fimc_formats[0];
> @@ -1892,6 +1929,7 @@ static struct samsung_fimc_variant
> fimc0_variant_exynos4 = { .has_cam_if	 = 1,
>  	.has_cistatus2	 = 1,
>  	.has_mainscaler_ext = 1,
> +	.has_alpha	 = 1,
>  	.min_inp_pixsize = 16,
>  	.min_out_pixsize = 16,
>  	.hor_offs_align	 = 2,
> @@ -1905,6 +1943,7 @@ static struct samsung_fimc_variant
> fimc3_variant_exynos4 = { .has_cam_if	 = 1,
>  	.has_cistatus2	 = 1,
>  	.has_mainscaler_ext = 1,
> +	.has_alpha	 = 1,
>  	.min_inp_pixsize = 16,
>  	.min_out_pixsize = 16,
>  	.hor_offs_align	 = 2,
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h
> b/drivers/media/video/s5p-fimc/fimc-core.h index c7f01c4..9d1f669 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -85,11 +85,14 @@ enum fimc_datapath {
>  };
> 
>  enum fimc_color_fmt {
> -	S5P_FIMC_RGB565 = 0x10,
> +	S5P_FIMC_RGB444 = 0x10,
> +	S5P_FIMC_RGB555,
> +	S5P_FIMC_RGB565,
>  	S5P_FIMC_RGB666,
>  	S5P_FIMC_RGB888,
>  	S5P_FIMC_RGB30_LOCAL,
>  	S5P_FIMC_YCBCR420 = 0x20,
> +	S5P_FIMC_YCBCR422,
>  	S5P_FIMC_YCBYCR422,
>  	S5P_FIMC_YCRYCB422,
>  	S5P_FIMC_CBYCRY422,
> @@ -162,6 +165,7 @@ struct fimc_fmt {
>  	u16	flags;
>  #define FMT_FLAGS_CAM	(1 << 0)
>  #define FMT_FLAGS_M2M	(1 << 1)
> +#define FMT_HAS_ALPHA	(1 << 2)
>  };
> 
>  /**
> @@ -283,6 +287,7 @@ struct fimc_frame {
>  	struct fimc_addr	paddr;
>  	struct fimc_dma_offset	dma_offset;
>  	struct fimc_fmt		*fmt;
> +	u8			alpha;
>  };
> 
>  /**
> @@ -387,6 +392,7 @@ struct samsung_fimc_variant {
>  	unsigned int	has_cistatus2:1;
>  	unsigned int	has_mainscaler_ext:1;
>  	unsigned int	has_cam_if:1;
> +	unsigned int	has_alpha:1;
>  	struct fimc_pix_limit *pix_limit;
>  	u16		min_inp_pixsize;
>  	u16		min_out_pixsize;
> @@ -482,7 +488,8 @@ struct fimc_dev {
>   * @ctrl_handler:	v4l2 controls handler
>   * @ctrl_rotate		image rotation control
>   * @ctrl_hflip		horizontal flip control
> - * @ctrl_vflip		vartical flip control
> + * @ctrl_vflip		vertical flip control
> + * @ctrl_alpha		RGB alpha control
>   * @ctrls_rdy:		true if the control handler is initialized
>   */
>  struct fimc_ctx {
> @@ -509,6 +516,7 @@ struct fimc_ctx {
>  	struct v4l2_ctrl	*ctrl_rotate;
>  	struct v4l2_ctrl	*ctrl_hflip;
>  	struct v4l2_ctrl	*ctrl_vflip;
> +	struct v4l2_ctrl	*ctrl_alpha;
>  	bool			ctrls_rdy;
>  };
> 
> @@ -674,6 +682,7 @@ void fimc_hw_set_prescaler(struct fimc_ctx *ctx);
>  void fimc_hw_set_mainscaler(struct fimc_ctx *ctx);
>  void fimc_hw_en_capture(struct fimc_ctx *ctx);
>  void fimc_hw_set_effect(struct fimc_ctx *ctx, bool active);
> +void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx);
>  void fimc_hw_set_in_dma(struct fimc_ctx *ctx);
>  void fimc_hw_set_input_path(struct fimc_ctx *ctx);
>  void fimc_hw_set_output_path(struct fimc_ctx *ctx);
> diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c
> b/drivers/media/video/s5p-fimc/fimc-reg.c index 44f5c2d..15466d0 100644
> --- a/drivers/media/video/s5p-fimc/fimc-reg.c
> +++ b/drivers/media/video/s5p-fimc/fimc-reg.c
> @@ -117,7 +117,7 @@ void fimc_hw_set_target_format(struct fimc_ctx *ctx)
>  		  S5P_CITRGFMT_VSIZE_MASK);
> 
>  	switch (frame->fmt->color) {
> -	case S5P_FIMC_RGB565...S5P_FIMC_RGB888:
> +	case S5P_FIMC_RGB444...S5P_FIMC_RGB888:
>  		cfg |= S5P_CITRGFMT_RGB;
>  		break;
>  	case S5P_FIMC_YCBCR420:
> @@ -175,6 +175,7 @@ void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
>  	struct fimc_dev *dev = ctx->fimc_dev;
>  	struct fimc_frame *frame = &ctx->d_frame;
>  	struct fimc_dma_offset *offset = &frame->dma_offset;
> +	struct fimc_fmt *fmt = frame->fmt;
> 
>  	/* Set the input dma offsets. */
>  	cfg = 0;
> @@ -198,15 +199,22 @@ void fimc_hw_set_out_dma(struct fimc_ctx *ctx)
>  	cfg = readl(dev->regs + S5P_CIOCTRL);
> 
>  	cfg &= ~(S5P_CIOCTRL_ORDER2P_MASK | S5P_CIOCTRL_ORDER422_MASK |
> -		 S5P_CIOCTRL_YCBCR_PLANE_MASK);
> +		 S5P_CIOCTRL_YCBCR_PLANE_MASK | S5P_CIOCTRL_RGB16FMT_MASK);
> 
> -	if (frame->fmt->colplanes == 1)
> +	if (fmt->colplanes == 1)
>  		cfg |= ctx->out_order_1p;
> -	else if (frame->fmt->colplanes == 2)
> +	else if (fmt->colplanes == 2)
>  		cfg |= ctx->out_order_2p | S5P_CIOCTRL_YCBCR_2PLANE;
> -	else if (frame->fmt->colplanes == 3)
> +	else if (fmt->colplanes == 3)
>  		cfg |= S5P_CIOCTRL_YCBCR_3PLANE;
> 
> +	if (fmt->color == S5P_FIMC_RGB565)
> +		cfg |= S5P_CIOCTRL_RGB565;
> +	else if (fmt->color == S5P_FIMC_RGB555)
> +		cfg |= S5P_CIOCTRL_ARGB1555;
> +	else if (fmt->color == S5P_FIMC_RGB444)
> +		cfg |= S5P_CIOCTRL_ARGB4444;
> +
>  	writel(cfg, dev->regs + S5P_CIOCTRL);
>  }
> 
> @@ -278,22 +286,28 @@ static void fimc_hw_set_scaler(struct fimc_ctx *ctx)
>  	if (sc->copy_mode)
>  		cfg |= S5P_CISCCTRL_ONE2ONE;
> 
> -
>  	if (ctx->in_path == FIMC_DMA) {
> -		if (src_frame->fmt->color == S5P_FIMC_RGB565)
> +		switch (src_frame->fmt->color) {
> +		case S5P_FIMC_RGB565:
>  			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB565;
> -		else if (src_frame->fmt->color == S5P_FIMC_RGB666)
> +			break;
> +		case S5P_FIMC_RGB666:
>  			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB666;
> -		else if (src_frame->fmt->color == S5P_FIMC_RGB888)
> +			break;
> +		case S5P_FIMC_RGB888:
>  			cfg |= S5P_CISCCTRL_INRGB_FMT_RGB888;
> +			break;
> +		}
>  	}
> 
>  	if (ctx->out_path == FIMC_DMA) {
> -		if (dst_frame->fmt->color == S5P_FIMC_RGB565)
> +		u32 color = dst_frame->fmt->color;
> +
> +		if (color >= S5P_FIMC_RGB444 && color <= S5P_FIMC_RGB565)
>  			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB565;
> -		else if (dst_frame->fmt->color == S5P_FIMC_RGB666)
> +		else if (color == S5P_FIMC_RGB666)
>  			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB666;
> -		else if (dst_frame->fmt->color == S5P_FIMC_RGB888)
> +		else if (color == S5P_FIMC_RGB888)
>  			cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
>  	} else {
>  		cfg |= S5P_CISCCTRL_OUTRGB_FMT_RGB888;
> @@ -379,6 +393,21 @@ void fimc_hw_set_effect(struct fimc_ctx *ctx, bool
> active) writel(cfg, dev->regs + S5P_CIIMGEFF);
>  }
> 
> +void fimc_hw_set_rgb_alpha(struct fimc_ctx *ctx)
> +{
> +	struct fimc_dev *dev = ctx->fimc_dev;
> +	struct fimc_frame *frame = &ctx->d_frame;
> +	u32 cfg;
> +
> +	if (!(frame->fmt->flags & FMT_HAS_ALPHA))
> +		return;
> +
> +	cfg = readl(dev->regs + S5P_CIOCTRL);
> +	cfg &= ~S5P_CIOCTRL_ALPHA_OUT_MASK;
> +	cfg |= (frame->alpha << 4);
> +	writel(cfg, dev->regs + S5P_CIOCTRL);
> +}
> +
>  static void fimc_hw_set_in_dma_size(struct fimc_ctx *ctx)
>  {
>  	struct fimc_dev *dev = ctx->fimc_dev;
> diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h
> b/drivers/media/video/s5p-fimc/regs-fimc.h index c8e3b94..c7a5bc5 100644
> --- a/drivers/media/video/s5p-fimc/regs-fimc.h
> +++ b/drivers/media/video/s5p-fimc/regs-fimc.h
> @@ -107,6 +107,11 @@
>  #define S5P_CIOCTRL_YCBCR_3PLANE	(0 << 3)
>  #define S5P_CIOCTRL_YCBCR_2PLANE	(1 << 3)
>  #define S5P_CIOCTRL_YCBCR_PLANE_MASK	(1 << 3)
> +#define S5P_CIOCTRL_ALPHA_OUT_MASK	(0xff << 4)
> +#define S5P_CIOCTRL_RGB16FMT_MASK	(3 << 16)
> +#define S5P_CIOCTRL_RGB565		(0 << 16)
> +#define S5P_CIOCTRL_ARGB1555		(1 << 16)
> +#define S5P_CIOCTRL_ARGB4444		(2 << 16)
>  #define S5P_CIOCTRL_ORDER2P_SHIFT	(24)
>  #define S5P_CIOCTRL_ORDER2P_MASK	(3 << 24)
>  #define S5P_CIOCTRL_ORDER422_2P_LSB_CRCB (0 << 24)
