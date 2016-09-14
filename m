Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:33638 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756146AbcINLY0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Sep 2016 07:24:26 -0400
Received: by mail-wm0-f45.google.com with SMTP id b187so5726233wme.0
        for <linux-media@vger.kernel.org>; Wed, 14 Sep 2016 04:24:25 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org
Cc: kernel@stlinux.com, arnd@arndb.de, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 2/4] add stih-cec driver
Date: Wed, 14 Sep 2016 13:24:07 +0200
Message-Id: <1473852249-15960-3-git-send-email-benjamin.gaignard@linaro.org>
In-Reply-To: <1473852249-15960-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1473852249-15960-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implement CEC driver for stih4xx platform.
Driver compliance has been test with cec-ctl and
cec-compliance tools.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
---
 drivers/staging/media/Kconfig           |   2 +
 drivers/staging/media/Makefile          |   1 +
 drivers/staging/media/st-cec/Kconfig    |   8 +
 drivers/staging/media/st-cec/Makefile   |   1 +
 drivers/staging/media/st-cec/stih-cec.c | 382 ++++++++++++++++++++++++++++++++
 5 files changed, 394 insertions(+)
 create mode 100644 drivers/staging/media/st-cec/Kconfig
 create mode 100644 drivers/staging/media/st-cec/Makefile
 create mode 100644 drivers/staging/media/st-cec/stih-cec.c

diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index 7292f23..699719b 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -38,4 +38,6 @@ source "drivers/staging/media/s5p-cec/Kconfig"
 # Keep LIRC at the end, as it has sub-menus
 source "drivers/staging/media/lirc/Kconfig"
 
+source "drivers/staging/media/st-cec/Kconfig"
+
 endif
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 87ce8ad..03cf58c 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
 obj-$(CONFIG_USB_PULSE8_CEC)    += pulse8-cec/
 obj-$(CONFIG_VIDEO_TW686X_KH)	+= tw686x-kh/
