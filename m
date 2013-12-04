Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44099 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755844Ab3LDA4l (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:41 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9AB9C366AE
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:41 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 23/25] v4l: omap4iss: csi2: Replace manual if statement with a subclk field
Date: Wed,  4 Dec 2013 01:56:23 +0100
Message-Id: <1386118585-12449-24-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Instead of manually checking whether the CSI2 module is CSI2a or CSI2b
in order to select the right subclock to enable/disable, add a subclk
field to the iss_csi2 structure, initialize it with the corresponding
subclock value and use it at runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c | 12 ++++--------
 drivers/staging/media/omap4iss/iss_csi2.h |  2 ++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 7e7e955..e4fc4a0 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -1062,10 +1062,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 		if (enable == ISS_PIPELINE_STREAM_STOPPED)
 			return 0;
 
-		if (csi2 == &iss->csi2a)
-			omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_CSI2_A);
-		else if (csi2 == &iss->csi2b)
-			omap4iss_subclk_enable(iss, OMAP4_ISS_SUBCLK_CSI2_B);
+		omap4iss_subclk_enable(iss, csi2->subclk);
 	}
 
 	switch (enable) {
@@ -1106,10 +1103,7 @@ static int csi2_set_stream(struct v4l2_subdev *sd, int enable)
 		csi2_if_enable(csi2, 0);
 		csi2_irq_ctx_set(csi2, 0);
 		omap4iss_csiphy_release(csi2->phy);
-		if (csi2 == &iss->csi2a)
-			omap4iss_subclk_disable(iss, OMAP4_ISS_SUBCLK_CSI2_A);
-		else if (csi2 == &iss->csi2b)
-			omap4iss_subclk_disable(iss, OMAP4_ISS_SUBCLK_CSI2_B);
+		omap4iss_subclk_disable(iss, csi2->subclk);
 		iss_video_dmaqueue_flags_clr(video_out);
 		break;
 	}
@@ -1311,6 +1305,7 @@ int omap4iss_csi2_init(struct iss_device *iss)
 	csi2a->available = 1;
 	csi2a->regs1 = OMAP4_ISS_MEM_CSI2_A_REGS1;
 	csi2a->phy = &iss->csiphy1;
+	csi2a->subclk = OMAP4_ISS_SUBCLK_CSI2_A;
 	csi2a->state = ISS_PIPELINE_STREAM_STOPPED;
 	init_waitqueue_head(&csi2a->wait);
 
@@ -1322,6 +1317,7 @@ int omap4iss_csi2_init(struct iss_device *iss)
 	csi2b->available = 1;
 	csi2b->regs1 = OMAP4_ISS_MEM_CSI2_B_REGS1;
 	csi2b->phy = &iss->csiphy2;
+	csi2b->subclk = OMAP4_ISS_SUBCLK_CSI2_B;
 	csi2b->state = ISS_PIPELINE_STREAM_STOPPED;
 	init_waitqueue_head(&csi2b->wait);
 
diff --git a/drivers/staging/media/omap4iss/iss_csi2.h b/drivers/staging/media/omap4iss/iss_csi2.h
index 69a6263..971aa7b 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.h
+++ b/drivers/staging/media/omap4iss/iss_csi2.h
@@ -131,6 +131,8 @@ struct iss_csi2_device {
 	/* memory resources, as defined in enum iss_mem_resources */
 	unsigned int regs1;
 	unsigned int regs2;
+	/* ISP subclock, as defined in enum iss_isp_subclk_resource */
+	unsigned int subclk;
 
 	u32 output; /* output to IPIPEIF, memory or both? */
 	bool dpcm_decompress;
-- 
1.8.3.2

