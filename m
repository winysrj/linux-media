Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2380 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaHGGsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Aug 2014 02:48:23 -0400
Message-ID: <53E320F2.2000303@xs4all.nl>
Date: Thu, 07 Aug 2014 08:47:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCHv4] videobuf2: fix lockdep warning
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v3: renamed queue_lock to mmap_lock.

The following lockdep warning has been there ever since commit a517cca6b24fc54ac209e44118ec8962051662e3
one year ago:

[  403.117947] ======================================================
[  403.117949] [ INFO: possible circular locking dependency detected ]
[  403.117953] 3.16.0-rc6-test-media #961 Not tainted
[  403.117954] -------------------------------------------------------
[  403.117956] v4l2-ctl/15377 is trying to acquire lock:
[  403.117959]  (&dev->mutex#3){+.+.+.}, at: [<ffffffffa005a6c3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]
[  403.117974]
[  403.117974] but task is already holding lock:
[  403.117976]  (&mm->mmap_sem){++++++}, at: [<ffffffff8118291f>] vm_mmap_pgoff+0x6f/0xc0
[  403.117987]
[  403.117987] which lock already depends on the new lock.
[  403.117987]
[  403.117990]
[  403.117990] the existing dependency chain (in reverse order) is:
[  403.117992]
[  403.117992] -> #1 (&mm->mmap_sem){++++++}:
[  403.117997]        [<ffffffff810d733c>] validate_chain.isra.39+0x5fc/0x9a0
[  403.118006]        [<ffffffff810d8bc3>] __lock_acquire+0x4d3/0xd30
[  403.118010]        [<ffffffff810d9da7>] lock_acquire+0xa7/0x160
[  403.118014]        [<ffffffff8118c9ec>] might_fault+0x7c/0xb0
[  403.118018]        [<ffffffffa0028a25>] video_usercopy+0x425/0x610 [videodev]
[  403.118028]        [<ffffffffa0028c25>] video_ioctl2+0x15/0x20 [videodev]
[  403.118034]        [<ffffffffa0022764>] v4l2_ioctl+0x184/0x1a0 [videodev]
[  403.118040]        [<ffffffff811d77d0>] do_vfs_ioctl+0x2f0/0x4f0
[  403.118307]        [<ffffffff811d7a51>] SyS_ioctl+0x81/0xa0
[  403.118311]        [<ffffffff8199dc69>] system_call_fastpath+0x16/0x1b
[  403.118319]
[  403.118319] -> #0 (&dev->mutex#3){+.+.+.}:
[  403.118324]        [<ffffffff810d6a96>] check_prevs_add+0x746/0x9f0
[  403.118329]        [<ffffffff810d733c>] validate_chain.isra.39+0x5fc/0x9a0
[  403.118333]        [<ffffffff810d8bc3>] __lock_acquire+0x4d3/0xd30
[  403.118336]        [<ffffffff810d9da7>] lock_acquire+0xa7/0x160
[  403.118340]        [<ffffffff81999664>] mutex_lock_interruptible_nested+0x64/0x640
[  403.118344]        [<ffffffffa005a6c3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]
[  403.118349]        [<ffffffffa0022122>] v4l2_mmap+0x62/0xa0 [videodev]
[  403.118354]        [<ffffffff81197270>] mmap_region+0x3d0/0x5d0
[  403.118359]        [<ffffffff8119778d>] do_mmap_pgoff+0x31d/0x400
[  403.118363]        [<ffffffff81182940>] vm_mmap_pgoff+0x90/0xc0
[  403.118366]        [<ffffffff81195cef>] SyS_mmap_pgoff+0x1df/0x2a0
[  403.118369]        [<ffffffff810085c2>] SyS_mmap+0x22/0x30
[  403.118376]        [<ffffffff8199dc69>] system_call_fastpath+0x16/0x1b
[  403.118381]
[  403.118381] other info that might help us debug this:
[  403.118381]
[  403.118383]  Possible unsafe locking scenario:
[  403.118383]
[  403.118385]        CPU0                    CPU1
[  403.118387]        ----                    ----
[  403.118388]   lock(&mm->mmap_sem);
[  403.118391]                                lock(&dev->mutex#3);
[  403.118394]                                lock(&mm->mmap_sem);
[  403.118397]   lock(&dev->mutex#3);
[  403.118400]
[  403.118400]  *** DEADLOCK ***
[  403.118400]
[  403.118403] 1 lock held by v4l2-ctl/15377:
[  403.118405]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff8118291f>] vm_mmap_pgoff+0x6f/0xc0
[  403.118411]
[  403.118411] stack backtrace:
[  403.118415] CPU: 0 PID: 15377 Comm: v4l2-ctl Not tainted 3.16.0-rc6-test-media #961
[  403.118418] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 07/31/2013
[  403.118420]  ffffffff82a6c9d0 ffff8800af37fb00 ffffffff819916a2 ffffffff82a6c9d0
[  403.118425]  ffff8800af37fb40 ffffffff810d5715 ffff8802308e4200 0000000000000000
[  403.118429]  ffff8802308e4a48 ffff8802308e4a48 ffff8802308e4200 0000000000000001
[  403.118433] Call Trace:
[  403.118441]  [<ffffffff819916a2>] dump_stack+0x4e/0x7a
[  403.118445]  [<ffffffff810d5715>] print_circular_bug+0x1d5/0x2a0
[  403.118449]  [<ffffffff810d6a96>] check_prevs_add+0x746/0x9f0
[  403.118455]  [<ffffffff8119c172>] ? find_vmap_area+0x42/0x70
[  403.118459]  [<ffffffff810d733c>] validate_chain.isra.39+0x5fc/0x9a0
[  403.118463]  [<ffffffff810d8bc3>] __lock_acquire+0x4d3/0xd30
[  403.118468]  [<ffffffff810d9da7>] lock_acquire+0xa7/0x160
[  403.118472]  [<ffffffffa005a6c3>] ? vb2_fop_mmap+0x33/0x90 [videobuf2_core]
[  403.118476]  [<ffffffffa005a6c3>] ? vb2_fop_mmap+0x33/0x90 [videobuf2_core]
[  403.118480]  [<ffffffff81999664>] mutex_lock_interruptible_nested+0x64/0x640
[  403.118484]  [<ffffffffa005a6c3>] ? vb2_fop_mmap+0x33/0x90 [videobuf2_core]
[  403.118488]  [<ffffffffa005a6c3>] ? vb2_fop_mmap+0x33/0x90 [videobuf2_core]
[  403.118493]  [<ffffffff810d8055>] ? mark_held_locks+0x75/0xa0
[  403.118497]  [<ffffffffa005a6c3>] vb2_fop_mmap+0x33/0x90 [videobuf2_core]
[  403.118502]  [<ffffffffa0022122>] v4l2_mmap+0x62/0xa0 [videodev]
[  403.118506]  [<ffffffff81197270>] mmap_region+0x3d0/0x5d0
[  403.118510]  [<ffffffff8119778d>] do_mmap_pgoff+0x31d/0x400
[  403.118513]  [<ffffffff81182940>] vm_mmap_pgoff+0x90/0xc0
[  403.118517]  [<ffffffff81195cef>] SyS_mmap_pgoff+0x1df/0x2a0
[  403.118521]  [<ffffffff810085c2>] SyS_mmap+0x22/0x30
[  403.118525]  [<ffffffff8199dc69>] system_call_fastpath+0x16/0x1b

The reason is that vb2_fop_mmap and vb2_fop_get_unmapped_area take the core lock
while they are called with the mmap_sem semaphore held. But elsewhere in the code
the core lock is taken first but calls to copy_to/from_user() can take the mmap_sem
semaphore as well, potentially causing a classical A-B/B-A deadlock.

However, the mmap/get_unmapped_area calls really shouldn't take the core lock
at all. So what would happen if they don't take the core lock anymore?

There are two situations that need to be taken into account: calling mmap while
new buffers are being added and calling mmap while buffers are being deleted.

The first case works almost fine without a lock: in all cases mmap relies on
correctly filled-in q->num_buffers/q->num_planes values and those are only
updated by reqbufs and create_buffers *after* any new buffers have been
initialized completely. Except in one case: if an error occurred while allocating
the buffers it will increase num_buffers and rely on __vb2_queue_free to
decrease it again. So there is a short period where the buffer information
may be wrong.

The second case definitely does pose a problem: buffers may be in the process
of being deleted, without the internal structure being updated.

In order to fix this a new mutex is added to vb2_queue that is taken when
buffers are allocated or deleted, and in vb2_mmap. That way vb2_mmap won't
get stale buffer data. Note that this is a problem only for MEMORY_MMAP, so
even though __qbuf_userptr and __qbuf_dmabuf also mess around with buffers
(mem_priv in particular), this doesn't clash with vb2_mmap or
vb2_get_unmapped_area since those are MMAP specific.

As an additional bonus the hack in __buf_prepare, the USERPTR case, can be
removed as well since mmap() no longer takes the core lock.

All in all a much cleaner solution.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 56 +++++++++++---------------------
 include/media/videobuf2-core.h           |  2 ++
 2 files changed, 21 insertions(+), 37 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index c359006..6554bf3 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -882,7 +882,9 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
 		 */
+		mutex_lock(&q->mmap_lock);
 		if (q->memory == V4L2_MEMORY_MMAP && __buffers_in_use(q)) {
+			mutex_unlock(&q->mmap_lock);
 			dprintk(1, "memory in use, cannot free\n");
 			return -EBUSY;
 		}
@@ -894,6 +896,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 */
 		__vb2_queue_cancel(q);
 		ret = __vb2_queue_free(q, q->num_buffers);
+		mutex_unlock(&q->mmap_lock);
 		if (ret)
 			return ret;
 
@@ -955,6 +958,7 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 */
 	}
 
+	mutex_lock(&q->mmap_lock);
 	q->num_buffers = allocated_buffers;
 
 	if (ret < 0) {
@@ -963,8 +967,10 @@ static int __reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 		 * from q->num_buffers.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
+		mutex_unlock(&q->mmap_lock);
 		return ret;
 	}
+	mutex_unlock(&q->mmap_lock);
 
 	/*
 	 * Return the number of successfully allocated buffers
@@ -1061,6 +1067,7 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		 */
 	}
 
