Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1428 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867AbaDKIMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 07/13] vb2: reject output buffers with V4L2_FIELD_ALTERNATE
Date: Fri, 11 Apr 2014 10:11:13 +0200
Message-Id: <1397203879-37443-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is not allowed by the spec and does in fact not make any sense.
Return -EINVAL if this is the case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 6e05495..f8c0247 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1511,6 +1511,19 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 		dprintk(1, "plane parameters verification failed: %d\n", ret);
 		return ret;
 	}
+	if (b->field == V4L2_FIELD_ALTERNATE && V4L2_TYPE_IS_OUTPUT(q->type)) {
+		/*
+		 * If the format's field is ALTERNATE, then the buffer's field
+		 * should be either TOP or BOTTOM, not ALTERNATE since that
+		 * makes no sense. The driver has to know whether the
+		 * buffer represents a top or a bottom field in order to
+		 * program any DMA correctly. Using ALTERNATE is wrong, since
+		 * that just says that it is either a top or a bottom field,
+		 * but not which of the two it is.
+		 */
+		dprintk(1, "the field is incorrectly set to ALTERNATE for an output buffer\n");
+		return -EINVAL;
+	}
 
 	vb->state = VB2_BUF_STATE_PREPARING;
 	vb->v4l2_buf.timestamp.tv_sec = 0;
-- 
1.9.1

