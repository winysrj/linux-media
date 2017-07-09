Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33843 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdGIQgt (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Jul 2017 12:36:49 -0400
Received: by mail-wr0-f194.google.com with SMTP id k67so19537872wrc.1
        for <linux-media@vger.kernel.org>; Sun, 09 Jul 2017 09:36:49 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: liplianin@netup.ru
Subject: [PATCH] [media] dvb-frontends/stv0367: DDB frontend status inquiry fixup
Date: Sun,  9 Jul 2017 18:36:45 +0200
Message-Id: <20170709163645.1214-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Return 0 instead of -EINVAL in get_frontend if no demod mode is active.
This fixes ie. dvb-fe-tool getting confused and assuming a DVBv3 FE on idle
frontends when the FE has been put to sleep using sleep().

Also, in read_status(), don't immediately return when no demod is active,
so the remaining code has a chance to clear the signal statistics.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0367.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
index 8ac0f598978d..59c1aad256c2 100644
--- a/drivers/media/dvb-frontends/stv0367.c
+++ b/drivers/media/dvb-frontends/stv0367.c
@@ -3090,7 +3090,7 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
 {
 	struct stv0367_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
-	int ret;
+	int ret = 0;
 
 	switch (state->activedemod) {
 	case demod_ter:
@@ -3100,7 +3100,7 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
 		ret = stv0367cab_read_status(fe, status);
 		break;
 	default:
-		return 0;
+		break;
 	}
 
 	/* stop and report on *_read_status failure */
@@ -3138,7 +3138,7 @@ static int stv0367ddb_get_frontend(struct dvb_frontend *fe,
 		break;
 	}
 
-	return -EINVAL;
+	return 0;
 }
 
 static int stv0367ddb_sleep(struct dvb_frontend *fe)
-- 
2.13.0
