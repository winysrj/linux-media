Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:38917 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752145AbdKZNAP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Nov 2017 08:00:15 -0500
Received: by mail-wm0-f65.google.com with SMTP id x63so29771131wmf.4
        for <linux-media@vger.kernel.org>; Sun, 26 Nov 2017 05:00:15 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rjkm@metzlerbros.de, rascobie@slingshot.co.nz, jasmin@anw.at
Subject: [PATCH 2/7] [media] dvb-frontends/stv0910: WARN_ON() on consecutive mutex_unlock()
Date: Sun, 26 Nov 2017 14:00:04 +0100
Message-Id: <20171126130009.6798-3-d.scheller.oss@gmail.com>
In-Reply-To: <20171126130009.6798-1-d.scheller.oss@gmail.com>
References: <20171126130009.6798-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Stack dump when gate_ctrl() is called in a way that consecutive unlocks
happen. This is a clear indication that other drivers interfacing with
the stv0910 driver don't do things properly or don't check for failures,
so dump stack so that those drivers can be identified and fixed.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Richard Scobie <rascobie@slingshot.co.nz>
---
 drivers/media/dvb-frontends/stv0910.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 8bf855c301f5..cd247ab9c62d 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1241,7 +1241,8 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 	if (write_reg(state, state->nr ? RSTV0910_P2_I2CRPT :
 		      RSTV0910_P1_I2CRPT, i2crpt) < 0) {
 		/* don't hold the I2C bus lock on failure */
-		mutex_unlock(&state->base->i2c_lock);
+		if (!WARN_ON(!mutex_is_locked(&state->base->i2c_lock)))
+			mutex_unlock(&state->base->i2c_lock);
 		dev_err(&state->base->i2c->dev,
 			"%s() write_reg failure (enable=%d)\n",
 			__func__, enable);
@@ -1251,7 +1252,8 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 	state->i2crpt = i2crpt;
 
 	if (!enable)
-		mutex_unlock(&state->base->i2c_lock);
+		if (!WARN_ON(!mutex_is_locked(&state->base->i2c_lock)))
+			mutex_unlock(&state->base->i2c_lock);
 	return 0;
 }
 
-- 
2.13.6
