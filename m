Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:45206 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab2ABOMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 09:12:36 -0500
Received: by wibhm6 with SMTP id hm6so8408700wib.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 06:12:35 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, pawel@osciak.com,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 2/2] uvcvideo: Allow userptr IO mode.
Date: Mon,  2 Jan 2012 15:12:23 +0100
Message-Id: <1325513543-17299-2-git-send-email-javier.martin@vista-silicon.com>
In-Reply-To: <1325513543-17299-1-git-send-email-javier.martin@vista-silicon.com>
References: <1325513543-17299-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Userptr can be very useful if a UVC camera
is requested to use video buffers allocated
by another processing device. So that
buffers don't need to be copied.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/video/uvc/uvc_queue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_queue.c b/drivers/media/video/uvc/uvc_queue.c
index 518f77d..8f54e24 100644
--- a/drivers/media/video/uvc/uvc_queue.c
+++ b/drivers/media/video/uvc/uvc_queue.c
@@ -126,7 +126,7 @@ void uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 		    int drop_corrupted)
 {
 	queue->queue.type = type;
-	queue->queue.io_modes = VB2_MMAP;
+	queue->queue.io_modes = VB2_MMAP | VB2_USERPTR;
 	queue->queue.drv_priv = queue;
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
-- 
1.7.0.4

