Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0117.outbound.protection.outlook.com ([104.47.2.117]:27101
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752214AbdGaNjJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 09:39:09 -0400
From: Peter Rosin <peda@axentia.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 1/3] [media] cx231xx: fail probe if i2c_add_adapter fails
Date: Mon, 31 Jul 2017 15:38:50 +0200
Message-Id: <20170731133852.8013-2-peda@axentia.se>
In-Reply-To: <20170731133852.8013-1-peda@axentia.se>
References: <20170731133852.8013-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While at it, change the type of the previously always-zero i2c_rc
member to int, matching the returned type from i2c_add_adapter.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 2 +-
 drivers/media/usb/cx231xx/cx231xx.h     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 8d95b1154e12..3a0c45ffd40f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -538,7 +538,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
-	i2c_add_adapter(&bus->i2c_adap);
+	bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
 
 	if (0 != bus->i2c_rc)
 		dev_warn(dev->dev,
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 986c64ba5b56..27ee035f9f84 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -476,7 +476,7 @@ struct cx231xx_i2c {
 
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap;
-	u32 i2c_rc;
+	int i2c_rc;
 
 	/* different settings for each bus */
 	u8 i2c_period;
-- 
2.11.0
