Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40725 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1032322AbdAFMtP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Jan 2017 07:49:15 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 2/9] [media] lirc: exorcise struct irctl
Date: Fri,  6 Jan 2017 12:49:05 +0000
Message-Id: <ffd26215658ff2566ecf04242eeec012073497a5.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
In-Reply-To: <cover.1483706563.git.sean@mess.org>
References: <cover.1483706563.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc_register_driver() takes a struct lirc_driver argument, it then
allocates a new struct irctl which contains another struct lirc_driver
and then copies it over.

By moving the members of struct irctl to struct lirc_driver, we avoid the
extra allocation and we can remove struct irctl completely. We also
remove the duplicate chunk_size member.

In addition, the members of irctl are now visible elsewhere.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c        |   1 -
 drivers/media/rc/lirc_dev.c             | 317 ++++++++++++++------------------
 drivers/staging/media/lirc/lirc_sasem.c |   1 -
 include/media/lirc_dev.h                |  25 +++
 4 files changed, 168 insertions(+), 176 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index c3a2a6d..b78a402 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -424,7 +424,6 @@ int ir_lirc_unregister(struct rc_dev *dev)
 	lirc_unregister_driver(lirc->drv->minor);
 	lirc_buffer_free(lirc->drv->rbuf);
 	kfree(lirc->drv->rbuf);
-	kfree(lirc->drv);
 
 	return 0;
 }
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 5884f0e..379e9d4 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -47,24 +47,9 @@
 
 static dev_t lirc_base_dev;
 
-struct irctl {
-	struct lirc_driver d;
-	int attached;
-	int open;
-
-	struct mutex irctl_lock;
-	struct lirc_buffer *buf;
-	unsigned int chunk_size;
-
-	struct cdev *cdev;
-
-	struct task_struct *task;
-	long jiffies_to_wait;
-};
-
 static DEFINE_MUTEX(lirc_dev_lock);
 
-static struct irctl *irctls[MAX_IRCTL_DEVICES];
+static struct lirc_driver *irctls[MAX_IRCTL_DEVICES];
 
 /* Only used for sysfs but defined to void otherwise */
 static struct class *lirc_class;
@@ -72,33 +57,27 @@ static struct class *lirc_class;
 /*  helper function
  *  initializes the irctl structure
  */
-static void lirc_irctl_init(struct irctl *ir)
-{
-	mutex_init(&ir->irctl_lock);
-	ir->d.minor = NOPLUG;
-}
-
-static void lirc_irctl_cleanup(struct irctl *ir)
+static void lirc_irctl_cleanup(struct lirc_driver *d)
 {
-	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
+	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), d->minor));
 
-	if (ir->buf != ir->d.rbuf) {
-		lirc_buffer_free(ir->buf);
-		kfree(ir->buf);
+	if (d->buf != d->rbuf) {
+		lirc_buffer_free(d->buf);
+		kfree(d->buf);
 	}
-	ir->buf = NULL;
+	d->buf = NULL;
 }
 
 /*  helper function
  *  reads key codes from driver and puts them into buffer
  *  returns 0 on success
  */
-static int lirc_add_to_buf(struct irctl *ir)
+static int lirc_add_to_buf(struct lirc_driver *d)
 {
 	int res;
 	int got_data = -1;
 
-	if (!ir->d.add_to_buf)
+	if (!d->add_to_buf)
 		return 0;
 
 	/*
@@ -107,31 +86,31 @@ static int lirc_add_to_buf(struct irctl *ir)
 	 */
 	do {
 		got_data++;
-		res = ir->d.add_to_buf(ir->d.data, ir->buf);
+		res = d->add_to_buf(d->data, d->buf);
 	} while (!res);
 
 	if (res == -ENODEV)
-		kthread_stop(ir->task);
+		kthread_stop(d->task);
 
 	return got_data ? 0 : res;
 }
 
 /* main function of the polling thread
  */
