Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1562 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2FRHa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 03:30:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: David Dillow <dave@thedillows.org>
Subject: Re: [RFC] [media] cx231xx: restore tuner settings on first open
Date: Mon, 18 Jun 2012 09:29:48 +0200
Cc: linux-media@vger.kernel.org
References: <1339994998.32360.61.camel@obelisk.thedillows.org>
In-Reply-To: <1339994998.32360.61.camel@obelisk.thedillows.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201206180929.48107.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon June 18 2012 06:49:58 David Dillow wrote:
> Without this patch, MythTV requires some workarounds to be able to
> capture analog TV on my HVR-850. I need to keep the v4l device open via
> 'sleep 365d < /dev/video0' or some other mechanism or there will be no
> recording. Also, I need to run vq4l2 and change the standard away and
> back to NTSC or I'll get garbage. Both of these can be traced to the
> settings (or lack there of) on the tuner.
> 
> The first problem is that we will tell applications that we are in NTSC
> mode for the HVR-850 when they open the device for the first time after
> plugging it in, but never actually set the TDA18271 to NTSC, so it
> defaults to PAL_I. Applications may decide to not change the signal
> standard, as they have been told it is already in the desired state.
> This could be resolved by setting it during init (as we claim in the
> query results), as it seems to survive putting the tuner into standby
> mode.

That's correct. Drivers must set an initial tuner standard and frequency.
It doesn't matter whether that's PAL or NTSC, or what frequency, as long
as there is something setup initially.

> The second problem is a bad interaction between driver behavior and
> MythTV. MythTV opens the video device, tunes to the desired channel,
> then closes the device. It then reopens the device and starts recording.
> While this works for my WinTV-FM PCI card, the cx231xx driver puts the
> tuner into standby after MythTV closes the device, and the tuner looses
> the frequency when waking back up.

That sounds like a bug in the tuner driver: it should remember and restore
the last set frequency when waking up.

> I solved both of these issues by just setting the standard and frequency
> when opening the device for the first user. This fixes the immediate
> problem, but I'm not sure it's the right fix, and I'm a bit
> uncomfortable faking a call into the ioctl() routines.
> 
> What does the V4L2 API spec say about tuning frequency being persistent
> when there are no users of a video capture device? Is MythTV wrong to
> have that assumption, or is cx231xx wrong to not restore the frequency
> when a user first opens the device?

Tuner standards and frequencies must be persistent. So cx231xx is wrong.
Actually, all V4L2 settings must in general be persistent (there are
some per-filehandle settings when dealing with low-level subdev setups or
mem2mem devices).

> Either way, I think MythTV should keep the device open until it is done
> with it, as that would avoid added latency from putting the tuner to
> sleep and waking it back up. But, I think we should address the issue in
> the driver if it is not living up to the guarantees of the API.

>From what I can tell it is a bug in the tda tuner (not restoring the frequency)
and cx231xx (not setting the initial standard and possibly frequency).

Regards,

	Hans

> 
> 
> 
> diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
> index 7f916f0..2794396 100644
> --- a/drivers/media/video/cx231xx/cx231xx-video.c
> +++ b/drivers/media/video/cx231xx/cx231xx-video.c
> @@ -2190,6 +2190,12 @@ static int cx231xx_v4l2_open(struct file *filp)
>  	filp->private_data = fh;
>  
>  	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
> +		struct v4l2_frequency freq = {
> +			.tuner = 0,
> +			.type = V4L2_TUNER_ANALOG_TV,
> +			.frequency = dev->ctl_freq,
> +		};
> +
>  		dev->width = norm_maxw(dev);
>  		dev->height = norm_maxh(dev);
>  
> @@ -2214,6 +2220,11 @@ static int cx231xx_v4l2_open(struct file *filp)
>  		/* device needs to be initialized before isoc transfer */
>  		dev->video_input = dev->video_input > 2 ? 2 : dev->video_input;
>  
> +		/* Restore standard and channel, as they may be lost when
> +		 * the tuner went to sleep.
> +		 */
> +		vidioc_s_std(filp, fh, &dev->norm);
> +		vidioc_s_frequency(filp, fh, &freq);
>  	}
>  	if (fh->radio) {
>  		cx231xx_videodbg("video_open: setting radio device\n");
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
