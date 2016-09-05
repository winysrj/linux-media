Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933292AbcIEKcu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Terry Heo <terryheo@google.com>, Peter Rosin <peda@axentia.se>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH v2 09/12] [media] cx231xx: can't proceed if I2C bus register fails
Date: Mon,  5 Sep 2016 07:32:37 -0300
Message-Id: <4a6a0b77d5b33127677230d8184e3cae9e107820.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver should not ignore errors while registering the I2C
bus, as this device can't even minimally work without the buses,
as it uses those buses internally to talk with the several IP
blocks inside the chip.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 68b0df2814cf..03754c75454b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1309,15 +1309,29 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	dev->i2c_bus[2].i2c_reserve = 0;
 
 	/* register I2C buses */
-	cx231xx_i2c_register(&dev->i2c_bus[0]);
-	cx231xx_i2c_register(&dev->i2c_bus[1]);
-	cx231xx_i2c_register(&dev->i2c_bus[2]);
+	errCode = cx231xx_i2c_register(&dev->i2c_bus[0]);
+	if (errCode < 0)
+		return errCode;
+	errCode = cx231xx_i2c_register(&dev->i2c_bus[1]);
+	if (errCode < 0)
+		return errCode;
+	errCode = cx231xx_i2c_register(&dev->i2c_bus[2]);
+	if (errCode < 0)
+		return errCode;
 
 	errCode = cx231xx_i2c_mux_create(dev);
+	if (errCode < 0) {
+		dev_err(dev->dev,
+			"%s: Failed to create I2C mux\n", __func__);
+		return errCode;
+	}
+	errCode = cx231xx_i2c_mux_register(dev, 0);
+	if (errCode < 0)
+		return errCode;
+
+	errCode = cx231xx_i2c_mux_register(dev, 1);
 	if (errCode < 0)
 		return errCode;
-	cx231xx_i2c_mux_register(dev, 0);
-	cx231xx_i2c_mux_register(dev, 1);
 
 	/* scan the real bus segments in the order of physical port numbers */
 	cx231xx_do_i2c_scan(dev, I2C_0);
-- 
2.7.4


