Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.94]:20172
	"HELO nm1-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753184Ab1HQXC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 19:02:28 -0400
Message-ID: <4E4C487E.6090204@yahoo.com>
Date: Thu, 18 Aug 2011 00:02:22 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] Fix locking and resource problems for PCTV 290e (em28xx /
 em28xx-dvb)
References: <1313366188.5010.YahooMailClassic@web121715.mail.ne1.yahoo.com> <4E486216.90501@iki.fi>
In-Reply-To: <4E486216.90501@iki.fi>
Content-Type: multipart/mixed;
 boundary="------------040206080406060903050809"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040206080406060903050809
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This is my third draft at fixing the em28xx modules for the PCTV 290e DVB 
adapter. The highlights are:

- resolve the locking issue when replugging the USB adapter,
- remove race condition when initialising an adapter and simultaneously loading 
the em28xx-dvb module,
- more reliable releasing of resources on error paths,
- use atomic bit operations for em28xx_devused mask, and enforce hard limit of 
EM28XX_MAXBOARDS adapters.

The patch is against 3.0, but these particular files don't seem to have changed 
much by 3.1. Any review comments welcome.

Cheers,
Chris


--------------040206080406060903050809
Content-Type: text/x-patch;
 name="EM28xx-DVB-4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-DVB-4.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-core.c.orig	2011-08-17 08:52:25.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-core.c	2011-08-17 08:52:37.000000000 +0100
@@ -1160,10 +1160,9 @@
 static DEFINE_MUTEX(em28xx_devlist_mutex);
 
 /*
- * em28xx_realease_resources()
- * unregisters the v4l2,i2c and usb devices
- * called when the device gets disconected or at module unload
-*/
+ * em28xx_remove_from_devlist()
+ * Removes the device from the list of active devices.
+ */
 void em28xx_remove_from_devlist(struct em28xx *dev)
 {
 	mutex_lock(&em28xx_devlist_mutex);
@@ -1171,13 +1170,6 @@
 	mutex_unlock(&em28xx_devlist_mutex);
 };
 
-void em28xx_add_into_devlist(struct em28xx *dev)
-{
-	mutex_lock(&em28xx_devlist_mutex);
-	list_add_tail(&dev->devlist, &em28xx_devlist);
-	mutex_unlock(&em28xx_devlist_mutex);
-};
-
 /*
  * Extension interface
  */
@@ -1193,8 +1185,8 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->init(dev);
 	}
-	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	return 0;
 }
 EXPORT_SYMBOL(em28xx_register_extension);
@@ -1207,9 +1199,9 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->fini(dev);
 	}
-	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 	list_del(&ops->next);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 
@@ -1218,11 +1210,10 @@
 	struct em28xx_ops *ops = NULL;
 
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
--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-17 08:52:19.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-17 19:22:29.000000000 +0100
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
@@ -2763,7 +2763,7 @@
 	usb_put_dev(dev->udev);
 
 	/* Mark device as unused */
-	em28xx_devused &= ~(1 << dev->devno);
+	clear_bit(dev->devno, &em28xx_devused);
 };
 
 /*
@@ -2776,7 +2776,6 @@
 {
 	struct em28xx *dev = *devhandle;
 	int retval;
-	int errCode;
 
 	dev->udev = udev;
 	mutex_init(&dev->ctrl_urb_lock);
@@ -2872,12 +2871,11 @@
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
@@ -2891,11 +2889,11 @@
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
@@ -2909,31 +2907,28 @@
 
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
@@ -2943,7 +2938,14 @@
 
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
 
@@ -2967,8 +2969,14 @@
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
@@ -2979,7 +2987,6 @@
 			ifnum,
 			interface->altsetting[0].desc.bInterfaceClass);
 
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
@@ -3013,7 +3020,6 @@
 			em28xx_err(DRIVER_NAME " This is an anciliary "
 				"interface not used by the driver\n");
 
-			em28xx_devused &= ~(1<<nr);
 			retval = -ENODEV;
 			goto err;
 		}
@@ -3063,7 +3069,6 @@
 		printk(DRIVER_NAME ": Device initialization failed.\n");
 		printk(DRIVER_NAME ": Device must be connected to a high-speed"
 		       " USB 2.0 port.\n");
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
@@ -3071,7 +3076,6 @@
 	if (nr >= EM28XX_MAXBOARDS) {
 		printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
 				EM28XX_MAXBOARDS);
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENOMEM;
 		goto err;
 	}
@@ -3080,12 +3084,11 @@
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
@@ -3107,7 +3110,6 @@
 
 	if (dev->alt_max_pkt_size == NULL) {
 		em28xx_errdev("out of memory!\n");
-		em28xx_devused &= ~(1<<nr);
 		kfree(dev);
 		retval = -ENOMEM;
 		goto err;
@@ -3127,7 +3129,7 @@
 	mutex_lock(&dev->lock);
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
-		em28xx_devused &= ~(1<<dev->devno);
+		kfree(dev->alt_max_pkt_size);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		goto err;
@@ -3146,6 +3148,10 @@
 	return 0;
 
 err:
+	clear_bit(nr, &em28xx_devused);
+
+err_no_slot:
+	usb_put_dev(udev);
 	return retval;
 }
 
--- linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c.orig	2011-08-17 08:52:30.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c	2011-08-17 08:52:37.000000000 +0100
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

--------------040206080406060903050809--
