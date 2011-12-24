Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5xQ017050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 22/47] [media] budget-patch: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:27 -0200
Message-Id: <1324741852-26138-23-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-22-git-send-email-mchehab@redhat.com>
References: <1324741852-26138-1-git-send-email-mchehab@redhat.com>
 <1324741852-26138-2-git-send-email-mchehab@redhat.com>
 <1324741852-26138-3-git-send-email-mchehab@redhat.com>
 <1324741852-26138-4-git-send-email-mchehab@redhat.com>
 <1324741852-26138-5-git-send-email-mchehab@redhat.com>
 <1324741852-26138-6-git-send-email-mchehab@redhat.com>
 <1324741852-26138-7-git-send-email-mchehab@redhat.com>
 <1324741852-26138-8-git-send-email-mchehab@redhat.com>
 <1324741852-26138-9-git-send-email-mchehab@redhat.com>
 <1324741852-26138-10-git-send-email-mchehab@redhat.com>
 <1324741852-26138-11-git-send-email-mchehab@redhat.com>
 <1324741852-26138-12-git-send-email-mchehab@redhat.com>
 <1324741852-26138-13-git-send-email-mchehab@redhat.com>
 <1324741852-26138-14-git-send-email-mchehab@redhat.com>
 <1324741852-26138-15-git-send-email-mchehab@redhat.com>
 <1324741852-26138-16-git-send-email-mchehab@redhat.com>
 <1324741852-26138-17-git-send-email-mchehab@redhat.com>
 <1324741852-26138-18-git-send-email-mchehab@redhat.com>
 <1324741852-26138-19-git-send-email-mchehab@redhat.com>
 <1324741852-26138-20-git-send-email-mchehab@redhat.com>
 <1324741852-26138-21-git-send-email-mchehab@redhat.com>
 <1324741852-26138-22-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/ttpci/budget-patch.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ttpci/budget-patch.c b/drivers/media/dvb/ttpci/budget-patch.c
index 3395d1a..1f14a7f 100644
--- a/drivers/media/dvb/ttpci/budget-patch.c
+++ b/drivers/media/dvb/ttpci/budget-patch.c
@@ -263,17 +263,18 @@ static int budget_patch_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_c
 
 static int alps_bsrv2_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_patch* budget = (struct budget_patch*) fe->dvb->priv;
 	u8 pwr = 0;
 	u8 buf[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
-	u32 div = (params->frequency + 479500) / 125;
+	u32 div = (p->frequency + 479500) / 125;
 
-	if (params->frequency > 2000000) pwr = 3;
-	else if (params->frequency > 1800000) pwr = 2;
-	else if (params->frequency > 1600000) pwr = 1;
-	else if (params->frequency > 1200000) pwr = 0;
-	else if (params->frequency >= 1100000) pwr = 1;
+	if (p->frequency > 2000000) pwr = 3;
+	else if (p->frequency > 1800000) pwr = 2;
+	else if (p->frequency > 1600000) pwr = 1;
+	else if (p->frequency > 1200000) pwr = 0;
+	else if (p->frequency >= 1100000) pwr = 1;
 	else pwr = 2;
 
 	buf[0] = (div >> 8) & 0x7f;
@@ -299,12 +300,13 @@ static struct ves1x93_config alps_bsrv2_config = {
 
 static int grundig_29504_451_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct budget_patch* budget = (struct budget_patch*) fe->dvb->priv;
 	u32 div;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = params->frequency / 125;
+	div = p->frequency / 125;
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0x8e;
-- 
1.7.8.352.g876a6

