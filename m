Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4141 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab3KSOwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:52:55 -0500
Message-ID: <528B7B36.4020009@xs4all.nl>
Date: Tue, 19 Nov 2013 15:52:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH 15/16] s5p-jpeg: Ensure setting correct value of the chroma
 subsampling control
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com> <1384871228-6648-16-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1384871228-6648-16-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/19/2013 03:27 PM, Jacek Anaszewski wrote:
> Exynos4x12 has limitations regarding setting chroma subsampling
> of an output JPEG image. It cannot be lower than the subsampling
> of the raw source image. Also in case of V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY
> option the source image fourcc has to be V4L2_PIX_FMT_GREY.
> This patch adds mechanism that prevents setting invalid value
> of the V4L2_CID_JPEG_CHROMA_SUBSAMPLING control.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c |   27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index d4db612..3605470 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1176,6 +1176,7 @@ static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct s5p_jpeg_ctx *ctx = ctrl_to_ctx(ctrl);
>  	unsigned long flags;
> +	int ret = 0;
>  
>  	spin_lock_irqsave(&ctx->jpeg->slock, flags);
>  
> @@ -1187,12 +1188,34 @@ static int s5p_jpeg_s_ctrl(struct v4l2_ctrl *ctrl)
>  		ctx->restart_interval = ctrl->val;
>  		break;
>  	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
> -		ctx->subsampling = ctrl->val;
> +		if (ctx->jpeg->variant->version == SJPEG_S5P) {
> +			ctx->subsampling = ctrl->val;
> +			break;
> +		}
> +		/*
> +		 * The exynos4x12 device requires input raw image fourcc
> +		 * to be V4L2_PIX_FMT_GREY if gray jpeg format
> +		 * is to be set.
> +		 */
> +		if (ctx->out_q.fmt->fourcc != V4L2_PIX_FMT_GREY &&
> +		    ctrl->val == V4L2_JPEG_CHROMA_SUBSAMPLING_GRAY) {
> +			ret = -EINVAL;
> +			goto error_free;
> +		}
> +		/*
> +		 * The exynos4x12 device requires resulting jpeg subsampling
> +		 * not to be lower than the input raw image subsampling.
> +		 */
> +		if (ctx->out_q.fmt->subsampling > ctrl->val)
> +			ctx->subsampling = ctx->out_q.fmt->subsampling;
> +		else
> +			ctx->subsampling = ctrl->val;

I would do this in a try_ctrl op instead: that way VIDIOC_TRY_EXT_CTRLS will
also be able to understand these restrictions.

Before the s_ctrl op is called the control framework will always call the
try_ctrl op as well if it is present.

Regards,

	Hans

>  		break;
>  	}
>  
> +error_free:
>  	spin_unlock_irqrestore(&ctx->jpeg->slock, flags);
> -	return 0;
> +	return ret;
>  }
>  
>  static const struct v4l2_ctrl_ops s5p_jpeg_ctrl_ops = {
> 

