Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9V0q015935
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 72/94] [media] cinergyT2-fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:09 -0200
Message-Id: <1325257711-12274-73-git-send-email-mchehab@redhat.com>
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

