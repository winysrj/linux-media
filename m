Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5F1smYw021760
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 21:54:48 -0400
Received: from mail-in-06.arcor-online.net (mail-in-06.arcor-online.net
	[151.189.21.46])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5F1sXH2017768
	for <video4linux-list@redhat.com>; Sat, 14 Jun 2008 21:54:34 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Bozhan Boiadzhiev <bozhan@abv.bg>
In-Reply-To: <2100460850.64345.1213476240157.JavaMail.apache@mail73.abv.bg>
References: <2100460850.64345.1213476240157.JavaMail.apache@mail73.abv.bg>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 03:53:14 +0200
Message-Id: <1213494794.3072.25.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Mauro Carvalho Chehab <mechehab@infradead.org>
Subject: Re: [linux-dvb] ASUS My-Cinema remote patch
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

Hi Bozhan,

Am Samstag, den 14.06.2008, 23:44 +0300 schrieb Bozhan Boiadzhiev: 
> ASUS My-Cinema package include remote 
> here i found patch for 2.6.22  https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/141622
> Please include it!
> All ASUS My-Cinema comes with remote control.
> Thanks.
> 

the video4linux-list is the better place for analog only cards.

The problem is known, but we had no testers.

The old Asus TVFM35 is not identical to your card.

It seems to have different s-video and composite inputs and also came
with an USB remote. Adding a new, on the old card not present remote now
there, seems to be confusing for the users.

The new tuner type tda8275a is auto detected, that makes the old entry
working for you. It has the previous tda8275 not "a".

The problem is the unchanged PCI subsystem on your card, which causes
that it is autodetected as card=53.

The following untested patch is a first try to detect your card and add
a separate entry for it. We discussed this once.

Cheers,
Hermann

diff -r 2a89445f3b24 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c Tue Jun 10 11:22:00 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Jun 15 01:55:38 2008 +0200
@@ -4401,6 +4401,39 @@ struct saa7134_board saa7134_boards[] =
                },
                /* no DVB support for now */
                /* .mpeg           = SAA7134_MPEG_DVB, */
+       },
+       [SAA7134_BOARD_ASUSTeK_P7131_ANALOG] = {
+               .name           = "ASUSTeK P7131 Analog",
+               .audio_clock    = 0x00187de7,
+               .tuner_type     = TUNER_PHILIPS_TDA8290,
+               .radio_type     = UNSET,
+               .tuner_addr     = ADDR_UNSET,
+               .radio_addr     = ADDR_UNSET,
+               .gpiomask       = 1 << 21,
+               .inputs         = {{
+                       .name = name_tv,
+                       .vmux = 1,
+                       .amux = TV,
+                       .tv   = 1,
+                       .gpio = 0x0000000,
+               }, {
+                       .name = name_comp1,
+                       .vmux = 3,
+                       .amux = LINE2,
+               }, {
+                       .name = name_comp2,
+                       .vmux = 0,
+                       .amux = LINE2,
+               }, {
+                       .name = name_svideo,
+                       .vmux = 8,
+                       .amux = LINE2,
+               } },
+               .radio = {
+                       .name = name_radio,
+                       .amux = TV,
+                       .gpio = 0x0200000,
+               },
        },
 };

@@ -5679,6 +5712,7 @@ int saa7134_board_init1(struct saa7134_d
        case SAA7134_BOARD_FLYDVBT_LR301:
        case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
        case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+       case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
        case SAA7134_BOARD_FLYDVBTDUO:
        case SAA7134_BOARD_PROTEUS_2309:
        case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -6005,6 +6039,15 @@ int saa7134_board_init2(struct saa7134_d
                i2c_transfer(&dev->i2c_adap, &msg, 1);
                break;
        }
+       case SAA7134_BOARD_ASUSTeK_TVFM7135:
+       /* The card is misdetected as card=53, but is different */
+               if(dev->autodetected && (dev->eedata[0x27] == 0x03)) {
+                       dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
+                       printk(KERN_INFO "%s: P7131 analog only using "
+                                                       "entry of %s\n",
+                       dev->name, saa7134_boards[dev->board].name);
+               }
+               break;
        case SAA7134_BOARD_HAUPPAUGE_HVR1110:
                hauppauge_eeprom(dev, dev->eedata+0x80);
                /* break intentionally omitted */
diff -r 2a89445f3b24 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c Tue Jun 10 11:22:00 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c Sun Jun 15 01:55:38 2008 +0200
@@ -400,6 +400,7 @@ int saa7134_input_init1(struct saa7134_d
                break;
        case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
        case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+       case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
                ir_codes     = ir_codes_asus_pc39;
                mask_keydown = 0x0040000;
                rc5_gpio = 1;
diff -r 2a89445f3b24 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h       Tue Jun 10 11:22:00 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h       Sun Jun 15 01:55:38 2008 +0200
@@ -273,6 +273,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_H6      142
 #define SAA7134_BOARD_BEHOLD_M63      143
 #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
+#define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 145

 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
