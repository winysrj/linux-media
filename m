Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:58092 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754681AbdCGNtB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 08:49:01 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH] [media] platform: Order the Makefile alphabetically
Date: Tue,  7 Mar 2017 14:39:28 +0100
Message-Id: <20170307133928.24527-1-maxime.ripard@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Makefile was a free for all without a clear order defined. Sort all the
options based on the Kconfig symbol.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/media/platform/Makefile | 89 ++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 349ddf6a69da..bd5dc3068cbc 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -1,73 +1,46 @@
 #
 # Makefile for the video capture/playback device drivers.
 #
+ccflags-y += -I$(srctree)/drivers/media/i2c
 
-obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
-
-obj-$(CONFIG_VIDEO_VIA_CAMERA) += via-camera.o
-obj-$(CONFIG_VIDEO_CAFE_CCIC) += marvell-ccic/
-obj-$(CONFIG_VIDEO_MMP_CAMERA) += marvell-ccic/
-
-obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
-obj-$(CONFIG_VIDEO_PXA27x)	+= pxa_camera.o
-
-obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
-
-obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
-obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
-
-obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
-
-obj-$(CONFIG_VIDEO_TI_CAL)		+= ti-vpe/
-
-obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
+obj-y					+= omap/
+obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
+obj-$(CONFIG_BLACKFIN)                  += blackfin/
+obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
+obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
+obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
+obj-$(CONFIG_VIDEO_CAFE_CCIC)		+= marvell-ccic/
 obj-$(CONFIG_VIDEO_CODA) 		+= coda/
-
-obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
-
+obj-$(CONFIG_VIDEO_M32R_AR_M64278)	+= arv.o
+obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
+obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
+obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
 obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
-
+obj-$(CONFIG_VIDEO_MMP_CAMERA)		+= marvell-ccic/
+obj-$(CONFIG_VIDEO_MX2_EMMAPRP)		+= mx2_emmaprp.o
+obj-$(CONFIG_VIDEO_OMAP3)		+= omap3isp/
+obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
+obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
+obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
+obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
+obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
+obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
-
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_G2D)	+= s5p-g2d/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS_GSC)	+= exynos-gsc/
-
+obj-$(CONFIG_VIDEO_SH_VEU)		+= sh_veu.o
+obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
 obj-$(CONFIG_VIDEO_STI_BDISP)		+= sti/bdisp/
-obj-$(CONFIG_VIDEO_STI_HVA)		+= sti/hva/
-obj-$(CONFIG_DVB_C8SECTPFE)		+= sti/c8sectpfe/
-
 obj-$(CONFIG_VIDEO_STI_DELTA)		+= sti/delta/
-
-obj-$(CONFIG_BLACKFIN)                  += blackfin/
-
-obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
-
-obj-$(CONFIG_VIDEO_SH_VOU)		+= sh_vou.o
-
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera/
-
-obj-$(CONFIG_VIDEO_RENESAS_FCP) 	+= rcar-fcp.o
-obj-$(CONFIG_VIDEO_RENESAS_FDP1)	+= rcar_fdp1.o
-obj-$(CONFIG_VIDEO_RENESAS_JPU) 	+= rcar_jpu.o
-obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
-
-obj-y	+= omap/
-
-obj-$(CONFIG_VIDEO_AM437X_VPFE)		+= am437x/
-
+obj-$(CONFIG_VIDEO_STI_HVA)		+= sti/hva/
+obj-$(CONFIG_VIDEO_TI_CAL)		+= ti-vpe/
+obj-$(CONFIG_VIDEO_TI_VPE)		+= ti-vpe/
+obj-$(CONFIG_VIDEO_VIA_CAMERA)		+= via-camera.o
+obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
+obj-$(CONFIG_VIDEO_VIU)			+= fsl-viu.o
+obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
 obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
-
-obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
-
-obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
-
-ccflags-y += -I$(srctree)/drivers/media/i2c
-
-obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
-
-obj-$(CONFIG_VIDEO_MEDIATEK_VCODEC)	+= mtk-vcodec/
-
-obj-$(CONFIG_VIDEO_MEDIATEK_MDP)	+= mtk-mdp/
-- 
2.11.0
