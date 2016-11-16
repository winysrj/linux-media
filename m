Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49704 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753821AbcKPQnQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:16 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 35/35] [media] tveeprom: print log messages using pr_foo()
Date: Wed, 16 Nov 2016 14:43:07 -0200
Message-Id: <4088fcf5c93ae243308c089e4e86d646c19e60c5.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Unfortunately, the callers of tveeprom don't do the right
thing to initialize the device. So, it produces log messages
like:

[  267.533010]  (null): Hauppauge model 42012, rev C186, serial# 2819348
[  267.533012]  (null): tuner model is Philips FQ1236 MK3 (idx 86, type 43)
[  267.533013]  (null): TV standards NTSC(M) (eeprom 0x08)
[  267.533014]  (null): audio processor is MSP3445 (idx 12)
[  267.533015]  (null): has radio

So, replace it to pr_foo(), as it should work fine.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/tveeprom.c | 42 +++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/media/common/tveeprom.c b/drivers/media/common/tveeprom.c
index e7d0d86f19aa..11976031aff8 100644
--- a/drivers/media/common/tveeprom.c
+++ b/drivers/media/common/tveeprom.c
@@ -28,6 +28,8 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
@@ -496,12 +498,12 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 			len = eeprom_data[i] & 0x07;
 			++i;
 		} else {
-			dev_warn(&c->dev, "Encountered bad packet header [%02x]. Corrupt or not a Hauppauge eeprom.\n",
+			pr_warn("Encountered bad packet header [%02x]. Corrupt or not a Hauppauge eeprom.\n",
 				eeprom_data[i]);
 			return;
 		}
 
-		dev_dbg(&c->dev, "Tag [%02x] + %d bytes: %*ph\n",
+		pr_debug("Tag [%02x] + %d bytes: %*ph\n",
 			eeprom_data[i], len - 1, len, &eeprom_data[i]);
 
 		/* process by tag */
@@ -642,14 +644,14 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 		/* case 0x12: tag 'InfoBits' */
 
 		default:
-			dev_dbg(&c->dev, "Not sure what to do with tag [%02x]\n",
+			pr_debug("Not sure what to do with tag [%02x]\n",
 					tag);
 			/* dump the rest of the packet? */
 		}
 	}
 
 	if (!done) {
-		dev_warn(&c->dev, "Ran out of data!\n");
+		pr_warn("Ran out of data!\n");
 		return;
 	}
 
@@ -662,8 +664,8 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 	}
 
 	if (hasRadioTuner(tuner1) && !tvee->has_radio) {
-		dev_info(&c->dev, "The eeprom says no radio is present, but the tuner type\n");
-		dev_info(&c->dev, "indicates otherwise. I will assume that radio is present.\n");
+		pr_info("The eeprom says no radio is present, but the tuner type\n");
+		pr_info("indicates otherwise. I will assume that radio is present.\n");
 		tvee->has_radio = 1;
 	}
 
@@ -698,46 +700,46 @@ void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
 		}
 	}
 
-	dev_info(&c->dev, "Hauppauge model %d, rev %s, serial# %u\n",
+	pr_info("Hauppauge model %d, rev %s, serial# %u\n",
 		tvee->model, tvee->rev_str, tvee->serial_number);
 	if (tvee->has_MAC_address == 1)
-		dev_info(&c->dev, "MAC address is %pM\n", tvee->MAC_address);
-	dev_info(&c->dev, "tuner model is %s (idx %d, type %d)\n",
+		pr_info("MAC address is %pM\n", tvee->MAC_address);
+	pr_info("tuner model is %s (idx %d, type %d)\n",
 		t_name1, tuner1, tvee->tuner_type);
-	dev_info(&c->dev, "TV standards%s%s%s%s%s%s%s%s (eeprom 0x%02x)\n",
+	pr_info("TV standards%s%s%s%s%s%s%s%s (eeprom 0x%02x)\n",
 		t_fmt_name1[0], t_fmt_name1[1], t_fmt_name1[2],
 		t_fmt_name1[3],	t_fmt_name1[4], t_fmt_name1[5],
 		t_fmt_name1[6], t_fmt_name1[7],	t_format1);
 	if (tuner2)
-		dev_info(&c->dev, "second tuner model is %s (idx %d, type %d)\n",
+		pr_info("second tuner model is %s (idx %d, type %d)\n",
 					t_name2, tuner2, tvee->tuner2_type);
 	if (t_format2)
-		dev_info(&c->dev, "TV standards%s%s%s%s%s%s%s%s (eeprom 0x%02x)\n",
+		pr_info("TV standards%s%s%s%s%s%s%s%s (eeprom 0x%02x)\n",
 			t_fmt_name2[0], t_fmt_name2[1], t_fmt_name2[2],
 			t_fmt_name2[3],	t_fmt_name2[4], t_fmt_name2[5],
 			t_fmt_name2[6], t_fmt_name2[7], t_format2);
 	if (audioic < 0) {
-		dev_info(&c->dev, "audio processor is unknown (no idx)\n");
+		pr_info("audio processor is unknown (no idx)\n");
 		tvee->audio_processor = TVEEPROM_AUDPROC_OTHER;
 	} else {
 		if (audioic < ARRAY_SIZE(audio_ic))
-			dev_info(&c->dev, "audio processor is %s (idx %d)\n",
+			pr_info("audio processor is %s (idx %d)\n",
 					audio_ic[audioic].name, audioic);
 		else
-			dev_info(&c->dev, "audio processor is unknown (idx %d)\n",
+			pr_info("audio processor is unknown (idx %d)\n",
 								audioic);
 	}
 	if (tvee->decoder_processor)
-		dev_info(&c->dev, "decoder processor is %s (idx %d)\n",
+		pr_info("decoder processor is %s (idx %d)\n",
 			STRM(decoderIC, tvee->decoder_processor),
 			tvee->decoder_processor);
 	if (tvee->has_ir)
-		dev_info(&c->dev, "has %sradio, has %sIR receiver, has %sIR transmitter\n",
+		pr_info("has %sradio, has %sIR receiver, has %sIR transmitter\n",
 				tvee->has_radio ? "" : "no ",
 				(tvee->has_ir & 2) ? "" : "no ",
 				(tvee->has_ir & 4) ? "" : "no ");
 	else
-		dev_info(&c->dev, "has %sradio\n",
+		pr_info("has %sradio\n",
 				tvee->has_radio ? "" : "no ");
 }
 EXPORT_SYMBOL(tveeprom_hauppauge_analog);
@@ -753,12 +755,12 @@ int tveeprom_read(struct i2c_client *c, unsigned char *eedata, int len)
 	buf = 0;
 	err = i2c_master_send(c, &buf, 1);
 	if (err != 1) {
-		dev_info(&c->dev, "Huh, no eeprom present (err=%d)?\n", err);
+		pr_info("Huh, no eeprom present (err=%d)?\n", err);
 		return -1;
 	}
 	err = i2c_master_recv(c, eedata, len);
 	if (err != len) {
-		dev_warn(&c->dev, "i2c eeprom read error (err=%d)\n", err);
+		pr_warn("i2c eeprom read error (err=%d)\n", err);
 		return -1;
 	}
 
-- 
2.7.4


