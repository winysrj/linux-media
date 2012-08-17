Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46743 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab2HQAtf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 20:49:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org, Bryan Wu <bryan.wu@canonical.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Marcus Lorentzon <marcus.lorentzon@linaro.org>,
	Sumit Semwal <sumit.semwal@ti.com>,
	Archit Taneja <archit@ti.com>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	Inki Dae <inki.dae@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [RFC 4/5] video: panel: Add R61505 panel support
Date: Fri, 17 Aug 2012 02:49:42 +0200
Message-Id: <1345164583-18924-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1345164583-18924-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The R61505 is a SYS-80 bus panel controller from Renesas.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/video/panel/Kconfig        |    9 +
 drivers/video/panel/Makefile       |    1 +
 drivers/video/panel/panel-r61505.c |  520 ++++++++++++++++++++++++++++++++++++
 include/video/panel-r61505.h       |   27 ++
 4 files changed, 557 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/panel/panel-r61505.c
 create mode 100644 include/video/panel-r61505.h

diff --git a/drivers/video/panel/Kconfig b/drivers/video/panel/Kconfig
index fd0b3cf..12d7712 100644
--- a/drivers/video/panel/Kconfig
+++ b/drivers/video/panel/Kconfig
@@ -16,4 +16,13 @@ config DISPLAY_PANEL_DBI
 	tristate
 	default n
 
+config DISPLAY_PANEL_R61505
+	tristate "Renesas R61505-based Display Panel"
+	select DISPLAY_PANEL_DBI
+	---help---
+	  Support panels based on the Renesas R61505 panel controller.
+	  Those panels are controlled through a MIPI DBI interface.
+
+	  If you are in doubt, say N.
+
 endif # DISPLAY_PANEL
diff --git a/drivers/video/panel/Makefile b/drivers/video/panel/Makefile
index 2ab0520..e4fb9fe 100644
--- a/drivers/video/panel/Makefile
+++ b/drivers/video/panel/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_DISPLAY_PANEL) += panel.o
 obj-$(CONFIG_DISPLAY_PANEL_DUMMY) += panel-dummy.o
 obj-$(CONFIG_DISPLAY_PANEL_DBI) += panel-dbi.o
