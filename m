Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:51085 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbZCPWQt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 18:16:49 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v3 1/4] pxa_camera: Enforce YUV422P frame sizes to be 16 multiples
Date: Mon, 16 Mar 2009 23:16:34 +0100
Message-Id: <1237241797-381-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1237241797-381-1-git-send-email-robert.jarzmik@free.fr>
References: <1237241797-381-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to DMA constraints, the DMA chain always transfers bytes
from the QCI fifos to memory in 8 bytes units. In planar
formats, that could mean 0 padding between Y and U plane
(and between U and V plane), which is against YUV422P
standard.

Therefore, a frame size is required to be a multiple of 16
(so U plane size is a multiple of 8). It is enforced in
try_fmt() and set_fmt() primitives, be aligning height then
width on 4 multiples as need be, to reach a 16 multiple.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index e3e6b29..8a76225 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -163,6 +163,13 @@
 			CICR0_EOFM | CICR0_FOM)
 
 /*
+ * YUV422P picture size should be a multiple of 16, so the heuristic aligns
+ * height, width on 4 byte boundaries to reach the 16 multiple for the size.
+ */
+#define YUV422P_X_Y_ALIGN 4
+#define YUV422P_SIZE_ALIGN YUV422P_X_Y_ALIGN * YUV422P_X_Y_ALIGN
+
+/*
  * Structures
  */
 enum pxa_camera_active_dma {
@@ -236,20 +243,11 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
-	struct pxa_camera_dev *pcdev = ici->priv;
 
 	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
 
-	/* planar capture requires Y, U and V buffers to be page aligned */
-	if (pcdev->channels == 3) {
-		*size = PAGE_ALIGN(icd->width * icd->height); /* Y pages */
-		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* U pages */
-		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
-	} else {
-		*size = icd->width * icd->height *
-			((icd->current_fmt->depth + 7) >> 3);
-	}
+	*size = roundup(icd->width * icd->height *
+			((icd->current_fmt->depth + 7) >> 3), 8);
 
 	if (0 == *count)
 		*count = 32;
@@ -1234,6 +1232,18 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 		pix->width = 2048;
 	pix->width &= ~0x01;
 
+	/*
+	 * YUV422P planar format requires images size to be a 16 bytes
+	 * multiple. If not, zeros will be inserted between Y and U planes, and
+	 * U and V planes, and YUV422P standard would be violated.
+	 */
+	if (xlate->host_fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+		if (!IS_ALIGNED(pix->width * pix->height, YUV422P_SIZE_ALIGN))
+			pix->height = ALIGN(pix->height, YUV422P_X_Y_ALIGN);
+		if (!IS_ALIGNED(pix->width * pix->height, YUV422P_SIZE_ALIGN))
+			pix->width = ALIGN(pix->width, YUV422P_X_Y_ALIGN);
+	}
+
 	pix->bytesperline = pix->width *
 		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
 	pix->sizeimage = pix->height * pix->bytesperline;
-- 
1.5.6.5

