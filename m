Return-path: <mchehab@pedra>
Received: from blu0-omc2-s36.blu0.hotmail.com ([65.55.111.111]:38062 "EHLO
	blu0-omc2-s36.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933933Ab1ESSuK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 14:50:10 -0400
Message-ID: <BLU0-SMTP1094E019B719AEBED47F0EED88E0@phx.gbl>
From: Manoel PN <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [RFC] add i2c_gate_ctrl to mb86a20s.c
Date: Thu, 19 May 2011 15:49:58 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The register 0xfe controls the i2c-bus from the mb86a20s to tuner.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>


diff --git a/drivers/media/dvb/frontends/mb86a20s.c 
b/drivers/media/dvb/frontends/mb86a20s.c
index 0f867a5..f3c4013 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -370,6 +370,17 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state 
*state,
 	mb86a20s_i2c_writeregdata(state, state->config->demod_address, \
 	regdata, ARRAY_SIZE(regdata))
 
+static int mb86a20s_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
+{
+	struct mb86a20s_state *state = fe->demodulator_priv;
+
+	/* Enable/Disable I2C bus for tuner control */
+	if (enable)
+		return mb86a20s_writereg(state, 0xfe, 0);
+	else
+		return mb86a20s_writereg(state, 0xfe, 1);
+}
+
 static int mb86a20s_initfe(struct dvb_frontend *fe)
 {
 	struct mb86a20s_state *state = fe->demodulator_priv;
@@ -626,6 +637,7 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 
 	.release = mb86a20s_release,
 
+	.i2c_gate_ctrl = mb86a20s_i2c_gate_ctrl,
 	.init = mb86a20s_initfe,
 	.set_frontend = mb86a20s_set_frontend,
 	.get_frontend = mb86a20s_get_frontend,


