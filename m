Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:47908 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753307Ab2CKSLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 14:11:48 -0400
Message-ID: <4F5CEAE1.4070903@gmx.de>
Date: Sun, 11 Mar 2012 19:11:45 +0100
From: Andreas Regel <andreas.regel@gmx.de>
MIME-Version: 1.0
To: abraham.manu@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] stv090x: On STV0903 do not set registers of the second
 path.
References: <4F4BEAB3.4080101@gmx.de>
In-Reply-To: <4F4BEAB3.4080101@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

resend w/o line-wrapps.

---
 drivers/media/dvb/frontends/stv090x.c |  141 ++++++++++++++++++++++++++++++--
 1 files changed, 132 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv090x.c b/drivers/media/dvb/frontends/stv090x.c
index afbd50c..ce064a3 100644
--- a/drivers/media/dvb/frontends/stv090x.c
+++ b/drivers/media/dvb/frontends/stv090x.c
@@ -4268,7 +4268,7 @@ err:
 	return -1;
 }
 
-static int stv090x_set_tspath(struct stv090x_state *state)
+static int stv0900_set_tspath(struct stv090x_state *state)
 {
 	u32 reg;
 
@@ -4539,6 +4539,121 @@ err:
 	return -1;
 }
 
+static int stv0903_set_tspath(struct stv090x_state *state)
+{
+	u32 reg;
+
+	if (state->internal->dev_ver >= 0x20) {
+		switch (state->config->ts1_mode) {
+		case STV090x_TSMODE_PARALLEL_PUNCTURED:
+		case STV090x_TSMODE_DVBCI:
+			stv090x_write_reg(state, STV090x_TSGENERAL, 0x00);
+			break;
+
+		case STV090x_TSMODE_SERIAL_PUNCTURED:
+		case STV090x_TSMODE_SERIAL_CONTINUOUS:
+		default:
+			stv090x_write_reg(state, STV090x_TSGENERAL, 0x0c);
+			break;
+		}
+	} else {
+		switch (state->config->ts1_mode) {
+		case STV090x_TSMODE_PARALLEL_PUNCTURED:
+		case STV090x_TSMODE_DVBCI:
+			stv090x_write_reg(state, STV090x_TSGENERAL1X, 0x10);
+			break;
+
+		case STV090x_TSMODE_SERIAL_PUNCTURED:
+		case STV090x_TSMODE_SERIAL_CONTINUOUS:
+		default:
+			stv090x_write_reg(state, STV090x_TSGENERAL1X, 0x14);
+			break;
+		}
+	}
+
+	switch (state->config->ts1_mode) {
+	case STV090x_TSMODE_PARALLEL_PUNCTURED:
+		reg = stv090x_read_reg(state, STV090x_P1_TSCFGH);
+		STV090x_SETFIELD_Px(reg, TSFIFO_SERIAL_FIELD, 0x00);
+		STV090x_SETFIELD_Px(reg, TSFIFO_DVBCI_FIELD, 0x00);
+		if (stv090x_write_reg(state, STV090x_P1_TSCFGH, reg) < 0)
+			goto err;
+		break;
+
+	case STV090x_TSMODE_DVBCI:
+		reg = stv090x_read_reg(state, STV090x_P1_TSCFGH);
+		STV090x_SETFIELD_Px(reg, TSFIFO_SERIAL_FIELD, 0x00);
+		STV090x_SETFIELD_Px(reg, TSFIFO_DVBCI_FIELD, 0x01);
+		if (stv090x_write_reg(state, STV090x_P1_TSCFGH, reg) < 0)
+			goto err;
+		break;
+
+	case STV090x_TSMODE_SERIAL_PUNCTURED:
+		reg = stv090x_read_reg(state, STV090x_P1_TSCFGH);
+		STV090x_SETFIELD_Px(reg, TSFIFO_SERIAL_FIELD, 0x01);
+		STV090x_SETFIELD_Px(reg, TSFIFO_DVBCI_FIELD, 0x00);
+		if (stv090x_write_reg(state, STV090x_P1_TSCFGH, reg) < 0)
+			goto err;
+		break;
+
+	case STV090x_TSMODE_SERIAL_CONTINUOUS:
+		reg = stv090x_read_reg(state, STV090x_P1_TSCFGH);
+		STV090x_SETFIELD_Px(reg, TSFIFO_SERIAL_FIELD, 0x01);
+		STV090x_SETFIELD_Px(reg, TSFIFO_DVBCI_FIELD, 0x01);
+		if (stv090x_write_reg(state, STV090x_P1_TSCFGH, reg) < 0)
+			goto err;
+		break;
+
+	default:
+		break;
+	}
+
+	if (state->config->ts1_clk > 0) {
+		u32 speed;
+
+		switch (state->config->ts1_mode) {
+		case STV090x_TSMODE_PARALLEL_PUNCTURED:
+		case STV090x_TSMODE_DVBCI:
+		default:
+			speed = state->internal->mclk /
+				(state->config->ts1_clk / 4);
+			if (speed < 0x08)
+				speed = 0x08;
+			if (speed > 0xFF)
+				speed = 0xFF;
+			break;
+		case STV090x_TSMODE_SERIAL_PUNCTURED:
+		case STV090x_TSMODE_SERIAL_CONTINUOUS:
+			speed = state->internal->mclk /
+				(state->config->ts1_clk / 32);
+			if (speed < 0x20)
+				speed = 0x20;
+			if (speed > 0xFF)
+				speed = 0xFF;
+			break;
+		}
+		reg = stv090x_read_reg(state, STV090x_P1_TSCFGM);
+		STV090x_SETFIELD_Px(reg, TSFIFO_MANSPEED_FIELD, 3);
+		if (stv090x_write_reg(state, STV090x_P1_TSCFGM, reg) < 0)
+			goto err;
+		if (stv090x_write_reg(state, STV090x_P1_TSSPEED, speed) < 0)
+			goto err;
+	}
+
+	reg = stv090x_read_reg(state, STV090x_P1_TSCFGH);
+	STV090x_SETFIELD_Px(reg, RST_HWARE_FIELD, 0x01);
+	if (stv090x_write_reg(state, STV090x_P1_TSCFGH, reg) < 0)
+		goto err;
+	STV090x_SETFIELD_Px(reg, RST_HWARE_FIELD, 0x00);
+	if (stv090x_write_reg(state, STV090x_P1_TSCFGH, reg) < 0)
+		goto err;
+
+	return 0;
+err:
+	dprintk(FE_ERROR, 1, "I/O error");
+	return -1;
+}
+
 static int stv090x_init(struct dvb_frontend *fe)
 {
 	struct stv090x_state *state = fe->demodulator_priv;
@@ -4601,8 +4716,13 @@ static int stv090x_init(struct dvb_frontend *fe)
 	if (stv090x_i2c_gate_ctrl(state, 0) < 0)
 		goto err;
 
-	if (stv090x_set_tspath(state) < 0)
-		goto err;
+	if (state->device == STV0900) {
+		if (stv0900_set_tspath(state) < 0)
+			goto err;
+	} else {
+		if (stv0903_set_tspath(state) < 0)
+			goto err;
+	}
 
 	return 0;
 
@@ -4643,23 +4763,26 @@ static int stv090x_setup(struct dvb_frontend *fe)
 	/* Stop Demod */
 	if (stv090x_write_reg(state, STV090x_P1_DMDISTATE, 0x5c) < 0)
 		goto err;
-	if (stv090x_write_reg(state, STV090x_P2_DMDISTATE, 0x5c) < 0)
-		goto err;
+	if (state->device == STV0900)
+		if (stv090x_write_reg(state, STV090x_P2_DMDISTATE, 0x5c) < 0)
+			goto err;
 
 	msleep(5);
 
 	/* Set No Tuner Mode */
 	if (stv090x_write_reg(state, STV090x_P1_TNRCFG, 0x6c) < 0)
 		goto err;
-	if (stv090x_write_reg(state, STV090x_P2_TNRCFG, 0x6c) < 0)
-		goto err;
+	if (state->device == STV0900)
+		if (stv090x_write_reg(state, STV090x_P2_TNRCFG, 0x6c) < 0)
+			goto err;
 
 	/* I2C repeater OFF */
 	STV090x_SETFIELD_Px(reg, ENARPT_LEVEL_FIELD, config->repeater_level);
 	if (stv090x_write_reg(state, STV090x_P1_I2CRPT, reg) < 0)
 		goto err;
-	if (stv090x_write_reg(state, STV090x_P2_I2CRPT, reg) < 0)
-		goto err;
+	if (state->device == STV0900)
+		if (stv090x_write_reg(state, STV090x_P2_I2CRPT, reg) < 0)
+			goto err;
 
 	if (stv090x_write_reg(state, STV090x_NCOARSE, 0x13) < 0) /* set PLL divider */
 		goto err;
-- 
1.7.2.5
 
