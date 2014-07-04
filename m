Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39553 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709AbaGDRPw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:15:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 10/14] dib0090: Fix the sleep time at the state machine
Date: Fri,  4 Jul 2014 14:15:36 -0300
Message-Id: <1404494140-17777-11-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

msleep() is not too precise: its precision depends on the
HZ config. As the driver selects precise timings for the
state machine, change it to usleep_range().

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib0090.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib0090.c b/drivers/media/dvb-frontends/dib0090.c
index 3ee22ff76315..68e2af2650d3 100644
--- a/drivers/media/dvb-frontends/dib0090.c
+++ b/drivers/media/dvb-frontends/dib0090.c
@@ -2557,10 +2557,19 @@ static int dib0090_set_params(struct dvb_frontend *fe)
 
 	do {
 		ret = dib0090_tune(fe);
-		if (ret != FE_CALLBACK_TIME_NEVER)
-			msleep(ret / 10);
-		else
+		if (ret == FE_CALLBACK_TIME_NEVER)
 			break;
+
+		/*
+		 * Despite dib0090_tune returns time at a 0.1 ms range,
+		 * the actual sleep time depends on CONFIG_HZ. The worse case
+		 * is when CONFIG_HZ=100. In such case, the minimum granularity
+		 * is 10ms. On some real field tests, the tuner sometimes don't
+		 * lock when this timer is lower than 10ms. So, enforce a 10ms
+		 * granularity and use usleep_range() instead of msleep().
+		 */
+		ret = 10 * (ret + 99)/100;
+		usleep_range(ret * 1000, (ret + 1) * 1000);
 	} while (state->tune_state != CT_TUNER_STOP);
 
 	return 0;
-- 
1.9.3

