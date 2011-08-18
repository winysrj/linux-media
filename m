Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ird.yahoo.com ([212.82.108.233]:43407 "HELO
	nm2.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751377Ab1HRRw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 13:52:29 -0400
Message-ID: <4E4D5157.2080406@yahoo.com>
Date: Thu, 18 Aug 2011 18:52:23 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: mchehab@redhat.com, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV 290e
Content-Type: multipart/mixed;
 boundary="------------060109060106030102030105"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060109060106030102030105
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Here's my latest patch for the em28xx / em28xx-dvb modules, which addresses the 
following problems:

a) Locking problem when unplugging and then replugging USB adapter.
b) Race conditions between adding/removing devices from the devlist, while 
simultaneously loading/unloading extension modules.
c) Resource leaks on error paths.
d) Preventing the DVB framework from trying to put the adapter into sleep mode 
when the adapter has been physically unplugged. (This results in occasional 
"-19" errors from I2C functions when disconnecting.)
e) Use atomic bit operations to manage "device in use" slots, and enforce upper 
limit of EM28XX_MAXBOARDS slots.

BTW, was there a reason why the em28xx-dvb module doesn't use dvb-usb?

Any review comments welcome,

Cheers,
Chris


--------------060109060106030102030105
Content-Type: text/x-patch;
 name="EM28xx-DVB-5.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-DVB-5.diff"

--- linux-3.0/drivers/media/dvb/frontends/cxd2820r_core.c.orig	2011-08-18 16:56:02.000000000 +0100
+++ linux-3.0/drivers/media/dvb/frontends/cxd2820r_core.c	2011-08-18 16:56:08.000000000 +0100
@@ -778,7 +778,7 @@
 }
 EXPORT_SYMBOL(cxd2820r_get_tuner_i2c_adapter);
 
-static struct dvb_frontend_ops cxd2820r_ops[2];
+static const struct dvb_frontend_ops cxd2820r_ops[2];
 
 struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 	struct i2c_adapter *i2c, struct dvb_frontend *fe)
@@ -844,7 +844,7 @@
 }
 EXPORT_SYMBOL(cxd2820r_attach);
 
