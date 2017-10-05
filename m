Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40119 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751330AbdJEIpf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 04:45:35 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 13/25] media: lirc: move lirc_dev->attached to rc_dev->registered
Date: Thu,  5 Oct 2017 09:45:15 +0100
Message-Id: <a651aac654962a70c1b665dc1b651ac35e0237e2.1507192752.git.sean@mess.org>
In-Reply-To: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
References: <88e30a50734f7d132ac8a6234acc7335cbbb3a56.1507192751.git.sean@mess.org>
In-Reply-To: <cover.1507192751.git.sean@mess.org>
References: <cover.1507192751.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is done to further remove the lirc kernel api. Ensure that every
fops checks for this.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c | 16 ++++++++++------
 drivers/media/rc/lirc_dev.c      |  4 +---
 drivers/media/rc/rc-main.c       |  8 ++++++++
 include/media/lirc_dev.h         |  2 --
 include/media/rc-core.h          |  3 +++
 5 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 801d5d174b04..ca3a2556e836 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -101,6 +101,9 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	unsigned int duration = 0; /* signal duration in us */
 	int i;
 
+	if (!dev->registered)
+		return -ENODEV;
+
 	start = ktime_get();
 
 	if (dev->send_mode == LIRC_MODE_SCANCODE) {
@@ -223,6 +226,9 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 			return ret;
 	}
 
+	if (!dev->registered)
+		return -ENODEV;
+
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
 		if (dev->driver_type == RC_DRIVER_IR_RAW) {
@@ -408,12 +414,11 @@ static unsigned int ir_lirc_poll(struct file *file,
 				 struct poll_table_struct *wait)
 {
 	struct rc_dev *rcdev = file->private_data;
-	struct lirc_dev *d = rcdev->lirc_dev;
 	unsigned int events = 0;
 
 	poll_wait(file, &rcdev->wait_poll, wait);
 
-	if (!d->attached)
+	if (!rcdev->registered)
 		events = POLLHUP | POLLERR;
 	else if (rcdev->driver_type == RC_DRIVER_IR_RAW &&
 		 !kfifo_is_empty(&rcdev->rawir))
@@ -426,7 +431,6 @@ static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 			    size_t length, loff_t *ppos)
 {
 	struct rc_dev *rcdev = file->private_data;
-	struct lirc_dev *d = rcdev->lirc_dev;
 	unsigned int copied;
 	int ret;
 
@@ -436,7 +440,7 @@ static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 	if (length < sizeof(unsigned int) || length % sizeof(unsigned int))
 		return -EINVAL;
 
-	if (!d->attached)
+	if (!rcdev->registered)
 		return -ENODEV;
 
 	do {
@@ -446,12 +450,12 @@ static ssize_t ir_lirc_read(struct file *file, char __user *buffer,
 
 			ret = wait_event_interruptible(rcdev->wait_poll,
 					!kfifo_is_empty(&rcdev->rawir) ||
-					!d->attached);
+					!rcdev->registered);
 			if (ret)
 				return ret;
 		}
 
-		if (!d->attached)
+		if (!rcdev->registered)
 			return -ENODEV;
 
 		mutex_lock(&rcdev->lock);
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 9a0ad8d9a0cb..22171267aa90 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -122,7 +122,6 @@ int lirc_register_device(struct lirc_dev *d)
 
 	cdev_init(&d->cdev, d->fops);
 	d->cdev.owner = d->owner;
-	d->attached = true;
 
 	err = cdev_device_add(&d->cdev, &d->dev);
 	if (err) {
@@ -153,7 +152,6 @@ void lirc_unregister_device(struct lirc_dev *d)
 
 	mutex_lock(&d->mutex);
 
-	d->attached = false;
 	if (d->open) {
 		dev_dbg(&d->dev, LOGHEAD "releasing opened driver\n",
 			d->name, d->minor);
@@ -180,7 +178,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 	if (retval)
 		return retval;
 
-	if (!d->attached) {
+	if (!rcdev->registered) {
 		retval = -ENODEV;
 		goto out;
 	}
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 38393f13822f..9ae60a5fa6d2 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1795,6 +1795,8 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_lirc;
 	}
 
+	dev->registered = true;
+
 	IR_dprintk(1, "Registered rc%u (driver: %s)\n",
 		   dev->minor,
 		   dev->driver_name ? dev->driver_name : "unknown");
@@ -1857,6 +1859,12 @@ void rc_unregister_device(struct rc_dev *dev)
 
 	rc_free_rx_device(dev);
 
+	dev->registered = false;
+
+	/*
+	 * lirc device should be freed with dev->registered = false, so
+	 * that userspace polling will get notified.
+	 */
 	if (dev->driver_type != RC_DRIVER_SCANCODE)
 		ir_lirc_unregister(dev);
 
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 14d3eb36672e..5782add67edd 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -26,7 +26,6 @@
  * @rdev:		&struct rc_dev associated with the device
  * @fops:		&struct file_operations for the device
  * @owner:		the module owning this struct
- * @attached:		if the device is still live
  * @open:		open count for the device's chardev
  * @mutex:		serialises file_operations calls
  * @dev:		&struct device assigned to the device
@@ -40,7 +39,6 @@ struct lirc_dev {
 	const struct file_operations *fops;
 	struct module *owner;
 
-	bool attached;
 	int open;
 
 	struct mutex mutex; /* protect from simultaneous accesses */
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index d886ac56015b..17131762fb75 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -127,6 +127,8 @@ enum rc_filter_type {
  * @wait_poll: poll struct for lirc device
  * @send_mode: lirc mode for sending, either LIRC_MODE_SCANCODE or
  *	LIRC_MODE_PULSE
+ * @registered: set to true by rc_register_device(), false by
+ *	rc_unregister_device
  * @change_protocol: allow changing the protocol used on hardware decoders
  * @open: callback to allow drivers to enable polling/irq when IR input device
  *	is opened.
@@ -198,6 +200,7 @@ struct rc_dev {
 	wait_queue_head_t		wait_poll;
 	u8				send_mode;
 #endif
+	bool				registered;
 	int				(*change_protocol)(struct rc_dev *dev, u64 *rc_proto);
 	int				(*open)(struct rc_dev *dev);
 	void				(*close)(struct rc_dev *dev);
-- 
2.13.6
