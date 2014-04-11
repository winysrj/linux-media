Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4755 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbaDKIMO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 04:12:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv3 PATCH 06/13] vb2: set timestamp when using write()
Date: Fri, 11 Apr 2014 10:11:12 +0200
Message-Id: <1397203879-37443-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When using write() to write data to an output video node the vb2 core
should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
else is able to provide this information with the write() operation.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Pawel Osciak <pawel@osciak.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 2e448a7..6e05495 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -22,6 +22,7 @@
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
+#include <media/v4l2-common.h>
 #include <media/videobuf2-core.h>
 
 static int debug;
@@ -2751,6 +2752,14 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 {
 	struct vb2_fileio_data *fileio;
 	struct vb2_fileio_buf *buf;
+	/*
+	 * When using write() to write data to an output video node the vb2 core
+	 * should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
+	 * else is able to provide this information with the write() operation.
+	 */
+	bool set_timestamp = !read &&
+		(q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+		V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	int ret, index;
 
 	dprintk(3, "mode %s, offset %ld, count %zd, %sblocking\n",
@@ -2852,6 +2861,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
 		fileio->b.memory = q->memory;
 		fileio->b.index = index;
 		fileio->b.bytesused = buf->pos;
+		if (set_timestamp)
+			v4l2_get_timestamp(&fileio->b.timestamp);
 		ret = vb2_internal_qbuf(q, &fileio->b);
 		dprintk(5, "vb2_dbuf result: %d\n", ret);
 		if (ret)
-- 
1.9.1

