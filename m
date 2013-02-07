Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:49408 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758220Ab3BGMGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:06:09 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [REVIEW PATCH V4 04/12] [media] marvell-ccic: refine mcam_set_contig_buffer function
Date: Thu,  7 Feb 2013 20:04:39 +0800
Message-Id: <1360238687-15768-5-git-send-email-twang13@marvell.com>
In-Reply-To: <1360238687-15768-1-git-send-email-twang13@marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch refines mcam_set_contig_buffer() in mcam core.
It can remove redundant code line and enhance readability.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/mcam-core.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index a32df35..f89fce7 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -475,22 +475,21 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
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

