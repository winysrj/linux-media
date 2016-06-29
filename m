Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53841 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbcF2Xki (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:40:38 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/3] af9033: move statistics to read_status()
Date: Thu, 30 Jun 2016 02:40:21 +0300
Message-Id: <1467243623-26315-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move statistics polling to read_status() in order to avoid use of
kernel work.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c | 326 +++++++++++++++++------------------
 1 file changed, 154 insertions(+), 172 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index efebe5c..42fbd0f 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -41,7 +41,6 @@ struct af9033_dev {
 	u64 post_bit_count;
 	u64 error_block_count;
 	u64 total_block_count;
-	struct delayed_work stat_work;
 };
 
 /* write multiple registers */
@@ -468,8 +467,6 @@ static int af9033_init(struct dvb_frontend *fe)
 	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
 	c->post_bit_error.len = 1;
 	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	/* start statistics polling */
-	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
 
 	return 0;
 
@@ -485,9 +482,6 @@ static int af9033_sleep(struct dvb_frontend *fe)
 	int ret, i;
 	u8 tmp;
 
-	/* stop statistics polling */
-	cancel_delayed_work_sync(&dev->stat_work);
-
 	ret = af9033_wr_reg(dev, 0x80004c, 1);
 	if (ret < 0)
 		goto err;