-static struct dvb_frontend_ops cxd2820r_ops[2] = {
+static const struct dvb_frontend_ops cxd2820r_ops[2] = {
 	{
 		/* DVB-T/T2 */
 		.info = {
--- linux-3.0/drivers/media/common/tuners/tda18271-fe.c.orig	2011-08-18 16:55:53.000000000 +0100
+++ linux-3.0/drivers/media/common/tuners/tda18271-fe.c	2011-08-18 16:56:08.000000000 +0100
@@ -1230,7 +1230,7 @@
 	return 0;
 }
 
-static struct dvb_tuner_ops tda18271_tuner_ops = {
+static const struct dvb_tuner_ops tda18271_tuner_ops = {
 	.info = {
 		.name = "NXP TDA18271HD",
 		.frequency_min  =  45000000,
--- linux-3.0/drivers/media/video/em28xx/em28xx-video.c.orig	2011-08-18 17:20:10.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-video.c	2011-08-18 17:20:33.000000000 +0100
@@ -2202,6 +2202,7 @@
 		   free the remaining resources */
 		if (dev->state & DEV_DISCONNECTED) {
 			em28xx_release_resources(dev);
+			kfree(dev->alt_max_pkt_size);
 			kfree(dev);
 			return 0;
 		}
--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-17 08:52:19.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-18 16:56:08.000000000 +0100
@@ -60,7 +60,7 @@
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card,     "card type");
 
-/* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS */
+/* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
 static unsigned long em28xx_devused;
 
 struct em28xx_hash_table {
@@ -2738,9 +2738,9 @@
 #endif /* CONFIG_MODULES */
 
 /*
- * em28xx_realease_resources()
+ * em28xx_release_resources()
  * unregisters the v4l2,i2c and usb devices
- * called when the device gets disconected or at module unload
+ * called when the device gets disconnected or at module unload
 */
 void em28xx_release_resources(struct em28xx *dev)
 {
@@ -2754,8 +2754,6 @@
 
 	em28xx_release_analog_resources(dev);
 
-	em28xx_remove_from_devlist(dev);
-
 	em28xx_i2c_unregister(dev);
 
 	v4l2_device_unregister(&dev->v4l2_dev);
@@ -2763,7 +2761,7 @@
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
-	em28xx_devused &= ~(1 << dev->devno);
+	clear_bit(dev->devno, &em28xx_devused);
 };
 
 /*
@@ -2776,7 +2774,6 @@
 {
 	struct em28xx *dev = *devhandle;
 	int retval;
-	int errCode;
 
 	dev->udev = udev;
 	mutex_init(&dev->ctrl_urb_lock);
@@ -2872,12 +2869,11 @@
 	}
 
 	/* register i2c bus */
-	errCode = em28xx_i2c_register(dev);
-	if (errCode < 0) {
-		v4l2_device_unregister(&dev->v4l2_dev);
+	retval = em28xx_i2c_register(dev);
+	if (retval < 0) {
 		em28xx_errdev("%s: em28xx_i2c_register - errCode [%d]!\n",
-			__func__, errCode);
-		return errCode;
+			__func__, retval);
+		goto fail_reg_i2c;
 	}
 
 	/*
@@ -2891,11 +2887,11 @@
 	em28xx_card_setup(dev);
 
 	/* Configure audio */
-	errCode = em28xx_audio_setup(dev);
-	if (errCode < 0) {
-		v4l2_device_unregister(&dev->v4l2_dev);
+	retval = em28xx_audio_setup(dev);
+	if (retval < 0) {
 		em28xx_errdev("%s: Error while setting audio - errCode [%d]!\n",
-			__func__, errCode);
+			__func__, retval);
+		goto fail_setup_audio;
 	}
 
 	/* wake i2c devices */
@@ -2909,31 +2905,28 @@
 
 	if (dev->board.has_msp34xx) {
 		/* Send a reset to other chips via gpio */
-		errCode = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
-		if (errCode < 0) {
-			em28xx_errdev("%s: em28xx_write_regs_req - "
+		retval = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xf7);
+		if (retval < 0) {
+			em28xx_errdev("%s: em28xx_write_reg - "
 				      "msp34xx(1) failed! errCode [%d]\n",
-				      __func__, errCode);
-			return errCode;
+				      __func__, retval);
+			goto fail_write_reg;
 		}
 		msleep(3);
 
-		errCode = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
-		if (errCode < 0) {
-			em28xx_errdev("%s: em28xx_write_regs_req - "
+		retval = em28xx_write_reg(dev, EM28XX_R08_GPIO, 0xff);
+		if (retval < 0) {
+			em28xx_errdev("%s: em28xx_write_reg - "
 				      "msp34xx(2) failed! errCode [%d]\n",
-				      __func__, errCode);
-			return errCode;
+				      __func__, retval);
+			goto fail_write_reg;
 		}
 		msleep(3);
 	}
 
-	em28xx_add_into_devlist(dev);
-
 	retval = em28xx_register_analog_devices(dev);
 	if (retval < 0) {
-		em28xx_release_resources(dev);
-		goto fail_reg_devices;
+		goto fail_reg_analog_devices;
 	}
 
 	em28xx_init_extension(dev);
@@ -2943,7 +2936,14 @@
 
 	return 0;
 
-fail_reg_devices:
+fail_setup_audio:
+fail_write_reg:
+fail_reg_analog_devices:
+	em28xx_i2c_unregister(dev);
+
+fail_reg_i2c:
+	v4l2_device_unregister(&dev->v4l2_dev);
+
 	return retval;
 }
 
@@ -2967,8 +2967,14 @@
 	ifnum = interface->altsetting[0].desc.bInterfaceNumber;
 
 	/* Check to see next free device and mark as used */
-	nr = find_first_zero_bit(&em28xx_devused, EM28XX_MAXBOARDS);
-	em28xx_devused |= 1<<nr;
+	do {
+		nr = find_first_zero_bit(&em28xx_devused, EM28XX_MAXBOARDS);
+		if (nr >= EM28XX_MAXBOARDS) {
+			/* No free device slots */
+			retval = -ENODEV;
+			goto err_no_slot;
+		}
+	} while (test_and_set_bit(nr, &em28xx_devused));
 
 	/* Don't register audio interfaces */
 	if (interface->altsetting[0].desc.bInterfaceClass == USB_CLASS_AUDIO) {
@@ -2979,7 +2985,6 @@
 			ifnum,
 			interface->altsetting[0].desc.bInterfaceClass);
 
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
@@ -3013,7 +3018,6 @@
 			em28xx_err(DRIVER_NAME " This is an anciliary "
 				"interface not used by the driver\n");
 
-			em28xx_devused &= ~(1<<nr);
 			retval = -ENODEV;
 			goto err;
 		}
@@ -3063,7 +3067,6 @@
 		printk(DRIVER_NAME ": Device initialization failed.\n");
 		printk(DRIVER_NAME ": Device must be connected to a high-speed"
 		       " USB 2.0 port.\n");
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
@@ -3071,7 +3074,6 @@
 	if (nr >= EM28XX_MAXBOARDS) {
 		printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
 				EM28XX_MAXBOARDS);
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENOMEM;
 		goto err;
 	}
@@ -3080,12 +3082,11 @@
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
 		em28xx_err(DRIVER_NAME ": out of memory!\n");
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENOMEM;
 		goto err;
 	}
 
-	snprintf(dev->name, 29, "em28xx #%d", nr);
+	snprintf(dev->name, sizeof(dev->name), "em28xx #%d", nr);
 	dev->devno = nr;
 	dev->model = id->driver_info;
 	dev->alt   = -1;
@@ -3107,7 +3108,6 @@
 
 	if (dev->alt_max_pkt_size == NULL) {
 		em28xx_errdev("out of memory!\n");
-		em28xx_devused &= ~(1<<nr);
 		kfree(dev);
 		retval = -ENOMEM;
 		goto err;
@@ -3127,7 +3127,7 @@
 	mutex_lock(&dev->lock);
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
-		em28xx_devused &= ~(1<<dev->devno);
+		kfree(dev->alt_max_pkt_size);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		goto err;
@@ -3146,12 +3146,16 @@
 	return 0;
 
 err:
+	clear_bit(nr, &em28xx_devused);
+
+err_no_slot:
+	usb_put_dev(udev);
 	return retval;
 }
 
 /*
  * em28xx_usb_disconnect()
- * called when the device gets diconencted
+ * called when the device gets disconnected
  * video device will be unregistered on v4l2_close in case it is still open
  */
 static void em28xx_usb_disconnect(struct usb_interface *interface)
--- linux-3.0/drivers/media/video/em28xx/em28xx-core.c.orig	2011-08-17 08:52:25.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-core.c	2011-08-18 16:56:08.000000000 +0100
@@ -1160,25 +1160,6 @@
 static DEFINE_MUTEX(em28xx_devlist_mutex);
 
 /*
- * em28xx_realease_resources()
- * unregisters the v4l2,i2c and usb devices
- * called when the device gets disconected or at module unload
-*/
-void em28xx_remove_from_devlist(struct em28xx *dev)
-{
-	mutex_lock(&em28xx_devlist_mutex);
-	list_del(&dev->devlist);
-	mutex_unlock(&em28xx_devlist_mutex);
-};
-
-void em28xx_add_into_devlist(struct em28xx *dev)
-{
-	mutex_lock(&em28xx_devlist_mutex);
-	list_add_tail(&dev->devlist, &em28xx_devlist);
-	mutex_unlock(&em28xx_devlist_mutex);
-};
-
-/*
  * Extension interface
  */
 
@@ -1193,8 +1174,8 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->init(dev);
 	}
-	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	return 0;
 }
 EXPORT_SYMBOL(em28xx_register_extension);
