Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45716 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752388AbaCANOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 08:14:00 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATH v6 07/10] uvcvideo: Tell the user space we're using start-of-exposure timestamps
Date: Sat,  1 Mar 2014 15:17:04 +0200
Message-Id: <1393679828-25878-8-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UVC device provided timestamps are taken from the clock once the
exposure of the frame has begun, not when the reception of the frame would
have been finished as almost anywhere else. Show this to the user space by
using V4L2_BUF_FLAG_TSTAMP_SRC_SOE buffer flag.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_queue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_queue.c b/drivers/media/usb/uvc/uvc_queue.c
index 7c14616..935556e 100644
--- a/drivers/media/usb/uvc/uvc_queue.c
+++ b/drivers/media/usb/uvc/uvc_queue.c
@@ -151,7 +151,8 @@ int uvc_queue_init(struct uvc_video_queue *queue, enum v4l2_buf_type type,
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
-	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+		| V4L2_BUF_FLAG_TSTAMP_SRC_SOE;
 	ret = vb2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
-- 
1.7.10.4

