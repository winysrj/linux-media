Return-path: <mchehab@pedra>
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:51394 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab0KJMvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:51:43 -0500
From: Jimmy Rubin <jimmy.rubin@stericsson.com>
To: <linux-fbdev@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
	Dan Johansson <dan.johansson@stericsson.com>,
	Jimmy Rubin <jimmy.rubin@stericsson.com>
Subject: [PATCH 01/10] MCDE: Add hardware abstraction layer
Date: Wed, 10 Nov 2010 13:04:04 +0100
Message-ID: <1289390653-6111-2-git-send-email-jimmy.rubin@stericsson.com>
In-Reply-To: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
References: <1289390653-6111-1-git-send-email-jimmy.rubin@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch adds support for MCDE, Memory-to-display controller
found in the ST-Ericsson ux500 products.

This patch adds the hardware abstraction layer.
All calls to the hardware is handled in mcde_hw.c

Signed-off-by: Jimmy Rubin <jimmy.rubin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij.stericsson.com>
---
 drivers/video/mcde/mcde_hw.c | 2528 ++++++++++++++++++++++++++++++++++++++++++
 include/video/mcde/mcde.h    |  387 +++++++
 2 files changed, 2915 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/mcde/mcde_hw.c
 create mode 100644 include/video/mcde/mcde.h

