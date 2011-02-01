Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1BAWlu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Feb 2011 17:41:50 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so7348272fxm.19
        for <linux-media@vger.kernel.org>; Tue, 01 Feb 2011 14:41:49 -0800 (PST)
Subject: [PATCH 9/9 v2] ds3000: hardware tune algorithm
To: mchehab@infradead.org, linux-media@vger.kernel.org
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Wed, 2 Feb 2011 00:41:13 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102020041.14110.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Igor M. Liplianin <liplianin@me.by>
---
 drivers/media/dvb/frontends/ds3000.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index e2037b5..3c6e08e 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -967,22 +967,21 @@ static int ds3000_set_carrier_offset(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int ds3000_tune(struct dvb_frontend *fe,
+static int ds3000_set_frontend(struct dvb_frontend *fe,
 				struct dvb_frontend_parameters *p)
 {
 	struct ds3000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	int i;
-	u8 status, mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf, div4;
+	fe_status_t status;
+	u8 mlpf, mlpf_new, mlpf_max, mlpf_min, nlpf, div4;
 	s32 offset_khz;
 	u16 value, ndiv;
 	u32 f3db;
 
 	dprintk("%s() ", __func__);
 
-	/* Reset status register */
-	status = 0;
 	/* Tune */
 	/* unknown */
 	ds3000_tuner_writereg(state, 0x07, 0x02);
@@ -1218,10 +1217,16 @@ static int ds3000_tune(struct dvb_frontend *fe,
 	return 1;
 }
 
+static int ds3000_tune(struct dvb_frontend *fe,
+			struct dvb_frontend_parameters *p)
+{
+	return ds3000_set_frontend(fe, p);
+}
+
 static enum dvbfe_algo ds3000_get_algo(struct dvb_frontend *fe)
 {
 	dprintk("%s()\n", __func__);
-	return DVBFE_ALGO_SW;
+	return DVBFE_ALGO_HW;
 }
 
 /*
@@ -1296,7 +1301,8 @@ static struct dvb_frontend_ops ds3000_ops = {
 
 	.set_property = ds3000_set_property,
 	.get_property = ds3000_get_property,
-	.set_frontend = ds3000_tune,
+	.set_frontend = ds3000_set_frontend,
+	.tune = ds3000_tune,
 };
 
 module_param(debug, int, 0644);
-- 
1.7.1

