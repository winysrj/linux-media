Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40016 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760039Ab3LHWb4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 Dec 2013 17:31:56 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH REVIEW 18/18] m88ds3103: fix possible i2c deadlock
Date: Mon,  9 Dec 2013 00:31:35 +0200
Message-Id: <1386541895-8634-19-git-send-email-crope@iki.fi>
In-Reply-To: <1386541895-8634-1-git-send-email-crope@iki.fi>
References: <1386541895-8634-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adapter is locked by I2C core already. Use unlocked i2c_transfer()
version __i2c_transfer() to avoid deadlock.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/m88ds3103.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index 76bd85a..b5503ed 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1159,7 +1159,7 @@ static int m88ds3103_select(struct i2c_adapter *adap, void *mux_priv, u32 chan)
 	mutex_lock(&priv->i2c_mutex);
 
 	/* open tuner I2C repeater for 1 xfer, closes automatically */
-	ret = i2c_transfer(priv->i2c, gate_open_msg, 1);
+	ret = __i2c_transfer(priv->i2c, gate_open_msg, 1);
 	if (ret != 1) {
 		dev_warn(&priv->i2c->dev, "%s: i2c wr failed=%d\n",
 				KBUILD_MODNAME, ret);
-- 
1.8.4.2

