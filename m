Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33350 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaKAVhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 1 Nov 2014 17:37:18 -0400
Date: Sat, 1 Nov 2014 23:36:54 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Gulsah Kose <gulsah.1004@gmail.com>,
	Matina Maria Trompouki <mtrompou@gmail.com>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] staging: media: lirc: lirc_zilog.c: adjust debug messages
Message-ID: <20141101213654.GA3191@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes one debug message and replaces a dev_err
call by pr_err.

Signed-off-by: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
---
 drivers/staging/media/lirc/lirc_zilog.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index 11a7cb1..ba538cd4 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -1336,11 +1336,6 @@ static int close(struct inode *node, struct file *filep)
 	/* find our IR struct */
 	struct IR *ir = filep->private_data;
 
-	if (ir == NULL) {
-		dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
-		return -ENODEV;
-	}
-
 	atomic_dec(&ir->open_count);
 
 	put_ir_device(ir, false);
@@ -1633,7 +1628,7 @@ out_put_xx:
 out_put_ir:
 	put_ir_device(ir, true);
 out_no_ir:
-	dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
+	pr_err("%s: probing IR %s on %s (i2c-%d) failed with %d\n",
 		    __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
 		   ret);
 	mutex_unlock(&ir_devices_lock);
-- 
1.9.3

