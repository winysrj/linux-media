Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:48888 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753049AbdCaKAr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Mar 2017 06:00:47 -0400
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-buf: fence debugging
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1cttMI-00068z-3X@rmk-PC.armlinux.org.uk>
Date: Fri, 31 Mar 2017 11:00:42 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add debugfs output to report shared and exclusive fences on a dma_buf
object.  This produces output such as:

Dma-buf Objects:
size    flags   mode    count   exp_name
08294400        00000000        00000005        00000005        drm
        Exclusive fence: etnaviv 134000.gpu signalled
        Attached Devices:
        gpu-subsystem
Total 1 devices attached


Total 1 objects, 8294400 bytes


Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/dma-buf/dma-buf.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 0007b792827b..f72aaacbe023 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1059,7 +1059,11 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 	int ret;
 	struct dma_buf *buf_obj;
 	struct dma_buf_attachment *attach_obj;
-	int count = 0, attach_count;
+	struct reservation_object *robj;
+	struct reservation_object_list *fobj;
+	struct dma_fence *fence;
+	unsigned seq;
+	int count = 0, attach_count, shared_count, i;
 	size_t size = 0;
 
 	ret = mutex_lock_interruptible(&db_list.lock);
@@ -1085,6 +1090,34 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 				file_count(buf_obj->file),
 				buf_obj->exp_name);
 
+		robj = buf_obj->resv;
+		while (true) {
+			seq = read_seqcount_begin(&robj->seq);
+			rcu_read_lock();
+			fobj = rcu_dereference(robj->fence);
+			shared_count = fobj ? fobj->shared_count : 0;
+			fence = rcu_dereference(robj->fence_excl);
+			if (!read_seqcount_retry(&robj->seq, seq))
+				break;
+			rcu_read_unlock();
+		}
+
+		if (fence)
+			seq_printf(s, "\tExclusive fence: %s %s %ssignalled\n",
+				   fence->ops->get_driver_name(fence),
+				   fence->ops->get_timeline_name(fence),
+				   dma_fence_is_signaled(fence) ? "" : "un");
+		for (i = 0; i < shared_count; i++) {
+			fence = rcu_dereference(fobj->shared[i]);
+			if (!dma_fence_get_rcu(fence))
+				continue;
+			seq_printf(s, "\tShared fence: %s %s %ssignalled\n",
+				   fence->ops->get_driver_name(fence),
+				   fence->ops->get_timeline_name(fence),
+				   dma_fence_is_signaled(fence) ? "" : "un");
+		}
+		rcu_read_unlock();
+
 		seq_puts(s, "\tAttached Devices:\n");
 		attach_count = 0;
 
-- 
2.7.4
