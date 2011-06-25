Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43059 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571Ab1FYNYx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jun 2011 09:24:53 -0400
Received: by wwe5 with SMTP id 5so3589101wwe.1
        for <linux-media@vger.kernel.org>; Sat, 25 Jun 2011 06:24:52 -0700 (PDT)
Subject: [PATCH] Make Compro VideoMate Vista T750F actually work
To: linux-media@vger.kernel.org
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
Date: Sat, 25 Jun 2011 14:24:28 +0100
Message-ID: <20110625132421.18612.63063.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Based on the work of John Newbigin, Davor Emard and others who contributed
on the mailing lists.

The previous 'support' for this card was a partial merge of John's changes
that, as far as I can tell, never actually got the thing working (no DVB-T,
analog tuner not initialised).

Initialise the analog tuner properly and hook up the DVB tuner and demodulator.

DVB-T and analog now work (though I can't tune every DVB channel, but I think
there's an issue with the aerial and signal boosters here that is causing
me problems).

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
---
I've dropped remote control support for now - I need to re-review the original
patches in more detail and also differentiate between the T750 and T750F (I
know how to do this based on the eeprom, but that'll take some time to get
ready and getting the rest of the card working first is more important).

 drivers/media/video/saa7134/saa7134-cards.c |   13 ++++++++++++-
 drivers/media/video/saa7134/saa7134-dvb.c   |   25 +++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index e2062b2..0f9fb99 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -4951,8 +4951,9 @@ struct saa7134_board saa7134_boards[] = {
 		.audio_clock    = 0x00187de7,
 		.tuner_type     = TUNER_XC2028,
 		.radio_type     = UNSET,
-		.tuner_addr	= ADDR_UNSET,
+		.tuner_addr	= 0x61,
 		.radio_addr	= ADDR_UNSET,
+		.mpeg           = SAA7134_MPEG_DVB,
 		.inputs = {{
 			.name   = name_tv,
 			.vmux   = 3,
@@ -6992,6 +6993,11 @@ static int saa7134_xc2028_callback(struct saa7134_dev *dev,
 			msleep(10);
 			saa7134_set_gpio(dev, 18, 1);
 		break;
+		case SAA7134_BOARD_VIDEOMATE_T750:
+			saa7134_set_gpio(dev, 20, 0);
+			msleep(10);
+			saa7134_set_gpio(dev, 20, 1);
+		break;
 		}
 	return 0;
 	}
@@ -7451,6 +7457,11 @@ int saa7134_board_init1(struct saa7134_dev *dev)
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0e050000, 0x0c050000);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0e050000, 0x0c050000);
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		/* enable the analog tuner */
+		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+		break;
 	}
 	return 0;
 }
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 996a206..1e4ef16 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -56,6 +56,7 @@
 #include "lgs8gxx.h"
 
 #include "zl10353.h"
+#include "qt1010.h"
 
 #include "zl10036.h"
 #include "zl10039.h"
@@ -939,6 +940,18 @@ static struct zl10353_config behold_x7_config = {
 	.disable_i2c_gate_ctrl = 1,
 };
 
+static struct zl10353_config videomate_t750_zl10353_config = {
+	.demod_address         = 0x0f,
+	.no_tuner              = 1,
+	.parallel_ts           = 1,
+	.disable_i2c_gate_ctrl = 1,
+};
+
+static struct qt1010_config videomate_t750_qt1010_config = {
+	.i2c_address = 0x62
+};
+
+
 /* ==================================================================
  * tda10086 based DVB-S cards, helper functions
  */
@@ -1650,6 +1663,18 @@ static int dvb_init(struct saa7134_dev *dev)
 					__func__);
 
 		break;
+	case SAA7134_BOARD_VIDEOMATE_T750:
+		fe0->dvb.frontend = dvb_attach(zl10353_attach,
+						&videomate_t750_zl10353_config,
+						&dev->i2c_adap);
+		if (fe0->dvb.frontend != NULL) {
+			if (dvb_attach(qt1010_attach,
+					fe0->dvb.frontend,
+					&dev->i2c_adap,
+					&videomate_t750_qt1010_config) == NULL)
+				wprintk("error attaching QT1010\n");
+		}
+		break;
 	case SAA7134_BOARD_ZOLID_HYBRID_PCI:
 		fe0->dvb.frontend = dvb_attach(tda10048_attach,
 					       &zolid_tda10048_config,

