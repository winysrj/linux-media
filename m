Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46716 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753765AbaBOUvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Feb 2014 15:51:37 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, k.debski@samsung.com,
	hverkuil@xs4all.nl, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v5 4/7] uvcvideo: Tell the user space we're using start-of-exposure timestamps
Date: Sat, 15 Feb 2014 22:53:02 +0200
Message-Id: <1392497585-5084-5-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
References: <1392497585-5084-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UVC device provided timestamps are taken from the clock once the
exposure of the frame has begun, not when the reception of the frame would
have been finished as almost anywhere else. Show this to the user space by
using V4L2_BUF_FLAG_TSTAMP_SRC_SOE buffer flag.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/usb/uvc/uvc_queue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index cd962be..a9292d2 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -149,7 +149,8 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
-	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	queue->queue.timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
 	ret = vb2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
-- 
1.7.10.4

