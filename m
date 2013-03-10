Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43024 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 14/41] it913x: merge it913x_fe_start() to it913x_init_tuner()
Date: Sun, 10 Mar 2013 04:03:06 +0200
Message-Id: <1362881013-5271-14-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Merge those functions to one and disable sleep.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 165 ++++++++++++------------------------------
 1 file changed, 45 insertions(+), 120 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index 6ee4f97..f1938a1 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -43,7 +43,6 @@ struct it913x_fe_state {
 	u32 ucblocks;
 };
 
-
 static int it913x_read_reg(struct it913x_fe_state *state,
 		u32 reg, u8 *data, u8 count)
 {
@@ -147,10 +146,54 @@ static int it913x_init_tuner(struct dvb_frontend *fe)
 {
 	struct it913x_fe_state *state = fe->tuner_priv;
 	int ret, i, reg;
+	struct it913xset *set_lna;
 	u8 val, nv_val;
 	u8 nv[] = {48, 32, 24, 16, 12, 8, 6, 4, 2};
 	u8 b[2];
 
+	/* v1 or v2 tuner script */
+	if (state->config->chip_ver > 1)
+		ret = it913x_fe_script_loader(state, it9135_v2);
+	else
+		ret = it913x_fe_script_loader(state, it9135_v1);
+	if (ret < 0)
+		return ret;
+
+	/* LNA Scripts */
+	switch (state->tuner_type) {
+	case IT9135_51:
+		set_lna = it9135_51;
+		break;
+	case IT9135_52:
+		set_lna = it9135_52;
+		break;
+	case IT9135_60:
+		set_lna = it9135_60;
+		break;
+	case IT9135_61:
+		set_lna = it9135_61;
+		break;
+	case IT9135_62:
+		set_lna = it9135_62;
+		break;
+	case IT9135_38:
+	default:
+		set_lna = it9135_38;
+	}
+	pr_info("Tuner LNA type :%02x\n", state->tuner_type);
+
+	ret = it913x_fe_script_loader(state, set_lna);
+	if (ret < 0)
+		return ret;
+
+	if (state->config->chip_ver == 2) {
+		ret = it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x1);
+		ret |= it913x_write_reg(state, PRO_LINK, PADODPU, 0x0);
+		ret |= it913x_write_reg(state, PRO_LINK, AGC_O_D, 0x0);
+	}
+	if (ret < 0)
+		return -ENODEV;
+
 	reg = it913x_read_reg_u8(state, 0xec86);
 	switch (reg) {
 	case 0:
@@ -361,6 +404,7 @@ static int it9137_set_tuner(struct dvb_frontend *fe)
 static int it913x_fe_suspend(struct it913x_fe_state *state)
 {
 	int ret = 0;
+	return 0;
 #if 0
 	int ret, i;
 	u8 b;
@@ -397,121 +441,6 @@ static int it913x_fe_sleep(struct dvb_frontend *fe)
 	return it913x_fe_suspend(state);
 }
 
-static int it913x_fe_start(struct dvb_frontend *fe)
-{
-	struct it913x_fe_state *state = fe->tuner_priv;
-	struct it913xset *set_lna;
-//	struct it913xset *set_mode;
-	int ret;
-//	u8 adf = (state->config->adf & 0xf);
-//	u32 adc, xtal;
-//	u8 b[4];
-
-	if (state->config->chip_ver == 1)
-		ret = it913x_init_tuner(fe);
-
-#if 0
-	pr_info("ADF table value	:%02x\n", adf);
-
-	if (adf < 10) {
-		state->crystalFrequency = fe_clockTable[adf].xtal ;
-		state->table = fe_clockTable[adf].table;
-		state->adcFrequency = state->table->adcFrequency;
-
-		adc = compute_div(state->adcFrequency, 1000000ul, 19ul);
-		xtal = compute_div(state->crystalFrequency, 1000000ul, 19ul);
-
-	} else
-		return -EINVAL;
-
-	/* Set LED indicator on GPIOH3 */
-	ret = it913x_write_reg(state, PRO_LINK, GPIOH3_EN, 0x1);
-	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_ON, 0x1);
-	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x1);
-
-	ret |= it913x_write_reg(state, PRO_LINK, 0xf641, state->tuner_type);
-	ret |= it913x_write_reg(state, PRO_DMOD, 0xf5ca, 0x01);
-	ret |= it913x_write_reg(state, PRO_DMOD, 0xf715, 0x01);
-
-	b[0] = xtal & 0xff;
-	b[1] = (xtal >> 8) & 0xff;
-	b[2] = (xtal >> 16) & 0xff;
-	b[3] = (xtal >> 24);
-	ret |= it913x_write(state, PRO_DMOD, XTAL_CLK, b , 4);
-
-	b[0] = adc & 0xff;
-	b[1] = (adc >> 8) & 0xff;
-	b[2] = (adc >> 16) & 0xff;
-	ret |= it913x_write(state, PRO_DMOD, ADC_FREQ, b, 3);
-
-	if (state->config->adc_x2)
-		ret |= it913x_write_reg(state, PRO_DMOD, ADC_X_2, 0x01);
-	b[0] = 0;
-	b[1] = 0;
-	b[2] = 0;
-	ret |= it913x_write(state, PRO_DMOD, 0x0029, b, 3);
-
-	pr_info("Crystal Frequency :%d Adc Frequency :%d ADC X2: %02x\n",
-		state->crystalFrequency, state->adcFrequency,
-			state->config->adc_x2);
-	pr_debug("Xtal value :%04x Adc value :%04x\n", xtal, adc);
-
-	if (ret < 0)
-		return -ENODEV;
-#endif
-
-	/* v1 or v2 tuner script */
-	if (state->config->chip_ver > 1)
-		ret = it913x_fe_script_loader(state, it9135_v2);
-	else
-		ret = it913x_fe_script_loader(state, it9135_v1);
-	if (ret < 0)
-		return ret;
-
-	/* LNA Scripts */
-	switch (state->tuner_type) {
-	case IT9135_51:
-		set_lna = it9135_51;
-		break;
-	case IT9135_52:
-		set_lna = it9135_52;
-		break;
-	case IT9135_60:
-		set_lna = it9135_60;
-		break;
-	case IT9135_61:
-		set_lna = it9135_61;
-		break;
-	case IT9135_62:
-		set_lna = it9135_62;
-		break;
-	case IT9135_38:
-	default:
-		set_lna = it9135_38;
-	}
-	pr_info("Tuner LNA type :%02x\n", state->tuner_type);
-
-	ret = it913x_fe_script_loader(state, set_lna);
-	if (ret < 0)
-		return ret;
-
-	if (state->config->chip_ver == 2) {
-		ret = it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x1);
-		ret |= it913x_write_reg(state, PRO_LINK, PADODPU, 0x0);
-		ret |= it913x_write_reg(state, PRO_LINK, AGC_O_D, 0x0);
-		ret |= it913x_init_tuner(fe);
-	}
-	if (ret < 0)
-		return -ENODEV;
-
-	/* Always solo frontend */
-//	set_mode = set_solo_fe;
-//	ret |= it913x_fe_script_loader(state, set_mode);
-
-	ret |= it913x_fe_suspend(state);
-	return (ret < 0) ? -ENODEV : 0;
-}
-
 static int it913x_release(struct dvb_frontend *fe)
 {
 	kfree(fe->tuner_priv);
@@ -566,10 +495,6 @@ struct dvb_frontend *it913x_attach(struct dvb_frontend *fe,
 	memcpy(&fe->ops.tuner_ops, &it913x_tuner_ops,
 			sizeof(struct dvb_tuner_ops));
 
-	ret = it913x_fe_start(fe);
-	if (ret < 0)
-		goto error;
-
 	pr_info("%s: ITE Tech IT913X attached\n", KBUILD_MODNAME);
 
 	return fe;
-- 
1.7.11.7

