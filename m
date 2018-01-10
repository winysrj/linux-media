Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:45404 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966003AbeAJQKC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 11:10:02 -0500
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
Subject: [PATCH v7 1/6] [media] vb2: add is_unordered callback for drivers
Date: Wed, 10 Jan 2018 14:07:27 -0200
Message-Id: <20180110160732.7722-2-gustavo@padovan.org>
In-Reply-To: <20180110160732.7722-1-gustavo@padovan.org>
References: <20180110160732.7722-1-gustavo@padovan.org>
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
index f3ee4c7c2fb3..583cdc06de79 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -370,6 +370,9 @@ struct vb2_buffer {
  *			callback by calling vb2_buffer_done() with either
  *			%VB2_BUF_STATE_DONE or %VB2_BUF_STATE_ERROR; may use
  *			vb2_wait_for_all_buffers() function
+ * @is_unordered:	tell if the queue format is unordered. The default is
+ *			assumed to be ordered and this function only needs to
+ *			be implemented for unordered queues.
  * @buf_queue:		passes buffer vb to the driver; driver may start
  *			hardware operation on this buffer; driver should give
  *			the buffer back by calling vb2_buffer_done() function;
@@ -393,6 +396,7 @@ struct vb2_ops {
 
 	int (*start_streaming)(struct vb2_queue *q, unsigned int count);
 	void (*stop_streaming)(struct vb2_queue *q);
+	int (*is_unordered)(struct vb2_queue *q);
 
 	void (*buf_queue)(struct vb2_buffer *vb);
 };
@@ -566,6 +570,7 @@ struct vb2_queue {
 	u32				cnt_wait_finish;
 	u32				cnt_start_streaming;
 	u32				cnt_stop_streaming;
+	u32				cnt_is_unordered;
 #endif
 };
 
-- 
2.14.3
