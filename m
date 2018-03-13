Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:60525 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932443AbeCMXkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:12 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 05/18] af9013: wrap dvbv3 statistics via dvbv5
Date: Wed, 14 Mar 2018 01:39:31 +0200
Message-Id: <20180313233944.7234-5-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver has calculated dvbv5 statistics, so use those as a base for
legacy dvbv3 statistics. Wrap and convert needed values to dvbv3,
remove old dvbv3 statistic implementations.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9013.c      | 306 +++---------------------------
 drivers/media/dvb-frontends/af9013_priv.h |  68 -------
 2 files changed, 22 insertions(+), 352 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9013.c b/drivers/media/dvb-frontends/af9013.c
index a054e39510e0..e81dc827e1b8 100644
--- a/drivers/media/dvb-frontends/af9013.c
+++ b/drivers/media/dvb-frontends/af9013.c
@@ -33,12 +33,6 @@ struct af9013_state {
 	u8 api_version[4];
 	u8 gpio[4];
 
-	/* tuner/demod RF and IF AGC limits used for signal strength calc */
-	u8 signal_strength_en, rf_50, rf_80, if_50, if_80;
-	u16 signal_strength;
-	u32 ber;
-	u32 ucblocks;
-	u16 snr;
 	u32 bandwidth_hz;
 	enum fe_status fe_status;
 	/* RF and IF AGC limits used for signal strength calc */
@@ -48,10 +42,12 @@ struct af9013_state {
 	unsigned long strength_jiffies;
 	unsigned long cnr_jiffies;
 	unsigned long ber_ucb_jiffies;
+	u16 dvbv3_snr;
+	u16 dvbv3_strength;
+	u32 dvbv3_ber;
+	u32 dvbv3_ucblocks;
 	bool first_tune;
 	bool i2c_gate_state;
-	unsigned int statistics_step:3;
-	struct delayed_work statistics_work;
 };
 
 static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
@@ -106,228 +102,6 @@ static int af9013_set_gpio(struct af9013_state *state, u8 gpio, u8 gpioval)
 	return ret;
 }
 
