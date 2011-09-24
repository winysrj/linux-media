Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4.bt.bullet.mail.ird.yahoo.com ([212.82.108.235]:43996 "HELO
	nm4.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751659Ab1IXPCh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 11:02:37 -0400
Message-ID: <4E7DF108.40307@yahoo.com>
Date: Sat, 24 Sep 2011 16:02:32 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH 2/2] EM28xx - fix race on disconnect
Content-Type: multipart/mixed;
 boundary="------------000004070602030408030700"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000004070602030408030700
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This patch closes the race on the device and extension lists at USB disconnect 
time. Previously, the device was removed from the device list during 
em28xx_release_resources(), and then passed to the em28xx_close_extension() 
function so that all extensions could run their fini() operations. However, this 
left a (brief, theoretical, highly unlikely ;-)) window between these two calls 
during which a new module could call em28xx_register_extension(). The result 
would have been that the em28xx_usb_disconnect() function would also have passed 
the device to the new extension's fini() function, despite never having called 
the extension's init() function.

This patch also restores em28xx_close_extension()'s symmetry with 
em28xx_init_extension(), and establishes the property that every device in the 
device list must have been initialised for every extension in the extension list.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------000004070602030408030700
Content-Type: text/x-patch;
 name="EM28xx-race-on-disconnect-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-race-on-disconnect-2.diff"

--- linux/drivers/media/video/em28xx/em28xx-core.c.orig	2011-09-24 14:56:05.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-core.c	2011-09-24 15:01:23.000000000 +0100
@@ -1184,18 +1184,6 @@
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
-/*
  * Extension interface
  */
 
@@ -1245,14 +1233,13 @@
 
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
--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-09-24 15:19:28.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-24 15:19:33.000000000 +0100
@@ -2800,9 +2800,9 @@
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
@@ -2816,8 +2816,6 @@
 
 	em28xx_release_analog_resources(dev);
 
-	em28xx_remove_from_devlist(dev);
-
 	em28xx_i2c_unregister(dev);
 
 	v4l2_device_unregister(&dev->v4l2_dev);
@@ -3255,7 +3253,7 @@
 
 /*
  * em28xx_usb_disconnect()
- * called when the device gets diconencted
+ * called when the device gets disconnected
  * video device will be unregistered on v4l2_close in case it is still open
  */
 static void em28xx_usb_disconnect(struct usb_interface *interface)

--------------000004070602030408030700--
