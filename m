Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:62614 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbBSPlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Feb 2015 10:41:04 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NK000BT6ZKF2BA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Fri, 20 Feb 2015 00:41:03 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH v4 2/4] vb2: add allow_zero_bytesused flag to the vb2_queue
 struct
Date: Thu, 19 Feb 2015 16:40:48 +0100
Message-id: <1424360450-13048-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1424360450-13048-1-git-send-email-k.debski@samsung.com>
References: <1424360450-13048-1-git-send-email-k.debski@samsung.com>
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
 include/media/videobuf2-core.h           |    2 ++
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 5cd60bf..b8a30d5 100644
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
index e49dc6b..a5790fd 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -337,6 +337,7 @@ struct v4l2_fh;
  * @io_modes:	supported io methods (see vb2_io_modes enum)
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
+ * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
  * @lock:	pointer to a mutex that protects the vb2_queue struct. The
  *		driver can set this to a mutex to let the v4l2 core serialize
  *		the queuing ioctls. If the driver wants to handle locking
@@ -388,6 +389,7 @@ struct vb2_queue {
 	unsigned int			io_modes;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
+	unsigned			allow_zero_bytesused:1;
 
 	struct mutex			*lock;
 	struct v4l2_fh			*owner;
-- 
1.7.9.5

