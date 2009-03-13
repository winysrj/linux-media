Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:59650 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596AbZCMXRc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 19:17:32 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH v2 1/4] pxa_camera: Enforce YUV422P frame sizes to be 16 multiples
Date: Sat, 14 Mar 2009 00:17:17 +0100
Message-Id: <1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Due to DMA constraints, the DMA chain always transfers bytes
from the QIF fifos to memory in 8 bytes units. In planar
formats, that could mean 0 padding between Y and U plane
(and between U and V plane), which is against YUV422P
standard.

Therefore, a frame size is required to be a multiple of 16
(so U plane size is a multiple of 8). It is enforced in
try_fmt() and set_fmt() primitives, be aligning height then
width on 4 multiples as need be, to reach a 16 multiple.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   28 +++++++++++++++++++---------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index e3e6b29..8e5611b 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -162,6 +162,8 @@
 			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
 			CICR0_EOFM | CICR0_FOM)
 
+#define PIX_YUV422P_ALIGN 16	/* YUV422P pix size should be a multiple of 16 */
+
 /*
  * Structures
  */
@@ -241,15 +243,11 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 
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
+	if (pcdev->channels == 3)
+		*size = icd->width * icd->height * 2;
+	else
+		*size = roundup(icd->width * icd->height *
+				((icd->current_fmt->depth + 7) >> 3), 8);
 
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
+		if (!IS_ALIGNED(pix->width * pix->height, PIX_YUV422P_ALIGN))
+			pix->height = ALIGN(pix->height, PIX_YUV422P_ALIGN / 2);
+		if (!IS_ALIGNED(pix->width * pix->height, PIX_YUV422P_ALIGN))
+			pix->width = ALIGN(pix->width, PIX_YUV422P_ALIGN / 2);
+	}
+
 	pix->bytesperline = pix->width *
 		DIV_ROUND_UP(xlate->host_fmt->depth, 8);
 	pix->sizeimage = pix->height * pix->bytesperline;
-- 
1.5.6.5

