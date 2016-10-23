Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34070 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754033AbcJWMDG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 23 Oct 2016 08:03:06 -0400
From: Leo Sperling <leosperling97@gmail.com>
To: mchehab@kernel.org, gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Leo Sperling <leosperling97@gmail.com>
Subject: [PATCH] Staging: media: davinci_vpfe: fix indentation issue in vpfe_video.c
Date: Sun, 23 Oct 2016 14:02:23 +0200
Message-Id: <1477224143-22653-1-git-send-email-leosperling97@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a patch to the vpfe_video.c file that fixes an indentation
warning reported by checkpatch.pl

Signed-off-by: Leo Sperling <leosperling97@gmail.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 8be9f85..c34bf46 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1143,8 +1143,8 @@ static int vpfe_buffer_prepare(struct vb2_buffer *vb)
 	/* Initialize buffer */
 	vb2_set_plane_payload(vb, 0, video->fmt.fmt.pix.sizeimage);
 	if (vb2_plane_vaddr(vb, 0) &&
-		vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
-			return -EINVAL;
+	    vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
+		return -EINVAL;
 
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	/* Make sure user addresses are aligned to 32 bytes */
-- 
2.1.4

