Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:56737 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752072AbdATNIl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Jan 2017 08:08:41 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/4] [media] lirc: fix null dereference for tx-only devices
Date: Fri, 20 Jan 2017 13:08:38 +0000
Message-Id: <2bcb8057c7cc8ad3af4f4359a9ca476fa4ee09df.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
In-Reply-To: <cover.1484916689.git.sean@mess.org>
References: <cover.1484916689.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tx-only RC devices do not have a receive buffer.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 7f5d109..18b4dae 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -472,7 +472,7 @@ int lirc_dev_fop_open(struct inode *inode, struct file *file)
 		if (retval) {
 			module_put(cdev->owner);
 			ir->open--;
-		} else {
+		} else if (ir->buf) {
 			lirc_buffer_clear(ir->buf);
 		}
 		if (ir->task)
-- 
2.9.3

