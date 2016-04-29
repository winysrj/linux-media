Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:38051 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438AbcD2JjS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2016 05:39:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: tomi.valkeinen@ti.com, dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/3] omap4: add CEC support
Date: Fri, 29 Apr 2016 11:39:05 +0200
Message-Id: <1461922746-17521-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
References: <1461922746-17521-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/omap4-panda-a4.dts   |   2 +-
 arch/arm/boot/dts/omap4-panda-es.dts   |   2 +-
 arch/arm/boot/dts/omap4.dtsi           |   5 +-
 drivers/gpu/drm/omapdrm/dss/Kconfig    |   8 +
 drivers/gpu/drm/omapdrm/dss/Makefile   |   3 +
 drivers/gpu/drm/omapdrm/dss/hdmi.h     |  62 ++++++-
 drivers/gpu/drm/omapdrm/dss/hdmi4.c    |  39 +++-
 drivers/gpu/drm/omapdrm/dss/hdmi_cec.c | 329 +++++++++++++++++++++++++++++++++
 8 files changed, 441 insertions(+), 9 deletions(-)
 create mode 100644 drivers/gpu/drm/omapdrm/dss/hdmi_cec.c

diff --git a/arch/arm/boot/dts/omap4-panda-a4.dts b/arch/arm/boot/dts/omap4-panda-a4.dts
index 78d3631..f0c1020 100644
--- a/arch/arm/boot/dts/omap4-panda-a4.dts
+++ b/arch/arm/boot/dts/omap4-panda-a4.dts
@@ -13,7 +13,7 @@
 /* Pandaboard Rev A4+ have external pullups on SCL & SDA */
 &dss_hdmi_pins {
 	pinctrl-single,pins = <
-		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_cec */
+		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)	/* hdmi_cec.hdmi_cec */
 		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
 		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
 		>;
