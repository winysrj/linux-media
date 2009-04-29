Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:51931 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757735AbZD2UaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2009 16:30:24 -0400
Subject: Re: ASUS 'My Cinema Europa Hybrid' (P7131 DVB-T) [SAA7134]
	Firmware oddities
From: hermann pitton <hermann-pitton@arcor.de>
To: Sam Spilsbury <smspillaz@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <5e20e5fc0904290247o276f8bai7011a2bd9232f2ed@mail.gmail.com>
References: <5e20e5fc0904280902h12e62b0dq51e21c2945665f5f@mail.gmail.com>
	 <1240939480.3731.27.camel@pc07.localdom.local>
	 <5e20e5fc0904290247o276f8bai7011a2bd9232f2ed@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 22:24:07 +0200
Message-Id: <1241036647.3710.67.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Mittwoch, den 29.04.2009, 17:47 +0800 schrieb Sam Spilsbury:
> On Wed, Apr 29, 2009 at 1:24 AM, hermann pitton <hermann-pitton@arcor.de> wrote:
> > Hello,
> >
> > you seem to have a card which is not in the database of the saa7134
> > driver yet.
> 
> OK. Are the steps below necessary to put into a text file somewhere to
> add it to the database?

If we can get it to work, a patch must be created to add it to the
saa7134 driver and in the future it will be auto detected and hopefully
is correctly configured.

Please read.
http://linuxtv.org/wiki/index.php/Development:_How_to_add_support_for_a_device

> >
> > Am Mittwoch, den 29.04.2009, 00:02 +0800 schrieb Sam Spilsbury:
> >> Hi everyone,
> >>
> >> So It's my first time to LinuxTV hacking, debugging etc, so I
> >> apologize if I've failed to provide anything essential.
> >>
> >> Anyways, I've just bought a ASUS 'My Cinema Europa Hybrid' (P7131
> >> DVB-T) which has the Phillips saa7131 chipset in it (supported by the
> >> saa7131 module et al). There is a problem getting the firmware in this
> >> card to boot correctly - I may have the wrong card number and I cannot
> >> use i2c because it detects it as UNKNOWN/GENERIC (i.e type 0) which
> >> doesn't work.
> >
> > The driver detects a saa7134 chip on it.
> >
> >> According to /usr/share/doc/linux/video4linux etc my card number
> >> should be either 78, 111 or 112. Specifying card=x seems to make the
> >> module somewhat recognize the card, and even though I have the
> >> firmware - it won't actually boot. This is shown by the fact that all
> >> dvb operations essentially just time out and the fact that I cannot
> >> scan channels in software like tvtime. I might be wrong though.
> >
> > None of these above cards can work for you.
> 
> OK. They all looked pretty close (ASUS P7131) so I thought I might
> give them a try. (P7131 is what it said on the box of my card - but
> interestingly enough even though the specs on the box say it comes
> with composite and composite inputs it doesn't - do you think this
> might be a case of shipping muckup or just a lower model of the card?)

Europa and Europa II are Philips reference designs.
Europa II is known as OEM version only. External inputs are connected
from a panel on the card to inputs at the front of the PC.

Your Asus Europa card was never seen before.
I got the info about your card by comparing eeprom content with already
known cards. This must not always end up well, since manufacturers often
use different encodings, especially for the tuner type.

Also, Asus does not list your PCI card as I checked now.
http://www.asus.com/ProductGroup2.aspx?PG_ID=athl2A14Q5Jax5Id

But we can find it here in an OEM box.
http://support.packardbell.com/uk/item/index.php?i=spec_tvtuner_AsusHybridEuropa&ppn=PB14207401

Tuner TD1316 etc. Note also the on-board connector for analog audio out,
the two pins in the middle are usually ground.
If you don't have the Spider Cable P/N 6924780000 and the front panel,
it might become difficult with the external inputs ... 

> >
> >> Here is relevant output which might assist in helping the problem:
> >>
> >> ==== dmesg log ====c
> >>
> >> saa7130/34: v4l2 driver version 0.2.14 loaded
> >> saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
> >> 0xeb007000
> >> saa7134[0]: subsystem: 1043:4847, board: ASUSTeK P7131 Dual
> >
> > Here we see a new Asus card with subdevice 0x4847.
> >
> >> [card=78,insmod option]
> >> saa7134[0]: board init: gpio is 200000
> >
> > Was board init gpio the same for card=0 UNKNOWN/GENERIC before you tried
> > any other card?
> 
> This is basically what I got with dmesg with UNKNOWN/GENERIC
> [card=0,autodetected]
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
> 0xeb007000
> saa7134[0]: subsystem: 1043:4847, board: UNKNOWN/GENERIC [card=0,autodetected]
> saa7134[0]: board init: gpio is 0

Ah, thanks.

> saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c scan: found device @ 0x10  [???]
> saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
> saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]

No tuner found at 0x61/c2.

> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> 
> >
> >> input: saa7134 IR (ASUSTeK P7131 Dual) as
> >> /devices/pci0000:00/0000:00:09.0/input/input7
> >> tuner' 3-0043: chip found @ 0x86 (saa7134[0])
> >> tda9887 3-0043: creating new instance
> >> tda9887 3-0043: tda988[5/6/7] found
> >
> > There is likely not only the tda9885/6/7 analog IF demodulator, but also
> > an old style can tuner at 0xc2. With i2c_scan=1, try "modinfo saa7134",
> > it might be detected.
> 
> Not sure how to check for that - but here is the output of "modinfo saa7134"

The i2c scan does not detect the tuner's PLL chip.

> > It is also not the Asus Europa2 hybrid design here and not a Philips
> > FMD1216ME MK3 hybrid. On this card tda9887 and the tuner PLL chip are
> > not visible on the bus until the i2c bridge of the tda10046 DVB-T demod
> > is opened.
> 
> Strange. Do you know what it might be? (The box says it's a Europa Hybrid)

Some info we have together now, but hybrid cards can be tricky.

> >> saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> >> saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> >> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
> >
> > This sequence here is the same for the SAA7134_BOARD_VIDEOMATE_DVBT_200A
> > and it has some sort of Philips TD1316 tuner. Analog tuner support is
> > not enabled on this card.
> 
> So the card says it comes with analog tuner support but it's not enabled?

On the Compro 200A it is not enabled. Don't remember offhand.
The TD1316 comes in various flavours, IIRC.
Some have a tda9887 analog demodulator outside of the tuner on the main
PCB and some not. Maybe on the 200A it was not found how to switch to
it. The Compro 200 has nothing for analog TV.

You could force tuner=67, but it seems not to be visible on the bus.

> >> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> >> saa7134[0]: registered device video0 [v4l2]
> >> saa7134[0]: registered device vbi0
> >> saa7134[0]: registered device radio0
> >> DVB: registering new adapter (saa7134[0])
> >> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> >> tda1004x: setting up plls for 48MHz sampling clock
> >> tda1004x: timeout waiting for DSP ready
> >> tda1004x: found firmware revision 0 -- invalid
> >> tda1004x: trying to boot from eeprom
> >> tda1004x: found firmware revision 26 -- ok
> >> saa7134[0]/dvb: could not access tda8290 I2C gate
> >> tda827x_probe_version: could not read from tuner at addr: 0xc2
> >
> > You get this, because on your card are no such silicon analog demod and
> > tuner chips.
> >
> >> ===== Relevant bits of lspci =====
> >>
> >> 00:09.0 Multimedia controller: Philips Semiconductors
> >> SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
> >>        Subsystem: ASUSTeK Computer Inc. Device 4847
> >>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> >> Stepping- SERR- FastB2B- DisINTx-
> >>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> >> <TAbort- <MAbort- >SERR- <PERR- INTx-
> >>        Latency: 32 (21000ns min, 8000ns max)
> >>        Interrupt: pin A routed to IRQ 18
> >>        Region 0: Memory at eb007000 (32-bit, non-prefetchable) [size=1K]
> >>        Capabilities: [40] Power Management version 1
> >>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> >> PME(D0-,D1-,D2-,D3hot-,D3cold-)
> >>                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
> >>        Kernel driver in use: saa7134
> >>        Kernel modules: saa7134
> >>
> >>
> >> Any help would be greatly appreciated however I understand if this
> >> isn't a fixable issue. If so it would be nice to know where I could
> >> buy (online) TV Tuner cards with a composite input, are the old PCI
> >> type and of course work well with Linux (Fedora 10 at least).
> >
> > You might try to force the Compro DVB-T 200A card=103 and see what
> > happens for DVB-T. Composite input you will get to work in any case.
> 
> Here is what I get when I specify card=103
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
> 0xeb007000
> saa7134[0]: subsystem: 1043:4847, board: UNKNOWN/GENERIC [card=0,autodetected]
> saa7134[0]: board init: gpio is 0
> saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c scan: found device @ 0x10  [???]
> saa7134[0]: i2c scan: found device @ 0x86  [tda9887]
> saa7134[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
> 0xeb007000
> saa7134[0]: subsystem: 1043:4847, board: Compro Videomate DVB-T200A
> [card=103,insmod option]
> saa7134[0]: board init: gpio is 0
> saa7134[0]: Oops: IR config error [card=103]

BTW, another bogus remote support detected.

> saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: registered device video0 [v4l2]
> saa7134[0]: registered device vbi0
> DVB: registering new adapter (saa7134[0])
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision 26 -- ok
> 
> I've waited about 5 minutes after loading the module and no errors
> have been reported so far. However I don't seem to be getting anything
> from dvbdate, dvbsnoop etc.
> 
> kdetv displays static but I can't seem to tune any channels.

I suspect, even with tuner=67 for analog TV loaded, we will see errors
for i2c traffic to the tuner at 0xc2 during tuning attempts for both,
digital and analog. You can see such traffic with i2c_debug=1.

Please try also with card=70 Compro 300 and keep i2c_scan=1 and set also
audio_debug=1. We must find the tuner and maybe it is behind the i2c
bridge of the tda10046 like on that card.

Enable also debug=1 for the tuner module and for tuner-simple.

The Compro 300 has for analog TV video vmux = 3 connected, Asus usually
uses vmux=1, but The Europa reference design also uses vmux = 3.

Good luck again,

Hermann


