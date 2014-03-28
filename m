Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36130 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaC1QAy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 12:00:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-usb@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Roland Scheidegger <rscheidegger_lists@hispeed.ch>
Subject: [PATCH v2 1/3] usb: gadget: uvc: Switch to monotonic clock for buffer timestamps
Date: Fri, 28 Mar 2014 17:02:46 +0100
Message-Id: <1396022568-6794-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1396022568-6794-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The wall time clock isn't useful for applications as it can jump around
due to time adjustement. Switch to the monotonic clock.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/uvc_queue.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Changes since v1:

- Replace ktime_get_ts() with v4l2_get_timestamp()

diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index 0bb5d50..9ac4ffe1 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -20,6 +20,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
 
+#include <media/v4l2-common.h>
 #include <media/videobuf2-vmalloc.h>
 
 #include "uvc.h"
@@ -379,14 +380,8 @@ static struct uvc_buffer *uvc_queue_next_buffer(struct uvc_video_queue *queue,
 	else
 		nextbuf = NULL;
 
-	/*
-	 * FIXME: with videobuf2, the sequence number or timestamp fields
-	 * are valid only for video capture devices and the UVC gadget usually
-	 * is a video output device. Keeping these until the specs are clear on
-	 * this aspect.
-	 */
 	buf->buf.v4l2_buf.sequence = queue->sequence++;
-	do_gettimeofday(&buf->buf.v4l2_buf.timestamp);
+	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
 
 	vb2_set_plane_payload(&buf->buf, 0, buf->bytesused);
 	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
-- 
1.8.3.2

