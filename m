Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43903 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751609AbeDIOUh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 10:20:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv11 PATCH 23/29] videobuf2-v4l2: export request_fd
Date: Mon,  9 Apr 2018 16:20:20 +0200
Message-Id: <20180409142026.19369-24-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-1-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Requested by Sakari

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 6 ++++--
 include/media/videobuf2-v4l2.h                  | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 3d0c74bb4220..7b79149b7fae 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -184,6 +184,7 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 		return -EINVAL;
 	}
 	vbuf->sequence = 0;
+	vbuf->request_fd = -1;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
 		switch (b->memory) {
@@ -391,6 +392,7 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 	}
 
 	*p_req = req;
+	vbuf->request_fd = b->request_fd;
 
 	return 0;
 }
@@ -496,9 +498,9 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 
 	if (vb2_buffer_in_use(q, vb))
 		b->flags |= V4L2_BUF_FLAG_MAPPED;
-	if (vb->req_obj.req) {
+	if (vbuf->request_fd >= 0) {
 		b->flags |= V4L2_BUF_FLAG_REQUEST_FD;
-		b->request_fd = -1;
+		b->request_fd = vbuf->request_fd;
 	}
 
 	if (!q->is_output &&
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 0baa3023d7ad..d3ee1f28e197 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -32,6 +32,7 @@
  *		&enum v4l2_field.
  * @timecode:	frame timecode.
  * @sequence:	sequence count of this frame.
+ * @request_fd:	the request_fd associated with this buffer
  * @planes:	plane information (userptr/fd, length, bytesused, data_offset).
  *
  * Should contain enough information to be able to cover all the fields
@@ -44,6 +45,7 @@ struct vb2_v4l2_buffer {
 	__u32			field;
 	struct v4l2_timecode	timecode;
 	__u32			sequence;
+	__s32			request_fd;
 	struct vb2_plane	planes[VB2_MAX_PLANES];
 };
 
-- 
2.16.3
