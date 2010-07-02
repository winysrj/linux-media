Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:47447 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570Ab0GBBW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Jul 2010 21:22:59 -0400
Subject: Re: [PATCH] Terratec Cinergy 250 PCI support
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean-Michel Grimaldi <jm@via.ecp.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTikfcq_MFrz1jnxorZKmHUq9pDrx0aEluXfGfc5a@mail.gmail.com>
References: <AANLkTim5-Cc-ijE1U7M1DWSF8hcj8svSH30a0YVM4qv9@mail.gmail.com>
	 <1277423038.4742.9.camel@pc07.localdom.local>
	 <1277503171.6256.7.camel@pc07.localdom.local>
	 <AANLkTikfcq_MFrz1jnxorZKmHUq9pDrx0aEluXfGfc5a@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 02 Jul 2010 03:16:39 +0200
Message-Id: <1278033399.3147.1.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

Am Mittwoch, den 30.06.2010, 00:02 +0200 schrieb Jean-Michel Grimaldi:
> Hi Hermann,
> 
> Thanks for your answer. Do you mean I should add an entry with .name =
> name_comp1, .vmux = 3, .amux = LINE1 ?
> 
> Should I remove the svideo entry, given that the card (which can be
> seen at [1]) only has a (proprietary) composite jack? However there
> seems to exist another card with the same name "Terratec Cinergy 250
> PCI" but different connectors : [2]
> 
> What do you think? Should I just add a composite entry and leave the
> svideo as it is?
> 
> Jean-Michel
> 
> [1] http://www.arminformatique.fr/images/TerraTec%20Cinergy%20250%
> 20PCI.jpg
> [2] http://www.notebookland.hu/shop
> +TERRATEC-CINERGY-250-PCI-TERRATEC-TV-tuner_29849_49


there is also a low profile PCI card.

http://www.terratec.net/de/produkte/bilder/img/2195346_5f78fcd0d7.png
http://www.terratec.net/de/produkte/bilder/produkt_bilder_de_4387.html

Without any such device in my possession and without sufficient testing
and reports, hard to tell.

Do you have the known subsystem 153b:1160 ?

For that one from http://www.bttv-gallery.de

chips: saa7131e, KS008, 8275ac1
pcb: TV-7131 Ver:B
0000:00:0b.0 Multimedia controller: Philips Semiconductors SAA7133 Audio+video broadcast decoder (rev d0)
        Subsystem: TERRATEC Electronic GmbH: Unknown device 1160
saa7130/34: v4l2 driver version 0.2.14 loaded
ACPI: PCI interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) -> IRQ 19
saa7133[0]: found at 0000:00:0b.0, rev: 208, irq: 19, latency: 32, mmio: 0xdfffb800
saa7133[0]: subsystem: 153b:1160, board: UNKNOWN/GENERIC [card=0,autodetected]
saa7133[0]: board init: gpio is 40
saa7133[0]: i2c eeprom 00: 3b 15 60 11 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: 00 00 20 00 ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 01 00 9c ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 00 01 30 ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

from INF:
; History:
; 16-Sep-04 FMB 1st version
; 24-Sep-04 FMB changed name from "Cinergy 250 TV" to "Cinergy 250 PCI"
...
; 13-Apr-05 FMB v.1.3.2.2 - added option for forced hardware configuration
; 09-May-05 FMB v.1.3.2.0 - added KW driver (modified for IR)
; 24-May-05 FMB v.1.3.2.0 - added registry entry for GPIO config
[TerraTec] 
; Cinergy 250 PCI (SAA7134)
%Cinergy.DeviceDesc%=3xHybrid,PCI\VEN_1131&DEV_7134&SUBSYS_1160153B
; Cinergy 250 PCI (SAA7135)
%Cinergy.DeviceDesc%=3xHybrid,PCI\VEN_1131&DEV_7133&SUBSYS_1160153B
...
; Customization
; Setting FM radio of the Silicon tuner via SIF (GPIO 21 in use/ 5.5MHz)
HKR, "Audio", "FM Radio IF",0x00010001,0x729555
[ForceHWConfig.AddReg]
HKR, "I2C Devices", "Force Registry Settings",0x00010001,1

HKR, "AudioDecoder", "Tuner Channel"   ,0x00010001,1
HKR, "AudioDecoder", "CVBS Channel"    ,0x00010001,3
HKR, "AudioDecoder", "SVHS Channel"    ,0x00010001,3
HKR, "AudioDecoder", "FM Radio Channel",0x00010001,1

