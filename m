Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:60316 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbeLCNw6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 08:52:58 -0500
From: hverkuil-cisco@xs4all.nl
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, nicolas@ndufresne.ca,
        sakari.ailus@linux.intel.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv3 6/9] vb2: add new supports_tags queue flag
Date: Mon,  3 Dec 2018 14:51:40 +0100
Message-Id: <20181203135143.45487-7-hverkuil-cisco@xs4all.nl>
In-Reply-To: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
References: <20181203135143.45487-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Add new flag to indicate that buffer tags are supported.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/common/videobuf2/videobuf2-v4l2.c | 2 ++
 include/media/videobuf2-core.h                  | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index ecbf4f0755cb..189dd7fb12c0 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -665,6 +665,8 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_DMABUF;
 	if (q->supports_requests)
 		*caps |= V4L2_BUF_CAP_SUPPORTS_REQUESTS;
+	if (q->supports_tags)
+		*caps |= V4L2_BUF_CAP_SUPPORTS_TAGS;
 }
 
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index e86981d615ae..81f2dbfd0094 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -473,6 +473,7 @@ struct vb2_buf_ops {
  *              has not been called. This is a vb1 idiom that has been adopted
  *              also by vb2.
  * @supports_requests: this queue supports the Request API.
+ * @supports_tags: this queue supports tags in struct v4l2_buffer.
  * @uses_qbuf:	qbuf was used directly for this queue. Set to 1 the first
  *		time this is called. Set to 0 when the queue is canceled.
  *		If this is 1, then you cannot queue buffers from a request.
@@ -547,6 +548,7 @@ struct vb2_queue {
 	unsigned			allow_zero_bytesused:1;
 	unsigned		   quirk_poll_must_check_waiting_for_buffers:1;
 	unsigned			supports_requests:1;
+	unsigned			supports_tags:1;
 	unsigned			uses_qbuf:1;
 	unsigned			uses_requests:1;
 
-- 
2.19.1
