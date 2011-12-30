Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673Ab1L3PJc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:32 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Vkb009167
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:31 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 78/94] [media] vp7045-fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:15 -0200
Message-Id: <1325257711-12274-79-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/dvb-usb/vp7045-fe.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp7045-fe.c b/drivers/media/dvb/dvb-usb/vp7045-fe.c
index f8b5d8c..53d658a0 100644
--- a/drivers/media/dvb/dvb-usb/vp7045-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp7045-fe.c
@@ -103,9 +103,9 @@ static int vp7045_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_front
 	return 0;
 }
 
-static int vp7045_fe_set_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
+static int vp7045_fe_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct vp7045_fe_state *state = fe->demodulator_priv;
 	u8 buf[5];
 	u32 freq = fep->frequency / 1000;
@@ -115,11 +115,10 @@ static int vp7045_fe_set_frontend(struct dvb_frontend* fe,
 	buf[2] =  freq        & 0xff;
 	buf[3] = 0;
 
-	switch (fep->u.ofdm.bandwidth) {
-		case BANDWIDTH_8_MHZ: buf[4] = 8; break;
-		case BANDWIDTH_7_MHZ: buf[4] = 7; break;
-		case BANDWIDTH_6_MHZ: buf[4] = 6; break;
-		case BANDWIDTH_AUTO: return -EOPNOTSUPP;
+	switch (fep->bandwidth_hz) {
+		case 8000000: buf[4] = 8; break;
+		case 7000000: buf[4] = 7; break;
+		case 6000000: buf[4] = 6; break;
 		default:
 			return -EINVAL;
 	}
@@ -128,12 +127,6 @@ static int vp7045_fe_set_frontend(struct dvb_frontend* fe,
 	return 0;
 }
 
-static int vp7045_fe_get_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
-{
-	return 0;
-}
-
 static void vp7045_fe_release(struct dvb_frontend* fe)
 {
 	struct vp7045_fe_state *state = fe->demodulator_priv;
@@ -159,6 +152,7 @@ error:
 
 
 static struct dvb_frontend_ops vp7045_fe_ops = {
+	.delsys = { SYS_DVBT },
 	.info = {
 		.name			= "Twinhan VP7045/46 USB DVB-T",
 		.type			= FE_OFDM,
@@ -180,8 +174,7 @@ static struct dvb_frontend_ops vp7045_fe_ops = {
 	.init = vp7045_fe_init,
 	.sleep = vp7045_fe_sleep,
 
-	.set_frontend_legacy = vp7045_fe_set_frontend,
-	.get_frontend_legacy = vp7045_fe_get_frontend,
+	.set_frontend = vp7045_fe_set_frontend,
 	.get_tune_settings = vp7045_fe_get_tune_settings,
 
 	.read_status = vp7045_fe_read_status,
-- 
1.7.8.352.g876a6

