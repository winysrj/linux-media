Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5FKfZgU011397
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 16:41:35 -0400
Received: from mail-in-17.arcor-online.net (mail-in-17.arcor-online.net
	[151.189.21.57])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5FKf8YR010509
	for <video4linux-list@redhat.com>; Sun, 15 Jun 2008 16:41:09 -0400
Received: from mail-in-09-z2.arcor-online.net (mail-in-09-z2.arcor-online.net
	[151.189.8.21])
	by mail-in-17.arcor-online.net (Postfix) with ESMTP id 1E1732BCA2F
	for <video4linux-list@redhat.com>;
	Sun, 15 Jun 2008 22:41:08 +0200 (CEST)
Received: from mail-in-02.arcor-online.net (mail-in-02.arcor-online.net
	[151.189.21.42])
	by mail-in-09-z2.arcor-online.net (Postfix) with ESMTP id CB49A28EDDB
	for <video4linux-list@redhat.com>;
	Sun, 15 Jun 2008 22:41:07 +0200 (CEST)
Received: from [192.168.0.10] (181.126.46.212.adsl.ncore.de [212.46.126.181])
	(Authenticated sender: hermann-pitton@arcor.de)
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id EB05636E870
	for <video4linux-list@redhat.com>;
	Sun, 15 Jun 2008 22:41:06 +0200 (CEST)
From: hermann pitton <hermann-pitton@arcor.de>
To: video4linux-list@redhat.com
In-Reply-To: <1634623854.65471.1213524197148.JavaMail.apache@mail71.abv.bg>
References: <1634623854.65471.1213524197148.JavaMail.apache@mail71.abv.bg>
Content-Type: multipart/mixed; boundary="=-ympWdOqPnCEwZQnMkxa1"
Date: Sun, 15 Jun 2008 22:40:01 +0200
Message-Id: <1213562401.2683.80.camel@pc10.localdom.local>
Mime-Version: 1.0
Subject: Re: Re: [linux-dvb] ASUS My-Cinema remote patch
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


--=-ympWdOqPnCEwZQnMkxa1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Am Sonntag, den 15.06.2008, 13:03 +0300 schrieb Bozhan Boiadzhiev:
> 
> ok i'll test patch later.
> thanks
> :)

here is an updated version after latest changes by Matthias and Tim on
saa7134. Should work.

Can't do much more on it. 

Hartmut, Mauro, the eeprom detection is very basic, but should work. I
sign off so far. Also attached.

Cheers,
Hermann

saa7134: add a separate entry for the ASUSTeK P7131 analog only
         and do some eeprom detection to escape from the TVFM35
         with the same PCI subsystem on auto detection.

Signed-off-by: Hermann Pitton <hermann-pitton@arcor.de>

diff -r 78442352b885 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134  Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134  Sun Jun 15 22:25:29 2008 +0200
@@ -143,3 +143,4 @@ 142 -> Beholder BeholdTV H6
 142 -> Beholder BeholdTV H6                     [5ace:6290]
 143 -> Beholder BeholdTV M63                    [5ace:6191]
 144 -> Beholder BeholdTV M6 Extra               [5ace:6193]
+145 -> ASUSTeK P7131 Analog
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Jun 15 22:25:29 2008 +0200
@@ -4394,6 +4394,39 @@ struct saa7134_board saa7134_boards[] =
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

