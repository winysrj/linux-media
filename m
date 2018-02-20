Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:45922 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbeBTEpQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:45:16 -0500
Received: by mail-pl0-f66.google.com with SMTP id p5so6832303plo.12
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:45:16 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 12/21] media: videobuf2: add support for requests
Date: Tue, 20 Feb 2018 13:44:16 +0900
Message-Id: <20180220044425.169493-13-acourbot@chromium.org>
In-Reply-To: <20180220044425.169493-1-acourbot@chromium.org>
References: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make vb2 core aware of requests. Drivers can specify whether a given
queue accepts requests or not.

Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 3 +++
 include/media/videobuf2-core.h                  | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index debe35fc66b4..355fe7dc99d7 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -930,6 +930,9 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 		vb->state = state;
 	}
 	atomic_dec(&q->owned_by_drv_count);
+
+	vb->request = NULL;
+
 	spin_unlock_irqrestore(&q->done_lock, flags);
 
 	trace_vb2_buf_done(q, vb);
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 5b6c541e4e1b..6e9e814886e7 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -238,6 +238,7 @@ struct vb2_queue;
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue.
  * @timestamp:		frame timestamp in ns.
+ * @request:		request the buffer belongs to, if any.
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -246,6 +247,7 @@ struct vb2_buffer {
 	unsigned int		memory;
 	unsigned int		num_planes;
 	u64			timestamp;
+	struct media_request	*request;
 
 	/* private: internal use only
 	 *
@@ -446,6 +448,7 @@ struct vb2_buf_ops {
  * @quirk_poll_must_check_waiting_for_buffers: Return %EPOLLERR at poll when QBUF
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
+ * @allow_requests:	whether requests are supported on this queue.
  * @lock:	pointer to a mutex that protects the &struct vb2_queue. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -513,6 +516,7 @@ struct vb2_queue {
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
+	unsigned			allow_requests:1;
 
 	struct mutex			*lock;
 	void				*owner;
-- 
2.16.1.291.g4437f3f132-goog
