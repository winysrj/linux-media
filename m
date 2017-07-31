Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0117.outbound.protection.outlook.com ([104.47.2.117]:27101
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752369AbdGaNjM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 09:39:12 -0400
From: Peter Rosin <peda@axentia.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 3/3] [media] cx231xx: only unregister successfully registered i2c adapters
Date: Mon, 31 Jul 2017 15:38:52 +0200
Message-Id: <20170731133852.8013-4-peda@axentia.se>
In-Reply-To: <20170731133852.8013-1-peda@axentia.se>
References: <20170731133852.8013-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This prevents potentially scary debug messages from the i2c core.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 3 +++
 drivers/media/usb/cx231xx/cx231xx-i2c.c  | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 46646ecd2dbc..f372ad3917a8 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1311,6 +1311,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	dev->i2c_bus[0].i2c_period = I2C_SPEED_100K;	/* 100 KHz */
 	dev->i2c_bus[0].i2c_nostop = 0;
 	dev->i2c_bus[0].i2c_reserve = 0;
+	dev->i2c_bus[0].i2c_rc = -ENODEV;
 
 	/* External Master 2 Bus */
 	dev->i2c_bus[1].nr = 1;
@@ -1318,6 +1319,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	dev->i2c_bus[1].i2c_period = I2C_SPEED_100K;	/* 100 KHz */
 	dev->i2c_bus[1].i2c_nostop = 0;
 	dev->i2c_bus[1].i2c_reserve = 0;
+	dev->i2c_bus[1].i2c_rc = -ENODEV;
 
 	/* Internal Master 3 Bus */
 	dev->i2c_bus[2].nr = 2;
@@ -1325,6 +1327,7 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	dev->i2c_bus[2].i2c_period = I2C_SPEED_100K;	/* 100kHz */
 	dev->i2c_bus[2].i2c_nostop = 0;
 	dev->i2c_bus[2].i2c_reserve = 0;
+	dev->i2c_bus[2].i2c_rc = -ENODEV;
 
 	/* register I2C buses */
 	errCode = cx231xx_i2c_register(&dev->i2c_bus[0]);
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 3e49517cb5e0..8ce6b815d16d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -553,7 +553,8 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
  */
 void cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
 {
-	i2c_del_adapter(&bus->i2c_adap);
+	if (!bus->i2c_rc)
+		i2c_del_adapter(&bus->i2c_adap);
 }
 
 /*
-- 
2.11.0
