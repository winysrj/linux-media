Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53767 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab3CJCEk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:40 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 15/41] it913x: merge it913x_fe_suspend() to it913x_fe_sleep()
Date: Sun, 10 Mar 2013 04:03:07 +0200
Message-Id: <1362881013-5271-15-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/tuners/it913x.c | 32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

diff --git a/drivers/media/tuners/it913x.c b/drivers/media/tuners/it913x.c
index f1938a1..6eb3afa 100644
--- a/drivers/media/tuners/it913x.c
+++ b/drivers/media/tuners/it913x.c
@@ -401,36 +401,6 @@ static int it9137_set_tuner(struct dvb_frontend *fe)
 	return (ret < 0) ? -ENODEV : 0;
 }
 
-static int it913x_fe_suspend(struct it913x_fe_state *state)
-{
-	int ret = 0;
-	return 0;
-#if 0
-	int ret, i;
-	u8 b;
-
-	ret = it913x_write_reg(state, PRO_DMOD, SUSPEND_FLAG, 0x1);
-
-	ret |= it913x_write_reg(state, PRO_DMOD, TRIGGER_OFSM, 0x0);
-
-	for (i = 0; i < 128; i++) {
-		ret = it913x_read_reg(state, SUSPEND_FLAG, &b, 1);
-		if (ret < 0)
-			return -ENODEV;
-		if (b == 0)
-			break;
-
-	}
-
-	ret |= it913x_write_reg(state, PRO_DMOD, AFE_MEM0, 0x8);
-	/* Turn LED off */
-	ret |= it913x_write_reg(state, PRO_LINK, GPIOH3_O, 0x0);
-#endif
-	ret |= it913x_fe_script_loader(state, it9137_tuner_off);
-
-	return (ret < 0) ? -ENODEV : 0;
-}
-
 /* Power sequence */
 /* Power Up	Tuner on -> Frontend suspend off -> Tuner clk on */
 /* Power Down	Frontend suspend on -> Tuner clk off -> Tuner off */
@@ -438,7 +408,7 @@ static int it913x_fe_suspend(struct it913x_fe_state *state)
 static int it913x_fe_sleep(struct dvb_frontend *fe)
 {
 	struct it913x_fe_state *state = fe->tuner_priv;
-	return it913x_fe_suspend(state);
+	return it913x_fe_script_loader(state, it9137_tuner_off);
 }
 
 static int it913x_release(struct dvb_frontend *fe)
-- 
1.7.11.7

