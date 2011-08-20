Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2.bt.bullet.mail.ird.yahoo.com ([212.82.108.233]:27569 "HELO
	nm2.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753394Ab1HTLme (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 07:42:34 -0400
Message-ID: <4E4F9DA4.90701@yahoo.com>
Date: Sat, 20 Aug 2011 12:42:28 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 1/2] EM28xx - fix race on disconnect
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com>
In-Reply-To: <4E4DFA65.4090508@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060801070901080106070800"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060801070901080106070800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

*Sigh* I overlooked two patches in the original numbering...

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

Signed-of-by: Chris Rankin <ranki...@yahoo.com>


--------------060801070901080106070800
Content-Type: text/x-patch;
 name="EM28xx-race-on-disconnect.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-race-on-disconnect.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-19 00:23:17.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-19 00:32:40.000000000 +0100
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
@@ -3152,7 +3150,7 @@
 
 /*
  * em28xx_usb_disconnect()
- * called when the device gets diconencted
+ * called when the device gets disconnected
  * video device will be unregistered on v4l2_close in case it is still open
  */
 static void em28xx_usb_disconnect(struct usb_interface *interface)
--- linux-3.0/drivers/media/video/em28xx/em28xx-core.c.orig	2011-08-18 23:07:51.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-core.c	2011-08-19 00:27:00.000000000 +0100
@@ -1160,18 +1160,6 @@
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
 
@@ -1221,14 +1209,13 @@
 
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

--------------060801070901080106070800--
