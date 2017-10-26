Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:52756 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932407AbdJZShm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Oct 2017 14:37:42 -0400
Received: by mail-wr0-f193.google.com with SMTP id k62so4074317wrc.9
        for <linux-media@vger.kernel.org>; Thu, 26 Oct 2017 11:37:41 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at, rjkm@metzlerbros.de
Subject: [PATCH v2] [media] dvb-frontends/stv0910: prevent consecutive mutex_unlock()'s
Date: Thu, 26 Oct 2017 20:37:37 +0200
Message-Id: <20171026183737.10655-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

When calling gate_ctrl() with enable=0 if previously the mutex wasn't
locked (ie. on enable=1 failure and subdrivers not handling this properly,
or by otherwise badly behaving drivers), the i2c_lock could be unlocked
consecutively which isn't allowed. Prevent this by checking the lock
state, and actually call mutex_unlock() only when certain the lock
is actually held.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Tested-by: Jasmin Jessich <jasmin@anw.at>
Cc: Ralph Metzler <rjkm@metzlerbros.de>
---
Changes from v1 to v2:
 - use mutex_is_locked() instead of tracking the lock state in a separate
   variable
 - print message to KERN_DEBUG after a double unlock was prevented

 drivers/media/dvb-frontends/stv0910.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0910.c b/drivers/media/dvb-frontends/stv0910.c
index 73f6df0abbfe..5d0146782488 100644
--- a/drivers/media/dvb-frontends/stv0910.c
+++ b/drivers/media/dvb-frontends/stv0910.c
@@ -1240,8 +1240,17 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	if (write_reg(state, state->nr ? RSTV0910_P2_I2CRPT :
 		      RSTV0910_P1_I2CRPT, i2crpt) < 0) {
-		/* don't hold the I2C bus lock on failure */
-		mutex_unlock(&state->base->i2c_lock);
+		/*
+		 * don't hold the I2C bus lock on failure while preventing
+		 * consecutive and disallowed calls to mutex_unlock()
+		 */
+		if (mutex_is_locked(&state->base->i2c_lock))
+			mutex_unlock(&state->base->i2c_lock);
+		else
+			dev_dbg(&state->base->i2c->dev,
+				"%s(): prevented consecutive mutex_unlock\n",
+				__func__);
+
 		dev_err(&state->base->i2c->dev,
 			"%s() write_reg failure (enable=%d)\n",
 			__func__, enable);
@@ -1250,8 +1259,15 @@ static int gate_ctrl(struct dvb_frontend *fe, int enable)
 
 	state->i2crpt = i2crpt;
 
-	if (!enable)
-		mutex_unlock(&state->base->i2c_lock);
+	if (!enable) {
+		if (mutex_is_locked(&state->base->i2c_lock))
+			mutex_unlock(&state->base->i2c_lock);
+		else
+			dev_dbg(&state->base->i2c->dev,
+				"%s(): prevented consecutive mutex_unlock\n",
+				__func__);
+	}
+
 	return 0;
 }
 
-- 
2.13.6
