Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1K0k1K-0001N7-PK
	for linux-dvb@linuxtv.org; Mon, 26 May 2008 23:14:19 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org
Date: Mon, 26 May 2008 23:13:42 +0200
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GgyOIbtb43vnkOU"
Message-Id: <200805262313.42843.zzam@gentoo.org>
Subject: [linux-dvb] [PATCH] Add Analog RF Tuner support for Avermedia
	Avertv A700 Hybrid+FM DVB-S
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_GgyOIbtb43vnkOU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi there!

This is an untested patch to add support for the Analog RF Tuner for the 
Avermedia Avertv A700 Hybrid+FM DVB-S card.

It is currently untested.

Regards
Matthias

--Boundary-00=_GgyOIbtb43vnkOU
Content-Type: text/x-diff;
  charset="utf-8";
  name="avertv_a700_hybrid_rf_tuner.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="avertv_a700_hybrid_rf_tuner.diff"

saa7134: add analog RF tuner support for Avermedia A700 DVB-S Hybrid+FM

This patch adds support for the RF tuner input on the
Avermedia A700 DVB-S Hybrid+FM card.
It is currently untested.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>

Index: v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
===================================================================
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-cards.c
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-cards.c
@@ -4277,13 +4277,18 @@ struct saa7134_board saa7134_boards[] = 
 		/* Matthias Schwarzott <zzam@gentoo.org> */
 		.name           = "Avermedia DVB-S Hybrid+FM A700",
 		.audio_clock    = 0x00187de7,
-		.tuner_type     = TUNER_ABSENT, /* TUNER_XC2028 */
+		.tuner_type     = TUNER_XC2028,
 		.radio_type     = UNSET,
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		/* no DVB support for now */
 		/* .mpeg           = SAA7134_MPEG_DVB, */
 		.inputs         = { {
+			.name = name_tv,
+			.vmux = 3, /* untested */
+			.amux = TV,
+			.tv   = 1,
+		}, {
 			.name = name_comp,
 			.vmux = 1,
 			.amux = LINE1,
@@ -4292,6 +4297,10 @@ struct saa7134_board saa7134_boards[] = 
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

--Boundary-00=_GgyOIbtb43vnkOU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_GgyOIbtb43vnkOU--
