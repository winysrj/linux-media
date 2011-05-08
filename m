Return-path: <mchehab@gaivota>
Received: from mail.dream-property.net ([82.149.226.172]:52922 "EHLO
	mail.dream-property.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1EHXNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 19:13:21 -0400
From: Andreas Oberritter <obi@linuxtv.org>
To: linux-media@vger.kernel.org
Cc: Thierry LELEGARD <tlelegard@logiways.com>
Subject: [PATCH 2/8] DVB: dtv_property_cache_submit shouldn't modifiy the cache
Date: Sun,  8 May 2011 23:03:35 +0000
Message-Id: <1304895821-21642-3-git-send-email-obi@linuxtv.org>
In-Reply-To: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
References: <1304895821-21642-1-git-send-email-obi@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

- Use const pointers and remove assignments.
- delivery_system already gets assigned by DTV_DELIVERY_SYSTEM
  and dtv_property_cache_sync.

Signed-off-by: Andreas Oberritter <obi@linuxtv.org>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index be0f631..1ac7633 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1074,7 +1074,7 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
  */
 static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_frontend_parameters *p = &fepriv->parameters;
 
@@ -1086,14 +1086,12 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 		dprintk("%s() Preparing QPSK req\n", __func__);
 		p->u.qpsk.symbol_rate = c->symbol_rate;
 		p->u.qpsk.fec_inner = c->fec_inner;
-		c->delivery_system = SYS_DVBS;
 		break;
 	case FE_QAM:
 		dprintk("%s() Preparing QAM req\n", __func__);
 		p->u.qam.symbol_rate = c->symbol_rate;
 		p->u.qam.fec_inner = c->fec_inner;
 		p->u.qam.modulation = c->modulation;
-		c->delivery_system = SYS_DVBC_ANNEX_AC;
 		break;
 	case FE_OFDM:
 		dprintk("%s() Preparing OFDM req\n", __func__);
@@ -1111,15 +1109,10 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 		p->u.ofdm.transmission_mode = c->transmission_mode;
 		p->u.ofdm.guard_interval = c->guard_interval;
 		p->u.ofdm.hierarchy_information = c->hierarchy;
-		c->delivery_system = SYS_DVBT;
 		break;
 	case FE_ATSC:
 		dprintk("%s() Preparing VSB req\n", __func__);
 		p->u.vsb.modulation = c->modulation;
-		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
-			c->delivery_system = SYS_ATSC;
-		else
-			c->delivery_system = SYS_DVBC_ANNEX_B;
 		break;
 	}
 }
@@ -1129,7 +1122,7 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
  */
 static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_frontend_parameters *p = &fepriv->parameters;
 
@@ -1170,7 +1163,7 @@ static void dtv_property_adv_params_sync(struct dvb_frontend *fe)
 
 static void dtv_property_cache_submit(struct dvb_frontend *fe)
 {
-	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
 	/* For legacy delivery systems we don't need the delivery_system to
 	 * be specified, but we populate the older structures from the cache
-- 
1.7.2.5

