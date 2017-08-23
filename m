Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34292 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932103AbdHWQKH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 12:10:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id r187so615463wma.1
        for <linux-media@vger.kernel.org>; Wed, 23 Aug 2017 09:10:07 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/5] [media] dvb-frontends/stv0910: release lock on gate_ctrl() failure
Date: Wed, 23 Aug 2017 18:09:58 +0200
Message-Id: <20170823161002.25459-2-d.scheller.oss@gmail.com>
In-Reply-To: <20170823161002.25459-1-d.scheller.oss@gmail.com>
References: <20170823161002.25459-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Whenever write_reg() fails to open/close the demod's I2C gate, release the
lock to avoid deadlocking situations. If I2c gate open failed, there's no
need to hold a lock, and if close fails, the mutex_unlock() at the end of
the function is never reached, leaving the mutex_lock in locked state,
which in turn will cause potential for deadlocks. Thus, release the lock
on failure.

While we're touching gate_ctrl(), add some explanation about the need for
locking and the shared I2C bus/gate.

Cc: Julia Lawall <julia.lawall@lip6.fr>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/stv0910.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index d1ae9553f74c..0d4a6a115159 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1221,17 +1221,32 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 	struct stv *state = fe->demodulator_priv;
 	u8 i2crpt = state->i2crpt & ~0x86;
 
-	if (enable)
-		mutex_lock(&state->base->i2c_lock);
+	/*
+	 * mutex_lock note: Concurrent I2C gate bus accesses must be
+	 * prevented (STV0910 = dual demod on a single IC with a single I2C
+	 * gate/bus, and two tuners attached), similar to most (if not all)
+	 * other I2C host interfaces/busses.
+	 *
+	 * enable=1 (open I2C gate) will grab the lock
+	 * enable=0 (close I2C gate) releases the lock
+	 */
 
-	if (enable)
+	if (enable) {
+		mutex_lock(&state->base->i2c_lock);
 		i2crpt |= 0x80;
-	else
+	} else {
 		i2crpt |= 0x02;
+	}
 
 	if (write_reg(state, state->nr ? RSTV0910_P2_I2CRPT :
-		      RSTV0910_P1_I2CRPT, i2crpt) < 0)
+		      RSTV0910_P1_I2CRPT, i2crpt) < 0) {
+		/* don't hold the I2C bus lock on failure */
+		mutex_unlock(&state->base->i2c_lock);
+		dev_err(&state->base->i2c->dev,
+			"%s() write_reg failure (enable=%d)\n",
+			__func__, enable);
 		return -EIO;
+	}
 
 	state->i2crpt = i2crpt;
 
-- 
2.13.0
