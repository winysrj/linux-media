Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab1L0BJa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:30 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19U50032599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:30 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 78/91] [media] vp7045-fe: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:06 -0200
Message-Id: <1324948159-23709-79-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-78-git-send-email-mchehab@redhat.com>
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

