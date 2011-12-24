Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab1LXPvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:08 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7i9030860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 27/47] [media] bsbe1, bsru6, tdh1: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:32 -0200
Message-Id: <1324741852-26138-28-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-27-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-23-git-send-email-mchehab@redhat.com>
 <1324741852-26138-24-git-send-email-mchehab@redhat.com>
 <1324741852-26138-25-git-send-email-mchehab@redhat.com>
 <1324741852-26138-26-git-send-email-mchehab@redhat.com>
 <1324741852-26138-27-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/bsbe1.h |    5 +++--
 drivers/media/dvb/frontends/bsru6.h |    7 ++++---
 drivers/media/dvb/frontends/tdhd1.h |    9 +++++----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/dvb/frontends/bsbe1.h b/drivers/media/dvb/frontends/bsbe1.h
index 5e431eb..e008946 100644
--- a/drivers/media/dvb/frontends/bsbe1.h
+++ b/drivers/media/dvb/frontends/bsbe1.h
@@ -71,16 +71,17 @@ static int alps_bsbe1_set_symbol_rate(struct dvb_frontend* fe, u32 srate, u32 ra
 
 static int alps_bsbe1_tuner_set_params(struct dvb_frontend* fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	int ret;
 	u8 data[4];
 	u32 div;
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 	struct i2c_adapter *i2c = fe->tuner_priv;
 
-	if ((params->frequency < 950000) || (params->frequency > 2150000))
+	if ((p->frequency < 950000) || (p->frequency > 2150000))
 		return -EINVAL;
 
-	div = params->frequency / 1000;
+	div = p->frequency / 1000;
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0x80 | ((div & 0x18000) >> 10) | 0x1;
diff --git a/drivers/media/dvb/frontends/bsru6.h b/drivers/media/dvb/frontends/bsru6.h
index c480c83..cd8c675 100644
--- a/drivers/media/dvb/frontends/bsru6.h
+++ b/drivers/media/dvb/frontends/bsru6.h
@@ -103,21 +103,22 @@ static int alps_bsru6_set_symbol_rate(struct dvb_frontend *fe, u32 srate, u32 ra
 
 static int alps_bsru6_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	u8 buf[4];
 	u32 div;
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = buf, .len = sizeof(buf) };
 	struct i2c_adapter *i2c = fe->tuner_priv;
 
-	if ((params->frequency < 950000) || (params->frequency > 2150000))
+	if ((p->frequency < 950000) || (p->frequency > 2150000))
 		return -EINVAL;
 
-	div = (params->frequency + (125 - 1)) / 125;	// round correctly
+	div = (p->frequency + (125 - 1)) / 125;	// round correctly
 	buf[0] = (div >> 8) & 0x7f;
 	buf[1] = div & 0xff;
 	buf[2] = 0x80 | ((div & 0x18000) >> 10) | 4;
 	buf[3] = 0xC4;
 
-	if (params->frequency > 1530000)
+	if (p->frequency > 1530000)
 		buf[3] = 0xc0;
 
 	if (fe->ops.i2c_gate_ctrl)
diff --git a/drivers/media/dvb/frontends/tdhd1.h b/drivers/media/dvb/frontends/tdhd1.h
index 51f1706..9db221b 100644
--- a/drivers/media/dvb/frontends/tdhd1.h
+++ b/drivers/media/dvb/frontends/tdhd1.h
@@ -42,22 +42,23 @@ static struct tda1004x_config alps_tdhd1_204a_config = {
 
 static int alps_tdhd1_204a_tuner_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct i2c_adapter *i2c = fe->tuner_priv;
 	u8 data[4];
 	struct i2c_msg msg = { .addr = 0x61, .flags = 0, .buf = data, .len = sizeof(data) };
 	u32 div;
 
-	div = (params->frequency + 36166666) / 166666;
+	div = (p->frequency + 36166666) / 166666;
 
 	data[0] = (div >> 8) & 0x7f;
 	data[1] = div & 0xff;
 	data[2] = 0x85;
 
-	if (params->frequency >= 174000000 && params->frequency <= 230000000)
+	if (p->frequency >= 174000000 && p->frequency <= 230000000)
 		data[3] = 0x02;
-	else if (params->frequency >= 470000000 && params->frequency <= 823000000)
+	else if (p->frequency >= 470000000 && p->frequency <= 823000000)
 		data[3] = 0x0C;
-	else if (params->frequency > 823000000 && params->frequency <= 862000000)
+	else if (p->frequency > 823000000 && p->frequency <= 862000000)
 		data[3] = 0x8C;
 	else
 		return -EINVAL;
-- 
1.7.8.352.g876a6

