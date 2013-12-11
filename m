Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44086 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3LKQHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Dec 2013 11:07:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Josh Wu <josh.wu@atmel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v2 7/7] v4l: atmel-isi: Should clear bits before set the hardware register
Date: Wed, 11 Dec 2013 17:07:45 +0100
Message-Id: <1386778065-14135-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386778065-14135-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Josh Wu <josh.wu@atmel.com>

In the ISI driver it reads the config register to get original value,
then set the correct FRATE_DIV and YCC_SWAP_MODE directly. This will
cause some bits overlap.

So we need to clear these bits first, then set correct value. This patch
fix it.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/soc_camera/atmel-isi.c | 3 +++
 include/media/atmel-isi.h                     | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 9c4cadc..4835173 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -132,6 +132,8 @@ static int configure_geometry(struct atmel_isi *isi, u32 width,
 	isi_writel(isi, ISI_CTRL, ISI_CTRL_DIS);
 
 	cfg2 = isi_readl(isi, ISI_CFG2);
+	/* Set YCC swap mode */
+	cfg2 &= ~ISI_CFG2_YCC_SWAP_MODE_MASK;
 	cfg2 |= cr;
 	/* Set width */
 	cfg2 &= ~(ISI_CFG2_IM_HSIZE_MASK);
@@ -346,6 +348,7 @@ static void start_dma(struct atmel_isi *isi, struct frame_buffer *buffer)
 	isi_writel(isi, ISI_DMA_C_CTRL, ISI_DMA_CTRL_FETCH | ISI_DMA_CTRL_DONE);
 	isi_writel(isi, ISI_DMA_CHER, ISI_DMA_CHSR_C_CH);
 
+	cfg1 &= ~ISI_CFG1_FRATE_DIV_MASK;
 	/* Enable linked list */
 	cfg1 |= isi->pdata->frate | ISI_CFG1_DISCR;
 
diff --git a/include/media/atmel-isi.h b/include/media/atmel-isi.h
index 6568230..2b02347 100644
--- a/include/media/atmel-isi.h
+++ b/include/media/atmel-isi.h
@@ -56,6 +56,7 @@
 #define		ISI_CFG1_FRATE_DIV_6		(5 << 8)
 #define		ISI_CFG1_FRATE_DIV_7		(6 << 8)
 #define		ISI_CFG1_FRATE_DIV_8		(7 << 8)
+#define		ISI_CFG1_FRATE_DIV_MASK		(7 << 8)
 #define ISI_CFG1_DISCR				(1 << 11)
 #define ISI_CFG1_FULL_MODE			(1 << 12)
 
@@ -66,6 +67,7 @@
 #define		ISI_CFG2_YCC_SWAP_MODE_1	(1 << 28)
 #define		ISI_CFG2_YCC_SWAP_MODE_2	(2 << 28)
 #define		ISI_CFG2_YCC_SWAP_MODE_3	(3 << 28)
+#define		ISI_CFG2_YCC_SWAP_MODE_MASK	(3 << 28)
 #define ISI_CFG2_IM_VSIZE_OFFSET		0
 #define ISI_CFG2_IM_HSIZE_OFFSET		16
 #define ISI_CFG2_IM_VSIZE_MASK		(0x7FF << ISI_CFG2_IM_VSIZE_OFFSET)
-- 
1.8.3.2

