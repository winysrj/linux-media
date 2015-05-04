Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:58576 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbbEDRev (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 13:34:51 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: [PATCH v6 11/11] cec: s5p-cec: Add s5p-cec driver
Date: Mon, 04 May 2015 19:33:04 +0200
Message-id: <1430760785-1169-12-git-send-email-k.debski@samsung.com>
In-reply-to: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add CEC interface driver present in the Samsung Exynos range of
SoCs.

The following files were based on work by SangPil Moon:
- exynos_hdmi_cec.h
- exynos_hdmi_cecctl.c

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 .../devicetree/bindings/media/s5p-cec.txt          |   33 +++
 drivers/media/platform/Kconfig                     |   10 +
 drivers/media/platform/Makefile                    |    1 +
 drivers/media/platform/s5p-cec/Makefile            |    4 +
 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h   |   37 +++
 .../media/platform/s5p-cec/exynos_hdmi_cecctrl.c   |  208 ++++++++++++++
 drivers/media/platform/s5p-cec/regs-cec.h          |   96 +++++++
 drivers/media/platform/s5p-cec/s5p_cec.c           |  283 ++++++++++++++++++++
 drivers/media/platform/s5p-cec/s5p_cec.h           |   76 ++++++
 9 files changed, 748 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/s5p-cec.txt
 create mode 100644 drivers/media/platform/s5p-cec/Makefile
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
 create mode 100644 drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
 create mode 100644 drivers/media/platform/s5p-cec/regs-cec.h
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.c
 create mode 100644 drivers/media/platform/s5p-cec/s5p_cec.h

diff --git a/Documentation/devicetree/bindings/media/s5p-cec.txt b/Documentation/devicetree/bindings/media/s5p-cec.txt
new file mode 100644
index 0000000..97ca664
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/s5p-cec.txt
@@ -0,0 +1,33 @@
+* Samsung HDMI CEC driver
+
+The HDMI CEC module is present is Samsung SoCs and its purpose is to
+handle communication between HDMI connected devices over the CEC bus.
+
+Required properties:
+  - compatible : value should be follwoing
+	"samsung,s5p-cec"
+
+  - reg : Physical base address of the IP registers and length of memory
+	  mapped region.
+
+  - interrupts : HDMI CEC interrupt number to the CPU.
+  - clocks : from common clock binding: handle to HDMI CEC clock.
+  - clock-names : from common clock binding: must contain "hdmicec",
+		  corresponding to entry in the clocks property.
+  - samsung,syscon-phandle - phandle to the PMU system controller
+
+Example:
+
+hdmicec: cec@100B0000 {
+	compatible = "samsung,s5p-cec";
+	reg = <0x100B0000 0x200>;
+	interrupts = <0 114 0>;
+	clocks = <&clock CLK_HDMI_CEC>;
+	clock-names = "hdmicec";
+	samsung,syscon-phandle = <&pmu_system_controller>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&hdmi_cec>;
+	status = "okay";
+};
+
+
diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 421f531..203bc06 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -157,6 +157,16 @@ config VIDEO_MEM2MEM_DEINTERLACE
 	help
 	    Generic deinterlacing V4L2 driver.
 
+config VIDEO_SAMSUNG_S5P_CEC
+	tristate "Samsung S5P CEC driver"
+	depends on CEC && VIDEO_DEV && VIDEO_V4L2 && (PLAT_S5P || ARCH_EXYNOS)
+	default n
+	---help---
+	  This is a driver for Samsung S5P HDMI CEC interface. It uses the
+	  generic CEC framework interface.
+	  CEC bus is present in the HDMI connector and enables communication
+	  between compatible devices.
+
 config VIDEO_SAMSUNG_S5P_G2D
 	tristate "Samsung S5P and EXYNOS4 G2D 2d graphics accelerator driver"
 	depends on VIDEO_DEV && VIDEO_V4L2
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 8f85561..f96c9a3 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_VIDEO_MEM2MEM_DEINTERLACE)	+= m2m-deinterlace.o
 
 obj-$(CONFIG_VIDEO_S3C_CAMIF) 		+= s3c-camif/
 obj-$(CONFIG_VIDEO_SAMSUNG_EXYNOS4_IS) 	+= exynos4-is/
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC)	+= s5p-cec/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_JPEG)	+= s5p-jpeg/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MFC)	+= s5p-mfc/
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
diff --git a/drivers/media/platform/s5p-cec/Makefile b/drivers/media/platform/s5p-cec/Makefile
new file mode 100644
index 0000000..7f84226
--- /dev/null
+++ b/drivers/media/platform/s5p-cec/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_CEC)	+= s5p-cec.o
+s5p-cec-y += s5p_cec.o exynos_hdmi_cecctrl.o
+
+
diff --git a/drivers/media/platform/s5p-cec/exynos_hdmi_cec.h b/drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
new file mode 100644
index 0000000..d008695
--- /dev/null
+++ b/drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
@@ -0,0 +1,37 @@
+/* drivers/media/platform/s5p-cec/exynos_hdmi_cec.h
+ *
+ * Copyright (c) 2010, 2014 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * Header file for interface of Samsung Exynos hdmi cec hardware
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _EXYNOS_HDMI_CEC_H_
+#define _EXYNOS_HDMI_CEC_H_ __FILE__
+
+#include <linux/regmap.h>
+#include <linux/miscdevice.h>
+#include "s5p_cec.h"
+
+void s5p_cec_set_divider(struct s5p_cec_dev *cec);
+void s5p_cec_enable_rx(struct s5p_cec_dev *cec);
+void s5p_cec_mask_rx_interrupts(struct s5p_cec_dev *cec);
+void s5p_cec_unmask_rx_interrupts(struct s5p_cec_dev *cec);
+void s5p_cec_mask_tx_interrupts(struct s5p_cec_dev *cec);
+void s5p_cec_unmask_tx_interrupts(struct s5p_cec_dev *cec);
+void s5p_cec_reset(struct s5p_cec_dev *cec);
+void s5p_cec_tx_reset(struct s5p_cec_dev *cec);
+void s5p_cec_rx_reset(struct s5p_cec_dev *cec);
+void s5p_cec_threshold(struct s5p_cec_dev *cec);
+void s5p_cec_copy_packet(struct s5p_cec_dev *cec, char *data, size_t count);
+void s5p_cec_set_addr(struct s5p_cec_dev *cec, u32 addr);
+u32 s5p_cec_get_status(struct s5p_cec_dev *cec);
+void s5p_clr_pending_tx(struct s5p_cec_dev *cec);
+void s5p_clr_pending_rx(struct s5p_cec_dev *cec);
+void s5p_cec_get_rx_buf(struct s5p_cec_dev *cec, u32 size, u8 *buffer);
+
+#endif /* _EXYNOS_HDMI_CEC_H_ */
diff --git a/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c b/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
new file mode 100644
index 0000000..134e50b
--- /dev/null
+++ b/drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
@@ -0,0 +1,208 @@
+/* drivers/media/platform/s5p-cec/exynos_hdmi_cecctrl.c
+ *
+ * Copyright (c) 2009, 2014 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ * cec ftn file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/io.h>
+#include <linux/device.h>
+
+#include "exynos_hdmi_cec.h"
+#include "regs-cec.h"
+
+#define S5P_HDMI_FIN			24000000
+#define CEC_DIV_RATIO			320000
+
+#define CEC_MESSAGE_BROADCAST_MASK	0x0F
+#define CEC_MESSAGE_BROADCAST		0x0F
+#define CEC_FILTER_THRESHOLD		0x15
+
+void s5p_cec_set_divider(struct s5p_cec_dev *cec)
+{
+	u32 div_ratio, div_val;
+	unsigned int reg;
+
+	div_ratio  = S5P_HDMI_FIN / CEC_DIV_RATIO - 1;
+
+	if (regmap_read(cec->pmu, EXYNOS_HDMI_PHY_CONTROL, &reg)) {
+		dev_err(cec->dev, "failed to read phy control\n");
+		return;
+	}
+
+	reg = (reg & ~(0x3FF << 16)) | (div_ratio << 16);
+
+	if (regmap_write(cec->pmu, EXYNOS_HDMI_PHY_CONTROL, reg)) {
+		dev_err(cec->dev, "failed to write phy control\n");
+		return;
+	}
+
+	div_val = CEC_DIV_RATIO * 0.00005 - 1;
+
+	writeb(0x0, cec->reg + S5P_CEC_DIVISOR_3);
+	writeb(0x0, cec->reg + S5P_CEC_DIVISOR_2);
+	writeb(0x0, cec->reg + S5P_CEC_DIVISOR_1);
+	writeb(div_val, cec->reg + S5P_CEC_DIVISOR_0);
+}
+
+void s5p_cec_enable_rx(struct s5p_cec_dev *cec)
+{
+	u8 reg;
+
+	reg = readb(cec->reg + S5P_CEC_RX_CTRL);
+	reg |= S5P_CEC_RX_CTRL_ENABLE;
+	writeb(reg, cec->reg + S5P_CEC_RX_CTRL);
+}
+
+void s5p_cec_mask_rx_interrupts(struct s5p_cec_dev *cec)
+{
+	u8 reg;
+
+	reg = readb(cec->reg + S5P_CEC_IRQ_MASK);
+	reg |= S5P_CEC_IRQ_RX_DONE;
+	reg |= S5P_CEC_IRQ_RX_ERROR;
+	writeb(reg, cec->reg + S5P_CEC_IRQ_MASK);
+}
+
+void s5p_cec_unmask_rx_interrupts(struct s5p_cec_dev *cec)
+{
+	u8 reg;
+
+	reg = readb(cec->reg + S5P_CEC_IRQ_MASK);
+	reg &= ~S5P_CEC_IRQ_RX_DONE;
+	reg &= ~S5P_CEC_IRQ_RX_ERROR;
+	writeb(reg, cec->reg + S5P_CEC_IRQ_MASK);
+}
+
+void s5p_cec_mask_tx_interrupts(struct s5p_cec_dev *cec)
+{
+	u8 reg;
+
+	reg = readb(cec->reg + S5P_CEC_IRQ_MASK);
+	reg |= S5P_CEC_IRQ_TX_DONE;
+	reg |= S5P_CEC_IRQ_TX_ERROR;
+	writeb(reg, cec->reg + S5P_CEC_IRQ_MASK);
+
+}
+
+void s5p_cec_unmask_tx_interrupts(struct s5p_cec_dev *cec)
+{
+	u8 reg;
+
+	reg = readb(cec->reg + S5P_CEC_IRQ_MASK);
+	reg &= ~S5P_CEC_IRQ_TX_DONE;
+	reg &= ~S5P_CEC_IRQ_TX_ERROR;
+	writeb(reg, cec->reg + S5P_CEC_IRQ_MASK);
+}
+
+void s5p_cec_reset(struct s5p_cec_dev *cec)
+{
+	u8 reg;
+
+	writeb(S5P_CEC_RX_CTRL_RESET, cec->reg + S5P_CEC_RX_CTRL);
+	writeb(S5P_CEC_TX_CTRL_RESET, cec->reg + S5P_CEC_TX_CTRL);
+
+	reg = readb(cec->reg + 0xc4);
+	reg &= ~0x1;
+	writeb(reg, cec->reg + 0xc4);
+}
+
+void s5p_cec_tx_reset(struct s5p_cec_dev *cec)
+{
+	writeb(S5P_CEC_TX_CTRL_RESET, cec->reg + S5P_CEC_TX_CTRL);
+}
+
+void s5p_cec_rx_reset(struct s5p_cec_dev *cec)
+{
+	u8 reg;
+
+	writeb(S5P_CEC_RX_CTRL_RESET, cec->reg + S5P_CEC_RX_CTRL);
+
+	reg = readb(cec->reg + 0xc4);
+	reg &= ~0x1;
+	writeb(reg, cec->reg + 0xc4);
+}
+
+void s5p_cec_threshold(struct s5p_cec_dev *cec)
+{
+	writeb(CEC_FILTER_THRESHOLD, cec->reg + S5P_CEC_RX_FILTER_TH);
+	writeb(0, cec->reg + S5P_CEC_RX_FILTER_CTRL);
+}
+
+void s5p_cec_copy_packet(struct s5p_cec_dev *cec, char *data, size_t count)
+{
+	char debug[40];
+	int i = 0;
+	u8 reg;
+
+	while (i < count) {
+		writeb(data[i], cec->reg + (S5P_CEC_TX_BUFF0 + (i * 4)));
+		sprintf(debug + i * 2, "%02x ", data[i]);
+		i++;
+	}
+
+	writeb(count, cec->reg + S5P_CEC_TX_BYTES);
+	reg = readb(cec->reg + S5P_CEC_TX_CTRL);
+	reg |= S5P_CEC_TX_CTRL_START;
+
+	if ((data[0] & CEC_MESSAGE_BROADCAST_MASK) == CEC_MESSAGE_BROADCAST) {
+		dev_dbg(cec->dev, "Broadcast");
+		reg |= S5P_CEC_TX_CTRL_BCAST;
+	} else {
+		dev_dbg(cec->dev, "No Broadcast");
+		reg &= ~S5P_CEC_TX_CTRL_BCAST;
+	}
+
+	reg |= 0x50;
+	writeb(reg, cec->reg + S5P_CEC_TX_CTRL);
+	dev_dbg(cec->dev, "cec-tx: cec count(%d): %s", count, debug);
+}
+
+void s5p_cec_set_addr(struct s5p_cec_dev *cec, u32 addr)
+{
+	writeb(addr & 0x0F, cec->reg + S5P_CEC_LOGIC_ADDR);
+}
+
+u32 s5p_cec_get_status(struct s5p_cec_dev *cec)
+{
+	u32 status = 0;
+
+	status = readb(cec->reg + S5P_CEC_STATUS_0);
+	status |= readb(cec->reg + S5P_CEC_STATUS_1) << 8;
+	status |= readb(cec->reg + S5P_CEC_STATUS_2) << 16;
+	status |= readb(cec->reg + S5P_CEC_STATUS_3) << 24;
+
+	dev_dbg(cec->dev, "status = 0x%x!\n", status);
+
+	return status;
+}
+
+void s5p_clr_pending_tx(struct s5p_cec_dev *cec)
+{
+	writeb(S5P_CEC_IRQ_TX_DONE | S5P_CEC_IRQ_TX_ERROR,
+					cec->reg + S5P_CEC_IRQ_CLEAR);
+}
+
+void s5p_clr_pending_rx(struct s5p_cec_dev *cec)
+{
+	writeb(S5P_CEC_IRQ_RX_DONE | S5P_CEC_IRQ_RX_ERROR,
+					cec->reg + S5P_CEC_IRQ_CLEAR);
+}
+
+void s5p_cec_get_rx_buf(struct s5p_cec_dev *cec, u32 size, u8 *buffer)
+{
+	u32 i = 0;
+	char debug[40];
+
+	while (i < size) {
+		buffer[i] = readb(cec->reg + S5P_CEC_RX_BUFF0 + (i * 4));
+		sprintf(debug + i * 2, "%02x ", buffer[i]);
+		i++;
+	}
+	dev_dbg(cec->dev, "cec-rx: cec size(%d): %s", size, debug);
+}
diff --git a/drivers/media/platform/s5p-cec/regs-cec.h b/drivers/media/platform/s5p-cec/regs-cec.h
new file mode 100644
index 0000000..b2e7e12
--- /dev/null
+++ b/drivers/media/platform/s5p-cec/regs-cec.h
@@ -0,0 +1,96 @@
+/* drivers/media/platform/s5p-cec/regs-cec.h
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *		http://www.samsung.com/
+ *
+ *  register header file for Samsung TVOUT driver
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __EXYNOS_REGS__H
+#define __EXYNOS_REGS__H
+
+/*
+ * Register part
+ */
+#define S5P_CEC_STATUS_0			(0x0000)
+#define S5P_CEC_STATUS_1			(0x0004)
+#define S5P_CEC_STATUS_2			(0x0008)
+#define S5P_CEC_STATUS_3			(0x000C)
+#define S5P_CEC_IRQ_MASK			(0x0010)
+#define S5P_CEC_IRQ_CLEAR			(0x0014)
+#define S5P_CEC_LOGIC_ADDR			(0x0020)
+#define S5P_CEC_DIVISOR_0			(0x0030)
+#define S5P_CEC_DIVISOR_1			(0x0034)
+#define S5P_CEC_DIVISOR_2			(0x0038)
+#define S5P_CEC_DIVISOR_3			(0x003C)
+
+#define S5P_CEC_TX_CTRL				(0x0040)
+#define S5P_CEC_TX_BYTES			(0x0044)
+#define S5P_CEC_TX_STAT0			(0x0060)
+#define S5P_CEC_TX_STAT1			(0x0064)
+#define S5P_CEC_TX_BUFF0			(0x0080)
+#define S5P_CEC_TX_BUFF1			(0x0084)
+#define S5P_CEC_TX_BUFF2			(0x0088)
+#define S5P_CEC_TX_BUFF3			(0x008C)
+#define S5P_CEC_TX_BUFF4			(0x0090)
+#define S5P_CEC_TX_BUFF5			(0x0094)
+#define S5P_CEC_TX_BUFF6			(0x0098)
+#define S5P_CEC_TX_BUFF7			(0x009C)
+#define S5P_CEC_TX_BUFF8			(0x00A0)
+#define S5P_CEC_TX_BUFF9			(0x00A4)
+#define S5P_CEC_TX_BUFF10			(0x00A8)
+#define S5P_CEC_TX_BUFF11			(0x00AC)
+#define S5P_CEC_TX_BUFF12			(0x00B0)
+#define S5P_CEC_TX_BUFF13			(0x00B4)
+#define S5P_CEC_TX_BUFF14			(0x00B8)
+#define S5P_CEC_TX_BUFF15			(0x00BC)
+
+#define S5P_CEC_RX_CTRL				(0x00C0)
+#define S5P_CEC_RX_STAT0			(0x00E0)
+#define S5P_CEC_RX_STAT1			(0x00E4)
+#define S5P_CEC_RX_BUFF0			(0x0100)
+#define S5P_CEC_RX_BUFF1			(0x0104)
+#define S5P_CEC_RX_BUFF2			(0x0108)
+#define S5P_CEC_RX_BUFF3			(0x010C)
+#define S5P_CEC_RX_BUFF4			(0x0110)
+#define S5P_CEC_RX_BUFF5			(0x0114)
+#define S5P_CEC_RX_BUFF6			(0x0118)
+#define S5P_CEC_RX_BUFF7			(0x011C)
+#define S5P_CEC_RX_BUFF8			(0x0120)
+#define S5P_CEC_RX_BUFF9			(0x0124)
+#define S5P_CEC_RX_BUFF10			(0x0128)
+#define S5P_CEC_RX_BUFF11			(0x012C)
+#define S5P_CEC_RX_BUFF12			(0x0130)
+#define S5P_CEC_RX_BUFF13			(0x0134)
+#define S5P_CEC_RX_BUFF14			(0x0138)
+#define S5P_CEC_RX_BUFF15			(0x013C)
+
+#define S5P_CEC_RX_FILTER_CTRL			(0x0180)
+#define S5P_CEC_RX_FILTER_TH			(0x0184)
+
+/*
+ * Bit definition part
+ */
+#define S5P_CEC_IRQ_TX_DONE			(1<<0)
+#define S5P_CEC_IRQ_TX_ERROR			(1<<1)
+#define S5P_CEC_IRQ_RX_DONE			(1<<4)
+#define S5P_CEC_IRQ_RX_ERROR			(1<<5)
+
+#define S5P_CEC_TX_CTRL_START			(1<<0)
+#define S5P_CEC_TX_CTRL_BCAST			(1<<1)
+#define S5P_CEC_TX_CTRL_RETRY			(0x04<<4)
+#define S5P_CEC_TX_CTRL_RESET			(1<<7)
+
+#define S5P_CEC_RX_CTRL_ENABLE			(1<<0)
+#define S5P_CEC_RX_CTRL_RESET			(1<<7)
+
+#define S5P_CEC_LOGIC_ADDR_MASK			(0xF)
+
+/* PMU Registers for PHY */
+#define EXYNOS_HDMI_PHY_CONTROL			0x700
+
+#endif	/* __EXYNOS_REGS__H	*/
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
new file mode 100644
index 0000000..a3dbcdb
--- /dev/null
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -0,0 +1,283 @@
+/* drivers/media/platform/s5p-cec/s5p_cec.c
+ *
+ * Samsung S5P CEC driver
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This driver is based on the "cec interface driver for exynos soc" by
+ * SangPil Moon.
+ */
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/timer.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
+#include <media/cec.h>
+
+#include "exynos_hdmi_cec.h"
+#include "regs-cec.h"
+#include "s5p_cec.h"
+
+#define CEC_NAME	"s5p-cec"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-2)");
+
+static int s5p_cec_enable(struct cec_adapter *adap, bool enable)
+{
+	struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev, adap);
+	int ret;
+
+	if (enable) {
+		ret = pm_runtime_get_sync(cec->dev);
+
+		adap->phys_addr = 0x100b;
+		s5p_cec_reset(cec);
+
+		s5p_cec_set_divider(cec);
+		s5p_cec_threshold(cec);
+
+		s5p_cec_unmask_tx_interrupts(cec);
+		s5p_cec_unmask_rx_interrupts(cec);
+		s5p_cec_enable_rx(cec);
+	} else {
+		s5p_cec_mask_tx_interrupts(cec);
+		s5p_cec_mask_rx_interrupts(cec);
+		pm_runtime_disable(cec->dev);
+	}
+
+	return 0;
+}
+
+static int s5p_cec_log_addr(struct cec_adapter *adap, u8 addr)
+{
+	struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev, adap);
+
+	s5p_cec_set_addr(cec, addr);
+	return 0;
+}
+
+static int s5p_cec_trasmit(struct cec_adapter *adap, struct cec_msg *msg)
+{
+	struct s5p_cec_dev *cec = container_of(adap, struct s5p_cec_dev, adap);
+
+	s5p_cec_copy_packet(cec, msg->msg, msg->len);
+	return 0;
+}
+
+static void s5p_cec_transmit_timed_out(struct cec_adapter *adap)
+{
+
+}
+
+static irqreturn_t s5p_cec_irq_handler(int irq, void *priv)
+{
+	struct s5p_cec_dev *cec = priv;
+	u32 status = 0;
+
+	status = s5p_cec_get_status(cec);
+
+	dev_dbg(cec->dev, "irq received\n");
+
+	if (status & CEC_STATUS_TX_DONE) {
+		if (status & CEC_STATUS_TX_ERROR) {
+			dev_dbg(cec->dev, "CEC_STATUS_TX_ERROR set\n");
+			cec->tx = STATE_ERROR;
+		} else {
+			dev_dbg(cec->dev, "CEC_STATUS_TX_DONE\n");
+			cec->tx = STATE_DONE;
+		}
+		s5p_clr_pending_tx(cec);
+	}
+
+	if (status & CEC_STATUS_RX_DONE) {
+		if (status & CEC_STATUS_RX_ERROR) {
+			dev_dbg(cec->dev, "CEC_STATUS_RX_ERROR set\n");
+			s5p_cec_rx_reset(cec);
+			s5p_cec_enable_rx(cec);
+		} else {
+			dev_dbg(cec->dev, "CEC_STATUS_RX_DONE set\n");
+			if (cec->rx != STATE_IDLE)
+				dev_dbg(cec->dev, "Buffer overrun (worker did not process previous message)\n");
+			cec->rx = STATE_BUSY;
+			cec->msg.len = status >> 24;
+			cec->msg.status = CEC_RX_STATUS_READY;
+			s5p_cec_get_rx_buf(cec, cec->msg.len,
+					cec->msg.msg);
+			cec->rx = STATE_DONE;
+			s5p_cec_enable_rx(cec);
+		}
+		/* Clear interrupt pending bit */
+		s5p_clr_pending_rx(cec);
+	}
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t s5p_cec_irq_handler_thread(int irq, void *priv)
+{
+	struct s5p_cec_dev *cec = priv;
+
+	dev_dbg(cec->dev, "irq processing thread\n");
+	switch (cec->tx) {
+	case STATE_DONE:
+		cec_transmit_done(&cec->adap, CEC_TX_STATUS_OK);
+		cec->tx = STATE_IDLE;
+		break;
+	case STATE_ERROR:
+		cec_transmit_done(&cec->adap, CEC_TX_STATUS_RETRY_TIMEOUT);
+		cec->tx = STATE_IDLE;
+		break;
+	case STATE_BUSY:
+		dev_err(cec->dev, "state set to busy, this should not occur here\n");
+		break;
+	default:
+		break;
+	}
+
+	switch (cec->rx) {
+	case STATE_DONE:
+		cec_received_msg(&cec->adap, &cec->msg);
+		cec->rx = STATE_IDLE;
+	default:
+		break;
+	};
+
+	return IRQ_HANDLED;
+}
+
+static int s5p_cec_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	struct s5p_cec_dev *cec;
+	int ret;
+
+	cec = devm_kzalloc(&pdev->dev, sizeof(*cec), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	cec->dev = dev;
+
+	cec->irq = platform_get_irq(pdev, 0);
+	if (IS_ERR_VALUE(cec->irq))
+		return cec->irq;
+
+	ret = devm_request_threaded_irq(dev, cec->irq, s5p_cec_irq_handler,
+		s5p_cec_irq_handler_thread, 0, pdev->name, cec);
+	if (IS_ERR_VALUE(ret))
+		return ret;
+
+	cec->clk = devm_clk_get(dev, "hdmicec");
+	if (IS_ERR(cec->clk))
+		return PTR_ERR(cec->clk);
+
+	cec->pmu = syscon_regmap_lookup_by_phandle(dev->of_node,
+						 "samsung,syscon-phandle");
+	if (IS_ERR(cec->pmu))
+		return -EPROBE_DEFER;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	cec->reg = devm_ioremap_resource(dev, res);
+	if (IS_ERR(cec->reg))
+		return PTR_ERR(cec->reg);
+
+	cec->adap.adap_enable = s5p_cec_enable;
+	cec->adap.adap_log_addr = s5p_cec_log_addr;
+	cec->adap.adap_transmit = s5p_cec_trasmit;
+	cec->adap.adap_transmit_timed_out = s5p_cec_transmit_timed_out;
+	cec_create_adapter(&cec->adap, CEC_NAME, CEC_CAP_STATE |
+		CEC_CAP_LOG_ADDRS | CEC_CAP_TRANSMIT |
+		CEC_CAP_RECEIVE);
+
+	platform_set_drvdata(pdev, cec);
+	pm_runtime_enable(dev);
+
+	dev_dbg(dev, "successfuly probed\n");
+	return 0;
+}
+
+static int s5p_cec_remove(struct platform_device *pdev)
+{
+	struct s5p_cec_dev *cec = platform_get_drvdata(pdev);
+
+	cec_delete_adapter(&cec->adap);
+	pm_runtime_disable(&pdev->dev);
+	return 0;
+}
+
+static int s5p_cec_runtime_suspend(struct device *dev)
+{
+	struct s5p_cec_dev *cec = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(cec->clk);
+	return 0;
+}
+
+static int s5p_cec_runtime_resume(struct device *dev)
+{
+	struct s5p_cec_dev *cec = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(cec->clk);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+static int s5p_cec_suspend(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+	return s5p_cec_runtime_suspend(dev);
+}
+
+static int s5p_cec_resume(struct device *dev)
+{
+	if (pm_runtime_suspended(dev))
+		return 0;
+	return s5p_cec_runtime_resume(dev);
+}
+
+static const struct dev_pm_ops s5p_cec_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(s5p_cec_suspend, s5p_cec_resume)
+	SET_RUNTIME_PM_OPS(s5p_cec_runtime_suspend, s5p_cec_runtime_resume,
+			   NULL)
+};
+
+static const struct of_device_id s5p_cec_match[] = {
+	{
+		.compatible	= "samsung,s5p-cec",
+	},
+	{},
+};
+
+static struct platform_driver s5p_cec_pdrv = {
+	.probe	= s5p_cec_probe,
+	.remove	= s5p_cec_remove,
+	.driver	= {
+		.name		= CEC_NAME,
+		.owner		= THIS_MODULE,
+		.of_match_table	= s5p_cec_match,
+		.pm		= &s5p_cec_pm_ops,
+	},
+};
+
+module_platform_driver(s5p_cec_pdrv);
+
+MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Samsung S5P CEC driver");
+
diff --git a/drivers/media/platform/s5p-cec/s5p_cec.h b/drivers/media/platform/s5p-cec/s5p_cec.h
new file mode 100644
index 0000000..d6ffd92
--- /dev/null
+++ b/drivers/media/platform/s5p-cec/s5p_cec.h
@@ -0,0 +1,76 @@
+/* drivers/media/platform/s5p-cec/s5p_cec.h
+ *
+ * Samsung S5P HDMI CEC driver
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _S5P_CEC_H_
+#define _S5P_CEC_H_ __FILE__
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mfd/syscon.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/timer.h>
+#include <linux/version.h>
+#include <linux/workqueue.h>
+#include <media/cec.h>
+
+#include "exynos_hdmi_cec.h"
+#include "regs-cec.h"
+#include "s5p_cec.h"
+
+#define CEC_NAME	"s5p-cec"
+
+#define CEC_STATUS_TX_RUNNING		(1 << 0)
+#define CEC_STATUS_TX_TRANSFERRING	(1 << 1)
+#define CEC_STATUS_TX_DONE		(1 << 2)
+#define CEC_STATUS_TX_ERROR		(1 << 3)
+#define CEC_STATUS_TX_BYTES		(0xFF << 8)
+#define CEC_STATUS_RX_RUNNING		(1 << 16)
+#define CEC_STATUS_RX_RECEIVING		(1 << 17)
+#define CEC_STATUS_RX_DONE		(1 << 18)
+#define CEC_STATUS_RX_ERROR		(1 << 19)
+#define CEC_STATUS_RX_BCAST		(1 << 20)
+#define CEC_STATUS_RX_BYTES		(0xFF << 24)
+
+#define CEC_WORKER_TX_DONE		(1 << 0)
+#define CEC_WORKER_RX_MSG		(1 << 1)
+
+/* CEC Rx buffer size */
+#define CEC_RX_BUFF_SIZE		16
+/* CEC Tx buffer size */
+#define CEC_TX_BUFF_SIZE		16
+
+enum cec_state {
+	STATE_IDLE,
+	STATE_BUSY,
+	STATE_DONE,
+	STATE_ERROR
+};
+
+struct s5p_cec_dev {
+	struct cec_adapter	adap;
+	struct clk		*clk;
+	struct device		*dev;
+	struct mutex		lock;
+	struct regmap           *pmu;
+	int			irq;
+	void __iomem		*reg;
+
+	enum cec_state		rx;
+	enum cec_state		tx;
+	struct cec_msg		msg;
+};
+
+#endif /* _S5P_CEC_H_ */
-- 
1.7.9.5

