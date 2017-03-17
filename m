Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38417 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751079AbdCQQuy (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 12:50:54 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] mn88472: implement cnr statistics
Date: Fri, 17 Mar 2017 18:50:26 +0200
Message-Id: <20170317165027.11471-2-crope@iki.fi>
In-Reply-To: <20170317165027.11471-1-crope@iki.fi>
References: <20170317165027.11471-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 CNR.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/mn88472.c      | 90 +++++++++++++++++++++++++++++-
 drivers/media/dvb-frontends/mn88472_priv.h |  1 +
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/mn88472.c b/drivers/media/dvb-frontends/mn88472.c
index 25dd742..c7e5f63 100644
--- a/drivers/media/dvb-frontends/mn88472.c
+++ b/drivers/media/dvb-frontends/mn88472.c
@@ -28,9 +28,9 @@ static int mn88472_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct mn88472_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret, i;
-	unsigned int utmp, utmp1;
-	u8 buf[2];
+	int ret, i, stmp;
+	unsigned int utmp, utmp1, utmp2;
+	u8 buf[5];
 
 	if (!dev->active) {
 		ret = -EAGAIN;
@@ -96,6 +96,89 @@ static int mn88472_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	}
 
+	/* CNR */
+	if (*status & FE_HAS_VITERBI && c->delivery_system == SYS_DVBT) {
+		/* DVB-T CNR */
+		ret = regmap_bulk_read(dev->regmap[0], 0x9c, buf, 2);
+		if (ret)
+			goto err;
+
+		utmp = buf[0] << 8 | buf[1] << 0;
+		if (utmp) {
+			/* CNR[dB]: 10 * log10(65536 / value) + 2 */
+			/* log10(65536) = 80807124, 0.2 = 3355443 */
+			stmp = ((u64)80807124 - intlog10(utmp) + 3355443)
+			       * 10000 >> 24;
+
+			dev_dbg(&client->dev, "cnr=%d value=%u\n", stmp, utmp);
+		} else {
+			stmp = 0;
+		}
+
+		c->cnr.stat[0].svalue = stmp;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else if (*status & FE_HAS_VITERBI &&
+		   c->delivery_system == SYS_DVBT2) {
+		/* DVB-T2 CNR */
+		for (i = 0; i < 3; i++) {
+			ret = regmap_bulk_read(dev->regmap[2], 0xbc + i,
+					       &buf[i], 1);
+			if (ret)
+				goto err;
+		}
+
+		utmp = buf[1] << 8 | buf[2] << 0;
+		utmp1 = (buf[0] >> 2) & 0x01; /* 0=SISO, 1=MISO */
+		if (utmp) {
+			if (utmp1) {
+				/* CNR[dB]: 10 * log10(16384 / value) - 6 */
+				/* log10(16384) = 70706234, 0.6 = 10066330 */
+				stmp = ((u64)70706234 - intlog10(utmp)
+				       - 10066330) * 10000 >> 24;
+				dev_dbg(&client->dev, "cnr=%d value=%u MISO\n",
+					stmp, utmp);
+			} else {
+				/* CNR[dB]: 10 * log10(65536 / value) + 2 */
+				/* log10(65536) = 80807124, 0.2 = 3355443 */
+				stmp = ((u64)80807124 - intlog10(utmp)
+				       + 3355443) * 10000 >> 24;
+
+				dev_dbg(&client->dev, "cnr=%d value=%u SISO\n",
+					stmp, utmp);
+			}
+		} else {
+			stmp = 0;
+		}
+
+		c->cnr.stat[0].svalue = stmp;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else if (*status & FE_HAS_VITERBI &&
+		   c->delivery_system == SYS_DVBC_ANNEX_A) {
+		/* DVB-C CNR */
+		ret = regmap_bulk_read(dev->regmap[1], 0xa1, buf, 4);
+		if (ret)
+			goto err;
+
+		utmp1 = buf[0] << 8 | buf[1] << 0; /* signal */
+		utmp2 = buf[2] << 8 | buf[3] << 0; /* noise */
+		if (utmp1 && utmp2) {
+			/* CNR[dB]: 10 * log10(8 * (signal / noise)) */
+			/* log10(8) = 15151336 */
+			stmp = ((u64)15151336 + intlog10(utmp1)
+			       - intlog10(utmp2)) * 10000 >> 24;
+
+			dev_dbg(&client->dev, "cnr=%d signal=%u noise=%u\n",
+				stmp, utmp1, utmp2);
+		} else {
+			stmp = 0;
+		}
+
+		c->cnr.stat[0].svalue = stmp;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+	} else {
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -570,6 +653,7 @@ static int mn88472_probe(struct i2c_client *client,
 	/* Init stats to indicate which stats are supported */
 	c = &dev->fe.dtv_property_cache;
 	c->strength.len = 1;
+	c->cnr.len = 1;
 
 	/* Setup callbacks */
 	pdata->get_dvb_frontend = mn88472_get_dvb_frontend;
diff --git a/drivers/media/dvb-frontends/mn88472_priv.h b/drivers/media/dvb-frontends/mn88472_priv.h
index cdf2597..fb50f56 100644
--- a/drivers/media/dvb-frontends/mn88472_priv.h
+++ b/drivers/media/dvb-frontends/mn88472_priv.h
@@ -18,6 +18,7 @@
 #define MN88472_PRIV_H
 
 #include "dvb_frontend.h"
+#include "dvb_math.h"
 #include "mn88472.h"
 #include <linux/firmware.h>
 #include <linux/regmap.h>
-- 
http://palosaari.fi/
