Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755689Ab1LXPvM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:12 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFpBPs009983
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:11 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 19/47] [media] zl10039: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:24 -0200
Message-Id: <1324741852-26138-20-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-19-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/zl10039.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/zl10039.c b/drivers/media/dvb/frontends/zl10039.c
index c085e58..7fc8cef 100644
--- a/drivers/media/dvb/frontends/zl10039.c
+++ b/drivers/media/dvb/frontends/zl10039.c
@@ -177,8 +177,9 @@ static int zl10039_sleep(struct dvb_frontend *fe)
 }
 
 static int zl10039_set_params(struct dvb_frontend *fe,
-			struct dvb_frontend_parameters *params)
+			      struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct zl10039_state *state = fe->tuner_priv;
 	u8 buf[6];
 	u8 bf;
@@ -188,12 +189,12 @@ static int zl10039_set_params(struct dvb_frontend *fe,
 
 	dprintk("%s\n", __func__);
 	dprintk("Set frequency = %d, symbol rate = %d\n",
-			params->frequency, params->u.qpsk.symbol_rate);
+			c->frequency, c->symbol_rate);
 
 	/* Assumed 10.111 MHz crystal oscillator */
 	/* Cancelled num/den 80 to prevent overflow */
-	div = (params->frequency * 1000) / 126387;
-	fbw = (params->u.qpsk.symbol_rate * 27) / 32000;
+	div = (c->frequency * 1000) / 126387;
+	fbw = (c->symbol_rate * 27) / 32000;
 	/* Cancelled num/den 10 to prevent overflow */
 	bf = ((fbw * 5088) / 1011100) - 1;
 
-- 
1.7.8.352.g876a6

