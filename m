Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:50617 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762Ab0GHWw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Jul 2010 18:52:29 -0400
Subject: Re: [PATCH] Terratec Cinergy 250 PCI support
From: hermann pitton <hermann-pitton@arcor.de>
To: Jean-Michel Grimaldi <jm@via.ecp.fr>
Cc: linux-media@vger.kernel.org
In-Reply-To: <AANLkTik-IcqUJz7KTxNvyAeQbPuBg-72a0NSI8-VMT12@mail.gmail.com>
References: <AANLkTim5-Cc-ijE1U7M1DWSF8hcj8svSH30a0YVM4qv9@mail.gmail.com>
	 <1277423038.4742.9.camel@pc07.localdom.local>
	 <1277503171.6256.7.camel@pc07.localdom.local>
	 <AANLkTikfcq_MFrz1jnxorZKmHUq9pDrx0aEluXfGfc5a@mail.gmail.com>
	 <1278033399.3147.1.camel@pc07.localdom.local>
	 <AANLkTik-IcqUJz7KTxNvyAeQbPuBg-72a0NSI8-VMT12@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-pmlHhy6WwoPwQ+OGbX0t"
Date: Fri, 09 Jul 2010 00:45:01 +0200
Message-Id: <1278629101.6103.67.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-pmlHhy6WwoPwQ+OGbX0t
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Jean-Michel,

Am Sonntag, den 04.07.2010, 19:03 +0200 schrieb Jean-Michel Grimaldi:
> Thanks Hermann,
> 
> Yes my card is 153b:1160 in dmesg. After testing, the right audio is
> actually LINE2 rather than LINE1 (it did not make any difference for
> me since I did not use the audio on this card). Hence the following
> patch does the job for my card:

sorry for the delay.

Ah, indeed the same PCI subsystem on yours.

Looks like the documentation of the card variants needs improvement.

On the low profile one at the bttv-gallery the chips for digital TV are
not soldered, it has the huge brown 7.5MHz radio IF filter, the yellow
input connector seems to be for radio RF antenna input. 
Especially to be noted, it has a KS008 for i2c IR.

But that fuzzy picture on the package there shows the same card as on
your second link. It has extra connectors for audio in and out. (blue
and green)

Like on your card on your first link, 250 PCI Ver.1.0, the KS008 is
missing, the digital TV chips are present, the huge radio IF ceramic
filter is gone and likely replaced by some SMD part, since analog radio
support is still announced, but you don't have the blue and green audio
connectors.

Thanks for testing also the audio input.
Your result is conform to the .inf file in the bttv-gallery.

Is external audio-in over a "break out" cable together with S-Video?
Is the yellow input for the radio RF antenna or Composite?
The vmux 3 is typically used for an extra Composite input whereas vmux 0
is in most cases Composite over the S-Video connector.

Please post also all "dmesg" related to the card for the record and in
case we should need it in the future.

BTW, the recent Cinergy HT PCI is cx88x based and comes with a Composite
to S-Video adapter.
http://www.terratec.net/de/produkte/bilder/produkt_bilder_de_4387.html

But for the connectivity they show the HT PCI with saa7131e ...
and point to the yellow input from VCR/DVD/etc.

