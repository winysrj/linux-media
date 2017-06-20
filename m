Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36543 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751487AbdFTT51 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Jun 2017 15:57:27 -0400
Received: by mail-wr0-f195.google.com with SMTP id 77so20148773wrb.3
        for <linux-media@vger.kernel.org>; Tue, 20 Jun 2017 12:57:27 -0700 (PDT)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org, aospan@netup.ru,
        serjk@netup.ru
Subject: [PATCH] [media] dvb-frontends/lnbh25: improve kernellog output
Date: Tue, 20 Jun 2017 21:57:24 +0200
Message-Id: <20170620195724.8271-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Use dev_dbg() in conjunction with the %*ph format macro to print the vmon
status debug, thus hiding continuous hexdumping from default log levels.
Also, change the attach success log line from error to info severity.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 drivers/media/dvb-frontends/lnbh25.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/lnbh25.c b/drivers/media/dvb-frontends/lnbh25.c
index ef3021e964be..cb486e879fdd 100644
--- a/drivers/media/dvb-frontends/lnbh25.c
+++ b/drivers/media/dvb-frontends/lnbh25.c
@@ -76,8 +76,8 @@ static int lnbh25_read_vmon(struct lnbh25_priv *priv)
 			return ret;
 		}
 	}
-	print_hex_dump_bytes("lnbh25_read_vmon: ",
-		DUMP_PREFIX_OFFSET, status, sizeof(status));
+	dev_dbg(&priv->i2c->dev, "%s(): %*ph\n",
+		__func__, (int) sizeof(status), status);
 	if ((status[0] & (LNBH25_STATUS_OFL | LNBH25_STATUS_VMON)) != 0) {
 		dev_err(&priv->i2c->dev,
 			"%s(): voltage in failure state, status reg 0x%x\n",
@@ -178,7 +178,7 @@ struct dvb_frontend *lnbh25_attach(struct dvb_frontend *fe,
 	fe->ops.release_sec = lnbh25_release;
 	fe->ops.set_voltage = lnbh25_set_voltage;
 
-	dev_err(&i2c->dev, "%s(): attached at I2C addr 0x%02x\n",
+	dev_info(&i2c->dev, "%s(): attached at I2C addr 0x%02x\n",
 		__func__, priv->i2c_address);
 	return fe;
 }
-- 
2.13.0
