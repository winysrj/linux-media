Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:34448 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaAGE3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jan 2014 23:29:55 -0500
Received: by mail-pb0-f49.google.com with SMTP id jt11so19141152pbb.8
        for <linux-media@vger.kernel.org>; Mon, 06 Jan 2014 20:29:55 -0800 (PST)
From: Tim Mester <ttmesterr@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Tim Mester <tmester@ieee.org>
Subject: [PATCH 2/3] au0828: Add option to preallocate digital transfer buffers
Date: Mon,  6 Jan 2014 21:29:25 -0700
Message-Id: <1389068966-14594-2-git-send-email-tmester@ieee.org>
In-Reply-To: <1389068966-14594-1-git-send-email-tmester@ieee.org>
References: <1389068966-14594-1-git-send-email-tmester@ieee.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added command line parameter preallocate_big_buffers so that the digital
transfer buffers can be allocated when the driver is registered. They
do not have to be allocated every time a feed is started.

Signed-off-by: Tim Mester <tmester@ieee.org>
---
 linux/drivers/media/usb/au0828/au0828-core.c | 13 +++++---
 linux/drivers/media/usb/au0828/au0828-dvb.c  | 46 ++++++++++++++++++++++++++--
 linux/drivers/media/usb/au0828/au0828.h      |  4 +++
 3 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/linux/drivers/media/usb/au0828/au0828-core.c b/linux/drivers/media/usb/au0828/au0828-core.c
index bd9d19a..ab45a6f 100644
--- a/linux/drivers/media/usb/au0828/au0828-core.c
+++ b/linux/drivers/media/usb/au0828/au0828-core.c
@@ -173,9 +173,8 @@ static int au0828_usb_probe(struct usb_interface *interface,
 	const struct usb_device_id *id)
 {
 	int ifnum;
-#ifdef CONFIG_VIDEO_AU0828_V4L2
-	int retval;
-#endif
+	int retval = 0;
+
 	struct au0828_dev *dev;
 	struct usb_device *usbdev = interface_to_usbdev(interface);
 
@@ -257,7 +256,11 @@ static int au0828_usb_probe(struct usb_interface *interface,
 #endif
 
 	/* Digital TV */
-	au0828_dvb_register(dev);
+	retval = au0828_dvb_register(dev);
+	if (retval)
+		pr_err("%s() au0282_dev_register failed\n",
+		       __func__);
+
 
 	/* Store the pointer to the au0828_dev so it can be accessed in
 	   au0828_usb_disconnect */
@@ -268,7 +271,7 @@ static int au0828_usb_probe(struct usb_interface *interface,
 
 	mutex_unlock(&dev->lock);
 
-	return 0;
+	return retval;
 }
 
 static struct usb_driver au0828_usb_driver = {
diff --git a/linux/drivers/media/usb/au0828/au0828-dvb.c b/linux/drivers/media/usb/au0828/au0828-dvb.c
index 2312381..1673c88 100644
--- a/linux/drivers/media/usb/au0828/au0828-dvb.c
+++ b/linux/drivers/media/usb/au0828/au0828-dvb.c
@@ -33,6 +33,10 @@
 #include "mxl5007t.h"
 #include "tda18271.h"
 
+int preallocate_big_buffers;
+module_param_named(preallocate_big_buffers, preallocate_big_buffers, int, 0644);
+MODULE_PARM_DESC(preallocate_big_buffers, "Preallocate the larger transfer buffers at module load time");
+
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 #define _AU0828_BULKPIPE 0x83
@@ -155,7 +159,9 @@ static int stop_urb_transfer(struct au0828_dev *dev)
 	for (i = 0; i < URB_COUNT; i++) {
 		if (dev->urbs[i]) {
 			usb_kill_urb(dev->urbs[i]);
-			kfree(dev->urbs[i]->transfer_buffer);
+			if (!preallocate_big_buffers)
+				kfree(dev->urbs[i]->transfer_buffer);
+
 			usb_free_urb(dev->urbs[i]);
 		}
 	}
@@ -183,7 +189,12 @@ static int start_urb_transfer(struct au0828_dev *dev)
 
 		purb = dev->urbs[i];
 
-		purb->transfer_buffer = kzalloc(URB_BUFSIZE, GFP_KERNEL);
+		if (preallocate_big_buffers)
+			purb->transfer_buffer = dev->dig_transfer_buffer[i];
+		else
+			purb->transfer_buffer = kzalloc(URB_BUFSIZE,
+					GFP_KERNEL);
+
 		if (!purb->transfer_buffer) {
 			usb_free_urb(purb);
 			dev->urbs[i] = NULL;
@@ -333,6 +344,22 @@ static int dvb_register(struct au0828_dev *dev)
 
 	dprintk(1, "%s()\n", __func__);
 
+	if (preallocate_big_buffers) {
+		int i;
+		for (i = 0; i < URB_COUNT; i++) {
+			dev->dig_transfer_buffer[i] = kzalloc(URB_BUFSIZE,
+					GFP_KERNEL);
+
+			if (!dev->dig_transfer_buffer[i]) {
+				result = -ENOMEM;
+
+				printk(KERN_ERR "%s: failed buffer allocation"
+				       "(errno = %d)\n", DRIVER_NAME, result);
+				goto fail_adapter;
+			}
+		}
+	}
+
 	INIT_WORK(&dev->restart_streaming, au0828_restart_dvb_streaming);
 
 	/* register adapter */
@@ -423,6 +450,13 @@ fail_frontend:
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
 fail_adapter:
+
+	if (preallocate_big_buffers) {
+		int i;
+		for (i = 0; i < URB_COUNT; i++)
+			kfree(dev->dig_transfer_buffer[i]);
+	}
+
 	return result;
 }
 
@@ -443,6 +477,14 @@ void au0828_dvb_unregister(struct au0828_dev *dev)
 	dvb_unregister_frontend(dvb->frontend);
 	dvb_frontend_detach(dvb->frontend);
 	dvb_unregister_adapter(&dvb->adapter);
+
+	if (preallocate_big_buffers) {
+		int i;
+		for (i = 0; i < URB_COUNT; i++)
+			kfree(dev->dig_transfer_buffer[i]);
+	}
+
+
 }
 
 /* All the DVB attach calls go here, this function get's modified
diff --git a/linux/drivers/media/usb/au0828/au0828.h b/linux/drivers/media/usb/au0828/au0828.h
index a00b400..5439772 100644
--- a/linux/drivers/media/usb/au0828/au0828.h
+++ b/linux/drivers/media/usb/au0828/au0828.h
@@ -262,6 +262,10 @@ struct au0828_dev {
 	/* USB / URB Related */
 	int		urb_streaming;
 	struct urb	*urbs[URB_COUNT];
+
+	/* Preallocated transfer digital transfer buffers */
+
+	char *dig_transfer_buffer[URB_COUNT];
 };
 
 /* ----------------------------------------------------------- */
-- 
1.8.1.4

