Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:58644 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1IPR2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Sep 2011 13:28:49 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LRM0001BLVZDO@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:28:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRM00K9PLVYAI@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 16 Sep 2011 18:28:47 +0100 (BST)
Date: Fri, 16 Sep 2011 19:28:43 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/2] s5p-fimc: Convert to use generic bus polarity flags
In-reply-to: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	g.liakhovetski@gmx.de, sw0312.kim@samsung.com,
	riverful.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1316194123-21185-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1316194123-21185-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-reg.c |    8 ++++----
 include/media/s5p_fimc.h                |    7 +------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-reg.c b/drivers/media/video/s5p-fimc/fimc-reg.c
index 2a1ae51..5543b1b 100644
--- a/drivers/media/video/s5p-fimc/fimc-reg.c
+++ b/drivers/media/video/s5p-fimc/fimc-reg.c
@@ -535,16 +535,16 @@ int fimc_hw_set_camera_polarity(struct fimc_dev *fimc,
 	cfg &= ~(S5P_CIGCTRL_INVPOLPCLK | S5P_CIGCTRL_INVPOLVSYNC |
 		 S5P_CIGCTRL_INVPOLHREF | S5P_CIGCTRL_INVPOLHSYNC);
 
-	if (cam->flags & FIMC_CLK_INV_PCLK)
+	if (cam->flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
 		cfg |= S5P_CIGCTRL_INVPOLPCLK;
 
-	if (cam->flags & FIMC_CLK_INV_VSYNC)
+	if (cam->flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
 		cfg |= S5P_CIGCTRL_INVPOLVSYNC;
 
-	if (cam->flags & FIMC_CLK_INV_HREF)
+	if (cam->flags & V4L2_MBUS_HREF_ACTIVE_LOW)
 		cfg |= S5P_CIGCTRL_INVPOLHREF;
 
-	if (cam->flags & FIMC_CLK_INV_HSYNC)
+	if (cam->flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
 		cfg |= S5P_CIGCTRL_INVPOLHSYNC;
 
 	writel(cfg, fimc->regs + S5P_CIGCTRL);
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
1.7.6

