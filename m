Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59598 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdL1Q3p (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Dec 2017 11:29:45 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Satendra Singh Thakur <satendra.t@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/5] media: vb2: Fix a bug about unnecessary calls to queue cancel and free
Date: Thu, 28 Dec 2017 14:29:35 -0200
Message-Id: <73a2a81d072b56ab25b36c0f40515d83ef45fccc.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1514478428.git.mchehab@s-opensource.com>
References: <cover.1514478428.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Satendra Singh Thakur <satendra.t@samsung.com>

Currently, there's a logic with checks if *count is non-zero,
q->num_buffers is zero and q->memory is different than memory.

That's flawed when the device is initialized, or after the
queues are freed, as it does, unnecessary calls to
__vb2_queue_cancel() and  __vb2_queue_free().

That can be avoided by making sure that q->memory is set to
VB2_MEMORY_UNKNOWN at vb2_core_queue_init(), and adding such
check at the loop.

[mchehab@s-opensource.com: fix checkpatch issues and improve the
 patch, by setting q->memory to zero at vb2_core_queue_init]
Signed-off-by: Satendra Singh Thakur <satendra.t@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/videobuf/videobuf2-core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf/videobuf2-core.c b/drivers/media/common/videobuf/videobuf2-core.c
index a3b4836fc41d..1793bdb1fe54 100644
--- a/drivers/media/common/videobuf/videobuf2-core.c
+++ b/drivers/media/common/videobuf/videobuf2-core.c
@@ -523,7 +523,7 @@ static int __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
 
 	q->num_buffers -= buffers;
 	if (!q->num_buffers) {
-		q->memory = 0;
+		q->memory = VB2_MEMORY_UNKNOWN;
 		INIT_LIST_HEAD(&q->queued_list);
 	}
 	return 0;
@@ -665,7 +665,8 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		return -EBUSY;
 	}
 
-	if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
+	if (*count == 0 || q->num_buffers != 0 ||
+	    (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
@@ -1997,6 +1998,8 @@ int vb2_core_queue_init(struct vb2_queue *q)
 	mutex_init(&q->mmap_lock);
 	init_waitqueue_head(&q->done_wq);
 
+	q->memory = VB2_MEMORY_UNKNOWN;
+
 	if (q->buf_struct_size == 0)
 		q->buf_struct_size = sizeof(struct vb2_buffer);
 
-- 
2.14.3
