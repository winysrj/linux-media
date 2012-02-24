Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49727 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab2BXPY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 10:24:57 -0500
Received: by mail-yx0-f174.google.com with SMTP id m8so1156267yen.19
        for <linux-media@vger.kernel.org>; Fri, 24 Feb 2012 07:24:57 -0800 (PST)
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: mchehab@infradead.org, gregkh@linuxfoundation.org
Cc: tomas.winkler@intel.com, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, dan.carpenter@oracle.com,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH 7/9] staging: easycap: Clean comment style in easycap_usb_disconnect()
Date: Fri, 24 Feb 2012 12:24:20 -0300
Message-Id: <1330097062-31663-7-git-send-email-elezegarcia@gmail.com>
In-Reply-To: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
References: <1330097062-31663-1-git-send-email-elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/staging/media/easycap/easycap_main.c |   64 ++++++++++----------------
 1 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/media/easycap/easycap_main.c b/drivers/staging/media/easycap/easycap_main.c
index 6e1734d..de53ed8 100644
--- a/drivers/staging/media/easycap/easycap_main.c
+++ b/drivers/staging/media/easycap/easycap_main.c
@@ -3973,15 +3973,13 @@ static int easycap_usb_probe(struct usb_interface *intf,
 	SAM("ends successfully for interface %i\n", bInterfaceNumber);
 	return 0;
 }
-/*****************************************************************************/
-/*---------------------------------------------------------------------------*/
+
 /*
- *  WHEN THIS FUNCTION IS CALLED THE EasyCAP HAS ALREADY BEEN PHYSICALLY
- *  UNPLUGGED.  HENCE peasycap->pusb_device IS NO LONGER VALID.
- *
- *  THIS FUNCTION AFFECTS ALSA.  BEWARE.
+ * When this function is called the device has already been
+ * physically unplugged.
+ * Hence, peasycap->pusb_device is no longer valid.
+ * This function affects alsa.
  */
-/*---------------------------------------------------------------------------*/
 static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 {
 	struct usb_host_interface *pusb_host_interface;
@@ -4006,6 +4004,7 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 	minor = pusb_interface->minor;
 	JOT(4, "intf[%i]: minor=%i\n", bInterfaceNumber, minor);
 
+	/* There is nothing to do for Interface Number 1 */
 	if (1 == bInterfaceNumber)
 		return;
 
@@ -4014,11 +4013,8 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 		SAY("ERROR: peasycap is NULL\n");
 		return;
 	}
-/*---------------------------------------------------------------------------*/
-/*
- *  IF THE WAIT QUEUES ARE NOT CLEARED A DEADLOCK IS POSSIBLE.  BEWARE.
-*/
-/*---------------------------------------------------------------------------*/
+
+	/* If the waitqueues are not cleared a deadlock is possible */
 	peasycap->video_eof = 1;
 	peasycap->audio_eof = 1;
 	wake_up_interruptible(&(peasycap->wq_video));
@@ -4034,15 +4030,14 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 	default:
 		break;
 	}
-/*--------------------------------------------------------------------------*/
-/*
- *  DEREGISTER
- *
- *  THIS PROCEDURE WILL BLOCK UNTIL easycap_poll(), VIDEO IOCTL AND AUDIO
- *  IOCTL ARE ALL UNLOCKED.  IF THIS IS NOT DONE AN Oops CAN OCCUR WHEN
- *  AN EasyCAP IS UNPLUGGED WHILE THE URBS ARE RUNNING.  BEWARE.
- */
-/*--------------------------------------------------------------------------*/
+
+	/*
+	 * Deregister
+	 * This procedure will block until easycap_poll(),
+	 * video and audio ioctl are all unlocked.
+	 * If this is not done an oops can occur when an easycap
+	 * is unplugged while the urbs are running.
+	 */
 	kd = easycap_isdongle(peasycap);
 	switch (bInterfaceNumber) {
 	case 0: {
@@ -4059,7 +4054,6 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 		} else {
 			SAY("ERROR: %i=kd is bad: cannot lock dongle\n", kd);
 		}
-/*---------------------------------------------------------------------------*/
 		if (!peasycap->v4l2_device.name[0]) {
 			SAM("ERROR: peasycap->v4l2_device.name is empty\n");
 			if (0 <= kd && DONGLE_MANY > kd)
@@ -4075,7 +4069,6 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 		JOM(4, "intf[%i]: video_unregister_device() minor=%i\n",
 				bInterfaceNumber, minor);
 		peasycap->registered_video--;
-/*^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/
 
 		if (0 <= kd && DONGLE_MANY > kd) {
 			mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
@@ -4111,12 +4104,12 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 	default:
 		break;
 	}
-/*---------------------------------------------------------------------------*/
-/*
- *  CALL easycap_delete() IF NO REMAINING REFERENCES TO peasycap
- *  (ALSO WHEN ALSA HAS BEEN IN USE)
- */
-/*---------------------------------------------------------------------------*/
+
+	/*
+	 * If no remaining references to peasycap,
+	 * call easycap_delete.
+	 * (Also when alsa has been in use)
+	 */
 	if (!peasycap->kref.refcount.counter) {
 		SAM("ERROR: peasycap->kref.refcount.counter is zero "
 							"so cannot call kref_put()\n");
@@ -4151,17 +4144,11 @@ static void easycap_usb_disconnect(struct usb_interface *pusb_interface)
 		mutex_unlock(&easycapdc60_dongle[kd].mutex_video);
 		JOT(4, "unlocked dongle[%i].mutex_video\n", kd);
 	}
-/*---------------------------------------------------------------------------*/
 	JOM(4, "ends\n");
 	return;
 }
-/*****************************************************************************/
 
-/*---------------------------------------------------------------------------*/
-/*
- *  PARAMETERS APPLICABLE TO ENTIRE DRIVER, I.E. BOTH VIDEO AND AUDIO
- */
-/*---------------------------------------------------------------------------*/
+/* Devices supported by this driver */
 static struct usb_device_id easycap_usb_device_id_table[] = {
 	{USB_DEVICE(USB_EASYCAP_VENDOR_ID, USB_EASYCAP_PRODUCT_ID)},
 	{ }
@@ -4196,14 +4183,11 @@ static int __init easycap_module_init(void)
 
 	return rc;
 }
-/*****************************************************************************/
+
 static void __exit easycap_module_exit(void)
 {
 	usb_deregister(&easycap_usb_driver);
 }
-/*****************************************************************************/
 
 module_init(easycap_module_init);
 module_exit(easycap_module_exit);
-
-/*****************************************************************************/
-- 
1.7.3.4

