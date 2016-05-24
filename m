Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbcEXQvA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 12:51:00 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	mchehab@osg.samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC v2 12/21] vb2: Add allow_requests flag
Date: Tue, 24 May 2016 19:47:22 +0300
Message-Id: <1464108451-28142-13-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1464108451-28142-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 0721258..bb135fc 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -174,6 +174,11 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b,
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
index 8a0f55b..41dab63 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -400,6 +400,7 @@ struct vb2_buf_ops {
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
+ * @allow_requests:		allow request != 0 to be passed to the driver
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -463,6 +464,7 @@ struct vb2_queue {
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
+	unsigned			allow_requests:1;
 
 	struct mutex			*lock;
 	void				*owner;
-- 
1.9.1

