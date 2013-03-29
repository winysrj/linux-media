Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2418 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3C2Mtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Mar 2013 08:49:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] radio-si476x: vidioc_s* now uses a const parameter
Date: Fri, 29 Mar 2013 13:49:22 +0100
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Andrey Smirnov <andrew.smirnov@gmail.com>
References: <1364561197-19719-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1364561197-19719-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303291349.22993.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 29 2013 13:46:37 Mauro Carvalho Chehab wrote:
> vidioc_s_tuner, vidioc_s_frequency and vidioc_s_register now
> uses a constant argument. So, the driver reports warnings:
> 
> 	drivers/media/radio/radio-si476x.c:1196:2: warning: initialization from incompatible pointer type [enabled by default]
> 	drivers/media/radio/radio-si476x.c:1196:2: warning: (near initialization for 'si4761_ioctl_ops.vidioc_s_tuner') [enabled by default]
> 	drivers/media/radio/radio-si476x.c:1199:2: warning: initialization from incompatible pointer type [enabled by default]
> 	drivers/media/radio/radio-si476x.c:1199:2: warning: (near initialization for 'si4761_ioctl_ops.vidioc_s_frequency') [enabled by default]
> 	drivers/media/radio/radio-si476x.c:1209:2: warning: initialization from incompatible pointer type [enabled by default]
> 	drivers/media/radio/radio-si476x.c:1209:2: warning: (near initialization for 'si4761_ioctl_ops.vidioc_s_register') [enabled by default]
> 
> This is due to a (soft) merge conflict, as both this driver and the
> const patches were applied for the same Kernel version.
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> Cc: Andrey Smirnov <andrew.smirnov@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/radio/radio-si476x.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
> index 0895a0c..9430c6a 100644
> --- a/drivers/media/radio/radio-si476x.c
> +++ b/drivers/media/radio/radio-si476x.c
> @@ -472,7 +472,7 @@ static int si476x_radio_g_tuner(struct file *file, void *priv,
>  }
>  
>  static int si476x_radio_s_tuner(struct file *file, void *priv,
> -				struct v4l2_tuner *tuner)
> +				const struct v4l2_tuner *tuner)
>  {
>  	struct si476x_radio *radio = video_drvdata(file);
>  
> @@ -699,15 +699,16 @@ static int si476x_radio_g_frequency(struct file *file, void *priv,
>  }
>  
>  static int si476x_radio_s_frequency(struct file *file, void *priv,
> -				    struct v4l2_frequency *f)
> +				    const struct v4l2_frequency *f)
>  {
>  	int err;
> +	u32 freq = f->frequency;
>  	struct si476x_tune_freq_args args;
>  	struct si476x_radio *radio = video_drvdata(file);
>  
>  	const u32 midrange = (si476x_bands[SI476X_BAND_AM].rangehigh +
>  			      si476x_bands[SI476X_BAND_FM].rangelow) / 2;
> -	const int band = (f->frequency > midrange) ?
> +	const int band = (freq > midrange) ?
>  		SI476X_BAND_FM : SI476X_BAND_AM;
>  	const enum si476x_func func = (band == SI476X_BAND_AM) ?
>  		SI476X_FUNC_AM_RECEIVER : SI476X_FUNC_FM_RECEIVER;
> @@ -718,11 +719,11 @@ static int si476x_radio_s_frequency(struct file *file, void *priv,
>  
>  	si476x_core_lock(radio->core);
>  
> -	f->frequency = clamp(f->frequency,
> -			     si476x_bands[band].rangelow,
> -			     si476x_bands[band].rangehigh);
> +	freq = clamp(freq,
> +		     si476x_bands[band].rangelow,
> +		     si476x_bands[band].rangehigh);
>  
> -	if (si476x_radio_freq_is_inside_of_the_band(f->frequency,
> +	if (si476x_radio_freq_is_inside_of_the_band(freq,
>  						    SI476X_BAND_AM) &&
>  	    (!si476x_core_has_am(radio->core) ||
>  	     si476x_core_is_a_secondary_tuner(radio->core))) {
> @@ -737,8 +738,7 @@ static int si476x_radio_s_frequency(struct file *file, void *priv,
>  	args.zifsr		= false;
>  	args.hd			= false;
>  	args.injside		= SI476X_INJSIDE_AUTO;
> -	args.freq		= v4l2_to_si476x(radio->core,
> -						 f->frequency);
> +	args.freq		= v4l2_to_si476x(radio->core, freq);
>  	args.tunemode		= SI476X_TM_VALIDATED_NORMAL_TUNE;
>  	args.smoothmetrics	= SI476X_SM_INITIALIZE_AUDIO;
>  	args.antcap		= 0;
> @@ -1046,7 +1046,7 @@ static int si476x_radio_g_register(struct file *file, void *fh,
>  	return err;
>  }
>  static int si476x_radio_s_register(struct file *file, void *fh,
> -				   struct v4l2_dbg_register *reg)
> +				   const struct v4l2_dbg_register *reg)
>  {
>  
>  	int err;
> 
