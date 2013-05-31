Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:63616 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289Ab3EaPKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 May 2013 11:10:55 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, arun.kk@samsung.com,
	shaik.ameer@samsung.com
Cc: hj210.choi@samsung.com, kyungmin.park@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC] exynos4-is: Add support for Exynos5250 MIPI-CSIS
Date: Fri, 31 May 2013 17:10:35 +0200
Message-id: <1370013035-18492-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add compatible property for the Exynos5250 and enable the frame start
and frame end interrupts. These interrupts are needed for the Exynos5
FIMC-IS firmware. The driver enables those interrupts only where they
are available, depending on the 'compatible' property. This can be
optimized further, by exposing some API at the subdev driver, so the
host driver can enable extra interrupts only for the image processing
chains involving FIMC-IS.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Shaik/ Arun,

Can you please review/test this patch on an Exynos5 SoC ?
I have only tested it on Exynos4412. It is based on patch
https://linuxtv.org/patch/17125/

Thanks,
Sylwester

 .../bindings/media/samsung-mipi-csis.txt           |    4 +-
 drivers/media/platform/exynos4-is/mipi-csis.c      |   67 ++++++++++++++++----
 2 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt b/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
index 5f8e28e..be45f0b 100644
--- a/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
+++ b/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt
@@ -5,8 +5,8 @@ Required properties:

 - compatible	  : "samsung,s5pv210-csis" for S5PV210 (S5PC110),
 		    "samsung,exynos4210-csis" for Exynos4210 (S5PC210),
-		    "samsung,exynos4212-csis" for Exynos4212/Exynos4412
-		    SoC series;
+		    "samsung,exynos4212-csis" for Exynos4212/Exynos4412,
+		    "samsung,exynos5250-csis" for Exynos5250;
 - reg		  : offset and length of the register set for the device;
 - interrupts      : should contain MIPI CSIS interrupt; the format of the
 		    interrupt specifier depends on the interrupt controller;
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index ae99803..69a3d26 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -1,8 +1,8 @@
 /*
- * Samsung S5P/EXYNOS4 SoC series MIPI-CSI receiver driver
+ * Samsung S5P/EXYNOS SoC series MIPI-CSI receiver driver
  *
- * Copyright (C) 2011 - 2012 Samsung Electronics Co., Ltd.
- * Sylwester Nawrocki <s.nawrocki@samsung.com>
+ * Copyright (C) 2011 - 2013 Samsung Electronics Co., Ltd.
+ * Author: Sylwester Nawrocki <s.nawrocki@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -66,11 +66,12 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");

 /* Interrupt mask */
 #define S5PCSIS_INTMSK			0x10
-#define S5PCSIS_INTMSK_EN_ALL		0xf000103f
 #define S5PCSIS_INTMSK_EVEN_BEFORE	(1 << 31)
 #define S5PCSIS_INTMSK_EVEN_AFTER	(1 << 30)
 #define S5PCSIS_INTMSK_ODD_BEFORE	(1 << 29)
 #define S5PCSIS_INTMSK_ODD_AFTER	(1 << 28)
+#define S5PCSIS_INTMSK_FRAME_END	(1 << 27)
+#define S5PCSIS_INTMSK_FRAME_START	(1 << 26)
 #define S5PCSIS_INTMSK_ERR_SOT_HS	(1 << 12)
 #define S5PCSIS_INTMSK_ERR_LOST_FS	(1 << 5)
 #define S5PCSIS_INTMSK_ERR_LOST_FE	(1 << 4)
@@ -78,6 +79,8 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 #define S5PCSIS_INTMSK_ERR_ECC		(1 << 2)
 #define S5PCSIS_INTMSK_ERR_CRC		(1 << 1)
 #define S5PCSIS_INTMSK_ERR_UNKNOWN	(1 << 0)
+#define S5PCSIS_INTMSK_EXYNOS4_EN_ALL	0xf000103f
+#define S5PCSIS_INTMSK_EXYNOS5_EN_ALL	0xfc00103f

 /* Interrupt source */
 #define S5PCSIS_INTSRC			0x14
@@ -88,6 +91,8 @@ MODULE_PARM_DESC(debug, "Debug level (0-2)");
 #define S5PCSIS_INTSRC_ODD_AFTER	(1 << 28)
 #define S5PCSIS_INTSRC_ODD		(0x3 << 28)
 #define S5PCSIS_INTSRC_NON_IMAGE_DATA	(0xff << 28)
+#define S5PCSIS_INTSRC_FRAME_END	(1 << 27)
+#define S5PCSIS_INTSRC_FRAME_START	(1 << 26)
 #define S5PCSIS_INTSRC_ERR_SOT_HS	(0xf << 12)
 #define S5PCSIS_INTSRC_ERR_LOST_FS	(1 << 5)
 #define S5PCSIS_INTSRC_ERR_LOST_FE	(1 << 4)
