Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:49726 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbZLGDgq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Dec 2009 22:36:46 -0500
Subject: Re: IR Receiver on an Tevii S470
From: Andy Walls <awalls@radix.net>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: Matthias Fechner <idefix@fechner.net>, linux-media@vger.kernel.org
In-Reply-To: <200912070323.14440.liplianin@me.by>
References: <4B0459B1.50600@fechner.net>
	 <200911220303.36715.liplianin@me.by>
	 <1260135654.3101.15.camel@palomino.walls.org>
	 <200912070323.14440.liplianin@me.by>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Dec 2009 22:35:46 -0500
Message-Id: <1260156946.1809.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-12-07 at 03:23 +0200, Igor M. Liplianin wrote:
> On 6 декабря 2009 23:40:54 Andy Walls wrote:
> > On Sun, 2009-11-22 at 03:03 +0200, Igor M. Liplianin wrote:
> > > On 21 ноября 2009 22:41:42 Andy Walls wrote:
> > > > > Matthias Fechner schrieb:
> > > > > > I bought some days ago a Tevii S470 DVB-S2 (PCI-E) card and got it
> > > > > > running with the driver from:
> > > > > > http://mercurial.intuxication.org/hg/s2-liplianin
> > > > > >
> > > > > > But I was not successfull in got the IR receiver working.
> > > > > > It seems that it is not supported yet by the driver.
> > > > > >
> > > > > > Is there maybe some code available to get the IR receiver with
> > > > > > evdev running?
> > > >
> > > > If the card is using the built in IR controller in the CX23885, then
> > > > you'll have to wait until I port my CX23888 IR controller changes to
> > > > work with the IR controller in the CX23885.  That should be somewhat
> > > > straightforward, but will take time.  Then we'll still need you to
> > > > experiment with a patch.
> > >
> > > It's cx23885 definitely.
> > > Remote uses NEC codes.
> > > In any case I can test.
> >
> > On Mon, 2009-11-23, Igor M. Liplianin wrote:
> > > Receiver connected to cx23885 IR_RX(pin 106). It is not difficult to
> > > track.
> >
> > Igor,
> Hi Andy,
> 
> >
> > As I make patches for test, perhaps you can help answer some questions
> > which will save some experimentation:
> >
> >
> > 1. Does the remote for the TeVii S470 use the same codes as
> >
> > linux/drivers/media/common/ir-keymaps.c : ir_codes_tevii_nec[]
> That is correct table for cx88 based TeVii card with the same remote.
> I believe there is no difference for cx23885.
> 
> >
> > or some other remote code table we have in the kernel?
> >
> >
> > 2. Does the remote for the TeVii S470, like other TeVii remotes, use a
> > standard NEC address of 0x00 (so that Addr'Addr is 0xff00) ?  Or does it
> > use another address?
> Again like in cx88, the address is standard.
> 
> >
> >
> > 3. When you traced board wiring from the IR receiver to the IR_RX pin on
> > the CX23885, did you notice any external components that might modify
> > the signal?  For example, a capacitor that integrates carrier bursts
> > into baseband pulses.
> Yet again I believe there is no capacitors.
> Very same scheme like in cx88 variants for TeVii and others.


Igor and Matthias,

Please try the changes that I have for the TeVii S470 that are here:

	http://linuxtv.org/hg/~awalls/cx23885-ir

You will want to modprobe the driver modules like this to get debugging
information:

	# modprobe cx25840 ir_debug=2
	# modprobe cx23885 ir_input_debug=1

With that debugging you will get output something like this in dmesg or
your logs when you press a button on the remote (this is RC-5 using a
CX23888 chip not NEC using a CX23885 chip):

cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
cx23885[0]/888-ir: IRQ Enables:     rse rte roe
cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
cx23885[0]/888-ir: IRQ Enables:     rse rte roe
cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
cx23885[0]/888-ir: IRQ Enables:     rse rte roe
cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
cx23885[0]/888-ir: IRQ Enables:     rse rte roe
cx23885[0]/888-ir: IRQ Status:  tsr rsr             rby
cx23885[0]/888-ir: IRQ Enables:     rse rte roe
cx23885[0]/888-ir: IRQ Status:  tsr     rto            
cx23885[0]/888-ir: IRQ Enables:     rse rte roe
cx23885[0]/888-ir: rx read:     817000 ns  mark
cx23885[0]/888-ir: rx read:     838926 ns  space
cx23885[0]/888-ir: rx read:    1572259 ns  mark
cx23885[0]/888-ir: rx read:    1705296 ns  space
[...]
cx23885[0]/888-ir: rx read:     838037 ns  space
cx23885[0]/888-ir: rx read:     746333 ns  mark
cx23885[0]/888-ir: rx read:    1705741 ns  space
cx23885[0]/888-ir: rx read:    1619370 ns  mark
cx23885[0]/888-ir: rx read: end of rx

NEC would actually have this sort of timing:

8257296 ns  mark
4206185 ns  space
 482926 ns  mark
 545296 ns  space
 481296 ns  mark
1572259 ns  space
 481148 ns  mark
 546333 ns  space
[...]
 433593 ns  mark
1618333 ns  space
 454481 ns  mark
end of rx

8255519 ns  mark
2130926 ns  space
 480556 ns  mark
end of rx


The NEC decoder will also log the decoded 32 bits it receives and
separate out the address and the command bits.


If you do not see good or many NEC timing measurments in the logs, the
first thing to try is to change lines 533-534 of
linux/drivers/media/cx23885/cx23885-input.c:

               params.modulation = true;
               params.invert_level = false;

If you see no timing measurements or few timing measurements, change the
"modulation" to "false".  If the chip is expecting carrier pulses and an
external circuit or capacitor is smoothing carrier bursts into baseband
pulses, then the hardware won't make measurements properly.

If you see inverted mark and space inverted when "modulation" is set to
"false", then set "invert_level" to "true".

Those are the two things I had to really guess at.


BTW, I'm not accessing the CX23885 AV Core registers across the I2C bus
in a very conservative way.  If you notice some performance problem with
an occasionally missed pulse measurement, then I know there is room for
improvement by being smarter about I2C bus transactions.

Good Luck.

Regards,
Andy

