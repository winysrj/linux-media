Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:51103 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945234AbcJaRwc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 13:52:32 -0400
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 9/9] [media] lirc: use-after free while reading from device and unplugging
Date: Mon, 31 Oct 2016 17:52:27 +0000
Message-Id: <1477936347-9029-10-git-send-email-sean@mess.org>
In-Reply-To: <1477936347-9029-1-git-send-email-sean@mess.org>
References: <1477936347-9029-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Many lirc drivers have their own receive buffers which are freed on
unplug (e.g. ir_lirc_unregister). This means that ir->buf->wait_poll
will be freed directly after unplug so do not remove yourself from the
wait queue.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 60fd106..b0c79a5 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -718,7 +718,7 @@ ssize_t lirc_dev_fop_read(struct file *file,
 
 			if (!ir->attached) {
 				ret = -ENODEV;
-				break;
+				goto out_locked;
 			}
 		} else {
 			lirc_buffer_read(ir->buf, buf);
-- 
2.7.4

