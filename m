Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55039 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933113AbcIEKcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:32:48 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@axentia.se>
Subject: [PATCH v2 08/12] [media] cx231xx-i2c: handle errors with cx231xx_get_i2c_adap()
Date: Mon,  5 Sep 2016 07:32:36 -0300
Message-Id: <21d53f2480ed561d8233b41b4bcf693503460019.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1473071468.git.mchehab@s-opensource.com>
References: <cover.1473071468.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx231xx_get_i2c_adap() function should return the I2C
adapter that will be used to talk with a device. It should never
be NULL, as otherwise the driver will try to dereference a
null pointer.

We might instead fix the callers, but if this condition
ever happens, it is really a driver bug, because i2c_port
should always be a value from enum CX231XX_I2C_MASTER_PORT.

Found when checking the code due to this bug:

[   39.769021] BUG: unable to handle kernel NULL pointer dereference at 0000000000000002
[   39.769105] IP: [<ffffffff81638393>] i2c_master_send+0x13/0x70

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 473cd3433fe5..3e7982ef180a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -608,7 +608,7 @@ struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
 	case I2C_1_MUX_3:
 		return dev->muxc->adapter[1];
 	default:
-		return NULL;
+		BUG();
 	}
 }
 EXPORT_SYMBOL_GPL(cx231xx_get_i2c_adap);
-- 
2.7.4


