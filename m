Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:45365 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab3GCF41 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 01:56:27 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 4/7] marvell-ccic: refine mcam_set_contig_buffer function
Date: Wed, 3 Jul 2013 13:56:01 +0800
Message-ID: <1372830964-22323-5-git-send-email-lbyang@marvell.com>
In-Reply-To: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
References: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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
index 6921e84..dbd0c6b 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -482,22 +482,21 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
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

