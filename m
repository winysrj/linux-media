Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:52051 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751683AbdCCKek (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Mar 2017 05:34:40 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mike Isely <isely@pobox.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Stephen Backway <stev391@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Utkin <andrey_utkin@fastmail.com>,
        GEORGE <geoubuntu@gmail.com>, Shuah Khan <shuah@kernel.org>,
        Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH] [media] tveeprom: get rid of unused arg on tveeprom_hauppauge_analog()
Date: Fri,  3 Mar 2017 07:33:43 -0300
Message-Id: <a0c1fc52fda7e36389fd0c19ea320e5c37b00c17.1488537200.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tveeprom_hauppauge_analog() used to need the I2C adapter in
order to print debug messages. As it now uses pr_foo() facilities,
this is not needed anymore.

So, get rid of it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/tveeprom.c            | 4 ++--
 drivers/media/pci/bt8xx/bttv-cards.c       | 2 +-
 drivers/media/pci/cx18/cx18-driver.c       | 2 +-
 drivers/media/pci/cx23885/cx23885-cards.c  | 3 +--
 drivers/media/pci/cx88/cx88-cards.c        | 2 +-
 drivers/media/pci/ivtv/ivtv-driver.c       | 2 +-
 drivers/media/pci/saa7134/saa7134-cards.c  | 2 +-
 drivers/media/pci/saa7164/saa7164-cards.c  | 4 +---
 drivers/media/usb/au0828/au0828-cards.c    | 2 +-
 drivers/media/usb/cx231xx/cx231xx-cards.c  | 3 +--
 drivers/media/usb/dvb-usb-v2/mxl111sf.c    | 4 ++--
 drivers/media/usb/em28xx/em28xx-cards.c    | 3 +--
 drivers/media/usb/pvrusb2/pvrusb2-eeprom.c | 2 +-
 include/media/tveeprom.h                   | 2 +-
 14 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/media/common/tveeprom.c b/drivers/media/common/tveeprom.c
index 6e1020227f9f..ccf2d3b12aec 100644
--- a/drivers/media/common/tveeprom.c
+++ b/drivers/media/common/tveeprom.c
@@ -420,8 +420,8 @@ static int hasRadioTuner(int tunerType)
 	return 0;
 }
 
