Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:5812 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab1BRBUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:20:00 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1JpHu021234
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:19:55 GMT
Subject: [PATCH 10/13] lirc_zilog: Add ref counting of struct IR, IR_tx,
 and IR_rx
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:20:03 -0500
Message-ID: <1297992004.9399.26.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


This is a major change to add pointer reference counting for
struct IR, struct IR_tx, and struct IR_rx object instances.
This ref counting gets lirc_zilog closer to gracefully handling
bridge drivers and hot-unplugged USB devices disappearing out from
under lirc_zilog when the /dev/lircN node is still open.  (mutexes
to protect the i2c_client pointers in struct IR_tx and struct IR_rx
still need to be added.)

This reference counting also helps lirc_zilog clean up properly
when the i2c_clients disappear.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |  582 ++++++++++++++++++++++++-------------
 1 files changed, 380 insertions(+), 202 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 8ab60e9..755cb39 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -63,8 +63,14 @@
 #include <media/lirc_dev.h>
 #include <media/lirc.h>
 
+struct IR;
+
 struct IR_rx {
+	struct kref ref;
+	struct IR *ir;
+
 	/* RX device */
+	/* FIXME mutex lock access to this pointer */
 	struct i2c_client *c;
 
 	/* RX polling thread data */
@@ -76,7 +82,11 @@ struct IR_rx {
 };
 
 struct IR_tx {
+	struct kref ref;
+	struct IR *ir;
+
 	/* TX device */
+	/* FIXME mutex lock access to this pointer */
 	struct i2c_client *c;
 
 	/* TX additional actions needed */
@@ -85,8 +95,10 @@ struct IR_tx {
 };
 
 struct IR {
+	struct kref ref;
 	struct list_head list;
 
+	/* FIXME spinlock access to l.features */
 	struct lirc_driver l;
 	struct lirc_buffer rbuf;
 
@@ -94,11 +106,21 @@ struct IR {
 	atomic_t open_count;
 
 	struct i2c_adapter *adapter;
+
+	spinlock_t rx_ref_lock; /* struct IR_rx kref get()/put() */
 	struct IR_rx *rx;
+
+	spinlock_t tx_ref_lock; /* struct IR_tx kref get()/put() */
 	struct IR_tx *tx;
 };
 
 /* IR transceiver instance object list */
+/*
+ * This lock is used for the following:
+ * a. ir_devices_list access, insertions, deletions
+ * b. struct IR kref get()s and put()s
+ * c. serialization of ir_probe() for the two i2c_clients for a Z8
+ */
 static DEFINE_MUTEX(ir_devices_lock);
 static LIST_HEAD(ir_devices_list);
 
@@ -146,6 +168,157 @@ static int minor = -1;	/* minor number */
 				 ## args);				\
 	} while (0)
 
+
+/* struct IR reference counting */
+static struct IR *get_ir_device(struct IR *ir, bool ir_devices_lock_held)
+{
+	if (ir_devices_lock_held) {
+		kref_get(&ir->ref);
+	} else {
+		mutex_lock(&ir_devices_lock);
+		kref_get(&ir->ref);
+		mutex_unlock(&ir_devices_lock);
+	}
+	return ir;
+}
+
+static void release_ir_device(struct kref *ref)
+{
+	struct IR *ir = container_of(ref, struct IR, ref);
+
+	/*
+	 * Things should be in this state by now:
+	 * ir->rx set to NULL and deallocated - happens before ir->rx->ir put()
+	 * ir->rx->task kthread stopped - happens before ir->rx->ir put()
+	 * ir->tx set to NULL and deallocated - happens before ir->tx->ir put()
+	 * ir->open_count ==  0 - happens on final close()
+	 * ir_lock, tx_ref_lock, rx_ref_lock, all released
+	 */
+	if (ir->l.minor >= 0 && ir->l.minor < MAX_IRCTL_DEVICES) {
+		lirc_unregister_driver(ir->l.minor);
+		ir->l.minor = MAX_IRCTL_DEVICES;
+	}
+	if (ir->rbuf.fifo_initialized)
+		lirc_buffer_free(&ir->rbuf);
+	list_del(&ir->list);
+	kfree(ir);
+}
+
+static int put_ir_device(struct IR *ir, bool ir_devices_lock_held)
+{
+	int released;
+
+	if (ir_devices_lock_held)
+		return kref_put(&ir->ref, release_ir_device);
+
+	mutex_lock(&ir_devices_lock);
+	released = kref_put(&ir->ref, release_ir_device);
+	mutex_unlock(&ir_devices_lock);
+
+	return released;
+}
+
+/* struct IR_rx reference counting */
+static struct IR_rx *get_ir_rx(struct IR *ir)
+{
+	struct IR_rx *rx;
+
+	spin_lock(&ir->rx_ref_lock);
+	rx = ir->rx;
+	if (rx != NULL)
+		kref_get(&rx->ref);
+	spin_unlock(&ir->rx_ref_lock);
+	return rx;
+}
+
+static void destroy_rx_kthread(struct IR_rx *rx, bool ir_devices_lock_held)
+{
+	/* end up polling thread */
+	if (!IS_ERR_OR_NULL(rx->task)) {
+		kthread_stop(rx->task);
+		rx->task = NULL;
+		/* Put the ir ptr that ir_probe() gave to the rx poll thread */
+		put_ir_device(rx->ir, ir_devices_lock_held);
+	}
+}
+
+static void release_ir_rx(struct kref *ref)
+{
+	struct IR_rx *rx = container_of(ref, struct IR_rx, ref);
+	struct IR *ir = rx->ir;
+
+	/*
+	 * This release function can't do all the work, as we want
+	 * to keep the rx_ref_lock a spinlock, and killing the poll thread
+	 * and releasing the ir reference can cause a sleep.  That work is
+	 * performed by put_ir_rx()
+	 */
+	ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
+	/* Don't put_ir_device(rx->ir) here; lock can't be freed yet */
+	ir->rx = NULL;
+	/* Don't do the kfree(rx) here; we still need to kill the poll thread */
+	return;
+}
+
+static int put_ir_rx(struct IR_rx *rx, bool ir_devices_lock_held)
+{
+	int released;
+	struct IR *ir = rx->ir;
+
+	spin_lock(&ir->rx_ref_lock);
+	released = kref_put(&rx->ref, release_ir_rx);
+	spin_unlock(&ir->rx_ref_lock);
+	/* Destroy the rx kthread while not holding the spinlock */
+	if (released) {
+		destroy_rx_kthread(rx, ir_devices_lock_held);
+		kfree(rx);
+		/* Make sure we're not still in a poll_table somewhere */
+		wake_up_interruptible(&ir->rbuf.wait_poll);
+	}
+	/* Do a reference put() for the rx->ir reference, if we released rx */
+	if (released)
+		put_ir_device(ir, ir_devices_lock_held);
+	return released;
+}
+
+/* struct IR_tx reference counting */
+static struct IR_tx *get_ir_tx(struct IR *ir)
+{
+	struct IR_tx *tx;
+
+	spin_lock(&ir->tx_ref_lock);
+	tx = ir->tx;
+	if (tx != NULL)
+		kref_get(&tx->ref);
+	spin_unlock(&ir->tx_ref_lock);
+	return tx;
+}
+
+static void release_ir_tx(struct kref *ref)
+{
+	struct IR_tx *tx = container_of(ref, struct IR_tx, ref);
+	struct IR *ir = tx->ir;
+
+	ir->l.features &= ~LIRC_CAN_SEND_PULSE;
+	/* Don't put_ir_device(tx->ir) here, so our lock doesn't get freed */
+	ir->tx = NULL;
+	kfree(tx);
+}
+
+static int put_ir_tx(struct IR_tx *tx, bool ir_devices_lock_held)
+{
+	int released;
+	struct IR *ir = tx->ir;
+
+	spin_lock(&ir->tx_ref_lock);
+	released = kref_put(&tx->ref, release_ir_tx);
+	spin_unlock(&ir->tx_ref_lock);
+	/* Do a reference put() for the tx->ir reference, if we released tx */
+	if (released)
+		put_ir_device(ir, ir_devices_lock_held);
+	return released;
+}
+
 static int add_to_buf(struct IR *ir)
 {
 	__u16 code;
@@ -156,23 +329,29 @@ static int add_to_buf(struct IR *ir)
 	int failures = 0;
 	unsigned char sendbuf[1] = { 0 };
 	struct lirc_buffer *rbuf = ir->l.rbuf;
-	struct IR_rx *rx = ir->rx;
-
-	if (rx == NULL)
-		return -ENXIO;
+	struct IR_rx *rx;
+	struct IR_tx *tx;
 
 	if (lirc_buffer_full(rbuf)) {
 		dprintk("buffer overflow\n");
 		return -EOVERFLOW;
 	}
 
+	rx = get_ir_rx(ir);
+	if (rx == NULL)
+		return -ENXIO;
+
+	tx = get_ir_tx(ir);
+
 	/*
 	 * service the device as long as it is returning
 	 * data and we have space
 	 */
 	do {
-		if (kthread_should_stop())
-			return -ENODATA;
+		if (kthread_should_stop()) {
+			ret = -ENODATA;
+			break;
+		}
 
 		/*
 		 * Lock i2c bus for the duration.  RX/TX chips interfere so
@@ -182,7 +361,8 @@ static int add_to_buf(struct IR *ir)
 
 		if (kthread_should_stop()) {
 			mutex_unlock(&ir->ir_lock);
-			return -ENODATA;
+			ret = -ENODATA;
+			break;
 		}
 
 		/*
@@ -196,7 +376,7 @@ static int add_to_buf(struct IR *ir)
 				mutex_unlock(&ir->ir_lock);
 				zilog_error("unable to read from the IR chip "
 					    "after 3 resets, giving up\n");
-				return ret;
+				break;
 			}
 
 			/* Looks like the chip crashed, reset it */
@@ -206,20 +386,23 @@ static int add_to_buf(struct IR *ir)
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (kthread_should_stop()) {
 				mutex_unlock(&ir->ir_lock);
-				return -ENODATA;
+				ret = -ENODATA;
+				break;
 			}
 			schedule_timeout((100 * HZ + 999) / 1000);
-			if (ir->tx != NULL)
-				ir->tx->need_boot = 1;
+			if (tx != NULL)
+				tx->need_boot = 1;
 
 			++failures;
 			mutex_unlock(&ir->ir_lock);
+			ret = 0;
 			continue;
 		}
 
 		if (kthread_should_stop()) {
 			mutex_unlock(&ir->ir_lock);
-			return -ENODATA;
+			ret = -ENODATA;
+			break;
 		}
 		ret = i2c_master_recv(rx->c, keybuf, sizeof(keybuf));
 		mutex_unlock(&ir->ir_lock);
@@ -235,12 +418,17 @@ static int add_to_buf(struct IR *ir)
 
 		/* key pressed ? */
 		if (rx->hdpvr_data_fmt) {
-			if (got_data && (keybuf[0] == 0x80))
-				return 0;
-			else if (got_data && (keybuf[0] == 0x00))
-				return -ENODATA;
-		} else if ((rx->b[0] & 0x80) == 0)
-			return got_data ? 0 : -ENODATA;
+			if (got_data && (keybuf[0] == 0x80)) {
+				ret = 0;
+				break;
+			} else if (got_data && (keybuf[0] == 0x00)) {
+				ret = -ENODATA;
+				break;
+			}
+		} else if ((rx->b[0] & 0x80) == 0) {
+			ret = got_data ? 0 : -ENODATA;
+			break;
+		}
 
 		/* look what we have */
 		code = (((__u16)rx->b[0] & 0x7f) << 6) | (rx->b[1] >> 2);
@@ -251,9 +439,13 @@ static int add_to_buf(struct IR *ir)
 		/* return it */
 		lirc_buffer_write(rbuf, codes);
 		++got_data;
+		ret = 0;
 	} while (!lirc_buffer_full(rbuf));
 
-	return 0;
+	if (tx != NULL)
+		put_ir_tx(tx, false);
+	put_ir_rx(rx, false);
+	return ret;
 }
 
 /*
@@ -564,7 +756,7 @@ static int fw_load(struct IR_tx *tx)
 	}
 
 	/* Request codeset data file */
