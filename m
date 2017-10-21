Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54569 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751668AbdJUIgq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 21 Oct 2017 04:36:46 -0400
Received: by mail-wm0-f66.google.com with SMTP id r68so1590556wmr.3
        for <linux-media@vger.kernel.org>; Sat, 21 Oct 2017 01:36:45 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH] [media] dvb-frontends/stv0910: prevent consecutive mutex_unlock()'s
Date: Sat, 21 Oct 2017 10:36:41 +0200
Message-Id: <20171021083641.7226-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When calling gate_ctrl() with enable=0 if previously the mutex wasn't
locked (ie. on enable=1 failure and subdrivers not handling this properly,
or by otherwise badly behaving drivers), the i2c_lock could be unlocked
consecutively which isn't allowed. Prevent this by keeping track of the
lock state, and actually call mutex_unlock() only when certain the lock
is held.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-frontends/stv0910.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 73f6df0abbfe..36ef96ec64c1 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -80,6 +80,7 @@ struct stv_base {
 	u8                   adr;
 	struct i2c_adapter  *i2c;
 	struct mutex         i2c_lock; /* shared I2C access protect */
+	u8                   i2c_islocked; /* I2C lock state */
 	struct mutex         reg_lock; /* shared register write protect */
 	int                  count;
 
@@ -1233,6 +1234,7 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	if (enable) {
 		mutex_lock(&state->base->i2c_lock);
+		state->base->i2c_islocked = 1;
 		i2crpt |= 0x80;
 	} else {
 		i2crpt |= 0x02;
@@ -1240,8 +1242,15 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	if (write_reg(state, state->nr ? RSTV0910_P2_I2CRPT :
 		      RSTV0910_P1_I2CRPT, i2crpt) < 0) {
-		/* don't hold the I2C bus lock on failure */
-		mutex_unlock(&state->base->i2c_lock);
+		/*
+		 * don't hold the I2C bus lock on failure while preventing
+		 * consecutive and disallowed calls to mutex_unlock()
+		 */
+		if (state->base->i2c_islocked) {
+			state->base->i2c_islocked = 0;
+			mutex_unlock(&state->base->i2c_lock);
+		}
+
 		dev_err(&state->base->i2c->dev,
 			"%s() write_reg failure (enable=%d)\n",
 			__func__, enable);
@@ -1250,8 +1259,13 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	state->i2crpt = i2crpt;
 
-	if (!enable)
-		mutex_unlock(&state->base->i2c_lock);
+	if (!enable) {
+		if (state->base->i2c_islocked) {
+			state->base->i2c_islocked = 0;
+			mutex_unlock(&state->base->i2c_lock);
+		}
+	}
+
 	return 0;
 }
 
@@ -1795,6 +1809,7 @@ struct dvb_frontend *stv0910_attach(struct i2c_adapter *i2c,
 
 		mutex_init(&base->i2c_lock);
 		mutex_init(&base->reg_lock);
+		base->i2c_islocked = 0;
 		state->base = base;
 		if (probe(state) < 0) {
 			dev_info(&i2c->dev, "No demod found at adr %02X on %s\n",
-- 
2.13.6
