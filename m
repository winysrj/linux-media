Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:38024 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638Ab1BRBR3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:17:29 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by pear.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1HRBw026865
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:17:27 GMT
Subject: [PATCH 07/13] lirc_zilog: Remove unneeded rx->buf_lock
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:17:40 -0500
Message-ID: <1297991860.9399.23.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

 
Remove the rx->buf_lock that protected the rx->buf lirc_buffer.  The
underlying operations on the objects within the lirc_buffer are already
protected by spinlocks, or the objects are constant (e.g. chunk_size).

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index dfa6a42..0f2fa58 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -67,9 +67,8 @@ struct IR_rx {
 	/* RX device */
 	struct i2c_client *c;
 
-	/* RX device buffer & lock */
+	/* RX device buffer */
 	struct lirc_buffer buf;
-	struct mutex buf_lock;
 
 	/* RX polling thread data */
 	struct task_struct *task;
@@ -718,18 +717,15 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 	struct IR *ir = filep->private_data;
 	struct IR_rx *rx = ir->rx;
 	int ret = 0, written = 0;
+	unsigned int m;
 	DECLARE_WAITQUEUE(wait, current);
 
 	dprintk("read called\n");
 	if (rx == NULL)
 		return -ENODEV;
 
-	if (mutex_lock_interruptible(&rx->buf_lock))
-		return -ERESTARTSYS;
-
 	if (n % rx->buf.chunk_size) {
 		dprintk("read result = -EINVAL\n");
-		mutex_unlock(&rx->buf_lock);
 		return -EINVAL;
 	}
 
@@ -767,19 +763,19 @@ static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
 			unsigned char buf[rx->buf.chunk_size];
-			lirc_buffer_read(&rx->buf, buf);
-			ret = copy_to_user((void *)outbuf+written, buf,
-					   rx->buf.chunk_size);
-			written += rx->buf.chunk_size;
+			m = lirc_buffer_read(&rx->buf, buf);
+			if (m == rx->buf.chunk_size) {
+				ret = copy_to_user((void *)outbuf+written, buf,
+						   rx->buf.chunk_size);
+				written += rx->buf.chunk_size;
+			}
 		}
 	}
 
 	remove_wait_queue(&rx->buf.wait_poll, &wait);
 	set_current_state(TASK_RUNNING);
-	mutex_unlock(&rx->buf_lock);
 
-	dprintk("read result = %s (%d)\n",
-		ret ? "-EFAULT" : "OK", ret);
+	dprintk("read result = %d (%s)\n", ret, ret ? "Error" : "OK");
 
 	return ret ? ret : written;
 }
@@ -1327,7 +1323,6 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		if (ret)
 			goto out_free_xx;
 
-		mutex_init(&ir->rx->buf_lock);
 		ir->rx->c = client;
 		ir->rx->hdpvr_data_fmt =
 			       (id->driver_data & ID_FLAG_HDPVR) ? true : false;
-- 
1.7.2.1



