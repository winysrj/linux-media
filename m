Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:45179 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbZK3AGS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Nov 2009 19:06:18 -0500
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: jonsmirl@gmail.com, alan@lxorguk.ukuu.org.uk,
	dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	jarod@wilsonet.com, khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	maximlevitsky@gmail.com, mchehab@redhat.com, ray-lk@madrabbit.org,
	stefanr@s5r6.in-berlin.de, superm1@ubuntu.com
In-Reply-To: <BDodzfumqgB@lirc>
References: <BDodzfumqgB@lirc>
Content-Type: text/plain
Date: Sun, 29 Nov 2009 19:05:30 -0500
Message-Id: <1259539530.5231.36.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-11-29 at 20:49 +0100, Christoph Bartelmus wrote:
> Hi,
> 
> on 29 Nov 09 at 14:16, Jon Smirl wrote:
> > On Sun, Nov 29, 2009 at 2:04 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >>> Jon is asking for an architecture discussion, y'know, with use cases.
> [...]
> > So we're just back to the status quo of last year which is to do
> > nothing except some minor clean up.
> >
> > We'll be back here again next year repeating this until IR gets
> > redesigned into something fairly invisible like keyboard and mouse
> > drivers.
> 
> Last year everyone complained that LIRC does not support evdev - so I  
> added support for evdev.
> 
> This year everyone complains that LIRC is not plug'n'play - we'll fix that  
> 'til next year.

V4L-DVB is also making progress on the enumeration front.  At least for
V4L devices a new media controller device node will be able to enumerate
all devices associated with a video card (or embedded system or SoC).
>From one device node, an app should be able to discover all video, alsa,
dvb, and framebuffer device nodes on a video card, find out about
entities on the card, and set up the reconfigurable connections between
entities on the card.  One should be able to discover subdevices on
cards like IR controllers.

The RFC before the mini-summit at the 2009 LPC is here:
http://lwn.net/Articles/352623/


The V4L media controller entity discover mechanism won't completely
solve the general discovery problem for IR.   It will be one way to
discover IR devices associated with V4L supported peripherals.  I assume
discovering USB IR-only devices by USB Id is not a problem.  That leaves
serial port, parallel port and sound jack connected devices as the
difficult ones to "discover". 

Regards,
Andy

> Christoph
> --