+	mutex_lock(&q->mmap_lock);
 	q->num_buffers += allocated_buffers;
 
 	if (ret < 0) {
@@ -1069,8 +1076,10 @@ static int __create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create
 		 * from q->num_buffers.
 		 */
 		__vb2_queue_free(q, allocated_buffers);
+		mutex_unlock(&q->mmap_lock);
 		return -ENOMEM;
 	}
+	mutex_unlock(&q->mmap_lock);
 
 	/*
 	 * Return the number of successfully allocated buffers
@@ -1582,7 +1591,6 @@ static void __enqueue_in_driver(struct vb2_buffer *vb)
 static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 {
 	struct vb2_queue *q = vb->vb2_queue;
-	struct rw_semaphore *mmap_sem;
 	int ret;
 
 	ret = __verify_length(vb, b);
@@ -1619,26 +1627,7 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		ret = __qbuf_mmap(vb, b);
 		break;
 	case V4L2_MEMORY_USERPTR:
-		/*
-		 * In case of user pointer buffers vb2 allocators need to get
-		 * direct access to userspace pages. This requires getting
-		 * the mmap semaphore for read access in the current process
-		 * structure. The same semaphore is taken before calling mmap
-		 * operation, while both qbuf/prepare_buf and mmap are called
-		 * by the driver or v4l2 core with the driver's lock held.
-		 * To avoid an AB-BA deadlock (mmap_sem then driver's lock in
-		 * mmap and driver's lock then mmap_sem in qbuf/prepare_buf),
-		 * the videobuf2 core releases the driver's lock, takes
-		 * mmap_sem and then takes the driver's lock again.
-		 */
-		mmap_sem = &current->mm->mmap_sem;
-		call_void_qop(q, wait_prepare, q);
-		down_read(mmap_sem);
-		call_void_qop(q, wait_finish, q);
-
 		ret = __qbuf_userptr(vb, b);
