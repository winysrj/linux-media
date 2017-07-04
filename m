Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:34970 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752395AbdGDOM1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 10:12:27 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sylwester Nawrocki <snawrocki@kernel.org>
Subject: [PATCH v6 2/4] [media] platform: Add Synopsys Designware HDMI RX Controller Driver
Date: Tue,  4 Jul 2017 15:11:38 +0100
Message-Id: <26f5e57f34dff4d3bf81e78ab39b9ed9ab7ea459.1499176790.git.joabreu@synopsys.com>
In-Reply-To: <cover.1499176790.git.joabreu@synopsys.com>
References: <cover.1499176790.git.joabreu@synopsys.com>
In-Reply-To: <cover.1499176790.git.joabreu@synopsys.com>
References: <cover.1499176790.git.joabreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an initial submission for the Synopsys Designware HDMI RX
Controller Driver. This driver interacts with a phy driver so that
a communication between them is created and a video pipeline is
configured.

The controller + phy pipeline can then be integrated into a fully
featured system that can be able to receive video up to 4k@60Hz
with deep color 48bit RGB, depending on the platform. Although,
this initial version does not yet handle deep color modes.

This driver was implemented as a standard V4L2 subdevice and its
main features are:
	- Internal state machine that reconfigures phy until the
	video is not stable
	- JTAG communication with phy
	- Inter-module communication with phy driver
	- Debug write/read ioctls

Some notes:
	- RX sense controller (cable connection/disconnection) must
	be handled by the platform wrapper as this is not integrated
	into the controller RTL
	- The same goes for EDID ROM's
	- ZCAL calibration is needed only in FPGA platforms, in ASIC
	this is not needed
	- The state machine is not an ideal solution as it creates a
	kthread but it is needed because some sources might not be
	very stable at sending the video (i.e. we must react
	accordingly).

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sylwester Nawrocki <snawrocki@kernel.org>

Changes from v5:
	- Removed HDCP 1.4 support (Hans)
	- Removed some CEC debug messages (Hans)
	- Add s_dv_timings callback (Hans)
	- Add V4L2_CID_DV_RX_POWER_PRESENT ctrl (Hans)
Changes from v4:
	- Add flag V4L2_SUBDEV_FL_HAS_DEVNODE (Sylwester)
	- Remove some comments and change some messages to dev_dbg (Sylwester)
	- Use v4l2_async_subnotifier_register() (Sylwester)
Changes from v3:
	- Use v4l2 async API (Sylwester)
	- Do not block waiting for phy
	- Do not use busy waiting delays (Sylwester)
	- Simplify dw_hdmi_power_on (Sylwester)
	- Use clock API (Sylwester)
	- Use compatible string (Sylwester)
	- Minor fixes (Sylwester)
Changes from v2:
	- Address review comments from Hans regarding CEC
	- Use CEC notifier
	- Enable SCDC
Changes from v1:
	- Add support for CEC
	- Correct typo errors
	- Correctly detect interlaced video modes
	- Correct VIC parsing
Changes from RFC:
	- Add support for HDCP 1.4
	- Fixup HDMI_VIC not being parsed (Hans)
	- Send source change signal when powering off (Hans)
	- Add a "wait stable delay"
	- Detect interlaced video modes (Hans)
	- Restrain g/s_register from reading/writing to HDCP regs (Hans)
---
 drivers/media/platform/dwc/Kconfig      |   15 +
 drivers/media/platform/dwc/Makefile     |    1 +
 drivers/media/platform/dwc/dw-hdmi-rx.c | 1809 +++++++++++++++++++++++++++++++
 drivers/media/platform/dwc/dw-hdmi-rx.h |  441 ++++++++
 include/media/dwc/dw-hdmi-rx-pdata.h    |   70 ++
 5 files changed, 2336 insertions(+)
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.c
 create mode 100644 drivers/media/platform/dwc/dw-hdmi-rx.h
 create mode 100644 include/media/dwc/dw-hdmi-rx-pdata.h

diff --git a/drivers/media/platform/dwc/Kconfig b/drivers/media/platform/dwc/Kconfig
index 361d38d..3ddccde 100644
--- a/drivers/media/platform/dwc/Kconfig
+++ b/drivers/media/platform/dwc/Kconfig
@@ -6,3 +6,18 @@ config VIDEO_DWC_HDMI_PHY_E405
 
 	  To compile this driver as a module, choose M here. The module
 	  will be called dw-hdmi-phy-e405.
