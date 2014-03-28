Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36131 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaC1QAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:00:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: [PATCH v2 2/3] usb: gadget: uvc: Set the V4L2 buffer field to V4L2_FIELD_NONE
Date: Fri, 28 Mar 2014 17:02:47 +0100
Message-Id: <1396022568-6794-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The UVC gadget driver doesn't support interlaced video but left the
buffer field uninitialized. Set it to V4L2_FIELD_NONE.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/uvc_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index 9ac4ffe1..305eb49 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -380,6 +380,7 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	else
 		nextbuf = NULL;
 
+	buf->buf.v4l2_buf.field = V4L2_FIELD_NONE;
 	buf->buf.v4l2_buf.sequence = queue->sequence++;
 	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
 
-- 
1.8.3.2

