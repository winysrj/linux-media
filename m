Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:54940 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbbBSKLe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 05:11:34 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NK00035TKB9BT50@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 Feb 2015 19:11:33 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH v3 2/4] vb2: add allow_zero_bytesused flag to the vb2_queue
 struct
Date: Thu, 19 Feb 2015 11:11:18 +0100
Message-id: <1424340680-13817-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1424340680-13817-1-git-send-email-k.debski@samsung.com>
References: <1424340680-13817-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vb2: fix bytesused == 0 handling (8a75ffb) patch changed the behavior
of __fill_vb2_buffer function, so that if bytesused is 0 it is set to the
size of the buffer. However, bytesused set to 0 is used by older codec
drivers as as indication used to mark the end of stream.

To keep backward compatibility, this patch adds a flag passed to the
vb2_queue_init function - allow_zero_bytesused. If the flag is set upon
initialization of the queue, the videobuf2 keeps the value of bytesused
intact in the OUTPUT queue and passes it to the driver.

Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |   29 +++++++++++++++++++++++------
 include/media/videobuf2-core.h           |    1 +
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 62531956..487e31f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1276,13 +1276,22 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			 * userspace clearly never bothered to set it and
 			 * it's a safe assumption that they really meant to
 			 * use the full plane sizes.
+			 *
+			 * Some drivers, e.g. old codec drivers, use bytesused
+			 * == 0 as a way to indicate that streaming is finished.
+			 * In that case, the driver should use the
+			 * allow_zero_bytesused flag to keep old userspace
+			 * applications working.
 			 */
 			for (plane = 0; plane < vb->num_planes; ++plane) {
 				struct v4l2_plane *pdst = &v4l2_planes[plane];
 				struct v4l2_plane *psrc = &b->m.planes[plane];
 
-				pdst->bytesused = psrc->bytesused ?
-					psrc->bytesused : pdst->length;
+				if (vb->vb2_queue->allow_zero_bytesused)
+					pdst->bytesused = psrc->bytesused;
+				else
+					pdst->bytesused = psrc->bytesused ?
+						psrc->bytesused : pdst->length;
 				pdst->data_offset = psrc->data_offset;
 			}
 		}
@@ -1295,6 +1304,11 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 *
 		 * If bytesused == 0 for the output buffer, then fall back
 		 * to the full buffer size as that's a sensible default.
+		 *
+		 * Some drivers, e.g. old codec drivers, use bytesused * == 0 as
+		 * a way to indicate that streaming is finished. In that case,
+		 * the driver should use the allow_zero_bytesused flag to keep
+		 * old userspace applications working.
 		 */
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			v4l2_planes[0].m.userptr = b->m.userptr;
@@ -1306,10 +1320,13 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 			v4l2_planes[0].length = b->length;
 		}
 
-		if (V4L2_TYPE_IS_OUTPUT(b->type))
-			v4l2_planes[0].bytesused = b->bytesused ?
-				b->bytesused : v4l2_planes[0].length;
-		else
+		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
+			if (vb->vb2_queue->allow_zero_bytesused)
+				v4l2_planes[0].bytesused = b->bytesused;
+			else
+				v4l2_planes[0].bytesused = b->bytesused ?
+					b->bytesused : v4l2_planes[0].length;
+		} else
 			v4l2_planes[0].bytesused = 0;
 
 	}
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 1346693..50111bd573 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -388,6 +388,7 @@ struct vb2_queue {
 	unsigned int			io_modes;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
+	unsigned			allow_zero_bytesused:1;
 
 	struct mutex			*lock;
 	struct v4l2_fh			*owner;
-- 
1.7.9.5

