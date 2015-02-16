Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41968 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbbBPSYn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 13:24:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] uvcvideo: Don't call vb2 mmap and get_unmapped_area with queue lock held
Date: Mon, 16 Feb 2015 20:25:34 +0200
Message-Id: <1424111134-22413-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf2 has long been subject to AB-BA style deadlocks due to the
queue lock and mmap_sem being taken in different orders for the mmap and
get_unmapped_area operations. The problem has been fixed by making those
two operations callable without taking the queue lock, using an
mmap_lock internal to videobuf2.

The uvcvideo driver still calls the mmap and get_unmapped_area
operations with the queue lock held, resulting in a potential deadlock.
As the operations can now be called without locking the queue, fix it.

Reported-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Bjørn, does this fix the circular locking dependency you have reported in
"[v3.19-rc7] possible circular locking dependency in uvc_queue_streamoff" ?
The report mentions involves locks, so I'm not 100% this patch will fix the
issue.

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 10c554e..87a19f3 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -306,25 +306,14 @@ int uvc_queue_streamoff(struct uvc_video_queue *queue, enum v4l2_buf_type type)
 
 int uvc_queue_mmap(struct uvc_video_queue *queue, struct vm_area_struct *vma)
 {
-	int ret;
-
-	mutex_lock(&queue->mutex);
-	ret = vb2_mmap(&queue->queue, vma);
-	mutex_unlock(&queue->mutex);
-
-	return ret;
+	return vb2_mmap(&queue->queue, vma);
 }
 
 #ifndef CONFIG_MMU
 unsigned long uvc_queue_get_unmapped_area(struct uvc_video_queue *queue,
 		unsigned long pgoff)
 {
-	unsigned long ret;
-
-	mutex_lock(&queue->mutex);
-	ret = vb2_get_unmapped_area(&queue->queue, 0, 0, pgoff, 0);
-	mutex_unlock(&queue->mutex);
-	return ret;
+	return vb2_get_unmapped_area(&queue->queue, 0, 0, pgoff, 0);
 }
 #endif
 
-- 
Regards,

Laurent Pinchart

