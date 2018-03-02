Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:35144 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbeCBTfB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Mar 2018 14:35:01 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 7/8] media: dvb-core: add helper functions for I2C binding
Date: Fri,  2 Mar 2018 16:34:48 -0300
Message-Id: <5d1d5793e64944e079e0607a76e522f96c3b3bcf.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1520018558.git.mchehab@s-opensource.com>
References: <cover.1520018558.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The dvb_attach()/dvb_detach() methods are ugly hacks designed
to keep using the I2C low-level API. The proper way is to
do I2C bus bindings instead.

Several modules were already converted to use it. Yet,
it is painful to use it, as lots of code need to be
duplicated.

Make it easier by providing two new helper functions:
	- dvb_module_probe()
	- dvb_module_release()

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-core/dvbdev.c | 48 ++++++++++++++++++++++++++++++
 include/media/dvbdev.h          | 65 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 60e9c2ba26be..a840133feacb 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -24,6 +24,7 @@
 #include <linux/string.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/device.h>
@@ -941,6 +942,53 @@ int dvb_usercopy(struct file *file,
 	return err;
 }
 
+#ifdef CONFIG_I2C
+struct i2c_client *dvb_module_probe(const char *module_name,
+				    const char *name,
+				    struct i2c_adapter *adap,
+				    unsigned char addr,
+				    void *platform_data)
+{
+	struct i2c_client *client;
+	struct i2c_board_info *board_info;
+
+	board_info = kzalloc(sizeof(*board_info), GFP_KERNEL);
+
+	if (name)
+		strlcpy(board_info->type, name, I2C_NAME_SIZE);
+	else
+		strlcpy(board_info->type, module_name, I2C_NAME_SIZE);
+
+	board_info->addr = addr;
+	board_info->platform_data = platform_data;
+	request_module(module_name);
+	client = i2c_new_device(adap, board_info);
+	if (client == NULL || client->dev.driver == NULL) {
+		kfree(board_info);
+		return NULL;
+	}
+
+	if (!try_module_get(client->dev.driver->owner)) {
+		i2c_unregister_device(client);
+		client = NULL;
+	}
+
+	kfree(board_info);
+	return client;
+}
+EXPORT_SYMBOL_GPL(dvb_module_probe);
+
+void dvb_module_release(struct i2c_client *client)
+{
+	if (!client)
+		return;
+
+	module_put(client->dev.driver->owner);
+	i2c_unregister_device(client);
+}
+EXPORT_SYMBOL_GPL(dvb_module_release);
+#endif
+
 static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct dvb_device *dvbdev = dev_get_drvdata(dev);
diff --git a/include/media/dvbdev.h b/include/media/dvbdev.h
index 554db879527f..2d2897508590 100644
--- a/include/media/dvbdev.h
+++ b/include/media/dvbdev.h
@@ -358,7 +358,61 @@ long dvb_generic_ioctl(struct file *file,
 int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 		 int (*func)(struct file *file, unsigned int cmd, void *arg));
 
-/** generic DVB attach function. */
+#ifdef CONFIG_I2C
+
+struct i2c_adapter;
+struct i2c_client;
+/**
+ * dvb_module_probe - helper routine to probe an I2C module
+ *
+ * @module_name:
+ *	Name of the I2C module to be probed
+ * @name:
+ *	Optional name for the I2C module. Used for debug purposes.
+ * 	If %NULL, defaults to @module_name.
+ * @adap:
+ *	pointer to &struct i2c_adapter that describes the I2C adapter where
+ *	the module will be bound.
+ * @addr:
+ *	I2C address of the adapter, in 7-bit notation.
+ * @platform_data:
+ *	Platform data to be passed to the I2C module probed.
+ *
+ * This function binds an I2C device into the DVB core. Should be used by
+ * all drivers that use I2C bus to control the hardware. A module bound
+ * with dvb_module_probe() should use dvb_module_release() to unbind.
+ *
+ * Return:
+ *	On success, return an &struct i2c_client, pointing the the bound
+ *	I2C device. %NULL otherwise.
+ *
+ * .. note::
+ *
+ *    In the past, DVB modules (mainly, frontends) were bound via dvb_attach()
+ *    macro, with does an ugly hack, using I2C low level functions. Such
+ *    usage is deprecated and will be removed soon. Instead, use this routine.
+ */
+struct i2c_client *dvb_module_probe(const char *module_name,
+				    const char *name,
+				    struct i2c_adapter *adap,
+				    unsigned char addr,
+				    void *platform_data);
+
+/**
+ * dvb_module_release - releases an I2C device allocated with
+ *	 dvb_module_probe().
+ *
+ * @client: pointer to &struct i2c_client with the I2C client to be released.
+ *	    can be %NULL.
+ *
+ * This function should be used to free all resources reserved by
+ * dvb_module_probe() and unbinding the I2C hardware.
+ */
+void dvb_module_release(struct i2c_client *client);
+
+#endif /* CONFIG_I2C */
+
+/* Legacy generic DVB attach function. */
 #ifdef CONFIG_MEDIA_ATTACH
 
 /**
@@ -371,6 +425,13 @@ int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
  * the @FUNCTION function there, with @ARGS.
  * As it increments symbol usage cont, at unregister, dvb_detach()
  * should be called.
+ *
+ * .. note::
+ *
+ *    In the past, DVB modules (mainly, frontends) were bound via dvb_attach()
+ *    macro, with does an ugly hack, using I2C low level functions. Such
+ *    usage is deprecated and will be removed soon. Instead, you should use
+ *    dvb_module_probe().
  */
 #define dvb_attach(FUNCTION, ARGS...) ({ \
 	void *__r = NULL; \
@@ -402,6 +463,6 @@ int dvb_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
 
 #define dvb_detach(FUNC)	{}
 
-#endif
+#endif	/* CONFIG_MEDIA_ATTACH */
 
 #endif /* #ifndef _DVBDEV_H_ */
-- 
2.14.3
