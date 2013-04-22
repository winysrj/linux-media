Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3696 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab3DVHSr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Apr 2013 03:18:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFCv3 07/10] [media] tuner-core: add SDR support for g_tuner
Date: Mon, 22 Apr 2013 09:18:27 +0200
References: <1366570839-662-1-git-send-email-mchehab@redhat.com> <1366570839-662-8-git-send-email-mchehab@redhat.com>
In-Reply-To: <1366570839-662-8-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304220918.27748.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun April 21 2013 21:00:36 Mauro Carvalho Chehab wrote:
> Properly initialize the fields for VIDIOC_G_TUNER, if the
> device is in SDR mode.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/v4l2-core/tuner-core.c | 29 +++++++++++++++++++++++++----
>  1 file changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/tuner-core.c b/drivers/media/v4l2-core/tuner-core.c
> index b97ec63..e54b5ae 100644
> --- a/drivers/media/v4l2-core/tuner-core.c
> +++ b/drivers/media/v4l2-core/tuner-core.c
> @@ -1190,7 +1190,31 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  	}
>  
>  	/* radio mode */
> -	if (vt->type == t->mode) {
> +	vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
> +
> +	if (V4L2_TUNER_IS_SDR(vt->type)) {
> +		vt->rangelow  = tv_range[0] * 16000;
> +		vt->rangehigh = tv_range[1] * 16000;

Why use tv_range for SDR? It's a bit odd for something called SD 'Radio'.

Regards,

	Hans

> +	else {
> +		vt->rangelow = radio_range[0] * 16000;
> +		vt->rangehigh = radio_range[1] * 16000;
> +	}
> +	/* Check if the radio device is active */
> +	if (vt->type != t->mode)
> +		return 0;
> +
> +	if (V4L2_TUNER_IS_SDR(vt->type)) {
> +		if (fe_tuner_ops->get_bandwidth)
> +			fe_tuner_ops->get_bandwidth(&t->fe,
> +							&vt->bandwidth);
> +		if (fe_tuner_ops->get_if_frequency)
> +			fe_tuner_ops->get_if_frequency(&t->fe,
> +							&vt->int_freq);
> +		/*
> +			* Sampe rate is not a tuner props - it is up to the
> +			* bridge driver to fill it.
> +			*/
> +	} else {
>  		vt->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
>  		if (fe_tuner_ops->get_status) {
>  			u32 tuner_status;
> @@ -1203,9 +1227,6 @@ static int tuner_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
>  		}
>  		vt->audmode = t->audmode;
>  	}
> -	vt->capability |= V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
> -	vt->rangelow = radio_range[0] * 16000;
> -	vt->rangehigh = radio_range[1] * 16000;
>  
>  	return 0;
>  }
> 
