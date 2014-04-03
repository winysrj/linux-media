Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40296 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXcn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:43 -0400
Subject: [PATCH 17/49] rc-core: add chardev
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:41 +0200
Message-ID: <20140403233241.27099.78648.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch lays the groundwork for adding a rc-core chardev.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-raw.c  |    2 
 drivers/media/rc/rc-main.c |  284 +++++++++++++++++++++++++++++++++++---------
 include/media/rc-core.h    |   11 +-
 3 files changed, 238 insertions(+), 59 deletions(-)

diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index aed2997..7eb347a 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -271,7 +271,7 @@ int ir_raw_event_register(struct rc_dev *dev)
 
 	spin_lock_init(&dev->raw->lock);
 	dev->raw->thread = kthread_run(ir_raw_event_thread, dev->raw,
-				       "rc%u", dev->minor);
+				       dev_name(&dev->dev));
 
 	if (IS_ERR(dev->raw->thread)) {
 		rc = PTR_ERR(dev->raw->thread);
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 42268f3..9c7bdb8 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -18,6 +18,7 @@
 #include <linux/input.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <linux/idr.h>
 #include <linux/device.h>
 #include <linux/module.h>
@@ -38,6 +39,20 @@ static struct led_trigger *led_feedback;
 
 /* Used to keep track of rc devices */
 static DEFINE_IDA(rc_ida);
+static dev_t rc_devt;
+
+/**
+ * struct rc_client - keeps track of processes which have opened a rc chardev
+ * @dev: the &struct rc_dev which is being controlled
+ * @fasync: keeps track of the fasync queue
+ * @node: list of current clients for the rc device (protected by client_lock
+ *	in &struct rc_dev)
+ */
+struct rc_client {
+	struct rc_dev *dev;
+	struct fasync_struct *fasync;
+	struct list_head node;
+};
 
 static struct rc_map_list *seek_rc_map(const char *name)
 {
@@ -844,47 +859,45 @@ void rc_keydown_notimeout(struct rc_dev *dev, enum rc_type protocol,
 }
 EXPORT_SYMBOL_GPL(rc_keydown_notimeout);
 
-int rc_open(struct rc_dev *rdev)
+int rc_open(struct rc_dev *dev)
 {
-	int rval = 0;
-
-	if (!rdev)
-		return -EINVAL;
+	int err = 0;
 
-	mutex_lock(&rdev->lock);
-	if (!rdev->users++ && rdev->open != NULL)
-		rval = rdev->open(rdev);
+	mutex_lock(&dev->lock);
 
-	if (rval)
-		rdev->users--;
+	if (dev->dead)
+		err = -ENODEV;
+	else if (!dev->users++ && dev->open) {
+		err = dev->open(dev);
+		if (err)
+			dev->users--;
+	}
 
-	mutex_unlock(&rdev->lock);
+	mutex_unlock(&dev->lock);
 
-	return rval;
+	return err;
 }
 EXPORT_SYMBOL_GPL(rc_open);
 
-static int ir_open(struct input_dev *idev)
+static int rc_input_open(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
 
 	return rc_open(rdev);
 }
 
-void rc_close(struct rc_dev *rdev)
+void rc_close(struct rc_dev *dev)
 {
-	if (rdev) {
-		mutex_lock(&rdev->lock);
+	mutex_lock(&dev->lock);
 
-		 if (!--rdev->users && rdev->close != NULL)
-			rdev->close(rdev);
+	if (!dev->dead && !--dev->users && dev->close)
+		dev->close(dev);
 
-		mutex_unlock(&rdev->lock);
-	}
+	mutex_unlock(&dev->lock);
 }
 EXPORT_SYMBOL_GPL(rc_close);
 
-static void ir_close(struct input_dev *idev)
+static void rc_input_close(struct input_dev *idev)
 {
 	struct rc_dev *rdev = input_get_drvdata(idev);
 	rc_close(rdev);
@@ -1306,8 +1319,136 @@ unlock:
 	return (ret < 0) ? ret : len;
 }
 
+/**
+ * rc_attach_client() - attaches a new userspace client to a rc device
+ * @dev:	the rc device
+ * @client:	the client to attach
+ */
+static void rc_attach_client(struct rc_dev *dev, struct rc_client *client)
+{
+	spin_lock(&dev->client_lock);
+	list_add_tail_rcu(&client->node, &dev->client_list);
+	spin_unlock(&dev->client_lock);
+}
+
+/**
+ * rc_detach_client() - detaches a userspace client from a rc device
+ * @dev:	the rc device
+ * @client:	the client to detach
+ */
+static void rc_detach_client(struct rc_dev *dev, struct rc_client *client)
+{
+	spin_lock(&dev->client_lock);
+	list_del_rcu(&client->node);
+	spin_unlock(&dev->client_lock);
+	synchronize_rcu();
+}
+	
+/**
+ * rc_dev_open() - allows userspace to open() a rc device file
+ * @inode:	the &struct inode corresponding to the device file
+ * @file:	the &struct file corresponding to the open() attempt
+ * @return:	zero on success, or a negative error code
+ *
+ * This function (which implements open in &struct file_operations)
+ * allows userspace to open() a rc device file.
+ */
+static int rc_dev_open(struct inode *inode, struct file *file)
+{
+	struct rc_dev *dev = container_of(inode->i_cdev, struct rc_dev, cdev);
+	struct rc_client *client;
+	int err;
+
+	IR_dprintk(2, "Open attempt on %u\n", iminor(inode));
+
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
+	if (!client)
+		return -ENOMEM;
+
+	client->dev = dev;
+
+	rc_attach_client(dev, client);
+
+	err = rc_open(dev);
+	if (err)
+		goto out;
+
+	file->private_data = client;
+	nonseekable_open(inode, file);
+
+	IR_dprintk(2, "Device %u opened\n", iminor(inode));
+	return 0;
+
+out:
+	rc_detach_client(dev, client);
+	kfree(client);
+	return err;
+}
+
+/**
+ * rc_release() - allows userspace to close() a rc device file
+ * @inode:	the &struct inode corresponding to the device file
+ * @file:	the &struct file corresponding to the previous open()
+ * @return:	zero on success, or a negative error code
+ *
+ * This function (which implements release in &struct file_operations)
+ * allows userspace to close() a rc device file.
+ */
+static int rc_release(struct inode *inode, struct file *file)
+{
+	struct rc_client *client = file->private_data;
+	struct rc_dev *dev = client->dev;
+
+	rc_detach_client(dev, client);
+	kfree(client);
+	rc_close(dev);
+
+	IR_dprintk(2, "Device %u closed\n", iminor(inode));
+	return 0;
+}
+
+/**
+ * rc_fasync() - allows userspace to recieve asynchronous notifications
+ * @fd:		the file descriptor corresponding to the opened rc device
+ * @file:	the &struct file corresponding to the previous open()
+ * @on:		whether notifications should be enabled or disabled
+ * @return:	zero on success, or a negative error code
+ *
+ * This function (which implements fasync in &struct file_operations)
+ * allows userspace to receive asynchronous signal notifications
+ * when the state of a rc device file changes.
+ */
+static int rc_fasync(int fd, struct file *file, int on)
+{
+	struct rc_client *client = file->private_data;
+
+	return fasync_helper(fd, file, on, &client->fasync);
+}
+
+static const struct file_operations rc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= rc_dev_open,
+	.release	= rc_release,
+	.fasync		= rc_fasync,
+	.llseek		= no_llseek,
+};
+
+/**
+ * rc_dev_release() - release a &struct rc_dev
+ * @device: the &struct device which corresponds to the &struct rc_dev
+ *
+ * This function is called by the driver core when the refcount
+ * for the &device reaches zero.
+ */
 static void rc_dev_release(struct device *device)
 {
+	struct rc_dev *dev = to_rc_dev(device);
+
+	if (dev->input_dev)
+		input_free_device(dev->input_dev);
+
+	kfree(dev);
+	module_put(THIS_MODULE);
 }
 
 #define ADD_HOTPLUG_VAR(fmt, val...)					\
@@ -1409,6 +1550,9 @@ struct rc_dev *rc_allocate_device(void)
 	dev->input_dev->setkeycode = ir_setkeycode;
 	input_set_drvdata(dev->input_dev, dev);
 
+	INIT_LIST_HEAD(&dev->client_list);
+	spin_lock_init(&dev->client_lock);
+
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
 	mutex_init(&dev->lock);
@@ -1418,23 +1562,27 @@ struct rc_dev *rc_allocate_device(void)
 	dev->dev.class = &rc_class;
 	device_initialize(&dev->dev);
 
+	cdev_init(&dev->cdev, &rc_fops);
+	dev->cdev.kobj.parent = &dev->dev.kobj;
+	dev->cdev.owner = THIS_MODULE;
+
 	__module_get(THIS_MODULE);
 	return dev;
 }
 EXPORT_SYMBOL_GPL(rc_allocate_device);
 
