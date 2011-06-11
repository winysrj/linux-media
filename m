Return-path: <mchehab@pedra>
Received: from blu0-omc2-s35.blu0.hotmail.com ([65.55.111.110]:4297 "EHLO
	blu0-omc2-s35.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab1FKI4P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 04:56:15 -0400
Message-ID: <BLU0-SMTP64C916F06DA764C4E6C297D8670@phx.gbl>
From: Manoel Pinheiro <pinusdtv@hotmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/5] [media] mb86a20s: add i2c_gate_ctrl
Date: Sat, 11 Jun 2011 05:56:00 -0300
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The register 0xfe controls the i2c-bus from the mb86a20s to tuner.


Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
---
 drivers/media/dvb/frontends/mb86a20s.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
index 0f867a5..f3c4013 100644
--- a/drivers/media/dvb/frontends/mb86a20s.c
+++ b/drivers/media/dvb/frontends/mb86a20s.c
@@ -370,6 +370,17 @@ static int mb86a20s_i2c_readreg(struct mb86a20s_state *state,
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
-- 
1.7.3.4

