Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:44650 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750753AbdKEOZT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 5 Nov 2017 09:25:19 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 04/15] si2165: define register macros
Date: Sun,  5 Nov 2017 15:25:00 +0100
Message-Id: <20171105142511.16563-4-zzam@gentoo.org>
In-Reply-To: <20171105142511.16563-1-zzam@gentoo.org>
References: <20171105142511.16563-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert register numbers to macros.

Correctness verified by comparing the disassembly before and after.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c      | 206 +++++++++++++++---------------
 drivers/media/dvb-frontends/si2165_priv.h |  65 ++++++++++
 2 files changed, 169 insertions(+), 102 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 6b22d079ecef..0f5325798bd2 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -239,18 +239,18 @@ static int si2165_init_pll(struct si2165_state *state)
 	state->adc_clk = state->fvco_hz / (divm * 4u);
 	state->sys_clk = state->fvco_hz / (divl * 2u);
 
-	/* write pll registers 0x00a0..0x00a3 at once */
+	/* write all 4 pll registers 0x00a0..0x00a3 at once */
 	buf[0] = divl;
 	buf[1] = divm;
 	buf[2] = (divn & 0x3f) | ((divp == 1) ? 0x40 : 0x00) | 0x80;
 	buf[3] = divr;
-	return si2165_write(state, 0x00a0, buf, 4);
+	return si2165_write(state, REG_PLL_DIVL, buf, 4);
 }
 
 static int si2165_adjust_pll_divl(struct si2165_state *state, u8 divl)
 {
 	state->sys_clk = state->fvco_hz / (divl * 2u);
-	return si2165_writereg8(state, 0x00a0, divl); /* pll_divl */
+	return si2165_writereg8(state, REG_PLL_DIVL, divl);
 }
 
 static u32 si2165_get_fe_clk(struct si2165_state *state)
