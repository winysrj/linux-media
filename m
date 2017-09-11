Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53319 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751660AbdIKM37 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Sep 2017 08:29:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, thierry.reding@gmail.com,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv4 3/4] tegra-cec: add Tegra HDMI CEC driver
Date: Mon, 11 Sep 2017 14:29:51 +0200
Message-Id: <20170911122952.33980-4-hverkuil@xs4all.nl>
In-Reply-To: <20170911122952.33980-1-hverkuil@xs4all.nl>
References: <20170911122952.33980-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver adds support for the Tegra CEC IP. It is based on the
NVIDIA drivers/misc/tegra-cec driver in their 3.10 kernel.

This has been converted to the CEC framework and cleaned up.

Tested with my Jetson TK1 board. It has also been tested with the
Tegra X1 in an embedded product.

Note of warning for the Tegra X2: this SoC supports two HDMI outputs,
but only one CEC adapter and the CEC bus is shared between the
two outputs. This is a design mistake and the CEC adapter can
control only one HDMI output. Never hook up both HDMI outputs
to the CEC bus in a hardware design: this is illegal as per the
CEC specification.

The CEC bus can be shared between multiple inputs and zero or one
outputs, but not between multiple outputs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                                  |   8 +
 drivers/media/platform/Kconfig               |  11 +
 drivers/media/platform/Makefile              |   2 +
 drivers/media/platform/tegra-cec/Makefile    |   1 +
 drivers/media/platform/tegra-cec/tegra_cec.c | 501 +++++++++++++++++++++++++++
 drivers/media/platform/tegra-cec/tegra_cec.h | 127 +++++++
 6 files changed, 650 insertions(+)
 create mode 100644 drivers/media/platform/tegra-cec/Makefile
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.c
 create mode 100644 drivers/media/platform/tegra-cec/tegra_cec.h

diff --git a/MAINTAINERS b/MAINTAINERS
index eb930ebecfcb..dd40c1f335a8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1923,6 +1923,14 @@ M:	Lennert Buytenhek <kernel@wantstofly.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 
+ARM/TEGRA HDMI CEC SUBSYSTEM SUPPORT
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-tegra@vger.kernel.org
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/platform/tegra-cec/
+F:	Documentation/devicetree/bindings/media/tegra-cec.txt
+
 ARM/TETON BGA MACHINE SUPPORT
 M:	"Mark F. Brown" <mark.brown314@gmail.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 7e7cc49b8674..ec218fcf3886 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -589,6 +589,17 @@ config VIDEO_STM32_HDMI_CEC
          CEC bus is present in the HDMI connector and enables communication
          between compatible devices.
 
+config VIDEO_TEGRA_HDMI_CEC
+       tristate "Tegra HDMI CEC driver"
+       depends on ARCH_TEGRA || COMPILE_TEST
+       select CEC_CORE
+       select CEC_NOTIFIER
+       ---help---
+         This is a driver for the Tegra HDMI CEC interface. It uses the
+         generic CEC framework interface.
+         The CEC bus is present in the HDMI connector and enables communication
+         between compatible devices.
+
 endif #CEC_PLATFORM_DRIVERS
 
 menuconfig SDR_PLATFORM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index c1ef946bf032..e31faaa852f3 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -46,6 +46,8 @@ obj-$(CONFIG_VIDEO_STI_HDMI_CEC) 	+= sti/cec/
 
 obj-$(CONFIG_VIDEO_STI_DELTA)		+= sti/delta/
 
+obj-$(CONFIG_VIDEO_TEGRA_HDMI_CEC)	+= tegra-cec/
+
 obj-y 					+= stm32/
 
 obj-y                                   += blackfin/
