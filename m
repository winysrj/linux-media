Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:35838 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968826AbeE3JJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 05:09:52 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH 5/8] media: uniphier: add LD11/LD20 HSC support
Date: Wed, 30 May 2018 18:09:43 +0900
Message-Id: <20180530090946.1635-6-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds definition of registers specs to support of HSC
MPEG2-TS I/O driver for UniPhier LD11/LD20 SoCs.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
---
 drivers/media/platform/uniphier/Kconfig    |   8 +
 drivers/media/platform/uniphier/Makefile   |   1 +
 drivers/media/platform/uniphier/hsc-ld11.c | 219 +++++++++++++++++++++
 3 files changed, 228 insertions(+)
 create mode 100644 drivers/media/platform/uniphier/hsc-ld11.c

diff --git a/drivers/media/platform/uniphier/Kconfig b/drivers/media/platform/uniphier/Kconfig
index 1b4543ec1e3c..8f3a662a391c 100644
--- a/drivers/media/platform/uniphier/Kconfig
+++ b/drivers/media/platform/uniphier/Kconfig
@@ -7,3 +7,11 @@ config DVB_UNIPHIER
 	  Driver for UniPhier frontend for MPEG2-TS input/output,
 	  demux and descramble.
 	  Say Y when you want to support this frontend.
+
+config DVB_UNIPHIER_LD11
+	bool "Support UniPhier LD11/LD20 HSC Device Driver"
+	depends on DVB_UNIPHIER
+	help
+	  Driver for the HSC (High speed Stream Controller) for
+	  UniPhier LD11/LD20.
+	  Say Y when you want to support this hardware.
diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
index 88bc860b391f..0622f04d9e68 100644
--- a/drivers/media/platform/uniphier/Makefile
+++ b/drivers/media/platform/uniphier/Makefile
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 uniphier-dvb-y += hsc-core.o hsc-ucode.o hsc-css.o hsc-ts.o hsc-dma.o
+uniphier-dvb-$(CONFIG_DVB_UNIPHIER_LD11) += hsc-ld11.o
 
 obj-$(CONFIG_DVB_UNIPHIER) += uniphier-dvb.o
