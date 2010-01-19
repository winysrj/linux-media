Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:40807 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab0ASCMR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 21:12:17 -0500
Subject: Re: Need testers: cx23885 IR Rx for TeVii S470 and HVR-1250
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org,
	Andreas Tschirpke <andreas.tschirpke@gmail.com>,
	Matthias Fechner <idefix@fechner.net>, stoth@kernellabs.com
In-Reply-To: <201001190025.20539.liplianin@me.by>
References: <1263614561.6084.15.camel@palomino.walls.org>
	 <1263691595.3062.124.camel@palomino.walls.org>
	 <1263793012.5220.103.camel@palomino.walls.org>
	 <201001190025.20539.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 21:10:42 -0500
Message-Id: <1263867042.3710.23.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-01-19 at 00:25 +0200, Igor M. Liplianin wrote:
> On 18 января 2010 07:36:52 Andy Walls wrote:
> > On Sat, 2010-01-16 at 20:26 -0500, Andy Walls wrote:
> > > On Sat, 2010-01-16 at 23:56 +0200, Igor M. Liplianin wrote:
> > > > On 16 января 2010 21:55:52 Andy Walls wrote:
> > > > > I have checked in more changes to
> > > > >
> > > > > 	http://linuxtv.org/hg/~awalls/cx23885-ir2
> > > > >
> > > > > Please test again using these module parameters:
> > > > >
> > > > > 	modprobe cx25840 ir_debug=2 debug=2
> > > > > 	modprobe cx23885 ir_input_debug=2 irq_debug=7 debug=7
> >
> > I have removed the spurious interrupt handling code - it was bogus.  The
> > real problems are:
> >
> > 1. performing AV Core i2c transactions from an IRQ context is bad
> >
> > 2. the cx25840 module needs locking to prevent i2c transaction
> > contention during the AV Core register reads and writes.
> >
> >
> > I have implemented and checked in a change for #1.  Now the AV_CORE
> > interrupt gets disabled and a work handler is scheduled to deal with the
> > IR controller on the AV core.  When the work handler is done, it will
> > re-enable the AV_CORE interrupt.
> >
> > I have not implmented a change for #2 yet.  I have not added locking to
> > protect cx25840_read() and cx25840_write() functions.  This will take
> > time to get right.

I have now fixed the cx25840 module.

I also added a log function for "v4l2-ctl -d /dev/video0 --log-status"
to log the status of the IR controller.


> > You may test these latest changes if you want, but I won't be surprised
> > if things don't work on occasion.
> It is very same behaviour here. A lot of interrupts without purpose.

:(


> > I have tested IR loopback with my HVR-1250 and things are fine for me,
> > but I have no video interrupts coming in either.
> I wonder what is the difference.

a. I set up the IR transmit pin for the HVR-1250 but not the S470 in
cx23885-cards.c:cx23885_ir_init()

b. I set the transmitter invert_level for the Tx pin (a no-op for the
cx23885 IR controller) at the bottom of
cx23885-input.c:cx23885_input_ir_start() for the HVR-1250, but not the
S470.

c. For testing, I add an analog device video node to the HVR1250 for a
debug and test:

diff -r 9128ef95c5a7 -r 1ce2344226c1 linux/drivers/media/video/cx23885/cx23885-cards.c
--- a/linux/drivers/media/video/cx23885/cx23885-cards.c	Sat Jan 09 13:58:18 2010 -0500
+++ b/linux/drivers/media/video/cx23885/cx23885-cards.c	Sat Jan 09 14:31:30 2010 -0500
@@ -104,6 +104,8 @@
 	},
 	[CX23885_BOARD_HAUPPAUGE_HVR1250] = {
 		.name		= "Hauppauge WinTV-HVR1250",
+		.tuner_type	= TUNER_ABSENT,
+		.porta		= CX23885_ANALOG_VIDEO,
 		.portc		= CX23885_MPEG_DVB,
 		.input          = {{
 			.type   = CX23885_VMUX_TELEVISION,



d.  The script of commands I use for testing the HVR-1250 IR Rx with the
IR Tx in hardware loopback is:

#make unload; make unload
#make install

#modprobe cx25840 ir_debug=2 debug=2
#modprobe cx23885 ir_input_debug=2 irq_debug=7 debug=7

#v4l2-ctl -d /dev/video0 --log-status

# Get pin ctrl setting
v4l2-dbg -d /dev/video0 -c 0x44 -g 0x123

# disable tx fifo
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x200 0x4c

# disable tx fifo svc req
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x214 0x20

# disable tx, enable loopback
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x201 0x21

#v4l2-ctl -d /dev/video0 --log-status

# set tx clk div
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x204 1 0

#enable tx fifo
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x200 0xcc

# store test pulse data
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x7f 0x1 0x0
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x5f 0x0 0x0
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x7f 0x1 0x0
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x5f 0x0 0x0
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x7f 0x1 0x0
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x5f 0x0 0x0
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x7f 0x1 0x0
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x23c 0xff 0x5f 0x0 0x0

#v4l2-ctl -d /dev/video0 --log-status

#enable tx
v4l2-dbg -d /dev/video0 -c 0x44 -s 0x201 0x23

#v4l2-ctl -d /dev/video0 --log-status



e. My HVR-1250 doesn't have actual external IR Rx hardware, so I can
only test with loopback.



If my latest changes don't work, I'll probably have to order a CX23885
card with the hardware for actual IR Rx.  Maybe I'll get a TeVii S470
and buy a satellite dish. ;)


Thanks again for all your test efforts.

Regards,
Andy