-static int af9013_statistics_ber_unc_start(struct dvb_frontend *fe)
-{
-	struct af9013_state *state = fe->demodulator_priv;
-	struct i2c_client *client = state->client;
-	int ret;
-
-	dev_dbg(&client->dev, "\n");
-
-	/* reset and start BER counter */
-	ret = regmap_update_bits(state->regmap, 0xd391, 0x10, 0x10);
-	if (ret)
-		goto err;
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
-	return ret;
-}
-
-static int af9013_statistics_ber_unc_result(struct dvb_frontend *fe)
-{
-	struct af9013_state *state = fe->demodulator_priv;
-	struct i2c_client *client = state->client;
-	int ret;
-	unsigned int utmp;
-	u8 buf[5];
-
-	dev_dbg(&client->dev, "\n");
-
-	/* check if error bit count is ready */
-	ret = regmap_read(state->regmap, 0xd391, &utmp);
-	if (ret)
-		goto err;
-
-	if (!((utmp >> 4) & 0x01)) {
-		dev_dbg(&client->dev, "not ready\n");
-		return 0;
-	}
-
-	ret = regmap_bulk_read(state->regmap, 0xd387, buf, 5);
-	if (ret)
-		goto err;
-
-	state->ber = (buf[2] << 16) | (buf[1] << 8) | buf[0];
-	state->ucblocks += (buf[4] << 8) | buf[3];
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
-	return ret;
-}
-
-static int af9013_statistics_snr_start(struct dvb_frontend *fe)
-{
-	struct af9013_state *state = fe->demodulator_priv;
-	struct i2c_client *client = state->client;
-	int ret;
-
-	dev_dbg(&client->dev, "\n");
-
-	/* start SNR meas */
-	ret = regmap_update_bits(state->regmap, 0xd2e1, 0x08, 0x08);
-	if (ret)
-		goto err;
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
-	return ret;
-}
-
-static int af9013_statistics_snr_result(struct dvb_frontend *fe)
-{
-	struct af9013_state *state = fe->demodulator_priv;
-	struct i2c_client *client = state->client;
-	int ret, i, len;
-	unsigned int utmp;
-	u8 buf[3];
-	u32 snr_val;
-	const struct af9013_snr *uninitialized_var(snr_lut);
-
-	dev_dbg(&client->dev, "\n");
-
-	/* check if SNR ready */
-	ret = regmap_read(state->regmap, 0xd2e1, &utmp);
-	if (ret)
-		goto err;
-
-	if (!((utmp >> 3) & 0x01)) {
-		dev_dbg(&client->dev, "not ready\n");
-		return 0;
-	}
-
-	/* read value */
-	ret = regmap_bulk_read(state->regmap, 0xd2e3, buf, 3);
-	if (ret)
-		goto err;
-
-	snr_val = (buf[2] << 16) | (buf[1] << 8) | buf[0];
-
-	/* read current modulation */
-	ret = regmap_read(state->regmap, 0xd3c1, &utmp);
-	if (ret)
-		goto err;
-
-	switch ((utmp >> 6) & 3) {
-	case 0:
-		len = ARRAY_SIZE(qpsk_snr_lut);
-		snr_lut = qpsk_snr_lut;
-		break;
-	case 1:
-		len = ARRAY_SIZE(qam16_snr_lut);
-		snr_lut = qam16_snr_lut;
-		break;
-	case 2:
-		len = ARRAY_SIZE(qam64_snr_lut);
-		snr_lut = qam64_snr_lut;
-		break;
-	default:
-		goto err;
-	}
-
-	for (i = 0; i < len; i++) {
-		utmp = snr_lut[i].snr;
-
-		if (snr_val < snr_lut[i].val)
-			break;
-	}
-	state->snr = utmp * 10; /* dB/10 */
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
-	return ret;
-}
-
-static int af9013_statistics_signal_strength(struct dvb_frontend *fe)
-{
-	struct af9013_state *state = fe->demodulator_priv;
-	struct i2c_client *client = state->client;
-	int ret = 0;
-	u8 buf[2], rf_gain, if_gain;
-	int signal_strength;
-
-	dev_dbg(&client->dev, "\n");
-
-	if (!state->signal_strength_en)
-		return 0;
-
-	ret = regmap_bulk_read(state->regmap, 0xd07c, buf, 2);
-	if (ret)
-		goto err;
-
-	rf_gain = buf[0];
-	if_gain = buf[1];
-
-	signal_strength = (0xffff / \
-		(9 * (state->rf_50 + state->if_50) - \
-		11 * (state->rf_80 + state->if_80))) * \
-		(10 * (rf_gain + if_gain) - \
-		11 * (state->rf_80 + state->if_80));
-	if (signal_strength < 0)
-		signal_strength = 0;
-	else if (signal_strength > 0xffff)
-		signal_strength = 0xffff;
-
-	state->signal_strength = signal_strength;
-
-	return 0;
-err:
-	dev_dbg(&client->dev, "failed %d\n", ret);
-	return ret;
-}
-
-static void af9013_statistics_work(struct work_struct *work)
-{
-	struct af9013_state *state = container_of(work,
-		struct af9013_state, statistics_work.work);
-	unsigned int next_msec;
-
-	/* update only signal strength when demod is not locked */
-	if (!(state->fe_status & FE_HAS_LOCK)) {
-		state->statistics_step = 0;
-		state->ber = 0;
-		state->snr = 0;
-	}
-
-	switch (state->statistics_step) {
-	default:
-		state->statistics_step = 0;
-		/* fall-through */
-	case 0:
-		af9013_statistics_signal_strength(&state->fe);
-		state->statistics_step++;
-		next_msec = 300;
-		break;
-	case 1:
-		af9013_statistics_snr_start(&state->fe);
-		state->statistics_step++;
-		next_msec = 200;
-		break;
-	case 2:
-		af9013_statistics_ber_unc_start(&state->fe);
-		state->statistics_step++;
-		next_msec = 1000;
-		break;
-	case 3:
-		af9013_statistics_snr_result(&state->fe);
-		state->statistics_step++;
-		next_msec = 400;
-		break;
-	case 4:
-		af9013_statistics_ber_unc_result(&state->fe);
-		state->statistics_step++;
-		next_msec = 100;
-		break;
-	}
-
-	schedule_delayed_work(&state->statistics_work,
-		msecs_to_jiffies(next_msec));
-}
-
 static int af9013_get_tune_settings(struct dvb_frontend *fe,
 	struct dvb_frontend_tune_settings *fesettings)
 {
@@ -858,6 +632,9 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			stmp1, agc_gain, agc_gain_50dbm, agc_gain_80dbm);
 
 		state->strength_jiffies = jiffies;
