Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:10277 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753551AbdBMNHJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:07:09 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [Patch 2/2] media: ti-vpe: vpe: allow use of user specified stride
Date: Mon, 13 Feb 2017 07:06:58 -0600
Message-ID: <20170213130658.31907-3-bparrot@ti.com>
In-Reply-To: <20170213130658.31907-1-bparrot@ti.com>
References: <20170213130658.31907-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bytesperline/stride was always overwritten by VPE to the most
adequate value based on needed alignment.

However in order to make use of arbitrary size DMA buffer it
is better to use the user space provide stride instead.

The driver will still calculate an appropriate stride but will
use the provided one when it is larger than the calculated one.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 2dd67232b3bc..c47151495b6f 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1597,6 +1597,7 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 	struct v4l2_plane_pix_format *plane_fmt;
 	unsigned int w_align;
 	int i, depth, depth_bytes, height;
+	unsigned int stride = 0;
 
 	if (!fmt || !(fmt->types & type)) {
 		vpe_err(ctx->dev, "Fourcc format (0x%08x) invalid.\n",
@@ -1683,16 +1684,27 @@ static int __vpe_try_fmt(struct vpe_ctx *ctx, struct v4l2_format *f,
 		plane_fmt = &pix->plane_fmt[i];
 		depth = fmt->vpdma_fmt[i]->depth;
 
-		if (i == VPE_LUMA)
-			plane_fmt->bytesperline = (pix->width * depth) >> 3;
-		else
-			plane_fmt->bytesperline = pix->width;
+		stride = (pix->width * fmt->vpdma_fmt[VPE_LUMA]->depth) >> 3;
+		if (stride > plane_fmt->bytesperline)
+			plane_fmt->bytesperline = stride;
+
+		plane_fmt->bytesperline = ALIGN(plane_fmt->bytesperline,
+						VPDMA_STRIDE_ALIGN);
 
-		if (pix->num_planes == 1 && fmt->coplanar)
-			depth += fmt->vpdma_fmt[VPE_CHROMA]->depth;
-		plane_fmt->sizeimage =
-				(pix->height * pix->width * depth) >> 3;
+		if (i == VPE_LUMA) {
+			plane_fmt->sizeimage = pix->height *
+					       plane_fmt->bytesperline;
 
+			if (pix->num_planes == 1 && fmt->coplanar)
+				plane_fmt->sizeimage += pix->height *
+					plane_fmt->bytesperline *
+					fmt->vpdma_fmt[VPE_CHROMA]->depth >> 3;
+
+		} else { /* i == VIP_CHROMA */
+			plane_fmt->sizeimage = (pix->height *
+					       plane_fmt->bytesperline *
+					       depth) >> 3;
+		}
 		memset(plane_fmt->reserved, 0, sizeof(plane_fmt->reserved));
 	}
 
-- 
2.9.0
