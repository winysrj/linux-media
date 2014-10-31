Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:51741 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895AbaJaPVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 11:21:17 -0400
Received: from avalon.ideasonboard.com (dsl-hkibrasgw3-50ddcc-40.dhcp.inet.fi [80.221.204.40])
	by galahad.ideasonboard.com (Postfix) with ESMTPSA id 44167217D2
	for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 16:19:05 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] v4l: omap4iss: Remove bogus frame number propagation
Date: Fri, 31 Oct 2014 17:21:20 +0200
Message-Id: <1414768882-16255-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414768882-16255-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Frame number propagation tries to increase the robustness of the frame
number counter by using sources less likely to be missed than the end of
frame interrupts, such as hardware frame counters or start of frame
interrupts.

Increasing the frame number in the IPIPE ISIF and resizer end of frame
interrupt handlers is pointless as it doesn't bring any improvement.
Don't do it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_ipipeif.c | 22 +++-------------------
 drivers/staging/media/omap4iss/iss_resizer.c | 18 +-----------------
 2 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 75f6a15..77ccb97 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -242,23 +242,6 @@ static void ipipeif_isr_buffer(struct iss_ipipeif_device *ipipeif)
 }
 
 /*
- * ipipeif_isif0_isr - Handle ISIF0 event
- * @ipipeif: Pointer to ISP IPIPEIF device.
- *
- * Executes LSC deferred enablement before next frame starts.
- */
-static void ipipeif_isif0_isr(struct iss_ipipeif_device *ipipeif)
-{
-	struct iss_pipeline *pipe =
-			     to_iss_pipeline(&ipipeif->subdev.entity);
-	if (pipe->do_propagation)
-		atomic_inc(&pipe->frame_number);
-
-	if (ipipeif->output & IPIPEIF_OUTPUT_MEMORY)
-		ipipeif_isr_buffer(ipipeif);
-}
-
-/*
  * omap4iss_ipipeif_isr - Configure ipipeif during interframe time.
  * @ipipeif: Pointer to ISP IPIPEIF device.
  * @events: IPIPEIF events
@@ -269,8 +252,9 @@ void omap4iss_ipipeif_isr(struct iss_ipipeif_device *ipipeif, u32 events)
 					     &ipipeif->stopping))
 		return;
 
-	if (events & ISP5_IRQ_ISIF_INT(0))
-		ipipeif_isif0_isr(ipipeif);
+	if ((events & ISP5_IRQ_ISIF_INT(0)) &&
+	    (ipipeif->output & IPIPEIF_OUTPUT_MEMORY))
+		ipipeif_isr_buffer(ipipeif);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index a21e356..0423718 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -283,22 +283,6 @@ static void resizer_isr_buffer(struct iss_resizer_device *resizer)
 }
 
 /*
- * resizer_isif0_isr - Handle ISIF0 event
- * @resizer: Pointer to ISP RESIZER device.
- *
- * Executes LSC deferred enablement before next frame starts.
- */
-static void resizer_int_dma_isr(struct iss_resizer_device *resizer)
-{
-	struct iss_pipeline *pipe =
-			     to_iss_pipeline(&resizer->subdev.entity);
-	if (pipe->do_propagation)
-		atomic_inc(&pipe->frame_number);
-
-	resizer_isr_buffer(resizer);
-}
-
-/*
  * omap4iss_resizer_isr - Configure resizer during interframe time.
  * @resizer: Pointer to ISP RESIZER device.
  * @events: RESIZER events
@@ -322,7 +306,7 @@ void omap4iss_resizer_isr(struct iss_resizer_device *resizer, u32 events)
 		return;
 
 	if (events & ISP5_IRQ_RSZ_INT_DMA)
-		resizer_int_dma_isr(resizer);
+		resizer_isr_buffer(resizer);
 }
 
 /* -----------------------------------------------------------------------------
-- 
2.0.4

