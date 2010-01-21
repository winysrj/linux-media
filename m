Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56808 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0AUBMz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jan 2010 20:12:55 -0500
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org,
	Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>, stoth@kernellabs.com
In-Reply-To: <201001201911.33236.liplianin@me.by>
References: <1263614561.6084.15.camel@palomino.walls.org>
	 <201001190025.20539.liplianin@me.by>
	 <1263867042.3710.23.camel@palomino.walls.org>
	 <201001201911.33236.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 20:12:12 -0500
Message-Id: <1264036332.3098.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-01-20 at 19:11 +0200, Igor M. Liplianin wrote:
> On 19 января 2010 04:10:42 Andy Walls wrote:
> > On Tue, 2010-01-19 at 00:25 +0200, Igor M. Liplianin wrote:
> > > On 18 января 2010 07:36:52 Andy Walls wrote:
> > > > On Sat, 2010-01-16 at 20:26 -0500, Andy Walls wrote:
> > > > > On Sat, 2010-01-16 at 23:56 +0200, Igor M. Liplianin wrote:
> > > > > > On 16 января 2010 21:55:52 Andy Walls wrote:
> > > > > > > I have checked in more changes to
> > > > > > >
> > > > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir2
> > > > > > >
> > > > > > > Please test again using these module parameters:
> > > > > > >
> > > > > > > 	modprobe cx25840 ir_debug=2 debug=2
> > > > > > > 	modprobe cx23885 ir_input_debug=2 irq_debug=7 debug=7
> > > >
> > > > I have removed the spurious interrupt handling code - it was bogus. 
> > > > The real problems are:
> > > >
> > > > 1. performing AV Core i2c transactions from an IRQ context is bad
> > > >
> > > > 2. the cx25840 module needs locking to prevent i2c transaction
> > > > contention during the AV Core register reads and writes.
> > > >
> > > >
> > > > I have implemented and checked in a change for #1.  Now the AV_CORE
> > > > interrupt gets disabled and a work handler is scheduled to deal with
> > > > the IR controller on the AV core.  When the work handler is done, it
> > > > will re-enable the AV_CORE interrupt.
> > > >
> > > > I have not implmented a change for #2 yet.  I have not added locking to
> > > > protect cx25840_read() and cx25840_write() functions.  This will take
> > > > time to get right.
> >
> > I have now fixed the cx25840 module.
> >
> > I also added a log function for "v4l2-ctl -d /dev/video0 --log-status"
> > to log the status of the IR controller.
> >
> Now I can not remove modules.
> Unloading cx25840 module raises exception in cx23885_av_workhandler, unloading cx23885 - in 
> i2c_transfer.


:(

OK. I give up for now.

Although, you can't unload the cx25840 module before the cx23885 module.
You have to unload the cx23885 module first, as the
cx23885_av_workhandler() calls cx25840_irq_handler().

If you remove the cx25840 module first, cx25840_irq_handler() is gone
and the cx23885_av_workhandler() will call into garbage memory.

Thanks for your help.

Regards,
Andy

