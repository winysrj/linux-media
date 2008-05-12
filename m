Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CKXkq4020486
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 16:33:46 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CKXYE6031098
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 16:33:34 -0400
Message-ID: <4828A99B.8020802@users.sourceforge.net>
Date: Mon, 12 May 2008 22:33:31 +0200
From: =?ISO-8859-1?Q?Andr=E9_AUZI?= <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: PATCH: Add support for ITEMS ITV-301 PCI Stereo TV Tuner [1/2]
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

Hi list,

please find here below the first patch (video/radio integration) for  
the support of  the card mentioned.

Remote control support will follow.

Regards,
Andre

# HG changeset patch
# User Andre Auzi <aauzi@users.sourceforge.net>
# Date 1210622939 -7200
# Node ID 73ccafbb571a2678f115635339e540a97c301e5f
# Parent  d876384888805da67d5cde770f8dd43bd269fad7
Add support for ITEMS ITV-301 PCI Stereo TV Tuner

From: Andre Auzi <aauzi@users.sourceforge.net>



Signed-off-by: Andre Auzi <aauzi@users.sourceforge.net>

diff -r d87638488880 -r 73ccafbb571a 
linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134  Thu May 01 
03:23:23 2008 -0400
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134  Mon May 12 
22:08:59 2008 +0200
@@ -141,3 +141,4 @@ 140 -> Avermedia DVB-S Pro A700        
 140 -> Avermedia DVB-S Pro A700                 [1461:a7a1]
 141 -> Avermedia DVB-S Hybrid+FM A700           [1461:a7a2]
 142 -> Beholder BeholdTV H6                     [5ace:6290]
+143 -> Items ITV-301 PCI Stereo TV Tuner
diff -r d87638488880 -r 73ccafbb571a 
linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c Thu May 01 
03:23:23 2008 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Mon May 12 
22:08:59 2008 +0200
@@ -4322,6 +4322,86 @@ struct saa7134_board saa7134_boards[] =
                },
                /* no DVB support for now */
                /* .mpeg           = SAA7134_MPEG_DVB, */
+       },
+       [SAA7134_BOARD_ITEMS_ITV301] = {
+               /* Andre Auzi <aauzi@users.sourceforge.net>
+                *
+                * INPUTS:
+                * vmux = 0, S-video input (from ATI 9250 PAL 800x600 
tv-out)
+                *           poor color quality
+                * vmux = 1, composite input, OK
+                *           tested with PAL DVD and SECAM VHS
+                * vmux = 2, S-video input, no synchronization
+                * vmux = 3, TV tuner, OK - tested in SECAM (france)
+                * vmux = 4, FM radio tuner, OK
+                * vmux = 5, no video signal
+                * vmux = 6, S-video input (from ATI 9250 PAL 800x600 
tv-out)
+                *           OK
+                * vmux = 7, no video signal
+                * vmux = 8, S-video input (from ATI 9250 PAL 800x600 
tv-out)
+                *           OK
+                *
+                * amux = LINE2, tuner stereo input, OK
+                * amux = LINE1, jack stereo input, OK
+                *
+                * GPIO:
+                * bits[8-12] IR key code value (mask: 0x1F00)
+                * bit14 IR key pressed, active low (mask: 0x4000)
+                * bit15 (output) when set to zero, enables bit14's key 
pressed
+                * status and auto repeat (gpiomask: 0x8000)
+                *
+                * alsa mixing OK
+                * teletext not tested
+                *
+                * I2C-SCAN:
+                * saa7130/34: v4l2 driver version 0.2.14 loaded
+                * saa7133[0]: found at 0000:04:08.0,
+                *             rev: 209, irq: 16, latency: 32, mmio: 
0xfdbfe000
+                * saa7133[0]: subsystem: 1131:0000,
+                *             board: Items ITV-301 PCI Stereo TV Tuner
+                *             [card=143,insmod option]
+                * saa7133[0]: board init: gpio is 4c04c00
+                * tuner' 2-0043: chip found @ 0x86 (saa7133[0])
+                * tda9887 2-0043: creating new instance
+                * tda9887 2-0043: tda988[5/6/7] found
+                * All bytes are equal. It is not a TEA5767
+                * tuner' 2-0060: chip found @ 0xc0 (saa7133[0])
+                * saa7133[0]: Huh, no eeprom present (err=-5)?
+                * saa7133[0]: i2c scan: found device @ 0x86  [tda9887]
+                * saa7133[0]: i2c scan: found device @ 0xc0  [tuner 
(analog)]
+                * tuner-simple 2-0060: creating new instance
+                * tuner-simple 2-0060: type set to 38
+                *                      (Philips PAL/SECAM multi 
(FM1216ME MK3))
+                * saa7133[0]: registered device video0 [v4l2]
+                * saa7133[0]: registered device vbi0
+                * saa7133[0]: registered device radio0
+I               */
+               .name           = "Items ITV-301 PCI Stereo TV Tuner",
+               .audio_clock    = 0x00187de7,
+               .tuner_type     = TUNER_PHILIPS_FM1216ME_MK3,
+               .radio_type     = UNSET,
+               .tuner_addr     = ADDR_UNSET,
+               .radio_addr     = ADDR_UNSET,
+               .gpiomask       = 0x8000,
+               .inputs         = {{
+                       .name = name_tv,
+                       .vmux = 3,
+                       .amux = LINE2,
+                       .tv   = 1,
+               }, {
+                       .name = name_comp1,
+                       .vmux = 1,
+                       .amux = LINE1,
+               }, {
+                       .name = name_svideo,
+                       .vmux = 6,
+                       .amux = LINE1,
+               } },
+               .radio = {
+                       .name = name_radio,
+                       .vmux = 4,
+                       .amux = LINE2,
+               },
        },
 };
 
diff -r d87638488880 -r 73ccafbb571a 
linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h       Thu May 01 
03:23:23 2008 -0400
+++ b/linux/drivers/media/video/saa7134/saa7134.h       Mon May 12 
22:08:59 2008 +0200
@@ -271,6 +271,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
 #define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 #define SAA7134_BOARD_BEHOLD_H6      142
+#define SAA7134_BOARD_ITEMS_ITV301        143
 
 
 #define SAA7134_MAXBOARDS 8

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
