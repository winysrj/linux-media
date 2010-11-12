Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:59358 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413Ab0KLVSK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Nov 2010 16:18:10 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [omap3isp RFC][PATCH 09/10] omap3isp: ccp2: Make SYSCONFIG fields consistent
Date: Fri, 12 Nov 2010 15:18:12 -0600
Message-Id: <1289596693-27660-10-git-send-email-saaguirre@ti.com>
In-Reply-To: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
References: <1289596693-27660-1-git-send-email-saaguirre@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/isp/ispccp2.c |    3 +--
 drivers/media/video/isp/ispreg.h  |   14 ++++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/isp/ispccp2.c b/drivers/media/video/isp/ispccp2.c
index fa23394..3127a74 100644
--- a/drivers/media/video/isp/ispccp2.c
+++ b/drivers/media/video/isp/ispccp2.c
@@ -419,8 +419,7 @@ static void ispccp2_mem_configure(struct isp_ccp2_device *ccp2,
 		config->src_ofst = 0;
 	}
 
-	isp_reg_writel(isp, (ISPCSI1_MIDLEMODE_SMARTSTANDBY <<
-		       ISPCSI1_MIDLEMODE_SHIFT),
+	isp_reg_writel(isp, ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART,
 		       OMAP3_ISP_IOMEM_CCP2, ISPCCP2_SYSCONFIG);
 
 	/* Hsize, Skip */
diff --git a/drivers/media/video/isp/ispreg.h b/drivers/media/video/isp/ispreg.h
index d885541..9b0d3ad 100644
--- a/drivers/media/video/isp/ispreg.h
+++ b/drivers/media/video/isp/ispreg.h
@@ -141,6 +141,14 @@
 #define ISPCCP2_REVISION		(0x000)
 #define ISPCCP2_SYSCONFIG		(0x004)
 #define ISPCCP2_SYSCONFIG_SOFT_RESET	(1 << 1)
+#define ISPCCP2_SYSCONFIG_AUTO_IDLE		0x1
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT	12
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_FORCE	\
+	(0x0 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_NO	\
+	(0x1 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
+#define ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SMART	\
+	(0x2 << ISPCCP2_SYSCONFIG_MSTANDBY_MODE_SHIFT)
 #define ISPCCP2_SYSSTATUS		(0x008)
 #define ISPCCP2_SYSSTATUS_RESET_DONE	(1 << 0)
 #define ISPCCP2_LC01_IRQENABLE		(0x00C)
@@ -1309,12 +1317,6 @@
 #define ISPMMU_SIDLEMODE_SMARTIDLE		2
 #define ISPMMU_SIDLEMODE_SHIFT			3
 
-#define ISPCSI1_AUTOIDLE			0x1
-#define ISPCSI1_MIDLEMODE_SHIFT			12
-#define ISPCSI1_MIDLEMODE_FORCESTANDBY		0x0
-#define ISPCSI1_MIDLEMODE_NOSTANDBY		0x1
-#define ISPCSI1_MIDLEMODE_SMARTSTANDBY		0x2
-
 /* -----------------------------------------------------------------------------
  * CSI2 receiver registers (ES2.0)
  */
-- 
1.7.0.4

