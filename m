Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:33074 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756202AbdD1REL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 13:04:11 -0400
Subject: [PATCH] ir-lirc-codec: let lirc_dev handle the lirc_buffer
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, sean@mess.org
Date: Fri, 28 Apr 2017 19:04:09 +0200
Message-ID: <149339904926.12280.15877468271781678130.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

ir_lirc_register() currently creates its own lirc_buffer before
passing the lirc_driver to lirc_register_driver().

When a module is later unloaded, ir_lirc_unregister() gets called
which performs a call to lirc_unregister_driver() and then free():s
the lirc_buffer.

The problem is that:

a) there can still be a userspace app holding an open lirc fd
   when lirc_unregister_driver() returns; and

b) the lirc_buffer contains "wait_queue_head_t wait_poll" which
   is potentially used as long as any userspace app is still around.

The result is an oops which can be triggered quite easily by a
userspace app monitoring its lirc fd using epoll() and not closing
the fd promptly on device removal.

The minimalistic fix is to let lirc_dev create the lirc_buffer since
lirc_dev will then also free the buffer once it believes it is safe to
do so.

I'm pretty certain that any driver which creates its own lirc_buffer
is quite likely to be buggy as well, but that seems to only concern
staging.

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/ir-lirc-codec.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index de85f1d7ce43..7b961357d333 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -354,7 +354,6 @@ static const struct file_operations lirc_fops = {
 static int ir_lirc_register(struct rc_dev *dev)
 {
 	struct lirc_driver *drv;
-	struct lirc_buffer *rbuf;
 	int rc = -ENOMEM;
 	unsigned long features = 0;
 
@@ -362,19 +361,12 @@ static int ir_lirc_register(struct rc_dev *dev)
 	if (!drv)
 		return rc;
 
-	rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
-	if (!rbuf)
-		goto rbuf_alloc_failed;
-
-	rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
-	if (rc)
-		goto rbuf_init_failed;
-
 	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
 		features |= LIRC_CAN_REC_MODE2;
 		if (dev->rx_resolution)
 			features |= LIRC_CAN_GET_REC_RESOLUTION;
 	}
+
 	if (dev->tx_ir) {
 		features |= LIRC_CAN_SEND_PULSE;
 		if (dev->s_tx_mask)
@@ -403,7 +395,7 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->minor = -1;
 	drv->features = features;
 	drv->data = &dev->raw->lirc;
-	drv->rbuf = rbuf;
+	drv->rbuf = NULL;
 	drv->set_use_inc = &ir_lirc_open;
 	drv->set_use_dec = &ir_lirc_close;
 	drv->code_length = sizeof(struct ir_raw_event) * 8;
@@ -415,19 +407,15 @@ static int ir_lirc_register(struct rc_dev *dev)
 	drv->minor = lirc_register_driver(drv);
 	if (drv->minor < 0) {
 		rc = -ENODEV;
-		goto lirc_register_failed;
+		goto out;
 	}
 
 	dev->raw->lirc.drv = drv;
 	dev->raw->lirc.dev = dev;
 	return 0;
 
-lirc_register_failed:
-rbuf_init_failed:
-	kfree(rbuf);
-rbuf_alloc_failed:
+out:
 	kfree(drv);
-
 	return rc;
 }
 
@@ -436,9 +424,8 @@ static int ir_lirc_unregister(struct rc_dev *dev)
 	struct lirc_codec *lirc = &dev->raw->lirc;
 
 	lirc_unregister_driver(lirc->drv->minor);
-	lirc_buffer_free(lirc->drv->rbuf);
-	kfree(lirc->drv->rbuf);
 	kfree(lirc->drv);
+	lirc->drv = NULL;
 
 	return 0;
 }
