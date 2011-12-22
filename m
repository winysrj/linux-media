Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab1LVLUX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 06:20:23 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBMBKNxJ004855
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Thu, 22 Dec 2011 06:20:23 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC v3 27/28] [media] dvb-bt8xx: use DVBv5 parameters
Date: Thu, 22 Dec 2011 09:20:15 -0200
Message-Id: <1324552816-25704-28-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324552816-25704-27-git-send-email-mchehab@redhat.com>
References: <1324552816-25704-1-git-send-email-mchehab@redhat.com>
 <1324552816-25704-2-git-send-email-mchehab@redhat.com>
 <1324552816-25704-3-git-send-email-mchehab@redhat.com>
 <1324552816-25704-4-git-send-email-mchehab@redhat.com>
 <1324552816-25704-5-git-send-email-mchehab@redhat.com>
 <1324552816-25704-6-git-send-email-mchehab@redhat.com>
 <1324552816-25704-7-git-send-email-mchehab@redhat.com>
 <1324552816-25704-8-git-send-email-mchehab@redhat.com>
 <1324552816-25704-9-git-send-email-mchehab@redhat.com>
 <1324552816-25704-10-git-send-email-mchehab@redhat.com>
 <1324552816-25704-11-git-send-email-mchehab@redhat.com>
 <1324552816-25704-12-git-send-email-mchehab@redhat.com>
 <1324552816-25704-13-git-send-email-mchehab@redhat.com>
 <1324552816-25704-14-git-send-email-mchehab@redhat.com>
 <1324552816-25704-15-git-send-email-mchehab@redhat.com>
 <1324552816-25704-16-git-send-email-mchehab@redhat.com>
 <1324552816-25704-17-git-send-email-mchehab@redhat.com>
 <1324552816-25704-18-git-send-email-mchehab@redhat.com>
 <1324552816-25704-19-git-send-email-mchehab@redhat.com>
 <1324552816-25704-20-git-send-email-mchehab@redhat.com>
 <1324552816-25704-21-git-send-email-mchehab@redhat.com>
 <1324552816-25704-22-git-send-email-mchehab@redhat.com>
 <1324552816-25704-23-git-send-email-mchehab@redhat.com>
 <1324552816-25704-24-git-send-email-mchehab@redhat.com>
 <1324552816-25704-25-git-send-email-mchehab@redhat.com>
 <1324552816-25704-26-git-send-email-mchehab@redhat.com>
 <1324552816-25704-27-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/bt8xx/dvb-bt8xx.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index 521d691..5948601 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -193,11 +193,10 @@ static struct zl10353_config thomson_dtt7579_zl10353_config = {
 
 static int cx24108_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
-	u32 freq = params->frequency;
-
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
+	u32 freq = c->frequency;
 	int i, a, n, pump;
 	u32 band, pll;
-
 	u32 osci[]={950000,1019000,1075000,1178000,1296000,1432000,
 		1576000,1718000,1856000,2036000,2150000};
 	u32 bandsel[]={0,0x00020000,0x00040000,0x00100800,0x00101000,
@@ -269,29 +268,30 @@ static struct cx24110_config pctvsat_config = {
 
 static int microtune_mt7202dtf_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *) fe->dvb->priv;
 	u8 cfg, cpump, band_select;
 	u8 data[4];
 	u32 div;
 	struct i2c_msg msg = { .addr = 0x60, .flags = 0, .buf = data, .len = sizeof(data) };
 
-	div = (36000000 + params->frequency + 83333) / 166666;
+	div = (36000000 + c->frequency + 83333) / 166666;
 	cfg = 0x88;
 
-	if (params->frequency < 175000000)
+	if (c->frequency < 175000000)
 		cpump = 2;
-	else if (params->frequency < 390000000)
+	else if (c->frequency < 390000000)
 		cpump = 1;
-	else if (params->frequency < 470000000)
+	else if (c->frequency < 470000000)
 		cpump = 2;
-	else if (params->frequency < 750000000)
+	else if (c->frequency < 750000000)
 		cpump = 2;
 	else
 		cpump = 3;
 
-	if (params->frequency < 175000000)
+	if (c->frequency < 175000000)
 		band_select = 0x0e;
-	else if (params->frequency < 470000000)
+	else if (c->frequency < 470000000)
 		band_select = 0x05;
 	else
 		band_select = 0x03;
@@ -463,23 +463,24 @@ static struct or51211_config or51211_config = {
 
 static int vp3021_alps_tded4_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters* params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_bt8xx_card *card = (struct dvb_bt8xx_card *) fe->dvb->priv;
 	u8 buf[4];
 	u32 div;
 	struct i2c_msg msg = { .addr = 0x60, .flags = 0, .buf = buf, .len = sizeof(buf) };
 
-	div = (params->frequency + 36166667) / 166667;
+	div = (c->frequency + 36166667) / 166667;
 
 	buf[0] = (div >> 8) & 0x7F;
 	buf[1] = div & 0xFF;
 	buf[2] = 0x85;
-	if ((params->frequency >= 47000000) && (params->frequency < 153000000))
+	if ((c->frequency >= 47000000) && (c->frequency < 153000000))
 		buf[3] = 0x01;
-	else if ((params->frequency >= 153000000) && (params->frequency < 430000000))
+	else if ((c->frequency >= 153000000) && (c->frequency < 430000000))
 		buf[3] = 0x02;
-	else if ((params->frequency >= 430000000) && (params->frequency < 824000000))
+	else if ((c->frequency >= 430000000) && (c->frequency < 824000000))
 		buf[3] = 0x0C;
-	else if ((params->frequency >= 824000000) && (params->frequency < 863000000))
+	else if ((c->frequency >= 824000000) && (c->frequency < 863000000))
 		buf[3] = 0x8C;
 	else
 		return -EINVAL;
-- 
1.7.8.352.g876a6

