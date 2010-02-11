Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:59730 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0BKDcd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2010 22:32:33 -0500
Subject: Re: Leadtek WinFast DVR3100 H zl10353_read_register: readreg error
 (reg=127, ret==-6)
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Patrick Cairns <patrick_cairns@yahoo.com>,
	linux-media@vger.kernel.org
In-Reply-To: <1265833750.4019.96.camel@palomino.walls.org>
References: <47786.707.qm@web33501.mail.mud.yahoo.com>
	 <829197381002090725m2ec3c6c3r346c32f965a5a198@mail.gmail.com>
	 <1265833750.4019.96.camel@palomino.walls.org>
Content-Type: text/plain
Date: Wed, 10 Feb 2010 22:31:26 -0500
Message-Id: <1265859086.8809.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-02-10 at 15:29 -0500, Andy Walls wrote:
> On Tue, 2010-02-09 at 10:25 -0500, Devin Heitmueller wrote:

> > 
> > Are we sure the zl10353 is being reset at all?
> 
> Devin,
> 
> I know for a fact it is not.
> 
> 
> >   I've seen cases before
> > where the zl10353 can hang the entire i2c bus ( in particular with the
> > i2c_gate_ctrl issue), and the only path to recovery is strobing the
> > chip reset.  It's possible that the GPIO for resetting the zl10353 is
> > just *wrong* because somebody copied it from some other board profile,
> > and the chip is never being reset.
> 
> I have no information of the GPIO line that would be used to reset the
> ZL10353.  We can narrow the field with some differential analysis.
> 
> Patrick,
> 
> For every LeadTek 3100 H you have, could you, as root, run
> 
> # v4l2-dbg -d /dev/videoN -c host0 -g 0x2c72010
> ioctl: VIDIOC_DBG_G_REGISTER
> Register 0x02c72010 = 96ff13h (9895699d  00000000 10010110 11111111 00010011b)
> 
> And record the register value and whether or not the card initialized
> DVB properly or had the error.

Patrick,

Bah, what was I thinking?  You can only record the GPIO levels of cards
that initialize properly with that command.  Of all the working cards,
all the GPIO "1" bits that line up between all the cards are the likely
candidates for the ZL10353 reset line.

Regards,
Andy

> It would be better to log out the contents of this register immediately
> after the zl10353_attach fails in cx18-dvb.c, but we'll hopefully get
> close enough without doing that.
> 
> Regards,
> Andy
> 


