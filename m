Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52975 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaAAMKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 Jan 2014 07:10:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] v4l: vb2: Fix comment in __qbuf_dmabuf
Date: Wed,  1 Jan 2014 13:10:48 +0100
Message-Id: <1388578248-3371-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The comment incorrectly explains that the code verifies information
provided by userspace, while verification has been performed earlier in
reality. Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 12df9fd..1fc2d7f 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1116,7 +1116,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
 	int ret;
 	int write = !V4L2_TYPE_IS_OUTPUT(q->type);
 
-	/* Verify and copy relevant information provided by the userspace */
+	/* Copy relevant information provided by the userspace */
 	__fill_vb2_buffer(vb, b, planes);
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
-- 
Regards,

Laurent Pinchart

