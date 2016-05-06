Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:63881 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758112AbcEFK4l (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 06:56:41 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [RFC 13/22] vb2: Add helper function to check for request buffers
Date: Fri,  6 May 2016 13:53:22 +0300
Message-Id: <1462532011-15527-14-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

The vb2_queue_has_request() function will check whether a buffer has
been prepared for the given request ID.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 17 +++++++++++++++++
 include/media/videobuf2-v4l2.h           |  2 ++
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index bb135fc..6c1c4bf 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -790,6 +790,23 @@ void vb2_queue_release(struct vb2_queue *q)
 }
 EXPORT_SYMBOL_GPL(vb2_queue_release);
 
+bool vb2_queue_has_request(struct vb2_queue *q, unsigned int request)
+{
+	unsigned int i;
+
+	for (i = 0; i < q->num_buffers; i++) {
+		struct vb2_buffer *vb = q->bufs[i];
+		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+		if (vb->state == VB2_BUF_STATE_PREPARED &&
+		    vbuf->request == request)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(vb2_queue_has_request);
+
 /**
  * vb2_poll() - implements poll userspace operation
  * @q:		videobuf2 queue
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index b1ee91c..7727c52 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -68,6 +68,8 @@ void vb2_queue_release(struct vb2_queue *q);
 unsigned int vb2_poll(struct vb2_queue *q, struct file *file,
 		poll_table *wait);
 
+bool vb2_queue_has_request(struct vb2_queue *q, unsigned int request);
+
 /*
  * The following functions are not part of the vb2 core API, but are simple
  * helper functions that you can use in your struct v4l2_file_operations,
-- 
1.9.1

