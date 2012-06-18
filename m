Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46347 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab2FRTYN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jun 2012 15:24:13 -0400
Received: by yenl2 with SMTP id l2so3568634yen.19
        for <linux-media@vger.kernel.org>; Mon, 18 Jun 2012 12:24:12 -0700 (PDT)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: <linux-media@vger.kernel.org>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 05/12] cx23885: Remove useless struct i2c_algo_bit_data
Date: Mon, 18 Jun 2012 16:23:38 -0300
Message-Id: <1340047425-32000-5-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
References: <1340047425-32000-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/cx23885/cx23885-i2c.c |    3 ---
 drivers/media/video/cx23885/cx23885.h     |    2 --
 drivers/media/video/saa7164/saa7164.h     |    1 -
 3 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index 7a93fc6..1404050 100644
--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -318,8 +318,6 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 
 	memcpy(&bus->i2c_adap, &cx23885_i2c_adap_template,
 	       sizeof(bus->i2c_adap));
-	memcpy(&bus->i2c_algo, &cx23885_i2c_algo_template,
-	       sizeof(bus->i2c_algo));
 	memcpy(&bus->i2c_client, &cx23885_i2c_client_template,
 	       sizeof(bus->i2c_client));
 
@@ -328,7 +326,6 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 	strlcpy(bus->i2c_adap.name, bus->dev->name,
 		sizeof(bus->i2c_adap.name));
 
-	bus->i2c_algo.data = bus;
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
 	bus->i2c_rc = i2c_add_adapter(&bus->i2c_adap);
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index d884784..3cf397f 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -21,7 +21,6 @@
 
 #include <linux/pci.h>
 #include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
 #include <linux/kdev_t.h>
 #include <linux/slab.h>
 
@@ -246,7 +245,6 @@ struct cx23885_i2c {
 
 	/* i2c i/o */
 	struct i2c_adapter         i2c_adap;
-	struct i2c_algo_bit_data   i2c_algo;
 	struct i2c_client          i2c_client;
 	u32                        i2c_rc;
 
diff --git a/drivers/media/video/saa7164/saa7164.h b/drivers/media/video/saa7164/saa7164.h
index fc1f854..35219b9 100644
--- a/drivers/media/video/saa7164/saa7164.h
+++ b/drivers/media/video/saa7164/saa7164.h
@@ -46,7 +46,6 @@
 
 #include <linux/pci.h>
 #include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
 #include <linux/kdev_t.h>
 #include <linux/mutex.h>
 #include <linux/crc32.h>
-- 
1.7.4.4

