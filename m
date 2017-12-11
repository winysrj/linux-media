Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43968 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbdLKS2A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Dec 2017 13:28:00 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        Thierry Escande <thierry.escande@collabora.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v6 1/6] [media] vb2: add is_unordered callback for drivers
Date: Mon, 11 Dec 2017 16:27:36 -0200
Message-Id: <20171211182741.29712-2-gustavo@padovan.org>
In-Reply-To: <20171211182741.29712-1-gustavo@padovan.org>
References: <20171211182741.29712-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Explicit synchronization benefits a lot from ordered queues, they fit
better in a pipeline with DRM for example so create a opt-in way for
drivers notify videobuf2 that the queue is unordered.

Drivers don't need implement it if the queue is ordered.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-core.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index ef9b64398c8c..eddb38a2a2f3 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -368,6 +368,9 @@ struct vb2_buffer {
  *			callback by calling vb2_buffer_done() with either
  *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
  *			vb2_wait_for_all_buffers() function
+ * @is_unordered:	tell if the queue format is unordered. The default is
+ *			assumed to be ordered and this function only needs to
+ *			be implemented for unordered queues.
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
  *			the buffer back by calling vb2_buffer_done() function;
@@ -391,6 +394,7 @@ struct vb2_ops {
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
 	void (*stop_streaming)(struct vb2_queue *q);
+	int (*is_unordered)(struct vb2_queue *q);
 
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
@@ -564,6 +568,7 @@ struct vb2_queue {
 	u32				cnt_wait_finish;
 	u32				cnt_start_streaming;
 	u32				cnt_stop_streaming;
+	u32				cnt_is_unordered;
 #endif
 };
 
-- 
2.13.6
