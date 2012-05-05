Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:52731 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755250Ab2EEMFX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 May 2012 08:05:23 -0400
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 2/4] si470x: add control event support and more v4l2 compliancy fixes.
Date: Sat, 5 May 2012 14:05:17 +0200
Cc: linux-media@vger.kernel.org,
	Joonyoung Shim <jy0922.shim@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
References: <1336138232-17528-1-git-send-email-hverkuil@xs4all.nl> <0acaad8cb3d59f5301a67f7378e7e540fab3196e.1336137768.git.hans.verkuil@cisco.com>
In-Reply-To: <0acaad8cb3d59f5301a67f7378e7e540fab3196e.1336137768.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205051405.18225.tobias.lorenz@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

thanks for the improvements. Looks good to me.

Acked-by: Tobias Lorenz <tobias.lorenz@gmx.net>

Bye,
Toby

Am Freitag, 4. Mai 2012, 15:30:30 schrieb Hans Verkuil:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/radio/si470x/radio-si470x-common.c |   45
> ++++++++++++++-------- 1 file changed, 28 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/media/radio/si470x/radio-si470x-common.c
> b/drivers/media/radio/si470x/radio-si470x-common.c index de9475f..e70badf
> 100644
> --- a/drivers/media/radio/si470x/radio-si470x-common.c
> +++ b/drivers/media/radio/si470x/radio-si470x-common.c
> @@ -262,7 +262,7 @@ static int si470x_get_freq(struct si470x_device *radio,
> unsigned int *freq) */
>  int si470x_set_freq(struct si470x_device *radio, unsigned int freq)
>  {
> -	unsigned int spacing, band_bottom;
> +	unsigned int spacing, band_bottom, band_top;
>  	unsigned short chan;
> 
>  	/* Spacing (kHz) */
> @@ -278,19 +278,26 @@ int si470x_set_freq(struct si470x_device *radio,
> unsigned int freq) spacing = 0.050 * FREQ_MUL; break;
>  	};
> 
> -	/* Bottom of Band (MHz) */
> +	/* Bottom/Top of Band (MHz) */
>  	switch ((radio->registers[SYSCONFIG2] & SYSCONFIG2_BAND) >> 6) {
>  	/* 0: 87.5 - 108 MHz (USA, Europe) */
>  	case 0:
> -		band_bottom = 87.5 * FREQ_MUL; break;
> +		band_bottom = 87.5 * FREQ_MUL;
> +		band_top = 108 * FREQ_MUL;
> +		break;
>  	/* 1: 76   - 108 MHz (Japan wide band) */
>  	default:
> -		band_bottom = 76   * FREQ_MUL; break;
> +		band_bottom = 76 * FREQ_MUL;
> +		band_top = 108 * FREQ_MUL;
> +		break;
>  	/* 2: 76   -  90 MHz (Japan) */
>  	case 2:
> -		band_bottom = 76   * FREQ_MUL; break;
> +		band_bottom = 76 * FREQ_MUL;
> +		band_top = 90 * FREQ_MUL;
> +		break;
>  	};
> 
> +	freq = clamp(freq, band_bottom, band_top);
>  	/* Chan = [ Freq (Mhz) - Bottom of Band (MHz) ] / Spacing (kHz) */
>  	chan = (freq - band_bottom) / spacing;
> 
> @@ -515,17 +522,19 @@ static unsigned int si470x_fops_poll(struct file
> *file, struct poll_table_struct *pts)
>  {
>  	struct si470x_device *radio = video_drvdata(file);
> -	int retval = 0;
> -
> -	/* switch on rds reception */
> +	unsigned long req_events = poll_requested_events(pts);
> +	int retval = v4l2_ctrl_poll(file, pts);
> 
> -	if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
> -		si470x_rds_on(radio);
> +	if (req_events & (POLLIN | POLLRDNORM)) {
> +		/* switch on rds reception */
> +		if ((radio->registers[SYSCONFIG1] & SYSCONFIG1_RDS) == 0)
> +			si470x_rds_on(radio);
> 
> -	poll_wait(file, &radio->read_queue, pts);
> +		poll_wait(file, &radio->read_queue, pts);
> 
> -	if (radio->rd_index != radio->wr_index)
> -		retval = POLLIN | POLLRDNORM;
> +		if (radio->rd_index != radio->wr_index)
> +			retval |= POLLIN | POLLRDNORM;
> +	}
> 
>  	return retval;
>  }
> @@ -637,6 +646,8 @@ static int si470x_vidioc_g_tuner(struct file *file,
> void *priv, tuner->signal = (radio->registers[STATUSRSSI] &
> STATUSRSSI_RSSI); /* the ideal factor is 0xffff/75 = 873,8 */
>  	tuner->signal = (tuner->signal * 873) + (8 * tuner->signal / 10);
> +	if (tuner->signal > 0xffff)
> +		tuner->signal = 0xffff;
> 
>  	/* automatic frequency control: -1: freq to low, 1 freq to high */
>  	/* AFCRL does only indicate that freq. differs, not if too low/high */
> @@ -660,7 +671,7 @@ static int si470x_vidioc_s_tuner(struct file *file,
> void *priv, int retval = 0;
> 
>  	if (tuner->index != 0)
> -		goto done;
> +		return -EINVAL;
> 
>  	/* mono/stereo selector */
>  	switch (tuner->audmode) {
> @@ -668,15 +679,13 @@ static int si470x_vidioc_s_tuner(struct file *file,
> void *priv, radio->registers[POWERCFG] |= POWERCFG_MONO;  /* force mono */
>  		break;
>  	case V4L2_TUNER_MODE_STEREO:
> +	default:
>  		radio->registers[POWERCFG] &= ~POWERCFG_MONO; /* try stereo */
>  		break;
> -	default:
> -		goto done;
>  	}
> 
>  	retval = si470x_set_register(radio, POWERCFG);
> 
> -done:
>  	if (retval < 0)
>  		dev_warn(&radio->videodev.dev,
>  			"set tuner failed with %d\n", retval);
> @@ -770,6 +779,8 @@ static const struct v4l2_ioctl_ops si470x_ioctl_ops = {
>  	.vidioc_g_frequency	= si470x_vidioc_g_frequency,
>  	.vidioc_s_frequency	= si470x_vidioc_s_frequency,
>  	.vidioc_s_hw_freq_seek	= si470x_vidioc_s_hw_freq_seek,
> +	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>  };

