Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55962 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaCWPat (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Mar 2014 11:30:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: [PATCH 2/2] usb: gadget: uvc: Set the vb2 queue timestamp flags
Date: Sun, 23 Mar 2014 16:32:34 +0100
Message-Id: <1395588754-20587-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1395588754-20587-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <20140323001018.GA11963@localhost>
 <1395588754-20587-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2 queue timestamp_flags field must be set by drivers, as enforced
by a WARN_ON in vb2_queue_init. The UVC gadget driver failed to do so.
This resulted in the following warning.

[    2.104371] g_webcam gadget: uvc_function_bind
[    2.105567] ------------[ cut here ]------------
[    2.105567] ------------[ cut here ]------------
[    2.106779] WARNING: CPU: 0 PID: 1 at drivers/media/v4l2-core/videobuf2-core.c:2207 vb2_queue_init+0xa3/0x113()

Fix it.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/uvc_queue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index d4561ba..4611e9c 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -136,6 +136,8 @@ static int uvc_queue_init(struct uvc_video_queue *queue,
 	queue->queue.buf_struct_size = sizeof(struct uvc_buffer);
 	queue->queue.ops = &uvc_queue_qops;
 	queue->queue.mem_ops = &vb2_vmalloc_memops;
+	queue->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
+				     | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
 	ret = vb2_queue_init(&queue->queue);
 	if (ret)
 		return ret;
-- 
1.8.3.2

