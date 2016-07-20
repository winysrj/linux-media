Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47163
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbcGTQIQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 12:08:16 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v2] [media] vb2: include lengths in dmabuf qbuf debug message
Date: Wed, 20 Jul 2016 12:07:55 -0400
Message-Id: <1469030875-2246-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the VIDIOC_QBUF ioctl fails due a wrong dmabuf length, it's
useful to get the invalid and minimum lengths as a debug info.

Before this patch:

vb2-core: __qbuf_dmabuf: invalid dmabuf length for plane 1

After this patch:

vb2-core: __qbuf_dmabuf: invalid dmabuf length 221248 for plane 1, minimum length 410880

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

Changes in v2:
- Use %u instead of %d (Sakari Ailus)
- Include min_length (Sakari Ailus)

 drivers/media/v4l2-core/videobuf2-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index b6fbc04f9699..bbba50d6e1ad 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1227,8 +1227,10 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const void *pb)
 			planes[plane].length = dbuf->size;
 
 		if (planes[plane].length < vb->planes[plane].min_length) {
-			dprintk(1, "invalid dmabuf length for plane %d\n",
-				plane);
+			dprintk(1, "invalid dmabuf length %u for plane %d, "
+				"minimum length %u\n",
+				planes[plane].length, plane,
+				vb->planes[plane].min_length);
 			dma_buf_put(dbuf);
 			ret = -EINVAL;
 			goto err;
-- 
2.5.5

