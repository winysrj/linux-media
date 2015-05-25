Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34604 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbbEYPef (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2015 11:34:35 -0400
Received: by wicmc15 with SMTP id mc15so43239178wic.1
        for <linux-media@vger.kernel.org>; Mon, 25 May 2015 08:34:34 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 2/3] media: davinci_vpfe: set minimum required buffers to three
Date: Mon, 25 May 2015 16:34:28 +0100
Message-Id: <1432568069-11349-3-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1432568069-11349-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1432568069-11349-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch sets nbuffers to three or more and drops the
unset member video_limit which just a copy paste from
earlier driver.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h |  2 --
 drivers/staging/media/davinci_vpfe/vpfe_video.c      | 15 +++------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
index 2632a80..8ad8d74 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
@@ -67,8 +67,6 @@ struct vpfe_device {
 	/* CCDC IRQs used when CCDC/ISIF output to SDRAM */
 	unsigned int			ccdc_irq0;
 	unsigned int			ccdc_irq1;
-	/* maximum video memory that is available*/
-	unsigned int			video_limit;
 	/* media device */
 	struct media_device		media_dev;
 	/* ccdc subdevice */
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 06d48d5..6744192 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -27,9 +27,6 @@
 #include "vpfe.h"
 #include "vpfe_mc_capture.h"
 
-/* minimum number of buffers needed in cont-mode */
-#define MIN_NUM_BUFFERS			3
-
 static int debug;
 
 /* get v4l2 subdev pointer to external subdev which is active */
@@ -1088,20 +1085,14 @@ vpfe_buffer_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
 	struct vpfe_fh *fh = vb2_get_drv_priv(vq);
 	struct vpfe_video_device *video = fh->video;
 	struct vpfe_device *vpfe_dev = video->vpfe_dev;
-	struct vpfe_pipeline *pipe = &video->pipe;
 	unsigned long size;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_buffer_queue_setup\n");
 	size = video->fmt.fmt.pix.sizeimage;
 
-	if (vpfe_dev->video_limit) {
-		while (size * *nbuffers > vpfe_dev->video_limit)
-			(*nbuffers)--;
-	}
-	if (pipe->state == VPFE_PIPELINE_STREAM_CONTINUOUS) {
-		if (*nbuffers < MIN_NUM_BUFFERS)
-			*nbuffers = MIN_NUM_BUFFERS;
-	}
+	if (vq->num_buffers + *nbuffers < 3)
+		*nbuffers = 3 - vq->num_buffers;
+
 	*nplanes = 1;
 	sizes[0] = size;
 	alloc_ctxs[0] = video->alloc_ctx;
-- 
2.1.4

