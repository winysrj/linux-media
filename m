Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45943 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbcGEGlU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Jul 2016 02:41:20 -0400
Subject: Re: [PATCH v2 1/3] sur40: properly report a single frame rate of 60
 FPS
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
References: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
Cc: linux-input@vger.kernel.org, Martin Kaltenbrunner <modin@yuri.at>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f5d84d25-eae4-df9b-819b-256565783c35@xs4all.nl>
Date: Tue, 5 Jul 2016 08:41:13 +0200
MIME-Version: 1.0
In-Reply-To: <1464725733-22119-1-git-send-email-floe@butterbrot.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2016 10:15 PM, Florian Echtler wrote:
> The device hardware is always running at 60 FPS, so report this both via
> PARM_IOCTL and ENUM_FRAMEINTERVALS.
> 
> Signed-off-by: Martin Kaltenbrunner <modin@yuri.at>
> Signed-off-by: Florian Echtler <floe@butterbrot.org>
> ---
>  drivers/input/touchscreen/sur40.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index 880c40b..4b1f703 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -788,6 +788,19 @@ static int sur40_vidioc_fmt(struct file *file, void *priv,
>  	return 0;
>  }
>  
> +static int sur40_ioctl_parm(struct file *file, void *priv,
> +			    struct v4l2_streamparm *p)
> +{
> +	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;
> +
> +	p->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
> +	p->parm.capture.timeperframe.numerator = 1;
> +	p->parm.capture.timeperframe.denominator = 60;
> +	p->parm.capture.readbuffers = 3;
> +	return 0;
> +}
> +
>  static int sur40_vidioc_enum_fmt(struct file *file, void *priv,
>  				 struct v4l2_fmtdesc *f)
>  {
> @@ -814,13 +827,13 @@ static int sur40_vidioc_enum_framesizes(struct file *file, void *priv,
>  static int sur40_vidioc_enum_frameintervals(struct file *file, void *priv,
>  					    struct v4l2_frmivalenum *f)
>  {
> -	if ((f->index > 1) || (f->pixel_format != V4L2_PIX_FMT_GREY)
> +	if ((f->index > 0) || (f->pixel_format != V4L2_PIX_FMT_GREY)
>  		|| (f->width  != sur40_video_format.width)
>  		|| (f->height != sur40_video_format.height))
>  			return -EINVAL;
>  
>  	f->type = V4L2_FRMIVAL_TYPE_DISCRETE;
> -	f->discrete.denominator  = 60/(f->index+1);
> +	f->discrete.denominator  = 60;
>  	f->discrete.numerator = 1;
>  	return 0;
>  }
> @@ -880,6 +893,9 @@ static const struct v4l2_ioctl_ops sur40_video_ioctl_ops = {
>  	.vidioc_enum_framesizes = sur40_vidioc_enum_framesizes,
>  	.vidioc_enum_frameintervals = sur40_vidioc_enum_frameintervals,
>  
> +	.vidioc_g_parm = sur40_ioctl_parm,
> +	.vidioc_s_parm = sur40_ioctl_parm,

Why is s_parm added when you can't change the framerate? Same questions for the
enum_frameintervals function: it doesn't hurt to have it, but if there is only
one unchangeable framerate, then it doesn't make much sense.

Sorry, missed this when I reviewed this the first time around.

Regards,

	Hans

> +
>  	.vidioc_enum_input	= sur40_vidioc_enum_input,
>  	.vidioc_g_input		= sur40_vidioc_g_input,
>  	.vidioc_s_input		= sur40_vidioc_s_input,
> 