-	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", &tx->c->dev);
+	ret = request_firmware(&fw_entry, "haup-ir-blaster.bin", tx->ir->l.dev);
 	if (ret != 0) {
 		zilog_error("firmware haup-ir-blaster.bin not available "
 			    "(%d)\n", ret);
@@ -690,45 +882,26 @@ out:
 	return ret;
 }
 
-/* initialise the IR TX device */
-static int tx_init(struct IR_tx *tx)
-{
-	int ret;
-
-	/* Load 'firmware' */
-	ret = fw_load(tx);
-	if (ret != 0)
-		return ret;
-
-	/* Send boot block */
-	ret = send_boot_data(tx);
-	if (ret != 0)
-		return ret;
-	tx->need_boot = 0;
-
-	/* Looks good */
-	return 0;
-}
-
 /* copied from lirc_dev */
 static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 {
 	struct IR *ir = filep->private_data;
-	struct IR_rx *rx = ir->rx;
+	struct IR_rx *rx;
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 	int ret = 0, written = 0;
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
 
 	dprintk("read called\n");
-	if (rx == NULL)
-		return -ENODEV;
-
 	if (n % rbuf->chunk_size) {
 		dprintk("read result = -EINVAL\n");
 		return -EINVAL;
 	}
 
+	rx = get_ir_rx(ir);
+	if (rx == NULL)
+		return -ENXIO;
+
 	/*
 	 * we add ourselves to the task queue before buffer check
 	 * to avoid losing scan code (in case when queue is awaken somewhere
@@ -773,6 +946,7 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 	}
 
 	remove_wait_queue(&rbuf->wait_poll, &wait);
+	put_ir_rx(rx, false);
 	set_current_state(TASK_RUNNING);
 
 	dprintk("read result = %d (%s)\n", ret, ret ? "Error" : "OK");
@@ -902,17 +1076,19 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 			  loff_t *ppos)
 {
 	struct IR *ir = filep->private_data;
-	struct IR_tx *tx = ir->tx;
+	struct IR_tx *tx;
 	size_t i;
 	int failures = 0;
 
-	if (tx == NULL)
-		return -ENODEV;
-
 	/* Validate user parameters */
 	if (n % sizeof(int))
 		return -EINVAL;
 
+	/* Get a struct IR_tx reference */
+	tx = get_ir_tx(ir);
+	if (tx == NULL)
+		return -ENXIO;
+
 	/* Lock i2c bus for the duration */
 	mutex_lock(&ir->ir_lock);
 
@@ -923,11 +1099,22 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 
 		if (copy_from_user(&command, buf + i, sizeof(command))) {
 			mutex_unlock(&ir->ir_lock);
+			put_ir_tx(tx, false);
 			return -EFAULT;
 		}
 
 		/* Send boot data first if required */
 		if (tx->need_boot == 1) {
+			/* Make sure we have the 'firmware' loaded, first */
+			ret = fw_load(tx);
+			if (ret != 0) {
+				mutex_unlock(&ir->ir_lock);
+				put_ir_tx(tx, false);
+				if (ret != -ENOMEM)
+					ret = -EIO;
+				return ret;
+			}
+			/* Prep the chip for transmitting codes */
 			ret = send_boot_data(tx);
 			if (ret == 0)
 				tx->need_boot = 0;
@@ -939,6 +1126,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 					    (unsigned)command & 0xFFFF);
 			if (ret == -EPROTO) {
 				mutex_unlock(&ir->ir_lock);
+				put_ir_tx(tx, false);
 				return ret;
 			}
 		}
