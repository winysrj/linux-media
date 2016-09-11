Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33773 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753834AbcIKU2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 11 Sep 2016 16:28:00 -0400
Received: by mail-wm0-f67.google.com with SMTP id b187so10892746wme.0
        for <linux-media@vger.kernel.org>; Sun, 11 Sep 2016 13:27:59 -0700 (PDT)
Subject: Re: [PATCH v3 08/10] v4l: fdp1: Rewrite format setting code
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <1473287110-780-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1473287110-780-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-renesas-soc@vger.kernel.org
From: Kieran Bingham <kieran@ksquared.org.uk>
Message-ID: <d2c08948-5c1b-992d-b7b6-0df9942341e1@bingham.xyz>
Date: Sun, 11 Sep 2016 21:27:57 +0100
MIME-Version: 1.0
In-Reply-To: <1473287110-780-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I've gone through this one as well, and certainly seems like some much
better approaches in there.

I can't find anything to fault it.

Acked-by: Kieran Bingham <kieran@bingham.xyz>
Reviewed-by: Kieran Bingham <kieran@bingham.xyz>

Thanks again,

Kieran

On 07/09/16 23:25, Laurent Pinchart wrote:
> The handling of the TRY_FMT and S_FMT ioctls isn't correct. In
> particular, the sink format isn't propagated to the source format
> automatically, the strides are not computed when the device is opened,
> and the colorspace handling is wrong.
> 
> Rewrite the implementation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/media/platform/rcar_fdp1.c | 324 +++++++++++++++++++++++--------------
>  1 file changed, 205 insertions(+), 119 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
> index fdab41165f5a..480f89381f15 100644
> --- a/drivers/media/platform/rcar_fdp1.c
> +++ b/drivers/media/platform/rcar_fdp1.c
> @@ -40,7 +40,7 @@ static unsigned int debug;
>  module_param(debug, uint, 0644);
>  MODULE_PARM_DESC(debug, "activate debug info");
>  
> -/* Min Width/Height/Height-Field */
> +/* Minimum and maximum frame width/height */
>  #define FDP1_MIN_W		80U
>  #define FDP1_MIN_H		80U
>  
> @@ -48,6 +48,7 @@ MODULE_PARM_DESC(debug, "activate debug info");
>  #define FDP1_MAX_H		2160U
>  
>  #define FDP1_MAX_PLANES		3U
> +#define FDP1_MAX_STRIDE		8190U
>  
>  /* Flags that indicate a format can be used for capture/output */
>  #define FDP1_CAPTURE		BIT(0)
> @@ -1506,82 +1507,12 @@ static int fdp1_g_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  	return 0;
>  }
>  
> -static int __fdp1_try_fmt(struct fdp1_ctx *ctx, const struct fdp1_fmt **fmtinfo,
> -			  struct v4l2_pix_format_mplane *pix,
> -			  enum v4l2_buf_type type)
> +static void fdp1_compute_stride(struct v4l2_pix_format_mplane *pix,
> +				const struct fdp1_fmt *fmt)
>  {
> -	const struct fdp1_fmt *fmt;
> -	unsigned int width = pix->width;
> -	unsigned int height = pix->height;
> -	unsigned int fmt_type;
>  	unsigned int i;
>  
> -	fmt_type = V4L2_TYPE_IS_OUTPUT(type) ? FDP1_OUTPUT : FDP1_CAPTURE;
> -
> -	fmt = fdp1_find_format(pix->pixelformat);
> -	if (!fmt || !(fmt->types & fmt_type))
> -		fmt = fdp1_find_format(V4L2_PIX_FMT_YUYV);
> -
> -	pix->pixelformat = fmt->fourcc;
> -
> -	/* Manage colorspace on the two queues */
> -	if (V4L2_TYPE_IS_OUTPUT(type)) {
> -		if (pix->colorspace == V4L2_COLORSPACE_DEFAULT)
> -			pix->colorspace = V4L2_COLORSPACE_REC709;
> -
> -		if (pix->ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
> -			pix->ycbcr_enc =
> -				V4L2_MAP_YCBCR_ENC_DEFAULT(pix->colorspace);
> -
> -		if (pix->quantization == V4L2_QUANTIZATION_DEFAULT)
> -			pix->quantization =
> -				V4L2_MAP_QUANTIZATION_DEFAULT(false,
> -						pix->colorspace,
> -						pix->ycbcr_enc);
> -	} else {
> -		/* Manage the CAPTURE Queue */
> -		struct fdp1_q_data *src_data = &ctx->out_q;
> -
> -		if (fdp1_fmt_is_rgb(fmt)) {
> -			pix->colorspace = V4L2_COLORSPACE_SRGB;
> -			pix->ycbcr_enc = V4L2_YCBCR_ENC_SYCC;
> -			pix->quantization = V4L2_QUANTIZATION_FULL_RANGE;
> -		} else {
> -			/* Copy input queue colorspace across */
> -			pix->colorspace = src_data->format.colorspace;
> -			pix->ycbcr_enc = src_data->format.ycbcr_enc;
> -			pix->quantization = src_data->format.quantization;
> -		}
> -	}
> -
> -	/* We should be allowing FIELDS through on the Output queue !*/
> -	if (V4L2_TYPE_IS_OUTPUT(type)) {
> -		/* Clamp to allowable field types */
> -		if (pix->field == V4L2_FIELD_ANY ||
> -		    pix->field == V4L2_FIELD_NONE)
> -			pix->field = V4L2_FIELD_NONE;
> -		else if (!V4L2_FIELD_HAS_BOTH(pix->field))
> -			pix->field = V4L2_FIELD_INTERLACED;
> -
> -		dprintk(ctx->fdp1, "Output Field Type set as %d\n", pix->field);
> -	} else {
> -		pix->field = V4L2_FIELD_NONE;
> -	}
> -
> -	pix->num_planes = fmt->num_planes;
> -
> -	/* Align the width and height for YUV 4:2:2 and 4:2:0 formats. */
> -	width = round_down(width, fmt->hsub);
> -	height = round_down(height, fmt->vsub);
> -
> -	/* Clamp the width and height */
> -	pix->width = clamp(width, FDP1_MIN_W, FDP1_MAX_W);
> -	pix->height = clamp(height, FDP1_MIN_H, FDP1_MAX_H);
> -
> -	/* Compute and clamp the stride and image size. While not documented in
> -	 * the datasheet, strides not aligned to a multiple of 128 bytes result
> -	 * in image corruption.
> -	 */
> +	/* Compute and clamp the stride and image size. */
>  	for (i = 0; i < min_t(unsigned int, fmt->num_planes, 2U); ++i) {
>  		unsigned int hsub = i > 0 ? fmt->hsub : 1;
>  		unsigned int vsub = i > 0 ? fmt->vsub : 1;
> @@ -1591,91 +1522,247 @@ static int __fdp1_try_fmt(struct fdp1_ctx *ctx, const struct fdp1_fmt **fmtinfo,
>  
>  		bpl = clamp_t(unsigned int, pix->plane_fmt[i].bytesperline,
>  			      pix->width / hsub * fmt->bpp[i] / 8,
> -			      round_down(65535U, align));
> +			      round_down(FDP1_MAX_STRIDE, align));
>  
>  		pix->plane_fmt[i].bytesperline = round_up(bpl, align);
>  		pix->plane_fmt[i].sizeimage = pix->plane_fmt[i].bytesperline
>  					    * pix->height / vsub;
>  
>  		memset(pix->plane_fmt[i].reserved, 0,
> -				sizeof(pix->plane_fmt[i].reserved));
> +		       sizeof(pix->plane_fmt[i].reserved));
>  	}
>  
>  	if (fmt->num_planes == 3) {
> -		/* The second and third planes must have the same stride. */
> +		/* The two chroma planes must have the same stride. */
>  		pix->plane_fmt[2].bytesperline = pix->plane_fmt[1].bytesperline;
>  		pix->plane_fmt[2].sizeimage = pix->plane_fmt[1].sizeimage;
>  
>  		memset(pix->plane_fmt[2].reserved, 0,
> -				sizeof(pix->plane_fmt[2].reserved));
> +		       sizeof(pix->plane_fmt[2].reserved));
>  	}
> +}
> +
> +static void fdp1_try_fmt_output(struct fdp1_ctx *ctx,
> +				const struct fdp1_fmt **fmtinfo,
> +				struct v4l2_pix_format_mplane *pix)
> +{
> +	const struct fdp1_fmt *fmt;
> +	unsigned int width;
> +	unsigned int height;
> +
> +	/* Validate the pixel format to ensure the output queue supports it. */
> +	fmt = fdp1_find_format(pix->pixelformat);
> +	if (!fmt || !(fmt->types & FDP1_OUTPUT))
> +		fmt = fdp1_find_format(V4L2_PIX_FMT_YUYV);
> +
> +	if (fmtinfo)
> +		*fmtinfo = fmt;
>  
> +	pix->pixelformat = fmt->fourcc;
>  	pix->num_planes = fmt->num_planes;
>  
> +	/*
> +	 * Progressive video and all interlaced field orders are acceptable.
> +	 * Default to V4L2_FIELD_INTERLACED.
> +	 */
> +	if (pix->field != V4L2_FIELD_NONE &&
> +	    pix->field != V4L2_FIELD_ALTERNATE &&
> +	    !V4L2_FIELD_HAS_BOTH(pix->field))
> +		pix->field = V4L2_FIELD_INTERLACED;
> +
> +	/*
> +	 * The deinterlacer doesn't care about the colorspace, accept all values
> +	 * and default to V4L2_COLORSPACE_SMPTE170M. The YUV to RGB conversion
> +	 * at the output of the deinterlacer supports a subset of encodings and
> +	 * quantization methods and will only be available when the colorspace
> +	 * allows it.
> +	 */
> +	if (pix->colorspace == V4L2_COLORSPACE_DEFAULT)
> +		pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
> +
> +	/*
> +	 * Align the width and height for YUV 4:2:2 and 4:2:0 formats and clamp
> +	 * them to the supported frame size range. The height boundary are
> +	 * related to the full frame, divide them by two when the format passes
> +	 * fields in separate buffers.
> +	 */
> +	width = round_down(pix->width, fmt->hsub);
> +	pix->width = clamp(width, FDP1_MIN_W, FDP1_MAX_W);
> +
> +	height = round_down(pix->height, fmt->vsub);
> +	if (pix->field == V4L2_FIELD_ALTERNATE)
> +		pix->height = clamp(height, FDP1_MIN_H / 2, FDP1_MAX_H / 2);
> +	else
> +		pix->height = clamp(height, FDP1_MIN_H, FDP1_MAX_H);
> +
> +	fdp1_compute_stride(pix, fmt);
> +}
> +
> +static void fdp1_try_fmt_capture(struct fdp1_ctx *ctx,
> +				 const struct fdp1_fmt **fmtinfo,
> +				 struct v4l2_pix_format_mplane *pix)
> +{
> +	struct fdp1_q_data *src_data = &ctx->out_q;
> +	enum v4l2_colorspace colorspace;
> +	enum v4l2_ycbcr_encoding ycbcr_enc;
> +	enum v4l2_quantization quantization;
> +	const struct fdp1_fmt *fmt;
> +	bool allow_rgb;
> +
> +	/*
> +	 * Validate the pixel format. We can only accept RGB output formats if
> +	 * the input encoding and quantization are compatible with the format
> +	 * conversions supported by the hardware. The supported combinations are
> +	 *
> +	 * V4L2_YCBCR_ENC_601 + V4L2_QUANTIZATION_LIM_RANGE
> +	 * V4L2_YCBCR_ENC_601 + V4L2_QUANTIZATION_FULL_RANGE
> +	 * V4L2_YCBCR_ENC_709 + V4L2_QUANTIZATION_LIM_RANGE
> +	 */
> +	colorspace = src_data->format.colorspace;
> +
> +	ycbcr_enc = src_data->format.ycbcr_enc;
> +	if (ycbcr_enc == V4L2_YCBCR_ENC_DEFAULT)
> +		ycbcr_enc = V4L2_MAP_YCBCR_ENC_DEFAULT(colorspace);
> +
> +	quantization = src_data->format.quantization;
> +	if (quantization == V4L2_QUANTIZATION_DEFAULT)
> +		quantization = V4L2_MAP_QUANTIZATION_DEFAULT(false, colorspace,
> +							     ycbcr_enc);
> +
> +	allow_rgb = ycbcr_enc == V4L2_YCBCR_ENC_601 ||
> +		    (ycbcr_enc == V4L2_YCBCR_ENC_709 &&
> +		     quantization == V4L2_QUANTIZATION_LIM_RANGE);
> +
> +	fmt = fdp1_find_format(pix->pixelformat);
> +	if (!fmt || (!allow_rgb && fdp1_fmt_is_rgb(fmt)))
> +		fmt = fdp1_find_format(V4L2_PIX_FMT_YUYV);
> +
>  	if (fmtinfo)
>  		*fmtinfo = fmt;
>  
> -	return 0;
> +	pix->pixelformat = fmt->fourcc;
> +	pix->num_planes = fmt->num_planes;
> +	pix->field = V4L2_FIELD_NONE;
> +
> +	/*
> +	 * The colorspace on the capture queue is copied from the output queue
> +	 * as the hardware can't change the colorspace. It can convert YCbCr to
> +	 * RGB though, in which case the encoding and quantization are set to
> +	 * default values as anything else wouldn't make sense.
> +	 */
> +	pix->colorspace = src_data->format.colorspace;
> +	pix->xfer_func = src_data->format.xfer_func;
> +
> +	if (fdp1_fmt_is_rgb(fmt)) {
> +		pix->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +		pix->quantization = V4L2_QUANTIZATION_DEFAULT;
> +	} else {
> +		pix->ycbcr_enc = src_data->format.ycbcr_enc;
> +		pix->quantization = src_data->format.quantization;
> +	}
> +
> +	/*
> +	 * The frame width is identical to the output queue, and the height is
> +	 * either doubled or identical depending on whether the output queue
> +	 * field order contains one or two fields per frame.
> +	 */
> +	pix->width = src_data->format.width;
> +	if (src_data->format.field == V4L2_FIELD_ALTERNATE)
> +		pix->height = 2 * src_data->format.height;
> +	else
> +		pix->height = src_data->format.height;
> +
> +	fdp1_compute_stride(pix, fmt);
>  }
>  
>  static int fdp1_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>  {
>  	struct fdp1_ctx *ctx = fh_to_ctx(priv);
> -	int ret;
>  
> -	ret = __fdp1_try_fmt(ctx, NULL, &f->fmt.pix_mp, f->type);
> +	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		fdp1_try_fmt_output(ctx, NULL, &f->fmt.pix_mp);
> +	else
> +		fdp1_try_fmt_capture(ctx, NULL, &f->fmt.pix_mp);
>  
> -	if (ret < 0)
> -		dprintk(ctx->fdp1, "try_fmt failed %d\n", ret);
> +	dprintk(ctx->fdp1, "Try %s format: %4s (0x%08x) %ux%u field %u\n",
> +		V4L2_TYPE_IS_OUTPUT(f->type) ? "output" : "capture",
> +		(char *)&f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.pixelformat,
> +		f->fmt.pix_mp.width, f->fmt.pix_mp.height, f->fmt.pix_mp.field);
>  
> -	return ret;
> +	return 0;
>  }
>  
> -static int fdp1_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +static void fdp1_set_format(struct fdp1_ctx *ctx,
> +			    struct v4l2_pix_format_mplane *pix,
> +			    enum v4l2_buf_type type)
>  {
> -	struct vb2_queue *vq;
> -	struct fdp1_ctx *ctx = fh_to_ctx(priv);
> -	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
> -	struct fdp1_q_data *q_data;
> +	struct fdp1_q_data *q_data = get_q_data(ctx, type);
>  	const struct fdp1_fmt *fmtinfo;
> -	int ret;
> -
> -	vq = v4l2_m2m_get_vq(m2m_ctx, f->type);
> -
> -	if (vb2_is_busy(vq)) {
> -		v4l2_err(&ctx->fdp1->v4l2_dev, "%s queue busy\n", __func__);
> -		return -EBUSY;
> -	}
>  
> -	ret = __fdp1_try_fmt(ctx, &fmtinfo, &f->fmt.pix_mp, f->type);
> -	if (ret < 0) {
> -		v4l2_err(&ctx->fdp1->v4l2_dev, "set_fmt failed %d\n", ret);
> -		return ret;
> -	}
> +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +		fdp1_try_fmt_output(ctx, &fmtinfo, pix);
> +	else
> +		fdp1_try_fmt_capture(ctx, &fmtinfo, pix);
>  
> -	q_data = get_q_data(ctx, f->type);
> -	q_data->format = f->fmt.pix_mp;
>  	q_data->fmt = fmtinfo;
> +	q_data->format = *pix;
>  
> -	q_data->vsize = f->fmt.pix_mp.height;
> -	if (q_data->format.field != V4L2_FIELD_NONE)
> +	q_data->vsize = pix->height;
> +	if (pix->field != V4L2_FIELD_NONE)
>  		q_data->vsize /= 2;
>  
> -	q_data->stride_y = q_data->format.plane_fmt[0].bytesperline;
> -	q_data->stride_c = q_data->format.plane_fmt[1].bytesperline;
> +	q_data->stride_y = pix->plane_fmt[0].bytesperline;
> +	q_data->stride_c = pix->plane_fmt[1].bytesperline;
>  
>  	/* Adjust strides for interleaved buffers */
> -	if (q_data->format.field == V4L2_FIELD_INTERLACED ||
> -	    q_data->format.field == V4L2_FIELD_INTERLACED_TB ||
> -	    q_data->format.field == V4L2_FIELD_INTERLACED_BT) {
> +	if (pix->field == V4L2_FIELD_INTERLACED ||
> +	    pix->field == V4L2_FIELD_INTERLACED_TB ||
> +	    pix->field == V4L2_FIELD_INTERLACED_BT) {
>  		q_data->stride_y *= 2;
>  		q_data->stride_c *= 2;
>  	}
>  
> -	dprintk(ctx->fdp1,
> -		"Setting format for type %d, wxh: %dx%d, fmt: %4s (%d)\n",
> -			f->type, q_data->format.width, q_data->format.height,
> -			(char *)&q_data->fmt->fourcc, q_data->fmt->fourcc);
> +	/* Propagate the format from the output node to the capture node. */
> +	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +		struct fdp1_q_data *dst_data = &ctx->cap_q;
> +
> +		/*
> +		 * Copy the format, clear the per-plane bytes per line and image
> +		 * size, override the field and double the height if needed.
> +		 */
> +		dst_data->format = q_data->format;
> +		memset(dst_data->format.plane_fmt, 0,
> +		       sizeof(dst_data->format.plane_fmt));
> +
> +		dst_data->format.field = V4L2_FIELD_NONE;
> +		if (pix->field == V4L2_FIELD_ALTERNATE)
> +			dst_data->format.height *= 2;
> +
> +		fdp1_try_fmt_capture(ctx, &dst_data->fmt, &dst_data->format);
> +
> +		dst_data->vsize = dst_data->format.height;
> +		dst_data->stride_y = dst_data->format.plane_fmt[0].bytesperline;
> +		dst_data->stride_c = dst_data->format.plane_fmt[1].bytesperline;
> +	}
> +}
> +
> +static int fdp1_s_fmt(struct file *file, void *priv, struct v4l2_format *f)
> +{
> +	struct fdp1_ctx *ctx = fh_to_ctx(priv);
> +	struct v4l2_m2m_ctx *m2m_ctx = ctx->fh.m2m_ctx;
> +	struct vb2_queue *vq = v4l2_m2m_get_vq(m2m_ctx, f->type);
> +
> +	if (vb2_is_busy(vq)) {
> +		v4l2_err(&ctx->fdp1->v4l2_dev, "%s queue busy\n", __func__);
> +		return -EBUSY;
> +	}
> +
> +	fdp1_set_format(ctx, &f->fmt.pix_mp, f->type);
> +
> +	dprintk(ctx->fdp1, "Set %s format: %4s (0x%08x) %ux%u field %u\n",
> +		V4L2_TYPE_IS_OUTPUT(f->type) ? "output" : "capture",
> +		(char *)&f->fmt.pix_mp.pixelformat, f->fmt.pix_mp.pixelformat,
> +		f->fmt.pix_mp.width, f->fmt.pix_mp.height, f->fmt.pix_mp.field);
>  
>  	return 0;
>  }
> @@ -1989,6 +2076,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
>  static int fdp1_open(struct file *file)
>  {
>  	struct fdp1_dev *fdp1 = video_drvdata(file);
> +	struct v4l2_pix_format_mplane format;
>  	struct fdp1_ctx *ctx = NULL;
>  	struct v4l2_ctrl *ctrl;
>  	unsigned int i;
> @@ -2044,10 +2132,8 @@ static int fdp1_open(struct file *file)
>  	v4l2_ctrl_handler_setup(&ctx->hdl);
>  
>  	/* Configure default parameters. */
> -	__fdp1_try_fmt(ctx, &ctx->out_q.fmt, &ctx->out_q.format,
> -		      V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
> -	__fdp1_try_fmt(ctx, &ctx->cap_q.fmt, &ctx->cap_q.format,
> -		      V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE);
> +	memset(&format, 0, sizeof(format));
> +	fdp1_set_format(ctx, &format, V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE);
>  
>  	ctx->fh.m2m_ctx = v4l2_m2m_ctx_init(fdp1->m2m_dev, ctx, &queue_init);
>  
> 

-- 
Regards

Kieran Bingham
