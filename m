Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:48593 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138Ab2LOKAG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 05:00:06 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [PATCH V3 13/15] [media] marvell-ccic: add dma burst mode support in marvell-ccic driver
Date: Sat, 15 Dec 2012 17:58:02 +0800
Message-Id: <1355565484-15791-14-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the dma burst size config support for marvell-ccic.
Developer can set the dma burst size in specified board driver.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 .../media/platform/marvell-ccic/mcam-core-soc.c    |    2 +-
 drivers/media/platform/marvell-ccic/mcam-core.h    |    7 ++++---
 drivers/media/platform/marvell-ccic/mmp-driver.c   |   11 +++++++++++
 include/media/mmp-camera.h                         |    1 +
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core-soc.c b/drivers/media/platform/marvell-ccic/mcam-core-soc.c
index 9016dc6..5b1dcfe 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core-soc.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core-soc.c
@@ -83,7 +83,7 @@ static int mcam_camera_add_device(struct soc_camera_device *icd)
 	mcam_ctlr_stop(mcam);
 	mcam_set_config_needed(mcam, 1);
 	mcam_reg_write(mcam, REG_CTRL1,
-				   C1_RESERVED | C1_DMAPOSTED);
+			mcam->burst |  C1_RESERVED | C1_DMAPOSTED);
 	mcam_reg_write(mcam, REG_CLKCTRL,
 		(mcam->mclk_src << 29) | mcam->mclk_div);
 	cam_dbg(mcam, "camera: set sensor mclk = %dMHz\n", mcam->mclk_min);
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 57442e0..e1025f2 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -126,6 +126,7 @@ struct mcam_camera {
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
 
+	int burst;
 	int mclk_min;
 	int mclk_src;
 	int mclk_div;
@@ -411,9 +412,9 @@ int mcam_soc_camera_host_register(struct mcam_camera *mcam);
 #define   C1_DESC_3WORD   0x00000200	/* Three-word descriptors used */
 #define	  C1_444ALPHA	  0x00f00000	/* Alpha field in RGB444 */
 #define	  C1_ALPHA_SHFT	  20
-#define	  C1_DMAB32	  0x00000000	/* 32-byte DMA burst */
-#define	  C1_DMAB16	  0x02000000	/* 16-byte DMA burst */
-#define	  C1_DMAB64	  0x04000000	/* 64-byte DMA burst */
+#define	  C1_DMAB64	  0x00000000	/* 64-byte DMA burst */
+#define	  C1_DMAB128	  0x02000000	/* 128-byte DMA burst */
+#define	  C1_DMAB256	  0x04000000	/* 256-byte DMA burst */
 #define	  C1_DMAB_MASK	  0x06000000
 #define	  C1_TWOBUFS	  0x08000000	/* Use only two DMA buffers */
 #define	  C1_PWRDWN	  0x10000000	/* Power down */
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index cd850f4..3469f02 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -400,6 +400,17 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->dphy = pdata->dphy;
 	mcam->mipi_enabled = 0;
 	mcam->lane = pdata->lane;
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
diff --git a/include/media/mmp-camera.h b/include/media/mmp-camera.h
index ec4f21f..4da0df7 100755
--- a/include/media/mmp-camera.h
+++ b/include/media/mmp-camera.h
@@ -13,6 +13,7 @@ struct mmp_camera_platform_data {
 	int mclk_src;
 	int mclk_div;
 	int chip_id;
+	int dma_burst;
 	/*
 	 * MIPI support
 	 */
-- 
1.7.9.5

