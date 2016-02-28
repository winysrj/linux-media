Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:32918 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbcB1S37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2016 13:29:59 -0500
Received: by mail-wm0-f41.google.com with SMTP id l68so10762400wml.0
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2016 10:29:58 -0800 (PST)
From: Jemma Denson <jdenson@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Patrick Boettcher <patrick.boettcher@posteo.de>
Subject: [PATCH] [media] cx24120: make sure tuner is locked at get_frontend
Date: Sun, 28 Feb 2016 18:29:50 +0000
Message-Id: <1456684190-24713-1-git-send-email-jdenson@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change get_frontend to re-check current lock status rather than relying
on a cached value from get_status. Removes potential for tuning failure
if get_frontend is called during tuning.

Probably not too essential as other changes work around this:
https://patchwork.linuxtv.org/patch/32845/

Signed-off-by: Jemma Denson <jdenson@gmail.com>
---
 drivers/media/dvb-frontends/cx24120.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 6ccbd86..066ee38 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -1507,11 +1507,13 @@ static int cx24120_get_frontend(struct dvb_frontend *fe,
 {
 	struct cx24120_state *state = fe->demodulator_priv;
 	u8 freq1, freq2, freq3;
+	int status;
 
 	dev_dbg(&state->i2c->dev, "\n");
 
 	/* don't return empty data if we're not tuned in */
-	if ((state->fe_status & FE_HAS_LOCK) == 0)
+	status = cx24120_readreg(state, CX24120_REG_STATUS);
+	if (!(status & CX24120_HAS_LOCK))
 		return 0;
 
 	/* Get frequency */
-- 
2.5.0

