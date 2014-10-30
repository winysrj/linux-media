Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34990 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161011AbaJ3UNB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:13:01 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v4 01/14] cx231xx: let i2c bus scanning use its own i2c_client
Date: Thu, 30 Oct 2014 21:12:22 +0100
Message-Id: <1414699955-5760-2-git-send-email-zzam@gentoo.org>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a preparation for deleting the otherwise useless i2c_clients
that are allocated for all the i2c master adapters.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/cx231xx/cx231xx-i2c.c | 17 +++++++++++------
 drivers/media/usb/cx231xx/cx231xx.h     |  2 +-
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 7c0f797..67a1391 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -480,22 +480,27 @@ static char *i2c_devs[128] = {
  * cx231xx_do_i2c_scan()
  * check i2c address range for devices
  */
-void cx231xx_do_i2c_scan(struct cx231xx *dev, struct i2c_client *c)
+void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 {
 	unsigned char buf;
 	int i, rc;
+	struct i2c_client client;
 
-	cx231xx_info(": Checking for I2C devices ..\n");
+	memset(&client, 0, sizeof(client));
+	client.adapter = &dev->i2c_bus[i2c_port].i2c_adap;
+
+	cx231xx_info(": Checking for I2C devices on port=%d ..\n", i2c_port);
 	for (i = 0; i < 128; i++) {
-		c->addr = i;
-		rc = i2c_master_recv(c, &buf, 0);
+		client.addr = i;
+		rc = i2c_master_recv(&client, &buf, 0);
 		if (rc < 0)
 			continue;
 		cx231xx_info("%s: i2c scan: found device @ 0x%x  [%s]\n",
 			     dev->name, i << 1,
 			     i2c_devs[i] ? i2c_devs[i] : "???");
 	}
-	cx231xx_info(": Completed Checking for I2C devices.\n");
+	cx231xx_info(": Completed Checking for I2C devices on port=%d.\n",
+		i2c_port);
 }
 
 /*
@@ -522,7 +527,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 
 	if (0 == bus->i2c_rc) {
 		if (i2c_scan)
-			cx231xx_do_i2c_scan(dev, &bus->i2c_client);
+			cx231xx_do_i2c_scan(dev, bus->nr);
 	} else
 		cx231xx_warn("%s: i2c bus %d register FAILED\n",
 			     dev->name, bus->nr);
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index aeb1bf4..5efc93e 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -751,7 +751,7 @@ int cx231xx_set_analog_freq(struct cx231xx *dev, u32 freq);
 int cx231xx_reset_analog_tuner(struct cx231xx *dev);
 
 /* Provided by cx231xx-i2c.c */
-void cx231xx_do_i2c_scan(struct cx231xx *dev, struct i2c_client *c);
+void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port);
 int cx231xx_i2c_register(struct cx231xx_i2c *bus);
 int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
 
-- 
2.1.2

