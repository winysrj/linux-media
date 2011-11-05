Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp21.services.sfr.fr ([93.17.128.1]:31774 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab1KEPTo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Nov 2011 11:19:44 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2121.sfr.fr (SMTP Server) with ESMTP id 6222470000D8
	for <linux-media@vger.kernel.org>; Sat,  5 Nov 2011 16:19:41 +0100 (CET)
Received: from smtp-in.softsystem.co.uk (183.95.30.93.rev.sfr.net [93.30.95.183])
	by msfrf2121.sfr.fr (SMTP Server) with SMTP id 2126670000D2
	for <linux-media@vger.kernel.org>; Sat,  5 Nov 2011 16:19:41 +0100 (CET)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.95.183] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Sat, 05 Nov 2011 16:19:40 +0100
Subject: [PATCH] Revert most of 15cc2bb [media] DVB:
 dtv_property_cache_submit shouldn't modifiy the cache
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: obi@linuxtv.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Nov 2011 16:19:39 +0100
Message-ID: <1320506379.1731.12.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I believe that I have found a problem with dtv_property_cache updating
when handling the legacy API.  This was introduced between 2.6.39 and
3.0.

dtv_property_cache_submit() in dvb_frontend.c tests the field
delivery_system and if it's a legacy type (including SYS_UNDEFINED) then
it calls dtv_property_legacy_params_sync().

The original patch removed the assignment to delivery_system in this
function.  However, the legacy API allows delivery_system to be
SYS_UNDEFINED - in fact is_legacy_delivery_system() tests for this
value.

If the delivery_system field is left as SYS_UNDEFINED then when tuning
is started, fe->ops.set_frontend() fails.

The current version of MythTV 0.24.1 is affected by this bug when using
a dvb-s2 card (tbs6981) tuned to a dvb-s channel.

Signed-off-by: Lawrence Rust <lvr@softsystem.co.uk>
---
 drivers/media/dvb/dvb-core/dvb_frontend.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 5b6b451..06c3975 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1076,7 +1076,7 @@ static void dtv_property_cache_sync(struct dvb_frontend *fe,
  */
 static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 {
-	const struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_frontend_parameters *p = &fepriv->parameters_in;
 
@@ -1088,12 +1088,14 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 		dprintk("%s() Preparing QPSK req\n", __func__);
 		p->u.qpsk.symbol_rate = c->symbol_rate;
 		p->u.qpsk.fec_inner = c->fec_inner;
+		c->delivery_system = SYS_DVBS;
 		break;
 	case FE_QAM:
 		dprintk("%s() Preparing QAM req\n", __func__);
 		p->u.qam.symbol_rate = c->symbol_rate;
 		p->u.qam.fec_inner = c->fec_inner;
 		p->u.qam.modulation = c->modulation;
+		c->delivery_system = SYS_DVBC_ANNEX_AC;
 		break;
 	case FE_OFDM:
 		dprintk("%s() Preparing OFDM req\n", __func__);
@@ -1111,10 +1113,15 @@ static void dtv_property_legacy_params_sync(struct dvb_frontend *fe)
 		p->u.ofdm.transmission_mode = c->transmission_mode;
 		p->u.ofdm.guard_interval = c->guard_interval;
 		p->u.ofdm.hierarchy_information = c->hierarchy;
+		c->delivery_system = SYS_DVBT;
 		break;
 	case FE_ATSC:
 		dprintk("%s() Preparing VSB req\n", __func__);
 		p->u.vsb.modulation = c->modulation;
+		if ((c->modulation == VSB_8) || (c->modulation == VSB_16))
+			c->delivery_system = SYS_ATSC;
+		else
+			c->delivery_system = SYS_DVBC_ANNEX_B;
 		break;
 	}
 }
-- 
1.7.4.1