-void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
-				unsigned char *eeprom_data)
+void tveeprom_hauppauge_analog(struct tveeprom *tvee,
+			       unsigned char *eeprom_data)
 {
 	/* ----------------------------------------------
 	** The hauppauge eeprom format is tagged
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index a1b0f3193bc0..5cc42b426715 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -3717,7 +3717,7 @@ static void hauppauge_eeprom(struct bttv *btv)
 {
 	struct tveeprom tv;
 
-	tveeprom_hauppauge_analog(&btv->i2c_client, &tv, eeprom_data);
+	tveeprom_hauppauge_analog(&tv, eeprom_data);
 	btv->tuner_type = tv.tuner_type;
 	btv->has_radio  = tv.has_radio;
 
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 206db81ef78e..8bce49cdad46 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -339,7 +339,7 @@ void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
 	case CX18_CARD_HVR_1600_ESMT:
 	case CX18_CARD_HVR_1600_SAMSUNG:
 	case CX18_CARD_HVR_1600_S5H1411:
-		tveeprom_hauppauge_analog(c, tv, eedata);
+		tveeprom_hauppauge_analog(tv, eedata);
 		break;
 	case CX18_CARD_YUAN_MPC718:
 	case CX18_CARD_GOTVIEW_PCI_DVD3:
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index 0350f13c5a9f..9e39aea85df6 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -1143,8 +1143,7 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 {
 	struct tveeprom tv;
 
-	tveeprom_hauppauge_analog(&dev->i2c_bus[0].i2c_client, &tv,
-		eeprom_data);
+	tveeprom_hauppauge_analog(&tv, eeprom_data);
 
 	/* Make sure we support the board model */
 	switch (tv.model) {
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index cdfbde277b8b..61e1803882d9 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -2854,7 +2854,7 @@ static void hauppauge_eeprom(struct cx88_core *core, u8 *eeprom_data)
 {
 	struct tveeprom tv;
 
-	tveeprom_hauppauge_analog(&core->i2c_client, &tv, eeprom_data);
+	tveeprom_hauppauge_analog(&tv, eeprom_data);
 	core->board.tuner_type = tv.tuner_type;
 	core->tuner_formats = tv.tuner_formats;
 	core->board.radio.type = tv.has_radio ? CX88_RADIO : 0;
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index ab2ae53618e8..aaccc1187791 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -408,7 +408,7 @@ void ivtv_read_eeprom(struct ivtv *itv, struct tveeprom *tv)
 
 	itv->i2c_client.addr = 0xA0 >> 1;
 	tveeprom_read(&itv->i2c_client, eedata, sizeof(eedata));
-	tveeprom_hauppauge_analog(&itv->i2c_client, tv, eedata);
+	tveeprom_hauppauge_analog(tv, eedata);
 }
 
 static void ivtv_process_eeprom(struct ivtv *itv)
diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index 321253827997..f79380faf499 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -7319,7 +7319,7 @@ static void hauppauge_eeprom(struct saa7134_dev *dev, u8 *eeprom_data)
 {
 	struct tveeprom tv;
 
-	tveeprom_hauppauge_analog(&dev->i2c_client, &tv, eeprom_data);
+	tveeprom_hauppauge_analog(&tv, eeprom_data);
 
 	/* Make sure we support the board model */
 	switch (tv.model) {
diff --git a/drivers/media/pci/saa7164/saa7164-cards.c b/drivers/media/pci/saa7164/saa7164-cards.c
index 0e1cd7e153ca..3af16062e79d 100644
--- a/drivers/media/pci/saa7164/saa7164-cards.c
+++ b/drivers/media/pci/saa7164/saa7164-cards.c
@@ -780,9 +780,7 @@ static void hauppauge_eeprom(struct saa7164_dev *dev, u8 *eeprom_data)
 {
 	struct tveeprom tv;
 
-	/* TODO: Assumption: eeprom on bus 0 */
-	tveeprom_hauppauge_analog(&dev->i2c_bus[0].i2c_client, &tv,
-		eeprom_data);
+	tveeprom_hauppauge_analog(&tv, eeprom_data);
 
 	/* Make sure we support the board model */
 	switch (tv.model) {
diff --git a/drivers/media/usb/au0828/au0828-cards.c b/drivers/media/usb/au0828/au0828-cards.c
index 313f659f0bfb..43bfa778b070 100644
--- a/drivers/media/usb/au0828/au0828-cards.c
+++ b/drivers/media/usb/au0828/au0828-cards.c
@@ -153,7 +153,7 @@ static void hauppauge_eeprom(struct au0828_dev *dev, u8 *eeprom_data)
 {
 	struct tveeprom tv;
 
-	tveeprom_hauppauge_analog(&dev->i2c_client, &tv, eeprom_data);
+	tveeprom_hauppauge_analog(&tv, eeprom_data);
 	dev->board.tuner_type = tv.tuner_type;
 
 	/* Make sure we support the board model */
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index f730fdbc9156..9b28d57006af 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1165,8 +1165,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 			e->client.addr = 0xa0 >> 1;
 
 			read_eeprom(dev, &e->client, e->eeprom, sizeof(e->eeprom));
-			tveeprom_hauppauge_analog(&e->client,
-						&e->tvee, e->eeprom + 0xc0);
+			tveeprom_hauppauge_analog(&e->tvee, e->eeprom + 0xc0);
 			kfree(e);
 			break;
 		}
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 60bc5cc9a483..abf69d8fa469 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -938,8 +938,8 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 	ret = i2c_transfer(&d->i2c_adap, msg, 2);
 	if (mxl_fail(ret))
 		return 0;
-	tveeprom_hauppauge_analog(NULL, &state->tv, (0x84 == eeprom[0xa0]) ?
-			eeprom + 0xa0 : eeprom + 0x80);
+	tveeprom_hauppauge_analog(&state->tv, (0x84 == eeprom[0xa0]) ?
+				  eeprom + 0xa0 : eeprom + 0x80);
 #if 0
 	switch (state->tv.model) {
 	case 117001:
diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 5f90d0899a45..5f80a1b2fb8c 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2974,8 +2974,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 #endif
 		/* Call first TVeeprom */
 
-		dev->i2c_client[dev->def_i2c_bus].addr = 0xa0 >> 1;
-		tveeprom_hauppauge_analog(&dev->i2c_client[dev->def_i2c_bus], &tv, dev->eedata);
+		tveeprom_hauppauge_analog(&tv, dev->eedata);
 
 		dev->tuner_type = tv.tuner_type;
 
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
index 7252f113df2f..8b643d511a0b 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-eeprom.c
@@ -121,7 +121,7 @@ int pvr2_eeprom_analyze(struct pvr2_hdw *hdw)
 	if (!eeprom)
 		return -EINVAL;
 
-	tveeprom_hauppauge_analog(NULL, &tvdata, eeprom);
+	tveeprom_hauppauge_analog(&tvdata, eeprom);
 
 	trace_eeprom("eeprom assumed v4l tveeprom module");
 	trace_eeprom("eeprom direct call results:");
diff --git a/include/media/tveeprom.h b/include/media/tveeprom.h
index c56501ee0484..5324c82fc810 100644
--- a/include/media/tveeprom.h
+++ b/include/media/tveeprom.h
@@ -100,7 +100,7 @@ struct tveeprom {
  *			contain 256 bytes filled with the contents of the
  *			eeprom read from the Hauppauge device.
  */
-void tveeprom_hauppauge_analog(struct i2c_client *c, struct tveeprom *tvee,
+void tveeprom_hauppauge_analog(struct tveeprom *tvee,
 			       unsigned char *eeprom_data);
 
 /**
-- 
2.9.3
