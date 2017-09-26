Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54939 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965270AbdIZUOG (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 16:14:06 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 15/20] media: lirc: remove name from lirc_dev
Date: Tue, 26 Sep 2017 21:13:54 +0100
Message-Id: <27da4e38e173aa2ffca9bbfa9fe636afe68923f0.1506455086.git.sean@mess.org>
In-Reply-To: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
References: <2d8072bb3a5e80de4a6dd175a358cb2034c12d3e.1506455086.git.sean@mess.org>
In-Reply-To: <cover.1506455086.git.sean@mess.org>
References: <cover.1506455086.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a duplicate of rcdev->driver_name.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-dev-intro.rst | 2 +-
 drivers/media/rc/ir-lirc-codec.c               | 2 --
 drivers/media/rc/lirc_dev.c                    | 9 +++------
 include/media/lirc_dev.h                       | 2 --
 4 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/uapi/rc/lirc-dev-intro.rst b/Documentation/media/uapi/rc/lirc-dev-intro.rst
index 3cacf9aeac40..a3fa3c1ef169 100644
--- a/Documentation/media/uapi/rc/lirc-dev-intro.rst
+++ b/Documentation/media/uapi/rc/lirc-dev-intro.rst
@@ -18,7 +18,7 @@ Example dmesg output upon a driver registering w/LIRC:
 
     $ dmesg |grep lirc_dev
     lirc_dev: IR Remote Control driver registered, major 248
-    rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
+    rc rc0: lirc_dev: driver mceusb registered at minor = 0
 
 What you should see for a chardev:
 
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 0b956ff09740..b6e20ddcd915 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -534,8 +534,6 @@ int ir_lirc_register(struct rc_dev *dev)
 	if (!ldev)
 		return rc;
 
-	snprintf(ldev->name, sizeof(ldev->name), "ir-lirc-codec (%s)",
-		 dev->driver_name);
 	ldev->fops = &lirc_fops;
 	ldev->dev.parent = &dev->dev;
 	ldev->rdev = dev;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 32124fb5c88e..4ac74fd86fd4 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -101,9 +101,6 @@ int lirc_register_device(struct lirc_dev *d)
 		return -EINVAL;
 	}
 
-	/* some safety check 8-) */
-	d->name[sizeof(d->name) - 1] = '\0';
-
 	if (rcdev->driver_type == RC_DRIVER_IR_RAW) {
 		if (kfifo_alloc(&rcdev->rawir, MAX_IR_EVENT_SIZE, GFP_KERNEL))
 			return -ENOMEM;
@@ -131,7 +128,7 @@ int lirc_register_device(struct lirc_dev *d)
 	get_device(d->dev.parent);
 
 	dev_info(&d->dev, "lirc_dev: driver %s registered at minor = %d\n",
-		 d->name, d->minor);
+		 rcdev->driver_name, d->minor);
 
 	return 0;
 }
@@ -147,13 +144,13 @@ void lirc_unregister_device(struct lirc_dev *d)
 	rcdev = d->rdev;
 
 	dev_dbg(&d->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
-		d->name, d->minor);
+		rcdev->driver_name, d->minor);
 
 	mutex_lock(&rcdev->lock);
 
 	if (rcdev->lirc_open) {
 		dev_dbg(&d->dev, LOGHEAD "releasing opened driver\n",
-			d->name, d->minor);
+			rcdev->driver_name, d->minor);
 		wake_up_poll(&rcdev->wait_poll, POLLHUP);
 	}
 
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index b45af81b4633..d12e1d1c3d67 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -21,7 +21,6 @@
 /**
  * struct lirc_dev - represents a LIRC device
  *
- * @name:		used for logging
  * @minor:		the minor device (/dev/lircX) number for the device
  * @rdev:		&struct rc_dev associated with the device
  * @fops:		&struct file_operations for the device
@@ -30,7 +29,6 @@
  * @cdev:		&struct cdev assigned to the device
  */
 struct lirc_dev {
-	char name[40];
 	unsigned int minor;
 
 	struct rc_dev *rdev;
-- 
2.13.5
