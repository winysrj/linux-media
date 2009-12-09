Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:48993 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbZLILtf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2009 06:49:35 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	stoth@kernellabs.com
In-Reply-To: <200912081959.21245.liplianin@me.by>
References: <4B0459B1.50600@fechner.net>
	 <200912070323.14440.liplianin@me.by> <1260156946.1809.25.camel@localhost>
	 <200912081959.21245.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Dec 2009 06:47:46 -0500
Message-Id: <1260359266.3093.15.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-12-08 at 19:59 +0200, Igor M. Liplianin wrote:
> On 7 декабря 2009 05:35:46 Andy Walls wrote:

> > Igor and Matthias,
> >
> > Please try the changes that I have for the TeVii S470 that are here:
> >
> > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> >
> > You will want to modprobe the driver modules like this to get debugging
> > information:
> >
> > 	# modprobe cx25840 ir_debug=2
> > 	# modprobe cx23885 ir_input_debug=1
> >
> > With that debugging you will get output something like this in dmesg or
> > your logs when you press a button on the remote (this is RC-5 using a
> > CX23888 chip not NEC using a CX23885 chip):
> >
> > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > cx23885[0]/888-ir: IRQ Status:  tsr     rto
> > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > cx23885[0]/888-ir: rx read:     817000 ns  mark
> > cx23885[0]/888-ir: rx read:     838926 ns  space
> > cx23885[0]/888-ir: rx read:    1572259 ns  mark
> > cx23885[0]/888-ir: rx read:    1705296 ns  space
> > [...]
> > cx23885[0]/888-ir: rx read:     838037 ns  space
> > cx23885[0]/888-ir: rx read:     746333 ns  mark
> > cx23885[0]/888-ir: rx read:    1705741 ns  space
> > cx23885[0]/888-ir: rx read:    1619370 ns  mark
> > cx23885[0]/888-ir: rx read: end of rx

> > If you do not see good or many NEC timing measurments in the logs, the
> > first thing to try is to change lines 533-534 of
> > linux/drivers/media/cx23885/cx23885-input.c:
> >
> >                params.modulation = true;
> >                params.invert_level = false;
> >
> > If you see no timing measurements or few timing measurements, change the
> > "modulation" to "false".  If the chip is expecting carrier pulses and an
> > external circuit or capacitor is smoothing carrier bursts into baseband
> > pulses, then the hardware won't make measurements properly.
> >
> > If you see inverted mark and space inverted when "modulation" is set to
> > "false", then set "invert_level" to "true".
> >
> > Those are the two things I had to really guess at.

> > Regards,
> > Andy
> 
> No luck :(
> Nothing in logs

:(

OK.

1. I assume you have the v4l-cx23885-avcore-01.fw file available for the
cx25840 module, just so there is no problem initializing the CX23885 AV
core.


2. Does dmesg or the logs show the input device being created?
Somewhere in the log you should see:

	"cx23885 IR (TeVii S470)"

when the input device is created.


3. With the "debug=7" option to the cx23885 module, do you see any IR
interrupts coming in?  In dmesg or the log you should see:

	"(PCI_MSK_IR        0x...)"

when an IR interrupt happens.


Tonight I will:

a. Add a guess at HVR-1800 support so maybe Steve can help us debug as
well.  I know the NEC decoder works; I tested it.  What I don't know is
if the CX23885 AV IR implementation works (I don't have CX23885 hardware
at the moment).

b. Add a temporary patch to add a /dev/videoN node for the TeVii S470 so
you can use "v4l2-ctl --log-status" to show the status of the IR
controller and v4l2-dbg to dump the cx23885 and cx23885-av-core
registers, so I can see if everthying is set right.

c. Review the register settings to make sure interrupts should be
enabled for the IR controller.

Regards,
Andy

