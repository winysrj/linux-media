Return-path: <mchehab@pedra>
Received: from bear.ext.ti.com ([192.94.94.41]:48385 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757867Ab1COOAJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 10:00:09 -0400
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	LAK <linux-arm-kernel@lists.infradead.org>,
	Sekhar Nori <nsekhar@ti.com>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH v17 13/13] davinci: dm644x EVM: add support for VPBE display
Date: Tue, 15 Mar 2011 19:29:55 +0530
Message-Id: <1300197595-5188-1-git-send-email-manjunath.hadli@ti.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for V4L2 video display to DM6446 EVM.
Support for SD and ED modes is provided, along with Composite
and Component outputs.

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 arch/arm/mach-davinci/board-dm644x-evm.c    |  108 ++++++++++++++++++++++++++-
 arch/arm/mach-davinci/dm644x.c              |    4 +-
 arch/arm/mach-davinci/include/mach/dm644x.h |    3 +-
 3 files changed, 112 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index d1542b1..4a642dd 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -616,6 +616,112 @@ static void __init evm_init_i2c(void)
 	i2c_register_board_info(1, i2c_info, ARRAY_SIZE(i2c_info));
 }
 
+#define VENC_STD_ALL	(V4L2_STD_NTSC | V4L2_STD_PAL)
+
+/* venc standard timings */
+static struct vpbe_enc_mode_info dm644xevm_enc_std_timing[] = {
+	{
+		.name		= "ntsc",
+		.timings_type	= VPBE_ENC_STD,
+		.timings	= {V4L2_STD_525_60},
+		.interlaced	= 1,
+		.xres		= 720,
+		.yres		= 480,
+		.aspect		= {11, 10},
+		.fps		= {30000, 1001},
+		.left_margin	= 0x79,
+		.upper_margin	= 0x10,
+	},
+	{
+		.name		= "pal",
+		.timings_type	= VPBE_ENC_STD,
+		.timings	= {V4L2_STD_625_50},
+		.interlaced	= 1,
+		.xres		= 720,
+		.yres		= 576,
+		.aspect		= {54, 59},
+		.fps		= {25, 1},
+		.left_margin	= 0x7E,
+		.upper_margin	= 0x16,
+	},
+};
+
+/* venc dv preset timings */
+static struct vpbe_enc_mode_info dm644xevm_enc_preset_timing[] = {
+	{
+		.name		= "480p59_94",
+		.timings_type	= VPBE_ENC_DV_PRESET,
+		.timings	= {V4L2_DV_480P59_94},
+		.interlaced	= 0,
+		.xres		= 720,
+		.yres		= 480,
+		.aspect		= {1, 1},
+		.fps		= {5994, 100},
+		.left_margin	= 0x80,
+		.upper_margin	= 0x20,
+	},
+	{
+		.name		= "576p50",
+		.timings_type	= VPBE_ENC_DV_PRESET,
+		.timings	= {V4L2_DV_576P50},
+		.interlaced	= 0,
+		.xres		= 720,
+		.yres		= 576,
+		.aspect		= {1, 1},
+		.fps		= {50, 1},
+		.left_margin	= 0x7E,
+		.upper_margin	= 0x30,
+	},
+};
+
+/*
+ * The outputs available from VPBE + encoders. Keep the order same
+ * as that of encoders. First those from venc followed by that from
+ * encoders. Index in the output refers to index on a particular encoder.
+ * Driver uses this index to pass it to encoder when it supports more than
+ * one output. Application uses index of the array to set an output.
+ */
+static struct vpbe_output dm644xevm_vpbe_outputs[] = {
+	{
+		.output		= {
+			.index		= 0,
+			.name		= "Composite",
+			.type		= V4L2_OUTPUT_TYPE_ANALOG,
+			.std		= VENC_STD_ALL,
+			.capabilities	= V4L2_OUT_CAP_STD,
+		},
+		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
+		.default_mode	= "ntsc",
+		.num_modes	= ARRAY_SIZE(dm644xevm_enc_std_timing),
+		.modes		= dm644xevm_enc_std_timing,
+	},
+	{
+		.output		= {
+			.index		= 1,
+			.name		= "Component",
+			.type		= V4L2_OUTPUT_TYPE_ANALOG,
+			.capabilities	= V4L2_OUT_CAP_PRESETS,
+		},
+		.subdev_name	= VPBE_VENC_SUBDEV_NAME,
+		.default_mode	= "480p59_94",
+		.num_modes	= ARRAY_SIZE(dm644xevm_enc_preset_timing),
+		.modes		= dm644xevm_enc_preset_timing,
+	},
+};
+
+static struct vpbe_config dm644xevm_display_cfg = {
+	.module_name	= "dm644x-vpbe-display",
+	.i2c_adapter_id	= 1,
+	.osd		= {
+		.module_name	= VPBE_OSD_SUBDEV_NAME,
+	},
+	.venc		= {
+		.module_name	= VPBE_VENC_SUBDEV_NAME,
+	},
+	.num_outputs	= ARRAY_SIZE(dm644xevm_vpbe_outputs),
+	.outputs	= dm644xevm_vpbe_outputs,
+};
+
 static struct platform_device *davinci_evm_devices[] __initdata = {
 	&davinci_fb_device,
 	&rtc_dev,
@@ -699,7 +805,7 @@ static __init void davinci_evm_init(void)
 	evm_init_i2c();
 
 	davinci_setup_mmc(0, &dm6446evm_mmc_config);
-	dm644x_init_video(&dm644xevm_capture_cfg);
+	dm644x_init_video(&dm644xevm_capture_cfg, &dm644xevm_display_cfg);
 
 	davinci_serial_init(&uart_config);
 	dm644x_init_asp(&dm644x_evm_snd_data);
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index aaa8f4d..2d37163 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -909,9 +909,11 @@ static struct platform_device *dm644x_video_devices[] __initdata = {
 	&dm644x_vpbe_display,
 };
 
-int __init dm644x_init_video(struct vpfe_config *vpfe_cfg)
+int __init dm644x_init_video(struct vpfe_config *vpfe_cfg,
+			     struct vpbe_config *vpbe_cfg)
 {
 	dm644x_vpfe_dev.dev.platform_data = vpfe_cfg;
+	dm644x_vpbe_dev.dev.platform_data = vpbe_cfg;
 	/* Add ccdc clock aliases */
 	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
 	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
diff --git a/arch/arm/mach-davinci/include/mach/dm644x.h b/arch/arm/mach-davinci/include/mach/dm644x.h
index d18a2e5..6c90afa 100644
--- a/arch/arm/mach-davinci/include/mach/dm644x.h
+++ b/arch/arm/mach-davinci/include/mach/dm644x.h
@@ -46,6 +46,7 @@
 
 void __init dm644x_init(void);
 void __init dm644x_init_asp(struct snd_platform_data *pdata);
-int __init dm644x_init_video(struct vpfe_config *);
+int __init dm644x_init_video(struct vpfe_config *,
+			     struct vpbe_config *);
 
 #endif /* __ASM_ARCH_DM644X_H */
-- 
1.6.2.4

