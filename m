Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63426 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZF3INc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2009 04:13:32 -0400
Received: by bwz9 with SMTP id 9so3724376bwz.37
        for <linux-media@vger.kernel.org>; Tue, 30 Jun 2009 01:13:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246321072.6477.26.camel@pc07.localdom.local>
References: <9057c8440906291443y5fb2cbb7ke72a988737169ca4@mail.gmail.com>
	 <1246317441.6477.22.camel@pc07.localdom.local>
	 <1246321072.6477.26.camel@pc07.localdom.local>
Date: Tue, 30 Jun 2009 09:13:33 +0100
Message-ID: <9057c8440906300113w6557c876p58a530490bd4992f@mail.gmail.com>
Subject: Re: Compro Videomate S350 - new version?
From: Richard Smith <theras@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hermann,

On Tue, Jun 30, 2009 at 1:17 AM, hermann pitton<hermann-pitton@arcor.de> wrote:
>
> Am Dienstag, den 30.06.2009, 01:17 +0200 schrieb hermann pitton:
>> Hi Richard,
>>
>> Am Montag, den 29.06.2009, 22:43 +0100 schrieb Richard Smith:
>> > Hi,
>> > I bought a Compro Videomate S350 DVB-S card a few weeks ago as it was
>> > cheap and looked like it might work with Linux using Jan Louw's
>> > patches.  However, my S350 seems to be slightly different - it uses a
>> > SAA7135 chip so isn't correctly identified.  Changing the PCI Vendor
>> > ID to 0x7133 in the S350 patch fixed this, but unfortunately this is
>> > the same PCI Vendor / Device / subvendor / subdevice as the Compro
>> > Videomate T750 - an entirely different, DVB-T board.  I'm not sure how
>> > these should be told apart - maybe using eeprom content?
>> > Anyway, once this was updated the card still didn't work.  I realised
>> > there was no voltage on the RF input to power the LNB, so by trial and
>> > error found a GPIO bit that appears to turn LNB voltage on and off.
>> > Instead of 0x8000 used in Jan's patch, use 0xC000 for GPIO setup.
>
> Likely more comes up, but forgot to ask already if 0x4000 is enough?

No, with 0x4000 only the demodulator doesn't respond to I2C - I assume
it is in sleep mode.

Regards,
Richard.
>
> Cheers,
> Hermann
>
>> > With this change the card appears to work, at least receiving DVB-S.
>> > I haven't tested the IR remote control or analogue inputs.
>> > I hope this info is of some use to somebody, and that it's considered
>> > if the S350 support gets added to v4l-dvb tree.  I'm not sure if my
>> > card is rare, or a sign of things to come.
>> >
>> > Here is the kernel log after modifying the driver:
>> >
>> > saa7133[0]: found at 0000:04:09.0, rev: 209, irq: 5, latency: 64,
>> > mmio: 0xfaafe800
>> > saa7133[0]: subsystem: 185b:c900, board: Compro VideoMate S350/300
>> > [card=169,autodetected]
>> > saa7133[0]: board init: gpio is 843f00
>> > saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>> > saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
>> > saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
>> > saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom 70: 00 00 00 01 40 2a ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > saa7133[0]: registered device video0 [v4l2]
>> > saa7133[0]: registered device vbi0
>> > dvb_init() allocating 1 frontend
>> > DVB: registering new adapter (saa7133[0])
>> > DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S)...
>> >
>> > Regards,
>> >
>> > Richard Smith.
>>
>> good work!
>>
>> Compro has a lot of different cards with the same PCI subsystem (:
>>
>> And you are right, we can't make a difference to the T750 by that, since
>> it also uses what is subsumed under the saa7133 chips. (saa7133/35/31e)
>>
>> Nothing left to detect than use some byte from the eeprom, even the not
>> yet used board init for both is the same, might be different on the
>> T750.
>>
>> > saa7130[0]: board init: gpio is 843f00
>>
>> > saa7130[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
>> > > saa7130[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
>> > > saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
>> > > saa7130[0]: i2c eeprom 60: 30 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom 70: 00 00 00 10 03 9c ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>> > > saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>>
>> >From the Compro T750.
>>
>> [ 13.317113] saa7130/34: v4l2 driver version 0.2.14 loaded
>> [ 13.317703] ACPI: PCI Interrupt Link [APC1] enabled at IRQ 16
>> [ 13.317709] saa7134 0000:04:08.0: PCI INT A -> Link[APC1] -> GSI 16
>> (level, low) -> IRQ 16
>> [ 13.317716] saa7133[0]: found at 0000:04:08.0, rev: 209, irq: 16,
>> latency: 32, mmio: 0xfdbfe000
>> [ 13.317723] saa7133[0]: subsystem: 185b:c900, board: Compro VideoMate
>> T750 [card=139,autodetected]
>> [ 13.317734] saa7133[0]: board init: gpio is 84bf00
>> [ 13.317746] saa7133[0]: Oops: IR config error [card=139]
>> [ 13.476035] saa7133[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9
>> 1c 55 d2 b2 92
>> [ 13.476046] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476055] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00
>> 87 ff ff ff ff
>> [ 13.476064] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476072] saa7133[0]: i2c eeprom 40: ff d7 00 c4 86 1e 05 ff 02 c2 ff
>> 01 c6 ff 05 ff
>> [ 13.476081] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff cb
>> [ 13.476089] saa7133[0]: i2c eeprom 60: 35 ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476098] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476106] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476115] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476123] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476132] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476140] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476149] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476157] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>> [ 13.476166] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff
>>
>> Seems we could use byte 0x41 like on the other Compro cards.
>>
>> Tuner type is 0xd6 versus 0xd7 on the T750, also tuner address is 0xc0
>> versus 0xc4 and digital demod is 0x1c versus 0x1e. (not shifted >> 1)
>>
>> Igor received also a patch for remote support on the S350.
>>
>> Without looking into any further details yet, might me more to consider,
>> but maybe that IR patch works on recent Compro cards like the T750 too.
>>
>
>
>
