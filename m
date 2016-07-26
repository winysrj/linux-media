Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:55122 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbcGZHJm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2016 03:09:42 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, crope@iki.fi,
	Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH 5/7] si2165: Remove legacy attach
Date: Tue, 26 Jul 2016 09:09:06 +0200
Message-Id: <20160726070908.10135-5-zzam@gentoo.org>
In-Reply-To: <20160726070908.10135-1-zzam@gentoo.org>
References: <20160726070908.10135-1-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that all users of legacy attach are converted it can be removed.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/dvb-frontends/si2165.c      | 117 ------------------------------
 drivers/media/dvb-frontends/si2165.h      |  31 --------
 drivers/media/dvb-frontends/si2165_priv.h |  17 +++++
 3 files changed, 17 insertions(+), 148 deletions(-)

diff --git a/drivers/media/dvb-frontends/si2165.c b/drivers/media/dvb-frontends/si2165.c
index 2d9bbdd..e979fc0 100644
--- a/drivers/media/dvb-frontends/si2165.c
+++ b/drivers/media/dvb-frontends/si2165.c
@@ -1005,14 +1005,6 @@ static int si2165_set_frontend(struct dvb_frontend *fe)
 	return 0;
 }
 
-static void si2165_release(struct dvb_frontend *fe)
-{
-	struct si2165_state *state = fe->demodulator_priv;
-
-	dprintk("%s: called\n", __func__);
-	kfree(state);
-}
-
 static struct dvb_frontend_ops si2165_ops = {
 	.info = {
 		.name = "Silicon Labs ",
@@ -1048,117 +1040,8 @@ static struct dvb_frontend_ops si2165_ops = {
 
 	.set_frontend      = si2165_set_frontend,
 	.read_status       = si2165_read_status,
-
-	.release = si2165_release,
 };
 
-struct dvb_frontend *si2165_attach(const struct si2165_config *config,
-				   struct i2c_adapter *i2c)
-{
-	struct si2165_state *state = NULL;
-	int n;
-	int io_ret;
-	u8 val;
-	char rev_char;
-	const char *chip_name;
-
-	if (config == NULL || i2c == NULL)
-		goto error;
-
-	/* allocate memory for the internal state */
-	state = kzalloc(sizeof(struct si2165_state), GFP_KERNEL);
-	if (state == NULL)
-		goto error;
-
-	/* setup the state */
-	state->i2c = i2c;
-	state->config = *config;
-
-	if (state->config.ref_freq_Hz < 4000000
-	    || state->config.ref_freq_Hz > 27000000) {
-		dev_err(&state->i2c->dev, "%s: ref_freq of %d Hz not supported by this driver\n",
-			 KBUILD_MODNAME, state->config.ref_freq_Hz);
-		goto error;
-	}
-
-	/* create dvb_frontend */
-	memcpy(&state->fe.ops, &si2165_ops,
-		sizeof(struct dvb_frontend_ops));
-	state->fe.demodulator_priv = state;
-
-	/* powerup */
-	io_ret = si2165_writereg8(state, 0x0000, state->config.chip_mode);
-	if (io_ret < 0)
-		goto error;
-
-	io_ret = si2165_readreg8(state, 0x0000, &val);
-	if (io_ret < 0)
-		goto error;
-	if (val != state->config.chip_mode)
-		goto error;
-
-	io_ret = si2165_readreg8(state, 0x0023, &state->chip_revcode);
-	if (io_ret < 0)
-		goto error;
-
-	io_ret = si2165_readreg8(state, 0x0118, &state->chip_type);
-	if (io_ret < 0)
-		goto error;
-
-	/* powerdown */
-	io_ret = si2165_writereg8(state, 0x0000, SI2165_MODE_OFF);
-	if (io_ret < 0)
-		goto error;
-
-	if (state->chip_revcode < 26)
-		rev_char = 'A' + state->chip_revcode;
-	else
-		rev_char = '?';
-
-	switch (state->chip_type) {
-	case 0x06:
-		chip_name = "Si2161";
-		state->has_dvbt = true;
-		break;
-	case 0x07:
-		chip_name = "Si2165";
-		state->has_dvbt = true;
-		state->has_dvbc = true;
-		break;
-	default:
-		dev_err(&state->i2c->dev, "%s: Unsupported Silicon Labs chip (type %d, rev %d)\n",
-			KBUILD_MODNAME, state->chip_type, state->chip_revcode);
-		goto error;
-	}
-
-	dev_info(&state->i2c->dev,
-		"%s: Detected Silicon Labs %s-%c (type %d, rev %d)\n",
-		KBUILD_MODNAME, chip_name, rev_char, state->chip_type,
-		state->chip_revcode);
-
-	strlcat(state->fe.ops.info.name, chip_name,
-			sizeof(state->fe.ops.info.name));
-
-	n = 0;
-	if (state->has_dvbt) {
-		state->fe.ops.delsys[n++] = SYS_DVBT;
-		strlcat(state->fe.ops.info.name, " DVB-T",
-			sizeof(state->fe.ops.info.name));
-	}
-	if (state->has_dvbc) {
-		state->fe.ops.delsys[n++] = SYS_DVBC_ANNEX_A;
-		strlcat(state->fe.ops.info.name, " DVB-C",
-			sizeof(state->fe.ops.info.name));
-	}
-
-	return &state->fe;
-
-error:
-	kfree(state);
-	return NULL;
-}
-EXPORT_SYMBOL(si2165_attach);
-
 static int si2165_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
diff --git a/drivers/media/dvb-frontends/si2165.h b/drivers/media/dvb-frontends/si2165.h
index abbebc9..76c2ca7 100644
--- a/drivers/media/dvb-frontends/si2165.h
+++ b/drivers/media/dvb-frontends/si2165.h
@@ -50,35 +50,4 @@ struct si2165_platform_data {
 	bool inversion;
 };
 
-struct si2165_config {
-	/* i2c addr
-	 * possible values: 0x64,0x65,0x66,0x67 */
-	u8 i2c_addr;
-
-	/* external clock or XTAL */
-	u8 chip_mode;
-
-	/* frequency of external clock or xtal in Hz
-	 * possible values: 4000000, 16000000, 20000000, 240000000, 27000000
-	 */
-	u32 ref_freq_Hz;
-
-	/* invert the spectrum */
-	bool inversion;
-};
-
-#if IS_REACHABLE(CONFIG_DVB_SI2165)
-struct dvb_frontend *si2165_attach(
-	const struct si2165_config *config,
-	struct i2c_adapter *i2c);
-#else
-static inline struct dvb_frontend *si2165_attach(
-	const struct si2165_config *config,
-	struct i2c_adapter *i2c)
-{
-	pr_warn("%s: driver disabled by Kconfig\n", __func__);
-	return NULL;
-}
-#endif /* CONFIG_DVB_SI2165 */
-
 #endif /* _DVB_SI2165_H */
diff --git a/drivers/media/dvb-frontends/si2165_priv.h b/drivers/media/dvb-frontends/si2165_priv.h
index 2b70cf1..e593211 100644
--- a/drivers/media/dvb-frontends/si2165_priv.h
+++ b/drivers/media/dvb-frontends/si2165_priv.h
@@ -20,4 +20,21 @@
 
 #define SI2165_FIRMWARE_REV_D "dvb-demod-si2165.fw"
 
+struct si2165_config {
+	/* i2c addr
+	 * possible values: 0x64,0x65,0x66,0x67 */
+	u8 i2c_addr;
+
+	/* external clock or XTAL */
+	u8 chip_mode;
+
+	/* frequency of external clock or xtal in Hz
+	 * possible values: 4000000, 16000000, 20000000, 240000000, 27000000
+	 */
+	u32 ref_freq_Hz;
+
+	/* invert the spectrum */
+	bool inversion;
+};
+
 #endif /* _DVB_SI2165_PRIV */
-- 
2.9.2

