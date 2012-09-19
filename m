Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2818 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2ISOi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 10:38:26 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 2/6] videobuf2-core: use vb2_queue in __verify_planes_array
Date: Wed, 19 Sep 2012 16:37:36 +0200
Message-Id: <09515c88fe0760fddd124ec86995dc2cfdd56e7a.1348064901.git.hans.verkuil@cisco.com>
In-Reply-To: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
References: <9e4acd70e02bb67e6e7af0c236c69af27108e4fa.1348064901.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Since num_planes has been moved to vb2_queue, the __verify_planes_array()
function can now switch to a vb2_queue argument as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index febc23b..2e26e58 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -274,10 +274,8 @@ static void __vb2_queue_free(struct vb2_queue *q, unsigned int buffers)
  * __verify_planes_array() - verify that the planes array passed in struct
  * v4l2_buffer from userspace can be safely used
  */
-static int __verify_planes_array(struct vb2_buffer *vb, const struct v4l2_buffer *b)
+static int __verify_planes_array(struct vb2_queue *q, const struct v4l2_buffer *b)
 {
-	struct vb2_queue *q = vb->vb2_queue;
-
 	/* Is memory for copying plane information present? */
 	if (NULL == b->m.planes) {
 		dprintk(1, "Multi-planar buffer passed but "
@@ -344,7 +342,7 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	b->reserved = vb->v4l2_buf.reserved;
 
 	if (V4L2_TYPE_IS_MULTIPLANAR(q->type)) {
-		ret = __verify_planes_array(vb, b);
+		ret = __verify_planes_array(q, b);
 		if (ret)
 			return ret;
 
@@ -831,7 +829,7 @@ static int __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b,
 		 * Verify that the userspace gave us a valid array for
 		 * plane information.
 		 */
-		ret = __verify_planes_array(vb, b);
+		ret = __verify_planes_array(q, b);
 		if (ret)
 			return ret;
 
-- 
1.7.10.4

