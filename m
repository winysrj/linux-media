Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:56082 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162058Ab2CPXgW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 19:36:22 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 4/7] marvell-cam: fix the green screen of death
Date: Fri, 16 Mar 2012 17:14:53 -0600
Message-Id: <1331939696-12482-5-git-send-email-corbet@lwn.net>
In-Reply-To: <1331939696-12482-1-git-send-email-corbet@lwn.net>
References: <1331939696-12482-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I had learned through hard experience that dinking around with the DMA
descriptors while the C1_DESC_ENA enable bit was set is a recipe for all
kinds of truly malicious behavior on the hardware's part, regardless of
whether the DMA engine is actually operating at the time.  That
notwithstanding, the driver did so dink, resulting in "green frame"
captures and the death of the system in random, spectacular ways.

Move the tweaking of C1_DESC_ENA to the same function that sets the
descriptor so we know that we'll never try to set a descriptor while that
bit is set.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/video/marvell-ccic/mcam-core.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/marvell-ccic/mcam-core.c b/drivers/media/video/marvell-ccic/mcam-core.c
index 050724f..e46a72a 100644
--- a/drivers/media/video/marvell-ccic/mcam-core.c
+++ b/drivers/media/video/marvell-ccic/mcam-core.c
@@ -509,11 +509,17 @@ static void mcam_sg_next_buffer(struct mcam_camera *cam)
 
 	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
 	list_del_init(&buf->queue);
+	/*
+	 * Very Bad Not Good Things happen if you don't clear
+	 * C1_DESC_ENA before making any descriptor changes.
+	 */
+	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_ENA);
 	mcam_reg_write(cam, REG_DMA_DESC_Y, buf->dma_desc_pa);
 	mcam_reg_write(cam, REG_DESC_LEN_Y,
 			buf->dma_desc_nent*sizeof(struct mcam_dma_desc));
 	mcam_reg_write(cam, REG_DESC_LEN_U, 0);
 	mcam_reg_write(cam, REG_DESC_LEN_V, 0);
+	mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
 	cam->vb_bufs[0] = buf;
 }
 
@@ -533,7 +539,6 @@ static void mcam_ctlr_dma_sg(struct mcam_camera *cam)
 
 	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_3WORD);
 	mcam_sg_next_buffer(cam);
-	mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
 	cam->nbufs = 3;
 }
 
@@ -561,17 +566,11 @@ static void mcam_dma_sg_done(struct mcam_camera *cam, int frame)
 	if (cam->state != S_STREAMING)
 		return;
 	/*
-	 * Very Bad Not Good Things happen if you don't clear
-	 * C1_DESC_ENA before making any descriptor changes.
-	 */
-	mcam_reg_clear_bit(cam, REG_CTRL1, C1_DESC_ENA);
-	/*
 	 * If we have another buffer available, put it in and
 	 * restart the engine.
 	 */
 	if (!list_empty(&cam->buffers)) {
 		mcam_sg_next_buffer(cam);
-		mcam_reg_set_bit(cam, REG_CTRL1, C1_DESC_ENA);
 		mcam_ctlr_start(cam);
 	/*
 	 * Otherwise set CF_SG_RESTART and the controller will
-- 
1.7.9.3

