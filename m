Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40298 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXcs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:48 -0400
Subject: [PATCH 18/49] rc-core: allow chardev to be read
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:46 +0200
Message-ID: <20140403233246.27099.89520.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is the first step towards making the rc chardev usable by adding
read functionality.

Basically the implementation mimics what evdev does. Userspace applications can
open the rc device and read rc_event structs with data. Only some basic events
are supported for now but later patches will add further events.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |  154 +++++++++++++++++++++++++++++++++++++++++++-
 include/media/rc-core.h    |   40 +++++++++++
 2 files changed, 189 insertions(+), 5 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 9c7bdb8..5ce0cdb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -22,12 +22,14 @@
 #include <linux/idr.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/poll.h>
 #include "rc-core-priv.h"
 
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
-#define IR_TAB_MIN_SIZE	256
-#define IR_TAB_MAX_SIZE	8192
-#define RC_DEV_MAX	256
+#define IR_TAB_MIN_SIZE		256
+#define IR_TAB_MAX_SIZE		8192
+#define RC_DEV_MAX		256
+#define RC_RX_BUFFER_SIZE	1024
 
 /* FIXME: IR_KEYPRESS_TIMEOUT should be protocol specific */
 #define IR_KEYPRESS_TIMEOUT 250
@@ -44,16 +46,75 @@ static dev_t rc_devt;
 /**
  * struct rc_client - keeps track of processes which have opened a rc chardev
  * @dev: the &struct rc_dev which is being controlled
+ * @rxlock: protects the rxfifo
+ * @rxfifo: stores rx events which can be read by the process
  * @fasync: keeps track of the fasync queue
  * @node: list of current clients for the rc device (protected by client_lock
  *	in &struct rc_dev)
  */
 struct rc_client {
 	struct rc_dev *dev;
+	spinlock_t rxlock;
+	DECLARE_KFIFO(rxfifo, struct rc_event, RC_RX_BUFFER_SIZE);
 	struct fasync_struct *fasync;
 	struct list_head node;
 };
 
