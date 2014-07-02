Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbaGBPwd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jul 2014 11:52:33 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Patrick Boettcher <pboettcher@kernellabs.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH RFC 7/9] dib8000: Fix the sleep time at the state machine
Date: Wed,  2 Jul 2014 12:52:21 -0300
Message-Id: <1404316343-23856-8-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
References: <1404316343-23856-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

msleep() is not too precise: its precision depends on the
HZ config. As the driver selects precise timings for the
state machine, change it to usleep_range().

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/dib8000.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index f657cb510bd1..d160a1ed92bb 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3601,10 +3601,10 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 			else if ((time_slave != FE_CALLBACK_TIME_NEVER) && (time_slave > time))
 				time = time_slave;
 		}
-		if (time != FE_CALLBACK_TIME_NEVER)
-			msleep(time / 10);
-		else
+		if (time == FE_CALLBACK_TIME_NEVER)
 			break;
+
+		usleep_range(time * 100, (time + 10) * 100);
 		exit_condition = 1;
 		for (index_frontend = 0; (index_frontend < MAX_NUMBER_OF_FRONTENDS) && (state->fe[index_frontend] != NULL); index_frontend++) {
 			if (dib8000_get_tune_state(state->fe[index_frontend]) != CT_AGC_STOP) {
-- 
1.9.3

