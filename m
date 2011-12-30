Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527Ab1L3PJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:30 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9UYk024197
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 53/94] [media] stv0288: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:50 -0200
Message-Id: <1325257711-12274-54-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using dvb_frontend_parameters struct, that were
designed for a subset of the supported standards, use the DVBv5
cache information.

Also, fill the supported delivery systems at dvb_frontend_ops
struct.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/stv0288.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index 105f0bf..b0ddebc 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -458,8 +458,7 @@ static int stv0288_get_property(struct dvb_frontend *fe, struct dtv_property *p)
 	return 0;
 }
 
-static int stv0288_set_frontend(struct dvb_frontend *fe,
-					struct dvb_frontend_parameters *dfp)
+static int stv0288_set_frontend(struct dvb_frontend *fe)
 {
 	struct stv0288_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -481,8 +480,6 @@ static int stv0288_set_frontend(struct dvb_frontend *fe,
 		state->config->set_ts_params(fe, 0);
 
 	/* only frequency & symbol_rate are used for tuner*/
-	dfp->frequency = c->frequency;
-	dfp->u.qpsk.symbol_rate = c->symbol_rate;
 	if (fe->ops.tuner_ops.set_params) {
 		fe->ops.tuner_ops.set_params(fe);
 		if (fe->ops.i2c_gate_ctrl)
@@ -545,7 +542,7 @@ static void stv0288_release(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops stv0288_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "ST STV0288 DVB-S",
 		.type			= FE_QPSK,
@@ -579,7 +576,7 @@ static struct dvb_frontend_ops stv0288_ops = {
 
 	.set_property = stv0288_set_property,
 	.get_property = stv0288_get_property,
-	.set_frontend_legacy = stv0288_set_frontend,
+	.set_frontend = stv0288_set_frontend,
 };
 
 struct dvb_frontend *stv0288_attach(const struct stv0288_config *config,
-- 
1.7.8.352.g876a6

