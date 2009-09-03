Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217AbZICUBW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2009 16:01:22 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Janne Grunau <j@jannau.net>
Subject: [PATCH] hdpvr: fix i2c device registration on latest kernel
Date: Thu, 3 Sep 2009 15:59:40 -0400
Cc: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909031559.40207.jarod@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The i2c changes in 2.6.31 lead to the hdpvr driver oops'ing on load
at the moment. These changes remedy that, and after some related changes
in the lirc_zilog driver, IR is working again as well.

This patch is against http://hg.jannau.net/hdpvr/, which contains
multiple related patches also required for properly enabling the IR
part on the hdpvr. Tested on 2.6.30.5 and 2.6.31-rc8.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 hdpvr-core.c |    5 +----
 hdpvr-i2c.c  |   48 ++++++++++++++++++++++++++++++------------------
 hdpvr.h      |    2 +-
 3 files changed, 32 insertions(+), 23 deletions(-)

diff -r d7fa66230b73 linux/drivers/media/video/hdpvr/hdpvr-core.c
--- a/linux/drivers/media/video/hdpvr/hdpvr-core.c	Thu Sep 03 21:07:38 2009 +0200
+++ b/linux/drivers/media/video/hdpvr/hdpvr-core.c	Thu Sep 03 15:49:56 2009 -0400
@@ -415,10 +415,7 @@
 	/* deregister I2C adapter */
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	mutex_lock(&dev->i2c_mutex);
-	if (dev->i2c_adapter)
-		i2c_del_adapter(dev->i2c_adapter);
-	kfree(dev->i2c_adapter);
-	dev->i2c_adapter = NULL;
+	i2c_del_adapter(&dev->i2c_adapter);
 	mutex_unlock(&dev->i2c_mutex);
 #endif /* CONFIG_I2C */
 
diff -r d7fa66230b73 linux/drivers/media/video/hdpvr/hdpvr-i2c.c
--- a/linux/drivers/media/video/hdpvr/hdpvr-i2c.c	Thu Sep 03 21:07:38 2009 +0200
+++ b/linux/drivers/media/video/hdpvr/hdpvr-i2c.c	Thu Sep 03 15:49:56 2009 -0400
@@ -22,6 +22,9 @@
 #define REQTYPE_I2C_WRITE	0xb0
 #define REQTYPE_I2C_WRITE_STAT	0xd0
 
+#define HDPVR_HW_Z8F0811_IR_TX_I2C_ADDR	0x70
+#define HDPVR_HW_Z8F0811_IR_RX_I2C_ADDR	0x71
+
 static int hdpvr_i2c_read(struct hdpvr_device *dev, unsigned char addr,
 			  char *data, int len, int bus)
 {
@@ -115,6 +118,21 @@
 	.functionality = hdpvr_functionality,
 };
 
+static struct i2c_adapter hdpvr_i2c_adap_template = {
+	.name		= "Hauppauge HD PVR I2C",
+	.owner		= THIS_MODULE,
+	.id		= I2C_HW_B_HDPVR,
+	.algo		= &hdpvr_algo,
+	.class		= I2C_CLASS_TV_ANALOG,
+};
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
+static struct i2c_board_info hdpvr_i2c_board_info = {
+	I2C_BOARD_INFO("ir_tx_z8f0811_haup", HDPVR_HW_Z8F0811_IR_TX_I2C_ADDR),
+	I2C_BOARD_INFO("ir_rx_z8f0811_haup", HDPVR_HW_Z8F0811_IR_RX_I2C_ADDR),
+};
+#endif
+
 static int hdpvr_activate_ir(struct hdpvr_device *dev)
 {
 	char buffer[8];
@@ -136,31 +154,25 @@
 
 int hdpvr_register_i2c_adapter(struct hdpvr_device *dev)
 {
-	struct i2c_adapter *i2c_adap;
 	int retval = -ENOMEM;
 
-	i2c_adap = kzalloc(sizeof(struct i2c_adapter), GFP_KERNEL);
-	if (i2c_adap == NULL)
-		goto error;
-
 	hdpvr_activate_ir(dev);
 
-	strlcpy(i2c_adap->name, "Hauppauge HD PVR I2C",
-		sizeof(i2c_adap->name));
-	i2c_adap->algo  = &hdpvr_algo;
-	i2c_adap->class = I2C_CLASS_TV_ANALOG;
-	i2c_adap->id    = I2C_HW_B_HDPVR;
-	i2c_adap->owner = THIS_MODULE;
-	i2c_adap->dev.parent = &dev->udev->dev;
+	memcpy(&dev->i2c_adapter, &hdpvr_i2c_adap_template,
+	       sizeof(struct i2c_adapter));
 
-	i2c_set_adapdata(i2c_adap, dev);
+	dev->i2c_adapter.dev.parent = &dev->udev->dev;
 
-	retval = i2c_add_adapter(i2c_adap);
+	i2c_set_adapdata(&dev->i2c_adapter, dev);
 
-	if (!retval)
-		dev->i2c_adapter = i2c_adap;
-	else
-		kfree(i2c_adap);
+	retval = i2c_add_adapter(&dev->i2c_adapter);
+
+	if (retval)
+		goto error;
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
+	i2c_new_device(&dev->i2c_adapter, &hdpvr_i2c_board_info);
+#endif
 
 error:
 	return retval;
diff -r d7fa66230b73 linux/drivers/media/video/hdpvr/hdpvr.h
--- a/linux/drivers/media/video/hdpvr/hdpvr.h	Thu Sep 03 21:07:38 2009 +0200
+++ b/linux/drivers/media/video/hdpvr/hdpvr.h	Thu Sep 03 15:49:56 2009 -0400
@@ -101,7 +101,7 @@
 	struct work_struct	worker;
 
 	/* I2C adapter */
-	struct i2c_adapter	*i2c_adapter;
+	struct i2c_adapter	i2c_adapter;
 	/* I2C lock */
 	struct mutex		i2c_mutex;
 

-- 
Jarod Wilson
jarod@redhat.com
