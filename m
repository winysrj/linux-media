Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44247 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab2EWJtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:49:49 -0400
Subject: [PATCH 09/43] rc-core: add chardev
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:48 +0200
Message-ID: <20120523094247.14474.20517.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch lays the groundwork for adding a rc-core chardev.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |  211 ++++++++++++++++++++++++++++++++++++++++----
 include/media/rc-core.h    |    6 +
 2 files changed, 196 insertions(+), 21 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8da7701..d7a50b6 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -17,6 +17,7 @@
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/slab.h>
+#include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include "rc-core-priv.h"
@@ -25,6 +26,7 @@
 #define IR_TAB_MIN_SIZE	256
 #define IR_TAB_MAX_SIZE	8192
 #define RC_DEV_MAX	32
+#define RC_RX_BUFFER_SIZE 1024
 
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
 #define IR_KEYPRESS_TIMEOUT 250
@@ -34,9 +36,27 @@ static LIST_HEAD(rc_map_list);
 static DEFINE_SPINLOCK(rc_map_lock);
 
 /* Various bits and pieces to keep track of rc devices */
+static unsigned int rc_major;
 static struct rc_dev *rc_dev_table[RC_DEV_MAX];
 static DEFINE_MUTEX(rc_dev_table_mutex);
 
+/**
+ * struct rc_client - keeps track of processes which have opened a rc chardev
+ * @dev: the &struct rc_dev which is being controlled
+ * @rxlock: protects the rxfifo
+ * @rxfifo: stores rx events which can be read by the process
+ * @fasync: keeps track of the fasync queue
+ * @node: list of current clients for the rc device (protected by client_lock
+ *	in &struct rc_dev)
+ */
+struct rc_client {
+	struct rc_dev *dev;
+	spinlock_t rxlock;
+	DECLARE_KFIFO(rxfifo, int, RC_RX_BUFFER_SIZE);
+	struct fasync_struct *fasync;
+	struct list_head node;
+};
+
 static struct rc_map_list *seek_rc_map(const char *name)
 {
 	struct rc_map_list *map = NULL;
@@ -1041,8 +1061,22 @@ out:
 	return ret;
 }
 
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
@@ -1111,6 +1145,9 @@ struct rc_dev *rc_allocate_device(void)
 	dev->input_dev->setkeycode = ir_setkeycode;
 	input_set_drvdata(dev->input_dev, dev);
 
+	INIT_LIST_HEAD(&dev->client_list);
+	spin_lock_init(&dev->client_lock);
+
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
 	mutex_init(&dev->lock);
@@ -1125,18 +1162,18 @@ struct rc_dev *rc_allocate_device(void)
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
 
@@ -1183,6 +1220,7 @@ int rc_register_device(struct rc_dev *dev)
 		return -ENFILE;
 
 	dev->minor = i;
+	dev->dev.devt = MKDEV(rc_major, dev->minor);
 	dev_set_name(&dev->dev, "rc%u", dev->minor);
 	dev_set_drvdata(&dev->dev, dev);
 
@@ -1251,6 +1289,7 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_raw;
 	}
 