@@ -821,36 +815,39 @@ err:
 static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 {
 	struct af9033_dev *dev = fe->demodulator_priv;
-	int ret;
-	u8 tmp;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	int ret, i, tmp;
+	u8 u8tmp, buf[7];
+
+	dev_dbg(&dev->client->dev, "\n");
 
 	*status = 0;
 
 	/* radio channel status, 0=no result, 1=has signal, 2=no signal */
-	ret = af9033_rd_reg(dev, 0x800047, &tmp);
+	ret = af9033_rd_reg(dev, 0x800047, &u8tmp);
 	if (ret < 0)
 		goto err;
 
 	/* has signal */
-	if (tmp == 0x01)
+	if (u8tmp == 0x01)
 		*status |= FE_HAS_SIGNAL;
 
-	if (tmp != 0x02) {
+	if (u8tmp != 0x02) {
 		/* TPS lock */
-		ret = af9033_rd_reg_mask(dev, 0x80f5a9, &tmp, 0x01);
+		ret = af9033_rd_reg_mask(dev, 0x80f5a9, &u8tmp, 0x01);
 		if (ret < 0)
 			goto err;
 
-		if (tmp)
+		if (u8tmp)
 			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 					FE_HAS_VITERBI;
 
 		/* full lock */
-		ret = af9033_rd_reg_mask(dev, 0x80f999, &tmp, 0x01);
+		ret = af9033_rd_reg_mask(dev, 0x80f999, &u8tmp, 0x01);
 		if (ret < 0)
 			goto err;
 
-		if (tmp)
+		if (u8tmp)
 			*status |= FE_HAS_SIGNAL | FE_HAS_CARRIER |
 					FE_HAS_VITERBI | FE_HAS_SYNC |
 					FE_HAS_LOCK;
@@ -858,6 +855,148 @@ static int af9033_read_status(struct dvb_frontend *fe, enum fe_status *status)
 
 	dev->fe_status = *status;
 
+	/* signal strength */
+	if (dev->fe_status & FE_HAS_SIGNAL) {
+		if (dev->is_af9035) {
+			ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
+			if (ret)
+				goto err;
+			tmp = -u8tmp * 1000;
+		} else {
+			ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
+			if (ret)
+				goto err;
+			tmp = (u8tmp - 100) * 1000;
+		}
+
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
+		c->strength.stat[0].svalue = tmp;
+	} else {
+		c->strength.len = 1;
+		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* CNR */
+	if (dev->fe_status & FE_HAS_VITERBI) {
+		u32 snr_val, snr_lut_size;
+		const struct val_snr *snr_lut;
+
+		/* read value */
+		ret = af9033_rd_regs(dev, 0x80002c, buf, 3);
+		if (ret)
+			goto err;
+
+		snr_val = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
+
+		/* read superframe number */
+		ret = af9033_rd_reg(dev, 0x80f78b, &u8tmp);
+		if (ret)
+			goto err;
+
+		if (u8tmp)
+			snr_val /= u8tmp;
+
+		/* read current transmission mode */
+		ret = af9033_rd_reg(dev, 0x80f900, &u8tmp);
+		if (ret)
+			goto err;
+
+		switch ((u8tmp >> 0) & 3) {
+		case 0:
+			snr_val *= 4;
+			break;
+		case 1:
+			snr_val *= 1;
+			break;
+		case 2:
+			snr_val *= 2;
+			break;
+		default:
+			snr_val *= 0;
+			break;
+		}
+
+		/* read current modulation */
+		ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
+		if (ret)
+			goto err;
+
+		switch ((u8tmp >> 0) & 3) {
+		case 0:
+			snr_lut_size = ARRAY_SIZE(qpsk_snr_lut);
+			snr_lut = qpsk_snr_lut;
+			break;
+		case 1:
+			snr_lut_size = ARRAY_SIZE(qam16_snr_lut);
+			snr_lut = qam16_snr_lut;
+			break;
+		case 2:
+			snr_lut_size = ARRAY_SIZE(qam64_snr_lut);
+			snr_lut = qam64_snr_lut;
+			break;
+		default:
+			snr_lut_size = 0;
+			tmp = 0;
+			break;
+		}
+
+		for (i = 0; i < snr_lut_size; i++) {
+			tmp = snr_lut[i].snr * 1000;
+			if (snr_val < snr_lut[i].val)
+				break;
+		}
+
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
+		c->cnr.stat[0].svalue = tmp;
+	} else {
+		c->cnr.len = 1;
+		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
+	}
+
+	/* UCB/PER/BER */
+	if (dev->fe_status & FE_HAS_LOCK) {
+		/* outer FEC, 204 byte packets */
+		u16 abort_packet_count, rsd_packet_count;
+		/* inner FEC, bits */
+		u32 rsd_bit_err_count;
+
+		/*
+		 * Packet count used for measurement is 10000
+		 * (rsd_packet_count). Maybe it should be increased?
+		 */
+
+		ret = af9033_rd_regs(dev, 0x800032, buf, 7);
+		if (ret)
+			goto err;
+
+		abort_packet_count = (buf[1] << 8) | (buf[0] << 0);
+		rsd_bit_err_count = (buf[4] << 16) | (buf[3] << 8) | buf[2];
+		rsd_packet_count = (buf[6] << 8) | (buf[5] << 0);
+
+		dev->error_block_count += abort_packet_count;
+		dev->total_block_count += rsd_packet_count;
+		dev->post_bit_error += rsd_bit_err_count;
+		dev->post_bit_count += rsd_packet_count * 204 * 8;
+
+		c->block_count.len = 1;
+		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_count.stat[0].uvalue = dev->total_block_count;
+
+		c->block_error.len = 1;
+		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->block_error.stat[0].uvalue = dev->error_block_count;
+
+		c->post_bit_count.len = 1;
+		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_count.stat[0].uvalue = dev->post_bit_count;
+
+		c->post_bit_error.len = 1;
+		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
+		c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
+	}
+
 	return 0;
 
 err:
@@ -1059,159 +1198,6 @@ err:
 	return ret;
 }
 
-static void af9033_stat_work(struct work_struct *work)
-{
-	struct af9033_dev *dev = container_of(work, struct af9033_dev, stat_work.work);
-	struct dtv_frontend_properties *c = &dev->fe.dtv_property_cache;
-	int ret, tmp, i, len;
-	u8 u8tmp, buf[7];
-
-	dev_dbg(&dev->client->dev, "\n");
-
-	/* signal strength */
-	if (dev->fe_status & FE_HAS_SIGNAL) {
-		if (dev->is_af9035) {
-			ret = af9033_rd_reg(dev, 0x80004a, &u8tmp);
-			tmp = -u8tmp * 1000;
-		} else {
-			ret = af9033_rd_reg(dev, 0x8000f7, &u8tmp);
-			tmp = (u8tmp - 100) * 1000;
-		}
-		if (ret)
-			goto err;
-
-		c->strength.len = 1;
-		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
-		c->strength.stat[0].svalue = tmp;
-	} else {
-		c->strength.len = 1;
-		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-	/* CNR */
-	if (dev->fe_status & FE_HAS_VITERBI) {
-		u32 snr_val;
-		const struct val_snr *snr_lut;
-
-		/* read value */
-		ret = af9033_rd_regs(dev, 0x80002c, buf, 3);
-		if (ret)
-			goto err;
-
-		snr_val = (buf[2] << 16) | (buf[1] << 8) | (buf[0] << 0);
-
-		/* read superframe number */
-		ret = af9033_rd_reg(dev, 0x80f78b, &u8tmp);
-		if (ret)
-			goto err;
-
-		if (u8tmp)
-			snr_val /= u8tmp;
-
-		/* read current transmission mode */
-		ret = af9033_rd_reg(dev, 0x80f900, &u8tmp);
-		if (ret)
-			goto err;
-
-		switch ((u8tmp >> 0) & 3) {
-		case 0:
-			snr_val *= 4;
-			break;
-		case 1:
-			snr_val *= 1;
-			break;
-		case 2:
-			snr_val *= 2;
-			break;
-		default:
-			goto err_schedule_delayed_work;
-		}
-
-		/* read current modulation */
-		ret = af9033_rd_reg(dev, 0x80f903, &u8tmp);
-		if (ret)
-			goto err;
-
-		switch ((u8tmp >> 0) & 3) {
-		case 0:
-			len = ARRAY_SIZE(qpsk_snr_lut);
-			snr_lut = qpsk_snr_lut;
-			break;
-		case 1:
-			len = ARRAY_SIZE(qam16_snr_lut);
-			snr_lut = qam16_snr_lut;
-			break;
-		case 2:
-			len = ARRAY_SIZE(qam64_snr_lut);
-			snr_lut = qam64_snr_lut;
-			break;
-		default:
-			goto err_schedule_delayed_work;
-		}
-
-		for (i = 0; i < len; i++) {
-			tmp = snr_lut[i].snr * 1000;
-			if (snr_val < snr_lut[i].val)
-				break;
-		}
-
-		c->cnr.len = 1;
-		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
-		c->cnr.stat[0].svalue = tmp;
-	} else {
-		c->cnr.len = 1;
-		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
-	}
-
-	/* UCB/PER/BER */
-	if (dev->fe_status & FE_HAS_LOCK) {
-		/* outer FEC, 204 byte packets */
-		u16 abort_packet_count, rsd_packet_count;
-		/* inner FEC, bits */
-		u32 rsd_bit_err_count;
-
-		/*
-		 * Packet count used for measurement is 10000
-		 * (rsd_packet_count). Maybe it should be increased?
-		 */
-
-		ret = af9033_rd_regs(dev, 0x800032, buf, 7);
-		if (ret)
-			goto err;
-
-		abort_packet_count = (buf[1] << 8) | (buf[0] << 0);
-		rsd_bit_err_count = (buf[4] << 16) | (buf[3] << 8) | buf[2];
-		rsd_packet_count = (buf[6] << 8) | (buf[5] << 0);
-
-		dev->error_block_count += abort_packet_count;
-		dev->total_block_count += rsd_packet_count;
-		dev->post_bit_error += rsd_bit_err_count;
-		dev->post_bit_count += rsd_packet_count * 204 * 8;
-
-		c->block_count.len = 1;
-		c->block_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->block_count.stat[0].uvalue = dev->total_block_count;
-
-		c->block_error.len = 1;
-		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->block_error.stat[0].uvalue = dev->error_block_count;
-
-		c->post_bit_count.len = 1;
-		c->post_bit_count.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_count.stat[0].uvalue = dev->post_bit_count;
-
-		c->post_bit_error.len = 1;
-		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
-		c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
-	}
-
-err_schedule_delayed_work:
-	schedule_delayed_work(&dev->stat_work, msecs_to_jiffies(2000));
-	return;
-err:
-	dev_dbg(&dev->client->dev, "failed=%d\n", ret);
-}
-
 static struct dvb_frontend_ops af9033_ops = {
 	.delsys = { SYS_DVBT },
 	.info = {
@@ -1272,7 +1258,6 @@ static int af9033_probe(struct i2c_client *client,
 
 	/* setup the state */
 	dev->client = client;
-	INIT_DELAYED_WORK(&dev->stat_work, af9033_stat_work);
 	memcpy(&dev->cfg, cfg, sizeof(struct af9033_config));
 
 	if (dev->cfg.clock != 12000000) {
@@ -1372,9 +1357,6 @@ static int af9033_remove(struct i2c_client *client)
 
 	dev_dbg(&dev->client->dev, "\n");
 
-	/* stop statistics polling */
-	cancel_delayed_work_sync(&dev->stat_work);
-
 	dev->fe.ops.release = NULL;
 	dev->fe.demodulator_priv = NULL;
 	kfree(dev);
-- 
http://palosaari.fi/

