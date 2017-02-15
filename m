Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33114 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750719AbdBORzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 12:55:41 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/6] [media] vb2: only check ret if we assigned it
Date: Wed, 15 Feb 2017 15:55:28 -0200
Message-Id: <20170215175533.6384-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Move the ret check to the right level under if (pb). It is not
used by the code before that point if pb is NULL.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 7c1d390..94afbbf9 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -984,11 +984,12 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const void *pb)
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	if (pb)
+	if (pb) {
 		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
 				 vb, pb, planes);
-	if (ret)
-		return ret;
+		if (ret)
+			return ret;
+	}
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		/* Skip the plane if already verified */
@@ -1101,11 +1102,12 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 
 	memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
 	/* Copy relevant information provided by the userspace */
-	if (pb)
+	if (pb) {
 		ret = call_bufop(vb->vb2_queue, fill_vb2_buffer,
 				 vb, pb, planes);
-	if (ret)
-		return ret;
+		if (ret)
+			return ret;
+	}
 
 	for (plane = 0; plane < vb->num_planes; ++plane) {
 		struct dma_buf *dbuf = dma_buf_get(planes[plane].m.fd);
-- 
2.9.3