+/**
+ * rc_free_device() - free an allocated struct rc_dev
+ * @dev:	the &struct rc_dev to free
+ *
+ * This function is used by drivers to free a &struct rc_dev which has
+ * been allocated with rc_allocate_device(). It must not be used
+ * after rc_register_device() has been successfully called.
+ */
 void rc_free_device(struct rc_dev *dev)
 {
-	if (!dev)
-		return;
-
-	if (dev->input_dev)
-		input_free_device(dev->input_dev);
-
-	put_device(&dev->dev);
-
-	kfree(dev);
-	module_put(THIS_MODULE);
+	if (dev)
+		put_device(&dev->dev);
 }
 EXPORT_SYMBOL_GPL(rc_free_device);
 
@@ -1460,17 +1608,15 @@ int rc_register_device(struct rc_dev *dev)
 	set_bit(EV_REP, dev->input_dev->evbit);
 	set_bit(EV_MSC, dev->input_dev->evbit);
 	set_bit(MSC_SCAN, dev->input_dev->mscbit);
-	if (dev->open)
-		dev->input_dev->open = ir_open;
-	if (dev->close)
-		dev->input_dev->close = ir_close;
+	dev->input_dev->open = rc_input_open;
+	dev->input_dev->close = rc_input_close;
 
 	minor = ida_simple_get(&rc_ida, 0, RC_DEV_MAX, GFP_KERNEL);
 	if (minor < 0)
 		return minor;
 
