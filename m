Return-path: <linux-media-owner@vger.kernel.org>
Received: from 82-70-136-246.dsl.in-addr.zen.co.uk ([82.70.136.246]:56258 "EHLO
	xk120.dyn.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752357AbbEUJCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 May 2015 05:02:47 -0400
From: William Towle <william.towle@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk, linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, sergei.shtylyov@cogentembedded.com,
	hverkuil@xs4all.nl, rob.taylor@codethink.co.uk
Subject: [PATCH 15/20] media: rcar_vin: Don't advertise support for USERPTR
Date: Wed, 20 May 2015 17:39:35 +0100
Message-Id: <1432139980-12619-16-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
References: <1432139980-12619-1-git-send-email-william.towle@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

rcar_vin requires physically contiguous buffer, so shouldn't advertise
support for USERPTR.

Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
Reviewed-by: William Towle <william.towle@codethink.co.uk>
---
 drivers/media/platform/soc_camera/rcar_vin.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
index 222002a..b530503 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -1824,7 +1824,7 @@ static int rcar_vin_init_videobuf2(struct vb2_queue *vq,
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 
 	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	vq->io_modes = VB2_MMAP | VB2_USERPTR;
+	vq->io_modes = VB2_MMAP;
 	vq->drv_priv = icd;
 	vq->ops = &rcar_vin_vb2_ops;
 	vq->mem_ops = &vb2_dma_contig_memops;
-- 
1.7.10.4

