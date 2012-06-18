Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38163 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2FRTYS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:18 -0400
Received: by mail-yw0-f46.google.com with SMTP id m54so4149641yhm.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:18 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 08/12] cx231xx: Remove useless struct i2c_algo_bit_data usage
Date: Mon, 18 Jun 2012 16:23:41 -0300
Message-Id: <1340047425-32000-8-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx231xx/cx231xx-i2c.c |    2 --
 drivers/media/video/cx231xx/cx231xx.h     |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-i2c.c b/drivers/media/video/cx231xx/cx231xx-i2c.c
index 8064119..f5f4844 100644
--- a/drivers/media/video/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/video/cx231xx/cx231xx-i2c.c
@@ -500,7 +500,6 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 	BUG_ON(!dev->cx231xx_send_usb_command);
 
 	memcpy(&bus->i2c_adap, &cx231xx_adap_template, sizeof(bus->i2c_adap));
-	memcpy(&bus->i2c_algo, &cx231xx_algo, sizeof(bus->i2c_algo));
 	memcpy(&bus->i2c_client, &cx231xx_client_template,
 	       sizeof(bus->i2c_client));
 
@@ -508,7 +507,6 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus)
 
 	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
 
-	bus->i2c_algo.data = bus;
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
 	bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index e174475..a89d020 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 #include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
 
@@ -481,7 +480,6 @@ struct cx231xx_i2c {
 
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap;
-	struct i2c_algo_bit_data i2c_algo;
 	struct i2c_client i2c_client;
 	u32 i2c_rc;
 
-- 
1.7.4.4

