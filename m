Return-path: <mchehab@gaivota>
Received: from devils.ext.ti.com ([198.47.26.153]:52311 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab0KSXYA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:24:00 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 4/4] omap3isp: csi2: Don't dump ISP main registers
Date: Fri, 19 Nov 2010 17:23:51 -0600
Message-Id: <1290209031-12817-5-git-send-email-saaguirre@ti.com>
In-Reply-To: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
References: <1290209031-12817-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

This keeps the driver focused only on accessing CSI2 registers
only.

if the same info is needed, isp_print_status should be called instead.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/ispcsi2.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/media/video/isp/ispcsi2.c b/drivers/media/video/isp/ispcsi2.c
index 35e3629..13e7e22 100644
--- a/drivers/media/video/isp/ispcsi2.c
+++ b/drivers/media/video/isp/ispcsi2.c
@@ -611,13 +611,6 @@ void isp_csi2_regdump(struct isp_csi2_device *csi2)
 
 	dev_dbg(isp->dev, "-------------CSI2 Register dump-------------\n");
 
-	dev_dbg(isp->dev, "###ISP_CTRL=0x%x\n",
-		isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_CTRL));
-	dev_dbg(isp->dev, "###ISP_IRQ0ENABLE=0x%x\n",
-		isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE));
-	dev_dbg(isp->dev, "###ISP_IRQ0STATUS=0x%x\n",
-		isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS));
-
 	CSI2_PRINT_REGISTER(isp, csi2->regs1, SYSCONFIG);
 	CSI2_PRINT_REGISTER(isp, csi2->regs1, SYSSTATUS);
 	CSI2_PRINT_REGISTER(isp, csi2->regs1, IRQENABLE);
-- 
1.7.0.4

