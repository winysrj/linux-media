Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48960 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754720AbdCaKD1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 06:03:27 -0400
From: Russell King <rmk+kernel@armlinux.org.uk>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-buf: align debugfs output
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1cttOq-0006GX-U7@rmk-PC.armlinux.org.uk>
Date: Fri, 31 Mar 2017 11:03:20 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Align the heading with the values output from debugfs.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/dma-buf/dma-buf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index ebaf1923ad6b..f72aaacbe023 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1072,7 +1072,8 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		return ret;
 
 	seq_puts(s, "\nDma-buf Objects:\n");
-	seq_puts(s, "size\tflags\tmode\tcount\texp_name\n");
+	seq_printf(s, "%-8s\t%-8s\t%-8s\t%-8s\texp_name\n",
+		   "size", "flags", "mode", "count");
 
 	list_for_each_entry(buf_obj, &db_list.head, list_node) {
 		ret = mutex_lock_interruptible(&buf_obj->lock);
-- 
2.7.4
