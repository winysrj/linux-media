Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34276 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965196AbdCXS0P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 14:26:15 -0400
Received: by mail-wm0-f65.google.com with SMTP id u132so2231757wmg.1
        for <linux-media@vger.kernel.org>; Fri, 24 Mar 2017 11:26:03 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 06/12] [media] dvb-frontends/stv0367: make full reinit on set_frontend() optional
Date: Fri, 24 Mar 2017 19:24:02 +0100
Message-Id: <20170324182408.25996-7-d.scheller.oss@gmail.com>
In-Reply-To: <20170324182408.25996-1-d.scheller.oss@gmail.com>
References: <20170324182408.25996-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Every time dvb_frontend_ops.set_frontend() is called, an almost full reinit
of the demodulator will be performed. While this might cause a slight delay
when switching channels due to all involved tables being rewritten, it can
even be dangerous in certain causes in that the demod may lock up and
requires to be powercycled (this can happen on Digital Devices hardware).
So this adds a flag if it should be done, and to not change behaviour with
existing card support, it'll be enabled in all cases.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index da10d9a..9370afa 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -93,6 +93,7 @@ struct stv0367_state {
 	/* flags for operation control */
 	u8 use_i2c_gatectrl;
 	u8 deftabs;
+	u8 reinit_on_setfrontend;
 };
 
 #define RF_LOOKUP_TABLE_SIZE  31
@@ -1217,7 +1218,8 @@ static int stv0367ter_set_frontend(struct dvb_frontend *fe)
 	s8 num_trials, index;
 	u8 SenseTrials[] = { INVERSION_ON, INVERSION_OFF };
 
-	stv0367ter_init(fe);
+	if (state->reinit_on_setfrontend)
+		stv0367ter_init(fe);
 
 	if (fe->ops.tuner_ops.set_params) {
 		if (state->use_i2c_gatectrl && fe->ops.i2c_gate_ctrl)
@@ -1717,6 +1719,7 @@ struct dvb_frontend *stv0367ter_attach(const struct stv0367_config *config,
 	/* demod operation options */
 	state->use_i2c_gatectrl = 1;
 	state->deftabs = STV0367_DEFTAB_GENERIC;
+	state->reinit_on_setfrontend = 1;
 
 	dprintk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
 
@@ -2511,7 +2514,8 @@ static int stv0367cab_set_frontend(struct dvb_frontend *fe)
 		break;
 	}
 
-	stv0367cab_init(fe);
+	if (state->reinit_on_setfrontend)
+		stv0367cab_init(fe);
 
 	/* Tuner Frequency Setting */
 	if (fe->ops.tuner_ops.set_params) {
@@ -2835,6 +2839,7 @@ struct dvb_frontend *stv0367cab_attach(const struct stv0367_config *config,
 	/* demod operation options */
 	state->use_i2c_gatectrl = 1;
 	state->deftabs = STV0367_DEFTAB_GENERIC;
+	state->reinit_on_setfrontend = 1;
 
 	dprintk("%s: chip_id = 0x%x\n", __func__, state->chip_id);
 
-- 
2.10.2
