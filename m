Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59313 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755652AbaHVAjR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Aug 2014 20:39:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] m88ds3103: fix coding style issues
Date: Fri, 22 Aug 2014 03:39:08 +0300
Message-Id: <1408667948-13463-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix coding style issues pointed out by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index d8fbdfd..235608d 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -159,6 +159,7 @@ static int m88ds3103_wr_reg_val_tab(struct m88ds3103_priv *priv,
 {
 	int ret, i, j;
 	u8 buf[83];
+
 	dev_dbg(&priv->i2c->dev, "%s: tab_len=%d\n", __func__, tab_len);
 
 	if (tab_len > 83) {
@@ -249,6 +250,7 @@ static int m88ds3103_set_frontend(struct dvb_frontend *fe)
 	u16 u16tmp, divide_ratio;
 	u32 tuner_frequency, target_mclk;
 	s32 s32tmp;
+
 	dev_dbg(&priv->i2c->dev,
 			"%s: delivery_system=%d modulation=%d frequency=%d symbol_rate=%d inversion=%d pilot=%d rolloff=%d\n",
 			__func__, c->delivery_system,
@@ -520,6 +522,7 @@ static int m88ds3103_init(struct dvb_frontend *fe)
 	const struct firmware *fw = NULL;
 	u8 *fw_file = M88DS3103_FIRMWARE;
 	u8 u8tmp;
+
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	/* set cold state by default */
@@ -632,6 +635,7 @@ static int m88ds3103_sleep(struct dvb_frontend *fe)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	int ret;
+
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	priv->delivery_system = SYS_UNDEFINED;
@@ -666,6 +670,7 @@ static int m88ds3103_get_frontend(struct dvb_frontend *fe)
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	int ret;
 	u8 buf[3];
+
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	if (!priv->warm || !(priv->fe_status & FE_HAS_LOCK)) {
@@ -841,6 +846,7 @@ static int m88ds3103_read_snr(struct dvb_frontend *fe, u16 *snr)
 	u8 buf[3];
 	u16 noise, signal;
 	u32 noise_tot, signal_tot;
+
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 	/* reports SNR in resolution of 0.1 dB */
 
@@ -917,6 +923,7 @@ static int m88ds3103_read_ber(struct dvb_frontend *fe, u32 *ber)
 	int ret;
 	unsigned int utmp;
 	u8 buf[3], u8tmp;
+
 	dev_dbg(&priv->i2c->dev, "%s:\n", __func__);
 
 	switch (c->delivery_system) {
@@ -997,6 +1004,7 @@ static int m88ds3103_set_tone(struct dvb_frontend *fe,
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	int ret;
 	u8 u8tmp, tone, reg_a1_mask;
+
 	dev_dbg(&priv->i2c->dev, "%s: fe_sec_tone_mode=%d\n", __func__,
 			fe_sec_tone_mode);
 
@@ -1094,6 +1102,7 @@ static int m88ds3103_diseqc_send_master_cmd(struct dvb_frontend *fe,
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	int ret, i;
 	u8 u8tmp;
+
 	dev_dbg(&priv->i2c->dev, "%s: msg=%*ph\n", __func__,
 			diseqc_cmd->msg_len, diseqc_cmd->msg);
 
@@ -1165,6 +1174,7 @@ static int m88ds3103_diseqc_send_burst(struct dvb_frontend *fe,
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
 	int ret, i;
 	u8 u8tmp, burst;
+
 	dev_dbg(&priv->i2c->dev, "%s: fe_sec_mini_cmd=%d\n", __func__,
 			fe_sec_mini_cmd);
 
@@ -1237,6 +1247,7 @@ static int m88ds3103_get_tune_settings(struct dvb_frontend *fe,
 static void m88ds3103_release(struct dvb_frontend *fe)
 {
 	struct m88ds3103_priv *priv = fe->demodulator_priv;
+
 	i2c_del_mux_adapter(priv->i2c_adapter);
 	kfree(priv);
 }
-- 
http://palosaari.fi/

