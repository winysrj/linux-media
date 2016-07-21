Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:40230 "EHLO
	email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751748AbcGUIb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 04:31:57 -0400
From: Songjun Wu <songjun.wu@microchip.com>
To: <nicolas.ferre@atmel.com>, <robh@kernel.org>
CC: <laurent.pinchart@ideasonboard.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	Songjun Wu <songjun.wu@microchip.com>,
	Arnd Bergmann <arnd@arndb.de>,
	=?UTF-8?q?Niklas=20S=C3=83=C2=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Benoit Parrot <bparrot@ti.com>, <linux-kernel@vger.kernel.org>,
	Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
	Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Kamil Debski <kamil@wypas.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	=?UTF-8?q?Richard=20R=C3=B6jfors?= <richard@puffinpack.se>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH v6 1/2] [media] atmel-isc: add the Image Sensor Controller code
Date: Thu, 21 Jul 2016 16:14:57 +0800
Message-ID: <1469088900-23935-2-git-send-email-songjun.wu@microchip.com>
In-Reply-To: <1469088900-23935-1-git-send-email-songjun.wu@microchip.com>
References: <1469088900-23935-1-git-send-email-songjun.wu@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add driver for the Image Sensor Controller. It manages
incoming data from a parallel based CMOS/CCD sensor.
It has an internal image processor, also integrates a
triple channel direct memory access controller master
interface.

Signed-off-by: Songjun Wu <songjun.wu@microchip.com>
---

Changes in v6: None
Changes in v5:
- Modify the macro definition and the related code.

Changes in v4:
- Modify the isc clock code since the dt is changed.

Changes in v3:
- Add pm runtime feature.
- Modify the isc clock code since the dt is changed.

Changes in v2:
- Add "depends on COMMON_CLK" and "VIDEO_V4L2_SUBDEV_API"
  in Kconfig file.
- Correct typos and coding style according to Laurent's remarks
- Delete the loop while in 'isc_clk_enable' function.
- Replace 'hsync_active', 'vsync_active' and 'pclk_sample'
  with 'pfe_cfg0' in struct isc_subdev_entity.
- Add the code to support VIDIOC_CREATE_BUFS in
  'isc_queue_setup' function.
- Invoke isc_config to configure register in
  'isc_start_streaming' function.
- Add the struct completion 'comp' to synchronize with
  the frame end interrupt in 'isc_stop_streaming' function.
- Check the return value of the clk_prepare_enable
  in 'isc_open' function.
- Set the default format in 'isc_open' function.
- Add an exit condition in the loop while in 'isc_config'.
- Delete the hardware setup operation in 'isc_set_format'.
- Refuse format modification during streaming
  in 'isc_s_fmt_vid_cap' function.
- Invoke v4l2_subdev_alloc_pad_config to allocate and
  initialize the pad config in 'isc_async_complete' function.
- Remove the '.owner  = THIS_MODULE,' in atmel_isc_driver.
- Replace the module_platform_driver_probe() with
  module_platform_driver().

 drivers/media/platform/Kconfig                |    1 +
 drivers/media/platform/Makefile               |    2 +
 drivers/media/platform/atmel/Kconfig          |    9 +
 drivers/media/platform/atmel/Makefile         |    1 +
 drivers/media/platform/atmel/atmel-isc-regs.h |  165 +++
 drivers/media/platform/atmel/atmel-isc.c      | 1554 +++++++++++++++++++++++++
 6 files changed, 1732 insertions(+)
 create mode 100644 drivers/media/platform/atmel/Kconfig
 create mode 100644 drivers/media/platform/atmel/Makefile
 create mode 100644 drivers/media/platform/atmel/atmel-isc-regs.h
 create mode 100644 drivers/media/platform/atmel/atmel-isc.c

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index f25344b..b23db17 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -111,6 +111,7 @@ source "drivers/media/platform/s5p-tv/Kconfig"
 source "drivers/media/platform/am437x/Kconfig"
 source "drivers/media/platform/xilinx/Kconfig"
 source "drivers/media/platform/rcar-vin/Kconfig"
+source "drivers/media/platform/atmel/Kconfig"
 
 config VIDEO_TI_CAL
 	tristate "TI CAL (Camera Adaptation Layer) driver"
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 21771c1..37b6c75 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -58,6 +58,8 @@ obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
 
 obj-$(CONFIG_VIDEO_RCAR_VIN)		+= rcar-vin/
 
+obj-$(CONFIG_VIDEO_ATMEL_ISC)		+= atmel/
+
 ccflags-y += -I$(srctree)/drivers/media/i2c
 
 obj-$(CONFIG_VIDEO_MEDIATEK_VPU)	+= mtk-vpu/
