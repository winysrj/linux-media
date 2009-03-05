Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp5-g21.free.fr ([212.27.42.5]:43941 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754754AbZCETqH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 14:46:07 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: g.liakhovetski@gmx.de, mike@compulab.co.il
Cc: linux-media@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 3/4] pxa_camera: Coding style sweeping
Date: Thu,  5 Mar 2009 20:45:50 +0100
Message-Id: <1236282351-28471-4-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
References: <1236282351-28471-1-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-2-git-send-email-robert.jarzmik@free.fr>
 <1236282351-28471-3-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Transform sequences of form:
	  foo = val1 | val2 |
	        val3 | val4;
into :
	  foo = val1 | val2
	        | val3 | val4;

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   43 ++++++++++++++++++-------------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 2d79ded..16bf0a3 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -158,9 +158,9 @@
 #define CICR3_VSW_VAL(x)  (((x) << 11) & CICR3_VSW) /* Vertical sync pulse width */
 #define CICR3_LPF_VAL(x)  (((x) << 0) & CICR3_LPF)  /* Lines per frame */
 
-#define CICR0_IRQ_MASK (CICR0_TOM | CICR0_RDAVM | CICR0_FEM | CICR0_EOLM | \
-			CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM | \
-			CICR0_EOFM | CICR0_FOM)
+#define CICR0_IRQ_MASK (CICR0_TOM | CICR0_RDAVM | CICR0_FEM | CICR0_EOLM \
+			| CICR0_PERRM | CICR0_QDM | CICR0_CDM | CICR0_SOFM \
+			| CICR0_EOFM | CICR0_FOM)
 
 /*
  * Structures
@@ -429,10 +429,10 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	 * the actual buffer is yours */
 	buf->inwork = 1;
 
-	if (buf->fmt	!= icd->current_fmt ||
-	    vb->width	!= icd->width ||
-	    vb->height	!= icd->height ||
-	    vb->field	!= field) {
+	if (buf->fmt		!= icd->current_fmt
+	    || vb->width	!= icd->width
+	    || vb->height	!= icd->height
+	    || vb->field	!= field) {
 		buf->fmt	= icd->current_fmt;
 		vb->width	= icd->width;
 		vb->height	= icd->height;
@@ -960,13 +960,13 @@ static int test_platform_param(struct pxa_camera_dev *pcdev,
 	 * quick capture interface supports both.
 	 */
 	*flags = (pcdev->platform_flags & PXA_CAMERA_MASTER ?
-		  SOCAM_MASTER : SOCAM_SLAVE) |
-		SOCAM_HSYNC_ACTIVE_HIGH |
-		SOCAM_HSYNC_ACTIVE_LOW |
-		SOCAM_VSYNC_ACTIVE_HIGH |
-		SOCAM_VSYNC_ACTIVE_LOW |
-		SOCAM_PCLK_SAMPLE_RISING |
-		SOCAM_PCLK_SAMPLE_FALLING;
+		  SOCAM_MASTER : SOCAM_SLAVE)
+		| SOCAM_HSYNC_ACTIVE_HIGH
+		| SOCAM_HSYNC_ACTIVE_LOW
+		| SOCAM_VSYNC_ACTIVE_HIGH
+		| SOCAM_VSYNC_ACTIVE_LOW
+		| SOCAM_PCLK_SAMPLE_RISING
+		| SOCAM_PCLK_SAMPLE_FALLING;
 
 	/* If requested data width is supported by the platform, use it */
 	switch (buswidth) {
@@ -1094,8 +1094,8 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 		cicr1 |= CICR1_COLOR_SP_VAL(2);
 		break;
 	case V4L2_PIX_FMT_RGB555:
-		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
-			CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
+		cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2)
+			| CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
 		break;
 	case V4L2_PIX_FMT_RGB565:
 		cicr1 |= CICR1_COLOR_SP_VAL(1) | CICR1_RGB_BPP_VAL(2);
@@ -1103,8 +1103,8 @@ static int pxa_camera_set_bus_param(struct soc_camera_device *icd, __u32 pixfmt)
 	}
 
 	cicr2 = 0;
-	cicr3 = CICR3_LPF_VAL(icd->height - 1) |
-		CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
+	cicr3 = CICR3_LPF_VAL(icd->height - 1)
+		| CICR3_BFW_VAL(min((unsigned short)255, icd->y_skip_top));
 	cicr4 |= pcdev->mclk_divisor;
 
 	__raw_writel(cicr1, pcdev->base + CICR1);
@@ -1372,8 +1372,7 @@ static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
 
 	poll_wait(file, &buf->vb.done, pt);
 
-	if (buf->vb.state == VIDEOBUF_DONE ||
-	    buf->vb.state == VIDEOBUF_ERROR)
+	if (buf->vb.state == VIDEOBUF_DONE || buf->vb.state == VIDEOBUF_ERROR)
 		return POLLIN|POLLRDNORM;
 
 	return 0;
@@ -1489,8 +1488,8 @@ static int pxa_camera_probe(struct platform_device *pdev)
 
 	pcdev->pdata = pdev->dev.platform_data;
 	pcdev->platform_flags = pcdev->pdata->flags;
-	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8 |
-			PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
+	if (!(pcdev->platform_flags & (PXA_CAMERA_DATAWIDTH_8
+			| PXA_CAMERA_DATAWIDTH_9 | PXA_CAMERA_DATAWIDTH_10))) {
 		/* Platform hasn't set available data widths. This is bad.
 		 * Warn and use a default. */
 		dev_warn(&pdev->dev, "WARNING! Platform hasn't set available "
-- 
1.5.6.5