+	dev->exist = true;
 	mutex_unlock(&dev->lock);
 
 	IR_dprintk(1, "Registered rc%u (driver: %s, remote: %s, mode %s)\n",
@@ -1282,13 +1321,24 @@ EXPORT_SYMBOL_GPL(rc_register_device);
 
 void rc_unregister_device(struct rc_dev *dev)
 {
+	struct rc_client *client;
+
 	if (!dev)
 		return;
 
+	mutex_lock(&dev->lock);
+	dev->exist = false;
+	mutex_unlock(&dev->lock);
+
 	mutex_lock(&rc_dev_table_mutex);
 	rc_dev_table[dev->minor] = NULL;
 	mutex_unlock(&rc_dev_table_mutex);
 
+	spin_lock(&dev->client_lock);
+	list_for_each_entry(client, &dev->client_list, node)
+		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+	spin_unlock(&dev->client_lock);
+
 	del_timer_sync(&dev->timer_keyup);
 
 	if (dev->driver_type == RC_DRIVER_IR_RAW)
@@ -1301,34 +1351,153 @@ void rc_unregister_device(struct rc_dev *dev)
 	input_unregister_device(dev->input_dev);
 	dev->input_dev = NULL;
 
-	device_del(&dev->dev);
-
-	rc_free_device(dev);
+	device_unregister(&dev->dev);
 }
 
 EXPORT_SYMBOL_GPL(rc_unregister_device);
 
-/*
- * Init/exit code for the module. Basically, creates/removes /sys/class/rc
+/**
+ * rc_open() - allows userspace to open() a rc device file
+ * @inode:	the &struct inode corresponding to the device file
+ * @file:	the &struct file corresponding to the open() attempt
+ * @return:	zero on success, or a negative error code
+ *
+ * This function (which implements open in &struct file_operations)
+ * allows userspace to open() a rc device file.
+ */
+static int rc_open(struct inode *inode, struct file *file)
+{
+	int err;
+	struct rc_dev *dev;
+	struct rc_client *client;
+
+	IR_dprintk(2, "Open attempt on %u\n", iminor(inode));
+
+	if (iminor(inode) >= RC_DEV_MAX)
+		return -ENODEV;
+
+	err = mutex_lock_interruptible(&rc_dev_table_mutex);
+	if (err)
+		return err;
+	dev = rc_dev_table[iminor(inode)];
+	if (dev && dev->exist)
+		get_device(&dev->dev);
+	else
+		dev = NULL;
+	mutex_unlock(&rc_dev_table_mutex);
+
+	if (!dev)
+		return -ENODEV;
+
+	client = kzalloc(sizeof(*client), GFP_KERNEL);
+	if (!client) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock_init(&client->rxlock);
+	INIT_KFIFO(client->rxfifo);
+	client->dev = dev;
+
+	spin_lock(&dev->client_lock);
+	list_add_tail_rcu(&client->node, &dev->client_list);
+	spin_unlock(&dev->client_lock);
+	synchronize_rcu();
+
+	file->private_data = client;
+	nonseekable_open(inode, file);
+
+	IR_dprintk(2, "Device %u opened\n", iminor(inode));
+	return 0;
+
+out:
+	put_device(&dev->dev);
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
  */
+static int rc_release(struct inode *inode, struct file *file)
+{
+	struct rc_client *client = file->private_data;
+	struct rc_dev *dev = client->dev;
+
+	spin_lock(&dev->client_lock);
+	list_del_rcu(&client->node);
+	spin_unlock(&dev->client_lock);
+	synchronize_rcu();
+	kfree(client);
+	put_device(&dev->dev);
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
+	.open		= rc_open,
+	.release	= rc_release,
+	.fasync		= rc_fasync,
+};
 
 static int __init rc_core_init(void)
 {
-	int rc = class_register(&rc_class);
-	if (rc) {
-		printk(KERN_ERR "rc_core: unable to register rc class\n");
-		return rc;
+	int ret;
+
+	ret = register_chrdev(0, "rc", &rc_fops);
+	if (ret < 0) {
+		printk(KERN_ERR "rc_core: failed to allocate char dev\n");
+		goto out;
 	}
 
-	rc_map_register(&empty_map);
+	rc_major = ret;
+	IR_dprintk(1, "Allocated char dev: %u\n", rc_major);
 
+	ret = class_register(&rc_class);
+	if (ret < 0) {
+		printk(KERN_ERR "rc_core: unable to create rc class\n");
+		goto chrdev;
+	}
+
+	rc_map_register(&empty_map);
 	return 0;
+
+chrdev:
+	unregister_chrdev(rc_major, "rc");
+out:
+	return ret;
 }
 
 static void __exit rc_core_exit(void)
 {
 	class_unregister(&rc_class);
-	rc_map_unregister(&empty_map);
+	unregister_chrdev(rc_major, "rc");
+rc_map_unregister(&empty_map);
 }
 
 subsys_initcall(rc_core_init);
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 1d4f5a0..0cd414d 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -64,6 +64,9 @@ struct rc_keymap_entry {
  * @lock: used to ensure we've filled in all protocol details before
  *	anyone can call show_protocols or store_protocols
  * @minor: unique minor remote control device number
+ * @exist: used to determine if the device is still valid
+ * @client_list: list of clients (processes which have opened the rc chardev)
+ * @client_lock: protects client_list
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
@@ -112,6 +115,9 @@ struct rc_dev {
 	struct rc_map			rc_map;
 	struct mutex			lock;
 	unsigned int			minor;
+	bool				exist;
+	struct list_head		client_list;
+	spinlock_t			client_lock;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;

