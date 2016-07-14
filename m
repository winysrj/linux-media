Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46616
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcGNPKT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 11:10:19 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] vb2: include length in dmabuf qbuf debug message
Date: Thu, 14 Jul 2016 11:09:34 -0400
Message-Id: <1468508975-6146-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the the VIDIOC_QBUF ioctl fails due a wrong dmabuf length,
it's useful to get the invalid length as a debug information.

Before this patch:

vb2-core: __qbuf_dmabuf: invalid dmabuf length for plane 1

After this patch:

vb2-core: __qbuf_dmabuf: invalid dmabuf length 221248 for plane 1

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/v4l2-core/videobuf2-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index ca8ffeb56d72..97d1483e0f7a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1228,8 +1228,8 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 			planes[plane].length = dbuf->size;
 
 		if (planes[plane].length < vb->planes[plane].min_length) {
-			dprintk(1, "invalid dmabuf length for plane %d\n",
-				plane);
+			dprintk(1, "invalid dmabuf length %d for plane %d\n",
+				planes[plane].length, plane);
 			dma_buf_put(dbuf);
 			ret = -EINVAL;
 			goto err;
-- 
2.5.5

