Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41232 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757788AbdEAQDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:03:45 -0400
Subject: [PATCH 01/16] lirc_dev: remove pointless functions
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Mon, 01 May 2017 18:03:41 +0200
Message-ID: <149365462098.12922.6242101173051498781.stgit@zeus.hardeman.nu>
In-Reply-To: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
References: <149365439677.12922.11872546284425440362.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drv->set_use_inc and drv->set_use_dec are already optional so we can remove all
dummy functions.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c        |   14 ++------------
 drivers/staging/media/lirc/lirc_zilog.c |   11 -----------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 8f0669c9894c..fc58745b26b8 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -327,16 +327,6 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
-static int ir_lirc_open(void *data)
-{
-	return 0;
-}
-
-static void ir_lirc_close(void *data)
-{
-	return;
-}
-
 static const struct file_operations lirc_fops = {
 	.owner		= THIS_MODULE,
 	.write		= ir_lirc_transmit_ir,
@@ -396,8 +386,8 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->features = features;
 	drv->data = &dev->raw->lirc;
 	drv->rbuf = NULL;
-	drv->set_use_inc = &ir_lirc_open;
-	drv->set_use_dec = &ir_lirc_close;
+	drv->set_use_inc = NULL;
+	drv->set_use_dec = NULL;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
 	drv->chunk_size = sizeof(int);
 	drv->buffer_size = LIRCBUF_SIZE;
diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
index e4a533b6beb3..436cf1b6a70a 100644
--- a/drivers/staging/media/lirc/lirc_zilog.c
+++ b/drivers/staging/media/lirc/lirc_zilog.c
@@ -497,15 +497,6 @@ static int lirc_thread(void *arg)
 	return 0;
 }
 
-static int set_use_inc(void *data)
-{
-	return 0;
-}
-
-static void set_use_dec(void *data)
-{
-}
-
 /* safe read of a uint32 (always network byte order) */
 static int read_uint32(unsigned char **data,
 				     unsigned char *endp, unsigned int *val)
@@ -1396,8 +1387,6 @@ static struct lirc_driver lirc_template = {
 	.buffer_size	= BUFLEN / 2,
 	.sample_rate	= 0, /* tell lirc_dev to not start its own kthread */
 	.chunk_size	= 2,
-	.set_use_inc	= set_use_inc,
-	.set_use_dec	= set_use_dec,
 	.fops		= &lirc_fops,
 	.owner		= THIS_MODULE,
 };
