Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:41570 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932071AbZKJVua (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 16:50:30 -0500
From: santiago.nunez@ridgerun.com
To: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-media@vger.kernel.org, nsnehaprabha@ti.com,
	m-karicheri2@ti.com, diego.dompe@ridgerun.com,
	todd.fischer@ridgerun.com, mgrosen@ti.com,
	Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
Date: Tue, 10 Nov 2009 15:50:36 -0600
Message-Id: <1257889836-19208-1-git-send-email-santiago.nunez@ridgerun.com>
Subject: [PATCH 3/4 v7] TVP7002 driver for DM365
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>

This patch provides the implementation of the TVP7002 decoder
driver for DM365. Implemented using the V4L2 DV presets API.

Signed-off-by: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
---
 drivers/media/video/tvp7002.c | 1475 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 1475 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/tvp7002.c

diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
new file mode 100644
index 0000000..a43cb84
--- /dev/null
+++ b/drivers/media/video/tvp7002.c
@@ -0,0 +1,1475 @@
+/* Texas Instruments Triple 8-/10-BIT 165-/110-MSPS Video and Graphics
+ * Digitizer with Horizontal PLL registers
+ *
+ * Copyright (C) 2009 Texas Instruments Inc
+ * Author: Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>
+ *
+ * This code is partially based upon the TVP5150 driver
+ * written by Mauro Carvalho Chehab (mchehab@infradead.org),
+ * the TVP514x driver written by Vaibhav Hiremath <hvaibhav@ti.com>
+ * and the TVP7002 driver in the TI LSP 2.10.00.14. Revisions by
+ * Muralidharan Karicheri and Snehaprabha Narnakaje (TI).
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
+#include <media/tvp7002.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include "tvp7002_reg.h"
+
+MODULE_DESCRIPTION("TI TVP7002 Video and Graphics Digitizer driver");
+MODULE_AUTHOR("Santiago Nunez-Corrales <santiago.nunez@ridgerun.com>");
+MODULE_LICENSE("GPL");
+
+/* Module Name */
+#define TVP7002_MODULE_NAME		"tvp7002"
+
+/* I2C retry attempts */
+#define I2C_RETRY_COUNT			(5)
+
+/* End of registers */
+#define TVP7002_EOR			0x5c
+
+/* Read write definition for registers */
+#define TVP7002_READ			0
+#define TVP7002_WRITE			1
+#define TVP7002_RESERVED		2
+
+/* Total frame lines information */
+#define TVP7002_LINES_720       0x2EE
+#define TVP7002_LINES_1080   	0x465
+
+/* Clocks per line assuming 6.5 MHz internal clock +- 6% */
+#define TVP7002_CPL_1080P_60_LOWER	90
+#define TVP7002_CPL_1080P_60_UPPER	102
+#define TVP7002_CPL_1080_60_LOWER	181
+#define TVP7002_CPL_1080_60_UPPER	205
+#define TVP7002_CPL_1080_50_LOWER	217
+#define TVP7002_CPL_1080_50_UPPER	245
+#define TVP7002_CPL_720P_50_LOWER	163
+#define TVP7002_CPL_720P_50_UPPER	183
+#define TVP7002_CPL_720P_60_LOWER	135
+#define TVP7002_CPL_720P_60_UPPER	153
+
+#define INTERLACED_VIDEO		0
+#define PROGRESSIVE_VIDEO		1
+
+/* Indexes for digital video presets */
+#define INDEX_720P60		0
+#define INDEX_1080I60		1
+#define INDEX_1080I50		2
+#define INDEX_720P50		3
+#define INDEX_1080P60		4
+#define INDEX_480P59_94		5
+#define INDEX_576P50		6
+
+/* Number of pixels and number of lines per frame for different standards */
+#define NTSC_NUM_ACTIVE_PIXELS          (720)
+#define NTSC_NUM_ACTIVE_LINES           (480)
+#define PAL_NUM_ACTIVE_PIXELS           (720)
+#define PAL_NUM_ACTIVE_LINES            (576)
+#define HD_720_NUM_ACTIVE_PIXELS        (1280)
+#define HD_720_NUM_ACTIVE_LINES         (720)
+#define HD_1080_NUM_ACTIVE_PIXELS       (1920)
+#define HD_1080_NUM_ACTIVE_LINES        (1080)
+
+/* Interlaced vs progressive mask and shift */
+#define TVP7002_IP_SHIFT		5
+#define TVP7002_INPR_MASK		(0x01 << TVP7002_IP_SHIFT)
+
+/* Shift for CPL and LPF registers */
+#define TVP7002_CL_SHIFT		8
+#define TVP7002_CL_MASK			0x0f
+
+/* Debug functions */
+static int debug;
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Debug level (0-2)");
+
+/* Structure for register values */
+struct i2c_reg_value {
+	u8 reg;
+	u8 value;
+	u8 type;
+};
+
+/*
+ * Register default values (according to tvp7002 datasheet)
+ * In the case of read-only registers, the value (0xff) is
+ * never written. R/W functionality is controlled by the
+ * writable bit in the register struct definition.
+ */
+static const struct i2c_reg_value tvp7002_init_default[] = {
+	{ TVP7002_CHIP_REV, 0xff, TVP7002_READ },
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x67, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x20, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0xa0, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x80, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
+	{ TVP7002_HSYNC_OUT_W, 0x60, TVP7002_WRITE },
+	{ TVP7002_B_FINE_GAIN, 0x00, TVP7002_WRITE },
+	{ TVP7002_G_FINE_GAIN, 0x00, TVP7002_WRITE },
+	{ TVP7002_R_FINE_GAIN, 0x00, TVP7002_WRITE },
+	{ TVP7002_B_FINE_OFF_MSBS, 0x80, TVP7002_WRITE },
+	{ TVP7002_G_FINE_OFF_MSBS, 0x80, TVP7002_WRITE },
+	{ TVP7002_R_FINE_OFF_MSBS, 0x80, TVP7002_WRITE },
+	{ TVP7002_SYNC_CTL_1, 0x20, TVP7002_WRITE },
+	{ TVP7002_HPLL_AND_CLAMP_CTL, 0x2e, TVP7002_WRITE },
+	{ TVP7002_SYNC_ON_G_THRS, 0x5d, TVP7002_WRITE },
+	{ TVP7002_SYNC_SEPARATOR_THRS, 0x47, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_SYNC_DETECT_STAT, 0xff, TVP7002_READ },
+	{ TVP7002_OUT_FORMATTER, 0x47, TVP7002_WRITE },
+	{ TVP7002_MISC_CTL_1, 0x01, TVP7002_WRITE },
+	{ TVP7002_MISC_CTL_2, 0x00, TVP7002_WRITE },
+	{ TVP7002_MISC_CTL_3, 0x01, TVP7002_WRITE },
+	{ TVP7002_IN_MUX_SEL_1, 0x00, TVP7002_WRITE },
+	{ TVP7002_IN_MUX_SEL_2, 0x67, TVP7002_WRITE },
+	{ TVP7002_B_AND_G_COARSE_GAIN, 0x77, TVP7002_WRITE },
+	{ TVP7002_R_COARSE_GAIN, 0x07, TVP7002_WRITE },
+	{ TVP7002_FINE_OFF_LSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_B_COARSE_OFF, 0x10, TVP7002_WRITE },
+	{ TVP7002_G_COARSE_OFF, 0x10, TVP7002_WRITE },
+	{ TVP7002_R_COARSE_OFF, 0x10, TVP7002_WRITE },
+	{ TVP7002_HSOUT_OUT_START, 0x08, TVP7002_WRITE },
+	{ TVP7002_MISC_CTL_4, 0x00, TVP7002_WRITE },
+	{ TVP7002_B_DGTL_ALC_OUT_LSBS, 0xff, TVP7002_READ },
+	{ TVP7002_G_DGTL_ALC_OUT_LSBS, 0xff, TVP7002_READ },
+	{ TVP7002_R_DGTL_ALC_OUT_LSBS, 0xff, TVP7002_READ },
+	{ TVP7002_AUTO_LVL_CTL_ENABLE, 0x80, TVP7002_WRITE },
+	{ TVP7002_DGTL_ALC_OUT_MSBS, 0xff, TVP7002_READ },
+	{ TVP7002_AUTO_LVL_CTL_FILTER, 0x53, TVP7002_WRITE },
+	{ 0x29, 0x08, TVP7002_RESERVED },
+	{ TVP7002_FINE_CLAMP_CTL, 0x07, TVP7002_WRITE },
+	/* PWR_CTL is controlled only by the probe and reset functions */
+	{ TVP7002_PWR_CTL, 0x00, TVP7002_RESERVED },
+	{ TVP7002_ADC_SETUP, 0x50, TVP7002_WRITE },
+	{ TVP7002_COARSE_CLAMP_CTL, 0x00, TVP7002_WRITE },
+	{ TVP7002_SOG_CLAMP, 0x80, TVP7002_WRITE },
+	{ TVP7002_RGB_COARSE_CLAMP_CTL, 0x00, TVP7002_WRITE },
+	{ TVP7002_SOG_COARSE_CLAMP_CTL, 0x04, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
+	{ 0x32, 0x18, TVP7002_RESERVED },
+	{ 0x33, 0x60, TVP7002_RESERVED },
+	{ TVP7002_MVIS_STRIPPER_W, 0xff, TVP7002_RESERVED },
+	{ TVP7002_VSYNC_ALGN, 0x10, TVP7002_WRITE },
+	{ TVP7002_SYNC_BYPASS, 0x00, TVP7002_WRITE },
+	{ TVP7002_L_FRAME_STAT_LSBS, 0xff, TVP7002_READ },
+	{ TVP7002_L_FRAME_STAT_MSBS, 0xff, TVP7002_READ },
+	{ TVP7002_CLK_L_STAT_LSBS, 0xff, TVP7002_READ },
+	{ TVP7002_CLK_L_STAT_MSBS, 0xff, TVP7002_READ },
+	{ TVP7002_HSYNC_W, 0xff, TVP7002_READ },
+	{ TVP7002_VSYNC_W, 0xff, TVP7002_READ },
+	{ TVP7002_L_LENGTH_TOL, 0x03, TVP7002_WRITE },
+	{ 0x3e, 0x60, TVP7002_RESERVED },
+	{ TVP7002_VIDEO_BWTH_CTL, 0x01, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x01, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x2c, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x06, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x2c, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x05, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x1e, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
+	{ TVP7002_FBIT_F_0_START_L_OFF, 0x00, TVP7002_WRITE },
+	{ TVP7002_FBIT_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
+	{ TVP7002_YUV_Y_G_COEF_LSBS, 0xe3, TVP7002_WRITE },
+	{ TVP7002_YUV_Y_G_COEF_MSBS, 0x16, TVP7002_WRITE },
+	{ TVP7002_YUV_Y_B_COEF_LSBS, 0x4f, TVP7002_WRITE },
+	{ TVP7002_YUV_Y_B_COEF_MSBS, 0x02, TVP7002_WRITE },
+	{ TVP7002_YUV_Y_R_COEF_LSBS, 0xce, TVP7002_WRITE },
+	{ TVP7002_YUV_Y_R_COEF_MSBS, 0x06, TVP7002_WRITE },
+	{ TVP7002_YUV_U_G_COEF_LSBS, 0xab, TVP7002_WRITE },
+	{ TVP7002_YUV_U_G_COEF_MSBS, 0xf3, TVP7002_WRITE },
+	{ TVP7002_YUV_U_B_COEF_LSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_YUV_U_B_COEF_MSBS, 0x10, TVP7002_WRITE },
+	{ TVP7002_YUV_U_R_COEF_LSBS, 0x55, TVP7002_WRITE },
+	{ TVP7002_YUV_U_R_COEF_MSBS, 0xfc, TVP7002_WRITE },
+	{ TVP7002_YUV_V_G_COEF_LSBS, 0x78, TVP7002_WRITE },
+	{ TVP7002_YUV_V_G_COEF_MSBS, 0xf1, TVP7002_WRITE },
+	{ TVP7002_YUV_V_B_COEF_LSBS, 0x88, TVP7002_WRITE },
+	{ TVP7002_YUV_V_B_COEF_MSBS, 0xfe, TVP7002_WRITE },
+	{ TVP7002_YUV_V_R_COEF_LSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_YUV_V_R_COEF_MSBS, 0x10, TVP7002_WRITE },
+	/* This signals end of register values */
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Register parameters for 480P */
+static const struct i2c_reg_value tvp7002_parms_480P[] = {
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x35, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x0a, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0x02, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x91, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x0B, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x03, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x01, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x13, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x13, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x18, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x06, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x10, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x03, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x03, TVP7002_WRITE },
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Register parameters for 576P */
+static const struct i2c_reg_value tvp7002_parms_576P[] = {
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x36, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0x18, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x9B, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x0F, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x00, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x2D, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x18, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x06, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x10, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x03, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x03, TVP7002_WRITE },
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Register parameters for 1080I60 */
+static const struct i2c_reg_value tvp7002_parms_1080I60[] = {
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x08, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x08, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x02, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x02, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x16, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x17, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x01, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Register parameters for 1080P60 */
+static const struct i2c_reg_value tvp7002_parms_1080P60[] = {
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x89, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x08, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0xE0, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x08, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x02, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x02, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x16, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x17, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x01, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Register parameters for 1080I50 */
+static const struct i2c_reg_value tvp7002_parms_1080I50[] = {
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0xa5, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x00, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x14, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x06, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x8a, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x08, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x02, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x02, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x16, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x17, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x01, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Register parameters for 720P60 */
+static const struct i2c_reg_value tvp7002_parms_720P60[] = {
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x67, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x02, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0xa0, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x4B, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x06, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x05, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x2D, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Register parameters for 720P50 */
+static const struct i2c_reg_value tvp7002_parms_720P50[] = {
+	{ TVP7002_HPLL_FDBK_DIV_MSBS, 0x7b, TVP7002_WRITE },
+	{ TVP7002_HPLL_FDBK_DIV_LSBS, 0x0c, TVP7002_WRITE },
+	{ TVP7002_HPLL_CRTL, 0x98, TVP7002_WRITE },
+	{ TVP7002_HPLL_PHASE_SEL, 0x16, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_LSBS, 0x47, TVP7002_WRITE },
+	{ TVP7002_AVID_START_PIXEL_MSBS, 0x01, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_LSBS, 0x4B, TVP7002_WRITE },
+	{ TVP7002_AVID_STOP_PIXEL_MSBS, 0x06, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_START_L_OFF, 0x05, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_START_L_OFF, 0x00, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_0_DURATION, 0x2D, TVP7002_WRITE },
+	{ TVP7002_VBLK_F_1_DURATION, 0x00, TVP7002_WRITE },
+	{ TVP7002_ALC_PLACEMENT, 0x5a, TVP7002_WRITE },
+	{ TVP7002_CLAMP_START, 0x32, TVP7002_WRITE },
+	{ TVP7002_CLAMP_W, 0x20, TVP7002_WRITE },
+	{ TVP7002_HPLL_PRE_COAST, 0x01, TVP7002_WRITE },
+	{ TVP7002_HPLL_POST_COAST, 0x00, TVP7002_WRITE },
+	{ TVP7002_EOR, 0xff, TVP7002_RESERVED }
+};
+
+/* Struct list for available formats */
+static const struct v4l2_fmtdesc tvp7002_fmt_list[] = {
+	{
+	 .index = 0,
+	 .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	 .flags = 0,
+	 .description = "8-bit UYVY 4:2:2 Format",
+	 .pixelformat = V4L2_PIX_FMT_UYVY,
+	},
+};
+
+#define NUM_FORMATS		ARRAY_SIZE(tvp7002_fmt_list)
+
+/* Struct list for digital video presents */
+static const struct v4l2_dv_enum_preset tvp7002_presets[] = {
+	{
+		.index = INDEX_720P60,
+		.preset = V4L2_DV_720P60,
+		.name = "720P-60",
+		.width = 1280,
+		.height = 720,
+	},
+	{
+		.index = INDEX_1080I60,
+		.preset = V4L2_DV_1080I60,
+		.name = "1080I-30",
+		.width = 1920,
+		.height = 1080,
+	},
+	{
+		.index = INDEX_1080I50,
+		.preset = V4L2_DV_1080I50,
+		.name = "1080I-25",
+		.width = 1920,
+		.height = 1080,
+	},
+	{
+		.index = INDEX_720P50,
+		.preset = V4L2_DV_720P50,
+		.name = "720P-50",
+		.width = 1280,
+		.height = 720,
+	},
+	{
+		.index = INDEX_1080P60,
+		.preset = V4L2_DV_1080P60,
+		.name = "1080P-60",
+		.width = 1920,
+		.height = 1080,
+	},
+	{
+		.index = INDEX_480P59_94,
+		.preset = V4L2_DV_480P59_94,
+		.name = "480P-60",
+		.width = 720,
+		.height = 480,
+	},
+	{
+		.index = INDEX_576P50,
+		.preset = V4L2_DV_576P50,
+		.name = "576P-50",
+		.width = 720,
+		.height = 576,
+	},
+};
+
+#define NUM_PRESETS		ARRAY_SIZE(tvp7002_presets)
+
+/* Device definition */
+struct tvp7002 {
+	struct v4l2_subdev sd;
+	const struct tvp7002_config *pdata;
+	struct i2c_reg_value registers[ARRAY_SIZE(tvp7002_init_default)];
+
+	int ver;
+	int streaming;
+
+	struct v4l2_pix_format pix;
+	int current_preset;
+
+};
+
+/*
+ * to_tvp7002 - Obtain device handler TVP7002
+ * @sd: ptr to v4l2_subdev struct
+ *
+ * Returns device handler tvp7002.
+ */
+static inline struct tvp7002 *to_tvp7002(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tvp7002, sd);
+}
+
+/*
+ * tvp7002_read - Read a value from a register in an TVP7002
+ * @sd: ptr to v4l2_subdev struct
+ * @reg: TVP7002 register address
+ * @dst: pointer to 8-bit destination
+ *
+ * Returns value read if successful, or non-zero (-1) otherwise.
+ */
+static int tvp7002_read(struct v4l2_subdev *sd, u8 addr, u8 *dst)
+{
+	struct i2c_client *c = v4l2_get_subdevdata(sd);
+	int retry;
+	int error;
+
+	for (retry = 0; retry < I2C_RETRY_COUNT; retry++) {
+		error = i2c_smbus_read_byte_data(c, addr);
+
+		if (error >= 0) {
+			*dst = (u8)error;
+			return 0;
+		}
+
+		msleep_interruptible(10);
+	}
+	v4l2_err(sd, "TVP7002 read error %d\n", error);
+	return error;
+}
+
+/*
+ * tvp7002_read_err() - Read a register value with error code
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @reg: destination register
+ * @val: value to be read
+ * @error: pointer to error value
+ *
+ * Read a value in a register and save error value in pointer.
+ * Also update the register table if successful
+ */
+static inline void tvp7002_read_err(struct v4l2_subdev *sd, u8 reg,
+							u8 *dst, int *err)
+{
+	if (!*err)
+		*err = tvp7002_read(sd, reg, dst);
+}
+
+/*
+ * tvp7002_write() - Write a value to a register in TVP7002
+ * @sd: ptr to v4l2_subdev struct
+ * @addr: TVP7002 register address
+ * @value: value to be written to the register
+ *
+ * Write a value to a register in an TVP7002 decoder device.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+static int tvp7002_write(struct v4l2_subdev *sd, u8 addr, u8 value)
+{
+	struct i2c_client *c;
+	int retry;
+	int error;
+
+	c = v4l2_get_subdevdata(sd);
+
+	for (retry = 0; retry < I2C_RETRY_COUNT; retry++) {
+		error = i2c_smbus_write_byte_data(c, addr, value);
+
+		if (error >= 0)
+			return 0;
+
+		v4l2_warn(sd, "Write: retry ... %d\n", retry);
+		msleep_interruptible(10);
+	}
+	v4l2_err(sd, "TVP7002 write error %d\n", error);
+	return error;
+}
+
+/*
+ * tvp7002_write_err() - Write a register value with error code
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @reg: destination register
+ * @val: value to be written
+ * @error: pointer to error value
+ *
+ * Write a value in a register and save error value in pointer.
+ * Also update the register table if successful
+ */
+static inline void tvp7002_write_err(struct v4l2_subdev *sd, u8 reg,
+							u8 val, int *err)
+{
+	if (!*err)
+		*err = tvp7002_write(sd, reg, val);
+}
+
+/*
+ * tvp7002_g_chip_ident() - Get chip identification number
+ * @sd: ptr to v4l2_subdev struct
+ * @chip: ptr to v4l2_dbg_chip_ident struct
+ *
+ * Obtains the chip's identification number.
+ * Returns zero or -EINVAL if read operation fails.
+ */
+static int tvp7002_g_chip_ident(struct v4l2_subdev *sd,
+					struct v4l2_dbg_chip_ident *chip)
+{
+	u8 rev;
+	int error;
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	error = tvp7002_read(sd, TVP7002_CHIP_REV, &rev);
+
+	if (error < 0)
+		return error;
+
+	return v4l2_chip_ident_i2c_client(client, chip, V4L2_IDENT_TVP7002,
+									rev);
+}
+
+/*
+ * tvp7002_write_inittab() - Write initialization values
+ * @sd: ptr to v4l2_subdev struct
+ * @regs: ptr to i2c_reg_value struct
+ *
+ * Write initialization values.
+ * Returns zero or -EINVAL if read operation fails.
+ */
+static int tvp7002_write_inittab(struct v4l2_subdev *sd,
+					const struct i2c_reg_value *regs)
+{
+	int error = 0;
+
+	/* Initialize the first (defined) registers */
+	while (TVP7002_EOR != regs->reg) {
+		if (TVP7002_WRITE == regs->type)
+			tvp7002_write_err(sd, regs->reg, regs->value, &error);
+		regs++;
+	}
+
+	return error;
+}
+
+/*
+ * tvp7002_update_dev_tab() - Update device's register table
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @tab: pointer to device table
+ *
+ * Update state information in the device's register table.
+ * Returns 0 on success or -EINVAL on error.
+ */
+static int tvp7002_update_dev_tab(struct v4l2_subdev *sd,
+					const struct i2c_reg_value *regs)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+
+	if (!regs)
+		return -EINVAL;
+
+	while (TVP7002_EOR != regs->reg) {
+		device->registers[regs->reg].value = regs->value;
+		regs++;
+	}
+
+	return 0;
+}
+
+/*
+ * tvp7002_set_fmt_parms() - Write parameters to set video mode
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @regs: pointer to register table
+ *
+ * Set video mode register-dependent parameters
+ * Returns 0 on success or -EINVAL on error.
+ */
+static int tvp7002_set_fmt_parms(struct v4l2_subdev *sd,
+						const struct i2c_reg_value *regs){
+	int error;
+
+	v4l2_dbg(1, debug, sd, "Setting format parameters...\n");
+
+	if (regs == NULL) {
+		v4l2_dbg(1, debug, sd, "Parameter reference is NULL.\n");
+		return -EINVAL;
+	}
+
+	error = tvp7002_write_inittab(sd, regs);
+
+	if (error < 0) {
+		v4l2_dbg(1, debug, sd, "Error in setting video parameters\n");
+		return error;
+	}
+
+	/* Update our device device information */
+	return tvp7002_update_dev_tab(sd, regs);
+}
+
+/*
+ * tvp7002_map_set_preset() - Map and set video preset to register parameters
+ * @std: v4l2_std_id (u64) integer
+ *
+ * Returns 0 if successful or -EINVAL on error.
+ */
+static int tvp7002_map_set_preset(struct v4l2_subdev *sd, u32 preset)
+{
+	switch (preset) {
+	case V4L2_DV_480P59_94:
+		return tvp7002_set_fmt_parms(sd, tvp7002_parms_480P);
+	case V4L2_DV_576P50:
+		return tvp7002_set_fmt_parms(sd, tvp7002_parms_576P);
+	case V4L2_DV_720P50:
+		return tvp7002_set_fmt_parms(sd, tvp7002_parms_720P50);
+	case V4L2_DV_720P60:
+		return tvp7002_set_fmt_parms(sd, tvp7002_parms_720P60);
+	case V4L2_DV_1080I50:
+		return tvp7002_set_fmt_parms(sd, tvp7002_parms_1080I50);
+	case V4L2_DV_1080I60:
+		return tvp7002_set_fmt_parms(sd, tvp7002_parms_1080I60);
+	case V4L2_DV_1080P60:
+		return tvp7002_set_fmt_parms(sd, tvp7002_parms_1080P60);
+	default:
+		return -EINVAL;
+	}
+}
+
+/*
+ * tvp7002_s_dv_preset() - Set digital video preset
+ * @sd: ptr to v4l2_subdev struct
+ * @std: id of the standard to be set
+ *
+ * Set the digital video preset for a TVP7002 decoder device.
+ * Returns zero when successful or -EINVAL if register access fails.
+ */
+static int tvp7002_s_dv_preset(struct v4l2_subdev *sd,
+					struct v4l2_dv_preset *dv_preset)
+{
+	struct v4l2_dv_enum_preset *preset;
+	int i;
+
+	for (i = 0; i < NUM_PRESETS; i++) {
+		preset = &tvp7002_presets[i];
+		if (preset->preset == dv_preset->preset)
+			break;
+	}
+
+	if (i == NUM_PRESETS)
+		return -EINVAL;
+
+	return tvp7002_map_set_preset(sd, preset->preset);
+}
+
+/*
+ * tvp7002_g_ctrl() - Get a control
+ * @sd: ptr to v4l2_subdev struct
+ * @ctrl: ptr to v4l2_control struct
+ *
+ * Get a control for a TVP7002 decoder device.
+ * Returns zero when successful or -EINVAL if register access fails.
+ */
+static int tvp7002_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	int error = 0;
+	u8 rval;
+	u8 gval;
+	u8 bval;
+
+	switch (ctrl->id) {
+	case V4L2_CID_GAIN:
+		tvp7002_read_err(sd, TVP7002_R_FINE_GAIN, &rval, &error);
+		tvp7002_read_err(sd, TVP7002_G_FINE_GAIN, &gval, &error);
+		tvp7002_read_err(sd, TVP7002_B_FINE_GAIN, &bval, &error);
+
+		if (error < 0)
+			return -EINVAL;
+
+		if (rval != gval || rval != bval)
+			return -EINVAL;
+
+		ctrl->value = rval & 0x0F;
+		return 0;
+
+		break;
+	default:
+		return -EINVAL;
+	}
+}
+
+/*
+ * tvp7002_s_ctrl() - Set a control
+ * @sd: ptr to v4l2_subdev struct
+ * @ctrl: ptr to v4l2_control struct
+ *
+ * Set a control in TVP7002 decoder device.
+ * Returns zero when successful or -EINVAL if register access fails.
+ */
+static int tvp7002_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	int error = 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_GAIN:
+		tvp7002_write_err(sd, TVP7002_R_FINE_GAIN,
+								ctrl->value & 0xff, &error);
+		tvp7002_write_err(sd, TVP7002_G_FINE_GAIN,
+								ctrl->value & 0xff, &error);
+		tvp7002_write_err(sd, TVP7002_B_FINE_GAIN,
+								ctrl->value & 0xff, &error);
+
+		if (error < 0)
+			return -EINVAL;
+
+		device->registers[TVP7002_R_FINE_GAIN].value = ctrl->value;
+		device->registers[TVP7002_G_FINE_GAIN].value = ctrl->value;
+		device->registers[TVP7002_B_FINE_GAIN].value = ctrl->value;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+/*
+ * tvp7002_queryctrl() - Query a control
+ * @sd: ptr to v4l2_subdev struct
+ * @ctrl: ptr to v4l2_queryctrl struct
+ *
+ * Query a control of a TVP7002 decoder device.
+ * Returns zero when successful or -EINVAL if register read fails.
+ */
+static int tvp7002_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
+{
+	switch (qc->id) {
+	case V4L2_CID_GAIN:
+		/*
+		 * Gain is supported [0-255, default=0, step=1]
+		 */
+		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 0);
+	default:
+		return -EINVAL;
+	}
+}
+
+/*
+ * tvp7002_colorspace - Find the color space of a video format
+ * @std: v4l2_std_id (u64) integer
+ *
+ * Returns color space for a standard id
+ */
+static inline enum v4l2_colorspace tvp7002_colorspace(int preset)
+{
+	switch (preset) {
+	case INDEX_480P59_94:
+	case INDEX_576P50:
+		return V4L2_COLORSPACE_SMPTE170M;
+	case INDEX_720P50:
+	case INDEX_720P60:
+	case INDEX_1080I50:
+	case INDEX_1080I60:
+	case INDEX_1080P60:
+		return V4L2_COLORSPACE_REC709;
+	default:
+		return 0;
+	}
+}
+
+/*
+ * tvp7002_scanmode - Find the scan mode of a video format
+ * @std: v4l2_std_id (u64) integer
+ *
+ * Returns color space for a standard id
+ */
+static inline enum v4l2_field tvp7002_scanmode(v4l2_std_id std)
+{
+	switch (std) {
+	case INDEX_480P59_94:
+	case INDEX_576P50:
+	case INDEX_720P50:
+	case INDEX_720P60:
+	case INDEX_1080P60:
+		return V4L2_FIELD_SEQ_TB;
+	case INDEX_1080I50:
+	case INDEX_1080I60:
+		return V4L2_FIELD_INTERLACED;
+	default:
+		return V4L2_FIELD_NONE;
+	}
+}
+
+/*
+ * tvp7002_try_fmt_cap() - V4L2 decoder interface handler for try_fmt
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @f: pointer to standard V4L2 VIDIOC_TRY_FMT ioctl structure
+ *
+ * Implement the VIDIOC_TRY_FMT ioctl for the CAPTURE buffer type. This
+ * ioctl is used to negotiate the image capture size and pixel format
+ * without actually making it take effect.
+ */
+static int tvp7002_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	struct v4l2_pix_format *pix;
+	u32 current_preset;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
+		return -EINVAL;
+
+	pix = &f->fmt.pix;
+
+	/* Calculate height and width based on current standard */
+	current_preset = device->current_preset;
+
+	pix->width = tvp7002_presets[current_preset].width;
+	pix->height = tvp7002_presets[current_preset].height;
+
+	pix->pixelformat = V4L2_PIX_FMT_UYVY;
+
+	pix->field = tvp7002_scanmode(current_preset);
+	pix->bytesperline = pix->width * 2;
+	pix->sizeimage = pix->bytesperline * pix->height;
+	pix->colorspace = tvp7002_colorspace(current_preset);
+	pix->priv = 0;
+
+	v4l2_dbg(1, debug, sd, "Try FMT: pixelformat - %s, bytesperline - %d"
+			"Width - %d, Height - %d",
+			"8-bit UYVY 4:2:2 Format", pix->bytesperline,
+			pix->width, pix->height);
+	return 0;
+}
+
+/*
+ * tvp7002_s_fmt() - V4L2 decoder interface handler for s_fmt
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @f: pointer to standard V4L2 VIDIOC_S_FMT ioctl structure
+ *
+ * If the requested format is supported, configures the HW to use that
+ * format, returns error code if format not supported or HW can't be
+ * correctly configured.
+ */
+static int tvp7002_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct tvp7002 *decoder = to_tvp7002(sd);
+	struct v4l2_pix_format *pix;
+	int rval;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
+		return -EINVAL;
+
+	pix = &f->fmt.pix;
+	rval = tvp7002_try_fmt_cap(sd, f);
+	if (rval)
+		return rval;
+
+	decoder->pix = *pix;
+
+	return rval;
+}
+
+/*
+ * tvp7002_g_fmt() - V4L2 decoder interface handler for tvp7002_g_fmt
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @f: pointer to standard V4L2 v4l2_format structure
+ *
+ * Returns the decoder's current pixel format in the v4l2_format
+ * parameter.
+ */
+static int tvp7002_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
+{
+	struct tvp7002 *decoder = to_tvp7002(sd);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		/* only capture is supported */
+		return -EINVAL;
+
+	f->fmt.pix = decoder->pix;
+
+	v4l2_dbg(1, debug, sd, "Current FMT: bytesperline - %d"
+			"Width - %d, Height - %d",
+			decoder->pix.bytesperline,
+			decoder->pix.width, decoder->pix.height);
+	return 0;
+}
+
+/*
+ * tvp7002_check_cpl() - check potential range for the value of clks per line
+ * @cpl: value of clocks per line
+ *
+ * Returns the index of detected mode or -EINVAL if no one is detected
+ */
+static inline int tvp7002_check_cpl(int clocks_per_line)
+{
+	if (clocks_per_line >= TVP7002_CPL_1080_60_LOWER &&
+		clocks_per_line <= TVP7002_CPL_1080_60_UPPER)
+		return INDEX_1080I60;
+	else if (clocks_per_line >= TVP7002_CPL_1080_50_LOWER &&
+		clocks_per_line <= TVP7002_CPL_1080_50_UPPER)
+		return INDEX_1080I50;
+	else if (clocks_per_line >= TVP7002_CPL_1080P_60_LOWER &&
+		clocks_per_line <= TVP7002_CPL_1080P_60_UPPER)
+		return INDEX_1080P60;
+	else if (clocks_per_line >= TVP7002_CPL_720P_50_LOWER &&
+		clocks_per_line <= TVP7002_CPL_720P_50_UPPER)
+		return INDEX_720P50;
+	else if (clocks_per_line >= TVP7002_CPL_720P_60_LOWER &&
+		clocks_per_line <= TVP7002_CPL_720P_60_UPPER)
+		return INDEX_720P60;
+	else
+		return -EINVAL;
+}
+
+/*
+ * tvp7002_query_dv_preset() - query DV preset
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @std_id: standard V4L2 v4l2_dv_preset
+ *
+ * Returns the current DV preset by TVP7002. If no active input is
+ * detected, returns -EINVAL
+ */
+static int tvp7002_query_dv_preset(struct v4l2_subdev *sd,
+						struct v4l2_dv_preset *qpreset)
+{
+	struct tvp7002 *device;
+	u32 lines_per_frame;
+	u32 clocks_per_line;
+	u8 progressive;
+	int error;
+	u8 lpf_lsb;
+	u8 lpf_msb;
+	u8 cpl_lsb;
+	u8 cpl_msb;
+	int index;
+
+	device = to_tvp7002(sd);
+
+	/* Read standards from device registers */
+	tvp7002_read_err(sd, TVP7002_L_FRAME_STAT_LSBS, &lpf_lsb, &error);
+	tvp7002_read_err(sd, TVP7002_L_FRAME_STAT_MSBS, &lpf_msb, &error);
+
+	if (error < 0)
+		return -EINVAL;
+
+	tvp7002_read_err(sd, TVP7002_CLK_L_STAT_LSBS, &cpl_lsb, &error);
+	tvp7002_read_err(sd, TVP7002_CLK_L_STAT_MSBS, &cpl_msb, &error);
+
+	if (error < 0)
+		return -EINVAL;
+
+	/* Get lines per frame, clocks per line and interlaced/progresive */
+	lines_per_frame = lpf_lsb | ((TVP7002_CL_MASK & lpf_msb) <<
+							TVP7002_CL_SHIFT);
+	clocks_per_line = cpl_lsb | ((TVP7002_CL_MASK & cpl_msb) <<
+							TVP7002_CL_SHIFT);
+	progressive = (lpf_msb & TVP7002_INPR_MASK) >> TVP7002_IP_SHIFT;
+
+	/* Assert read values */
+	if (!progressive) {
+		switch (lines_per_frame) {
+		case TVP7002_LINES_1080:
+			goto assert_hd;
+		default:
+			goto assert_fail;
+		}
+	} else {
+		switch (lines_per_frame) {
+		case TVP7002_LINES_1080:
+		case TVP7002_LINES_720:
+			goto assert_hd;
+		case 525:
+			index = INDEX_480P59_94;
+			goto assert_sd;
+		case 625:
+			index = INDEX_576P50;
+			goto assert_sd;
+		default:
+			goto assert_fail;
+		}
+	}
+
+assert_fail:
+	v4l2_err(sd, "querystd error, lpf = %x, cpl = %x\n",
+											lines_per_frame, clocks_per_line);
+	return -EINVAL;
+
+assert_hd:
+	index = tvp7002_check_cpl(clocks_per_line);
+	if (index < 0)
+		goto assert_fail;
+
+assert_sd:
+	/* Set values in found preset */
+	qpreset->preset = tvp7002_presets[index].preset;
+	device->current_preset = index;
+	error = tvp7002_s_dv_preset(sd, qpreset);
+
+	/* Update lines per frame and clocks per line info */
+	v4l2_dbg(1, debug, sd, "Current preset: %d %d",
+											tvp7002_presets[index].width,
+											tvp7002_presets[index].height);
+
+	return error;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+/*
+ * tvp7002_g_register() - Get the value of a register
+ * @sd: ptr to v4l2_subdev struct
+ * @vreg: ptr to v4l2_dbg_register struct
+ *
+ * Get the value of a TVP7002 decoder device register.
+ * Returns zero when successful, -EINVAL if register read fails or
+ * access to I2C client fails, -EPERM if the call is not allowed
+ * by diabled CAP_SYS_ADMIN.
+ */
+static int tvp7002_g_register(struct v4l2_subdev *sd,
+						struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return reg->val < 0 ? -EINVAL : 0;
+}
+
+/*
+ * tvp7002_s_register() - set a control
+ * @sd: ptr to v4l2_subdev struct
+ * @ctrl: ptr to v4l2_control struct
+ *
+ * Get the value of a TVP7002 decoder device register.
+ * Returns zero when successful or -EINVAL if register read fails.
+ */
+static int tvp7002_s_register(struct v4l2_subdev *sd,
+						struct v4l2_dbg_register *reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct tvp7002 *device = to_tvp7002(sd);
+	int wres;
+
+	if (!v4l2_chip_match_i2c_client(client, &reg->match))
+		return -EINVAL;
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	wres = tvp7002_write(sd, reg->reg & 0xff, reg->val & 0xff);
+
+	/* Update the register value in device's table */
+	if (!wres)
+		device->registers[reg->reg].value = reg->val;
+
+	return wres < 0 ? -EINVAL : 0;
+}
+#endif
+
+/*
+ * tvp7002_enum_fmt() - Enum supported formats
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @enable: pointer to format struct
+ *
+ * Enumerate supported formats.
+ */
+
+static int tvp7002_enum_fmt(struct v4l2_subdev *sd,
+						struct v4l2_fmtdesc *fmtdesc)
+{
+	/* Check requested format index is within range */
+	if (fmtdesc->index < 0 || fmtdesc->index >= NUM_FORMATS)
+		return -EINVAL;
+	memcpy(fmtdesc, tvp7002_fmt_list + fmtdesc->index,
+									sizeof(tvp7002_fmt_list[fmtdesc->index]));
+
+	return 0;
+}
+
+/*
+ * tvp7002_s_stream() - V4L2 decoder i/f handler for s_stream
+ * @sd: pointer to standard V4L2 sub-device structure
+ * @enable: streaming enable or disable
+ *
+ * Sets streaming to enable or disable, if possible.
+ */
+static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	int error = 0;
+
+	if (device->streaming == enable)
+		return 0;
+
+	if (enable) {
+		/* Set output state on (low impedance means stream on) */
+		device->registers[TVP7002_MISC_CTL_2].value = 0x00;
+		/* Power off chip */
+		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x7f);
+		if (error) {
+			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
+			error = -EINVAL;
+		}
+		/* Power on chip */
+		error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
+		if (error) {
+			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
+			return error;
+		}
+		/* Re-set register values with stored ones */
+		error = tvp7002_write_inittab(sd, device->registers);
+
+		if (error < 0) {
+			v4l2_dbg(1, debug, sd, "Unable to start streaming\n");
+			return error;
+		}
+		device->streaming = enable;
+	} else {
+		/* Set output state off (low impedance means stream off) */
+		device->registers[TVP7002_MISC_CTL_2].value = 0x03;
+		error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x03);
+		if (error) {
+			v4l2_dbg(1, debug, sd, "Unable to stop streaming\n");
+			error = -EINVAL;
+		}
+
+		device->streaming = enable;
+	}
+
+	return error;
+}
+
+/*
+ * tvp7002_log_chk() - Check reading the value of a register
+ * @sd: ptr to v4l2_subdev struct
+ * @reg: register to read
+ * @message: register name/function
+ *
+ * Check procedure for reading a register.
+ * Returns nothing (void).
+ */
+static inline void tvp7002_log_chk(struct v4l2_subdev *sd, u8 reg,
+							const char *message)
+{
+	int error;
+	u8 result;
+
+	error = tvp7002_read(sd, reg, &result);
+
+	if (error >= 0)
+		v4l2_info(sd, "%s (0x%02x) = 0x%02x\n", message, reg, result);
+}
+
+/*
+ * tvp7002_log_status() - Print information about register settings
+ * @sd: ptr to v4l2_subdev struct
+ *
+ * Log register values of a TVP7002 decoder device.
+ * Returns zero or -EINVAL if read operation fails.
+ */
+static int tvp7002_log_status(struct v4l2_subdev *sd)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	struct v4l2_dv_preset preset;
+	int i;
+
+	tvp7002_log_chk(sd, TVP7002_CHIP_REV, "Chip revision number");
+
+	/* Find my current standard*/
+	tvp7002_query_dv_preset(sd, &preset);
+
+	/* Print standard related code values */
+	for (i = 0; i < NUM_PRESETS; i++)
+		if (tvp7002_presets[i].preset == preset.preset)
+			break;
+
+	if (i == NUM_PRESETS)
+		return -EINVAL;
+
+	v4l2_info(sd, "DV Preset: %s\n", tvp7002_presets[i].name);
+	v4l2_info(sd, "Pixels per line: %u\n", tvp7002_presets[i].width);
+	v4l2_info(sd, "Lines per frame: %u\n", tvp7002_presets[i].height);
+	v4l2_info(sd, "Streaming enabled: %s\n", device->streaming ? "yes" : "no");
+
+	/* Print values of the gain control */
+	tvp7002_log_chk(sd, TVP7002_B_FINE_GAIN, "Digital fine gain B ch");
+	tvp7002_log_chk(sd, TVP7002_G_FINE_GAIN, "Digital fine gain G ch");
+	tvp7002_log_chk(sd, TVP7002_R_FINE_GAIN, "Digital fine gain R ch");
+
+	return 0;
+}
+
+/*
+ * tvp7002_reset - Reset a TVP7002 device
+ * @sd: ptr to v4l2_subdev struct
+ * @val: unsigned integer (not used)
+ *
+ * Reset the TVP7002 device
+ * Returns zero when successful or -EINVAL if register read fails.
+ */
+static int tvp7002_reset(struct v4l2_subdev *sd, u32 val)
+{
+	struct tvp7002 *device = to_tvp7002(sd);
+	struct v4l2_dv_preset preset;
+	int polarity_a;
+	int polarity_b;
+	u8 revision;
+	int error;
+
+	error = tvp7002_read(sd, TVP7002_CHIP_REV, &revision);
+	if (error < 0)
+		goto found_error;
+
+	/* Get revision number */
+	v4l2_info(sd, "Rev. %02x detected.\n", revision);
+	if (revision != 0x02)
+		v4l2_info(sd, "Unknown revision detected.\n");
+
+	/* Power down and up */
+	error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x7f);
+	if (error < 0)
+		goto found_error;
+
+	error = tvp7002_write(sd, TVP7002_PWR_CTL, 0x00);
+	if (error < 0)
+		goto found_error;
+
+	/* Set the default register values */
+	memcpy(device->registers, tvp7002_init_default,
+					sizeof(tvp7002_init_default));
+
+	/* Initializes TVP7002 to its default values */
+	error = tvp7002_write_inittab(sd, device->registers);
+
+	if (error < 0)
+		goto found_error;
+
+	/* Set polarity information after registers have been set */
+
+	polarity_a = 0x20 | device->pdata->hs_polarity << 5
+			| device->pdata->vs_polarity << 2;
+	error = tvp7002_write(sd, TVP7002_SYNC_CTL_1, polarity_a);
+	if (error < 0)
+		goto found_error;
+
+	polarity_b = 0x01  | device->pdata->fid_polarity << 2
+			| device->pdata->sog_polarity << 1
+			| device->pdata->clk_polarity;
+	error = tvp7002_write(sd, TVP7002_MISC_CTL_3, polarity_b);
+	if (error < 0)
+		goto found_error;
+
+	/* Save polarity information in register */
+	device->registers[TVP7002_SYNC_CTL_1].value = polarity_a;
+	device->registers[TVP7002_MISC_CTL_3].value = polarity_b;
+	/* Set registers according to default video mode */
+	preset.preset = tvp7002_presets[device->current_preset].preset;
+	error = tvp7002_s_dv_preset(sd, &preset);
+
+found_error:
+	return error;
+};
+
+/* V4L2 core operation handlers */
+static const struct v4l2_subdev_core_ops tvp7002_core_ops = {
+	.g_chip_ident = tvp7002_g_chip_ident,
+	.log_status = tvp7002_log_status,
+	.g_ctrl = tvp7002_g_ctrl,
+	.s_ctrl = tvp7002_s_ctrl,
+	.queryctrl = tvp7002_queryctrl,
+	.reset = tvp7002_reset,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = tvp7002_g_register,
+	.s_register = tvp7002_s_register,
+#endif
+};
+
+/* Specific video subsystem operation handlers */
+static const struct v4l2_subdev_video_ops tvp7002_video_ops = {
+	.s_dv_preset = tvp7002_s_dv_preset,
+	.query_dv_preset = tvp7002_query_dv_preset,
+	.s_stream = tvp7002_s_stream,
+	.g_fmt = tvp7002_g_fmt,
+	.s_fmt = tvp7002_s_fmt,
+	.enum_fmt = tvp7002_enum_fmt,
+};
+
+/* V4L2 top level operation handlers */
+static const struct v4l2_subdev_ops tvp7002_ops = {
+	.core = &tvp7002_core_ops,
+	.video = &tvp7002_video_ops,
+};
+
+static struct tvp7002 tvp7002_dev = {
+	.streaming = 0,
+
+	.pix = {
+		.width = HD_720_NUM_ACTIVE_PIXELS,
+		.height = HD_720_NUM_ACTIVE_LINES,
+		.pixelformat = V4L2_PIX_FMT_UYVY,
+		.field = V4L2_FIELD_NONE,
+		.bytesperline = HD_720_NUM_ACTIVE_PIXELS * 2,
+		.sizeimage =
+		HD_720_NUM_ACTIVE_PIXELS * 2 * HD_720_NUM_ACTIVE_LINES,
+		.colorspace = V4L2_COLORSPACE_SMPTE170M,
+		},
+
+	.current_preset = INDEX_720P60,
+};
+
+/*
+ * tvp7002_probe - Probe a TVP7002 device
+ * @sd: ptr to v4l2_subdev struct
+ * @ctrl: ptr to i2c_device_id struct
+ *
+ * Initialize the TVP7002 device
+ * Returns zero when successful or -EINVAL if register read fails.
+ */
+static int tvp7002_probe(struct i2c_client *c, const struct i2c_device_id *id)
+{
+	struct v4l2_subdev *sd;
+	struct tvp7002 *device;
+	int error;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(c->adapter,
+		I2C_FUNC_SMBUS_READ_BYTE | I2C_FUNC_SMBUS_WRITE_BYTE_DATA))
+		return -EIO;
+
+	if (!c->dev.platform_data) {
+		v4l2_err(c, "No platform data!!\n");
+		return -ENODEV;
+	}
+
+	device = (struct tvp7002 *) kmalloc(sizeof(struct tvp7002),
+								GFP_KERNEL);
+
+	if (!device)
+		return -ENOMEM;
+
+	memcpy(device, &tvp7002_dev, sizeof(struct tvp7002));
+	sd = &device->sd;
+	device->pdata = c->dev.platform_data;
+
+	/* Tell v4l2 the device is ready */
+	v4l2_i2c_subdev_init(sd, c, &tvp7002_ops);
+	v4l_info(c, "tvp7002 found @ 0x%02x (%s)\n",
+					c->addr, c->adapter->name);
+
+	/* Initialize device internals */
+	error = tvp7002_reset(sd, 0);
+	if (error < 0) {
+		kfree(device);
+		return error;
+	}
+	return 0;
+}
+
+/*
+ * tvp7002_remove - Remove TVP7002 device support
+ * @c: ptr to i2c_client struct
+ *
+ * Reset the TVP7002 device
+ * Returns zero.
+ */
+static int tvp7002_remove(struct i2c_client *c)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(c);
+	struct tvp7002 *device = to_tvp7002(sd);
+
+	v4l2_dbg(1, debug, sd, "Removing tvp7002 adapter"
+				"on address 0x%x\n", c->addr);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(device);
+	return 0;
+}
+
+/* I2C Device ID table */
+static const struct i2c_device_id tvp7002_id[] = {
+	{ "tvp7002", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tvp7002_id);
+
+/* I2C driver data */
+static struct i2c_driver tvp7002_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = TVP7002_MODULE_NAME,
+	},
+	.probe = tvp7002_probe,
+	.remove = tvp7002_remove,
+	.id_table = tvp7002_id,
+};
+
+/*
+ * tvp7002_init - Initialize driver via I2C interface
+ *
+ * Register the TVP7002 driver.
+ * Returns 0 on success or < 0 on failure.
+ */
+static int __init tvp7002_init(void)
+{
+	return i2c_add_driver(&tvp7002_driver);
+}
+
+/*
+ * tvp7002_exit - Remove driver via I2C interface
+ *
+ * Unregister the TVP7002 driver.
+ * Returns 0 on success or < 0 on failure.
+ */
+static void __exit tvp7002_exit(void)
+{
+	i2c_del_driver(&tvp7002_driver);
+}
+
+module_init(tvp7002_init);
+module_exit(tvp7002_exit);
-- 
1.6.0.4

