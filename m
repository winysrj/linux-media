Return-path: <linux-media-owner@vger.kernel.org>
Received: from etezian.org ([198.101.225.253]:58645 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab3KSN5i (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 08:57:38 -0500
From: Andi Shyti <andi@etezian.org>
To: m.chehab@samsung.com, mkrufky@linuxtv.org, ljalvs@gmail.com,
	crope@iki.fi
Cc: andi@etezian.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] media: cx24117: remove dead code in always 'false' if statement
Date: Tue, 19 Nov 2013 14:49:37 +0100
Message-Id: <1384868977-24211-1-git-send-email-andi@etezian.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

At this point of the execution in the function cx24117_attach()
demod cannot be '0'. In that case the function returns earlier
with an error value ('NULL'). Remove the if statement.

This error has been reported by scan.coverity.com

Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/media/dvb-frontends/cx24117.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index 476b422..07a9894 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1190,12 +1190,6 @@ struct dvb_frontend *cx24117_attach(const struct cx24117_config *config,
 	state->demod = demod - 1;
 	state->priv = priv;
 
-	/* test i2c bus for ack */
-	if (demod == 0) {
-		if (cx24117_readreg(state, 0x00) < 0)
-			goto error3;
-	}
-
 	dev_info(&state->priv->i2c->dev,
 		"%s: Attaching frontend %d\n",
 		KBUILD_MODNAME, state->demod);
@@ -1206,8 +1200,6 @@ struct dvb_frontend *cx24117_attach(const struct cx24117_config *config,
 	state->frontend.demodulator_priv = state;
 	return &state->frontend;
 
-error3:
-	kfree(state);
 error2:
 	cx24117_release_priv(priv);
 error1:
-- 
1.8.4.3

