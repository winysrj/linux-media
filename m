Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:52792 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbZJOOnp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Oct 2009 10:43:45 -0400
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Thu, 15 Oct 2009 08:43:14 -0600
Message-Id: <1255617794-1401-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 2/6 v5] Support for TVP7002 in dm365 board
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides support for TVP7002 in architecture definitions
within DM365.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 arch/arm/mach-davinci/board-dm365-evm.c |  170 ++++++++++++++++++++++++++++++-
 1 files changed, 166 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index a1d5e7d..6c544d3 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -38,6 +38,11 @@
 #include <mach/common.h>
 #include <mach/mmc.h>
 #include <mach/nand.h>
+#include <mach/gpio.h>
+#include <linux/videodev2.h>
+#include <media/tvp514x.h>
+#include <media/tvp7002.h>
+#include <media/davinci/videohd.h>
 
 
 static inline int have_imager(void)
@@ -48,8 +53,11 @@ static inline int have_imager(void)
 
 static inline int have_tvp7002(void)
 {
-	/* REVISIT when it's supported, trigger via Kconfig */
+#ifdef CONFIG_VIDEO_TVP7002
+	return 1;
+#else
 	return 0;
+#endif
 }
 
 
@@ -96,8 +104,26 @@ static inline int have_tvp7002(void)
 #define CPLD_CCD_DIR3	CPLD_OFFSET(0x3f,0)
 #define CPLD_CCD_IO3	CPLD_OFFSET(0x3f,1)
 
+#define CPLD_VIDEO_INPUT_MUX_MASK	0x7
+#define CPLD_VIDEO_INPUT_MUX_TVP7002	0x1
+#define CPLD_VIDEO_INPUT_MUX_IMAGER	0x2
+#define CPLD_VIDEO_INPUT_MUX_TVP5146	0x5
+
 static void __iomem *cpld;
 
