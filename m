Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1236 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaIHOPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Sep 2014 10:15:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 10/12] vb2: add 'new_cookies' flag
Date: Mon,  8 Sep 2014 16:14:39 +0200
Message-Id: <1410185681-20111-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
References: <1410185681-20111-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This flag helps drivers that need to reprogram their DMA engine whenever
a plane cookie (== DMA address or DMA scatter-gather list) changes.

Otherwise they would have to reprogram the DMA engine for every frame.

Note that it is not possible to do this in buf_init() since dma_map_sg has
to be done first, which happens just before buf_prepare() in the prepare()
memop. It is dma_map_sg that sets up the dma addresses that are needed to
configure the DMA engine.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |  5 +++++
 include/media/videobuf2-core.h           | 14 ++++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 01bab25..7217eb1 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -391,6 +391,7 @@ static int __vb2_queue_alloc(struct vb2_queue *q, enum v4l2_memory memory,
 				kfree(vb);
 				break;
 			}
+			vb->new_cookies = 1;
 		}
 
 		q->bufs[q->num_buffers + buffer] = vb;
@@ -1373,6 +1374,8 @@ static int __buf_memory_prepare(struct vb2_buffer *vb)
 		for (plane = 0; plane < vb->num_planes; ++plane)
 			call_void_memop(vb, finish, vb->planes[plane].mem_priv);
 		call_void_vb_qop(vb, buf_finish_for_cpu, vb);
+	} else {
+		vb->new_cookies = 0;
 	}
 	return ret;
 }
@@ -1467,6 +1470,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			dprintk(1, "buffer initialization failed\n");
 			goto err;
 		}
+		vb->new_cookies = 1;
 	}
 
 	ret = __buf_memory_prepare(vb);
@@ -1591,6 +1595,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			dprintk(1, "buffer initialization failed\n");
 			goto err;
 		}
+		vb->new_cookies = 1;
 	}
 
 	ret = __buf_memory_prepare(vb);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index bf8bde2..9304718 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -186,6 +186,11 @@ struct vb2_queue;
  * @vb2_queue:		the queue to which this driver belongs
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue
+ * @new_cookies:	the planes of the buffer have new cookie values.
+ *			This happens if a new userptr or dmabuf is used for one
+ *			or more of the buffer planes. This will change the cookie
+ *			value of those planes and you may need to reprogram the DMA
+ *			engine when buf_prepare is called.
  * @state:		current buffer state; do not change
  * @queued_entry:	entry on the queued buffers list, which holds all
  *			buffers queued from userspace
@@ -200,6 +205,7 @@ struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
 
 	unsigned int		num_planes;
+	unsigned int		new_cookies:1;
 
 /* Private: internal use only */
 	enum vb2_buffer_state	state;
@@ -290,8 +296,12 @@ struct vb2_buffer {
  *			hardware operation in this callback; drivers that
  *			support	VIDIOC_CREATE_BUFS must also validate the
  *			buffer size, if they haven't done that yet in
- *			@buf_prepare_for_cpu. If an error is returned, the
- *			buffer will not be queued in the driver; optional.
+ *			@buf_prepare_for_cpu. If one or more of the plane
+ *			cookies (see vb2_plane_cookie) are updated, then
+ *			vb->new_cookies is set to 1. If buf_prepare returns
+ *			0 (success), then new_cookies is cleared automatically.
+ *			If an error is returned, then the buffer will not be
+ *			queued in the driver; optional.
  * @buf_finish:		called before every dequeue of the buffer back to
  *			userspace; the contents of the buffer cannot be
  *			accessed by the cpu at this stage as it is still setup
-- 
2.1.0

