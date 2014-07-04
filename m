Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaGDRRK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jul 2014 13:17:10 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [[PATCH v2] 09/14] dib8000: Fix the sleep time at the state machine
Date: Fri,  4 Jul 2014 14:15:35 -0300
Message-Id: <1404494140-17777-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
References: <1404494140-17777-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

msleep() is not too precise: its precision depends on the
HZ config. As the driver selects precise timings for the
state machine, change it to usleep_range().

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index e4da545680b6..9f40af588441 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3607,10 +3607,19 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 			else if ((time_slave != FE_CALLBACK_TIME_NEVER) && (time_slave > time))
 				time = time_slave;
 		}
-		if (time != FE_CALLBACK_TIME_NEVER)
-			msleep(time / 10);
-		else
+		if (time == FE_CALLBACK_TIME_NEVER)
 			break;
+
+		/*
+		 * Despite dib8000_agc_startup returns time at a 0.1 ms range,
+		 * the actual sleep time depends on CONFIG_HZ. The worse case
+		 * is when CONFIG_HZ=100. In such case, the minimum granularity
+		 * is 10ms. On some real field tests, the tuner sometimes don't
+		 * lock when this timer is lower than 10ms. So, enforce a 10ms
+		 * granularity.
+		 */
+		time = 10 * (time + 99)/100;
+		usleep_range(time * 1000, (time + 1) * 1000);
 		exit_condition = 1;
 		for (index_frontend = 0; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 			if (dib8000_get_tune_state(state->fe[index_frontend]) != CT_AGC_STOP) {
-- 
1.9.3

