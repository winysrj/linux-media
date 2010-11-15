Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:38536 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab0KOOaC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:30:02 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp][PATCH v2 5/9] omap3isp: Remove unused CBUFF register access
Date: Mon, 15 Nov 2010 08:29:57 -0600
Message-Id: <1289831401-593-6-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289831401-593-1-git-send-email-saaguirre@ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/isp.c    |    2 --
 drivers/media/video/isp/isp.h    |    1 -
 drivers/media/video/isp/ispreg.h |   25 -------------------------
 3 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/drivers/media/video/isp/isp.c b/drivers/media/video/isp/isp.c
index a5c02ba..f266e7c 100644
--- a/drivers/media/video/isp/isp.c
+++ b/drivers/media/video/isp/isp.c
@@ -86,7 +86,6 @@ static const struct isp_res_mapping isp_res_maps[] = {
 	{
 		.isp_rev = ISP_REVISION_2_0,
 		.map = 1 << OMAP3_ISP_IOMEM_MAIN |
-		       1 << OMAP3_ISP_IOMEM_CBUFF |
 		       1 << OMAP3_ISP_IOMEM_CCP2 |
 		       1 << OMAP3_ISP_IOMEM_CCDC |
 		       1 << OMAP3_ISP_IOMEM_HIST |
@@ -100,7 +99,6 @@ static const struct isp_res_mapping isp_res_maps[] = {
 	{
 		.isp_rev = ISP_REVISION_15_0,
 		.map = 1 << OMAP3_ISP_IOMEM_MAIN |
-		       1 << OMAP3_ISP_IOMEM_CBUFF |
 		       1 << OMAP3_ISP_IOMEM_CCP2 |
 		       1 << OMAP3_ISP_IOMEM_CCDC |
 		       1 << OMAP3_ISP_IOMEM_HIST |
diff --git a/drivers/media/video/isp/isp.h b/drivers/media/video/isp/isp.h
index edc029c..b8f63e2 100644
--- a/drivers/media/video/isp/isp.h
+++ b/drivers/media/video/isp/isp.h
@@ -56,7 +56,6 @@
 
 enum isp_mem_resources {
 	OMAP3_ISP_IOMEM_MAIN,
-	OMAP3_ISP_IOMEM_CBUFF,
 	OMAP3_ISP_IOMEM_CCP2,
 	OMAP3_ISP_IOMEM_CCDC,
 	OMAP3_ISP_IOMEM_HIST,
diff --git a/drivers/media/video/isp/ispreg.h b/drivers/media/video/isp/ispreg.h
index 8e4324f..c080980 100644
--- a/drivers/media/video/isp/ispreg.h
+++ b/drivers/media/video/isp/ispreg.h
@@ -37,11 +37,6 @@
 #define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
 #define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))
 
-#define OMAP3ISP_CBUFF_REG_OFFSET	0x0100
-#define OMAP3ISP_CBUFF_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_CBUFF_REG_OFFSET)
-#define OMAP3ISP_CBUFF_REG(offset)	(OMAP3ISP_CBUFF_REG_BASE + (offset))
-
 #define OMAP3ISP_CCP2_REG_OFFSET	0x0400
 #define OMAP3ISP_CCP2_REG_BASE		(OMAP3ISP_REG_BASE +		\
 					 OMAP3ISP_CCP2_REG_OFFSET)
@@ -244,26 +239,6 @@
 #define ISP_CSIB_SYSCONFIG		ISPCCP2_SYSCONFIG
 #define ISP_CSIA_SYSCONFIG		ISPCSI2_SYSCONFIG
 
-/* ISP_CBUFF Registers */
-
-#define ISP_CBUFF_SYSCONFIG		(0x010)
-#define ISP_CBUFF_IRQENABLE		(0x01C)
-
-#define ISP_CBUFF0_CTRL			(0x020)
-#define ISP_CBUFF1_CTRL			(0x024)
-
-#define ISP_CBUFF0_START		(0x040)
-#define ISP_CBUFF1_START		(0x044)
-
-#define ISP_CBUFF0_END			(0x050)
-#define ISP_CBUFF1_END			(0x054)
-
-#define ISP_CBUFF0_WINDOWSIZE		(0x060)
-#define ISP_CBUFF1_WINDOWSIZE		(0x064)
-
-#define ISP_CBUFF0_THRESHOLD		(0x070)
-#define ISP_CBUFF1_THRESHOLD		(0x074)
-
 /* CCDC module register offset */
 
 #define ISPCCDC_PID			(0x000)
-- 
1.7.0.4

