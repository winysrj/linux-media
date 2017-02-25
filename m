Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:40649 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751231AbdBYMWI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Feb 2017 07:22:08 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v3 12/19] [media] lirc: exorcise struct irctl
Date: Sat, 25 Feb 2017 11:51:27 +0000
Message-Id: <2dda8e75a2827d44117860b1798c27b8df517711.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
In-Reply-To: <cover.1488023302.git.sean@mess.org>
References: <cover.1488023302.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

lirc_register_driver() takes a struct lirc_driver argument, it then
allocates a new struct irctl which contains another struct lirc_driver
and then copies it over.

By moving the members of struct irctl to struct lirc_driver, we avoid the
extra allocation and we can remove struct irctl completely. We also
remove the duplicate chunk_size member.

In addition, the members of irctl are now visible elsewhere.

Tested send, receive and rmmod with lirc_zilog and various rc-core
devices.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/ir-lirc-codec.c        |   3 +-
 drivers/media/rc/lirc_dev.c             | 353 +++++++++++++++-----------------
 drivers/staging/media/lirc/lirc_sasem.c |   3 +-
 drivers/staging/media/lirc/lirc_zilog.c | 167 ++++++++-------
 include/media/lirc_dev.h                |  33 ++-
 5 files changed, 288 insertions(+), 271 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 16ac65a..78f354a 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -407,7 +407,7 @@ int ir_lirc_register(struct rc_dev *dev)
 	drv->set_use_dec = &ir_lirc_close;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
 	drv->fops = &lirc_fops;
-	drv->dev = &dev->dev;
+	drv->dev.parent = &dev->dev;
 	drv->rdev = dev;
 	drv->owner = THIS_MODULE;
 
@@ -437,5 +437,4 @@ void ir_lirc_unregister(struct rc_dev *dev)
 	lirc_unregister_driver(lirc->drv->minor);
 	lirc_buffer_free(lirc->drv->rbuf);
 	kfree(lirc->drv->rbuf);
-	kfree(lirc->drv);
 }
diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 26e1983..44650e4 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -43,25 +43,9 @@
 
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
-	struct device dev;
-	struct cdev cdev;
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
@@ -69,39 +53,39 @@ static struct class *lirc_class;
 /*  helper function
  *  initializes the irctl structure
  */