+static struct tvp514x_platform_data tvp5146_pdata = {
+       .clk_polarity = 0,
+       .hs_polarity = 1,
+       .vs_polarity = 1
+};
+
+/* tvp7002 platform data, used during reset and probe operations */
+static struct tvp7002_config tvp7002_pdata = {
+       .clk_polarity = 0,
+       .hs_polarity = 0,
+       .vs_polarity = 0,
+       .fid_polarity = 0,
+};
 
 /* NOTE:  this is geared for the standard config, with a socketed
  * 2 GByte Micron NAND (MT29F16G08FAA) using 128KB sectors.  If you
@@ -207,6 +233,140 @@ static int cpld_mmc_get_ro(int module)
 	return !!(__raw_readb(cpld + CPLD_CARDSTAT) & BIT(module ? 5 : 1));
 }
 
+#define TVP514X_STD_ALL        (V4L2_STD_NTSC | V4L2_STD_PAL)
+/* Inputs available at the TVP5146 */
+static struct v4l2_input tvp5146_inputs[] = {
+	{
+		.index = 0,
+		.name = "Composite",
+		.type = V4L2_INPUT_TYPE_CAMERA,
+		.std = TVP514X_STD_ALL,
+	},
+	{
+		.index = 1,
+		.name = "S-Video",
+		.type = V4L2_INPUT_TYPE_CAMERA,
+		.std = TVP514X_STD_ALL,
+	},
+};
+
+#define TVP7002_STD_ALL        (V4L2_STD_525P_60   | V4L2_STD_625P_50 	|\
+				V4L2_STD_NTSC      | V4L2_STD_PAL   	|\
+				V4L2_STD_720P_50   | V4L2_STD_720P_60 	|\
+				V4L2_STD_1080I_50  | V4L2_STD_1080I_60 	|\
+				V4L2_STD_1080P_50  | V4L2_STD_1080P_60)
+
+/* Inputs available at the TVP7002 */
+static struct v4l2_input tvp7002_inputs[] = {
+	{
+		.index = 0,
+		.name = "Component",
+		.type = V4L2_INPUT_TYPE_CAMERA,
+		.std = TVP7002_STD_ALL,
+	},
+};
+
+/*
+ * this is the route info for connecting each input to decoder
+ * ouput that goes to vpfe. There is a one to one correspondence
+ * with tvp5146_inputs
+ */
+static struct vpfe_route tvp5146_routes[] = {
+	{
+		.input = INPUT_CVBS_VI2B,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+	},
+{
+		.input = INPUT_SVIDEO_VI2C_VI1C,
+		.output = OUTPUT_10BIT_422_EMBEDDED_SYNC,
+	},
+};
+
+static struct vpfe_subdev_info vpfe_sub_devs[] = {
+{
+		.module_name = "tvp5146",
+		.grp_id = VPFE_SUBDEV_TVP5146,
+		.num_inputs = ARRAY_SIZE(tvp5146_inputs),
+		.inputs = tvp5146_inputs,
+		.routes = tvp5146_routes,
+		.can_route = 1,
+		.ccdc_if_params = {
+			.if_type = VPFE_BT656,
+			.hdpol = VPFE_PINPOL_POSITIVE,
+			.vdpol = VPFE_PINPOL_POSITIVE,
+		},
+		.board_info = {
+			I2C_BOARD_INFO("tvp5146", 0x5d),
+			.platform_data = &tvp5146_pdata,
+		},
+	},
+	{
+		.module_name = "tvp7002",
+		.grp_id = VPFE_SUBDEV_TVP7002,
+		.num_inputs = ARRAY_SIZE(tvp7002_inputs),
+		.inputs = tvp7002_inputs,
+		.ccdc_if_params = {
+			.if_type = VPFE_BT1120,
+			.hdpol = VPFE_PINPOL_POSITIVE,
+			.vdpol = VPFE_PINPOL_POSITIVE,
+		},
+		.board_info = {
+			I2C_BOARD_INFO("tvp7002", 0x5c),
+			.platform_data = &tvp7002_pdata,
+		},
+	},
+	{
+		.module_name = "ths7353",
+		.board_info = {
+			I2C_BOARD_INFO("ths7353", 0x2e),
+		},
+	},
+};
+
+/* Set the input mux for TVP7002/TVP5146/MTxxxx sensors */
+static int dm365evm_setup_video_input(enum vpfe_subdev_id id)
+{
+	const char *label;
+	u8 mux, resets;
+
+	mux = __raw_readb(cpld + CPLD_MUX);
+	mux &= ~CPLD_VIDEO_INPUT_MUX_MASK;
+	resets = __raw_readb(cpld + CPLD_RESETS);
+	switch (id) {
+	case VPFE_SUBDEV_TVP5146:
+		mux |= CPLD_VIDEO_INPUT_MUX_TVP5146;
+		resets &= ~BIT(0);
+		label = "tvp5146 SD";
+		break;
+	case VPFE_SUBDEV_MT9T031:
+		mux |= CPLD_VIDEO_INPUT_MUX_IMAGER;
+		resets |= BIT(0); /* Put TVP5146 in reset */
+		label = "HD imager";
+		break;
+	case VPFE_SUBDEV_TVP7002:
+		resets &= ~BIT(2);
+		mux |= CPLD_VIDEO_INPUT_MUX_TVP7002;
+		label = "tvp7002 HD";
+		break;
+	default:
+		return 0;
+	}
+	__raw_writeb(mux, cpld + CPLD_MUX);
+	__raw_writeb(resets, cpld + CPLD_RESETS);
+	pr_info("EVM: switch to %s video input\n", label);
+	return 0;
+}
+
+static struct vpfe_config vpfe_cfg = {
+       .setup_input = dm365evm_setup_video_input,
+       .num_subdevs = ARRAY_SIZE(vpfe_sub_devs),
+       .sub_devs = vpfe_sub_devs,
+       .card_name = "DM365 EVM",
+       .ccdc = "DM365 ISIF",
+       .num_clocks = 1,
+       .clocks = {"vpss_master"},
+};
+
 static struct davinci_mmc_config dm365evm_mmc_config = {
 	.get_cd		= cpld_mmc_get_cd,
 	.get_ro		= cpld_mmc_get_ro,
@@ -414,7 +574,7 @@ fail:
 	 */
 	if (have_imager()) {
 		label = "HD imager";
-		mux |= 1;
+		mux |= CPLD_VIDEO_INPUT_MUX_IMAGER;
 
 		/* externally mux MMC1/ENET/AIC33 to imager */
 		mux |= BIT(6) | BIT(5) | BIT(3);
@@ -435,12 +595,12 @@ fail:
 		resets &= ~BIT(1);
 
 		if (have_tvp7002()) {
-			mux |= 2;
+			mux |= CPLD_VIDEO_INPUT_MUX_TVP7002;
 			resets &= ~BIT(2);
 			label = "tvp7002 HD";
 		} else {
 			/* default to tvp5146 */
-			mux |= 5;
+			mux |= CPLD_VIDEO_INPUT_MUX_TVP5146;
 			resets &= ~BIT(0);
 			label = "tvp5146 SD";
 		}
@@ -458,6 +618,8 @@ static struct davinci_uart_config uart_config __initdata = {
 
 static void __init dm365_evm_map_io(void)
 {
+	/* setup input configuration for VPFE input devices */
+	dm365_set_vpfe_config(&vpfe_cfg);
 	dm365_init();
 }
 
-- 
1.6.0.4

