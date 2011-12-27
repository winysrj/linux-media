Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1L0BJq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:46 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19kkS005544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 72/91] [media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:00 -0200
Message-Id: <1324948159-23709-73-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-72-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/dvb-usb/cinergyT2-fe.c |   31 ++++++++++++++++++++---------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
index 40d50f7..0b49d44 100644
--- a/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/dvb/dvb-usb/cinergyT2-fe.c
@@ -40,9 +40,8 @@
  *  We replace errornous fields by default TPS fields (the ones with value 0).
  */
 
-static uint16_t compute_tps(struct dvb_frontend_parameters *p)
+static uint16_t compute_tps(struct dtv_frontend_properties *op)
 {
-	struct dvb_ofdm_parameters *op = &p->u.ofdm;
 	uint16_t tps = 0;
 
 	switch (op->code_rate_HP) {
@@ -83,7 +82,7 @@ static uint16_t compute_tps(struct dvb_frontend_parameters *p)
 		/* tps |= (0 << 4) */;
 	}
 
-	switch (op->constellation) {
+	switch (op->modulation) {
 	case QAM_16:
 		tps |= (1 << 13);
 		break;
@@ -119,7 +118,7 @@ static uint16_t compute_tps(struct dvb_frontend_parameters *p)
 		/* tps |= (0 << 2) */;
 	}
 
-	switch (op->hierarchy_information) {
+	switch (op->hierarchy) {
 	case HIERARCHY_1:
 		tps |= (1 << 10);
 		break;
@@ -263,9 +262,9 @@ static int cinergyt2_fe_get_tune_settings(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *fep)
+static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
 	struct dvbt_set_parameters_msg param;
 	char result[2];
@@ -274,9 +273,20 @@ static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe,
 	param.cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
 	param.tps = cpu_to_le16(compute_tps(fep));
 	param.freq = cpu_to_le32(fep->frequency / 1000);
-	param.bandwidth = 8 - fep->u.ofdm.bandwidth - BANDWIDTH_8_MHZ;
 	param.flags = 0;
 
+	switch (fep->bandwidth_hz) {
+		case 8000000:
+			param.bandwidth = 0;
+			break;
+		case 7000000:
+			param.bandwidth = 1;
+			break;
+		case 6000000:
+			param.bandwidth = 2;
+			break;
+	}
+
 	err = dvb_usb_generic_rw(state->d,
 			(char *)&param, sizeof(param),
 			result, sizeof(result), 0);
@@ -287,7 +297,7 @@ static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe,
 }
 
 static int cinergyt2_fe_get_frontend(struct dvb_frontend *fe,
-				  struct dvb_frontend_parameters *fep)
+				  struct dtv_frontend_properties *fep)
 {
 	return 0;
 }
@@ -316,6 +326,7 @@ struct dvb_frontend *cinergyt2_fe_attach(struct dvb_usb_device *d)
 
 
 static struct dvb_frontend_ops cinergyt2_fe_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= DRIVER_NAME,
 		.type			= FE_OFDM,
@@ -340,8 +351,8 @@ static struct dvb_frontend_ops cinergyt2_fe_ops = {
 	.init			= cinergyt2_fe_init,
 	.sleep			= cinergyt2_fe_sleep,
 
-	.set_frontend_legacy		= cinergyt2_fe_set_frontend,
-	.get_frontend_legacy = cinergyt2_fe_get_frontend,
+	.set_frontend		= cinergyt2_fe_set_frontend,
+	.get_frontend		= cinergyt2_fe_get_frontend,
 	.get_tune_settings	= cinergyt2_fe_get_tune_settings,
 
 	.read_status		= cinergyt2_fe_read_status,
-- 
1.7.8.352.g876a6

