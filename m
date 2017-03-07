Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34621 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756643AbdCHBKz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 20:10:55 -0500
Received: by mail-wr0-f194.google.com with SMTP id u48so2283071wrc.1
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 17:09:33 -0800 (PST)
Received: from dvbdev.wuest.de (ip-178-201-73-185.hsi08.unitymediagroup.de. [178.201.73.185])
        by smtp.gmail.com with ESMTPSA id m186sm13760369wmd.21.2017.03.07.10.58.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 07 Mar 2017 10:58:30 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/13] [media] dvb-frontends/stv0367: add flag to make i2c_gatectrl optional
Date: Tue,  7 Mar 2017 19:57:15 +0100
Message-Id: <20170307185727.564-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170307185727.564-1-d.scheller.oss@gmail.com>
References: <20170307185727.564-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

There can be use cases (bridges, namely ddbridge) which will care about
gate control in a way that involves mutex_locks and remapped i2c_gatectrl
FE ops. If the demod driver (additionally) performs it's own gate control
and there's something else that already took the lock, locking again will
lead to kernel deadlocks, so add and check a conditional before triggering
gate_ctrl.

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