@@ -1207,36 +1188,34 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->fini(dev);
 	}
-	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 	list_del(&ops->next);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 
 void em28xx_init_extension(struct em28xx *dev)
 {
-	struct em28xx_ops *ops = NULL;
+	const struct em28xx_ops *ops = NULL;
 
 	mutex_lock(&em28xx_devlist_mutex);
-	if (!list_empty(&em28xx_extension_devlist)) {
-		list_for_each_entry(ops, &em28xx_extension_devlist, next) {
-			if (ops->init)
-				ops->init(dev);
-		}
+	list_add_tail(&dev->devlist, &em28xx_devlist);
+	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
+		if (ops->init)
+			ops->init(dev);
 	}
 	mutex_unlock(&em28xx_devlist_mutex);
 }
 
 void em28xx_close_extension(struct em28xx *dev)
 {
-	struct em28xx_ops *ops = NULL;
+	const struct em28xx_ops *ops = NULL;
 
 	mutex_lock(&em28xx_devlist_mutex);
-	if (!list_empty(&em28xx_extension_devlist)) {
-		list_for_each_entry(ops, &em28xx_extension_devlist, next) {
-			if (ops->fini)
-				ops->fini(dev);
-		}
+	list_for_each_entry(ops, &em28xx_extension_devlist, next) {
+		if (ops->fini)
+			ops->fini(dev);
 	}
+	list_del(&dev->devlist);
 	mutex_unlock(&em28xx_devlist_mutex);
 }
--- linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c.orig	2011-08-17 08:52:30.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c	2011-08-18 17:06:51.000000000 +0100
@@ -542,7 +542,6 @@
 	dev->dvb = dvb;
 	dvb->fe[0] = dvb->fe[1] = NULL;
 
-	mutex_lock(&dev->lock);
 	em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	/* init frontend */
 	switch (dev->model) {
@@ -711,7 +710,6 @@
 	em28xx_info("Successfully loaded em28xx-dvb\n");
 ret:
 	em28xx_set_mode(dev, EM28XX_SUSPEND);
-	mutex_unlock(&dev->lock);
 	return result;
 
 out_free:
@@ -720,6 +718,12 @@
 	goto ret;
 }
 
+static inline void prevent_sleep(struct dvb_frontend_ops *ops) {
+	ops->set_voltage = NULL;
+	ops->sleep = NULL;
+	ops->tuner_ops.sleep = NULL;
+}
+
 static int dvb_fini(struct em28xx *dev)
 {
 	if (!dev->board.has_dvb) {
@@ -728,8 +732,17 @@
 	}
 
 	if (dev->dvb) {
-		unregister_dvb(dev->dvb);
-		kfree(dev->dvb);
+		struct em28xx_dvb *dvb = dev->dvb;
+
+		if (dev->state & DEV_DISCONNECTED) {
+			/* We cannot tell the device to sleep
+			 * once it has been unplugged. */
+			prevent_sleep(&dvb->fe[0]->ops);
+			prevent_sleep(&dvb->fe[1]->ops);
+		}
+
+		unregister_dvb(dvb);
+		kfree(dvb);
 		dev->dvb = NULL;
 	}
 

--------------060109060106030102030105--
