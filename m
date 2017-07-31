Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db5eur01on0117.outbound.protection.outlook.com ([104.47.2.117]:27101
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752306AbdGaNjK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 09:39:10 -0400
From: Peter Rosin <peda@axentia.se>
To: linux-kernel@vger.kernel.org
Cc: Peter Rosin <peda@axentia.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: [PATCH 2/3] [media] cx231xx: drop return value of cx231xx_i2c_unregister
Date: Mon, 31 Jul 2017 15:38:51 +0200
Message-Id: <20170731133852.8013-3-peda@axentia.se>
In-Reply-To: <20170731133852.8013-1-peda@axentia.se>
References: <20170731133852.8013-1-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Noone cares anyway.

Signed-off-by: Peter Rosin <peda@axentia.se>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 3 +--
 drivers/media/usb/cx231xx/cx231xx.h     | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 3a0c45ffd40f..3e49517cb5e0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -551,10 +551,9 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
  * cx231xx_i2c_unregister()
  * unregister i2c_bus
  */
-int cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
+void cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
 {
 	i2c_del_adapter(&bus->i2c_adap);
-	return 0;
 }
 
 /*
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 27ee035f9f84..72d5937a087e 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -762,7 +762,7 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev);
 /* Provided by cx231xx-i2c.c */
 void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port);
 int cx231xx_i2c_register(struct cx231xx_i2c *bus);
-int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
+void cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
 int cx231xx_i2c_mux_create(struct cx231xx *dev);
 int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no);
 void cx231xx_i2c_mux_unregister(struct cx231xx *dev);
-- 
2.11.0
