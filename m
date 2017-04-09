Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34066 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752427AbdDITie (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Apr 2017 15:38:34 -0400
Received: by mail-wr0-f195.google.com with SMTP id u18so18615244wrc.1
        for <linux-media@vger.kernel.org>; Sun, 09 Apr 2017 12:38:33 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: aospan@netup.ru, serjk@netup.ru, mchehab@kernel.org,
        linux-media@vger.kernel.org
Cc: rjkm@metzlerbros.de
Subject: [PATCH 02/19] [media] dvb-frontends/cxd2841er: do I2C reads in one go
Date: Sun,  9 Apr 2017 21:38:11 +0200
Message-Id: <20170409193828.18458-3-d.scheller.oss@gmail.com>
In-Reply-To: <20170409193828.18458-1-d.scheller.oss@gmail.com>
References: <20170409193828.18458-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Doing the I2C read operation with two calls to i2c_transfer() causes the
exclusive I2C bus lock of the underlying adapter to be released. While this
isn't an issue if only one demodulator is attached to the bus, having two
or even more causes troubles in that concurrent accesses to the different
demods will cause all kinds of issues due to wrong data being returned on
read operations (for example, the TS config register will be set wrong).
This changes the read_regs() function to do the operation in one go (by
calling i2c_transfer with the whole msg list instead of one by one) to not
loose the I2C bus lock, fixing all sorts of random runtime failures.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/cxd2841er.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
index 60d85ce..525d006 100644
--- a/drivers/media/dvb-frontends/cxd2841er.c
+++ b/drivers/media/dvb-frontends/cxd2841er.c
@@ -282,17 +282,8 @@ static int cxd2841er_read_regs(struct cxd2841er_priv *priv,
 		}
 	};
 
-	ret = i2c_transfer(priv->i2c, &msg[0], 1);
-	if (ret >= 0 && ret != 1)
-		ret = -EIO;
-	if (ret < 0) {
-		dev_warn(&priv->i2c->dev,
-			"%s: i2c rw failed=%d addr=%02x reg=%02x\n",
-			KBUILD_MODNAME, ret, i2c_addr, reg);
-		return ret;
-	}
-	ret = i2c_transfer(priv->i2c, &msg[1], 1);
-	if (ret >= 0 && ret != 1)
+	ret = i2c_transfer(priv->i2c, msg, 2);
+	if (ret >= 0 && ret != 2)
 		ret = -EIO;
 	if (ret < 0) {
 		dev_warn(&priv->i2c->dev,
-- 
2.10.2
