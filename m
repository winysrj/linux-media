Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:52648 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbZDESPV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 14:15:21 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>, Janne Grunau <j@jannau.net>
In-Reply-To: <20090405150807.594d1378@hyperion.delvare>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090404142837.3e12824c@hyperion.delvare>
	 <1238852529.2845.34.camel@morgan.walls.org>
	 <20090405005139.03ba18b5@hyperion.delvare>
	 <1238896208.2995.86.camel@morgan.walls.org>
	 <20090405150807.594d1378@hyperion.delvare>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 14:13:10 -0400
Message-Id: <1238955190.3337.35.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-04-05 at 15:08 +0200, Jean Delvare wrote:
> Hi Andy,
> 

> > > If IR on the cx18 is not supported (by the ir-kbd-i2c driver) then I
> > > can simplify my patch set and omit the cx18 entirely.
> 
> Which I just did...
> 
> > The HVR-1600 could have been supported by ir-kbd-i2c.
> > 
> > It's submission was redirected slightly here:
> > 
> > http://lkml.org/lkml/2009/2/3/118
> > 
> > And deferred here:
> > 
> > http://www.spinics.net/lists/linux-media/msg03883.html
> > 
> > until your changes were done.
> 
> OK. Then let's indeed get my changes merged first, and then we can see
> the best way to add support for the HVR-1600 IR.

OK.  I'll test your change anyway if I can.



> > lirc_pvr150 has always been out of kernel and likely always will be.
> 
> Any valid reason? Out-of-free drivers are a pain for users :(

Well, like many of the lirc modules, it's a little kludged.  The main
problem is this:

1. lirc_pvr150, in the past, needed to make a direct call into the ivtv
module to reset the IR chip, if it detected that the chip was hung up.
That's why it tries to load the ivtv module, to make sure that symbol is
in the kernel.  This could cause problems, if it was a Z8 chip that was
supported by some other bridge driver.  I wrote a patch for lirc_pvr150
for cx18 devices for users who needed it. 

lirc_zilog is the cut down version of lirc_pvr150 module that was
submitted in the patchset to the LKML, and no longer has the reset
logic.  The reset logic is not needed anymore as far as I can tell, and
thus the cx18 specific patch is probably irrelevant for lirc_zilog.


Other weird things include:

2. In lirc_pvr150 and lirc_zilog, both the IR Rx and IR Tx support are
in one module, which is a break from the normal LIRC driver modules that
keep those functions separate.  This was done for the sake of detecting
if the chip had hung up and to call the reset logic, AFAICT.

3. lirc_pvr150 and lirc_zilog have an IR blaster "firmware" image that
is really an encoding of a bunch of captured sequences between the
Windows driver and the Z8F0811 chip.  It allows the lirc_zilog or
lirc_pvr150 driver to do IR blasting by essentially performing a replay
attack on the Z8F0811.

Since the Zilog EULA that comes with the Hauppauge Windows IR driver for
the Z8F0811 is pretty draconian, replaying captured snoops is probably
the best that can be done legally to stimulate the microcontroller IR Tx
code in the Z8 as delivered.


Regards,
Andy

