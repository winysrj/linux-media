Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Rc7026532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 22/94] [media] dib9000: get rid of unused dvb_frontend_parameters
Date: Fri, 30 Dec 2011 13:07:19 -0200
Message-Id: <1325257711-12274-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This parameter is passed as NULL, and it is never used. Just
remove it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dib9000.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib9000.c b/drivers/media/dvb/frontends/dib9000.c
index a3a9fb1..974c2b7 100644
--- a/drivers/media/dvb/frontends/dib9000.c
+++ b/drivers/media/dvb/frontends/dib9000.c
@@ -1309,7 +1309,7 @@ error:
 	return ret;
 }
 
-static int dib9000_fw_set_channel_union(struct dvb_frontend *fe, struct dvb_frontend_parameters *channel)
+static int dib9000_fw_set_channel_union(struct dvb_frontend *fe)
 {
 	struct dib9000_state *state = fe->demodulator_priv;
 	struct dibDVBTChannel {
@@ -1454,7 +1454,7 @@ static int dib9000_fw_set_channel_union(struct dvb_frontend *fe, struct dvb_fron
 	return 0;
 }
 
-static int dib9000_fw_tune(struct dvb_frontend *fe, struct dvb_frontend_parameters *ch)
+static int dib9000_fw_tune(struct dvb_frontend *fe)
 {
 	struct dib9000_state *state = fe->demodulator_priv;
 	int ret = 10, search = state->channel_status.status == CHANNEL_STATUS_PARAMETERS_UNKNOWN;
@@ -1471,7 +1471,7 @@ static int dib9000_fw_tune(struct dvb_frontend *fe, struct dvb_frontend_paramete
 		if (search)
 			dib9000_mbx_send(state, OUT_MSG_FE_CHANNEL_SEARCH, NULL, 0);
 		else {
-			dib9000_fw_set_channel_union(fe, ch);
+			dib9000_fw_set_channel_union(fe);
 			dib9000_mbx_send(state, OUT_MSG_FE_CHANNEL_TUNE, NULL, 0);
 		}
 		state->tune_state = CT_DEMOD_STEP_1;
@@ -2010,9 +2010,9 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 	exit_condition = 0;	/* 0: tune pending; 1: tune failed; 2:tune success */
 	index_frontend_success = 0;
 	do {
-		sleep_time = dib9000_fw_tune(state->fe[0], NULL);
+		sleep_time = dib9000_fw_tune(state->fe[0]);
 		for (index_frontend = 1; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
-			sleep_time_slave = dib9000_fw_tune(state->fe[index_frontend], NULL);
+			sleep_time_slave = dib9000_fw_tune(state->fe[index_frontend]);
 			if (sleep_time == FE_CALLBACK_TIME_NEVER)
 				sleep_time = sleep_time_slave;
 			else if ((sleep_time_slave != FE_CALLBACK_TIME_NEVER) && (sleep_time_slave > sleep_time))
@@ -2070,7 +2070,7 @@ static int dib9000_set_frontend(struct dvb_frontend *fe)
 		sleep_time = FE_CALLBACK_TIME_NEVER;
 		for (index_frontend = 0; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 			if (index_frontend != index_frontend_success) {
-				sleep_time_slave = dib9000_fw_tune(state->fe[index_frontend], NULL);
+				sleep_time_slave = dib9000_fw_tune(state->fe[index_frontend]);
 				if (sleep_time == FE_CALLBACK_TIME_NEVER)
 					sleep_time = sleep_time_slave;
 				else if ((sleep_time_slave != FE_CALLBACK_TIME_NEVER) && (sleep_time_slave > sleep_time))
-- 
1.7.8.352.g876a6

