Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:51532 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279Ab3FDFsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jun 2013 01:48:23 -0400
Message-ID: <1370324790.26072.25.camel@younglee-desktop>
Subject: [PATCH 3/7] marvell-ccic: reset ccic phy when stop streaming for
 stability
From: lbyang <lbyang@marvell.com>
Reply-To: <lbyang@marvell.com>
To: <corbet@lwn.net>, <g.liakhovetski@gmx.de>, <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <lbyang@marvell.com>,
	<albert.v.wang@gmail.com>
Date: Tue, 4 Jun 2013 13:46:30 +0800
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Libin Yang <lbyang@marvell.com>

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
index bb3de1f..f9b8641 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1056,6 +1056,12 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
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
index c506cd3..ab5e829c9 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -109,6 +109,7 @@ struct mcam_camera {
 	int mclk_src;
 	int mclk_div;
 
+	int ccic_id;
 	enum v4l2_mbus_type bus_type;
 	/* MIPI support */
 	int *dphy;
@@ -124,6 +125,7 @@ struct mcam_camera {
 	int (*plat_power_up) (struct mcam_camera *cam);
 	void (*plat_power_down) (struct mcam_camera *cam);
 	void (*calc_dphy) (struct mcam_camera *cam);
+	void (*ctlr_reset) (struct mcam_camera *cam);
 
 	/*
 	 * Everything below here is private to the mcam core and
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 233d0ff..2998477 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -106,6 +106,7 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 #define CPU_SUBSYS_PMU_BASE	0xd4282800
 #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
 #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
+#define REG_CCIC2_CRCR		0xf4	/* CCIC2 clk reset ctrl reg	*/
 
 static void mcam_clk_enable(struct mcam_camera *mcam)
 {
@@ -193,6 +194,28 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
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
@@ -339,9 +362,11 @@ static int mmpcam_probe(struct platform_device *pdev)
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



