Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:53844 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514Ab2LOJ7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:54 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH V3 05/15] [media] marvell-ccic: refine mcam_set_contig_buffer function
Date: Sat, 15 Dec 2012 17:57:54 +0800
Message-Id: <1355565484-15791-6-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch refines mcam_set_contig_buffer() in mcam core

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 19e91c5..3cc1d0c 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -486,22 +486,21 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
 	 */
 	if (list_empty(&cam->buffers)) {
 		buf = cam->vb_bufs[frame ^ 0x1];
-		cam->vb_bufs[frame] = buf;
-		mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
-				vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
 		set_bit(CF_SINGLE_BUFFER, &cam->flags);
 		cam->frame_state.singles++;
-		return;
+	} else {
+		/*
+		 * OK, we have a buffer we can use.
+		 */
+		buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
+					queue);
+		list_del_init(&buf->queue);
+		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
 	}
-	/*
-	 * OK, we have a buffer we can use.
-	 */
-	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
-	list_del_init(&buf->queue);
+
+	cam->vb_bufs[frame] = buf;
 	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
 			vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
-	cam->vb_bufs[frame] = buf;
-	clear_bit(CF_SINGLE_BUFFER, &cam->flags);
 }
 
 /*
-- 
1.7.9.5

