Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab1L3PJ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:29 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Sqd015892
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:28 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 41/94] [media] s5h1432: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:38 -0200
Message-Id: <1325257711-12274-42-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/s5h1432.c |   29 +++++++++++------------------
 1 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/frontends/s5h1432.c b/drivers/media/dvb/frontends/s5h1432.c
index f22c71e..3a9050f 100644
--- a/drivers/media/dvb/frontends/s5h1432.c
+++ b/drivers/media/dvb/frontends/s5h1432.c
@@ -178,9 +178,9 @@ static int s5h1432_set_IF(struct dvb_frontend *fe, u32 ifFreqHz)
 }
 
 /* Talk to the demod, set the FEC, GUARD, QAM settings etc */
-static int s5h1432_set_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *p)
+static int s5h1432_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u32 dvb_bandwidth = 8;
 	struct s5h1432_state *state = fe->demodulator_priv;
 
@@ -191,16 +191,16 @@ static int s5h1432_set_frontend(struct dvb_frontend *fe,
 		fe->ops.tuner_ops.set_params(fe);
 		msleep(300);
 		s5h1432_set_channel_bandwidth(fe, dvb_bandwidth);
-		switch (p->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+		switch (p->bandwidth_hz) {
+		case 6000000:
 			dvb_bandwidth = 6;
 			s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			dvb_bandwidth = 7;
 			s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
 			break;
-		case BANDWIDTH_8_MHZ:
+		case 8000000:
 			dvb_bandwidth = 8;
 			s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
 			break;
@@ -215,16 +215,16 @@ static int s5h1432_set_frontend(struct dvb_frontend *fe,
 		s5h1432_writereg(state, S5H1432_I2C_TOP_ADDR, 0x09, 0x1b);
 
 		s5h1432_set_channel_bandwidth(fe, dvb_bandwidth);
-		switch (p->u.ofdm.bandwidth) {
-		case BANDWIDTH_6_MHZ:
+		switch (p->bandwidth_hz) {
+		case 6000000:
 			dvb_bandwidth = 6;
 			s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
 			break;
-		case BANDWIDTH_7_MHZ:
+		case 7000000:
 			dvb_bandwidth = 7;
 			s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
 			break;
-		case BANDWIDTH_8_MHZ:
+		case 8000000:
 			dvb_bandwidth = 8;
 			s5h1432_set_IF(fe, IF_FREQ_4_MHZ);
 			break;
@@ -329,12 +329,6 @@ static int s5h1432_read_ber(struct dvb_frontend *fe, u32 *ber)
 	return 0;
 }
 
-static int s5h1432_get_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *p)
-{
-	return 0;
-}
-
 static int s5h1432_get_tune_settings(struct dvb_frontend *fe,
 				     struct dvb_frontend_tune_settings *tune)
 {
@@ -396,8 +390,7 @@ static struct dvb_frontend_ops s5h1432_ops = {
 
 	.init = s5h1432_init,
 	.sleep = s5h1432_sleep,
-	.set_frontend_legacy = s5h1432_set_frontend,
-	.get_frontend_legacy = s5h1432_get_frontend,
+	.set_frontend = s5h1432_set_frontend,
 	.get_tune_settings = s5h1432_get_tune_settings,
 	.read_status = s5h1432_read_status,
 	.read_ber = s5h1432_read_ber,
-- 
1.7.8.352.g876a6

