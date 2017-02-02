Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:39917 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751672AbdBBXOi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 18:14:38 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH] [media] lirc: cannot read from tx-only device
Date: Thu,  2 Feb 2017 23:14:35 +0000
Message-Id: <1486077276-14156-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bail out early, otherwise we follow a null pointer.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/lirc_dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index 0030ce0..a54ca53 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -647,6 +647,9 @@ ssize_t lirc_dev_fop_read(struct file *file,
 		return -ENODEV;
 	}
 
+	if (!LIRC_CAN_REC(ir->d.features))
+		return -EINVAL;
+
 	dev_dbg(ir->d.dev, LOGHEAD "read called\n", ir->d.name, ir->d.minor);
 
 	buf = kzalloc(ir->chunk_size, GFP_KERNEL);
-- 
2.9.3

