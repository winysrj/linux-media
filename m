Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:57232 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757617Ab1BRBTH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:19:07 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by mango.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1J1ca020589
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:19:04 GMT
Subject: [PATCH 09/13] lirc_zilog: Move constants from ir_probe() into the
 lirc_driver template
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:19:14 -0500
Message-ID: <1297991954.9399.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


ir_probe() makes a number of constant assignments into the lirc_driver
object after copying in a template.  Make better use of the template.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index a94b10a..8ab60e9 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -1116,13 +1116,6 @@ static int close(struct inode *node, struct file *filep)
 	return 0;
 }
 
-static struct lirc_driver lirc_template = {
-	.name		= "lirc_zilog",
-	.set_use_inc	= set_use_inc,
-	.set_use_dec	= set_use_dec,
-	.owner		= THIS_MODULE
-};
-
 static int ir_remove(struct i2c_client *client);
 static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id);
 
@@ -1161,6 +1154,19 @@ static const struct file_operations lirc_fops = {
 	.release	= close
 };
 
+static struct lirc_driver lirc_template = {
+	.name		= "lirc_zilog",
+	.minor		= -1,
+	.code_length	= 13,
+	.buffer_size	= BUFLEN / 2,
+	.sample_rate	= 0, /* tell lirc_dev to not start its own kthread */
+	.chunk_size	= 2,
+	.set_use_inc	= set_use_inc,
+	.set_use_dec	= set_use_dec,
+	.fops		= &lirc_fops,
+	.owner		= THIS_MODULE,
+};
+
 static void destroy_rx_kthread(struct IR_rx *rx)
 {
 	/* end up polling thread */
@@ -1292,14 +1298,9 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		/* set lirc_dev stuff */
 		memcpy(&ir->l, &lirc_template, sizeof(struct lirc_driver));
 		ir->l.minor       = minor; /* module option */
-		ir->l.code_length = 13;
-		ir->l.chunk_size  = 2;
-		ir->l.buffer_size = BUFLEN / 2;
 		ir->l.rbuf	  = &ir->rbuf;
-		ir->l.fops	  = &lirc_fops;
 		ir->l.data	  = ir;
 		ir->l.dev         = &adap->dev;
-		ir->l.sample_rate = 0;
 		ret = lirc_buffer_init(ir->l.rbuf,
 				       ir->l.chunk_size, ir->l.buffer_size);
 		if (ret)
@@ -1314,6 +1315,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			goto out_free_xx;
 		}
 
+		ir->l.features |= LIRC_CAN_SEND_PULSE;
 		ir->tx->c = client;
 		ir->tx->need_boot = 1;
 		ir->tx->post_tx_ready_poll =
@@ -1326,6 +1328,7 @@ static int ir_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			goto out_free_xx;
 		}
 
+		ir->l.features |= LIRC_CAN_REC_LIRCCODE;
 		ir->rx->c = client;
 		ir->rx->hdpvr_data_fmt =
 			       (id->driver_data & ID_FLAG_HDPVR) ? true : false;
-- 
1.7.2.1



