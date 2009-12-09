Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49829 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbZLIPyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2009 10:54:10 -0500
Received: by bwz27 with SMTP id 27so5335443bwz.21
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2009 07:54:15 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andy Walls <awalls@radix.net>
Subject: Re: IR Receiver on an Tevii S470
Date: Wed, 9 Dec 2009 17:54:09 +0200
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org,
	stoth@kernellabs.com
References: <4B0459B1.50600@fechner.net> <200912081959.21245.liplianin@me.by> <1260359266.3093.15.camel@palomino.walls.org>
In-Reply-To: <1260359266.3093.15.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912091754.09985.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9 декабря 2009 13:47:46 Andy Walls wrote:
> On Tue, 2009-12-08 at 19:59 +0200, Igor M. Liplianin wrote:
> > On 7 декабря 2009 05:35:46 Andy Walls wrote:
> > > Igor and Matthias,
> > >
> > > Please try the changes that I have for the TeVii S470 that are here:
> > >
> > > 	http://linuxtv.org/hg/~awalls/cx23885-ir
> > >
> > > You will want to modprobe the driver modules like this to get debugging
> > > information:
> > >
> > > 	# modprobe cx25840 ir_debug=2
> > > 	# modprobe cx23885 ir_input_debug=1
> > >
> > > With that debugging you will get output something like this in dmesg or
> > > your logs when you press a button on the remote (this is RC-5 using a
> > > CX23888 chip not NEC using a CX23885 chip):
> > >
> > > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > > cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
> > > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > > cx23885[0]/888-ir: IRQ Status:  tsr     rto
> > > cx23885[0]/888-ir: IRQ Enables:     rse rte roe
> > > cx23885[0]/888-ir: rx read:     817000 ns  mark
> > > cx23885[0]/888-ir: rx read:     838926 ns  space
> > > cx23885[0]/888-ir: rx read:    1572259 ns  mark
> > > cx23885[0]/888-ir: rx read:    1705296 ns  space
> > > [...]
> > > cx23885[0]/888-ir: rx read:     838037 ns  space
> > > cx23885[0]/888-ir: rx read:     746333 ns  mark
> > > cx23885[0]/888-ir: rx read:    1705741 ns  space
> > > cx23885[0]/888-ir: rx read:    1619370 ns  mark
> > > cx23885[0]/888-ir: rx read: end of rx
> > >
> > > If you do not see good or many NEC timing measurments in the logs, the
> > > first thing to try is to change lines 533-534 of
> > > linux/drivers/media/cx23885/cx23885-input.c:
> > >
> > >                params.modulation = true;
> > >                params.invert_level = false;
> > >
> > > If you see no timing measurements or few timing measurements, change
> > > the "modulation" to "false".  If the chip is expecting carrier pulses
> > > and an external circuit or capacitor is smoothing carrier bursts into
> > > baseband pulses, then the hardware won't make measurements properly.
> > >
> > > If you see inverted mark and space inverted when "modulation" is set to
> > > "false", then set "invert_level" to "true".
> > >
> > > Those are the two things I had to really guess at.
> > >
> > > Regards,
> > > Andy
> >
> > No luck :(
> > Nothing in logs
> >
> :(
>
> OK.
>
> 1. I assume you have the v4l-cx23885-avcore-01.fw file available for the
> cx25840 module, just so there is no problem initializing the CX23885 AV
> core.
>
>
> 2. Does dmesg or the logs show the input device being created?
> Somewhere in the log you should see:
>
> 	"cx23885 IR (TeVii S470)"
>
> when the input device is created.
>
>
> 3. With the "debug=7" option to the cx23885 module, do you see any IR
> interrupts coming in?  In dmesg or the log you should see:
>
> 	"(PCI_MSK_IR        0x...)"
>
> when an IR interrupt happens.

cx25840 3-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
cx25840 3-0044: firmware: requesting v4l-cx23885-avcore-01.fw
cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
DS3000 chip version: 0.192 attached.
DVB: registering new adapter (cx23885[0])
dvb_register_frontend
DVB: registering adapter 0 frontend 0 (Montage Technology DS3000/TS2020)...
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfea00000
cx23885 0000:02:00.0: setting latency timer to 64
IRQ 16/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs
input: cx23885 IR (TeVii S470) as /class/input/input5

That's all.

In fact some time ago I was writing some code for cx23885 IR, but not reached IR interrupts to 
work. Though I used PCI_MSK_AV_CORE (1 << 27), then test register PIN_CTRL for field 
FLD_IR_IRQ_STAT.

I have Compro E650F with RC6 remote, also have RC5 remote from TV set.
I will made little hack to test Compro & RC5.


>
>
> Tonight I will:
>
> a. Add a guess at HVR-1800 support so maybe Steve can help us debug as
> well.  I know the NEC decoder works; I tested it.  What I don't know is
> if the CX23885 AV IR implementation works (I don't have CX23885 hardware
> at the moment).
>
> b. Add a temporary patch to add a /dev/videoN node for the TeVii S470 so
> you can use "v4l2-ctl --log-status" to show the status of the IR
> controller and v4l2-dbg to dump the cx23885 and cx23885-av-core
> registers, so I can see if everthying is set right.
>
> c. Review the register settings to make sure interrupts should be
> enabled for the IR controller.
>
> Regards,
> Andy

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
