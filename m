Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35182 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728324AbeJEBtJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 21:49:09 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 08/11] media: imx: vdic: rely on VDIC for correct field order
Date: Thu,  4 Oct 2018 11:53:58 -0700
Message-Id: <20181004185401.15751-9-slongerbeam@gmail.com>
In-Reply-To: <20181004185401.15751-1-slongerbeam@gmail.com>
References: <20181004185401.15751-1-slongerbeam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

prepare_vdi_in_buffers() was setting up the dma pointers as if the
VDIC is always programmed to receive the fields in bottom-top order,
i.e. as if ipu_vdi_set_field_order() only programs BT order in the VDIC.
But that's not true, ipu_vdi_set_field_order() is working correctly.

So fix prepare_vdi_in_buffers() to give the VDIC the fields in whatever
order they were received by the video source, and rely on the VDIC to
sort out which is top and which is bottom.

Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
---
 drivers/staging/media/imx/imx-media-vdic.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 482250d47e7c..4a890714193e 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -219,26 +219,18 @@ static void __maybe_unused prepare_vdi_in_buffers(struct vdic_priv *priv,
 
 	switch (priv->fieldtype) {
 	case V4L2_FIELD_SEQ_TB:
-		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0);
-		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + fs;
-		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
-		break;
 	case V4L2_FIELD_SEQ_BT:
 		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0) + fs;
 		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
 		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + fs;
 		break;
+	case V4L2_FIELD_INTERLACED_TB:
 	case V4L2_FIELD_INTERLACED_BT:
+	case V4L2_FIELD_INTERLACED:
 		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0) + is;
 		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
 		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
 		break;
-	default:
-		/* assume V4L2_FIELD_INTERLACED_TB */
-		prev_phys = vb2_dma_contig_plane_dma_addr(prev_vb, 0);
-		curr_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0) + is;
-		next_phys = vb2_dma_contig_plane_dma_addr(curr_vb, 0);
-		break;
 	}
 
 	ipu_cpmem_set_buffer(priv->vdi_in_ch_p, 0, prev_phys);
-- 
2.17.1