diff --git a/drivers/video/mcde/mcde_hw.c b/drivers/video/mcde/mcde_hw.c
new file mode 100644
index 0000000..38bc49c
--- /dev/null
+++ b/drivers/video/mcde/mcde_hw.c
@@ -0,0 +1,2528 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE base driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/err.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/regulator/consumer.h>
+#include <linux/clk.h>
+#include <linux/slab.h>
+#include <linux/jiffies.h>
+
+#include <video/mcde/mcde.h>
+
+#include "dsi_link_config.h"
+#include "mcde_formatter.h"
+#include "mcde_pixelprocess.h"
+#include "mcde_config.h"
+
+static void disable_channel(struct mcde_chnl_state *chnl);
+static void enable_channel(struct mcde_chnl_state *chnl);
+static void watchdog_auto_sync_timer_function(unsigned long arg);
+
+#define OVLY_TIMEOUT 500
+#define CHNL_TIMEOUT 500
+
+u8 *mcdeio;
+u8 **dsiio;
+DEFINE_SPINLOCK(mcde_lock); /* REVIEW: Remove or use */
+struct platform_device *mcde_dev;
+u8 num_dsilinks;
+static u8 hardware_version;
+
+static struct regulator *regulator;
+static struct clk *clock_dsi;
+static struct clk *clock_mcde;
+static struct clk *clock_dsi_lp;
+static u8 mcde_is_enabled;
+
+static inline u32 dsi_rreg(int i, u32 reg)
+{
+	return readl(dsiio[i] + reg);
+}
+static inline void dsi_wreg(int i, u32 reg, u32 val)
+{
+	writel(val, dsiio[i] + reg);
+}
+#define dsi_rfld(__i, __reg, __fld) \
+	((dsi_rreg(__i, __reg) & __reg##_##__fld##_MASK) >> \
+		__reg##_##__fld##_SHIFT)
+#define dsi_wfld(__i, __reg, __fld, __val) \
+	dsi_wreg(__i, __reg, (dsi_rreg(__i, __reg) & \
+	~__reg##_##__fld##_MASK) | (((__val) << __reg##_##__fld##_SHIFT) & \
+		 __reg##_##__fld##_MASK))
+
+static inline u32 mcde_rreg(u32 reg)
+{
+	return readl(mcdeio + reg);
+}
+static inline void mcde_wreg(u32 reg, u32 val)
+{
+	writel(val, mcdeio + reg);
+}
+#define mcde_rfld(__reg, __fld) \
+	((mcde_rreg(__reg) & __reg##_##__fld##_MASK) >> \
+		__reg##_##__fld##_SHIFT)
+#define mcde_wfld(__reg, __fld, __val) \
+	mcde_wreg(__reg, (mcde_rreg(__reg) & \
+	~__reg##_##__fld##_MASK) | (((__val) << __reg##_##__fld##_SHIFT) & \
+		 __reg##_##__fld##_MASK))
+
+struct ovly_regs {
+	u8   ch_id;
+	bool enabled;
+	u32  baseaddress0;
+	u32  baseaddress1;
+	bool reset_buf_id;
+	u8   bits_per_pixel;
+	u8   bpp;
+	bool bgr;
+	bool bebo;
+	bool opq;
+	u8   col_conv;
+	u8   pixoff;
+	u16  ppl;
+	u16  lpf;
+	u16  cropx;
+	u16  cropy;
+	u16  xpos;
+	u16  ypos;
+	u8   z;
+};
+
+struct mcde_ovly_state {
+	bool inuse;
+	u8 idx; /* MCDE overlay index */
+	struct mcde_chnl_state *chnl; /* Owner channel */
+	u32 transactionid; /* Apply time stamp */
+	u32 transactionid_regs; /* Register update time stamp */
+	u32 transactionid_hw; /* HW completed time stamp */
+	wait_queue_head_t waitq_hw; /* Waitq for transactionid_hw */
+
+	/* Staged settings */
+	u32 paddr;
+	u16 stride;
+	enum mcde_ovly_pix_fmt pix_fmt;
+
+	u16 src_x;
+	u16 src_y;
+	u16 dst_x;
+	u16 dst_y;
+	u16 dst_z;
+	u16 w;
+	u16 h;
+
+	/* Applied settings */
+	struct ovly_regs regs;
+};
+static struct mcde_ovly_state overlays[] = {
+	{ .idx = 0 },
+	{ .idx = 1 },
+	{ .idx = 2 },
+	{ .idx = 3 },
+	{ .idx = 4 },
+	{ .idx = 5 },
+};
+
+struct chnl_regs {
+	bool floen;
+	u16  x;
+	u16  y;
+	u16  ppl;
+	u16  lpf;
+	u8   bpp;
+	bool synchronized_update;
+	bool roten;
+	u8   rotdir;
+	u32  rotbuf1; /* TODO: Replace with eSRAM alloc */
+	u32  rotbuf2; /* TODO: Replace with eSRAM alloc */
+
+	/* DSI */
+	u8 dsipacking;
+};
+
+struct col_regs {
+	u16 y_red;
+	u16 y_green;
+	u16 y_blue;
+	u16 cb_red;
+	u16 cb_green;
+	u16 cb_blue;
+	u16 cr_red;
+	u16 cr_green;
+	u16 cr_blue;
+	u16 off_red;
+	u16 off_green;
+	u16 off_blue;
+};
+
+struct tv_regs {
+	u16 hbw; /* horizontal blanking width */
+	/* field 1 */
+	u16 bel1; /* field total vertical blanking lines */
+	u16 fsl1; /* field vbp */
+	/* field 2 */
+	u16 bel2;
+	u16 fsl2;
+	bool interlaced_en;
+	u8 tv_mode;
+};
+
+struct mcde_chnl_state {
+	bool inuse;
+	enum mcde_chnl id;
+	enum mcde_fifo fifo;
+	struct mcde_port port;
+	struct mcde_ovly_state *ovly0;
+	struct mcde_ovly_state *ovly1;
+	const struct chnl_config *cfg;
+	u32 transactionid;
+	u32 transactionid_regs;
+	u32 transactionid_hw;
+	wait_queue_head_t waitq_hw; /* Waitq for transactionid_hw */
+	/* Used as watchdog timer for auto sync feature */
+	struct timer_list auto_sync_timer;
+
+	enum mcde_display_power_mode power_mode;
+
+	/* Staged settings */
+	bool synchronized_update;
+	enum mcde_port_pix_fmt pix_fmt;
+	struct mcde_video_mode vmode;
+	enum mcde_display_rotation rotation;
+	u32 rotbuf1;
+	u32 rotbuf2;
+
+	/* Applied settings */
+	struct chnl_regs regs;
+	struct col_regs  col_regs;
+	struct tv_regs   tv_regs;
+
+	bool continous_running;
+};
+
+static struct mcde_chnl_state channels[] = {
+	{
+		.id = MCDE_CHNL_A,
+		.ovly0 = &overlays[0],
+		.ovly1 = &overlays[1],
+	},
+	{
+		.id = MCDE_CHNL_B,
+		.ovly0 = &overlays[2],
+		.ovly1 = &overlays[3],
+	},
+	{
+		.id = MCDE_CHNL_C0,
+		.ovly0 = &overlays[4],
+		.ovly1 = NULL,
+	},
+	{
+		.id = MCDE_CHNL_C1,
+		.ovly0 = &overlays[5],
+		.ovly1 = NULL,
+	}
+};
+
+struct chnl_config {
+	/* Key */
+	enum mcde_chnl_path path;
+
+	/* Value */
+	bool swap_a_c0;
+	bool swap_a_c0_set;
+	bool swap_b_c1;
+	bool swap_b_c1_set;
+	bool fabmux;
+	bool fabmux_set;
+	bool f01mux;
+	bool f01mux_set;
+};
+
+static /* TODO: const, compiler bug? */ struct chnl_config chnl_configs[] = {
+	/* Channel A */
+	{ .path = MCDE_CHNLPATH_CHNLA_FIFOA_DPI_0,
+	  .swap_a_c0 = false, .swap_a_c0_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC0_0,
+	  .swap_a_c0 = false, .swap_a_c0_set = true,
+	  .fabmux = false, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC0_1,
+	  .swap_a_c0 = false, .swap_a_c0_set = true,
+	  .fabmux = true, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC0_2,
+	  .swap_a_c0 = true, .swap_a_c0_set = true,
+	  .f01mux = false, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC1_0,
+	  .swap_a_c0 = true, .swap_a_c0_set = true,
+	  .f01mux = false, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC1_1,
+	  .swap_a_c0 = true, .swap_a_c0_set = true,
+	  .f01mux = true, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC1_2,
+	  .swap_a_c0 = false, .swap_a_c0_set = true,
+	  .fabmux = false, .fabmux_set = true },
+	/* Channel B */
+	{ .path = MCDE_CHNLPATH_CHNLB_FIFOB_DPI_1,
+	  .swap_b_c1 = false, .swap_b_c1_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLB_FIFOB_DSI_IFC0_0,
+	  .swap_b_c1 = false, .swap_b_c1_set = true,
+	  .fabmux = true, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLB_FIFOB_DSI_IFC0_1,
+	  .swap_b_c1 = false, .swap_b_c1_set = true,
+	  .fabmux = false, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLB_FIFOC1_DSI_IFC0_2,
+	  .swap_b_c1 = true, .swap_b_c1_set = true,
+	  .f01mux = true, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLB_FIFOC1_DSI_IFC1_0,
+	  .swap_b_c1 = true, .swap_b_c1_set = true,
+	  .f01mux = true, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLB_FIFOC1_DSI_IFC1_1,
+	  .swap_b_c1 = true, .swap_b_c1_set = true,
+	  .f01mux = false, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLB_FIFOB_DSI_IFC1_2,
+	  .swap_b_c1 = false, .swap_b_c1_set = true,
+	  .fabmux = true, .fabmux_set = true },
+	/* Channel C0 */
+	{ .path = MCDE_CHNLPATH_CHNLC0_FIFOA_DSI_IFC0_0,
+	  .swap_a_c0 = true, .swap_a_c0_set = true,
+	  .fabmux = false, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC0_FIFOA_DSI_IFC0_1,
+	  .swap_a_c0 = true, .swap_a_c0_set = true,
+	  .fabmux = true, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC0_FIFOC0_DSI_IFC0_2,
+	  .swap_a_c0 = false, .swap_a_c0_set = true,
+	  .f01mux = false, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC0_FIFOC0_DSI_IFC1_0,
+	  .swap_a_c0 = false, .swap_a_c0_set = true,
+	  .f01mux = false, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC0_FIFOC0_DSI_IFC1_1,
+	  .swap_a_c0 = false, .swap_a_c0_set = true,
+	  .f01mux = true, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC0_FIFOA_DSI_IFC1_2,
+	  .swap_a_c0 = true, .swap_a_c0_set = true,
+	  .fabmux = false, .fabmux_set = true },
+	/* Channel C1 */
+	{ .path = MCDE_CHNLPATH_CHNLC1_FIFOB_DSI_IFC0_0,
+	  .swap_b_c1 = true, .swap_b_c1_set = true,
+	  .fabmux = true, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC1_FIFOB_DSI_IFC0_1,
+	  .swap_b_c1 = true, .swap_b_c1_set = true,
+	  .fabmux = false, .fabmux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC1_FIFOC1_DSI_IFC0_2,
+	  .swap_b_c1 = false, .swap_b_c1_set = true,
+	  .f01mux = true, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC1_FIFOC1_DSI_IFC1_0,
+	  .swap_b_c1 = false, .swap_b_c1_set = true,
+	  .f01mux = true, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC1_FIFOC1_DSI_IFC1_1,
+	  .swap_b_c1 = false, .swap_b_c1_set = true,
+	  .f01mux = false, .f01mux_set = true },
+	{ .path = MCDE_CHNLPATH_CHNLC1_FIFOB_DSI_IFC1_2,
+	  .swap_b_c1 = true, .swap_b_c1_set = true,
+	  .fabmux = true, .fabmux_set = true },
+};
+
+static int enable_clocks_and_power(struct platform_device *pdev)
+{
+	struct mcde_platform_data *pdata = pdev->dev.platform_data;
+	int ret = 0;
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+
+	if (regulator) {
+		ret = regulator_enable(regulator);
+		if (ret < 0) {
+			dev_warn(&pdev->dev, "%s: regulator_enable failed\n",
+			__func__);
+			return ret;
+		}
+	} else {
+		dev_dbg(&pdev->dev, "%s: No regulator id supplied\n"
+						, __func__);
+	}
+
+	ret = pdata->platform_enable();
+	if (ret < 0) {
+		dev_warn(&pdev->dev, "%s: "
+			"platform_enable failed ret = %d\n", __func__, ret);
+		goto prcmu_err;
+	}
+
+	ret = clk_enable(clock_dsi);
+	if (ret < 0) {
+		dev_warn(&pdev->dev, "%s: "
+			"clk_enable dsi failed ret = %d\n", __func__, ret);
+		goto clk_dsi_err;
+	}
+	ret = clk_enable(clock_dsi_lp);
+	if (ret < 0) {
+		dev_warn(&pdev->dev, "%s: "
+			"clk_enable dsi_lp failed ret = %d\n", __func__, ret);
+		goto clk_dsi_lp_err;
+	}
+	ret = clk_enable(clock_mcde);
+	if (ret < 0) {
+		dev_warn(&pdev->dev, "%s: "
+			"clk_enable mcde failed ret = %d\n", __func__, ret);
+		goto clk_mcde_err;
+	}
+
+	return ret;
+
+prcmu_err:
+	pdata->platform_disable();
+clk_mcde_err:
+	clk_disable(clock_dsi_lp);
+clk_dsi_lp_err:
+	clk_disable(clock_dsi);
+clk_dsi_err:
+	if (regulator)
+		regulator_disable(regulator);
+	return ret;
+}
+
+static int disable_clocks_and_power(struct platform_device *pdev)
+{
+	struct mcde_platform_data *pdata = pdev->dev.platform_data;
+	int ret = 0;
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+
+	clk_disable(clock_dsi_lp);
+	clk_disable(clock_mcde);
+	clk_disable(clock_dsi);
+	if (regulator) {
+		ret = regulator_disable(regulator);
+		if (ret < 0) {
+			dev_warn(&pdev->dev, "%s: regulator_disable failed\n"
+					, __func__);
+			goto regulator_err;
+		}
+	} else {
+		dev_dbg(&pdev->dev, "%s: No regulator id supplied\n"
+					, __func__);
+	}
+
+	pdata->platform_disable();
+
+	return ret;
+regulator_err:
+	clk_enable(clock_dsi_lp);
+	clk_enable(clock_mcde);
+	clk_enable(clock_dsi);
+	return ret;
+}
+
+static void update_mcde_registers(void)
+{
+	struct mcde_platform_data *pdata = mcde_dev->dev.platform_data;
+
+	/* Setup output muxing */
+	mcde_wreg(MCDE_CONF0,
+		MCDE_CONF0_IFIFOCTRLWTRMRKLVL(7) |
+		MCDE_CONF0_OUTMUX0(pdata->outmux[0]) |
+		MCDE_CONF0_OUTMUX1(pdata->outmux[1]) |
+		MCDE_CONF0_OUTMUX2(pdata->outmux[2]) |
+		MCDE_CONF0_OUTMUX3(pdata->outmux[3]) |
+		MCDE_CONF0_OUTMUX4(pdata->outmux[4]) |
+		pdata->syncmux);
+
+	/* Enable channel VCMP interrupts */
+	mcde_wreg(MCDE_IMSCPP,
+		MCDE_IMSCPP_VCMPAIM(true) |
+		MCDE_IMSCPP_VCMPBIM(true) |
+		MCDE_IMSCPP_VCMPC0IM(true) |
+		MCDE_IMSCPP_VCMPC1IM(true));
+
+	/* Enable overlay fetch done interrupts */
+	mcde_wfld(MCDE_IMSCOVL, OVLFDIM, 0x3f);
+
+	/* Setup sync pulse length */
+	mcde_wreg(MCDE_VSCRC0,
+		MCDE_VSCRC0_VSPMIN(1) |
+		MCDE_VSCRC0_VSPMAX(0xff));
+	mcde_wreg(MCDE_VSCRC1,
+		MCDE_VSCRC1_VSPMIN(1) |
+		MCDE_VSCRC1_VSPMAX(0xff));
+}
+
+static int is_channel_enabled(struct mcde_chnl_state *chnl)
+{
+	switch (chnl->id) {
+	case MCDE_CHNL_A:
+		return mcde_rfld(MCDE_CRA0, FLOEN);
+	case MCDE_CHNL_B:
+		return mcde_rfld(MCDE_CRB0, FLOEN);
+	case MCDE_CHNL_C0:
+		return mcde_rfld(MCDE_CRC, FLOEN);
+	case MCDE_CHNL_C1:
+		return mcde_rfld(MCDE_CRC, FLOEN);
+	}
+	return 0;
+}
+
+static void channel_flow_disable(struct mcde_chnl_state *chnl)
+{
+	switch (chnl->id) {
+	case MCDE_CHNL_A:
+		mcde_wfld(MCDE_CRA0, FLOEN, false);
+		break;
+	case MCDE_CHNL_B:
+		mcde_wfld(MCDE_CRB0, FLOEN, false);
+		break;
+	case MCDE_CHNL_C0:
+		mcde_wfld(MCDE_CRC, FLOEN, false);
+		break;
+	case MCDE_CHNL_C1:
+		mcde_wfld(MCDE_CRC, FLOEN, false);
+		break;
+	}
+}
+
+static void channel_flow_enable(struct mcde_chnl_state *chnl)
+{
+	switch (chnl->id) {
+	case MCDE_CHNL_A:
+		mcde_wfld(MCDE_CRA0, FLOEN, true);
+		break;
+	case MCDE_CHNL_B:
+		mcde_wfld(MCDE_CRB0, FLOEN, true);
+		break;
+	case MCDE_CHNL_C0:
+		mcde_wfld(MCDE_CRC, C1EN, true);
+		mcde_wfld(MCDE_CRC, FLOEN, true);
+		break;
+	case MCDE_CHNL_C1:
+		mcde_wfld(MCDE_CRC, C2EN, true);
+		mcde_wfld(MCDE_CRC, FLOEN, true);
+		break;
+	}
+}
+
+#define MCDE_PIXELDISABLE_MAX_TRIAL 20
+static void channel_pixelprocessing_disable(struct mcde_chnl_state *chnl)
+{
+	int i;
+	switch (chnl->id) {
+	case MCDE_CHNL_A:
+	case MCDE_CHNL_B:
+		/* Pixelprocessing can not be enable/disabled for A and B */
+		return;
+	case MCDE_CHNL_C0:
+		mcde_wfld(MCDE_CRC, C1EN, false);
+		for (i = 0; i < MCDE_PIXELDISABLE_MAX_TRIAL; i++) {
+			msleep(3);
+			if (!mcde_rfld(MCDE_CRC, C1EN)) {
+				dev_vdbg(&mcde_dev->dev,
+					"C1 disable after >= %d ms\n"
+									, i);
+				return;
+			}
+		}
+		break;
+	case MCDE_CHNL_C1:
+		mcde_wfld(MCDE_CRC, C2EN, false);
+		for (i = 0; i < MCDE_PIXELDISABLE_MAX_TRIAL; i++) {
+			msleep(3);
+			if (!mcde_rfld(MCDE_CRC, C2EN)) {
+				dev_vdbg(&mcde_dev->dev,
+					"C2 disable after >= %d ms\n"
+									, i);
+				return;
+			}
+		}
+		break;
+	}
+	dev_warn(&mcde_dev->dev, "%s: Channel %d timeout\n"
+						, __func__, chnl->id);
+}
+#undef MCDE_PIXELDISABLE_MAX_TRIAL
+
+int mcde_chnl_set_video_mode(struct mcde_chnl_state *chnl,
+				struct mcde_video_mode *vmode)
+{
+	if (chnl == NULL || vmode == NULL)
+		return -EINVAL;
+
+	chnl->vmode = *vmode;
+
+	return 0;
+}
+
+static void tv_video_mode_apply(struct mcde_chnl_state *chnl)
+{
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+	/* -4 since MCDE doesn't include SAV/EAV, 2 bytes each, to blanking */
+	chnl->tv_regs.hbw  = chnl->vmode.hbp + chnl->vmode.hfp - 4;
+	chnl->tv_regs.bel1 = chnl->vmode.vbp1 + chnl->vmode.vfp1;
+	chnl->tv_regs.fsl1 = chnl->vmode.vbp1;
+	chnl->tv_regs.bel2 = chnl->vmode.vbp2 + chnl->vmode.vfp2;
+	chnl->tv_regs.fsl2 = chnl->vmode.vbp2;
+	chnl->tv_regs.interlaced_en = chnl->vmode.interlaced;
+
+	if (chnl->port.phy.dpi.bus_width == 4)
+		chnl->tv_regs.tv_mode = MCDE_TVCRA_TVMODE_SDTV_656P_BE;
+	else
+		chnl->tv_regs.tv_mode = MCDE_TVCRA_TVMODE_SDTV_656P;
+}
+
+static void update_tv_registers(enum mcde_chnl chnl_id, struct tv_regs *regs)
+{
+	u8 idx = chnl_id;
+
+	dev_dbg(&mcde_dev->dev, "%s\n", __func__);
+	mcde_wreg(MCDE_TVCRA + idx * MCDE_TVCRA_GROUPOFFSET,
+			MCDE_TVCRA_SEL_MOD(MCDE_TVCRA_SEL_MOD_TV)         |
+			MCDE_TVCRA_INTEREN(regs->interlaced_en)           |
+			MCDE_TVCRA_IFIELD(1)                              |
+			MCDE_TVCRA_TVMODE(regs->tv_mode)                  |
+			MCDE_TVCRA_SDTVMODE(MCDE_TVCRA_SDTVMODE_Y0CBY1CR) |
+			MCDE_TVCRA_AVRGEN(0));
+	mcde_wreg(MCDE_TVBLUA + idx * MCDE_TVBLUA_GROUPOFFSET,
+		MCDE_TVBLUA_TVBLU(MCDE_CONFIG_TVOUT_BACKGROUND_LUMINANCE) |
+		MCDE_TVBLUA_TVBCB(MCDE_CONFIG_TVOUT_BACKGROUND_CHROMINANCE_CB)|
+		MCDE_TVBLUA_TVBCR(MCDE_CONFIG_TVOUT_BACKGROUND_CHROMINANCE_CR));
+
+	/* Vertical timing registers */
+	mcde_wreg(MCDE_TVDVOA + idx * MCDE_TVDVOA_GROUPOFFSET,
+				MCDE_TVDVOA_DVO1(MCDE_CONFIG_TVOUT_VBORDER) |
+				MCDE_TVDVOA_DVO2(MCDE_CONFIG_TVOUT_VBORDER));
+	mcde_wreg(MCDE_TVBL1A + idx * MCDE_TVBL1A_GROUPOFFSET,
+				MCDE_TVBL1A_BEL1(regs->bel1) |
+				MCDE_TVBL1A_BSL1(MCDE_CONFIG_TVOUT_VBORDER));
+	mcde_wreg(MCDE_TVBL2A + idx * MCDE_TVBL1A_GROUPOFFSET,
+				MCDE_TVBL2A_BEL2(regs->bel2) |
+				MCDE_TVBL2A_BSL2(MCDE_CONFIG_TVOUT_VBORDER));
+	mcde_wreg(MCDE_TVISLA + idx * MCDE_TVISLA_GROUPOFFSET,
+				MCDE_TVISLA_FSL1(regs->fsl1) |
+				MCDE_TVISLA_FSL2(regs->fsl2));
+
+	/* Horizontal timing registers */
+	if (hardware_version == MCDE_CHIP_VERSION_3_0_8) {
+		mcde_wreg(MCDE_TVLBALWA + idx * MCDE_TVLBALWA_GROUPOFFSET,
+				MCDE_TVLBALWA_LBW(regs->hbw) |
+				MCDE_TVLBALWA_ALW(MCDE_CONFIG_TVOUT_HBORDER));
+		mcde_wreg(MCDE_TVTIM1A + idx * MCDE_TVTIM1A_GROUPOFFSET,
+				MCDE_TVTIM1A_DHO(MCDE_CONFIG_TVOUT_HBORDER));
+	} else {
+		/* in earlier versions the LBW and DHO fields are swapped */
+		mcde_wreg(MCDE_TVLBALWA + idx * MCDE_TVLBALWA_GROUPOFFSET,
+				MCDE_TVLBALWA_LBW(MCDE_CONFIG_TVOUT_HBORDER) |
+				MCDE_TVLBALWA_ALW(MCDE_CONFIG_TVOUT_HBORDER));
+		mcde_wreg(MCDE_TVTIM1A + idx * MCDE_TVTIM1A_GROUPOFFSET,
+			MCDE_TVTIM1A_DHO(regs->hbw));
+	}
+}
+
+static void update_col_registers(enum mcde_chnl chnl_id, struct col_regs *regs)
+{
+	u8 idx = chnl_id;
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+	mcde_wreg(MCDE_RGBCONV1A + idx * MCDE_RGBCONV1A_GROUPOFFSET,
+				MCDE_RGBCONV1A_YR_RED(regs->y_red) |
+				MCDE_RGBCONV1A_YR_GREEN(regs->y_green));
+	mcde_wreg(MCDE_RGBCONV2A + idx * MCDE_RGBCONV2A_GROUPOFFSET,
+				MCDE_RGBCONV2A_YR_BLUE(regs->y_blue) |
+				MCDE_RGBCONV2A_CR_RED(regs->cr_red));
+	mcde_wreg(MCDE_RGBCONV3A + idx * MCDE_RGBCONV3A_GROUPOFFSET,
+				MCDE_RGBCONV3A_CR_GREEN(regs->cr_green) |
+				MCDE_RGBCONV3A_CR_BLUE(regs->cr_blue));
+	mcde_wreg(MCDE_RGBCONV4A + idx * MCDE_RGBCONV4A_GROUPOFFSET,
+				MCDE_RGBCONV4A_CB_RED(regs->cb_red) |
+				MCDE_RGBCONV4A_CB_GREEN(regs->cb_green));
+	mcde_wreg(MCDE_RGBCONV5A + idx * MCDE_RGBCONV5A_GROUPOFFSET,
+				MCDE_RGBCONV5A_CB_BLUE(regs->cb_blue) |
+				MCDE_RGBCONV5A_OFF_RED(regs->off_red));
+	mcde_wreg(MCDE_RGBCONV6A + idx * MCDE_RGBCONV6A_GROUPOFFSET,
+				MCDE_RGBCONV6A_OFF_GREEN(regs->off_green) |
+				MCDE_RGBCONV6A_OFF_BLUE(regs->off_blue));
+}
+
+/* MCDE internal helpers */
+static u8 portfmt2dsipacking(enum mcde_port_pix_fmt pix_fmt)
+{
+	switch (pix_fmt) {
+	case MCDE_PORTPIXFMT_DSI_16BPP:
+		return MCDE_DSIVID0CONF0_PACKING_RGB565;
+	case MCDE_PORTPIXFMT_DSI_18BPP_PACKED:
+		return MCDE_DSIVID0CONF0_PACKING_RGB666;
+	case MCDE_PORTPIXFMT_DSI_18BPP:
+	case MCDE_PORTPIXFMT_DSI_24BPP:
+	default:
+		return MCDE_DSIVID0CONF0_PACKING_RGB888;
+	case MCDE_PORTPIXFMT_DSI_YCBCR422:
+		return MCDE_DSIVID0CONF0_PACKING_HDTV;
+	}
+}
+
+static u8 portfmt2bpp(enum mcde_port_pix_fmt pix_fmt)
+{
+	/* TODO: Check DPI spec *//* REVIEW: Remove or check */
+	switch (pix_fmt) {
+	case MCDE_PORTPIXFMT_DPI_16BPP_C1:
+	case MCDE_PORTPIXFMT_DPI_16BPP_C2:
+	case MCDE_PORTPIXFMT_DPI_16BPP_C3:
+	case MCDE_PORTPIXFMT_DSI_16BPP:
+	case MCDE_PORTPIXFMT_DSI_YCBCR422:
+		return 16;
+	case MCDE_PORTPIXFMT_DPI_18BPP_C1:
+	case MCDE_PORTPIXFMT_DPI_18BPP_C2:
+	case MCDE_PORTPIXFMT_DSI_18BPP_PACKED:
+		return 18;
+	case MCDE_PORTPIXFMT_DSI_18BPP:
+	case MCDE_PORTPIXFMT_DPI_24BPP:
+	case MCDE_PORTPIXFMT_DSI_24BPP:
+		return 24;
+	default:
+		return 1;
+	}
+}
+
+static u8 bpp2outbpp(u8 bpp)
+{
+	/* TODO: Check DPI spec *//* REVIEW: Remove or check */
+	switch (bpp) {
+	case 16:
+		return MCDE_CRA1_OUTBPP_16BPP;
+	case 18:
+		return MCDE_CRA1_OUTBPP_18BPP;
+	case 24:
+		return MCDE_CRA1_OUTBPP_24BPP;
+	default:
+		return 0;
+	}
+}
+
+static u32 get_output_fifo_size(enum mcde_fifo fifo)
+{
+	u32 ret = 1; /* Avoid div by zero */
+
+	switch (fifo) {
+	case MCDE_FIFO_A:
+	case MCDE_FIFO_B:
+		ret = MCDE_FIFO_AB_SIZE;
+		break;
+	case MCDE_FIFO_C0:
+	case MCDE_FIFO_C1:
+		ret = MCDE_FIFO_C0C1_SIZE;
+		break;
+	default:
+		dev_vdbg(&mcde_dev->dev, "Unsupported fifo");
+		break;
+	}
+	return ret;
+}
+
+static u8 get_dsi_formid(const struct mcde_port *port)
+{
+	if (port->ifc == DSI_VIDEO_MODE && port->link == 0)
+		return MCDE_CTRLA_FORMID_DSI0VID;
+	else if (port->ifc == DSI_VIDEO_MODE && port->link == 1)
+		return MCDE_CTRLA_FORMID_DSI1VID;
+	else if (port->ifc == DSI_VIDEO_MODE && port->link == 2)
+		return MCDE_CTRLA_FORMID_DSI2VID;
+	else if (port->ifc == DSI_CMD_MODE && port->link == 0)
+		return MCDE_CTRLA_FORMID_DSI0CMD;
+	else if (port->ifc == DSI_CMD_MODE && port->link == 1)
+		return MCDE_CTRLA_FORMID_DSI1CMD;
+	else if (port->ifc == DSI_CMD_MODE && port->link == 2)
+		return MCDE_CTRLA_FORMID_DSI2CMD;
+	return 0;
+}
+
+static struct mcde_chnl_state *find_channel_by_dsilink(int link)
+{
+	struct mcde_chnl_state *chnl = &channels[0];
+	for (; chnl < &channels[ARRAY_SIZE(channels)]; chnl++)
+		if (chnl->inuse && chnl->port.link == link &&
+					chnl->port.type == MCDE_PORTTYPE_DSI)
+			return chnl;
+	return NULL;
+}
+
+static irqreturn_t mcde_irq_handler(int irq, void *dev)
+{
+	int i;
+	u32 irq_status;
+	bool trig = false;
+	struct mcde_chnl_state *chnl;
+
+	/* Handle overlay irqs */
+	irq_status = mcde_rfld(MCDE_RISOVL, OVLFDRIS);
+	for (i = 0; i < ARRAY_SIZE(overlays); i++) {
+		if (irq_status & (1 << i)) {
+			struct mcde_ovly_state *ovly = &overlays[i];
+			ovly->transactionid_hw = ovly->transactionid_regs;
+			wake_up(&ovly->waitq_hw);
+		}
+	}
+	mcde_wfld(MCDE_RISOVL, OVLFDRIS, irq_status);
+
+	/* Handle channel irqs */
+	irq_status = mcde_rreg(MCDE_RISPP);
+	if (irq_status & MCDE_RISPP_VCMPARIS_MASK) {
+		chnl = &channels[MCDE_CHNL_A];
+		chnl->transactionid_hw = chnl->transactionid_regs;
+		wake_up(&chnl->waitq_hw);
+		mcde_wfld(MCDE_RISPP, VCMPARIS, 1);
+		if (chnl->port.update_auto_trig &&
+				chnl->port.sync_src == MCDE_SYNCSRC_OFF &&
+				chnl->port.type == MCDE_PORTTYPE_DSI &&
+				chnl->continous_running) {
+			mcde_wreg(MCDE_CHNL0SYNCHSW +
+				chnl->id * MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+				MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+			mod_timer(&chnl->auto_sync_timer,
+				jiffies +
+				msecs_to_jiffies(MCDE_AUTO_SYNC_WATCHDOG
+								* 1000));
+		}
+	}
+	if (irq_status & MCDE_RISPP_VCMPBRIS_MASK) {
+		chnl = &channels[MCDE_CHNL_B];
+		chnl->transactionid_hw = chnl->transactionid_regs;
+		wake_up(&chnl->waitq_hw);
+		mcde_wfld(MCDE_RISPP, VCMPBRIS, 1);
+		if (chnl->port.update_auto_trig &&
+				chnl->port.sync_src == MCDE_SYNCSRC_OFF &&
+				chnl->port.type == MCDE_PORTTYPE_DSI &&
+				chnl->continous_running) {
+			mcde_wreg(MCDE_CHNL0SYNCHSW +
+				chnl->id * MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+				MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+			mod_timer(&chnl->auto_sync_timer,
+				jiffies +
+				msecs_to_jiffies(MCDE_AUTO_SYNC_WATCHDOG
+								* 1000));
+		}
+	}
+	if (irq_status & MCDE_RISPP_VCMPC0RIS_MASK) {
+		chnl = &channels[MCDE_CHNL_C0];
+		chnl->transactionid_hw = chnl->transactionid_regs;
+		wake_up(&chnl->waitq_hw);
+		mcde_wfld(MCDE_RISPP, VCMPC0RIS, 1);
+		if (chnl->port.update_auto_trig &&
+				chnl->port.sync_src == MCDE_SYNCSRC_OFF &&
+				chnl->port.type == MCDE_PORTTYPE_DSI &&
+				chnl->continous_running) {
+			mcde_wreg(MCDE_CHNL0SYNCHSW +
+				chnl->id * MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+				MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+			mod_timer(&chnl->auto_sync_timer,
+				jiffies +
+				msecs_to_jiffies(MCDE_AUTO_SYNC_WATCHDOG
+								* 1000));
+		}
+	}
+	if (irq_status & MCDE_RISPP_VCMPC1RIS_MASK) {
+		chnl = &channels[MCDE_CHNL_C1];
+		chnl->transactionid_hw = chnl->transactionid_regs;
+		wake_up(&chnl->waitq_hw);
+		mcde_wfld(MCDE_RISPP, VCMPC1RIS, 1);
+		if (chnl->port.update_auto_trig &&
+				chnl->port.sync_src == MCDE_SYNCSRC_OFF &&
+				chnl->port.type == MCDE_PORTTYPE_DSI &&
+				chnl->continous_running) {
+			mcde_wreg(MCDE_CHNL0SYNCHSW +
+				chnl->id * MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+				MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+			mod_timer(&chnl->auto_sync_timer,
+				jiffies +
+				msecs_to_jiffies(MCDE_AUTO_SYNC_WATCHDOG
+								* 1000));
+		}
+	}
+	for (i = 0; i < num_dsilinks; i++) {
+		struct mcde_chnl_state *chnl_from_dsi;
+
+		trig = false;
+		irq_status = dsi_rfld(i, DSI_DIRECT_CMD_STS_FLAG,
+			TE_RECEIVED_FLAG);
+		if (irq_status) {
+			trig = true;
+			dsi_wreg(i, DSI_DIRECT_CMD_STS_CLR,
+				DSI_DIRECT_CMD_STS_CLR_TE_RECEIVED_CLR(true));
+			dev_vdbg(&mcde_dev->dev, "BTA TE DSI%d\n", i);
+		}
+		irq_status = dsi_rfld(i, DSI_CMD_MODE_STS_FLAG, ERR_NO_TE_FLAG);
+		if (irq_status) {
+			dsi_wreg(i, DSI_CMD_MODE_STS_CLR,
+				DSI_CMD_MODE_STS_CLR_ERR_NO_TE_CLR(true));
+			dev_info(&mcde_dev->dev, "NO_TE DSI%d\n", i);
+		}
+		if (!trig)
+			continue;
+		chnl_from_dsi = find_channel_by_dsilink(i);
+		if (chnl_from_dsi) {
+			mcde_wreg(MCDE_CHNL0SYNCHSW +
+				chnl_from_dsi->id *
+				MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+				MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+			dev_vdbg(&mcde_dev->dev, "SW TRIG DSI%d, chnl=%d\n", i,
+				chnl_from_dsi->id);
+			/*
+			* This comment is valid for hardware_version ==
+			* MCDE_CHIP_VERSION_3_0_8.
+			*
+			* If you disable after the last frame you triggered has
+			* finished. The output formatter
+			* (at least DSI is working like this) is waiting for a
+			* new frame that will never come, and then the FLOEN
+			* will stay at 1. To avoid this, you have to always
+			* disable just after your last trig, before receiving
+			* VCOMP interrupt (= before the last triggered frame
+			* is finished).
+			*/
+			if (hardware_version == MCDE_CHIP_VERSION_3_0_8)
+				channel_flow_disable(chnl_from_dsi);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+void wait_for_overlay(struct mcde_ovly_state *ovly)
+{
+	int ret;
+
+	ret = wait_event_timeout(ovly->waitq_hw,
+		ovly->transactionid_hw == ovly->transactionid_regs,
+		msecs_to_jiffies(OVLY_TIMEOUT));
+	if (!ret)
+		dev_warn(&mcde_dev->dev,
+			"Wait for overlay timeout (ovly=%d,%d<%d)!\n",
+			ovly->idx, ovly->transactionid_hw,
+			ovly->transactionid_regs);
+}
+
+void wait_for_channel(struct mcde_chnl_state *chnl)
+{
+	int ret;
+
+	ret = wait_event_timeout(chnl->waitq_hw,
+		chnl->transactionid_hw == chnl->transactionid_regs,
+		msecs_to_jiffies(CHNL_TIMEOUT));
+	if (!ret)
+		dev_warn(&mcde_dev->dev,
+			"Wait for channel timeout (chnl=%d,%d<%d)!\n",
+			chnl->id, chnl->transactionid_hw,
+			chnl->transactionid_regs);
+}
+
+static int update_channel_static_registers(struct mcde_chnl_state *chnl)
+{
+	const struct chnl_config *cfg = chnl->cfg;
+	const struct mcde_port *port = &chnl->port;
+
+	if (hardware_version == MCDE_CHIP_VERSION_3_0_5) {
+		/* Fifo & muxing */
+		if (cfg->swap_a_c0_set)
+			mcde_wfld(MCDE_CONF0, SWAP_A_C0_V1, cfg->swap_a_c0);
+		if (cfg->swap_b_c1_set)
+			mcde_wfld(MCDE_CONF0, SWAP_B_C1_V1, cfg->swap_b_c1);
+		if (cfg->fabmux_set)
+			mcde_wfld(MCDE_CR, FABMUX_V1, cfg->fabmux);
+		if (cfg->f01mux_set)
+			mcde_wfld(MCDE_CR, F01MUX_V1, cfg->f01mux);
+
+		if (port->type == MCDE_PORTTYPE_DPI) {
+			if (port->link == 0)
+				mcde_wfld(MCDE_CR, DPIA_EN_V1, true);
+			else if (port->link == 1)
+				mcde_wfld(MCDE_CR, DPIB_EN_V1, true);
+		} else if (port->type == MCDE_PORTTYPE_DSI) {
+			if (port->ifc == DSI_VIDEO_MODE && port->link == 0)
+				mcde_wfld(MCDE_CR, DSIVID0_EN_V1, true);
+			else if (port->ifc == DSI_VIDEO_MODE && port->link == 1)
+				mcde_wfld(MCDE_CR, DSIVID1_EN_V1, true);
+			else if (port->ifc == DSI_VIDEO_MODE && port->link == 2)
+				mcde_wfld(MCDE_CR, DSIVID2_EN_V1, true);
+			else if (port->ifc == DSI_CMD_MODE && port->link == 0)
+				mcde_wfld(MCDE_CR, DSICMD0_EN_V1, true);
+			else if (port->ifc == DSI_CMD_MODE && port->link == 1)
+				mcde_wfld(MCDE_CR, DSICMD1_EN_V1, true);
+			else if (port->ifc == DSI_CMD_MODE && port->link == 2)
+				mcde_wfld(MCDE_CR, DSICMD2_EN_V1, true);
+		}
+
+		if (chnl->fifo == MCDE_FIFO_C0)
+			mcde_wreg(MCDE_CTRLC0, MCDE_CTRLC0_FIFOWTRMRK(
+					get_output_fifo_size(MCDE_FIFO_C0)));
+		else if (chnl->fifo == MCDE_FIFO_C1)
+			mcde_wreg(MCDE_CTRLC1, MCDE_CTRLC1_FIFOWTRMRK(
+					get_output_fifo_size(MCDE_FIFO_C1)));
+		else if (port->update_auto_trig &&
+					(port->sync_src == MCDE_SYNCSRC_TE0))
+			mcde_wreg(MCDE_CTRLC0, MCDE_CTRLC0_FIFOWTRMRK(
+					get_output_fifo_size(MCDE_FIFO_C0)));
+		else if (port->update_auto_trig &&
+					(port->sync_src == MCDE_SYNCSRC_TE1))
+			mcde_wreg(MCDE_CTRLC1, MCDE_CTRLC1_FIFOWTRMRK(
+					get_output_fifo_size(MCDE_FIFO_C1)));
+	} else {
+
+		switch (chnl->fifo) {
+		case MCDE_FIFO_A:
+			mcde_wreg(MCDE_CHNL0MUXING_V2 + chnl->id *
+				MCDE_CHNL0MUXING_V2_GROUPOFFSET,
+				MCDE_CHNL0MUXING_V2_FIFO_ID_ENUM(FIFO_A));
+			if (port->type == MCDE_PORTTYPE_DPI) {
+				mcde_wfld(MCDE_CTRLA, FORMTYPE,
+						MCDE_CTRLA_FORMTYPE_DPITV);
+				mcde_wfld(MCDE_CTRLA, FORMID, port->link);
+				mcde_wfld(MCDE_CTRLA, FIFOWTRMRK,
+					get_output_fifo_size(MCDE_FIFO_A));
+			} else if (port->type == MCDE_PORTTYPE_DSI) {
+				mcde_wfld(MCDE_CTRLA, FORMTYPE,
+						MCDE_CTRLA_FORMTYPE_DSI);
+				mcde_wfld(MCDE_CTRLA, FORMID,
+							get_dsi_formid(port));
+				mcde_wfld(MCDE_CTRLA, FIFOWTRMRK,
+					get_output_fifo_size(MCDE_FIFO_A));
+			}
+			break;
+		case MCDE_FIFO_B:
+			mcde_wreg(MCDE_CHNL0MUXING_V2 + chnl->id *
+				MCDE_CHNL0MUXING_V2_GROUPOFFSET,
+				MCDE_CHNL0MUXING_V2_FIFO_ID_ENUM(FIFO_B));
+			if (port->type == MCDE_PORTTYPE_DPI) {
+				mcde_wfld(MCDE_CTRLB, FORMTYPE,
+						MCDE_CTRLB_FORMTYPE_DPITV);
+				mcde_wfld(MCDE_CTRLB, FORMID, port->link);
+				mcde_wfld(MCDE_CTRLB, FIFOWTRMRK,
+					get_output_fifo_size(MCDE_FIFO_B));
+			} else if (port->type == MCDE_PORTTYPE_DSI) {
+				mcde_wfld(MCDE_CTRLB, FORMTYPE,
+						MCDE_CTRLB_FORMTYPE_DSI);
+				mcde_wfld(MCDE_CTRLB, FORMID,
+							get_dsi_formid(port));
+				mcde_wfld(MCDE_CTRLB, FIFOWTRMRK,
+					get_output_fifo_size(MCDE_FIFO_B));
+			}
+
+			break;
+		case MCDE_FIFO_C0:
+			mcde_wreg(MCDE_CHNL0MUXING_V2 + chnl->id *
+				MCDE_CHNL0MUXING_V2_GROUPOFFSET,
+				MCDE_CHNL0MUXING_V2_FIFO_ID_ENUM(FIFO_C0));
+			if (port->type == MCDE_PORTTYPE_DPI)
+				return -EINVAL;
+			mcde_wfld(MCDE_CTRLC0, FORMTYPE,
+						MCDE_CTRLC0_FORMTYPE_DSI);
+			mcde_wfld(MCDE_CTRLC0, FORMID, get_dsi_formid(port));
+			mcde_wfld(MCDE_CTRLC0, FIFOWTRMRK,
+					get_output_fifo_size(MCDE_FIFO_C0));
+			break;
+		case MCDE_FIFO_C1:
+			mcde_wreg(MCDE_CHNL0MUXING_V2 + chnl->id *
+				MCDE_CHNL0MUXING_V2_GROUPOFFSET,
+				MCDE_CHNL0MUXING_V2_FIFO_ID_ENUM(FIFO_C1));
+			if (port->type == MCDE_PORTTYPE_DPI)
+				return -EINVAL;
+			mcde_wfld(MCDE_CTRLC1, FORMTYPE,
+						MCDE_CTRLC1_FORMTYPE_DSI);
+			mcde_wfld(MCDE_CTRLC1, FORMID, get_dsi_formid(port));
+			mcde_wfld(MCDE_CTRLC1, FIFOWTRMRK,
+					get_output_fifo_size(MCDE_FIFO_C1));
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	/* Formatter */
+	if (port->type == MCDE_PORTTYPE_DSI) {
+		int i = 0;
+		u8 idx = 2 * port->link + port->ifc;
+		u8 lnk = port->link;
+
+		dsi_wfld(lnk, DSI_MCTL_MAIN_DATA_CTL, LINK_EN, true);
+		dsi_wfld(lnk, DSI_MCTL_MAIN_DATA_CTL, BTA_EN, true);
+		dsi_wfld(lnk, DSI_MCTL_MAIN_DATA_CTL, READ_EN, true);
+		dsi_wfld(lnk, DSI_MCTL_MAIN_DATA_CTL, REG_TE_EN, true);
+		dsi_wreg(lnk, DSI_MCTL_DPHY_STATIC,
+			DSI_MCTL_DPHY_STATIC_UI_X4(port->phy.dsi.ui));
+		dsi_wreg(lnk, DSI_DPHY_LANES_TRIM,
+			DSI_DPHY_LANES_TRIM_DPHY_SPECS_90_81B_ENUM(0_90));
+		dsi_wreg(lnk, DSI_MCTL_DPHY_TIMEOUT,
+			DSI_MCTL_DPHY_TIMEOUT_CLK_DIV(0xf) |
+			DSI_MCTL_DPHY_TIMEOUT_HSTX_TO_VAL(0x3fff) |
+			DSI_MCTL_DPHY_TIMEOUT_LPRX_TO_VAL(0x3fff));
+		dsi_wreg(lnk, DSI_MCTL_MAIN_PHY_CTL,
+			DSI_MCTL_MAIN_PHY_CTL_WAIT_BURST_TIME(0xf) |
+			DSI_MCTL_MAIN_PHY_CTL_LANE2_EN(true) |
+			DSI_MCTL_MAIN_PHY_CTL_CLK_CONTINUOUS(
+				port->phy.dsi.clk_cont));
+		dsi_wreg(lnk, DSI_MCTL_ULPOUT_TIME,
+			DSI_MCTL_ULPOUT_TIME_CKLANE_ULPOUT_TIME(1) |
+			DSI_MCTL_ULPOUT_TIME_DATA_ULPOUT_TIME(1));
+		/* TODO: make enum */
+		dsi_wfld(lnk, DSI_CMD_MODE_CTL, ARB_MODE, false);
+		/* TODO: make enum */
+		dsi_wfld(lnk, DSI_CMD_MODE_CTL, ARB_PRI, port->ifc == 1);
+		dsi_wreg(lnk, DSI_MCTL_MAIN_EN,
+			DSI_MCTL_MAIN_EN_PLL_START(true) |
+			DSI_MCTL_MAIN_EN_CKLANE_EN(true) |
+			DSI_MCTL_MAIN_EN_DAT1_EN(true) |
+			DSI_MCTL_MAIN_EN_DAT2_EN(port->phy.dsi.num_data_lanes
+				== 2) |
+			DSI_MCTL_MAIN_EN_IF1_EN(port->ifc == 0) |
+			DSI_MCTL_MAIN_EN_IF2_EN(port->ifc == 1));
+		while (dsi_rfld(lnk, DSI_MCTL_MAIN_STS, CLKLANE_READY) == 0 ||
+		       dsi_rfld(lnk, DSI_MCTL_MAIN_STS, DAT1_READY) == 0 ||
+		       dsi_rfld(lnk, DSI_MCTL_MAIN_STS, DAT2_READY) == 0) {
+			mdelay(1);
+			if (i++ == 10) {
+				dev_warn(&mcde_dev->dev,
+					"DSI lane not ready (link=%d)!\n", lnk);
+				return -EINVAL;
+			}
+		}
+
+		mcde_wreg(MCDE_DSIVID0CONF0 +
+			idx * MCDE_DSIVID0CONF0_GROUPOFFSET,
+			MCDE_DSIVID0CONF0_BLANKING(0) |
+			MCDE_DSIVID0CONF0_VID_MODE(
+				port->mode == MCDE_PORTMODE_VID) |
+			MCDE_DSIVID0CONF0_CMD8(true) |
+			MCDE_DSIVID0CONF0_BIT_SWAP(false) |
+			MCDE_DSIVID0CONF0_BYTE_SWAP(false) |
+			MCDE_DSIVID0CONF0_DCSVID_NOTGEN(true));
+
+		if (port->mode == MCDE_PORTMODE_CMD) {
+			if (port->ifc == DSI_VIDEO_MODE)
+				dsi_wfld(port->link, DSI_CMD_MODE_CTL, IF1_ID,
+					port->phy.dsi.virt_id);
+			else if (port->ifc == DSI_CMD_MODE)
+				dsi_wfld(port->link, DSI_CMD_MODE_CTL, IF2_ID,
+					port->phy.dsi.virt_id);
+		}
+	}
+
+	mcde_wfld(MCDE_CR, MCDEEN, true);
+
+	dev_vdbg(&mcde_dev->dev, "Static registers setup, chnl=%d\n", chnl->id);
+
+	return 0;
+}
+
+/* REVIEW: Make update_* an mcde_rectangle? */
+static void update_overlay_registers(u8 idx, struct ovly_regs *regs,
+			struct mcde_port *port, enum mcde_fifo fifo,
+			u16 update_x, u16 update_y, u16 update_w,
+			u16 update_h, u16 stride, bool interlaced)
+{
+	/* TODO: fix clipping for small overlay */
+	u32 lmrgn = (regs->cropx + update_x) * regs->bits_per_pixel;
+	u32 tmrgn = (regs->cropy + update_y) * stride;
+	u32 ppl = regs->ppl - update_x;
+	u32 lpf = regs->lpf - update_y;
+	u32 ljinc = stride;
+	u32 pixelfetchwtrmrklevel;
+	u8  nr_of_bufs = 1;
+	u32 fifo_size;
+
+	/* TODO: disable if everything clipped */
+	if (!regs->enabled) {
+		u32 temp;
+		temp = mcde_rreg(MCDE_OVL0CR + idx * MCDE_OVL0CR_GROUPOFFSET);
+		mcde_wreg(MCDE_OVL0CR + idx * MCDE_OVL0CR_GROUPOFFSET,
+			(temp & ~MCDE_OVL0CR_OVLEN_MASK) |
+			MCDE_OVL0CR_OVLEN(false));
+		return;
+	}
+
+	/*
+	* TODO: Preferably most of this is done in some apply function instead
+	* of every update. Problem is however that at overlay apply
+	* there is no port type info available (and the question is
+	* whether it is appropriate to add a port type there).
+	* Note that lpf has a dependency on update_y.
+	*/
+	if (port->type == MCDE_PORTTYPE_DPI)
+		/* REVIEW: Why not for DSI? enable in regs? */
+		regs->col_conv = MCDE_OVL0CR_COLCCTRL_ENABLED_NO_SAT;
+	else if (port->type == MCDE_PORTTYPE_DSI) {
+		if (port->pixel_format == MCDE_PORTPIXFMT_DSI_YCBCR422)
+			regs->col_conv = MCDE_OVL0CR_COLCCTRL_ENABLED_NO_SAT;
+		else
+			regs->col_conv = MCDE_OVL0CR_COLCCTRL_DISABLED;
+		if (interlaced) {
+			nr_of_bufs = 2;
+			lpf = lpf / 2;
+			ljinc *= 2;
+		}
+	}
+
+	fifo_size = get_output_fifo_size(fifo);
+#ifdef CONFIG_AV8100_SDTV
+	/* TODO: check if these watermark levels work for HDMI as well. */
+	pixelfetchwtrmrklevel = MCDE_PIXFETCH_SMALL_WTRMRKLVL;
+#else
+	if ((fifo == MCDE_FIFO_A || fifo == MCDE_FIFO_B) &&
+					regs->ppl >= fifo_size * 2)
+		pixelfetchwtrmrklevel = MCDE_PIXFETCH_LARGE_WTRMRKLVL;
+	else
+		pixelfetchwtrmrklevel = MCDE_PIXFETCH_MEDIUM_WTRMRKLVL;
+#endif /* CONFIG_AV8100_SDTV */
+
+	if (regs->reset_buf_id) {
+		u32 sel_mod = MCDE_EXTSRC0CR_SEL_MOD_SOFTWARE_SEL;
+		if (port->update_auto_trig && port->type == MCDE_PORTTYPE_DSI) {
+			switch (port->sync_src) {
+			case MCDE_SYNCSRC_OFF:
+				sel_mod = MCDE_EXTSRC0CR_SEL_MOD_SOFTWARE_SEL;
+				break;
+			case MCDE_SYNCSRC_TE0:
+			case MCDE_SYNCSRC_TE1:
+			default:
+				sel_mod = MCDE_EXTSRC0CR_SEL_MOD_AUTO_TOGGLE;
+			}
+		} else if (port->type == MCDE_PORTTYPE_DPI) {
+			sel_mod = port->update_auto_trig ?
+					MCDE_EXTSRC0CR_SEL_MOD_AUTO_TOGGLE :
+					MCDE_EXTSRC0CR_SEL_MOD_SOFTWARE_SEL;
+		}
+
+		regs->reset_buf_id = false;
+		mcde_wreg(MCDE_EXTSRC0CONF + idx * MCDE_EXTSRC0CONF_GROUPOFFSET,
+			MCDE_EXTSRC0CONF_BUF_ID(0) |
+			MCDE_EXTSRC0CONF_BUF_NB(nr_of_bufs) |
+			MCDE_EXTSRC0CONF_PRI_OVLID(idx) |
+			MCDE_EXTSRC0CONF_BPP(regs->bpp) |
+			MCDE_EXTSRC0CONF_BGR(regs->bgr) |
+			MCDE_EXTSRC0CONF_BEBO(regs->bebo) |
+			MCDE_EXTSRC0CONF_BEPO(false));
+		mcde_wreg(MCDE_EXTSRC0CR + idx * MCDE_EXTSRC0CR_GROUPOFFSET,
+			MCDE_EXTSRC0CR_SEL_MOD(sel_mod) |
+			MCDE_EXTSRC0CR_MULTIOVL_CTRL_ENUM(PRIMARY) |
+			MCDE_EXTSRC0CR_FS_DIV_DISABLE(false) |
+			MCDE_EXTSRC0CR_FORCE_FS_DIV(false));
+		mcde_wreg(MCDE_OVL0CR + idx * MCDE_OVL0CR_GROUPOFFSET,
+			MCDE_OVL0CR_OVLEN(true) |
+		MCDE_OVL0CR_COLCCTRL(regs->col_conv) |
+			MCDE_OVL0CR_CKEYGEN(false) |
+			MCDE_OVL0CR_ALPHAPMEN(true) |
+			MCDE_OVL0CR_OVLF(false) |
+			MCDE_OVL0CR_OVLR(false) |
+			MCDE_OVL0CR_OVLB(false) |
+			MCDE_OVL0CR_FETCH_ROPC(0) |
+			MCDE_OVL0CR_STBPRIO(0) |
+			MCDE_OVL0CR_BURSTSIZE_ENUM(HW_8W) |
+			/* TODO: enum, get from ovly */
+			MCDE_OVL0CR_MAXOUTSTANDING_ENUM(4_REQ) |
+			/* TODO: _HW_8W, calculate? */
+			MCDE_OVL0CR_ROTBURSTSIZE_ENUM(HW_8W));
+		mcde_wreg(MCDE_OVL0CONF + idx * MCDE_OVL0CONF_GROUPOFFSET,
+			MCDE_OVL0CONF_PPL(ppl) |
+			MCDE_OVL0CONF_EXTSRC_ID(idx) |
+			MCDE_OVL0CONF_LPF(lpf));
+		mcde_wreg(MCDE_OVL0CONF2 + idx * MCDE_OVL0CONF2_GROUPOFFSET,
+			MCDE_OVL0CONF2_BP_ENUM(PER_PIXEL_ALPHA) |
+			/* TODO: Allow setting? */
+			MCDE_OVL0CONF2_ALPHAVALUE(0xff) |
+			MCDE_OVL0CONF2_OPQ(regs->opq) |
+			MCDE_OVL0CONF2_PIXOFF(lmrgn & 63) |
+			MCDE_OVL0CONF2_PIXELFETCHERWATERMARKLEVEL(
+				pixelfetchwtrmrklevel));
+		mcde_wreg(MCDE_OVL0LJINC + idx * MCDE_OVL0LJINC_GROUPOFFSET,
+			ljinc);
+		mcde_wreg(MCDE_OVL0CROP + idx * MCDE_OVL0CROP_GROUPOFFSET,
+			MCDE_OVL0CROP_TMRGN(tmrgn) |
+			MCDE_OVL0CROP_LMRGN(lmrgn >> 6));
+		mcde_wreg(MCDE_OVL0COMP + idx * MCDE_OVL0COMP_GROUPOFFSET,
+			MCDE_OVL0COMP_XPOS(regs->xpos) |
+			MCDE_OVL0COMP_CH_ID(regs->ch_id) |
+			MCDE_OVL0COMP_YPOS(regs->ypos) |
+			MCDE_OVL0COMP_Z(regs->z));
+	}
+
+	dev_vdbg(&mcde_dev->dev, "Overlay registers setup, idx=%d\n", idx);
+}
+
+static void update_overlay_address_registers(u8 idx, struct ovly_regs *regs)
+{
+	mcde_wreg(MCDE_EXTSRC0A0 + idx * MCDE_EXTSRC0A0_GROUPOFFSET,
+		regs->baseaddress0);
+	mcde_wreg(MCDE_EXTSRC0A1 + idx * MCDE_EXTSRC0A1_GROUPOFFSET,
+		regs->baseaddress1);
+}
+
+#define MCDE_FLOWEN_MAX_TRIAL	6
+
+static void disable_channel(struct mcde_chnl_state *chnl)
+{
+	int i;
+	const struct mcde_port *port = &chnl->port;
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+
+	if (hardware_version == MCDE_CHIP_VERSION_3_0_8 &&
+				!is_channel_enabled(chnl)) {
+		chnl->continous_running = false;
+		return;
+	}
+
+	if (port->type == MCDE_PORTTYPE_DSI)
+		dsi_wfld(port->link, DSI_MCTL_MAIN_PHY_CTL, CLK_CONTINUOUS,
+			false);
+
+	channel_pixelprocessing_disable(chnl);
+
+	channel_flow_disable(chnl);
+
+	wait_for_channel(chnl);
+
+	for (i = 0; i < MCDE_FLOWEN_MAX_TRIAL; i++) {
+		if (hardware_version == MCDE_CHIP_VERSION_3_0_5)
+			msleep(1);
+		if (!is_channel_enabled(chnl)) {
+			dev_vdbg(&mcde_dev->dev,
+				"%s: Flow %d after >= %d ms\n"
+						, __func__, chnl->id, i);
+			chnl->continous_running = false;
+			return;
+		}
+		if (hardware_version == MCDE_CHIP_VERSION_3_0_8)
+			msleep(5);
+	}
+	/*
+	* For MCDE 3.0.5.8 and forward if this occurs the last frame
+	* is still in progress then reconsider the delay and the
+	* MAX_TRAIL value to match the refresh rate of the display
+	*/
+	dev_warn(&mcde_dev->dev, "%s: Flow %d timeout\n"
+						, __func__, chnl->id);
+}
+static void enable_channel(struct mcde_chnl_state *chnl)
+{
+	const struct mcde_port *port = &chnl->port;
+	int i;
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+
+	if (port->type == MCDE_PORTTYPE_DSI)
+		dsi_wfld(port->link, DSI_MCTL_MAIN_PHY_CTL, CLK_CONTINUOUS,
+				port->phy.dsi.clk_cont);
+
+	channel_flow_enable(chnl);
+
+	if (hardware_version == MCDE_CHIP_VERSION_3_0_8) {
+		for (i = 0; i < MCDE_FLOWEN_MAX_TRIAL; i++) {
+			if (is_channel_enabled(chnl)) {
+				dev_vdbg(&mcde_dev->dev,
+				"Flow %d enable after >= %d ms\n"
+							, chnl->id, i*5);
+				return;
+			}
+			msleep(5);
+		}
+		dev_warn(&mcde_dev->dev, "%s: channel %d timeout\n",
+							__func__, chnl->id);
+	}
+}
+#undef MCDE_FLOWEN_MAX_TRIAL
+
+static void watchdog_auto_sync_timer_function(unsigned long arg)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(channels); i++) {
+		struct mcde_chnl_state *chnl = &channels[i];
+		if (chnl->port.update_auto_trig &&
+				chnl->port.sync_src == MCDE_SYNCSRC_OFF &&
+				chnl->port.type == MCDE_PORTTYPE_DSI &&
+				chnl->continous_running) {
+			mcde_wreg(MCDE_CHNL0SYNCHSW +
+				chnl->id
+				* MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+				MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+			mod_timer(&chnl->auto_sync_timer,
+				jiffies +
+				msecs_to_jiffies(MCDE_AUTO_SYNC_WATCHDOG
+								* 1000));
+		}
+	}
+}
+
+/* TODO get from register */
+#define MCDE_CLK_FREQ_MHZ 160
+
+void update_channel_registers(enum mcde_chnl chnl_id, struct chnl_regs *regs,
+				struct mcde_port *port, enum mcde_fifo fifo,
+				struct mcde_video_mode *video_mode)
+{
+	u8 idx = chnl_id;
+	u32 out_synch_src = MCDE_CHNL0SYNCHMOD_OUT_SYNCH_SRC_FORMATTER;
+	u32 src_synch = MCDE_CHNL0SYNCHMOD_SRC_SYNCH_SOFTWARE;
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+	/* Channel */
+	if (port->update_auto_trig && port->type == MCDE_PORTTYPE_DSI) {
+		switch (port->sync_src) {
+		case MCDE_SYNCSRC_TE0:
+			out_synch_src = MCDE_CHNL0SYNCHMOD_OUT_SYNCH_SRC_VSYNC0;
+			src_synch = MCDE_CHNL0SYNCHMOD_SRC_SYNCH_OUTPUT;
+			break;
+		case MCDE_SYNCSRC_OFF:
+			src_synch = MCDE_CHNL0SYNCHMOD_SRC_SYNCH_SOFTWARE;
+			break;
+		case MCDE_SYNCSRC_TE1:
+		default:
+			out_synch_src = MCDE_CHNL0SYNCHMOD_OUT_SYNCH_SRC_VSYNC1;
+			src_synch = MCDE_CHNL0SYNCHMOD_SRC_SYNCH_OUTPUT;
+		}
+	} else if (port->type == MCDE_PORTTYPE_DPI) {
+		src_synch = port->update_auto_trig ?
+					MCDE_CHNL0SYNCHMOD_SRC_SYNCH_OUTPUT :
+					MCDE_CHNL0SYNCHMOD_SRC_SYNCH_SOFTWARE;
+	}
+
+	mcde_wreg(MCDE_CHNL0CONF + idx * MCDE_CHNL0CONF_GROUPOFFSET,
+		MCDE_CHNL0CONF_PPL(regs->ppl-1) |
+		MCDE_CHNL0CONF_LPF(regs->lpf-1));
+	mcde_wreg(MCDE_CHNL0STAT + idx * MCDE_CHNL0STAT_GROUPOFFSET,
+		MCDE_CHNL0STAT_CHNLBLBCKGND_EN(false) |
+		MCDE_CHNL0STAT_CHNLRD(true));
+	mcde_wreg(MCDE_CHNL0SYNCHMOD +
+		idx * MCDE_CHNL0SYNCHMOD_GROUPOFFSET,
+		MCDE_CHNL0SYNCHMOD_SRC_SYNCH(src_synch) |
+		MCDE_CHNL0SYNCHMOD_OUT_SYNCH_SRC(out_synch_src));
+	mcde_wreg(MCDE_CHNL0BCKGNDCOL + idx * MCDE_CHNL0BCKGNDCOL_GROUPOFFSET,
+		MCDE_CHNL0BCKGNDCOL_B(0) |
+		MCDE_CHNL0BCKGNDCOL_G(0) |
+		MCDE_CHNL0BCKGNDCOL_R(0));
+
+	switch (chnl_id) {
+	case MCDE_CHNL_A:
+		if (port->type == MCDE_PORTTYPE_DPI) {
+			mcde_wreg(MCDE_CRA1,
+				MCDE_CRA1_CLKSEL_ENUM(EXT_TV1) |
+				MCDE_CRA1_OUTBPP(bpp2outbpp(regs->bpp)) |
+				MCDE_CRA1_BCD(1)
+			);
+		} else {
+			mcde_wreg(MCDE_CRA1, MCDE_CRA1_CLKSEL_ENUM(166MHZ));
+		}
+		break;
+	case MCDE_CHNL_B:
+		if (port->type == MCDE_PORTTYPE_DPI) {
+			mcde_wreg(MCDE_CRB1,
+				MCDE_CRB1_CLKSEL_ENUM(EXT_TV2) |
+				MCDE_CRB1_OUTBPP(bpp2outbpp(regs->bpp)) |
+				MCDE_CRB1_BCD(1)
+			);
+		} else {
+			mcde_wreg(MCDE_CRB1, MCDE_CRB1_CLKSEL_ENUM(166MHZ));
+		}
+		break;
+	default:
+		break;
+	}
+
+	/* Formatter */
+	if (port->type == MCDE_PORTTYPE_DSI) {
+		u8 fidx = 2 * port->link + port->ifc;
+		u32 temp, packet;
+		/* pkt_div is used to avoid underflow in output fifo for
+		 * large packets */
+		u32 pkt_div = 1;
+		u32 dsi_delay0 = 0;
+		u32 screen_ppl, screen_lpf;
+
+		screen_ppl = video_mode->xres;
+		screen_lpf = video_mode->yres;
+
+		if  (screen_ppl == 1920) {
+			pkt_div = (screen_ppl - 1) /
+			get_output_fifo_size(fifo) + 1;
+		} else {
+			pkt_div = screen_ppl /
+			(get_output_fifo_size(fifo) * 2) + 1;
+		}
+
+		if (video_mode->interlaced)
+			screen_lpf /= 2;
+
+		/* pkt_delay_progressive = pixelclock * htot /
+		 * (1E12 / 160E6) / pkt_div */
+		dsi_delay0 = (video_mode->pixclock + 1) *
+			(video_mode->xres + video_mode->hbp +
+				video_mode->hfp) /
+			(1000000 / MCDE_CLK_FREQ_MHZ) / pkt_div;
+		temp = mcde_rreg(MCDE_DSIVID0CONF0 +
+			fidx * MCDE_DSIVID0CONF0_GROUPOFFSET);
+		mcde_wreg(MCDE_DSIVID0CONF0 +
+			fidx * MCDE_DSIVID0CONF0_GROUPOFFSET,
+			(temp & ~MCDE_DSIVID0CONF0_PACKING_MASK) |
+			MCDE_DSIVID0CONF0_PACKING(regs->dsipacking));
+		/* 1==CMD8 */
+		packet = ((screen_ppl / pkt_div * regs->bpp) >> 3) + 1;
+		mcde_wreg(MCDE_DSIVID0FRAME +
+			fidx * MCDE_DSIVID0FRAME_GROUPOFFSET,
+			MCDE_DSIVID0FRAME_FRAME(packet * pkt_div * screen_lpf));
+		mcde_wreg(MCDE_DSIVID0PKT + fidx * MCDE_DSIVID0PKT_GROUPOFFSET,
+			MCDE_DSIVID0PKT_PACKET(packet));
+		mcde_wreg(MCDE_DSIVID0SYNC +
+			fidx * MCDE_DSIVID0SYNC_GROUPOFFSET,
+			MCDE_DSIVID0SYNC_SW(0) |
+			MCDE_DSIVID0SYNC_DMA(0));
+		mcde_wreg(MCDE_DSIVID0CMDW +
+			fidx * MCDE_DSIVID0CMDW_GROUPOFFSET,
+			MCDE_DSIVID0CMDW_CMDW_START(DCS_CMD_WRITE_START) |
+			MCDE_DSIVID0CMDW_CMDW_CONTINUE(DCS_CMD_WRITE_CONTINUE));
+		mcde_wreg(MCDE_DSIVID0DELAY0 +
+			fidx * MCDE_DSIVID0DELAY0_GROUPOFFSET,
+			MCDE_DSIVID0DELAY0_INTPKTDEL(dsi_delay0));
+		mcde_wreg(MCDE_DSIVID0DELAY1 +
+			fidx * MCDE_DSIVID0DELAY1_GROUPOFFSET,
+			MCDE_DSIVID0DELAY1_TEREQDEL(0) |
+			MCDE_DSIVID0DELAY1_FRAMESTARTDEL(0));
+	}
+
+	if (regs->roten) {
+		/* TODO: Allocate memory in ESRAM instead of
+				static allocations. */
+		mcde_wreg(MCDE_ROTADD0A + chnl_id * MCDE_ROTADD0A_GROUPOFFSET,
+			regs->rotbuf1);
+		mcde_wreg(MCDE_ROTADD1A + chnl_id * MCDE_ROTADD1A_GROUPOFFSET,
+			regs->rotbuf2);
+
+		mcde_wreg(MCDE_ROTACONF + chnl_id * MCDE_ROTACONF_GROUPOFFSET,
+			MCDE_ROTACONF_ROTBURSTSIZE_ENUM(8W) |
+			MCDE_ROTACONF_ROTBURSTSIZE_HW(1) |
+			MCDE_ROTACONF_ROTDIR(regs->rotdir) |
+			MCDE_ROTACONF_STRIP_WIDTH_ENUM(16PIX) |
+			MCDE_ROTACONF_RD_MAXOUT_ENUM(4_REQ) |
+			MCDE_ROTACONF_WR_MAXOUT_ENUM(8_REQ));
+		if (chnl_id == MCDE_CHNL_A) {
+			mcde_wfld(MCDE_CRA0, ROTEN, true);
+			mcde_wfld(MCDE_CRA1, CLKSEL, MCDE_CRA1_CLKSEL_166MHZ);
+			mcde_wfld(MCDE_CRA1, OUTBPP, bpp2outbpp(regs->bpp));
+			mcde_wfld(MCDE_CRA1, BCD, true);
+		} else if (chnl_id == MCDE_CHNL_B) {
+			mcde_wfld(MCDE_CRB0, ROTEN, true);
+			mcde_wfld(MCDE_CRB1, CLKSEL, MCDE_CRB1_CLKSEL_166MHZ);
+			mcde_wfld(MCDE_CRB1, OUTBPP, bpp2outbpp(regs->bpp));
+			mcde_wfld(MCDE_CRB1, BCD, true);
+		}
+	} else {
+		if (chnl_id == MCDE_CHNL_A)
+			mcde_wfld(MCDE_CRA0, ROTEN, false);
+		else if (chnl_id == MCDE_CHNL_B)
+			mcde_wfld(MCDE_CRB0, ROTEN, false);
+	}
+
+	dev_vdbg(&mcde_dev->dev, "Channel registers setup, chnl=%d\n", chnl_id);
+}
+
+/* DSI */
+
+int mcde_dsi_dcs_write(struct mcde_chnl_state *chnl, u8 cmd, u8* data, int len)
+{
+	int i;
+	u32 wrdat[4] = { 0, 0, 0, 0 };
+	u32 settings;
+	u8 link = chnl->port.link;
+	u8 virt_id = chnl->port.phy.dsi.virt_id;
+
+	/* REVIEW: One command at a time */
+	/* REVIEW: Allow read/write on unreserved ports */
+	if (len > MCDE_MAX_DCS_WRITE || chnl->port.type != MCDE_PORTTYPE_DSI)
+		return -EINVAL;
+
+	wrdat[0] = cmd;
+	for (i = 1; i <= len; i++)
+		wrdat[i>>2] |= ((u32)data[i-1] << ((i & 3) * 8));
+
+	settings = DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_NAT_ENUM(WRITE) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_LONGNOTSHORT(len > 1) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_ID(virt_id) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_SIZE(len+1) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_LP_EN(true);
+	if (len == 0)
+		settings |= DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_HEAD_ENUM(
+			DCS_SHORT_WRITE_0);
+	else if (len == 1)
+		settings |= DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_HEAD_ENUM(
+			DCS_SHORT_WRITE_1);
+	else
+		settings |= DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_HEAD_ENUM(
+			DCS_LONG_WRITE);
+
+	dsi_wreg(link, DSI_DIRECT_CMD_MAIN_SETTINGS, settings);
+	dsi_wreg(link, DSI_DIRECT_CMD_WRDAT0, wrdat[0]);
+	if (len >  3)
+		dsi_wreg(link, DSI_DIRECT_CMD_WRDAT1, wrdat[1]);
+	if (len >  7)
+		dsi_wreg(link, DSI_DIRECT_CMD_WRDAT2, wrdat[2]);
+	if (len > 11)
+		dsi_wreg(link, DSI_DIRECT_CMD_WRDAT3, wrdat[3]);
+	dsi_wreg(link, DSI_DIRECT_CMD_STS_CLR, ~0);
+	dsi_wreg(link, DSI_DIRECT_CMD_SEND, true);
+
+	/* TODO: irq wait and error check */
+	mdelay(10);
+	dsi_wreg(link, DSI_CMD_MODE_STS_CLR, ~0);
+	dsi_wreg(link, DSI_DIRECT_CMD_STS_CLR, ~0);
+
+	return 0;
+}
+
+int mcde_dsi_dcs_read(struct mcde_chnl_state *chnl, u8 cmd, u8* data, int *len)
+{
+	int ret = 0;
+	u8 link = chnl->port.link;
+	u8 virt_id = chnl->port.phy.dsi.virt_id;
+	u32 settings;
+	int wait = 100;
+	bool error, ok;
+
+	if (*len > MCDE_MAX_DCS_READ || chnl->port.type != MCDE_PORTTYPE_DSI)
+		return -EINVAL;
+
+	dsi_wfld(link, DSI_MCTL_MAIN_DATA_CTL, BTA_EN, true);
+	dsi_wfld(link, DSI_MCTL_MAIN_DATA_CTL, READ_EN, true);
+	settings = DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_NAT_ENUM(READ) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_LONGNOTSHORT(false) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_ID(virt_id) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_SIZE(1) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_LP_EN(true) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_HEAD_ENUM(DCS_READ);
+	dsi_wreg(link, DSI_DIRECT_CMD_MAIN_SETTINGS, settings);
+	dsi_wreg(link, DSI_DIRECT_CMD_WRDAT0, cmd);
+	dsi_wreg(link, DSI_DIRECT_CMD_STS_CLR, ~0);
+	dsi_wreg(link, DSI_DIRECT_CMD_RD_STS_CLR, ~0);
+	dsi_wreg(link, DSI_DIRECT_CMD_SEND, true);
+
+	/* TODO */
+	while (wait-- && !(error = dsi_rfld(link, DSI_DIRECT_CMD_STS,
+		READ_COMPLETED_WITH_ERR)) && !(ok = dsi_rfld(link,
+		DSI_DIRECT_CMD_STS, READ_COMPLETED)))
+		mdelay(10);
+
+	if (ok) {
+		int rdsize;
+		u32 rddat;
+
+		rdsize = dsi_rfld(link, DSI_DIRECT_CMD_RD_PROPERTY, RD_SIZE);
+		rddat = dsi_rreg(link, DSI_DIRECT_CMD_RDDAT);
+		if (rdsize < *len)
+			pr_debug("DCS incomplete read %d<%d (%.8X)\n",
+				rdsize, *len, rddat);/* REVIEW: dev_dbg */
+		*len = min(*len, rdsize);
+		memcpy(data, &rddat, *len);
+	} else {
+		pr_err("DCS read failed, err=%d, sts=%X\n",
+			error, dsi_rreg(link, DSI_DIRECT_CMD_STS));
+		ret = -EIO;
+	}
+
+	dsi_wreg(link, DSI_CMD_MODE_STS_CLR, ~0);
+	dsi_wreg(link, DSI_DIRECT_CMD_STS_CLR, ~0);
+
+	return ret;
+}
+
+static void dsi_te_request(struct mcde_chnl_state *chnl)
+{
+	u8 link = chnl->port.link;
+	u8 virt_id = chnl->port.phy.dsi.virt_id;
+	u32 settings;
+
+	dev_vdbg(&mcde_dev->dev, "Request BTA TE, chnl=%d\n",
+		chnl->id);
+
+	dsi_wfld(link, DSI_MCTL_MAIN_DATA_CTL, BTA_EN, true);
+	dsi_wfld(link, DSI_MCTL_MAIN_DATA_CTL, REG_TE_EN, true);
+	dsi_wfld(link, DSI_CMD_MODE_CTL, TE_TIMEOUT, 0x3FF);
+	settings = DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_NAT_ENUM(TE_REQ) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_LONGNOTSHORT(false) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_ID(virt_id) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_SIZE(2) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_LP_EN(true) |
+		DSI_DIRECT_CMD_MAIN_SETTINGS_CMD_HEAD_ENUM(DCS_SHORT_WRITE_1);
+	dsi_wreg(link, DSI_DIRECT_CMD_MAIN_SETTINGS, settings);
+	dsi_wreg(link, DSI_DIRECT_CMD_WRDAT0, DCS_CMD_SET_TEAR_ON);
+	dsi_wreg(link, DSI_DIRECT_CMD_STS_CLR,
+		DSI_DIRECT_CMD_STS_CLR_TE_RECEIVED_CLR(true));
+	dsi_wfld(link, DSI_DIRECT_CMD_STS_CTL, TE_RECEIVED_EN, true);
+	dsi_wreg(link, DSI_CMD_MODE_STS_CLR,
+		DSI_CMD_MODE_STS_CLR_ERR_NO_TE_CLR(true));
+	dsi_wfld(link, DSI_CMD_MODE_STS_CTL, ERR_NO_TE_EN, true);
+	dsi_wreg(link, DSI_DIRECT_CMD_SEND, true);
+}
+
+/* MCDE channels */
+struct mcde_chnl_state *mcde_chnl_get(enum mcde_chnl chnl_id,
+	enum mcde_fifo fifo, const struct mcde_port *port)
+{
+	int i;
+	struct mcde_chnl_state *chnl = NULL;
+	enum mcde_chnl_path path;
+	const struct chnl_config *cfg = NULL;
+
+	/* Allocate channel */
+	for (i = 0; i < ARRAY_SIZE(channels); i++) {
+		if (chnl_id == channels[i].id)
+			chnl = &channels[i];
+	}
+	if (!chnl) {
+		dev_dbg(&mcde_dev->dev, "Invalid channel, chnl=%d\n", chnl_id);
+		return ERR_PTR(-EINVAL);
+	}
+	if (chnl->inuse) {
+		dev_dbg(&mcde_dev->dev, "Channel in use, chnl=%d\n", chnl_id);
+		return ERR_PTR(-EBUSY);
+	}
+
+	if (hardware_version == MCDE_CHIP_VERSION_3_0_5) {
+		path = MCDE_CHNLPATH(chnl->id, fifo, port->type, port->ifc,
+								port->link);
+		for (i = 0; i < ARRAY_SIZE(chnl_configs); i++)
+			if (chnl_configs[i].path == path) {
+				cfg = &chnl_configs[i];
+				break;
+			}
+		if (cfg == NULL) {
+			dev_dbg(&mcde_dev->dev, "Invalid config, chnl=%d,"
+					" path=0x%.8X\n", chnl_id, path);
+			return ERR_PTR(-EINVAL);
+		} else
+			dev_info(&mcde_dev->dev, "Config, chnl=%d,"
+					" path=0x%.8X\n", chnl_id, path);
+
+		/*
+		* TODO: verify that cfg is ok to activate
+		* (check other chnl cfgs)
+		*/
+	}
+
+	chnl->cfg = cfg;
+	chnl->port = *port;
+	chnl->fifo = fifo;
+
+	if (!mcde_is_enabled) {
+		int ret;
+		ret = enable_clocks_and_power(mcde_dev);
+		if (ret < 0) {
+			dev_dbg(&mcde_dev->dev,
+				"%s: Enable clocks and power failed\n"
+							, __func__);
+			return ERR_PTR(-EINVAL);
+		}
+		update_mcde_registers();
+		mcde_is_enabled = true;
+	}
+
+	if (update_channel_static_registers(chnl) < 0)
+		return ERR_PTR(-EINVAL);
+
+	chnl->synchronized_update = true;
+	chnl->pix_fmt = port->pixel_format;
+	mcde_chnl_apply(chnl);
+	chnl->inuse = true;
+
+	return chnl;
+}
+
+int mcde_chnl_set_pixel_format(struct mcde_chnl_state *chnl,
+	enum mcde_port_pix_fmt pix_fmt)
+{
+	if (!chnl->inuse)
+		return -EINVAL;
+	chnl->pix_fmt = pix_fmt;
+	return 0;
+}
+
+void mcde_chnl_set_col_convert(struct mcde_chnl_state *chnl,
+					struct mcde_col_convert *col_convert)
+{
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+	chnl->col_regs.y_red     = col_convert->matrix[0][0];
+	chnl->col_regs.y_green   = col_convert->matrix[0][1];
+	chnl->col_regs.y_blue    = col_convert->matrix[0][2];
+	chnl->col_regs.cb_red    = col_convert->matrix[1][0];
+	chnl->col_regs.cb_green  = col_convert->matrix[1][1];
+	chnl->col_regs.cb_blue   = col_convert->matrix[1][2];
+	chnl->col_regs.cr_red    = col_convert->matrix[2][0];
+	chnl->col_regs.cr_green  = col_convert->matrix[2][1];
+	chnl->col_regs.cr_blue   = col_convert->matrix[2][2];
+	chnl->col_regs.off_red   = col_convert->offset[0];
+	chnl->col_regs.off_green = col_convert->offset[1];
+	chnl->col_regs.off_blue  = col_convert->offset[2];
+}
+
+int mcde_chnl_set_rotation(struct mcde_chnl_state *chnl,
+	enum mcde_display_rotation rotation, u32 rotbuf1, u32 rotbuf2)
+{
+	if (!chnl->inuse)
+		return -EINVAL;
+
+	/* TODO: Fix 180 degrees rotation */
+	if (rotation == MCDE_DISPLAY_ROT_180_CCW ||
+		(chnl->id != MCDE_CHNL_A && chnl->id != MCDE_CHNL_B))
+		return -EINVAL;
+
+	chnl->rotation = rotation;
+	chnl->rotbuf1  = rotbuf1;
+	chnl->rotbuf2  = rotbuf2;
+
+	return 0;
+}
+
+int mcde_chnl_enable_synchronized_update(struct mcde_chnl_state *chnl,
+	bool enable)
+{
+	if (!chnl->inuse)
+		return -EINVAL;
+	chnl->synchronized_update = enable;
+	return 0;
+}
+
+int mcde_chnl_set_power_mode(struct mcde_chnl_state *chnl,
+	enum mcde_display_power_mode power_mode)
+{
+	if (!chnl->inuse)
+		return -EINVAL;
+
+	chnl->power_mode = power_mode;
+	return 0;
+}
+
+int mcde_chnl_apply(struct mcde_chnl_state *chnl)
+{
+	/* TODO: lock *//* REVIEW: MCDE locking! */
+	bool roten = false;
+	u8 rotdir = 0;
+
+	if (!chnl->inuse)
+		return -EINVAL;
+
+	if (chnl->rotation == MCDE_DISPLAY_ROT_90_CCW) {
+		roten = true;
+		rotdir = MCDE_ROTACONF_ROTDIR_CCW;
+	} else if (chnl->rotation == MCDE_DISPLAY_ROT_90_CW) {
+		roten = true;
+		rotdir = MCDE_ROTACONF_ROTDIR_CW;
+	}
+	/* REVIEW: 180 deg? */
+
+	chnl->regs.bpp = portfmt2bpp(chnl->pix_fmt);
+	chnl->regs.synchronized_update = chnl->synchronized_update;
+	chnl->regs.roten = roten;
+	chnl->regs.rotdir = rotdir;
+	chnl->regs.rotbuf1 = chnl->rotbuf1;
+	chnl->regs.rotbuf2 = chnl->rotbuf2;
+	if (chnl->port.type == MCDE_PORTTYPE_DSI)
+		chnl->regs.dsipacking = portfmt2dsipacking(chnl->pix_fmt);
+	else if (chnl->port.type == MCDE_PORTTYPE_DPI)
+		tv_video_mode_apply(chnl);
+	chnl->transactionid++;
+
+	dev_vdbg(&mcde_dev->dev, "Channel applied, chnl=%d\n", chnl->id);
+	return 0;
+}
+
+static void chnl_update_registers(struct mcde_chnl_state *chnl)
+{
+	/* REVIEW: Move content to update_channel_register */
+	/* and remove this one */
+	if (chnl->port.type == MCDE_PORTTYPE_DPI)
+		update_tv_registers(chnl->id, &chnl->tv_regs);
+	if (chnl->id == MCDE_CHNL_A || chnl->id == MCDE_CHNL_B)
+		update_col_registers(chnl->id, &chnl->col_regs);
+	update_channel_registers(chnl->id, &chnl->regs, &chnl->port,
+						chnl->fifo, &chnl->vmode);
+
+	chnl->transactionid_regs = chnl->transactionid;
+}
+
+static void chnl_update_continous(struct mcde_chnl_state *chnl)
+{
+	if (!chnl->continous_running) {
+		if (chnl->transactionid_regs < chnl->transactionid)
+			chnl_update_registers(chnl);
+
+		if (chnl->port.sync_src == MCDE_SYNCSRC_TE0)
+			mcde_wfld(MCDE_CRC, SYCEN0, true);
+		else if (chnl->port.sync_src == MCDE_SYNCSRC_TE1)
+			mcde_wfld(MCDE_CRC, SYCEN1, true);
+
+		chnl->continous_running = true;
+
+		enable_channel(chnl);
+
+		if (chnl->port.type == MCDE_PORTTYPE_DSI &&
+				chnl->port.sync_src == MCDE_SYNCSRC_OFF) {
+			/*
+			* For main and secondary display,
+			* FLOWEN has to be set before a SOFTWARE TRIG
+			* Otherwise not overlay interrupt is triggerd
+			*/
+			/*
+			* In MCDE_CHIP_VERSION_3_0_5 an VCOMP Irq was
+			* triggered after FLOEN = true but this does not
+			* happen in 3_0_8 and therefor SW_TRIG is added
+			*/
+			if (hardware_version == MCDE_CHIP_VERSION_3_0_8)
+				mcde_wreg(MCDE_CHNL0SYNCHSW +
+				chnl->id * MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+				MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+
+			mod_timer(&chnl->auto_sync_timer,
+					jiffies +
+			msecs_to_jiffies(MCDE_AUTO_SYNC_WATCHDOG * 1000));
+		}
+	}
+}
+
+static void chnl_update_non_continous(struct mcde_chnl_state *chnl)
+{
+	/* Commit settings to registers */
+	wait_for_channel(chnl);
+	if (chnl->transactionid_regs < chnl->transactionid)
+		chnl_update_registers(chnl);
+
+	/*
+	* For main and secondary display,
+	* FLOWEN has to be set before a SOFTWARE TRIG
+	* Otherwise not overlay interrupt is triggerd
+	* However FLOWEN must not be triggered before SOFTWARE TRIG
+	* if rotation is enabled
+	*/
+	if (hardware_version == MCDE_CHIP_VERSION_3_0_8 ||
+			(chnl->power_mode == MCDE_DISPLAY_PM_STANDBY ||
+							!chnl->regs.roten))
+		enable_channel(chnl);
+
+	/* TODO: look at port sync source and synched_update */
+	if (chnl->regs.synchronized_update &&
+				chnl->power_mode == MCDE_DISPLAY_PM_ON) {
+		if (chnl->port.type == MCDE_PORTTYPE_DSI &&
+			chnl->port.sync_src == MCDE_SYNCSRC_BTA) {
+			while (dsi_rfld(chnl->port.link, DSI_CMD_MODE_STS,
+				CSM_RUNNING))
+				udelay(100);
+			dsi_te_request(chnl);
+		}
+	} else {
+		mcde_wreg(MCDE_CHNL0SYNCHSW +
+			chnl->id * MCDE_CHNL0SYNCHSW_GROUPOFFSET,
+			MCDE_CHNL0SYNCHSW_SW_TRIG(true));
+		dev_vdbg(&mcde_dev->dev, "Channel update (no sync), chnl=%d\n",
+			chnl->id);
+
+		/*
+		* This comment is valid for hardware_version ==
+		* MCDE_CHIP_VERSION_3_0_8.
+		*
+		* If you disable after the last frame you triggered has
+		* finished. The output formatter
+		* (at least DSI is working like this) is waiting for a new
+		* frame that will never come, and then the FLOEN will
+		* stay at 1. To avoid this, you have to always disable just
+		* after your last trig, before receiving VCOMP interrupt
+		* (= before the last triggered frame is finished).
+		*/
+		if (hardware_version == MCDE_CHIP_VERSION_3_0_8)
+			channel_flow_disable(chnl);
+	}
+
+	if (hardware_version == MCDE_CHIP_VERSION_3_0_5 &&
+		chnl->power_mode == MCDE_DISPLAY_PM_ON && chnl->regs.roten)
+		enable_channel(chnl);
+
+}
+
+static void chnl_update_overlay(struct mcde_chnl_state *chnl,
+						struct mcde_ovly_state *ovly)
+{
+	if (!ovly || (ovly->transactionid_regs >= ovly->transactionid &&
+			chnl->transactionid_regs >= chnl->transactionid))
+		return;
+
+	update_overlay_address_registers(ovly->idx, &ovly->regs);
+	if (ovly->regs.reset_buf_id) {
+		if (!chnl->continous_running)
+			wait_for_overlay(ovly);
+
+		update_overlay_registers(ovly->idx, &ovly->regs, &chnl->port,
+			chnl->fifo, chnl->regs.x, chnl->regs.y,
+			chnl->regs.ppl, chnl->regs.lpf, ovly->stride,
+			chnl->vmode.interlaced);
+		ovly->transactionid_regs = ovly->transactionid;
+	} else if (chnl->continous_running) {
+		ovly->transactionid_regs = ovly->transactionid;
+		wait_for_overlay(ovly);
+	}
+}
+
+int mcde_chnl_update(struct mcde_chnl_state *chnl,
+					struct mcde_rectangle *update_area)
+{
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+
+	/* TODO: lock & make wait->trig async */
+	if (!chnl->inuse || !update_area
+			|| (update_area->w == 0 && update_area->h == 0)) {
+		return -EINVAL;
+	}
+
+	chnl->regs.x   = update_area->x;
+	chnl->regs.y   = update_area->y;
+	/* TODO Crop against video_mode.xres and video_mode.yres */
+	chnl->regs.ppl = update_area->w;
+	chnl->regs.lpf = update_area->h;
+	if (chnl->port.type == MCDE_PORTTYPE_DPI) {/* REVIEW: Comment */
+		chnl->regs.ppl -= 2 * MCDE_CONFIG_TVOUT_HBORDER;
+		/* subtract double borders, ie. per field */
+		chnl->regs.lpf -= 4 * MCDE_CONFIG_TVOUT_VBORDER;
+	} else if (chnl->port.type == MCDE_PORTTYPE_DSI &&
+			chnl->vmode.interlaced)
+		chnl->regs.lpf /= 2;
+
+	chnl_update_overlay(chnl, chnl->ovly0);
+	chnl_update_overlay(chnl, chnl->ovly1);
+
+	if (chnl->port.update_auto_trig)
+		chnl_update_continous(chnl);
+	else
+		chnl_update_non_continous(chnl);
+
+	dev_vdbg(&mcde_dev->dev, "Channel updated, chnl=%d\n", chnl->id);
+	return 0;
+}
+
+void mcde_chnl_put(struct mcde_chnl_state *chnl)
+{
+	struct mcde_chnl_state *chnl_tmp = &channels[0];
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+
+	if (!chnl->inuse)
+		return;
+
+	disable_channel(chnl);
+	chnl->inuse = false;
+
+	for (; chnl_tmp < &channels[ARRAY_SIZE(channels)]; chnl_tmp++)
+		if (chnl_tmp->inuse)
+			return;
+
+	disable_clocks_and_power(mcde_dev);
+
+	mcde_is_enabled = false;
+}
+
+void mcde_chnl_stop_flow(struct mcde_chnl_state *chnl)
+{
+	disable_channel(chnl);
+}
+
+/* MCDE overlays */
+struct mcde_ovly_state *mcde_ovly_get(struct mcde_chnl_state *chnl)
+{
+	struct mcde_ovly_state *ovly;
+
+	if (!chnl->inuse)
+		return ERR_PTR(-EINVAL);
+
+	if (!chnl->ovly0->inuse)
+		ovly = chnl->ovly0;
+	else if (chnl->ovly1 && !chnl->ovly1->inuse)
+		ovly = chnl->ovly1;
+	else
+		ovly = ERR_PTR(-EBUSY);
+
+	if (!IS_ERR(ovly)) {
+		ovly->inuse = true;
+		ovly->paddr = 0;
+		ovly->stride = 0;
+		ovly->pix_fmt = MCDE_OVLYPIXFMT_RGB565;
+		ovly->src_x = 0;
+		ovly->src_y = 0;
+		ovly->dst_x = 0;
+		ovly->dst_y = 0;
+		ovly->dst_z = 0;
+		ovly->w = 0;
+		ovly->h = 0;
+		mcde_ovly_apply(ovly);
+	}
+
+	return ovly;
+}
+
+void mcde_ovly_put(struct mcde_ovly_state *ovly)
+{
+	if (!ovly->inuse)
+		return;
+	if (ovly->regs.enabled) {
+		ovly->paddr = 0;
+		mcde_ovly_apply(ovly);/* REVIEW: API call calling API call! */
+	}
+	ovly->inuse = false;
+}
+
+void mcde_ovly_set_source_buf(struct mcde_ovly_state *ovly, u32 paddr)
+{
+	if (!ovly->inuse)
+		return;
+
+	ovly->paddr = paddr;
+}
+
+void mcde_ovly_set_source_info(struct mcde_ovly_state *ovly,
+	u32 stride, enum mcde_ovly_pix_fmt pix_fmt)
+{
+	if (!ovly->inuse)
+		return;
+
+	ovly->stride = stride;
+	ovly->pix_fmt = pix_fmt;
+}
+
+void mcde_ovly_set_source_area(struct mcde_ovly_state *ovly,
+	u16 x, u16 y, u16 w, u16 h)
+{
+	if (!ovly->inuse)
+		return;
+
+	ovly->src_x = x;
+	ovly->src_y = y;
+	ovly->w = w;
+	ovly->h = h;
+}
+
+void mcde_ovly_set_dest_pos(struct mcde_ovly_state *ovly, u16 x, u16 y, u8 z)
+{
+	if (!ovly->inuse)
+		return;
+
+	ovly->dst_x = x;
+	ovly->dst_y = y;
+	ovly->dst_z = z;
+}
+
+void mcde_ovly_apply(struct mcde_ovly_state *ovly)
+{
+	if (!ovly->inuse)
+		return;
+
+	/* TODO: lock */
+
+	ovly->regs.ch_id = ovly->chnl->id;
+	ovly->regs.enabled = ovly->paddr != 0;
+	ovly->regs.baseaddress0 = ovly->paddr;
+	ovly->regs.baseaddress1 = ovly->paddr + ovly->stride;
+	/*TODO set to true if interlaced *//* REVIEW: Video mode interlaced? */
+	ovly->regs.reset_buf_id = !ovly->chnl->continous_running;
+	switch (ovly->pix_fmt) {/* REVIEW: Extract to table */
+	case MCDE_OVLYPIXFMT_RGB565:
+		ovly->regs.bits_per_pixel = 16;
+		ovly->regs.bpp = MCDE_EXTSRC0CONF_BPP_RGB565;
+		ovly->regs.bgr = false;
+		ovly->regs.bebo = false;
+		ovly->regs.opq = true;
+		break;
+	case MCDE_OVLYPIXFMT_RGBA5551:
+		ovly->regs.bits_per_pixel = 16;
+		ovly->regs.bpp = MCDE_EXTSRC0CONF_BPP_IRGB1555;
+		ovly->regs.bgr = false;
+		ovly->regs.bebo = false;
+		ovly->regs.opq = false;
+		break;
+	case MCDE_OVLYPIXFMT_RGBA4444:
+		ovly->regs.bits_per_pixel = 16;
+		ovly->regs.bpp = MCDE_EXTSRC0CONF_BPP_ARGB4444;
+		ovly->regs.bgr = false;
+		ovly->regs.bebo = false;
+		ovly->regs.opq = false;
+		break;
+	case MCDE_OVLYPIXFMT_RGB888:
+		ovly->regs.bits_per_pixel = 24;
+		ovly->regs.bpp = MCDE_EXTSRC0CONF_BPP_RGB888;
+		ovly->regs.bgr = false;
+		ovly->regs.bebo = false;
+		ovly->regs.opq = true;
+		break;
+	case MCDE_OVLYPIXFMT_RGBX8888:
+		ovly->regs.bits_per_pixel = 32;
+		ovly->regs.bpp = MCDE_EXTSRC0CONF_BPP_XRGB8888;
+		ovly->regs.bgr = false;
+		ovly->regs.bebo = true;
+		ovly->regs.opq = true;
+		break;
+	case MCDE_OVLYPIXFMT_RGBA8888:
+		ovly->regs.bits_per_pixel = 32;
+		ovly->regs.bpp = MCDE_EXTSRC0CONF_BPP_ARGB8888;
+		ovly->regs.bgr = false;
+		ovly->regs.bebo = true;
+		ovly->regs.opq = false;
+		break;
+	case MCDE_OVLYPIXFMT_YCbCr422:
+		ovly->regs.bits_per_pixel = 16;
+		ovly->regs.bpp = MCDE_EXTSRC0CONF_BPP_YCBCR422;
+		ovly->regs.bgr = false;
+		ovly->regs.bebo = false;
+		ovly->regs.opq = true;
+		break;
+	default:
+		break;
+	}
+
+	ovly->regs.ppl = ovly->w;
+	ovly->regs.lpf = ovly->h;
+	ovly->regs.cropx = ovly->src_x;
+	ovly->regs.cropy = ovly->src_y;
+	ovly->regs.xpos = ovly->dst_x;
+	ovly->regs.ypos = ovly->dst_y;
+	ovly->regs.z = ovly->dst_z > 0; /* 0 or 1 */
+	ovly->regs.col_conv = MCDE_OVL0CR_COLCCTRL_DISABLED;
+
+	ovly->transactionid = ++ovly->chnl->transactionid;
+
+	dev_vdbg(&mcde_dev->dev, "Overlay applied, chnl=%d\n", ovly->chnl->id);
+}
+
+static int init_clocks_and_power(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct mcde_platform_data *pdata = pdev->dev.platform_data;
+	if (pdata->regulator_id) {
+		regulator = regulator_get(&pdev->dev,
+				pdata->regulator_id);
+		if (IS_ERR(regulator)) {
+			ret = PTR_ERR(regulator);
+			dev_warn(&pdev->dev,
+				"%s: Failed to get regulator '%s'\n",
+				__func__, pdata->regulator_id);
+			regulator = NULL;
+			goto regulator_err;
+		}
+	} else {
+		dev_dbg(&pdev->dev, "%s: No regulator id supplied\n",
+								__func__);
+		regulator = NULL;
+	}
+	clock_dsi = clk_get(&pdev->dev, pdata->clock_dsi_id);
+	if (IS_ERR(clock_dsi)) {
+		ret = PTR_ERR(clock_dsi);
+		dev_warn(&pdev->dev, "%s: Failed to get clock '%s'\n",
+					__func__, pdata->clock_dsi_id);
+		goto clk_dsi_err;
+	}
+
+	clock_dsi_lp = clk_get(&pdev->dev, pdata->clock_dsi_lp_id);
+	if (IS_ERR(clock_dsi_lp)) {
+		ret = PTR_ERR(clock_dsi_lp);
+		dev_warn(&pdev->dev, "%s: Failed to get clock '%s'\n",
+					__func__, pdata->clock_dsi_lp_id);
+		goto clk_dsi_lp_err;
+	}
+
+	clock_mcde = clk_get(&pdev->dev, pdata->clock_mcde_id);
+	if (IS_ERR(clock_mcde)) {
+		ret = PTR_ERR(clock_mcde);
+		dev_warn(&pdev->dev, "%s: Failed to get clock '%s'\n",
+					__func__, pdata->clock_mcde_id);
+		goto clk_mcde_err;
+	}
+
+	return ret;
+
+clk_mcde_err:
+	clk_put(clock_dsi_lp);
+clk_dsi_lp_err:
+	clk_put(clock_dsi);
+clk_dsi_err:
+	if (regulator)
+		regulator_put(regulator);
+regulator_err:
+	return ret;
+}
+
+static void remove_clocks_and_power(struct platform_device *pdev)
+{
+	/* REVIEW: Release only if exist */
+	/* REVIEW: Remove make sure MCDE is done */
+	clk_put(clock_dsi);
+	clk_put(clock_dsi_lp);
+	clk_put(clock_mcde);
+	if (regulator)
+		regulator_put(regulator);
+}
+
+static int __devinit mcde_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	int i, irq;
+	struct resource *res;
+	struct mcde_platform_data *pdata = pdev->dev.platform_data;
+	u8 major_version;
+	u8 minor_version;
+	u8 development_version;
+
+	if (!pdata) {
+		dev_dbg(&pdev->dev, "No platform data\n");
+		return -EINVAL;
+	}
+
+	num_dsilinks = pdata->num_dsilinks;
+	mcde_dev = pdev;
+
+	dsiio = kzalloc(num_dsilinks * sizeof(*dsiio), GFP_KERNEL);
+	if (!dsiio) {
+		ret = -ENOMEM;
+		goto failed_dsi_alloc;
+	}
+
+	/* Hook up irq */
+	irq = platform_get_irq(pdev, 0);
+	if (irq <= 0) {
+		dev_dbg(&pdev->dev, "No irq defined\n");
+		ret = -EINVAL;
+		goto failed_irq_get;
+	}
+	ret = request_irq(irq, mcde_irq_handler, 0, "mcde", &pdev->dev);
+	if (ret) {
+		dev_dbg(&pdev->dev, "Failed to request irq (irq=%d)\n", irq);
+		goto failed_request_irq;
+	}
+
+	/* Map I/O */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_dbg(&pdev->dev, "No MCDE io defined\n");
+		ret = -EINVAL;
+		goto failed_get_mcde_io;
+	}
+	mcdeio = ioremap(res->start, res->end - res->start + 1);
+	if (!mcdeio) {
+		dev_dbg(&pdev->dev, "MCDE iomap failed\n");
+		ret = -EINVAL;
+		goto failed_map_mcde_io;
+	}
+	dev_info(&pdev->dev, "MCDE iomap: 0x%.8X->0x%.8X\n",
+		(u32)res->start, (u32)mcdeio);
+	for (i = 0; i < num_dsilinks; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1+i);
+		if (!res) {
+			dev_dbg(&pdev->dev, "No DSI%d io defined\n", i);
+			ret = -EINVAL;
+			goto failed_get_dsi_io;
+		}
+		dsiio[i] = ioremap(res->start, res->end - res->start + 1);
+		if (!dsiio[i]) {
+			dev_dbg(&pdev->dev, "MCDE DSI%d iomap failed\n", i);
+			ret = -EINVAL;
+			goto failed_map_dsi_io;
+		}
+		dev_info(&pdev->dev, "MCDE DSI%d iomap: 0x%.8X->0x%.8X\n",
+			i, (u32)res->start, (u32)dsiio[i]);
+	}
+
+	ret = init_clocks_and_power(pdev);
+	if (ret < 0) {
+		dev_warn(&pdev->dev, "%s: init_clocks_and_power failed\n"
+					, __func__);
+		goto failed_init_clocks;
+	}
+	ret = enable_clocks_and_power(pdev);
+	if (ret < 0) {
+		dev_warn(&pdev->dev, "%s: enable_clocks_and_power failed\n"
+					, __func__);
+		goto failed_enable_clocks;
+	}
+	update_mcde_registers();
+
+	major_version = MCDE_REG2VAL(MCDE_PID, MAJOR_VERSION,
+							mcde_rreg(MCDE_PID));
+	minor_version = MCDE_REG2VAL(MCDE_PID, MINOR_VERSION,
+							mcde_rreg(MCDE_PID));
+	development_version = MCDE_REG2VAL(MCDE_PID, DEVELOPMENT_VERSION,
+							mcde_rreg(MCDE_PID));
+
+	dev_info(&mcde_dev->dev, "MCDE HW revision %u.%u.%u.%u\n",
+			major_version, minor_version, development_version,
+					mcde_rfld(MCDE_PID, METALFIX_VERSION));
+
+	if (major_version == 3 && minor_version == 0 &&
+					development_version >= 8) {
+		hardware_version = MCDE_CHIP_VERSION_3_0_8;
+		dev_info(&mcde_dev->dev, "V2 HW\n");
+	} else if (major_version == 3 && minor_version == 0 &&
+					development_version >= 5) {
+		hardware_version = MCDE_CHIP_VERSION_3_0_5;
+		dev_info(&mcde_dev->dev, "V1 HW\n");
+	} else {
+		dev_err(&mcde_dev->dev, "Unsupported HW version\n");
+		ret = -ENOTSUPP;
+		goto failed_hardware_version;
+	}
+
+	mcde_is_enabled = true;
+
+	return 0;
+
+failed_hardware_version:
+	disable_clocks_and_power(pdev);
+failed_enable_clocks:
+	remove_clocks_and_power(pdev);
+failed_init_clocks:
+failed_map_dsi_io:
+failed_get_dsi_io:
+	for (i = 0; i < num_dsilinks; i++) {
+		if (dsiio[i])
+			iounmap(dsiio[i]);
+	}
+	iounmap(mcdeio);
+failed_map_mcde_io:
+failed_get_mcde_io:
+	free_irq(irq, &pdev->dev);
+failed_request_irq:
+failed_irq_get:
+	kfree(dsiio);
+	dsiio = NULL;
+failed_dsi_alloc:
+	return ret;
+}
+
+
+static int __devexit mcde_remove(struct platform_device *pdev)
+{
+	struct mcde_chnl_state *chnl = &channels[0];
+
+	for (; chnl < &channels[ARRAY_SIZE(channels)]; chnl++) {
+		if (del_timer(&chnl->auto_sync_timer))
+			dev_vdbg(&mcde_dev->dev,
+				"%s timer could not be stopped\n"
+				, __func__);
+	}
+	remove_clocks_and_power(pdev);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int mcde_resume(struct platform_device *pdev)
+{
+	int ret;
+	struct mcde_chnl_state *chnl = &channels[0];
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+	ret = enable_clocks_and_power(pdev);
+	if (ret < 0) {
+		dev_dbg(&pdev->dev, "%s: Enable clocks and power failed\n"
+						, __func__);
+		goto clock_err;
+	}
+	update_mcde_registers();
+
+	for (; chnl < &channels[ARRAY_SIZE(channels)]; chnl++) {
+		if (chnl->inuse) {
+			(void)update_channel_static_registers(chnl);
+			update_channel_registers(chnl->id, &chnl->regs,
+						&chnl->port, chnl->fifo,
+						&chnl->vmode);
+			if (chnl->ovly0)
+				update_overlay_registers(chnl->ovly0->idx,
+						&chnl->ovly0->regs,
+						&chnl->port, chnl->fifo,
+						chnl->regs.x, chnl->regs.y,
+						chnl->regs.ppl, chnl->regs.lpf,
+						chnl->ovly0->stride,
+						chnl->vmode.interlaced);
+			if (chnl->ovly1)
+				update_overlay_registers(chnl->ovly1->idx,
+						&chnl->ovly1->regs,
+						&chnl->port, chnl->fifo,
+						chnl->regs.x, chnl->regs.y,
+						chnl->regs.ppl, chnl->regs.lpf,
+						chnl->ovly1->stride,
+						chnl->vmode.interlaced);
+		}
+	}
+
+	mcde_is_enabled = true;
+clock_err:
+	return ret;
+}
+#endif
+
+#ifdef CONFIG_PM
+static int mcde_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct mcde_chnl_state *chnl = &channels[0];
+
+	dev_vdbg(&mcde_dev->dev, "%s\n", __func__);
+
+	/* This is added because of the auto sync feature */
+	for (; chnl < &channels[ARRAY_SIZE(channels)]; chnl++) {
+		mcde_chnl_stop_flow(chnl);
+		if (del_timer(&chnl->auto_sync_timer))
+			dev_vdbg(&mcde_dev->dev,
+				"%s timer could not be stopped\n"
+				, __func__);
+	}
+
+	mcde_is_enabled = false;
+
+	return disable_clocks_and_power(pdev);
+}
+#endif
+
+static struct platform_driver mcde_driver = {
+	.probe = mcde_probe,
+	.remove = mcde_remove,
+#ifdef CONFIG_PM
+	.suspend = mcde_suspend,
+	.resume = mcde_resume,
+#else
+	.suspend = NULL,
+	.resume = NULL,
+#endif
+	.driver = {
+		.name	= "mcde",
+	},
+};
+
+int __init mcde_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(channels); i++) {
+		channels[i].ovly0->chnl = &channels[i];
+		if (channels[i].ovly1)
+			channels[i].ovly1->chnl = &channels[i];
+		init_waitqueue_head(&channels[i].waitq_hw);
+		init_timer(&channels[i].auto_sync_timer);
+		channels[i].auto_sync_timer.function =
+					watchdog_auto_sync_timer_function;
+	}
+	for (i = 0; i < ARRAY_SIZE(overlays); i++)
+		init_waitqueue_head(&overlays[i].waitq_hw);
+
+	return platform_driver_register(&mcde_driver);
+}
+
+void mcde_exit(void)
+{
+	/* REVIEW: shutdown MCDE? */
+	platform_driver_unregister(&mcde_driver);
+}
diff --git a/include/video/mcde/mcde.h b/include/video/mcde/mcde.h
new file mode 100644
index 0000000..27a3f3f
--- /dev/null
+++ b/include/video/mcde/mcde.h
@@ -0,0 +1,387 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * ST-Ericsson MCDE base driver
+ *
+ * Author: Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>
+ * for ST-Ericsson.
+ *
+ * License terms: GNU General Public License (GPL), version 2.
+ */
+#ifndef __MCDE__H__
+#define __MCDE__H__
+
+/* Physical interface types */
+enum mcde_port_type {
+	MCDE_PORTTYPE_DSI = 0,
+	MCDE_PORTTYPE_DPI = 1,
+};
+
+/* Interface mode */
+enum mcde_port_mode {
+	MCDE_PORTMODE_CMD = 0,
+	MCDE_PORTMODE_VID = 1,
+};
+
+/* MCDE fifos */
+enum mcde_fifo {
+	MCDE_FIFO_A  = 0,
+	MCDE_FIFO_B  = 1,
+	MCDE_FIFO_C0 = 2,
+	MCDE_FIFO_C1 = 3,
+};
+
+/* MCDE channels (pixel pipelines) */
+enum mcde_chnl {
+	MCDE_CHNL_A  = 0,
+	MCDE_CHNL_B  = 1,
+	MCDE_CHNL_C0 = 2,
+	MCDE_CHNL_C1 = 3,
+};
+
+/* Channel path */
+#define MCDE_CHNLPATH(__chnl, __fifo, __type, __ifc, __link) \
+	(((__chnl) << 16) | ((__fifo) << 12) | \
+	 ((__type) << 8) | ((__ifc) << 4) | ((__link) << 0))
+enum mcde_chnl_path {
+	/* Channel A */
+	MCDE_CHNLPATH_CHNLA_FIFOA_DPI_0 = MCDE_CHNLPATH(MCDE_CHNL_A,
+		MCDE_FIFO_A, MCDE_PORTTYPE_DPI, 0, 0),
+	MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC0_0 = MCDE_CHNLPATH(MCDE_CHNL_A,
+		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 0, 0),
+	MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC0_1 = MCDE_CHNLPATH(MCDE_CHNL_A,
+		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 0, 1),
+	MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC0_2 = MCDE_CHNLPATH(MCDE_CHNL_A,
+		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 0, 2),
+	MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC1_0 = MCDE_CHNLPATH(MCDE_CHNL_A,
+		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 1, 0),
+	MCDE_CHNLPATH_CHNLA_FIFOC0_DSI_IFC1_1 = MCDE_CHNLPATH(MCDE_CHNL_A,
+		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 1, 1),
+	MCDE_CHNLPATH_CHNLA_FIFOA_DSI_IFC1_2 = MCDE_CHNLPATH(MCDE_CHNL_A,
+		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 1, 2),
+	/* Channel B */
+	MCDE_CHNLPATH_CHNLB_FIFOB_DPI_1 = MCDE_CHNLPATH(MCDE_CHNL_B,
+		MCDE_FIFO_B, MCDE_PORTTYPE_DPI, 0, 1),
+	MCDE_CHNLPATH_CHNLB_FIFOB_DSI_IFC0_0 = MCDE_CHNLPATH(MCDE_CHNL_B,
+		MCDE_FIFO_B, MCDE_PORTTYPE_DSI, 0, 0),
+	MCDE_CHNLPATH_CHNLB_FIFOB_DSI_IFC0_1 = MCDE_CHNLPATH(MCDE_CHNL_B,
+		MCDE_FIFO_B, MCDE_PORTTYPE_DSI, 0, 1),
+	MCDE_CHNLPATH_CHNLB_FIFOC1_DSI_IFC0_2 = MCDE_CHNLPATH(MCDE_CHNL_B,
+		MCDE_FIFO_C1, MCDE_PORTTYPE_DSI, 0, 2),
+	MCDE_CHNLPATH_CHNLB_FIFOC1_DSI_IFC1_0 = MCDE_CHNLPATH(MCDE_CHNL_B,
+		MCDE_FIFO_C1, MCDE_PORTTYPE_DSI, 1, 0),
+	MCDE_CHNLPATH_CHNLB_FIFOC1_DSI_IFC1_1 = MCDE_CHNLPATH(MCDE_CHNL_B,
+		MCDE_FIFO_C1, MCDE_PORTTYPE_DSI, 1, 1),
+	MCDE_CHNLPATH_CHNLB_FIFOB_DSI_IFC1_2 = MCDE_CHNLPATH(MCDE_CHNL_B,
+		MCDE_FIFO_B, MCDE_PORTTYPE_DSI, 1, 2),
+	/* Channel C0 */
+	MCDE_CHNLPATH_CHNLC0_FIFOA_DSI_IFC0_0 = MCDE_CHNLPATH(MCDE_CHNL_C0,
+		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 0, 0),
+	MCDE_CHNLPATH_CHNLC0_FIFOA_DSI_IFC0_1 = MCDE_CHNLPATH(MCDE_CHNL_C0,
+		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 0, 1),
+	MCDE_CHNLPATH_CHNLC0_FIFOC0_DSI_IFC0_2 = MCDE_CHNLPATH(MCDE_CHNL_C0,
+		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 0, 2),
+	MCDE_CHNLPATH_CHNLC0_FIFOC0_DSI_IFC1_0 = MCDE_CHNLPATH(MCDE_CHNL_C0,
+		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 1, 0),
+	MCDE_CHNLPATH_CHNLC0_FIFOC0_DSI_IFC1_1 = MCDE_CHNLPATH(MCDE_CHNL_C0,
+		MCDE_FIFO_C0, MCDE_PORTTYPE_DSI, 1, 1),
+	MCDE_CHNLPATH_CHNLC0_FIFOA_DSI_IFC1_2 = MCDE_CHNLPATH(MCDE_CHNL_C0,
+		MCDE_FIFO_A, MCDE_PORTTYPE_DSI, 1, 2),
+	/* Channel C1 */
+	MCDE_CHNLPATH_CHNLC1_FIFOB_DSI_IFC0_0 = MCDE_CHNLPATH(MCDE_CHNL_C1,
+		MCDE_FIFO_B, MCDE_PORTTYPE_DSI, 0, 0),
+	MCDE_CHNLPATH_CHNLC1_FIFOB_DSI_IFC0_1 = MCDE_CHNLPATH(MCDE_CHNL_C1,
+		MCDE_FIFO_B, MCDE_PORTTYPE_DSI, 0, 1),
+	MCDE_CHNLPATH_CHNLC1_FIFOC1_DSI_IFC0_2 = MCDE_CHNLPATH(MCDE_CHNL_C1,
+		MCDE_FIFO_C1, MCDE_PORTTYPE_DSI, 0, 2),
+	MCDE_CHNLPATH_CHNLC1_FIFOC1_DSI_IFC1_0 = MCDE_CHNLPATH(MCDE_CHNL_C1,
+		MCDE_FIFO_C1, MCDE_PORTTYPE_DSI, 1, 0),
+	MCDE_CHNLPATH_CHNLC1_FIFOC1_DSI_IFC1_1 = MCDE_CHNLPATH(MCDE_CHNL_C1,
+		MCDE_FIFO_C1, MCDE_PORTTYPE_DSI, 1, 1),
+	MCDE_CHNLPATH_CHNLC1_FIFOB_DSI_IFC1_2 = MCDE_CHNLPATH(MCDE_CHNL_C1,
+		MCDE_FIFO_B, MCDE_PORTTYPE_DSI, 1, 2),
+};
+
+/* Update sync mode */
+enum mcde_sync_src {
+	MCDE_SYNCSRC_OFF = 0, /* No sync */
+	MCDE_SYNCSRC_TE0 = 1, /* MCDE ext TE0 */
+	MCDE_SYNCSRC_TE1 = 2, /* MCDE ext TE1 */
+	MCDE_SYNCSRC_BTA = 3, /* DSI BTA */
+};
+
+/* Interface pixel formats (output) */
+/*
+* REVIEW: Define formats
+* Add explanatory comments how the formats are ordered in memory
+*/
+enum mcde_port_pix_fmt {
+	/* MIPI standard formats */
+
+	MCDE_PORTPIXFMT_DPI_16BPP_C1 =     0x21,
+	MCDE_PORTPIXFMT_DPI_16BPP_C2 =     0x22,
+	MCDE_PORTPIXFMT_DPI_16BPP_C3 =     0x23,
+	MCDE_PORTPIXFMT_DPI_18BPP_C1 =     0x24,
+	MCDE_PORTPIXFMT_DPI_18BPP_C2 =     0x25,
+	MCDE_PORTPIXFMT_DPI_24BPP =        0x26,
+
+	MCDE_PORTPIXFMT_DSI_16BPP =        0x31,
+	MCDE_PORTPIXFMT_DSI_18BPP =        0x32,
+	MCDE_PORTPIXFMT_DSI_18BPP_PACKED = 0x33,
+	MCDE_PORTPIXFMT_DSI_24BPP =        0x34,
+
+	/* Custom formats */
+	MCDE_PORTPIXFMT_DSI_YCBCR422 =     0x40,
+};
+
+struct mcde_col_convert {
+	u16 matrix[3][3];
+	u16 offset[3];
+};
+
+struct mcde_port {
+	enum mcde_port_type type;
+	enum mcde_port_mode mode;
+	enum mcde_port_pix_fmt pixel_format;
+	u8 ifc;
+	u8 link;
+	enum mcde_sync_src sync_src;
+	bool update_auto_trig;
+	union {
+		struct {
+			u8 virt_id;
+			u8 num_data_lanes;
+			u8 ui;
+			bool clk_cont;
+		} dsi;
+		struct {
+			u8 bus_width;
+		} dpi;
+	} phy;
+};
+
+/* Overlay pixel formats (input) *//* REVIEW: Define byte order */
+enum mcde_ovly_pix_fmt {
+	MCDE_OVLYPIXFMT_RGB565   = 1,
+	MCDE_OVLYPIXFMT_RGBA5551 = 2,
+	MCDE_OVLYPIXFMT_RGBA4444 = 3,
+	MCDE_OVLYPIXFMT_RGB888   = 4,
+	MCDE_OVLYPIXFMT_RGBX8888 = 5,
+	MCDE_OVLYPIXFMT_RGBA8888 = 6,
+	MCDE_OVLYPIXFMT_YCbCr422 = 7,/* REVIEW: Capitalize */
+};
+
+/* Display power modes */
+enum mcde_display_power_mode {
+	MCDE_DISPLAY_PM_OFF     = 0, /* Power off */
+	MCDE_DISPLAY_PM_STANDBY = 1, /* DCS sleep mode */
+	MCDE_DISPLAY_PM_ON      = 2, /* DCS normal mode, display on */
+};
+
+/* Display rotation */
+enum mcde_display_rotation {
+	MCDE_DISPLAY_ROT_0       = 0,
+	MCDE_DISPLAY_ROT_90_CCW  = 90,
+	MCDE_DISPLAY_ROT_180_CCW = 180,
+	MCDE_DISPLAY_ROT_270_CCW = 270,
+	MCDE_DISPLAY_ROT_90_CW   = MCDE_DISPLAY_ROT_270_CCW,
+	MCDE_DISPLAY_ROT_180_CW  = MCDE_DISPLAY_ROT_180_CCW,
+	MCDE_DISPLAY_ROT_270_CW  = MCDE_DISPLAY_ROT_90_CCW,
+};
+
+/* REVIEW: Verify */
+#define MCDE_MIN_WIDTH  16
+#define MCDE_MIN_HEIGHT 16
+#define MCDE_MAX_WIDTH  2048
+#define MCDE_MAX_HEIGHT 2048
+#define MCDE_BUF_START_ALIGMENT 8
+#define MCDE_BUF_LINE_ALIGMENT 8
+
+#define MCDE_FIFO_AB_SIZE 640
+#define MCDE_FIFO_C0C1_SIZE 160
+
+#define MCDE_PIXFETCH_LARGE_WTRMRKLVL 128
+#define MCDE_PIXFETCH_MEDIUM_WTRMRKLVL 32
+#define MCDE_PIXFETCH_SMALL_WTRMRKLVL 16
+
+/* Tv-out defines */
+#define MCDE_CONFIG_TVOUT_HBORDER 2
+#define MCDE_CONFIG_TVOUT_VBORDER 2
+#define MCDE_CONFIG_TVOUT_BACKGROUND_LUMINANCE		0x83
+#define MCDE_CONFIG_TVOUT_BACKGROUND_CHROMINANCE_CB	0x9C
+#define MCDE_CONFIG_TVOUT_BACKGROUND_CHROMINANCE_CR	0x2C
+
+/* In seconds */
+#define MCDE_AUTO_SYNC_WATCHDOG 5
+
+/* Hardware versions */
+#define MCDE_CHIP_VERSION_3_0_8 2
+#define MCDE_CHIP_VERSION_3_0_5 1
+#define MCDE_CHIP_VERSION_3	0
+
+/* DSI modes */
+#define DSI_VIDEO_MODE	0
+#define DSI_CMD_MODE	1
+
+/* Video mode descriptor */
+struct mcde_video_mode {/* REVIEW: Join 1 & 2 */
+	u32 xres;
+	u32 yres;
+	u32 pixclock;	/* pixel clock in ps (pico seconds) */
+	u32 hbp;	/* hor back porch = left_margin */
+	u32 hfp;	/* hor front porch equals to right_margin */
+	u32 vbp1;	/* field 1: vert back porch equals to upper_margin */
+	u32 vfp1;	/* field 1: vert front porch equals to lower_margin */
+	u32 vbp2;	/* field 2: vert back porch equals to upper_margin */
+	u32 vfp2;	/* field 2: vert front porch equals to lower_margin */
+	bool interlaced;
+};
+
+struct mcde_rectangle {
+	u16 x;
+	u16 y;
+	u16 w;
+	u16 h;
+};
+
+struct mcde_overlay_info {
+	u32 paddr;
+	u16 stride; /* buffer line len in bytes */
+	enum mcde_ovly_pix_fmt fmt;
+
+	u16 src_x;
+	u16 src_y;
+	u16 dst_x;
+	u16 dst_y;
+	u16 dst_z;
+	u16 w;
+	u16 h;
+	struct mcde_rectangle dirty;
+};
+
+struct mcde_overlay {
+	struct kobject kobj;
+	struct list_head list; /* mcde_display_device.ovlys */
+
+	struct mcde_display_device *ddev;
+	struct mcde_overlay_info info;
+	struct mcde_ovly_state *state;
+};
+
+struct mcde_chnl_state;
+
+struct mcde_chnl_state *mcde_chnl_get(enum mcde_chnl chnl_id,
+			enum mcde_fifo fifo, const struct mcde_port *port);
+int mcde_chnl_set_pixel_format(struct mcde_chnl_state *chnl,
+					enum mcde_port_pix_fmt pix_fmt);
+void mcde_chnl_set_col_convert(struct mcde_chnl_state *chnl,
+					struct mcde_col_convert *col_convert);
+int mcde_chnl_set_video_mode(struct mcde_chnl_state *chnl,
+					struct mcde_video_mode *vmode);
+/* TODO: Remove rotbuf* parameters when ESRAM allocator is implemented*/
+int mcde_chnl_set_rotation(struct mcde_chnl_state *chnl,
+		enum mcde_display_rotation rotation, u32 rotbuf1, u32 rotbuf2);
+int mcde_chnl_enable_synchronized_update(struct mcde_chnl_state *chnl,
+								bool enable);
+int mcde_chnl_set_power_mode(struct mcde_chnl_state *chnl,
+				enum mcde_display_power_mode power_mode);
+
+int mcde_chnl_apply(struct mcde_chnl_state *chnl);
+int mcde_chnl_update(struct mcde_chnl_state *chnl,
+					struct mcde_rectangle *update_area);
+void mcde_chnl_put(struct mcde_chnl_state *chnl);
+
+void mcde_chnl_stop_flow(struct mcde_chnl_state *chnl);
+
+/* MCDE overlay */
+struct mcde_ovly_state;
+
+struct mcde_ovly_state *mcde_ovly_get(struct mcde_chnl_state *chnl);
+void mcde_ovly_set_source_buf(struct mcde_ovly_state *ovly,
+	u32 paddr);
+void mcde_ovly_set_source_info(struct mcde_ovly_state *ovly,
+	u32 stride, enum mcde_ovly_pix_fmt pix_fmt);
+void mcde_ovly_set_source_area(struct mcde_ovly_state *ovly,
+	u16 x, u16 y, u16 w, u16 h);
+void mcde_ovly_set_dest_pos(struct mcde_ovly_state *ovly,
+	u16 x, u16 y, u8 z);
+void mcde_ovly_apply(struct mcde_ovly_state *ovly);
+void mcde_ovly_put(struct mcde_ovly_state *ovly);
+
+/* MCDE dsi */
+
+#define DCS_CMD_ENTER_IDLE_MODE       0x39
+#define DCS_CMD_ENTER_INVERT_MODE     0x21
+#define DCS_CMD_ENTER_NORMAL_MODE     0x13
+#define DCS_CMD_ENTER_PARTIAL_MODE    0x12
+#define DCS_CMD_ENTER_SLEEP_MODE      0x10
+#define DCS_CMD_EXIT_IDLE_MODE        0x38
+#define DCS_CMD_EXIT_INVERT_MODE      0x20
+#define DCS_CMD_EXIT_SLEEP_MODE       0x11
+#define DCS_CMD_GET_ADDRESS_MODE      0x0B
+#define DCS_CMD_GET_BLUE_CHANNEL      0x08
+#define DCS_CMD_GET_DIAGNOSTIC_RESULT 0x0F
+#define DCS_CMD_GET_DISPLAY_MODE      0x0D
+#define DCS_CMD_GET_GREEN_CHANNEL     0x07
+#define DCS_CMD_GET_PIXEL_FORMAT      0x0C
+#define DCS_CMD_GET_POWER_MODE        0x0A
+#define DCS_CMD_GET_RED_CHANNEL       0x06
+#define DCS_CMD_GET_SCANLINE          0x45
+#define DCS_CMD_GET_SIGNAL_MODE       0x0E
+#define DCS_CMD_NOP                   0x00
+#define DCS_CMD_READ_DDB_CONTINUE     0xA8
+#define DCS_CMD_READ_DDB_START        0xA1
+#define DCS_CMD_READ_MEMORY_CONTINE   0x3E
+#define DCS_CMD_READ_MEMORY_START     0x2E
+#define DCS_CMD_SET_ADDRESS_MODE      0x36
+#define DCS_CMD_SET_COLUMN_ADDRESS    0x2A
+#define DCS_CMD_SET_DISPLAY_OFF       0x28
+#define DCS_CMD_SET_DISPLAY_ON        0x29
+#define DCS_CMD_SET_GAMMA_CURVE       0x26
+#define DCS_CMD_SET_PAGE_ADDRESS      0x2B
+#define DCS_CMD_SET_PARTIAL_AREA      0x30
+#define DCS_CMD_SET_PIXEL_FORMAT      0x3A
+#define DCS_CMD_SET_SCROLL_AREA       0x33
+#define DCS_CMD_SET_SCROLL_START      0x37
+#define DCS_CMD_SET_TEAR_OFF          0x34
+#define DCS_CMD_SET_TEAR_ON           0x35
+#define DCS_CMD_SET_TEAR_SCANLINE     0x44
+#define DCS_CMD_SOFT_RESET            0x01
+#define DCS_CMD_WRITE_LUT             0x2D
+#define DCS_CMD_WRITE_CONTINUE        0x3C
+#define DCS_CMD_WRITE_START           0x2C
+
+#define MCDE_MAX_DCS_READ   4
+#define MCDE_MAX_DCS_WRITE 15
+
+int mcde_dsi_dcs_write(struct mcde_chnl_state *chnl, u8 cmd, u8* data, int len);
+int mcde_dsi_dcs_read(struct mcde_chnl_state *chnl, u8 cmd, u8* data, int *len);
+
+/* MCDE */
+
+/* Driver data */
+#define MCDE_IRQ     "MCDE IRQ"
+#define MCDE_IO_AREA "MCDE I/O Area"
+
+struct mcde_platform_data {
+	/* DSI */
+	int num_dsilinks;
+
+	/* DPI */
+	u8 outmux[5]; /* MCDE_CONF0.OUTMUXx */
+	u8 syncmux;   /* MCDE_CONF0.SYNCMUXx */
+
+	const char *regulator_id;
+	const char *clock_dsi_id;
+	const char *clock_dsi_lp_id;
+	const char *clock_mcde_id;
+
+	int (*platform_enable)(void);
+	int (*platform_disable)(void);
+};
+
+int mcde_init(void);
+void mcde_exit(void);
+
+#endif /* __MCDE__H__ */
+
-- 
1.6.3.3

