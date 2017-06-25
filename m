Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:56450 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751362AbdFYMci (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 08:32:38 -0400
Subject: [PATCH 16/19] lirc_dev: merge struct irctl into struct lirc_dev
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Sun, 25 Jun 2017 14:32:36 +0200
Message-ID: <149839395608.28811.5939411094152357479.stgit@zeus.hardeman.nu>
In-Reply-To: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The use of two separate structs (lirc_dev aka lirc_driver and irctl) makes
it much harder to follow the proper lifetime of the various structs and
necessitates hacks such as keeping a copy of struct lirc_dev inside
struct irctl.

Merging the two structs means that lirc_dev can properly manage the lifetime
of the resulting struct and simplifies the code at the same time.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c        |   15 +-
 drivers/media/rc/lirc_dev.c             |  288 +++++++++++++------------------
 drivers/staging/media/lirc/lirc_zilog.c |   20 +-
 include/media/lirc_dev.h                |   26 ++-
 4 files changed, 161 insertions(+), 188 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index f276c4f56fb5..ba20a4ce9cbc 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -35,7 +35,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 	int sample;
 
-	if (!dev->raw->lirc.ldev || !dev->raw->lirc.ldev->rbuf)
+	if (!dev->raw->lirc.ldev || !dev->raw->lirc.ldev->buf)
 		return -EINVAL;
 
 	/* Packet start */
@@ -84,7 +84,7 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 							(u64)LIRC_VALUE_MASK);
 
 			gap_sample = LIRC_SPACE(lirc->gap_duration);
-			lirc_buffer_write(dev->raw->lirc.ldev->rbuf,
+			lirc_buffer_write(dev->raw->lirc.ldev->buf,
 						(unsigned char *) &gap_sample);
 			lirc->gap = false;
 		}
@@ -95,9 +95,9 @@ static int ir_lirc_decode(struct rc_dev *dev, struct ir_raw_event ev)
 			   TO_US(ev.duration), TO_STR(ev.pulse));
 	}
 
-	lirc_buffer_write(dev->raw->lirc.ldev->rbuf,
+	lirc_buffer_write(dev->raw->lirc.ldev->buf,
 			  (unsigned char *) &sample);
-	wake_up(&dev->raw->lirc.ldev->rbuf->wait_poll);
+	wake_up(&dev->raw->lirc.ldev->buf->wait_poll);
 
 	return 0;
 }
@@ -384,12 +384,12 @@ static int ir_lirc_register(struct rc_dev *dev)
 		 dev->driver_name);
 	ldev->features = features;
 	ldev->data = &dev->raw->lirc;
-	ldev->rbuf = NULL;
+	ldev->buf = NULL;
 	ldev->code_length = sizeof(struct ir_raw_event) * 8;
 	ldev->chunk_size = sizeof(int);
 	ldev->buffer_size = LIRCBUF_SIZE;
 	ldev->fops = &lirc_fops;
-	ldev->dev = &dev->dev;
+	ldev->dev.parent = &dev->dev;
 	ldev->rdev = dev;
 	ldev->owner = THIS_MODULE;
 
@@ -402,7 +402,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	return 0;
 
 out:
-	kfree(ldev);
+	lirc_free_device(ldev);
 	return rc;
 }
 
@@ -411,7 +411,6 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 
 	lirc_unregister_device(lirc->ldev);
-	kfree(lirc->ldev);
 	lirc->ldev = NULL;
 
 	return 0;
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 80944c2f7e91..4ad08d3d4e2f 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -34,19 +34,6 @@
 
 static dev_t lirc_base_dev;
 
-struct irctl {
-	struct lirc_dev d;
-	bool attached;
-	int open;
-
-	struct mutex mutex;
-	struct lirc_buffer *buf;
-	bool buf_internal;
-
-	struct device dev;
-	struct cdev cdev;
-};
-
 /* Used to keep track of allocated lirc devices */
 #define LIRC_MAX_DEVICES 256
 static DEFINE_IDA(lirc_ida);
