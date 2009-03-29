Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:57892 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbZC2TgK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 15:36:10 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] saa7134: Add analog RF tuner support for Avermedia A700 DVB-S Hybrid+FM card
Date: Sun, 29 Mar 2009 20:36:02 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	panagonov <panagonov@mail.bg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_j28zJRDzlnBWKCh"
Message-Id: <200903292136.03369.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_j28zJRDzlnBWKCh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi list!

The attached patch enables the XC2028 analog tuner used on the Avermedia A700 
DVB-S Hybrid+FM card.

Regards
Matthias

--Boundary-00=_j28zJRDzlnBWKCh
Content-Type: text/x-diff;
  charset="utf-8";
  name="avertv_a700_hybrid_rf_tuner.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="avertv_a700_hybrid_rf_tuner.diff"

saa7134: add analog RF tuner support for Avermedia A700 DVB-S Hybrid+FM card

Thanks to panagonov <panagonov@mail.bg> for requesting support and testing patches.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4546,12 +4546,17 @@ struct saa7134_board saa7134_boards[] = 
 		/* Matthias Schwarzott <zzam@gentoo.org> */
 		.name           = "Avermedia DVB-S Hybrid+FM A700",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_ABSENT, /* TUNER_XC2028 */
+		.tuner_type     = TUNER_XC2028,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs         = { {
+			.name   = name_tv,
+			.vmux   = 4,
+			.amux   = TV,
+			.tv     = 1,
+		}, {
 			.name = name_comp,
 			.vmux = 1,
 			.amux = LINE1,
@@ -4560,6 +4565,10 @@ struct saa7134_board saa7134_boards[] = 
 			.vmux = 6,
 			.amux = LINE1,
 		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+		},
 	},
 	[SAA7134_BOARD_BEHOLD_H6] = {
 		/* Igor Kuznetsov <igk@igk.ru> */
@@ -5989,6 +5998,11 @@ static int saa7134_xc2028_callback(struc
 			msleep(10);
 			saa7134_set_gpio(dev, 21, 1);
 		break;
+		case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
+			saa7134_set_gpio(dev, 18, 0);
+			msleep(10);
+			saa7134_set_gpio(dev, 18, 1);
+		break;
 		}
 	return 0;
 	}
@@ -6361,10 +6375,6 @@ int saa7134_board_init1(struct saa7134_d
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0c0007cd, 0x0c0007cd);
 		break;
 	case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
-		printk("%s: %s: hybrid analog/dvb card\n"
-		       "%s: Sorry, of the analog inputs, only analog s-video and composite "
-		       "are supported for now.\n",
-			dev->name, card(dev).name, dev->name);
 	case SAA7134_BOARD_AVERMEDIA_A700_PRO:
 		/* write windows gpio values */
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x80040100, 0x80040100);
@@ -6428,6 +6438,7 @@ static void saa7134_tuner_setup(struct s
 		case SAA7134_BOARD_AVERMEDIA_A16D:
 		case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 		case SAA7134_BOARD_AVERMEDIA_M103:
+		case SAA7134_BOARD_AVERMEDIA_A700_HYBRID:
 			ctl.demod = XC3028_FE_ZARLINK456;
 			break;
 		default:

--Boundary-00=_j28zJRDzlnBWKCh--
