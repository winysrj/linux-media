Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34913 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754351AbdCXSZu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 14:25:50 -0400
Received: by mail-wm0-f67.google.com with SMTP id z133so2223163wmb.2
        for <linux-media@vger.kernel.org>; Fri, 24 Mar 2017 11:25:44 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 01/12] [media] dvb-frontends/stv0367: add flag to make i2c_gatectrl optional
Date: Fri, 24 Mar 2017 19:23:57 +0100
Message-Id: <20170324182408.25996-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170324182408.25996-1-d.scheller.oss@gmail.com>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Some hardware and bridges (namely ddbridge) require that tuner access is
limited to one concurrent access and wrap i2c gate control with a
mutex_lock when attaching frontends. According to vendor information, this
is required as concurrent tuner reconfiguration can interfere each other
and at worst cause tuning fails or bad reception quality.

If the demod driver does gate_ctrl before setting up tuner parameters, and
the tuner does another I2C enable, it will deadlock forever when gate_ctrl
is wrapped into the mutex_lock. This adds a flag and a conditional before
triggering gate_ctrl in the demodulator driver.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index fd49c43..fc80934 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -89,6 +89,8 @@ struct stv0367_state {
 	struct stv0367cab_state *cab_state;
 	/* DVB-T */
 	struct stv0367ter_state *ter_state;
+	/* flags for operation control */
+	u8 use_i2c_gatectrl;
 };
 
 struct st_register {
@@ -1827,10 +1829,10 @@ static int stv0367ter_set_frontend(struct dvb_frontend *fe)
 	stv0367ter_init(fe);
 
 	if (fe->ops.tuner_ops.set_params) {
-		if (fe->ops.i2c_gate_ctrl)
+		if (state->use_i2c_gatectrl && fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
 		fe->ops.tuner_ops.set_params(fe);
-		if (fe->ops.i2c_gate_ctrl)
+		if (state->use_i2c_gatectrl && fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
@@ -2321,6 +2323,9 @@ struct dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
 	state->fe.demodulator_priv = state;
 	state->chip_id = stv0367_readreg(state, 0xf000);
 
+	/* demod operation options */
+	state->use_i2c_gatectrl = 1;
+
 	dprintk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
 
 	/* check if the demod is there */
@@ -3120,10 +3125,10 @@ static int stv0367cab_set_frontend(struct dvb_frontend *fe)
 
 	/* Tuner Frequency Setting */
 	if (fe->ops.tuner_ops.set_params) {
-		if (fe->ops.i2c_gate_ctrl)
+		if (state->use_i2c_gatectrl && fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 1);
 		fe->ops.tuner_ops.set_params(fe);
-		if (fe->ops.i2c_gate_ctrl)
+		if (state->use_i2c_gatectrl && fe->ops.i2c_gate_ctrl)
 			fe->ops.i2c_gate_ctrl(fe, 0);
 	}
 
@@ -3437,6 +3442,9 @@ struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
 	state->fe.demodulator_priv = state;
 	state->chip_id = stv0367_readreg(state, 0xf000);
 
+	/* demod operation options */
+	state->use_i2c_gatectrl = 1;
+
 	dprintk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
 
 	/* check if the demod is there */
-- 
2.10.2
