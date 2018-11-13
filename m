Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:49960 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733096AbeKNAFJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Nov 2018 19:05:09 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] vb2: vb2_mmap: move lock up
Message-ID: <71cb9482-fa06-def3-115e-105a0e0f3aec@xs4all.nl>
Date: Tue, 13 Nov 2018 15:06:46 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If a filehandle is dup()ped, then it is possible to close it from one fd
and call mmap from the other. This creates a race condition in vb2_mmap
where it is using queue data that __vb2_queue_free (called from close())
is in the process of releasing.

By moving up the mutex_lock(mmap_lock) in vb2_mmap this race is avoided
since __vb2_queue_free is called with the same mutex locked. So vb2_mmap
now reads consistent buffer data.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Reported-by: syzbot+be93025dd45dccd8923c@syzkaller.appspotmail.com
---
 drivers/media/common/videobuf2/videobuf2-core.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index c49c67473408..03954c13024c 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2120,9 +2120,13 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 			return -EINVAL;
 		}
 	}
+
+	mutex_lock(&q->mmap_lock);
+
 	if (vb2_fileio_is_active(q)) {
 		dprintk(1, "mmap: file io in progress\n");
-		return -EBUSY;
+		ret = -EBUSY;
+		goto unlock;
 	}

 	/*
@@ -2130,7 +2134,7 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 	 */
 	ret = __find_plane_by_offset(q, off, &buffer, &plane);
 	if (ret)
-		return ret;
+		goto unlock;

 	vb = q->bufs[buffer];

@@ -2146,8 +2150,9 @@ int vb2_mmap(struct vb2_queue *q, struct vm_area_struct *vma)
 		return -EINVAL;
 	}

-	mutex_lock(&q->mmap_lock);
 	ret = call_memop(vb, mmap, vb->planes[plane].mem_priv, vma);
+
+unlock:
 	mutex_unlock(&q->mmap_lock);
 	if (ret)
 		return ret;
-- 
2.19.1