@@ -266,7 +266,7 @@ static int si2165_wait_init_done(struct si2165_state *state)
 	int i;
 
 	for (i = 0; i < 3; ++i) {
-		si2165_readreg8(state, 0x0054, &val);
+		si2165_readreg8(state, REG_INIT_DONE, &val);
 		if (val == 0x01)
 			return 0;
 		usleep_range(1000, 50000);
@@ -315,17 +315,18 @@ static int si2165_upload_firmware_block(struct si2165_state *state,
 
 		buf_ctrl[0] = wordcount - 1;
 
-		ret = si2165_write(state, 0x0364, buf_ctrl, 4);
+		ret = si2165_write(state, REG_DCOM_CONTROL_BYTE, buf_ctrl, 4);
 		if (ret < 0)
 			goto error;
-		ret = si2165_write(state, 0x0368, data + offset + 4, 4);
+		ret = si2165_write(state, REG_DCOM_ADDR, data + offset + 4, 4);
 		if (ret < 0)
 			goto error;
 
 		offset += 8;
 
 		while (wordcount > 0) {
-			ret = si2165_write(state, 0x36c, data + offset, 4);
+			ret = si2165_write(state, REG_DCOM_DATA,
+					   data + offset, 4);
 			if (ret < 0)
 				goto error;
 			wordcount--;
@@ -415,26 +416,26 @@ static int si2165_upload_firmware(struct si2165_state *state)
 
 	/* start uploading fw */
 	/* boot/wdog status */
-	ret = si2165_writereg8(state, 0x0341, 0x00);
+	ret = si2165_writereg8(state, REG_WDOG_AND_BOOT, 0x00);
 	if (ret < 0)
 		goto error;
 	/* reset */
-	ret = si2165_writereg8(state, 0x00c0, 0x00);
+	ret = si2165_writereg8(state, REG_RST_ALL, 0x00);
 	if (ret < 0)
 		goto error;
 	/* boot/wdog status */
-	ret = si2165_readreg8(state, 0x0341, val);
+	ret = si2165_readreg8(state, REG_WDOG_AND_BOOT, val);
 	if (ret < 0)
 		goto error;
 
 	/* enable reset on error */
-	ret = si2165_readreg8(state, 0x035c, val);
+	ret = si2165_readreg8(state, REG_EN_RST_ERROR, val);
 	if (ret < 0)
 		goto error;
-	ret = si2165_readreg8(state, 0x035c, val);
+	ret = si2165_readreg8(state, REG_EN_RST_ERROR, val);
 	if (ret < 0)
 		goto error;
-	ret = si2165_writereg8(state, 0x035c, 0x02);
+	ret = si2165_writereg8(state, REG_EN_RST_ERROR, 0x02);
 	if (ret < 0)
 		goto error;
 
@@ -448,12 +449,12 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	if (ret < 0)
 		goto error;
 
-	ret = si2165_writereg8(state, 0x0344, patch_version);
+	ret = si2165_writereg8(state, REG_PATCH_VERSION, patch_version);
 	if (ret < 0)
 		goto error;
 
 	/* reset crc */
-	ret = si2165_writereg8(state, 0x0379, 0x01);
+	ret = si2165_writereg8(state, REG_RST_CRC, 0x01);
 	if (ret)
 		goto error;
 
@@ -466,7 +467,7 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	}
 
 	/* read crc */
-	ret = si2165_readreg16(state, 0x037a, &val16);
+	ret = si2165_readreg16(state, REG_CRC, &val16);
 	if (ret)
 		goto error;
 
@@ -491,12 +492,12 @@ static int si2165_upload_firmware(struct si2165_state *state)
 	}
 
 	/* reset watchdog error register */
-	ret = si2165_writereg_mask8(state, 0x0341, 0x02, 0x02);
+	ret = si2165_writereg_mask8(state, REG_WDOG_AND_BOOT, 0x02, 0x02);
 	if (ret < 0)
 		goto error;
 
 	/* enable reset on error */
-	ret = si2165_writereg_mask8(state, 0x035c, 0x01, 0x01);
+	ret = si2165_writereg_mask8(state, REG_EN_RST_ERROR, 0x01, 0x01);
 	if (ret < 0)
 		goto error;
 
@@ -523,14 +524,15 @@ static int si2165_init(struct dvb_frontend *fe)
 	dev_dbg(&state->client->dev, "%s: called\n", __func__);
 
 	/* powerup */
-	ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
+	ret = si2165_writereg8(state, REG_CHIP_MODE, state->config.chip_mode);
 	if (ret < 0)
 		goto error;
 	/* dsp_clock_enable */
-	ret = si2165_writereg8(state, 0x0104, 0x01);
+	ret = si2165_writereg8(state, REG_DSP_CLOCK, 0x01);
 	if (ret < 0)
 		goto error;
-	ret = si2165_readreg8(state, 0x0000, &val); /* verify chip_mode */
+	/* verify chip_mode */
+	ret = si2165_readreg8(state, REG_CHIP_MODE, &val);
 	if (ret < 0)
 		goto error;
 	if (val != state->config.chip_mode) {
@@ -539,23 +541,23 @@ static int si2165_init(struct dvb_frontend *fe)
 	}
 
 	/* agc */
-	ret = si2165_writereg8(state, 0x018b, 0x00);
+	ret = si2165_writereg8(state, REG_AGC_IF_TRI, 0x00);
 	if (ret < 0)
 		goto error;
-	ret = si2165_writereg8(state, 0x0190, 0x01);
+	ret = si2165_writereg8(state, REG_AGC_IF_SLR, 0x01);
 	if (ret < 0)
 		goto error;
-	ret = si2165_writereg8(state, 0x0170, 0x00);
+	ret = si2165_writereg8(state, REG_AGC2_OUTPUT, 0x00);
 	if (ret < 0)
 		goto error;
-	ret = si2165_writereg8(state, 0x0171, 0x07);
+	ret = si2165_writereg8(state, REG_AGC2_CLKDIV, 0x07);
 	if (ret < 0)
 		goto error;
 	/* rssi pad */
-	ret = si2165_writereg8(state, 0x0646, 0x00);
+	ret = si2165_writereg8(state, REG_RSSI_PAD_CTRL, 0x00);
 	if (ret < 0)
 		goto error;
-	ret = si2165_writereg8(state, 0x0641, 0x00);
+	ret = si2165_writereg8(state, REG_RSSI_ENABLE, 0x00);
 	if (ret < 0)
 		goto error;
 
@@ -564,11 +566,11 @@ static int si2165_init(struct dvb_frontend *fe)
 		goto error;
 
 	/* enable chip_init */
-	ret = si2165_writereg8(state, 0x0050, 0x01);
+	ret = si2165_writereg8(state, REG_CHIP_INIT, 0x01);
 	if (ret < 0)
 		goto error;
 	/* set start_init */
-	ret = si2165_writereg8(state, 0x0096, 0x01);
+	ret = si2165_writereg8(state, REG_START_INIT, 0x01);
 	if (ret < 0)
 		goto error;
 	ret = si2165_wait_init_done(state);
@@ -576,29 +578,29 @@ static int si2165_init(struct dvb_frontend *fe)
 		goto error;
 
 	/* disable chip_init */
-	ret = si2165_writereg8(state, 0x0050, 0x00);
+	ret = si2165_writereg8(state, REG_CHIP_INIT, 0x00);
 	if (ret < 0)
 		goto error;
 
 	/* ber_pkt */
-	ret = si2165_writereg16(state, 0x0470, 0x7530);
+	ret = si2165_writereg16(state, REG_BER_PKT, 0x7530);
 	if (ret < 0)
 		goto error;
 
-	ret = si2165_readreg8(state, 0x0344, &patch_version);
+	ret = si2165_readreg8(state, REG_PATCH_VERSION, &patch_version);
 	if (ret < 0)
 		goto error;
 
-	ret = si2165_writereg8(state, 0x00cb, 0x00);
+	ret = si2165_writereg8(state, REG_AUTO_RESET, 0x00);
 	if (ret < 0)
 		goto error;
 
 	/* dsp_addr_jump */
-	ret = si2165_writereg32(state, 0x0348, 0xf4000000);
+	ret = si2165_writereg32(state, REG_ADDR_JUMP, 0xf4000000);
 	if (ret < 0)
 		goto error;
 	/* boot/wdog status */
-	ret = si2165_readreg8(state, 0x0341, &val);
+	ret = si2165_readreg8(state, REG_WDOG_AND_BOOT, &val);
 	if (ret < 0)
 		goto error;
 
@@ -609,16 +611,16 @@ static int si2165_init(struct dvb_frontend *fe)
 	}
 
 	/* ts output config */
