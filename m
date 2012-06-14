Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33431 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756526Ab2FNSAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 14:00:43 -0400
Received: by ghrr11 with SMTP id r11so1614804ghr.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 11:00:42 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 6/8] stv0367: variable 'tps_rcvd' set but not used
Date: Thu, 14 Jun 2012 14:58:14 -0300
Message-Id: <1339696716-14373-6-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/dvb/frontends/stv0367.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/media/dvb/frontends/stv0367.c b/drivers/media/dvb/frontends/stv0367.c
index fdd20c7..2a8aaeb 100644
--- a/drivers/media/dvb/frontends/stv0367.c
+++ b/drivers/media/dvb/frontends/stv0367.c
@@ -1584,7 +1584,7 @@ static int stv0367ter_algo(struct dvb_frontend *fe)
 	struct stv0367ter_state *ter_state = state->ter_state;
 	int offset = 0, tempo = 0;
 	u8 u_var;
-	u8 /*constell,*/ counter, tps_rcvd[2];
+	u8 /*constell,*/ counter;
 	s8 step;
 	s32 timing_offset = 0;
 	u32 trl_nomrate = 0, InternalFreq = 0, temp = 0;
@@ -1709,9 +1709,6 @@ static int stv0367ter_algo(struct dvb_frontend *fe)
 		return 0;
 
 	ter_state->state = FE_TER_LOCKOK;
-	/* update results */
-	tps_rcvd[0] = stv0367_readreg(state, R367TER_TPS_RCVD2);
-	tps_rcvd[1] = stv0367_readreg(state, R367TER_TPS_RCVD3);
 
 	ter_state->mode = stv0367_readbits(state, F367TER_SYR_MODE);
 	ter_state->guard = stv0367_readbits(state, F367TER_SYR_GUARD);
-- 
1.7.10.2

