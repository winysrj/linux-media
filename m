Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab1L0BJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:46 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19jqx015714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:45 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 21/91] [media] dib8000: Remove the old DVBv3 struct from it and add delsys
Date: Mon, 26 Dec 2011 23:08:09 -0200
Message-Id: <1324948159-23709-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-21-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-20-git-send-email-mchehab@redhat.com>
 <1324948159-23709-21-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver only uses the DVBv5 struct. All it needs is to remove
the non-used params var, and to add the ISDB-T to the delivery
systems.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dib8000.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib8000.c b/drivers/media/dvb/frontends/dib8000.c
index 9860062..115c099 100644
--- a/drivers/media/dvb/frontends/dib8000.c
+++ b/drivers/media/dvb/frontends/dib8000.c
@@ -2810,7 +2810,7 @@ int dib8000_set_tune_state(struct dvb_frontend *fe, enum frontend_tune_state tun
 }
 EXPORT_SYMBOL(dib8000_set_tune_state);
 
-static int dib8000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib8000_get_frontend(struct dvb_frontend *fe, struct dtv_frontend_properties *c)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u16 i, val = 0;
@@ -2824,7 +2824,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 		if (stat&FE_HAS_SYNC) {
 			dprintk("TMCC lock on the slave%i", index_frontend);
 			/* synchronize the cache with the other frontends */
-			state->fe[index_frontend]->ops.get_frontend_legacy(state->fe[index_frontend], fep);
+			state->fe[index_frontend]->ops.get_frontend(state->fe[index_frontend], c);
 			for (sub_index_frontend = 0; (sub_index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[sub_index_frontend] != NULL); sub_index_frontend++) {
 				if (sub_index_frontend != index_frontend) {
 					state->fe[sub_index_frontend]->dtv_property_cache.isdbt_sb_mode = state->fe[index_frontend]->dtv_property_cache.isdbt_sb_mode;
@@ -2956,7 +2956,7 @@ static int dib8000_get_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 	return 0;
 }
 
-static int dib8000_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_parameters *fep)
+static int dib8000_set_frontend(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	u8 nbr_pending, exit_condition, index_frontend;
@@ -3088,7 +3088,7 @@ static int dib8000_set_frontend(struct dvb_frontend *fe, struct dvb_frontend_par
 
 		dprintk("tune success on frontend%i", index_frontend_success);
 
-		dib8000_get_frontend(fe, fep);
+		dib8000_get_frontend(fe, &state->fe[0]->dtv_property_cache);
 	}
 
 	for (index_frontend = 0, ret = 0; (ret >= 0) && (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++)
@@ -3461,6 +3461,7 @@ int dib8000_pid_filter(struct dvb_frontend *fe, u8 id, u16 pid, u8 onoff)
 EXPORT_SYMBOL(dib8000_pid_filter);
 
 static const struct dvb_frontend_ops dib8000_ops = {
+	.delsys = { SYS_ISDBT },
 	.info = {
 		 .name = "DiBcom 8000 ISDB-T",
 		 .type = FE_OFDM,
@@ -3479,9 +3480,9 @@ static const struct dvb_frontend_ops dib8000_ops = {
 	.init = dib8000_wakeup,
 	.sleep = dib8000_sleep,
 
-	.set_frontend_legacy = dib8000_set_frontend,
+	.set_frontend = dib8000_set_frontend,
 	.get_tune_settings = dib8000_fe_get_tune_settings,
-	.get_frontend_legacy = dib8000_get_frontend,
+	.get_frontend = dib8000_get_frontend,
 
 	.read_status = dib8000_read_status,
 	.read_ber = dib8000_read_ber,
-- 
1.7.8.352.g876a6

