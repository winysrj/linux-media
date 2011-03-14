Return-path: <mchehab@pedra>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48852 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab1CNNih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 09:38:37 -0400
Received: by gwaa18 with SMTP id a18so1814447gwa.19
        for <linux-media@vger.kernel.org>; Mon, 14 Mar 2011 06:38:36 -0700 (PDT)
From: Pawel Osciak <pawel@osciak.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
	hverkuil@xs4all.nl, Pawel Osciak <pawel@osciak.com>
Subject: [PATCH 1/2] [media] sh_mobile_ceu_camera: Do not call vb2's mem_ops directly
Date: Mon, 14 Mar 2011 06:38:23 -0700
Message-Id: <1300109904-3991-1-git-send-email-pawel@osciak.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Use vb2_dma_contig_plane_paddr to retrieve a physical address for a plane
instead of calling an internal mem_ops callback.

Signed-off-by: Pawel Osciak <pawel@osciak.com>
---
 drivers/media/video/sh_mobile_ceu_camera.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 61f3701..3fe54bf 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -302,9 +302,7 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
 		bottom2	= CDBCR;
 	}
 
-	/* mem_ops->cookie must not be NULL */
-	phys_addr_top = (dma_addr_t)icd->vb2_vidq.mem_ops->cookie(pcdev->
-						active->planes[0].mem_priv);
+	phys_addr_top = vb2_dma_contig_plane_paddr(pcdev->active, 0);
 
 	ceu_write(pcdev, top1, phys_addr_top);
 	if (V4L2_FIELD_NONE != pcdev->field) {
-- 
1.7.4.1

