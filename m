Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:27314 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbbIFLrE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Sep 2015 07:47:04 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v5 1/4] media: pxa_camera: fix the buffer free path
Date: Sun,  6 Sep 2015 13:42:10 +0200
Message-Id: <1441539733-19201-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix the error path where the video buffer wasn't allocated nor
mapped. In this case, in the driver free path don't try to unmap memory
which was not mapped in the first place.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
Since v3: take into account the 2 paths possibilities to free_buffer()
---
 drivers/media/platform/soc_camera/pxa_camera.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index fcb942de0c7f..d4e887841372 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -272,8 +272,6 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 	 * longer in STATE_QUEUED or STATE_ACTIVE
 	 */
 	videobuf_waiton(vq, &buf->vb, 0, 0);
-	videobuf_dma_unmap(vq->dev, dma);
-	videobuf_dma_free(dma);
 
 	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
 		if (buf->dmas[i].sg_cpu)
@@ -283,6 +281,8 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 					  buf->dmas[i].sg_dma);
 		buf->dmas[i].sg_cpu = NULL;
 	}
+	videobuf_dma_unmap(vq->dev, dma);
+	videobuf_dma_free(dma);
 
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
@@ -479,7 +479,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 
 		ret = videobuf_iolock(vq, vb, NULL);
 		if (ret)
-			goto fail;
+			goto out;
 
 		if (pcdev->channels == 3) {
 			size_y = size / 2;
@@ -504,7 +504,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 						   size_u, &sg, &next_ofs);
 		if (ret) {
 			dev_err(dev, "DMA initialization for U failed\n");
-			goto fail_u;
+			goto fail;
 		}
 
 		/* init DMA for V channel */
@@ -513,7 +513,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 						   size_v, &sg, &next_ofs);
 		if (ret) {
 			dev_err(dev, "DMA initialization for V failed\n");
-			goto fail_v;
+			goto fail;
 		}
 
 		vb->state = VIDEOBUF_PREPARED;
@@ -524,12 +524,6 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 
 	return 0;
 
-fail_v:
-	dma_free_coherent(dev, buf->dmas[1].sg_size,
-			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
-fail_u:
-	dma_free_coherent(dev, buf->dmas[0].sg_size,
-			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
 fail:
 	free_buffer(vq, buf);
 out:
-- 
2.1.4

