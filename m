Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020Ab1L3PJZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Dec 2011 10:09:25 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBUF9OgD009087
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 30 Dec 2011 10:09:24 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCHv2 07/94] [media] bcm3510: convert set_fontend to use DVBv5 parameters
Date: Fri, 30 Dec 2011 13:07:04 -0200
Message-Id: <1325257711-12274-8-git-send-email-mchehab@redhat.com>
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
 drivers/media/dvb/frontends/bcm3510.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index 43b17fa..a53f83a 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -479,16 +479,16 @@ static int bcm3510_set_freq(struct bcm3510_state* st,u32 freq)
 	return -EINVAL;
 }
 
-static int bcm3510_set_frontend(struct dvb_frontend* fe,
-					     struct dvb_frontend_parameters *p)
+static int bcm3510_set_frontend(struct dvb_frontend *fe)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct bcm3510_state* st = fe->demodulator_priv;
 	struct bcm3510_hab_cmd_ext_acquire cmd;
 	struct bcm3510_hab_cmd_bert_control bert;
 	int ret;
 
 	memset(&cmd,0,sizeof(cmd));
-	switch (p->u.vsb.modulation) {
+	switch (c->modulation) {
 		case QAM_256:
 			cmd.ACQUIRE0.MODE = 0x1;
 			cmd.ACQUIRE1.SYM_RATE = 0x1;
@@ -499,7 +499,8 @@ static int bcm3510_set_frontend(struct dvb_frontend* fe,
 			cmd.ACQUIRE1.SYM_RATE = 0x2;
 			cmd.ACQUIRE1.IF_FREQ = 0x1;
 			break;
-/*		case QAM_256:
+#if 0
+		case QAM_256:
 			cmd.ACQUIRE0.MODE = 0x3;
 			break;
 		case QAM_128:
@@ -513,7 +514,8 @@ static int bcm3510_set_frontend(struct dvb_frontend* fe,
 			break;
 		case QAM_16:
 			cmd.ACQUIRE0.MODE = 0x7;
-			break;*/
+			break;
+#endif
 		case VSB_8:
 			cmd.ACQUIRE0.MODE = 0x8;
 			cmd.ACQUIRE1.SYM_RATE = 0x0;
@@ -552,7 +554,8 @@ static int bcm3510_set_frontend(struct dvb_frontend* fe,
 
 	bcm3510_bert_reset(st);
 
-	if ((ret = bcm3510_set_freq(st,p->frequency)) < 0)
+	ret = bcm3510_set_freq(st, c->frequency);
+	if (ret < 0)
 		return ret;
 
 	memset(&st->status1,0,sizeof(st->status1));
@@ -819,7 +822,7 @@ error:
 EXPORT_SYMBOL(bcm3510_attach);
 
 static struct dvb_frontend_ops bcm3510_ops = {
-
+	.delsys = { SYS_ATSC, SYS_DVBC_ANNEX_B },
 	.info = {
 		.name = "Broadcom BCM3510 VSB/QAM frontend",
 		.type = FE_ATSC,
@@ -839,7 +842,7 @@ static struct dvb_frontend_ops bcm3510_ops = {
 	.init = bcm3510_init,
 	.sleep = bcm3510_sleep,
 
-	.set_frontend_legacy = bcm3510_set_frontend,
+	.set_frontend = bcm3510_set_frontend,
 	.get_tune_settings = bcm3510_get_tune_settings,
 
 	.read_status = bcm3510_read_status,
-- 
1.7.8.352.g876a6

