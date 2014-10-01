Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34783 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaJAFUv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 01:20:51 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH V2 13/13] cx231xx: scan all four existing i2c busses instead of the 3 masters
Date: Wed,  1 Oct 2014 07:20:21 +0200
Message-Id: <1412140821-16285-14-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The scanning itself just fails (as before this series) but now the correct busses are scanned.

V2: Changed to symbolic names where muxed adapters can be seen directly.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 6 ++++++
 drivers/media/usb/cx231xx/cx231xx-i2c.c  | 8 ++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index c49022f..60dbbbb 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1303,6 +1303,12 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	cx231xx_i2c_mux_register(dev, 0);
 	cx231xx_i2c_mux_register(dev, 1);
 
+	/* scan the real bus segments */
+	cx231xx_do_i2c_scan(dev, I2C_0);
+	cx231xx_do_i2c_scan(dev, I2C_1_MUX_1);
+	cx231xx_do_i2c_scan(dev, I2C_2);
+	cx231xx_do_i2c_scan(dev, I2C_1_MUX_3);
+
 	/* init hardware */
 	/* Note : with out calling set power mode function,
 	afe can not be set up correctly */
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index bb82e6d..0df50d3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -492,6 +492,9 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	int i, rc;
 	struct i2c_client client;
 
+	if (!i2c_scan)
+		return;
+
 	memset(&client, 0, sizeof(client));
 	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
 
@@ -533,10 +536,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
 	i2c_add_adapter(&bus->i2c_adap);
 
-	if (0 == bus->i2c_rc) {
-		if (i2c_scan)
-			cx231xx_do_i2c_scan(dev, bus->nr);
-	} else
+	if (0 != bus->i2c_rc)
 		cx231xx_warn("%s: i2c bus %d register FAILED\n",
 			     dev->name, bus->nr);
 
-- 
2.1.1

