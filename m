Return-path: <linux-media-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:3970 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZF0JJY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Jun 2009 05:09:24 -0400
Received: by rv-out-0506.google.com with SMTP id f6so803390rvb.1
        for <linux-media@vger.kernel.org>; Sat, 27 Jun 2009 02:09:28 -0700 (PDT)
Message-ID: <4A45E1C0.8090603@gmail.com>
Date: Sat, 27 Jun 2009 19:09:20 +1000
From: O&M Ugarcina <mo.ucina@gmail.com>
Reply-To: mo.ucina@gmail.com
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org
CC: "Jan D. Louw" <jd.louw@mweb.co.za>
Subject: Re: [linux-dvb] Support for Compro VideoMate S350 - Testing Results
References: <81c0b0550905250703o786a2a65ib757287da841dc11@mail.gmail.com> <200906201633.58431.liplianin@me.by> <4A40C81E.7070304@gmail.com> <200906231804.28893.liplianin@me.by>
In-Reply-To: <200906231804.28893.liplianin@me.by>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Igor ,

I want to thank you for making those patches available . I have been 
able to patch the latest HG pull and to compile and install the drivers 
. I decided to install the whole lot as it was a bit hard to workout 
just the ko's responsible for the S350 . After installing the card I 
have this from dmesg :

saa7130/34: v4l2 driver version 0.2.15 loaded
saa7134 0000:04:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
saa7130[0]: found at 0000:04:01.0, rev: 1, irq: 22, latency: 64, mmio: 
0xfeaffc00
saa7130[0]: subsystem: 185b:c900, board: Compro VideoMate S350/S300 
[card=169,autodetected]
saa7130[0]: board init: gpio is 843f00
input: saa7134 IR (Compro VideoMate S3 as 
/devices/pci0000:00/0000:00:1e.0/0000:04:01.0/input/input5
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
parport_pc 00:0b: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE,EPP]
saa7130[0]: i2c eeprom 00: 5b 18 00 c9 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7130[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 20: 01 40 01 02 02 01 03 01 08 ff 00 87 ff ff ff ff
saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 40: ff d6 00 c0 86 1c 02 01 02 ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff cb
saa7130[0]: i2c eeprom 60: 30 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 70: 00 00 00 10 03 9c ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7130[0]: registered device video0 [v4l2]
saa7130[0]: registered device vbi0
i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region 
SMRG [0x400-0x40f]
ACPI: Device needs an ACPI driver
ppdev: user-space parallel port driver
dvb_init() allocating 1 frontend
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
DVB: registering new adapter (saa7130[0])
DVB: registering adapter 0 frontend 0 (Zarlink ZL10313 DVB-S).


I was able to tune into my favourite satellite with mythtv with no 
problems . I also was able to tune to another satellite using the mythtv 
configuration for 4 way diseqc . So 4 way diseqc works fine for me . 
Picture is satble and very good , sound also is ok . I will just run it 
now to see how the system stability is over a longer period of time .

One small issue I have noticed : and that is in mythtv the signal 
strength indicator shows very low with S350 now . Before I was getting 
with TT1500S around 79 to 89% while now with S350 I see about 18% for 
the same channel .

Best Regards

Milorad


