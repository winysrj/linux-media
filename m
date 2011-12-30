Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304Ab1L3PJ1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:27 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9Rad015878
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:27 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 27/94] [media] ds3000: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:24 -0200
Message-Id: <1325257711-12274-28-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/ds3000.c |   33 ++++++++-------------------------
 1 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/media/dvb/frontends/ds3000.c b/drivers/media/dvb/frontends/ds3000.c
index 7fa5b92..f8fa80a 100644
--- a/drivers/media/dvb/frontends/ds3000.c
+++ b/drivers/media/dvb/frontends/ds3000.c
@@ -934,20 +934,6 @@ error2:
 }
 EXPORT_SYMBOL(ds3000_attach);
 
-static int ds3000_set_property(struct dvb_frontend *fe,
-	struct dtv_property *tvp)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
-static int ds3000_get_property(struct dvb_frontend *fe,
-	struct dtv_property *tvp)
-{
-	dprintk("%s(..)\n", __func__);
-	return 0;
-}
-
 static int ds3000_set_carrier_offset(struct dvb_frontend *fe,
 					s32 carrier_offset_khz)
 {
@@ -967,8 +953,7 @@ static int ds3000_set_carrier_offset(struct dvb_frontend *fe,
 	return 0;
 }
 
-static int ds3000_set_frontend(struct dvb_frontend *fe,
-				struct dvb_frontend_parameters *p)
+static int ds3000_set_frontend(struct dvb_frontend *fe)
 {
 	struct ds3000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
@@ -994,15 +979,15 @@ static int ds3000_set_frontend(struct dvb_frontend *fe,
 	div4 = 0;
 
 	/* calculate and set freq divider */
-	if (p->frequency < 1146000) {
+	if (c->frequency < 1146000) {
 		ds3000_tuner_writereg(state, 0x10, 0x11);
 		div4 = 1;
-		ndiv = ((p->frequency * (6 + 8) * 4) +
+		ndiv = ((c->frequency * (6 + 8) * 4) +
 				(DS3000_XTAL_FREQ / 2)) /
 				DS3000_XTAL_FREQ - 1024;
 	} else {
 		ds3000_tuner_writereg(state, 0x10, 0x01);
-		ndiv = ((p->frequency * (6 + 8) * 2) +
+		ndiv = ((c->frequency * (6 + 8) * 2) +
 				(DS3000_XTAL_FREQ / 2)) /
 				DS3000_XTAL_FREQ - 1024;
 	}
@@ -1101,7 +1086,7 @@ static int ds3000_set_frontend(struct dvb_frontend *fe,
 	msleep(60);
 
 	offset_khz = (ndiv - ndiv % 2 + 1024) * DS3000_XTAL_FREQ
-		/ (6 + 8) / (div4 + 1) / 2 - p->frequency;
+		/ (6 + 8) / (div4 + 1) / 2 - c->frequency;
 
 	/* ds3000 global reset */
 	ds3000_writereg(state, 0x07, 0x80);
@@ -1226,7 +1211,7 @@ static int ds3000_tune(struct dvb_frontend *fe,
 			fe_status_t *status)
 {
 	if (p) {
-		int ret = ds3000_set_frontend(fe, p);
+		int ret = ds3000_set_frontend(fe);
 		if (ret)
 			return ret;
 	}
@@ -1279,7 +1264,7 @@ static int ds3000_sleep(struct dvb_frontend *fe)
 }
 
 static struct dvb_frontend_ops ds3000_ops = {
-
+	.delsys = { SYS_DVBS, SYS_DVBS2},
 	.info = {
 		.name = "Montage Technology DS3000/TS2020",
 		.type = FE_QPSK,
@@ -1312,9 +1297,7 @@ static struct dvb_frontend_ops ds3000_ops = {
 	.diseqc_send_burst = ds3000_diseqc_send_burst,
 	.get_frontend_algo = ds3000_get_algo,
 
-	.set_property = ds3000_set_property,
-	.get_property = ds3000_get_property,
-	.set_frontend_legacy = ds3000_set_frontend,
+	.set_frontend = ds3000_set_frontend,
 	.tune = ds3000_tune,
 };
 
-- 
1.7.8.352.g876a6

