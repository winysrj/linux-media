Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:48145 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581Ab1BRBST (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:18:19 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by pear.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1IHMo027574
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:18:18 GMT
Subject: [PATCH 08/13] lirc_zilog: Always allocate a Rx lirc_buffer object
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:18:30 -0500
Message-ID: <1297991910.9399.24.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Always allocate a lirc_buffer object, instead of just upon setup of
the Rx i2c_client.  If we do not allocate a lirc_buffer object, because
we are not handling the Rx i2c_client, lirc_dev will allocate its own
lirc_buffer anyway and not tell us about its location.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   62 ++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 0f2fa58..a94b10a 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -67,9 +67,6 @@ struct IR_rx {
 	/* RX device */
 	struct i2c_client *c;
 
-	/* RX device buffer */
-	struct lirc_buffer buf;
-
 	/* RX polling thread data */
 	struct task_struct *task;
 
@@ -91,6 +88,7 @@ struct IR {
 	struct list_head list;
 
 	struct lirc_driver l;
+	struct lirc_buffer rbuf;
 
 	struct mutex ir_lock;
 	atomic_t open_count;
@@ -157,12 +155,13 @@ static int add_to_buf(struct IR *ir)
 	int ret;
 	int failures = 0;
 	unsigned char sendbuf[1] = { 0 };
+	struct lirc_buffer *rbuf = ir->l.rbuf;
 	struct IR_rx *rx = ir->rx;
 
 	if (rx == NULL)
 		return -ENXIO;
 
-	if (lirc_buffer_full(&rx->buf)) {
+	if (lirc_buffer_full(rbuf)) {
 		dprintk("buffer overflow\n");
 		return -EOVERFLOW;
 	}
@@ -250,9 +249,9 @@ static int add_to_buf(struct IR *ir)
 		codes[1] = code & 0xff;
 
 		/* return it */
-		lirc_buffer_write(&rx->buf, codes);
+		lirc_buffer_write(rbuf, codes);
 		++got_data;
-	} while (!lirc_buffer_full(&rx->buf));
+	} while (!lirc_buffer_full(rbuf));
 
 	return 0;
 }
@@ -270,7 +269,7 @@ static int add_to_buf(struct IR *ir)
 static int lirc_thread(void *arg)
 {
 	struct IR *ir = arg;
-	struct IR_rx *rx = ir->rx;
+	struct lirc_buffer *rbuf = ir->l.rbuf;
 
 	dprintk("poll thread started\n");
 
@@ -297,7 +296,7 @@ static int lirc_thread(void *arg)
 		if (kthread_should_stop())
 			break;
 		if (!add_to_buf(ir))
-			wake_up_interruptible(&rx->buf.wait_poll);
+			wake_up_interruptible(&rbuf->wait_poll);
 	}
 
 	dprintk("poll thread ended\n");
@@ -716,6 +715,7 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 {
 	struct IR *ir = filep->private_data;
 	struct IR_rx *rx = ir->rx;
+	struct lirc_buffer *rbuf = ir->l.rbuf;
 	int ret = 0, written = 0;
 	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
@@ -724,7 +724,7 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 	if (rx == NULL)
 		return -ENODEV;
 
-	if (n % rx->buf.chunk_size) {
+	if (n % rbuf->chunk_size) {
 		dprintk("read result = -EINVAL\n");
 		return -EINVAL;
 	}
@@ -734,7 +734,7 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 	 * to avoid losing scan code (in case when queue is awaken somewhere
 	 * between while condition checking and scheduling)
 	 */
-	add_wait_queue(&rx->buf.wait_poll, &wait);
+	add_wait_queue(&rbuf->wait_poll, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	/*
@@ -742,7 +742,7 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 	 * mode and 'copy_to_user' is happy, wait for data.
 	 */
 	while (written < n && ret == 0) {
-		if (lirc_buffer_empty(&rx->buf)) {
+		if (lirc_buffer_empty(rbuf)) {
 			/*
 			 * According to the read(2) man page, 'written' can be
 			 * returned as less than 'n', instead of blocking
@@ -762,17 +762,17 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 			schedule();
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
-			unsigned char buf[rx->buf.chunk_size];
-			m = lirc_buffer_read(&rx->buf, buf);
-			if (m == rx->buf.chunk_size) {
+			unsigned char buf[rbuf->chunk_size];
+			m = lirc_buffer_read(rbuf, buf);
+			if (m == rbuf->chunk_size) {
 				ret = copy_to_user((void *)outbuf+written, buf,
-						   rx->buf.chunk_size);
-				written += rx->buf.chunk_size;
+						   rbuf->chunk_size);
+				written += rbuf->chunk_size;
 			}
 		}
 	}
 
-	remove_wait_queue(&rx->buf.wait_poll, &wait);
+	remove_wait_queue(&rbuf->wait_poll, &wait);
 	set_current_state(TASK_RUNNING);
 
 	dprintk("read result = %d (%s)\n", ret, ret ? "Error" : "OK");
@@ -978,6 +978,7 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 {
 	struct IR *ir = filep->private_data;
 	struct IR_rx *rx = ir->rx;
+	struct lirc_buffer *rbuf = ir->l.rbuf;
 	unsigned int ret;
 
 	dprintk("poll called\n");
@@ -995,10 +996,10 @@ static unsigned int poll(struct file *filep, poll_table *wait)
 	 * Add our lirc_buffer's wait_queue to the poll_table. A wake up on
 	 * that buffer's wait queue indicates we may have a new poll status.
 	 */
-	poll_wait(filep, &rx->buf.wait_poll, wait);
+	poll_wait(filep, &rbuf->wait_poll, wait);
 
 	/* Indicate what ops could happen immediately without blocking */
-	ret = lirc_buffer_empty(&rx->buf) ? 0 : (POLLIN|POLLRDNORM);
+	ret = lirc_buffer_empty(rbuf) ? 0 : (POLLIN|POLLRDNORM);
 
 	dprintk("poll result = %s\n", ret ? "POLLIN|POLLRDNORM" : 0);
 	return ret;
@@ -1209,8 +1210,6 @@ static int ir_remove(struct i2c_client *client)
 	/* Good-bye Rx */
 	destroy_rx_kthread(ir->rx);
 	if (ir->rx != NULL) {
-		if (ir->rx->buf.fifo_initialized)
-			lirc_buffer_free(&ir->rx->buf);
 		i2c_set_clientdata(ir->rx->c, NULL);
 		kfree(ir->rx);
 	}
@@ -1222,6 +1221,8 @@ static int ir_remove(struct i2c_client *client)
 	}
 
 	/* Good-bye IR */
+	if (ir->rbuf.fifo_initialized)
+		lirc_buffer_free(&ir->rbuf);
 	del_ir_device(ir);
 	kfree(ir);
 
@@ -1292,11 +1293,17 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
 		ir->l.minor       = minor; /* module option */
 		ir->l.code_length = 13;
-		ir->l.rbuf	  = NULL;
+		ir->l.chunk_size  = 2;
+		ir->l.buffer_size = BUFLEN / 2;
+		ir->l.rbuf	  = &ir->rbuf;
 		ir->l.fops	  = &lirc_fops;
 		ir->l.data	  = ir;
 		ir->l.dev         = &adap->dev;
 		ir->l.sample_rate = 0;
+		ret = lirc_buffer_init(ir->l.rbuf,
+				       ir->l.chunk_size, ir->l.buffer_size);
+		if (ret)
+			goto out_free_ir;
 	}
 
 	if (tx_probe) {
@@ -1319,16 +1326,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			goto out_free_xx;
 		}
 
-		ret = lirc_buffer_init(&ir->rx->buf, 2, BUFLEN / 2);
-		if (ret)
-			goto out_free_xx;
-
 		ir->rx->c = client;
 		ir->rx->hdpvr_data_fmt =
 			       (id->driver_data & ID_FLAG_HDPVR) ? true : false;
-
-		/* set lirc_dev stuff */
-		ir->l.rbuf = &ir->rx->buf;
 	}
 
 	i2c_set_clientdata(client, ir);
@@ -1388,8 +1388,6 @@ out_free_thread:
 	destroy_rx_kthread(ir->rx);
 out_free_xx:
 	if (ir->rx != NULL) {
-		if (ir->rx->buf.fifo_initialized)
-			lirc_buffer_free(&ir->rx->buf);
 		if (ir->rx->c != NULL)
 			i2c_set_clientdata(ir->rx->c, NULL);
 		kfree(ir->rx);
@@ -1399,6 +1397,8 @@ out_free_xx:
 			i2c_set_clientdata(ir->tx->c, NULL);
 		kfree(ir->tx);
 	}
+	if (ir->rbuf.fifo_initialized)
+		lirc_buffer_free(&ir->rbuf);
 out_free_ir:
 	del_ir_device(ir);
 	kfree(ir);
-- 
1.7.2.1



