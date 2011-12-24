Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab1LXPvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:07 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7Yq017064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 25/47] [media] tua6100: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:30 -0200
Message-Id: <1324741852-26138-26-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-25-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tua6100.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/frontends/tua6100.c b/drivers/media/dvb/frontends/tua6100.c
index bcb95c2..621d750 100644
--- a/drivers/media/dvb/frontends/tua6100.c
+++ b/drivers/media/dvb/frontends/tua6100.c
@@ -70,6 +70,7 @@ static int tua6100_sleep(struct dvb_frontend *fe)
 static int tua6100_set_params(struct dvb_frontend *fe,
 			      struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct tua6100_priv *priv = fe->tuner_priv;
 	u32 div;
 	u32 prediv;
@@ -85,36 +86,36 @@ static int tua6100_set_params(struct dvb_frontend *fe,
 #define _ri 4000000
 
 	// setup register 0
-	if (params->frequency < 2000000) {
+	if (c->frequency < 2000000) {
 		reg0[1] = 0x03;
 	} else {
 		reg0[1] = 0x07;
 	}
 
 	// setup register 1
-	if (params->frequency < 1630000) {
+	if (c->frequency < 1630000) {
 		reg1[1] = 0x2c;
 	} else {
 		reg1[1] = 0x0c;
 	}
 	if (_P == 64)
 		reg1[1] |= 0x40;
-	if (params->frequency >= 1525000)
+	if (c->frequency >= 1525000)
 		reg1[1] |= 0x80;
 
 	// register 2
 	reg2[1] = (_R >> 8) & 0x03;
 	reg2[2] = _R;
-	if (params->frequency < 1455000) {
+	if (c->frequency < 1455000) {
 		reg2[1] |= 0x1c;
-	} else if (params->frequency < 1630000) {
+	} else if (c->frequency < 1630000) {
 		reg2[1] |= 0x0c;
 	} else {
 		reg2[1] |= 0x1c;
 	}
 
-	// The N divisor ratio (note: params->frequency is in kHz, but we need it in Hz)
-	prediv = (params->frequency * _R) / (_ri / 1000);
+	// The N divisor ratio (note: c->frequency is in kHz, but we need it in Hz)
+	prediv = (c->frequency * _R) / (_ri / 1000);
 	div = prediv / _P;
 	reg1[1] |= (div >> 9) & 0x03;
 	reg1[2] = div >> 1;
-- 
1.7.8.352.g876a6

