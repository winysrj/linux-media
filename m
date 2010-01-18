Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53206 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0ARWZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 17:25:39 -0500
Received: by bwz19 with SMTP id 19so2190177bwz.28
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 14:25:37 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
Date: Tue, 19 Jan 2010 00:25:20 +0200
Cc: linux-media@vger.kernel.org,
	Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>, stoth@kernellabs.com
References: <1263614561.6084.15.camel@palomino.walls.org> <1263691595.3062.124.camel@palomino.walls.org> <1263793012.5220.103.camel@palomino.walls.org>
In-Reply-To: <1263793012.5220.103.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201001190025.20539.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 января 2010 07:36:52 Andy Walls wrote:
> On Sat, 2010-01-16 at 20:26 -0500, Andy Walls wrote:
> > On Sat, 2010-01-16 at 23:56 +0200, Igor M. Liplianin wrote:
> > > On 16 января 2010 21:55:52 Andy Walls wrote:
> > > > I have checked in more changes to
> > > >
> > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir2
> > > >
> > > > Please test again using these module parameters:
> > > >
> > > > 	modprobe cx25840 ir_debug=2 debug=2
> > > > 	modprobe cx23885 ir_input_debug=2 irq_debug=7 debug=7
>
> I have removed the spurious interrupt handling code - it was bogus.  The
> real problems are:
>
> 1. performing AV Core i2c transactions from an IRQ context is bad
>
> 2. the cx25840 module needs locking to prevent i2c transaction
> contention during the AV Core register reads and writes.
>
>
> I have implemented and checked in a change for #1.  Now the AV_CORE
> interrupt gets disabled and a work handler is scheduled to deal with the
> IR controller on the AV core.  When the work handler is done, it will
> re-enable the AV_CORE interrupt.
>
> I have not implmented a change for #2 yet.  I have not added locking to
> protect cx25840_read() and cx25840_write() functions.  This will take
> time to get right.
>
>
> You may test these latest changes if you want, but I won't be surprised
> if things don't work on occasion.
It is very same behaviour here. A lot of interrupts without purpose.

>
> I have tested IR loopback with my HVR-1250 and things are fine for me,
> but I have no video interrupts coming in either.
I wonder what is the difference.

>
> Regards,
> Andy
>
> > OK.  I think I finally have guessed what is going on:
> >
> > 1. The cx23885_irq_handler is called for the AV_CORE when something else
> > in the cx23885 or cx25840 module is accessing that I2C bus.
> >
> > 2. The I2C bus adapter mutex in the i2c_subsystem stays locked so the
> > cx23885_irq_handler() and cx25840_irq_handler() cannot read the AV core
> > registers since the I2C subsystem returns -EINVAL and 0 for the data.
> >
> > 3. The interrupt handler keeps getting called because it never clears
> > the interrupt condition in the AV Core.
> >
> > I think I have to do some work in the cx25840 module and the cx23885
> > module to handle locking of the AV Core I2C client and I2C bus 3.

BR

Igor
