Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Vh1015920
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 64/94] [media] or51211: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:01 -0200
Message-Id: <1325257711-12274-65-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/or51211.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index 2f2c7f8..58ddf55 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -218,13 +218,13 @@ static int or51211_setmode(struct dvb_frontend* fe, int mode)
 	return 0;
 }
 
-static int or51211_set_parameters(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *param)
+static int or51211_set_parameters(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct or51211_state* state = fe->demodulator_priv;
 
 	/* Change only if we are actually changing the channel */
-	if (state->current_frequency != param->frequency) {
+	if (state->current_frequency != p->frequency) {
 		if (fe->ops.tuner_ops.set_params) {
 			fe->ops.tuner_ops.set_params(fe);
 			if (fe->ops.i2c_gate_ctrl) fe->ops.i2c_gate_ctrl(fe, 0);
@@ -234,7 +234,7 @@ static int or51211_set_parameters(struct dvb_frontend* fe,
 		or51211_setmode(fe,0);
 
 		/* Update current frequency */
-		state->current_frequency = param->frequency;
+		state->current_frequency = p->frequency;
 	}
 	return 0;
 }
@@ -544,7 +544,7 @@ struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 }
 
 static struct dvb_frontend_ops or51211_ops = {
-
+        .delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name               = "Oren OR51211 VSB Frontend",
 		.type               = FE_ATSC,
@@ -561,7 +561,7 @@ static struct dvb_frontend_ops or51211_ops = {
 	.init = or51211_init,
 	.sleep = or51211_sleep,
 
-	.set_frontend_legacy = or51211_set_parameters,
+	.set_frontend = or51211_set_parameters,
 	.get_tune_settings = or51211_get_tune_settings,
 
 	.read_status = or51211_read_status,
-- 
1.7.8.352.g876a6