+		/* Convert [-90, -30] dBm to [0x0000, 0xffff] for dvbv3 */
+		utmp1 = clamp(stmp1 + 90000, 0, 60000);
+		state->dvbv3_strength = div_u64((u64)utmp1 * 0xffff, 60000);
 
 		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
 		c->strength.stat[0].svalue = stmp1;
@@ -939,6 +716,7 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		dev_dbg(&client->dev, "cnr %u\n", utmp1);
 
 		state->cnr_jiffies = jiffies;
+		state->dvbv3_snr = utmp1 / 100;
 
 		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
 		c->cnr.stat[0].svalue = utmp1;
@@ -994,6 +772,8 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			utmp3, utmp4);
 
 		state->ber_ucb_jiffies = jiffies;
+		state->dvbv3_ber = utmp1;
+		state->dvbv3_ucblocks += utmp3;
 
 		c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 		c->post_bit_error.stat[0].uvalue += utmp1;
@@ -1023,28 +803,36 @@ static int af9013_read_status(struct dvb_frontend *fe, enum fe_status *status)
 static int af9013_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
 	struct af9013_state *state = fe->demodulator_priv;
-	*snr = state->snr;
+
+	*snr = state->dvbv3_snr;
+
 	return 0;
 }
 
 static int af9013_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
 {
 	struct af9013_state *state = fe->demodulator_priv;
-	*strength = state->signal_strength;
+
+	*strength = state->dvbv3_strength;
+
 	return 0;
 }
 
 static int af9013_read_ber(struct dvb_frontend *fe, u32 *ber)
 {
 	struct af9013_state *state = fe->demodulator_priv;
-	*ber = state->ber;
+
+	*ber = state->dvbv3_ber;
+
 	return 0;
 }
 
 static int af9013_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 {
 	struct af9013_state *state = fe->demodulator_priv;
-	*ucblocks = state->ucblocks;
+
+	*ucblocks = state->dvbv3_ucblocks;
+
 	return 0;
 }
 
@@ -1194,50 +982,7 @@ static int af9013_init(struct dvb_frontend *fe)
 	if (ret)
 		goto err;
 
-	/* check if we support signal strength */
-	if (!state->signal_strength_en) {
-		ret = regmap_read(state->regmap, 0x9bee, &utmp);
-		if (ret)
-			goto err;
-
-		state->signal_strength_en = (utmp >> 0) & 0x01;
-	}
-
-	/* read values needed for signal strength calculation */
-	if (state->signal_strength_en && !state->rf_50) {
-		ret = regmap_bulk_read(state->regmap, 0x9bbd, &state->rf_50, 1);
-		if (ret)
-			goto err;
-		ret = regmap_bulk_read(state->regmap, 0x9bd0, &state->rf_80, 1);
-		if (ret)
-			goto err;
-		ret = regmap_bulk_read(state->regmap, 0x9be2, &state->if_50, 1);
-		if (ret)
-			goto err;
-		ret = regmap_bulk_read(state->regmap, 0x9be4, &state->if_80, 1);
-		if (ret)
-			goto err;
-	}
-
-	/* SNR */
-	ret = regmap_write(state->regmap, 0xd2e2, 0x01);
-	if (ret)
-		goto err;
-
-	/* BER / UCB */
-	buf[0] = (10000 >> 0) & 0xff;
-	buf[1] = (10000 >> 8) & 0xff;
-	ret = regmap_bulk_write(state->regmap, 0xd385, buf, 2);
-	if (ret)
-		goto err;
-
-	/* enable FEC monitor */
-	ret = regmap_update_bits(state->regmap, 0xd392, 0x02, 0x02);
-	if (ret)
-		goto err;
-
 	state->first_tune = true;
-	schedule_delayed_work(&state->statistics_work, msecs_to_jiffies(400));
 
 	return 0;
 err:
@@ -1254,9 +999,6 @@ static int af9013_sleep(struct dvb_frontend *fe)
 
 	dev_dbg(&client->dev, "\n");
 
-	/* stop statistics polling */
-	cancel_delayed_work_sync(&state->statistics_work);
-
 	/* disable lock led */
 	ret = regmap_update_bits(state->regmap, 0xd730, 0x01, 0x00);
 	if (ret)