-
-		up_read(mmap_sem);
 		break;
 	case V4L2_MEMORY_DMABUF:
 		ret = __qbuf_dmabuf(vb, b);
@@ -2485,7 +2474,9 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	mutex_lock(&q->mmap_lock);
 	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
+	mutex_unlock(&q->mmap_lock);
 	if (ret)
 		return ret;
 
@@ -2504,6 +2495,7 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 	unsigned long off = pgoff << PAGE_SHIFT;
 	struct vb2_buffer *vb;
 	unsigned int buffer, plane;
+	void *vaddr;
 	int ret;
 
 	if (q->memory != V4L2_MEMORY_MMAP) {
@@ -2520,7 +2512,8 @@ unsigned long vb2_get_unmapped_area(struct vb2_queue *q,
 
 	vb = q->bufs[buffer];
 
-	return (unsigned long)vb2_plane_vaddr(vb, plane);
+	vaddr = vb2_plane_vaddr(vb, plane);
+	return vaddr ? (unsigned long)vaddr : -EINVAL;
 }
 EXPORT_SYMBOL_GPL(vb2_get_unmapped_area);
 #endif
@@ -2660,6 +2653,7 @@ int vb2_queue_init(struct vb2_queue *q)
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
 	spin_lock_init(&q->done_lock);
+	mutex_init(&q->mmap_lock);
 	init_waitqueue_head(&q->done_wq);
 
 	if (q->buf_struct_size == 0)
@@ -2681,7 +2675,9 @@ void vb2_queue_release(struct vb2_queue *q)
 {
 	__vb2_cleanup_fileio(q);
 	__vb2_queue_cancel(q);
+	mutex_lock(&q->mmap_lock);
 	__vb2_queue_free(q, q->num_buffers);
+	mutex_unlock(&q->mmap_lock);
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
@@ -3346,15 +3342,8 @@ EXPORT_SYMBOL_GPL(vb2_ioctl_expbuf);
 int vb2_fop_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
-	int err;
 
-	if (lock && mutex_lock_interruptible(lock))
-		return -ERESTARTSYS;
-	err = vb2_mmap(vdev->queue, vma);
-	if (lock)
-		mutex_unlock(lock);
-	return err;
+	return vb2_mmap(vdev->queue, vma);
 }
 EXPORT_SYMBOL_GPL(vb2_fop_mmap);
 
@@ -3473,15 +3462,8 @@ unsigned long vb2_fop_get_unmapped_area(struct file *file, unsigned long addr,
 		unsigned long len, unsigned long pgoff, unsigned long flags)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct mutex *lock = vdev->queue->lock ? vdev->queue->lock : vdev->lock;
-	int ret;
 
-	if (lock && mutex_lock_interruptible(lock))
-		return -ERESTARTSYS;
-	ret = vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
-	if (lock)
-		mutex_unlock(lock);
-	return ret;
+	return vb2_get_unmapped_area(vdev->queue, addr, len, pgoff, flags);
 }
 EXPORT_SYMBOL_GPL(vb2_fop_get_unmapped_area);
 #endif
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index fc910a6..ae1289b 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -366,6 +366,7 @@ struct v4l2_fh;
  *		cannot be started unless at least this number of buffers
  *		have been queued into the driver.
  *
+ * @mmap_lock:	private mutex used when buffers are allocated/freed/mmapped
  * @memory:	current memory type used
  * @bufs:	videobuf buffer structures
  * @num_buffers: number of allocated/used buffers
@@ -399,6 +400,7 @@ struct vb2_queue {
 	u32				min_buffers_needed;
 
 /* private: internal use only */
+	struct mutex			mmap_lock;
 	enum v4l2_memory		memory;
 	struct vb2_buffer		*bufs[VIDEO_MAX_FRAME];
 	unsigned int			num_buffers;
-- 
2.0.1

