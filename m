Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab3BEU5M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 15:57:12 -0500
Date: Tue, 5 Feb 2013 18:57:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] em28xx: fix usb alternate setting for analog and
 digital video endpoints > 0
Message-ID: <20130205185707.5ecb3801@redhat.com>
In-Reply-To: <1358529948-2260-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358529948-2260-1-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Jan 2013 18:25:48 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> While the current code handles sound interfaces with a number > 0 correctly, it
> assumes that the interface number for analog + digital video is always 0 when
> changing the alternate setting.
> 
> (NOTE: the "SpeedLink VAD Laplace webcam" (EM2765) uses interface number 3 for video)
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-audio.c |   10 +++++-----
>  drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
>  drivers/media/usb/em28xx/em28xx-core.c  |    2 +-
>  drivers/media/usb/em28xx/em28xx-dvb.c   |    2 +-
>  drivers/media/usb/em28xx/em28xx.h       |    3 +--
>  5 Dateien geändert, 9 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> index 2fdb66e..cdbfe0a 100644
> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> @@ -283,15 +283,15 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
>  	}
>  
>  	runtime->hw = snd_em28xx_hw_capture;
> -	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
> -		if (dev->audio_ifnum)
> +	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
> +		if (dev->ifnum)

Please don't merge a non-fix change (variable rename) with a fix.

Btw, audio_ifnum is a better name, as it avoids it to be miss-interpreted.

>  			dev->alt = 1;
>  		else
>  			dev->alt = 7;
>  
>  		dprintk("changing alternate number on interface %d to %d\n",
> -			dev->audio_ifnum, dev->alt);
> -		usb_set_interface(dev->udev, dev->audio_ifnum, dev->alt);
> +			dev->ifnum, dev->alt);
> +		usb_set_interface(dev->udev, dev->ifnum, dev->alt);
>  
>  		/* Sets volume, mute, etc */
>  		dev->mute = 0;
> @@ -642,7 +642,7 @@ static int em28xx_audio_init(struct em28xx *dev)
>  	static int          devnr;
>  	int                 err;
>  
> -	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
> +	if (!dev->has_alsa_audio) {
>  		/* This device does not support the extension (in this case
>  		   the device is expecting the snd-usb-audio module or
>  		   doesn't have analog audio support at all) */
> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> index 0a5aa62..553db17 100644
> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> @@ -3376,7 +3376,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
>  	dev->alt   = -1;
>  	dev->is_audio_only = has_audio && !(has_video || has_dvb);
>  	dev->has_alsa_audio = has_audio;
> -	dev->audio_ifnum = ifnum;
> +	dev->ifnum = ifnum;
>  
>  	/* Checks if audio is provided by some interface */
>  	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index ce4f252..210859a 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -862,7 +862,7 @@ set_alt:
>  	}
>  	em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
>  		       dev->alt, dev->max_pkt_size);
> -	errCode = usb_set_interface(dev->udev, 0, dev->alt);
> +	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
>  	if (errCode < 0) {
>  		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
>  				dev->alt, errCode);

This hunk doesn't apply upstream:

patching file drivers/media/usb/em28xx/em28xx-core.c
Hunk #1 FAILED at 862.
1 out of 1 hunk FAILED -- rejects in file drivers/media/usb/em28xx/em28xx-core.c

> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> index a81ec2e..dbeed6c 100644
> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> @@ -196,7 +196,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
>  		dvb_alt = dev->dvb_alt_isoc;
>  	}
>  
> -	usb_set_interface(dev->udev, 0, dvb_alt);
> +	usb_set_interface(dev->udev, dev->ifnum, dvb_alt);
>  	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
>  	if (rc < 0)
>  		return rc;
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 5f0b2c5..0dc5b73 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -487,8 +487,6 @@ struct em28xx {
>  
>  	unsigned char disconnected:1;	/* device has been diconnected */
>  
> -	int audio_ifnum;
> -
>  	struct v4l2_device v4l2_dev;
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	/* provides ac97 mute and volume overrides */
> @@ -597,6 +595,7 @@ struct em28xx {
>  
>  	/* usb transfer */
>  	struct usb_device *udev;	/* the usb device */
> +	int ifnum;			/* usb interface number */
>  	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
>  	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
>  	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */


-- 

Cheers,
Mauro
