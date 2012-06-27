Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64955 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab2F0QxT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jun 2012 12:53:19 -0400
Received: by gglu4 with SMTP id u4so1097650ggl.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2012 09:53:18 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>, stoth@kernellabs.com,
	dan.carpenter@oracle.com, palash.bandyopadhyay@conexant.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 4/9] cx25821: Remove useless struct i2c_algo_bit_data
Date: Wed, 27 Jun 2012 13:52:49 -0300
Message-Id: <1340815974-4120-4-git-send-email-elezegarcia@gmail.com>
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
 drivers/media/video/cx25821/cx25821-i2c.c |    3 ---
 drivers/media/video/cx25821/cx25821.h     |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/cx25821/cx25821-i2c.c b/drivers/media/video/cx25821/cx25821-i2c.c
index 6311180..0a44b4e 100644
--- a/drivers/media/video/cx25821/cx25821-i2c.c
+++ b/drivers/media/video/cx25821/cx25821-i2c.c
@@ -307,8 +307,6 @@ int cx25821_i2c_register(struct cx25821_i2c *bus)
 
 	memcpy(&bus->i2c_adap, &cx25821_i2c_adap_template,
 	       sizeof(bus->i2c_adap));
-	memcpy(&bus->i2c_algo, &cx25821_i2c_algo_template,
-	       sizeof(bus->i2c_algo));
 	memcpy(&bus->i2c_client, &cx25821_i2c_client_template,
 	       sizeof(bus->i2c_client));
 
@@ -316,7 +314,6 @@ int cx25821_i2c_register(struct cx25821_i2c *bus)
 
 	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
 
-	bus->i2c_algo.data = bus;
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
 	i2c_add_adapter(&bus->i2c_adap);
diff --git a/drivers/media/video/cx25821/cx25821.h b/drivers/media/video/cx25821/cx25821.h
index b9aa801..ed52501 100644
--- a/drivers/media/video/cx25821/cx25821.h
+++ b/drivers/media/video/cx25821/cx25821.h
@@ -26,7 +26,6 @@
 
 #include <linux/pci.h>
 #include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
@@ -213,7 +212,6 @@ struct cx25821_i2c {
 
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap;
-	struct i2c_algo_bit_data i2c_algo;
 	struct i2c_client i2c_client;
 	u32 i2c_rc;
 
-- 
1.7.4.4

