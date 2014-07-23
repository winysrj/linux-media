Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49117 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989AbaGWO5C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 10:57:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH 1/3] omap3isp: resizer: Remove needless variable initializations
Date: Wed, 23 Jul 2014 16:57:09 +0200
Message-Id: <1406127431-9503-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406127431-9503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to initialize local variables to zero when they're
explicitly assigned another value right after. Remove the needless
initializations.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispresizer.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 6f077c2..8515793 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -239,7 +239,7 @@ static void resizer_set_phase(struct isp_res_device *res, u32 h_phase,
 			      u32 v_phase)
 {
 	struct isp_device *isp = to_isp_device(res);
-	u32 rgval = 0;
+	u32 rgval;
 
 	rgval = isp_reg_readl(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT) &
 	      ~(ISPRSZ_CNT_HSTPH_MASK | ISPRSZ_CNT_VSTPH_MASK);
@@ -275,7 +275,7 @@ static void resizer_set_luma(struct isp_res_device *res,
 			     struct resizer_luma_yenh *luma)
 {
 	struct isp_device *isp = to_isp_device(res);
-	u32 rgval = 0;
+	u32 rgval;
 
 	rgval  = (luma->algo << ISPRSZ_YENH_ALGO_SHIFT)
 		  & ISPRSZ_YENH_ALGO_MASK;
@@ -322,7 +322,7 @@ static void resizer_set_ratio(struct isp_res_device *res,
 {
 	struct isp_device *isp = to_isp_device(res);
 	const u16 *h_filter, *v_filter;
-	u32 rgval = 0;
+	u32 rgval;
 
 	rgval = isp_reg_readl(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT) &
 			      ~(ISPRSZ_CNT_HRSZ_MASK | ISPRSZ_CNT_VRSZ_MASK);
@@ -365,7 +365,7 @@ static void resizer_set_output_size(struct isp_res_device *res,
 				    u32 width, u32 height)
 {
 	struct isp_device *isp = to_isp_device(res);
-	u32 rgval = 0;
+	u32 rgval;
 
 	dev_dbg(isp->dev, "Output size[w/h]: %dx%d\n", width, height);
 	rgval  = (width << ISPRSZ_OUT_SIZE_HORZ_SHIFT)
@@ -409,7 +409,7 @@ static void resizer_set_output_offset(struct isp_res_device *res, u32 offset)
 static void resizer_set_start(struct isp_res_device *res, u32 left, u32 top)
 {
 	struct isp_device *isp = to_isp_device(res);
-	u32 rgval = 0;
+	u32 rgval;
 
 	rgval = (left << ISPRSZ_IN_START_HORZ_ST_SHIFT)
 		& ISPRSZ_IN_START_HORZ_ST_MASK;
@@ -429,7 +429,7 @@ static void resizer_set_input_size(struct isp_res_device *res,
 				   u32 width, u32 height)
 {
 	struct isp_device *isp = to_isp_device(res);
-	u32 rgval = 0;
+	u32 rgval;
 
 	dev_dbg(isp->dev, "Input size[w/h]: %dx%d\n", width, height);
 
-- 
1.8.5.5

