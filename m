Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab1LXPvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Dec 2011 10:51:07 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pBOFp7JY018685
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 24 Dec 2011 10:51:07 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH v4 26/47] [media] itd1000: use DVBv5 parameters on set_params()
Date: Sat, 24 Dec 2011 13:50:31 -0200
Message-Id: <1324741852-26138-27-git-send-email-mchehab@redhat.com>
In-Reply-To: <1324741852-26138-26-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of using DVBv3 parameters, rely on DVBv5 parameters to
set the tuner

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/frontends/itd1000.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/frontends/itd1000.c b/drivers/media/dvb/frontends/itd1000.c
index aa9ccb8..afe7cc0 100644
--- a/drivers/media/dvb/frontends/itd1000.c
+++ b/drivers/media/dvb/frontends/itd1000.c
@@ -252,11 +252,12 @@ static void itd1000_set_lo(struct itd1000_state *state, u32 freq_khz)
 
 static int itd1000_set_parameters(struct dvb_frontend *fe, struct dvb_frontend_parameters *p)
 {
+	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct itd1000_state *state = fe->tuner_priv;
 	u8 pllcon1;
 
-	itd1000_set_lo(state, p->frequency);
-	itd1000_set_lpf_bw(state, p->u.qpsk.symbol_rate);
+	itd1000_set_lo(state, c->frequency);
+	itd1000_set_lpf_bw(state, c->symbol_rate);
 
 	pllcon1 = itd1000_read_reg(state, PLLCON1) & 0x7f;
 	itd1000_write_reg(state, PLLCON1, pllcon1 | (1 << 7));
-- 
1.7.8.352.g876a6

