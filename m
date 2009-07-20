Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39486 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbZGTR7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 13:59:55 -0400
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 591043BCAC2
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 13:59:55 -0400 (EDT)
Received: from localhost.localdomain (ool-457b4d55.dyn.optonline.net [69.123.77.85])
	by mail.messagingengine.com (Postfix) with ESMTPSA id 1EC63A759
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 13:59:55 -0400 (EDT)
Received: from acano by localhost.localdomain with local (Exim 4.69)
	(envelope-from <acano@fastmail.fm>)
	id 1MSx9k-0006Vv-1w
	for linux-media@vger.kernel.org; Mon, 20 Jul 2009 14:00:08 -0400
Date: Mon, 20 Jul 2009 14:00:08 -0400
From: acano@fastmail.fm
To: linux-media@vger.kernel.org
Subject: Re: em28xx i2s volume control
Message-ID: <20090720180008.GA25027@localhost.localdomain>
References: <20090718182251.GA974@localhost.localdomain>
 <20090719105049.0cb1690c@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090719105049.0cb1690c@pedra.chehab.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 19, 2009 at 10:50:49AM -0300, Mauro Carvalho Chehab wrote:
> Em Sat, 18 Jul 2009 14:22:51 -0400
> acano@fastmail.fm escreveu:
>
> > How do you control the i2s volume output on empia boards?
>
> the em28xx chip doesn't control volume. This is done at the audio chip.
>
> For ac97 chips, the volume is inside the em28xx driver, since we don't have a
> v4l2 device driver for it yet.
>
> On the cases where the volume is on an i2s chips like msp34xx, the volume
> control is done at the i2c driver, that should be exporting such controls via
> v4l2 dev/subdev API, by calling:
> 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_ctrl, ctrl);
>
> This way, any application can control the volume via the proper ioctl's.
>
> While trying to see why are you asking this, I noticed that the em28xx driver,
> due to historic reasons, had an implementation that may cause
> confusion.

The problem is that it's not working for usb audio streaming.  With a
cable from line out of the device to my sound card it works well.
Volume can be controlled by applications using the v4l2 ioctls.

The audio from /dev/dsp? is always at max and distorts horribly on
many tv stations.  I can verify with 'modprobe msp3400 debug=1' that
it is trying to set volume I pass to it, but it simply has no effect
on the usb audio stream.

The reason I asked about i2s volume control is because the eeprom has
the bit set that shows my device as "USB audio class volume control
(capable) when audio source is i2s device".

Maybe it's a snd-usb-audio issue since the mixer setting for the
device doesn't allow volume changing.

>
> I just add there two patches that will make it clearer.
>
> There aren't any functional changes with those patches (I tested here on
> devices with msp34xx and with ac202 ac97), except for the fact that now the
> qv4l2 will show the volume as a slider.