-	dev->minor = minor;
-	dev_set_name(&dev->dev, "rc%u", dev->minor);
+	dev->dev.devt = MKDEV(MAJOR(rc_devt), minor);
+	dev_set_name(&dev->dev, "rc%u", minor);
 	dev_set_drvdata(&dev->dev, dev);
 
 	dev->dev.groups = dev->sysfs_groups;
@@ -1491,10 +1637,14 @@ int rc_register_device(struct rc_dev *dev)
 	 */
 	mutex_lock(&dev->lock);
 
-	rc = device_add(&dev->dev);
+	rc = cdev_add(&dev->cdev, dev->dev.devt, 1);
 	if (rc)
 		goto out_unlock;
 
+	rc = device_add(&dev->dev);
+	if (rc)
+		goto out_cdev;
+
 	rc = ir_setkeytable(dev, rc_map);
 	if (rc)
 		goto out_dev;
@@ -1558,8 +1708,8 @@ int rc_register_device(struct rc_dev *dev)
 
 	mutex_unlock(&dev->lock);
 
-	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
-		   dev->minor,
+	IR_dprintk(1, "Registered %s (driver: %s, remote: %s, mode %s)\n",
+		   dev_name(&dev->dev),
 		   dev->driver_name ? dev->driver_name : "unknown",
 		   rc_map->name ? rc_map->name : "unknown",
 		   dev->driver_type == RC_DRIVER_IR_RAW ? "raw" : "cooked");
@@ -1576,6 +1726,8 @@ out_table:
 	ir_free_table(&dev->rc_map);
 out_dev:
 	device_del(&dev->dev);
+out_cdev:
+	cdev_del(&dev->cdev);
 out_unlock:
 	mutex_unlock(&dev->lock);
 	ida_simple_remove(&rc_ida, minor);