-	ret = si2165_writereg8(state, 0x04e4, 0x20);
+	ret = si2165_writereg8(state, REG_TS_DATA_MODE, 0x20);
 	if (ret < 0)
 		return ret;
-	ret = si2165_writereg16(state, 0x04ef, 0x00fe);
+	ret = si2165_writereg16(state, REG_TS_TRI, 0x00fe);
 	if (ret < 0)
 		return ret;
-	ret = si2165_writereg24(state, 0x04f4, 0x555555);
+	ret = si2165_writereg24(state, REG_TS_SLR, 0x555555);
 	if (ret < 0)
 		return ret;
-	ret = si2165_writereg8(state, 0x04e5, 0x01);
+	ret = si2165_writereg8(state, REG_TS_CLK_MODE, 0x01);
 	if (ret < 0)
 		return ret;
 
@@ -633,11 +635,11 @@ static int si2165_sleep(struct dvb_frontend *fe)
 	struct si2165_state *state = fe->demodulator_priv;
 
 	/* dsp clock disable */
-	ret = si2165_writereg8(state, 0x0104, 0x00);
+	ret = si2165_writereg8(state, REG_DSP_CLOCK, 0x00);
 	if (ret < 0)
 		return ret;
 	/* chip mode */
-	ret = si2165_writereg8(state, 0x0000, SI2165_MODE_OFF);
+	ret = si2165_writereg8(state, REG_CHIP_MODE, SI2165_MODE_OFF);
 	if (ret < 0)
 		return ret;
 	return 0;
@@ -653,7 +655,7 @@ static int si2165_read_status(struct dvb_frontend *fe, enum fe_status *status)
 		return -EINVAL;
 
 	/* check fec_lock */
-	ret = si2165_readreg8(state, 0x4e0, &fec_lock);
+	ret = si2165_readreg8(state, REG_FEC_LOCK, &fec_lock);
 	if (ret < 0)
 		return ret;
 	*status = 0;
@@ -682,7 +684,7 @@ static int si2165_set_oversamp(struct si2165_state *state, u32 dvb_rate)
 	reg_value = oversamp & 0x3fffffff;
 
 	dev_dbg(&state->client->dev, "Write oversamp=%#x\n", reg_value);
-	return si2165_writereg32(state, 0x00e4, reg_value);
+	return si2165_writereg32(state, REG_OVERSAMP, reg_value);
 }
 
 static int si2165_set_if_freq_shift(struct si2165_state *state)
@@ -715,30 +717,30 @@ static int si2165_set_if_freq_shift(struct si2165_state *state)
 	reg_value = reg_value & 0x1fffffff;
 
 	/* if_freq_shift, usbdump contained 0x023ee08f; */