diff --git a/drivers/media/platform/atmel/Kconfig b/drivers/media/platform/atmel/Kconfig
new file mode 100644
index 0000000..867dca2
--- /dev/null
+++ b/drivers/media/platform/atmel/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_ATMEL_ISC
+	tristate "ATMEL Image Sensor Controller (ISC) support"
+	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
+	depends on ARCH_AT91 || COMPILE_TEST
+	select VIDEOBUF2_DMA_CONTIG
+	select REGMAP_MMIO
+	help
+	   This module makes the ATMEL Image Sensor Controller available
+	   as a v4l2 device.
\ No newline at end of file
diff --git a/drivers/media/platform/atmel/Makefile b/drivers/media/platform/atmel/Makefile
new file mode 100644
index 0000000..9d7c999
--- /dev/null
+++ b/drivers/media/platform/atmel/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_ATMEL_ISC) += atmel-isc.o
diff --git a/drivers/media/platform/atmel/atmel-isc-regs.h b/drivers/media/platform/atmel/atmel-isc-regs.h
new file mode 100644
index 0000000..00c4497
--- /dev/null
+++ b/drivers/media/platform/atmel/atmel-isc-regs.h
@@ -0,0 +1,165 @@
+#ifndef __ATMEL_ISC_REGS_H
+#define __ATMEL_ISC_REGS_H
+
+#include <linux/bitops.h>
+
+/* ISC Control Enable Register 0 */
+#define ISC_CTRLEN      0x00000000
+
+/* ISC Control Disable Register 0 */
+#define ISC_CTRLDIS     0x00000004
+
+/* ISC Control Status Register 0 */
+#define ISC_CTRLSR      0x00000008
+
+#define ISC_CTRL_CAPTURE	BIT(0)
+#define ISC_CTRL_UPPRO		BIT(1)
+#define ISC_CTRL_HISREQ		BIT(2)
+#define ISC_CTRL_HISCLR		BIT(3)
+
+/* ISC Parallel Front End Configuration 0 Register */
+#define ISC_PFE_CFG0    0x0000000c
+
+#define ISC_PFE_CFG0_HPOL_LOW   BIT(0)
+#define ISC_PFE_CFG0_VPOL_LOW   BIT(1)
+#define ISC_PFE_CFG0_PPOL_LOW   BIT(2)
+
+#define ISC_PFE_CFG0_MODE_PROGRESSIVE   (0x0 << 4)
+#define ISC_PFE_CFG0_MODE_MASK          GENMASK(6, 4)
+
+#define ISC_PFE_CFG0_BPS_EIGHT  (0x4 << 28)
+#define ISC_PFG_CFG0_BPS_NINE   (0x3 << 28)
+#define ISC_PFG_CFG0_BPS_TEN    (0x2 << 28)
+#define ISC_PFG_CFG0_BPS_ELEVEN (0x1 << 28)
+#define ISC_PFG_CFG0_BPS_TWELVE (0x0 << 28)
+#define ISC_PFE_CFG0_BPS_MASK   GENMASK(30, 28)
+
+/* ISC Clock Enable Register */
+#define ISC_CLKEN               0x00000018
+
+/* ISC Clock Disable Register */
+#define ISC_CLKDIS              0x0000001c
+
+/* ISC Clock Status Register */
+#define ISC_CLKSR               0x00000020
+
+#define ISC_CLK(n)		BIT(n)
+
+/* ISC Clock Configuration Register */
+#define ISC_CLKCFG              0x00000024
+#define ISC_CLKCFG_DIV_SHIFT(n) ((n)*16)
+#define ISC_CLKCFG_DIV_MASK(n)  GENMASK(((n)*16 + 7), (n)*16)
+#define ISC_CLKCFG_SEL_SHIFT(n) ((n)*16 + 8)
+#define ISC_CLKCFG_SEL_MASK(n)  GENMASK(((n)*17 + 8), ((n)*16 + 8))
+
+/* ISC Interrupt Enable Register */
+#define ISC_INTEN       0x00000028
+
+/* ISC Interrupt Disable Register */
+#define ISC_INTDIS      0x0000002c
+
+/* ISC Interrupt Mask Register */
+#define ISC_INTMASK     0x00000030
+
+/* ISC Interrupt Status Register */
+#define ISC_INTSR       0x00000034
+
+#define ISC_INT_DDONE		BIT(8)
+
+/* ISC White Balance Control Register */
+#define ISC_WB_CTRL     0x00000058
+
+/* ISC White Balance Configuration Register */
+#define ISC_WB_CFG      0x0000005c
+
+/* ISC Color Filter Array Control Register */
+#define ISC_CFA_CTRL    0x00000070
+
+/* ISC Color Filter Array Configuration Register */
+#define ISC_CFA_CFG     0x00000074
+
+#define ISC_BAY_CFG_GRGR	0x0
+#define ISC_BAY_CFG_RGRG	0x1
+#define ISC_BAY_CFG_GBGB	0x2
+#define ISC_BAY_CFG_BGBG	0x3
+#define ISC_BAY_CFG_MASK	GENMASK(1, 0)
+
+/* ISC Color Correction Control Register */
+#define ISC_CC_CTRL     0x00000078
+
+/* ISC Gamma Correction Control Register */
+#define ISC_GAM_CTRL    0x00000094
+
+/* Color Space Conversion Control Register */
+#define ISC_CSC_CTRL    0x00000398
+
+/* Contrast And Brightness Control Register */
+#define ISC_CBC_CTRL    0x000003b4
+
+/* Subsampling 4:4:4 to 4:2:2 Control Register */
+#define ISC_SUB422_CTRL 0x000003c4
+
+/* Subsampling 4:2:2 to 4:2:0 Control Register */
+#define ISC_SUB420_CTRL 0x000003cc
+
+/* Rounding, Limiting and Packing Configuration Register */
+#define ISC_RLP_CFG     0x000003d0
+
+#define ISC_RLP_CFG_MODE_DAT8           0x0
+#define ISC_RLP_CFG_MODE_DAT9           0x1
+#define ISC_RLP_CFG_MODE_DAT10          0x2
+#define ISC_RLP_CFG_MODE_DAT11          0x3
+#define ISC_RLP_CFG_MODE_DAT12          0x4
+#define ISC_RLP_CFG_MODE_DATY8          0x5
+#define ISC_RLP_CFG_MODE_DATY10         0x6
+#define ISC_RLP_CFG_MODE_ARGB444        0x7
+#define ISC_RLP_CFG_MODE_ARGB555        0x8
+#define ISC_RLP_CFG_MODE_RGB565         0x9
+#define ISC_RLP_CFG_MODE_ARGB32         0xa
+#define ISC_RLP_CFG_MODE_YYCC           0xb
+#define ISC_RLP_CFG_MODE_YYCC_LIMITED   0xc
+#define ISC_RLP_CFG_MODE_MASK           GENMASK(3, 0)
+
+/* DMA Configuration Register */
+#define ISC_DCFG        0x000003e0
+#define ISC_DCFG_IMODE_PACKED8          0x0
+#define ISC_DCFG_IMODE_PACKED16         0x1
+#define ISC_DCFG_IMODE_PACKED32         0x2
+#define ISC_DCFG_IMODE_YC422SP          0x3
+#define ISC_DCFG_IMODE_YC422P           0x4
+#define ISC_DCFG_IMODE_YC420SP          0x5
+#define ISC_DCFG_IMODE_YC420P           0x6
+#define ISC_DCFG_IMODE_MASK             GENMASK(2, 0)
+
+#define ISC_DCFG_YMBSIZE_SINGLE         (0x0 << 4)
+#define ISC_DCFG_YMBSIZE_BEATS4         (0x1 << 4)
+#define ISC_DCFG_YMBSIZE_BEATS8         (0x2 << 4)
+#define ISC_DCFG_YMBSIZE_BEATS16        (0x3 << 4)
+#define ISC_DCFG_YMBSIZE_MASK           GENMASK(5, 4)
+
+#define ISC_DCFG_CMBSIZE_SINGLE         (0x0 << 8)
+#define ISC_DCFG_CMBSIZE_BEATS4         (0x1 << 8)
+#define ISC_DCFG_CMBSIZE_BEATS8         (0x2 << 8)
+#define ISC_DCFG_CMBSIZE_BEATS16        (0x3 << 8)
+#define ISC_DCFG_CMBSIZE_MASK           GENMASK(9, 8)
+
+/* DMA Control Register */
+#define ISC_DCTRL       0x000003e4
+
+#define ISC_DCTRL_DVIEW_PACKED          (0x0 << 1)
+#define ISC_DCTRL_DVIEW_SEMIPLANAR      (0x1 << 1)
+#define ISC_DCTRL_DVIEW_PLANAR          (0x2 << 1)
+#define ISC_DCTRL_DVIEW_MASK            GENMASK(2, 1)
+
+#define ISC_DCTRL_IE_IS			(0x0 << 4)
+
+/* DMA Descriptor Address Register */
+#define ISC_DNDA        0x000003e8
+
+/* DMA Address 0 Register */
+#define ISC_DAD0        0x000003ec
+
+/* DMA Stride 0 Register */
+#define ISC_DST0        0x000003f0
+
+#endif
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
new file mode 100644
index 0000000..03bebfd
--- /dev/null
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -0,0 +1,1554 @@
+/*
+ * Atmel Image Sensor Controller (ISC) driver
+ *
+ * Copyright (C) 2016 Atmel
+ *
+ * Author: Songjun Wu <songjun.wu@microchip.com>
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * Sensor-->PFE-->WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB-->RLP-->DMA
+ *
+ * ISC video pipeline integrates the following submodules:
+ * PFE: Parallel Front End to sample the camera sensor input stream
+ *  WB: Programmable white balance in the Bayer domain
+ * CFA: Color filter array interpolation module
+ *  CC: Programmable color correction
+ * GAM: Gamma correction
+ * CSC: Programmable color space conversion
+ * CBC: Contrast and Brightness control
+ * SUB: This module performs YCbCr444 to YCbCr420 chrominance subsampling
+ * RLP: This module performs rounding, range limiting
+ *      and packing of the incoming data
+ */
+
+#include <linux/clk.h>
+#include <linux/clkdev.h>
+#include <linux/clk-provider.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regmap.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-image-sizes.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "atmel-isc-regs.h"
+
+#define ATMEL_ISC_NAME		"atmel_isc"
+
+#define ISC_MAX_SUPPORT_WIDTH   2592
+#define ISC_MAX_SUPPORT_HEIGHT  1944
+
+#define ISC_CLK_MAX_DIV		255
+
+enum isc_clk_id {
+	ISC_ISPCK = 0,
+	ISC_MCK = 1,
+};
+
+struct isc_clk {
+	struct clk_hw   hw;
+	struct clk      *clk;
+	struct regmap   *regmap;
+	u8		id;
+	u8		parent_id;
+	u32		div;
+	struct device	*dev;
+};
+
+#define to_isc_clk(hw) container_of(hw, struct isc_clk, hw)
+
+struct isc_buffer {
+	struct vb2_v4l2_buffer  vb;
+	struct list_head	list;
+};
+
+struct isc_subdev_entity {
+	struct v4l2_subdev		*sd;
+	struct v4l2_async_subdev	*asd;
+	struct v4l2_async_notifier      notifier;
+	struct v4l2_subdev_pad_config	*config;
+
+	u32 pfe_cfg0;
+
+	struct list_head list;
+};
+
+/*
+ * struct isc_format - ISC media bus format information
+ * @fourcc:		Fourcc code for this format
+ * @isc_mbus_code:      V4L2 media bus format code if ISC is preferred
+ * @sd_mbus_code:       V4L2 media bus format code if subdev is preferred
+ * @bpp:		Bytes per pixel (when stored in memory)
+ * @reg_sd_bps:		reg value for bits per sample if subdev is preferred
+ *			(when transferred over a bus)
+ * @reg_isc_bps:	reg value for bits per sample if ISC is preferred
+ *			(when transferred over a bus)
+ * @pipeline:		pipeline switch if ISC is preferred
+ * @isc_support:	ISC can convert raw format to this format
+ * @sd_support:		Subdev supports this format
+ */
+struct isc_format {
+	u32	fourcc;
+	u32	isc_mbus_code;
+	u32	sd_mbus_code;
+
+	u8	bpp;
+
+	u32	reg_sd_bps;
+	u32	reg_isc_bps;
+
+	u32	reg_bay_cfg;
+	u32	reg_rlp_mode;
+	u32	reg_dcfg_imode;
+	u32	reg_dctrl_dview;
+
+	u32	pipeline;
+
+	bool	isc_support;
+	bool	sd_support;
+};
+
+#define ISC_PIPE_LINE_NODE_NUM	11
+
+struct isc_device {
+	struct regmap		*regmap;
+	struct clk		*hclock;
+	struct clk		*ispck;
+	struct isc_clk		isc_clks[2];
+
+	struct device		*dev;
+	struct v4l2_device	v4l2_dev;
+	struct video_device	video_dev;
+
+	struct vb2_queue	vb2_vidq;
+	spinlock_t		dma_queue_lock;
+	struct list_head	dma_queue;
+	struct isc_buffer	*cur_frm;
+	unsigned int		sequence;
+	bool			stop;
+	struct completion	comp;
+
+	struct v4l2_format	fmt;
+	struct isc_format	**user_formats;
+	unsigned int		num_user_formats;
+	const struct isc_format	*current_fmt;
+
+	struct mutex		lock;
+
+	struct regmap_field	*pipeline[ISC_PIPE_LINE_NODE_NUM];
+
+	struct isc_subdev_entity	*current_subdev;
+	struct list_head		subdev_entities;
+};
+
+static unsigned int sensor_preferred = 1;
+module_param(sensor_preferred, uint, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(sensor_preferred,
+		 "Sensor is preferred to output the specified format (1-on 0-off) default 1");
+
+#define RAW_FMT_INDEX_START	0
+#define RAW_FMT_INDEX_END	11
+#define ISC_FMT_INDEX_START	12
+#define ISC_FMT_INDEX_END	12
+
+/*
+ * index(0~11):  raw formats.
+ * index(12~12): the formats which can be converted from raw format by ISC.
+ * index():      the formats which can only be provided by subdev.
+ */
+static struct isc_format isc_formats[] = {
+	{ V4L2_PIX_FMT_SBGGR8, MEDIA_BUS_FMT_SBGGR8_1X8,
+	  MEDIA_BUS_FMT_SBGGR8_1X8, 1, ISC_PFE_CFG0_BPS_EIGHT,
+	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG,
+	  ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SGBRG8, MEDIA_BUS_FMT_SGBRG8_1X8,
+	  MEDIA_BUS_FMT_SGBRG8_1X8, 1, ISC_PFE_CFG0_BPS_EIGHT,
+	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GBGB,
+	  ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SGRBG8, MEDIA_BUS_FMT_SGRBG8_1X8,
+	  MEDIA_BUS_FMT_SGRBG8_1X8, 1, ISC_PFE_CFG0_BPS_EIGHT,
+	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_GRGR,
+	  ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SRGGB8, MEDIA_BUS_FMT_SRGGB8_1X8,
+	  MEDIA_BUS_FMT_SRGGB8_1X8, 1, ISC_PFE_CFG0_BPS_EIGHT,
+	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_RGRG,
+	  ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+
+	{ V4L2_PIX_FMT_SBGGR10, MEDIA_BUS_FMT_SBGGR10_1X10,
+	  MEDIA_BUS_FMT_SBGGR10_1X10, 2, ISC_PFG_CFG0_BPS_TEN,
+	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_BGBG,
+	  ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SGBRG10, MEDIA_BUS_FMT_SGBRG10_1X10,
+	  MEDIA_BUS_FMT_SGBRG10_1X10, 2, ISC_PFG_CFG0_BPS_TEN,
+	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GBGB,
+	  ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SGRBG10, MEDIA_BUS_FMT_SGRBG10_1X10,
+	  MEDIA_BUS_FMT_SGRBG10_1X10, 2, ISC_PFG_CFG0_BPS_TEN,
+	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_GRGR,
+	  ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SRGGB10, MEDIA_BUS_FMT_SRGGB10_1X10,
+	  MEDIA_BUS_FMT_SRGGB10_1X10, 2, ISC_PFG_CFG0_BPS_TEN,
+	  ISC_PFG_CFG0_BPS_TEN, ISC_BAY_CFG_RGRG,
+	  ISC_RLP_CFG_MODE_DAT10, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+
+	{ V4L2_PIX_FMT_SBGGR12, MEDIA_BUS_FMT_SBGGR12_1X12,
+	  MEDIA_BUS_FMT_SBGGR12_1X12, 2, ISC_PFG_CFG0_BPS_TWELVE,
+	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_BGBG,
+	  ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SGBRG12, MEDIA_BUS_FMT_SGBRG12_1X12,
+	  MEDIA_BUS_FMT_SGBRG12_1X12, 2, ISC_PFG_CFG0_BPS_TWELVE,
+	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GBGB,
+	  ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SGRBG12, MEDIA_BUS_FMT_SGRBG12_1X12,
+	  MEDIA_BUS_FMT_SGRBG12_1X12, 2, ISC_PFG_CFG0_BPS_TWELVE,
+	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_GRGR,
+	  ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+	{ V4L2_PIX_FMT_SRGGB12, MEDIA_BUS_FMT_SRGGB12_1X12,
+	  MEDIA_BUS_FMT_SRGGB12_1X12, 2, ISC_PFG_CFG0_BPS_TWELVE,
+	  ISC_PFG_CFG0_BPS_TWELVE, ISC_BAY_CFG_RGRG,
+	  ISC_RLP_CFG_MODE_DAT12, ISC_DCFG_IMODE_PACKED16,
+	  ISC_DCTRL_DVIEW_PACKED, 0x0, false, false },
+
+	{ V4L2_PIX_FMT_YUYV, MEDIA_BUS_FMT_YUYV8_2X8,
+	  MEDIA_BUS_FMT_YUYV8_2X8, 2, ISC_PFE_CFG0_BPS_EIGHT,
+	  ISC_PFE_CFG0_BPS_EIGHT, ISC_BAY_CFG_BGBG,
+	  ISC_RLP_CFG_MODE_DAT8, ISC_DCFG_IMODE_PACKED8,
+	  ISC_DCTRL_DVIEW_PACKED, 0x3ff, false, false },
+};
+
+static int isc_clk_enable(struct clk_hw *hw)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+	u32 id = isc_clk->id;
+	struct regmap *regmap = isc_clk->regmap;
+
+	dev_dbg(isc_clk->dev, "ISC CLK: %s, div = %d, parent id = %d\n",
+		__func__, isc_clk->div, isc_clk->parent_id);
+
+	regmap_update_bits(regmap, ISC_CLKCFG,
+			   ISC_CLKCFG_DIV_MASK(id) | ISC_CLKCFG_SEL_MASK(id),
+			   (isc_clk->div << ISC_CLKCFG_DIV_SHIFT(id)) |
+			   (isc_clk->parent_id << ISC_CLKCFG_SEL_SHIFT(id)));
+
+	regmap_write(regmap, ISC_CLKEN, ISC_CLK(id));
+
+	return 0;
+}
+
+static void isc_clk_disable(struct clk_hw *hw)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+	u32 id = isc_clk->id;
+
+	regmap_write(isc_clk->regmap, ISC_CLKDIS, ISC_CLK(id));
+}
+
+static int isc_clk_is_enabled(struct clk_hw *hw)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+	u32 status;
+
+	regmap_read(isc_clk->regmap, ISC_CLKSR, &status);
+
+	return status & ISC_CLK(isc_clk->id) ? 1 : 0;
+}
+
+static unsigned long
+isc_clk_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+
+	return DIV_ROUND_CLOSEST(parent_rate, isc_clk->div + 1);
+}
+
+static int isc_clk_determine_rate(struct clk_hw *hw,
+				   struct clk_rate_request *req)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+	long best_rate = -EINVAL;
+	int best_diff = -1;
+	unsigned int i, div;
+
+	for (i = 0; i < clk_hw_get_num_parents(hw); i++) {
+		struct clk_hw *parent;
+		unsigned long parent_rate;
+
+		parent = clk_hw_get_parent_by_index(hw, i);
+		if (!parent)
+			continue;
+
+		parent_rate = clk_hw_get_rate(parent);
+		if (!parent_rate)
+			continue;
+
+		for (div = 1; div < ISC_CLK_MAX_DIV + 2; div++) {
+			unsigned long rate;
+			int diff;
+
+			rate = DIV_ROUND_CLOSEST(parent_rate, div);
+			diff = abs(req->rate - rate);
+
+			if (best_diff < 0 || best_diff > diff) {
+				best_rate = rate;
+				best_diff = diff;
+				req->best_parent_rate = parent_rate;
+				req->best_parent_hw = parent;
+			}
+
+			if (!best_diff || rate < req->rate)
+				break;
+		}
+
+		if (!best_diff)
+			break;
+	}
+
+	dev_dbg(isc_clk->dev,
+		"ISC CLK: %s, best_rate = %ld, parent clk: %s @ %ld\n",
+		__func__, best_rate,
+		__clk_get_name((req->best_parent_hw)->clk),
+		req->best_parent_rate);
+
+	if (best_rate < 0)
+		return best_rate;
+
+	req->rate = best_rate;
+
+	return 0;
+}
+
+static int isc_clk_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+
+	if (index >= clk_hw_get_num_parents(hw))
+		return -EINVAL;
+
+	isc_clk->parent_id = index;
+
+	return 0;
+}
+
+static u8 isc_clk_get_parent(struct clk_hw *hw)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+
+	return isc_clk->parent_id;
+}
+
+static int isc_clk_set_rate(struct clk_hw *hw,
+			     unsigned long rate,
+			     unsigned long parent_rate)
+{
+	struct isc_clk *isc_clk = to_isc_clk(hw);
+	u32 div;
+
+	if (!rate)
+		return -EINVAL;
+
+	div = DIV_ROUND_CLOSEST(parent_rate, rate);
+	if (div > (ISC_CLK_MAX_DIV + 1) || !div)
+		return -EINVAL;
+
+	isc_clk->div = div - 1;
+
+	return 0;
+}
+
+static const struct clk_ops isc_clk_ops = {
+	.enable		= isc_clk_enable,
+	.disable	= isc_clk_disable,
+	.is_enabled	= isc_clk_is_enabled,
+	.recalc_rate	= isc_clk_recalc_rate,
+	.determine_rate	= isc_clk_determine_rate,
+	.set_parent	= isc_clk_set_parent,
+	.get_parent	= isc_clk_get_parent,
+	.set_rate	= isc_clk_set_rate,
+};
+
+static int isc_clk_register(struct isc_device *isc, unsigned int id)
+{
+	struct regmap *regmap = isc->regmap;
+	struct device_node *np = isc->dev->of_node;
+	struct isc_clk *isc_clk;
+	struct clk_init_data init;
+	const char *clk_name = np->name;
+	const char *parent_names[3];
+	int num_parents;
+
+	num_parents = of_clk_get_parent_count(np);
+	if (num_parents < 1 || num_parents > 3)
+		return -EINVAL;
+
+	if (num_parents > 2 && id == ISC_ISPCK)
+		num_parents = 2;
+
+	of_clk_parent_fill(np, parent_names, num_parents);
+
+	if (id == ISC_MCK)
+		of_property_read_string(np, "clock-output-names", &clk_name);
+	else
+		clk_name = "isc-ispck";
+
+	init.parent_names	= parent_names;
+	init.num_parents	= num_parents;
+	init.name		= clk_name;
+	init.ops		= &isc_clk_ops;
+	init.flags		= CLK_SET_RATE_GATE | CLK_SET_PARENT_GATE;
+
+	isc_clk = &isc->isc_clks[id];
+	isc_clk->hw.init	= &init;
+	isc_clk->regmap		= regmap;
+	isc_clk->id		= id;
+	isc_clk->dev		= isc->dev;
+
+	isc_clk->clk = clk_register(isc->dev, &isc_clk->hw);
+	if (IS_ERR(isc_clk->clk)) {
+		dev_err(isc->dev, "%s: clock register fail\n", clk_name);
+		return PTR_ERR(isc_clk->clk);
+	} else if (id == ISC_MCK)
+		of_clk_add_provider(np, of_clk_src_simple_get, isc_clk->clk);
+
+	return 0;
+}
+
+static int isc_clk_init(struct isc_device *isc)
+{
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(isc->isc_clks); i++)
+		isc->isc_clks[i].clk = ERR_PTR(-EINVAL);
+
+	for (i = 0; i < ARRAY_SIZE(isc->isc_clks); i++) {
+		ret = isc_clk_register(isc, i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void isc_clk_cleanup(struct isc_device *isc)
+{
+	unsigned int i;
+
+	of_clk_del_provider(isc->dev->of_node);
+
+	for (i = 0; i < ARRAY_SIZE(isc->isc_clks); i++) {
+		struct isc_clk *isc_clk = &isc->isc_clks[i];
+
+		if (!IS_ERR(isc_clk->clk))
+			clk_unregister(isc_clk->clk);
+	}
+}
+
+static int isc_queue_setup(struct vb2_queue *vq,
+			    unsigned int *nbuffers, unsigned int *nplanes,
+			    unsigned int sizes[], struct device *alloc_devs[])
+{
+	struct isc_device *isc = vb2_get_drv_priv(vq);
+	unsigned int size = isc->fmt.fmt.pix.sizeimage;
+
+	if (*nplanes)
+		return sizes[0] < size ? -EINVAL : 0;
+
+	*nplanes = 1;
+	sizes[0] = size;
+
+	return 0;
+}
+
+static int isc_buffer_prepare(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct isc_device *isc = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long size = isc->fmt.fmt.pix.sizeimage;
+
+	if (vb2_plane_size(vb, 0) < size) {
+		v4l2_err(&isc->v4l2_dev, "buffer too small (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0), size);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, size);
+
+	vbuf->field = isc->fmt.fmt.pix.field;
+
+	return 0;
+}
+
+static inline void isc_start_dma(struct regmap *regmap,
+				  struct isc_buffer *frm, u32 dview)
+{
+	dma_addr_t addr;
+
+	addr = vb2_dma_contig_plane_dma_addr(&frm->vb.vb2_buf, 0);
+
+	regmap_write(regmap, ISC_DCTRL, dview | ISC_DCTRL_IE_IS);
+	regmap_write(regmap, ISC_DAD0, addr);
+	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_CAPTURE);
+}
+
+static inline bool sensor_is_preferred(const struct isc_format *isc_fmt)
+{
+	if ((sensor_preferred && isc_fmt->sd_support) ||
+	    !isc_fmt->isc_support)
+		return true;
+	else
+		return false;
+}
+
+static void isc_set_pipeline(struct isc_device *isc, u32 pipeline)
+{
+	u32 val;
+	unsigned int i;
+
+	for (i = 0; i < ISC_PIPE_LINE_NODE_NUM; i++) {
+		val = pipeline & BIT(i) ? 1 : 0;
+		regmap_field_write(isc->pipeline[i], val);
+	}
+}
+
+static int isc_configure(struct isc_device *isc)
+{
+	struct regmap *regmap = isc->regmap;
+	const struct isc_format *current_fmt = isc->current_fmt;
+	struct isc_subdev_entity *subdev = isc->current_subdev;
+	u32 pipeline, val, mask;
+	int counter = 10;
+
+	if (sensor_is_preferred(current_fmt)) {
+		val = current_fmt->reg_sd_bps;
+		pipeline = 0x0;
+	} else {
+		val = current_fmt->reg_isc_bps;
+		pipeline = current_fmt->pipeline;
+
+		regmap_update_bits(regmap, ISC_WB_CFG, ISC_BAY_CFG_MASK,
+				   current_fmt->reg_bay_cfg);
+		regmap_update_bits(regmap, ISC_CFA_CFG, ISC_BAY_CFG_MASK,
+				   current_fmt->reg_bay_cfg);
+	}
+
+	val |= subdev->pfe_cfg0 | ISC_PFE_CFG0_MODE_PROGRESSIVE;
+	mask = ISC_PFE_CFG0_BPS_MASK | ISC_PFE_CFG0_HPOL_LOW |
+	       ISC_PFE_CFG0_VPOL_LOW | ISC_PFE_CFG0_PPOL_LOW |
+	       ISC_PFE_CFG0_MODE_MASK;
+
+	regmap_update_bits(regmap, ISC_PFE_CFG0, mask, val);
+
+	regmap_update_bits(regmap, ISC_RLP_CFG, ISC_RLP_CFG_MODE_MASK,
+			   current_fmt->reg_rlp_mode);
+
+	regmap_update_bits(regmap, ISC_DCFG, ISC_DCFG_IMODE_MASK,
+			   current_fmt->reg_dcfg_imode);
+
+	isc_set_pipeline(isc, pipeline);
+
+	/* Update profile */
+	regmap_write(regmap, ISC_CTRLEN, ISC_CTRL_UPPRO);
+
+	regmap_read(regmap, ISC_CTRLSR, &val);
+	while ((val & ISC_CTRL_UPPRO) && counter--) {
+		usleep_range(1000, 2000);
+		regmap_read(regmap, ISC_CTRLSR, &val);
+	}
+
+	if (counter < 0)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int isc_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct isc_device *isc = vb2_get_drv_priv(vq);
+	struct regmap *regmap = isc->regmap;
+	struct isc_buffer *buf;
+	unsigned long flags;
+	int ret;
+	u32 val;
+
+	/* Enable stream on the sub device */
+	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 1);
+	if (ret && ret != -ENOIOCTLCMD) {
+		v4l2_err(&isc->v4l2_dev, "stream on failed in subdev\n");
+		goto err;
+	}
+
+	pm_runtime_get_sync(isc->dev);
+
+	/* Disable all the interrupts */
+	regmap_write(isc->regmap, ISC_INTDIS, (u32)~0UL);
+
+	/* Clean the interrupt status register */
+	regmap_read(regmap, ISC_INTSR, &val);
+
+	ret = isc_configure(isc);
+	if (unlikely(ret))
+		goto err;
+
+	/* Enable DMA interrupt */
+	regmap_write(regmap, ISC_INTEN, ISC_INT_DDONE);
+
+	spin_lock_irqsave(&isc->dma_queue_lock, flags);
+
+	isc->sequence = 0;
+	isc->stop = false;
+	reinit_completion(&isc->comp);
+
+	isc->cur_frm = list_first_entry(&isc->dma_queue,
+					struct isc_buffer, list);
+	list_del(&isc->cur_frm->list);
+
+	isc_start_dma(regmap, isc->cur_frm, isc->current_fmt->reg_dctrl_dview);
+
+	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
+
+	return 0;
+
+err:
+	pm_runtime_put_sync(isc->dev);
+
+	spin_lock_irqsave(&isc->dma_queue_lock, flags);
+	list_for_each_entry(buf, &isc->dma_queue, list)
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	INIT_LIST_HEAD(&isc->dma_queue);
+	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
+
+	return ret;
+}
+
+static void isc_stop_streaming(struct vb2_queue *vq)
+{
+	struct isc_device *isc = vb2_get_drv_priv(vq);
+	unsigned long flags;
+	struct isc_buffer *buf;
+	int ret;
+
+	isc->stop = true;
+
+	/* Wait until the end of the current frame */
+	if (isc->cur_frm && !wait_for_completion_timeout(&isc->comp, 5 * HZ))
+		v4l2_err(&isc->v4l2_dev,
+			 "Timeout waiting for end of the capture\n");
+
+	/* Disable DMA interrupt */
+	regmap_write(isc->regmap, ISC_INTDIS, ISC_INT_DDONE);
+
+	pm_runtime_put_sync(isc->dev);
+
+	/* Disable stream on the sub device */
+	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_stream, 0);
+	if (ret && ret != -ENOIOCTLCMD)
+		v4l2_err(&isc->v4l2_dev, "stream off failed in subdev\n");
+
+	/* Release all active buffers */
+	spin_lock_irqsave(&isc->dma_queue_lock, flags);
+	if (unlikely(isc->cur_frm)) {
+		vb2_buffer_done(&isc->cur_frm->vb.vb2_buf,
+				VB2_BUF_STATE_ERROR);
+		isc->cur_frm = NULL;
+	}
+	list_for_each_entry(buf, &isc->dma_queue, list)
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	INIT_LIST_HEAD(&isc->dma_queue);
+	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
+}
+
+static void isc_buffer_queue(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+	struct isc_buffer *buf = container_of(vbuf, struct isc_buffer, vb);
+	struct isc_device *isc = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned long flags;
+
+	spin_lock_irqsave(&isc->dma_queue_lock, flags);
+	list_add_tail(&buf->list, &isc->dma_queue);
+	spin_unlock_irqrestore(&isc->dma_queue_lock, flags);
+}
+
+static struct vb2_ops isc_vb2_ops = {
+	.queue_setup		= isc_queue_setup,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
+	.buf_prepare		= isc_buffer_prepare,
+	.start_streaming	= isc_start_streaming,
+	.stop_streaming		= isc_stop_streaming,
+	.buf_queue		= isc_buffer_queue,
+};
+
+static int isc_querycap(struct file *file, void *priv,
+			 struct v4l2_capability *cap)
+{
+	struct isc_device *isc = video_drvdata(file);
+
+	strcpy(cap->driver, ATMEL_ISC_NAME);
+	strcpy(cap->card, "Atmel Image Sensor Controller");
+	snprintf(cap->bus_info, sizeof(cap->bus_info),
+		 "platform:%s", isc->v4l2_dev.name);
+
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int isc_enum_fmt_vid_cap(struct file *file, void *priv,
+				 struct v4l2_fmtdesc *f)
+{
+	struct isc_device *isc = video_drvdata(file);
+	u32 index = f->index;
+
+	if (index >= isc->num_user_formats)
+		return -EINVAL;
+
+	f->pixelformat = isc->user_formats[index]->fourcc;
+
+	return 0;
+}
+
+static int isc_g_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *fmt)
+{
+	struct isc_device *isc = video_drvdata(file);
+
+	*fmt = isc->fmt;
+
+	return 0;
+}
+
+static struct isc_format *find_format_by_fourcc(struct isc_device *isc,
+						 unsigned int fourcc)
+{
+	unsigned int num_formats = isc->num_user_formats;
+	struct isc_format *fmt;
+	unsigned int i;
+
+	for (i = 0; i < num_formats; i++) {
+		fmt = isc->user_formats[i];
+		if (fmt->fourcc == fourcc)
+			return fmt;
+	}
+
+	return NULL;
+}
+
+static int isc_try_fmt(struct isc_device *isc, struct v4l2_format *f,
+			struct isc_format **current_fmt, u32 *code)
+{
+	struct isc_format *isc_fmt;
+	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_TRY,
+	};
+	u32 mbus_code;
+	int ret;
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	isc_fmt = find_format_by_fourcc(isc, pixfmt->pixelformat);
+	if (!isc_fmt) {
+		v4l2_warn(&isc->v4l2_dev, "Format 0x%x not found\n",
+			  pixfmt->pixelformat);
+		isc_fmt = isc->user_formats[isc->num_user_formats - 1];
+		pixfmt->pixelformat = isc_fmt->fourcc;
+	}
+
+	/* Limit to Atmel ISC hardware capabilities */
+	if (pixfmt->width > ISC_MAX_SUPPORT_WIDTH)
+		pixfmt->width = ISC_MAX_SUPPORT_WIDTH;
+	if (pixfmt->height > ISC_MAX_SUPPORT_HEIGHT)
+		pixfmt->height = ISC_MAX_SUPPORT_HEIGHT;
+
+	if (sensor_is_preferred(isc_fmt))
+		mbus_code = isc_fmt->sd_mbus_code;
+	else
+		mbus_code = isc_fmt->isc_mbus_code;
+
+	v4l2_fill_mbus_format(&format.format, pixfmt, mbus_code);
+	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, set_fmt,
+			       isc->current_subdev->config, &format);
+	if (ret < 0)
+		return ret;
+
+	v4l2_fill_pix_format(pixfmt, &format.format);
+
+	switch (pixfmt->field) {
+	case V4L2_FIELD_ANY:
+	case V4L2_FIELD_NONE:
+		break;
+	default:
+		v4l2_err(&isc->v4l2_dev, "Field type %d unsupported.\n",
+			 pixfmt->field);
+		return -EINVAL;
+	}
+
+	pixfmt->bytesperline = pixfmt->width * isc_fmt->bpp;
+	pixfmt->sizeimage = pixfmt->bytesperline * pixfmt->height;
+
+	if (current_fmt)
+		*current_fmt = isc_fmt;
+
+	if (code)
+		*code = mbus_code;
+
+	return 0;
+}
+
+static int isc_set_fmt(struct isc_device *isc, struct v4l2_format *f)
+{
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	struct isc_format *current_fmt;
+	int ret;
+	u32 mbus_code;
+
+	ret = isc_try_fmt(isc, f, &current_fmt, &mbus_code);
+	if (ret)
+		return ret;
+
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, mbus_code);
+	ret = v4l2_subdev_call(isc->current_subdev->sd, pad,
+			       set_fmt, NULL, &format);
+	if (ret < 0)
+		return ret;
+
+	isc->fmt = *f;
+	isc->current_fmt = current_fmt;
+
+	return 0;
+}
+
+static int isc_s_fmt_vid_cap(struct file *file, void *priv,
+			      struct v4l2_format *f)
+{
+	struct isc_device *isc = video_drvdata(file);
+
+	if (vb2_is_streaming(&isc->vb2_vidq))
+		return -EBUSY;
+
+	return isc_set_fmt(isc, f);
+}
+
+static int isc_try_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct isc_device *isc = video_drvdata(file);
+
+	return isc_try_fmt(isc, f, NULL, NULL);
+}
+
+static int isc_enum_input(struct file *file, void *priv,
+			   struct v4l2_input *inp)
+{
+	if (inp->index != 0)
+		return -EINVAL;
+
+	inp->type = V4L2_INPUT_TYPE_CAMERA;
+	inp->std = 0;
+	strcpy(inp->name, "Camera");
+
+	return 0;
+}
+
+static int isc_g_input(struct file *file, void *priv, unsigned int *i)
+{
+	*i = 0;
+
+	return 0;
+}
+
+static int isc_s_input(struct file *file, void *priv, unsigned int i)
+{
+	if (i > 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int isc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct isc_device *isc = video_drvdata(file);
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	ret = v4l2_subdev_call(isc->current_subdev->sd, video, g_parm, a);
+	if (ret == -ENOIOCTLCMD)
+		ret = 0;
+
+	return ret;
+}
+
+static int isc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
+{
+	struct isc_device *isc = video_drvdata(file);
+	int ret;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	ret = v4l2_subdev_call(isc->current_subdev->sd, video, s_parm, a);
+	if (ret == -ENOIOCTLCMD)
+		ret = 0;
+
+	return ret;
+}
+
+static const struct v4l2_ioctl_ops isc_ioctl_ops = {
+	.vidioc_querycap		= isc_querycap,
+	.vidioc_enum_fmt_vid_cap	= isc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap		= isc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap		= isc_s_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap		= isc_try_fmt_vid_cap,
+
+	.vidioc_enum_input		= isc_enum_input,
+	.vidioc_g_input			= isc_g_input,
+	.vidioc_s_input			= isc_s_input,
+
+	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
+	.vidioc_querybuf		= vb2_ioctl_querybuf,
+	.vidioc_qbuf			= vb2_ioctl_qbuf,
+	.vidioc_expbuf			= vb2_ioctl_expbuf,
+	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
+	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
+	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
+	.vidioc_streamon		= vb2_ioctl_streamon,
+	.vidioc_streamoff		= vb2_ioctl_streamoff,
+
+	.vidioc_g_parm			= isc_g_parm,
+	.vidioc_s_parm			= isc_s_parm,
+};
+
+static int isc_set_default_fmt(struct isc_device *isc)
+{
+	u32 index = isc->num_user_formats - 1;
+	struct v4l2_format f = {
+		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+		.fmt.pix = {
+			.width		= VGA_WIDTH,
+			.height		= VGA_HEIGHT,
+			.field		= V4L2_FIELD_ANY,
+			.pixelformat	= isc->user_formats[index]->fourcc,
+		},
+	};
+
+	return isc_set_fmt(isc, &f);
+}
+
+static int isc_open(struct file *file)
+{
+	struct isc_device *isc = video_drvdata(file);
+	struct v4l2_subdev *sd = isc->current_subdev->sd;
+	int ret;
+
+	if (mutex_lock_interruptible(&isc->lock))
+		return -ERESTARTSYS;
+
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
+		goto unlock;
+
+	ret = v4l2_subdev_call(sd, core, s_power, 1);
+	if (ret < 0 && ret != -ENOIOCTLCMD)
+		goto unlock;
+
+	ret = isc_set_default_fmt(isc);
+	if (ret)
+		goto unlock;
+
+unlock:
+	mutex_unlock(&isc->lock);
+	return ret;
+}
+
+static int isc_release(struct file *file)
+{
+	struct isc_device *isc = video_drvdata(file);
+	struct v4l2_subdev *sd = isc->current_subdev->sd;
+	int ret;
+
+	mutex_lock(&isc->lock);
+
+	ret = _vb2_fop_release(file, NULL);
+
+	v4l2_subdev_call(sd, core, s_power, 0);
+
+	mutex_unlock(&isc->lock);
+
+	return ret;
+}
+
+static const struct v4l2_file_operations isc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= isc_open,
+	.release	= isc_release,
+	.unlocked_ioctl	= video_ioctl2,
+	.read		= vb2_fop_read,
+	.mmap		= vb2_fop_mmap,
+	.poll		= vb2_fop_poll,
+};
+
+static irqreturn_t isc_interrupt(int irq, void *dev_id)
+{
+	struct isc_device *isc = (struct isc_device *)dev_id;
+	struct regmap *regmap = isc->regmap;
+	u32 isc_intsr, isc_intmask, pending;
+	irqreturn_t ret = IRQ_NONE;
+
+	spin_lock(&isc->dma_queue_lock);
+
+	regmap_read(regmap, ISC_INTSR, &isc_intsr);
+	regmap_read(regmap, ISC_INTMASK, &isc_intmask);
+
+	pending = isc_intsr & isc_intmask;
+
+	if (likely(pending & ISC_INT_DDONE)) {
+		if (isc->cur_frm) {
+			struct vb2_v4l2_buffer *vbuf = &isc->cur_frm->vb;
+			struct vb2_buffer *vb = &vbuf->vb2_buf;
+
+			vb->timestamp = ktime_get_ns();
+			vbuf->sequence = isc->sequence++;
+			vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
+			isc->cur_frm = NULL;
+		}
+
+		if (!list_empty(&isc->dma_queue) && !isc->stop) {
+			isc->cur_frm = list_first_entry(&isc->dma_queue,
+						     struct isc_buffer, list);
+			list_del(&isc->cur_frm->list);
+
+			isc_start_dma(regmap, isc->cur_frm,
+				      isc->current_fmt->reg_dctrl_dview);
+		}
+
+		if (isc->stop)
+			complete(&isc->comp);
+
+		ret = IRQ_HANDLED;
+	}
+
+	spin_unlock(&isc->dma_queue_lock);
+
+	return ret;
+}
+
+static int isc_async_bound(struct v4l2_async_notifier *notifier,
+			    struct v4l2_subdev *subdev,
+			    struct v4l2_async_subdev *asd)
+{
+	struct isc_device *isc = container_of(notifier->v4l2_dev,
+					      struct isc_device, v4l2_dev);
+	struct isc_subdev_entity *subdev_entity =
+		container_of(notifier, struct isc_subdev_entity, notifier);
+
+	if (video_is_registered(&isc->video_dev)) {
+		v4l2_err(&isc->v4l2_dev, "only supports one sub-device.\n");
+		return -EBUSY;
+	}
+
+	subdev_entity->sd = subdev;
+
+	return 0;
+}
+
+static void isc_async_unbind(struct v4l2_async_notifier *notifier,
+			      struct v4l2_subdev *subdev,
+			      struct v4l2_async_subdev *asd)
+{
+	struct isc_device *isc = container_of(notifier->v4l2_dev,
+					      struct isc_device, v4l2_dev);
+
+	video_unregister_device(&isc->video_dev);
+	if (isc->current_subdev->config)
+		v4l2_subdev_free_pad_config(isc->current_subdev->config);
+}
+
+static struct isc_format *find_format_by_code(unsigned int code, int *index)
+{
+	struct isc_format *fmt = &isc_formats[0];
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
+		if (fmt->sd_mbus_code == code) {
+			*index = i;
+			return fmt;
+		}
+
+		fmt++;
+	}
+
+	return NULL;
+}
+
+static int isc_formats_init(struct isc_device *isc)
+{
+	struct isc_format *fmt;
+	struct v4l2_subdev *subdev = isc->current_subdev->sd;
+	int num_fmts, i, j;
+	struct v4l2_subdev_mbus_code_enum mbus_code = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+
+	fmt = &isc_formats[0];
+	for (i = 0; i < ARRAY_SIZE(isc_formats); i++) {
+		fmt->isc_support = false;
+		fmt->sd_support = false;
+
+		fmt++;
+	}
+
+	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code,
+	       NULL, &mbus_code)) {
+		mbus_code.index++;
+		fmt = find_format_by_code(mbus_code.code, &i);
+		if (!fmt)
+			continue;
+
+		fmt->sd_support = true;
+
+		if (i <= RAW_FMT_INDEX_END) {
+			for (j = ISC_FMT_INDEX_START;
+			     j <= ISC_FMT_INDEX_END; j++) {
+				isc_formats[j].isc_support = true;
+				isc_formats[j].isc_mbus_code = mbus_code.code;
+				isc_formats[j].reg_isc_bps = fmt->reg_sd_bps;
+				isc_formats[j].reg_bay_cfg = fmt->reg_bay_cfg;
+			}
+		}
+	}
+
+	fmt = &isc_formats[0];
+	for (i = 0, num_fmts = 0; i < ARRAY_SIZE(isc_formats); i++) {
+		if (fmt->isc_support || fmt->sd_support)
+			num_fmts++;
+
+		fmt++;
+	}
+
+	if (!num_fmts)
+		return -ENXIO;
+
+	isc->num_user_formats = num_fmts;
+	isc->user_formats = devm_kcalloc(isc->dev,
+					 num_fmts, sizeof(struct isc_format *),
+					 GFP_KERNEL);
+	if (!isc->user_formats) {
+		v4l2_err(&isc->v4l2_dev, "could not allocate memory\n");
+		return -ENOMEM;
+	}
+
+	fmt = &isc_formats[0];
+	for (i = 0, j = 0; i < ARRAY_SIZE(isc_formats); i++) {
+		if (fmt->isc_support || fmt->sd_support)
+			isc->user_formats[j++] = fmt;
+
+		fmt++;
+	}
+
+	return 0;
+}
+
+static int isc_async_complete(struct v4l2_async_notifier *notifier)
+{
+	struct isc_device *isc = container_of(notifier->v4l2_dev,
+					      struct isc_device, v4l2_dev);
+	struct isc_subdev_entity *sd_entity;
+	struct video_device *vdev = &isc->video_dev;
+	struct vb2_queue *q = &isc->vb2_vidq;
+	int ret;
+
+	isc->current_subdev = container_of(notifier,
+					   struct isc_subdev_entity, notifier);
+
+	mutex_init(&isc->lock);
+	init_completion(&isc->comp);
+
+	/* Initialize videobuf2 queue */
+	q->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	q->io_modes		= VB2_MMAP;
+	q->drv_priv		= isc;
+	q->buf_struct_size	= sizeof(struct isc_buffer);
+	q->ops			= &isc_vb2_ops;
+	q->mem_ops		= &vb2_dma_contig_memops;
+	q->timestamp_flags	= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	q->lock			= &isc->lock;
+	q->min_buffers_needed	= 1;
+
+	ret = vb2_queue_init(q);
+	if (ret < 0) {
+		v4l2_err(&isc->v4l2_dev,
+			 "vb2_queue_init() failed: %d\n", ret);
+		return ret;
+	}
+
+	/* Init video dma queues */
+	INIT_LIST_HEAD(&isc->dma_queue);
+	spin_lock_init(&isc->dma_queue_lock);
+
+	/* Register video device */
+	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
+	vdev->release		= video_device_release_empty;
+	vdev->fops		= &isc_fops;
+	vdev->ioctl_ops		= &isc_ioctl_ops;
+	vdev->v4l2_dev		= &isc->v4l2_dev;
+	vdev->vfl_dir		= VFL_DIR_RX;
+	vdev->queue		= q;
+	vdev->lock		= &isc->lock;
+	vdev->ctrl_handler	= isc->current_subdev->sd->ctrl_handler;
+	video_set_drvdata(vdev, isc);
+
+	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
+	if (ret < 0) {
+		v4l2_err(&isc->v4l2_dev,
+			 "video_register_device failed: %d\n", ret);
+		return ret;
+	}
+
+	sd_entity = isc->current_subdev;
+	sd_entity->config = v4l2_subdev_alloc_pad_config(sd_entity->sd);
+	if (sd_entity->config == NULL)
+		return -ENOMEM;
+
+	ret = isc_formats_init(isc);
+	if (ret < 0) {
+		v4l2_err(&isc->v4l2_dev,
+			 "Init format failed: %d\n", ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void isc_subdev_cleanup(struct isc_device *isc)
+{
+	struct isc_subdev_entity *subdev_entity;
+
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+		v4l2_async_notifier_unregister(&subdev_entity->notifier);
+
+	INIT_LIST_HEAD(&isc->subdev_entities);
+}
+
+static int isc_pipeline_init(struct isc_device *isc)
+{
+	struct device *dev = isc->dev;
+	struct regmap *regmap = isc->regmap;
+	struct regmap_field *regs;
+	unsigned int i;
+
+	/* WB-->CFA-->CC-->GAM-->CSC-->CBC-->SUB422-->SUB420 */
+	static const struct reg_field regfields[ISC_PIPE_LINE_NODE_NUM] = {
+		REG_FIELD(ISC_WB_CTRL, 0, 0),
+		REG_FIELD(ISC_CFA_CTRL, 0, 0),
+		REG_FIELD(ISC_CC_CTRL, 0, 0),
+		REG_FIELD(ISC_GAM_CTRL, 0, 0),
+		REG_FIELD(ISC_GAM_CTRL, 1, 1),
+		REG_FIELD(ISC_GAM_CTRL, 2, 2),
+		REG_FIELD(ISC_GAM_CTRL, 3, 3),
+		REG_FIELD(ISC_CSC_CTRL, 0, 0),
+		REG_FIELD(ISC_CBC_CTRL, 0, 0),
+		REG_FIELD(ISC_SUB422_CTRL, 0, 0),
+		REG_FIELD(ISC_SUB420_CTRL, 0, 0),
+	};
+
+	for (i = 0; i < ISC_PIPE_LINE_NODE_NUM; i++) {
+		regs = devm_regmap_field_alloc(dev, regmap, regfields[i]);
+		if (IS_ERR(regs))
+			return PTR_ERR(regs);
+
+		isc->pipeline[i] =  regs;
+	}
+
+	return 0;
+}
+
+static int isc_parse_dt(struct device *dev, struct isc_device *isc)
+{
+	struct device_node *np = dev->of_node;
+	struct device_node *epn = NULL, *rem;
+	struct v4l2_of_endpoint v4l2_epn;
+	struct isc_subdev_entity *subdev_entity;
+	unsigned int flags;
+	int ret;
+
+	INIT_LIST_HEAD(&isc->subdev_entities);
+
+	for (; ;) {
+		epn = of_graph_get_next_endpoint(np, epn);
+		if (!epn)
+			break;
+
+		rem = of_graph_get_remote_port_parent(epn);
+		if (!rem) {
+			dev_notice(dev, "Remote device at %s not found\n",
+				   of_node_full_name(epn));
+			continue;
+		}
+
+		ret = v4l2_of_parse_endpoint(epn, &v4l2_epn);
+		if (ret) {
+			of_node_put(rem);
+			ret = -EINVAL;
+			dev_err(dev, "Could not parse the endpoint\n");
+			break;
+		}
+
+		subdev_entity = devm_kzalloc(dev,
+					  sizeof(*subdev_entity), GFP_KERNEL);
+		if (subdev_entity == NULL) {
+			of_node_put(rem);
+			ret = -ENOMEM;
+			break;
+		}
+
+		subdev_entity->asd = devm_kzalloc(dev,
+				     sizeof(*subdev_entity->asd), GFP_KERNEL);
+		if (subdev_entity->asd == NULL) {
+			of_node_put(rem);
+			ret = -ENOMEM;
+			break;
+		}
+
+		flags = v4l2_epn.bus.parallel.flags;
+
+		if (flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
+			subdev_entity->pfe_cfg0 = ISC_PFE_CFG0_HPOL_LOW;
+
+		if (flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
+			subdev_entity->pfe_cfg0 |= ISC_PFE_CFG0_VPOL_LOW;
+
+		if (flags & V4L2_MBUS_PCLK_SAMPLE_FALLING)
+			subdev_entity->pfe_cfg0 |= ISC_PFE_CFG0_PPOL_LOW;
+
+		subdev_entity->asd->match_type = V4L2_ASYNC_MATCH_OF;
+		subdev_entity->asd->match.of.node = rem;
+		list_add_tail(&subdev_entity->list, &isc->subdev_entities);
+	}
+
+	of_node_put(epn);
+	return ret;
+}
+
+/* regmap configuration */
+#define ATMEL_ISC_REG_MAX    0xbfc
+static const struct regmap_config isc_regmap_config = {
+	.reg_bits       = 32,
+	.reg_stride     = 4,
+	.val_bits       = 32,
+	.max_register	= ATMEL_ISC_REG_MAX,
+};
+
+static int atmel_isc_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct isc_device *isc;
+	struct resource *res;
+	void __iomem *io_base;
+	struct isc_subdev_entity *subdev_entity;
+	int irq;
+	int ret;
+
+	isc = devm_kzalloc(dev, sizeof(*isc), GFP_KERNEL);
+	if (!isc)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, isc);
+	isc->dev = dev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	io_base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(io_base))
+		return PTR_ERR(io_base);
+
+	isc->regmap = devm_regmap_init_mmio(dev, io_base, &isc_regmap_config);
+	if (IS_ERR(isc->regmap)) {
+		ret = PTR_ERR(isc->regmap);
+		dev_err(dev, "failed to init register map: %d\n", ret);
+		return ret;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (IS_ERR_VALUE(irq)) {
+		ret = irq;
+		dev_err(dev, "failed to get irq: %d\n", ret);
+		return ret;
+	}
+
+	ret = devm_request_irq(dev, irq, isc_interrupt, 0,
+			       ATMEL_ISC_NAME, isc);
+	if (ret < 0) {
+		dev_err(dev, "can't register ISR for IRQ %u (ret=%i)\n",
+			irq, ret);
+		return ret;
+	}
+
+	ret = isc_pipeline_init(isc);
+	if (ret)
+		return ret;
+
+	isc->hclock = devm_clk_get(dev, "hclock");
+	if (IS_ERR(isc->hclock)) {
+		ret = PTR_ERR(isc->hclock);
+		dev_err(dev, "failed to get hclock: %d\n", ret);
+		return ret;
+	}
+
+	ret = isc_clk_init(isc);
+	if (ret) {
+		dev_err(dev, "failed to init isc clock: %d\n", ret);
+		goto clean_isc_clk;
+	}
+
+	isc->ispck = isc->isc_clks[ISC_ISPCK].clk;
+
+	/* ispck should be greater or equal to hclock */
+	ret = clk_set_rate(isc->ispck, clk_get_rate(isc->hclock));
+	if (ret) {
+		dev_err(dev, "failed to set ispck rate: %d\n", ret);
+		goto clean_isc_clk;
+	}
+
+	ret = v4l2_device_register(dev, &isc->v4l2_dev);
+	if (ret) {
+		dev_err(dev, "unable to register v4l2 device.\n");
+		goto clean_isc_clk;
+	}
+
+	ret = isc_parse_dt(dev, isc);
+	if (ret) {
+		dev_err(dev, "fail to parse device tree\n");
+		goto unregister_v4l2_device;
+	}
+
+	if (list_empty(&isc->subdev_entities)) {
+		dev_err(dev, "no subdev found\n");
+		goto unregister_v4l2_device;
+	}
+
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list) {
+		subdev_entity->notifier.subdevs = &subdev_entity->asd;
+		subdev_entity->notifier.num_subdevs = 1;
+		subdev_entity->notifier.bound = isc_async_bound;
+		subdev_entity->notifier.unbind = isc_async_unbind;
+		subdev_entity->notifier.complete = isc_async_complete;
+
+		ret = v4l2_async_notifier_register(&isc->v4l2_dev,
+						   &subdev_entity->notifier);
+		if (ret) {
+			dev_err(dev, "fail to register async notifier\n");
+			goto cleanup_subdev;
+		}
+
+		if (video_is_registered(&isc->video_dev))
+			break;
+	}
+
+	pm_runtime_enable(dev);
+
+	return 0;
+
+cleanup_subdev:
+	isc_subdev_cleanup(isc);
+
+unregister_v4l2_device:
+	v4l2_device_unregister(&isc->v4l2_dev);
+
+clean_isc_clk:
+	isc_clk_cleanup(isc);
+
+	return ret;
+}
+
+static int atmel_isc_remove(struct platform_device *pdev)
+{
+	struct isc_device *isc = platform_get_drvdata(pdev);
+
+	pm_runtime_disable(&pdev->dev);
+
+	isc_subdev_cleanup(isc);
+
+	v4l2_device_unregister(&isc->v4l2_dev);
+
+	isc_clk_cleanup(isc);
+
+	return 0;
+}
+
+static int isc_runtime_suspend(struct device *dev)
+{
+	struct isc_device *isc = dev_get_drvdata(dev);
+
+	clk_disable_unprepare(isc->ispck);
+	clk_disable_unprepare(isc->hclock);
+
+	return 0;
+}
+
+static int isc_runtime_resume(struct device *dev)
+{
+	struct isc_device *isc = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(isc->hclock);
+	if (ret)
+		return ret;
+
+	return clk_prepare_enable(isc->ispck);
+}
+
+static const struct dev_pm_ops atmel_isc_dev_pm_ops = {
+	SET_RUNTIME_PM_OPS(isc_runtime_suspend, isc_runtime_resume, NULL)
+};
+
+static const struct of_device_id atmel_isc_of_match[] = {
+	{ .compatible = "atmel,sama5d2-isc" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, atmel_isc_of_match);
+
+static struct platform_driver atmel_isc_driver = {
+	.probe	= atmel_isc_probe,
+	.remove	= atmel_isc_remove,
+	.driver	= {
+		.name		= ATMEL_ISC_NAME,
+		.pm		= &atmel_isc_dev_pm_ops,
+		.of_match_table = of_match_ptr(atmel_isc_of_match),
+	},
+};
+
+module_platform_driver(atmel_isc_driver);
+
+MODULE_AUTHOR("Songjun Wu <songjun.wu@atmel.com>");
+MODULE_DESCRIPTION("The V4L2 driver for Atmel-ISC");
+MODULE_LICENSE("GPL v2");
+MODULE_SUPPORTED_DEVICE("video");
-- 
2.7.4

