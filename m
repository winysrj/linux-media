Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:46461 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab3GCF4X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jul 2013 01:56:23 -0400
From: Libin Yang <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>
CC: <linux-media@vger.kernel.org>, <albert.v.wang@gmail.com>,
	Libin Yang <lbyang@marvell.com>,
	Albert Wang <twang13@marvell.com>
Subject: [PATCH v3 3/7] marvell-ccic: reset ccic phy when stop streaming for stability
Date: Wed, 3 Jul 2013 13:56:00 +0800
Message-ID: <1372830964-22323-4-git-send-email-lbyang@marvell.com>
In-Reply-To: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
References: <1372830964-22323-1-git-send-email-lbyang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the reset ccic phy operation when stop streaming.

Stop streaming without reset ccic phy, the next start streaming
may be unstable.
Also need add CCIC2 definition when PXA688/PXA2128 support dual ccics.

Signed-off-by: Albert Wang <twang13@marvell.com>
Signed-off-by: Libin Yang <lbyang@marvell.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/marvell-ccic/mcam-core.c  |    6 ++++++
 drivers/media/platform/marvell-ccic/mcam-core.h  |    2 ++
 drivers/media/platform/marvell-ccic/mmp-driver.c |   25 ++++++++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index abe8538..6921e84 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1059,6 +1059,12 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
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
index 07fdf68..4d4db6b 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -109,6 +109,7 @@ struct mcam_camera {
 	int mclk_src;	/* which clock source the mclk derives from */
 	int mclk_div;	/* Clock Divider Value for MCLK */
 
+	int ccic_id;
 	enum v4l2_mbus_type bus_type;
 	/* MIPI support */
 	/* The dphy config value, allocated in board file
@@ -129,6 +130,7 @@ struct mcam_camera {
 	int (*plat_power_up) (struct mcam_camera *cam);
 	void (*plat_power_down) (struct mcam_camera *cam);
 	void (*calc_dphy) (struct mcam_camera *cam);
+	void (*ctlr_reset) (struct mcam_camera *cam);
 
 	/*
 	 * Everything below here is private to the mcam core and
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 64dacc5..7503983 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -106,6 +106,7 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 #define CPU_SUBSYS_PMU_BASE	0xd4282800
 #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
 #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
+#define REG_CCIC2_CRCR		0xf4	/* CCIC2 clk reset ctrl reg	*/
 
 static void mcam_clk_enable(struct mcam_camera *mcam)
 {
@@ -195,6 +196,28 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
 	mcam_clk_disable(mcam);
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
@@ -355,9 +378,11 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam = &cam->mcam;
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
+	mcam->ctlr_reset = mcam_ctlr_reset;
 	mcam->calc_dphy = mmpcam_calc_dphy;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
+	mcam->ccic_id = pdev->id;
 	mcam->mclk_min = pdata->mclk_min;
 	mcam->mclk_src = pdata->mclk_src;
 	mcam->mclk_div = pdata->mclk_div;
-- 
1.7.9.5

