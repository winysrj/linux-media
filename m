Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1832 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaCJVVe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 17:21:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, sakari.ailus@iki.fi,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 07/11] vb2: reject output buffers with V4L2_FIELD_ALTERNATE
Date: Mon, 10 Mar 2014 22:20:54 +0100
Message-Id: <1394486458-9836-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is not allowed by the spec and does in fact not make any sense.
Return -EINVAL if this is the case.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index afd1268..8984187 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1526,6 +1526,15 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 			__func__, ret);
 		return ret;
 	}
+	if (V4L2_TYPE_IS_OUTPUT(q->type) && b->field == V4L2_FIELD_ALTERNATE) {
+		/*
+		 * If field is ALTERNATE, then we return an error.
+		 * If the format's field is ALTERNATE, then the buffer's field
+		 * should be either TOP or BOTTOM, but using ALTERNATE here as
+		 * well makes no sense.
+		 */
+		return -EINVAL;
+	}
 
 	vb->state = VB2_BUF_STATE_PREPARING;
 	vb->v4l2_buf.timestamp.tv_sec = 0;
-- 
1.9.0

