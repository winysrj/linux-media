Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:34098 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752735AbZD1R2h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 13:28:37 -0400
Subject: Re: ASUS 'My Cinema Europa Hybrid' (P7131 DVB-T) [SAA7134]
	Firmware oddities
From: hermann pitton <hermann-pitton@arcor.de>
To: Sam Spilsbury <smspillaz@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <5e20e5fc0904280902h12e62b0dq51e21c2945665f5f@mail.gmail.com>
References: <5e20e5fc0904280902h12e62b0dq51e21c2945665f5f@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 19:24:40 +0200
Message-Id: <1240939480.3731.27.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

you seem to have a card which is not in the database of the saa7134
driver yet.

Am Mittwoch, den 29.04.2009, 00:02 +0800 schrieb Sam Spilsbury:
> Hi everyone,
> 
> So It's my first time to LinuxTV hacking, debugging etc, so I
> apologize if I've failed to provide anything essential.
> 
> Anyways, I've just bought a ASUS 'My Cinema Europa Hybrid' (P7131
> DVB-T) which has the Phillips saa7131 chipset in it (supported by the
> saa7131 module et al). There is a problem getting the firmware in this
> card to boot correctly - I may have the wrong card number and I cannot
> use i2c because it detects it as UNKNOWN/GENERIC (i.e type 0) which
> doesn't work.

The driver detects a saa7134 chip on it.

> According to /usr/share/doc/linux/video4linux etc my card number
> should be either 78, 111 or 112. Specifying card=x seems to make the
> module somewhat recognize the card, and even though I have the
> firmware - it won't actually boot. This is shown by the fact that all
> dvb operations essentially just time out and the fact that I cannot
> scan channels in software like tvtime. I might be wrong though.

None of these above cards can work for you.

> Here is relevant output which might assist in helping the problem:
> 
> ==== dmesg log ====c
> 
> saa7130/34: v4l2 driver version 0.2.14 loaded
> saa7134[0]: found at 0000:00:09.0, rev: 1, irq: 18, latency: 32, mmio:
> 0xeb007000
> saa7134[0]: subsystem: 1043:4847, board: ASUSTeK P7131 Dual

Here we see a new Asus card with subdevice 0x4847.

> [card=78,insmod option]
> saa7134[0]: board init: gpio is 200000

Was board init gpio the same for card=0 UNKNOWN/GENERIC before you tried
any other card?

> input: saa7134 IR (ASUSTeK P7131 Dual) as
> /devices/pci0000:00/0000:00:09.0/input/input7
> tuner' 3-0043: chip found @ 0x86 (saa7134[0])
> tda9887 3-0043: creating new instance
> tda9887 3-0043: tda988[5/6/7] found

There is likely not only the tda9885/6/7 analog IF demodulator, but also
an old style can tuner at 0xc2. With i2c_scan=1, try "modinfo saa7134",
it might be detected.

It is also not the Asus Europa2 hybrid design here and not a Philips
FMD1216ME MK3 hybrid. On this card tda9887 and the tuner PLL chip are
not visible on the bus until the i2c bridge of the tda10046 DVB-T demod
is opened.

> saa7134[0]: i2c eeprom 00: 43 10 47 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> saa7134[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 20: 01 40 01 02 03 ff 03 04 08 ff 00 2a ff ff ff ff
> saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> saa7134[0]: i2c eeprom 40: ff 02 00 c2 86 10 ff ff ff ff ff ff ff ff ff ff

This sequence here is the same for the SAA7134_BOARD_VIDEOMATE_DVBT_200A
and it has some sort of Philips TD1316 tuner. Analog tuner support is
not enabled on this card.

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
> saa7134[0]: registered device radio0
> DVB: registering new adapter (saa7134[0])
> DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: found firmware revision 26 -- ok
> saa7134[0]/dvb: could not access tda8290 I2C gate
> tda827x_probe_version: could not read from tuner at addr: 0xc2

You get this, because on your card are no such silicon analog demod and
tuner chips.

> ===== Relevant bits of lspci =====
> 
> 00:09.0 Multimedia controller: Philips Semiconductors
> SAA7134/SAA7135HL Video Broadcast Decoder (rev 01)
>        Subsystem: ASUSTeK Computer Inc. Device 4847
>        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>        Latency: 32 (21000ns min, 8000ns max)
>        Interrupt: pin A routed to IRQ 18
>        Region 0: Memory at eb007000 (32-bit, non-prefetchable) [size=1K]
>        Capabilities: [40] Power Management version 1
>                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>        Kernel driver in use: saa7134
>        Kernel modules: saa7134
> 
> 
> Any help would be greatly appreciated however I understand if this
> isn't a fixable issue. If so it would be nice to know where I could
> buy (online) TV Tuner cards with a composite input, are the old PCI
> type and of course work well with Linux (Fedora 10 at least).

You might try to force the Compro DVB-T 200A card=103 and see what
happens for DVB-T. Composite input you will get to work in any case.

Good Luck,

Hermann