+
+config VIDEO_DWC_HDMI_RX
+	tristate "Synopsys Designware HDMI Receiver driver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	help
+	  Support for Synopsys Designware HDMI RX controller.
+
+	  To compile this driver as a module, choose M here. The module
+	  will be called dw-hdmi-rx.
+
+config VIDEO_DWC_HDMI_RX_CEC
+	bool
+	depends on VIDEO_DWC_HDMI_RX
+	select CEC_CORE
+	select CEC_NOTIFIER
diff --git a/drivers/media/platform/dwc/Makefile b/drivers/media/platform/dwc/Makefile
index fc3b62c..cd04ca9 100644
--- a/drivers/media/platform/dwc/Makefile
+++ b/drivers/media/platform/dwc/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_VIDEO_DWC_HDMI_PHY_E405) += dw-hdmi-phy-e405.o
+obj-$(CONFIG_VIDEO_DWC_HDMI_RX) += dw-hdmi-rx.o
diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.c b/drivers/media/platform/dwc/dw-hdmi-rx.c
new file mode 100644
index 0000000..a7ae5a3
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-hdmi-rx.c
@@ -0,0 +1,1809 @@
+/*
+ * Synopsys Designware HDMI Receiver controller driver
+ *
+ * This Synopsys dw-hdmi-rx software and associated documentation
+ * (hereinafter the "Software") is an unsupported proprietary work of
+ * Synopsys, Inc. unless otherwise expressly agreed to in writing between
+ * Synopsys and you. The Software IS NOT an item of Licensed Software or a
+ * Licensed Product under any End User Software License Agreement or
+ * Agreement for Licensed Products with Synopsys or any supplement thereto.
+ * Synopsys is a registered trademark of Synopsys, Inc. Other names included
+ * in the SOFTWARE may be the trademarks of their respective owners.
+ *
+ * The contents of this file are dual-licensed; you may select either version 2
+ * of the GNU General Public License (“GPL”) or the MIT license (“MIT”).
+ *
+ * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE
+ * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/v4l2-dv-timings.h>
+#include <linux/workqueue.h>
+#include <media/cec.h>
+#include <media/cec-notifier.h>
+#include <media/v4l2-async.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-dv-timings.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-subdev.h>
+#include <media/dwc/dw-hdmi-phy-pdata.h>
+#include <media/dwc/dw-hdmi-rx-pdata.h>
+#include "dw-hdmi-rx.h"
+
+#define HDMI_DEFAULT_TIMING		V4L2_DV_BT_CEA_640X480P59_94
+#define HDMI_CEC_MAX_LOG_ADDRS		CEC_MAX_LOG_ADDRS
+
+MODULE_AUTHOR("Carlos Palminha <palminha@synopsys.com>");
+MODULE_AUTHOR("Jose Abreu <joabreu@synopsys.com>");
+MODULE_DESCRIPTION("Designware HDMI Receiver driver");
+MODULE_LICENSE("Dual MIT/GPL");
+
+static const struct v4l2_dv_timings_cap dw_hdmi_timings_cap = {
+	.type = V4L2_DV_BT_656_1120,
+	.reserved = { 0 },
+	V4L2_INIT_BT_TIMINGS(
+			640, 4096,		/* min/max width */
+			480, 4455,		/* min/max height */
+			20000000, 600000000,	/* min/max pixelclock */
+			V4L2_DV_BT_STD_CEA861,	/* standards */
+			/* capabilities */
+			V4L2_DV_BT_CAP_PROGRESSIVE
+	)
+};
+
+static const struct v4l2_event dw_hdmi_event_fmt = {
+	.type = V4L2_EVENT_SOURCE_CHANGE,
+	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+};
+
+enum dw_hdmi_state {
+	HDMI_STATE_NO_INIT = 0,
+	HDMI_STATE_POWER_OFF,
+	HDMI_STATE_PHY_CONFIG,
+	HDMI_STATE_EQUALIZER,
+	HDMI_STATE_VIDEO_UNSTABLE,
+	HDMI_STATE_POWER_ON,
+};
+
+struct dw_hdmi_dev {
+	struct v4l2_async_notifier v4l2_notifier;
+	struct v4l2_async_subdev phy_async_sd;
+	struct dw_hdmi_rx_pdata *config;
+	struct workqueue_struct *wq;
+	struct work_struct work;
+	enum dw_hdmi_state state;
+	bool registered;
+	bool pending_config;
+	bool force_off;
+	spinlock_t lock;
+	void __iomem *regs;
+	struct device_node *of_node;
+	struct v4l2_subdev sd;
+	struct v4l2_dv_timings timings;
+	struct dw_phy_pdata phy_config;
+	struct platform_device *notifier_pdev;
+	struct v4l2_subdev *phy_sd;
+	bool phy_eq_force;
+	u8 phy_jtag_addr;
+	const char *phy_drv;
+	struct device *dev;
+	u32 mbus_code;
+	unsigned int selected_input;
+	unsigned int configured_input;
+	struct clk *clk;
+	u32 cfg_clk;
+	struct cec_adapter *cec_adap;
+	struct cec_notifier *cec_notifier;
+	struct v4l2_ctrl_handler hdl;
+	struct v4l2_ctrl *detect_tx_5v_ctrl;
+};
+
+static const char *get_state_name(enum dw_hdmi_state state)
+{
+	switch (state) {
+	case HDMI_STATE_NO_INIT:
+		return "NO_INIT";
+	case HDMI_STATE_POWER_OFF:
+		return "POWER_OFF";
+	case HDMI_STATE_PHY_CONFIG:
+		return "PHY_CONFIG";
+	case HDMI_STATE_EQUALIZER:
+		return "EQUALIZER";
+	case HDMI_STATE_VIDEO_UNSTABLE:
+		return "VIDEO_UNSTABLE";
+	case HDMI_STATE_POWER_ON:
+		return "POWER_ON";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static inline void dw_hdmi_set_state(struct dw_hdmi_dev *dw_dev,
+		enum dw_hdmi_state new_state)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dw_dev->lock, flags);
+	dev_dbg(dw_dev->dev, "old_state=%s, new_state=%s\n",
+			get_state_name(dw_dev->state),
+			get_state_name(new_state));
+	dw_dev->state = new_state;
+	spin_unlock_irqrestore(&dw_dev->lock, flags);
+}
+
+static inline struct dw_hdmi_dev *to_dw_dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct dw_hdmi_dev, sd);
+}
+
+static inline struct dw_hdmi_dev *notifier_to_dw_dev(
+		struct v4l2_async_notifier *notifier)
+{
+	return container_of(notifier, struct dw_hdmi_dev, v4l2_notifier);
+}
+
+static inline void hdmi_writel(struct dw_hdmi_dev *dw_dev, u32 val, int reg)
+{
+	writel(val, dw_dev->regs + reg);
+}
+
+static inline u32 hdmi_readl(struct dw_hdmi_dev *dw_dev, int reg)
+{
+	return readl(dw_dev->regs + reg);
+}
+
+static void hdmi_modl(struct dw_hdmi_dev *dw_dev, u32 data, u32 mask, int reg)
+{
+	u32 val = hdmi_readl(dw_dev, reg) & ~mask;
+
+	val |= data & mask;
+	hdmi_writel(dw_dev, val, reg);
+}
+
+static void hdmi_mask_writel(struct dw_hdmi_dev *dw_dev, u32 data, int reg,
+		u32 shift, u32 mask)
+{
+	hdmi_modl(dw_dev, data << shift, mask, reg);
+}
+
+static u32 hdmi_mask_readl(struct dw_hdmi_dev *dw_dev, int reg, u32 shift,
+		u32 mask)
+{
+	return (hdmi_readl(dw_dev, reg) & mask) >> shift;
+}
+
+static bool dw_hdmi_5v_status(struct dw_hdmi_dev *dw_dev, int input)
+{
+	void __iomem *arg = dw_dev->config->dw_5v_arg;
+
+	if (dw_dev->config->dw_5v_status)
+		return dw_dev->config->dw_5v_status(arg, input);
+	return false;
+}
+
+static void dw_hdmi_5v_clear(struct dw_hdmi_dev *dw_dev)
+{
+	void __iomem *arg = dw_dev->config->dw_5v_arg;
+
+	if (dw_dev->config->dw_5v_clear)
+		dw_dev->config->dw_5v_clear(arg);
+}
+
+static inline bool is_off(struct dw_hdmi_dev *dw_dev)
+{
+	return dw_dev->state <= HDMI_STATE_POWER_OFF;
+}
+
+static bool has_signal(struct dw_hdmi_dev *dw_dev, unsigned int input)
+{
+	return dw_hdmi_5v_status(dw_dev, input);
+}
+
+#define HDMI_JTAG_TAP_ADDR_CMD		0
+#define HDMI_JTAG_TAP_WRITE_CMD		1
+#define HDMI_JTAG_TAP_READ_CMD		3
+
+static void hdmi_phy_jtag_send_pulse(struct dw_hdmi_dev *dw_dev, u8 tms, u8 tdi)
+{
+	u8 val;
+
+	val = tms ? HDMI_PHY_JTAG_TAP_IN_TMS : 0;
+	val |= tdi ? HDMI_PHY_JTAG_TAP_IN_TDI : 0;
+
+	hdmi_writel(dw_dev, 0, HDMI_PHY_JTAG_TAP_TCLK);
+	hdmi_writel(dw_dev, val, HDMI_PHY_JTAG_TAP_IN);
+	hdmi_writel(dw_dev, 1, HDMI_PHY_JTAG_TAP_TCLK);
+}
+
+static void hdmi_phy_jtag_shift_dr(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
+}
+
+static void hdmi_phy_jtag_shift_ir(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
+	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
+}
+
+static u16 hdmi_phy_jtag_send(struct dw_hdmi_dev *dw_dev, u8 cmd, u16 val)
+{
+	u32 in = (cmd << 16) | val;
+	u16 out = 0;
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		hdmi_phy_jtag_send_pulse(dw_dev, 0, in & 0x1);
+		out |= (hdmi_readl(dw_dev, HDMI_PHY_JTAG_TAP_OUT) & 0x1) << i;
+		in >>= 1;
+	}
+
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, in & 0x1);
+	in >>= 1;
+	hdmi_phy_jtag_send_pulse(dw_dev, 1, in & 0x1);
+
+	out |= (hdmi_readl(dw_dev, HDMI_PHY_JTAG_TAP_OUT) & 0x1) << ++i;
+	return out;
+}
+
+static void hdmi_phy_jtag_idle(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
+}
+
+static void hdmi_phy_jtag_init(struct dw_hdmi_dev *dw_dev, u8 addr)
+{
+	int i;
+
+	hdmi_writel(dw_dev, addr, HDMI_PHY_JTAG_ADDR);
+	/* reset */
+	hdmi_writel(dw_dev, 0x10, HDMI_PHY_JTAG_TAP_IN);
+	hdmi_writel(dw_dev, 0x0, HDMI_PHY_JTAG_CONF);
+	hdmi_writel(dw_dev, 0x1, HDMI_PHY_JTAG_CONF);
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
+	/* soft reset */
+	for (i = 0; i < 5; i++)
+		hdmi_phy_jtag_send_pulse(dw_dev, 1, 0);
+	hdmi_phy_jtag_send_pulse(dw_dev, 0, 0);
+	/* set slave address */
+	hdmi_phy_jtag_shift_ir(dw_dev);
+	for (i = 0; i < 7; i++) {
+		hdmi_phy_jtag_send_pulse(dw_dev, 0, addr & 0x1);
+		addr >>= 1;
+	}
+	hdmi_phy_jtag_send_pulse(dw_dev, 1, addr & 0x1);
+	hdmi_phy_jtag_idle(dw_dev);
+}
+
+static void hdmi_phy_jtag_write(struct dw_hdmi_dev *dw_dev, u16 val, u16 addr)
+{
+	hdmi_phy_jtag_shift_dr(dw_dev);
+	hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_ADDR_CMD, addr << 8);
+	hdmi_phy_jtag_idle(dw_dev);
+	hdmi_phy_jtag_shift_dr(dw_dev);
+	hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_WRITE_CMD, val);
+	hdmi_phy_jtag_idle(dw_dev);
+}
+
+static u16 hdmi_phy_jtag_read(struct dw_hdmi_dev *dw_dev, u16 addr)
+{
+	u16 val;
+
+	hdmi_phy_jtag_shift_dr(dw_dev);
+	hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_ADDR_CMD, addr << 8);
+	hdmi_phy_jtag_idle(dw_dev);
+	hdmi_phy_jtag_shift_dr(dw_dev);
+	val = hdmi_phy_jtag_send(dw_dev, HDMI_JTAG_TAP_READ_CMD, 0xFFFF);
+	hdmi_phy_jtag_idle(dw_dev);
+	
+	return val;
+}
+
+static void dw_hdmi_phy_write(void *arg, u16 val, u16 addr)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+	u16 rval;
+
+	hdmi_phy_jtag_init(dw_dev, dw_dev->phy_jtag_addr);
+	hdmi_phy_jtag_write(dw_dev, val, addr);
+	rval = hdmi_phy_jtag_read(dw_dev, addr);
+
+	if (rval != val) {
+		dev_err(dw_dev->dev,
+			"JTAG read-back failed: expected=0x%x, got=0x%x\n",
+			val, rval);
+	}
+}
+
+static u16 dw_hdmi_phy_read(void *arg, u16 addr)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+
+	hdmi_phy_jtag_init(dw_dev, dw_dev->phy_jtag_addr);
+	return hdmi_phy_jtag_read(dw_dev, addr);
+}
+
+static void dw_hdmi_phy_reset(void *arg, int enable)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+
+	hdmi_mask_writel(dw_dev, enable, HDMI_PHY_CTRL,
+			HDMI_PHY_CTRL_RESET_OFFSET,
+			HDMI_PHY_CTRL_RESET_MASK);
+}
+
+static void dw_hdmi_phy_pddq(void *arg, int enable)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+
+	hdmi_mask_writel(dw_dev, enable, HDMI_PHY_CTRL,
+			HDMI_PHY_CTRL_PDDQ_OFFSET,
+			HDMI_PHY_CTRL_PDDQ_MASK);
+}
+
+static void dw_hdmi_phy_svsmode(void *arg, int enable)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+
+	hdmi_mask_writel(dw_dev, enable, HDMI_PHY_CTRL,
+			HDMI_PHY_CTRL_SVSRETMODEZ_OFFSET,
+			HDMI_PHY_CTRL_SVSRETMODEZ_MASK);
+}
+
+static void dw_hdmi_zcal_reset(void *arg)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+
+	if (dw_dev->config->dw_zcal_reset)
+		dw_dev->config->dw_zcal_reset(dw_dev->config->dw_zcal_arg);
+}
+
+static bool dw_hdmi_zcal_done(void *arg)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+
+	if (dw_dev->config->dw_zcal_done)
+		return dw_dev->config->dw_zcal_done(dw_dev->config->dw_zcal_arg);
+	return true;
+}
+
+static bool dw_hdmi_tmds_valid(void *arg)
+{
+	struct dw_hdmi_dev *dw_dev = arg;
+
+	return hdmi_readl(dw_dev, HDMI_PLL_LCK_STS) & HDMI_PLL_LCK_STS_PLL_LOCKED;
+}
+
+static const struct dw_phy_funcs dw_hdmi_phy_funcs = {
+	.write = dw_hdmi_phy_write,
+	.read = dw_hdmi_phy_read,
+	.reset = dw_hdmi_phy_reset,
+	.pddq = dw_hdmi_phy_pddq,
+	.svsmode = dw_hdmi_phy_svsmode,
+	.zcal_reset = dw_hdmi_zcal_reset,
+	.zcal_done = dw_hdmi_zcal_done,
+	.tmds_valid = dw_hdmi_tmds_valid,
+};
+
+static const struct of_device_id dw_hdmi_supported_phys[] = {
+	{ .compatible = "snps,dw-hdmi-phy-e405", .data = DW_PHY_E405_DRVNAME, },
+	{ },
+};
+
+static struct device_node *dw_hdmi_get_phy_of_node(struct dw_hdmi_dev *dw_dev,
+		const struct of_device_id **found_id)
+{
+	struct device_node *child = NULL;
+	const struct of_device_id *id;
+
+	for_each_child_of_node(dw_dev->of_node, child) {
+		id = of_match_node(dw_hdmi_supported_phys, child);
+		if (id)
+			break;
+	}
+
+	if (!id)
+		return NULL;
+	if (found_id)
+		*found_id = id;
+
+	return child;
+}
+
+static int dw_hdmi_phy_init(struct dw_hdmi_dev *dw_dev)
+{
+	struct dw_phy_pdata *phy = &dw_dev->phy_config;
+	struct of_dev_auxdata lookup = { };
+	const struct of_device_id *of_id;
+	struct device_node *child;
+	const char *drvname;
+	int ret;
+
+	child = dw_hdmi_get_phy_of_node(dw_dev, &of_id);
+	if (!child || !of_id || !of_id->data) {
+		dev_err(dw_dev->dev, "no supported phy found in DT\n");
+		return -EINVAL;
+	}
+
+	drvname = of_id->data;
+	phy->funcs = &dw_hdmi_phy_funcs;
+	phy->funcs_arg = dw_dev;
+
+	lookup.compatible = (char *)of_id->compatible;
+	lookup.platform_data = phy;
+
+	request_module(drvname);
+
+	ret = of_platform_populate(dw_dev->of_node, NULL, &lookup, dw_dev->dev);
+	if (ret) {
+		dev_err(dw_dev->dev, "failed to populate phy driver\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void dw_hdmi_phy_exit(struct dw_hdmi_dev *dw_dev)
+{
+	of_platform_depopulate(dw_dev->dev);
+}
+
+static int dw_hdmi_phy_eq_init(struct dw_hdmi_dev *dw_dev, u16 acq, bool force)
+{
+	struct dw_phy_eq_command cmd = {
+		.result = 0,
+		.nacq = acq,
+		.force = force,
+	};
+	int ret;
+
+	ret = v4l2_subdev_call(dw_dev->phy_sd, core, ioctl,
+			DW_PHY_IOCTL_EQ_INIT, &cmd);
+	if (ret)
+		return ret;
+	return cmd.result;
+}
+
+static int dw_hdmi_phy_config(struct dw_hdmi_dev *dw_dev,
+		unsigned char color_depth, bool hdmi2, bool scrambling)
+{
+	struct dw_phy_config_command cmd = {
+		.result = 0,
+		.color_depth = color_depth,
+		.hdmi2 = hdmi2,
+		.scrambling = scrambling,
+	};
+	int ret;
+
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
+			HDMI_CBUSIOCTRL_DATAPATH_CBUSZ_OFFSET,
+			HDMI_CBUSIOCTRL_DATAPATH_CBUSZ_MASK);
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
+			HDMI_CBUSIOCTRL_SVSRETMODEZ_OFFSET,
+			HDMI_CBUSIOCTRL_SVSRETMODEZ_MASK);
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
+			HDMI_CBUSIOCTRL_PDDQ_OFFSET,
+			HDMI_CBUSIOCTRL_PDDQ_MASK);
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_CBUSIOCTRL,
+			HDMI_CBUSIOCTRL_RESET_OFFSET,
+			HDMI_CBUSIOCTRL_RESET_MASK);
+
+	ret = v4l2_subdev_call(dw_dev->phy_sd, core, ioctl,
+			DW_PHY_IOCTL_CONFIG, &cmd);
+	if (ret)
+		return ret;
+	return cmd.result;
+}
+
+static void dw_hdmi_phy_s_power(struct dw_hdmi_dev *dw_dev, bool on)
+{
+	v4l2_subdev_call(dw_dev->phy_sd, core, s_power, on);
+}
+
+static void dw_hdmi_event_source_change(struct dw_hdmi_dev *dw_dev)
+{
+	if (dw_dev->registered)
+		v4l2_subdev_notify_event(&dw_dev->sd, &dw_hdmi_event_fmt);
+}
+
+static int dw_hdmi_wait_phy_lock_poll(struct dw_hdmi_dev *dw_dev)
+{
+	int timeout = 10;
+
+	while (!dw_hdmi_tmds_valid(dw_dev) && timeout-- && !dw_dev->force_off)
+		usleep_range(5000, 10000);
+
+	if (!dw_hdmi_tmds_valid(dw_dev))
+		return -ETIMEDOUT;
+	return 0;
+}
+
+static void dw_hdmi_reset_datapath(struct dw_hdmi_dev *dw_dev)
+{
+	u32 val = HDMI_DMI_SW_RST_TMDS |
+		HDMI_DMI_SW_RST_HDCP |
+		HDMI_DMI_SW_RST_VID |
+		HDMI_DMI_SW_RST_PIXEL |
+		HDMI_DMI_SW_RST_CEC |
+		HDMI_DMI_SW_RST_AUD |
+		HDMI_DMI_SW_RST_BUS |
+		HDMI_DMI_SW_RST_HDMI |
+		HDMI_DMI_SW_RST_MODET;
+
+	hdmi_writel(dw_dev, val, HDMI_DMI_SW_RST);
+}
+
+static void dw_hdmi_wait_video_stable(struct dw_hdmi_dev *dw_dev)
+{
+	/*
+	 * Empiric value. Video should be stable way longer before the
+	 * end of this sleep time. Though, we can have some video change
+	 * interrupts before the video is stable so filter them by sleeping.
+	 */
+	msleep(200);
+}
+
+static void dw_hdmi_enable_ints(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_writel(dw_dev, HDMI_ISTS_CLK_CHANGE | HDMI_ISTS_PLL_LCK_CHG,
+			HDMI_IEN_SET);
+	hdmi_writel(dw_dev, (~0x0) & (~HDMI_MD_ISTS_VOFS_LIN), HDMI_MD_IEN_SET);
+}
+
+static void dw_hdmi_disable_ints(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_writel(dw_dev, ~0x0, HDMI_IEN_CLR);
+	hdmi_writel(dw_dev, ~0x0, HDMI_MD_IEN_CLR);
+}
+
+static void dw_hdmi_clear_ints(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_writel(dw_dev, ~0x0, HDMI_ICLR);
+	hdmi_writel(dw_dev, ~0x0, HDMI_MD_ICLR);
+}
+
+static u32 dw_hdmi_get_int_val(struct dw_hdmi_dev *dw_dev, u32 ists, u32 ien)
+{
+	return hdmi_readl(dw_dev, ists) & hdmi_readl(dw_dev, ien);
+}
+
+#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
+static void dw_hdmi_cec_enable_ints(struct dw_hdmi_dev *dw_dev)
+{
+	u32 mask = HDMI_AUD_CEC_ISTS_DONE | HDMI_AUD_CEC_ISTS_EOM |
+		HDMI_AUD_CEC_ISTS_NACK | HDMI_AUD_CEC_ISTS_ARBLST |
+		HDMI_AUD_CEC_ISTS_ERROR_INIT | HDMI_AUD_CEC_ISTS_ERROR_FOLL;
+
+	hdmi_writel(dw_dev, mask, HDMI_AUD_CEC_IEN_SET);
+	hdmi_writel(dw_dev, 0x0, HDMI_CEC_MASK);
+}
+
+static void dw_hdmi_cec_disable_ints(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_writel(dw_dev, ~0x0, HDMI_AUD_CEC_IEN_CLR);
+	hdmi_writel(dw_dev, ~0x0, HDMI_CEC_MASK);
+}
+
+static void dw_hdmi_cec_clear_ints(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_writel(dw_dev, ~0x0, HDMI_AUD_CEC_ICLR);
+}
+
+static void dw_hdmi_cec_tx_raw_status(struct dw_hdmi_dev *dw_dev, u32 stat)
+{
+	if (hdmi_readl(dw_dev, HDMI_CEC_CTRL) & HDMI_CEC_CTRL_SEND_MASK) {
+		dev_dbg(dw_dev->dev, "%s: tx is busy\n", __func__);
+		return;
+	}
+
+	if (stat & HDMI_AUD_CEC_ISTS_ARBLST) {
+		cec_transmit_attempt_done(dw_dev->cec_adap,
+				CEC_TX_STATUS_ARB_LOST);
+		return;
+	}
+
+	if (stat & HDMI_AUD_CEC_ISTS_NACK) {
+		cec_transmit_attempt_done(dw_dev->cec_adap, CEC_TX_STATUS_NACK);
+		return;
+	}
+
+	if (stat & HDMI_AUD_CEC_ISTS_ERROR_INIT) {
+		dev_dbg(dw_dev->dev, "%s: got initiator error\n", __func__);
+		cec_transmit_attempt_done(dw_dev->cec_adap, CEC_TX_STATUS_ERROR);
+		return;
+	}
+
+	if (stat & HDMI_AUD_CEC_ISTS_DONE) {
+		cec_transmit_attempt_done(dw_dev->cec_adap, CEC_TX_STATUS_OK);
+		return;
+	}
+}
+
+static void dw_hdmi_cec_received_msg(struct dw_hdmi_dev *dw_dev)
+{
+	struct cec_msg msg;
+	u8 i;
+
+	msg.len = hdmi_readl(dw_dev, HDMI_CEC_RX_CNT);
+	if (!msg.len || msg.len > HDMI_CEC_RX_DATA_MAX)
+		return; /* it's an invalid/non-existent message */
+
+	for (i = 0; i < msg.len; i++)
+		msg.msg[i] = hdmi_readl(dw_dev, HDMI_CEC_RX_DATA(i));
+
+	hdmi_writel(dw_dev, 0x0, HDMI_CEC_LOCK);
+	cec_received_msg(dw_dev->cec_adap, &msg);
+}
+
+static int dw_hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct dw_hdmi_dev *dw_dev = cec_get_drvdata(adap);
+
+	if (enable) {
+		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_L);
+		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_H);
+		hdmi_writel(dw_dev, 0x0, HDMI_CEC_LOCK);
+		dw_hdmi_cec_clear_ints(dw_dev);
+		dw_hdmi_cec_enable_ints(dw_dev);
+	} else {
+		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_L);
+		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_H);
+		dw_hdmi_cec_disable_ints(dw_dev);
+		dw_hdmi_cec_clear_ints(dw_dev);
+	}
+
+	return 0;
+}
+
+static int dw_hdmi_cec_adap_log_addr(struct cec_adapter *adap, u8 addr)
+{
+	struct dw_hdmi_dev *dw_dev = cec_get_drvdata(adap);
+	u32 tmp;
+
+	if (addr == CEC_LOG_ADDR_INVALID) {
+		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_L);
+		hdmi_writel(dw_dev, 0x0, HDMI_CEC_ADDR_H);
+		return 0;
+	}
+
+	if (addr >= 8) {
+		tmp = hdmi_readl(dw_dev, HDMI_CEC_ADDR_H);
+		tmp |= BIT(addr - 8);
+		hdmi_writel(dw_dev, tmp, HDMI_CEC_ADDR_H);
+	} else {
+		tmp = hdmi_readl(dw_dev, HDMI_CEC_ADDR_L);
+		tmp |= BIT(addr);
+		hdmi_writel(dw_dev, tmp, HDMI_CEC_ADDR_L);
+	}
+
+	return 0;
+}
+
+static int dw_hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+		u32 signal_free_time, struct cec_msg *msg)
+{
+	struct dw_hdmi_dev *dw_dev = cec_get_drvdata(adap);
+	u8 len = msg->len;
+	u32 reg;
+	int i;
+
+	if (hdmi_readl(dw_dev, HDMI_CEC_CTRL) & HDMI_CEC_CTRL_SEND_MASK) {
+		dev_err(dw_dev->dev, "%s: tx is busy\n", __func__);
+		return -EBUSY;
+	}
+
+	for (i = 0; i < len; i++)
+		hdmi_writel(dw_dev, msg->msg[i], HDMI_CEC_TX_DATA(i));
+
+	switch (signal_free_time) {
+	case CEC_SIGNAL_FREE_TIME_RETRY:
+		reg = 0x0;
+		break;
+	case CEC_SIGNAL_FREE_TIME_NEXT_XFER:
+		reg = 0x2;
+		break;
+	case CEC_SIGNAL_FREE_TIME_NEW_INITIATOR:
+	default:
+		reg = 0x1;
+		break;
+	}
+
+	hdmi_writel(dw_dev, len, HDMI_CEC_TX_CNT);
+	hdmi_mask_writel(dw_dev, reg, HDMI_CEC_CTRL,
+			HDMI_CEC_CTRL_FRAME_TYP_OFFSET,
+			HDMI_CEC_CTRL_FRAME_TYP_MASK);
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_CEC_CTRL,
+			HDMI_CEC_CTRL_SEND_OFFSET,
+			HDMI_CEC_CTRL_SEND_MASK);
+	return 0;
+}
+
+static const struct cec_adap_ops dw_hdmi_cec_adap_ops = {
+	.adap_enable = dw_hdmi_cec_adap_enable,
+	.adap_log_addr = dw_hdmi_cec_adap_log_addr,
+	.adap_transmit = dw_hdmi_cec_adap_transmit,
+};
+
+static void dw_hdmi_cec_irq_handler(struct dw_hdmi_dev *dw_dev)
+{
+	u32 cec_ists = dw_hdmi_get_int_val(dw_dev, HDMI_AUD_CEC_ISTS,
+			HDMI_AUD_CEC_IEN);
+
+	dw_hdmi_cec_clear_ints(dw_dev);
+
+	if (cec_ists) {
+		dw_hdmi_cec_tx_raw_status(dw_dev, cec_ists);
+		if (cec_ists & HDMI_AUD_CEC_ISTS_EOM)
+			dw_hdmi_cec_received_msg(dw_dev);
+	}
+}
+#endif
+
+static u8 dw_hdmi_get_curr_vic(struct dw_hdmi_dev *dw_dev, bool *is_hdmi_vic)
+{
+	u8 vic = hdmi_mask_readl(dw_dev, HDMI_PDEC_AVI_PB,
+			HDMI_PDEC_AVI_PB_VID_IDENT_CODE_OFFSET,
+			HDMI_PDEC_AVI_PB_VID_IDENT_CODE_MASK) & 0xff;
+
+	if (!vic) {
+		vic = hdmi_mask_readl(dw_dev, HDMI_PDEC_VSI_PAYLOAD0,
+				HDMI_PDEC_VSI_PAYLOAD0_HDMI_VIC_OFFSET,
+				HDMI_PDEC_VSI_PAYLOAD0_HDMI_VIC_MASK) & 0xff;
+		if (is_hdmi_vic)
+			*is_hdmi_vic = true;
+	} else {
+		if (is_hdmi_vic)
+			*is_hdmi_vic = false;
+	}
+
+	return vic;
+}
+
+static u64 dw_hdmi_get_pixelclk(struct dw_hdmi_dev *dw_dev)
+{
+	u32 rate = hdmi_mask_readl(dw_dev, HDMI_CKM_RESULT,
+			HDMI_CKM_RESULT_CLKRATE_OFFSET,
+			HDMI_CKM_RESULT_CLKRATE_MASK);
+	u32 evaltime = hdmi_mask_readl(dw_dev, HDMI_CKM_EVLTM,
+			HDMI_CKM_EVLTM_EVAL_TIME_OFFSET,
+			HDMI_CKM_EVLTM_EVAL_TIME_MASK);
+	u64 tmp = (u64)rate * (u64)dw_dev->cfg_clk * 1000000;
+
+	do_div(tmp, evaltime);
+	return tmp;
+}
+
+static u32 dw_hdmi_get_colordepth(struct dw_hdmi_dev *dw_dev)
+{
+	u32 dcm = hdmi_mask_readl(dw_dev, HDMI_STS,
+			HDMI_STS_DCM_CURRENT_MODE_OFFSET,
+			HDMI_STS_DCM_CURRENT_MODE_MASK);
+
+	switch (dcm) {
+	case 0x4:
+		return 24;
+	case 0x5:
+		return 30;
+	case 0x6:
+		return 36;
+	case 0x7:
+		return 48;
+	default:
+		return 24;
+	}
+}
+
+static void dw_hdmi_set_input(struct dw_hdmi_dev *dw_dev, u32 input)
+{
+	hdmi_mask_writel(dw_dev, input, HDMI_PHY_CTRL,
+			HDMI_PHY_CTRL_PORTSELECT_OFFSET,
+			HDMI_PHY_CTRL_PORTSELECT_MASK);
+}
+
+static void dw_hdmi_enable_hpd(struct dw_hdmi_dev *dw_dev, u32 input_mask)
+{
+	hdmi_mask_writel(dw_dev, input_mask, HDMI_SETUP_CTRL,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_OFFSET,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_MASK);
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_SETUP_CTRL,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_OFFSET,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_MASK);
+}
+
+static void dw_hdmi_disable_hpd(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_mask_writel(dw_dev, 0x0, HDMI_SETUP_CTRL,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_OFFSET,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_MASK);
+	hdmi_mask_writel(dw_dev, 0x0, HDMI_SETUP_CTRL,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_OFFSET,
+			HDMI_SETUP_CTRL_HOT_PLUG_DETECT_MASK);
+}
+
+static void dw_hdmi_enable_scdc(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_SCDC_CONFIG,
+			HDMI_SCDC_CONFIG_POWERPROVIDED_OFFSET,
+			HDMI_SCDC_CONFIG_POWERPROVIDED_MASK);
+}
+
+static void dw_hdmi_disable_scdc(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_mask_writel(dw_dev, 0x0, HDMI_SCDC_CONFIG,
+			HDMI_SCDC_CONFIG_POWERPROVIDED_OFFSET,
+			HDMI_SCDC_CONFIG_POWERPROVIDED_MASK);
+}
+
+static int dw_hdmi_config(struct dw_hdmi_dev *dw_dev, u32 input)
+{
+	int eqret, ret = 0;
+
+	while (1) {
+		/* Give up silently if we are forcing off */
+		if (dw_dev->force_off) {
+			ret = 0;
+			goto out;
+		}
+		/* Give up silently if input has disconnected */
+		if (!has_signal(dw_dev, input)) {
+			ret = 0;
+			goto out;
+		}
+
+		switch (dw_dev->state) {
+		case HDMI_STATE_POWER_OFF:
+			dw_hdmi_disable_ints(dw_dev);
+			dw_hdmi_set_state(dw_dev, HDMI_STATE_PHY_CONFIG);
+			break;
+		case HDMI_STATE_PHY_CONFIG:
+			dw_hdmi_phy_s_power(dw_dev, true);
+			dw_hdmi_phy_config(dw_dev, 8, false, false);
+			dw_hdmi_set_state(dw_dev, HDMI_STATE_EQUALIZER);
+			break;
+		case HDMI_STATE_EQUALIZER:
+			eqret = dw_hdmi_phy_eq_init(dw_dev, 5,
+					dw_dev->phy_eq_force);
+			ret = dw_hdmi_wait_phy_lock_poll(dw_dev);
+
+			/* Do not force equalizer */
+			dw_dev->phy_eq_force = false;
+
+			if (ret || eqret) {
+				if (ret || eqret == -ETIMEDOUT) {
+					/* No TMDSVALID signal:
+					 * 	- force equalizer */
+					dw_dev->phy_eq_force = true;
+				}
+				break;
+			}
+
+			dw_hdmi_set_state(dw_dev, HDMI_STATE_VIDEO_UNSTABLE);
+			break;
+		case HDMI_STATE_VIDEO_UNSTABLE:
+			dw_hdmi_reset_datapath(dw_dev);
+			dw_hdmi_wait_video_stable(dw_dev);
+			dw_hdmi_clear_ints(dw_dev);
+			dw_hdmi_enable_ints(dw_dev);
+			dw_hdmi_set_state(dw_dev, HDMI_STATE_POWER_ON);
+			break;
+		case HDMI_STATE_POWER_ON:
+			break;
+		default:
+			dev_err(dw_dev->dev, "%s called with state (%d)\n",
+					__func__, dw_dev->state);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (dw_dev->state == HDMI_STATE_POWER_ON) {
+			dev_info(dw_dev->dev, "HDMI-RX configured\n");
+			dw_hdmi_event_source_change(dw_dev);
+			return 0;
+		}
+	}
+
+out:
+	dw_hdmi_set_state(dw_dev, HDMI_STATE_POWER_OFF);
+	return ret;
+}
+
+static void dw_hdmi_config_hdcp(struct dw_hdmi_dev *dw_dev)
+{
+	hdmi_mask_writel(dw_dev, 0x0, HDMI_HDCP22_CONTROL,
+			HDMI_HDCP22_CONTROL_OVR_VAL_OFFSET,
+			HDMI_HDCP22_CONTROL_OVR_VAL_MASK);
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_HDCP22_CONTROL,
+			HDMI_HDCP22_CONTROL_OVR_EN_OFFSET,
+			HDMI_HDCP22_CONTROL_OVR_EN_MASK);
+}
+
+static int __dw_hdmi_power_on(struct dw_hdmi_dev *dw_dev, u32 input)
+{
+	unsigned long flags;
+	int ret;
+
+	ret = dw_hdmi_config(dw_dev, input);
+
+	spin_lock_irqsave(&dw_dev->lock, flags);
+	dw_dev->pending_config = false;
+	spin_unlock_irqrestore(&dw_dev->lock, flags);
+
+	return ret;
+}
+
+static void dw_hdmi_work_handler(struct work_struct *work)
+{
+	struct dw_hdmi_dev *dw_dev = container_of(work, struct dw_hdmi_dev, work);
+
+	__dw_hdmi_power_on(dw_dev, dw_dev->configured_input);
+}
+
+static int dw_hdmi_power_on(struct dw_hdmi_dev *dw_dev, u32 input)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dw_dev->lock, flags);
+	if (dw_dev->pending_config) {
+		spin_unlock_irqrestore(&dw_dev->lock, flags);
+		return 0;
+	}
+
+	INIT_WORK(&dw_dev->work, dw_hdmi_work_handler);
+	dw_dev->configured_input = input;
+	dw_dev->pending_config = true;
+	queue_work(dw_dev->wq, &dw_dev->work);
+	spin_unlock_irqrestore(&dw_dev->lock, flags);
+	return 0;
+}
+
+static void dw_hdmi_power_off(struct dw_hdmi_dev *dw_dev)
+{
+	unsigned long flags;
+
+	dw_dev->force_off = true;
+	flush_workqueue(dw_dev->wq);
+	dw_dev->force_off = false;
+
+	spin_lock_irqsave(&dw_dev->lock, flags);
+	dw_dev->pending_config = false;
+	dw_dev->state = HDMI_STATE_POWER_OFF;
+	spin_unlock_irqrestore(&dw_dev->lock, flags);
+
+	/* Reset variables */
+	dw_dev->phy_eq_force = true;
+
+	/* Send source change event to userspace */
+	dw_hdmi_event_source_change(dw_dev);
+}
+
+static irqreturn_t dw_hdmi_irq_handler(int irq, void *dev_data)
+{
+	struct dw_hdmi_dev *dw_dev = dev_data;
+	u32 hdmi_ists = dw_hdmi_get_int_val(dw_dev, HDMI_ISTS, HDMI_IEN);
+	u32 md_ists = dw_hdmi_get_int_val(dw_dev, HDMI_MD_ISTS, HDMI_MD_IEN);
+
+	dw_hdmi_clear_ints(dw_dev);
+
+	if ((hdmi_ists & HDMI_ISTS_CLK_CHANGE) ||
+	    (hdmi_ists & HDMI_ISTS_PLL_LCK_CHG) || md_ists) {
+		dw_hdmi_power_off(dw_dev);
+		if (has_signal(dw_dev, dw_dev->configured_input))
+			dw_hdmi_power_on(dw_dev, dw_dev->configured_input);
+	}
+
+#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
+	dw_hdmi_cec_irq_handler(dw_dev);
+#endif
+
+	return IRQ_HANDLED;
+}
+
+static void dw_hdmi_detect_tx_5v(struct dw_hdmi_dev *dw_dev)
+{
+	unsigned int input_count = 4; /* TODO: Get from DT node this value */
+	unsigned int old_input = dw_dev->configured_input;
+	unsigned int new_input = old_input;
+	bool pending_config = false, current_on = true;
+	u32 stat = 0;
+	int i;
+
+	if (!has_signal(dw_dev, old_input)) {
+		dw_hdmi_disable_ints(dw_dev);
+		dw_hdmi_power_off(dw_dev);
+		current_on = false;
+	}
+
+	for (i = 0; i < input_count; i++) {
+		bool on = has_signal(dw_dev, i);
+		stat |= on << i;
+
+		if (is_off(dw_dev) && on && !pending_config) {
+			dw_hdmi_power_on(dw_dev, i);
+			dw_hdmi_set_input(dw_dev, i);
+			new_input = i;
+			pending_config = true;
+		}
+	}
+
+	if ((new_input == old_input) && !pending_config && !current_on)
+		dw_hdmi_phy_s_power(dw_dev, false);
+
+	if (stat) {
+		/*
+		 * If there are any connected ports enable the HPD and the SCDC
+		 * for these ports.
+		 */
+		dw_hdmi_enable_scdc(dw_dev);
+		dw_hdmi_enable_hpd(dw_dev, stat);
+	} else {
+		/*
+		 * If there are no connected ports disable whole HPD and SCDC
+		 * also.
+		 */
+		dw_hdmi_disable_hpd(dw_dev);
+		dw_hdmi_disable_scdc(dw_dev);
+	}
+
+	v4l2_ctrl_s_ctrl(dw_dev->detect_tx_5v_ctrl, stat);
+	dev_dbg(dw_dev->dev, "%s: stat=0x%x\n", __func__, stat);
+}
+
+static irqreturn_t dw_hdmi_5v_irq_handler(int irq, void *dev_data)
+{
+	struct dw_hdmi_dev *dw_dev = dev_data;
+
+	dw_hdmi_detect_tx_5v(dw_dev);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t dw_hdmi_5v_hard_irq_handler(int irq, void *dev_data)
+{
+	struct dw_hdmi_dev *dw_dev = dev_data;
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+	dw_hdmi_5v_clear(dw_dev);
+	return IRQ_WAKE_THREAD;
+}
+
+static int dw_hdmi_s_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+		u32 config)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	if (!has_signal(dw_dev, input))
+		return -EINVAL;
+
+	dw_dev->selected_input = input;
+	if (input == dw_dev->configured_input)
+		return 0;
+
+	dw_hdmi_power_off(dw_dev);
+	return dw_hdmi_power_on(dw_dev, input);
+}
+
+static int dw_hdmi_g_input_status(struct v4l2_subdev *sd, u32 *status)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	*status = 0;
+	if (!has_signal(dw_dev, dw_dev->selected_input))
+		*status |= V4L2_IN_ST_NO_POWER;
+	if (is_off(dw_dev))
+		*status |= V4L2_IN_ST_NO_SIGNAL;
+
+	dev_dbg(dw_dev->dev, "%s: status=0x%x\n", __func__, *status);
+	return 0;
+}
+
+static int dw_hdmi_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parm)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+
+	/* TODO: Use helper to compute timeperframe */
+	parm->parm.capture.timeperframe.numerator = 1;
+	parm->parm.capture.timeperframe.denominator = 60;
+	return 0;
+}
+
+static int dw_hdmi_s_dv_timings(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+	if (!v4l2_valid_dv_timings(timings, &dw_hdmi_timings_cap, NULL, NULL))
+		return -EINVAL;
+	if (v4l2_match_dv_timings(timings, &dw_dev->timings, 0, false))
+		return 0;
+
+	dw_dev->timings = *timings;
+	return 0;
+}
+
+static int dw_hdmi_g_dv_timings(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+
+	*timings = dw_dev->timings;
+	return 0;
+}
+
+static int dw_hdmi_query_dv_timings(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+	struct v4l2_bt_timings *bt = &timings->bt;
+	bool is_hdmi_vic;
+	u32 htot, hofs;
+	u32 vtot;
+	u8 vic;
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+
+	memset(timings, 0, sizeof(*timings));
+
+	timings->type = V4L2_DV_BT_656_1120;
+	bt->width = hdmi_readl(dw_dev, HDMI_MD_HACT_PX);
+	bt->height = hdmi_readl(dw_dev, HDMI_MD_VAL);
+	bt->interlaced = hdmi_readl(dw_dev, HDMI_MD_STS) & HDMI_MD_STS_ILACE;
+
+	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_VS_POL_ADJ)
+		bt->polarities |= V4L2_DV_VSYNC_POS_POL;
+	if (hdmi_readl(dw_dev, HDMI_ISTS) & HDMI_ISTS_HS_POL_ADJ)
+		bt->polarities |= V4L2_DV_HSYNC_POS_POL;
+
+	bt->pixelclock = dw_hdmi_get_pixelclk(dw_dev);
+
+	/* HTOT = HACT + HFRONT + HSYNC + HBACK */
+	htot = hdmi_mask_readl(dw_dev, HDMI_MD_HT1,
+			HDMI_MD_HT1_HTOT_PIX_OFFSET,
+			HDMI_MD_HT1_HTOT_PIX_MASK);
+	/* HOFS = HSYNC + HBACK */
+	hofs = hdmi_mask_readl(dw_dev, HDMI_MD_HT1,
+			HDMI_MD_HT1_HOFS_PIX_OFFSET,
+			HDMI_MD_HT1_HOFS_PIX_MASK);
+
+	bt->hfrontporch = htot - hofs - bt->width;
+	bt->hsync = hdmi_mask_readl(dw_dev, HDMI_MD_HT0,
+			HDMI_MD_HT0_HS_CLK_OFFSET,
+			HDMI_MD_HT0_HS_CLK_MASK);
+	bt->hbackporch = hofs - bt->hsync;
+
+	/* VTOT = VACT + VFRONT + VSYNC + VBACK */
+	vtot = hdmi_readl(dw_dev, HDMI_MD_VTL);
+
+	hdmi_mask_writel(dw_dev, 0x1, HDMI_MD_VCTRL,
+			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
+			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
+	msleep(50);
+	bt->vsync = hdmi_readl(dw_dev, HDMI_MD_VOL);
+
+	hdmi_mask_writel(dw_dev, 0x0, HDMI_MD_VCTRL,
+			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET,
+			HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK);
+	msleep(50);
+	bt->vbackporch = hdmi_readl(dw_dev, HDMI_MD_VOL);
+	bt->vfrontporch = vtot - bt->height - bt->vsync - bt->vbackporch;
+	bt->standards = V4L2_DV_BT_STD_CEA861;
+
+	vic = dw_hdmi_get_curr_vic(dw_dev, &is_hdmi_vic);
+	if (vic) {
+		if (is_hdmi_vic) {
+			bt->flags |= V4L2_DV_FL_HAS_HDMI_VIC;
+			bt->hdmi_vic = vic;
+			bt->cea861_vic = 0;
+		} else {
+			bt->flags |= V4L2_DV_FL_HAS_CEA861_VIC;
+			bt->hdmi_vic = 0;
+			bt->cea861_vic = vic;
+		}
+	}
+
+	return 0;
+}
+
+static int dw_hdmi_enum_mbus_code(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+	if (code->index != 0)
+		return -EINVAL;
+
+	code->code = dw_dev->mbus_code;
+	return 0;
+}
+
+static int dw_hdmi_fill_format(struct dw_hdmi_dev *dw_dev,
+		struct v4l2_mbus_framefmt *format)
+{
+	memset(format, 0, sizeof(*format));
+
+	format->width = dw_dev->timings.bt.width;
+	format->height = dw_dev->timings.bt.height;
+	format->colorspace = V4L2_COLORSPACE_SRGB;
+	format->code = dw_dev->mbus_code;
+	if (dw_dev->timings.bt.interlaced)
+		format->field = V4L2_FIELD_ALTERNATE;
+	else
+		format->field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int dw_hdmi_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+	return dw_hdmi_fill_format(dw_dev, &format->format);
+}
+
+static int dw_hdmi_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+
+	if (format->format.code != dw_dev->mbus_code) {
+		dev_dbg(dw_dev->dev, "invalid format\n");
+		return -EINVAL;
+	}
+
+	return dw_hdmi_get_fmt(sd, cfg, format);
+}
+
+static int dw_hdmi_dv_timings_cap(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings_cap *cap)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+	unsigned int pad = cap->pad;
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+
+	*cap = dw_hdmi_timings_cap;
+	cap->pad = pad;
+	return 0;
+}
+
+static int dw_hdmi_enum_dv_timings(struct v4l2_subdev *sd,
+		struct v4l2_enum_dv_timings *timings)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dev_dbg(dw_dev->dev, "%s\n", __func__);
+	return v4l2_enum_dv_timings_cap(timings, &dw_hdmi_timings_cap,
+			NULL, NULL);
+}
+
+static int dw_hdmi_log_status(struct v4l2_subdev *sd)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+	struct v4l2_dv_timings timings;
+
+	v4l2_info(sd, "--- Chip configuration ---\n");
+	v4l2_info(sd, "cfg_clk=%dMHz\n", dw_dev->cfg_clk);
+	v4l2_info(sd, "phy_drv=%s, phy_jtag_addr=0x%x\n", dw_dev->phy_drv,
+			dw_dev->phy_jtag_addr);
+
+	v4l2_info(sd, "--- Chip status ---\n");
+	v4l2_info(sd, "selected_input=%d: signal=%d\n", dw_dev->selected_input,
+			has_signal(dw_dev, dw_dev->selected_input));
+	v4l2_info(sd, "configured_input=%d: signal=%d\n",
+			dw_dev->configured_input,
+			has_signal(dw_dev, dw_dev->configured_input));
+
+	v4l2_info(sd, "--- Video status ---\n");
+	v4l2_info(sd, "type=%s, color_depth=%dbits",
+			hdmi_readl(dw_dev, HDMI_PDEC_STS) &
+			HDMI_PDEC_STS_DVIDET ? "dvi" : "hdmi",
+			dw_hdmi_get_colordepth(dw_dev));
+
+	v4l2_info(sd, "--- Video timings ---\n");
+	if (dw_hdmi_query_dv_timings(sd, &timings))
+		v4l2_info(sd, "No video detected\n");
+	else
+		v4l2_print_dv_timings(sd->name, "Detected format: ",
+				&timings, true);
+	v4l2_print_dv_timings(sd->name, "Configured format: ",
+			&dw_dev->timings, true);
+
+	v4l2_ctrl_subdev_log_status(sd);
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static void dw_hdmi_invalid_register(struct dw_hdmi_dev *dw_dev, u64 reg)
+{
+	dev_err(dw_dev->dev, "register 0x%llx not supported\n", reg);
+	dev_err(dw_dev->dev, "0x0000-0x7fff: Main controller map\n");
+	dev_err(dw_dev->dev, "0x8000-0x80ff: PHY map\n");
+}
+
+static bool dw_hdmi_is_reserved_register(struct dw_hdmi_dev *dw_dev, u32 reg)
+{
+	/*
+	 * NOTE: Some of the HDCP registers are write only. This means that
+	 * a read from these registers will never return and can block the bus
+	 * in some architectures. Disable the read to these registers and also
+	 * disable the write as a safety measure because userspace should not
+	 * be able to set HDCP registers.
+	 */
+	if (reg >= HDMI_HDCP_CTRL && reg <= HDMI_HDCP_STS)
+		return true;
+	if (reg == HDMI_HDCP22_CONTROL)
+		return true;
+	if (reg == HDMI_HDCP22_STATUS)
+		return true;
+	return false;
+}
+
+static int dw_hdmi_g_register(struct v4l2_subdev *sd,
+		struct v4l2_dbg_register *reg)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	switch (reg->reg >> 15) {
+	case 0: /* Controller core read */
+		if (dw_hdmi_is_reserved_register(dw_dev, reg->reg & 0x7fff))
+			return -EINVAL;
+
+		reg->size = 4;
+		reg->val = hdmi_readl(dw_dev, reg->reg & 0x7fff);
+		return 0;
+	case 1: /* PHY read */
+		if ((reg->reg & ~0xff) != BIT(15))
+			break;
+
+		reg->size = 2;
+		reg->val = dw_hdmi_phy_read(dw_dev, reg->reg & 0xff);
+		return 0;
+	default:
+		break;
+	}
+
+	dw_hdmi_invalid_register(dw_dev, reg->reg);
+	return 0;
+}
+
+static int dw_hdmi_s_register(struct v4l2_subdev *sd,
+		const struct v4l2_dbg_register *reg)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	switch (reg->reg >> 15) {
+	case 0: /* Controller core write */
+		if (dw_hdmi_is_reserved_register(dw_dev, reg->reg & 0x7fff))
+			return -EINVAL;
+
+		hdmi_writel(dw_dev, reg->val & GENMASK(31,0), reg->reg & 0x7fff);
+		return 0;
+	case 1: /* PHY write */
+		if ((reg->reg & ~0xff) != BIT(15))
+			break;
+		dw_hdmi_phy_write(dw_dev, reg->val & 0xffff, reg->reg & 0xff);
+		return 0;
+	default:
+		break;
+	}
+
+	dw_hdmi_invalid_register(dw_dev, reg->reg);
+	return 0;
+}
+#endif
+
+static int dw_hdmi_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+		struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
+	default:
+		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
+	}
+}
+
+static int dw_hdmi_registered(struct v4l2_subdev *sd)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+	int ret;
+
+	ret = cec_register_adapter(dw_dev->cec_adap, dw_dev->dev);
+	if (ret) {
+		dev_err(dw_dev->dev, "failed to register CEC adapter\n");
+		cec_delete_adapter(dw_dev->cec_adap);
+		return ret;
+	}
+
+	cec_register_cec_notifier(dw_dev->cec_adap, dw_dev->cec_notifier);
+	dw_dev->registered = true;
+
+	return v4l2_async_subnotifier_register(&dw_dev->sd,
+			&dw_dev->v4l2_notifier);
+}
+
+static void dw_hdmi_unregistered(struct v4l2_subdev *sd)
+{
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	cec_unregister_adapter(dw_dev->cec_adap);
+	cec_notifier_put(dw_dev->cec_notifier);
+	v4l2_async_subnotifier_unregister(&dw_dev->v4l2_notifier);
+}
+
+static const struct v4l2_subdev_core_ops dw_hdmi_sd_core_ops = {
+	.log_status = dw_hdmi_log_status,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = dw_hdmi_g_register,
+	.s_register = dw_hdmi_s_register,
+#endif
+	.subscribe_event = dw_hdmi_subscribe_event,
+};
+
+static const struct v4l2_subdev_video_ops dw_hdmi_sd_video_ops = {
+	.s_routing = dw_hdmi_s_routing,
+	.g_input_status = dw_hdmi_g_input_status,
+	.g_parm = dw_hdmi_g_parm,
+	.s_dv_timings = dw_hdmi_s_dv_timings,
+	.g_dv_timings = dw_hdmi_g_dv_timings,
+	.query_dv_timings = dw_hdmi_query_dv_timings,
+};
+
+static const struct v4l2_subdev_pad_ops dw_hdmi_sd_pad_ops = {
+	.enum_mbus_code = dw_hdmi_enum_mbus_code,
+	.get_fmt = dw_hdmi_get_fmt,
+	.set_fmt = dw_hdmi_set_fmt,
+	.dv_timings_cap = dw_hdmi_dv_timings_cap,
+	.enum_dv_timings = dw_hdmi_enum_dv_timings,
+};
+
+static const struct v4l2_subdev_ops dw_hdmi_sd_ops = {
+	.core = &dw_hdmi_sd_core_ops,
+	.video = &dw_hdmi_sd_video_ops,
+	.pad = &dw_hdmi_sd_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops dw_hdmi_internal_ops = {
+	.registered = dw_hdmi_registered,
+	.unregistered = dw_hdmi_unregistered,
+};
+
+static int dw_hdmi_v4l2_notify_bound(struct v4l2_async_notifier *notifier,
+		struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
+{
+	struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
+
+	if (dw_dev->phy_async_sd.match.fwnode.fwnode ==
+			of_fwnode_handle(subdev->dev->of_node)) {
+		dev_dbg(dw_dev->dev, "found new subdev '%s'\n", subdev->name);
+		dw_dev->phy_sd = subdev;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static void dw_hdmi_v4l2_notify_unbind(struct v4l2_async_notifier *notifier,
+		struct v4l2_subdev *subdev, struct v4l2_async_subdev *asd)
+{
+	struct dw_hdmi_dev *dw_dev = notifier_to_dw_dev(notifier);
+
+	if (dw_dev->phy_sd == subdev) {
+		dev_dbg(dw_dev->dev, "unbinding '%s'\n", subdev->name);
+		dw_dev->phy_sd = NULL;
+	}
+}
+
+static int dw_hdmi_v4l2_init_notifier(struct dw_hdmi_dev *dw_dev)
+{
+	struct v4l2_async_subdev **subdevs = NULL;
+	struct device_node *child = NULL;
+
+	subdevs = devm_kzalloc(dw_dev->dev, sizeof(*subdevs), GFP_KERNEL);
+	if (!subdevs)
+		return -ENOMEM;
+
+	child = dw_hdmi_get_phy_of_node(dw_dev, NULL);
+	if (!child)
+		return -EINVAL;
+
+	dw_dev->phy_async_sd.match.fwnode.fwnode = of_fwnode_handle(child);
+	dw_dev->phy_async_sd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+
+	subdevs[0] = &dw_dev->phy_async_sd;
+	dw_dev->v4l2_notifier.num_subdevs = 1;
+	dw_dev->v4l2_notifier.subdevs = subdevs;
+	dw_dev->v4l2_notifier.bound = dw_hdmi_v4l2_notify_bound;
+	dw_dev->v4l2_notifier.unbind = dw_hdmi_v4l2_notify_unbind;
+
+	return 0;
+}
+
+static int dw_hdmi_parse_dt(struct dw_hdmi_dev *dw_dev)
+{
+	struct device_node *notifier, *phy_node, *np = dw_dev->of_node;
+	u32 tmp;
+	int ret;
+
+	if (!np) {
+		dev_err(dw_dev->dev, "missing DT node\n");
+		return -EINVAL;
+	}
+
+	/* PHY properties parsing */
+	phy_node = dw_hdmi_get_phy_of_node(dw_dev, NULL);
+	of_property_read_u32(phy_node, "reg", &tmp);
+
+	dw_dev->phy_jtag_addr = tmp & 0xff;
+	if (!dw_dev->phy_jtag_addr) {
+		dev_err(dw_dev->dev, "missing phy jtag address in DT\n");
+		return -EINVAL;
+	}
+
+	/* Get config clock value */
+	dw_dev->clk = devm_clk_get(dw_dev->dev, "cfg");
+	if (IS_ERR(dw_dev->clk)) {
+		dev_err(dw_dev->dev, "failed to get cfg clock\n");
+		return PTR_ERR(dw_dev->clk);
+	}
+
+	ret = clk_prepare_enable(dw_dev->clk);
+	if (ret) {
+		dev_err(dw_dev->dev, "failed to enable cfg clock\n");
+		return ret;
+	}
+
+	dw_dev->cfg_clk = clk_get_rate(dw_dev->clk) / 1000000U;
+	if (!dw_dev->cfg_clk) {
+		dev_err(dw_dev->dev, "invalid cfg clock frequency\n");
+		ret = -EINVAL;
+		goto err_clk;
+	}
+
+#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
+	/* Notifier device parsing */
+	notifier = of_parse_phandle(np, "edid-phandle", 0);
+	if (!notifier) {
+		dev_err(dw_dev->dev, "missing edid-phandle in DT\n");
+		ret = -EINVAL;
+		goto err_clk;
+	}
+
+	dw_dev->notifier_pdev = of_find_device_by_node(notifier);
+	if (!dw_dev->notifier_pdev)
+		return -EPROBE_DEFER;
+#endif
+
+	return 0;
+
+err_clk:
+	clk_disable_unprepare(dw_dev->clk);
+	return ret;
+}
+
+static int dw_hdmi_rx_probe(struct platform_device *pdev)
+{
+	const struct v4l2_dv_timings timings_def = HDMI_DEFAULT_TIMING;
+	struct dw_hdmi_rx_pdata *pdata = pdev->dev.platform_data;
+	struct device *dev = &pdev->dev;
+	struct v4l2_ctrl_handler *hdl;
+	struct dw_hdmi_dev *dw_dev;
+	struct v4l2_subdev *sd;
+	struct resource *res;
+	int ret, irq;
+
+	dev_dbg(dev, "%s\n", __func__);
+
+	dw_dev = devm_kzalloc(dev, sizeof(*dw_dev), GFP_KERNEL);
+	if (!dw_dev)
+		return -ENOMEM;
+
+	if (!pdata) {
+		dev_err(dev, "missing platform data\n");
+		return -EINVAL;
+	}
+
+	dw_dev->dev = dev;
+	dw_dev->config = pdata;
+	dw_dev->state = HDMI_STATE_NO_INIT;
+	dw_dev->of_node = dev->of_node;
+	spin_lock_init(&dw_dev->lock);
+
+	ret = dw_hdmi_parse_dt(dw_dev);
+	if (ret)
+		return ret;
+
+	/* Deferred work */
+	dw_dev->wq = create_singlethread_workqueue(DW_HDMI_RX_DRVNAME);
+	if (!dw_dev->wq) {
+		dev_err(dev, "failed to create workqueue\n");
+		return -ENOMEM;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	dw_dev->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(dw_dev->regs)) {
+		dev_err(dev, "failed to remap resource\n");
+		ret = PTR_ERR(dw_dev->regs);
+		goto err_wq;
+	}
+
+	/* Disable HPD as soon as posssible */
+	dw_hdmi_disable_hpd(dw_dev);
+	/* Prevent HDCP from tampering video */
+	dw_hdmi_config_hdcp(dw_dev);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		ret = irq;
+		goto err_wq;
+	}
+
+	ret = devm_request_threaded_irq(dev, irq, NULL, dw_hdmi_irq_handler,
+			IRQF_ONESHOT, DW_HDMI_RX_DRVNAME, dw_dev);
+	if (ret)
+		goto err_wq;
+
+	/* V4L2 initialization */
+	sd = &dw_dev->sd;
+	v4l2_subdev_init(sd, &dw_hdmi_sd_ops);
+	strlcpy(sd->name, dev_name(dev), sizeof(sd->name));
+	sd->dev = dev;
+	sd->internal_ops = &dw_hdmi_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	/* Control handlers */
+	hdl = &dw_dev->hdl;
+	v4l2_ctrl_handler_init(hdl, 1);
+	dw_dev->detect_tx_5v_ctrl = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_DV_RX_POWER_PRESENT, 0, BIT(4) - 1, 0, 0);
+
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		ret = hdl->error;
+		goto err_hdl;
+	}
+
+	/* Wait for ctrl handler register before requesting 5v interrupt */
+	irq = platform_get_irq(pdev, 1);
+	if (irq < 0) {
+		ret = irq;
+		goto err_hdl;
+	}
+
+	ret = devm_request_threaded_irq(dev, irq, dw_hdmi_5v_hard_irq_handler,
+			dw_hdmi_5v_irq_handler, IRQF_ONESHOT,
+			DW_HDMI_RX_DRVNAME "-5v-handler", dw_dev);
+	if (ret)
+		goto err_hdl;
+
+	/* Notifier for subdev binding */
+	ret = dw_hdmi_v4l2_init_notifier(dw_dev);
+	if (ret) {
+		dev_err(dev, "failed to init v4l2 notifier\n");
+		goto err_hdl;
+	}
+
+	/* PHY loading */
+	ret = dw_hdmi_phy_init(dw_dev);
+	if (ret)
+		goto err_hdl;
+
+	/* CEC */
+#if IS_ENABLED(CONFIG_VIDEO_DWC_HDMI_RX_CEC)
+	dw_dev->cec_adap = cec_allocate_adapter(&dw_hdmi_cec_adap_ops,
+			dw_dev, dev_name(dev), CEC_CAP_TRANSMIT |
+			CEC_CAP_LOG_ADDRS | CEC_CAP_RC | CEC_CAP_PASSTHROUGH,
+			HDMI_CEC_MAX_LOG_ADDRS);
+	ret = PTR_ERR_OR_ZERO(dw_dev->cec_adap);
+	if (ret) {
+		dev_err(dev, "failed to allocate CEC adapter\n");
+		goto err_phy;
+	}
+
+	dw_dev->cec_notifier = cec_notifier_get(&dw_dev->notifier_pdev->dev);
+	if (!dw_dev->cec_notifier) {
+		dev_err(dev, "failed to allocate CEC notifier\n");
+		ret = -ENOMEM;
+		goto err_cec;
+	}
+
+	dev_info(dev, "CEC is enabled\n");
+#else
+	dev_info(dev, "CEC is disabled\n");
+#endif
+
+	ret = v4l2_async_register_subdev(sd);
+	if (ret) {
+		dev_err(dev, "failed to register subdev\n");
+		goto err_cec;
+	}
+
+	/* Fill initial format settings */
+	dw_dev->timings = timings_def;
+	dw_dev->mbus_code = MEDIA_BUS_FMT_BGR888_1X24;
+
+	dev_set_drvdata(dev, sd);
+	dw_dev->state = HDMI_STATE_POWER_OFF;
+	dw_hdmi_detect_tx_5v(dw_dev);
+	dev_dbg(dev, "driver probed\n");
+	return 0;
+
+err_cec:
+	cec_delete_adapter(dw_dev->cec_adap);
+err_phy:
+	dw_hdmi_phy_exit(dw_dev);
+err_hdl:
+	v4l2_ctrl_handler_free(hdl);
+err_wq:
+	destroy_workqueue(dw_dev->wq);
+	return ret;
+}
+
+static int dw_hdmi_rx_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct dw_hdmi_dev *dw_dev = to_dw_dev(sd);
+
+	dw_hdmi_disable_ints(dw_dev);
+	dw_hdmi_disable_hpd(dw_dev);
+	dw_hdmi_disable_scdc(dw_dev);
+	dw_hdmi_power_off(dw_dev);
+	dw_hdmi_phy_s_power(dw_dev, false);
+	flush_workqueue(dw_dev->wq);
+	destroy_workqueue(dw_dev->wq);
+	dw_hdmi_phy_exit(dw_dev);
+	v4l2_async_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(sd->ctrl_handler);
+	clk_disable_unprepare(dw_dev->clk);
+	dev_dbg(dev, "driver removed\n");
+	return 0;
+}
+
+static const struct of_device_id dw_hdmi_rx_id[] = {
+	{ .compatible = "snps,dw-hdmi-rx" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, dw_hdmi_rx_id);
+
+static struct platform_driver dw_hdmi_rx_driver = {
+	.probe = dw_hdmi_rx_probe,
+	.remove = dw_hdmi_rx_remove,
+	.driver = {
+		.name = DW_HDMI_RX_DRVNAME,
+		.of_match_table = dw_hdmi_rx_id,
+	}
+};
+module_platform_driver(dw_hdmi_rx_driver);
diff --git a/drivers/media/platform/dwc/dw-hdmi-rx.h b/drivers/media/platform/dwc/dw-hdmi-rx.h
new file mode 100644
index 0000000..14ec5a6
--- /dev/null
+++ b/drivers/media/platform/dwc/dw-hdmi-rx.h
@@ -0,0 +1,441 @@
+/*
+ * Synopsys Designware HDMI Receiver controller driver
+ *
+ * This Synopsys dw-hdmi-rx software and associated documentation
+ * (hereinafter the "Software") is an unsupported proprietary work of
+ * Synopsys, Inc. unless otherwise expressly agreed to in writing between
+ * Synopsys and you. The Software IS NOT an item of Licensed Software or a
+ * Licensed Product under any End User Software License Agreement or
+ * Agreement for Licensed Products with Synopsys or any supplement thereto.
+ * Synopsys is a registered trademark of Synopsys, Inc. Other names included
+ * in the SOFTWARE may be the trademarks of their respective owners.
+ *
+ * The contents of this file are dual-licensed; you may select either version 2
+ * of the GNU General Public License (“GPL”) or the MIT license (“MIT”).
+ *
+ * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE
+ * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __DW_HDMI_RX_H__
+#define __DW_HDMI_RX_H__
+
+#include <linux/bitops.h>
+
+/* id_hdmi Registers */
+#define HDMI_SETUP_CTRL				0x0000
+#define HDMI_PLL_LCK_STS			0x0030
+#define HDMI_CKM_EVLTM				0x0094
+#define HDMI_CKM_RESULT				0x009c
+#define HDMI_STS				0x00bc
+
+/* id_hdcp_1_4 Registers */
+#define HDMI_HDCP_CTRL				0x00c0
+#define HDMI_HDCP_SETTINGS			0x00c4
+#define HDMI_HDCP_SEED				0x00c8
+#define HDMI_HDCP_BKSV1				0x00cc
+#define HDMI_HDCP_BKSV0				0x00d0
+#define HDMI_HDCP_KIDX				0x00d4
+#define HDMI_HDCP_KEY1				0x00d8
+#define HDMI_HDCP_KEY0				0x00dc
+#define HDMI_HDCP_DBG				0x00e0
+#define HDMI_HDCP_AKSV1				0x00e4
+#define HDMI_HDCP_AKSV0				0x00e8
+#define HDMI_HDCP_AN1				0x00ec
+#define HDMI_HDCP_AN0				0x00f0
+#define HDMI_HDCP_EESS_WOO			0x00f4
+#define HDMI_HDCP_I2C_TIMEOUT			0x00f8
+#define HDMI_HDCP_STS				0x00fc
+
+/* id_mode_detection Registers */
+#define HDMI_MD_HT0				0x0148
+#define HDMI_MD_HT1				0x014c
+#define HDMI_MD_HACT_PX				0x0150
+#define HDMI_MD_VCTRL				0x0158
+#define HDMI_MD_VOL				0x0164
+#define HDMI_MD_VAL				0x0168
+#define HDMI_MD_VTL				0x0170
+#define HDMI_MD_STS				0x0180
+
+/* id_phy_configuration Registers */
+#define HDMI_PHY_CTRL				0x02c0
+#define HDMI_PHY_JTAG_CONF			0x02ec
+#define HDMI_PHY_JTAG_TAP_TCLK			0x02f0
+#define HDMI_PHY_JTAG_TAP_IN			0x02f4
+#define HDMI_PHY_JTAG_TAP_OUT			0x02f8
+#define HDMI_PHY_JTAG_ADDR			0x02fc
+
+/* id_packet_decoder Registers */
+#define HDMI_PDEC_STS				0x0360
+#define HDMI_PDEC_VSI_PAYLOAD0			0x0368
+#define HDMI_PDEC_AVI_PB			0x03a4
+
+/* id_hdmi_2_0 Registers */
+#define HDMI_SCDC_CONFIG			0x0808
+#define HDMI_HDCP22_CONTROL			0x081c
+#define HDMI_HDCP22_STATUS			0x08fc
+
+/* id_audio_and_cec_interrupt Registers */
+#define HDMI_AUD_CEC_IEN_CLR			0x0f90
+#define HDMI_AUD_CEC_IEN_SET			0x0f94
+#define HDMI_AUD_CEC_ISTS			0x0f98
+#define HDMI_AUD_CEC_IEN			0x0f9c
+#define HDMI_AUD_CEC_ICLR			0x0fa0
+#define HDMI_AUD_CEC_ISET			0x0fa4
+
+/* id_mode_detection_interrupt Registers */
+#define HDMI_MD_IEN_CLR				0x0fc0
+#define HDMI_MD_IEN_SET				0x0fc4
+#define HDMI_MD_ISTS				0x0fc8
+#define HDMI_MD_IEN				0x0fcc
+#define HDMI_MD_ICLR				0x0fd0
+#define HDMI_MD_ISET				0x0fd4
+
+/* id_hdmi_interrupt Registers */
+#define HDMI_IEN_CLR				0x0fd8
+#define HDMI_IEN_SET				0x0fdc
+#define HDMI_ISTS				0x0fe0
+#define HDMI_IEN				0x0fe4
+#define HDMI_ICLR				0x0fe8
+#define HDMI_ISET				0x0fec
+
+/* id_dmi Registers */
+#define HDMI_DMI_SW_RST				0x0ff0
+
+/* id_cec Registers */
+#define HDMI_CEC_CTRL				0x1f00
+#define HDMI_CEC_MASK				0x1f08
+#define HDMI_CEC_ADDR_L				0x1f14
+#define HDMI_CEC_ADDR_H				0x1f18
+#define HDMI_CEC_TX_CNT				0x1f1c
+#define HDMI_CEC_RX_CNT				0x1f20
+#define HDMI_CEC_TX_DATA(i)			(0x1f40 + ((i) * 4))
+#define HDMI_CEC_TX_DATA_MAX			16
+#define HDMI_CEC_RX_DATA(i)			(0x1f80 + ((i) * 4))
+#define HDMI_CEC_RX_DATA_MAX			16
+#define HDMI_CEC_LOCK				0x1fc0
+#define HDMI_CEC_WAKEUPCTRL			0x1fc4
+
+/* id_cbus Registers */
+#define HDMI_CBUSIOCTRL				0x3020
+
+enum {
+	/* SETUP_CTRL field values */
+	HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_MASK = GENMASK(27,24),
+	HDMI_SETUP_CTRL_HOT_PLUG_DETECT_INPUT_X_OFFSET = 24,
+	HDMI_SETUP_CTRL_HDMIBUS_RESET_OVR_EN_MASK = BIT(21),
+	HDMI_SETUP_CTRL_HDMIBUS_RESET_OVR_EN_OFFSET = 21,
+	HDMI_SETUP_CTRL_BUS_RESET_OVR_MASK = BIT(20),
+	HDMI_SETUP_CTRL_BUS_RESET_OVR_OFFSET = 20,
+	HDMI_SETUP_CTRL_HDMI_RESET_OVR_MASK = BIT(19),
+	HDMI_SETUP_CTRL_HDMI_RESET_OVR_OFFSET = 19,
+	HDMI_SETUP_CTRL_PON_RESET_OVR_MASK = BIT(18),
+	HDMI_SETUP_CTRL_PON_RESET_OVR_OFFSET = 18,
+	HDMI_SETUP_CTRL_RESET_OVR_MASK = BIT(17),
+	HDMI_SETUP_CTRL_RESET_OVR_OFFSET = 17,
+	HDMI_SETUP_CTRL_RESET_OVR_EN_MASK = BIT(16),
+	HDMI_SETUP_CTRL_RESET_OVR_EN_OFFSET = 16,
+	HDMI_SETUP_CTRL_EQ_OSM_OVR_MASK = BIT(15),
+	HDMI_SETUP_CTRL_EQ_OSM_OVR_OFFSET = 15,
+	HDMI_SETUP_CTRL_EQ_OSM_OVR_EN_MASK = BIT(14),
+	HDMI_SETUP_CTRL_EQ_OSM_OVR_EN_OFFSET = 14,
+	HDMI_SETUP_CTRL_NOWAIT_ACTIVITY_MASK = BIT(13),
+	HDMI_SETUP_CTRL_NOWAIT_ACTIVITY_OFFSET = 13,
+	HDMI_SETUP_CTRL_EQ_CAL_TIME_MASK = GENMASK(12,7),
+	HDMI_SETUP_CTRL_EQ_CAL_TIME_OFFSET = 7,
+	HDMI_SETUP_CTRL_USE_PLL_LOCK_MASK = BIT(6),
+	HDMI_SETUP_CTRL_USE_PLL_LOCK_OFFSET = 6,
+	HDMI_SETUP_CTRL_FORCE_STATE_MASK = BIT(5),
+	HDMI_SETUP_CTRL_FORCE_STATE_OFFSET = 5,
+	HDMI_SETUP_CTRL_TARGET_STATE_MASK = GENMASK(4,1),
+	HDMI_SETUP_CTRL_TARGET_STATE_OFFSET = 1,
+	HDMI_SETUP_CTRL_HOT_PLUG_DETECT_MASK = BIT(0),
+	HDMI_SETUP_CTRL_HOT_PLUG_DETECT_OFFSET = 0,
+	/* PLL_LCK_STS field values */
+	HDMI_PLL_LCK_STS_PLL_LOCKED = BIT(0),
+	/* CKM_EVLTM field values */
+	HDMI_CKM_EVLTM_LOCK_HYST_MASK = GENMASK(21,20),
+	HDMI_CKM_EVLTM_LOCK_HYST_OFFSET = 20,
+	HDMI_CKM_EVLTM_CLK_HYST_MASK = GENMASK(18,16),
+	HDMI_CKM_EVLTM_CLK_HYST_OFFSET = 16,
+	HDMI_CKM_EVLTM_EVAL_TIME_MASK = GENMASK(15,4),
+	HDMI_CKM_EVLTM_EVAL_TIME_OFFSET = 4,
+	HDMI_CKM_EVLTM_CLK_MEAS_INPUT_SRC_MASK = BIT(0),
+	HDMI_CKM_EVLTM_CLK_MEAS_INPUT_SRC_OFFSET = 0,
+	/* CKM_RESULT field values */
+	HDMI_CKM_RESULT_CLOCK_IN_RANGE = BIT(17),
+	HDMI_CKM_RESULT_FREQ_LOCKED = BIT(16),
+	HDMI_CKM_RESULT_CLKRATE_MASK = GENMASK(15,0),
+	HDMI_CKM_RESULT_CLKRATE_OFFSET = 0,
+	/* STS field values */
+	HDMI_STS_DCM_CURRENT_MODE_MASK = GENMASK(31,28),
+	HDMI_STS_DCM_CURRENT_MODE_OFFSET = 28,
+	HDMI_STS_DCM_LAST_PIXEL_PHASE_STS_MASK = GENMASK(27,24),
+	HDMI_STS_DCM_LAST_PIXEL_PHASE_STS_OFFSET = 24,
+	HDMI_STS_DCM_PHASE_DIFF_CNT_MASK = GENMASK(23,16),
+	HDMI_STS_DCM_PH_DIFF_CNT_OVERFL = BIT(15),
+	HDMI_STS_DCM_GCP_ZERO_FIELDS_PASS = BIT(14),
+	HDMI_STS_CTL3_STS = BIT(13),
+	HDMI_STS_CTL2_STS = BIT(12),
+	HDMI_STS_CTL1_STS = BIT(11),
+	HDMI_STS_CTL0_STS = BIT(10),
+	HDMI_STS_VS_POL_ADJ_STS = BIT(9),
+	HDMI_STS_HS_POL_ADJ_STS = BIT(8),
+	HDMI_STS_RES_OVERLOAD_STS = BIT(7),
+	HDMI_STS_DCM_CURRENT_PP_MASK = GENMASK(3,0),
+	HDMI_STS_DCM_CURRENT_PP_OFFSET = 0,
+	/* HDCP_CTRL field values */
+	HDMI_HDCP_CTRL_ENDISLOCK_MASK = BIT(25),
+	HDMI_HDCP_CTRL_ENDISLOCK_OFFSET = 25,
+	HDMI_HDCP_CTRL_ENABLE_MASK = BIT(24),
+	HDMI_HDCP_CTRL_ENABLE_OFFSET = 24,
+	HDMI_HDCP_CTRL_FREEZE_HDCP_FSM_MASK = BIT(21),
+	HDMI_HDCP_CTRL_FREEZE_HDCP_FSM_OFFSET = 21,
+	HDMI_HDCP_CTRL_FREEZE_HDCP_STATE_MASK = GENMASK(20,15),
+	HDMI_HDCP_CTRL_FREEZE_HDCP_STATE_OFFSET = 15,
+	HDMI_HDCP_CTRL_VID_DE_MASK = BIT(14),
+	HDMI_HDCP_CTRL_VID_DE_OFFSET = 14,
+	HDMI_HDCP_CTRL_SEL_AVMUTE_MASK = GENMASK(11,10),
+	HDMI_HDCP_CTRL_SEL_AVMUTE_OFFSET = 10,
+	HDMI_HDCP_CTRL_CTL_MASK = GENMASK(9,8),
+	HDMI_HDCP_CTRL_CTL_OFFSET = 8,
+	HDMI_HDCP_CTRL_RI_RATE_MASK = GENMASK(7,6),
+	HDMI_HDCP_CTRL_RI_RATE_OFFSET = 6,
+	HDMI_HDCP_CTRL_HDMI_MODE_ENABLE_MASK = BIT(2),
+	HDMI_HDCP_CTRL_HDMI_MODE_ENABLE_OFFSET = 2,
+	HDMI_HDCP_CTRL_KEY_DECRYPT_ENABLE_MASK = BIT(1),
+	HDMI_HDCP_CTRL_KEY_DECRYPT_ENABLE_OFFSET = 1,
+	HDMI_HDCP_CTRL_ENC_EN_MASK = BIT(0),
+	HDMI_HDCP_CTRL_ENC_EN_OFFSET = 0,
+	/* HDCP_SEED field values */
+	HDMI_HDCP_SEED_KEY_DECRYPT_SEED_MASK = GENMASK(15,0),
+	HDMI_HDCP_SEED_KEY_DECRYPT_SEED_OFFSET = 0,
+	/* HDCP_STS field values */
+	HDMI_HDCP_STS_ENC_STATE = BIT(9),
+	HDMI_HDCP_STS_AUTH_START = BIT(8),
+	HDMI_HDCP_STS_KEY_WR_OK = BIT(0),
+	/* MD_HT0 field values */
+	HDMI_MD_HT0_HTOT32_CLK_MASK = GENMASK(31,16),
+	HDMI_MD_HT0_HTOT32_CLK_OFFSET = 16,
+	HDMI_MD_HT0_HS_CLK_MASK = GENMASK(15,0),
+	HDMI_MD_HT0_HS_CLK_OFFSET = 0,
+	/* MD_HT1 field values */
+	HDMI_MD_HT1_HTOT_PIX_MASK = GENMASK(31,16),
+	HDMI_MD_HT1_HTOT_PIX_OFFSET = 16,
+	HDMI_MD_HT1_HOFS_PIX_MASK = GENMASK(15,0),
+	HDMI_MD_HT1_HOFS_PIX_OFFSET = 0,
+	/* MD_VCTRL field values */
+	HDMI_MD_VCTRL_V_OFFS_LIN_MODE_MASK = BIT(4),
+	HDMI_MD_VCTRL_V_OFFS_LIN_MODE_OFFSET = 4,
+	HDMI_MD_VCTRL_V_EDGE_MASK = BIT(1),
+	HDMI_MD_VCTRL_V_EDGE_OFFSET = 1,
+	HDMI_MD_VCTRL_V_MODE_MASK = BIT(0),
+	HDMI_MD_VCTRL_V_MODE_OFFSET = 0,
+	/* MD_STS field values */
+	HDMI_MD_STS_ILACE = BIT(3),
+	HDMI_MD_STS_DE_ACTIVITY = BIT(2),
+	HDMI_MD_STS_VS_ACT = BIT(1),
+	HDMI_MD_STS_HS_ACT = BIT(0),
+	/* PHY_CTRL field values */
+	HDMI_PHY_CTRL_SVSRETMODEZ_MASK = BIT(6),
+	HDMI_PHY_CTRL_SVSRETMODEZ_OFFSET = 6,
+	HDMI_PHY_CTRL_CFGCLKFREQ_MASK = GENMASK(5,4),
+	HDMI_PHY_CTRL_CFGCLKFREQ_OFFSET = 4,
+	HDMI_PHY_CTRL_PORTSELECT_MASK = GENMASK(3,2),
+	HDMI_PHY_CTRL_PORTSELECT_OFFSET = 2,
+	HDMI_PHY_CTRL_PDDQ_MASK = BIT(1),
+	HDMI_PHY_CTRL_PDDQ_OFFSET = 1,
+	HDMI_PHY_CTRL_RESET_MASK = BIT(0),
+	HDMI_PHY_CTRL_RESET_OFFSET = 0,
+	/* PHY_JTAG_TAP_IN field values */
+	HDMI_PHY_JTAG_TAP_IN_TMS = BIT(4),
+	HDMI_PHY_JTAG_TAP_IN_TDI = BIT(0),
+	/* PDEC_STS field values */
+	HDMI_PDEC_STS_DRM_CKS_CHG = BIT(31),
+	HDMI_PDEC_STS_DRM_RCV = BIT(30),
+	HDMI_PDEC_STS_NTSCVBI_CKS_CHG = BIT(29),
+	HDMI_PDEC_STS_DVIDET = BIT(28),
+	HDMI_PDEC_STS_VSI_CKS_CHG = BIT(27),
+	HDMI_PDEC_STS_GMD_CKS_CHG = BIT(26),
+	HDMI_PDEC_STS_AIF_CKS_CHG = BIT(25),
+	HDMI_PDEC_STS_AVI_CKS_CHG = BIT(24),
+	HDMI_PDEC_STS_ACR_N_CHG = BIT(23),
+	HDMI_PDEC_STS_ACR_CTS_CHG = BIT(22),
+	HDMI_PDEC_STS_GCP_AV_MUTE_CHG = BIT(21),
+	HDMI_PDEC_STS_GMD_RCV = BIT(20),
+	HDMI_PDEC_STS_AIF_RCV = BIT(19),
+	HDMI_PDEC_STS_AVI_RCV = BIT(18),
+	HDMI_PDEC_STS_ACR_RCV = BIT(17),
+	HDMI_PDEC_STS_GCP_RCV = BIT(16),
+	HDMI_PDEC_STS_VSI_RCV = BIT(15),
+	HDMI_PDEC_STS_AMP_RCV = BIT(14),
+	HDMI_PDEC_STS_NTSCVBI_RCV = BIT(13),
+	HDMI_PDEC_STS_OBA_LAYOUT = BIT(12),
+	HDMI_PDEC_STS_AUDS_LAYOUT = BIT(11),
+	HDMI_PDEC_STS_PD_FIFO_NEW_ENTRY = BIT(8),
+	HDMI_PDEC_STS_PD_FIFO_OVERFL = BIT(4),
+	HDMI_PDEC_STS_PD_FIFO_UNDERFL = BIT(3),
+	HDMI_PDEC_STS_PD_FIFO_TH_START_PASS = BIT(2),
+	HDMI_PDEC_STS_PD_FIFO_TH_MAX_PASS = BIT(1),
+	HDMI_PDEC_STS_PD_FIFO_TH_MIN_PASS = BIT(0),
+	/* PDEC_VSI_PAYLOAD0 field values */
+	HDMI_PDEC_VSI_PAYLOAD0_HDMI_VIC_MASK = GENMASK(15,8),
+	HDMI_PDEC_VSI_PAYLOAD0_HDMI_VIC_OFFSET = 8,
+	/* PDEC_AVI_PB field values */
+	HDMI_PDEC_AVI_PB_VID_IDENT_CODE_MASK = GENMASK(31,24),
+	HDMI_PDEC_AVI_PB_VID_IDENT_CODE_OFFSET = 24,
+	HDMI_PDEC_AVI_PB_IT_CONTENT = BIT(23),
+	HDMI_PDEC_AVI_PB_EXT_COLORIMETRY_MASK = GENMASK(22,20),
+	HDMI_PDEC_AVI_PB_EXT_COLORIMETRY_OFFSET = 20,
+	HDMI_PDEC_AVI_PB_RGB_QUANT_RANGE_MASK = GENMASK(19,18),
+	HDMI_PDEC_AVI_PB_RGB_QUANT_RANGE_OFFSET = 18,
+	HDMI_PDEC_AVI_PB_NON_UNIF_SCALE_MASK = GENMASK(17,16),
+	HDMI_PDEC_AVI_PB_NON_UNIF_SCALE_OFFSET = 16,
+	HDMI_PDEC_AVI_PB_COLORIMETRY_MASK = GENMASK(15,14),
+	HDMI_PDEC_AVI_PB_COLORIMETRY_OFFSET = 14,
+	HDMI_PDEC_AVI_PB_PIC_ASPECT_RAT_MASK = GENMASK(13,12),
+	HDMI_PDEC_AVI_PB_PIC_ASPECT_RAT_OFFSET = 12,
+	HDMI_PDEC_AVI_PB_ACT_ASPECT_RAT_MASK = GENMASK(11,8),
+	HDMI_PDEC_AVI_PB_ACT_ASPECT_RAT_OFFSET = 8,
+	HDMI_PDEC_AVI_PB_VIDEO_FORMAT_MASK = GENMASK(7,5),
+	HDMI_PDEC_AVI_PB_VIDEO_FORMAT_OFFSET = 5,
+	HDMI_PDEC_AVI_PB_ACT_INFO_PRESENT = BIT(4),
+	HDMI_PDEC_AVI_PB_BAR_INFO_VALID_MASK = GENMASK(3,2),
+	HDMI_PDEC_AVI_PB_BAR_INFO_VALID_OFFSET = 2,
+	HDMI_PDEC_AVI_PB_SCAN_INFO_MASK = GENMASK(1,0),
+	HDMI_PDEC_AVI_PB_SCAN_INFO_OFFSET = 0,
+	/* SCDC_CONFIG field values */
+	HDMI_SCDC_CONFIG_HPDLOW_MASK = BIT(1),
+	HDMI_SCDC_CONFIG_HPDLOW_OFFSET = 1,
+	HDMI_SCDC_CONFIG_POWERPROVIDED_MASK = BIT(0),
+	HDMI_SCDC_CONFIG_POWERPROVIDED_OFFSET = 0,
+	/* HDCP22_CONTROL field values */
+	HDMI_HDCP22_CONTROL_CD_OVR_VAL_MASK = GENMASK(23,20),
+	HDMI_HDCP22_CONTROL_CD_OVR_VAL_OFFSET = 20,
+	HDMI_HDCP22_CONTROL_CD_OVR_EN_MASK = BIT(16),
+	HDMI_HDCP22_CONTROL_CD_OVR_EN_OFFSET = 16,
+	HDMI_HDCP22_CONTROL_HPD_MASK = BIT(12),
+	HDMI_HDCP22_CONTROL_HPD_OFFSET = 12,
+	HDMI_HDCP22_CONTROL_PKT_ERR_OVR_VAL_MASK = BIT(9),
+	HDMI_HDCP22_CONTROL_PKT_ERR_OVR_VAL_OFFSET= 9,
+	HDMI_HDCP22_CONTROL_PKT_ERR_OVR_EN_MASK = BIT(8),
+	HDMI_HDCP22_CONTROL_PKT_ERR_OVR_EN_OFFSET = 8,
+	HDMI_HDCP22_CONTROL_AVMUTE_OVR_VAL_MASK = BIT(5),
+	HDMI_HDCP22_CONTROL_AVMUTE_OVR_VAL_OFFSET = 5,
+	HDMI_HDCP22_CONTROL_AVMUTE_OVR_EN_MASK = BIT(4),
+	HDMI_HDCP22_CONTROL_AVMUTE_OVR_EN_OFFSET = 4,
+	HDMI_HDCP22_CONTROL_OVR_VAL_MASK = BIT(2),
+	HDMI_HDCP22_CONTROL_OVR_VAL_OFFSET = 2,
+	HDMI_HDCP22_CONTROL_OVR_EN_MASK = BIT(1),
+	HDMI_HDCP22_CONTROL_OVR_EN_OFFSET = 1,
+	HDMI_HDCP22_CONTROL_SWITCH_LCK_MASK = BIT(0),
+	HDMI_HDCP22_CONTROL_SWITCH_LCK_OFFSET = 0,
+	/* AUD_CEC_ISTS field values */
+	HDMI_AUD_CEC_ISTS_WAKEUPCTRL = BIT(22),
+	HDMI_AUD_CEC_ISTS_ERROR_FOLL = BIT(21),
+	HDMI_AUD_CEC_ISTS_ERROR_INIT = BIT(20),
+	HDMI_AUD_CEC_ISTS_ARBLST = BIT(19),
+	HDMI_AUD_CEC_ISTS_NACK = BIT(18),
+	HDMI_AUD_CEC_ISTS_EOM = BIT(17),
+	HDMI_AUD_CEC_ISTS_DONE = BIT(16),
+	HDMI_AUD_CEC_ISTS_SCK_STABLE = BIT(1),
+	HDMI_AUD_CEC_ISTS_CTSN_CNT = BIT(0),
+	/* MD_ISTS field values */
+	HDMI_MD_ISTS_VOFS_LIN = BIT(11),
+	HDMI_MD_ISTS_VTOT_LIN = BIT(10),
+	HDMI_MD_ISTS_VACT_LIN = BIT(9),
+	HDMI_MD_ISTS_VS_CLK = BIT(8),
+	HDMI_MD_ISTS_VTOT_CLK = BIT(7),
+	HDMI_MD_ISTS_HACT_PIX = BIT(6),
+	HDMI_MD_ISTS_HS_CLK = BIT(5),
+	HDMI_MD_ISTS_HTOT32_CLK = BIT(4),
+	HDMI_MD_ISTS_ILACE = BIT(3),
+	HDMI_MD_ISTS_DE_ACTIVITY = BIT(2),
+	HDMI_MD_ISTS_VS_ACT = BIT(1),
+	HDMI_MD_ISTS_HS_ACT = BIT(0),
+	/* ISTS field values */
+	HDMI_ISTS_I2CMP_ARBLOST = BIT(30),
+	HDMI_ISTS_I2CMPNACK = BIT(29),
+	HDMI_ISTS_I2CMPDONE = BIT(28),
+	HDMI_ISTS_VS_THR_REACHED = BIT(27),
+	HDMI_ISTS_VSYNC_ACT_EDGE = BIT(26),
+	HDMI_ISTS_AKSV_RCV = BIT(25),
+	HDMI_ISTS_PLL_CLOCK_GATED = BIT(24),
+	HDMI_ISTS_DESER_MISAL = BIT(23),
+	HDMI_ISTS_CDSENSE_CHG = BIT(22),
+	HDMI_ISTS_CEAVID_EMPTY = BIT(21),
+	HDMI_ISTS_CEAVID_FULL = BIT(20),
+	HDMI_ISTS_SCDCTMDSCFGCHANGE = BIT(19),
+	HDMI_ISTS_SCDCSCSTATUSCHANGE = BIT(18),
+	HDMI_ISTS_SCDCCFGCHANGE = BIT(17),
+	HDMI_ISTS_DCM_CURRENT_MODE_CHG = BIT(16),
+	HDMI_ISTS_DCM_PH_DIFF_CNT_OVERFL = BIT(15),
+	HDMI_ISTS_DCM_GCP_ZERO_FIELDS_PASS = BIT(14),
+	HDMI_ISTS_CTL3_CHANGE = BIT(13),
+	HDMI_ISTS_CTL2_CHANGE = BIT(12),
+	HDMI_ISTS_CTL1_CHANGE = BIT(11),
+	HDMI_ISTS_CTL0_CHANGE = BIT(10),
+	HDMI_ISTS_VS_POL_ADJ = BIT(9),
+	HDMI_ISTS_HS_POL_ADJ = BIT(8),
+	HDMI_ISTS_RES_OVERLOAD = BIT(7),
+	HDMI_ISTS_CLK_CHANGE = BIT(6),
+	HDMI_ISTS_PLL_LCK_CHG = BIT(5),
+	HDMI_ISTS_EQGAIN_DONE = BIT(4),
+	HDMI_ISTS_OFFSCAL_DONE = BIT(3),
+	HDMI_ISTS_RESCAL_DONE = BIT(2),
+	HDMI_ISTS_ACT_CHANGE = BIT(1),
+	HDMI_ISTS_STATE_REACHED = BIT(0),
+	/* DMI_SW_RST field values */
+	HDMI_DMI_SW_RST_TMDS = BIT(16),
+	HDMI_DMI_SW_RST_HDCP = BIT(8),
+	HDMI_DMI_SW_RST_VID = BIT(7),
+	HDMI_DMI_SW_RST_PIXEL = BIT(6),
+	HDMI_DMI_SW_RST_CEC = BIT(5),
+	HDMI_DMI_SW_RST_AUD = BIT(4),
+	HDMI_DMI_SW_RST_BUS = BIT(3),
+	HDMI_DMI_SW_RST_HDMI = BIT(2),
+	HDMI_DMI_SW_RST_MODET = BIT(1),
+	HDMI_DMI_SW_RST_MAIN = BIT(0),
+	/* CEC_CTRL field values */
+	HDMI_CEC_CTRL_STANDBY_MASK = BIT(4),
+	HDMI_CEC_CTRL_STANDBY_OFFSET = 4,
+	HDMI_CEC_CTRL_BC_NACK_MASK = BIT(3),
+	HDMI_CEC_CTRL_BC_NACK_OFFSET = 3,
+	HDMI_CEC_CTRL_FRAME_TYP_MASK = GENMASK(2,1),
+	HDMI_CEC_CTRL_FRAME_TYP_OFFSET = 1,
+	HDMI_CEC_CTRL_SEND_MASK = BIT(0),
+	HDMI_CEC_CTRL_SEND_OFFSET = 0,
+	/* CEC_MASK field values */
+	HDMI_CEC_MASK_WAKEUP_MASK = BIT(6),
+	HDMI_CEC_MASK_WAKEUP_OFFSET = 6,
+	HDMI_CEC_MASK_ERROR_FLOW_MASK = BIT(5),
+	HDMI_CEC_MASK_ERROR_FLOW_OFFSET = 5,
+	HDMI_CEC_MASK_ERROR_INITITATOR_MASK = BIT(4),
+	HDMI_CEC_MASK_ERROR_INITITATOR_OFFSET = 4,
+	HDMI_CEC_MASK_ARB_LOST_MASK = BIT(3),
+	HDMI_CEC_MASK_ARB_LOST_OFFSET = 3,
+	HDMI_CEC_MASK_NACK_MASK = BIT(2),
+	HDMI_CEC_MASK_NACK_OFFSET = 2,
+	HDMI_CEC_MASK_EOM_MASK = BIT(1),
+	HDMI_CEC_MASK_EOM_OFFSET = 1,
+	HDMI_CEC_MASK_DONE_MASK = BIT(0),
+	HDMI_CEC_MASK_DONE_OFFSET = 0,
+	/* CBUSIOCTRL field values */
+	HDMI_CBUSIOCTRL_DATAPATH_CBUSZ_MASK = BIT(24),
+	HDMI_CBUSIOCTRL_DATAPATH_CBUSZ_OFFSET = 24,
+	HDMI_CBUSIOCTRL_SVSRETMODEZ_MASK = BIT(16),
+	HDMI_CBUSIOCTRL_SVSRETMODEZ_OFFSET = 16,
+	HDMI_CBUSIOCTRL_PDDQ_MASK = BIT(8),
+	HDMI_CBUSIOCTRL_PDDQ_OFFSET = 8,
+	HDMI_CBUSIOCTRL_RESET_MASK = BIT(0),
+	HDMI_CBUSIOCTRL_RESET_OFFSET = 0,
+};
+
+#endif /* __DW_HDMI_RX_H__ */
diff --git a/include/media/dwc/dw-hdmi-rx-pdata.h b/include/media/dwc/dw-hdmi-rx-pdata.h
new file mode 100644
index 0000000..41d5c8d
--- /dev/null
+++ b/include/media/dwc/dw-hdmi-rx-pdata.h
@@ -0,0 +1,70 @@
+/*
+ * Synopsys Designware HDMI Receiver controller platform data
+ *
+ * This Synopsys dw-hdmi-rx software and associated documentation
+ * (hereinafter the "Software") is an unsupported proprietary work of
+ * Synopsys, Inc. unless otherwise expressly agreed to in writing between
+ * Synopsys and you. The Software IS NOT an item of Licensed Software or a
+ * Licensed Product under any End User Software License Agreement or
+ * Agreement for Licensed Products with Synopsys or any supplement thereto.
+ * Synopsys is a registered trademark of Synopsys, Inc. Other names included
+ * in the SOFTWARE may be the trademarks of their respective owners.
+ *
+ * The contents of this file are dual-licensed; you may select either version 2
+ * of the GNU General Public License (“GPL”) or the MIT license (“MIT”).
+ *
+ * Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
+ *
+ * THIS SOFTWARE IS PROVIDED "AS IS"  WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING, BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE, AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT, OR OTHERWISE
+ * ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __DW_HDMI_RX_PDATA_H__
+#define __DW_HDMI_RX_PDATA_H__
+
+#define DW_HDMI_RX_DRVNAME			"dw-hdmi-rx"
+
+/* Notify events */
+#define DW_HDMI_NOTIFY_IS_OFF		1
+#define DW_HDMI_NOTIFY_INPUT_CHANGED	2
+#define DW_HDMI_NOTIFY_AUDIO_CHANGED	3
+#define DW_HDMI_NOTIFY_IS_STABLE	4
+
+/**
+ * struct dw_hdmi_rx_pdata - Platform Data configuration for HDMI receiver.
+ *
+ * @dw_5v_status: 5v status callback. Shall return the status of the given
+ * input, i.e. shall be true if a cable is connected to the specified input.
+ *
+ * @dw_5v_clear: 5v clear callback. Shall clear the interrupt associated with
+ * the 5v sense controller.
+ *
+ * @dw_5v_arg: Argument to be used with the 5v sense callbacks.
+ *
+ * @dw_zcal_reset: Impedance calibration reset callback. Shall be called when
+ * the impedance calibration needs to be restarted. This is used by phy driver
+ * only.
+ *
+ * @dw_zcal_done: Impedance calibration status callback. Shall return true if
+ * the impedance calibration procedure has ended. This is used by phy driver
+ * only.
+ *
+ * @dw_zcal_arg: Argument to be used with the ZCAL calibration callbacks.
+ */
+struct dw_hdmi_rx_pdata {
+	/* 5V sense interface */
+	bool (*dw_5v_status)(void __iomem *regs, int input);
+	void (*dw_5v_clear)(void __iomem *regs);
+	void __iomem *dw_5v_arg;
+	/* Zcal interface */
+	void (*dw_zcal_reset)(void __iomem *regs);
+	bool (*dw_zcal_done)(void __iomem *regs);
+	void __iomem *dw_zcal_arg;
+};
+
+#endif /* __DW_HDMI_RX_PDATA_H__ */
-- 
1.9.1
