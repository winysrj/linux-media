Return-path: <linux-media-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50760 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750773AbdLSQs1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 11:48:27 -0500
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] media: lirc: don't kfree the uninitialized pointer txbuf
Date: Tue, 19 Dec 2017 16:48:25 +0000
Message-Id: <20171219164825.14642-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The current error exit path if ir_raw_encode_scancode fails is via the
label out_kfree which kfree's an uninitialized pointer txbuf. Fix this
by exiting via a new exit path that does not kfree txbuf.  Also exit
via this new exit path for a failed allocation of txbuf to avoid a
redundant kfree on a NULL pointer (to save a bunch of CPU cycles).

Detected by: CoverityScan, CID#1463070 ("Uninitialized pointer read")

Fixes: f81a8158d4fb ("media: lirc: release lock before sleep")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/rc/lirc_dev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index fae42f120aa4..62afa4493aea 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -295,14 +295,14 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 		ret = ir_raw_encode_scancode(scan.rc_proto, scan.scancode,
 					     raw, LIRCBUF_SIZE);
 		if (ret < 0)
-			goto out_kfree;
+			goto out_kfree_raw;
 
 		count = ret;
 
 		txbuf = kmalloc_array(count, sizeof(unsigned int), GFP_KERNEL);
 		if (!txbuf) {
 			ret = -ENOMEM;
-			goto out_kfree;
+			goto out_kfree_raw;
 		}
 
 		for (i = 0; i < count; i++)
@@ -366,6 +366,7 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
 	return n;
 out_kfree:
 	kfree(txbuf);
+out_kfree_raw:
 	kfree(raw);
 out_unlock:
 	mutex_unlock(&dev->lock);
-- 
2.14.1
