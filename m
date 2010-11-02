Return-path: <mchehab@gaivota>
Received: from d1.icnet.pl ([212.160.220.21]:53992 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541Ab0KBPW7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Nov 2010 11:22:59 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 2.6.37-rc1] SoC Camera: OMAP1: update for recent videobuf changes
Date: Tue, 2 Nov 2010 16:22:32 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	e3-hacking@earth.li
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011021622.33156.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Recent locking related videobuf changes has not been incorporated into the new 
OMAP1 camera driver. Fix it.

Created and tested against linux-2.6.37-rc1.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---

 drivers/media/video/omap1_camera.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.37-rc1/drivers/media/video/omap1_camera.c.orig	2010-11-01 22:41:59.000000000 +0100
+++ linux-2.6.37-rc1/drivers/media/video/omap1_camera.c	2010-11-01 23:55:26.000000000 +0100
@@ -235,7 +235,7 @@ static void free_buffer(struct videobuf_
 
 	BUG_ON(in_interrupt());
 
-	videobuf_waiton(vb, 0, 0);
+	videobuf_waiton(vq, vb, 0, 0);
 
 	if (vb_mode == OMAP1_CAM_DMA_CONTIG) {
 		videobuf_dma_contig_free(vq, vb);
@@ -1365,12 +1365,12 @@ static void omap1_cam_init_videobuf(stru
 		videobuf_queue_dma_contig_init(q, &omap1_videobuf_ops,
 				icd->dev.parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd);
+				sizeof(struct omap1_cam_buf), icd, NULL);
 	else
 		videobuf_queue_sg_init(q, &omap1_videobuf_ops,
 				icd->dev.parent, &pcdev->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
-				sizeof(struct omap1_cam_buf), icd);
+				sizeof(struct omap1_cam_buf), icd, NULL);
 
 	/* use videobuf mode (auto)selected with the module parameter */
 	pcdev->vb_mode = sg_mode ? OMAP1_CAM_DMA_SG : OMAP1_CAM_DMA_CONTIG;
