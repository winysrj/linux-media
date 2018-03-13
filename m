Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:51665 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932786AbeCMXkL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:11 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 04/18] af9013: dvbv5 ber and per
Date: Wed, 14 Mar 2018 01:39:30 +0200
Message-Id: <20180313233944.7234-4-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement dvbv5 ber and per.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c | 73 +++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index b3d08e437478..a054e39510e0 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -47,6 +47,7 @@ struct af9013_state {
 	unsigned long read_status_jiffies;
 	unsigned long strength_jiffies;
 	unsigned long cnr_jiffies;
+	unsigned long ber_ucb_jiffies;
 	bool first_tune;
 	bool i2c_gate_state;
 	unsigned int statistics_step:3;
@@ -754,7 +755,7 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret, stmp1;
 	unsigned int utmp, utmp1, utmp2, utmp3, utmp4;
-	u8 buf[3];
+	u8 buf[7];
 
 	dev_dbg(&client->dev, "\n");
 
@@ -947,6 +948,72 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		break;
 	}
 
+	/* BER / PER */
+	switch (state->fe_status & FE_HAS_SYNC) {
+	case FE_HAS_SYNC:
+		if (time_is_after_jiffies(state->ber_ucb_jiffies + msecs_to_jiffies(2000)))
+			break;
+
+		/* Check if ber / ucb is ready */
+		ret = regmap_read(state->regmap, 0xd391, &utmp);
+		if (ret)
+			goto err;
+
+		if (!((utmp >> 4) & 0x01)) {
+			dev_dbg(&client->dev, "ber not ready\n");
+			break;
+		}
+
+		/* Read value */
+		ret = regmap_bulk_read(state->regmap, 0xd385, buf, 7);
+		if (ret)
+			goto err;
+
+		utmp1 = buf[4] << 16 | buf[3] << 8 | buf[2] << 0;
+		utmp2 = (buf[1] << 8 | buf[0] << 0) * 204 * 8;
+		utmp3 = buf[6] << 8 | buf[5] << 0;
+		utmp4 = buf[1] << 8 | buf[0] << 0;
+
+		/* Use 10000 TS packets for measure */
+		if (utmp4 != 10000) {
+			buf[0] = (10000 >> 0) & 0xff;
+			buf[1] = (10000 >> 8) & 0xff;
+			ret = regmap_bulk_write(state->regmap, 0xd385, buf, 2);
+			if (ret)
+				goto err;
+		}
+
+		/* Reset ber / ucb counter */
+		ret = regmap_update_bits(state->regmap, 0xd391, 0x20, 0x20);
+		if (ret)
+			goto err;
+
+		dev_dbg(&client->dev, "post_bit_error %u, post_bit_count %u\n",
+			utmp1, utmp2);
+		dev_dbg(&client->dev, "block_error %u, block_count %u\n",
+			utmp3, utmp4);
+
+		state->ber_ucb_jiffies = jiffies;
+
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue += utmp1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue += utmp2;
+
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue += utmp3;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue += utmp4;
+		break;
+	default:
+		c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+
+		c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+		break;
+	}
+
 	return 0;
 err:
 	dev_dbg(&client->dev, "failed %d\n", ret);
@@ -1670,6 +1737,10 @@ static int af9013_probe(struct i2c_client *client,
 	c = &state->fe.dtv_property_cache;
 	c->strength.len = 1;
 	c->cnr.len = 1;
+	c->post_bit_error.len = 1;
+	c->post_bit_count.len = 1;
+	c->block_error.len = 1;
+	c->block_count.len = 1;
 
 	dev_info(&client->dev, "Afatech AF9013 successfully attached\n");
 	dev_info(&client->dev, "firmware version: %d.%d.%d.%d\n",
-- 
2.14.3