-static int lirc_thread(void *irctl)
+static int lirc_thread(void *lirc_driver)
 {
-	struct irctl *ir = irctl;
+	struct lirc_driver *d = lirc_driver;
 
 	do {
-		if (ir->open) {
-			if (ir->jiffies_to_wait) {
+		if (d->open) {
+			if (d->jiffies_to_wait) {
 				set_current_state(TASK_INTERRUPTIBLE);
-				schedule_timeout(ir->jiffies_to_wait);
+				schedule_timeout(d->jiffies_to_wait);
 			}
 			if (kthread_should_stop())
 				break;
-			if (!lirc_add_to_buf(ir))
-				wake_up_interruptible(&ir->buf->wait_poll);
+			if (!lirc_add_to_buf(d))
+				wake_up_interruptible(&d->buf->wait_poll);
 		} else {
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
@@ -141,7 +120,6 @@ static int lirc_thread(void *irctl)
 	return 0;
 }
 
-
 static const struct file_operations lirc_dev_fops = {
 	.owner		= THIS_MODULE,
 	.read		= lirc_dev_fop_read,
@@ -153,9 +131,8 @@ static const struct file_operations lirc_dev_fops = {
 	.llseek		= noop_llseek,
 };
 
-static int lirc_cdev_add(struct irctl *ir)
+static int lirc_cdev_add(struct lirc_driver *d)
 {
-	struct lirc_driver *d = &ir->d;
 	struct cdev *cdev;
 	int retval;
 
@@ -178,7 +155,7 @@ static int lirc_cdev_add(struct irctl *ir)
 	if (retval)
 		goto err_out;
 
-	ir->cdev = cdev;
+	d->cdev = cdev;
 
 	return 0;
 
@@ -187,13 +164,12 @@ static int lirc_cdev_add(struct irctl *ir)
 	return retval;
 }
 
-static int lirc_allocate_buffer(struct irctl *ir)
+static int lirc_allocate_buffer(struct lirc_driver *d)
 {
 	int err = 0;
 	int bytes_in_key;
 	unsigned int chunk_size;
 	unsigned int buffer_size;
-	struct lirc_driver *d = &ir->d;
 
 	mutex_lock(&lirc_dev_lock);
 
@@ -203,21 +179,21 @@ static int lirc_allocate_buffer(struct irctl *ir)
 	chunk_size  = d->chunk_size  ? d->chunk_size  : bytes_in_key;
 
 	if (d->rbuf) {
-		ir->buf = d->rbuf;
+		d->buf = d->rbuf;
 	} else {
-		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-		if (!ir->buf) {
+		d->buf = kmalloc(sizeof(*d->buf), GFP_KERNEL);
+		if (!d->buf) {
 			err = -ENOMEM;
 			goto out;
 		}
 
-		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
+		err = lirc_buffer_init(d->buf, chunk_size, buffer_size);
 		if (err) {
-			kfree(ir->buf);
+			kfree(d->buf);
 			goto out;
 		}
 	}
-	ir->chunk_size = ir->buf->chunk_size;
+	d->chunk_size = d->buf->chunk_size;
 
 out:
 	mutex_unlock(&lirc_dev_lock);
@@ -227,7 +203,6 @@ static int lirc_allocate_buffer(struct irctl *ir)
 
 static int lirc_allocate_driver(struct lirc_driver *d)
 {
-	struct irctl *ir;
 	int minor;
 	int err;
 
@@ -289,13 +264,8 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		goto out_lock;
 	}
 
-	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
-	if (!ir) {
-		err = -ENOMEM;
-		goto out_lock;
-	}
-	lirc_irctl_init(ir);
-	irctls[minor] = ir;
+	mutex_init(&d->irctl_lock);
+	irctls[minor] = d;
 	d->minor = minor;
 
 	/* some safety check 8-) */
@@ -304,18 +274,16 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 	if (d->features == 0)
 		d->features = LIRC_CAN_REC_LIRCCODE;
 
-	ir->d = *d;
-
-	device_create(lirc_class, ir->d.dev,
-		      MKDEV(MAJOR(lirc_base_dev), ir->d.minor), NULL,
-		      "lirc%u", ir->d.minor);
+	device_create(lirc_class, d->dev,
+		      MKDEV(MAJOR(lirc_base_dev), d->minor), NULL,
+		      "lirc%u", d->minor);
 
 	if (d->sample_rate) {
-		ir->jiffies_to_wait = HZ / d->sample_rate;
+		d->jiffies_to_wait = HZ / d->sample_rate;
 
 		/* try to fire up polling thread */
-		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
-		if (IS_ERR(ir->task)) {
+		d->task = kthread_run(lirc_thread, d, "lirc_dev");
+		if (IS_ERR(d->task)) {
 			dev_err(d->dev, "cannot run thread for minor = %d\n",
 								d->minor);
 			err = -ECHILD;
@@ -323,22 +291,22 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		}
 	} else {
 		/* it means - wait for external event in task queue */
-		ir->jiffies_to_wait = 0;
+		d->jiffies_to_wait = 0;
 	}
 
-	err = lirc_cdev_add(ir);
+	err = lirc_cdev_add(d);
 	if (err)
 		goto out_sysfs;
 
-	ir->attached = 1;
+	d->attached = 1;
 	mutex_unlock(&lirc_dev_lock);
 
-	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
-		 ir->d.name, ir->d.minor);
+	dev_info(d->dev, "lirc_dev: driver %s registered at minor = %d\n",
+		 d->name, d->minor);
 	return minor;
 
 out_sysfs:
-	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), ir->d.minor));
+	device_destroy(lirc_class, MKDEV(MAJOR(lirc_base_dev), d->minor));
 out_lock:
 	mutex_unlock(&lirc_dev_lock);
 
@@ -365,7 +333,7 @@ EXPORT_SYMBOL(lirc_register_driver);
 
 int lirc_unregister_driver(int minor)
 {
-	struct irctl *ir;
+	struct lirc_driver *d;
 	struct cdev *cdev;
 
 	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
@@ -374,46 +342,46 @@ int lirc_unregister_driver(int minor)
 		return -EBADRQC;
 	}
 
-	ir = irctls[minor];
-	if (!ir) {
+	d = irctls[minor];
+	if (!d) {
 		pr_err("failed to get irctl\n");
 		return -ENOENT;
 	}
 
-	cdev = ir->cdev;
+	cdev = d->cdev;
 
 	mutex_lock(&lirc_dev_lock);
 
-	if (ir->d.minor != minor) {
-		dev_err(ir->d.dev, "lirc_dev: minor %d device not registered\n",
-									minor);
+	if (d->minor != minor) {
+		dev_err(d->dev, "lirc_dev: minor %d device not registered\n",
+			minor);
 		mutex_unlock(&lirc_dev_lock);
 		return -ENOENT;
 	}
 
 	/* end up polling thread */
-	if (ir->task)
-		kthread_stop(ir->task);
+	if (d->task)
+		kthread_stop(d->task);
 
-	dev_dbg(ir->d.dev, "lirc_dev: driver %s unregistered from minor = %d\n",
-		ir->d.name, ir->d.minor);
+	dev_dbg(d->dev, "lirc_dev: driver %s unregistered from minor = %d\n",
+		d->name, d->minor);
 
-	ir->attached = 0;
-	if (ir->open) {
-		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
-			ir->d.name, ir->d.minor);
-		wake_up_interruptible(&ir->buf->wait_poll);
-		mutex_lock(&ir->irctl_lock);
+	d->attached = 0;
+	if (d->open) {
+		dev_dbg(d->dev, LOGHEAD "releasing opened driver\n",
+			d->name, d->minor);
+		wake_up_interruptible(&d->buf->wait_poll);
+		mutex_lock(&d->irctl_lock);
 
-		if (ir->d.set_use_dec)
-			ir->d.set_use_dec(ir->d.data);
+		if (d->set_use_dec)
+			d->set_use_dec(d->data);
 
 		module_put(cdev->owner);
-		mutex_unlock(&ir->irctl_lock);
+		mutex_unlock(&d->irctl_lock);
 	} else {
-		lirc_irctl_cleanup(ir);
+		lirc_irctl_cleanup(d);
 		cdev_del(cdev);
-		kfree(ir);
+		kfree(d);
 		irctls[minor] = NULL;
 	}
 
@@ -425,7 +393,7 @@ EXPORT_SYMBOL(lirc_unregister_driver);
 
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
-	struct irctl *ir;
+	struct lirc_driver *d;
 	struct cdev *cdev;
 	int retval = 0;
 
@@ -437,44 +405,44 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 	if (mutex_lock_interruptible(&lirc_dev_lock))
 		return -ERESTARTSYS;
 
-	ir = irctls[iminor(inode)];
-	if (!ir) {
+	d = irctls[iminor(inode)];
+	if (!d) {
 		retval = -ENODEV;
 		goto error;
 	}
 
-	dev_dbg(ir->d.dev, LOGHEAD "open called\n", ir->d.name, ir->d.minor);
+	dev_dbg(d->dev, LOGHEAD "open called\n", d->name, d->minor);
 
-	if (ir->d.minor == NOPLUG) {
+	if (d->minor == NOPLUG) {
 		retval = -ENODEV;
 		goto error;
 	}
 
-	if (ir->open) {
+	if (d->open) {
 		retval = -EBUSY;
 		goto error;
 	}
 
-	if (ir->d.rdev) {
-		retval = rc_open(ir->d.rdev);
+	if (d->rdev) {
+		retval = rc_open(d->rdev);
 		if (retval)
 			goto error;
 	}
 
-	cdev = ir->cdev;
+	cdev = d->cdev;
 	if (try_module_get(cdev->owner)) {
-		ir->open++;
-		if (ir->d.set_use_inc)
-			retval = ir->d.set_use_inc(ir->d.data);
+		d->open++;
+		if (d->set_use_inc)
+			retval = d->set_use_inc(d->data);
 
 		if (retval) {
 			module_put(cdev->owner);
-			ir->open--;
+			d->open--;
 		} else {
-			lirc_buffer_clear(ir->buf);
+			lirc_buffer_clear(d->buf);
 		}
-		if (ir->task)
-			wake_up_process(ir->task);
+		if (d->task)
+			wake_up_process(d->task);
 	}
 
 error:
@@ -488,32 +456,32 @@ EXPORT_SYMBOL(lirc_dev_fop_open);
 
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
-	struct irctl *ir = irctls[iminor(inode)];
+	struct lirc_driver *d = irctls[iminor(inode)];
 	struct cdev *cdev;
 	int ret;
 
-	if (!ir) {
+	if (!d) {
 		pr_err("called with invalid irctl\n");
 		return -EINVAL;
 	}
 
-	cdev = ir->cdev;
+	cdev = d->cdev;
 
 	ret = mutex_lock_killable(&lirc_dev_lock);
 	WARN_ON(ret);
 
-	rc_close(ir->d.rdev);
+	rc_close(d->rdev);
 
-	ir->open--;
-	if (ir->attached) {
-		if (ir->d.set_use_dec)
-			ir->d.set_use_dec(ir->d.data);
+	d->open--;
+	if (d->attached) {
+		if (d->set_use_dec)
+			d->set_use_dec(d->data);
 		module_put(cdev->owner);
 	} else {
-		lirc_irctl_cleanup(ir);
+		lirc_irctl_cleanup(d);
 		cdev_del(cdev);
-		irctls[ir->d.minor] = NULL;
-		kfree(ir);
+		irctls[d->minor] = NULL;
+		kfree(d);
 	}
 
 	if (!ret)
@@ -525,29 +493,30 @@ EXPORT_SYMBOL(lirc_dev_fop_close);
 
 unsigned int lirc_dev_fop_poll(struct file *file, poll_table *wait)
 {
-	struct irctl *ir = irctls[iminor(file_inode(file))];
+	struct lirc_driver *d = irctls[iminor(file_inode(file))];
 	unsigned int ret;
 
-	if (!ir) {
+	if (!d) {
 		pr_err("called with invalid irctl\n");
 		return POLLERR;
 	}
 
-	if (!ir->attached)
+	if (!d->attached)
 		return POLLERR;
 
-	if (ir->buf) {
-		poll_wait(file, &ir->buf->wait_poll, wait);
+	if (d->buf) {
+		poll_wait(file, &d->buf->wait_poll, wait);
 
-		if (lirc_buffer_empty(ir->buf))
+		if (lirc_buffer_empty(d->buf))
 			ret = 0;
 		else
 			ret = POLLIN | POLLRDNORM;
-	} else
+	} else {
 		ret = POLLERR;
+	}
 
-	dev_dbg(ir->d.dev, LOGHEAD "poll result = %d\n",
-		ir->d.name, ir->d.minor, ret);
+	dev_dbg(d->dev, LOGHEAD "poll result = %d\n",
+		d->name, d->minor, ret);
 
 	return ret;
 }
@@ -557,46 +526,46 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	__u32 mode;
 	int result = 0;
-	struct irctl *ir = irctls[iminor(file_inode(file))];
+	struct lirc_driver *d = irctls[iminor(file_inode(file))];
 
-	if (!ir) {
+	if (!d) {
 		pr_err("no irctl found!\n");
 		return -ENODEV;
 	}
 
-	dev_dbg(ir->d.dev, LOGHEAD "ioctl called (0x%x)\n",
-		ir->d.name, ir->d.minor, cmd);
+	dev_dbg(d->dev, LOGHEAD "ioctl called (0x%x)\n",
+		d->name, d->minor, cmd);
 
-	if (ir->d.minor == NOPLUG || !ir->attached) {
-		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
-			ir->d.name, ir->d.minor);
+	if (d->minor == NOPLUG || !d->attached) {
+		dev_err(d->dev, LOGHEAD "ioctl result = -ENODEV\n",
+			d->name, d->minor);
 		return -ENODEV;
 	}
 
-	mutex_lock(&ir->irctl_lock);
+	mutex_lock(&d->irctl_lock);
 
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
@@ -604,31 +573,31 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		 */
 		break;
 	case LIRC_GET_LENGTH:
-		result = put_user(ir->d.code_length, (__u32 __user *)arg);
+		result = put_user(d->code_length, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_MIN_TIMEOUT:
-		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
-		    ir->d.min_timeout == 0) {
+		if (!(d->features & LIRC_CAN_SET_REC_TIMEOUT) ||
+		    d->min_timeout == 0) {
 			result = -ENOTTY;
 			break;
 		}
 
-		result = put_user(ir->d.min_timeout, (__u32 __user *)arg);
+		result = put_user(d->min_timeout, (__u32 __user *)arg);
 		break;
 	case LIRC_GET_MAX_TIMEOUT:
-		if (!(ir->d.features & LIRC_CAN_SET_REC_TIMEOUT) ||
-		    ir->d.max_timeout == 0) {
+		if (!(d->features & LIRC_CAN_SET_REC_TIMEOUT) ||
+		    d->max_timeout == 0) {
 			result = -ENOTTY;
 			break;
 		}
 
-		result = put_user(ir->d.max_timeout, (__u32 __user *)arg);
+		result = put_user(d->max_timeout, (__u32 __user *)arg);
 		break;
 	default:
 		result = -EINVAL;
 	}
 
-	mutex_unlock(&ir->irctl_lock);
+	mutex_unlock(&d->irctl_lock);
 
 	return result;
 }
@@ -639,32 +608,32 @@ ssize_t lirc_dev_fop_read(struct file *file,
 			  size_t length,
 			  loff_t *ppos)
 {
-	struct irctl *ir = irctls[iminor(file_inode(file))];
+	struct lirc_driver *d = irctls[iminor(file_inode(file))];
 	unsigned char *buf;
 	int ret = 0, written = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
-	if (!ir) {
+	if (!d) {
 		pr_err("called with invalid irctl\n");
 		return -ENODEV;
 	}
 
-	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
+	dev_dbg(d->dev, LOGHEAD "read called\n", d->name, d->minor);
 
-	buf = kzalloc(ir->chunk_size, GFP_KERNEL);
+	buf = kzalloc(d->chunk_size, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	if (mutex_lock_interruptible(&ir->irctl_lock)) {
+	if (mutex_lock_interruptible(&d->irctl_lock)) {
 		ret = -ERESTARTSYS;
 		goto out_unlocked;
 	}
-	if (!ir->attached) {
+	if (!d->attached) {
 		ret = -ENODEV;
 		goto out_locked;
 	}
 
-	if (length % ir->chunk_size) {
+	if (length % d->chunk_size) {
 		ret = -EINVAL;
 		goto out_locked;
 	}
@@ -674,14 +643,14 @@ ssize_t lirc_dev_fop_read(struct file *file,
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
@@ -698,36 +667,36 @@ ssize_t lirc_dev_fop_read(struct file *file,
 				break;
 			}
 
-			mutex_unlock(&ir->irctl_lock);
+			mutex_unlock(&d->irctl_lock);
 			set_current_state(TASK_INTERRUPTIBLE);
 			schedule();
 			set_current_state(TASK_RUNNING);
 
-			if (mutex_lock_interruptible(&ir->irctl_lock)) {
+			if (mutex_lock_interruptible(&d->irctl_lock)) {
 				ret = -ERESTARTSYS;
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
-	mutex_unlock(&ir->irctl_lock);
+	mutex_unlock(&d->irctl_lock);
 
 out_unlocked:
 	kfree(buf);
@@ -738,7 +707,7 @@ EXPORT_SYMBOL(lirc_dev_fop_read);
 
 void *lirc_get_pdata(struct file *file)
 {
-	return irctls[iminor(file_inode(file))]->d.data;
+	return irctls[iminor(file_inode(file))]->data;
 }
 EXPORT_SYMBOL(lirc_get_pdata);
 
@@ -746,14 +715,14 @@ EXPORT_SYMBOL(lirc_get_pdata);
 ssize_t lirc_dev_fop_write(struct file *file, const char __user *buffer,
 			   size_t length, loff_t *ppos)
 {
-	struct irctl *ir = irctls[iminor(file_inode(file))];
+	struct lirc_driver *d = irctls[iminor(file_inode(file))];
 
-	if (!ir) {
+	if (!d) {
 		pr_err("called with invalid irctl\n");
 		return -ENODEV;
 	}
 
-	if (!ir->attached)
+	if (!d->attached)
 		return -ENODEV;
 
 	return -EINVAL;
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index b0c176e..dd9c877 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -167,7 +167,6 @@ static void delete_context(struct sasem_context *context)
 	usb_free_urb(context->rx_urb);  /* IR */
 	lirc_buffer_free(context->driver->rbuf);
 	kfree(context->driver->rbuf);
-	kfree(context->driver);
 	kfree(context);
 }
 
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index cec7d35..aa4ec34 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -182,6 +182,20 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
  *			device.
  *
  * @owner:		the module owning this struct
+ *
+ * @attached:		1 if the device is still attached, 0 otherwise
+ *
+ * @open:		1 if the lirc char device has been opened
+ *
+ * @irctl_lock:		mutex for the structure
+ *
+ * @buf:		read buffer used if rbuf is not set
+ *
+ * @cdev:		the char device structure
+ *
+ * @task:		thread performing read polling, if present
+ *
+ * @jiffies_to_wait:	jiffies to sleep in read polling thread
  */
 struct lirc_driver {
 	char name[40];
@@ -204,6 +218,17 @@ struct lirc_driver {
 	const struct file_operations *fops;
 	struct device *dev;
 	struct module *owner;
+
+	int attached;
+	int open;
+
+	struct mutex irctl_lock;
+	struct lirc_buffer *buf;
+
+	struct cdev *cdev;
+
+	struct task_struct *task;
+	long jiffies_to_wait;
 };
 
 /* following functions can be called ONLY from user context
-- 
2.9.3

