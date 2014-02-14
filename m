Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57329 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaBNAET (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 19:04:19 -0500
Date: Fri, 14 Feb 2014 01:04:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: Video capture in FPGA -- simple hardware to emulate?
Message-ID: <20140214000418.GA29848@xo-6d-61-c0.localdomain>
References: <20140213195224.GA10691@amd.pavel.ucw.cz>
 <CALzAhNVC1KRuhMks_2YUSF1e8iVEfsyvKZmphyXMqpJ+0d228Q@mail.gmail.com>
 <Pine.LNX.4.64.1402132223480.24792@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1402132223480.24792@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> > > I'm working on project that will need doing video capture from
> > > FPGA. That means I can define interface between kernel and hardware.
> > >
> > > Is there suitable, simple hardware we should emulate in the FPGA? I
> > > took a look, and pxa_camera seems to be one of the simple ones...
> 
> Too bad this one
> 
> http://opencores.org/project,100

Too bad indeed, that would certainly help.

> is only in planning... Maybe you could collaborate with them?

I will not be the one doing hardware, and that might be too much to ask...

> > Thats actually a pretty open-ended question. You might get better
> > advice if you describe your hardware platform in a little more detail.
> 
> +1. As usually you have to begin with what you need. Will it be using an 
> external DMA engine or will it have one built into it? If you've got a 
> DMAC core already, it will define your V4L2 dma operations choice - 
> contiguous or SG, unless, as Steven mentioned, you go over USB. Then you 
> decide what sensor interface you need - parallel or CSI, etc.

I don't know about the sensor interface -- it will likely change in future.

There is no PCI or USB involved.

The simplest device I could imagine would be just fixed location in memory,
where FPGA puts the RGB values (or YUV or something). Now... that would have
issues with teared frames. But perhaps if FPGA cycled between 5 such buffers,
and notified CPU using interrupts when buffer is filled, that would work 
"well enough"? (There would be teared frames where other designs drop frames,
but that could be acceptable.)

OTOH nobody is doing that, so it is probably bad idea for some reason...?

> > Are you using a USB or PCIe controller to talk to the fpga, or does
> > the fpga contain embedded IP cores for USB or PCIe?

There should be no USB/PCIe involved.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
