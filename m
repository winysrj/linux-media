Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:32821 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758224Ab3BGMGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 Feb 2013 07:06:00 -0500
From: Albert Wang <twang13@marvell.com>
To: corbet@lwn.net, g.liakhovetski@gmx.de
Cc: linux-media@vger.kernel.org, Albert Wang <twang13@marvell.com>,
	Libin Yang <lbyang@marvell.com>
Subject: [REVIEW PATCH V4 03/12] [media] marvell-ccic: reset ccic phy when stop streaming for stability
Date: Thu,  7 Feb 2013 20:04:38 +0800
Message-Id: <1360238687-15768-4-git-send-email-twang13@marvell.com>
In-Reply-To: <1360238687-15768-1-git-send-email-twang13@marvell.com>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
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
index 7e178d8..a32df35 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1045,6 +1045,12 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
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
index 2b2dc06..ec43630 100755
--- a/drivers/media/platform/marvell-ccic/mcam-core.h
+++ b/drivers/media/platform/marvell-ccic/mcam-core.h
@@ -104,6 +104,7 @@ struct mcam_camera {
 	short int use_smbus;	/* SMBUS or straight I2c? */
 	enum mcam_buffer_mode buffer_mode;
 
+	int ccic_id;
 	enum v4l2_mbus_type bus_type;
 	/* MIPI support */
 	int *dphy;
@@ -120,6 +121,7 @@ struct mcam_camera {
 	void (*plat_power_up) (struct mcam_camera *cam);
 	void (*plat_power_down) (struct mcam_camera *cam);
 	void (*calc_dphy) (struct mcam_camera *cam);
+	void (*ctlr_reset) (struct mcam_camera *cam);
 
 	/*
 	 * Everything below here is private to the mcam core and
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 2fe0324..818abf3 100755
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -105,6 +105,7 @@ static struct mmp_camera *mmpcam_find_device(struct platform_device *pdev)
 #define CPU_SUBSYS_PMU_BASE	0xd4282800
 #define REG_CCIC_DCGCR		0x28	/* CCIC dyn clock gate ctrl reg */
 #define REG_CCIC_CRCR		0x50	/* CCIC clk reset ctrl reg	*/
+#define REG_CCIC2_CRCR		0xf4	/* CCIC2 clk reset ctrl reg	*/
 
 static void mcam_clk_enable(struct mcam_camera *mcam)
 {
@@ -179,6 +180,28 @@ static void mmpcam_power_down(struct mcam_camera *mcam)
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
@@ -328,9 +351,11 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam = &cam->mcam;
 	mcam->plat_power_up = mmpcam_power_up;
 	mcam->plat_power_down = mmpcam_power_down;
+	mcam->ctlr_reset = mcam_ctlr_reset;
 	mcam->calc_dphy = mmpcam_calc_dphy;
 	mcam->dev = &pdev->dev;
 	mcam->use_smbus = 0;
+	mcam->ccic_id = pdev->id;
 	mcam->bus_type = pdata->bus_type;
 	mcam->dphy = pdata->dphy;
 	/* mosetly it won't happen. dphy is an array in pdata, but in case .. */
-- 
1.7.9.5

