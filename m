Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083Ab3BFQDq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Feb 2013 11:03:46 -0500
Date: Wed, 6 Feb 2013 14:03:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] em28xx: fix usb alternate setting for analog and
 digital video endpoints > 0
Message-ID: <20130206140341.28b95d67@redhat.com>
In-Reply-To: <5112775D.1000501@googlemail.com>
References: <1358529948-2260-1-git-send-email-fschaefer.oss@googlemail.com>
	<20130205185707.5ecb3801@redhat.com>
	<51117BAE.5090605@googlemail.com>
	<20130205200643.145178ae@redhat.com>
	<5112775D.1000501@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 06 Feb 2013 16:31:41 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 05.02.2013 23:06, schrieb Mauro Carvalho Chehab:
> > Em Tue, 05 Feb 2013 22:37:50 +0100
> > Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >
> >> Am 05.02.2013 21:57, schrieb Mauro Carvalho Chehab:
> >>> Em Fri, 18 Jan 2013 18:25:48 +0100
> >>> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> >>>
> >>>> While the current code handles sound interfaces with a number > 0 correctly, it
> >>>> assumes that the interface number for analog + digital video is always 0 when
> >>>> changing the alternate setting.
> >>>>
> >>>> (NOTE: the "SpeedLink VAD Laplace webcam" (EM2765) uses interface number 3 for video)
> >>>>
> >>>> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> >>>> ---
> >>>>  drivers/media/usb/em28xx/em28xx-audio.c |   10 +++++-----
> >>>>  drivers/media/usb/em28xx/em28xx-cards.c |    2 +-
> >>>>  drivers/media/usb/em28xx/em28xx-core.c  |    2 +-
> >>>>  drivers/media/usb/em28xx/em28xx-dvb.c   |    2 +-
> >>>>  drivers/media/usb/em28xx/em28xx.h       |    3 +--
> >>>>  5 Dateien geändert, 9 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)
> >>>>
> >>>> diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> >>>> index 2fdb66e..cdbfe0a 100644
> >>>> --- a/drivers/media/usb/em28xx/em28xx-audio.c
> >>>> +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> >>>> @@ -283,15 +283,15 @@ static int snd_em28xx_capture_open(struct snd_pcm_substream *substream)
> >>>>  	}
> >>>>  
> >>>>  	runtime->hw = snd_em28xx_hw_capture;
> >>>> -	if ((dev->alt == 0 || dev->audio_ifnum) && dev->adev.users == 0) {
> >>>> -		if (dev->audio_ifnum)
> >>>> +	if ((dev->alt == 0 || dev->ifnum) && dev->adev.users == 0) {
> >>>> +		if (dev->ifnum)
> >>> Please don't merge a non-fix change (variable rename) with a fix.
> >> Ok, sorry, it seems to be trivial...
> >>
> >>> Btw, audio_ifnum is a better name, as it avoids it to be miss-interpreted.
> >> Did you read the complete patch ? ;)
> >> Or do you really want the video interface number to be called audio_ifnum ?
> > There are two types of em28xx audio vendor class. In one type, the audio IF
> > is the same as the video one, but on the other one, it is different.
> 
> Sure, but if I'm not misunderstanding the code, we have two device
> instances with separate device structs when audio is on a separate
> interface.
>
> Hence we don't need two fields for the interface number in the struct
> and that's why renamed it.

No. The way the extension mechanism was written, the same data instance
is used by all modules. This is what is there at em28xx core:

void em28xx_init_extension(struct em28xx *dev)
{
	const struct em28xx_ops *ops = NULL;

	mutex_lock(&em28xx_devlist_mutex);
	list_add_tail(&dev->devlist, &em28xx_devlist);
	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
		if (ops->init)
			ops->init(dev);
	}
	mutex_unlock(&em28xx_devlist_mutex);
}

The ops->init() receives the data from the main driver. It doesn't matter
if the USB interface is the same or not.

If the changes at the probing code changed that, then it broke audio
support for several devices.

