Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3LDA4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:31 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5795336400
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:39 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 09/25] v4l: omap4iss: Fix operators precedence in ternary operators
Date: Wed,  4 Dec 2013 01:56:09 +0100
Message-Id: <1386118585-12449-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ternary operator ? : has a low precedence. Use parenthesis where
needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c    | 20 +++++++-------------
 drivers/staging/media/omap4iss/iss_ipipe.c   |  2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c |  4 ++--
 drivers/staging/media/omap4iss/iss_resizer.c | 12 +++++-------
 4 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index c3a5fca..ac5868ac 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -274,7 +274,7 @@ static void csi2_set_outaddr(struct iss_csi2_device *csi2, u32 addr)
  */
 static inline int is_usr_def_mapping(u32 format_id)
 {
-	return ((format_id & 0xF0) == 0x40) ? 1 : 0;
+	return (format_id & 0xF0) == 0x40 ? 1 : 0;
 }
 
 /*
@@ -766,16 +766,11 @@ void omap4iss_csi2_isr(struct iss_csi2_device *csi2)
 			      CSI2_IRQ_FIFO_OVF)) {
 		dev_dbg(iss->dev,
 			"CSI2 Err: OCP:%d SHORT:%d ECC:%d CPXIO:%d OVF:%d\n",
-			(csi2_irqstatus &
-			 CSI2_IRQ_OCP_ERR) ? 1 : 0,
-			(csi2_irqstatus &
-			 CSI2_IRQ_SHORT_PACKET) ? 1 : 0,
-			(csi2_irqstatus &
-			 CSI2_IRQ_ECC_NO_CORRECTION) ? 1 : 0,
-			(csi2_irqstatus &
-			 CSI2_IRQ_COMPLEXIO_ERR) ? 1 : 0,
-			(csi2_irqstatus &
-			 CSI2_IRQ_FIFO_OVF) ? 1 : 0);
+			csi2_irqstatus & CSI2_IRQ_OCP_ERR ? 1 : 0,
+			csi2_irqstatus & CSI2_IRQ_SHORT_PACKET ? 1 : 0,
+			csi2_irqstatus & CSI2_IRQ_ECC_NO_CORRECTION ? 1 : 0,
+			csi2_irqstatus & CSI2_IRQ_COMPLEXIO_ERR ? 1 : 0,
+			csi2_irqstatus & CSI2_IRQ_FIFO_OVF ? 1 : 0);
 		pipe->error = true;
 	}
 
@@ -1209,8 +1204,7 @@ static int csi2_link_setup(struct media_entity *entity,
 		return -EINVAL;
 	}
 
-	ctrl->vp_only_enable =
-		(csi2->output & CSI2_OUTPUT_MEMORY) ? false : true;
+	ctrl->vp_only_enable = csi2->output & CSI2_OUTPUT_MEMORY ? false : true;
 	ctrl->vp_clk_enable = !!(csi2->output & CSI2_OUTPUT_IPIPEIF);
 
 	return 0;
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index fc38a5c5..bdafd78 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -75,7 +75,7 @@ static void ipipe_enable(struct iss_ipipe_device *ipipe, u8 enable)
 
 	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_EN) &
 		~IPIPE_SRC_EN_EN) |
-		enable ? IPIPE_SRC_EN_EN : 0,
+		(enable ? IPIPE_SRC_EN_EN : 0),
 		iss->regs[OMAP4_ISS_MEM_ISP_IPIPE] + IPIPE_SRC_EN);
 }
 
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 5464742..3d6cc88 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -85,7 +85,7 @@ static void ipipeif_write_enable(struct iss_ipipeif_device *ipipeif, u8 enable)
 
 	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN) &
 		~ISIF_SYNCEN_DWEN) |
-		enable ? ISIF_SYNCEN_DWEN : 0,
+		(enable ? ISIF_SYNCEN_DWEN : 0),
 		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN);
 }
 
@@ -100,7 +100,7 @@ static void ipipeif_enable(struct iss_ipipeif_device *ipipeif, u8 enable)
 
 	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN) &
 		~ISIF_SYNCEN_SYEN) |
-		enable ? ISIF_SYNCEN_SYEN : 0,
+		(enable ? ISIF_SYNCEN_SYEN : 0),
 		iss->regs[OMAP4_ISS_MEM_ISP_ISIF] + ISIF_SYNCEN);
 }
 
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 272b92a..68eb2a7 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -118,13 +118,13 @@ static void resizer_enable(struct iss_resizer_device *resizer, u8 enable)
 
 	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_EN) &
 		~RSZ_SRC_EN_SRC_EN) |
-		enable ? RSZ_SRC_EN_SRC_EN : 0,
+		(enable ? RSZ_SRC_EN_SRC_EN : 0),
 		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_EN);
 
 	/* TODO: Enable RSZB */
 	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN) &
 		~RSZ_EN_EN) |
-		enable ? RSZ_EN_EN : 0,
+		(enable ? RSZ_EN_EN : 0),
 		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RZA_EN);
 }
 
@@ -202,7 +202,7 @@ static void resizer_configure(struct iss_resizer_device *resizer)
 	/* Select RSZ input */
 	writel((readl(iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_FMT0) &
 		~RSZ_SRC_FMT0_SEL) |
-		(resizer->input == RESIZER_INPUT_IPIPEIF) ? RSZ_SRC_FMT0_SEL : 0,
+		(resizer->input == RESIZER_INPUT_IPIPEIF ? RSZ_SRC_FMT0_SEL : 0),
 		iss->regs[OMAP4_ISS_MEM_ISP_RESIZER] + RSZ_SRC_FMT0);
 
 	/* RSZ ignores WEN signal from IPIPE/IPIPEIF */
@@ -318,10 +318,8 @@ void omap4iss_resizer_isr(struct iss_resizer_device *resizer, u32 events)
 	if (events & (ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR |
 		      ISP5_IRQ_RSZ_FIFO_OVF)) {
 		dev_dbg(iss->dev, "RSZ Err: FIFO_IN_BLK:%d, FIFO_OVF:%d\n",
-			(events &
-			 ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR) ? 1 : 0,
-			(events &
-			 ISP5_IRQ_RSZ_FIFO_OVF) ? 1 : 0);
+			events & ISP5_IRQ_RSZ_FIFO_IN_BLK_ERR ? 1 : 0,
+			events & ISP5_IRQ_RSZ_FIFO_OVF ? 1 : 0);
 		pipe->error = true;
 	}
 
-- 
1.8.3.2

