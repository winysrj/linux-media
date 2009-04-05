Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:53306 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755130AbZDEMoZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 08:44:25 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
 model
From: Andy Walls <awalls@radix.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>
In-Reply-To: <20090405061432.4165eabf@pedra.chehab.org>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl>
	 <20090405061432.4165eabf@pedra.chehab.org>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 08:44:15 -0400
Message-Id: <1238935455.3151.64.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-04-05 at 06:14 -0300, Mauro Carvalho Chehab wrote:

> 
> IMO, doing all those tricks to support an out-of-tree driver is the wrong
> approach. This is just postponing a more serious discussion about what should
> be done in kernel, in order to better support IR's.

The "tricks" were to not break the current user experience by saddling
them with a kernel module that they may not want.  (If the tricks are
needed at all - I'm will test later today.)

I agree that better in kernel infrastructure needs to be in place for
IR.

LIRC's kernel space infrastructure module, lirc_dev, probably isn't a
bad model for support of IR devices.  The individual LIRC modules for
supporting specific sets of devices are the ones that have problems to
varying degrees.


> In the case of lirc, the userspace part has already an event interface. If the
> drivers are doing the right thing with their IR part, lirc can just use the
> event interface for all drivers. This seems to be the proper approach.

Input event interfaces alone neglect IR blasters.


> >From what I got from Andy and Mike's comments is that the real issue is that
> the IR kernel code is incomplete, broken or bad designed. So, several users and
> userspace apps don't rely on the kernel code but, instead, use lirc as an
> alternative.

There is at least one other motivation:

LIRC also handles a number of other hardware interfaces that are not
I2C: serial ports (/dev/ttySX), parallel port, USB, etc.


I happen to use the lirc_mceusb2 module for my Phillips Home IR
receiver/blaster (I'm not sure if the blaster works under linux.)


> That's said, I propose a different approach:
> 
> 1) Add some entry at feature-removal-schedule.txt posting a date to end support
>    for out-of-tree I2C IR modules;
> 
> 2) Start discussing with lirc people (and input/event maintainers if needed)
> about what is needed to properly support the required functionalities for a
> better lirc usage;
> 
> 3) Propose a few API additions in order to support those functionalities;

> 4) apply IR patches on kernel to support the missing functionalities;

The scope of a complete kernel IR infrastructure goes a bit beyond I2C
bus devices that are only input devices.

What's the scope of what you want to tackle here?

I certainly don't want to reinvent something that's going to look just
like the LIRC driver model:

http://www.lirc.org/html/technical.html

Which already has an infrastructure for IR driver module writers:
http://www.lirc.org/html/technical.html#lirc_dev


Do we just convert lirc_dev, lirc_i2c, and lirc_zilog to a cleaned up
set of in kernel modules?  lirc_i2c can certainly be broken up into
several modules: 1 per supported device.  Should these create an input
device as well to maintain compatability with apps expecting an
ir-kbd-i2c like function?

Or do we split up ir-kbd-i2c into per device modules and in addition to
the input event interface, have it register with the lirc_dev module?

Do we leverage LIRC's lirc_dev infrastructure module at all? (I think it
would be a waste of time not to do so.) 

Regards,
Andy

> 5) remove the support for out-of-tree i2c IR modules.


> 
> Cheers,
> Mauro
> 

