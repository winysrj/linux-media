Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:27510 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaAENWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 08:22:42 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYX003ZRJTUM040@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sun, 05 Jan 2014 08:22:42 -0500 (EST)
Date: Sun, 05 Jan 2014 11:22:38 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 11/22] [media] em28xx: check if a device has audio
 earlier
Message-id: <20140105112238.3dacd54a@samsung.com>
In-reply-to: <52C93E22.2040806@googlemail.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
 <1388832951-11195-12-git-send-email-m.chehab@samsung.com>
 <52C93E22.2040806@googlemail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 12:12:34 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > Better to split chipset detection from the audio setup. So, move the
> > detection code to em28xx_init_dev().
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/em28xx/em28xx-cards.c | 11 +++++++++++
> >  drivers/media/usb/em28xx/em28xx-core.c  | 12 +-----------
> >  2 files changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
> > index d1c75e66554c..4fe742429f2c 100644
> > --- a/drivers/media/usb/em28xx/em28xx-cards.c
> > +++ b/drivers/media/usb/em28xx/em28xx-cards.c
> > @@ -2930,6 +2930,16 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
> >  		}
> >  	}
> >  
> > +	if (dev->chip_id == CHIP_ID_EM2870 ||
> > +	    dev->chip_id == CHIP_ID_EM2874 ||
> > +	    dev->chip_id == CHIP_ID_EM28174 ||
> > +	    dev->chip_id == CHIP_ID_EM28178) {
> > +		/* Digital only device - don't load any alsa module */
> > +		dev->audio_mode.has_audio = false;
> > +		dev->has_audio_class = false;
> > +		dev->has_alsa_audio = false;
> > +	}
> > +
> >  	if (chip_name != default_chip_name)
> >  		printk(KERN_INFO DRIVER_NAME
> >  		       ": chip ID is %s\n", chip_name);
> > @@ -3196,6 +3206,7 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >  	dev->alt   = -1;
> >  	dev->is_audio_only = has_audio && !(has_video || has_dvb);
> >  	dev->has_alsa_audio = has_audio;
> > +	dev->audio_mode.has_audio = has_audio;
> >  	dev->has_video = has_video;
> >  	dev->audio_ifnum = ifnum;
> >  
> > diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> > index 33cf26e106b5..818248d3fd28 100644
> > --- a/drivers/media/usb/em28xx/em28xx-core.c
> > +++ b/drivers/media/usb/em28xx/em28xx-core.c
> > @@ -505,18 +505,8 @@ int em28xx_audio_setup(struct em28xx *dev)
> >  	int vid1, vid2, feat, cfg;
> >  	u32 vid;
> >  
> > -	if (dev->chip_id == CHIP_ID_EM2870 ||
> > -	    dev->chip_id == CHIP_ID_EM2874 ||
> > -	    dev->chip_id == CHIP_ID_EM28174 ||
> > -	    dev->chip_id == CHIP_ID_EM28178) {
> > -		/* Digital only device - don't load any alsa module */
> > -		dev->audio_mode.has_audio = false;
> > -		dev->has_audio_class = false;
> > -		dev->has_alsa_audio = false;
> > +	if (!dev->audio_mode.has_audio)
> >  		return 0;
> > -	}
> > -
> > -	dev->audio_mode.has_audio = true;
> >  
> >  	/* See how this device is configured */
> >  	cfg = em28xx_read_reg(dev, EM28XX_R00_CHIPCFG);
> It's not clear to me how one of these audio variables could ever become
> true with these chip types, so this code should probably just be removed.

Maybe. This is part of a quick hack that added support for em2874.
Assuming that the em28xx USB descriptors are ok, the code is not needed.

However, as I'm not 100% sure about that (maybe ancient chips might have
some bugs), I opted to just move the code to be together with the other
detection code, instead of removing and risking a regression.

-- 

Cheers,
Mauro