diff --git a/drivers/media/platform/uniphier/hsc-ld11.c b/drivers/media/platform/uniphier/hsc-ld11.c
new file mode 100644
index 000000000000..df3cc85ac525
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-ld11.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0
+//
+// Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+// For UniPhier LD11/LD20.
+//
+// Copyright (c) 2018 Socionext Inc.
+
+#include "hsc.h"
+#include "hsc-reg.h"
+
+static const struct hsc_spec_init_ram uniphier_hsc_ld11_init_rams[] = {
+	{ FLT_PATN_RAM_TOP_ADDR, FLT_PATN_RAM_SIZE, ~0, },
+	{ FLT_MASK_RAM_TOP_ADDR, FLT_MASK_RAM_SIZE, 0, },
+	/* FLT_PID Pattern */
+	{ SHARE_MEMORY_0_NORMAL, FLT_PIDPATTERN_SIZE, ~0, },
+	/* FLT_PID Table */
+	{ SHARE_MEMORY_0_NORMAL + FLT_PIDPATTERN_SIZE,
+	  SHARE_MEMORY_0_SIZE - FLT_PIDPATTERN_SIZE, 0, },
+	{ SHARE_MEMORY_1_NORMAL, SHARE_MEMORY_1_SIZE, 0, },
+	{ SHARE_MEMORY_2_NORMAL, SHARE_MEMORY_2_SIZE, 0, },
+	{ SHARE_MEMORY_3_NORMAL, SHARE_MEMORY_3_SIZE, 0, },
+	{ SHARE_MEMORY_4_NORMAL, SHARE_MEMORY_4_SIZE, 0, },
+	{ SHARE_MEMORY_5_NORMAL, SHARE_MEMORY_5_SIZE, 0, },
+};
+
+static const struct hsc_spec_init_ram uniphier_hsc_ld20_init_rams[] = {
+	{ FLT_PATN_RAM_TOP_ADDR, FLT_PATN_RAM_SIZE, ~0, },
+	{ FLT_MASK_RAM_TOP_ADDR, FLT_MASK_RAM_SIZE, 0, },
+	/* FLT_PID Pattern */
+	{ SHARE_MEMORY_0_NORMAL, FLT_PIDPATTERN_SIZE, ~0, },
+	/* FLT_PID Table */
+	{ SHARE_MEMORY_0_NORMAL + FLT_PIDPATTERN_SIZE,
+	  SHARE_MEMORY_0_SIZE - FLT_PIDPATTERN_SIZE, 0, },
+	{ SHARE_MEMORY_1_NORMAL, SHARE_MEMORY_1_SIZE, 0, },
+	{ SHARE_MEMORY_2_NORMAL, SHARE_MEMORY_2_SIZE, 0, },
+	{ SHARE_MEMORY_3_NORMAL, SHARE_MEMORY_3_SIZE, 0, },
+	{ SHARE_MEMORY_4_NORMAL, SHARE_MEMORY_4_SIZE, 0, },
+	{ SHARE_MEMORY_5_NORMAL, SHARE_MEMORY_5_SIZE, 0, },
+	{ SHARE_MEMORY_6_NORMAL, SHARE_MEMORY_6_SIZE, 0, },
+	{ SHARE_MEMORY_7_NORMAL, SHARE_MEMORY_7_SIZE, 0, },
+};
+
+static const struct hsc_spec_css_in uniphier_hsc_ld11_css_in[] = {
+	[HSC_CSS_IN_SRLTS0] = {
+		.pol = { true, CSS_SIGNALPOLCH(0), -1,  3,  0, },
+	},
+	[HSC_CSS_IN_SRLTS1] = {
+		.pol = { true, CSS_SIGNALPOLCH(0), -1, 11,  8, },
+	},
+	[HSC_CSS_IN_SRLTS2] = {
+		.pol = { true, CSS_SIGNALPOLCH(0), -1, 19, 16, },
+	},
+	[HSC_CSS_IN_SRLTS3] = {
+		.pol = { true, CSS_SIGNALPOLCH(0), -1, 27, 24, },
+	},
+	[HSC_CSS_IN_SRLTS4] = {
+		.pol = { true, CSS_SIGNALPOLCH(1), -1,  3,  0, },
+	},
+	[HSC_CSS_IN_PARTS0] = {
+		.pol = { true, CSS_PTSISIGNALPOL,  -1, -1,  0, },
+	},
+	[HSC_CSS_IN_PARTS1] = {
+		.pol = { true, CSS_PTSISIGNALPOL,  -1, -1,  8, },
+	},
+	[HSC_CSS_IN_DMD0]   = {
+		.pol = { true, CSS_DMDSIGNALPOL,   -1, -1, 16, },
+	},
+};
+
+static const struct hsc_spec_css_out uniphier_hsc_ld11_css_out[] = {
+	[HSC_CSS_OUT_SRLTS0] = {
+		.pol = { true, CSS_STSOSIGNALPOL,   6, -1,  0, },
+		.sel = { true, CSS_OUTPUTCTRL(0), GENMASK(4,  0), },
+	},
+	[HSC_CSS_OUT_SRLTS1] = {
+		.pol = { true, CSS_STSOSIGNALPOL,  14, -1,  8, },
+		.sel = { true, CSS_OUTPUTCTRL(0), GENMASK(12,  8), },
+	},
+	[HSC_CSS_OUT_TSI0] = {
+		.sel = { true, CSS_OUTPUTCTRL(1), GENMASK(4,  0), },
+	},
+	[HSC_CSS_OUT_TSI1] = {
+		.sel = { true, CSS_OUTPUTCTRL(1), GENMASK(12,  8), },
+	},
+	[HSC_CSS_OUT_TSI2] = {
+		.sel = { true, CSS_OUTPUTCTRL(1), GENMASK(20, 16), },
+	},
+	[HSC_CSS_OUT_TSI3] = {
+		.sel = { true, CSS_OUTPUTCTRL(1), GENMASK(28, 24), },
+	},
+	[HSC_CSS_OUT_TSI4] = {
+		.sel = { true, CSS_OUTPUTCTRL(2), GENMASK(4,  0), },
+	},
+	[HSC_CSS_OUT_PARTS0] = {
+		.pol = { true, CSS_PTSOSIGNALPOL,  -1, -1,  0, },
+		.sel = { true, CSS_OUTPUTCTRL(4), GENMASK(4,  0), },
+	},
+	[HSC_CSS_OUT_PKTFF0] = {
+		.sel = { true, CSS_OUTPUTCTRL(5), GENMASK(4,  0), },
+	},
+};
+
+static const struct hsc_spec_ts uniphier_hsc_ld11_ts_in[] = {
+	[HSC_TSI0] = {
+		.intr = { true, IOB_INTREN0, 13 },
+	},
+	[HSC_TSI1] = {
+		.intr = { true, IOB_INTREN0, 14 },
+	},
+	[HSC_TSI2] = {
+		.intr = { true, IOB_INTREN0, 15 },
+	},
+	[HSC_TSI3] = {
+		.intr = { true, IOB_INTREN0, 16 },
+	},
+	[HSC_TSI4] = {
+		.intr = { true, IOB_INTREN0, 17 },
+	},
+};
+
+static const struct hsc_spec_dma uniphier_hsc_ld11_dma_in[] = {
+	[HSC_DMA_IN0] = {
+		.dma_ch = 5,
+		.en     = { true, CDMBC_TDSTRT, 5 },
+		.intr   = { true, IOB_INTREN1, 1 },
+	},
+	[HSC_DMA_IN1] = {
+		.dma_ch = 6,
+		.en     = { true, CDMBC_TDSTRT, 6 },
+		.intr   = { true, IOB_INTREN1, 2 },
+	},
+	[HSC_DMA_IN2] = {
+		.dma_ch = 7,
+		.en     = { true, CDMBC_TDSTRT, 7 },
+		.intr   = { true, IOB_INTREN1, 3 },
+	},
+	[HSC_DMA_IN3] = {
+		.dma_ch = 22,
+		.en     = { true, CDMBC_TDSTRT, 13 },
+		.intr   = { true, IOB_INTREN1, 4 },
+	},
+	[HSC_DMA_IN4] = {
+		.dma_ch = 23,
+		.en     = { true, CDMBC_TDSTRT, 14 },
+		.intr   = { true, IOB_INTREN1, 5 },
+	},
+	[HSC_DMA_IN5] = {
+		.dma_ch = 24,
+		.en     = { true, CDMBC_TDSTRT, 15 },
+		.intr   = { true, IOB_INTREN1, 6 },
+	},
+};
+
+static const struct hsc_spec_dma uniphier_hsc_ld11_dma_out[] = {
+	[HSC_DMA_OUT0] = {
+		.dma_ch = 1,
+		.en     = { true, CDMBC_TDSTRT, 1 },
+		.intr   = { true, IOB_INTREN1, 13 },
+	},
+	[HSC_DMA_OUT1] = {
+		.dma_ch = 2,
+		.en     = { true, CDMBC_TDSTRT, 2 },
+		.intr   = { true, IOB_INTREN1, 14 },
+	},
+	[HSC_DMA_OUT2] = {
+		.dma_ch = 3,
+		.en     = { true, CDMBC_TDSTRT, 3 },
+		.intr   = { true, IOB_INTREN1, 15 },
+	},
+	[HSC_DMA_OUT3] = {
+		.dma_ch = 19,
+		.en     = { true, CDMBC_TDSTRT, 9 },
+		.intr   = { true, IOB_INTREN1, 16 },
+	},
+	[HSC_DMA_OUT4] = {
+		.dma_ch = 20,
+		.en     = { true, CDMBC_TDSTRT, 10 },
+		.intr   = { true, IOB_INTREN1, 17 },
+	},
+	[HSC_DMA_OUT5] = {
+		.dma_ch = 21,
+		.en     = { true, CDMBC_TDSTRT, 11 },
+		.intr   = { true, IOB_INTREN1, 18 },
+	},
+};
+
+const struct hsc_spec uniphier_hsc_ld11_spec = {
+	.ucode_spu     = { "hsc_spu_code_ld11.bin", "hsc_spu_data_ld11.bin" },
+	.ucode_ace     = { "hsc_ace_code_ld11.bin", "hsc_ace_data_ld11.bin" },
+	.init_rams     = uniphier_hsc_ld11_init_rams,
+	.num_init_rams = ARRAY_SIZE(uniphier_hsc_ld11_init_rams),
+	.css_in        = uniphier_hsc_ld11_css_in,
+	.num_css_in    = ARRAY_SIZE(uniphier_hsc_ld11_css_in),
+	.css_out       = uniphier_hsc_ld11_css_out,
+	.num_css_out   = ARRAY_SIZE(uniphier_hsc_ld11_css_out),
+	.ts_in         = uniphier_hsc_ld11_ts_in,
+	.num_ts_in     = ARRAY_SIZE(uniphier_hsc_ld11_ts_in),
+	.dma_in        = uniphier_hsc_ld11_dma_in,
+	.num_dma_in    = ARRAY_SIZE(uniphier_hsc_ld11_dma_in),
+	.dma_out       = uniphier_hsc_ld11_dma_out,
+	.num_dma_out   = ARRAY_SIZE(uniphier_hsc_ld11_dma_out),
+};
+
+const struct hsc_spec uniphier_hsc_ld20_spec = {
+	.ucode_spu     = { "hsc_spu_code_ld11.bin", "hsc_spu_data_ld11.bin" },
+	.ucode_ace     = { "hsc_ace_code_ld11.bin", "hsc_ace_data_ld11.bin" },
+	.init_rams     = uniphier_hsc_ld20_init_rams,
+	.num_init_rams = ARRAY_SIZE(uniphier_hsc_ld20_init_rams),
+	.css_in        = uniphier_hsc_ld11_css_in,
+	.num_css_in    = ARRAY_SIZE(uniphier_hsc_ld11_css_in),
+	.css_out       = uniphier_hsc_ld11_css_out,
+	.num_css_out   = ARRAY_SIZE(uniphier_hsc_ld11_css_out),
+	.ts_in         = uniphier_hsc_ld11_ts_in,
+	.num_ts_in     = ARRAY_SIZE(uniphier_hsc_ld11_ts_in),
+	.dma_in        = uniphier_hsc_ld11_dma_in,
+	.num_dma_in    = ARRAY_SIZE(uniphier_hsc_ld11_dma_in),
+	.dma_out       = uniphier_hsc_ld11_dma_out,
+	.num_dma_out   = ARRAY_SIZE(uniphier_hsc_ld11_dma_out),
+};
-- 
2.17.0
