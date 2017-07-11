Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35311 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932536AbdGKVGK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Jul 2017 17:06:10 -0400
Received: by mail-wr0-f196.google.com with SMTP id z45so1066929wrb.2
        for <linux-media@vger.kernel.org>; Tue, 11 Jul 2017 14:06:09 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, aospan@netup.ru, serjk@netup.ru
Cc: mchehab@kernel.org, mchehab@s-opensource.com
Subject: [PATCH] [media] dvb-frontends/cxd2841er: do sleep on delivery system change
Date: Tue, 11 Jul 2017 23:06:05 +0200
Message-Id: <20170711210605.408-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Discovered using w_scan when scanning DVB-T/T2: When w_scan goes from -T
to -T2, it does so without stopping the frontend using .sleep. Due to
this, the demod operation mode isn't re-setup, but as it still is in
STATE_ACTIVE_TC, PLP and T2 Profile are set up, but only retune_active()
is called, leaving the demod in T mode, thus not operable on any T2
frequency.

Fix this by putting the demod to sleep if priv->system isn't equal to
p->delsys. To properly accomplish this, sleep_tc() is split into
sleep_tc() and shutdown_tc(), where sleep_tc() will only perform the
sleep operation, while shutdown_tc() additionally performs the full
demod shutdown (to keep the behaviour when the .sleep FE_OP is called).

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 12bff778c97f..f663f5c4a7a8 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -487,6 +487,8 @@ static int cxd2841er_sleep_tc_to_shutdown(struct cxd2841er_priv *priv);
 
 static int cxd2841er_shutdown_to_sleep_tc(struct cxd2841er_priv *priv);
 
+static int cxd2841er_sleep_tc(struct dvb_frontend *fe);
+
 static int cxd2841er_retune_active(struct cxd2841er_priv *priv,
 				   struct dtv_frontend_properties *p)
 {
@@ -3378,6 +3380,14 @@ static int cxd2841er_set_frontend_tc(struct dvb_frontend *fe)
 	if (priv->flags & CXD2841ER_EARLY_TUNE)
 		cxd2841er_tuner_set(fe);
 
+	/* deconfigure/put demod to sleep on delsys switch if active */
+	if (priv->state == STATE_ACTIVE_TC &&
+	    priv->system != p->delivery_system) {
+		dev_dbg(&priv->i2c->dev, "%s(): old_delsys=%d, new_delsys=%d -> sleep\n",
+			 __func__, priv->system, p->delivery_system);
+		cxd2841er_sleep_tc(fe);
+	}
+
 	if (p->delivery_system == SYS_DVBT) {
 		priv->system = SYS_DVBT;
 		switch (priv->state) {
@@ -3594,6 +3604,7 @@ static int cxd2841er_sleep_tc(struct dvb_frontend *fe)
 	struct cxd2841er_priv *priv = fe->demodulator_priv;
 
 	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
+
 	if (priv->state == STATE_ACTIVE_TC) {
 		switch (priv->system) {
 		case SYS_DVBT:
@@ -3619,7 +3630,17 @@ static int cxd2841er_sleep_tc(struct dvb_frontend *fe)
 			__func__, priv->state);
 		return -EINVAL;
 	}
-	cxd2841er_sleep_tc_to_shutdown(priv);
+	return 0;
+}
+
+static int cxd2841er_shutdown_tc(struct dvb_frontend *fe)
+{
+	struct cxd2841er_priv *priv = fe->demodulator_priv;
+
+	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
+
+	if (!cxd2841er_sleep_tc(fe))
+		cxd2841er_sleep_tc_to_shutdown(priv);
 	return 0;
 }
 
@@ -3968,7 +3989,7 @@ static struct dvb_frontend_ops cxd2841er_t_c_ops = {
 		.symbol_rate_max = 11700000
 	},
 	.init = cxd2841er_init_tc,
-	.sleep = cxd2841er_sleep_tc,
+	.sleep = cxd2841er_shutdown_tc,
 	.release = cxd2841er_release,
 	.set_frontend = cxd2841er_set_frontend_tc,
 	.get_frontend = cxd2841er_get_frontend,
-- 
2.13.0
