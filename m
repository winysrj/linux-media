Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:11607 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758091Ab1BRBPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:15:09 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1F7kR017768
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:15:08 GMT
Subject: [PATCH 04/13] lirc_zilog: Convert the instance open count to an
 atomic_t
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:15:20 -0500
Message-ID: <1297991720.9399.20.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


The open count is simply used for deciding if the Rx polling thread
needs to poll the IR chip for userspace.  Simplify the manipulation
of the open count by using an atomic_t and not requiring a lock
The polling thread errantly didn't try to take the lock anyway.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 39f7b53..c857b99 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -94,7 +94,7 @@ struct IR {
 	struct lirc_driver l;
 
 	struct mutex ir_lock;
-	int open;
+	atomic_t open_count;
 
 	struct i2c_adapter *adapter;
 	struct IR_rx *rx;
@@ -279,7 +279,7 @@ static int lirc_thread(void *arg)
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		/* if device not opened, we can sleep half a second */
-		if (!ir->open) {
+		if (atomic_read(&ir->open_count) == 0) {
 			schedule_timeout(HZ/2);
 			continue;
 		}
@@ -1094,10 +1094,7 @@ static int open(struct inode *node, struct file *filep)
 	if (ir == NULL)
 		return -ENODEV;
 
-	/* increment in use count */
-	mutex_lock(&ir->ir_lock);
-	++ir->open;
-	mutex_unlock(&ir->ir_lock);
+	atomic_inc(&ir->open_count);
 
 	/* stash our IR struct */
 	filep->private_data = ir;
@@ -1115,10 +1112,7 @@ static int close(struct inode *node, struct file *filep)
 		return -ENODEV;
 	}
 
-	/* decrement in use count */
-	mutex_lock(&ir->ir_lock);
-	--ir->open;
-	mutex_unlock(&ir->ir_lock);
+	atomic_dec(&ir->open_count);
 
 	return 0;
 }
@@ -1294,6 +1288,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 		ir->adapter = adap;
 		mutex_init(&ir->ir_lock);
+		atomic_set(&ir->open_count, 0);
 
 		/* set lirc_dev stuff */
 		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
-- 
1.7.2.1



