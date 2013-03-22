Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933792Ab3CVQUu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Mar 2013 12:20:50 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r2MGKnxP016604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Fri, 22 Mar 2013 12:20:49 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] em28xx: Only change I2C bus inside em28xx-i2c
Date: Fri, 22 Mar 2013 13:20:46 -0300
Message-Id: <1363969246-12908-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's currently a bug on em28xx-i2c that makes it write the
wrong values to register 06, that controlls the I2C bus speed
and bus.

Fix it to change only the I2C bus flag.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-i2c.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index de9b208..9e2fa41 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -284,6 +284,7 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	struct em28xx *dev = i2c_bus->dev;
 	unsigned bus = i2c_bus->bus;
 	int addr, rc, i, byte;
+	u8 reg;
 
 	rc = rt_mutex_trylock(&dev->i2c_bus_lock);
 	if (rc < 0)
@@ -292,10 +293,11 @@ static int em28xx_i2c_xfer(struct i2c_adapter *i2c_adap,
 	/* Switch I2C bus if needed */
 	if (bus != dev->cur_i2c_bus) {
 		if (bus == 1)
-			dev->cur_i2c_bus |= EM2874_I2C_SECONDARY_BUS_SELECT;
+			reg = EM2874_I2C_SECONDARY_BUS_SELECT;
 		else
-			dev->cur_i2c_bus &= ~EM2874_I2C_SECONDARY_BUS_SELECT;
-		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->cur_i2c_bus);
+			reg = 0;
+		em28xx_write_reg_bits(dev, EM28XX_R06_I2C_CLK, reg,
+				      EM2874_I2C_SECONDARY_BUS_SELECT);
 		dev->cur_i2c_bus = bus;
 	}
 
-- 
1.8.1.4

