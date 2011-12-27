Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab1L0BJr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:47 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19lw6017938
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:47 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 41/91] [media] s5h1432: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:08:29 -0200
Message-Id: <1324948159-23709-42-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-41-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-22-git-send-email-mchehab@redhat.com>
 <1324948159-23709-23-git-send-email-mchehab@redhat.com>
 <1324948159-23709-24-git-send-email-mchehab@redhat.com>
 <1324948159-23709-25-git-send-email-mchehab@redhat.com>
 <1324948159-23709-26-git-send-email-mchehab@redhat.com>
 <1324948159-23709-27-git-send-email-mchehab@redhat.com>
 <1324948159-23709-28-git-send-email-mchehab@redhat.com>
 <1324948159-23709-29-git-send-email-mchehab@redhat.com>
 <1324948159-23709-30-git-send-email-mchehab@redhat.com>
 <1324948159-23709-31-git-send-email-mchehab@redhat.com>
 <1324948159-23709-32-git-send-email-mchehab@redhat.com>
 <1324948159-23709-33-git-send-email-mchehab@redhat.com>
 <1324948159-23709-34-git-send-email-mchehab@redhat.com>
 <1324948159-23709-35-git-send-email-mchehab@redhat.com>
 <1324948159-23709-36-git-send-email-mchehab@redhat.com>
 <1324948159-23709-37-git-send-email-mchehab@redhat.com>
 <1324948159-23709-38-git-send-email-mchehab@redhat.com>
 <1324948159-23709-39-git-send-email-mchehab@redhat.com>
 <1324948159-23709-40-git-send-email-mchehab@redhat.com>
 <1324948159-23709-41-git-send-email-mchehab@redhat.com>
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