@@ -155,6 +160,9 @@ static const struct s5pcsis_event s5pcsis_events[] = {
 	{ S5PCSIS_INTSRC_EVEN_AFTER,	"Non-image data after even frame" },
 	{ S5PCSIS_INTSRC_ODD_BEFORE,	"Non-image data before odd frame" },
 	{ S5PCSIS_INTSRC_ODD_AFTER,	"Non-image data after odd frame" },
+	/* Frame start/end */
+	{ S5PCSIS_INTSRC_FRAME_START,	"Frame Start" },
+	{ S5PCSIS_INTSRC_FRAME_END,	"Frame End" },
 };
 #define S5PCSIS_NUM_EVENTS ARRAY_SIZE(s5pcsis_events)

@@ -163,6 +171,11 @@ struct csis_pktbuf {
 	unsigned int len;
 };

+struct csis_drvdata {
+	/* Mask of all used interrupts in S5PCSIS_INTMSK register */
+	u32 interrupt_mask;
+};
+
 /**
  * struct csis_state - the driver's internal state data structure
  * @lock: mutex serializing the subdev and power management operations,
@@ -175,6 +188,7 @@ struct csis_pktbuf {
  * @supplies: CSIS regulator supplies
  * @clock: CSIS clocks
  * @irq: requested s5p-mipi-csis irq number
+ * @interrupt_mask: interrupt mask of the all used interrupts
  * @flags: the state variable for power and streaming control
  * @clock_frequency: device bus clock frequency
  * @hs_settle: HS-RX settle time
@@ -197,6 +211,7 @@ struct csis_state {
 	struct regulator_bulk_data supplies[CSIS_NUM_SUPPLIES];
 	struct clk *clock[NUM_CSIS_CLOCKS];
 	int irq;
+	u32 interrupt_mask;
 	u32 flags;

 	u32 clk_frequency;
@@ -278,9 +293,10 @@ static const struct csis_pix_format *find_csis_format(
 static void s5pcsis_enable_interrupts(struct csis_state *state, bool on)
 {
 	u32 val = s5pcsis_read(state, S5PCSIS_INTMSK);
-
-	val = on ? val | S5PCSIS_INTMSK_EN_ALL :
-		   val & ~S5PCSIS_INTMSK_EN_ALL;
+	if (on)
+		val |= state->interrupt_mask;
+	else
+		val &= ~state->interrupt_mask;
 	s5pcsis_write(state, S5PCSIS_INTMSK, val);
 }

@@ -803,8 +819,12 @@ static int s5pcsis_parse_dt(struct platform_device *pdev,
 #define s5pcsis_parse_dt(pdev, state) (-ENOSYS)
 #endif

+static const struct of_device_id s5pcsis_of_match[];
+
 static int s5pcsis_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *of_id;
+	const struct csis_drvdata *drv_data;
 	struct device *dev = &pdev->dev;
 	struct resource *mem_res;
 	struct csis_state *state;
@@ -819,10 +839,19 @@ static int s5pcsis_probe(struct platform_device *pdev)
 	spin_lock_init(&state->slock);
 	state->pdev = pdev;

-	if (dev->of_node)
+	if (dev->of_node) {
+		of_id = of_match_node(s5pcsis_of_match, dev->of_node);
+		if (WARN_ON(of_id == NULL))
+			return -EINVAL;
+
+		drv_data = of_id->data;
+		state->interrupt_mask = drv_data->interrupt_mask;
+
 		ret = s5pcsis_parse_dt(pdev, state);
-	else
+	} else {
 		ret = s5pcsis_get_platform_data(pdev, state);
+	}
+
 	if (ret < 0)
 		return ret;

@@ -1018,9 +1047,25 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(s5pcsis_suspend, s5pcsis_resume)
 };

+static const struct csis_drvdata exynos4_csis_drvdata = {
+	.interrupt_mask = S5PCSIS_INTMSK_EXYNOS4_EN_ALL,
+};
+
+static const struct csis_drvdata exynos5_csis_drvdata = {
+	.interrupt_mask = S5PCSIS_INTMSK_EXYNOS5_EN_ALL,
+};
+
 static const struct of_device_id s5pcsis_of_match[] = {
-	{ .compatible = "samsung,s5pv210-csis" },
-	{ .compatible = "samsung,exynos4210-csis" },
+	{
+		.compatible = "samsung,s5pv210-csis",
+		.data = &exynos4_csis_drvdata,
+	}, {
+		.compatible = "samsung,exynos4210-csis",
+		.data = &exynos4_csis_drvdata,
+	}, {
+		.compatible = "samsung,exynos5250-csis",
+		.data = &exynos5_csis_drvdata,
+	},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, s5pcsis_of_match);
--
1.7.9.5

