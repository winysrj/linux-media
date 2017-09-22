Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34717 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751873AbdIVNIH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 09:08:07 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: andreyknvl@google.com, hverkuil@xs4all.nl, mchehab@kernel.org,
        laurent.pinchart@ideasonboard.com, dvyukov@google.com,
        kcc@google.com, syzkaller@googlegroups.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] hdpvr: Fix an error handling path in hdpvr_probe()
Date: Fri, 22 Sep 2017 18:37:06 +0530
Message-Id: <b5c06a8e071d38fc4b4df20b7f9c8fb25d5408fe.1506085151.git.arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here, hdpvr_register_videodev() is responsible for setup and
register a video device. Also defining and initializing a worker.
hdpvr_register_videodev() is calling by hdpvr_probe at last.
So No need to flash any work here.
Unregister v4l2, free buffers and memory. If hdpvr_probe() will fail.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index dbe29c6..1e8cbaf 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -292,7 +292,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		dev_err(&interface->dev, "v4l2_device_register failed\n");
-		goto error;
+		goto error_free_dev;
 	}
 
 	mutex_init(&dev->io_mutex);
@@ -301,7 +301,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	dev->usbc_buf = kmalloc(64, GFP_KERNEL);
 	if (!dev->usbc_buf) {
 		v4l2_err(&dev->v4l2_dev, "Out of memory\n");
-		goto error;
+		goto error_v4l2_unregister;
 	}
 
 	init_waitqueue_head(&dev->wait_buffer);
@@ -339,13 +339,13 @@ static int hdpvr_probe(struct usb_interface *interface,
 	}
 	if (!dev->bulk_in_endpointAddr) {
 		v4l2_err(&dev->v4l2_dev, "Could not find bulk-in endpoint\n");
-		goto error;
+		goto error_put_usb;
 	}
 
 	/* init the device */
 	if (hdpvr_device_init(dev)) {
 		v4l2_err(&dev->v4l2_dev, "device init failed\n");
-		goto error;
+		goto error_put_usb;
 	}
 
 	mutex_lock(&dev->io_mutex);
@@ -353,7 +353,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 		mutex_unlock(&dev->io_mutex);
 		v4l2_err(&dev->v4l2_dev,
 			 "allocating transfer buffers failed\n");
-		goto error;
+		goto error_put_usb;
 	}
 	mutex_unlock(&dev->io_mutex);
 
@@ -361,7 +361,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	retval = hdpvr_register_i2c_adapter(dev);
 	if (retval < 0) {
 		v4l2_err(&dev->v4l2_dev, "i2c adapter register failed\n");
-		goto error;
+		goto error_free_buffers;
 	}
 
 	client = hdpvr_register_ir_rx_i2c(dev);
@@ -394,13 +394,17 @@ static int hdpvr_probe(struct usb_interface *interface,
 reg_fail:
 #if IS_ENABLED(CONFIG_I2C)
 	i2c_del_adapter(&dev->i2c_adapter);
+error_free_buffers:
 #endif
+	hdpvr_free_buffers(dev);
+error_put_usb:
+	usb_put_dev(dev->udev);
+	kfree(dev->usbc_buf);
+error_v4l2_unregister:
+	v4l2_device_unregister(&dev->v4l2_dev);
+error_free_dev:
+	kfree(dev);
 error:
-	if (dev) {
-		flush_work(&dev->worker);
-		/* this frees allocated memory */
-		hdpvr_delete(dev);
-	}
 	return retval;
 }
 
-- 
1.9.1