@@ -956,6 +1144,7 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 				zilog_error("unable to send to the IR chip "
 					    "after 3 resets, giving up\n");
 				mutex_unlock(&ir->ir_lock);
+				put_ir_tx(tx, false);
 				return ret;
 			}
 			set_current_state(TASK_UNINTERRUPTIBLE);
@@ -969,6 +1158,9 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 	/* Release i2c bus */
 	mutex_unlock(&ir->ir_lock);
 
+	/* Give back our struct IR_tx reference */
+	put_ir_tx(tx, false);
+
 	/* All looks good */
 	return n;
 }
@@ -977,12 +1169,13 @@ static ssize_t write(struct file *filep, const char *buf, size_t n,
 static unsigned int poll(struct file *filep, poll_table *wait)
 {
 	struct IR *ir = filep->private_data;
-	struct IR_rx *rx = ir->rx;
+	struct IR_rx *rx;
 	struct lirc_buffer *rbuf = ir->l.rbuf;
 	unsigned int ret;
 
 	dprintk("poll called\n");
 
+	rx = get_ir_rx(ir);
 	if (rx == NULL) {
 		/*
 		 * Revisit this, if our poll function ever reports writeable
@@ -1001,6 +1194,8 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	/* Indicate what ops could happen immediately without blocking */
 	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN|POLLRDNORM);
 
+	put_ir_rx(rx, false);
+
 	dprintk("poll result = %s\n", ret ? "POLLIN|POLLRDNORM" : 0);
 	return ret;
 }
@@ -1009,12 +1204,9 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct IR *ir = filep->private_data;
 	int result;
-	unsigned long mode, features = 0;
+	unsigned long mode, features;
 
-	if (ir->rx != NULL)
-		features |= LIRC_CAN_REC_LIRCCODE;
-	if (ir->tx != NULL)
-		features |= LIRC_CAN_SEND_PULSE;
+	features = ir->l.features;
 
 	switch (cmd) {
 	case LIRC_GET_LENGTH:
@@ -1060,19 +1252,24 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	return result;
 }
 
-/* ir_devices_lock must be held */
-static struct IR *find_ir_device_by_minor(unsigned int minor)
+static struct IR *get_ir_device_by_minor(unsigned int minor)
 {
 	struct IR *ir;
+	struct IR *ret = NULL;
 
-	if (list_empty(&ir_devices_list))
-		return NULL;
+	mutex_lock(&ir_devices_lock);
 
-	list_for_each_entry(ir, &ir_devices_list, list)
-		if (ir->l.minor == minor)
-			return ir;
+	if (!list_empty(&ir_devices_list)) {
+		list_for_each_entry(ir, &ir_devices_list, list) {
+			if (ir->l.minor == minor) {
+				ret = get_ir_device(ir, true);
+				break;
+			}
+		}
+	}
 
-	return NULL;
+	mutex_unlock(&ir_devices_lock);
+	return ret;
 }
 
 /*
@@ -1085,9 +1282,7 @@ static int open(struct inode *node, struct file *filep)
 	unsigned int minor = MINOR(node->i_rdev);
 
 	/* find our IR struct */
-	mutex_lock(&ir_devices_lock);
-	ir = find_ir_device_by_minor(minor);
-	mutex_unlock(&ir_devices_lock);
+	ir = get_ir_device_by_minor(minor);
 
 	if (ir == NULL)
 		return -ENODEV;
@@ -1113,6 +1308,7 @@ static int close(struct inode *node, struct file *filep)
 
 	atomic_dec(&ir->open_count);
 
+	put_ir_device(ir, false);
 	return 0;
 }
 
