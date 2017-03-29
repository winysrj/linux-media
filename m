Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32897 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbdC2QnW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 12:43:22 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18so4576172wrc.0
        for <linux-media@vger.kernel.org>; Wed, 29 Mar 2017 09:43:21 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org
Cc: liplianin@netup.ru, rjkm@metzlerbros.de, crope@iki.fi
Subject: [PATCH v3 06/13] [media] dvb-frontends/stv0367: make full reinit on set_frontend() optional
Date: Wed, 29 Mar 2017 18:43:06 +0200
Message-Id: <20170329164313.14636-7-d.scheller.oss@gmail.com>
In-Reply-To: <20170329164313.14636-1-d.scheller.oss@gmail.com>
References: <20170329164313.14636-1-d.scheller.oss@gmail.com>
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
