Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:44271 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab2EWJyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 May 2012 05:54:51 -0400
Subject: [PATCH 14/43] rc-core: allow chardev to be written
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: mchehab@redhat.com, jarod@redhat.com
Date: Wed, 23 May 2012 11:43:14 +0200
Message-ID: <20120523094314.14474.95103.stgit@felix.hardeman.nu>
In-Reply-To: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
References: <20120523094157.14474.24367.stgit@felix.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add write functionality to the rc chardev (for use in transmitting remote
control commands on capable hardware).

The data format of the TX data is probably going to have to be dependent
on the rc_driver_type.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/rc-main.c |   68 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/rc-core.h    |    2 +
 2 files changed, 70 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 80d6dac..3389822 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1211,6 +1211,7 @@ struct rc_dev *rc_allocate_device(void)
 	INIT_KFIFO(dev->txfifo);
 	spin_lock_init(&dev->txlock);
 	init_waitqueue_head(&dev->rxwait);
+	init_waitqueue_head(&dev->txwait);
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
 	mutex_init(&dev->lock);
@@ -1409,6 +1410,7 @@ void rc_unregister_device(struct rc_dev *dev)
 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 	spin_unlock(&dev->client_lock);
 	wake_up_interruptible_all(&dev->rxwait);
+	wake_up_interruptible_all(&dev->txwait);
 
 	del_timer_sync(&dev->timer_keyup);
 
@@ -1560,6 +1562,69 @@ static ssize_t rc_read(struct file *file, char __user *buffer,
 }
 
 /**
+ * rc_write() - allows userspace to write data to transmit
+ * @file:	the &struct file corresponding to the previous open()
+ * @buffer:	the userspace buffer to read data from
+ * @count:	the number of bytes to read
+ * @ppos:	the file offset
+ * @return:	the number of bytes written, or a negative error code
+ *
+ * This function (which implements write in &struct file_operations)
+ * allows userspace to transmit data using a suitable rc device
+ */
+static ssize_t rc_write(struct file *file, const char __user *buffer,
+			size_t count, loff_t *ppos)
+{
+	struct rc_client *client = file->private_data;
+	struct rc_dev *dev = client->dev;
+	ssize_t ret;
+	DEFINE_IR_RAW_EVENT(event);
+	bool pulse = true;
+	u32 value;
+
+	if (!dev->tx_ir)
+		return -ENOSYS;
+
+	if ((count < sizeof(u32)) || (count % sizeof(u32)))
+		return -EINVAL;
+
+again:
+	if (kfifo_is_full(&dev->txfifo) && dev->exist &&
+	    (file->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+
+	ret = wait_event_interruptible(dev->txwait,
+				       !kfifo_is_full(&dev->txfifo) ||
+				       !dev->exist);
+	if (ret)
+		return ret;
+
+	if (!dev->exist)
+		return -ENODEV;
+
+	for (ret = 0; ret + sizeof(value) <= count; ret += sizeof(value)) {
+		if (copy_from_user(&value, buffer + ret, sizeof(value)))
+			return -EFAULT;
+
+		event.duration = US_TO_NS(value);
+		event.pulse = pulse;
+		pulse = !pulse;
+
+		if (kfifo_in_spinlocked(&dev->txfifo, &event, 1, &dev->txlock)
+		    != 1)
+			break;
+	}
+
+	if (ret == 0)
+		goto again;
+
+	dev->tx_ir(dev);
+	wake_up_interruptible(&dev->txwait);
+
+	return ret;
+}
+
+/**
  * rc_poll() - allows userspace to poll rc device files
  * @file:	the &struct file corresponding to the previous open()
  * @wait:	used to keep track of processes waiting for poll events
@@ -1573,8 +1638,10 @@ static unsigned int rc_poll(struct file *file, poll_table *wait)
 	struct rc_client *client = file->private_data;
 	struct rc_dev *dev = client->dev;
 
+	poll_wait(file, &dev->txwait, wait);
 	poll_wait(file, &dev->rxwait, wait);
 	return ((kfifo_is_empty(&client->rxfifo) ? 0 : (POLLIN | POLLRDNORM)) |
+		(kfifo_is_full(&dev->txfifo) ? 0 : (POLLOUT | POLLWRNORM)) |
 		(dev->exist ? 0 : (POLLHUP | POLLERR)));
 }
 
@@ -1601,6 +1668,7 @@ static const struct file_operations rc_fops = {
 	.open		= rc_open,
 	.release	= rc_release,
 	.read		= rc_read,
+	.write		= rc_write,
 	.poll		= rc_poll,
 	.fasync		= rc_fasync,
 };
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 4a5dbcb..1810984 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -87,6 +87,7 @@ struct ir_raw_event {
  * @client_lock: protects client_list
  * @txfifo: fifo with tx data to transmit
  * @txlock: protects txfifo
+ * @txwait: waitqueue for processes waiting to write data to the txfifo
  * @rxwait: waitqueue for processes waiting for data to read
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
@@ -141,6 +142,7 @@ struct rc_dev {
 	spinlock_t			client_lock;
 	DECLARE_KFIFO_PTR(txfifo, struct ir_raw_event);
 	spinlock_t			txlock;
+	wait_queue_head_t		txwait;
 	wait_queue_head_t		rxwait;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;