> 
> Regards,
> Frank
> 
> > That's why audio_ifnum were added in the first place.
> >
> > See this commit:
> >
> > commit 4f83e7b3ef938eb9a01eadf81a0f3b2c67d3afb6
> > Author: Mauro Carvalho Chehab <mchehab@redhat.com>
> > Date:   Fri Jun 17 15:15:12 2011 -0300
> >
> >     [media] em28xx: Add support for devices with a separate audio interface
> >     
> >     Some devices use a separate interface for the vendor audio class.
> >     
> >     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >
> >>>>  			dev->alt = 1;
> >>>>  		else
> >>>>  			dev->alt = 7;
> >>>>  
> >>>>  		dprintk("changing alternate number on interface %d to %d\n",
> >>>> -			dev->audio_ifnum, dev->alt);
> >>>> -		usb_set_interface(dev->udev, dev->audio_ifnum, dev->alt);
> >>>> +			dev->ifnum, dev->alt);
> >>>> +		usb_set_interface(dev->udev, dev->ifnum, dev->alt);
> >>>>  
> >>>>  		/* Sets volume, mute, etc */
> >>>>  		dev->mute = 0;
> >>>> @@ -642,7 +642,7 @@ static int em28xx_audio_init(struct em28xx *dev)
> >>>>  	static int          devnr;
> >>>>  	int                 err;
> >>>>  
> >>>> -	if (!dev->has_alsa_audio || dev->audio_ifnum < 0) {
> >>>> +	if (!dev->has_alsa_audio) {
> >>>>  		/* This device does not support the extension (in this case
> >>>>  		   the device is expecting the snd-usb-audio module or
> >>>>  		   doesn't have analog audio support at all) */
> >>>> diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> >>>> index 0a5aa62..553db17 100644
> >>>> --- a/drivers/media/usb/em28xx/em28xx-cards.c
> >>>> +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> >>>> @@ -3376,7 +3376,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >>>>  	dev->alt   = -1;
> >>>>  	dev->is_audio_only = has_audio && !(has_video || has_dvb);
> >>>>  	dev->has_alsa_audio = has_audio;
> >>>> -	dev->audio_ifnum = ifnum;
> >>>> +	dev->ifnum = ifnum;
> >>>>  
> >>>>  	/* Checks if audio is provided by some interface */
> >>>>  	for (i = 0; i < udev->config->desc.bNumInterfaces; i++) {
> >>>> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> >>>> index ce4f252..210859a 100644
> >>>> --- a/drivers/media/usb/em28xx/em28xx-core.c
> >>>> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> >>>> @@ -862,7 +862,7 @@ set_alt:
> >>>>  	}
> >>>>  	em28xx_coredbg("setting alternate %d with wMaxPacketSize=%u\n",
> >>>>  		       dev->alt, dev->max_pkt_size);
> >>>> -	errCode = usb_set_interface(dev->udev, 0, dev->alt);
> >>>> +	errCode = usb_set_interface(dev->udev, dev->ifnum, dev->alt);
> >>>>  	if (errCode < 0) {
> >>>>  		em28xx_errdev("cannot change alternate number to %d (error=%i)\n",
> >>>>  				dev->alt, errCode);
> >>> This hunk doesn't apply upstream:
> >>>
> >>> patching file drivers/media/usb/em28xx/em28xx-core.c
> >>> Hunk #1 FAILED at 862.
> >>> 1 out of 1 hunk FAILED -- rejects in file drivers/media/usb/em28xx/em28xx-core.c
> >> It applies after
> >>
> >> http://patchwork.linuxtv.org/patch/16197/
> >>
> >> has been applied.
> >>
> >> Regards,
> >> Frank
> >>
> >>>> diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> >>>> index a81ec2e..dbeed6c 100644
> >>>> --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> >>>> +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> >>>> @@ -196,7 +196,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
> >>>>  		dvb_alt = dev->dvb_alt_isoc;
> >>>>  	}
> >>>>  
> >>>> -	usb_set_interface(dev->udev, 0, dvb_alt);
> >>>> +	usb_set_interface(dev->udev, dev->ifnum, dvb_alt);
> >>>>  	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
> >>>>  	if (rc < 0)
> >>>>  		return rc;
> >>>> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> >>>> index 5f0b2c5..0dc5b73 100644
> >>>> --- a/drivers/media/usb/em28xx/em28xx.h
> >>>> +++ b/drivers/media/usb/em28xx/em28xx.h
> >>>> @@ -487,8 +487,6 @@ struct em28xx {
> >>>>  
> >>>>  	unsigned char disconnected:1;	/* device has been diconnected */
> >>>>  
> >>>> -	int audio_ifnum;
> >>>> -
> >>>>  	struct v4l2_device v4l2_dev;
> >>>>  	struct v4l2_ctrl_handler ctrl_handler;
> >>>>  	/* provides ac97 mute and volume overrides */
> >>>> @@ -597,6 +595,7 @@ struct em28xx {
> >>>>  
> >>>>  	/* usb transfer */
> >>>>  	struct usb_device *udev;	/* the usb device */
> >>>> +	int ifnum;			/* usb interface number */
> >>>>  	u8 analog_ep_isoc;	/* address of isoc endpoint for analog */
> >>>>  	u8 analog_ep_bulk;	/* address of bulk endpoint for analog */
> >>>>  	u8 dvb_ep_isoc;		/* address of isoc endpoint for DVB */
> 


-- 

Cheers,
Mauro
