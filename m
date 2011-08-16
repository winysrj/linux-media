Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm1-vm0.bt.bullet.mail.ird.yahoo.com ([212.82.108.94]:41778
	"HELO nm1-vm0.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751270Ab1HPIzX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 04:55:23 -0400
Received: from volcano.underworld (volcano.underworld [192.168.0.3])
	by wellhouse.underworld (8.14.3/8.14.3/Debian-5+lenny1) with ESMTP id p7G8o1cp031143
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-media@vger.kernel.org>; Tue, 16 Aug 2011 09:50:03 +0100
Message-ID: <4E4A2F39.6090809@yahoo.com>
Date: Tue, 16 Aug 2011 09:50:01 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix locking problem between em28xx and em28xx-dvb modules
Content-Type: multipart/mixed;
 boundary="------------020104090104070107080301"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020104090104070107080301
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've thought about this patch a bit more overnight, and it occurred to me that 
while  em28xx_init_extension() now takes the device mutex followed by the device 
list mutex, my original fix would have had em28xx_register_extension() taking 
the device list mutex followed by the device mutex. And that sounds suspiciously 
like a potential deadlock to me. So I was wondering: does 
em28xx_register_extension() actually need to lock the device if the device list 
has already been locked?

I've also moved two printk()s outside the region where we hold the device list 
mutex, because locked bits should be as brief as possible and neither printk() 
does anything that needs the lock.

A new patch is attached, for review.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------020104090104070107080301
Content-Type: text/x-patch;
 name="EM28xx-DVB.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-DVB.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-core.c.orig	2011-08-16 09:15:46.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-core.c	2011-08-16 09:21:08.000000000 +0100
@@ -1193,8 +1193,8 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->init(dev);
 	}
-	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Initialized (%s) extension\n", ops->name);
 	return 0;
 }
 EXPORT_SYMBOL(em28xx_register_extension);
@@ -1207,9 +1207,9 @@
 	list_for_each_entry(dev, &em28xx_devlist, devlist) {
 		ops->fini(dev);
 	}
-	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 	list_del(&ops->next);
 	mutex_unlock(&em28xx_devlist_mutex);
+	printk(KERN_INFO "Em28xx: Removed (%s) extension\n", ops->name);
 }
 EXPORT_SYMBOL(em28xx_unregister_extension);
 
--- linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c.orig	2011-08-16 09:16:03.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-dvb.c	2011-08-16 09:17:06.000000000 +0100
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

--------------020104090104070107080301--
