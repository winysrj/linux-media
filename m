Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53068 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732824AbeHNRIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 13:08:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv18 24/35] videobuf2-core: embed media_request_object
Date: Tue, 14 Aug 2018 16:20:36 +0200
Message-Id: <20180814142047.93856-25-hverkuil@xs4all.nl>
In-Reply-To: <20180814142047.93856-1-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make vb2_buffer a request object.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 2eb24961183e..413b8b2dc485 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -17,6 +17,7 @@
 #include <linux/poll.h>
 #include <linux/dma-buf.h>
 #include <linux/bitops.h>
+#include <media/media-request.h>
 
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
@@ -236,6 +237,8 @@ struct vb2_queue;
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue.
  * @timestamp:		frame timestamp in ns.
+ * @req_obj:		used to bind this buffer to a request. This
+ *			request object has a refcount.
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -244,6 +247,7 @@ struct vb2_buffer {
 	unsigned int		memory;
 	unsigned int		num_planes;
 	u64			timestamp;
+	struct media_request_object	req_obj;
 
 	/* private: internal use only
 	 *
-- 
2.18.0