diff --git a/arch/arm/boot/dts/omap4-panda-es.dts b/arch/arm/boot/dts/omap4-panda-es.dts
index 119f8e6..940fe4f 100644
--- a/arch/arm/boot/dts/omap4-panda-es.dts
+++ b/arch/arm/boot/dts/omap4-panda-es.dts
@@ -34,7 +34,7 @@
 /* PandaboardES has external pullups on SCL & SDA */
 &dss_hdmi_pins {
 	pinctrl-single,pins = <
-		OMAP4_IOPAD(0x09a, PIN_INPUT_PULLUP | MUX_MODE0)	/* hdmi_cec.hdmi_cec */
+		OMAP4_IOPAD(0x09a, PIN_INPUT | MUX_MODE0)		/* hdmi_cec.hdmi_cec */
 		OMAP4_IOPAD(0x09c, PIN_INPUT | MUX_MODE0)		/* hdmi_scl.hdmi_scl */
 		OMAP4_IOPAD(0x09e, PIN_INPUT | MUX_MODE0)		/* hdmi_sda.hdmi_sda */
 		>;
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 2bd9c83..1bb490f 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -1006,8 +1006,9 @@
 				reg = <0x58006000 0x200>,
 				      <0x58006200 0x100>,
 				      <0x58006300 0x100>,
-				      <0x58006400 0x1000>;
-				reg-names = "wp", "pll", "phy", "core";
+				      <0x58006400 0x900>,
+				      <0x58006D00 0x100>;
+				reg-names = "wp", "pll", "phy", "core", "cec";
 				interrupts = <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 				ti,hwmods = "dss_hdmi";
diff --git a/drivers/gpu/drm/omapdrm/dss/Kconfig b/drivers/gpu/drm/omapdrm/dss/Kconfig
index d1fa730..69638e9 100644
--- a/drivers/gpu/drm/omapdrm/dss/Kconfig
+++ b/drivers/gpu/drm/omapdrm/dss/Kconfig
@@ -71,9 +71,17 @@ config OMAP4_DSS_HDMI
 	bool "HDMI support for OMAP4"
         default y
 	select OMAP2_DSS_HDMI_COMMON
+	select MEDIA_CEC_EDID
 	help
 	  HDMI support for OMAP4 based SoCs.
 
+config OMAP2_DSS_HDMI_CEC
+	bool "Enable HDMI CEC support for OMAP4"
+	depends on OMAP4_DSS_HDMI && MEDIA_CEC
+	default y
+	---help---
+	  When selected the HDMI transmitter will support the CEC feature.
+
 config OMAP5_DSS_HDMI
 	bool "HDMI support for OMAP5"
 	default n
diff --git a/drivers/gpu/drm/omapdrm/dss/Makefile b/drivers/gpu/drm/omapdrm/dss/Makefile
index b651ec9..37eb597 100644
--- a/drivers/gpu/drm/omapdrm/dss/Makefile
+++ b/drivers/gpu/drm/omapdrm/dss/Makefile
@@ -10,6 +10,9 @@ omapdss-$(CONFIG_OMAP2_DSS_SDI) += sdi.o
 omapdss-$(CONFIG_OMAP2_DSS_DSI) += dsi.o
 omapdss-$(CONFIG_OMAP2_DSS_HDMI_COMMON) += hdmi_common.o hdmi_wp.o hdmi_pll.o \
 	hdmi_phy.o
+ifeq ($(CONFIG_OMAP2_DSS_HDMI_CEC),y)
+  omapdss-$(CONFIG_OMAP2_DSS_HDMI_COMMON) += hdmi_cec.o
+endif
 omapdss-$(CONFIG_OMAP4_DSS_HDMI) += hdmi4.o hdmi4_core.o
 omapdss-$(CONFIG_OMAP5_DSS_HDMI) += hdmi5.o hdmi5_core.o
 ccflags-$(CONFIG_OMAP2_DSS_DEBUG) += -DDEBUG
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi.h b/drivers/gpu/drm/omapdrm/dss/hdmi.h
index 53616b0..7cf8a91 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi.h
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi.h
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/hdmi.h>
 #include <video/omapdss.h>
+#include <media/cec.h>
 
 #include "dss.h"
 
@@ -83,6 +84,31 @@
 #define HDMI_TXPHY_PAD_CFG_CTRL			0xC
 #define HDMI_TXPHY_BIST_CONTROL			0x1C
 
+/* HDMI CEC */
+#define HDMI_CEC_DEV_ID                         0x0
+#define HDMI_CEC_SPEC                           0x4
+#define HDMI_CEC_DBG_3                          0x1C
+#define HDMI_CEC_TX_INIT                        0x20
+#define HDMI_CEC_TX_DEST                        0x24
+#define HDMI_CEC_SETUP                          0x38
+#define HDMI_CEC_TX_COMMAND                     0x3C
+#define HDMI_CEC_TX_OPERAND                     0x40
+#define HDMI_CEC_TRANSMIT_DATA                  0x7C
+#define HDMI_CEC_CA_7_0                         0x88
+#define HDMI_CEC_CA_15_8                        0x8C
+#define HDMI_CEC_INT_STATUS_0                   0x98
+#define HDMI_CEC_INT_STATUS_1                   0x9C
+#define HDMI_CEC_INT_ENABLE_0                   0x90
+#define HDMI_CEC_INT_ENABLE_1                   0x94
+#define HDMI_CEC_RX_CONTROL                     0xB0
+#define HDMI_CEC_RX_COUNT                       0xB4
+#define HDMI_CEC_RX_CMD_HEADER                  0xB8
+#define HDMI_CEC_RX_COMMAND                     0xBC
+#define HDMI_CEC_RX_OPERAND                     0xC0
+
+#define HDMI_CEC_TX_FIFO_INT_MASK		0x64
+#define HDMI_CEC_RETRANSMIT_CNT_INT_MASK	0x2
+
 enum hdmi_pll_pwr {
 	HDMI_PLLPWRCMD_ALLOFF = 0,
 	HDMI_PLLPWRCMD_PLLONLY = 1,
@@ -250,6 +276,12 @@ struct hdmi_phy_data {
 	u8 lane_polarity[4];
 };
 
+struct hdmi_cec_data {
+	void __iomem *base;
+	struct cec_adapter *adap;
+	u16 phys_addr;
+};
+
 struct hdmi_core_data {
 	void __iomem *base;
 };
@@ -319,6 +351,33 @@ void hdmi_phy_dump(struct hdmi_phy_data *phy, struct seq_file *s);
 int hdmi_phy_init(struct platform_device *pdev, struct hdmi_phy_data *phy);
 int hdmi_phy_parse_lanes(struct hdmi_phy_data *phy, const u32 *lanes);
 
+/* HDMI CEC funcs */
+#ifdef CONFIG_OMAP2_DSS_HDMI_CEC
+void hdmi_cec_set_phys_addr(struct hdmi_cec_data *cec, u16 pa);
+void hdmi_cec_irq(struct hdmi_cec_data *cec);
+int hdmi_cec_init(struct platform_device *pdev, struct hdmi_cec_data *cec);
+void hdmi_cec_uninit(struct hdmi_cec_data *cec);
+#else
+static inline void hdmi_cec_set_phys_addr(struct hdmi_cec_data *cec, u16 pa)
+{
+}
+
+static inline void hdmi_cec_irq(struct hdmi_cec_data *cec)
+{
+}
+
+static inline int hdmi_cec_init(struct platform_device *pdev,
+				struct hdmi_cec_data *cec)
+{
+	cec->phys_addr = CEC_PHYS_ADDR_INVALID;
+	return 0;
+}
+
+static inline void hdmi_cec_uninit(struct hdmi_cec_data *cec)
+{
+}
+#endif
+
 /* HDMI common funcs */
 int hdmi_parse_lanes_of(struct platform_device *pdev, struct device_node *ep,
 	struct hdmi_phy_data *phy);
@@ -344,6 +403,7 @@ struct omap_hdmi {
 	struct hdmi_wp_data	wp;
 	struct hdmi_pll_data	pll;
 	struct hdmi_phy_data	phy;
+	struct hdmi_cec_data	cec;
 	struct hdmi_core_data	core;
 
 	struct hdmi_config cfg;
@@ -361,7 +421,7 @@ struct omap_hdmi {
 	bool audio_configured;
 	struct omap_dss_audio audio_config;
 
-	/* This lock should be taken when booleans bellow are touched. */
+	/* This lock should be taken when booleans below are touched. */
 	spinlock_t audio_playing_lock;
 	bool audio_playing;
 	bool display_enabled;
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi4.c b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
index f892ae15..47a60bf 100644
--- a/drivers/gpu/drm/omapdrm/dss/hdmi4.c
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi4.c
@@ -34,6 +34,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/component.h>
 #include <video/omapdss.h>
+#include <media/cec-edid.h>
 #include <sound/omap-hdmi-audio.h>
 
 #include "hdmi4_core.h"
@@ -69,14 +70,15 @@ static void hdmi_runtime_put(void)
 
 static irqreturn_t hdmi_irq_handler(int irq, void *data)
 {
-	struct hdmi_wp_data *wp = data;
+	struct omap_hdmi *hdmi = data;
+	struct hdmi_wp_data *wp = &hdmi->wp;
 	u32 irqstatus;
 
 	irqstatus = hdmi_wp_get_irqstatus(wp);
 	hdmi_wp_set_irqstatus(wp, irqstatus);
 
 	if ((irqstatus & HDMI_IRQ_LINK_CONNECT) &&
-			irqstatus & HDMI_IRQ_LINK_DISCONNECT) {
+	    (irqstatus & HDMI_IRQ_LINK_DISCONNECT)) {
 		/*
 		 * If we get both connect and disconnect interrupts at the same
 		 * time, turn off the PHY, clear interrupts, and restart, which
@@ -94,6 +96,13 @@ static irqreturn_t hdmi_irq_handler(int irq, void *data)
 	} else if (irqstatus & HDMI_IRQ_LINK_DISCONNECT) {
 		hdmi_wp_set_phy_pwr(wp, HDMI_PHYPWRCMD_LDOON);
 	}
+	if (irqstatus & HDMI_IRQ_CORE) {
+		u32 intr4 = hdmi_read_reg(hdmi->core.base, HDMI_CORE_SYS_INTR4);
+
+		hdmi_write_reg(hdmi->core.base, HDMI_CORE_SYS_INTR4, intr4);
+		if (intr4 & 8)
+			hdmi_cec_irq(&hdmi->cec);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -213,6 +222,12 @@ static int hdmi_power_on_full(struct omap_dss_device *dssdev)
 
 	hdmi4_configure(&hdmi.core, &hdmi.wp, &hdmi.cfg);
 
+	/* Initialize CEC clock divider */
+	/* CEC needs 2MHz clock hence set the devider to 24 to get
+	   48/24=2MHz clock */
+	REG_FLD_MOD(hdmi.wp.base, HDMI_WP_CLK, 0x18, 5, 0);
+	hdmi_cec_set_phys_addr(&hdmi.cec, hdmi.cec.phys_addr);
+
 	/* bypass TV gamma table */
 	dispc_enable_gamma_table(0);
 
@@ -228,7 +243,11 @@ static int hdmi_power_on_full(struct omap_dss_device *dssdev)
 		goto err_vid_enable;
 
 	hdmi_wp_set_irqenable(wp,
-		HDMI_IRQ_LINK_CONNECT | HDMI_IRQ_LINK_DISCONNECT);
+		HDMI_IRQ_LINK_CONNECT | HDMI_IRQ_LINK_DISCONNECT |
+		HDMI_IRQ_CORE);
+
+	/* Unmask CEC interrupt */
+	REG_FLD_MOD(hdmi.core.base, HDMI_CORE_SYS_INTR_UNMASK4, 0x1, 3, 3);
 
 	return 0;
 
@@ -250,6 +269,8 @@ static void hdmi_power_off_full(struct omap_dss_device *dssdev)
 	enum omap_channel channel = dssdev->dispc_channel;
 
 	hdmi_wp_clear_irqenable(&hdmi.wp, 0xffffffff);
+	hdmi.cec.phys_addr = CEC_PHYS_ADDR_INVALID;
+	hdmi_cec_set_phys_addr(&hdmi.cec, hdmi.cec.phys_addr);
 
 	hdmi_wp_video_stop(&hdmi.wp);
 
@@ -488,6 +509,10 @@ static int hdmi_read_edid(struct omap_dss_device *dssdev,
 	}
 
 	r = read_edid(edid, len);
+	if (r >= 256)
+		hdmi.cec.phys_addr = cec_get_edid_phys_addr(edid, r, NULL);
+	else
+		hdmi.cec.phys_addr = CEC_PHYS_ADDR_INVALID;
 
 	if (need_enable)
 		hdmi_core_disable(dssdev);
@@ -724,6 +749,10 @@ static int hdmi4_bind(struct device *dev, struct device *master, void *data)
 	if (r)
 		goto err;
 
+	r = hdmi_cec_init(pdev, &hdmi.cec);
+	if (r)
+		goto err;
+
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		DSSERR("platform_get_irq failed\n");
@@ -733,7 +762,7 @@ static int hdmi4_bind(struct device *dev, struct device *master, void *data)
 
 	r = devm_request_threaded_irq(&pdev->dev, irq,
 			NULL, hdmi_irq_handler,
-			IRQF_ONESHOT, "OMAP HDMI", &hdmi.wp);
+			IRQF_ONESHOT, "OMAP HDMI", &hdmi);
 	if (r) {
 		DSSERR("HDMI IRQ request failed\n");
 		goto err;
@@ -768,6 +797,8 @@ static void hdmi4_unbind(struct device *dev, struct device *master, void *data)
 
 	hdmi_uninit_output(pdev);
 
+	hdmi_cec_uninit(&hdmi.cec);
+
 	hdmi_pll_uninit(&hdmi.pll);
 
 	pm_runtime_disable(&pdev->dev);
diff --git a/drivers/gpu/drm/omapdrm/dss/hdmi_cec.c b/drivers/gpu/drm/omapdrm/dss/hdmi_cec.c
new file mode 100644
index 0000000..d4309df
--- /dev/null
+++ b/drivers/gpu/drm/omapdrm/dss/hdmi_cec.c
@@ -0,0 +1,329 @@
+/*
+ * HDMI CEC
+ *
+ * Based on the CEC code from hdmi_ti_4xxx_ip.c from Android.
+ *
+ * Copyright (C) 2010-2011 Texas Instruments Incorporated - http://www.ti.com/
+ * Authors: Yong Zhi
+ *	Mythri pk <mythripk@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <video/omapdss.h>
+
+#include "dss.h"
+#include "hdmi.h"
+
+#define HDMI_CORE_CEC_RETRY    200
+
+void hdmi_cec_transmit_fifo_empty(struct hdmi_cec_data *cec, u32 stat1)
+{
+	if (stat1 & 2) {
+		u32 dbg3 = hdmi_read_reg(cec->base, HDMI_CEC_DBG_3);
+
+		cec_transmit_done(cec->adap,
+				  CEC_TX_STATUS_NACK | CEC_TX_STATUS_MAX_RETRIES,
+				  0, (dbg3 >> 4) & 7, 0, 0);
+	} else if (stat1 & 1) {
+		cec_transmit_done(cec->adap,
+				  CEC_TX_STATUS_ARB_LOST | CEC_TX_STATUS_MAX_RETRIES,
+				  0, 0, 0, 0);
+	} else if (stat1 == 0) {
+		cec_transmit_done(cec->adap, CEC_TX_STATUS_OK,
+				  0, 0, 0, 0);
+	}
+}
+
+void hdmi_cec_received_msg(struct hdmi_cec_data *cec)
+{
+	u32 cnt = hdmi_read_reg(cec->base, HDMI_CEC_RX_COUNT) & 0xff;
+
+	/* While there are CEC frames in the FIFO */
+	while (cnt & 0x70) {
+		/* and the frame doesn't have an error */
+		if (!(cnt & 0x80)) {
+			struct cec_msg msg = {};
+			unsigned int i;
+
+			/* then read the message */
+			msg.len = cnt & 0xf;
+			msg.msg[0] = hdmi_read_reg(cec->base, HDMI_CEC_RX_CMD_HEADER) & 0xff;
+			msg.msg[1] = hdmi_read_reg(cec->base, HDMI_CEC_RX_COMMAND) & 0xff;
+			for (i = 0; i < msg.len; i++)
+				msg.msg[2 + i] =
+					hdmi_read_reg(cec->base, HDMI_CEC_RX_OPERAND + i * 4) & 0xff;
+			msg.len += 2;
+			cec_received_msg(cec->adap, &msg);
+		}
+		/* Clear the current frame from the FIFO */
+		hdmi_write_reg(cec->base, HDMI_CEC_RX_CONTROL, 1);
+		/* Wait until the current frame is cleared */
+		while (hdmi_read_reg(cec->base, HDMI_CEC_RX_CONTROL) & 1)
+			udelay(1);
+		/*
+		 * Re-read the count register and loop to see if there are
+		 * more messages in the FIFO.
+		 */
+		cnt = hdmi_read_reg(cec->base, HDMI_CEC_RX_COUNT) & 0xff;
+	}
+}
+
+void hdmi_cec_irq(struct hdmi_cec_data *cec)
+{
+	u32 stat0 = hdmi_read_reg(cec->base, HDMI_CEC_INT_STATUS_0);
+	u32 stat1 = hdmi_read_reg(cec->base, HDMI_CEC_INT_STATUS_1);
+
+	hdmi_write_reg(cec->base, HDMI_CEC_INT_STATUS_0, stat0);
+	hdmi_write_reg(cec->base, HDMI_CEC_INT_STATUS_1, stat1);
+
+	if (stat0 & 0x02)
+		hdmi_cec_received_msg(cec);
+	if (stat0 & 0x40)
+		REG_FLD_MOD(cec->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
+	else if (stat0 & 0x24)
+		hdmi_cec_transmit_fifo_empty(cec, stat1);
+	if (stat1 & 2) {
+		u32 dbg3 = hdmi_read_reg(cec->base, HDMI_CEC_DBG_3);
+
+		cec_transmit_done(cec->adap,
+				  CEC_TX_STATUS_NACK | CEC_TX_STATUS_MAX_RETRIES,
+				  0, (dbg3 >> 4) & 7, 0, 0);
+	} else if (stat1 & 1) {
+		cec_transmit_done(cec->adap,
+				  CEC_TX_STATUS_ARB_LOST | CEC_TX_STATUS_MAX_RETRIES,
+				  0, 0, 0, 0);
+	}
+	if (stat1 & 0x3)
+		REG_FLD_MOD(cec->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
+}
+
+static int hdmi_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct hdmi_cec_data *cec = adap->priv;
+	int retry = HDMI_CORE_CEC_RETRY;
+	int temp;
+
+	/* Clear TX FIFO */
+	REG_FLD_MOD(cec->base, HDMI_CEC_DBG_3, 0x1, 7, 7);
+	while (retry) {
+		temp = hdmi_read_reg(cec->base, HDMI_CEC_DBG_3);
+		if (FLD_GET(temp, 7, 7) == 0)
+			break;
+		retry--;
+	}
+	if (retry == 0x0) {
+		pr_err("Could not clear TX FIFO");
+		return -EBUSY;
+	}
+
+	/* Clear RX FIFO */
+	hdmi_write_reg(cec->base, HDMI_CEC_RX_CONTROL, 0x3);
+	retry = HDMI_CORE_CEC_RETRY;
+	while (retry) {
+		temp = hdmi_read_reg(cec->base, HDMI_CEC_RX_CONTROL);
+		if (FLD_GET(temp, 1, 0) == 0)
+			break;
+		retry--;
+	}
+	if (retry == 0x0) {
+		pr_err("Could not clear RX FIFO");
+		return -EBUSY;
+	}
+
+	/* Clear CEC interrupts */
+	hdmi_write_reg(cec->base, HDMI_CEC_INT_STATUS_1,
+		hdmi_read_reg(cec->base, HDMI_CEC_INT_STATUS_1));
+	hdmi_write_reg(cec->base, HDMI_CEC_INT_STATUS_0,
+		hdmi_read_reg(cec->base, HDMI_CEC_INT_STATUS_0));
+
+	/* Enable HDMI core interrupts */
+	if (enable) {
+		/* Enable CEC interrupts */
+		/* Transmit FIFO full/empty event */
+		/* Receiver FIFO not empty event */
+		hdmi_write_reg(cec->base, HDMI_CEC_INT_ENABLE_0, 0x26);
+		/* Frame retransmit count exceeded event */
+		hdmi_write_reg(cec->base, HDMI_CEC_INT_ENABLE_1, 0x0f);
+	} else {
+		hdmi_write_reg(cec->base, HDMI_CEC_INT_ENABLE_0, 0);
+		hdmi_write_reg(cec->base, HDMI_CEC_INT_ENABLE_1, 0);
+		return 0;
+	}
+
+	/* Remove BYpass mode */
+
+	/* cec calibration enable (self clearing) */
+	hdmi_write_reg(cec->base, HDMI_CEC_SETUP, 0x03);
+	msleep(10);
+	hdmi_write_reg(cec->base, HDMI_CEC_SETUP, 0x04);
+
+	temp = hdmi_read_reg(cec->base, HDMI_CEC_SETUP);
+	if (FLD_GET(temp, 4, 4) != 0) {
+		temp = FLD_MOD(temp, 0, 4, 4);
+		hdmi_write_reg(cec->base, HDMI_CEC_SETUP, temp);
+
+		/*
+		 * If we enabled CEC in middle of a CEC messages on CEC n/w,
+		 * we could have start bit irregularity and/or short
+		 * pulse event. Clear them now.
+		 */
+		temp = hdmi_read_reg(cec->base, HDMI_CEC_INT_STATUS_1);
+		temp = FLD_MOD(0x0, 0x5, 2, 0);
+		hdmi_write_reg(cec->base, HDMI_CEC_INT_STATUS_1, temp);
+	}
+	return 0;
+}
+
+static int hdmi_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	struct hdmi_cec_data *cec = adap->priv;
+	u32 v;
+
+	if (log_addr == CEC_LOG_ADDR_INVALID) {
+		hdmi_write_reg(cec->base, HDMI_CEC_CA_7_0, 0);
+		hdmi_write_reg(cec->base, HDMI_CEC_CA_15_8, 0);
+		return 0;
+	}
+	if (log_addr <= 7) {
+		v = hdmi_read_reg(cec->base, HDMI_CEC_CA_7_0);
+		v |= 1 << log_addr;
+		hdmi_write_reg(cec->base, HDMI_CEC_CA_7_0, v);
+	} else {
+		v = hdmi_read_reg(cec->base, HDMI_CEC_CA_15_8);
+		v |= 1 << (log_addr - 8);
+		hdmi_write_reg(cec->base, HDMI_CEC_CA_15_8, v);
+	}
+	return 0;
+}
+
+static int hdmi_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				   u32 signal_free_time, struct cec_msg *msg)
+{
+	struct hdmi_cec_data *cec = adap->priv;
+	u32 retry = HDMI_CORE_CEC_RETRY;
+	u32 temp, i = 0;
+
+	/*
+	 * 1. Flush TX FIFO - required as change of initiator ID / destination
+	 *    ID while TX is in progress could result in corrupted message.
+	 * 2. Clear interrupt status registers for TX.
+	 * 3. Set initiator Address, set retry count
+	 * 4. Set Destination Address
+	 * 5. Clear TX interrupt flags - if required
+	 * 6. Set the command
+	 * 7. Transmit
+	 * 8. Check for NACK / ACK - report the same.
+	 */
+
+	/* Clear TX FIFO */
+	REG_FLD_MOD(cec->base, HDMI_CEC_DBG_3, 1, 7, 7);
+
+	while (retry) {
+		temp = hdmi_read_reg(cec->base, HDMI_CEC_DBG_3);
+		if (FLD_GET(temp, 7, 7) == 0)
+			break;
+		udelay(10);
+		retry--;
+	}
+	if (retry == 0x0) {
+		pr_err("Could not clear TX FIFO");
+		pr_err("\n FIFO Reset - retry  : %d - was %d\n",
+			retry, HDMI_CORE_CEC_RETRY);
+		return -EIO;
+	}
+
+	/* Clear TX interrupts */
+	hdmi_write_reg(cec->base, HDMI_CEC_INT_STATUS_0,
+		       HDMI_CEC_TX_FIFO_INT_MASK);
+
+	hdmi_write_reg(cec->base, HDMI_CEC_INT_STATUS_1,
+		       HDMI_CEC_RETRANSMIT_CNT_INT_MASK);
+
+	/* Set the retry count */
+	REG_FLD_MOD(cec->base, HDMI_CEC_DBG_3, attempts - 1, 6, 4);
+
+	/* Set the initiator addresses */
+	hdmi_write_reg(cec->base, HDMI_CEC_TX_INIT, cec_msg_initiator(msg));
+
+	/* Set destination id */
+	temp = cec_msg_destination(msg);
+	if (msg->len == 1)
+		temp |= 0x80;
+	hdmi_write_reg(cec->base, HDMI_CEC_TX_DEST, temp);
+	if (msg->len == 1)
+		return 0;
+
+	/* Setup command and arguments for the command */
+	hdmi_write_reg(cec->base, HDMI_CEC_TX_COMMAND, msg->msg[1]);
+
+	for (i = 0; i < msg->len - 2; i++)
+		hdmi_write_reg(cec->base, HDMI_CEC_TX_OPERAND + i * 4,
+			       msg->msg[2 + i]);
+
+	/* Operand count */
+	hdmi_write_reg(cec->base, HDMI_CEC_TRANSMIT_DATA,
+		       (msg->len - 2) | 0x10);
+	return 0;
+}
+
+void hdmi_cec_set_phys_addr(struct hdmi_cec_data *cec, u16 pa)
+{
+	cec_s_phys_addr(cec->adap, pa, false);
+}
+
+const struct cec_adap_ops hdmi_cec_adap_ops = {
+	.adap_enable = hdmi_cec_adap_enable,
+	.adap_log_addr = hdmi_cec_adap_log_addr,
+	.adap_transmit = hdmi_cec_adap_transmit,
+};
+
+int hdmi_cec_init(struct platform_device *pdev, struct hdmi_cec_data *cec)
+{
+	struct resource *res;
+	u32 caps = CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS |
+		CEC_CAP_PASSTHROUGH | CEC_CAP_RC;
+	unsigned int ret;
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cec");
+	if (!res) {
+		DSSERR("can't get CEC mem resource\n");
+		return -EINVAL;
+	}
+
+	cec->base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(cec->base)) {
+		DSSERR("can't ioremap TX CEC\n");
+		return PTR_ERR(cec->base);
+	}
+
+	cec->adap = cec_allocate_adapter(&hdmi_cec_adap_ops, cec,
+		"omap4", caps, CEC_MAX_LOG_ADDRS, &pdev->dev);
+	ret = PTR_ERR_OR_ZERO(cec->adap);
+	if (ret < 0)
+		return ret;
+	cec->phys_addr = CEC_PHYS_ADDR_INVALID;
+	ret = cec_register_adapter(cec->adap);
+	if (ret < 0) {
+		cec_delete_adapter(cec->adap);
+		return ret;
+	}
+	return 0;
+}
+
+void hdmi_cec_uninit(struct hdmi_cec_data *cec)
+{
+	cec_unregister_adapter(cec->adap);
+}
-- 
2.8.1