-static void lirc_irctl_init(struct irctl *ir)
+static void lirc_irctl_init(struct lirc_driver *d)
 {
-	mutex_init(&ir->irctl_lock);
-	ir->d.minor = NOPLUG;
+	mutex_init(&d->irctl_lock);
+	d->minor = NOPLUG;
 }
 
 static void lirc_release(struct device *ld)
 {
-	struct irctl *ir = container_of(ld, struct irctl, dev);
+	struct lirc_driver *d = container_of(ld, struct lirc_driver, dev);
 
-	put_device(ir->dev.parent);
+	put_device(d->dev.parent);
 
-	if (ir->buf != ir->d.rbuf) {
-		lirc_buffer_free(ir->buf);
-		kfree(ir->buf);
+	if (d->buf != d->rbuf) {
+		lirc_buffer_free(d->buf);
+		kfree(d->buf);
 	}
 
 	mutex_lock(&lirc_dev_lock);
-	irctls[ir->d.minor] = NULL;
+	irctls[d->minor] = NULL;
 	mutex_unlock(&lirc_dev_lock);
-	kfree(ir);
+	kfree(d);
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
@@ -110,31 +94,31 @@ static int lirc_add_to_buf(struct irctl *ir)
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
@@ -144,7 +128,6 @@ static int lirc_thread(void *irctl)
 	return 0;
 }
 
-
 static const struct file_operations lirc_dev_fops = {
 	.owner		= THIS_MODULE,
 	.read		= lirc_dev_fop_read,
@@ -156,13 +139,12 @@ static const struct file_operations lirc_dev_fops = {
 	.llseek		= noop_llseek,
 };
 
-static int lirc_cdev_add(struct irctl *ir)
+static int lirc_cdev_add(struct lirc_driver *d)
 {
-	struct lirc_driver *d = &ir->d;
 	struct cdev *cdev;
 	int retval;
 
-	cdev = &ir->cdev;
+	cdev = &d->cdev;
 
 	if (d->fops) {
 		cdev_init(cdev, d->fops);
@@ -175,17 +157,16 @@ static int lirc_cdev_add(struct irctl *ir)
 	if (retval)
 		return retval;
 
-	cdev->kobj.parent = &ir->dev.kobj;
-	return cdev_add(cdev, ir->dev.devt, 1);
+	cdev->kobj.parent = &d->dev.kobj;
+	return cdev_add(cdev, d->dev.devt, 1);
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
 
@@ -195,21 +176,21 @@ static int lirc_allocate_buffer(struct irctl *ir)
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
@@ -219,7 +200,6 @@ static int lirc_allocate_buffer(struct irctl *ir)
 
 static int lirc_allocate_driver(struct lirc_driver *d)
 {
-	struct irctl *ir;
 	int minor;
 	int err;
 
@@ -228,36 +208,36 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 		return -EBADRQC;
 	}
 
-	if (!d->dev) {
+	if (!d->dev.parent) {
 		pr_err("dev pointer not filled in!\n");
 		return -EINVAL;
 	}
 
 	if (d->minor >= MAX_IRCTL_DEVICES) {
-		dev_err(d->dev, "minor must be between 0 and %d!\n",
-						MAX_IRCTL_DEVICES - 1);
+		dev_err(d->dev.parent, "minor must be between 0 and %d!\n",
+			MAX_IRCTL_DEVICES - 1);
 		return -EBADRQC;
 	}
 
 	if (d->code_length < 1 || d->code_length > (BUFLEN * 8)) {
-		dev_err(d->dev, "code length must be less than %d bits\n",
-								BUFLEN * 8);
+		dev_err(d->dev.parent, "code length must be less than %d bits\n",
+			BUFLEN * 8);
 		return -EBADRQC;
 	}
 
 	if (d->sample_rate) {
 		if (2 > d->sample_rate || HZ < d->sample_rate) {
-			dev_err(d->dev, "invalid %d sample rate\n",
-							d->sample_rate);
+			dev_err(d->dev.parent, "invalid %d sample rate\n",
+				d->sample_rate);
 			return -EBADRQC;
 		}
 		if (!d->add_to_buf) {
-			dev_err(d->dev, "add_to_buf not set\n");
+			dev_err(d->dev.parent, "add_to_buf not set\n");
 			return -EBADRQC;
 		}
 	} else if (!d->rbuf && !(d->fops && d->fops->read &&
 				d->fops->poll && d->fops->unlocked_ioctl)) {
-		dev_err(d->dev, "undefined read, poll, ioctl\n");
+		dev_err(d->dev.parent, "undefined read, poll, ioctl\n");
 		return -EBADRQC;
 	}
 
@@ -271,23 +251,18 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 			if (!irctls[minor])
 				break;
 		if (minor == MAX_IRCTL_DEVICES) {
-			dev_err(d->dev, "no free slots for drivers!\n");
+			dev_err(d->dev.parent, "no free slots for drivers!\n");
 			err = -ENOMEM;
 			goto out_lock;
 		}
 	} else if (irctls[minor]) {
-		dev_err(d->dev, "minor (%d) just registered!\n", minor);
+		dev_err(d->dev.parent, "minor (%d) just registered!\n", minor);
 		err = -EBUSY;
 		goto out_lock;
 	}
 
-	ir = kzalloc(sizeof(struct irctl), GFP_KERNEL);
-	if (!ir) {
-		err = -ENOMEM;
-		goto out_lock;
-	}
-	lirc_irctl_init(ir);
-	irctls[minor] = ir;
+	lirc_irctl_init(d);
+	irctls[minor] = d;
 	d->minor = minor;
 
 	/* some safety check 8-) */
@@ -296,52 +271,49 @@ static int lirc_allocate_driver(struct lirc_driver *d)
 	if (d->features == 0)
 		d->features = LIRC_CAN_REC_LIRCCODE;
 
-	ir->d = *d;
-
-	ir->dev.devt = MKDEV(MAJOR(lirc_base_dev), ir->d.minor);
-	ir->dev.class = lirc_class;
-	ir->dev.parent = d->dev;
-	ir->dev.release = lirc_release;
-	dev_set_name(&ir->dev, "lirc%d", ir->d.minor);
-	device_initialize(&ir->dev);
+	d->dev.devt = MKDEV(MAJOR(lirc_base_dev), d->minor);
+	d->dev.class = lirc_class;
+	d->dev.release = lirc_release;
+	dev_set_name(&d->dev, "lirc%d", d->minor);
+	device_initialize(&d->dev);
 
 	if (d->sample_rate) {
-		ir->jiffies_to_wait = HZ / d->sample_rate;
+		d->jiffies_to_wait = HZ / d->sample_rate;
 
 		/* try to fire up polling thread */
-		ir->task = kthread_run(lirc_thread, (void *)ir, "lirc_dev");
-		if (IS_ERR(ir->task)) {
-			dev_err(d->dev, "cannot run thread for minor = %d\n",
-								d->minor);
+		d->task = kthread_run(lirc_thread, d, "lirc_dev");
+		if (IS_ERR(d->task)) {
+			dev_err(d->dev.parent, "cannot run thread for minor = %d\n",
+				d->minor);
 			err = -ECHILD;
 			goto out_sysfs;
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
 
-	err = device_add(&ir->dev);
+	err = device_add(&d->dev);
 	if (err)
 		goto out_cdev;
 
 	mutex_unlock(&lirc_dev_lock);
 
-	get_device(ir->dev.parent);
+	get_device(d->dev.parent);
 
-	dev_info(ir->d.dev, "lirc_dev: driver %s registered at minor = %d\n",
-		 ir->d.name, ir->d.minor);
+	dev_info(d->dev.parent, "lirc_dev: driver %s registered at minor = %d\n",
+		 d->name, d->minor);
 	return minor;
 out_cdev:
-	cdev_del(&ir->cdev);
+	cdev_del(&d->cdev);
 out_sysfs:
-	put_device(&ir->dev);
+	put_device(&d->dev);
 out_lock:
 	mutex_unlock(&lirc_dev_lock);
 
@@ -368,7 +340,7 @@ EXPORT_SYMBOL(lirc_register_driver);
 
 int lirc_unregister_driver(int minor)
 {
-	struct irctl *ir;
+	struct lirc_driver *d;
 
 	if (minor < 0 || minor >= MAX_IRCTL_DEVICES) {
 		pr_err("minor (%d) must be between 0 and %d!\n",
@@ -376,46 +348,46 @@ int lirc_unregister_driver(int minor)
 		return -EBADRQC;
 	}
 
-	ir = irctls[minor];
-	if (!ir) {
+	d = irctls[minor];
+	if (!d) {
 		pr_err("failed to get irctl\n");
 		return -ENOENT;
 	}
 
 	mutex_lock(&lirc_dev_lock);
 
-	if (ir->d.minor != minor) {
-		dev_err(ir->d.dev, "lirc_dev: minor %d device not registered\n",
-									minor);
+	if (d->minor != minor) {
+		dev_err(d->dev.parent, "lirc_dev: minor %d device not registered\n",
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
+	dev_dbg(d->dev.parent, "lirc_dev: driver %s unregistered from minor = %d\n",
+		d->name, d->minor);
 
-	ir->attached = 0;
-	if (ir->open) {
-		dev_dbg(ir->d.dev, LOGHEAD "releasing opened driver\n",
-			ir->d.name, ir->d.minor);
-		wake_up_interruptible(&ir->buf->wait_poll);
+	d->attached = 0;
+	if (d->open) {
+		dev_dbg(d->dev.parent, LOGHEAD "releasing opened driver\n",
+			d->name, d->minor);
+		wake_up_interruptible(&d->buf->wait_poll);
 	}
 
-	mutex_lock(&ir->irctl_lock);
+	mutex_lock(&d->irctl_lock);
 
-	if (ir->d.set_use_dec)
-		ir->d.set_use_dec(ir->d.data);
+	if (d->set_use_dec)
+		d->set_use_dec(d->data);
 
-	mutex_unlock(&ir->irctl_lock);
+	mutex_unlock(&d->irctl_lock);
 	mutex_unlock(&lirc_dev_lock);
 
-	device_del(&ir->dev);
-	cdev_del(&ir->cdev);
-	put_device(&ir->dev);
+	device_del(&d->dev);
+	cdev_del(&d->cdev);
+	put_device(&d->dev);
 
 	return 0;
 }
@@ -423,7 +395,7 @@ EXPORT_SYMBOL(lirc_unregister_driver);
 
 int lirc_dev_fop_open(struct inode *inode, struct file *file)
 {
-	struct irctl *ir;
+	struct lirc_driver *d;
 	int retval = 0;
 
 	if (iminor(inode) >= MAX_IRCTL_DEVICES) {
@@ -434,40 +406,40 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
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
+	dev_dbg(d->dev.parent, LOGHEAD "open called\n", d->name, d->minor);
 
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
 
-	ir->open++;
-	if (ir->d.set_use_inc)
-		retval = ir->d.set_use_inc(ir->d.data);
+	d->open++;
+	if (d->set_use_inc)
+		retval = d->set_use_inc(d->data);
 	if (retval) {
-		ir->open--;
+		d->open--;
 	} else {
-		if (ir->buf)
-			lirc_buffer_clear(ir->buf);
-		if (ir->task)
-			wake_up_process(ir->task);
+		if (d->buf)
+			lirc_buffer_clear(d->buf);
+		if (d->task)
+			wake_up_process(d->task);
 	}
 
 error:
@@ -481,10 +453,10 @@ EXPORT_SYMBOL(lirc_dev_fop_open);
 
 int lirc_dev_fop_close(struct inode *inode, struct file *file)
 {
-	struct irctl *ir = irctls[iminor(inode)];
+	struct lirc_driver *d = irctls[iminor(inode)];
 	int ret;
 
-	if (!ir) {
+	if (!d) {
 		pr_err("called with invalid irctl\n");
 		return -EINVAL;
 	}
@@ -492,11 +464,11 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 	ret = mutex_lock_killable(&lirc_dev_lock);
 	WARN_ON(ret);
 
-	rc_close(ir->d.rdev);
+	rc_close(d->rdev);
 
-	ir->open--;
-	if (ir->d.set_use_dec)
-		ir->d.set_use_dec(ir->d.data);
+	d->open--;
+	if (d->set_use_dec)
+		d->set_use_dec(d->data);
 	if (!ret)
 		mutex_unlock(&lirc_dev_lock);
 
@@ -506,29 +478,30 @@ EXPORT_SYMBOL(lirc_dev_fop_close);
 
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
+	dev_dbg(d->dev.parent, LOGHEAD "poll result = %d\n",
+		d->name, d->minor, ret);
 
 	return ret;
 }
@@ -538,46 +511,46 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
+	dev_dbg(d->dev.parent, LOGHEAD "ioctl called (0x%x)\n",
+		d->name, d->minor, cmd);
 
-	if (ir->d.minor == NOPLUG || !ir->attached) {
-		dev_err(ir->d.dev, LOGHEAD "ioctl result = -ENODEV\n",
-			ir->d.name, ir->d.minor);
+	if (d->minor == NOPLUG || !d->attached) {
+		dev_err(d->dev.parent, LOGHEAD "ioctl result = -ENODEV\n",
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
@@ -585,31 +558,31 @@ long lirc_dev_fop_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
 		result = -ENOTTY;
 	}
 
-	mutex_unlock(&ir->irctl_lock);
+	mutex_unlock(&d->irctl_lock);
 
 	return result;
 }
@@ -620,35 +593,35 @@ ssize_t lirc_dev_fop_read(struct file *file,
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
 
-	if (!LIRC_CAN_REC(ir->d.features))
+	if (!LIRC_CAN_REC(d->features))
 		return -EINVAL;
 
-	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
+	dev_dbg(d->dev.parent, LOGHEAD "read called\n", d->name, d->minor);
 
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
@@ -658,14 +631,14 @@ ssize_t lirc_dev_fop_read(struct file *file,
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
@@ -682,36 +655,36 @@ ssize_t lirc_dev_fop_read(struct file *file,
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
@@ -722,7 +695,7 @@ EXPORT_SYMBOL(lirc_dev_fop_read);
 
 void *lirc_get_pdata(struct file *file)
 {
-	return irctls[iminor(file_inode(file))]->d.data;
+	return irctls[iminor(file_inode(file))]->data;
 }
 EXPORT_SYMBOL(lirc_get_pdata);
 
@@ -730,14 +703,14 @@ EXPORT_SYMBOL(lirc_get_pdata);
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
index b0c176e..583e12e 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -167,7 +167,6 @@ static void delete_context(struct sasem_context *context)
 	usb_free_urb(context->rx_urb);  /* IR */
 	lirc_buffer_free(context->driver->rbuf);
 	kfree(context->driver->rbuf);
-	kfree(context->driver);
 	kfree(context);
 }
 
@@ -771,7 +770,7 @@ static int sasem_probe(struct usb_interface *interface,
 	driver->rbuf = rbuf;
 	driver->set_use_inc = ir_open;
 	driver->set_use_dec = ir_close;
-	driver->dev   = &interface->dev;
+	driver->dev.parent = &interface->dev;
 	driver->owner = THIS_MODULE;
 
 	mutex_lock(&context->ctx_lock);
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 34aac3e..5deb67db 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -100,7 +100,7 @@ struct IR {
 	struct list_head list;
 
 	/* FIXME spinlock access to l.features */
-	struct lirc_driver l;
+	struct lirc_driver *l;
 	struct lirc_buffer rbuf;
 
 	struct mutex ir_lock;
@@ -184,9 +184,9 @@ static void release_ir_device(struct kref *ref)
 	 * ir->open_count ==  0 - happens on final close()
 	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
 	 */
-	if (ir->l.minor >= 0 && ir->l.minor < MAX_IRCTL_DEVICES) {
-		lirc_unregister_driver(ir->l.minor);
-		ir->l.minor = MAX_IRCTL_DEVICES;
+	if (ir->l->minor >= 0 && ir->l->minor < MAX_IRCTL_DEVICES) {
+		lirc_unregister_driver(ir->l->minor);
+		ir->l->minor = MAX_IRCTL_DEVICES;
 	}
 	if (kfifo_initialized(&ir->rbuf.fifo))
 		lirc_buffer_free(&ir->rbuf);
@@ -243,7 +243,7 @@ static void release_ir_rx(struct kref *ref)
 	 * and releasing the ir reference can cause a sleep.  That work is
 	 * performed by put_ir_rx()
 	 */
-	ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
+	ir->l->features &= ~LIRC_CAN_REC_LIRCCODE;
 	/* Don't put_ir_device(rx->ir) here; lock can't be freed yet */
 	ir->rx = NULL;
 	/* Don't do the kfree(rx) here; we still need to kill the poll thread */
@@ -288,7 +288,7 @@ static void release_ir_tx(struct kref *ref)
 	struct IR_tx *tx = container_of(ref, struct IR_tx, ref);
 	struct IR *ir = tx->ir;
 
-	ir->l.features &= ~LIRC_CAN_SEND_PULSE;
+	ir->l->features &= ~LIRC_CAN_SEND_PULSE;
 	/* Don't put_ir_device(tx->ir) here, so our lock doesn't get freed */
 	ir->tx = NULL;
 	kfree(tx);
@@ -317,12 +317,12 @@ static int add_to_buf(struct IR *ir)
 	int ret;
 	int failures = 0;
 	unsigned char sendbuf[1] = { 0 };
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 	struct IR_rx *rx;
 	struct IR_tx *tx;
 
 	if (lirc_buffer_full(rbuf)) {
-		dev_dbg(ir->l.dev, "buffer overflow\n");
+		dev_dbg(&ir->adapter->dev, "buffer overflow\n");
 		return -EOVERFLOW;
 	}
 
@@ -368,17 +368,17 @@ static int add_to_buf(struct IR *ir)
 		 */
 		ret = i2c_master_send(rx->c, sendbuf, 1);
 		if (ret != 1) {
-			dev_err(ir->l.dev, "i2c_master_send failed with %d\n",
+			dev_err(&ir->adapter->dev, "i2c_master_send failed with %d\n",
 				ret);
 			if (failures >= 3) {
 				mutex_unlock(&ir->ir_lock);
-				dev_err(ir->l.dev,
+				dev_err(&ir->adapter->dev,
 					"unable to read from the IR chip after 3 resets, giving up\n");
 				break;
 			}
 
 			/* Looks like the chip crashed, reset it */
-			dev_err(ir->l.dev,
+			dev_err(&ir->adapter->dev,
 				"polling the IR receiver chip failed, trying reset\n");
 
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -405,14 +405,14 @@ static int add_to_buf(struct IR *ir)
 		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
 		mutex_unlock(&ir->ir_lock);
 		if (ret != sizeof(keybuf)) {
-			dev_err(ir->l.dev,
+			dev_err(&ir->adapter->dev,
 				"i2c_master_recv failed with %d -- keeping last read buffer\n",
 				ret);
 		} else {
 			rx->b[0] = keybuf[3];
 			rx->b[1] = keybuf[4];
 			rx->b[2] = keybuf[5];
-			dev_dbg(ir->l.dev,
+			dev_dbg(&ir->adapter->dev,
 				"key (0x%02x/0x%02x)\n",
 				rx->b[0], rx->b[1]);
 		}
@@ -463,9 +463,9 @@ static int add_to_buf(struct IR *ir)
 static int lirc_thread(void *arg)
 {
 	struct IR *ir = arg;
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 
-	dev_dbg(ir->l.dev, "poll thread started\n");
+	dev_dbg(&ir->adapter->dev, "poll thread started\n");
 
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -493,7 +493,7 @@ static int lirc_thread(void *arg)
 			wake_up_interruptible(&rbuf->wait_poll);
 	}
 
-	dev_dbg(ir->l.dev, "poll thread ended\n");
+	dev_dbg(&ir->adapter->dev, "poll thread ended\n");
 	return 0;
 }
 
@@ -655,10 +655,10 @@ static int send_data_block(struct IR_tx *tx, unsigned char *data_block)
 		buf[0] = (unsigned char)(i + 1);
 		for (j = 0; j < tosend; ++j)
 			buf[1 + j] = data_block[i + j];
-		dev_dbg(tx->ir->l.dev, "%*ph", 5, buf);
+		dev_dbg(&tx->ir->adapter->dev, "%*ph", 5, buf);
 		ret = i2c_master_send(tx->c, buf, tosend + 1);
 		if (ret != tosend + 1) {
-			dev_err(tx->ir->l.dev,
+			dev_err(&tx->ir->adapter->dev,
 				"i2c_master_send failed with %d\n", ret);
 			return ret < 0 ? ret : -EFAULT;
 		}
@@ -683,7 +683,8 @@ static int send_boot_data(struct IR_tx *tx)
 	buf[1] = 0x20;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -700,22 +701,24 @@ static int send_boot_data(struct IR_tx *tx)
 	}
 
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Here comes the firmware version... (hopefully) */
 	ret = i2c_master_recv(tx->c, buf, 4);
 	if (ret != 4) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_recv failed with %d\n",
+			ret);
 		return 0;
 	}
 	if ((buf[0] != 0x80) && (buf[0] != 0xa0)) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX init response: %02x\n",
+		dev_err(&tx->ir->adapter->dev, "unexpected IR TX init response: %02x\n",
 			buf[0]);
 		return 0;
 	}
-	dev_notice(tx->ir->l.dev,
+	dev_notice(&tx->ir->adapter->dev,
 		   "Zilog/Hauppauge IR blaster firmware version %d.%d.%d loaded\n",
 		   buf[1], buf[2], buf[3]);
 
@@ -760,15 +763,17 @@ static int fw_load(struct IR_tx *tx)
 	}
 
 	/* Request codeset data file */
-	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", tx->ir->l.dev);
+	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin",
+			       &tx->ir->adapter->dev);
 	if (ret != 0) {
-		dev_err(tx->ir->l.dev,
+		dev_err(&tx->ir->adapter->dev,
 			"firmware haup-ir-blaster.bin not available (%d)\n",
 			ret);
 		ret = ret < 0 ? ret : -EFAULT;
 		goto out;
 	}
-	dev_dbg(tx->ir->l.dev, "firmware of size %zu loaded\n", fw_entry->size);
+	dev_dbg(&tx->ir->adapter->dev, "firmware of size %zu loaded\n",
+		fw_entry->size);
 
 	/* Parse the file */
 	tx_data = vmalloc(sizeof(*tx_data));
@@ -796,7 +801,7 @@ static int fw_load(struct IR_tx *tx)
 	if (!read_uint8(&data, tx_data->endp, &version))
 		goto corrupt;
 	if (version != 1) {
-		dev_err(tx->ir->l.dev,
+		dev_err(&tx->ir->adapter->dev,
 			"unsupported code set file version (%u, expected 1) -- please upgrade to a newer driver\n",
 			version);
 		fw_unload_locked();
@@ -813,7 +818,7 @@ static int fw_load(struct IR_tx *tx)
 			      &tx_data->num_code_sets))
 		goto corrupt;
 
-	dev_dbg(tx->ir->l.dev, "%u IR blaster codesets loaded\n",
+	dev_dbg(&tx->ir->adapter->dev, "%u IR blaster codesets loaded\n",
 		tx_data->num_code_sets);
 
 	tx_data->code_sets = vmalloc(
@@ -878,7 +883,7 @@ static int fw_load(struct IR_tx *tx)
 	goto out;
 
 corrupt:
-	dev_err(tx->ir->l.dev, "firmware is corrupt\n");
+	dev_err(&tx->ir->adapter->dev, "firmware is corrupt\n");
 	fw_unload_locked();
 	ret = -EFAULT;
 
@@ -893,14 +898,14 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 {
 	struct IR *ir = filep->private_data;
 	struct IR_rx *rx;
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 	int ret = 0, written = 0, retries = 0;
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
 
-	dev_dbg(ir->l.dev, "read called\n");
+	dev_dbg(&ir->adapter->dev, "read called\n");
 	if (n % rbuf->chunk_size) {
-		dev_dbg(ir->l.dev, "read result = -EINVAL\n");
+		dev_dbg(&ir->adapter->dev, "read result = -EINVAL\n");
 		return -EINVAL;
 	}
 
@@ -944,7 +949,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 			unsigned char buf[MAX_XFER_SIZE];
 
 			if (rbuf->chunk_size > sizeof(buf)) {
-				dev_err(ir->l.dev,
+				dev_err(&ir->adapter->dev,
 					"chunk_size is too big (%d)!\n",
 					rbuf->chunk_size);
 				ret = -EINVAL;
@@ -959,7 +964,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 				retries++;
 			}
 			if (retries >= 5) {
-				dev_err(ir->l.dev, "Buffer read failed!\n");
+				dev_err(&ir->adapter->dev, "Buffer read failed!\n");
 				ret = -EIO;
 			}
 		}
@@ -969,7 +974,7 @@ static ssize_t read(struct file *filep, char __user *outbuf, size_t n,
 	put_ir_rx(rx, false);
 	set_current_state(TASK_RUNNING);
 
-	dev_dbg(ir->l.dev, "read result = %d (%s)\n", ret,
+	dev_dbg(&ir->adapter->dev, "read result = %d (%s)\n", ret,
 		ret ? "Error" : "OK");
 
 	return ret ? ret : written;
@@ -986,7 +991,7 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	ret = get_key_data(data_block, code, key);
 
 	if (ret == -EPROTO) {
-		dev_err(tx->ir->l.dev,
+		dev_err(&tx->ir->adapter->dev,
 			"failed to get data for code %u, key %u -- check lircd.conf entries\n",
 			code, key);
 		return ret;
@@ -1003,7 +1008,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x40;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -1016,18 +1022,20 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	}
 
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
 	/* Send finished download? */
 	ret = i2c_master_recv(tx->c, buf, 1);
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_recv failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 	if (buf[0] != 0xA0) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX response #1: %02x\n",
+		dev_err(&tx->ir->adapter->dev, "unexpected IR TX response #1: %02x\n",
 			buf[0]);
 		return -EFAULT;
 	}
@@ -1037,7 +1045,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	buf[1] = 0x80;
 	ret = i2c_master_send(tx->c, buf, 2);
 	if (ret != 2) {
-		dev_err(tx->ir->l.dev, "i2c_master_send failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_send failed with %d\n",
+			ret);
 		return ret < 0 ? ret : -EFAULT;
 	}
 
@@ -1047,7 +1056,8 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	 * going to skip this whole mess and say we're done on the HD PVR
 	 */
 	if (!tx->post_tx_ready_poll) {
-		dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
+		dev_dbg(&tx->ir->adapter->dev, "sent code %u, key %u\n",
+			code, key);
 		return 0;
 	}
 
@@ -1063,12 +1073,12 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 		ret = i2c_master_send(tx->c, buf, 1);
 		if (ret == 1)
 			break;
-		dev_dbg(tx->ir->l.dev,
+		dev_dbg(&tx->ir->adapter->dev,
 			"NAK expected: i2c_master_send failed with %d (try %d)\n",
 			ret, i+1);
 	}
 	if (ret != 1) {
-		dev_err(tx->ir->l.dev,
+		dev_err(&tx->ir->adapter->dev,
 			"IR TX chip never got ready: last i2c_master_send failed with %d\n",
 			ret);
 		return ret < 0 ? ret : -EFAULT;
@@ -1077,17 +1087,18 @@ static int send_code(struct IR_tx *tx, unsigned int code, unsigned int key)
 	/* Seems to be an 'ok' response */
 	i = i2c_master_recv(tx->c, buf, 1);
 	if (i != 1) {
-		dev_err(tx->ir->l.dev, "i2c_master_recv failed with %d\n", ret);
+		dev_err(&tx->ir->adapter->dev, "i2c_master_recv failed with %d\n",
+			ret);
 		return -EFAULT;
 	}
 	if (buf[0] != 0x80) {
-		dev_err(tx->ir->l.dev, "unexpected IR TX response #2: %02x\n",
+		dev_err(&tx->ir->adapter->dev, "unexpected IR TX response #2: %02x\n",
 			buf[0]);
 		return -EFAULT;
 	}
 
 	/* Oh good, it worked */
-	dev_dbg(tx->ir->l.dev, "sent code %u, key %u\n", code, key);
+	dev_dbg(&tx->ir->adapter->dev, "sent code %u, key %u\n", code, key);
 	return 0;
 }
 
@@ -1173,11 +1184,11 @@ static ssize_t write(struct file *filep, const char __user *buf, size_t n,
 		 */
 		if (ret != 0) {
 			/* Looks like the chip crashed, reset it */
-			dev_err(tx->ir->l.dev,
+			dev_err(&tx->ir->adapter->dev,
 				"sending to the IR transmitter chip failed, trying reset\n");
 
 			if (failures >= 3) {
-				dev_err(tx->ir->l.dev,
+				dev_err(&tx->ir->adapter->dev,
 					"unable to send to the IR chip after 3 resets, giving up\n");
 				mutex_unlock(&ir->ir_lock);
 				mutex_unlock(&tx->client_lock);
@@ -1209,10 +1220,10 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 {
 	struct IR *ir = filep->private_data;
 	struct IR_rx *rx;
-	struct lirc_buffer *rbuf = ir->l.rbuf;
+	struct lirc_buffer *rbuf = ir->l->rbuf;
 	unsigned int ret;
 
-	dev_dbg(ir->l.dev, "poll called\n");
+	dev_dbg(&ir->adapter->dev, "poll called\n");
 
 	rx = get_ir_rx(ir);
 	if (rx == NULL) {
@@ -1220,7 +1231,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 		 * Revisit this, if our poll function ever reports writeable
 		 * status for Tx
 		 */
-		dev_dbg(ir->l.dev, "poll result = POLLERR\n");
+		dev_dbg(&ir->adapter->dev, "poll result = POLLERR\n");
 		return POLLERR;
 	}
 
@@ -1233,7 +1244,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	/* Indicate what ops could happen immediately without blocking */
 	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN|POLLRDNORM);
 
-	dev_dbg(ir->l.dev, "poll result = %s\n",
+	dev_dbg(&ir->adapter->dev, "poll result = %s\n",
 		ret ? "POLLIN|POLLRDNORM" : "none");
 	return ret;
 }
@@ -1245,7 +1256,7 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	int result;
 	unsigned long mode, features;
 
-	features = ir->l.features;
+	features = ir->l->features;
 
 	switch (cmd) {
 	case LIRC_GET_LENGTH:
@@ -1299,7 +1310,7 @@ static struct IR *get_ir_device_by_minor(unsigned int minor)
 
 	if (!list_empty(&ir_devices_list)) {
 		list_for_each_entry(ir, &ir_devices_list, list) {
-			if (ir->l.minor == minor) {
+			if (ir->l->minor == minor) {
 				ret = get_ir_device(ir, true);
 				break;
 			}
@@ -1475,11 +1486,17 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	ir = get_ir_device_by_adapter(adap);
 	if (ir == NULL) {
 		ir = kzalloc(sizeof(struct IR), GFP_KERNEL);
-		if (ir == NULL) {
+		if (!ir) {
 			ret = -ENOMEM;
 			goto out_no_ir;
 		}
 		kref_init(&ir->ref);
+		ir->l = kzalloc(sizeof(*ir->l), GFP_KERNEL);
+		if (!ir) {
+			ret = -ENOMEM;
+			kfree(ir);
+			goto out_no_ir;
+		}
 
 		/* store for use in ir_probe() again, and open() later on */
 		INIT_LIST_HEAD(&ir->list);
@@ -1492,19 +1509,19 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		spin_lock_init(&ir->rx_ref_lock);
 
 		/* set lirc_dev stuff */
-		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
+		memcpy(ir->l, &lirc_template, sizeof(struct lirc_driver));
 		/*
 		 * FIXME this is a pointer reference to us, but no refcount.
 		 *
 		 * This OK for now, since lirc_dev currently won't touch this
 		 * buffer as we provide our own lirc_fops.
 		 *
-		 * Currently our own lirc_fops rely on this ir->l.rbuf pointer
+		 * Currently our own lirc_fops rely on this ir->l->rbuf pointer
 		 */
-		ir->l.rbuf = &ir->rbuf;
-		ir->l.dev  = &adap->dev;
-		ret = lirc_buffer_init(ir->l.rbuf,
-				       ir->l.chunk_size, ir->l.buffer_size);
+		ir->l->rbuf = &ir->rbuf;
+		ir->l->dev.parent = &adap->dev;
+		ret = lirc_buffer_init(ir->l->rbuf,
+				       ir->l->chunk_size, ir->l->buffer_size);
 		if (ret)
 			goto out_put_ir;
 	}
@@ -1522,7 +1539,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		kref_init(&tx->ref);
 		ir->tx = tx;
 
-		ir->l.features |= LIRC_CAN_SEND_PULSE;
+		ir->l->features |= LIRC_CAN_SEND_PULSE;
 		mutex_init(&tx->client_lock);
 		tx->c = client;
 		tx->need_boot = 1;
@@ -1548,7 +1565,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		/* Proceed only if the Rx client is also ready or not needed */
 		if (rx == NULL && !tx_only) {
-			dev_info(tx->ir->l.dev,
+			dev_info(&tx->ir->adapter->dev,
 				 "probe of IR Tx on %s (i2c-%d) done. Waiting on IR Rx.\n",
 				 adap->name, adap->nr);
 			goto out_ok;
@@ -1566,7 +1583,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		kref_init(&rx->ref);
 		ir->rx = rx;
 
-		ir->l.features |= LIRC_CAN_REC_LIRCCODE;
+		ir->l->features |= LIRC_CAN_REC_LIRCCODE;
 		mutex_init(&rx->client_lock);
 		rx->c = client;
 		rx->hdpvr_data_fmt =
@@ -1588,7 +1605,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 				       "zilog-rx-i2c-%d", adap->nr);
 		if (IS_ERR(rx->task)) {
 			ret = PTR_ERR(rx->task);
-			dev_err(tx->ir->l.dev,
+			dev_err(&tx->ir->adapter->dev,
 				"%s: could not start IR Rx polling thread\n",
 				__func__);
 			/* Failed kthread, so put back the ir ref */
@@ -1596,7 +1613,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			/* Failure exit, so put back rx ref from i2c_client */
 			i2c_set_clientdata(client, NULL);
 			put_ir_rx(rx, true);
-			ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
+			ir->l->features &= ~LIRC_CAN_REC_LIRCCODE;
 			goto out_put_xx;
 		}
 
@@ -1609,18 +1626,18 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	/* register with lirc */
-	ir->l.minor = minor; /* module option: user requested minor number */
-	ir->l.minor = lirc_register_driver(&ir->l);
-	if (ir->l.minor < 0 || ir->l.minor >= MAX_IRCTL_DEVICES) {
-		dev_err(tx->ir->l.dev,
+	ir->l->minor = minor; /* module option: user requested minor number */
+	ir->l->minor = lirc_register_driver(ir->l);
+	if (ir->l->minor < 0 || ir->l->minor >= MAX_IRCTL_DEVICES) {
+		dev_err(&tx->ir->adapter->dev,
 			"%s: \"minor\" must be between 0 and %d (%d)!\n",
-			__func__, MAX_IRCTL_DEVICES-1, ir->l.minor);
+			__func__, MAX_IRCTL_DEVICES - 1, ir->l->minor);
 		ret = -EBADRQC;
 		goto out_put_xx;
 	}
-	dev_info(ir->l.dev,
+	dev_info(&ir->adapter->dev,
 		 "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
-		 adap->name, adap->nr, ir->l.minor);
+		 adap->name, adap->nr, ir->l->minor);
 
 out_ok:
 	if (rx != NULL)
@@ -1628,7 +1645,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (tx != NULL)
 		put_ir_tx(tx, true);
 	put_ir_device(ir, true);
-	dev_info(ir->l.dev,
+	dev_info(&ir->adapter->dev,
 		 "probe of IR %s on %s (i2c-%d) done\n",
 		 tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
 	mutex_unlock(&ir_devices_lock);
diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
index cec7d35..98d4ed0 100644
--- a/include/media/lirc_dev.h
+++ b/include/media/lirc_dev.h
@@ -15,6 +15,8 @@
 #define mod(n, div) ((n) % (div))
 
 #include <linux/slab.h>
+#include <linux/cdev.h>
+#include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <linux/poll.h>
@@ -182,6 +184,20 @@ static inline unsigned int lirc_buffer_write(struct lirc_buffer *buf,
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
@@ -202,15 +218,28 @@ struct lirc_driver {
 	void (*set_use_dec)(void *data);
 	struct rc_dev *rdev;
 	const struct file_operations *fops;
-	struct device *dev;
+	struct device dev;
 	struct module *owner;
+
+	int attached;
+	int open;
+
+	struct mutex irctl_lock; /* locks this driver */
+	struct lirc_buffer *buf;
+
+	struct cdev cdev;
+
+	struct task_struct *task;
+	long jiffies_to_wait;
 };
 
 /* following functions can be called ONLY from user context
  *
  * returns negative value on error or minor number
  * of the registered device if success
- * contents of the structure pointed by p is copied
+ * contents of the structure pointed by will be freed once
+ * lirc_unregister_driver is called and all open file descriptors
+ * are closed.
  */
 extern int lirc_register_driver(struct lirc_driver *d);
 
-- 
2.9.3
