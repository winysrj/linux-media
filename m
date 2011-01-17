Return-path: <mchehab@pedra>
Received: from comal.ext.ti.com ([198.47.26.152]:51669 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222Ab1AQOPN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jan 2011 09:15:13 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	LAK <linux-arm-kernel@lists.arm.linux.org.uk>,
	Kevin Hilman <khilman@deeprootsystems.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v15 2/3] davinci vpbe: board specific additions
Date: Mon, 17 Jan 2011 19:44:52 +0530
Message-Id: <1295273692-15107-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch implements tables for display timings,outputs and
other board related functionalities.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 arch/arm/mach-davinci/board-dm644x-evm.c |   84 ++++++++++++++++++++++++-----
 1 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 0ca90b8..95ea13d 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -176,18 +176,6 @@ static struct platform_device davinci_evm_nandflash_device = {
 	.resource	= davinci_evm_nandflash_resource,
 };
 
-static u64 davinci_fb_dma_mask = DMA_BIT_MASK(32);
-
-static struct platform_device davinci_fb_device = {
-	.name		= "davincifb",
-	.id		= -1,
-	.dev = {
-		.dma_mask		= &davinci_fb_dma_mask,
-		.coherent_dma_mask      = DMA_BIT_MASK(32),
-	},
-	.num_resources = 0,
-};
-
 static struct tvp514x_platform_data tvp5146_pdata = {
 	.clk_polarity = 0,
 	.hs_polarity = 1,
@@ -337,7 +325,6 @@ static struct pcf857x_platform_data pcf_data_u2 = {
 	.teardown	= evm_led_teardown,
 };
 
-
 /* U18 - A/V clock generator and user switch */
 
 static int sw_gpio;
@@ -404,7 +391,6 @@ static struct pcf857x_platform_data pcf_data_u18 = {
 	.teardown	= evm_u18_teardown,
 };
 
-
 /* U35 - various I/O signals used to manage USB, CF, ATA, etc */
 
 static int
@@ -616,8 +602,73 @@ static void __init evm_init_i2c(void)
 	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
 }
 
+#define VENC_STD_ALL    (V4L2_STD_NTSC | V4L2_STD_PAL)
+
+/* venc standards timings */
+static struct vpbe_enc_mode_info vbpe_enc_std_timings[] = {
+	{"ntsc", VPBE_ENC_STD, {V4L2_STD_525_60}, 1, 720, 480,
+	{11, 10}, {30000, 1001}, 0x79, 0, 0x10, 0, 0, 0, 0},
+	{"pal", VPBE_ENC_STD, {V4L2_STD_625_50}, 1, 720, 576,
+	{54, 59}, {25, 1}, 0x7E, 0, 0x16, 0, 0, 0, 0},
+};
+
+/* venc dv preset timings */
+static struct vpbe_enc_mode_info vbpe_enc_preset_timings[] = {
+	{"480p59_94", VPBE_ENC_DV_PRESET, {V4L2_DV_480P59_94}, 0, 720, 480,
+	{1, 1}, {5994, 100}, 0x80, 0, 0x20, 0, 0, 0, 0},
+	{"576p50", VPBE_ENC_DV_PRESET, {V4L2_DV_576P50}, 0, 720, 576,
+	{1, 1}, {50, 1}, 0x7E, 0, 0x30, 0, 0, 0, 0},
+};
+
+/*
+ * The outputs available from VPBE + encoders. Keep the order same
+ * as that of encoders. First that from venc followed by that from
+ * encoders. Index in the output refers to index on a particular encoder.
+ * Driver uses this index to pass it to encoder when it supports more than
+ * one output. Application uses index of the array to set an output.
+ */
+static struct vpbe_output dm644x_vpbe_outputs[] = {
+	{
+		.output = {
+			.index = 0,
+			.name = "Composite",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+			.std = VENC_STD_ALL,
+			.capabilities = V4L2_OUT_CAP_STD,
+		},
+		.subdev_name = VPBE_VENC_SUBDEV_NAME,
+		.default_mode = "ntsc",
+		.num_modes = ARRAY_SIZE(vbpe_enc_std_timings),
+		.modes = vbpe_enc_std_timings,
+	},
+	{
+		.output = {
+			.index = 1,
+			.name = "Component",
+			.type = V4L2_OUTPUT_TYPE_ANALOG,
+			.capabilities = V4L2_OUT_CAP_PRESETS,
+		},
+		.subdev_name = VPBE_VENC_SUBDEV_NAME,
+		.default_mode = "480p59_94",
+		.num_modes = ARRAY_SIZE(vbpe_enc_preset_timings),
+		.modes = vbpe_enc_preset_timings,
+	},
+};
+
+static struct vpbe_display_config vpbe_display_cfg = {
+	.module_name = "dm644x-vpbe-display",
+	.i2c_adapter_id = 1,
+	.osd = {
+		.module_name = VPBE_OSD_SUBDEV_NAME,
+	},
+	.venc = {
+		.module_name = VPBE_VENC_SUBDEV_NAME,
+	},
+	.num_outputs = ARRAY_SIZE(dm644x_vpbe_outputs),
+	.outputs = dm644x_vpbe_outputs,
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata = {
-	&davinci_fb_device,
 	&rtc_dev,
 };
 
@@ -630,6 +681,9 @@ davinci_evm_map_io(void)
 {
 	/* setup input configuration for VPFE input devices */
 	dm644x_set_vpfe_config(&vpfe_cfg);
+
+	/* setup configuration for vpbe devices */
+	dm644x_set_vpbe_display_config(&vpbe_display_cfg);
 	dm644x_init();
 }
 
-- 
1.6.2.4

