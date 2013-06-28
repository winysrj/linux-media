Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961Ab3F1PdX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 11:33:23 -0400
Date: Fri, 28 Jun 2013 12:32:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media" <linux-media@vger.kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] usbtv: fix dependency
Message-ID: <20130628123251.1ec5f821.mchehab@redhat.com>
In-Reply-To: <201306281615.29926.hverkuil@xs4all.nl>
References: <201306281024.15428.hverkuil@xs4all.nl>
	<Pine.LNX.4.64.1306281521460.29767@axis700.grange>
	<20130628105515.0f2a3571.mchehab@redhat.com>
	<201306281615.29926.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Jun 2013 16:15:29 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> > > > I prefer to keep this part of videodev, at least for now: I think there will
> > > > be a fairly quick uptake of this API internally, certainly for subdevs. Note
> > > > BTW that even x86 kernels come with CONFIG_OF enabled these days.
> > 
> > Fedora 18 (and even Fedora 19 beta) Kernels don't enable it for x86. It
> > is enabled there only for arm:
> > 	config-armv7-generic:CONFIG_OF=y
> > 	config-armv7-generic:CONFIG_OF_DEVICE=y
> > 
> > I don't doubt that this would be enabled on x86 there some day, but
> > this is not the current status, and I fail to see why one would enable
> > it on x86, except if some specific distro have some specific issues
> > at their boot loaders that would be easier to solve if OF is enabled
> > on all of their kernels.
> 
> Debian sid turns it on,

Weird. 

> I think it is for some intel-based embedded systems.

Ok, then, it could make sense, if they want to use the same Kernel for both
embedded and non-embedded systems.

> > From my side, I don't see much sense of overbloating the videodev core
> > with platform-specific code.
> 
> About half of this source is necessary anyway for subdevs that need to
> be async-aware. Note that v4l2-async is by itself unrelated to CONFIG_OF.
> It can be used by any driver that wants to asynchronously load i2c drivers.

Making a V4L2 driver to initialize synchronously is already too complex,
and it takes some time until the code there becomes stable. I don't think
a typical driver should be using the async API, as this will just add
unneeded complexity to an already-complex-enough task.

So, yes, in thesis, this API could be used by non-OF driver, but
in practice, what's the gain of doing it? 

Very few hardware have more than one I2C buses, so, the access to the 
subdevs will be serialized anyway.

For a serialized I2C bus, the async API doesn't bring any benefit, and
may actually hurt the drivers, as the driver/hardware may have hard-to-track
bugs if initialized on certain specific infrequent init sequence.

The tm6000 chips, for example, have this issue: there are some parts 
there that, if you change the order where the registers are written, the
hardware crashes - it is believed to be a bug at its internal 8051
firmware.

Even the few hardware that have more than one I2C buses, where a parallel
init could make the hardware to initialize faster, it may have troubles
with parallel initialization, due to I2C gateways, I2C clock registers,
firmwares, etc. Allowing async init there could be a real nightmare,
any may require it to be serialized, anyway.

So, I see no benefit on having this code to be mandatory for a non-OF
hardware. In contrary, it would just increase the code size and make
debugging harder for nothing.

Cheers,
Mauro
