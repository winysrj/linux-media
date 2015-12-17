Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934193AbbLQIlM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:12 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 32/48] vb2: Add allow_requests flag
Date: Thu, 17 Dec 2015 10:40:10 +0200
Message-Id: <1450341626-6695-33-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The driver has to set allow_requests explicitly in order to allow
queuing or preparing buffers for a specific request ID.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 5 +++++
 include/media/videobuf2-core.h           | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index f6a2800e5f66..2c8776891535 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -169,6 +169,11 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
 		return -EINVAL;
 	}
 
+	if (!q->allow_requests && b->request) {
+		dprintk(1, "%s: unsupported request ID\n", opname);
+		return -EINVAL;
+	}
+
 	return __verify_planes_array(q->bufs[b->index], b);
 }
 
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 647ebfe5174f..5eb30071dcf1 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -379,6 +379,7 @@ struct vb2_buf_ops {
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
+ * @allow_requests:		allow request != 0 to be passed to the driver
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -441,6 +442,7 @@ struct vb2_queue {
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
+	unsigned			allow_requests:1;
 
 	struct mutex			*lock;
 	void				*owner;
-- 
2.4.10

