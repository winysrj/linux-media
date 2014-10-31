Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34549 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761333AbaJaH0c (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 03:26:32 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH] tveeprom: Update list of chips and extend serial number to 32bits
Date: Fri, 31 Oct 2014 08:26:18 +0100
Message-Id: <1414740378-18791-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The update was supplied directly by PCTV.

Add tuner ids 182-188.
Add audproc ids 45-52.
Add decoder chip ids 43-53.
Use 32bits for the serial number.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/common/tveeprom.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/media/common/tveeprom.c b/drivers/media/common/tveeprom.c
index c7dace6..47da037 100644
--- a/drivers/media/common/tveeprom.c
+++ b/drivers/media/common/tveeprom.c
@@ -286,9 +286,17 @@ static const struct {
 	{ TUNER_ABSENT,                 "Xceive XC5200C"},
 	{ TUNER_ABSENT,                 "NXP 18273"},
 	{ TUNER_ABSENT,                 "Montage M88TS2022"},
-	/* 180-189 */
+	/* 180-188 */
 	{ TUNER_ABSENT,                 "NXP 18272M"},
 	{ TUNER_ABSENT,                 "NXP 18272S"},
+
+	{ TUNER_ABSENT,                 "Mirics MSi003"},
+	{ TUNER_ABSENT,                 "MaxLinear MxL256"},
+	{ TUNER_ABSENT,                 "SiLabs Si2158"},
+	{ TUNER_ABSENT,                 "SiLabs Si2178"},
+	{ TUNER_ABSENT,                 "SiLabs Si2157"},
+	{ TUNER_ABSENT,                 "SiLabs Si2177"},
+	{ TUNER_ABSENT,                 "ITE IT9137FN"},
 };
 
 /* Use TVEEPROM_AUDPROC_INTERNAL for those audio 'chips' that are
@@ -351,6 +359,16 @@ static const struct {
 	{ TVEEPROM_AUDPROC_INTERNAL, "CX23887"   },
 	{ TVEEPROM_AUDPROC_INTERNAL, "SAA7164"   },
 	{ TVEEPROM_AUDPROC_INTERNAL, "AU8522"    },
+	/* 45-49 */
+	{ TVEEPROM_AUDPROC_INTERNAL, "AVF4910B"  },
+	{ TVEEPROM_AUDPROC_INTERNAL, "SAA7231"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "CX23102"   },
+	{ TVEEPROM_AUDPROC_INTERNAL, "SAA7163"   },
+	{ TVEEPROM_AUDPROC_OTHER,    "AK4113"    },
+	/* 50-52 */
+	{ TVEEPROM_AUDPROC_OTHER,    "CS5340"    },
+	{ TVEEPROM_AUDPROC_OTHER,    "CS8416"    },
+	{ TVEEPROM_AUDPROC_OTHER,    "CX20810"   },
 };
 
 /* This list is supplied by Hauppauge. Thanks! */
@@ -371,8 +389,12 @@ static const char *decoderIC[] = {
 	"CX25843", "CX23418", "NEC61153", "CX23885", "CX23888",
 	/* 35-39 */
 	"SAA7131", "CX25837", "CX23887", "CX23885A", "CX23887A",
-	/* 40-42 */
-	"SAA7164", "CX23885B", "AU8522"
+	/* 40-44 */
+	"SAA7164", "CX23885B", "AU8522", "ADV7401", "AVF4910B",
+	/* 45-49 */
+	"SAA7231", "CX23102", "SAA7163", "ADV7441A", "ADV7181C",
+	/* 50-53 */
+	"CX25836", "TDA9955", "TDA19977", "ADV7842"
 };
 
 static int hasRadioTuner(int tunerType)
@@ -548,10 +570,10 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			tvee->serial_number =
 				eeprom_data[i+5] +
 				(eeprom_data[i+6] << 8) +
-				(eeprom_data[i+7] << 16);
+				(eeprom_data[i+7] << 16)+
+				(eeprom_data[i+8] << 24);
 
-			if ((eeprom_data[i + 8] & 0xf0) &&
-					(tvee->serial_number < 0xffffff)) {
+			if (eeprom_data[i + 8] == 0xf0) {
 				tvee->MAC_address[0] = 0x00;
 				tvee->MAC_address[1] = 0x0D;
 				tvee->MAC_address[2] = 0xFE;
@@ -696,7 +718,7 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 		}
 	}
 
-	tveeprom_info("Hauppauge model %d, rev %s, serial# %d\n",
+	tveeprom_info("Hauppauge model %d, rev %s, serial# %u\n",
 		tvee->model, tvee->rev_str, tvee->serial_number);
 	if (tvee->has_MAC_address == 1)
 		tveeprom_info("MAC address is %pM\n", tvee->MAC_address);
-- 
2.1.2

