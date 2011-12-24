Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8445 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755325Ab1LXPvG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:06 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp5tF017046
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:05 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 18/47] [media] cx24113: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:23 -0200
Message-Id: <1324741852-26138-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-18-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/cx24113.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/cx24113.c b/drivers/media/dvb/frontends/cx24113.c
index c341d57..07737e2 100644
--- a/drivers/media/dvb/frontends/cx24113.c
+++ b/drivers/media/dvb/frontends/cx24113.c
@@ -479,18 +479,19 @@ static int cx24113_init(struct dvb_frontend *fe)
 static int cx24113_set_params(struct dvb_frontend *fe,
 		struct dvb_frontend_parameters *p)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct cx24113_state *state = fe->tuner_priv;
 	/* for a ROLL-OFF factor of 0.35, 0.2: 600, 0.25: 625 */
 	u32 roll_off = 675;
 	u32 bw;
 
-	bw  = ((p->u.qpsk.symbol_rate/100) * roll_off) / 1000;
+	bw  = ((c->symbol_rate/100) * roll_off) / 1000;
 	bw += (10000000/100) + 5;
 	bw /= 10;
 	bw += 1000;
 	cx24113_set_bandwidth(state, bw);
 
-	cx24113_set_frequency(state, p->frequency);
+	cx24113_set_frequency(state, c->frequency);
 	msleep(5);
 	return cx24113_get_status(fe, &bw);
 }
-- 
1.7.8.352.g876a6

