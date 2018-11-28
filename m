Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:33217 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727827AbeK1Tin (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Nov 2018 14:38:43 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH for v4.20 2/5] vb2: skip request checks for VIDIOC_PREPARE_BUF
Date: Wed, 28 Nov 2018 09:37:44 +0100
Message-Id: <20181128083747.18530-3-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
References: <20181128083747.18530-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

VIDIOC_PREPARE_BUF should ignore V4L2_BUF_FLAG_REQUEST_FD since it isn't
doing anything with requests. So inform vb2_queue_or_prepare_buf whether
it is called from vb2_prepare_buf or vb2_qbuf and just return 0 in the
first case.

This was found when adding new v4l2-compliance checks.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

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
-- 
2.19.1
