Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:18455 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759Ab1BRBPr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 20:15:47 -0500
Received: from [192.168.1.2] (d-216-36-28-191.cpe.metrocast.net [216.36.28.191])
	(authenticated bits=0)
	by pear.metrocast.net (8.13.8/8.13.8) with ESMTP id p1I1FjlS025507
	for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 01:15:46 GMT
Subject: [PATCH 05/13] lirc_zilog: Use kernel standard methods for marking
 device non-seekable
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
In-Reply-To: <1297991502.9399.16.camel@localhost>
References: <1297991502.9399.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 20:15:58 -0500
Message-ID: <1297991758.9399.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


lirc_zilog had its own llseek stub that returned -ESPIPE.  Get rid of
it and use the kernel's no_llseek() and nonseekable_open() functions
instead.

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
---
 drivers/staging/lirc/lirc_zilog.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lirc/lirc_zilog.c b/drivers/staging/lirc/lirc_zilog.c
index c857b99..720ef67 100644
--- a/drivers/staging/lirc/lirc_zilog.c
+++ b/drivers/staging/lirc/lirc_zilog.c
@@ -712,12 +712,6 @@ static int tx_init(struct IR_tx *tx)
 	return 0;
 }
 
-/* do nothing stub to make LIRC happy */
-static loff_t lseek(struct file *filep, loff_t offset, int orig)
-{
-	return -ESPIPE;
-}
-
 /* copied from lirc_dev */
 static ssize_t read(struct file *filep, char *outbuf, size_t n, loff_t *ppos)
 {
@@ -1099,6 +1093,7 @@ static int open(struct inode *node, struct file *filep)
 	/* stash our IR struct */
 	filep->private_data = ir;
 
+	nonseekable_open(node, filep);
 	return 0;
 }
 
@@ -1150,7 +1145,7 @@ static struct i2c_driver driver = {
 
 static const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
-	.llseek		= lseek,
+	.llseek		= no_llseek,
 	.read		= read,
 	.write		= write,
 	.poll		= poll,
-- 
1.7.2.1