+obj-$(CONFIG_DISPLAY_PANEL_R61505) += panel-r61505.o
diff --git a/drivers/video/panel/panel-r61505.c b/drivers/video/panel/panel-r61505.c
new file mode 100644
index 0000000..e09455e
--- /dev/null
+++ b/drivers/video/panel/panel-r61505.c
@@ -0,0 +1,520 @@
+/*
+ * Renesas R61505-based Display Panels
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ * Based on SuperH MigoR Quarter VGA LCD Panel
+ * Copyright (C) 2008 Magnus Damm
+ * Based on lcd_powertip.c from Kenati Technologies Pvt Ltd.
+ * Copyright (c) 2007 Ujjwal Pande
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <video/panel-r61505.h>
+#include <video/panel-dbi.h>
+
+#define R61505_DEVICE_CODE			0x0000
+#define R61505_DEVICE_CODE_VALUE		0x1505
+#define R61505_DRIVER_OUTPUT_CONTROL		0x0001
+#define R61505_DRIVER_OUTPUT_CONTROL_SM		(1 << 10)
+#define R61505_DRIVER_OUTPUT_CONTROL_SS		(1 << 8)
+#define R61505_LCD_WAVEFORM			0x0002
+#define R61505_LCD_WAVEFORM_BC0			(1 << 9)
+#define R61505_LCD_WAVEFORM_EOR			(1 << 8)
+#define R61505_ENTRY_MODE			0x0003
+#define R61505_ENTRY_MODE_TRIREG		(1 << 15)
+#define R61505_ENTRY_MODE_DFM			(1 << 14)
+#define R61505_ENTRY_MODE_BGR			(1 << 12)
+#define R61505_ENTRY_MODE_HWM			(1 << 9)
+#define R61505_ENTRY_MODE_ORG			(1 << 7)
+#define R61505_ENTRY_MODE_ID1			(1 << 5)
+#define R61505_ENTRY_MODE_ID0			(1 << 4)
+#define R61505_ENTRY_MODE_AM			(1 << 3)
+#define R61505_RESIZE_CONTROL			0x0004
+#define R61505_RESIZE_CONTROL_RCV(n)		(((n) & 3) << 8)
+#define R61505_RESIZE_CONTROL_RCH(n)		(((n) & 3) << 4)
+#define R61505_RESIZE_CONTROL_RSZ_4		(3 << 0)
+#define R61505_RESIZE_CONTROL_RSZ_2		(1 << 0)
+#define R61505_RESIZE_CONTROL_RSZ_1		(0 << 0)
+#define R61505_DISPLAY_CONTROL1			0x0007
+#define R61505_DISPLAY_CONTROL1_PTDE1		(1 << 13)
+#define R61505_DISPLAY_CONTROL1_PTDE0		(1 << 12)
+#define R61505_DISPLAY_CONTROL1_BASEE		(1 << 8)
+#define R61505_DISPLAY_CONTROL1_VON		(1 << 6)
+#define R61505_DISPLAY_CONTROL1_GON		(1 << 5)
+#define R61505_DISPLAY_CONTROL1_DTE		(1 << 4)
+#define R61505_DISPLAY_CONTROL1_COL		(1 << 3)
+#define R61505_DISPLAY_CONTROL1_D1		(1 << 1)
+#define R61505_DISPLAY_CONTROL1_D0		(1 << 0)
+#define R61505_DISPLAY_CONTROL2			0x0008
+#define R61505_DISPLAY_CONTROL2_FP(n)		(((n) & 0xf) << 8)
+#define R61505_DISPLAY_CONTROL2_BP(n)		(((n) & 0xf) << 0)
+#define R61505_DISPLAY_CONTROL3			0x0009
+#define R61505_DISPLAY_CONTROL3_PTS(n)		(((n) & 7) << 8)
+#define R61505_DISPLAY_CONTROL3_PTG(n)		(((n) & 3) << 3)
+#define R61505_DISPLAY_CONTROL3_ICS(n)		(((n) & 0xf) << 0)
+#define R61505_DISPLAY_CONTROL4			0x000a
+#define R61505_DISPLAY_CONTROL4_FMARKOE		(1 << 3)
+#define R61505_DISPLAY_CONTROL4_FMI_6		(5 << 0)
+#define R61505_DISPLAY_CONTROL4_FMI_4		(3 << 0)
+#define R61505_DISPLAY_CONTROL4_FMI_2		(1 << 0)
+#define R61505_DISPLAY_CONTROL4_FMI_1		(0 << 0)
+#define R61505_EXT_DISPLAY_IF_CONTROL1		0x000c
+#define R61505_EXT_DISPLAY_IF_CONTROL1_ENC(n)	(((n) & 7) << 12)
+#define R61505_EXT_DISPLAY_IF_CONTROL1_RM	(1 << 8)
+#define R61505_EXT_DISPLAY_IF_CONTROL1_DM_VSYNC	(2 << 4)
+#define R61505_EXT_DISPLAY_IF_CONTROL1_DM_RGB	(1 << 4)
+#define R61505_EXT_DISPLAY_IF_CONTROL1_DM_ICLK	(0 << 4)
+#define R61505_EXT_DISPLAY_IF_CONTROL1_RIM_6	(2 << 0)
+#define R61505_EXT_DISPLAY_IF_CONTROL1_RIM_16	(1 << 0)
+#define R61505_EXT_DISPLAY_IF_CONTROL1_RIM_18	(0 << 0)
+#define R61505_FRAME_MARKER_CONTROL		0x000d
+#define R61505_FRAME_MARKER_CONTROL_FMP(n)	(((n) & 0x1ff) << 0)
+#define R61505_EXT_DISPLAY_IF_CONTROL2		0x000f
+#define R61505_POWER_CONTROL1			0x0010
+#define R61505_POWER_CONTROL1_SAP		(1 << 12)
+#define R61505_POWER_CONTROL1_BT(n)		(((n) & 0xf) << 8)
+#define R61505_POWER_CONTROL1_APE		(1 << 7)
+#define R61505_POWER_CONTROL1_AP_100		(3 << 4)
+#define R61505_POWER_CONTROL1_AP_075		(2 << 4)
+#define R61505_POWER_CONTROL1_AP_050		(1 << 4)
+#define R61505_POWER_CONTROL1_AP_HALT		(0 << 4)
+#define R61505_POWER_CONTROL1_DSTB		(1 << 2)
+#define R61505_POWER_CONTROL1_SLP		(1 << 1)
+#define R61505_POWER_CONTROL2			0x0011
+#define R61505_POWER_CONTROL2_DC1_HALT		(6 << 8)
+#define R61505_POWER_CONTROL2_DC1_FOSC_256	(4 << 8)
+#define R61505_POWER_CONTROL2_DC1_FOSC_128	(3 << 8)
+#define R61505_POWER_CONTROL2_DC1_FOSC_64	(2 << 8)
+#define R61505_POWER_CONTROL2_DC1_FOSC_32	(1 << 8)
+#define R61505_POWER_CONTROL2_DC1_FOSC_16	(0 << 8)
+#define R61505_POWER_CONTROL2_DC0_HALT		(6 << 4)
+#define R61505_POWER_CONTROL2_DC0_FOSC_16	(4 << 4)
+#define R61505_POWER_CONTROL2_DC0_FOSC_8	(3 << 4)
+#define R61505_POWER_CONTROL2_DC0_FOSC_4	(2 << 4)
+#define R61505_POWER_CONTROL2_DC0_FOSC_2	(1 << 4)
+#define R61505_POWER_CONTROL2_DC0_FOSC		(0 << 4)
+#define R61505_POWER_CONTROL2_VC_100		(7 << 0)
+#define R61505_POWER_CONTROL2_VC_076		(4 << 0)
+#define R61505_POWER_CONTROL2_VC_089		(1 << 0)
+#define R61505_POWER_CONTROL2_VC_094		(0 << 0)
+#define R61505_POWER_CONTROL3			0x0012
+#define R61505_POWER_CONTROL3_VCMR		(1 << 8)
+#define R61505_POWER_CONTROL3_PSON		(1 << 5)
+#define R61505_POWER_CONTROL3_PON		(1 << 4)
+#define R61505_POWER_CONTROL3_VRH(n)		(((n) & 0xf) << 0)
+#define R61505_POWER_CONTROL4			0x0013
+#define R61505_POWER_CONTROL4_VDV(n)		(((n) & 0xf) << 8)
+#define R61505_POWER_CONTROL5			0x0015
+#define R61505_POWER_CONTROL5_BLDM		(1 << 12)
+#define R61505_POWER_CONTROL6			0x0017
+#define R61505_POWER_CONTROL6_PSE		(1 << 0)
+#define R61505_RAM_ADDR_HORZ			0x0020
+#define R61505_RAM_ADDR_VERT			0x0021
+#define R61505_RAM_DATA				0x0022
+#define R61505_POWER_CONTROL7			0x0029
+#define R61505_POWER_CONTROL7_VCM1(n)		(((n) & 0x1f) << 0)
+#define R61505_GAMMA_CONTROL1			0x0030
+#define R61505_GAMMA_CONTROL2			0x0031
+#define R61505_GAMMA_CONTROL3			0x0032
+#define R61505_GAMMA_CONTROL4			0x0033
+#define R61505_GAMMA_CONTROL5			0x0034
+#define R61505_GAMMA_CONTROL6			0x0035
+#define R61505_GAMMA_CONTROL7			0x0036
+#define R61505_GAMMA_CONTROL8			0x0037
+#define R61505_GAMMA_CONTROL9			0x0038
+#define R61505_GAMMA_CONTROL10			0x0039
+#define R61505_GAMMA_CONTROL11			0x003a
+#define R61505_GAMMA_CONTROL12			0x003b
+#define R61505_GAMMA_CONTROL13			0x003c
+#define R61505_GAMMA_CONTROL14			0x003d
+#define R61505_WINDOW_HORZ_START		0x0050
+#define R61505_WINDOW_HORZ_END			0x0051
+#define R61505_WINDOW_VERT_START		0x0052
+#define R61505_WINDOW_VERT_END			0x0053
+#define R61505_DRIVER_OUTPUT_CONTROL2		0x0060
+#define R61505_DRIVER_OUTPUT_CONTROL2_GS	(1 << 15)
+#define R61505_DRIVER_OUTPUT_CONTROL2_NL(n)	(((n) & 0x3f) << 8)
+#define R61505_DRIVER_OUTPUT_CONTROL2_SCN(n)	(((n) & 0x3f) << 0)
+#define R61505_BASE_IMG_DISPLAY_CONTROL		0x0061
+#define R61505_BASE_IMG_DISPLAY_CONTROL_NDL	(1 << 2)
+#define R61505_BASE_IMG_DISPLAY_CONTROL_VLE	(1 << 1)
+#define R61505_BASE_IMG_DISPLAY_CONTROL_REV	(1 << 0)
+#define R61505_VERTICAL_SCROLL_CONTROL		0x006a
+#define R61505_PANEL_IF_CONTROL1		0x0090
+#define R61505_PANEL_IF_CONTROL1_DIVI(n)	(((n) & 3) << 8)
+#define R61505_PANEL_IF_CONTROL1_RTNI(n)	(((n) & 0x1f) << 0)
+#define R61505_PANEL_IF_CONTROL2		0x0092
+#define R61505_PANEL_IF_CONTROL2_NOWI(n)	(((n) & 7) << 8)
+#define R61505_PANEL_IF_CONTROL3		0x0093
+#define R61505_PANEL_IF_CONTROL3_MCP(n)		(((n) & 7) << 8)
+#define R61505_PANEL_IF_CONTROL4		0x0095
+#define R61505_PANEL_IF_CONTROL5		0x0097
+#define R61505_PANEL_IF_CONTROL6		0x0098
+#define R61505_OSCILLATION_CONTROL		0x00a4
+#define R61505_OSCILLATION_CONTROL_CALB		(1 << 0)
+
+struct r61505 {
+	struct panel panel;
+	struct panel_dbi_device *dbi;
+	const struct panel_r61505_platform_data *pdata;
+};
+
+#define to_panel(p)	container_of(p, struct r61505, panel)
+
+/* -----------------------------------------------------------------------------
+ * Read, write and reset
+ */
+
+/* DB0-DB7 are connected to D1-D8, and DB8-DB15 to D10-D17 */
+
+static unsigned long adjust_reg18(u16 data)
+{
+	return (((data << 1) | 0x00000001) & 0x000001ff) |
+	       (((data << 2) | 0x00000200) & 0x0003fe00);
+}
+
+static void r61505_write_command(struct r61505 *panel, u16 reg)
+{
+	panel_dbi_write_command(panel->dbi, adjust_reg18(reg));
+}
+
+static void r61505_write(struct r61505 *panel, u16 reg, u16 data)
+{
+	panel_dbi_write_command(panel->dbi, adjust_reg18(reg));
+	panel_dbi_write_data(panel->dbi, adjust_reg18(data));
+}
+
+static u16 r61505_read(struct r61505 *panel, u16 reg)
+{
+	unsigned long data;
+
+	panel_dbi_write_command(panel->dbi, adjust_reg18(reg));
+	data = panel_dbi_read_data(panel->dbi);
+
+	return ((data >> 1) & 0xff) | ((data >> 2) & 0xff00);
+}
+
+static void r61505_write_array(struct r61505 *panel,
+				 const u16 *data, unsigned int len)
+{
+	unsigned int i;
+
+	for (i = 0; i < len; i += 2)
+		r61505_write(panel, data[i], data[i + 1]);
+}
+
+static void r61505_reset(struct r61505 *panel)
+{
+	if (panel->pdata->reset < 0)
+		return;
+
+	gpio_set_value(panel->pdata->reset, 0);
+	usleep_range(2000, 2500);
+	gpio_set_value(panel->pdata->reset, 1);
+	usleep_range(1000, 1500);
+}
+
+/* -----------------------------------------------------------------------------
+ * Configuration
+ */
+
+static const unsigned short sync_data[] = {
+	0x0000, 0x0000,
+	0x0000, 0x0000,
+	0x0000, 0x0000,
+	0x0000, 0x0000,
+};
+
+static const unsigned short magic0_data[] = {
+	R61505_DISPLAY_CONTROL2, R61505_DISPLAY_CONTROL2_FP(8) |
+				 R61505_DISPLAY_CONTROL2_BP(8),
+	R61505_PANEL_IF_CONTROL1, R61505_PANEL_IF_CONTROL1_RTNI(26),
+	R61505_DISPLAY_CONTROL1, R61505_DISPLAY_CONTROL1_D0,
+	R61505_POWER_CONTROL6, R61505_POWER_CONTROL6_PSE,
+	0x0019, 0x0000,
+	R61505_POWER_CONTROL1, R61505_POWER_CONTROL1_SAP |
+			       R61505_POWER_CONTROL1_BT(7) |
+			       R61505_POWER_CONTROL1_APE |
+			       R61505_POWER_CONTROL1_AP_100,
+	R61505_POWER_CONTROL2, R61505_POWER_CONTROL2_DC1_FOSC_32 |
+			       R61505_POWER_CONTROL2_DC0_FOSC_2 | 6,
+	R61505_POWER_CONTROL3, R61505_POWER_CONTROL3_VCMR | 0x80 |
+			       R61505_POWER_CONTROL3_PON |
+			       R61505_POWER_CONTROL3_VRH(8),
+	R61505_POWER_CONTROL4, 0x1000 | R61505_POWER_CONTROL4_VDV(4),
+	R61505_POWER_CONTROL7, R61505_POWER_CONTROL7_VCM1(12),
+	R61505_POWER_CONTROL3, R61505_POWER_CONTROL3_VCMR | 0x80 |
+			       R61505_POWER_CONTROL3_PSON |
+			       R61505_POWER_CONTROL3_PON |
+			       R61505_POWER_CONTROL3_VRH(8),
+};
+
+static const unsigned short magic1_data[] = {
+	R61505_GAMMA_CONTROL1, 0x0307,
+	R61505_GAMMA_CONTROL2, 0x0303,
+	R61505_GAMMA_CONTROL3, 0x0603,
+	R61505_GAMMA_CONTROL4, 0x0202,
+	R61505_GAMMA_CONTROL5, 0x0202,
+	R61505_GAMMA_CONTROL6, 0x0202,
+	R61505_GAMMA_CONTROL7, 0x1f1f,
+	R61505_GAMMA_CONTROL8, 0x0303,
+	R61505_GAMMA_CONTROL9, 0x0303,
+	R61505_GAMMA_CONTROL10, 0x0603,
+	R61505_GAMMA_CONTROL11, 0x0202,
+	R61505_GAMMA_CONTROL12, 0x0102,
+	R61505_GAMMA_CONTROL13, 0x0204,
+	R61505_GAMMA_CONTROL14, 0x0000,
+	R61505_DRIVER_OUTPUT_CONTROL, R61505_DRIVER_OUTPUT_CONTROL_SS,
+	R61505_LCD_WAVEFORM, R61505_LCD_WAVEFORM_BC0 |
+			     R61505_LCD_WAVEFORM_EOR,
+	R61505_ENTRY_MODE, R61505_ENTRY_MODE_DFM |
+			   R61505_ENTRY_MODE_BGR |
+			   R61505_ENTRY_MODE_ID1 |
+			   R61505_ENTRY_MODE_AM,
+	R61505_RAM_ADDR_HORZ, 239,
+	R61505_RAM_ADDR_VERT, 0,
+	R61505_RESIZE_CONTROL, R61505_RESIZE_CONTROL_RCV(0) |
+			       R61505_RESIZE_CONTROL_RCH(0) |
+			       R61505_RESIZE_CONTROL_RSZ_1,
+	R61505_DISPLAY_CONTROL3, R61505_DISPLAY_CONTROL3_PTS(0) |
+				 R61505_DISPLAY_CONTROL3_PTG(0) |
+				 R61505_DISPLAY_CONTROL3_ICS(0),
+	R61505_DISPLAY_CONTROL4, R61505_DISPLAY_CONTROL4_FMARKOE |
+				 R61505_DISPLAY_CONTROL4_FMI_1,
+	R61505_EXT_DISPLAY_IF_CONTROL1, R61505_EXT_DISPLAY_IF_CONTROL1_ENC(0) |
+					R61505_EXT_DISPLAY_IF_CONTROL1_DM_ICLK |
+					R61505_EXT_DISPLAY_IF_CONTROL1_RIM_18,
+	R61505_FRAME_MARKER_CONTROL, R61505_FRAME_MARKER_CONTROL_FMP(0),
+	R61505_POWER_CONTROL5, 0x8000,
+};
+
+static const unsigned short magic2_data[] = {
+	R61505_BASE_IMG_DISPLAY_CONTROL, R61505_BASE_IMG_DISPLAY_CONTROL_REV,
+	R61505_PANEL_IF_CONTROL2, R61505_PANEL_IF_CONTROL2_NOWI(1),
+	R61505_PANEL_IF_CONTROL3, R61505_PANEL_IF_CONTROL3_MCP(1),
+	R61505_DISPLAY_CONTROL1, R61505_DISPLAY_CONTROL1_GON |
+				 R61505_DISPLAY_CONTROL1_D0,
+};
+
+static const unsigned short magic3_data[] = {
+	R61505_POWER_CONTROL1, R61505_POWER_CONTROL1_SAP |
+			       R61505_POWER_CONTROL1_BT(6) |
+			       R61505_POWER_CONTROL1_APE |
+			       R61505_POWER_CONTROL1_AP_100,
+	R61505_POWER_CONTROL2, R61505_POWER_CONTROL2_DC1_FOSC_32 |
+			       R61505_POWER_CONTROL2_DC0_FOSC_2 |
+			       R61505_POWER_CONTROL2_VC_089,
+	R61505_DISPLAY_CONTROL1, R61505_DISPLAY_CONTROL1_VON |
+				 R61505_DISPLAY_CONTROL1_GON |
+				 R61505_DISPLAY_CONTROL1_D0,
+};
+
+static void r61505_enable_panel(struct r61505 *panel)
+{
+	unsigned long xres = panel->pdata->mode->xres;
+	unsigned long yres = panel->pdata->mode->yres;
+	unsigned int i;
+
+	r61505_write_array(panel, sync_data, ARRAY_SIZE(sync_data));
+
+	r61505_write(panel, R61505_OSCILLATION_CONTROL,
+		     R61505_OSCILLATION_CONTROL_CALB);
+	usleep_range(10000, 11000);
+
+	r61505_write(panel, R61505_DRIVER_OUTPUT_CONTROL2,
+		     R61505_DRIVER_OUTPUT_CONTROL2_NL((xres / 8) - 1));
+	r61505_write_array(panel, magic0_data, ARRAY_SIZE(magic0_data));
+	usleep_range(100000, 101000);
+
+	r61505_write_array(panel, magic1_data, ARRAY_SIZE(magic1_data));
+
+	r61505_write(panel, R61505_WINDOW_HORZ_START, 239 - (yres - 1));
+	r61505_write(panel, R61505_WINDOW_HORZ_END, 239);
+	r61505_write(panel, R61505_WINDOW_VERT_START, 0);
+	r61505_write(panel, R61505_WINDOW_VERT_END, xres - 1);
+
+	r61505_write_array(panel, magic2_data, ARRAY_SIZE(magic2_data));
+	usleep_range(10000, 11000);
+
+	r61505_write_array(panel, magic3_data, ARRAY_SIZE(magic3_data));
+	usleep_range(40000, 41000);
+
+	/* Clear GRAM to avoid displaying garbage. */
+	r61505_write(panel, R61505_RAM_ADDR_HORZ, 0);
+	r61505_write(panel, R61505_RAM_ADDR_VERT, 0);
+
+	for (i = 0; i < (xres * 256); i++) /* yes, 256 words per line */
+		r61505_write(panel, R61505_RAM_DATA, 0);
+
+	r61505_write(panel, R61505_RAM_ADDR_HORZ, 0);
+	r61505_write(panel, R61505_RAM_ADDR_VERT, 0);
+}
+
+static void r61505_disable_panel(struct r61505 *panel)
+{
+	r61505_reset(panel);
+}
+
+static void r61505_display_on(struct r61505 *panel)
+{
+	r61505_write(panel, R61505_DISPLAY_CONTROL1,
+		     R61505_DISPLAY_CONTROL1_BASEE |
+		     R61505_DISPLAY_CONTROL1_VON |
+		     R61505_DISPLAY_CONTROL1_GON |
+		     R61505_DISPLAY_CONTROL1_DTE |
+		     R61505_DISPLAY_CONTROL1_D1 |
+		     R61505_DISPLAY_CONTROL1_D0);
+	usleep_range(40000, 41000);
+}
+
+static void r61505_display_off(struct r61505 *panel)
+{
+	r61505_write(panel, R61505_DISPLAY_CONTROL1,
+		     R61505_DISPLAY_CONTROL1_VON |
+		     R61505_DISPLAY_CONTROL1_GON |
+		     R61505_DISPLAY_CONTROL1_D0);
+}
+
+/* -----------------------------------------------------------------------------
+ * Panel operations
+ */
+
+static int r61505_enable(struct panel *p, enum panel_enable_mode enable)
+{
+	struct r61505 *panel = to_panel(p);
+
+	switch (enable) {
+	case PANEL_ENABLE_OFF:
+		r61505_disable_panel(panel);
+		break;
+
+	case PANEL_ENABLE_BLANK:
+		if (p->enable == PANEL_ENABLE_OFF)
+			r61505_enable_panel(panel);
+		else
+			r61505_display_off(panel);
+		break;
+
+	case PANEL_ENABLE_ON:
+		if (p->enable == PANEL_ENABLE_OFF)
+			r61505_enable_panel(panel);
+
+		r61505_display_on(panel);
+		break;
+	}
+
+	return 0;
+}
+
+static int r61505_start_transfer(struct panel *p)
+{
+	struct r61505 *panel = to_panel(p);
+
+	r61505_write_command(panel, R61505_RAM_DATA);
+	usleep_range(100000, 101000);
+
+	return 0;
+}
+
+static int r61505_get_modes(struct panel *p, const struct fb_videomode **modes)
+{
+	struct r61505 *panel = to_panel(p);
+
+	*modes = panel->pdata->mode;
+	return 1;
+}
+
+static const struct panel_ops r61505_ops = {
+	.enable = r61505_enable,
+	.start_transfer = r61505_start_transfer,
+	.get_modes = r61505_get_modes,
+};
+
+static void r61505_release(struct panel *p)
+{
+	struct r61505 *panel = to_panel(p);
+
+	kfree(panel);
+}
+
+static int r61505_remove(struct panel_dbi_device *dev)
+{
+	struct r61505 *panel = panel_dbi_get_drvdata(dev);
+
+	panel_dbi_set_drvdata(dev, NULL);
+	panel_unregister(&panel->panel);
+
+	return 0;
+}
+
+static int __devinit r61505_probe(struct panel_dbi_device *dev)
+{
+	const struct panel_r61505_platform_data *pdata = dev->dev.platform_data;
+	struct r61505 *panel;
+	int ret;
+
+	if (pdata == NULL)
+		return -ENODEV;
+
+	panel = kzalloc(sizeof(*panel), GFP_KERNEL);
+	if (panel == NULL)
+		return -ENOMEM;
+
+	panel->pdata = pdata;
+	panel->dbi = dev;
+
+	r61505_reset(panel);
+	r61505_write_array(panel, sync_data, ARRAY_SIZE(sync_data));
+
+	if (r61505_read(panel, 0) != R61505_DEVICE_CODE_VALUE) {
+		kfree(panel);
+		return -ENODEV;
+	}
+
+	panel->panel.dev = &dev->dev;
+	panel->panel.release = r61505_release;
+	panel->panel.ops = &r61505_ops;
+	panel->panel.width = pdata->width;
+	panel->panel.height = pdata->height;
+
+	ret = panel_register(&panel->panel);
+	if (ret < 0) {
+		kfree(panel);
+		return ret;
+	}
+
+	panel_dbi_set_drvdata(dev, panel);
+
+	return 0;
+}
+
+static const struct dev_pm_ops r61505_dev_pm_ops = {
+};
+
+static struct panel_dbi_driver r61505_driver = {
+	.probe = r61505_probe,
+	.remove = r61505_remove,
+	.driver = {
+		.name = "panel_r61505",
+		.owner = THIS_MODULE,
+		.pm = &r61505_dev_pm_ops,
+	},
+};
+
+module_panel_dbi_driver(r61505_driver);
+
+MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
+MODULE_DESCRIPTION("Renesas R61505-based Display Panel");
+MODULE_LICENSE("GPL");
diff --git a/include/video/panel-r61505.h b/include/video/panel-r61505.h
new file mode 100644
index 0000000..90b3d62
--- /dev/null
+++ b/include/video/panel-r61505.h
@@ -0,0 +1,27 @@
+/*
+ * Renesas R61505-based Display Panels
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __PANEL_R61505_H__
+#define __PANEL_R61505_H__
+
+#include <linux/fb.h>
+#include <video/panel.h>
+
+struct panel_r61505_platform_data {
+	unsigned long width;		/* Panel width in mm */
+	unsigned long height;		/* Panel height in mm */
+	const struct fb_videomode *mode;
+
+	int reset;			/* Reset GPIO */
+};
+
+#endif /* __PANEL_R61505_H__ */
-- 
1.7.8.6