> --- saa7134-cards.old.c    2010-07-04 18:50:13.000000000 +0200
> +++ saa7134-cards.new.c    2010-07-04 18:17:54.000000000 +0200
> @@ -2832,6 +2832,10 @@
>              .amux = TV,
>              .tv   = 1,
>          },{
> +            .name = name_comp1,
> +            .vmux = 3,
> +            .amux = LINE2,
> +        },{
>              .name = name_svideo,  /* NOT tested */
>              .vmux = 8,
>              .amux = LINE1,
> 
> I did not touch the existing sections in case another variation of the
> card worked with them.
> Is this patch ok now?
> Regards,
> 
> Jean-Michel

Yes, looks at least much better.
We can change the amux of svideo to LINE2 too.

In the attached version of your patch against mercurial v4l-dvb I do
this and sign off for it.

Please reply with your SOB for adding and testing the Composite input
and put it above my "reviewed by" and the patch should be ready for
lift-off now.

Thanks for working on it,
Hermann

patch is attached

saa7134: add the Composite input on Cinergy 250 PCI and fix related amux

This was untested until now and the changes are also conform to the
.inf file of the Philips driver. We change the amux for S-Video
accordingly too. There are slightly different variants of the card
not yet fully investigated.

Priority: normal



Reviewed-by: hermann pitton <hermann-pitton@arcor.de>
Signed-off-by: hermann pitton <hermann-pitton@arcor.de>


> 2010/7/2 hermann pitton <hermann-pitton@arcor.de>
>         Hi Jean-Michel,
>         
>         Am Mittwoch, den 30.06.2010, 00:02 +0200 schrieb Jean-Michel
>         Grimaldi:
>         > Hi Hermann,
>         >
>         > Thanks for your answer. Do you mean I should add an entry
>         with .name =
>         > name_comp1, .vmux = 3, .amux = LINE1 ?
>         >
>         > Should I remove the svideo entry, given that the card (which
>         can be
>         > seen at [1]) only has a (proprietary) composite jack?
>         However there
>         > seems to exist another card with the same name "Terratec
>         Cinergy 250
>         > PCI" but different connectors : [2]
>         >
>         > What do you think? Should I just add a composite entry and
>         leave the
>         > svideo as it is?
>         >
>         > Jean-Michel
>         >
>         > [1] http://www.arminformatique.fr/images/TerraTec%20Cinergy%
>         20250%
>         > 20PCI.jpg
>         > [2] http://www.notebookland.hu/shop
>         > +TERRATEC-CINERGY-250-PCI-TERRATEC-TV-tuner_29849_49
>         
>         
>         
>         
>         there is also a low profile PCI card.
>         
>         http://www.terratec.net/de/produkte/bilder/img/2195346_5f78fcd0d7.png
>         http://www.terratec.net/de/produkte/bilder/produkt_bilder_de_4387.html
>         
>         Without any such device in my possession and without
>         sufficient testing
>         and reports, hard to tell.
>         
>         Do you have the known subsystem 153b:1160 ?
>         
>         For that one from http://www.bttv-gallery.de
>         
>         chips: saa7131e, KS008, 8275ac1
>         pcb: TV-7131 Ver:B
>         0000:00:0b.0 Multimedia controller: Philips Semiconductors
>         SAA7133 Audio+video broadcast decoder (rev d0)
>                Subsystem: TERRATEC Electronic GmbH: Unknown device
>         1160
>         saa7130/34: v4l2 driver version 0.2.14 loaded
>         ACPI: PCI interrupt 0000:00:0b.0[A] -> GSI 19 (level, low) ->
>         IRQ 19
>         saa7133[0]: found at 0000:00:0b.0, rev: 208, irq: 19, latency:
>         32, mmio: 0xdfffb800
>         saa7133[0]: subsystem: 153b:1160, board: UNKNOWN/GENERIC
>         [card=0,autodetected]
>         saa7133[0]: board init: gpio is 40
>         saa7133[0]: i2c eeprom 00: 3b 15 60 11 54 20 1c 00 43 43 a9 1c
>         55 d2 b2 92
>         saa7133[0]: i2c eeprom 10: 00 00 20 00 ff 20 ff ff ff ff ff ff
>         ff ff ff ff
>         saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 01 00 9c
>         ff ff ff ff
>         saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff
>         ff ff ff ff
>         saa7133[0]: i2c eeprom 40: ff 22 00 c2 96 00 01 30 ff ff ff ff
>         ff ff ff ff
>         saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff
>         ff ff ff ff
>         saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff
>         ff ff ff ff
>         saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff
>         ff ff ff ff
>         
>         from INF:
>         ; History:
>         ; 16-Sep-04 FMB 1st version
>         ; 24-Sep-04 FMB changed name from "Cinergy 250 TV" to "Cinergy
>         250 PCI"
>         ...
>         ; 13-Apr-05 FMB v.1.3.2.2 - added option for forced hardware
>         configuration
>         ; 09-May-05 FMB v.1.3.2.0 - added KW driver (modified for IR)
>         ; 24-May-05 FMB v.1.3.2.0 - added registry entry for GPIO
>         config
>         [TerraTec]
>         ; Cinergy 250 PCI (SAA7134)
>         %Cinergy.DeviceDesc%=3xHybrid,PCI
>         \VEN_1131&DEV_7134&SUBSYS_1160153B
>         ; Cinergy 250 PCI (SAA7135)
>         %Cinergy.DeviceDesc%=3xHybrid,PCI
>         \VEN_1131&DEV_7133&SUBSYS_1160153B
>         ...
>         ; Customization
>         ; Setting FM radio of the Silicon tuner via SIF (GPIO 21 in
>         use/ 5.5MHz)
>         HKR, "Audio", "FM Radio IF",0x00010001,0x729555
>         [ForceHWConfig.AddReg]
>         HKR, "I2C Devices", "Force Registry Settings",0x00010001,1
>         
>         HKR, "AudioDecoder", "Tuner Channel"   ,0x00010001,1
>         HKR, "AudioDecoder", "CVBS Channel"    ,0x00010001,3
>         HKR, "AudioDecoder", "SVHS Channel"    ,0x00010001,3
>         HKR, "AudioDecoder", "FM Radio Channel",0x00010001,1
>         
>         ; maps user setting to hardware video input
>         HKR, "VideoDecoder", "Tuner Channel"   ,0x00010001,1
>         HKR, "VideoDecoder", "CVBS Channel"    ,0x00010001,3
>         HKR, "VideoDecoder", "SVHS Channel"    ,0x00010001,8
>         HKR, "VideoDecoder", "FM Radio Channel",0x00010001,1
>         
>         ; Set GPIOs to output, required for TV/Radio switching
>         HKR, "GPIO", "Config", 0x00010001, 0xffffffff
>         
>         ; I2C Device settings
>         HKR, "I2C Devices", "Number of I2C Devices",0x00010001,1
>         
>         ; FMB NOTE: old prototype with TDA8275
>         ;HKR, "I2C Devices", "Device 0,
>         Data1",0x00010001,0x14,0x00,0x00,0x00              ; Tuner ID
>         ; FMB NOTE: new prototype with TDA8275A
>         HKR, "I2C Devices", "Device 0,
>         Data1",0x00010001,0x22,0x00,0x00,0x00               ; Tuner ID
>         HKR, "I2C Devices", "Device 0,
>         Data3",0x00010001,0x96,0x00,0x00,0x00               ; Tuner IF
>         PLL slave addr.
>         Cinergy.DeviceDesc  = "Cinergy 250 PCI Capture" ; Device
>         Manager strings
>         
>         For that one, Composite vmux = 3, S-Video vmux=8, for both
>         amux = LINE2
>         and it has analog FM radio support.
>         
>         For my experience, if we can't auto detect any difference
>         between those,
>         to treat such cards as the same until some difference shows
>         up, is still
>         a way to go. Hm, seems some are without radio support.
>         
>         If our auto detection fails, more hidden methods as PCI
>         subsystem IDs or
>         eeprom contents might be in use to identfy OEM stuff these
>         days like
>         undocumented checksums, then we can at least identify
>         different devices
>         physically and can disable our failing auto detection and
>         point to card
>         numbers.
>         
>         A S-Video connector has only four pins, but we find regularly
>         so called
>         break out connectors there, which can cover all sort of in-
>         and outputs.
>         
>         Cards can look extremely different, not only concerning
>         connectors, but
>         might be still functional in the same for the inputs. There
>         are a lot of
>         examples.
>         
>         On some cards the yellow input connector is used for the radio
>         antenna
>         RF input and changing to a low profile regularly calls for
>         smaller
>         connectors too.
>         
>         The opposite can be true of course too and much did change ...
>         
>         In best case, they do have a different PCI subsystem then, if
>         not and
>         much worse, maybe we can still figure out some difference from
>         the
>         eeprom content. Worst case, we don't know how to make any
>         difference and
>         the OEM does not follow Philips recommendations for the eeprom
>         content
>         and uses some proprietary methods to detect the cards.
>         
>         Cheers,
>         Hermann
>         
>         >
>         
>         
>         > 2010/6/25 hermann pitton <hermann-pitton@arcor.de>
>         >
>         >         Am Freitag, den 25.06.2010, 01:43 +0200 schrieb
>         hermann
>         >         pitton:
>         >
>         >         > Hi, Jean-Michel,
>         >         >
>         >         > Am Freitag, den 25.06.2010, 00:42 +0200 schrieb
>         Jean-Michel
>         >         Grimaldi:
>         >         > > Hi, I have a Terratec Cinergy 250 PCI video
>         card, and a
>         >         small
>         >         > > modification in saa7134-cards.c is needed for it
>         to work.
>         >         I built the
>         >         > > patch on 2.6.34 version (I sent the modification
>         to the
>         >         maintainer in
>         >         > > early 2009 but got no feedback):
>         >         > >
>         >         > > -- saa7134-cards.old.c      2010-06-25
>         00:31:16.000000000
>         >         +0200
>         >         > > +++ saa7134-cards.new.c     2010-06-25
>         00:30:52.000000000
>         >         +0200
>         >         > > @@ -2833,7 +2833,7 @@
>         >         > >                     .tv   = 1,
>         >         > >             },{
>         >         > >                     .name = name_svideo,  /* NOT
>         tested */
>         >         > > -                   .vmux = 8,
>         >         > > +                   .vmux = 3,
>         >         > >                     .amux = LINE1,
>         >         > >             }},
>         >         > >             .radio = {
>         >         > >
>         >         > > Thanks for taking it into account in future
>         kernels.
>         >         > >
>         >         >
>         >         > hm, don't know who missed it. After Gerd, the main
>         mover on
>         >         saa7134 was
>         >         > Hartmut, also /me and some well known others
>         cared.
>         >         >
>         >         > Official maintainer these days is Mauro.
>         >         >
>         >         > For latest DVB stuff, you also will meet Mike
>         Krufky.
>         >         >
>         >         > I'm sorry, but your patch is still wrong.
>         >         >
>         >         > You do have only a Composite signal. S-Video, with
>         separated
>         >         chroma and
>         >         > luma, can only be on vmux 5-9.
>         >         >
>         >         > NACKED-by: hermann pitton
>         <hermann-pitton@arcor.de>
>         >
>         >
>         >         Jean-Michel,
>         >
>         >         do you understand?
>         >
>         >         You need to add the missing Composite inputs
>         instead.
>         >         One of them can be Composite over the S-Video-in
>         connector.
>         >
>         >         Have a look at other cards in saa7134-cards.c.
>         >
>         >         Cheers,
>         >         Hermann
>         >
>         >
>         >
>         
>         
> 

--=-pmlHhy6WwoPwQ+OGbX0t
Content-Description: 
Content-Disposition: inline; filename*0=saa7134_cinergy-250-pci_add_composite-input_and_fix_amux.patc; filename*1=h
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 9652f85e688a linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu May 27 02:02:09 2010 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Jul 08 22:15:56 2010 +0200
@@ -2831,11 +2831,15 @@
 			.vmux = 1,
 			.amux = TV,
 			.tv   = 1,
-		},{
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE2,
+		}, {
 			.name = name_svideo,  /* NOT tested */
 			.vmux = 8,
-			.amux = LINE1,
-		}},
+			.amux = LINE2,
+		} },
 		.radio = {
 			.name   = name_radio,
 			.amux   = TV,

--=-pmlHhy6WwoPwQ+OGbX0t--

