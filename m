Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:56724 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753683Ab1BRBNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:13:38 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by pear.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1DbpC023920
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:13:37 GMT
Subject: [PATCH 02/13] lirc_zilog: Remove broken, ineffective reference
 counting
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:13:50 -0500
Message-ID: <1297991630.9399.18.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


The set_use_inc() and set_use_dec() functions tried to lock
the underlying bridge driver device instance in memory by
changing the use count on the device's i2c_clients.  This
worked for PCI devices (ivtv, cx18, bttv).  It doesn't
work for hot-pluggable usb devices (pvrusb2 and hdpvr).
With usb device instances, the driver may get locked into
memory, but the unplugged hardware is gone.

The set_use_inc() set_use_dec() functions also tried to have
lirc_zilog change its own module refernce count, which is
racy and not guaranteed to work.  The lirc_dev module does
actually perform proper module ref count manipulation on the
lirc_zilog module, so there is need for lirc_zilog to
attempt a buggy module get on itself anyway.

lirc_zilog also errantly called these functions on itself
in open() and close(), but lirc_dev did that already too.

So let's just gut the bodies of the set_use_*() functions,
and remove the extra calls to them from within lirc_zilog.

Proper reference counting of the struct IR, IR_rx, and IR_tx
objects -- to handle the case when the underlying
bttv, ivtv, cx18, hdpvr, or pvrusb2 bridge driver module or
device instance goes away -- will be added in subsequent
patches.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   32 +-------------------------------
 1 files changed, 1 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 7389b77..3a91257 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -305,34 +305,12 @@ static int lirc_thread(void *arg)
 
 static int set_use_inc(void *data)
 {
-	struct IR *ir = data;
-
-	if (ir->l.owner == NULL || try_module_get(ir->l.owner) == 0)
-		return -ENODEV;
-
-	/* lock bttv in memory while /dev/lirc is in use  */
-	/*
-	 * this is completely broken code. lirc_unregister_driver()
-	 * must be possible even when the device is open
-	 */
-	if (ir->rx != NULL)
-		i2c_use_client(ir->rx->c);
-	if (ir->tx != NULL)
-		i2c_use_client(ir->tx->c);
-
 	return 0;
 }
 
 static void set_use_dec(void *data)
 {
-	struct IR *ir = data;
-
-	if (ir->rx)
-		i2c_release_client(ir->rx->c);
-	if (ir->tx)
-		i2c_release_client(ir->tx->c);
-	if (ir->l.owner != NULL)
-		module_put(ir->l.owner);
+	return;
 }
 
 /* safe read of a uint32 (always network byte order) */
@@ -1098,7 +1076,6 @@ static struct IR *find_ir_device_by_minor(unsigned int minor)
 static int open(struct inode *node, struct file *filep)
 {
 	struct IR *ir;
-	int ret;
 	unsigned int minor = MINOR(node->i_rdev);
 
 	/* find our IR struct */
@@ -1112,12 +1089,6 @@ static int open(struct inode *node, struct file *filep)
 	/* increment in use count */
 	mutex_lock(&ir->ir_lock);
 	++ir->open;
-	ret = set_use_inc(ir);
-	if (ret != 0) {
-		--ir->open;
-		mutex_unlock(&ir->ir_lock);
-		return ret;
-	}
 	mutex_unlock(&ir->ir_lock);
 
 	/* stash our IR struct */
@@ -1139,7 +1110,6 @@ static int close(struct inode *node, struct file *filep)
 	/* decrement in use count */
 	mutex_lock(&ir->ir_lock);
 	--ir->open;
-	set_use_dec(ir);
 	mutex_unlock(&ir->ir_lock);
 
 	return 0;
-- 
1.7.2.1