diff --git a/drivers/media/platform/tegra-cec/Makefile b/drivers/media/platform/tegra-cec/Makefile
new file mode 100644
index 000000000000..f3d81127589f
--- /dev/null
+++ b/drivers/media/platform/tegra-cec/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_TEGRA_HDMI_CEC)	+= tegra_cec.o
diff --git a/drivers/media/platform/tegra-cec/tegra_cec.c b/drivers/media/platform/tegra-cec/tegra_cec.c
new file mode 100644
index 000000000000..b53743f555e8
--- /dev/null
+++ b/drivers/media/platform/tegra-cec/tegra_cec.c
@@ -0,0 +1,501 @@
+/*
+ * Tegra CEC implementation
+ *
+ * The original 3.10 CEC driver using a custom API:
+ *
+ * Copyright (c) 2012-2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Conversion to the CEC framework and to the mainline kernel:
+ *
+ * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/pm.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/clk/tegra.h>
+
+#include <media/cec-notifier.h>
+
+#include "tegra_cec.h"
+
+#define TEGRA_CEC_NAME "tegra-cec"
+
+struct tegra_cec {
+	struct cec_adapter	*adap;
+	struct device		*dev;
+	struct clk		*clk;
+	void __iomem		*cec_base;
+	struct cec_notifier	*notifier;
+	int			tegra_cec_irq;
+	bool			rx_done;
+	bool			tx_done;
+	int			tx_status;
+	u8			rx_buf[CEC_MAX_MSG_SIZE];
+	u8			rx_buf_cnt;
+	u32			tx_buf[CEC_MAX_MSG_SIZE];
+	u8			tx_buf_cur;
+	u8			tx_buf_cnt;
+};
+
+static inline u32 cec_read(struct tegra_cec *cec, u32 reg)
+{
+	return readl(cec->cec_base + reg);
+}
+
+static inline void cec_write(struct tegra_cec *cec, u32 reg, u32 val)
+{
+	writel(val, cec->cec_base + reg);
+}
+
+static void tegra_cec_error_recovery(struct tegra_cec *cec)
+{
+	u32 hw_ctrl;
+
+	hw_ctrl = cec_read(cec, TEGRA_CEC_HW_CONTROL);
+	cec_write(cec, TEGRA_CEC_HW_CONTROL, 0);
+	cec_write(cec, TEGRA_CEC_INT_STAT, 0xffffffff);
+	cec_write(cec, TEGRA_CEC_HW_CONTROL, hw_ctrl);
+}
+
+static irqreturn_t tegra_cec_irq_thread_handler(int irq, void *data)
+{
+	struct device *dev = data;
+	struct tegra_cec *cec = dev_get_drvdata(dev);
+
+	if (cec->tx_done) {
+		cec_transmit_attempt_done(cec->adap, cec->tx_status);
+		cec->tx_done = false;
+	}
+	if (cec->rx_done) {
+		struct cec_msg msg = {};
+
+		msg.len = cec->rx_buf_cnt;
+		memcpy(msg.msg, cec->rx_buf, msg.len);
+		cec_received_msg(cec->adap, &msg);
+		cec->rx_done = false;
+		cec->rx_buf_cnt = 0;
+	}
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t tegra_cec_irq_handler(int irq, void *data)
+{
+	struct device *dev = data;
+	struct tegra_cec *cec = dev_get_drvdata(dev);
+	u32 status, mask;
+
+	status = cec_read(cec, TEGRA_CEC_INT_STAT);
+	mask = cec_read(cec, TEGRA_CEC_INT_MASK);
+
+	status &= mask;
+
+	if (!status)
+		return IRQ_HANDLED;
+
+	if (status & TEGRA_CEC_INT_STAT_TX_REGISTER_UNDERRUN) {
+		dev_err(dev, "TX underrun, interrupt timing issue!\n");
+
+		tegra_cec_error_recovery(cec);
+		cec_write(cec, TEGRA_CEC_INT_MASK,
+			  mask & ~TEGRA_CEC_INT_MASK_TX_REGISTER_EMPTY);
+
+		cec->tx_done = true;
+		cec->tx_status = CEC_TX_STATUS_ERROR;
+		return IRQ_WAKE_THREAD;
+	}
+
+	if ((status & TEGRA_CEC_INT_STAT_TX_ARBITRATION_FAILED) ||
+		   (status & TEGRA_CEC_INT_STAT_TX_BUS_ANOMALY_DETECTED)) {
+		tegra_cec_error_recovery(cec);
+		cec_write(cec, TEGRA_CEC_INT_MASK,
+			  mask & ~TEGRA_CEC_INT_MASK_TX_REGISTER_EMPTY);
+
+		cec->tx_done = true;
+		if (status & TEGRA_CEC_INT_STAT_TX_BUS_ANOMALY_DETECTED)
+			cec->tx_status = CEC_TX_STATUS_LOW_DRIVE;
+		else
+			cec->tx_status = CEC_TX_STATUS_ARB_LOST;
+		return IRQ_WAKE_THREAD;
+	}
+
+	if (status & TEGRA_CEC_INT_STAT_TX_FRAME_TRANSMITTED) {
+		cec_write(cec, TEGRA_CEC_INT_STAT,
+			  TEGRA_CEC_INT_STAT_TX_FRAME_TRANSMITTED);
+
+		if (status & TEGRA_CEC_INT_STAT_TX_FRAME_OR_BLOCK_NAKD) {
+			tegra_cec_error_recovery(cec);
+
+			cec->tx_done = true;
+			cec->tx_status = CEC_TX_STATUS_NACK;
+		} else {
+			cec->tx_done = true;
+			cec->tx_status = CEC_TX_STATUS_OK;
+		}
+		return IRQ_WAKE_THREAD;
+	}
+
+	if (status & TEGRA_CEC_INT_STAT_TX_FRAME_OR_BLOCK_NAKD)
+		dev_warn(dev, "TX NAKed on the fly!\n");
+
+	if (status & TEGRA_CEC_INT_STAT_TX_REGISTER_EMPTY) {
+		if (cec->tx_buf_cur == cec->tx_buf_cnt) {
+			cec_write(cec, TEGRA_CEC_INT_MASK,
+				  mask & ~TEGRA_CEC_INT_MASK_TX_REGISTER_EMPTY);
+		} else {
+			cec_write(cec, TEGRA_CEC_TX_REGISTER,
+				  cec->tx_buf[cec->tx_buf_cur++]);
+			cec_write(cec, TEGRA_CEC_INT_STAT,
+				  TEGRA_CEC_INT_STAT_TX_REGISTER_EMPTY);
+		}
+	}
+
+	if (status & (TEGRA_CEC_INT_STAT_RX_REGISTER_OVERRUN |
+		      TEGRA_CEC_INT_STAT_RX_BUS_ANOMALY_DETECTED |
+		      TEGRA_CEC_INT_STAT_RX_START_BIT_DETECTED |
+		      TEGRA_CEC_INT_STAT_RX_BUS_ERROR_DETECTED)) {
+		cec_write(cec, TEGRA_CEC_INT_STAT,
+			  (TEGRA_CEC_INT_STAT_RX_REGISTER_OVERRUN |
+			   TEGRA_CEC_INT_STAT_RX_BUS_ANOMALY_DETECTED |
+			   TEGRA_CEC_INT_STAT_RX_START_BIT_DETECTED |
+			   TEGRA_CEC_INT_STAT_RX_BUS_ERROR_DETECTED));
+	} else if (status & TEGRA_CEC_INT_STAT_RX_REGISTER_FULL) {
+		u32 v;
+
+		cec_write(cec, TEGRA_CEC_INT_STAT,
+			  TEGRA_CEC_INT_STAT_RX_REGISTER_FULL);
+		v = cec_read(cec, TEGRA_CEC_RX_REGISTER);
+		if (cec->rx_buf_cnt < CEC_MAX_MSG_SIZE)
+			cec->rx_buf[cec->rx_buf_cnt++] = v & 0xff;
+		if (v & TEGRA_CEC_RX_REGISTER_EOM) {
+			cec->rx_done = true;
+			return IRQ_WAKE_THREAD;
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int tegra_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct tegra_cec *cec = adap->priv;
+
+	cec->rx_buf_cnt = 0;
+	cec->tx_buf_cnt = 0;
+	cec->tx_buf_cur = 0;
+
+	cec_write(cec, TEGRA_CEC_HW_CONTROL, 0);
+	cec_write(cec, TEGRA_CEC_INT_MASK, 0);
+	cec_write(cec, TEGRA_CEC_INT_STAT, 0xffffffff);
+	cec_write(cec, TEGRA_CEC_SW_CONTROL, 0);
+
+	if (!enable)
+		return 0;
+
+	cec_write(cec, TEGRA_CEC_INPUT_FILTER, (1U << 31) | 0x20);
+
+	cec_write(cec, TEGRA_CEC_RX_TIMING_0,
+		  (0x7a << TEGRA_CEC_RX_TIM0_START_BIT_MAX_LO_TIME_SHIFT) |
+		  (0x6d << TEGRA_CEC_RX_TIM0_START_BIT_MIN_LO_TIME_SHIFT) |
+		  (0x93 << TEGRA_CEC_RX_TIM0_START_BIT_MAX_DURATION_SHIFT) |
+		  (0x86 << TEGRA_CEC_RX_TIM0_START_BIT_MIN_DURATION_SHIFT));
+
+	cec_write(cec, TEGRA_CEC_RX_TIMING_1,
+		  (0x35 << TEGRA_CEC_RX_TIM1_DATA_BIT_MAX_LO_TIME_SHIFT) |
+		  (0x21 << TEGRA_CEC_RX_TIM1_DATA_BIT_SAMPLE_TIME_SHIFT) |
+		  (0x56 << TEGRA_CEC_RX_TIM1_DATA_BIT_MAX_DURATION_SHIFT) |
+		  (0x40 << TEGRA_CEC_RX_TIM1_DATA_BIT_MIN_DURATION_SHIFT));
+
+	cec_write(cec, TEGRA_CEC_RX_TIMING_2,
+		  (0x50 << TEGRA_CEC_RX_TIM2_END_OF_BLOCK_TIME_SHIFT));
+
+	cec_write(cec, TEGRA_CEC_TX_TIMING_0,
+		  (0x74 << TEGRA_CEC_TX_TIM0_START_BIT_LO_TIME_SHIFT) |
+		  (0x8d << TEGRA_CEC_TX_TIM0_START_BIT_DURATION_SHIFT) |
+		  (0x08 << TEGRA_CEC_TX_TIM0_BUS_XITION_TIME_SHIFT) |
+		  (0x71 << TEGRA_CEC_TX_TIM0_BUS_ERROR_LO_TIME_SHIFT));
+
+	cec_write(cec, TEGRA_CEC_TX_TIMING_1,
+		  (0x2f << TEGRA_CEC_TX_TIM1_LO_DATA_BIT_LO_TIME_SHIFT) |
+		  (0x13 << TEGRA_CEC_TX_TIM1_HI_DATA_BIT_LO_TIME_SHIFT) |
+		  (0x4b << TEGRA_CEC_TX_TIM1_DATA_BIT_DURATION_SHIFT) |
+		  (0x21 << TEGRA_CEC_TX_TIM1_ACK_NAK_BIT_SAMPLE_TIME_SHIFT));
+
+	cec_write(cec, TEGRA_CEC_TX_TIMING_2,
+		  (0x07 << TEGRA_CEC_TX_TIM2_BUS_IDLE_TIME_ADDITIONAL_FRAME_SHIFT) |
+		  (0x05 << TEGRA_CEC_TX_TIM2_BUS_IDLE_TIME_NEW_FRAME_SHIFT) |
+		  (0x03 << TEGRA_CEC_TX_TIM2_BUS_IDLE_TIME_RETRY_FRAME_SHIFT));
+
+	cec_write(cec, TEGRA_CEC_INT_MASK,
+		  TEGRA_CEC_INT_MASK_TX_REGISTER_UNDERRUN |
+		  TEGRA_CEC_INT_MASK_TX_FRAME_OR_BLOCK_NAKD |
+		  TEGRA_CEC_INT_MASK_TX_ARBITRATION_FAILED |
+		  TEGRA_CEC_INT_MASK_TX_BUS_ANOMALY_DETECTED |
+		  TEGRA_CEC_INT_MASK_TX_FRAME_TRANSMITTED |
+		  TEGRA_CEC_INT_MASK_RX_REGISTER_FULL |
+		  TEGRA_CEC_INT_MASK_RX_REGISTER_OVERRUN);
+
+	cec_write(cec, TEGRA_CEC_HW_CONTROL, TEGRA_CEC_HWCTRL_TX_RX_MODE);
+	return 0;
+}
+
+static int tegra_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
+{
+	struct tegra_cec *cec = adap->priv;
+	u32 state = cec_read(cec, TEGRA_CEC_HW_CONTROL);
+
+	if (logical_addr == CEC_LOG_ADDR_INVALID)
+		state &= ~TEGRA_CEC_HWCTRL_RX_LADDR_MASK;
+	else
+		state |= TEGRA_CEC_HWCTRL_RX_LADDR((1 << logical_addr));
+
+	cec_write(cec, TEGRA_CEC_HW_CONTROL, state);
+	return 0;
+}
+
+static int tegra_cec_adap_monitor_all_enable(struct cec_adapter *adap,
+					     bool enable)
+{
+	struct tegra_cec *cec = adap->priv;
+	u32 reg = cec_read(cec, TEGRA_CEC_HW_CONTROL);
+
+	if (enable)
+		reg |= TEGRA_CEC_HWCTRL_RX_SNOOP;
+	else
+		reg &= ~TEGRA_CEC_HWCTRL_RX_SNOOP;
+	cec_write(cec, TEGRA_CEC_HW_CONTROL, reg);
+	return 0;
+}
+
+static int tegra_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				   u32 signal_free_time_ms, struct cec_msg *msg)
+{
+	bool retry_xfer = signal_free_time_ms == CEC_SIGNAL_FREE_TIME_RETRY;
+	struct tegra_cec *cec = adap->priv;
+	unsigned int i;
+	u32 mode = 0;
+	u32 mask;
+
+	if (cec_msg_is_broadcast(msg))
+		mode = TEGRA_CEC_TX_REG_BCAST;
+
+	cec->tx_buf_cur = 0;
+	cec->tx_buf_cnt = msg->len;
+
+	for (i = 0; i < msg->len; i++) {
+		cec->tx_buf[i] = mode | msg->msg[i];
+		if (i == 0)
+			cec->tx_buf[i] |= TEGRA_CEC_TX_REG_START_BIT;
+		if (i == msg->len - 1)
+			cec->tx_buf[i] |= TEGRA_CEC_TX_REG_EOM;
+		if (i == 0 && retry_xfer)
+			cec->tx_buf[i] |= TEGRA_CEC_TX_REG_RETRY;
+	}
+
+	mask = cec_read(cec, TEGRA_CEC_INT_MASK);
+	cec_write(cec, TEGRA_CEC_INT_MASK,
+		  mask | TEGRA_CEC_INT_MASK_TX_REGISTER_EMPTY);
+
+	return 0;
+}
+
+static const struct cec_adap_ops tegra_cec_ops = {
+	.adap_enable = tegra_cec_adap_enable,
+	.adap_log_addr = tegra_cec_adap_log_addr,
+	.adap_transmit = tegra_cec_adap_transmit,
+	.adap_monitor_all_enable = tegra_cec_adap_monitor_all_enable,
+};
+
+static int tegra_cec_probe(struct platform_device *pdev)
+{
+	struct platform_device *hdmi_dev;
+	struct device_node *np;
+	struct tegra_cec *cec;
+	struct resource *res;
+	int ret = 0;
+
+	np = of_parse_phandle(pdev->dev.of_node, "hdmi-phandle", 0);
+
+	if (!np) {
+		dev_err(&pdev->dev, "Failed to find hdmi node in device tree\n");
+		return -ENODEV;
+	}
+	hdmi_dev = of_find_device_by_node(np);
+	if (hdmi_dev == NULL)
+		return -EPROBE_DEFER;
+
+	cec = devm_kzalloc(&pdev->dev, sizeof(struct tegra_cec), GFP_KERNEL);
+
+	if (!cec)
+		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+
+	if (!res) {
+		dev_err(&pdev->dev,
+			"Unable to allocate resources for device\n");
+		ret = -EBUSY;
+		goto cec_error;
+	}
+
+	if (!devm_request_mem_region(&pdev->dev, res->start, resource_size(res),
+		pdev->name)) {
+		dev_err(&pdev->dev,
+			"Unable to request mem region for device\n");
+		ret = -EBUSY;
+		goto cec_error;
+	}
+
+	cec->tegra_cec_irq = platform_get_irq(pdev, 0);
+
+	if (cec->tegra_cec_irq <= 0) {
+		ret = -EBUSY;
+		goto cec_error;
+	}
+
+	cec->cec_base = devm_ioremap_nocache(&pdev->dev, res->start,
+		resource_size(res));
+
+	if (!cec->cec_base) {
+		dev_err(&pdev->dev, "Unable to grab IOs for device\n");
+		ret = -EBUSY;
+		goto cec_error;
+	}
+
+	cec->clk = devm_clk_get(&pdev->dev, "cec");
+
+	if (IS_ERR_OR_NULL(cec->clk)) {
+		dev_err(&pdev->dev, "Can't get clock for CEC\n");
+		ret = -ENOENT;
+		goto clk_error;
+	}
+
+	clk_prepare_enable(cec->clk);
+
+	/* set context info. */
+	cec->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, cec);
+
+	ret = devm_request_threaded_irq(&pdev->dev, cec->tegra_cec_irq,
+		tegra_cec_irq_handler, tegra_cec_irq_thread_handler,
+		0, "cec_irq", &pdev->dev);
+
+	if (ret) {
+		dev_err(&pdev->dev,
+			"Unable to request interrupt for device\n");
+		goto cec_error;
+	}
+
+	cec->notifier = cec_notifier_get(&hdmi_dev->dev);
+	if (!cec->notifier) {
+		ret = -ENOMEM;
+		goto cec_error;
+	}
+
+	cec->adap = cec_allocate_adapter(&tegra_cec_ops, cec, TEGRA_CEC_NAME,
+			CEC_CAP_DEFAULTS | CEC_CAP_MONITOR_ALL,
+			CEC_MAX_LOG_ADDRS);
+	if (IS_ERR(cec->adap)) {
+		ret = -ENOMEM;
+		dev_err(&pdev->dev, "Couldn't create cec adapter\n");
+		goto cec_error;
+	}
+	ret = cec_register_adapter(cec->adap, &pdev->dev);
+	if (ret) {
+		dev_err(&pdev->dev, "Couldn't register device\n");
+		goto cec_error;
+	}
+
+	cec_register_cec_notifier(cec->adap, cec->notifier);
+
+	return 0;
+
+cec_error:
+	if (cec->notifier)
+		cec_notifier_put(cec->notifier);
+	cec_delete_adapter(cec->adap);
+	clk_disable_unprepare(cec->clk);
+clk_error:
+	return ret;
+}
+
+static int tegra_cec_remove(struct platform_device *pdev)
+{
+	struct tegra_cec *cec = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(cec->clk);
+
+	cec_unregister_adapter(cec->adap);
+	cec_notifier_put(cec->notifier);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int tegra_cec_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct tegra_cec *cec = platform_get_drvdata(pdev);
+
+	clk_disable_unprepare(cec->clk);
+
+	dev_notice(&pdev->dev, "suspended\n");
+	return 0;
+}
+
+static int tegra_cec_resume(struct platform_device *pdev)
+{
+	struct tegra_cec *cec = platform_get_drvdata(pdev);
+
+	dev_notice(&pdev->dev, "Resuming\n");
+
+	clk_prepare_enable(cec->clk);
+
+	return 0;
+}
+#endif
+
+static const struct of_device_id tegra_cec_of_match[] = {
+	{ .compatible = "nvidia,tegra114-cec", },
+	{ .compatible = "nvidia,tegra124-cec", },
+	{ .compatible = "nvidia,tegra210-cec", },
+	{},
+};
+
+static struct platform_driver tegra_cec_driver = {
+	.driver = {
+		.name = TEGRA_CEC_NAME,
+		.of_match_table = of_match_ptr(tegra_cec_of_match),
+	},
+	.probe = tegra_cec_probe,
+	.remove = tegra_cec_remove,
+
+#ifdef CONFIG_PM
+	.suspend = tegra_cec_suspend,
+	.resume = tegra_cec_resume,
+#endif
+};
+
+module_platform_driver(tegra_cec_driver);
diff --git a/drivers/media/platform/tegra-cec/tegra_cec.h b/drivers/media/platform/tegra-cec/tegra_cec.h
new file mode 100644
index 000000000000..e301513daa87
--- /dev/null
+++ b/drivers/media/platform/tegra-cec/tegra_cec.h
@@ -0,0 +1,127 @@
+/*
+ * Tegra CEC register definitions
+ *
+ * The original 3.10 CEC driver using a custom API:
+ *
+ * Copyright (c) 2012-2015, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * Conversion to the CEC framework and to the mainline kernel:
+ *
+ * Copyright 2016-2017 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef TEGRA_CEC_H
+#define TEGRA_CEC_H
+
+/* CEC registers */
+#define TEGRA_CEC_SW_CONTROL	0x000
+#define TEGRA_CEC_HW_CONTROL	0x004
+#define TEGRA_CEC_INPUT_FILTER	0x008
+#define TEGRA_CEC_TX_REGISTER	0x010
+#define TEGRA_CEC_RX_REGISTER	0x014
+#define TEGRA_CEC_RX_TIMING_0	0x018
+#define TEGRA_CEC_RX_TIMING_1	0x01c
+#define TEGRA_CEC_RX_TIMING_2	0x020
+#define TEGRA_CEC_TX_TIMING_0	0x024
+#define TEGRA_CEC_TX_TIMING_1	0x028
+#define TEGRA_CEC_TX_TIMING_2	0x02c
+#define TEGRA_CEC_INT_STAT	0x030
+#define TEGRA_CEC_INT_MASK	0x034
+#define TEGRA_CEC_HW_DEBUG_RX	0x038
+#define TEGRA_CEC_HW_DEBUG_TX	0x03c
+
+#define TEGRA_CEC_HWCTRL_RX_LADDR_MASK				0x7fff
+#define TEGRA_CEC_HWCTRL_RX_LADDR(x)	\
+	((x) & TEGRA_CEC_HWCTRL_RX_LADDR_MASK)
+#define TEGRA_CEC_HWCTRL_RX_SNOOP				(1 << 15)
+#define TEGRA_CEC_HWCTRL_RX_NAK_MODE				(1 << 16)
+#define TEGRA_CEC_HWCTRL_TX_NAK_MODE				(1 << 24)
+#define TEGRA_CEC_HWCTRL_FAST_SIM_MODE				(1 << 30)
+#define TEGRA_CEC_HWCTRL_TX_RX_MODE				(1 << 31)
+
+#define TEGRA_CEC_INPUT_FILTER_MODE				(1 << 31)
+#define TEGRA_CEC_INPUT_FILTER_FIFO_LENGTH_SHIFT		0
+
+#define TEGRA_CEC_TX_REG_DATA_SHIFT				0
+#define TEGRA_CEC_TX_REG_EOM					(1 << 8)
+#define TEGRA_CEC_TX_REG_BCAST					(1 << 12)
+#define TEGRA_CEC_TX_REG_START_BIT				(1 << 16)
+#define TEGRA_CEC_TX_REG_RETRY					(1 << 17)
+
+#define TEGRA_CEC_RX_REGISTER_SHIFT				0
+#define TEGRA_CEC_RX_REGISTER_EOM				(1 << 8)
+#define TEGRA_CEC_RX_REGISTER_ACK				(1 << 9)
+
+#define TEGRA_CEC_RX_TIM0_START_BIT_MAX_LO_TIME_SHIFT		0
+#define TEGRA_CEC_RX_TIM0_START_BIT_MIN_LO_TIME_SHIFT		8
+#define TEGRA_CEC_RX_TIM0_START_BIT_MAX_DURATION_SHIFT		16
+#define TEGRA_CEC_RX_TIM0_START_BIT_MIN_DURATION_SHIFT		24
+
+#define TEGRA_CEC_RX_TIM1_DATA_BIT_MAX_LO_TIME_SHIFT		0
+#define TEGRA_CEC_RX_TIM1_DATA_BIT_SAMPLE_TIME_SHIFT		8
+#define TEGRA_CEC_RX_TIM1_DATA_BIT_MAX_DURATION_SHIFT		16
+#define TEGRA_CEC_RX_TIM1_DATA_BIT_MIN_DURATION_SHIFT		24
+
+#define TEGRA_CEC_RX_TIM2_END_OF_BLOCK_TIME_SHIFT		0
+
+#define TEGRA_CEC_TX_TIM0_START_BIT_LO_TIME_SHIFT		0
+#define TEGRA_CEC_TX_TIM0_START_BIT_DURATION_SHIFT		8
+#define TEGRA_CEC_TX_TIM0_BUS_XITION_TIME_SHIFT			16
+#define TEGRA_CEC_TX_TIM0_BUS_ERROR_LO_TIME_SHIFT		24
+
+#define TEGRA_CEC_TX_TIM1_LO_DATA_BIT_LO_TIME_SHIFT		0
+#define TEGRA_CEC_TX_TIM1_HI_DATA_BIT_LO_TIME_SHIFT		8
+#define TEGRA_CEC_TX_TIM1_DATA_BIT_DURATION_SHIFT		16
+#define TEGRA_CEC_TX_TIM1_ACK_NAK_BIT_SAMPLE_TIME_SHIFT		24
+
+#define TEGRA_CEC_TX_TIM2_BUS_IDLE_TIME_ADDITIONAL_FRAME_SHIFT	0
+#define TEGRA_CEC_TX_TIM2_BUS_IDLE_TIME_NEW_FRAME_SHIFT		4
+#define TEGRA_CEC_TX_TIM2_BUS_IDLE_TIME_RETRY_FRAME_SHIFT	8
+
+#define TEGRA_CEC_INT_STAT_TX_REGISTER_EMPTY			(1 << 0)
+#define TEGRA_CEC_INT_STAT_TX_REGISTER_UNDERRUN			(1 << 1)
+#define TEGRA_CEC_INT_STAT_TX_FRAME_OR_BLOCK_NAKD		(1 << 2)
+#define TEGRA_CEC_INT_STAT_TX_ARBITRATION_FAILED		(1 << 3)
+#define TEGRA_CEC_INT_STAT_TX_BUS_ANOMALY_DETECTED		(1 << 4)
+#define TEGRA_CEC_INT_STAT_TX_FRAME_TRANSMITTED			(1 << 5)
+#define TEGRA_CEC_INT_STAT_RX_REGISTER_FULL			(1 << 8)
+#define TEGRA_CEC_INT_STAT_RX_REGISTER_OVERRUN			(1 << 9)
+#define TEGRA_CEC_INT_STAT_RX_START_BIT_DETECTED		(1 << 10)
+#define TEGRA_CEC_INT_STAT_RX_BUS_ANOMALY_DETECTED		(1 << 11)
+#define TEGRA_CEC_INT_STAT_RX_BUS_ERROR_DETECTED		(1 << 12)
+#define TEGRA_CEC_INT_STAT_FILTERED_RX_DATA_PIN_TRANSITION_H2L	(1 << 13)
+#define TEGRA_CEC_INT_STAT_FILTERED_RX_DATA_PIN_TRANSITION_L2H	(1 << 14)
+
+#define TEGRA_CEC_INT_MASK_TX_REGISTER_EMPTY			(1 << 0)
+#define TEGRA_CEC_INT_MASK_TX_REGISTER_UNDERRUN			(1 << 1)
+#define TEGRA_CEC_INT_MASK_TX_FRAME_OR_BLOCK_NAKD		(1 << 2)
+#define TEGRA_CEC_INT_MASK_TX_ARBITRATION_FAILED		(1 << 3)
+#define TEGRA_CEC_INT_MASK_TX_BUS_ANOMALY_DETECTED		(1 << 4)
+#define TEGRA_CEC_INT_MASK_TX_FRAME_TRANSMITTED			(1 << 5)
+#define TEGRA_CEC_INT_MASK_RX_REGISTER_FULL			(1 << 8)
+#define TEGRA_CEC_INT_MASK_RX_REGISTER_OVERRUN			(1 << 9)
+#define TEGRA_CEC_INT_MASK_RX_START_BIT_DETECTED		(1 << 10)
+#define TEGRA_CEC_INT_MASK_RX_BUS_ANOMALY_DETECTED		(1 << 11)
+#define TEGRA_CEC_INT_MASK_RX_BUS_ERROR_DETECTED		(1 << 12)
+#define TEGRA_CEC_INT_MASK_FILTERED_RX_DATA_PIN_TRANSITION_H2L	(1 << 13)
+#define TEGRA_CEC_INT_MASK_FILTERED_RX_DATA_PIN_TRANSITION_L2H	(1 << 14)
+
+#define TEGRA_CEC_HW_DEBUG_TX_DURATION_COUNT_SHIFT		0
+#define TEGRA_CEC_HW_DEBUG_TX_TXBIT_COUNT_SHIFT			17
+#define TEGRA_CEC_HW_DEBUG_TX_STATE_SHIFT			21
+#define TEGRA_CEC_HW_DEBUG_TX_FORCELOOUT			(1 << 25)
+#define TEGRA_CEC_HW_DEBUG_TX_TXDATABIT_SAMPLE_TIMER		(1 << 26)
+
+#endif /* TEGRA_CEC_H */
-- 
2.14.1