@@ -5671,6 +5704,7 @@ int saa7134_board_init1(struct saa7134_d
        case SAA7134_BOARD_FLYDVBT_LR301:
        case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
        case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+       case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
        case SAA7134_BOARD_FLYDVBTDUO:
        case SAA7134_BOARD_PROTEUS_2309:
        case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -6009,6 +6043,15 @@ int saa7134_board_init2(struct saa7134_d
                i2c_transfer(&dev->i2c_adap, &msg, 1);
                break;
        }
+       case SAA7134_BOARD_ASUSTeK_TVFM35:
+       /* The card below is detected as card=53, but is different */
+               if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
+                       dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
+                       printk(KERN_INFO "%s: P7131 analog only, using "
+                                                       "entry of %s\n",
+                       dev->name, saa7134_boards[dev->board].name);
+               }
+               break;
        case SAA7134_BOARD_HAUPPAUGE_HVR1110:
                hauppauge_eeprom(dev, dev->eedata+0x80);
                /* break intentionally omitted */
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c Sun Jun 15 22:25:29 2008 +0200
@@ -409,6 +409,7 @@ int saa7134_input_init1(struct saa7134_d
                break;
        case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
        case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+       case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
                ir_codes     = ir_codes_asus_pc39;
                mask_keydown = 0x0040000;
                rc5_gpio = 1;
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h       Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h       Sun Jun 15 22:25:29 2008 +0200
@@ -273,6 +273,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_H6      142
 #define SAA7134_BOARD_BEHOLD_M63      143
 #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
+#define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 145

 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8


>  >-------- Оригинално писмо --------
>  >От:  hermann pitton 
>  >Относно: Re: [linux-dvb] ASUS My-Cinema remote patch
>  >До: Bozhan Boiadzhiev 
>  >Изпратено на: Неделя, 2008, Юни 15 04:53:14 EEST
> 
>  >Hi Bozhan,
>  >
>  >Am Samstag, den 14.06.2008, 23:44 +0300 schrieb Bozhan Boiadzhiev: 
>  >> ASUS My-Cinema package include remote 
>  >> here i found patch for 2.6.22  https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/141622
>  >> Please include it!
>  >> All ASUS My-Cinema comes with remote control.
>  >> Thanks.
>  >> 
>  >
>  >the video4linux-list is the better place for analog only cards.
>  >
>  >The problem is known, but we had no testers.
>  >
>  >The old Asus TVFM35 is not identical to your card.
>  >
>  >It seems to have different s-video and composite inputs and also came
>  >with an USB remote. Adding a new, on the old card not present remote now
>  >there, seems to be confusing for the users.
>  >
>  >The new tuner type tda8275a is auto detected, that makes the old entry
>  >working for you. It has the previous tda8275 not "a".
>  >
>  >The problem is the unchanged PCI subsystem on your card, which causes
>  >that it is autodetected as card=53.
>  >
>  >The following untested patch is a first try to detect your card and add
>  >a separate entry for it. We discussed this once.
>  >
>  >Cheers,
>  >Hermann
>  >


--=-ympWdOqPnCEwZQnMkxa1
Content-Disposition: attachment; filename=saa7134_asus-p7131-analog_new.patch
Content-Type: text/x-patch; name=saa7134_asus-p7131-analog_new.patch;
	charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r 78442352b885 linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134	Sun Jun 15 22:08:34 2008 +0200
@@ -143,3 +143,4 @@ 142 -> Beholder BeholdTV H6             
 142 -> Beholder BeholdTV H6                     [5ace:6290]
 143 -> Beholder BeholdTV M63                    [5ace:6191]
 144 -> Beholder BeholdTV M6 Extra               [5ace:6193]
+145 -> ASUSTeK P7131 Analog
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Sun Jun 15 22:08:34 2008 +0200
@@ -4394,6 +4394,39 @@ struct saa7134_board saa7134_boards[] = 
 		},
 		/* no DVB support for now */
 		/* .mpeg           = SAA7134_MPEG_DVB, */
+	},
+	[SAA7134_BOARD_ASUSTeK_P7131_ANALOG] = {
+		.name           = "ASUSTeK P7131 Analog",
+		.audio_clock    = 0x00187de7,
+		.tuner_type     = TUNER_PHILIPS_TDA8290,
+		.radio_type     = UNSET,
+		.tuner_addr	= ADDR_UNSET,
+		.radio_addr	= ADDR_UNSET,
+		.gpiomask	= 1 << 21,
+		.inputs         = {{
+			.name = name_tv,
+			.vmux = 1,
+			.amux = TV,
+			.tv   = 1,
+			.gpio = 0x0000000,
+		}, {
+			.name = name_comp1,
+			.vmux = 3,
+			.amux = LINE2,
+		}, {
+			.name = name_comp2,
+			.vmux = 0,
+			.amux = LINE2,
+		}, {
+			.name = name_svideo,
+			.vmux = 8,
+			.amux = LINE2,
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x0200000,
+		},
 	},
 };
 
@@ -5671,6 +5704,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_FLYDVBT_LR301:
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_PROTEUS_2309:
 	case SAA7134_BOARD_AVERMEDIA_A16AR:
@@ -6009,6 +6043,15 @@ int saa7134_board_init2(struct saa7134_d
 		i2c_transfer(&dev->i2c_adap, &msg, 1);
 		break;
 	}
+	case SAA7134_BOARD_ASUSTeK_TVFM35:
+	/* The card below is detected as card=53, but is different */
+		if (dev->autodetected && (dev->eedata[0x27] == 0x03)) {
+			dev->board = SAA7134_BOARD_ASUSTeK_P7131_ANALOG;
+			printk(KERN_INFO "%s: P7131 analog only, using "
+							"entry of %s\n",
+			dev->name, saa7134_boards[dev->board].name);
+		}
+		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
 		hauppauge_eeprom(dev, dev->eedata+0x80);
 		/* break intentionally omitted */
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c	Sun Jun 15 22:08:34 2008 +0200
@@ -409,6 +409,7 @@ int saa7134_input_init1(struct saa7134_d
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
+	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 		ir_codes     = ir_codes_asus_pc39;
 		mask_keydown = 0x0040000;
 		rc5_gpio = 1;
diff -r 78442352b885 linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Sun Jun 15 10:33:42 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Sun Jun 15 22:08:34 2008 +0200
@@ -273,6 +273,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_BEHOLD_H6      142
 #define SAA7134_BOARD_BEHOLD_M63      143
 #define SAA7134_BOARD_BEHOLD_M6_EXTRA    144
+#define SAA7134_BOARD_ASUSTeK_P7131_ANALOG 145
 
 #define SAA7134_MAXBOARDS 8
 #define SAA7134_INPUT_MAX 8

--=-ympWdOqPnCEwZQnMkxa1
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
--=-ympWdOqPnCEwZQnMkxa1--