@@ -1167,78 +1363,23 @@ static struct lirc_driver lirc_template = {
 	.owner		= THIS_MODULE,
 };
 
-static void destroy_rx_kthread(struct IR_rx *rx)
-{
-	/* end up polling thread */
-	if (rx != NULL && !IS_ERR_OR_NULL(rx->task)) {
-		kthread_stop(rx->task);
-		rx->task = NULL;
-	}
-}
-
-/* ir_devices_lock must be held */
-static int add_ir_device(struct IR *ir)
-{
-	list_add_tail(&ir->list, &ir_devices_list);
-	return 0;
-}
-
-/* ir_devices_lock must be held */
-static void del_ir_device(struct IR *ir)
-{
-	struct IR *p;
-
-	if (list_empty(&ir_devices_list))
-		return;
-
-	list_for_each_entry(p, &ir_devices_list, list)
-		if (p == ir) {
-			list_del(&p->list);
-			break;
-		}
-}
-
 static int ir_remove(struct i2c_client *client)
 {
-	struct IR *ir = i2c_get_clientdata(client);
-
-	mutex_lock(&ir_devices_lock);
-
-	if (ir == NULL) {
-		/* We destroyed everything when the first client came through */
-		mutex_unlock(&ir_devices_lock);
-		return 0;
-	}
-
-	/* Good-bye LIRC */
-	lirc_unregister_driver(ir->l.minor);
-
-	/* Good-bye Rx */
-	destroy_rx_kthread(ir->rx);
-	if (ir->rx != NULL) {
-		i2c_set_clientdata(ir->rx->c, NULL);
-		kfree(ir->rx);
-	}
-
-	/* Good-bye Tx */
-	if (ir->tx != NULL) {
-		i2c_set_clientdata(ir->tx->c, NULL);
-		kfree(ir->tx);
+	if (strncmp("ir_tx_z8", client->name, 8) == 0) {
+		struct IR_tx *tx = i2c_get_clientdata(client);
+		if (tx != NULL)
+			put_ir_tx(tx, false);
+	} else if (strncmp("ir_rx_z8", client->name, 8) == 0) {
+		struct IR_rx *rx = i2c_get_clientdata(client);
+		if (rx != NULL)
+			put_ir_rx(rx, false);
 	}
-
-	/* Good-bye IR */
-	if (ir->rbuf.fifo_initialized)
-		lirc_buffer_free(&ir->rbuf);
-	del_ir_device(ir);
-	kfree(ir);
-
-	mutex_unlock(&ir_devices_lock);
 	return 0;
 }
 
 
 /* ir_devices_lock must be held */
-static struct IR *find_ir_device_by_adapter(struct i2c_adapter *adapter)
+static struct IR *get_ir_device_by_adapter(struct i2c_adapter *adapter)
 {
 	struct IR *ir;
 
@@ -1246,8 +1387,10 @@ static struct IR *find_ir_device_by_adapter(struct i2c_adapter *adapter)
 		return NULL;
 
 	list_for_each_entry(ir, &ir_devices_list, list)
-		if (ir->adapter == adapter)
+		if (ir->adapter == adapter) {
+			get_ir_device(ir, true);
 			return ir;
+		}
 
 	return NULL;
 }
@@ -1255,6 +1398,8 @@ static struct IR *find_ir_device_by_adapter(struct i2c_adapter *adapter)
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct IR *ir;
+	struct IR_tx *tx;
+	struct IR_rx *rx;
 	struct i2c_adapter *adap = client->adapter;
 	int ret;
 	bool tx_probe = false;
@@ -1278,133 +1423,166 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	mutex_lock(&ir_devices_lock);
 
 	/* Use a single struct IR instance for both the Rx and Tx functions */
-	ir = find_ir_device_by_adapter(adap);
+	ir = get_ir_device_by_adapter(adap);
 	if (ir == NULL) {
 		ir = kzalloc(sizeof(struct IR), GFP_KERNEL);
 		if (ir == NULL) {
 			ret = -ENOMEM;
 			goto out_no_ir;
 		}
+		kref_init(&ir->ref);
+
 		/* store for use in ir_probe() again, and open() later on */
 		INIT_LIST_HEAD(&ir->list);
-		ret = add_ir_device(ir);
-		if (ret)
-			goto out_free_ir;
+		list_add_tail(&ir->list, &ir_devices_list);
 
 		ir->adapter = adap;
 		mutex_init(&ir->ir_lock);
 		atomic_set(&ir->open_count, 0);
+		spin_lock_init(&ir->tx_ref_lock);
+		spin_lock_init(&ir->rx_ref_lock);
 
 		/* set lirc_dev stuff */
 		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
-		ir->l.minor       = minor; /* module option */
-		ir->l.rbuf	  = &ir->rbuf;
-		ir->l.data	  = ir;
-		ir->l.dev         = &adap->dev;
+		/*
+		 * FIXME this is a pointer reference to us, but no refcount.
+		 *
+		 * This OK for now, since lirc_dev currently won't touch this
+		 * buffer as we provide our own lirc_fops.
+		 *
+		 * Currently our own lirc_fops rely on this ir->l.rbuf pointer
+		 */
+		ir->l.rbuf = &ir->rbuf;
+		ir->l.dev  = &adap->dev;
 		ret = lirc_buffer_init(ir->l.rbuf,
 				       ir->l.chunk_size, ir->l.buffer_size);
 		if (ret)
-			goto out_free_ir;
+			goto out_put_ir;
 	}
 
 	if (tx_probe) {
+		/* Get the IR_rx instance for later, if already allocated */
+		rx = get_ir_rx(ir);
+
 		/* Set up a struct IR_tx instance */
-		ir->tx = kzalloc(sizeof(struct IR_tx), GFP_KERNEL);
-		if (ir->tx == NULL) {
+		tx = kzalloc(sizeof(struct IR_tx), GFP_KERNEL);
+		if (tx == NULL) {
 			ret = -ENOMEM;
-			goto out_free_xx;
+			goto out_put_xx;
 		}
+		kref_init(&tx->ref);
+		ir->tx = tx;
 
 		ir->l.features |= LIRC_CAN_SEND_PULSE;
-		ir->tx->c = client;
-		ir->tx->need_boot = 1;
-		ir->tx->post_tx_ready_poll =
+		tx->c = client;
+		tx->need_boot = 1;
+		tx->post_tx_ready_poll =
 			       (id->driver_data & ID_FLAG_HDPVR) ? false : true;
+
+		/* An ir ref goes to the struct IR_tx instance */
+		tx->ir = get_ir_device(ir, true);
+
+		/* A tx ref goes to the i2c_client */
+		i2c_set_clientdata(client, get_ir_tx(ir));
+
+		/*
+		 * Load the 'firmware'.  We do this before registering with
+		 * lirc_dev, so the first firmware load attempt does not happen
+		 * after a open() or write() call on the device.
+		 *
+		 * Failure here is not deemed catastrophic, so the receiver will
+		 * still be usable.  Firmware load will be retried in write(),
+		 * if it is needed.
+		 */
+		fw_load(tx);
+
+		/* Proceed only if the Rx client is also ready or not needed */
+		if (rx == NULL && !tx_only) {
+			zilog_info("probe of IR Tx on %s (i2c-%d) done. Waiting"
+				   " on IR Rx.\n", adap->name, adap->nr);
+			goto out_ok;
+		}
 	} else {
+		/* Get the IR_tx instance for later, if already allocated */
+		tx = get_ir_tx(ir);
+
 		/* Set up a struct IR_rx instance */
-		ir->rx = kzalloc(sizeof(struct IR_rx), GFP_KERNEL);
-		if (ir->rx == NULL) {
+		rx = kzalloc(sizeof(struct IR_rx), GFP_KERNEL);
+		if (rx == NULL) {
 			ret = -ENOMEM;
-			goto out_free_xx;
+			goto out_put_xx;
 		}
+		kref_init(&rx->ref);
+		ir->rx = rx;
 
 		ir->l.features |= LIRC_CAN_REC_LIRCCODE;
-		ir->rx->c = client;
-		ir->rx->hdpvr_data_fmt =
+		rx->c = client;
+		rx->hdpvr_data_fmt =
 			       (id->driver_data & ID_FLAG_HDPVR) ? true : false;
-	}
 
-	i2c_set_clientdata(client, ir);
+		/* An ir ref goes to the struct IR_rx instance */
+		rx->ir = get_ir_device(ir, true);
 
-	/* Proceed only if we have the required Tx and Rx clients ready to go */
-	if (ir->tx == NULL ||
-	    (ir->rx == NULL && !tx_only)) {
-		zilog_info("probe of IR %s on %s (i2c-%d) done. Waiting on "
-			   "IR %s.\n", tx_probe ? "Tx" : "Rx", adap->name,
-			   adap->nr, tx_probe ? "Rx" : "Tx");
-		goto out_ok;
-	}
+		/* An rx ref goes to the i2c_client */
+		i2c_set_clientdata(client, get_ir_rx(ir));
 
-	/* initialise RX device */
-	if (ir->rx != NULL) {
-		/* try to fire up polling thread */
-		ir->rx->task = kthread_run(lirc_thread, ir,
-					   "zilog-rx-i2c-%d", adap->nr);
-		if (IS_ERR(ir->rx->task)) {
-			ret = PTR_ERR(ir->rx->task);
+		/*
+		 * Start the polling thread.
+		 * It will only perform an empty loop around schedule_timeout()
+		 * until we register with lirc_dev and the first user open()
+		 */
+		/* An ir ref goes to the new rx polling kthread */
+		rx->task = kthread_run(lirc_thread, get_ir_device(ir, true),
+				       "zilog-rx-i2c-%d", adap->nr);
+		if (IS_ERR(rx->task)) {
+			ret = PTR_ERR(rx->task);
 			zilog_error("%s: could not start IR Rx polling thread"
 				    "\n", __func__);
-			goto out_free_xx;
+			/* Failed kthread, so put back the ir ref */
+			put_ir_device(ir, true);
+			/* Failure exit, so put back rx ref from i2c_client */
+			i2c_set_clientdata(client, NULL);
+			put_ir_rx(rx, true);
+			ir->l.features &= ~LIRC_CAN_REC_LIRCCODE;
+			goto out_put_xx;
+		}
+
+		/* Proceed only if the Tx client is also ready */
+		if (tx == NULL) {
+			zilog_info("probe of IR Rx on %s (i2c-%d) done. Waiting"
+				   " on IR Tx.\n", adap->name, adap->nr);
+			goto out_ok;
 		}
 	}
 
 	/* register with lirc */
+	ir->l.minor = minor; /* module option: user requested minor number */
 	ir->l.minor = lirc_register_driver(&ir->l);
 	if (ir->l.minor < 0 || ir->l.minor >= MAX_IRCTL_DEVICES) {
 		zilog_error("%s: \"minor\" must be between 0 and %d (%d)!\n",
 			    __func__, MAX_IRCTL_DEVICES-1, ir->l.minor);
 		ret = -EBADRQC;
-		goto out_free_thread;
-	}
-
-	/*
-	 * if we have the tx device, load the 'firmware'.  We do this
-	 * after registering with lirc as otherwise hotplug seems to take
-	 * 10s to create the lirc device.
-	 */
-	if (ir->tx != NULL) {
-		/* Special TX init */
-		ret = tx_init(ir->tx);
-		if (ret != 0)
-			goto out_unregister;
+		goto out_put_xx;
 	}
 
+out_ok:
+	if (rx != NULL)
+		put_ir_rx(rx, true);
+	if (tx != NULL)
+		put_ir_tx(tx, true);
+	put_ir_device(ir, true);
 	zilog_info("probe of IR %s on %s (i2c-%d) done. IR unit ready.\n",
 		   tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
-out_ok:
 	mutex_unlock(&ir_devices_lock);
 	return 0;
 
-out_unregister:
-	lirc_unregister_driver(ir->l.minor);
-out_free_thread:
-	destroy_rx_kthread(ir->rx);
-out_free_xx:
-	if (ir->rx != NULL) {
-		if (ir->rx->c != NULL)
-			i2c_set_clientdata(ir->rx->c, NULL);
-		kfree(ir->rx);
-	}
-	if (ir->tx != NULL) {
-		if (ir->tx->c != NULL)
-			i2c_set_clientdata(ir->tx->c, NULL);
-		kfree(ir->tx);
-	}
-	if (ir->rbuf.fifo_initialized)
-		lirc_buffer_free(&ir->rbuf);
-out_free_ir:
-	del_ir_device(ir);
-	kfree(ir);
+out_put_xx:
+	if (rx != NULL)
+		put_ir_rx(rx, true);
+	if (tx != NULL)
+		put_ir_tx(tx, true);
+out_put_ir:
+	put_ir_device(ir, true);
 out_no_ir:
 	zilog_error("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
 		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
-- 
1.7.2.1