@@ -1585,42 +1737,61 @@ EXPORT_SYMBOL_GPL(rc_register_device);
 
 void rc_unregister_device(struct rc_dev *dev)
 {
+	struct rc_client *client;
+
 	if (!dev)
 		return;
 
+	mutex_lock(&dev->lock);
+	dev->dead = true;
+	mutex_unlock(&dev->lock);
+
+	spin_lock(&dev->client_lock);
+	list_for_each_entry(client, &dev->client_list, node)
+		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+	spin_unlock(&dev->client_lock);
+
+	cdev_del(&dev->cdev);
+
 	del_timer_sync(&dev->timer_keyup);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
 		ir_raw_event_unregister(dev);
 
-	/* Freeing the table should also call the stop callback */
 	ir_free_table(&dev->rc_map);
-	IR_dprintk(1, "Freed keycode table\n");
 
 	input_unregister_device(dev->input_dev);
 	dev->input_dev = NULL;
 
-	device_del(&dev->dev);
-
-	ida_simple_remove(&rc_ida, dev->minor);
+	/* dev is marked as dead so no one changes dev->users */
+	if (dev->users && dev->close)
+		dev->close(dev);
 
-	rc_free_device(dev);
+	device_del(&dev->dev);
+	ida_simple_remove(&rc_ida, MINOR(dev->dev.devt));
+	put_device(&dev->dev);
 }
 
 EXPORT_SYMBOL_GPL(rc_unregister_device);
 
-/*
- * Init/exit code for the module. Basically, creates/removes /sys/class/rc
- */
-
 static int __init rc_core_init(void)
 {
-	int rc = class_register(&rc_class);
-	if (rc) {
-		printk(KERN_ERR "rc_core: unable to register rc class\n");
-		return rc;
+	int err;
+
+	err = class_register(&rc_class);
+	if (err) {
+		printk(KERN_ERR "rc_core: unable to create class\n");
+		return err;
 	}
 
+	err = alloc_chrdev_region(&rc_devt, 0, RC_DEV_MAX, "rc-core");
+	if (err) {
+		printk(KERN_ERR "rc_core: unable to allocate chardev region\n");
+		class_unregister(&rc_class);
+		return err;
+	}
+
+	IR_dprintk(1, "Allocated char dev: %u\n", MAJOR(rc_devt));
 	led_trigger_register_simple("rc-feedback", &led_feedback);
 	rc_map_register(&empty_map);
 
@@ -1629,9 +1800,10 @@ static int __init rc_core_init(void)
 
 static void __exit rc_core_exit(void)
 {
-	class_unregister(&rc_class);
-	led_trigger_unregister_simple(led_feedback);
 	rc_map_unregister(&empty_map);
+	led_trigger_unregister_simple(led_feedback);
+	unregister_chrdev_region(rc_devt, RC_DEV_MAX);
+	class_unregister(&rc_class);
 }
 
 subsys_initcall(rc_core_init);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index ca3d836..e2615e7 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -20,6 +20,7 @@
 #include <linux/kfifo.h>
 #include <linux/time.h>
 #include <linux/timer.h>
+#include <linux/cdev.h>
 #include <media/rc-map.h>
 
 extern int rc_core_debug;
@@ -78,6 +79,7 @@ enum rc_filter_type {
 /**
  * struct rc_dev - represents a remote control device
  * @dev: driver model's view of this device
+ * @cdev: character device structure
  * @sysfs_groups: sysfs attribute groups
  * @input_name: name of the input child device
  * @input_phys: physical path to the input child device
@@ -87,7 +89,9 @@ enum rc_filter_type {
  * @rc_map: current scan/key table
  * @lock: used to ensure we've filled in all protocol details before
  *	anyone can call show_protocols or store_protocols
- * @minor: unique minor remote control device number
+ * @dead: used to determine if the device is still alive
+ * @client_list: list of clients (processes which have opened the rc chardev)
+ * @client_lock: protects client_list
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
@@ -139,6 +143,7 @@ enum rc_filter_type {
  */
 struct rc_dev {
 	struct device			dev;
+	struct cdev			cdev;
 	const struct attribute_group	*sysfs_groups[5];
 	const char			*input_name;
 	const char			*input_phys;
@@ -147,7 +152,9 @@ struct rc_dev {
 	const char			*map_name;
 	struct rc_map			rc_map;
 	struct mutex			lock;
-	unsigned int			minor;
+	bool				dead;
+	struct list_head		client_list;
+	spinlock_t			client_lock;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;

