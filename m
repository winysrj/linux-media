Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828Ab1L0BJm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Dec 2011 20:09:42 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBR19g5U032663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 26 Dec 2011 20:09:42 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 77/91] [media] vp702x-fe: convert set_fontend to use DVBv5 parameters
Date: Mon, 26 Dec 2011 23:09:05 -0200
Message-Id: <1324948159-23709-78-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324948159-23709-77-git-send-email-mchehab@redhat.com>
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

