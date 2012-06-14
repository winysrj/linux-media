Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49371 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab2FNSBT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 14:01:19 -0400
Received: by mail-yx0-f174.google.com with SMTP id l2so1171135yen.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 11:01:19 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Justin P. Mattock" <justinmattock@gmail.com>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 8/8] s5h1420: Unused variable clock_setting
Date: Thu, 14 Jun 2012 14:58:16 -0300
Message-Id: <1339696716-14373-8-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The switch/case was setting clock_setting that is not being used. Both switch/case and the variable definition were removed.

Currently clock is being calculated by the formula:
(state->fclk/1000000 - 8)

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/dvb/frontends/s5h1420.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index 2322257..e2fec9e 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -634,7 +634,6 @@ static int s5h1420_set_frontend(struct dvb_frontend *fe)
 	struct s5h1420_state* state = fe->demodulator_priv;
 	int frequency_delta;
 	struct dvb_frontend_tune_settings fesettings;
-	uint8_t clock_setting;
 
 	dprintk("enter %s\n", __func__);
 
@@ -679,25 +678,6 @@ static int s5h1420_set_frontend(struct dvb_frontend *fe)
 	else
 		state->fclk = 44000000;
 
-	/* Clock */
-	switch (state->fclk) {
-	default:
-	case 88000000:
-		clock_setting = 80;
-		break;
-	case 86000000:
-		clock_setting = 78;
-		break;
-	case 80000000:
-		clock_setting = 72;
-		break;
-	case 59000000:
-		clock_setting = 51;
-		break;
-	case 44000000:
-		clock_setting = 36;
-		break;
-	}
 	dprintk("pll01: %d, ToneFreq: %d\n", state->fclk/1000000 - 8, (state->fclk + (TONE_FREQ * 32) - 1) / (TONE_FREQ * 32));
 	s5h1420_writereg(state, PLL01, state->fclk/1000000 - 8);
 	s5h1420_writereg(state, PLL02, 0x40);
-- 
1.7.10.2

