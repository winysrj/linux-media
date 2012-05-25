Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758496Ab2EYTxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:08 -0400
Date: Fri, 25 May 2012 21:52:42 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 03/13] ARM: Samsung: Remove unused fields from FIMC and
 CSIS platform data
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-3-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The MIPI-CSI2 bus data alignment is now being derived from the media
bus pixel code, the drivers don't use the corresponding structure
fields, so remove them. Also remove the s5p_csis_phy_enable callback
which is now used directly by s5p-csis driver.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/mach-nuri.c               |    3 ---
 arch/arm/mach-exynos/mach-universal_c210.c     |    3 ---
 arch/arm/plat-samsung/include/plat/mipi_csis.h |   13 +++----------
 include/media/s5p_fimc.h                       |    2 --
 4 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index c9ca54a..1cd4ded 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -1148,9 +1148,7 @@ static struct platform_device cam_8m_12v_fixed_rdev = {
 static struct s5p_platform_mipi_csis mipi_csis_platdata = {
 	.clk_rate	= 166000000UL,
 	.lanes		= 2,
-	.alignment	= 32,
 	.hs_settle	= 12,
-	.phy_enable	= s5p_csis_phy_enable,
 };
 
 #define GPIO_CAM_MEGA_RST	EXYNOS4_GPY3(7) /* ISP_RESET */
@@ -1194,7 +1192,6 @@ static struct s5p_fimc_isp_info nuri_camera_sensors[] = {
 		.bus_type	= FIMC_MIPI_CSI2,
 		.board_info	= &m5mols_board_info,
 		.clk_frequency	= 24000000UL,
-		.csi_data_align	= 32,
 	},
 };
 
diff --git a/arch/arm/mach-exynos/mach-universal_c210.c b/arch/arm/mach-exynos/mach-universal_c210.c
index 7ebf79c..c2cba7a 100644
--- a/arch/arm/mach-exynos/mach-universal_c210.c
+++ b/arch/arm/mach-exynos/mach-universal_c210.c
@@ -908,9 +908,7 @@ static struct platform_device cam_s_if_fixed_reg_dev = {
 static struct s5p_platform_mipi_csis mipi_csis_platdata = {
 	.clk_rate	= 166000000UL,
 	.lanes		= 2,
-	.alignment	= 32,
 	.hs_settle	= 12,
-	.phy_enable	= s5p_csis_phy_enable,
 };
 
 #define GPIO_CAM_LEVEL_EN(n)	EXYNOS4_GPE4(n + 3)
@@ -974,7 +972,6 @@ static struct s5p_fimc_isp_info universal_camera_sensors[] = {
 		.board_info	= &m5mols_board_info,
 		.i2c_bus_num	= 0,
 		.clk_frequency	= 24000000UL,
-		.csi_data_align	= 32,
 	},
 };
 
diff --git a/arch/arm/plat-samsung/include/plat/mipi_csis.h b/arch/arm/plat-samsung/include/plat/mipi_csis.h
index 609cf1e..c35bf7a 100644
--- a/arch/arm/plat-samsung/include/plat/mipi_csis.h
+++ b/arch/arm/plat-samsung/include/plat/mipi_csis.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
+ * Copyright (C) 2010 - 2012 Samsung Electronics Co., Ltd.
  *
  * S5P series MIPI CSI slave device support
  *
@@ -15,21 +15,14 @@ struct platform_device;
 
 /**
  * struct s5p_platform_mipi_csis - platform data for S5P MIPI-CSIS driver
- * @clk_rate: bus clock frequency
- * @lanes: number of data lanes used
- * @alignment: data alignment in bits
+ * @clk_rate:  bus clock frequency
+ * @lanes:     number of data lanes used
  * @hs_settle: HS-RX settle time
- * @fixed_phy_vdd: false to enable external D-PHY regulator management in the
- *		   driver or true in case this regulator has no enable function
- * @phy_enable: pointer to a callback controlling D-PHY enable/reset
  */
 struct s5p_platform_mipi_csis {
 	unsigned long clk_rate;
 	u8 lanes;
-	u8 alignment;
 	u8 hs_settle;
-	bool fixed_phy_vdd;
-	int (*phy_enable)(struct platform_device *pdev, bool on);
 };
 
 /**
diff --git a/include/media/s5p_fimc.h b/include/media/s5p_fimc.h
index 8587aaf..7be6f81 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -28,7 +28,6 @@ struct i2c_board_info;
  * @board_info: pointer to I2C subdevice's board info
  * @clk_frequency: frequency of the clock the host interface provides to sensor
  * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
- * @csi_data_align: MIPI-CSI interface data alignment in bits
  * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
  * @clk_id: index of the SoC peripheral clock for sensors
@@ -38,7 +37,6 @@ struct s5p_fimc_isp_info {
 	struct i2c_board_info *board_info;
 	unsigned long clk_frequency;
 	enum cam_bus_type bus_type;
-	u16 csi_data_align;
 	u16 i2c_bus_num;
 	u16 mux_id;
 	u16 flags;
-- 
1.7.10

