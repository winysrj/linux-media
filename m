Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57361 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3AFMku (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 07:40:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so8717926eek.5
        for <linux-media@vger.kernel.org>; Sun, 06 Jan 2013 04:40:49 -0800 (PST)
Message-ID: <1357476042.16016.8.camel@canaries64>
Subject: [PATCH] ts2020: call get_rf_strength from frontend
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: "Igor M. Liplianin" <liplianin@me.by>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Date: Sun, 06 Jan 2013 12:40:42 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Restore ds3000.c read_signal_strength.

Call tuner get_rf_strength from frontend read_signal_strength.

We are able to do a NULL check and doesn't limit the tuner
attach to the frontend attach area.

At the moment the lmedm04 tuner attach is stuck in frontend
attach area.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb-frontends/ds3000.c    | 10 ++++++++++
 drivers/media/dvb-frontends/m88rs2000.c |  4 +++-
 drivers/media/dvb-frontends/ts2020.c    |  1 -
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index d128f85..1e344b0 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -533,6 +533,15 @@ static int ds3000_read_ber(struct dvb_frontend *fe, u32* ber)
 	return 0;
 }
 
+static int ds3000_read_signal_strength(struct dvb_frontend *fe,
+						u16 *signal_strength)
+{
+	if (fe->ops.tuner_ops.get_rf_strength)
+		fe->ops.tuner_ops.get_rf_strength(fe, signal_strength);
+
+	return 0;
+}
+
 /* calculate DS3000 snr value in dB */
 static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
 {
@@ -1102,6 +1111,7 @@ static struct dvb_frontend_ops ds3000_ops = {
 	.i2c_gate_ctrl = ds3000_i2c_gate_ctrl,
 	.read_status = ds3000_read_status,
 	.read_ber = ds3000_read_ber,
+	.read_signal_strength = ds3000_read_signal_strength,
 	.read_snr = ds3000_read_snr,
 	.read_ucblocks = ds3000_read_ucblocks,
 	.set_voltage = ds3000_set_voltage,
diff --git a/drivers/media/dvb-frontends/m88rs2000.c b/drivers/media/dvb-frontends/m88rs2000.c
index 283c90f..4da5272 100644
--- a/drivers/media/dvb-frontends/m88rs2000.c
+++ b/drivers/media/dvb-frontends/m88rs2000.c
@@ -446,7 +446,9 @@ static int m88rs2000_read_ber(struct dvb_frontend *fe, u32 *ber)
 static int m88rs2000_read_signal_strength(struct dvb_frontend *fe,
 	u16 *strength)
 {
-	*strength = 0;
+	if (fe->ops.tuner_ops.get_rf_strength)
+		fe->ops.tuner_ops.get_rf_strength(fe, strength);
+
 	return 0;
 }
 
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index f50e237..ad7ad85 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -363,7 +363,6 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 
 	memcpy(&fe->ops.tuner_ops, &ts2020_tuner_ops,
 				sizeof(struct dvb_tuner_ops));
-	fe->ops.read_signal_strength = fe->ops.tuner_ops.get_rf_strength;
 
 	return fe;
 }
-- 
1.8.0


