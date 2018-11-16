Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36760 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbeKQJ5A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 04:57:00 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH] media: videobuf2-core: fix use after free in vb2_mmap
Date: Fri, 16 Nov 2018 23:42:27 +0000
Message-Id: <20181116234227.27255-1-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we are using __find_plane_by_offset() to find the matching plane
number and the buffer, the queue is not locked. So, after we have
calculated the buffer number and assigned the pointer to vb, it can get
freed. And if that happens then we get a use-after-free when we try to
use this for the mmap and get the following calltrace:

[   30.623259] Call Trace:
[   30.623531]  dump_stack+0x244/0x39d
[   30.623914]  ? dump_stack_print_info.cold.1+0x20/0x20
[   30.624439]  ? printk+0xa7/0xcf
[   30.624777]  ? kmsg_dump_rewind_nolock+0xe4/0xe4
[   30.625265]  print_address_description.cold.7+0x9/0x1ff
[   30.625809]  kasan_report.cold.8+0x242/0x309
[   30.626263]  ? vb2_mmap+0x712/0x790
[   30.626637]  __asan_report_load8_noabort+0x14/0x20
[   30.627201]  vb2_mmap+0x712/0x790
[   30.627642]  ? vb2_poll+0x1d0/0x1d0
[   30.628060]  vb2_fop_mmap+0x4b/0x70
[   30.628458]  v4l2_mmap+0x153/0x200
[   30.628929]  mmap_region+0xe85/0x1cd0

Lock the queue before we start finding the matching plane and buffer so
that there is no chance of the memory being freed while we are about
to use it.

Reported-by: syzbot+be93025dd45dccd8923c@syzkaller.appspotmail.com
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 975ff5669f72..a81320566e02 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2125,9 +2125,12 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	/*
 	 * Find the plane corresponding to the offset passed by userspace.
 	 */
+	mutex_lock(&q->mmap_lock);
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
-	if (ret)
+	if (ret) {
+		mutex_unlock(&q->mmap_lock);
 		return ret;
+	}
 
 	vb = q->bufs[buffer];
 
@@ -2138,12 +2141,12 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	 */
 	length = PAGE_ALIGN(vb->planes[plane].length);
 	if (length < (vma->vm_end - vma->vm_start)) {
+		mutex_unlock(&q->mmap_lock);
 		dprintk(1,
 			"MMAP invalid, as it would overflow buffer length\n");
 		return -EINVAL;
 	}
 
-	mutex_lock(&q->mmap_lock);
 	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
 	mutex_unlock(&q->mmap_lock);
 	if (ret)
-- 
2.11.0
