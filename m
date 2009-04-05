Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:57262 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680AbZDETA7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 15:00:59 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Janne Grunau <j@jannau.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jarod Wilson <jarod@redhat.com>
In-Reply-To: <20090405183154.GE10556@aniel>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <200904050746.47451.hverkuil@xs4all.nl> <20090405143748.GC10556@aniel>
	 <1238953174.3337.12.camel@morgan.walls.org>  <20090405183154.GE10556@aniel>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 14:58:17 -0400
Message-Id: <1238957897.3337.50.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-04-05 at 20:31 +0200, Janne Grunau wrote:
> On Sun, Apr 05, 2009 at 01:39:33PM -0400, Andy Walls wrote:

> > If one focuses on satisfying the LKML comments to lirc_dev and the
> > Makefile to get that kernel module in the kernel, then, at least for
> > video card hosted IR devices, there is an infrastructure to which to
> > hook new or rewritten i2c IR driver modules.
> 
> I guess lkml would NAK patches adding infrastructure only bits but we
> will probably for the next patchset concentrate on a few lirc drivers.
> Christopher doesn't participate in the merge attempt.

Oh, OK.

> > >  A git tree is available at
> > > 
> > > git://git.wilsonet.com/linux-2.6-lirc.git
> > > 
> > > Jared Wilson and I were working on it (mainly last september). Since the
> > > IR on the HD PVR is also driven by the same zilog chip as on other
> > > hauppauge devices I'll take of lirc_zilog. Help converting the i2c
> > > drivers to the new i2c model is welcome. General cleanup of lirc to make
> > > it ready for mainline is of course wellcome too.
> > 
> > I can help with this.  I'm mainly concerned with lirc_dev, lirc_i2c (for
> > Rx only use of the zilog at 0x71), lirc_zilog, and lirc_mceusb2.  That's
> > because, of course, I have devices that use those modules. :)
> 
> I have devices for lirc_zilog (which should probably be merged with
> lirc_i2c) 

Hmmm. Following Jean's reasoning, that may be the wrong way to go, if
you want to avoid probing.  A module to handle each specific type of I2C
IR chip, splitting up lirc_i2c and leaving lirc_zilog as is, may be
better in the long run.

I'd personally leave lirc_zilog separate since it handles Tx and RX for
one specific chip, and lirc_i2c is Rx only for a number of chips.
Perhaps dropping Rx support for the Zilog Z8 in lirc_i2c and then
modifying lirc_zilog to still do Rx, even if the "firmware" wasn't
available for Tx, is a better way to go.




> and lirc serial. Jarod has at least mce usb and imon devices.
> That are probably the devices we'll concentrate on the next submission.

OK.

> > lirc_dev and the API header would be my first priority, if you need
> > help.  Did anyone consolidate all the comments from the LKML on Jarrod's
> > patch submission?
> 
> no and I lost track which comments were already handled.

Hmm.  Well good luck.

Let me know if I can help.  I have 2 cards with the Zilog and a USB unit
that is supported by lirc_mceusb2.

Regards,
Andy

> Janne


