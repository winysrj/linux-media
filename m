Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:55589 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab1FGNpy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 09:45:54 -0400
Date: Tue, 7 Jun 2011 07:45:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kassey Lee <kassey1216@gmail.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	Kassey Lee <ygli@marvell.com>
Subject: Re: [RFC] Refactor the cafe_ccic driver and add Armada 610 support
Message-ID: <20110607074552.499550e7@bike.lwn.net>
In-Reply-To: <BANLkTim3ZCCti79FKn9-3toc56jZ9=w3-A@mail.gmail.com>
References: <1307400003-94758-1-git-send-email-corbet@lwn.net>
	<BANLkTim3ZCCti79FKn9-3toc56jZ9=w3-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 7 Jun 2011 13:30:11 +0800
Kassey Lee <kassey1216@gmail.com> wrote:

>       1)  this driver is still based on cafe_ccic.c, as you said, we
> can abstract the low level register function, and use soc_camera and
> videofbu2 to manage the buff and state machine,  how do you think ?

As I said, videobuf2 is on my list of things to do.  Note that the driver
works just fine without - that code has been in the kernel and working for
years.  But it's a cleanup that needs to be done at this point, and I will
do it.

>       2) i2c_adapter, how about move this code to driver/i2c, then
> ccic driver will become clean?

The problem there is that you can't easily disentangle the two devices -
they use the same registers, the same IRQ line, etc.  One *could* turn the
whole thing into an MFD driver and split them apart, but I honestly don't
see a reason to do that.  I'd be surprised if a Cafe chip ever shows up in
anything new these days, so it's only used in the OLPC XO 1, and that i2c
will never be used for anything but the sensor.

The i2c *has* been abstracted out of the camera core, so the Cafe i2c
implementation will not get in the way of any new drivers.

>       3) in mmp_driver.c, it has the sensor name, OV7670,  we wish
> that ccic driver do not need to aware of the sensor, also we need to
> support front and back camera sensor cases.

The only reason the ov7670 dependency is there is because that's the only
sensor the driver has ever been used with.  Adding other sensors has been
complicated a bit by Hans's changes which pushed awareness of the
available video formats into the controller driver (I complained at the
time), but that can be worked around.

For front and back: I didn't wire up the second controller in the mmp
driver because I don't have a device that uses both.  I very much wrote
the driver with the idea that both controllers could be used, though;
finishing that job will be easy.

One thing I haven't done is to look at your driver closely enough to think
about whether mmp_camera can drive your hardware or not.  You'll have a
better idea of that than me, I suspect; is the hardware pretty much the
same?

Thanks,

jon
