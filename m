Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47258 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2LQKhG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 05:37:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] v4l: vb2: Set data_offset to 0 for single-plane output buffers
Date: Mon, 17 Dec 2012 11:38:16 +0100
Message-Id: <1355740696-11400-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Single-planar V4L2 buffers are converted to multi-planar vb2 buffers
with a single plane when queued. The plane data_offset field is not
available in the single-planar API and must be set to 0 for all output
buffers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

Hi Marek,

Could you please take this patch in your tree ?

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 9f81be2..e02c479 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -921,8 +921,10 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 		 * In videobuf we use our internal V4l2_planes struct for
 		 * single-planar buffers as well, for simplicity.
 		 */
-		if (V4L2_TYPE_IS_OUTPUT(b->type))
+		if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 			v4l2_planes[0].bytesused = b->bytesused;
+			v4l2_planes[0].data_offset = 0;
+		}
 
 		if (b->memory == V4L2_MEMORY_USERPTR) {
 			v4l2_planes[0].m.userptr = b->m.userptr;
-- 
Regards,

Laurent Pinchart

