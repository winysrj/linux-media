Return-path: <linux-media-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10797
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755765Ab2ENKY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 May 2012 06:24:57 -0400
From: Bob Liu <lliubbo@gmail.com>
To: <linux-media@vger.kernel.org>
CC: <laurent.pinchart@ideasonboard.com>, <mchehab@infradead.org>,
	<linux-uvc-devel@lists.berlios.de>,
	<uclinux-dist-devel@blackfin.uclinux.org>,
	Bob Liu <lliubbo@gmail.com>
Subject: [PATCH] drivers:media:video:uvc: fix uvc_v4l2_get_unmapped_area for NOMMU
Date: Mon, 14 May 2012 18:23:59 +0800
Message-ID: <1336991039-15970-1-git-send-email-lliubbo@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix uvc_v4l2_get_unmapped_area() for NOMMU arch like blackfin after framework
updated to use videobuf2.

Signed-off-by: Bob Liu <lliubbo@gmail.com>
---
 drivers/media/video/uvc/uvc_queue.c |   30 ------------------------------
 drivers/media/video/uvc/uvc_v4l2.c  |    2 +-
 2 files changed, 1 insertions(+), 31 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 518f77d..30be060 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -237,36 +237,6 @@ int uvc_queue_allocated(struct uvc_video_queue *queue)
 	return allocated;
 }
 
-#ifndef CONFIG_MMU
-/*
- * Get unmapped area.
- *
- * NO-MMU arch need this function to make mmap() work correctly.
- */
-unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
-		unsigned long pgoff)
-{
-	struct uvc_buffer *buffer;
-	unsigned int i;
-	unsigned long ret;
-
-	mutex_lock(&queue->mutex);
-	for (i = 0; i < queue->count; ++i) {
-		buffer = &queue->buffer[i];
-		if ((buffer->buf.m.offset >> PAGE_SHIFT) == pgoff)
-			break;
-	}
-	if (i == queue->count) {
-		ret = -EINVAL;
-		goto done;
-	}
-	ret = (unsigned long)buf->mem;
-done:
-	mutex_unlock(&queue->mutex);
-	return ret;
-}
-#endif
-
 /*
  * Enable or disable the video buffers queue.
  *
diff --git a/drivers/media/video/uvc/uvc_v4l2.c b/drivers/media/video/uvc/uvc_v4l2.c
index 2ae4f88..506d3d6 100644
--- a/drivers/media/video/uvc/uvc_v4l2.c
+++ b/drivers/media/video/uvc/uvc_v4l2.c
@@ -1067,7 +1067,7 @@ static unsigned long uvc_v4l2_get_unmapped_area(struct file *file,
 
 	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_get_unmapped_area\n");
 
-	return uvc_queue_get_unmapped_area(&stream->queue, pgoff);
+	return vb2_get_unmapped_area(&stream->queue, addr, len, pgoff, flags);
 }
 #endif
 
-- 
1.6.3.3


