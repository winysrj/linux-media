Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:40994 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757267Ab3BGMGW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:06:22 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [REVIEW PATCH V4 11/12] [media] marvell-ccic: add dma burst support for marvell-ccic driver
Date: Thu,  7 Feb 2013 20:04:46 +0800
Message-Id: <1360238687-15768-12-git-send-email-twang13@marvell.com>
In-Reply-To: <1360238687-15768-1-git-send-email-twang13@marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the dma burst size config support for marvell-ccic.
Developer can set the dma burst size in specified board driver.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/media/platform/marvell-ccic/mcam-core.c  |    3 ++-
 drivers/media/platform/marvell-ccic/mcam-core.h  |    8 ++++----
 drivers/media/platform/marvell-ccic/mmp-driver.c |   11 +++++++++++
 include/media/mmp-camera.h                       |    1 +
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 16ba045..f206e3c 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1218,7 +1218,8 @@ static int mcam_camera_add_device(struct soc_camera_device *icd)
 	mcam_ctlr_power_up(mcam);
 	mcam_ctlr_stop(mcam);
 	mcam_set_config_needed(mcam, 1);
-	mcam_reg_write(mcam, REG_CTRL1, C1_RESERVED | C1_DMAPOSTED);
+	mcam_reg_write(mcam, REG_CTRL1,
+				mcam->burst | C1_RESERVED | C1_DMAPOSTED);
 	mcam_reg_write(mcam, REG_CLKCTRL,
 				(mcam->mclk_src << 29) | mcam->mclk_div);
 	cam_dbg(mcam, "camera: set sensor mclk = %dMHz\n", mcam->mclk_min);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 12af7d2..0accdbb 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -108,6 +108,7 @@ struct mcam_camera {
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
 
+	u32 burst;
 	int mclk_min;
 	int mclk_src;
 	int mclk_div;
@@ -347,10 +348,9 @@ int mccic_resume(struct mcam_camera *cam);
 #define   C1_DESC_3WORD   0x00000200	/* Three-word descriptors used */
 #define	  C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
 #define	  C1_ALPHA_SHFT	  20
-#define	  C1_DMAB32	  0x00000000	/* 32-byte DMA burst */
-#define	  C1_DMAB16	  0x02000000	/* 16-byte DMA burst */
-#define	  C1_DMAB64	  0x04000000	/* 64-byte DMA burst */
-#define	  C1_DMAB_MASK	  0x06000000
+#define	  C1_DMAB64	  0x00000000	/* 64-byte DMA burst */
+#define	  C1_DMAB128	  0x02000000	/* 128-byte DMA burst */
+#define	  C1_DMAB256	  0x04000000	/* 256-byte DMA burst */
 #define	  C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
 #define	  C1_PWRDWN	  0x10000000	/* Power down */
 #define   C1_DMAPOSTED	  0x40000000    /* DMA Posted Select */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 3d5db24..3fd6a46 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -360,6 +360,17 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->lane = pdata->lane;
 	/* set B_DMA_CONTIG as default */
 	mcam->buffer_mode = B_DMA_CONTIG;
+	switch (pdata->dma_burst) {
+	case 128:
+		mcam->burst = C1_DMAB128;
+		break;
+	case 256:
+		mcam->burst = C1_DMAB256;
+		break;
+	default:
+		mcam->burst = C1_DMAB64;
+		break;
+	}
 	INIT_LIST_HEAD(&mcam->buffers);
 	/*
 	 * Get our I/O memory.
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index 513d846..44234dd 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -13,6 +13,7 @@ struct mmp_camera_platform_data {
 	int mclk_src;
 	int mclk_div;
 	int chip_id;
+	u32 dma_burst;
 	/*
 	 * MIPI support
 	 */
-- 
1.7.9.5

