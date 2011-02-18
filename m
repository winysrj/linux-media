Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45966 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427Ab1BRBMl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:12:41 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1CcUl015730
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:12:39 GMT
Subject: [PATCH 01/13] lirc_zilog: Restore checks for existence of the
 IR_tx object
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:12:51 -0500
Message-ID: <1297991571.9399.17.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


This reverts commit 8090232a237ab62e22307fc060097da1a283dd66 and
adds an additional check for ir->tx == NULL.

The user may need us to handle an RX only unit.  Apparently
there are TV capture units in existence with Rx only wiring
and/or RX only firmware for the on-board Zilog Z8 IR unit.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index 0aad0d7..7389b77 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -209,7 +209,8 @@ static int add_to_buf(struct IR *ir)
 				return -ENODATA;
 			}
 			schedule_timeout((100 * HZ + 999) / 1000);
-			ir->tx->need_boot = 1;
+			if (ir->tx != NULL)
+				ir->tx->need_boot = 1;
 
 			++failures;
 			mutex_unlock(&ir->ir_lock);
@@ -1032,9 +1033,10 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	int result;
 	unsigned long mode, features = 0;
 
-	features |= LIRC_CAN_SEND_PULSE;
 	if (ir->rx != NULL)
 		features |= LIRC_CAN_REC_LIRCCODE;
+	if (ir->tx != NULL)
+		features |= LIRC_CAN_SEND_PULSE;
 
 	switch (cmd) {
 	case LIRC_GET_LENGTH:
@@ -1061,9 +1063,15 @@ static long ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 			result = -EINVAL;
 		break;
 	case LIRC_GET_SEND_MODE:
+		if (!(features&LIRC_CAN_SEND_MASK))
+			return -ENOSYS;
+
 		result = put_user(LIRC_MODE_PULSE, (unsigned long *) arg);
 		break;
 	case LIRC_SET_SEND_MODE:
+		if (!(features&LIRC_CAN_SEND_MASK))
+			return -ENOSYS;
+
 		result = get_user(mode, (unsigned long *) arg);
 		if (!result && mode != LIRC_MODE_PULSE)
 			return -EINVAL;
@@ -1242,8 +1250,10 @@ static int ir_remove(struct i2c_client *client)
 	}
 
 	/* Good-bye Tx */
-	i2c_set_clientdata(ir->tx->c, NULL);
-	kfree(ir->tx);
+	if (ir->tx != NULL) {
+		i2c_set_clientdata(ir->tx->c, NULL);
+		kfree(ir->tx);
+	}
 
 	/* Good-bye IR */
 	del_ir_device(ir);
@@ -1393,9 +1403,12 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	 * after registering with lirc as otherwise hotplug seems to take
 	 * 10s to create the lirc device.
 	 */
-	ret = tx_init(ir->tx);
-	if (ret != 0)
-		goto out_unregister;
+	if (ir->tx != NULL) {
+		/* Special TX init */
+		ret = tx_init(ir->tx);
+		if (ret != 0)
+			goto out_unregister;
+	}
 
 	zilog_info("probe of IR %s on %s (i2c-%d) done. IR unit ready.\n",
 		   tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
-- 
1.7.2.1



