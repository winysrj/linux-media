Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab1L0BJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:31 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19Viq032603
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 19/91] [media] dib9000: Get rid of the remaining DVBv3 legacy stuff
Date: Mon, 26 Dec 2011 23:08:07 -0200
Message-Id: <1324948159-23709-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-19-git-send-email-mchehab@redhat.com>
References: <1324948159-23709-1-git-send-email-mchehab@redhat.com>
 <1324948159-23709-2-git-send-email-mchehab@redhat.com>
 <1324948159-23709-3-git-send-email-mchehab@redhat.com>
 <1324948159-23709-4-git-send-email-mchehab@redhat.com>
 <1324948159-23709-5-git-send-email-mchehab@redhat.com>
 <1324948159-23709-6-git-send-email-mchehab@redhat.com>
 <1324948159-23709-7-git-send-email-mchehab@redhat.com>
 <1324948159-23709-8-git-send-email-mchehab@redhat.com>
 <1324948159-23709-9-git-send-email-mchehab@redhat.com>
 <1324948159-23709-10-git-send-email-mchehab@redhat.com>
 <1324948159-23709-11-git-send-email-mchehab@redhat.com>
 <1324948159-23709-12-git-send-email-mchehab@redhat.com>
 <1324948159-23709-13-git-send-email-mchehab@redhat.com>
 <1324948159-23709-14-git-send-email-mchehab@redhat.com>
 <1324948159-23709-15-git-send-email-mchehab@redhat.com>
 <1324948159-23709-16-git-send-email-mchehab@redhat.com>
 <1324948159-23709-17-git-send-email-mchehab@redhat.com>
 <1324948159-23709-18-git-send-email-mchehab@redhat.com>
 <1324948159-23709-19-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dib9000 is almost ok, with regards to the usage of DVBv5 parameters.
It has just a few stuff using the old way, at set_frontend.

Replace them by the DVBv5 way, and add the delivery system.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dib9000.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index 0488068..a3a9fb1 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -1867,7 +1867,7 @@ static int dib9000_fe_get_tune_settings(struct dvb_frontend *fe, struct dvb_fron
 	return 0;
 }
 
-static int dib9000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib9000_get_frontend(struct dvb_frontend *fe, struct dtv_frontend_properties *c)
 {
 	struct dib9000_state *state = fe->demodulator_priv;
 	u8 index_frontend, sub_index_frontend;
@@ -1883,7 +1883,7 @@ static int dib9000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 			dprintk("TPS lock on the slave%i", index_frontend);
 
 			/* synchronize the cache with the other frontends */
-			state->fe[index_frontend]->ops.get_frontend_legacy(state->fe[index_frontend], fep);
+			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], c);
 			for (sub_index_frontend = 0; (sub_index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[sub_index_frontend] != NULL);
 			     sub_index_frontend++) {
 				if (sub_index_frontend != index_frontend) {
@@ -1958,7 +1958,7 @@ static int dib9000_set_channel_status(struct dvb_frontend *fe, struct dvb_fronte
 	return 0;
 }
 
-static int dib9000_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib9000_set_frontend(struct dvb_frontend *fe)
 {
 	struct dib9000_state *state = fe->demodulator_priv;
 	int sleep_time, sleep_time_slave;
@@ -1983,8 +1983,10 @@ static int dib9000_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 	fe->dtv_property_cache.delivery_system = SYS_DVBT;
 
 	/* set the master status */
-	if (fep->u.ofdm.transmission_mode == TRANSMISSION_MODE_AUTO ||
-	    fep->u.ofdm.guard_interval == GUARD_INTERVAL_AUTO || fep->u.ofdm.constellation == QAM_AUTO || fep->u.ofdm.code_rate_HP == FEC_AUTO) {
+	if (state->fe[0]->dtv_property_cache.transmission_mode == TRANSMISSION_MODE_AUTO ||
+	    state->fe[0]->dtv_property_cache.guard_interval == GUARD_INTERVAL_AUTO ||
+	    state->fe[0]->dtv_property_cache.modulation == QAM_AUTO ||
+	    state->fe[0]->dtv_property_cache.code_rate_HP == FEC_AUTO) {
 		/* no channel specified, autosearch the channel */
 		state->channel_status.status = CHANNEL_STATUS_PARAMETERS_UNKNOWN;
 	} else
@@ -2052,7 +2054,7 @@ static int dib9000_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 
 	/* synchronize all the channel cache */
 	state->get_frontend_internal = 1;
-	dib9000_get_frontend(state->fe[0], fep);
+	dib9000_get_frontend(state->fe[0], &state->fe[0]->dtv_property_cache);
 	state->get_frontend_internal = 0;
 
 	/* retune the other frontends with the found channel */
@@ -2495,6 +2497,7 @@ error:
 EXPORT_SYMBOL(dib9000_attach);
 
 static struct dvb_frontend_ops dib9000_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		 .name = "DiBcom 9000",
 		 .type = FE_OFDM,
@@ -2513,9 +2516,9 @@ static struct dvb_frontend_ops dib9000_ops = {
 	.init = dib9000_wakeup,
 	.sleep = dib9000_sleep,
 
-	.set_frontend_legacy = dib9000_set_frontend,
+	.set_frontend = dib9000_set_frontend,
 	.get_tune_settings = dib9000_fe_get_tune_settings,
-	.get_frontend_legacy = dib9000_get_frontend,
+	.get_frontend = dib9000_get_frontend,
 
 	.read_status = dib9000_read_status,
 	.read_ber = dib9000_read_ber,
-- 
1.7.8.352.g876a6

