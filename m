Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8R4jnkI029672
	for <video4linux-list@redhat.com>; Sat, 27 Sep 2008 00:45:49 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8R4jSsc001653
	for <video4linux-list@redhat.com>; Sat, 27 Sep 2008 00:45:34 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: dabby bentam <db260179@hotmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <BLU116-W13E3E5DA492C7A08D36C3FC2470@phx.gbl>
References: <BLU116-W13E3E5DA492C7A08D36C3FC2470@phx.gbl>
Content-Type: multipart/mixed; boundary="=-ouVoJZx9pOGF3SuZOhvr"
Date: Sat, 27 Sep 2008 06:39:54 +0200
Message-Id: <1222490394.2668.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] saa7134: add support for Tv(working
	config), radio and analog audio in on the Hauppauge HVR-1110
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


--=-ouVoJZx9pOGF3SuZOhvr
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Am Freitag, den 26.09.2008, 22:13 +0000 schrieb dabby bentam:
> This patch fixes the Analog TV tuning issue and adds support of the Radio feature.
> 
> It resolves the S-Video and Composite Audio In - FIXME (sound redirect still required via sox etc)
> 
> [   30.263288] saa7133[0]: subsystem: 0070:6701, board: Hauppauge WinTV-HVR1110 DVB-T/Hybrid [card=104,autodetected]
> [   30.263297] saa7133[0]: board init: gpio is 6400000
> [   30.384637] input: HVR 1110 as /devices/virtual/input/input6
> [   30.427939] ir-kbd-i2c: HVR 1110 detected at i2c-2/2-0071/ir0 [saa7133[0]]
> [   30.474512] saa7133[0]: i2c eeprom 00: 70 00 01 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [   30.474521] saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
> [   30.474527] saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 aa ff ff ff ff
> [   30.474532] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [   30.474537] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 15 60 ff ff ff ff ff ff
> [   30.474542] saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   30.474547] saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   30.474552] saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   30.474557] saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 b0 16 35 f0 73 05 29 00
> [   30.474562] saa7133[0]: i2c eeprom 90: 84 08 00 06 cb 05 01 00 94 48 89 72 07 70 73 09
> [   30.474568] saa7133[0]: i2c eeprom a0: 23 5f 73 0a fc 72 72 0b 2f 72 0e 01 72 0f 03 72
> [   30.474573] saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 79 43 00 00 00 00 00 00 00 00 00
> [   30.474578] saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   30.474583] saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   30.474588] saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   30.474593] saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   30.474602] tveeprom 2-0050: Hauppauge model 67019, rev B4B4, serial# 3479216
> [   30.474605] tveeprom 2-0050: MAC address is 00-0D-FE-35-16-B0
> [   30.474607] tveeprom 2-0050: tuner model is Philips 8275A (idx 114, type 4)
> [   30.474609] tveeprom 2-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
> [   30.474612] tveeprom 2-0050: audio processor is SAA7131 (idx 41)
> [   30.474614] tveeprom 2-0050: decoder processor is SAA7131 (idx 35)
> [   30.474616] tveeprom 2-0050: has radio, has IR receiver, has IR transmitter
> [   30.474618] saa7133[0]: hauppauge eeprom: model=67019
> [   31.047409] tuner 2-004b: chip found @ 0x96 (saa7133[0])
> [   31.090707] tda8290 2-004b: setting tuner address to 61
> [   31.183556] tuner 2-004b: type set to tda8290+75a
> [   31.226853] tda8290 2-004b: setting tuner address to 61
> [   31.320122] tuner 2-004b: type set to tda8290+75a
> [   31.322302] saa7133[0]: registered device video0 [v4l2]
> [   31.322321] saa7133[0]: registered device vbi0
> [   31.322336] saa7133[0]: registered device radio0
> [   31.323774] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 22
> [   31.323777] ACPI: PCI Interrupt 0000:00:05.0[B] -> Link [AAZA] -> GSI 22 (level, low) -> IRQ 22
> [   31.323995] PCI: Setting latency timer of device 0000:00:05.0 to 64
> [   31.556834] saa7134 ALSA driver for DMA sound loaded
> [   31.556868] saa7133[0]/alsa: saa7133[0] at 0xfb010000 irq 16 registered as card -2
> [   32.040025] DVB: registering new adapter (saa7133[0])
> [   32.040031] DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
> [   32.099943] tda1004x: setting up plls for 48MHz sampling clock
> [   32.356492] tda1004x: found firmware revision 20 -- ok
> 
> 
> Signed-off-by: dabby bentam 

Mauro,

wait a little.

We likely will have a tested-by from Thomas, the original contributor of
that card, soon too.

So far.

Reviewed-by: Hermann Pitton <hermann-pitton@arcor.de>

Cheers,
Hermann


--=-ouVoJZx9pOGF3SuZOhvr
Content-Disposition: attachment; filename=hvr-1110-out.patch
Content-Type: text/x-patch; name=hvr-1110-out.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

diff -r aa3e5cc1d833 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Wed Sep 24 10:00:37 2008 +0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Fri Sep 26 22:31:08 2008 +0100
@@ -3299,6 +3299,7 @@
 	},
 	[SAA7134_BOARD_HAUPPAUGE_HVR1110] = {
 		/* Thomas Genty <tomlohave@gmail.com> */
+                /* David Bentham <db260179@hotmail.com> */
 		.name           = "Hauppauge WinTV-HVR1110 DVB-T/Hybrid",
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_PHILIPS_TDA8290,
@@ -3307,23 +3308,26 @@
 		.radio_addr     = ADDR_UNSET,
 		.tuner_config   = 1,
 		.mpeg           = SAA7134_MPEG_DVB,
-		.inputs         = {{
-			.name = name_tv,
-			.vmux = 1,
-			.amux = TV,
-			.tv   = 1,
-		},{
-			.name   = name_comp1,
-			.vmux   = 3,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		},{
-			.name   = name_svideo,
-			.vmux   = 8,
-			.amux   = LINE2, /* FIXME: audio doesn't work on svideo/composite */
-		}},
-		.radio = {
-			.name = name_radio,
-			.amux   = TV,
+                .gpiomask       = 0x0200100,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+                        .gpio = 0x0000100,
+		}, {
+			.name   = name_comp1,
+			.vmux   = 3,
+			.amux   = LINE1, 
+		}, {
+			.name   = name_svideo,
+			.vmux   = 8,
+			.amux   = LINE1, 
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux   = TV,
+                        .gpio = 0x0200100,
 		},
 	},
 	[SAA7134_BOARD_CINERGY_HT_PCMCIA] = {

--=-ouVoJZx9pOGF3SuZOhvr
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-ouVoJZx9pOGF3SuZOhvr--
