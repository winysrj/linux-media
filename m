Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:40481 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751912AbcGAKue (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 06:50:34 -0400
Subject: Re: [PATCH 2/2] tw686x: Support VIDIOC_{S,G}_PARM ioctls
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media@vger.kernel.org
References: <20160629021735.24463-1-ezequiel@vanguardiasur.com.ar>
 <20160629021735.24463-2-ezequiel@vanguardiasur.com.ar>
Cc: mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <04ed5330-c64a-f283-5984-7a0fd1f69a47@xs4all.nl>
Date: Fri, 1 Jul 2016 12:46:38 +0200
MIME-Version: 1.0
In-Reply-To: <20160629021735.24463-2-ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/29/2016 04:17 AM, Ezequiel Garcia wrote:
> Now that the frame rate can be properly set, this commit adds support
> for S_PARM and G_PARM.

As mentioned in our irc discussion you also need to add enum_framesize/intervals.
Otherwise applications won't know what values to use with s_parm.

> 
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---
>  drivers/media/pci/tw686x/tw686x-video.c | 46 ++++++++++++++++++++++++++++++---
>  1 file changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> index 3131f9305313..40b5b835d452 100644
> --- a/drivers/media/pci/tw686x/tw686x-video.c
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -437,9 +437,6 @@ static void tw686x_set_framerate(struct tw686x_video_channel *vc,
>  {
>  	unsigned int i;
>  
> -	if (vc->fps == fps)
> -		return;
> -
>  	i = tw686x_fps_idx(fps, TW686X_MAX_FPS(vc->video_standard));
>  	reg_write(vc->dev, VIDEO_FIELD_CTRL[vc->ch], fps_map[i]);
>  	vc->fps = tw686x_real_fps(i, TW686X_MAX_FPS(vc->video_standard));
> @@ -843,6 +840,12 @@ static int tw686x_s_std(struct file *file, void *priv, v4l2_std_id id)
>  	ret = tw686x_g_fmt_vid_cap(file, priv, &f);
>  	if (!ret)
>  		tw686x_s_fmt_vid_cap(file, priv, &f);
> +
> +	/*
> +	 * Frame decimation depends on the chosen standard,
> +	 * so reset it to the current value.
> +	 */
> +	tw686x_set_framerate(vc, vc->fps);
>  	return 0;
>  }
>  
> @@ -912,6 +915,40 @@ static int tw686x_g_std(struct file *file, void *priv, v4l2_std_id *id)
>  	return 0;
>  }
>  
> +static int tw686x_g_parm(struct file *file, void *priv,
> +			 struct v4l2_streamparm *sp)
> +{
> +	struct tw686x_video_channel *vc = video_drvdata(file);
> +	struct v4l2_captureparm *cp = &sp->parm.capture;
> +
> +	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		return -EINVAL;

You need this check in s_parm as well.

> +	sp->parm.capture.readbuffers = 3;
> +
> +	cp->capability = V4L2_CAP_TIMEPERFRAME;
> +	cp->timeperframe.numerator = 1;
> +	cp->timeperframe.denominator = vc->fps;
> +	return 0;
> +}
> +
> +static int tw686x_s_parm(struct file *file, void *priv,
> +			 struct v4l2_streamparm *sp)
> +{
> +	struct tw686x_video_channel *vc = video_drvdata(file);
> +	struct v4l2_captureparm *cp = &sp->parm.capture;
> +	unsigned int denominator = cp->timeperframe.denominator;
> +	unsigned int numerator = cp->timeperframe.numerator;
> +	unsigned int fps;
> +
> +	if (vb2_is_busy(&vc->vidq))
> +		return -EBUSY;
> +
> +	fps = (!numerator || !denominator) ? 0 : denominator / numerator;
> +	if (vc->fps != fps)
> +		tw686x_set_framerate(vc, fps);
> +	return tw686x_g_parm(file, priv, sp);
> +}
> +
>  static int tw686x_enum_fmt_vid_cap(struct file *file, void *priv,
>  				   struct v4l2_fmtdesc *f)
>  {
> @@ -998,6 +1035,9 @@ static const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
>  	.vidioc_g_std			= tw686x_g_std,
>  	.vidioc_s_std			= tw686x_s_std,
>  
> +	.vidioc_g_parm			= tw686x_g_parm,
> +	.vidioc_s_parm			= tw686x_s_parm,
> +
>  	.vidioc_enum_input		= tw686x_enum_input,
>  	.vidioc_g_input			= tw686x_g_input,
>  	.vidioc_s_input			= tw686x_s_input,
> 

Regards,

	Hans