-	return si2165_writereg32(state, 0x00e8, reg_value);
+	return si2165_writereg32(state, REG_IF_FREQ_SHIFT, reg_value);
 }
 
 static const struct si2165_reg_value_pair dvbt_regs[] = {
 	/* standard = DVB-T */
-	{ 0x00ec, 0x01 },
-	{ 0x08f8, 0x00 },
+	{ REG_DVB_STANDARD, 0x01 },
+	{ REG_TS_PARALLEL_MODE, 0x00 },
 	/* impulsive_noise_remover */
-	{ 0x031c, 0x01 },
-	{ 0x00cb, 0x00 },
+	{ REG_IMPULSIVE_NOISE_REM, 0x01 },
+	{ REG_AUTO_RESET, 0x00 },
 	/* agc2 */
-	{ 0x016e, 0x41 },
-	{ 0x016c, 0x0e },
-	{ 0x016d, 0x10 },
+	{ REG_AGC2_MIN, 0x41 },
+	{ REG_AGC2_KACQ, 0x0e },
+	{ REG_AGC2_KLOC, 0x10 },
 	/* agc */
-	{ 0x015b, 0x03 },
-	{ 0x0150, 0x78 },
+	{ REG_AGC_UNFREEZE_THR, 0x03 },
+	{ REG_AGC_CRESTF_DBX8, 0x78 },
 	/* agc */
-	{ 0x01a0, 0x78 },
-	{ 0x01c8, 0x68 },
+	{ REG_AAF_CRESTF_DBX8, 0x78 },
+	{ REG_ACI_CRESTF_DBX8, 0x68 },
 	/* freq_sync_range */
-	REG16(0x030c, 0x0064),
+	REG16(REG_FREQ_SYNC_RANGE, 0x0064),
 	/* gp_reg0 */
-	{ 0x0387, 0x00 }
+	{ REG_GP_REG0_MSB, 0x00 }
 };
 
 static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
@@ -767,7 +769,7 @@ static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
 		return ret;
 
 	/* bandwidth in 10KHz steps */
-	ret = si2165_writereg16(state, 0x0308, bw10k);
+	ret = si2165_writereg16(state, REG_T_BANDWIDTH, bw10k);
 	if (ret < 0)
 		return ret;
 	ret = si2165_set_oversamp(state, dvb_rate);
@@ -783,33 +785,33 @@ static int si2165_set_frontend_dvbt(struct dvb_frontend *fe)
 
 static const struct si2165_reg_value_pair dvbc_regs[] = {
 	/* standard = DVB-C */
-	{ 0x00ec, 0x05 },
-	{ 0x08f8, 0x00 },
+	{ REG_DVB_STANDARD, 0x05 },
+	{ REG_TS_PARALLEL_MODE, 0x00 },
 
 	/* agc2 */
-	{ 0x016e, 0x50 },
-	{ 0x016c, 0x0e },
-	{ 0x016d, 0x10 },
+	{ REG_AGC2_MIN, 0x50 },
+	{ REG_AGC2_KACQ, 0x0e },
+	{ REG_AGC2_KLOC, 0x10 },
 	/* agc */
-	{ 0x015b, 0x03 },
-	{ 0x0150, 0x68 },
+	{ REG_AGC_UNFREEZE_THR, 0x03 },
+	{ REG_AGC_CRESTF_DBX8, 0x68 },
 	/* agc */
-	{ 0x01a0, 0x68 },
-	{ 0x01c8, 0x50 },
-
-	{ 0x0278, 0x0d },
-
-	{ 0x023a, 0x05 },
-	{ 0x0261, 0x09 },
-	REG16(0x0350, 0x3e80),
-	{ 0x02f4, 0x00 },
-
-	{ 0x00cb, 0x01 },
-	REG16(0x024c, 0x0000),
-	REG16(0x027c, 0x0000),
-	{ 0x0232, 0x03 },
-	{ 0x02f4, 0x0b },
-	{ 0x018b, 0x00 },
+	{ REG_AAF_CRESTF_DBX8, 0x68 },
+	{ REG_ACI_CRESTF_DBX8, 0x50 },
+
+	{ REG_EQ_AUTO_CONTROL, 0x0d },
+
+	{ REG_KP_LOCK, 0x05 },
+	{ REG_CENTRAL_TAP, 0x09 },
+	REG16(REG_UNKNOWN_350, 0x3e80),
+	{ REG_REQ_CONSTELLATION, 0x00 },
+
+	{ REG_AUTO_RESET, 0x01 },
+	REG16(REG_UNKNOWN_24C, 0x0000),
+	REG16(REG_UNKNOWN_27C, 0x0000),
+	{ REG_SWEEP_STEP, 0x03 },
+	{ REG_REQ_CONSTELLATION, 0x0b },
+	{ REG_AGC_IF_TRI, 0x00 },
 };
 
 static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
