Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:45787 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab2LOJ7x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Dec 2012 04:59:53 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH V3 04/15] [media] marvell-ccic: reset ccic phy when stop streaming for stability
Date: Sat, 15 Dec 2012 17:57:53 +0800
Message-Id: <1355565484-15791-5-git-send-email-twang13@marvell.com>
In-Reply-To: <1355565484-15791-1-git-send-email-twang13@marvell.com>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

This patch adds the reset ccic phy operation when stop streaming.

Without reset ccic phy, the next start streaming may be unstable.

Also need add CCIC2 definition when PXA688/PXA2128 support dual ccics.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
---
 drivers/media/platform/marvell-ccic/mcam-core.c  |    6 ++++++
 drivers/media/platform/marvell-ccic/mcam-core.h  |    2 ++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   25 ++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index f6ae06d..19e91c5 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1058,6 +1058,12 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
 		return -EINVAL;
 	mcam_ctlr_stop_dma(cam);
 	/*
+	 * Reset the CCIC PHY after stopping streaming,
+	 * otherwise, the CCIC may be unstable.
+	 */
+	if (cam->ctlr_reset)
+		cam->ctlr_reset(cam);
+	/*
 	 * VB2 reclaims the buffers, so we need to forget
 	 * about them.
 	 */
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.h b/drivers/media/platform/marvell-ccic/mcam-core.h
index 86e634e..7c42cbe 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -103,6 +103,7 @@ struct mcam_camera {
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
 
+	int ccic_id;
 	enum v4l2_mbus_type bus_type;
 	/* MIPI support */
 	int *dphy;
@@ -120,6 +121,7 @@ struct mcam_camera {
 	void (*plat_power_up) (struct mcam_camera *cam);
 	void (*plat_power_down) (struct mcam_camera *cam);
 	void (*calc_dphy)(struct mcam_camera *cam);
+	void (*ctlr_reset)(struct mcam_camera *cam);
 
 	/*
 	 * Everything below here is private to the mcam core and
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 2c4dce3..fec7cd8 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -103,6 +103,7 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 #define CPU_SUBSYS_PMU_BASE	0xd4282800
 #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
 #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
+#define REG_CCIC2_CRCR		0xf4	/* CCIC2 clk reset ctrl reg	*/
 
 static void mcam_clk_set(struct mcam_camera *mcam, int on)
 {
@@ -174,6 +175,28 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 	mcam_clk_set(mcam, 0);
 }
 
+void mcam_ctlr_reset(struct mcam_camera *mcam)
+{
+	unsigned long val;
+	struct mmp_camera *cam = mcam_to_cam(mcam);
+
+	if (mcam->ccic_id) {
+		/*
+		 * Using CCIC2
+		 */
+		val = ioread32(cam->power_regs + REG_CCIC2_CRCR);
+		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC2_CRCR);
+		iowrite32(val | 0x2, cam->power_regs + REG_CCIC2_CRCR);
+	} else {
+		/*
+		 * Using CCIC1
+		 */
+		val = ioread32(cam->power_regs + REG_CCIC_CRCR);
+		iowrite32(val & ~0x2, cam->power_regs + REG_CCIC_CRCR);
+		iowrite32(val | 0x2, cam->power_regs + REG_CCIC_CRCR);
+	}
+}
+
 /*
  * calc the dphy register values
  * There are three dphy registers being used.
@@ -301,10 +324,12 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam = &cam->mcam;
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
+	mcam->ctlr_reset = mcam_ctlr_reset;
 	mcam->calc_dphy = mmpcam_calc_dphy;
 	mcam->pll1 = NULL;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
+	mcam->ccic_id = pdev->id;
 	mcam->bus_type = pdata->bus_type;
 	mcam->dphy = pdata->dphy;
 	mcam->mipi_enabled = 0;
-- 
1.7.9.5

