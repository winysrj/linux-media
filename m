Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:40302 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaDCXc6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Apr 2014 19:32:58 -0400
Subject: [PATCH 20/49] rc-core: allow chardev to be written
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Date: Fri, 04 Apr 2014 01:32:56 +0200
Message-ID: <20140403233256.27099.34338.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
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
 drivers/media/rc/rc-main.c |   71 ++++++++++++++++++++++++++++++++++++++++++++
 include/media/rc-core.h    |    2 +
 2 files changed, 73 insertions(+)

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 43789b4..d7b24a1 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1531,6 +1531,72 @@ static ssize_t rc_read(struct file *file, char __user *buffer,
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
+	struct rc_event ev;
+
+	if (!dev->tx_ir)
+		return -ENOSYS;
+
+	if (count < sizeof(ev) || count % sizeof(ev))
+		return -EINVAL;
+
+again:
+	if (kfifo_is_full(&dev->txfifo) && !dev->dead &&
+	    (file->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+
+	ret = wait_event_interruptible(dev->txwait,
+				       !kfifo_is_full(&dev->txfifo) ||
+				       dev->dead);
+	if (ret)
+		return ret;
+
+	if (dev->dead)
+		return -ENODEV;
+
+	mutex_lock(&dev->txmutex);
+	for (ret = 0; ret + sizeof(ev) <= count; ret += sizeof(ev)) {
+		if (copy_from_user(&ev, buffer + ret, sizeof(ev))) {
+			kfifo_reset_out(&dev->txfifo);
+			mutex_unlock(&dev->txmutex);
+			return -EFAULT;
+		}
+
+		if (kfifo_in(&dev->txfifo, &ev, 1) != 1)
+			break;
+	}
+
+	if (ret == 0) {
+		mutex_unlock(&dev->txmutex);
+		goto again;
+	}
+
+	ret = dev->tx_ir(dev, ret / sizeof(ev));
+	mutex_unlock(&dev->txmutex);
+	wake_up_interruptible(&dev->txwait);
+
+	if (ret > 0)
+		ret *= sizeof(ev);
+
+	return ret;
+}
+
+/**
  * rc_poll() - allows userspace to poll rc device files
  * @file:	the &struct file corresponding to the previous open()
  * @wait:	used to keep track of processes waiting for poll events
@@ -1544,8 +1610,10 @@ static unsigned int rc_poll(struct file *file, poll_table *wait)
 	struct rc_client *client = file->private_data;
 	struct rc_dev *dev = client->dev;
 
+	poll_wait(file, &dev->txwait, wait);
 	poll_wait(file, &dev->rxwait, wait);
 	return ((kfifo_is_empty(&client->rxfifo) ? 0 : (POLLIN | POLLRDNORM)) |
+		(kfifo_is_full(&dev->txfifo) ? 0 : (POLLOUT | POLLWRNORM)) |
 		(!dev->dead ? 0 : (POLLHUP | POLLERR)));
 }
 
@@ -1572,6 +1640,7 @@ static const struct file_operations rc_fops = {
 	.open		= rc_dev_open,
 	.release	= rc_release,
 	.read		= rc_read,
+	.write		= rc_write,
 	.poll		= rc_poll,
 	.fasync		= rc_fasync,
 	.llseek		= no_llseek,
@@ -1698,6 +1767,7 @@ struct rc_dev *rc_allocate_device(void)
 	INIT_LIST_HEAD(&dev->client_list);
 	spin_lock_init(&dev->client_lock);
 	mutex_init(&dev->txmutex);
+	init_waitqueue_head(&dev->txwait);
 	init_waitqueue_head(&dev->rxwait);
 	spin_lock_init(&dev->rc_map.lock);
 	spin_lock_init(&dev->keylock);
@@ -1904,6 +1974,7 @@ void rc_unregister_device(struct rc_dev *dev)
 		kill_fasync(&client->fasync, SIGIO, POLL_HUP);
 	spin_unlock(&dev->client_lock);
 	wake_up_interruptible_all(&dev->rxwait);
+	wake_up_interruptible_all(&dev->txwait);
 
 	cdev_del(&dev->cdev);
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index ca22cf7..39f3794 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -133,6 +133,7 @@ enum rc_filter_type {
  * @client_lock: protects client_list
  * @txfifo: fifo with tx data to transmit
  * @txmutex: protects txfifo and serializes calls to @tx_ir
+ * @txwait: waitqueue for processes waiting to write data to the txfifo
  * @rxwait: waitqueue for processes waiting for data to read
  * @raw: additional data for raw pulse/space devices
  * @input_dev: the input child device used to communicate events to userspace
@@ -199,6 +200,7 @@ struct rc_dev {
 	spinlock_t			client_lock;
 	DECLARE_KFIFO_PTR(txfifo, struct rc_event);
 	struct mutex			txmutex;
+	wait_queue_head_t		txwait;
 	wait_queue_head_t		rxwait;
 	struct ir_raw_event_ctrl	*raw;
 	struct input_dev		*input_dev;

