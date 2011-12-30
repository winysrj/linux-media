Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab1L3PJe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:34 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Y4Q024249
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:34 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 77/94] [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:08:14 -0200
Message-Id: <1325257711-12274-78-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/dvb-usb/vp702x-fe.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index 8ff5aab..fa0b811 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -135,9 +135,9 @@ static int vp702x_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_front
 	return 0;
 }
 
-static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
+static int vp702x_fe_set_frontend(struct dvb_frontend* fe)
 {
+	struct dtv_frontend_properties *fep = &fe->dtv_property_cache;
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	struct vp702x_device_state *dst = st->d->priv;
 	u32 freq = fep->frequency/1000;
@@ -155,14 +155,14 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 	cmd[1] =  freq       & 0xff;
 	cmd[2] = 1; /* divrate == 4 -> frequencyRef[1] -> 1 here */
 
-	sr = (u64) (fep->u.qpsk.symbol_rate/1000) << 20;
+	sr = (u64) (fep->symbol_rate/1000) << 20;
 	do_div(sr,88000);
 	cmd[3] = (sr >> 12) & 0xff;
 	cmd[4] = (sr >> 4)  & 0xff;
 	cmd[5] = (sr << 4)  & 0xf0;
 
 	deb_fe("setting frontend to: %u -> %u (%x) LNB-based GHz, symbolrate: %d -> %lu (%lx)\n",
-			fep->frequency,freq,freq, fep->u.qpsk.symbol_rate,
+			fep->frequency,freq,freq, fep->symbol_rate,
 			(unsigned long) sr, (unsigned long) sr);
 
 /*	if (fep->inversion == INVERSION_ON)
@@ -171,7 +171,7 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 	if (st->voltage == SEC_VOLTAGE_18)
 		cmd[6] |= 0x40;
 
-/*	if (fep->u.qpsk.symbol_rate > 8000000)
+/*	if (fep->symbol_rate > 8000000)
 		cmd[6] |= 0x20;
 
 	if (fep->frequency < 1531000)
@@ -212,7 +212,7 @@ static int vp702x_fe_sleep(struct dvb_frontend *fe)
 }
 
 static int vp702x_fe_get_frontend(struct dvb_frontend* fe,
-				  struct dvb_frontend_parameters *fep)
+				  struct dtv_frontend_properties *fep)
 {
 	deb_fe("%s\n",__func__);
 	return 0;
@@ -350,6 +350,7 @@ error:
 
 
 static struct dvb_frontend_ops vp702x_fe_ops = {
+	.delsys = { SYS_DVBS },
 	.info = {
 		.name           = "Twinhan DST-like frontend (VP7021/VP7020) DVB-S",
 		.type           = FE_QPSK,
@@ -370,8 +371,8 @@ static struct dvb_frontend_ops vp702x_fe_ops = {
 	.init  = vp702x_fe_init,
 	.sleep = vp702x_fe_sleep,
 
-	.set_frontend_legacy = vp702x_fe_set_frontend,
-	.get_frontend_legacy = vp702x_fe_get_frontend,
+	.set_frontend = vp702x_fe_set_frontend,
+	.get_frontend = vp702x_fe_get_frontend,
 	.get_tune_settings = vp702x_fe_get_tune_settings,
 
 	.read_status = vp702x_fe_read_status,
-- 
1.7.8.352.g876a6

