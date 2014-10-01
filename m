Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:34778 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbaJAFUt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Oct 2014 01:20:49 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com, crope@iki.fi
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH V2 11/13] cx231xx: register i2c mux adapters for master1 and use as I2C_1_MUX_1 and I2C_1_MUX_3
Date: Wed,  1 Oct 2014 07:20:19 +0200
Message-Id: <1412140821-16285-12-git-send-email-zzam@gentoo.org>
In-Reply-To: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
References: <1412140821-16285-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
---
 drivers/media/usb/cx231xx/Kconfig        |  1 +
 drivers/media/usb/cx231xx/cx231xx-core.c |  5 ++++
 drivers/media/usb/cx231xx/cx231xx-i2c.c  | 44 +++++++++++++++++++++++++++++++-
 drivers/media/usb/cx231xx/cx231xx.h      |  4 +++
 4 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/cx231xx/Kconfig b/drivers/media/usb/cx231xx/Kconfig
index 569aa29..173c0e2 100644
--- a/drivers/media/usb/cx231xx/Kconfig
+++ b/drivers/media/usb/cx231xx/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_CX231XX
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
+	select I2C_MUX
 
 	---help---
 	  This is a video4linux driver for Conexant 231xx USB based TV cards.
diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 180103e..c8a6d20 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1300,6 +1300,9 @@ int cx231xx_dev_init(struct cx231xx *dev)
 	cx231xx_i2c_register(&dev->i2c_bus[1]);
 	cx231xx_i2c_register(&dev->i2c_bus[2]);
 
+	cx231xx_i2c_mux_register(dev, 0);
+	cx231xx_i2c_mux_register(dev, 1);
+
 	/* init hardware */
 	/* Note : with out calling set power mode function,
 	afe can not be set up correctly */
@@ -1414,6 +1417,8 @@ EXPORT_SYMBOL_GPL(cx231xx_dev_init);
 void cx231xx_dev_uninit(struct cx231xx *dev)
 {
 	/* Un Initialize I2C bus */
+	cx231xx_i2c_mux_unregister(dev, 1);
+	cx231xx_i2c_mux_unregister(dev, 0);
 	cx231xx_i2c_unregister(&dev->i2c_bus[2]);
 	cx231xx_i2c_unregister(&dev->i2c_bus[1]);
 	cx231xx_i2c_unregister(&dev->i2c_bus[0]);
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 02ae498..bb82e6d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -24,6 +24,7 @@
 #include <linux/kernel.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
+#include <linux/i2c-mux.h>
 #include <media/v4l2-common.h>
 #include <media/tuner.h>
 
@@ -552,6 +553,46 @@ int cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
 	return 0;
 }
 
+/*
+ * cx231xx_i2c_mux_select()
+ * switch i2c master number 1 between port1 and port3
+ */
+static int cx231xx_i2c_mux_select(struct i2c_adapter *adap,
+			void *mux_priv, u32 chan_id)
+{
+	struct cx231xx *dev = mux_priv;
+
+	return cx231xx_enable_i2c_port_3(dev, chan_id);
+}
+
+int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
+{
+	struct i2c_adapter *i2c_parent = &dev->i2c_bus[1].i2c_adap;
+	/* what is the correct mux_dev? */
+	struct device *mux_dev = &dev->udev->dev;
+
+	dev->i2c_mux_adap[mux_no] = i2c_add_mux_adapter(i2c_parent,
+				mux_dev,
+				dev /* mux_priv */,
+				0,
+				mux_no /* chan_id */,
+				0 /* class */,
+				&cx231xx_i2c_mux_select,
+				NULL);
+
+	if (!dev->i2c_mux_adap[mux_no])
+		cx231xx_warn("%s: i2c mux %d register FAILED\n",
+			     dev->name, mux_no);
+
+	return 0;
+}
+
+void cx231xx_i2c_mux_unregister(struct cx231xx *dev, int mux_no)
+{
+	i2c_del_mux_adapter(dev->i2c_mux_adap[mux_no]);
+	dev->i2c_mux_adap[mux_no] = NULL;
+}
+
 struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
 {
 	switch (i2c_port) {
@@ -562,8 +603,9 @@ struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
 	case I2C_2:
 		return &dev->i2c_bus[2].i2c_adap;
 	case I2C_1_MUX_1:
+		return dev->i2c_mux_adap[0];
 	case I2C_1_MUX_3:
-		return &dev->i2c_bus[1].i2c_adap;
+		return dev->i2c_mux_adap[1];
 	default:
 		return NULL;
 	}
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 8a3c97b..c90aa44 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -628,6 +628,8 @@ struct cx231xx {
 
 	/* I2C adapters: Master 1 & 2 (External) & Master 3 (Internal only) */
 	struct cx231xx_i2c i2c_bus[3];
+	struct i2c_adapter *i2c_mux_adap[2];
+
 	unsigned int xc_fw_load_done:1;
 	unsigned int port_3_switch_enabled:1;
 	/* locks */
@@ -755,6 +757,8 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev);
 void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port);
 int cx231xx_i2c_register(struct cx231xx_i2c *bus);
 int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
+int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no);
+void cx231xx_i2c_mux_unregister(struct cx231xx *dev, int mux_no);
 struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port);
 
 /* Internal block control functions */
-- 
2.1.1

