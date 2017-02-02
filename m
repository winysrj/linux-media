Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:62472 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751500AbdBBOxy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2017 09:53:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Peter Rosin <peda@axentia.se>,
        Wolfram Sang <wsa@the-dreams.de>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] [media] cx231xx-i2c: reduce stack size in bus scan
Date: Thu,  2 Feb 2017 15:53:06 +0100
Message-Id: <20170202145318.3803805-3-arnd@arndb.de>
In-Reply-To: <20170202145318.3803805-1-arnd@arndb.de>
References: <20170202145318.3803805-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx231xx_do_i2c_scan function needs a lot of stack because
it puts an i2c_client structure on it:

drivers/media/usb/cx231xx/cx231xx-i2c.c: In function 'cx231xx_do_i2c_scan':
drivers/media/usb/cx231xx/cx231xx-i2c.c:518:1: error: the frame size of 1248 bytes is larger than 1152 bytes [-Werror=frame-larger-than=]

This changes it to call i2c_transfer() directly instead, avoiding the
need for the structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 35e9acfe63d3..24e23a06d8c6 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -491,20 +491,24 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 {
 	unsigned char buf;
 	int i, rc;
-	struct i2c_client client;
+	struct i2c_adapter *adap;
+	struct i2c_msg msg = {
+		.flags = I2C_M_RD,
+		.len = 1,
+		.buf = &buf,
+	};
 
 	if (!i2c_scan)
 		return;
 
 	/* Don't generate I2C errors during scan */
 	dev->i2c_scan_running = true;
-
-	memset(&client, 0, sizeof(client));
-	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
+	adap = cx231xx_get_i2c_adap(dev, i2c_port);
 
 	for (i = 0; i < 128; i++) {
-		client.addr = i;
-		rc = i2c_master_recv(&client, &buf, 0);
+		msg.addr = i;
+		rc = i2c_transfer(adap, &msg, 1);
+
 		if (rc < 0)
 			continue;
 		dev_info(dev->dev,
-- 
2.9.0

