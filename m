Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:45099 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752291AbeDIOUf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 10:20:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv11 PATCH 18/29] videobuf2-core: embed media_request_object
Date: Mon,  9 Apr 2018 16:20:15 +0200
Message-Id: <20180409142026.19369-19-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-1-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Make vb2_buffer a request object.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/videobuf2-core.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 224c4820a044..3d54654c3cd4 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -17,6 +17,7 @@
 #include <linux/poll.h>
 #include <linux/dma-buf.h>
 #include <linux/bitops.h>
+#include <media/media-request.h>
 
 #define VB2_MAX_FRAME	(32)
 #define VB2_MAX_PLANES	(8)
@@ -238,6 +239,7 @@ struct vb2_queue;
  * @num_planes:		number of planes in the buffer
  *			on an internal driver queue.
  * @timestamp:		frame timestamp in ns.
+ * @req_obj:		used to bind this buffer to a request
  */
 struct vb2_buffer {
 	struct vb2_queue	*vb2_queue;
@@ -246,6 +248,7 @@ struct vb2_buffer {
 	unsigned int		memory;
 	unsigned int		num_planes;
 	u64			timestamp;
+	struct media_request_object	req_obj;
 
 	/* private: internal use only
 	 *
-- 
2.16.3
