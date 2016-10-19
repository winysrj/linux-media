Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:60061 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933749AbcJSONA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 10:13:00 -0400
From: Thierry Escande <thierry.escande@collabora.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/2] [media] vb2: Add support for capture_dma_bidirectional queue flag
Date: Wed, 19 Oct 2016 10:24:17 +0200
Message-Id: <1476865457-506-3-git-send-email-thierry.escande@collabora.com>
In-Reply-To: <1476865457-506-1-git-send-email-thierry.escande@collabora.com>
References: <1476865457-506-1-git-send-email-thierry.escande@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset = "utf-8"
Content-Transfert-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

When this flag is set for CAPTURE queues by the driver on calling
vb2_queue_init(), it forces the buffers on the queue to be
allocated/mapped with DMA_BIDIRECTIONAL direction flag, instead of
DMA_FROM_DEVICE. This allows the device not only to write to the
buffers, but also read out from them. This may be useful e.g. for codec
hardware, which may be using CAPTURE buffers as reference to decode
other buffers.

This flag is ignored for OUTPUT queues, as we don't want to allow HW to
be able to write to OUTPUT buffers.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Tested-by: Pawel Osciak <posciak@chromium.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Signed-off-by: Thierry Escande <thierry.escande@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c |  3 +--
 include/media/videobuf2-core.h           | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index fde1e2d..c92197c 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -659,8 +659,7 @@ int vb2_queue_init(struct vb2_queue *q)
 	 * queues will always initialize waiting_for_buffers to false.
 	 */
 	q->quirk_poll_must_check_waiting_for_buffers = true;
-	q->dma_dir = V4L2_TYPE_IS_OUTPUT(q->type)
-		   ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	q->dma_dir = VB2_DMA_DIR(q);
 
 	return vb2_core_queue_init(q);
 }
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 38410dd..cd55917 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -433,6 +433,9 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return POLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @capture_dma_bidirectional:	use DMA_BIDIRECTIONAL for CAPTURE buffers; this
+ *				allows HW to read from the CAPTURE buffers in
+ *				addition to writing; ignored for OUTPUT queues.
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -500,6 +503,7 @@ struct vb2_queue {
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
+	unsigned			capture_dma_bidirectional:1;
 
 	struct mutex			*lock;
 	void				*owner;
@@ -556,6 +560,16 @@ struct vb2_queue {
 #endif
 };
 
+/*
+ * Return the corresponding DMA direction given the vb2_queue type (capture or
+ * output). returns DMA_BIRECTIONAL for capture buffers if set by the driver.
+ */
+#define VB2_DMA_DIR(q) (V4L2_TYPE_IS_OUTPUT((q)->type)   \
+			? DMA_TO_DEVICE                  \
+			: (q)->capture_dma_bidirectional \
+			  ? DMA_BIDIRECTIONAL            \
+			  : DMA_FROM_DEVICE)
+
 /**
  * vb2_plane_vaddr() - Return a kernel virtual address of a given plane
  * @vb:		vb2_buffer to which the plane in question belongs to
-- 
2.7.4

