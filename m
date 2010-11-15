Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:60873 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757356Ab0KOOaD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 09:30:03 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp][PATCH v2 9/9] omap3isp: Remove legacy MMU access regs/fields
Date: Mon, 15 Nov 2010 08:30:01 -0600
Message-Id: <1289831401-593-10-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289831401-593-1-git-send-email-saaguirre@ti.com>
References: <1289831401-593-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/ispreg.h |   43 --------------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/drivers/media/video/isp/ispreg.h b/drivers/media/video/isp/ispreg.h
index 9b0d3ad..af4ddaa 100644
--- a/drivers/media/video/isp/ispreg.h
+++ b/drivers/media/video/isp/ispreg.h
@@ -72,11 +72,6 @@
 					 OMAP3ISP_SBL_REG_OFFSET)
 #define OMAP3ISP_SBL_REG(offset)	(OMAP3ISP_SBL_REG_BASE + (offset))
 
-#define OMAP3ISP_MMU_REG_OFFSET		0x1400
-#define OMAP3ISP_MMU_REG_BASE		(OMAP3ISP_REG_BASE +		\
-					 OMAP3ISP_MMU_REG_OFFSET)
-#define OMAP3ISP_MMU_REG(offset)	(OMAP3ISP_MMU_REG_BASE + (offset))
-
 #define OMAP3ISP_CSI2A_REGS1_REG_OFFSET	0x1800
 #define OMAP3ISP_CSI2A_REGS1_REG_BASE	(OMAP3ISP_REG_BASE +		\
 					 OMAP3ISP_CSI2A_REGS1_REG_OFFSET)
@@ -458,26 +453,6 @@
 #define ISPRSZ_VFILT3130		(0x0A4)
 #define ISPRSZ_YENH			(0x0A8)
 
-/* MMU module registers */
-#define ISPMMU_REVISION			(0x000)
-#define ISPMMU_SYSCONFIG		(0x010)
-#define ISPMMU_SYSSTATUS		(0x014)
-#define ISPMMU_IRQSTATUS		(0x018)
-#define ISPMMU_IRQENABLE		(0x01C)
-#define ISPMMU_WALKING_ST		(0x040)
-#define ISPMMU_CNTL			(0x044)
-#define ISPMMU_FAULT_AD			(0x048)
-#define ISPMMU_TTB			(0x04C)
-#define ISPMMU_LOCK			(0x050)
-#define ISPMMU_LD_TLB			(0x054)
-#define ISPMMU_CAM			(0x058)
-#define ISPMMU_RAM			(0x05C)
-#define ISPMMU_GFLUSH			(0x060)
-#define ISPMMU_FLUSH_ENTRY		(0x064)
-#define ISPMMU_READ_CAM			(0x068)
-#define ISPMMU_READ_RAM			(0x06c)
-#define ISPMMU_EMU_FAULT_AD		(0x070)
-
 #define ISP_INT_CLR			0xFF113F11
 #define ISPPRV_PCR_EN			1
 #define ISPPRV_PCR_BUSY			(1 << 1)
@@ -1299,24 +1274,6 @@
 #define ISPCCDC_LSC_INITIAL_Y_MASK		0x3F0000
 #define ISPCCDC_LSC_INITIAL_Y_SHIFT		16
 
-#define ISPMMU_REVISION_REV_MINOR_MASK		0xF
-#define ISPMMU_REVISION_REV_MAJOR_SHIFT		0x4
-
-#define IRQENABLE_MULTIHITFAULT			(1<<4)
-#define IRQENABLE_TWFAULT			(1<<3)
-#define IRQENABLE_EMUMISS			(1<<2)
-#define IRQENABLE_TRANSLNFAULT			(1<<1)
-#define IRQENABLE_TLBMISS			(1)
-
-#define ISPMMU_MMUCNTL_MMU_EN			(1<<1)
-#define ISPMMU_MMUCNTL_TWL_EN			(1<<2)
-#define ISPMMU_MMUCNTL_EMUTLBUPDATE		(1<<3)
-#define ISPMMU_AUTOIDLE				0x1
-#define ISPMMU_SIDLEMODE_FORCEIDLE		0
-#define ISPMMU_SIDLEMODE_NOIDLE			1
-#define ISPMMU_SIDLEMODE_SMARTIDLE		2
-#define ISPMMU_SIDLEMODE_SHIFT			3
-
 /* -----------------------------------------------------------------------------
  * CSI2 receiver registers (ES2.0)
  */
-- 
1.7.0.4

