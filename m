Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:55597 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3KSO1n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Nov 2013 09:27:43 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MWI00M2MLI2NH40@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Nov 2013 23:27:42 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 05/16] s5p-jpeg: Rename functions specific to the S5PC210 SoC
 accordingly
Date: Tue, 19 Nov 2013 15:26:57 +0100
Message-id: <1384871228-6648-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
References: <1384871228-6648-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c |   58 ++++++++++++++++-----------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index a6ec8c6..32033e7 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -213,8 +213,9 @@ static inline struct s5p_jpeg_ctx *fh_to_ctx(struct v4l2_fh *fh)
 	return container_of(fh, struct s5p_jpeg_ctx, fh);
 }
 
-static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
-		   unsigned long tab, int len)
+static inline void s5p_jpeg_set_qtbl(void __iomem *regs,
+				     const unsigned char *qtbl,
+				     unsigned long tab, int len)
 {
 	int i;
 
@@ -222,22 +223,25 @@ static inline void jpeg_set_qtbl(void __iomem *regs, const unsigned char *qtbl,
 		writel((unsigned int)qtbl[i], regs + tab + (i * 0x04));
 }
 
-static inline void jpeg_set_qtbl_lum(void __iomem *regs, int quality)
+static inline void s5p_jpeg_set_qtbl_lum(void __iomem *regs, int quality)
 {
 	/* this driver fills quantisation table 0 with data for luma */
-	jpeg_set_qtbl(regs, qtbl_luminance[quality], S5P_JPG_QTBL_CONTENT(0),
-		      ARRAY_SIZE(qtbl_luminance[quality]));
+	s5p_jpeg_set_qtbl(regs, qtbl_luminance[quality],
+			  S5P_JPG_QTBL_CONTENT(0),
+			  ARRAY_SIZE(qtbl_luminance[quality]));
 }
 
-static inline void jpeg_set_qtbl_chr(void __iomem *regs, int quality)
+static inline void s5p_jpeg_set_qtbl_chr(void __iomem *regs, int quality)
 {
 	/* this driver fills quantisation table 1 with data for chroma */
-	jpeg_set_qtbl(regs, qtbl_chrominance[quality], S5P_JPG_QTBL_CONTENT(1),
-		      ARRAY_SIZE(qtbl_chrominance[quality]));
+	s5p_jpeg_set_qtbl(regs, qtbl_chrominance[quality],
+			  S5P_JPG_QTBL_CONTENT(1),
+			  ARRAY_SIZE(qtbl_chrominance[quality]));
 }
 
-static inline void jpeg_set_htbl(void __iomem *regs, const unsigned char *htbl,
-		   unsigned long tab, int len)
+static inline void s5p_jpeg_set_htbl(void __iomem *regs,
+				     const unsigned char *htbl,
+				     unsigned long tab, int len)
 {
 	int i;
 
@@ -245,28 +249,32 @@ static inline void jpeg_set_htbl(void __iomem *regs, const unsigned char *htbl,
 		writel((unsigned int)htbl[i], regs + tab + (i * 0x04));
 }
 
-static inline void jpeg_set_hdctbl(void __iomem *regs)
+static inline void s5p_jpeg_set_hdctbl(void __iomem *regs)
 {
 	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hdctbl0, S5P_JPG_HDCTBL(0), ARRAY_SIZE(hdctbl0));
+	s5p_jpeg_set_htbl(regs, hdctbl0, S5P_JPG_HDCTBL(0),
+						ARRAY_SIZE(hdctbl0));
 }
 
-static inline void jpeg_set_hdctblg(void __iomem *regs)
+static inline void s5p_jpeg_set_hdctblg(void __iomem *regs)
 {
 	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hdctblg0, S5P_JPG_HDCTBLG(0), ARRAY_SIZE(hdctblg0));
+	s5p_jpeg_set_htbl(regs, hdctblg0, S5P_JPG_HDCTBLG(0),
+						ARRAY_SIZE(hdctblg0));
 }
 
-static inline void jpeg_set_hactbl(void __iomem *regs)
+static inline void s5p_jpeg_set_hactbl(void __iomem *regs)
 {
 	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hactbl0, S5P_JPG_HACTBL(0), ARRAY_SIZE(hactbl0));
+	s5p_jpeg_set_htbl(regs, hactbl0, S5P_JPG_HACTBL(0),
+						ARRAY_SIZE(hactbl0));
 }
 
-static inline void jpeg_set_hactblg(void __iomem *regs)
+static inline void s5p_jpeg_set_hactblg(void __iomem *regs)
 {
 	/* this driver fills table 0 for this component */
-	jpeg_set_htbl(regs, hactblg0, S5P_JPG_HACTBLG(0), ARRAY_SIZE(hactblg0));
+	s5p_jpeg_set_htbl(regs, hactblg0, S5P_JPG_HACTBLG(0),
+						ARRAY_SIZE(hactblg0));
 }
 
 /*
@@ -962,8 +970,8 @@ static void s5p_jpeg_device_run(void *priv)
 		 * JPEG IP allows storing 4 quantization tables
 		 * We fill table 0 for luma and table 1 for chroma
 		 */
-		jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
-		jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
+		s5p_jpeg_set_qtbl_lum(jpeg->regs, ctx->compr_quality);
+		s5p_jpeg_set_qtbl_chr(jpeg->regs, ctx->compr_quality);
 		/* use table 0 for Y */
 		jpeg_qtbl(jpeg->regs, 1, 0);
 		/* use table 1 for Cb and Cr*/
@@ -1406,14 +1414,16 @@ static int s5p_jpeg_runtime_suspend(struct device *dev)
 static int s5p_jpeg_runtime_resume(struct device *dev)
 {
 	struct s5p_jpeg *jpeg = dev_get_drvdata(dev);
+
 	/*
 	 * JPEG IP allows storing two Huffman tables for each component
 	 * We fill table 0 for each component
 	 */
-	jpeg_set_hdctbl(jpeg->regs);
-	jpeg_set_hdctblg(jpeg->regs);
-	jpeg_set_hactbl(jpeg->regs);
-	jpeg_set_hactblg(jpeg->regs);
+	s5p_jpeg_set_hdctbl(jpeg->regs);
+	s5p_jpeg_set_hdctblg(jpeg->regs);
+	s5p_jpeg_set_hactbl(jpeg->regs);
+	s5p_jpeg_set_hactblg(jpeg->regs);
+
 	return 0;
 }
 
-- 
1.7.9.5

