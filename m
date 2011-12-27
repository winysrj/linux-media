Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753704Ab1L0BJi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:38 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19ctl032637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:38 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 81/91] [media] ttusb-dec: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:09 -0200
Message-Id: <1324948159-23709-82-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-81-git-send-email-mchehab@redhat.com>
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
 <1324948159-23709-42-git-send-email-mchehab@redhat.com>
 <1324948159-23709-43-git-send-email-mchehab@redhat.com>
 <1324948159-23709-44-git-send-email-mchehab@redhat.com>
 <1324948159-23709-45-git-send-email-mchehab@redhat.com>
 <1324948159-23709-46-git-send-email-mchehab@redhat.com>
 <1324948159-23709-47-git-send-email-mchehab@redhat.com>
 <1324948159-23709-48-git-send-email-mchehab@redhat.com>
 <1324948159-23709-49-git-send-email-mchehab@redhat.com>
 <1324948159-23709-50-git-send-email-mchehab@redhat.com>
 <1324948159-23709-51-git-send-email-mchehab@redhat.com>
 <1324948159-23709-52-git-send-email-mchehab@redhat.com>
 <1324948159-23709-53-git-send-email-mchehab@redhat.com>
 <1324948159-23709-54-git-send-email-mchehab@redhat.com>
 <1324948159-23709-55-git-send-email-mchehab@redhat.com>
 <1324948159-23709-56-git-send-email-mchehab@redhat.com>
 <1324948159-23709-57-git-send-email-mchehab@redhat.com>
 <1324948159-23709-58-git-send-email-mchehab@redhat.com>
 <1324948159-23709-59-git-send-email-mchehab@redhat.com>
 <1324948159-23709-60-git-send-email-mchehab@redhat.com>
 <1324948159-23709-61-git-send-email-mchehab@redhat.com>
 <1324948159-23709-62-git-send-email-mchehab@redhat.com>
 <1324948159-23709-63-git-send-email-mchehab@redhat.com>
 <1324948159-23709-64-git-send-email-mchehab@redhat.com>
 <1324948159-23709-65-git-send-email-mchehab@redhat.com>
 <1324948159-23709-66-git-send-email-mchehab@redhat.com>
 <1324948159-23709-67-git-send-email-mchehab@redhat.com>
 <1324948159-23709-68-git-send-email-mchehab@redhat.com>
 <1324948159-23709-69-git-send-email-mchehab@redhat.com>
 <1324948159-23709-70-git-send-email-mchehab@redhat.com>
 <1324948159-23709-71-git-send-email-mchehab@redhat.com>
 <1324948159-23709-72-git-send-email-mchehab@redhat.com>
 <1324948159-23709-73-git-send-email-mchehab@redhat.com>
 <1324948159-23709-74-git-send-email-mchehab@redhat.com>
 <1324948159-23709-75-git-send-email-mchehab@redhat.com>
 <1324948159-23709-76-git-send-email-mchehab@redhat.com>
 <1324948159-23709-77-git-send-email-mchehab@redhat.com>
 <1324948159-23709-78-git-send-email-mchehab@redhat.com>
 <1324948159-23709-79-git-send-email-mchehab@redhat.com>
 <1324948159-23709-80-git-send-email-mchehab@redhat.com>
 <1324948159-23709-81-git-send-email-mchehab@redhat.com>
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

