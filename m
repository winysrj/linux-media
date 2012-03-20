Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62539 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736Ab2CTKjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:39:12 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M1600KMWIX8SG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:09 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M160044PIX6KS@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:06 +0000 (GMT)
Date: Tue, 20 Mar 2012 11:39:00 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/6] s5p-fimc: Don't use platform data for CSI data alignment
 configuration
In-reply-to: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1332239945-32711-2-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MIPI-CSI2 data alignment parameter can be derived from media bus
pixel code, so it can be now dropped from the platform data structure.
This is a prerequisite for adding the device tree support. Once this
patch is merged the corresponding fields will be removed from the
driver public headers and corresponding board files.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c  |    3 ++-
 drivers/media/video/s5p-fimc/mipi-csis.c |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 15466d0..ff11f10 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -674,6 +674,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 {
 	u32 cfg, tmp;
 	struct fimc_vid_cap *vid_cap = &fimc->vid_cap;
+	u32 csis_data_alignment = 32;
 
 	cfg = readl(fimc->regs + S5P_CIGCTRL);
 
@@ -703,7 +704,7 @@ int fimc_hw_set_camera_type(struct fimc_dev *fimc,
 				 vid_cap->mf.code);
 			return -EINVAL;
 		}
-		tmp |= (cam->csi_data_align == 32) << 8;
+		tmp |= (csis_data_alignment == 32) << 8;
 
 		writel(tmp, fimc->regs + S5P_CSIIMGFMT);
 
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index f44f690..1cd6b6b 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -127,20 +127,24 @@ struct csis_state {
  *                       multiple of 2^pix_width_alignment
  * @code: corresponding media bus code
  * @fmt_reg: S5PCSIS_CONFIG register value
+ * @data_alignment: MIPI-CSI data alignment in bits
  */
 struct csis_pix_format {
 	unsigned int pix_width_alignment;
 	enum v4l2_mbus_pixelcode code;
 	u32 fmt_reg;
+	u8 data_alignment;
 };
 
 static const struct csis_pix_format s5pcsis_formats[] = {
 	{
 		.code = V4L2_MBUS_FMT_VYUY8_2X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_YCBCR422_8BIT,
+		.data_alignment = 32,
 	}, {
 		.code = V4L2_MBUS_FMT_JPEG_1X8,
 		.fmt_reg = S5PCSIS_CFG_FMT_USER(1),
+		.data_alignment = 32,
 	},
 };
 
@@ -239,7 +243,7 @@ static void s5pcsis_set_params(struct csis_state *state)
 	s5pcsis_set_hsync_settle(state, pdata->hs_settle);
 
 	val = s5pcsis_read(state, S5PCSIS_CTRL);
-	if (pdata->alignment == 32)
+	if (state->csis_fmt->data_alignment == 32)
 		val |= S5PCSIS_CTRL_ALIGN_32BIT;
 	else /* 24-bits */
 		val &= ~S5PCSIS_CTRL_ALIGN_32BIT;
-- 
1.7.9.2

