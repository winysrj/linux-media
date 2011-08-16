Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.dream-property.net ([82.149.226.172]:33552 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab1HPOEQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 10:04:16 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.dream-property.net (Postfix) with ESMTP id B17813153885
	for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 16:04:14 +0200 (CEST)
Received: from mail.dream-property.net ([127.0.0.1])
	by localhost (mail.dream-property.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 5EHtGaPfeTGW for <linux-media@vger.kernel.org>;
	Tue, 16 Aug 2011 16:04:08 +0200 (CEST)
Received: from pepe.dream-property.nete (dreamboxupdate.com [82.149.226.174])
	by mail.dream-property.net (Postfix) with SMTP id A037F315386C
	for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 16:04:07 +0200 (CEST)
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] DVB: dvb_frontend: remove static assignments from dtv_property_cache_sync()
Date: Tue, 16 Aug 2011 14:04:06 +0000
Message-Id: <1313503447-13743-1-git-send-email-obi@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- Move all static assignments to a new function
  dtv_property_cache_init().
- Call dtv_property_cache_init() from FE_SET_FRONTEND, but not from
  dtv_property_process_get().
- This fixes a problem where 2G delivery system parameters would get
  overwritten with invalid values, leading to partially incorrect
  results when calling FE_GET_PROPERTY.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index d218fe2..a716627 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1019,6 +1019,29 @@ static int is_legacy_delivery_system(fe_delivery_system_t s)
 	return 0;
 }
 
+/* Initialize the cache with some default values derived from the
+ * legacy frontend_info structure.
+ */
+static void dtv_property_cache_init(struct dvb_frontend *fe,
+				    struct dtv_frontend_properties *c)
+{
+	switch (fe->ops.info.type) {
+	case FE_QPSK:
+		c->modulation = QPSK;   /* implied for DVB-S in legacy API */
+		c->rolloff = ROLLOFF_35;/* implied for DVB-S */
+		c->delivery_system = SYS_DVBS;
+		break;
+	case FE_QAM:
+		c->delivery_system = SYS_DVBC_ANNEX_AC;
+		break;
+	case FE_OFDM:
+		c->delivery_system = SYS_DVBT;
+		break;
+	case FE_ATSC:
+		break;
+	}
+}
+
 /* Synchronise the legacy tuning parameters into the cache, so that demodulator
  * drivers can use a single set_frontend tuning function, regardless of whether
  * it's being used for the legacy or new API, reducing code and complexity.
@@ -1032,17 +1055,13 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
 
 	switch (fe->ops.info.type) {
 	case FE_QPSK:
-		c->modulation = QPSK;   /* implied for DVB-S in legacy API */
-		c->rolloff = ROLLOFF_35;/* implied for DVB-S */
 		c->symbol_rate = p->u.qpsk.symbol_rate;
 		c->fec_inner = p->u.qpsk.fec_inner;
-		c->delivery_system = SYS_DVBS;
 		break;
 	case FE_QAM:
 		c->symbol_rate = p->u.qam.symbol_rate;
 		c->fec_inner = p->u.qam.fec_inner;
 		c->modulation = p->u.qam.modulation;
-		c->delivery_system = SYS_DVBC_ANNEX_AC;
 		break;
 	case FE_OFDM:
 		if (p->u.ofdm.bandwidth == BANDWIDTH_6_MHZ)
@@ -1060,7 +1079,6 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
 		c->transmission_mode = p->u.ofdm.transmission_mode;
 		c->guard_interval = p->u.ofdm.guard_interval;
 		c->hierarchy = p->u.ofdm.hierarchy_information;
-		c->delivery_system = SYS_DVBT;
 		break;
 	case FE_ATSC:
 		c->modulation = p->u.vsb.modulation;
@@ -1821,6 +1839,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
 
 			memcpy (&fepriv->parameters_in, parg,
 				sizeof (struct dvb_frontend_parameters));
+			dtv_property_cache_init(fe, c);
 			dtv_property_cache_sync(fe, c, &fepriv->parameters_in);
 		}
 
-- 
1.7.2.5

