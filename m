Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44273 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab2EWJyy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:54 -0400
Subject: [PATCH 10/43] rc-core: allow chardev to be read
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:42:53 +0200
Message-ID: <20120523094253.14474.43327.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
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
 drivers/media/rc/rc-main.c |  134 +++++++++++++++++++++++++++++++++++++++++++-
 include/media/rc-core.h    |   31 ++++++++++
 2 files changed, 163 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index d7a50b6..ef8d358 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -20,6 +20,7 @@
 #include <linux/sched.h>
 #include <linux/device.h>
 #include <linux/module.h>
+#include <linux/poll.h>
 #include "rc-core-priv.h"
 
 /* Sizes are in bytes, 256 bytes allows for 32 entries on x64 */
@@ -52,11 +53,66 @@ static DEFINE_MUTEX(rc_dev_table_mutex);
 struct rc_client {
 	struct rc_dev *dev;
 	spinlock_t rxlock;
-	DECLARE_KFIFO(rxfifo, int, RC_RX_BUFFER_SIZE);
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
+			    u16 code, u64 val)
+{
+	unsigned long flags;
+	struct rc_event event;
+
+	event.type = type;
+	event.code = code;
+	event.reserved = 0;
+	event.val = val;
+
+	spin_lock_irqsave(&client->rxlock, flags);
+	if (kfifo_is_full(&client->rxfifo)) {
+		kfifo_skip(&client->rxfifo);
+		event.type = RC_CORE;
+		event.code = RC_CORE_DROPPED;
+		event.val = 1;
+	}
+	kfifo_in(&client->rxfifo, &event, 1);
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
+void rc_event(struct rc_dev *dev, u16 type, u16 code, u64 val)
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
@@ -719,6 +775,7 @@ void rc_repeat(struct rc_dev *dev)
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, dev->last_scancode);
 	input_sync(dev->input_dev);
+	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
 
 	if (!dev->keypressed)
 		goto out;
@@ -754,6 +811,9 @@ static void ir_do_keydown(struct rc_dev *dev, u16 protocol,
 		ir_do_keyup(dev, false);
 
 	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_PROTOCOL, protocol);
+	rc_event(dev, RC_KEY, RC_KEY_SCANCODE, scancode);
+	rc_event(dev, RC_KEY, RC_KEY_TOGGLE, toggle);
 
 	if (new_event && keycode != KEY_RESERVED) {
 		/* Register a keypress */
@@ -1147,7 +1207,7 @@ struct rc_dev *rc_allocate_device(void)
 
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
-
+	init_waitqueue_head(&dev->rxwait);
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
 	mutex_init(&dev->lock);
@@ -1338,6 +1398,7 @@ void rc_unregister_device(struct rc_dev *dev)
 	list_for_each_entry(client, &dev->client_list, node)
 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 	spin_unlock(&dev->client_lock);
+	wake_up_interruptible_all(&dev->rxwait);
 
 	del_timer_sync(&dev->timer_keyup);
 
@@ -1441,6 +1502,73 @@ static int rc_release(struct inode *inode, struct file *file)
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
+	struct rc_event event;
+	int ret;
+
+	if (count < sizeof(event))
+		return -EINVAL;
+
+	if (kfifo_is_empty(&client->rxfifo) && dev->exist &&
+	    (file->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+
+	ret = wait_event_interruptible(dev->rxwait,
+				       !kfifo_is_empty(&client->rxfifo) ||
+				       !dev->exist);
+
+	if (ret)
+		return ret;
+
+	if (!dev->exist)
+		return -ENODEV;
+
+	for (ret = 0; ret + sizeof(event) <= count; ret += sizeof(event)) {
+		if (kfifo_out_spinlocked(&client->rxfifo, &event, 1,
+					 &client->rxlock) != 1)
+			break;
+
+		if (copy_to_user(buffer + ret, &event, sizeof(event)))
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
+		(dev->exist ? 0 : (POLLHUP | POLLERR)));
+}
+
+/**
  * rc_fasync() - allows userspace to recieve asynchronous notifications
  * @fd:		the file descriptor corresponding to the opened rc device
  * @file:	the &struct file corresponding to the previous open()
@@ -1462,6 +1590,8 @@ static const struct file_operations rc_fops = {
 	.owner		= THIS_MODULE,
 	.open		= rc_open,
 	.release	= rc_release,
+	.read		= rc_read,
+	.poll		= rc_poll,
 	.fasync		= rc_fasync,
 };
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 0cd414d..4f69aa9 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -67,6 +67,7 @@ struct rc_keymap_entry {
  * @exist: used to determine if the device is still valid
  * @client_list: list of clients (processes which have opened the rc chardev)
  * @client_lock: protects client_list
+ * @rxwait: waitqueue for processes waiting for data to read
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
  * @driver_type: specifies if protocol decoding is done in hardware or software
@@ -118,6 +119,7 @@ struct rc_dev {
 	bool				exist;
 	struct list_head		client_list;
 	spinlock_t			client_lock;
+	wait_queue_head_t		rxwait;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;
 	enum rc_driver_type		driver_type;
@@ -154,6 +156,34 @@ struct rc_dev {
 
 #define to_rc_dev(d) container_of(d, struct rc_dev, dev)
 
+/* rc_event.type value */
+#define RC_DEBUG		0x0
+#define RC_CORE			0x1
+#define RC_KEY			0x2
+
+/* RC_CORE codes */
+#define RC_CORE_DROPPED		0x0
+
+/* RC_KEY codes */
+#define RC_KEY_REPEAT		0x0
+#define RC_KEY_PROTOCOL		0x1
+#define RC_KEY_SCANCODE		0x2
+#define RC_KEY_TOGGLE		0x3
+
+/**
+ * struct rc_event - used to communicate rc events to userspace
+ * @type:	the event type
+ * @code:	the event code (type specific)
+ * @reserved:	zero for now
+ * @val:	the event value (type and code specific)
+ */
+struct rc_event {
+	__u16 type;
+	__u16 code;
+	__u32 reserved;
+	__u64 val;
+} __packed;
+
 /*
  * From rc-main.c
  * Those functions can be used on any type of Remote Controller. They
@@ -165,6 +195,7 @@ struct rc_dev *rc_allocate_device(void);
 void rc_free_device(struct rc_dev *dev);
 int rc_register_device(struct rc_dev *dev);
 void rc_unregister_device(struct rc_dev *dev);
+void rc_event(struct rc_dev *dev, u16 type, u16 code, u64 val);
 
 void rc_repeat(struct rc_dev *dev);
 void rc_keydown(struct rc_dev *dev, enum rc_type protocol, u64 scancode, u8 toggle);