+obj-$(CONFIG_VIDEO_STIH_CEC)	+= st-cec/
diff --git a/drivers/staging/media/st-cec/Kconfig b/drivers/staging/media/st-cec/Kconfig
new file mode 100644
index 0000000..c9a8328
--- /dev/null
+++ b/drivers/staging/media/st-cec/Kconfig
@@ -0,0 +1,8 @@
+config VIDEO_STIH_CEC
+       tristate "STIH4xx CEC driver"
+       depends on VIDEO_DEV && MEDIA_CEC && (ARCH_STI || COMPILE_TEST)
+       ---help---
+         This is a driver for STIH4xx HDMI CEC interface. It uses the
+         generic CEC framework interface.
+         CEC bus is present in the HDMI connector and enables communication
+         between compatible devices.
diff --git a/drivers/staging/media/st-cec/Makefile b/drivers/staging/media/st-cec/Makefile
new file mode 100644
index 0000000..375ea24
--- /dev/null
+++ b/drivers/staging/media/st-cec/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_STIH_CEC) += stih-cec.o
diff --git a/drivers/staging/media/st-cec/stih-cec.c b/drivers/staging/media/st-cec/stih-cec.c
new file mode 100644
index 0000000..1c41ad2
--- /dev/null
+++ b/drivers/staging/media/st-cec/stih-cec.c
@@ -0,0 +1,382 @@
+/*
+ * drivers/staging/media/st-cec/stih-cec.c
+ *
+ * STIH4xx CEC driver
+ * Copyright (C) STMicroelectronic SA 2016
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/version.h>
+
+#include <media/cec.h>
+
+#define CEC_NAME	"stih-cec"
+
+/* CEC registers  */
+#define CEC_CLK_DIV           0x0
+#define CEC_CTRL              0x4
+#define CEC_IRQ_CTRL          0x8
+#define CEC_STATUS            0xC
+#define CEC_EXT_STATUS        0x10
+#define CEC_TX_CTRL           0x14
+#define CEC_FREE_TIME_THRESH  0x18
+#define CEC_BIT_TOUT_THRESH   0x1C
+#define CEC_BIT_PULSE_THRESH  0x20
+#define CEC_DATA              0x24
+#define CEC_TX_ARRAY_CTRL     0x28
+#define CEC_CTRL2             0x2C
+#define CEC_TX_ERROR_STS      0x30
+#define CEC_ADDR_TABLE        0x34
+#define CEC_DATA_ARRAY_CTRL   0x38
+#define CEC_DATA_ARRAY_STATUS 0x3C
+#define CEC_TX_DATA_BASE      0x40
+#define CEC_TX_DATA_TOP       0x50
+#define CEC_TX_DATA_SIZE      0x1
+#define CEC_RX_DATA_BASE      0x54
+#define CEC_RX_DATA_TOP       0x64
+#define CEC_RX_DATA_SIZE      0x1
+
+/* CEC_CTRL2 */
+#define CEC_LINE_INACTIVE_EN   BIT(0)
+#define CEC_AUTO_BUS_ERR_EN    BIT(1)
+#define CEC_STOP_ON_ARB_ERR_EN BIT(2)
+#define CEC_TX_REQ_WAIT_EN     BIT(3)
+
+/* CEC_DATA_ARRAY_CTRL */
+#define CEC_TX_ARRAY_EN          BIT(0)
+#define CEC_RX_ARRAY_EN          BIT(1)
+#define CEC_TX_ARRAY_RESET       BIT(2)
+#define CEC_RX_ARRAY_RESET       BIT(3)
+#define CEC_TX_N_OF_BYTES_IRQ_EN BIT(4)
+#define CEC_TX_STOP_ON_NACK      BIT(7)
+
+/* CEC_TX_ARRAY_CTRL */
+#define CEC_TX_N_OF_BYTES  0x1F
+#define CEC_TX_START       BIT(5)
+#define CEC_TX_AUTO_SOM_EN BIT(6)
+#define CEC_TX_AUTO_EOM_EN BIT(7)
+
+/* CEC_IRQ_CTRL */
+#define CEC_TX_DONE_IRQ_EN   BIT(0)
+#define CEC_ERROR_IRQ_EN     BIT(2)
+#define CEC_RX_DONE_IRQ_EN   BIT(3)
+#define CEC_RX_SOM_IRQ_EN    BIT(4)
+#define CEC_RX_EOM_IRQ_EN    BIT(5)
+#define CEC_FREE_TIME_IRQ_EN BIT(6)
+#define CEC_PIN_STS_IRQ_EN   BIT(7)
+
+/* CEC_CTRL */
+#define CEC_IN_FILTER_EN    BIT(0)
+#define CEC_PWR_SAVE_EN     BIT(1)
+#define CEC_EN              BIT(4)
+#define CEC_ACK_CTRL        BIT(5)
+#define CEC_RX_RESET_EN     BIT(6)
+#define CEC_IGNORE_RX_ERROR BIT(7)
+
+/* CEC_STATUS */
+#define CEC_TX_DONE_STS       BIT(0)
+#define CEC_TX_ACK_GET_STS    BIT(1)
+#define CEC_ERROR_STS         BIT(2)
+#define CEC_RX_DONE_STS       BIT(3)
+#define CEC_RX_SOM_STS        BIT(4)
+#define CEC_RX_EOM_STS        BIT(5)
+#define CEC_FREE_TIME_IRQ_STS BIT(6)
+#define CEC_PIN_STS           BIT(7)
+#define CEC_SBIT_TOUT_STS     BIT(8)
+#define CEC_DBIT_TOUT_STS     BIT(9)
+#define CEC_LPULSE_ERROR_STS  BIT(10)
+#define CEC_HPULSE_ERROR_STS  BIT(11)
+#define CEC_TX_ERROR          BIT(12)
+#define CEC_TX_ARB_ERROR      BIT(13)
+#define CEC_RX_ERROR_MIN      BIT(14)
+#define CEC_RX_ERROR_MAX      BIT(15)
+
+/* Signal free time in bit periods (2.4ms) */
+#define CEC_PRESENT_INIT_SFT 7
+#define CEC_NEW_INIT_SFT     5
+#define CEC_RETRANSMIT_SFT   3
+
+/* Constants for CEC_BIT_TOUT_THRESH register */
+#define CEC_SBIT_TOUT_47MS BIT(1)
+#define CEC_SBIT_TOUT_48MS BIT(0) | BIT(1)
+#define CEC_SBIT_TOUT_50MS BIT(2)
+#define CEC_DBIT_TOUT_27MS BIT(0)
+#define CEC_DBIT_TOUT_28MS BIT(1)
+#define CEC_DBIT_TOUT_29MS BIT(0) | BIT(1)
+
+/* Constants for CEC_BIT_PULSE_THRESH register */
+#define CEC_BIT_LPULSE_03MS BIT(1)
+#define CEC_BIT_HPULSE_03MS BIT(3)
+
+/* Constants for CEC_DATA_ARRAY_STATUS register */
+#define CEC_RX_N_OF_BYTES                     0x1F
+#define CEC_TX_N_OF_BYTES_SENT                BIT(5)
+#define CEC_RX_OVERRUN                        BIT(6)
+
+struct stih_cec {
+	struct cec_adapter	*adap;
+	struct device		*dev;
+	struct clk		*clk;
+	void __iomem		*regs;
+	int			irq;
+	u32			irq_status;
+	struct cec_msg		rx_msg;
+};
+
+static int stih_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct stih_cec *cec = adap->priv;
+
+	if (enable) {
+		/* The doc says (input TCLK_PERIOD * CEC_CLK_DIV) = 0.1ms */
+		unsigned long clk_freq = clk_get_rate(cec->clk);
+		u32 cec_clk_div = clk_freq / 10000;
+
+		writel(cec_clk_div, cec->regs + CEC_CLK_DIV);
+
+		/* Configuration of the durations activating a timeout */
+		writel(CEC_SBIT_TOUT_47MS | (CEC_DBIT_TOUT_28MS << 4),
+		       cec->regs + CEC_BIT_TOUT_THRESH);
+
+		/* Configuration of the smallest allowed duration for pulses */
+		writel(CEC_BIT_LPULSE_03MS | CEC_BIT_HPULSE_03MS,
+		       cec->regs + CEC_BIT_PULSE_THRESH);
+
+		/* Minimum received bit period threshold */
+		writel(BIT(5) | BIT(7), cec->regs + CEC_TX_CTRL);
+
+		/* Configuration of transceiver data arrays */
+		writel(CEC_TX_ARRAY_EN | CEC_RX_ARRAY_EN | CEC_TX_STOP_ON_NACK,
+		       cec->regs + CEC_DATA_ARRAY_CTRL);
+
+		/* Configuration of the control bits for CEC Transceiver */
+		writel(CEC_IN_FILTER_EN | CEC_EN | CEC_RX_RESET_EN,
+		       cec->regs + CEC_CTRL);
+
+		/* Clear logical addresses */
+		writel(0, cec->regs + CEC_ADDR_TABLE);
+
+		/* Clear the status register */
+		writel(0x0, cec->regs + CEC_STATUS);
+
+		/* Enable the interrupts */
+		writel(CEC_TX_DONE_IRQ_EN | CEC_RX_DONE_IRQ_EN |
+		       CEC_RX_SOM_IRQ_EN | CEC_RX_EOM_IRQ_EN |
+		       CEC_ERROR_IRQ_EN,
+		       cec->regs + CEC_IRQ_CTRL);
+
+	} else {
+		/* Clear logical addresses */
+		writel(0, cec->regs + CEC_ADDR_TABLE);
+
+		/* Clear the status register */
+		writel(0x0, cec->regs + CEC_STATUS);
+
+		/* Disable the interrupts */
+		writel(0, cec->regs + CEC_IRQ_CTRL);
+	}
+
+	return 0;
+}
+
+static int stih_cec_adap_log_addr(struct cec_adapter *adap, u8 logical_addr)
+{
+	struct stih_cec *cec = adap->priv;
+	u32 reg = readl(cec->regs + CEC_ADDR_TABLE);
+
+	reg |= 1 << logical_addr;
+
+	if (logical_addr == CEC_LOG_ADDR_INVALID)
+		reg = 0;
+
+	writel(reg, cec->regs + CEC_ADDR_TABLE);
+
+	return 0;
+}
+
+static int stih_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				  u32 signal_free_time, struct cec_msg *msg)
+{
+	struct stih_cec *cec = adap->priv;
+	int i;
+
+	/* Copy message into registers */
+	for (i = 0; i < msg->len; i++)
+		writeb(msg->msg[i], cec->regs + CEC_TX_DATA_BASE + i);
+
+	/* Start transmission, configure hardware to add start and stop bits
+	 * Signal free time is handled by the hardware
+	 */
+	writel(CEC_TX_AUTO_SOM_EN | CEC_TX_AUTO_EOM_EN | CEC_TX_START |
+	       msg->len, cec->regs + CEC_TX_ARRAY_CTRL);
+
+	return 0;
+}
+
+static void stih_tx_done(struct stih_cec *cec, u32 status)
+{
+	if (status & CEC_TX_ERROR) {
+		cec_transmit_done(cec->adap, CEC_TX_STATUS_ERROR, 0, 0, 0, 1);
+		return;
+	}
+
+	if (status & CEC_TX_ARB_ERROR) {
+		cec_transmit_done(cec->adap,
+				  CEC_TX_STATUS_ARB_LOST, 1, 0, 0, 0);
+		return;
+	}
+
+	if (!(status & CEC_TX_ACK_GET_STS)) {
+		cec_transmit_done(cec->adap, CEC_TX_STATUS_NACK, 0, 1, 0, 0);
+		return;
+	}
+
+	cec_transmit_done(cec->adap, CEC_TX_STATUS_OK, 0, 0, 0, 0);
+}
+
+static void stih_rx_done(struct stih_cec *cec, u32 status)
+{
+	struct cec_msg *msg = &cec->rx_msg;
+	u8 i;
+
+	if (status & CEC_RX_ERROR_MIN)
+		return;
+
+	if (status & CEC_RX_ERROR_MAX)
+		return;
+
+	memset(msg, 0x00, sizeof(*msg));
+	msg->len = readl(cec->regs + CEC_DATA_ARRAY_STATUS) & 0x1f;
+
+	if (!msg-len)
+		return;
+
+	if (msg->len > 16)
+		msg->len = 16;
+
+	for (i = 0; i < msg->len; i++)
+		msg->msg[i] = readl(cec->regs + CEC_RX_DATA_BASE + i);
+
+	cec_received_msg(cec->adap, msg);
+}
+
+static irqreturn_t stih_cec_irq_handler_thread(int irq, void *priv)
+{
+	struct stih_cec *cec = priv;
+
+	if (cec->irq_status & CEC_TX_DONE_STS)
+		stih_tx_done(cec, cec->irq_status);
+
+	if (cec->irq_status & CEC_RX_DONE_STS)
+		stih_rx_done(cec, cec->irq_status);
+
+	cec->irq_status = 0;
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t stih_cec_irq_handler(int irq, void *priv)
+{
+	struct stih_cec *cec = priv;
+
+	cec->irq_status = readl(cec->regs + CEC_STATUS);
+	writel(cec->irq_status, cec->regs + CEC_STATUS);
+
+	return IRQ_WAKE_THREAD;
+}
+
+static const struct cec_adap_ops sti_cec_adap_ops = {
+	.adap_enable = stih_cec_adap_enable,
+	.adap_log_addr = stih_cec_adap_log_addr,
+	.adap_transmit = stih_cec_adap_transmit,
+};
+
+static int stih_cec_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct stih_cec *cec;
+	int ret;
+
+	cec = devm_kzalloc(dev, sizeof(*cec), GFP_KERNEL);
+	if (!cec)
+		return -ENOMEM;
+
+	cec->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	cec->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(cec->regs))
+		return PTR_ERR(cec->regs);
+
+	cec->irq = platform_get_irq(pdev, 0);
+	if (cec->irq < 0)
+		return cec->irq;
+
+	ret = devm_request_threaded_irq(dev, cec->irq, stih_cec_irq_handler,
+					stih_cec_irq_handler_thread, 0,
+					pdev->name, cec);
+	if (ret)
+		return ret;
+
+	cec->clk = devm_clk_get(dev, "cec-clk");
+	if (IS_ERR(cec->clk)) {
+		dev_err(dev, "Cannot get cec clock\n");
+		return PTR_ERR(cec->clk);
+	}
+
+	cec->adap = cec_allocate_adapter(&sti_cec_adap_ops, cec,
+			CEC_NAME,
+			CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
+			CEC_CAP_PHYS_ADDR | CEC_CAP_TRANSMIT,
+			1, &pdev->dev);
+	ret = PTR_ERR_OR_ZERO(cec->adap);
+	if (ret)
+		return ret;
+
+	ret = cec_register_adapter(cec->adap);
+	if (ret) {
+		cec_delete_adapter(cec->adap);
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, cec);
+	return 0;
+}
+
+static int stih_cec_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct of_device_id stih_cec_match[] = {
+	{
+		.compatible	= "st,stih-cec",
+	},
+	{},
+};
+
+static struct platform_driver stih_cec_pdrv = {
+	.probe	= stih_cec_probe,
+	.remove = stih_cec_remove,
+	.driver = {
+		.name		= CEC_NAME,
+		.of_match_table	= stih_cec_match,
+	},
+};
+
+module_platform_driver(stih_cec_pdrv);
+
+MODULE_AUTHOR("Benjamin Gaignard <benjamin.gaignard@linaro.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("STIH4xx CEC driver");
-- 
1.9.1

