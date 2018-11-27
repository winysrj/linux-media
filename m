Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:58897 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbeK0WU3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 17:20:29 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.20] vb2: skip request checks for VIDIOC_PREPARE_BUF
Message-ID: <cdf0b2ed-5280-806c-bf69-4da7d764eb9f@cisco.com>
Date: Tue, 27 Nov 2018 12:22:37 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

VIDIOC_PREPARE_BUF should ignore V4L2_BUF_FLAG_REQUEST_FD since it isn't
doing anything with requests. So inform vb2_queue_or_prepare_buf whether
it is called from vb2_prepare_buf or vb2_qbuf and just return 0 in the
first case.

This was found when adding new v4l2-compliance checks.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 1244c246d0c4..1ac1b3f334f6 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -332,10 +332,10 @@ static int vb2_fill_vb2_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b
 }

 static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *mdev,
-				    struct v4l2_buffer *b,
-				    const char *opname,
+				    struct v4l2_buffer *b, bool is_prepare,
 				    struct media_request **p_req)
 {
+	const char *opname = is_prepare ? "prepare_buf" : "qbuf";
 	struct media_request *req;
 	struct vb2_v4l2_buffer *vbuf;
 	struct vb2_buffer *vb;
@@ -377,6 +377,9 @@ static int vb2_queue_or_prepare_buf(struct vb2_queue *q, struct media_device *md
 			return ret;
 	}

+	if (is_prepare)
+		return 0;
+
 	if (!(b->flags & V4L2_BUF_FLAG_REQUEST_FD)) {
 		if (q->uses_requests) {
 			dprintk(1, "%s: queue uses requests\n", opname);
@@ -656,7 +659,7 @@ int vb2_prepare_buf(struct vb2_queue *q, struct media_device *mdev,
 	if (b->flags & V4L2_BUF_FLAG_REQUEST_FD)
 		return -EINVAL;

-	ret = vb2_queue_or_prepare_buf(q, mdev, b, "prepare_buf", NULL);
+	ret = vb2_queue_or_prepare_buf(q, mdev, b, true, NULL);

 	return ret ? ret : vb2_core_prepare_buf(q, b->index, b);
 }
@@ -728,7 +731,7 @@ int vb2_qbuf(struct vb2_queue *q, struct media_device *mdev,
 		return -EBUSY;
 	}

-	ret = vb2_queue_or_prepare_buf(q, mdev, b, "qbuf", &req);
+	ret = vb2_queue_or_prepare_buf(q, mdev, b, false, &req);
 	if (ret)
 		return ret;
 	ret = vb2_core_qbuf(q, b->index, b, req);
