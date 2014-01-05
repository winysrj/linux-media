Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:47113 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaAEPbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 10:31:17 -0500
Date: Sun, 5 Jan 2014 13:31:10 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v4 07/22] [media] em28xx: improve extension information
 messages
Message-ID: <20140105133110.4b9464db@infradead.org>
In-Reply-To: <20140105110822.73fdbcb4@samsung.com>
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com>
	<1388832951-11195-8-git-send-email-m.chehab@samsung.com>
	<52C93A26.1070607@googlemail.com>
	<20140105110822.73fdbcb4@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 05 Jan 2014 11:08:22 -0200
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Sun, 05 Jan 2014 11:55:34 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> 
> > Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> > > Add a message with consistent prints before and after each
> > > extension initialization, and provide a better text for module
> > > load.
> > >
> > > While here, add a missing sanity check for extension finish
> > > code at em28xx-v4l extension.
> > >
> > > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > > ---
> > >  drivers/media/usb/em28xx/em28xx-audio.c |  4 +++-
> > >  drivers/media/usb/em28xx/em28xx-core.c  |  2 +-
> > >  drivers/media/usb/em28xx/em28xx-dvb.c   |  7 ++++---
> > >  drivers/media/usb/em28xx/em28xx-input.c |  4 ++++
> > >  drivers/media/usb/em28xx/em28xx-video.c | 10 ++++++++--
> > >  5 files changed, 20 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
> > > index 2fdb66ee44ab..263886adcf26 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-audio.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-audio.c
> > > @@ -649,7 +649,8 @@ static int em28xx_audio_init(struct em28xx *dev)
> > >  		return 0;
> > >  	}
> > >  
> > > -	printk(KERN_INFO "em28xx-audio.c: probing for em28xx Audio Vendor Class\n");
> > > +	em28xx_info("Binding audio extension\n");
> > > +
> > >  	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2006 Markus "
> > >  			 "Rechberger\n");
> > >  	printk(KERN_INFO "em28xx-audio.c: Copyright (C) 2007-2011 Mauro Carvalho Chehab\n");
> > > @@ -702,6 +703,7 @@ static int em28xx_audio_init(struct em28xx *dev)
> > >  	adev->sndcard = card;
> > >  	adev->udev = dev->udev;
> > >  
> > > +	em28xx_info("Audio extension successfully initialized\n");
> > >  	return 0;
> > >  }
> > >  
> > > diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> > > index 1113d4e107d8..33cf26e106b5 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-core.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-core.c
> > > @@ -1069,7 +1069,7 @@ int em28xx_register_extension(struct em28xx_ops *ops)
> > >  		ops->init(dev);
> > >  	}
> > >  	mutex_unlock(&em28xx_devlist_mutex);
> > > -	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
> > > +	printk(KERN_INFO "em28xx: Registered (%s) extension\n", ops->name);
> > >  	return 0;
> > >  }
> > >  EXPORT_SYMBOL(em28xx_register_extension);
> > > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
> > > index ddc0e609065d..f72663a9b5c5 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> > > @@ -274,7 +274,7 @@ static int em28xx_stop_feed(struct dvb_demux_feed *feed)
> > >  static int em28xx_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
> > >  {
> > >  	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
> > > -        struct em28xx *dev = i2c_bus->dev;
> > > +	struct em28xx *dev = i2c_bus->dev;
> > >  
> > >  	if (acquire)
> > >  		return em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
> > > @@ -992,10 +992,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
> > >  
> > >  	if (!dev->board.has_dvb) {
> > >  		/* This device does not support the extension */
> > > -		printk(KERN_INFO "em28xx_dvb: This device does not support the extension\n");
> > >  		return 0;
> > >  	}
> > >  
> > > +	em28xx_info("Binding DVB extension\n");
> > > +
> > >  	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
> > >  
> > >  	if (dvb == NULL) {
> > > @@ -1407,7 +1408,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
> > >  	/* MFE lock */
> > >  	dvb->adapter.mfe_shared = mfe_shared;
> > >  
> > > -	em28xx_info("Successfully loaded em28xx-dvb\n");
> > > +	em28xx_info("DVB extension successfully initialized\n");
> > >  ret:
> > >  	em28xx_set_mode(dev, EM28XX_SUSPEND);
> > >  	mutex_unlock(&dev->lock);
> > > diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
> > > index 93a7d02b9cb4..eed7dd79f734 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-input.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-input.c
> > > @@ -692,6 +692,8 @@ static int em28xx_ir_init(struct em28xx *dev)
> > >  		return 0;
> > >  	}
> > >  
> > > +	em28xx_info("Registering input extension\n");
> > > +
> > >  	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
> > >  	rc = rc_allocate_device();
> > >  	if (!ir || !rc)
> > > @@ -785,6 +787,8 @@ static int em28xx_ir_init(struct em28xx *dev)
> > >  	if (err)
> > >  		goto error;
> > >  
> > > +	em28xx_info("Input extension successfully initalized\n");
> > > +
> > >  	return 0;
> > >  
> > >  error:
> > > diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
> > > index 56d1b46164a0..b767262c642b 100644
> > > --- a/drivers/media/usb/em28xx/em28xx-video.c
> > > +++ b/drivers/media/usb/em28xx/em28xx-video.c
> > > @@ -1884,6 +1884,11 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
> > >  
> > >  	/*FIXME: I2C IR should be disconnected */
> > >  
> > > +	if (!dev->has_video) {
> > > +		/* This device does not support the v4l2 extension */
> > > +		return 0;
> > > +	}
> > > +
> > That's a separate change and AFAICS it's not needed.
> 
> It is needed. If you plug a device with video first and then a DVB-only device,
> as em28xx-v4l will be loaded, it will initialize the extension, if this code got
> removed.
> 
> I can move it to a separate patch adding the proper description.

Better to add it together with patch 4/22:
	http://git.linuxtv.org/mchehab/experimental.git/commitdiff/de93f52d20ba317d8a41614fbf439e956ec2c7d6

Regards,
Mauro
