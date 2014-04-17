Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2641 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaDQJWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:22:03 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 3/3] vb2: fix compiler warning
Date: Thu, 17 Apr 2014 11:21:50 +0200
Message-Id: <1397726510-12005-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl>
References: <1397726510-12005-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When compiling this for older kernels using the compatibility build
the compiler complains about uninitialized variables:

In file included from include/linux/kernel.h:20:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/input.h:13,
                 from /home/hans/work/build/media_build/v4l/compat.h:9,
                 from <command-line>:0:
/home/hans/work/build/media_build/v4l/videobuf2-core.c: In function 'vb2_mmap':
include/linux/dynamic_debug.h:60:9: warning: 'plane' may be used uninitialized in this function [-Wmaybe-uninitialized]
   printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);  \
         ^
/home/hans/work/build/media_build/v4l/videobuf2-core.c:2381:23: note: 'plane' was declared here
  unsigned int buffer, plane;
                       ^
In file included from include/linux/kernel.h:20:0,
                 from include/linux/cache.h:4,
                 from include/linux/time.h:7,
                 from include/linux/input.h:13,
                 from /home/hans/work/build/media_build/v4l/compat.h:9,
                 from <command-line>:0:
include/linux/dynamic_debug.h:60:9: warning: 'buffer' may be used uninitialized in this function [-Wmaybe-uninitialized]
   printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__);  \
         ^
/home/hans/work/build/media_build/v4l/videobuf2-core.c:2381:15: note: 'buffer' was declared here
  unsigned int buffer, plane;
               ^

While these warnings are bogus (the call to __find_plane_by_offset will
set buffer and plane), it doesn't hurt to initialize these variables.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index f8f694a..40024d7 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -2378,7 +2378,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 {
 	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
 	struct vb2_buffer *vb;
-	unsigned int buffer, plane;
+	unsigned int buffer = 0, plane = 0;
 	int ret;
 	unsigned long length;
 
-- 
1.9.2

