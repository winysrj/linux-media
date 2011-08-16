Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ukl.yahoo.com ([217.146.183.200]:29775 "HELO
	nm2.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751824Ab1HPXtq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 19:49:46 -0400
Received: from volcano.underworld (volcano.underworld [192.168.0.3])
	by wellhouse.underworld (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p7GNnfic032580
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 00:49:43 +0100
Message-ID: <4E4B0215.7080905@yahoo.com>
Date: Wed, 17 Aug 2011 00:49:41 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix locking problem, race conditions and resource leaks in
 em28xx, em28xx-dvb
Content-Type: multipart/mixed;
 boundary="------------070806080502030304080709"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070806080502030304080709
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Here's the latest draft of my patch (against 3.0). Any feedback greatly appreciated.

Cheers,
Chris


--------------070806080502030304080709
Content-Type: text/x-patch;
 name="EM28xx-DVB-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-DVB-2.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-core.c.orig	2011-08-16 19:49:58.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-core.c	2011-08-16 21:46:35.000000000 +0100
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
--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-16 21:28:25.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-16 23:10:06.000000000 +0100
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
 
@@ -2979,7 +2981,6 @@
 			ifnum,
 			interface->altsetting[0].desc.bInterfaceClass);
 
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
@@ -3013,7 +3014,6 @@
 			em28xx_err(DRIVER_NAME " This is an anciliary "
 				"interface not used by the driver\n");
 
-			em28xx_devused &= ~(1<<nr);
 			retval = -ENODEV;
 			goto err;
 		}
@@ -3063,7 +3063,6 @@
 		printk(DRIVER_NAME ": Device initialization failed.\n");
 		printk(DRIVER_NAME ": Device must be connected to a high-speed"
 		       " USB 2.0 port.\n");
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENODEV;
 		goto err;
 	}
@@ -3071,7 +3070,6 @@
 	if (nr >= EM28XX_MAXBOARDS) {
 		printk(DRIVER_NAME ": Supports only %i em28xx boards.\n",
 				EM28XX_MAXBOARDS);
-		em28xx_devused &= ~(1<<nr);
 		retval = -ENOMEM;
 		goto err;
 	}
@@ -3080,12 +3078,11 @@
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
@@ -3107,7 +3104,6 @@
 
 	if (dev->alt_max_pkt_size == NULL) {
 		em28xx_errdev("out of memory!\n");
-		em28xx_devused &= ~(1<<nr);
 		kfree(dev);
 		retval = -ENOMEM;
 		goto err;
@@ -3127,8 +3123,8 @@
 	mutex_lock(&dev->lock);
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
-		em28xx_devused &= ~(1<<dev->devno);
 		mutex_unlock(&dev->lock);
+		kfree(dev->alt_max_pkt_size);
 		kfree(dev);
 		goto err;
 	}
@@ -3146,6 +3142,8 @@
 	return 0;
 
 err:
+	em28xx_devused &= ~(1<<nr);
+	usb_put_dev(udev);
 	return retval;
 }
 
--- linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c.orig	2011-08-16 19:50:09.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c	2011-08-17 00:10:39.000000000 +0100
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

--------------070806080502030304080709--
