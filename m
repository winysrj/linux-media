Return-path: <linux-media-owner@vger.kernel.org>
Received: from s159.web-hosting.com ([68.65.121.203]:35290 "EHLO
	s159.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbbETUXS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 16:23:18 -0400
From: Jagan Teki <jteki@openedev.com>
To: linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	dri-devel@lists.freedesktop.org, Jagan Teki <jteki@openedev.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH] dma-buf: Minor coding style fixes
Date: Thu, 21 May 2015 01:09:31 +0530
Message-Id: <1432150771-10958-1-git-send-email-jteki@openedev.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- WARNING: Missing a blank line after declarations
- WARNING: line over 80 characters
- WARNING: please, no space before tabs

Signed-off-by: Jagan Teki <jteki@openedev.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/dma-buf/dma-buf.c     | 9 +++++++--
 drivers/dma-buf/reservation.c | 9 ++++++---
 drivers/dma-buf/seqno-fence.c | 8 +++++++-
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index c5a9138..30a099c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -285,6 +285,7 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	struct reservation_object *resv = exp_info->resv;
 	struct file *file;
 	size_t alloc_size = sizeof(struct dma_buf);
+
 	if (!exp_info->resv)
 		alloc_size += sizeof(struct reservation_object);
 	else
@@ -545,7 +546,8 @@ int dma_buf_begin_cpu_access(struct dma_buf *dmabuf, size_t start, size_t len,
 		return -EINVAL;
 
 	if (dmabuf->ops->begin_cpu_access)
-		ret = dmabuf->ops->begin_cpu_access(dmabuf, start, len, direction);
+		ret = dmabuf->ops->begin_cpu_access(dmabuf, start,
+							len, direction);
 
 	return ret;
 }
@@ -649,7 +651,7 @@ EXPORT_SYMBOL_GPL(dma_buf_kunmap);
  * @dmabuf:	[in]	buffer that should back the vma
  * @vma:	[in]	vma for the mmap
  * @pgoff:	[in]	offset in pages where this mmap should start within the
- * 			dma-buf buffer.
+ *			dma-buf buffer.
  *
  * This function adjusts the passed in vma so that it points at the file of the
  * dma_buf operation. It also adjusts the starting pgoff and does bounds
@@ -826,6 +828,7 @@ static int dma_buf_describe(struct seq_file *s)
 static int dma_buf_show(struct seq_file *s, void *unused)
 {
 	void (*func)(struct seq_file *) = s->private;
+
 	func(s);
 	return 0;
 }
@@ -847,7 +850,9 @@ static struct dentry *dma_buf_debugfs_dir;
 static int dma_buf_init_debugfs(void)
 {
 	int err = 0;
+
 	dma_buf_debugfs_dir = debugfs_create_dir("dma_buf", NULL);
+
 	if (IS_ERR(dma_buf_debugfs_dir)) {
 		err = PTR_ERR(dma_buf_debugfs_dir);
 		dma_buf_debugfs_dir = NULL;
diff --git a/drivers/dma-buf/reservation.c b/drivers/dma-buf/reservation.c
index 39920d7..c0bd572 100644
--- a/drivers/dma-buf/reservation.c
+++ b/drivers/dma-buf/reservation.c
@@ -337,7 +337,8 @@ retry:
 	rcu_read_lock();
 
 	if (wait_all) {
-		struct reservation_object_list *fobj = rcu_dereference(obj->fence);
+		struct reservation_object_list *fobj =
+						rcu_dereference(obj->fence);
 
 		if (fobj)
 			shared_count = fobj->shared_count;
@@ -429,7 +430,8 @@ retry:
 	if (test_all) {
 		unsigned i;
 
-		struct reservation_object_list *fobj = rcu_dereference(obj->fence);
+		struct reservation_object_list *fobj =
+						rcu_dereference(obj->fence);
 
 		if (fobj)
 			shared_count = fobj->shared_count;
@@ -462,7 +464,8 @@ retry:
 			goto unlock_retry;
 
 		if (fence_excl) {
-			ret = reservation_object_test_signaled_single(fence_excl);
+			ret = reservation_object_test_signaled_single(
+								fence_excl);
 			if (ret < 0)
 				goto unlock_retry;
 		}
diff --git a/drivers/dma-buf/seqno-fence.c b/drivers/dma-buf/seqno-fence.c
index 7d12a39..71127f8 100644
--- a/drivers/dma-buf/seqno-fence.c
+++ b/drivers/dma-buf/seqno-fence.c
@@ -24,24 +24,28 @@
 static const char *seqno_fence_get_driver_name(struct fence *fence)
 {
 	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+
 	return seqno_fence->ops->get_driver_name(fence);
 }
 
 static const char *seqno_fence_get_timeline_name(struct fence *fence)
 {
 	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+
 	return seqno_fence->ops->get_timeline_name(fence);
 }
 
 static bool seqno_enable_signaling(struct fence *fence)
 {
 	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+
 	return seqno_fence->ops->enable_signaling(fence);
 }
 
 static bool seqno_signaled(struct fence *fence)
 {
 	struct seqno_fence *seqno_fence = to_seqno_fence(fence);
+
 	return seqno_fence->ops->signaled && seqno_fence->ops->signaled(fence);
 }
 
@@ -56,9 +60,11 @@ static void seqno_release(struct fence *fence)
 		fence_free(&f->base);
 }
 
-static signed long seqno_wait(struct fence *fence, bool intr, signed long timeout)
+static signed long seqno_wait(struct fence *fence, bool intr,
+				signed long timeout)
 {
 	struct seqno_fence *f = to_seqno_fence(fence);
+
 	return f->ops->wait(fence, intr, timeout);
 }
 
-- 
1.9.1

