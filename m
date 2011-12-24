Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab1LXPvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:07 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7JF030853
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 29/47] [media] stb6000: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:34 -0200
Message-Id: <1324741852-26138-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-29-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/stb6000.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/stb6000.c b/drivers/media/dvb/frontends/stb6000.c
index ed69964..d4f4ebb 100644
--- a/drivers/media/dvb/frontends/stb6000.c
+++ b/drivers/media/dvb/frontends/stb6000.c
@@ -78,6 +78,7 @@ static int stb6000_sleep(struct dvb_frontend *fe)
 static int stb6000_set_params(struct dvb_frontend *fe,
 				struct dvb_frontend_parameters *params)
 {
+	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct stb6000_priv *priv = fe->tuner_priv;
 	unsigned int n, m;
 	int ret;
@@ -93,8 +94,8 @@ static int stb6000_set_params(struct dvb_frontend *fe,
 
 	dprintk("%s:\n", __func__);
 
-	freq_mhz = params->frequency / 1000;
-	bandwidth = params->u.qpsk.symbol_rate / 1000000;
+	freq_mhz = p->frequency / 1000;
+	bandwidth = p->symbol_rate / 1000000;
 
 	if (bandwidth > 31)
 		bandwidth = 31;
-- 
1.7.8.352.g876a6

