Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:15135 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab1IVQmj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 12:42:39 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRX00LQ4NR0SF@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 17:42:36 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRX0074HNQZNM@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Sep 2011 17:42:36 +0100 (BST)
Date: Thu, 22 Sep 2011 18:42:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 2/2] s5p-fimc: Convert to use generic media bus polarity
 flags
In-reply-to: <1316709751-29922-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, g.liakhovetski@gmx.de,
	sw0312.kim@samsung.com, riverful.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1316709751-29922-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316709751-29922-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Switch to generic media bus signal polarity flags and allow
configuring the FIELD signal polarity.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c  |   14 +++++++++-----
 drivers/media/video/s5p-fimc/regs-fimc.h |    1 +
 include/media/s5p_fimc.h                 |    7 +------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 2a1ae51..20e664e 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -533,20 +533,24 @@ int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
 	u32 cfg = readl(fimc->regs + S5P_CIGCTRL);
 
 	cfg &= ~(S5P_CIGCTRL_INVPOLPCLK | S5P_CIGCTRL_INVPOLVSYNC |
-		 S5P_CIGCTRL_INVPOLHREF | S5P_CIGCTRL_INVPOLHSYNC);
+		 S5P_CIGCTRL_INVPOLHREF | S5P_CIGCTRL_INVPOLHSYNC |
+		 S5P_CIGCTRL_INVPOLFIELD);
 
-	if (cam->flags & FIMC_CLK_INV_PCLK)
+	if (cam->flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cfg |= S5P_CIGCTRL_INVPOLPCLK;
 
-	if (cam->flags & FIMC_CLK_INV_VSYNC)
+	if (cam->flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
 		cfg |= S5P_CIGCTRL_INVPOLVSYNC;
 
-	if (cam->flags & FIMC_CLK_INV_HREF)
+	if (cam->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		cfg |= S5P_CIGCTRL_INVPOLHREF;
 
-	if (cam->flags & FIMC_CLK_INV_HSYNC)
+	if (cam->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		cfg |= S5P_CIGCTRL_INVPOLHSYNC;
 
+	if (cam->flags & V4L2_MBUS_FIELD_EVEN_LOW)
+		cfg |= S5P_CIGCTRL_INVPOLFIELD;
+
 	writel(cfg, fimc->regs + S5P_CIGCTRL);
 
 	return 0;
diff --git a/drivers/media/video/s5p-fimc/regs-fimc.h b/drivers/media/video/s5p-fimc/regs-fimc.h
index 94d2302..c8e3b94 100644
--- a/drivers/media/video/s5p-fimc/regs-fimc.h
+++ b/drivers/media/video/s5p-fimc/regs-fimc.h
@@ -61,6 +61,7 @@
 #define S5P_CIGCTRL_CSC_ITU601_709	(1 << 5)
 #define S5P_CIGCTRL_INVPOLHSYNC		(1 << 4)
 #define S5P_CIGCTRL_SELCAM_MIPI		(1 << 3)
+#define S5P_CIGCTRL_INVPOLFIELD		(1 << 1)
 #define S5P_CIGCTRL_INTERLACE		(1 << 0)
 
 /* Window offset 2 */
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 2b58904..688fb3f 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -19,11 +19,6 @@ enum cam_bus_type {
 	FIMC_LCD_WB, /* FIFO link from LCD mixer */
 };
 
-#define FIMC_CLK_INV_PCLK	(1 << 0)
-#define FIMC_CLK_INV_VSYNC	(1 << 1)
-#define FIMC_CLK_INV_HREF	(1 << 2)
-#define FIMC_CLK_INV_HSYNC	(1 << 3)
-
 struct i2c_board_info;
 
 /**
@@ -37,7 +32,7 @@ struct i2c_board_info;
  * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
  * @clk_id: index of the SoC peripheral clock for sensors
- * @flags: flags defining bus signals polarity inversion (High by default)
+ * @flags: the parallel bus flags defining signals polarity (V4L2_MBUS_*)
  */
 struct s5p_fimc_isp_info {
 	struct i2c_board_info *board_info;
-- 
1.7.6.3

