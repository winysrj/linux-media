Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:33330 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752851AbcLINzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Dec 2016 08:55:07 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] si2168: implement ber statistics
Date: Fri,  9 Dec 2016 15:54:55 +0200
Message-Id: <1481291696-11869-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement DVBv5 BER.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/si2168.c      | 46 +++++++++++++++++++++++++++++--
 drivers/media/dvb-frontends/si2168_priv.h |  1 +
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 20b4a65..5fbb6c1 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -85,7 +85,8 @@ static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct i2c_client *client = fe->demodulator_priv;
 	struct si2168_dev *dev = i2c_get_clientdata(client);
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	int ret;
+	int ret, i;
+	unsigned int utmp, utmp1, utmp2;
 	struct si2168_cmd cmd;
 
 	*status = 0;
@@ -144,6 +145,39 @@ static int si2168_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	dev_dbg(&client->dev, "status=%02x args=%*ph\n",
 			*status, cmd.rlen, cmd.args);
 
+	/* BER */
+	if (*status & FE_HAS_VITERBI) {
+		memcpy(cmd.args, "\x82\x00", 2);
+		cmd.wlen = 2;
+		cmd.rlen = 3;
+		ret = si2168_cmd_execute(client, &cmd);
+		if (ret)
+			goto err;
+
+		/*
+		 * Firmware returns [0, 255] mantissa and [0, 8] exponent.
+		 * Convert to DVB API: mantissa * 10^(8 - exponent) / 10^8
+		 */
+		utmp = clamp(8 - cmd.args[1], 0, 8);
+		for (i = 0, utmp1 = 1; i < utmp; i++)
+			utmp1 = utmp1 * 10;
+
+		utmp1 = cmd.args[2] * utmp1;
+		utmp2 = 100000000; /* 10^8 */
+
+		dev_dbg(&client->dev,
+			"post_bit_error=%u post_bit_count=%u ber=%u*10^-%u\n",
+			utmp1, utmp2, cmd.args[2], cmd.args[1]);
+
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue += utmp1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue += utmp2;
+	} else {
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed=%d\n", ret);
@@ -355,6 +389,7 @@ static int si2168_init(struct dvb_frontend *fe)
 {
 	struct i2c_client *client = fe->demodulator_priv;
 	struct si2168_dev *dev = i2c_get_clientdata(client);
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, len, remaining;
 	const struct firmware *fw;
 	struct si2168_cmd cmd;
@@ -493,10 +528,17 @@ static int si2168_init(struct dvb_frontend *fe)
 
 	dev->warm = true;
 warm:
+	/* Init stats here to indicate which stats are supported */
+	c->cnr.len = 1;
+	c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_error.len = 1;
+	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	c->post_bit_count.len = 1;
+	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
 	dev->active = true;
 
 	return 0;
-
 err_release_firmware:
 	release_firmware(fw);
 err:
diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
index 7843ccb..2fecac6 100644
--- a/drivers/media/dvb-frontends/si2168_priv.h
+++ b/drivers/media/dvb-frontends/si2168_priv.h
@@ -21,6 +21,7 @@
 #include "dvb_frontend.h"
 #include <linux/firmware.h>
 #include <linux/i2c-mux.h>
+#include <linux/kernel.h>
 
 #define SI2168_A20_FIRMWARE "dvb-demod-si2168-a20-01.fw"
 #define SI2168_A30_FIRMWARE "dvb-demod-si2168-a30-01.fw"
-- 
http://palosaari.fi/