+/**
+ * rc_client_event() - passes an rc event to a specific client
+ * @client:	the &struct rc_client for this client
+ * @type:	the event type
+ * @code:	the event code (type specific)
+ * @val:	the event value (type and code specific)
+ *
+ * This function writes a &struct rc_event entry to the client kfifo
+ * for later reading from userspace.
+ */
+static void rc_client_event(struct rc_client *client, u16 type,
+			    u16 code, u32 val)
+{
+	unsigned long flags;
+	struct rc_event ev;
+
+	ev.type = type;
+	ev.code = code;
+	ev.val = val;
+
+	spin_lock_irqsave(&client->rxlock, flags);
+	if (kfifo_is_full(&client->rxfifo)) {
+		kfifo_skip(&client->rxfifo);
+		ev.type = RC_CORE;
+		ev.code = RC_CORE_DROPPED;
+		ev.val = 1;
+	}
+
+	kfifo_in(&client->rxfifo, &ev, 1);
+	kill_fasync(&client->fasync, SIGIO, POLL_IN);
+	spin_unlock_irqrestore(&client->rxlock, flags);
+}
+
+/**
+ * rc_event() - sends an rc_event to all listeners
+ * @dev:	the struct rc_dev of the device generating the event
+ * @type:	the event type
+ * @code:	the event code (type specific)
+ * @val:	the event value (type and code specific)
+ *
+ * This function passes an rc event to all clients.
+ */
+void rc_event(struct rc_dev *dev, u16 type, u16 code, u32 val)
+{
+	struct rc_client *client;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(client, &dev->client_list, node)
+		rc_client_event(client, type, code, val);
+	rcu_read_unlock();
+
+	wake_up_interruptible(&dev->rxwait);
+}
+EXPORT_SYMBOL_GPL(rc_event);
+
 static struct rc_map_list *seek_rc_map(const char *name)
 {
 	struct rc_map_list *map = NULL;
@@ -753,6 +814,7 @@ void rc_repeat(struct rc_dev *dev)
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
 	input_sync(dev->input_dev);
+	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
 
 	if (!dev->keypressed)
 		goto out;
@@ -788,6 +850,15 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
 		ir_do_keyup(dev, false);
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
+	/*
+	 * NOTE: If we ever get > 32 bit scancodes, we need to break the
+	 *	 scancode into 32 bit pieces and feed them to userspace
+	 *	 as one or more RC_KEY_SCANCODE_PART events followed
+	 *	 by a final RC_KEY_SCANCODE event.
+	 */
+	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
 
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
@@ -997,6 +1068,7 @@ static ssize_t show_protocols(struct device *device,
 	if (!dev)
 		return -EINVAL;
 
+	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
 	mutex_lock(&dev->lock);
 
 	if (fattr->type == RC_FILTER_NORMAL) {
@@ -1366,6 +1438,8 @@ static int rc_dev_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	client->dev = dev;
+	spin_lock_init(&client->rxlock);
+	INIT_KFIFO(client->rxfifo);
 
 	rc_attach_client(dev, client);
 
@@ -1408,6 +1482,74 @@ static int rc_release(struct inode *inode, struct file *file)
 }
 
 /**
+ * rc_read() - allows userspace to read rc events
+ * @file:	the &struct file corresponding to the previous open()
+ * @buffer:	the userspace buffer to read data to
+ * @count:	the number of bytes to read
+ * @ppos:	the file offset
+ * @return:	the number of bytes read, or a negative error code
+ *
+ * This function (which implements read in &struct file_operations)
+ * allows userspace to read events from the rc device file.
+ */
+static ssize_t rc_read(struct file *file, char __user *buffer,
+		       size_t count, loff_t *ppos)
+{
+	struct rc_client *client = file->private_data;
+	struct rc_dev *dev = client->dev;
+	struct rc_event ev;
+	int ret;
+
+	if (count < sizeof(ev))
+		return -EINVAL;
+
+	if ((file->f_flags & O_NONBLOCK) &&
+	    kfifo_is_empty(&client->rxfifo) &&
+	    !dev->dead)
+		return -EAGAIN;
+
+	ret = wait_event_interruptible(dev->rxwait,
+				       !kfifo_is_empty(&client->rxfifo) ||
+				       dev->dead);
+
+	if (ret)
+		return ret;
+
+	if (dev->dead)
+		return -ENODEV;
+
+	for (ret = 0; ret + sizeof(ev) <= count; ret += sizeof(ev)) {
+		if (kfifo_out_spinlocked(&client->rxfifo, &ev, 1,
+					 &client->rxlock) != 1)
+			break;
+
+		if (copy_to_user(buffer + ret, &ev, sizeof(ev)))
+			return -EFAULT;
+	}
+
+	return ret;
+}
+
+/**
+ * rc_poll() - allows userspace to poll rc device files
+ * @file:	the &struct file corresponding to the previous open()
+ * @wait:	used to keep track of processes waiting for poll events
+ * @return:	a mask of poll events which have occurred
+ *
+ * This function (which implements poll in &struct file_operations)
+ * allows userspace to poll/select on the rc device file.
+ */
+static unsigned int rc_poll(struct file *file, poll_table *wait)
+{
+	struct rc_client *client = file->private_data;
+	struct rc_dev *dev = client->dev;
+
+	poll_wait(file, &dev->rxwait, wait);
+	return ((kfifo_is_empty(&client->rxfifo) ? 0 : (POLLIN | POLLRDNORM)) |
+		(!dev->dead ? 0 : (POLLHUP | POLLERR)));
+}
+
+/**
  * rc_fasync() - allows userspace to recieve asynchronous notifications
  * @fd:		the file descriptor corresponding to the opened rc device
  * @file:	the &struct file corresponding to the previous open()
@@ -1429,6 +1571,8 @@ static const struct file_operations rc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= rc_dev_open,
 	.release	= rc_release,
+	.read		= rc_read,
+	.poll		= rc_poll,
 	.fasync		= rc_fasync,
 	.llseek		= no_llseek,
 };
@@ -1552,7 +1696,7 @@ struct rc_dev *rc_allocate_device(void)
 
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
-
+	init_waitqueue_head(&dev->rxwait);
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
 	mutex_init(&dev->lock);
@@ -1750,6 +1894,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	list_for_each_entry(client, &dev->client_list, node)
 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 	spin_unlock(&dev->client_lock);
+	wake_up_interruptible_all(&dev->rxwait);
 
 	cdev_del(&dev->cdev);
 
@@ -1771,7 +1916,6 @@ void rc_unregister_device(struct rc_dev *dev)
 	ida_simple_remove(&rc_ida, MINOR(dev->dev.devt));
 	put_device(&dev->dev);
 }
-
 EXPORT_SYMBOL_GPL(rc_unregister_device);
 
 static int __init rc_core_init(void)
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index e2615e7..d31ccdd 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -53,6 +53,43 @@ struct rc_keymap_entry {
 	};
 };
 
+/* rc_event.type value */
+#define RC_DEBUG		0x0
+#define RC_CORE			0x1
+#define RC_KEY			0x2
+#define RC_IR			0x3
+
+/* RC_CORE codes */
+#define RC_CORE_DROPPED		0x0
+
+/* RC_KEY codes */
+#define RC_KEY_REPEAT		0x0
+#define RC_KEY_PROTOCOL		0x1
+#define RC_KEY_SCANCODE		0x2
+#define RC_KEY_SCANCODE_PART	0x3
+#define RC_KEY_TOGGLE		0x4
+
+/* RC_IR codes */
+#define RC_IR_SPACE		0x0
+#define RC_IR_PULSE		0x1
+#define RC_IR_START		0x2
+#define RC_IR_STOP		0x3
+#define RC_IR_RESET		0x4
+#define RC_IR_CARRIER		0x5
+#define RC_IR_DUTY_CYCLE	0x6
+
+/**
+ * struct rc_event - used to communicate rc events to/from userspace
+ * @type:	the event type
+ * @code:	the event code (type specific)
+ * @val:	the event value (type and code specific)
+ */
+struct rc_event {
+	__u16 type;
+	__u16 code;
+	__u32 val;
+} __packed;
+
 /**
  * struct rc_scancode_filter - Filter scan codes.
  * @data:	Scancode data to match.
@@ -92,6 +129,7 @@ enum rc_filter_type {
  * @dead: used to determine if the device is still alive
  * @client_list: list of clients (processes which have opened the rc chardev)
  * @client_lock: protects client_list
+ * @rxwait: waitqueue for processes waiting for data to read
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
@@ -155,6 +193,7 @@ struct rc_dev {
 	bool				dead;
 	struct list_head		client_list;
 	spinlock_t			client_lock;
+	wait_queue_head_t		rxwait;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
@@ -212,6 +251,7 @@ struct rc_dev *rc_allocate_device(void);
 void rc_free_device(struct rc_dev *dev);
 int rc_register_device(struct rc_dev *dev);
 void rc_unregister_device(struct rc_dev *dev);
+void rc_event(struct rc_dev *dev, u16 type, u16 code, u32 val);
 
 int rc_open(struct rc_dev *rdev);
 void rc_close(struct rc_dev *rdev);

