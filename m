Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab1LXPvI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:08 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7Eq018694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 41/47] [media] dib0070: Remove unused dvb_frontend_parameters
Date: Sat, 24 Dec 2011 13:50:46 -0200
Message-Id: <1324741852-26138-42-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-41-git-send-email-mchehab@redhat.com>
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
 <1324741852-26138-28-git-send-email-mchehab@redhat.com>
 <1324741852-26138-29-git-send-email-mchehab@redhat.com>
 <1324741852-26138-30-git-send-email-mchehab@redhat.com>
 <1324741852-26138-31-git-send-email-mchehab@redhat.com>
 <1324741852-26138-32-git-send-email-mchehab@redhat.com>
 <1324741852-26138-33-git-send-email-mchehab@redhat.com>
 <1324741852-26138-34-git-send-email-mchehab@redhat.com>
 <1324741852-26138-35-git-send-email-mchehab@redhat.com>
 <1324741852-26138-36-git-send-email-mchehab@redhat.com>
 <1324741852-26138-37-git-send-email-mchehab@redhat.com>
 <1324741852-26138-38-git-send-email-mchehab@redhat.com>
 <1324741852-26138-39-git-send-email-mchehab@redhat.com>
 <1324741852-26138-40-git-send-email-mchehab@redhat.com>
 <1324741852-26138-41-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/dib0070.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/dib0070.c b/drivers/media/dvb/frontends/dib0070.c
index dc1cb17..4ca3441 100644
--- a/drivers/media/dvb/frontends/dib0070.c
+++ b/drivers/media/dvb/frontends/dib0070.c
@@ -150,7 +150,7 @@ static int dib0070_write_reg(struct dib0070_state *state, u8 reg, u16 val)
     } \
 } while (0)
 
-static int dib0070_set_bandwidth(struct dvb_frontend *fe, struct dvb_frontend_parameters *ch)
+static int dib0070_set_bandwidth(struct dvb_frontend *fe)
 {
     struct dib0070_state *state = fe->tuner_priv;
     u16 tmp = dib0070_read_reg(state, 0x02) & 0x3fff;
@@ -335,7 +335,7 @@ static const struct dib0070_lna_match dib0070_lna[] = {
 };
 
 #define LPF	100
-static int dib0070_tune_digital(struct dvb_frontend *fe, struct dvb_frontend_parameters *ch)
+static int dib0070_tune_digital(struct dvb_frontend *fe)
 {
     struct dib0070_state *state = fe->tuner_priv;
 
@@ -507,7 +507,7 @@ static int dib0070_tune_digital(struct dvb_frontend *fe, struct dvb_frontend_par
 
 	*tune_state = CT_TUNER_STEP_5;
     } else if (*tune_state == CT_TUNER_STEP_5) {
-	dib0070_set_bandwidth(fe, ch);
+	dib0070_set_bandwidth(fe);
 	*tune_state = CT_TUNER_STOP;
     } else {
 	ret = FE_CALLBACK_TIME_NEVER; /* tuner finished, time to call again infinite */
@@ -524,7 +524,7 @@ static int dib0070_tune(struct dvb_frontend *fe, struct dvb_frontend_parameters
     state->tune_state = CT_TUNER_START;
 
     do {
-	ret = dib0070_tune_digital(fe, p);
+	ret = dib0070_tune_digital(fe);
 	if (ret != FE_CALLBACK_TIME_NEVER)
 		msleep(ret/10);
 	else
-- 
1.7.8.352.g876a6

