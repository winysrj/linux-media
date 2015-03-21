Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:19101 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbbCUXVf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2015 19:21:35 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@intel.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/4] media: pxa_camera: fix the buffer free path
Date: Sun, 22 Mar 2015 00:21:21 +0100
Message-Id: <1426980085-12281-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Robert Jarzmik <robert.jarzmik@intel.com>

Fix the error path where the video buffer wasn't allocated nor
mapped. In this case, in the driver free path don't try to unmap memory
which was not mapped in the first place.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/platform/soc_camera/pxa_camera.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 8d6e343..3ca33f0 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -272,8 +272,8 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 	 * longer in STATE_QUEUED or STATE_ACTIVE
 	 */
 	videobuf_waiton(vq, &buf->vb, 0, 0);
-	videobuf_dma_unmap(vq->dev, dma);
-	videobuf_dma_free(dma);
+	if (buf->vb.state == VIDEOBUF_NEEDS_INIT)
+		return;
 
 	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
 		if (buf->dmas[i].sg_cpu)
@@ -283,6 +283,8 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 					  buf->dmas[i].sg_dma);
 		buf->dmas[i].sg_cpu = NULL;
 	}
+	videobuf_dma_unmap(vq->dev, dma);
+	videobuf_dma_free(dma);
 
 	buf->vb.state = VIDEOBUF_NEEDS_INIT;
 }
-- 
2.1.4

