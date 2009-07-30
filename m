Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:35037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZG3FCR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2009 01:02:17 -0400
Date: Thu, 30 Jul 2009 02:02:03 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: acano@fastmail.fm, linux-media@vger.kernel.org
Subject: Re: em28xx i2s volume control
Message-ID: <20090730020203.0245c328@pedra.chehab.org>
In-Reply-To: <20090727213648.1e331d9a@pedra.chehab.org>
References: <20090718182251.GA974@localhost.localdomain>
	<20090719105049.0cb1690c@pedra.chehab.org>
	<20090720180008.GA25027@localhost.localdomain>
	<20090727213648.1e331d9a@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 27 Jul 2009 21:36:48 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Mon, 20 Jul 2009 14:00:08 -0400
> acano@fastmail.fm escreveu:
> 
> > On Sun, Jul 19, 2009 at 10:50:49AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Sat, 18 Jul 2009 14:22:51 -0400
> > > acano@fastmail.fm escreveu:
> > >
> > > > How do you control the i2s volume output on empia boards?
> > >
> > > the em28xx chip doesn't control volume. This is done at the audio chip.
> > >
> > > For ac97 chips, the volume is inside the em28xx driver, since we don't have a
> > > v4l2 device driver for it yet.
> > >
> > > On the cases where the volume is on an i2s chips like msp34xx, the volume
> > > control is done at the i2c driver, that should be exporting such controls via
> > > v4l2 dev/subdev API, by calling:
> > > 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
> > >
> > > This way, any application can control the volume via the proper ioctl's.
> > >
> > > While trying to see why are you asking this, I noticed that the em28xx driver,
> > > due to historic reasons, had an implementation that may cause
> > > confusion.
> > 
> > The problem is that it's not working for usb audio streaming.  With a
> > cable from line out of the device to my sound card it works well.
> > Volume can be controlled by applications using the v4l2 ioctls.
> > 
> > The audio from /dev/dsp? is always at max and distorts horribly on
> > many tv stations.  I can verify with 'modprobe msp3400 debug=1' that
> > it is trying to set volume I pass to it, but it simply has no effect
> > on the usb audio stream.
> > 
> > The reason I asked about i2s volume control is because the eeprom has
> > the bit set that shows my device as "USB audio class volume control
> > (capable) when audio source is i2s device".

Angelo,

I just checked the datasheet, at page 8 [1]: there's nothing we can do at msp34xx to control
volume at i2s interface.

Looking at the signal flow block diagram of MSP34x5G, it is clear that you have 3 different output patches:

1) loudspeaker: offers bass/treble, loudness, spatial effects, balance and volume controls;

2) SCART1 output: offers only volume control;

3) I2S: no control at all. 

So, with msp34xx, there's no way to change the i2s output volume.

[1] http://www.datasheetcatalog.org/datasheet/MicronasIntermetall/mXsrwrs.pdf



Cheers,
Mauro
