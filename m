Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55987 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759219Ab3DIXyX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Apr 2013 19:54:23 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/5] mxl5007t: fix buggy register read
Date: Wed, 10 Apr 2013 02:53:16 +0300
Message-Id: <1365551600-3394-2-git-send-email-crope@iki.fi>
In-Reply-To: <1365551600-3394-1-git-send-email-crope@iki.fi>
References: <1365551600-3394-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Chip uses WRITE + STOP + READ + STOP sequence for I2C register read.
Driver was using REPEATED START condition which makes it failing if
I2C adapter was implemented correctly.

Add use_broken_read_reg_intentionally option to keep old buggy
implantation as there is buggy I2C adapter implementation relying
that bug...

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/mxl5007t.c             | 56 ++++++++++++++++++++++++++++-
 drivers/media/tuners/mxl5007t.h             |  7 ++++
 drivers/media/usb/au0828/au0828-dvb.c       |  1 +
 drivers/media/usb/dvb-usb-v2/af9015.c       |  1 +
 drivers/media/usb/dvb-usb-v2/af9035.c       |  2 ++
 drivers/media/usb/dvb-usb/dib0700_devices.c |  1 +
 6 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/media/tuners/mxl5007t.c b/drivers/media/tuners/mxl5007t.c
index 69e453e..36605ea 100644
--- a/drivers/media/tuners/mxl5007t.c
+++ b/drivers/media/tuners/mxl5007t.c
@@ -156,6 +156,7 @@ struct mxl5007t_state {
 	struct tuner_i2c_props i2c_props;
 
 	struct mutex lock;
+	struct mutex i2c_lock;
 
 	struct mxl5007t_config *config;
 
@@ -490,7 +491,8 @@ static int mxl5007t_write_regs(struct mxl5007t_state *state,
 	return ret;
 }
 
-static int mxl5007t_read_reg(struct mxl5007t_state *state, u8 reg, u8 *val)
+/* XXX: bad implementation for avoiding regressions */
+static int mxl5007t_read_reg_bad(struct mxl5007t_state *state, u8 reg, u8 *val)
 {
 	u8 buf[2] = { 0xfb, reg };
 	struct i2c_msg msg[] = {
@@ -509,6 +511,57 @@ static int mxl5007t_read_reg(struct mxl5007t_state *state, u8 reg, u8 *val)
 	return 0;
 }
 
+/* chip uses I2C write + read with STOP condition */
+static int mxl5007t_read_reg_good(struct mxl5007t_state *state, u8 reg, u8 *val)
+{
+	int ret;
+	u8 buf[2] = { 0xfb, reg };
+	struct i2c_msg msg1[] = {
+		{
+			.addr = state->i2c_props.addr,
+			.flags = 0,
+			.buf = buf,
+			.len = 2,
+		},
+	};
+	struct i2c_msg msg2[] = {
+		{
+			.addr = state->i2c_props.addr,
+			.flags = I2C_M_RD,
+			.buf = val,
+			.len = 1,
+		},
+	};
+
+	mutex_lock(&state->i2c_lock);
+
+	ret = i2c_transfer(state->i2c_props.adap, msg1, 1);
+	if (ret != 1) {
+		mxl_err("failed!");
+		ret = -EREMOTEIO;
+		goto fail;
+	}
+
+	ret = i2c_transfer(state->i2c_props.adap, msg2, 1);
+	if (ret != 1) {
+		mxl_err("failed!");
+		ret = -EREMOTEIO;
+		goto fail;
+	}
+fail:
+	mutex_unlock(&state->i2c_lock);
+
+	return ret;
+}
+
+static int mxl5007t_read_reg(struct mxl5007t_state *state, u8 reg, u8 *val)
+{
+	if (state->config->use_broken_read_reg_intentionally)
+		return mxl5007t_read_reg_bad(state, reg, val);
+	else
+		return mxl5007t_read_reg_good(state, reg, val);
+}
+
 static int mxl5007t_soft_reset(struct mxl5007t_state *state)
 {
 	u8 d = 0xff;
@@ -883,6 +936,7 @@ struct dvb_frontend *mxl5007t_attach(struct dvb_frontend *fe,
 		state->config = cfg;
 
 		mutex_init(&state->lock);
+		mutex_init(&state->i2c_lock);
 
 		if (fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
diff --git a/drivers/media/tuners/mxl5007t.h b/drivers/media/tuners/mxl5007t.h
index 37b0942..728779b 100644
--- a/drivers/media/tuners/mxl5007t.h
+++ b/drivers/media/tuners/mxl5007t.h
@@ -75,6 +75,13 @@ struct mxl5007t_config {
 	unsigned int invert_if:1;
 	unsigned int loop_thru_enable:1;
 	unsigned int clk_out_enable:1;
+	/*
+	 * XXX: This should not be used. Defined for avoiding regressions.
+	 * Remove use of that option after device is tested to be working with
+	 * correct implementation.
+	 * MxL5007t does not use I2C REPEATED START condition for register read.
+	 */
+	unsigned int use_broken_read_reg_intentionally:1;
 };
 
 #if IS_ENABLED(CONFIG_MEDIA_TUNER_MXL5007T)
diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 9a6f156..7d32a0c 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -95,6 +95,7 @@ static struct xc5000_config hauppauge_xc5000c_config = {
 static struct mxl5007t_config mxl5007t_hvr950q_config = {
 	.xtal_freq_hz = MxL_XTAL_24_MHZ,
 	.if_freq_hz = MxL_IF_6_MHZ,
+	.use_broken_read_reg_intentionally = 1,
 };
 
 static struct tda18271_config hauppauge_woodbury_tunerconfig = {
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index d556042..b943304 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -931,6 +931,7 @@ static struct tda18218_config af9015_tda18218_config = {
 static struct mxl5007t_config af9015_mxl5007t_config = {
 	.xtal_freq_hz = MxL_XTAL_24_MHZ,
 	.if_freq_hz = MxL_IF_4_57_MHZ,
+	.use_broken_read_reg_intentionally = 1,
 };
 
 static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index b638fc1..b7e7135 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -947,6 +947,7 @@ static struct mxl5007t_config af9035_mxl5007t_config[] = {
 		.loop_thru_enable = 0,
 		.clk_out_enable = 0,
 		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
+		.use_broken_read_reg_intentionally = 1,
 	}, {
 		.xtal_freq_hz = MxL_XTAL_24_MHZ,
 		.if_freq_hz = MxL_IF_4_57_MHZ,
@@ -954,6 +955,7 @@ static struct mxl5007t_config af9035_mxl5007t_config[] = {
 		.loop_thru_enable = 1,
 		.clk_out_enable = 1,
 		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
+		.use_broken_read_reg_intentionally = 1,
 	}
 };
 
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 1179842..c58c6ea 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3433,6 +3433,7 @@ static struct mxl5007t_config hcw_mxl5007t_config = {
 	.xtal_freq_hz = MxL_XTAL_25_MHZ,
 	.if_freq_hz = MxL_IF_6_MHZ,
 	.invert_if = 1,
+	.use_broken_read_reg_intentionally = 1,
 };
 
 /* TIGER-ATSC map:
-- 
1.7.11.7

