Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:59412 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2F0QxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:53:16 -0400
Received: by ghrr11 with SMTP id r11so1108076ghr.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:53:16 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	dan.carpenter@oracle.com, palash.bandyopadhyay@conexant.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 3/9] cx231xx: Remove useless struct i2c_algo_bit_data
Date: Wed, 27 Jun 2012 13:52:48 -0300
Message-Id: <1340815974-4120-3-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
References: <1340815974-4120-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The field 'struct i2c_algo_bit_data i2c_algo' is wrongly confused with
struct i2c_algorithm. Moreover, i2c_algo field is not used since
i2c is registered using i2c_add_adpater() and not i2c_bit_add_bus().
Therefore, it's safe to remove it.
Tested by compilation only.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx231xx/cx231xx-i2c.c |    2 --
 drivers/media/video/cx231xx/cx231xx.h     |    2 --
 2 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/cx231xx/cx231xx-i2c.c b/drivers/media/video/cx231xx/cx231xx-i2c.c
index 925f3a0..7c0ed1b 100644
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
 	i2c_add_adapter(&bus->i2c_adap);
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

