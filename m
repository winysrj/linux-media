Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.229]:47283
	"HELO nm4-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754351Ab1HRWLO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 18:11:14 -0400
Message-ID: <4E4D8DFD.5060800@yahoo.com>
Date: Thu, 18 Aug 2011 23:11:09 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org, mchehab@redhat.com,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [PATCH] Latest version of em28xx / em28xx-dvb patch for PCTV
 290e
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com>
In-Reply-To: <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050002060205040306000508"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050002060205040306000508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Two more patches:

a) clean up resources more reliably if em28xx_init_dev() fails,
b) move two printk() statements outside the mutex lock

Cheers,
Chris

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------050002060205040306000508
Content-Type: text/x-patch;
 name="EM28xx-init-resources.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-init-resources.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-18 22:42:03.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-18 22:55:52.000000000 +0100
@@ -2776,7 +2776,6 @@
 {
 	struct em28xx *dev = *devhandle;
 	int retval;
-	int errCode;
 
 	dev->udev = udev;
 	mutex_init(&dev->ctrl_urb_lock);
@@ -2858,7 +2857,7 @@
 		/* Resets I2C speed */
 		em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, dev->board.i2c_speed);
 		if (retval < 0) {
-			em28xx_errdev("%s: em28xx_write_regs_req failed!"
+			em28xx_errdev("%s: em28xx_write_reg failed!"
 				      " retval [%d]\n",
 				      __func__, retval);
 			return retval;
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
 
--- linux-3.0/drivers/media/video/em28xx/em28xx-core.c.orig	2011-08-17 08:52:25.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-core.c	2011-08-18 22:51:59.000000000 +0100
@@ -1171,13 +1171,6 @@
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
@@ -1215,14 +1208,13 @@
 
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

--------------050002060205040306000508
Content-Type: text/x-patch;
 name="EM28xx-unlocked-printk.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-unlocked-printk.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-core.c.orig	2011-08-18 23:05:50.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-core.c	2011-08-18 23:07:02.000000000 +0100
@@ -1186,8 +1186,8 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->init(dev);
 	}
-	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	return 0;
 }
 EXPORT_SYMBOL(em28xx_register_extension);
@@ -1200,9 +1200,9 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->fini(dev);
 	}
-	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 	list_del(&ops->next);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 

--------------050002060205040306000508--
