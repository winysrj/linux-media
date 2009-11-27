Return-path: <linux-media-owner@vger.kernel.org>
Received: from n9a.bullet.mail.mud.yahoo.com ([209.191.87.108]:36726 "HELO
	n9a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752309AbZK0W7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Nov 2009 17:59:43 -0500
Message-ID: <8049.95935.qm@web110610.mail.gq1.yahoo.com>
References: <754577.88092.qm@web110614.mail.gq1.yahoo.com>  <1259025174.5511.24.camel@pc07.localdom.local>  <990417.69725.qm@web110607.mail.gq1.yahoo.com>  <1259107698.2535.10.camel@localhost>  <623705.13034.qm@web110608.mail.gq1.yahoo.com>  <1259172867.3335.7.camel@pc07.localdom.local>  <214960.24182.qm@web110609.mail.gq1.yahoo.com> <1259360050.6061.22.camel@pc07.localdom.local>
Date: Fri, 27 Nov 2009 14:59:48 -0800 (PST)
From: Dominic Fernandes <dalf198@yahoo.com>
Subject: Re: Compile error saa7134 - compro videomate S350
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1259360050.6061.22.camel@pc07.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hi,

where does  "options saa7134 alsa=0" need to be declared?  Is it in /etc/modprobe.d/options.conf ?  If so, it didn't work - "FATAL: saa7134-alsa is in use"

thanks,
Dominic



----- Original Message ----
From: hermann pitton <hermann-pitton@arcor.de>
To: Dominic Fernandes <dalf198@yahoo.com>
Cc: linux-media@vger.kernel.org
Sent: Fri, November 27, 2009 10:14:10 PM
Subject: Re: Compile error saa7134 - compro videomate S350

Hi,

Am Freitag, den 27.11.2009, 02:12 -0800 schrieb Dominic Fernandes:
> Hi Hermann,
> 
> > unload the driver with "modprobe -vr saa7134-alsa saa7134-dvb".
> 
> When I tried this I got the message "FATAL: saa7134-alsa is in use" (or something like that).

that are mixers and such using saa7134-alsa. They prevent you from
unloading saa7134 too. With "options saa7134 alsa=0" the alsa device is
not created.

> >You might have to close mixers using saa7134-alsa previously.
> > With "modinfo saa7134" you get available options.
> 
> I wasn't sure what to look for here, there was a lot of info. being displayed.

I just tried to tell that you can force a card=number.

> I carried on with "modprobe -v saa7134 card=169" command.  I ran dmesg to see the status of the card.  It did get the card id 169 but the board decription came up as unknown instead of the name of the videomate S350.  Is this expected?

No, "modprobe -v saa7134" should show if something in etc/modules.d
or /etc/modprobe.conf overrides your card=169 command line.

If I force a card=96 to card=169 it looks like that.

saa7130/34: v4l2 driver version 0.2.15 loaded
saa7133[0]: setting pci latency timer to 64
saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 22, latency: 64, mmio: 0xfebff800
saa7133[0]: subsystem: 16be:0008, board: Compro VideoMate S350/S300 [card=169,insmod option]
saa7133[0]: board init: gpio is 0
saa7133[0]: gpio: mode=0x0008000 in=0x0000000 out=0x0008000 [pre-init]
input: saa7134 IR (Compro VideoMate S3 as /class/input/input6
IRQ 22/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]: i2c eeprom 00: be 16 08 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 0f 0f ff 00 3c 02 51 96 2b
saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[0]: i2c eeprom 40: ff 28 00 c0 96 10 03 01 c0 1c fd 79 44 9f c2 8f
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[1]: setting pci latency timer to 64
saa7133[1]: found at 0000:04:02.0, rev: 209, irq: 20, latency: 64, mmio: 0xfebff000
saa7133[1]: subsystem: 16be:0007, board: Medion Md8800 Quadro [card=96,autodetected]
saa7133[1]: board init: gpio is 0
saa7133[1]: gpio: mode=0x0000000 in=0x0000000 out=0x0000000 [pre-init]
IRQ 20/saa7133[1]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[1]: i2c eeprom 00: be 16 07 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[1]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
saa7133[1]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 23 02 51 96 2b
saa7133[1]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
saa7133[1]: i2c eeprom 40: ff 28 00 c0 96 10 03 00 c0 1c fd 79 44 9f c2 8f

Note, saa7134 gpio_tracking=1 is enabled.
saa7133[0]: gpio: mode=0x0008000 in=0x0000000 out=0x0008000 [pre-init]

Means gpio 15 is set to 1, output.


> The modification of the GPIO address "Instead of 0x8000 used in Jan's patch, use 0xC000 for GPIO setup" I'm not sure what I changed was the correct value.  Looking at the code lines I found relate to the Remote that I had changed (saa7134-cards.c):
> 
> 
> +    case SAA7134_BOARD_VIDEOMATE_S350:
> +        dev->has_remote = SAA7134_REMOTE_GPIO;
> +        saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
> +        saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> +        break;
> 
> Which leads to the question where the GPIO address of 0x8000 is currently specified?

This is exactly caused by and only by the above, likely powering up some
chip.

If you change all to 0x0000c000, gpio 14 and 15 are set to 1, output.

Don't know what exactly is going on with your card variant, but such are
the reports.

Cheers,
Hermann


      

