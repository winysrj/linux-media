Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Vxj024223
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 81/94] [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:18 -0200
Message-Id: <1325257711-12274-82-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index 20a1410..96e2fdb 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -87,8 +87,9 @@ static int ttusbdecfe_dvbt_read_status(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusbdecfe_state* state = (struct ttusbdecfe_state*) fe->demodulator_priv;
 	u8 b[] = { 0x00, 0x00, 0x00, 0x03,
 		   0x00, 0x00, 0x00, 0x00,
@@ -113,8 +114,9 @@ static int ttusbdecfe_dvbt_get_tune_settings(struct dvb_frontend* fe,
 		return 0;
 }
 
-static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_parameters *p)
+static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct ttusbdecfe_state* state = (struct ttusbdecfe_state*) fe->demodulator_priv;
 
 	u8 b[] = { 0x00, 0x00, 0x00, 0x01,
@@ -135,7 +137,7 @@ static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend* fe, struct dvb_fron
 	freq = htonl(p->frequency +
 	       (state->hi_band ? LOF_HI : LOF_LO));
 	memcpy(&b[4], &freq, sizeof(u32));
-	sym_rate = htonl(p->u.qam.symbol_rate);
+	sym_rate = htonl(p->symbol_rate);
 	memcpy(&b[12], &sym_rate, sizeof(u32));
 	band = htonl(state->hi_band ? LOF_HI : LOF_LO);
 	memcpy(&b[24], &band, sizeof(u32));
@@ -241,7 +243,7 @@ struct dvb_frontend* ttusbdecfe_dvbs_attach(const struct ttusbdecfe_config* conf
 }
 
 static struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
-
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC2000-t Frontend",
 		.type			= FE_OFDM,
@@ -257,7 +259,7 @@ static struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
 
 	.release = ttusbdecfe_release,
 
-	.set_frontend_legacy = ttusbdecfe_dvbt_set_frontend,
+	.set_frontend = ttusbdecfe_dvbt_set_frontend,
 
 	.get_tune_settings = ttusbdecfe_dvbt_get_tune_settings,
 
@@ -265,7 +267,7 @@ static struct dvb_frontend_ops ttusbdecfe_dvbt_ops = {
 };
 
 static struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
-
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name			= "TechnoTrend/Hauppauge DEC3000-s Frontend",
 		.type			= FE_QPSK,
@@ -281,7 +283,7 @@ static struct dvb_frontend_ops ttusbdecfe_dvbs_ops = {
 
 	.release = ttusbdecfe_release,
 
-	.set_frontend_legacy = ttusbdecfe_dvbs_set_frontend,
+	.set_frontend = ttusbdecfe_dvbs_set_frontend,
 
 	.read_status = ttusbdecfe_dvbs_read_status,
 
-- 
1.7.8.352.g876a6

