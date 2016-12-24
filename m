Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:34933 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbcLXWb4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Dec 2016 17:31:56 -0500
Received: by mail-pg0-f66.google.com with SMTP id i5so4794036pgh.2
        for <linux-media@vger.kernel.org>; Sat, 24 Dec 2016 14:31:56 -0800 (PST)
From: Shyam Saini <mayhs11saini@gmail.com>
To: mchehab@kernel.org
Cc: linux-media@vger.kernel.org, Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 1/4] media: pci: saa7164: Replace BUG() with BUG_ON()
Date: Sun, 25 Dec 2016 04:01:39 +0530
Message-Id: <1482618702-13755-1-git-send-email-mayhs11saini@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace BUG() with BUG_ON() using coccinelle

Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 drivers/media/pci/saa7164/saa7164-buffer.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-buffer.c b/drivers/media/pci/saa7164/saa7164-buffer.c
index 62c3450..7d28d46 100644
--- a/drivers/media/pci/saa7164/saa7164-buffer.c
+++ b/drivers/media/pci/saa7164/saa7164-buffer.c
@@ -266,15 +266,13 @@ int saa7164_buffer_cfg_port(struct saa7164_port *port)
 	list_for_each_safe(c, n, &port->dmaqueue.list) {
 		buf = list_entry(c, struct saa7164_buffer, list);
 
-		if (buf->flags != SAA7164_BUFFER_FREE)
-			BUG();
+		BUG_ON(buf->flags != SAA7164_BUFFER_FREE);
 
 		/* Place the buffer in the h/w queue */
 		saa7164_buffer_activate(buf, i);
 
 		/* Don't exceed the device maximum # bufs */
-		if (i++ > port->hwcfg.buffercount)
-			BUG();
+		BUG_ON(i++ > port->hwcfg.buffercount);
 
 	}
 	mutex_unlock(&port->dmaqueue_lock);
-- 
2.7.4

