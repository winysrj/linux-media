Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59959 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaHANzw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Aug 2014 09:55:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Enric Balletbo Serra <eballetbo@gmail.com>
Subject: [PATCH 5/8] omap3isp: ccdc: Increment the frame number at VD0 time for BT.656
Date: Fri,  1 Aug 2014 15:46:31 +0200
Message-Id: <1406900794-9871-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1406900794-9871-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We will stop using VD1 in BT.656 mode, move frame number increment to
the VD0 interrupt handler.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/ispccdc.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 6a62cb7..112bced 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -1637,6 +1637,16 @@ static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
 	unsigned long flags;
 	int restart = 0;
 
+	/* In BT.656 mode the CCDC doesn't generate an HS/VS interrupt. We thus
+	 * need to increment the frame counter here.
+	 */
+	if (ccdc->bt656) {
+		struct isp_pipeline *pipe =
+			to_isp_pipeline(&ccdc->subdev.entity);
+
+		atomic_inc(&pipe->frame_number);
+	}
+
 	if (ccdc->output & CCDC_OUTPUT_MEMORY)
 		restart = ccdc_isr_buffer(ccdc);
 
@@ -1662,16 +1672,6 @@ static void ccdc_vd1_isr(struct isp_ccdc_device *ccdc)
 {
 	unsigned long flags;
 
-	/* In BT.656 mode the CCDC doesn't generate an HS/VS interrupt. We thus
-	 * need to increment the frame counter here.
-	 */
-	if (ccdc->bt656) {
-		struct isp_pipeline *pipe =
-			to_isp_pipeline(&ccdc->subdev.entity);
-
-		atomic_inc(&pipe->frame_number);
-	}
-
 	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
 
 	/*
-- 
1.8.5.5

