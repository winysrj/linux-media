Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab1L3PJb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:31 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9VdE026594
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 73/94] [media] dtt200u-fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:10 -0200
Message-Id: <1325257711-12274-74-git-send-email-mchehab@redhat.com>
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

