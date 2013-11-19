Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2168 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab3KSOrP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:47:15 -0500
Message-ID: <528B79E1.6050102@xs4all.nl>
Date: Tue, 19 Nov 2013 15:46:57 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
CC: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH 14/16] s5p-jpeg: Synchronize V4L2_CID_JPEG_CHROMA_SUBSAMPLING
 control value
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com> <1384871228-6648-15-git-send-email-j.anaszewski@samsung.com>
In-Reply-To: <1384871228-6648-15-git-send-email-j.anaszewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/19/2013 03:27 PM, Jacek Anaszewski wrote:
> When output queue fourcc is set to any flavour of YUV,
> the V4L2_CID_JPEG_CHROMA_SUBSAMPLING control value as
> well as its in-driver cached counterpart have to be
> updated with the subsampling property of the format
> so as to be able to provide correct information to the
> user space and preclude setting an illegal subsampling
> mode for Exynos4x12 encoder.
> 
> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-jpeg/jpeg-core.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 319be0c..d4db612 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1038,6 +1038,7 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
>  {
>  	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
>  	struct s5p_jpeg_fmt *fmt;
> +	struct v4l2_control ctrl_subs;
>  
>  	fmt = s5p_jpeg_find_format(ctx, f->fmt.pix.pixelformat,
>  						FMT_TYPE_OUTPUT);
> @@ -1048,6 +1049,10 @@ static int s5p_jpeg_try_fmt_vid_out(struct file *file, void *priv,
>  		return -EINVAL;
>  	}
>  
> +	ctrl_subs.id = V4L2_CID_JPEG_CHROMA_SUBSAMPLING;
> +	ctrl_subs.value = fmt->subsampling;
> +	v4l2_s_ctrl(priv, &ctx->ctrl_handler, &ctrl_subs);

TRY_FMT should never have side-effects, so this isn't the correct
way of implementing this.

Also, don't use v4l2_s_ctrl, instead use v4l2_ctrl_s_ctrl. The v4l2_s_ctrl
function is for core framework use only, not for use in drivers.

Regards,

	Hans

> +
>  	return vidioc_try_fmt(f, fmt, ctx, FMT_TYPE_OUTPUT);
>  }
>  
> 

