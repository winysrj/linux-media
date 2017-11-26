Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38920 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdKZNAR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 08:00:17 -0500
Received: by mail-wm0-f65.google.com with SMTP id x63so29771220wmf.4
        for <linux-media@vger.kernel.org>; Sun, 26 Nov 2017 05:00:17 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, rascobie@slingshot.co.nz, jasmin@anw.at
Subject: [PATCH 4/7] [media] dvb-frontends/stv0910: remove unneeded check/call to get_if_freq
Date: Sun, 26 Nov 2017 14:00:06 +0100
Message-Id: <20171126130009.6798-5-d.scheller.oss@gmail.com>
In-Reply-To: <20171126130009.6798-1-d.scheller.oss@gmail.com>
References: <20171126130009.6798-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

The result (if any) isn't used anywhere besides being assigned to a local
variable (and the only current companion stv6111 doesn't even implement
get_if_frequency()), thus remove the ptr check and the call, and also
remove the now unused iffreq variable.

Reported-by: Richard Scobie <rascobie@slingshot.co.nz>
Cc: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
---
 drivers/media/dvb-frontends/stv0910.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index cd247ab9c62d..074374fe00be 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1273,14 +1273,11 @@ static int set_parameters(struct dvb_frontend *fe)
 {
 	int stat = 0;
 	struct stv *state = fe->demodulator_priv;
-	u32 iffreq;
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 
 	stop(state);
 	if (fe->ops.tuner_ops.set_params)
 		fe->ops.tuner_ops.set_params(fe);
-	if (fe->ops.tuner_ops.get_if_frequency)
-		fe->ops.tuner_ops.get_if_frequency(fe, &iffreq);
 	state->symbol_rate = p->symbol_rate;
 	stat = start(state, p);
 	return stat;
-- 
2.13.6