@@ -835,7 +837,7 @@ static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
 	if (ret < 0)
 		return ret;
 
-	ret = si2165_writereg32(state, 0x00c4, bw_hz);
+	ret = si2165_writereg32(state, REG_LOCK_TIMEOUT, bw_hz);
 	if (ret < 0)
 		return ret;
 
@@ -846,12 +848,12 @@ static int si2165_set_frontend_dvbc(struct dvb_frontend *fe)
 	return 0;
 }
 
-static const struct si2165_reg_value_pair agc_rewrite[] = {
-	{ 0x012a, 0x46 },
-	{ 0x012c, 0x00 },
-	{ 0x012e, 0x0a },
-	{ 0x012f, 0xff },
-	{ 0x0123, 0x70 }
+static const struct si2165_reg_value_pair adc_rewrite[] = {
+	{ REG_ADC_RI1, 0x46 },
+	{ REG_ADC_RI3, 0x00 },
+	{ REG_ADC_RI5, 0x0a },
+	{ REG_ADC_RI6, 0xff },
+	{ REG_ADC_RI8, 0x70 }
 };
 
 static int si2165_set_frontend(struct dvb_frontend *fe)
@@ -883,7 +885,7 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	}
 
 	/* dsp_addr_jump */
-	ret = si2165_writereg32(state, 0x0348, 0xf4000000);
+	ret = si2165_writereg32(state, REG_ADDR_JUMP, 0xf4000000);
 	if (ret < 0)
 		return ret;
 
@@ -896,34 +898,34 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 		return ret;
 
 	/* boot/wdog status */
-	ret = si2165_readreg8(state, 0x0341, val);
+	ret = si2165_readreg8(state, REG_WDOG_AND_BOOT, val);
 	if (ret < 0)
 		return ret;
-	ret = si2165_writereg8(state, 0x0341, 0x00);
+	ret = si2165_writereg8(state, REG_WDOG_AND_BOOT, 0x00);
 	if (ret < 0)
 		return ret;
 
 	/* reset all */
-	ret = si2165_writereg8(state, 0x00c0, 0x00);
+	ret = si2165_writereg8(state, REG_RST_ALL, 0x00);
 	if (ret < 0)
 		return ret;
 	/* gp_reg0 */
-	ret = si2165_writereg32(state, 0x0384, 0x00000000);
+	ret = si2165_writereg32(state, REG_GP_REG0_LSB, 0x00000000);
 	if (ret < 0)
 		return ret;
 
 	/* write adc values after each reset*/
-	ret = si2165_write_reg_list(state, agc_rewrite,
-				    ARRAY_SIZE(agc_rewrite));
+	ret = si2165_write_reg_list(state, adc_rewrite,
+				    ARRAY_SIZE(adc_rewrite));
 	if (ret < 0)
 		return ret;
 
 	/* start_synchro */
-	ret = si2165_writereg8(state, 0x02e0, 0x01);
+	ret = si2165_writereg8(state, REG_START_SYNCHRO, 0x01);
 	if (ret < 0)
 		return ret;
 	/* boot/wdog status */
-	ret = si2165_readreg8(state, 0x0341, val);
+	ret = si2165_readreg8(state, REG_WDOG_AND_BOOT, val);
 	if (ret < 0)
 		return ret;
 
@@ -1020,26 +1022,26 @@ static int si2165_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, state);
 
 	/* powerup */
-	ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
+	ret = si2165_writereg8(state, REG_CHIP_MODE, state->config.chip_mode);
 	if (ret < 0)
 		goto nodev_error;
 
-	ret = si2165_readreg8(state, 0x0000, &val);
+	ret = si2165_readreg8(state, REG_CHIP_MODE, &val);
 	if (ret < 0)
 		goto nodev_error;
 	if (val != state->config.chip_mode)
 		goto nodev_error;
 