@@ -1696,7 +1438,6 @@ static int af9013_probe(struct i2c_client *client,
 	state->spec_inv = pdata->spec_inv;
 	memcpy(&state->api_version, pdata->api_version, sizeof(state->api_version));
 	memcpy(&state->gpio, pdata->gpio, sizeof(state->gpio));
-	INIT_DELAYED_WORK(&state->statistics_work, af9013_statistics_work);
 	state->regmap = regmap_init(&client->dev, &regmap_bus, client,
 				  &regmap_config);
 	if (IS_ERR(state->regmap)) {
@@ -1762,9 +1503,6 @@ static int af9013_remove(struct i2c_client *client)
 
 	dev_dbg(&client->dev, "\n");
 
-	/* Stop statistics polling */
-	cancel_delayed_work_sync(&state->statistics_work);
-
 	regmap_exit(state->regmap);
 
 	kfree(state);
diff --git a/drivers/media/dvb-frontends/af9013_priv.h b/drivers/media/dvb-frontends/af9013_priv.h
index 9c3cb04e3494..64f39d3db694 100644
--- a/drivers/media/dvb-frontends/af9013_priv.h
+++ b/drivers/media/dvb-frontends/af9013_priv.h
@@ -37,11 +37,6 @@ struct af9013_reg_bit {
 	u8  val;
 };
 
-struct af9013_snr {
-	u32 val;
-	u8 snr;
-};
-
 struct af9013_coeff {
 	u32 clock;
 	u32 bandwidth_hz;
@@ -92,69 +87,6 @@ static const struct af9013_coeff coeff_lut[] = {
 		0x2d, 0x00, 0x8c, 0x6a, 0xca, 0x01, 0x18, 0xde, 0x17 } },
 };
 
-/* QPSK SNR lookup table */
-static const struct af9013_snr qpsk_snr_lut[] = {
-	{ 0x000000,  0 },
-	{ 0x0b4771,  0 },
-	{ 0x0c1aed,  1 },
-	{ 0x0d0d27,  2 },
-	{ 0x0e4d19,  3 },
-	{ 0x0e5da8,  4 },
-	{ 0x107097,  5 },
-	{ 0x116975,  6 },
-	{ 0x1252d9,  7 },
-	{ 0x131fa4,  8 },
-	{ 0x13d5e1,  9 },
-	{ 0x148e53, 10 },
-	{ 0x15358b, 11 },
-	{ 0x15dd29, 12 },
-	{ 0x168112, 13 },
-	{ 0x170b61, 14 },
-	{ 0xffffff, 15 },
-};
-
-/* QAM16 SNR lookup table */
-static const struct af9013_snr qam16_snr_lut[] = {
-	{ 0x000000,  0 },
-	{ 0x05eb62,  5 },
-	{ 0x05fecf,  6 },
-	{ 0x060b80,  7 },
-	{ 0x062501,  8 },
-	{ 0x064865,  9 },
-	{ 0x069604, 10 },
-	{ 0x06f356, 11 },
-	{ 0x07706a, 12 },
-	{ 0x0804d3, 13 },
-	{ 0x089d1a, 14 },
-	{ 0x093e3d, 15 },
-	{ 0x09e35d, 16 },
-	{ 0x0a7c3c, 17 },
-	{ 0x0afaf8, 18 },
-	{ 0x0b719d, 19 },
-	{ 0xffffff, 20 },
-};
-
-/* QAM64 SNR lookup table */
-static const struct af9013_snr qam64_snr_lut[] = {
-	{ 0x000000,  0 },
-	{ 0x03109b, 12 },
-	{ 0x0310d4, 13 },
-	{ 0x031920, 14 },
-	{ 0x0322d0, 15 },
-	{ 0x0339fc, 16 },
-	{ 0x0364a1, 17 },
-	{ 0x038bcc, 18 },
-	{ 0x03c7d3, 19 },
-	{ 0x0408cc, 20 },
-	{ 0x043bed, 21 },
-	{ 0x048061, 22 },
-	{ 0x04be95, 23 },
-	{ 0x04fa7d, 24 },
-	{ 0x052405, 25 },
-	{ 0x05570d, 26 },
-	{ 0xffffff, 27 },
-};
-
 static const struct af9013_reg_bit ofsm_init[] = {
 	{ 0xd73a, 0, 8, 0xa1 },
 	{ 0xd73b, 0, 8, 0x1f },
-- 
2.14.3
