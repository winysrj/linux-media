Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1BAWld (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:41:33 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7348272fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:41:33 -0800 (PST)
Subject: [PATCH 6/9 v2] ds3000: yet clean up in tune procedure
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:40:57 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020040.57353.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Remove a lot of debug messages and delays.

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |   50 +++++-----------------------------
 1 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 7c61936..11f1aa2 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -536,25 +536,6 @@ static int ds3000_set_voltage(struct dvb_frontend *fe, fe_sec_voltage_t 
voltage)
 	return 0;
 }
 
-static void ds3000_dump_registers(struct dvb_frontend *fe)
-{
-	struct ds3000_state *state = fe->demodulator_priv;
-	int x, y, reg = 0, val;
-
-	for (y = 0; y < 16; y++) {
-		dprintk("%s: %02x: ", __func__, y);
-		for (x = 0; x < 16; x++) {
-			reg = (y << 4) + x;
-			val = ds3000_readreg(state, reg);
-			if (x != 15)
-				dprintk("%02x ",  val);
-			else
-				dprintk("%02x\n", val);
-		}
-	}
-	dprintk("%s: -- DS3000 DUMP DONE --\n", __func__);
-}
-
 static int ds3000_read_status(struct dvb_frontend *fe, fe_status_t* status)
 {
 	struct ds3000_state *state = fe->demodulator_priv;
@@ -589,16 +570,6 @@ static int ds3000_read_status(struct dvb_frontend *fe, fe_status_t* status)
 	return 0;
 }
 
-#define FE_IS_TUNED (FE_HAS_SIGNAL + FE_HAS_LOCK)
-static int ds3000_is_tuned(struct dvb_frontend *fe)
-{
-	fe_status_t tunerstat;
-
-	ds3000_read_status(fe, &tunerstat);
-
-	return ((tunerstat & FE_IS_TUNED) == FE_IS_TUNED);
-}
-
 /* read DS3000 BER value */
 static int ds3000_read_ber(struct dvb_frontend *fe, u32* ber)
 {
@@ -1049,7 +1020,7 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	struct ds3000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	int ret = 0, i;
+	int i;
 	u8 status, mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf;
 	u16 value, ndiv;
 	u32 f3db;
@@ -1292,22 +1263,15 @@ static int ds3000_tune(struct dvb_frontend *fe,
 
 	/* TODO: calculate and set carrier offset */
 
-	/* wait before retrying */
 	for (i = 0; i < 30 ; i++) {
-		if (ds3000_is_tuned(fe)) {
-			dprintk("%s: Tuned\n", __func__);
-			ds3000_dump_registers(fe);
-			goto tuned;
-		}
-		msleep(1);
-	}
-
-	dprintk("%s: Not tuned\n", __func__);
-	ds3000_dump_registers(fe);
+		ds3000_read_status(fe, &status);
+		if (status && FE_HAS_LOCK)
+			return 0;
 
+		msleep(10);
+	}
 
-tuned:
-	return ret;
+	return 1;
 }
 
 static enum dvbfe_algo ds3000_get_algo(struct dvb_frontend *fe)
-- 
1.7.1