-	ret = si2165_readreg8(state, 0x0023, &state->chip_revcode);
+	ret = si2165_readreg8(state, REG_CHIP_REVCODE, &state->chip_revcode);
 	if (ret < 0)
 		goto nodev_error;
 
-	ret = si2165_readreg8(state, 0x0118, &state->chip_type);
+	ret = si2165_readreg8(state, REV_CHIP_TYPE, &state->chip_type);
 	if (ret < 0)
 		goto nodev_error;
 
 	/* powerdown */
-	ret = si2165_writereg8(state, 0x0000, SI2165_MODE_OFF);
+	ret = si2165_writereg8(state, REG_CHIP_MODE, SI2165_MODE_OFF);
 	if (ret < 0)
 		goto nodev_error;
 
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index 3d10cb4486c5..da8bbda8a4e3 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -38,4 +38,69 @@ struct si2165_config {
 	bool inversion;
 };
 
+#define REG_CHIP_MODE			0x0000
+#define REG_CHIP_REVCODE		0x0023
+#define REV_CHIP_TYPE			0x0118
+#define REG_CHIP_INIT			0x0050
+#define REG_INIT_DONE			0x0054
+#define REG_START_INIT			0x0096
+#define REG_PLL_DIVL			0x00a0
+#define REG_RST_ALL			0x00c0
+#define REG_LOCK_TIMEOUT		0x00c4
+#define REG_AUTO_RESET			0x00cb
+#define REG_OVERSAMP			0x00e4
+#define REG_IF_FREQ_SHIFT		0x00e8
+#define REG_DVB_STANDARD		0x00ec
+#define REG_DSP_CLOCK			0x0104
+#define REG_ADC_RI8			0x0123
+#define REG_ADC_RI1			0x012a
+#define REG_ADC_RI2			0x012b
+#define REG_ADC_RI3			0x012c
+#define REG_ADC_RI4			0x012d
+#define REG_ADC_RI5			0x012e
+#define REG_ADC_RI6			0x012f
+#define REG_AGC_CRESTF_DBX8		0x0150
+#define REG_AGC_UNFREEZE_THR		0x015b
+#define REG_AGC2_MIN			0x016e
+#define REG_AGC2_KACQ			0x016c
+#define REG_AGC2_KLOC			0x016d
+#define REG_AGC2_OUTPUT			0x0170
+#define REG_AGC2_CLKDIV			0x0171
+#define REG_AGC_IF_TRI			0x018b
+#define REG_AGC_IF_SLR			0x0190
+#define REG_AAF_CRESTF_DBX8		0x01a0
+#define REG_ACI_CRESTF_DBX8		0x01c8
+#define REG_SWEEP_STEP			0x0232
+#define REG_KP_LOCK			0x023a
+#define REG_UNKNOWN_24C			0x024c
+#define REG_CENTRAL_TAP			0x0261
+#define REG_EQ_AUTO_CONTROL		0x0278
+#define REG_UNKNOWN_27C			0x027c
+#define REG_START_SYNCHRO		0x02e0
+#define REG_REQ_CONSTELLATION		0x02f4
+#define REG_T_BANDWIDTH			0x0308
+#define REG_FREQ_SYNC_RANGE		0x030c
+#define REG_IMPULSIVE_NOISE_REM		0x031c
+#define REG_WDOG_AND_BOOT		0x0341
+#define REG_PATCH_VERSION		0x0344
+#define REG_ADDR_JUMP			0x0348
+#define REG_UNKNOWN_350			0x0350
+#define REG_EN_RST_ERROR		0x035c
+#define REG_DCOM_CONTROL_BYTE		0x0364
+#define REG_DCOM_ADDR			0x0368
+#define REG_DCOM_DATA			0x036c
+#define REG_RST_CRC			0x0379
+#define REG_GP_REG0_LSB			0x0384
+#define REG_GP_REG0_MSB			0x0387
+#define REG_CRC				0x037a
+#define REG_BER_PKT			0x0470
+#define REG_FEC_LOCK			0x04e0
+#define REG_TS_DATA_MODE		0x04e4
+#define REG_TS_CLK_MODE			0x04e5
+#define REG_TS_TRI			0x04ef
+#define REG_TS_SLR			0x04f4
+#define REG_RSSI_ENABLE			0x0641
+#define REG_RSSI_PAD_CTRL		0x0646
+#define REG_TS_PARALLEL_MODE		0x08f8
+
 #endif /* _DVB_SI2165_PRIV */
-- 
2.15.0