@@ -54,69 +41,72 @@ static DEFINE_IDA(lirc_ida);
 /* Only used for sysfs but defined to void otherwise */
 static struct class *lirc_class;
 
-static void lirc_free_buffer(struct irctl *ir)
+static void lirc_release_device(struct device *ld)
 {
-	if (ir->buf_internal) {
-		lirc_buffer_free(ir->buf);
-		kfree(ir->buf);
-		ir->buf = NULL;
+	struct lirc_dev *d = container_of(ld, struct lirc_dev, dev);
+
+	if (d->buf_internal) {
+		lirc_buffer_free(d->buf);
+		kfree(d->buf);
+		d->buf = NULL;
 	}
+	kfree(d);
+	module_put(THIS_MODULE);
 }
 
-static void lirc_release(struct device *ld)
+static int lirc_allocate_buffer(struct lirc_dev *d)
 {
-	struct irctl *ir = container_of(ld, struct irctl, dev);
-
-	lirc_free_buffer(ir);
-	kfree(ir);
-}
+	int err;
 
-static int lirc_allocate_buffer(struct irctl *ir)
-{
-	int err = 0;
-	struct lirc_dev *d = &ir->d;
-
-	if (d->rbuf) {
-		ir->buf = d->rbuf;
-		ir->buf_internal = false;
-	} else {
-		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-		if (!ir->buf) {
-			err = -ENOMEM;
-			goto out;
-		}
+	if (d->buf) {
+		d->buf_internal = false;
+		return 0;
+	}
 
-		err = lirc_buffer_init(ir->buf, d->chunk_size, d->buffer_size);
-		if (err) {
-			kfree(ir->buf);
-			ir->buf = NULL;
-			goto out;
-		}
+	d->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
+	if (!d->buf)
+		return -ENOMEM;
 
-		ir->buf_internal = true;
-		d->rbuf = ir->buf;
+	err = lirc_buffer_init(d->buf, d->chunk_size, d->buffer_size);
+	if (err) {
+		kfree(d->buf);
+		d->buf = NULL;
+		return err;
 	}
 
-out:
-	return err;
+	d->buf_internal = true;
+	return 0;
 }
 
 struct lirc_dev *
 lirc_allocate_device(void)
 {
-	return kzalloc(sizeof(struct lirc_dev), GFP_KERNEL);
+	struct lirc_dev *d;
+
+	d = kzalloc(sizeof(struct lirc_dev), GFP_KERNEL);
+	if (d) {
+		mutex_init(&d->mutex);
+		device_initialize(&d->dev);
+		d->dev.class = lirc_class;
+		d->dev.release = lirc_release_device;
+		__module_get(THIS_MODULE);
+	}
+
+	return d;
 }
 EXPORT_SYMBOL(lirc_allocate_device);
 
 void lirc_free_device(struct lirc_dev *d)
 {
-	kfree(d);
+	if (!d)
+		return;
+
+	put_device(&d->dev);
 }
 EXPORT_SYMBOL(lirc_free_device);
 
 int lirc_register_device(struct lirc_dev *d)
 {
-	struct irctl *ir;
 	int minor;
 	int err;
 
@@ -125,8 +115,8 @@ int lirc_register_device(struct lirc_dev *d)
 		return -EBADRQC;
 	}
 
-	if (!d->dev) {
-		pr_err("dev pointer not filled in!\n");
+	if (!d->dev.parent) {
+		pr_err("dev parent pointer not filled in!\n");
 		return -EINVAL;
 	}
 
@@ -135,79 +125,58 @@ int lirc_register_device(struct lirc_dev *d)
 		return -EINVAL;
 	}
 
-	if (!d->rbuf && d->chunk_size < 1) {
+	if (!d->buf && d->chunk_size < 1) {
 		pr_err("chunk_size must be set!\n");
 		return -EINVAL;
 	}
 
-	if (!d->rbuf && d->buffer_size < 1) {
+	if (!d->buf && d->buffer_size < 1) {
 		pr_err("buffer_size must be set!\n");
 		return -EINVAL;
 	}
 
 	if (d->code_length < 1 || d->code_length > 128) {
-		dev_err(d->dev, "invalid code_length!\n");
+		dev_err(&d->dev, "invalid code_length!\n");
 		return -EBADRQC;
 	}
 
-	if (!d->rbuf && !(d->fops && d->fops->read &&
+	if (!d->buf && !(d->fops && d->fops->read &&
 			  d->fops->poll && d->fops->unlocked_ioctl)) {
-		dev_err(d->dev, "undefined read, poll, ioctl\n");
+		dev_err(&d->dev, "undefined read, poll, ioctl\n");
 		return -EBADRQC;
 	}
 
-	/* some safety check 8-) */
 	d->name[sizeof(d->name)-1] = '\0';
 
 	if (d->features == 0)
 		d->features = LIRC_CAN_REC_LIRCCODE;
 
-	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
-	if (!ir)
-		return -ENOMEM;
-
-	mutex_init(&ir->mutex);
-	ir->d = *d;
-
 	if (LIRC_CAN_REC(d->features)) {
-		err = lirc_allocate_buffer(ir);
-		if (err) {
-			kfree(ir);
+		err = lirc_allocate_buffer(d);
+		if (err)
 			return err;
-		}
-		d->rbuf = ir->buf;
 	}
 
 	minor = ida_simple_get(&lirc_ida, 0, LIRC_MAX_DEVICES, GFP_KERNEL);
-	if (minor < 0) {
-		lirc_free_buffer(ir);
-		kfree(ir);
+	if (minor < 0)
 		return minor;
-	}
 
-	d->irctl = ir;
 	d->minor = minor;
+	d->dev.devt = MKDEV(MAJOR(lirc_base_dev), d->minor);
+	dev_set_name(&d->dev, "lirc%d", d->minor);
 
-	device_initialize(&ir->dev);
-	ir->dev.devt = MKDEV(MAJOR(lirc_base_dev), ir->d.minor);
-	ir->dev.class = lirc_class;
-	ir->dev.parent = d->dev;
-	ir->dev.release = lirc_release;
-	dev_set_name(&ir->dev, "lirc%d", ir->d.minor);
+	cdev_init(&d->cdev, d->fops);
+	d->cdev.owner = d->owner;
+	d->attached = true;
 
-	cdev_init(&ir->cdev, d->fops);
-	ir->cdev.owner = ir->d.owner;
-	ir->attached = true;
-
-	err = cdev_device_add(&ir->cdev, &ir->dev);
+	err = cdev_device_add(&d->cdev, &d->dev);
 	if (err) {
 		ida_simple_remove(&lirc_ida, minor);
-		put_device(&ir->dev);
 		return err;
 	}
 
-	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
-		 ir->d.name, ir->d.minor);
+	dev_info(&d->dev, "lirc_dev: driver %s registered at minor = %d\n",
+		 d->name, d->minor);
 
 	return 0;
 }
@@ -215,88 +184,83 @@ EXPORT_SYMBOL(lirc_register_device);
 
 void lirc_unregister_device(struct lirc_dev *d)
 {
-	struct irctl *ir;
-
-	if (!d || !d->irctl)
+	if (!d)
 		return;
 
-	ir = d->irctl;
-
-	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
+	dev_dbg(&d->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
 		d->name, d->minor);
 
-	cdev_device_del(&ir->cdev, &ir->dev);
-
-	mutex_lock(&ir->mutex);
+	mutex_lock(&d->mutex);
 
-	ir->attached = false;
-	if (ir->open) {
-		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
+	d->attached = false;
+	if (d->open) {
+		dev_dbg(&d->dev, LOGHEAD "releasing opened driver\n",
 			d->name, d->minor);
-		wake_up_interruptible(&ir->buf->wait_poll);
+		wake_up_interruptible(&d->buf->wait_poll);
 	}
 
-	mutex_unlock(&ir->mutex);
+	mutex_unlock(&d->mutex);
 
+	cdev_device_del(&d->cdev, &d->dev);
 	ida_simple_remove(&lirc_ida, d->minor);
-	put_device(&ir->dev);
+	put_device(&d->dev);
 }
 EXPORT_SYMBOL(lirc_unregister_device);
 
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
-	struct irctl *ir = container_of(inode->i_cdev, struct irctl, cdev);
+	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
 	int retval;
 
-	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
+	dev_dbg(&d->dev, LOGHEAD "open called\n", d->name, d->minor);
 
-	retval = mutex_lock_interruptible(&ir->mutex);
+	retval = mutex_lock_interruptible(&d->mutex);
 	if (retval)
 		return retval;
 
-	if (!ir->attached) {
+	if (!d->attached) {
 		retval = -ENODEV;
 		goto out;
 	}
 
-	if (ir->open) {
+	if (d->open) {
 		retval = -EBUSY;
 		goto out;
 	}
 
-	if (ir->d.rdev) {
-		retval = rc_open(ir->d.rdev);
+	if (d->rdev) {
+		retval = rc_open(d->rdev);
 		if (retval)
 			goto out;
 	}
 
-	if (ir->buf)
-		lirc_buffer_clear(ir->buf);
+	if (d->buf)
+		lirc_buffer_clear(d->buf);
 
-	ir->open++;
+	d->open++;
 
 	lirc_init_pdata(inode, file);
 	nonseekable_open(inode, file);
-	mutex_unlock(&ir->mutex);
+	mutex_unlock(&d->mutex);
 
 	return 0;
 
 out:
-	mutex_unlock(&ir->mutex);
+	mutex_unlock(&d->mutex);
 	return retval;
 }
 EXPORT_SYMBOL(lirc_dev_fop_open);
 
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
-	struct irctl *ir = file->private_data;
+	struct lirc_dev *d = file->private_data;
 
-	mutex_lock(&ir->mutex);
+	mutex_lock(&d->mutex);
 
-	rc_close(ir->d.rdev);
-	ir->open--;
+	rc_close(d->rdev);
+	d->open--;
 
-	mutex_unlock(&ir->mutex);
+	mutex_unlock(&d->mutex);
 
 	return 0;
 }
@@ -304,24 +268,23 @@ EXPORT_SYMBOL(lirc_dev_fop_close);
 
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 {
-	struct irctl *ir = file->private_data;
+	struct lirc_dev *d = file->private_data;
 	unsigned int ret;
 
-	if (!ir->attached)
+	if (!d->attached)
 		return POLLHUP | POLLERR;
 
-	if (ir->buf) {
-		poll_wait(file, &ir->buf->wait_poll, wait);
+	if (d->buf) {
+		poll_wait(file, &d->buf->wait_poll, wait);
 
-		if (lirc_buffer_empty(ir->buf))
+		if (lirc_buffer_empty(d->buf))
 			ret = 0;
 		else
 			ret = POLLIN | POLLRDNORM;
 	} else
 		ret = POLLERR;
 
-	dev_dbg(ir->d.dev, LOGHEAD "poll result = %d\n",
-		ir->d.name, ir->d.minor, ret);
+	dev_dbg(&d->dev, LOGHEAD "poll result = %d\n", d->name, d->minor, ret);
 
 	return ret;
 }
@@ -329,44 +292,43 @@ EXPORT_SYMBOL(lirc_dev_fop_poll);
 
 long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct irctl *ir = file->private_data;
+	struct lirc_dev *d = file->private_data;
 	__u32 mode;
 	int result;
 
-	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
-		ir->d.name, ir->d.minor, cmd);
+	dev_dbg(&d->dev, LOGHEAD "ioctl called (0x%x)\n", d->name, d->minor, cmd);
 
-	result = mutex_lock_interruptible(&ir->mutex);
+	result = mutex_lock_interruptible(&d->mutex);
 	if (result)
 		return result;
 
-	if (!ir->attached) {
+	if (!d->attached) {
 		result = -ENODEV;
 		goto out;
 	}
 
 	switch (cmd) {
 	case LIRC_GET_FEATURES:
-		result = put_user(ir->d.features, (__u32 __user *)arg);
+		result = put_user(d->features, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_REC_MODE:
-		if (!LIRC_CAN_REC(ir->d.features)) {
+		if (!LIRC_CAN_REC(d->features)) {
 			result = -ENOTTY;
 			break;
 		}
 
 		result = put_user(LIRC_REC2MODE
-				  (ir->d.features & LIRC_CAN_REC_MASK),
+				  (d->features & LIRC_CAN_REC_MASK),
 				  (__u32 __user *)arg);
 		break;
 	case LIRC_SET_REC_MODE:
-		if (!LIRC_CAN_REC(ir->d.features)) {
+		if (!LIRC_CAN_REC(d->features)) {
 			result = -ENOTTY;
 			break;
 		}
 
 		result = get_user(mode, (__u32 __user *)arg);
-		if (!result && !(LIRC_MODE2REC(mode) & ir->d.features))
+		if (!result && !(LIRC_MODE2REC(mode) & d->features))
 			result = -EINVAL;
 		/*
 		 * FIXME: We should actually set the mode somehow but
@@ -374,14 +336,14 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		 */
 		break;
 	case LIRC_GET_LENGTH:
-		result = put_user(ir->d.code_length, (__u32 __user *)arg);
+		result = put_user(d->code_length, (__u32 __user *)arg);
 		break;
 	default:
 		result = -ENOTTY;
 	}
 
 out:
-	mutex_unlock(&ir->mutex);
+	mutex_unlock(&d->mutex);
 	return result;
 }
 EXPORT_SYMBOL(lirc_dev_fop_ioctl);
@@ -391,28 +353,28 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			  size_t length,
 			  loff_t *ppos)
 {
-	struct irctl *ir = file->private_data;
-	unsigned char buf[ir->buf->chunk_size];
+	struct lirc_dev *d = file->private_data;
+	unsigned char buf[d->buf->chunk_size];
 	int ret, written = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
-	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
+	dev_dbg(&d->dev, LOGHEAD "read called\n", d->name, d->minor);
 
-	ret = mutex_lock_interruptible(&ir->mutex);
+	ret = mutex_lock_interruptible(&d->mutex);
 	if (ret)
 		return ret;
 
-	if (!ir->attached) {
+	if (!d->attached) {
 		ret = -ENODEV;
 		goto out_locked;
 	}
 
-	if (!LIRC_CAN_REC(ir->d.features)) {
+	if (!LIRC_CAN_REC(d->features)) {
 		ret = -EINVAL;
 		goto out_locked;
 	}
 
-	if (length % ir->buf->chunk_size) {
+	if (length % d->buf->chunk_size) {
 		ret = -EINVAL;
 		goto out_locked;
 	}
@@ -422,14 +384,14 @@ ssize_t lirc_dev_fop_read(struct file *file,
 	 * to avoid losing scan code (in case when queue is awaken somewhere
 	 * between while condition checking and scheduling)
 	 */
-	add_wait_queue(&ir->buf->wait_poll, &wait);
+	add_wait_queue(&d->buf->wait_poll, &wait);
 
 	/*
 	 * while we didn't provide 'length' bytes, device is opened in blocking
 	 * mode and 'copy_to_user' is happy, wait for data.
 	 */
 	while (written < length && ret == 0) {
-		if (lirc_buffer_empty(ir->buf)) {
+		if (lirc_buffer_empty(d->buf)) {
 			/* According to the read(2) man page, 'written' can be
 			 * returned as less than 'length', instead of blocking
 			 * again, returning -EWOULDBLOCK, or returning
@@ -446,36 +408,36 @@ ssize_t lirc_dev_fop_read(struct file *file,
 				break;
 			}
 
-			mutex_unlock(&ir->mutex);
+			mutex_unlock(&d->mutex);
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			set_current_state(TASK_RUNNING);
 
-			ret = mutex_lock_interruptible(&ir->mutex);
+			ret = mutex_lock_interruptible(&d->mutex);
 			if (ret) {
-				remove_wait_queue(&ir->buf->wait_poll, &wait);
+				remove_wait_queue(&d->buf->wait_poll, &wait);
 				goto out_unlocked;
 			}
 
-			if (!ir->attached) {
+			if (!d->attached) {
 				ret = -ENODEV;
 				goto out_locked;
 			}
 		} else {
-			lirc_buffer_read(ir->buf, buf);
+			lirc_buffer_read(d->buf, buf);
 			ret = copy_to_user((void __user *)buffer+written, buf,
-					   ir->buf->chunk_size);
+					   d->buf->chunk_size);
 			if (!ret)
-				written += ir->buf->chunk_size;
+				written += d->buf->chunk_size;
 			else
 				ret = -EFAULT;
 		}
 	}
 
-	remove_wait_queue(&ir->buf->wait_poll, &wait);
+	remove_wait_queue(&d->buf->wait_poll, &wait);
 
 out_locked:
-	mutex_unlock(&ir->mutex);
+	mutex_unlock(&d->mutex);
 
 out_unlocked:
 	return ret ? ret : written;
@@ -484,17 +446,17 @@ EXPORT_SYMBOL(lirc_dev_fop_read);
 
 void lirc_init_pdata(struct inode *inode, struct file *file)
 {
-	struct irctl *ir = container_of(inode->i_cdev, struct irctl, cdev);
+	struct lirc_dev *d = container_of(inode->i_cdev, struct lirc_dev, cdev);
 
-	file->private_data = ir;
+	file->private_data = d;
 }
 EXPORT_SYMBOL(lirc_init_pdata);
 
 void *lirc_get_pdata(struct file *file)
 {
-	struct irctl *ir = file->private_data;
+	struct lirc_dev *d = file->private_data;
 
-	return ir->d.data;
+	return d->data;
 }
 EXPORT_SYMBOL(lirc_get_pdata);
 
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index bbbba25ae574..406833d3a28e 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -187,10 +187,8 @@ static void release_ir_device(struct kref *ref)
 	 * ir->open_count ==  0 - happens on final close()
 	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
 	 */
-	if (ir->l) {
+	if (ir->l)
 		lirc_unregister_device(ir->l);
-		lirc_free_device(ir->l);
-	}
 
 	if (kfifo_initialized(&ir->rbuf.fifo))
 		lirc_buffer_free(&ir->rbuf);
@@ -321,7 +319,7 @@ static int add_to_buf(struct IR *ir)
 	int ret;
 	int failures = 0;
 	unsigned char sendbuf[1] = { 0 };
-	struct lirc_buffer *rbuf = ir->l->rbuf;
+	struct lirc_buffer *rbuf = ir->l->buf;
 	struct IR_rx *rx;
 	struct IR_tx *tx;
 
@@ -467,7 +465,7 @@ static int add_to_buf(struct IR *ir)
 static int lirc_thread(void *arg)
 {
 	struct IR *ir = arg;
-	struct lirc_buffer *rbuf = ir->l->rbuf;
+	struct lirc_buffer *rbuf = ir->l->buf;
 
 	dev_dbg(ir->dev, "poll thread started\n");
 
@@ -888,7 +886,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 {
 	struct IR *ir = lirc_get_pdata(filep);
 	struct IR_rx *rx;
-	struct lirc_buffer *rbuf = ir->l->rbuf;
+	struct lirc_buffer *rbuf = ir->l->buf;
 	int ret = 0, written = 0, retries = 0;
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
@@ -1206,7 +1204,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 {
 	struct IR *ir = lirc_get_pdata(filep);
 	struct IR_rx *rx;
-	struct lirc_buffer *rbuf = ir->l->rbuf;
+	struct lirc_buffer *rbuf = ir->l->buf;
 	unsigned int ret;
 
 	dev_dbg(ir->dev, "%s called\n", __func__);
@@ -1452,6 +1450,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		ir->l->code_length = 13;
 		ir->l->fops = &lirc_fops;
 		ir->l->owner = THIS_MODULE;
+		ir->l->dev.parent = &adap->dev;
 
 		/*
 		 * FIXME this is a pointer reference to us, but no refcount.
@@ -1459,13 +1458,12 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		 * This OK for now, since lirc_dev currently won't touch this
 		 * buffer as we provide our own lirc_fops.
 		 *
-		 * Currently our own lirc_fops rely on this ir->l->rbuf pointer
+		 * Currently our own lirc_fops rely on this ir->l->buf pointer
 		 */
-		ir->l->rbuf = &ir->rbuf;
-		ir->l->dev  = &adap->dev;
+		ir->l->buf = &ir->rbuf;
 		/* This will be returned by lirc_get_pdata() */
 		ir->l->data = ir;
-		ret = lirc_buffer_init(ir->l->rbuf, 2, BUFLEN / 2);
+		ret = lirc_buffer_init(ir->l->buf, 2, BUFLEN / 2);
 		if (ret) {
 			lirc_free_device(ir->l);
 			ir->l = NULL;
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index 21aac9494678..63dd88b02479 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -15,6 +15,8 @@
 #include <linux/poll.h>
 #include <linux/kfifo.h>
 #include <media/lirc.h>
+#include <linux/device.h>
+#include <linux/cdev.h>
 
 struct lirc_buffer {
 	wait_queue_head_t wait_poll;
@@ -121,14 +123,19 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  * @chunk_size:		Size of each FIFO buffer.
  *			Only used if @rbuf is NULL.
  * @data:		private per-driver data
- * @rbuf:		if not NULL, it will be used as a read buffer, you will
+ * @buf:		if %NULL, lirc_dev will allocate and manage the buffer,
+ *			otherwise allocated by the caller which will
  *			have to write to the buffer by other means, like irq's
  *			(see also lirc_serial.c).
+ * @buf_internal:	whether lirc_dev has allocated the read buffer or not
  * @rdev:		&struct rc_dev associated with the device
  * @fops:		&struct file_operations for the device
- * @dev:		&struct device assigned to the device
  * @owner:		the module owning this struct
- * @irctl:		&struct irctl assigned to the device
+ * @attached:		if the device is still live
+ * @open:		open count for the device's chardev
+ * @mutex:		serialises file_operations calls
+ * @dev:		&struct device assigned to the device
+ * @cdev:		&struct cdev assigned to the device
  */
 struct lirc_dev {
 	char name[40];
@@ -138,14 +145,21 @@ struct lirc_dev {
 
 	unsigned int buffer_size; /* in chunks holding one code each */
 	unsigned int chunk_size;
+	struct lirc_buffer *buf;
+	bool buf_internal;
 
 	void *data;
-	struct lirc_buffer *rbuf;
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
-	struct device *dev;
 	struct module *owner;
-	struct irctl *irctl;
+
+	bool attached;
+	int open;
+
+	struct mutex mutex;
+
+	struct device dev;
+	struct cdev cdev;
 };
 
 extern struct lirc_dev *lirc_allocate_device(void);
