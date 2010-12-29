Return-path: <mchehab@gaivota>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:21188 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab0L2PUn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 10:20:43 -0500
Date: Wed, 29 Dec 2010 16:20:38 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2] [media] s5p-fimc: update checking scaling ratio range
In-reply-to: <1293585163-23907-1-git-send-email-khw0178.kim@samsung.com>
To: Hyunwoong Kim <khw0178.kim@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Message-id: <4D1B51C6.2020604@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1293585163-23907-1-git-send-email-khw0178.kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


On 12/29/2010 02:12 AM, Hyunwoong Kim wrote:
> Horizontal and vertical scaling range are according to the following equations.
> If (SRC_Width >= 64 x DST_Width) { Exit(-1);  /* Out of Horizontal scale range}
> If (SRC_Height >= 64 x DST_Height) { Exit(-1);  /* Out of Vertical scale range}
> 
> fimc_check_scaler_ratio() is used to check if horizontal and vertical
> scale range are valid or not. To use fimc_check_scaler_ratio,
> source and destination format should be set by VIDIOC_S_FMT.
> And in case of scaling up, it doesn't have to check the scale range.
> 
> Reviewed-by: Jonghun Han <jonghun.han@samsung.com>
> Signed-off-by: Hyunwoong Kim <khw0178.kim@samsung.com>
> ---
> Changes since V1:
> - change the definition of fimc_check_scaler_ratio()
> - remove the code to copy arguments
> 
> This patch is depended on Hyunwoong Kim's last patch.
> - [PATCH v2] [media] s5p-fimc: Configure scaler registers depending on FIMC version
> 
>  drivers/media/video/s5p-fimc/fimc-capture.c |    4 +-
>  drivers/media/video/s5p-fimc/fimc-core.c    |   59 ++++++++++++++++++---------
>  drivers/media/video/s5p-fimc/fimc-core.h    |    2 +-
>  3 files changed, 44 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c b/drivers/media/video/s5p-fimc/fimc-capture.c
> index b1cb937..e22a78c 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -761,7 +761,9 @@ static int fimc_cap_s_crop(struct file *file, void *fh,
>  
>  	f = &ctx->s_frame;
>  	/* Check for the pixel scaling ratio when cropping input image. */
> -	ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
> +	ret = fimc_check_scaler_ratio(cr->c.width, cr->c.height,
> +				      ctx->d_frame.width, ctx->d_frame.height,
> +				      ctx->rotation);
>  	if (ret) {
>  		v4l2_err(&fimc->vid_cap.v4l2_dev, "Out of the scaler range");
>  		return ret;
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
> index 2b65961..e608fb8 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -198,24 +198,21 @@ static struct v4l2_queryctrl *get_ctrl(int id)
>  	return NULL;
>  }
>  
> -int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f)
> +int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot)
>  {
> -	if (r->width > f->width) {
> -		if (f->width > (r->width * SCALER_MAX_HRATIO))
> -			return -EINVAL;
> -	} else {
> -		if ((f->width * SCALER_MAX_HRATIO) < r->width)
> -			return -EINVAL;
> -	}
> +	int tx, ty;
>  
> -	if (r->height > f->height) {
> -		if (f->height > (r->height * SCALER_MAX_VRATIO))
> -			return -EINVAL;
> +	if (rot == 90 || rot == 270) {
> +		ty = dw;
> +		tx = dh;
>  	} else {
> -		if ((f->height * SCALER_MAX_VRATIO) < r->height)
> -			return -EINVAL;
> +		tx = dw;
> +		ty = dh;
>  	}
>  
> +	if ((sw >= SCALER_MAX_HRATIO * tx) || (sh >= SCALER_MAX_VRATIO * ty))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> @@ -1063,6 +1060,7 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
>  	struct samsung_fimc_variant *variant = ctx->fimc_dev->variant;
>  	struct fimc_dev *fimc = ctx->fimc_dev;
>  	unsigned long flags;
> +	int ret = 0;
>  
>  	if (ctx->rotation != 0 &&
>  	    (ctrl->id == V4L2_CID_HFLIP || ctrl->id == V4L2_CID_VFLIP)) {
> @@ -1089,6 +1087,20 @@ int fimc_s_ctrl(struct fimc_ctx *ctx, struct v4l2_control *ctrl)
>  		break;
>  
>  	case V4L2_CID_ROTATE:
> +		if (!(~ctx->state & (FIMC_DST_FMT | FIMC_SRC_FMT))) {
> +			ret = fimc_check_scaler_ratio(ctx->s_frame.width,
> +						      ctx->s_frame.height,
> +						      ctx->d_frame.width,
> +						      ctx->d_frame.height,
> +						      ctrl->value);
> +			if (ret) {
> +				v4l2_err(&fimc->m2m.v4l2_dev,
> +					 "Out of scaler range");
> +				spin_unlock_irqrestore(&ctx->slock, flags);
> +				return -EINVAL;
> +			}
> +		}
> +
>  		/* Check for the output rotator availability */
>  		if ((ctrl->value == 90 || ctrl->value == 270) &&
>  		    (ctx->in_path == FIMC_DMA && !variant->has_out_rot)) {
> @@ -1237,18 +1249,27 @@ static int fimc_m2m_s_crop(struct file *file, void *fh, struct v4l2_crop *cr)
>  		&ctx->s_frame : &ctx->d_frame;
>  
>  	spin_lock_irqsave(&ctx->slock, flags);
> -	if (~ctx->state & (FIMC_SRC_FMT | FIMC_DST_FMT)) {
> -		/* Check to see if scaling ratio is within supported range */
> -		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -			ret = fimc_check_scaler_ratio(&cr->c, &ctx->d_frame);
> -		else
> -			ret = fimc_check_scaler_ratio(&cr->c, &ctx->s_frame);
> +	/* Check to see if scaling ratio is within supported range */
> +	if (!(~ctx->state & (FIMC_DST_FMT | FIMC_SRC_FMT))) {
> +		if (cr->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +			ret = fimc_check_scaler_ratio(cr->c.width, cr->c.height,
> +						      ctx->d_frame.width,
> +						      ctx->d_frame.height,
> +						      ctx->rotation);
> +		} else {
> +			ret = fimc_check_scaler_ratio(ctx->s_frame.width,
> +						      ctx->s_frame.height,
> +						      cr->c.width, cr->c.height,
> +						      ctx->rotation);
> +		}
> +
>  		if (ret) {
>  			v4l2_err(&fimc->m2m.v4l2_dev, "Out of scaler range");
>  			spin_unlock_irqrestore(&ctx->slock, flags);
>  			return -EINVAL;
>  		}
>  	}
> +
>  	ctx->state |= FIMC_PARAMS;
>  
>  	f->offs_h = cr->c.left;
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
> index d690398..b442fed 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.h
> +++ b/drivers/media/video/s5p-fimc/fimc-core.h
> @@ -605,7 +605,7 @@ struct fimc_fmt *find_format(struct v4l2_format *f, unsigned int mask);
>  struct fimc_fmt *find_mbus_format(struct v4l2_mbus_framefmt *f,
>  				  unsigned int mask);
>  
> -int fimc_check_scaler_ratio(struct v4l2_rect *r, struct fimc_frame *f);
> +int fimc_check_scaler_ratio(int sw, int sh, int dw, int dh, int rot);
>  int fimc_set_scaler_info(struct fimc_ctx *ctx);
>  int fimc_prepare_config(struct fimc_ctx *ctx, u32 flags);
>  int fimc_prepare_addr(struct fimc_ctx *ctx, struct vb2_buffer *vb,

Applied. Thank you.

Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
