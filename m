Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1648 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaBYKEz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Feb 2014 05:04:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 17/20] vb2: set timestamp when using write()
Date: Tue, 25 Feb 2014 11:04:22 +0100
Message-Id: <1393322665-29889-18-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
References: <1393322665-29889-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When using write() to write data to an output video node the vb2 core
should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
else is able to provide this information with the write() operation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2ac98ff..db95dcb 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
 #include <media/videobuf2-core.h>
 
 static int debug;
@@ -2797,6 +2798,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 {
 	struct vb2_fileio_data *fileio;
 	struct vb2_fileio_buf *buf;
+	bool set_timestamp = !read &&
+		q->timestamp_type == V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	int ret, index;
 
 	dprintk(3, "file io: mode %s, offset %ld, count %zd, %sblocking\n",
@@ -2909,6 +2912,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 			fileio->b.m.planes = &fileio->p;
 			fileio->b.length = 1;
 		}
+		if (set_timestamp)
+			v4l2_get_timestamp(&fileio->b.timestamp);
 		ret = vb2_internal_qbuf(q, &fileio->b);
 		dprintk(5, "file io: vb2_dbuf result: %d\n", ret);
 		if (ret)
-- 
1.9.0

