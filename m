Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507Ab1LXPvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:07 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp6oW009954
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 30/47] [media] tda826x: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:35 -0200
Message-Id: <1324741852-26138-31-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-30-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/tda826x.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/tda826x.c b/drivers/media/dvb/frontends/tda826x.c
index 06c9480..ab9122a 100644
--- a/drivers/media/dvb/frontends/tda826x.c
+++ b/drivers/media/dvb/frontends/tda826x.c
@@ -73,6 +73,7 @@ static int tda826x_sleep(struct dvb_frontend *fe)
 
 static int tda826x_set_params(struct dvb_frontend *fe, struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct tda826x_priv *priv = fe->tuner_priv;
 	int ret;
 	u32 div;
@@ -83,11 +84,11 @@ static int tda826x_set_params(struct dvb_frontend *fe, struct dvb_frontend_param
 
 	dprintk("%s:\n", __func__);
 
-	div = (params->frequency + (1000-1)) / 1000;
+	div = (p->frequency + (1000-1)) / 1000;
 
 	/* BW = ((1 + RO) * SR/2 + 5) * 1.3      [SR in MSPS, BW in MHz] */
 	/* with R0 = 0.35 and some transformations: */
-	ksyms = params->u.qpsk.symbol_rate / 1000;
+	ksyms = p->symbol_rate / 1000;
 	bandwidth = (878 * ksyms + 6500000) / 1000000 + 1;
 	if (bandwidth < 5)
 		bandwidth = 5;
-- 
1.7.8.352.g876a6

