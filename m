Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:39868 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752244Ab2CVEux (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Mar 2012 00:50:53 -0400
From: Bhupesh Sharma <bhupesh.sharma@st.com>
To: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Cc: <laurent.pinchart@ideasonboard.com>, <spear-devel@list.st.com>,
	<linux-media@vger.kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH] usb: gadget/uvc: Remove non-required locking from 'uvc_queue_next_buffer' routine
Date: Thu, 22 Mar 2012 10:20:37 +0530
Message-ID: <4cead89e45e3e31fccae5bb6fbfb72b2ce1b8cd5.1332391406.git.bhupesh.sharma@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch removes the non-required spinlock acquire/release calls on
'queue_irqlock' from 'uvc_queue_next_buffer' routine.

This routine is called from 'video->encode' function (which translates to either
'uvc_video_encode_bulk' or 'uvc_video_encode_isoc') in 'uvc_video.c'.
As, the 'video->encode' routines are called with 'queue_irqlock' already held,
so acquiring a 'queue_irqlock' again in 'uvc_queue_next_buffer' routine causes
a spin lock recursion.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@st.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/usb/gadget/uvc_queue.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/uvc_queue.c b/drivers/usb/gadget/uvc_queue.c
index d776adb..104ae9c 100644
--- a/drivers/usb/gadget/uvc_queue.c
+++ b/drivers/usb/gadget/uvc_queue.c
@@ -543,11 +543,11 @@ done:
 	return ret;
 }
 
+/* called with &queue_irqlock held.. */
 static struct uvc_buffer *
 uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer *buf)
 {
 	struct uvc_buffer *nextbuf;
-	unsigned long flags;
 
 	if ((queue->flags & UVC_QUEUE_DROP_INCOMPLETE) &&
 	    buf->buf.length != buf->buf.bytesused) {
@@ -556,14 +556,12 @@ uvc_queue_next_buffer(struct uvc_video_queue *queue, struct uvc_buffer *buf)
 		return buf;
 	}
 
-	spin_lock_irqsave(&queue->irqlock, flags);
 	list_del(&buf->queue);
 	if (!list_empty(&queue->irqqueue))
 		nextbuf = list_first_entry(&queue->irqqueue, struct uvc_buffer,
 					   queue);
 	else
 		nextbuf = NULL;
-	spin_unlock_irqrestore(&queue->irqlock, flags);
 
 	buf->buf.sequence = queue->sequence++;
 	do_gettimeofday(&buf->buf.timestamp);
-- 
1.7.2.2

