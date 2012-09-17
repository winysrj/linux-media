Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:42525 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab2IQKys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 06:54:48 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 5/7] s5p-fimc: Remove unused platform data structure fields
Date: Mon, 17 Sep 2012 12:54:31 +0200
Message-id: <1347879273-30463-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1347879273-30463-1-git-send-email-s.nawrocki@samsung.com>
References: <1347878888-30001-1-git-send-email-s.nawrocki@samsung.com>
 <1347879273-30463-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

alignment, fixed_phy_vdd and phy_enable fields are now unused
so removed them. The data alignment is now derived directly
from media bus pixel code, phy_enable callback has been replaced
with direct function call and fixed_phy_vdd was dropped in commit
438df3ebe5f0ce408490a777a758d5905f0dd58f
"[media] s5p-csis: Handle all available power supplies".

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/platform_data/mipi-csis.h | 15 ++++-----------
 include/media/s5p_fimc.h                |  2 --
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/include/linux/platform_data/mipi-csis.h b/include/linux/platform_data/mipi-csis.h
index 2e59e43..8b703e1 100644
--- a/include/linux/platform_data/mipi-csis.h
+++ b/include/linux/platform_data/mipi-csis.h
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2010-2011 Samsung Electronics Co., Ltd.
  *
- * S5P series MIPI CSI slave device support
+ * Samsung S5P/Exynos SoC series MIPI CSIS device support
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -13,21 +13,14 @@
 
 /**
  * struct s5p_platform_mipi_csis - platform data for S5P MIPI-CSIS driver
- * @clk_rate: bus clock frequency
- * @lanes: number of data lanes used
- * @alignment: data alignment in bits
- * @hs_settle: HS-RX settle time
- * @fixed_phy_vdd: false to enable external D-PHY regulator management in the
- *		   driver or true in case this regulator has no enable function
- * @phy_enable: pointer to a callback controlling D-PHY enable/reset
+ * @clk_rate:    bus clock frequency
+ * @lanes:       number of data lanes used
+ * @hs_settle:   HS-RX settle time
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
index 09421a61..eaea62a 100644
--- a/include/media/s5p_fimc.h
+++ b/include/media/s5p_fimc.h
@@ -30,7 +30,6 @@ struct i2c_board_info;
  * @board_info: pointer to I2C subdevice's board info
  * @clk_frequency: frequency of the clock the host interface provides to sensor
  * @bus_type: determines bus type, MIPI, ITU-R BT.601 etc.
- * @csi_data_align: MIPI-CSI interface data alignment in bits
  * @i2c_bus_num: i2c control bus id the sensor is attached to
  * @mux_id: FIMC camera interface multiplexer index (separate for MIPI and ITU)
  * @clk_id: index of the SoC peripheral clock for sensors
@@ -40,7 +39,6 @@ struct s5p_fimc_isp_info {
 	struct i2c_board_info *board_info;
 	unsigned long clk_frequency;
 	enum cam_bus_type bus_type;
-	u16 csi_data_align;
 	u16 i2c_bus_num;
 	u16 mux_id;
 	u16 flags;
-- 
1.7.11.3

