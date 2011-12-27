Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59925 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1L0BJu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:50 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19nBj005574
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:50 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 73/91] [media] dtt200u-fe: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:01 -0200
Message-Id: <1324948159-23709-74-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-73-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/dvb-usb/dtt200u-fe.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dtt200u-fe.c b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
index 7ce8227..643242e 100644
--- a/drivers/media/dvb/dvb-usb/dtt200u-fe.c
+++ b/drivers/media/dvb/dvb-usb/dtt200u-fe.c
@@ -16,7 +16,7 @@ struct dtt200u_fe_state {
 
 	fe_status_t stat;
 
-	struct dvb_frontend_parameters fep;
+	struct dtv_frontend_properties fep;
 	struct dvb_frontend frontend;
 };
 
@@ -100,20 +100,19 @@ static int dtt200u_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_fron
 	return 0;
 }
 
-static int dtt200u_fe_set_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
+static int dtt200u_fe_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
 	int i;
 	fe_status_t st;
 	u16 freq = fep->frequency / 250000;
 	u8 bwbuf[2] = { SET_BANDWIDTH, 0 },freqbuf[3] = { SET_RF_FREQ, 0, 0 };
 
-	switch (fep->u.ofdm.bandwidth) {
-		case BANDWIDTH_8_MHZ: bwbuf[1] = 8; break;
-		case BANDWIDTH_7_MHZ: bwbuf[1] = 7; break;
-		case BANDWIDTH_6_MHZ: bwbuf[1] = 6; break;
-		case BANDWIDTH_AUTO: return -EOPNOTSUPP;
+	switch (fep->bandwidth_hz) {
+		case 8000000: bwbuf[1] = 8; break;
+		case 7000000: bwbuf[1] = 7; break;
+		case 6000000: bwbuf[1] = 6; break;
 		default:
 			return -EINVAL;
 	}
@@ -135,10 +134,10 @@ static int dtt200u_fe_set_frontend(struct dvb_frontend* fe,
 }
 
 static int dtt200u_fe_get_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
+				  struct dtv_frontend_properties *fep)
 {
 	struct dtt200u_fe_state *state = fe->demodulator_priv;
-	memcpy(fep,&state->fep,sizeof(struct dvb_frontend_parameters));
+	memcpy(fep,&state->fep,sizeof(struct dtv_frontend_properties));
 	return 0;
 }
 
@@ -172,6 +171,7 @@ error:
 }
 
 static struct dvb_frontend_ops dtt200u_fe_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "WideView USB DVB-T",
 		.type			= FE_OFDM,
@@ -193,8 +193,8 @@ static struct dvb_frontend_ops dtt200u_fe_ops = {
 	.init = dtt200u_fe_init,
 	.sleep = dtt200u_fe_sleep,
 
-	.set_frontend_legacy = dtt200u_fe_set_frontend,
-	.get_frontend_legacy = dtt200u_fe_get_frontend,
+	.set_frontend = dtt200u_fe_set_frontend,
+	.get_frontend = dtt200u_fe_get_frontend,
 	.get_tune_settings = dtt200u_fe_get_tune_settings,
 
 	.read_status = dtt200u_fe_read_status,
-- 
1.7.8.352.g876a6

