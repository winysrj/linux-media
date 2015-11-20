Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:38078 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162891AbbKTRCF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Nov 2015 12:02:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, jh1009.sung@samsung.com,
	inki.dae@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv11 13/15] videobuf2-core: fill in q->bufs[vb->index] before buf_init()
Date: Fri, 20 Nov 2015 17:45:46 +0100
Message-Id: <1448037948-36820-14-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
References: <1448037948-36820-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Fill in q->bufs[vb->index] before the call to buf_init: it makes
sense that this is initialized correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 96dca47..98b5449 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -352,6 +352,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 		vb->memory = memory;
 		for (plane = 0; plane < num_planes; ++plane)
 			vb->planes[plane].length = q->plane_sizes[plane];
+		q->bufs[vb->index] = vb;
 
 		/* Allocate video buffer memory for the MMAP type */
 		if (memory == VB2_MEMORY_MMAP) {
@@ -360,6 +361,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 				dprintk(1, "failed allocating memory for "
 						"buffer %d\n", buffer);
 				kfree(vb);
+				q->bufs[vb->index] = NULL;
 				break;
 			}
 			/*
@@ -372,12 +374,11 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum vb2_memory memory,
 				dprintk(1, "buffer %d %p initialization"
 					" failed\n", buffer, vb);
 				__vb2_buf_mem_free(vb);
+				q->bufs[vb->index] = NULL;
 				kfree(vb);
 				break;
 			}
 		}
-
-		q->bufs[q->num_buffers + buffer] = vb;
 	}
 
 	if (memory == VB2_MEMORY_MMAP)
-- 
2.6.2