; maps user setting to hardware video input
HKR, "VideoDecoder", "Tuner Channel"   ,0x00010001,1
HKR, "VideoDecoder", "CVBS Channel"    ,0x00010001,3
HKR, "VideoDecoder", "SVHS Channel"    ,0x00010001,8
HKR, "VideoDecoder", "FM Radio Channel",0x00010001,1

; Set GPIOs to output, required for TV/Radio switching
HKR, "GPIO", "Config", 0x00010001, 0xffffffff

; I2C Device settings
HKR, "I2C Devices", "Number of I2C Devices",0x00010001,1

; FMB NOTE: old prototype with TDA8275
;HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x14,0x00,0x00,0x00              ; Tuner ID
; FMB NOTE: new prototype with TDA8275A
HKR, "I2C Devices", "Device 0, Data1",0x00010001,0x22,0x00,0x00,0x00               ; Tuner ID
HKR, "I2C Devices", "Device 0, Data3",0x00010001,0x96,0x00,0x00,0x00               ; Tuner IF PLL slave addr.
Cinergy.DeviceDesc  = "Cinergy 250 PCI Capture" ; Device Manager strings

For that one, Composite vmux = 3, S-Video vmux=8, for both amux = LINE2
and it has analog FM radio support.

For my experience, if we can't auto detect any difference between those,
to treat such cards as the same until some difference shows up, is still
a way to go. Hm, seems some are without radio support.

If our auto detection fails, more hidden methods as PCI subsystem IDs or
eeprom contents might be in use to identfy OEM stuff these days like
undocumented checksums, then we can at least identify different devices
physically and can disable our failing auto detection and point to card
numbers.

A S-Video connector has only four pins, but we find regularly so called
break out connectors there, which can cover all sort of in- and outputs.

Cards can look extremely different, not only concerning connectors, but
might be still functional in the same for the inputs. There are a lot of
examples.

On some cards the yellow input connector is used for the radio antenna
RF input and changing to a low profile regularly calls for smaller
connectors too.

The opposite can be true of course too and much did change ...

In best case, they do have a different PCI subsystem then, if not and
much worse, maybe we can still figure out some difference from the
eeprom content. Worst case, we don't know how to make any difference and
the OEM does not follow Philips recommendations for the eeprom content
and uses some proprietary methods to detect the cards.

Cheers,
Hermann 

> 
> 2010/6/25 hermann pitton <hermann-pitton@arcor.de>
>         
>         Am Freitag, den 25.06.2010, 01:43 +0200 schrieb hermann
>         pitton: 
>         
>         > Hi, Jean-Michel,
>         >
>         > Am Freitag, den 25.06.2010, 00:42 +0200 schrieb Jean-Michel
>         Grimaldi:
>         > > Hi, I have a Terratec Cinergy 250 PCI video card, and a
>         small
>         > > modification in saa7134-cards.c is needed for it to work.
>         I built the
>         > > patch on 2.6.34 version (I sent the modification to the
>         maintainer in
>         > > early 2009 but got no feedback):
>         > >
>         > > -- saa7134-cards.old.c      2010-06-25 00:31:16.000000000
>         +0200
>         > > +++ saa7134-cards.new.c     2010-06-25 00:30:52.000000000
>         +0200
>         > > @@ -2833,7 +2833,7 @@
>         > >                     .tv   = 1,
>         > >             },{
>         > >                     .name = name_svideo,  /* NOT tested */
>         > > -                   .vmux = 8,
>         > > +                   .vmux = 3,
>         > >                     .amux = LINE1,
>         > >             }},
>         > >             .radio = {
>         > >
>         > > Thanks for taking it into account in future kernels.
>         > >
>         >
>         > hm, don't know who missed it. After Gerd, the main mover on
>         saa7134 was
>         > Hartmut, also /me and some well known others cared.
>         >
>         > Official maintainer these days is Mauro.
>         >
>         > For latest DVB stuff, you also will meet Mike Krufky.
>         >
>         > I'm sorry, but your patch is still wrong.
>         >
>         > You do have only a Composite signal. S-Video, with separated
>         chroma and
>         > luma, can only be on vmux 5-9.
>         >
>         > NACKED-by: hermann pitton <hermann-pitton@arcor.de>
>         
>         
>         Jean-Michel,
>         
>         do you understand?
>         
>         You need to add the missing Composite inputs instead.
>         One of them can be Composite over the S-Video-in connector.
>         
>         Have a look at other cards in saa7134-cards.c.
>         
>         Cheers,
>         Hermann
>         
>         
> 

