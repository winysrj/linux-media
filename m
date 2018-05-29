Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-sn1nam01on0079.outbound.protection.outlook.com ([104.47.32.79]:43136
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965974AbeE2S5r (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 14:57:47 -0400
From: Vishal Sagar <vishal.sagar@xilinx.com>
To: <hyun.kwon@xilinx.com>, <laurent.pinchart@ideasonboard.com>,
        <michal.simek@xilinx.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <sakari.ailus@linux.intel.com>, <hans.verkuil@cisco.com>,
        <mchehab@kernel.org>, <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <dineshk@xilinx.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Vishal Sagar <vishal.sagar@xilinx.com>
Subject: [PATCH 2/2] media: v4l: xilinx: Add Xilinx MIPI CSI-2 Rx Subsystem driver
Date: Wed, 30 May 2018 00:24:44 +0530
Message-ID: <1527620084-94864-3-git-send-email-vishal.sagar@xilinx.com>
In-Reply-To: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
References: <1527620084-94864-1-git-send-email-vishal.sagar@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Xilinx MIPI CSI-2 Rx Subsystem soft IP is used to capture images
from MIPI CSI-2 camera sensors and output AXI4-Stream video data ready
for image processing.

It supports upto 4 lanes, filtering based on Virtual Channel selected in
IP, an optional Xilinx IIC controller, optional register interface for
the DPHY, multiple color formats, short packet capture,

This driver helps configure the number of active lanes to be set,
setting and handling interrupts and IP core enable.
It logs the count of events occurring according to their type between
streaming ON and OFF. The short packet reception is notified to
application via v4l2_event.

Signed-off-by: Vishal Sagar <vishal.sagar@xilinx.com>
---
 drivers/media/platform/xilinx/Kconfig           |   12 +
 drivers/media/platform/xilinx/Makefile          |    1 +
 drivers/media/platform/xilinx/xilinx-csi2rxss.c | 1751 +++++++++++++++++++=
++++
 include/uapi/linux/xilinx-csi2rxss.h            |   25 +
 include/uapi/linux/xilinx-v4l2-controls.h       |   14 +
 5 files changed, 1803 insertions(+)
 create mode 100644 drivers/media/platform/xilinx/xilinx-csi2rxss.c
 create mode 100644 include/uapi/linux/xilinx-csi2rxss.h

diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform=
/xilinx/Kconfig
index a5d21b7..06d5944 100644
--- a/drivers/media/platform/xilinx/Kconfig
+++ b/drivers/media/platform/xilinx/Kconfig
@@ -8,6 +8,18 @@ config VIDEO_XILINX

 if VIDEO_XILINX

+config VIDEO_XILINX_CSI2RXSS
+       tristate "Xilinx CSI2 Rx Subsystem"
+       depends on VIDEO_XILINX
+       help
+         Driver for Xilinx MIPI CSI2 Rx Subsystem. This is a V4L sub-devic=
e
+         based driver that takes input from CSI2 Tx source and converts
+         it into an AXI4-Stream. It has a DPHY (whose register interface
+         can be enabled, an optional I2C controller and an optional Video
+         Format Bridge which converts the AXI4-Stream data to Xilinx Video
+         Bus formats based on UG934. The driver is used to set the number
+         of active lanes and get short packet data.
+
 config VIDEO_XILINX_TPG
        tristate "Xilinx Video Test Pattern Generator"
        depends on VIDEO_XILINX
diff --git a/drivers/media/platform/xilinx/Makefile b/drivers/media/platfor=
m/xilinx/Makefile
index e8a0f2a..768f079 100644
--- a/drivers/media/platform/xilinx/Makefile
+++ b/drivers/media/platform/xilinx/Makefile
@@ -1,5 +1,6 @@
 xilinx-video-objs +=3D xilinx-dma.o xilinx-vip.o xilinx-vipp.o

 obj-$(CONFIG_VIDEO_XILINX) +=3D xilinx-video.o
+obj-$(CONFIG_VIDEO_XILINX_CSI2RXSS) +=3D xilinx-csi2rxss.o
 obj-$(CONFIG_VIDEO_XILINX_TPG) +=3D xilinx-tpg.o
 obj-$(CONFIG_VIDEO_XILINX_VTC) +=3D xilinx-vtc.o
diff --git a/drivers/media/platform/xilinx/xilinx-csi2rxss.c b/drivers/medi=
a/platform/xilinx/xilinx-csi2rxss.c
new file mode 100644
index 0000000..03f387c
--- /dev/null
+++ b/drivers/media/platform/xilinx/xilinx-csi2rxss.c
@@ -0,0 +1,1751 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Driver for Xilinx MIPI CSI2 Rx Subsystem
+ *
+ * Copyright (C) 2016 - 2018 Xilinx, Inc.
+ *
+ * Contacts: Vishal Sagar <vishal.sagar@xilinx.com>
+ *
+ */
+
+#include <dt-bindings/media/xilinx-vip.h>
+#include <linux/bitops.h>
+#include <linux/compiler.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/spinlock_types.h>
+#include <linux/types.h>
+#include <linux/v4l2-subdev.h>
+#include <linux/xilinx-csi2rxss.h>
+#include <linux/xilinx-v4l2-controls.h>
+#include <media/media-entity.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-subdev.h>
+#include "xilinx-vip.h"
+
+/*
+ * MIPI CSI2 Rx register map, bitmask and offsets
+ */
+#define XCSI_CCR_OFFSET                        0x00000000
+#define XCSI_CCR_SOFTRESET_SHIFT       1
+#define XCSI_CCR_COREENB_SHIFT         0
+#define XCSI_CCR_SOFTRESET_MASK                BIT(XCSI_CCR_SOFTRESET_SHIF=
T)
+#define XCSI_CCR_COREENB_MASK          BIT(XCSI_CCR_COREENB_SHIFT)
+
+#define XCSI_PCR_OFFSET                        0x00000004
+#define XCSI_PCR_MAXLANES_MASK         0x00000018
+#define XCSI_PCR_ACTLANES_MASK         0x00000003
+#define XCSI_PCR_MAXLANES_SHIFT                3
+#define XCSI_PCR_ACTLANES_SHIFT                0
+
+#define XCSI_CSR_OFFSET                        0x00000010
+#define XCSI_CSR_PKTCOUNT_SHIFT                16
+#define XCSI_CSR_SPFIFOFULL_SHIFT      3
+#define XCSI_CSR_SPFIFONE_SHIFT                2
+#define XCSI_CSR_SLBF_SHIFT            1
+#define XCSI_CSR_RIPCD_SHIFT           0
+#define XCSI_CSR_PKTCOUNT_MASK         0xFFFF0000
+#define XCSI_CSR_SPFIFOFULL_MASK       BIT(XCSI_CSR_SPFIFOFULL_SHIFT)
+#define XCSI_CSR_SPFIFONE_MASK         BIT(XCSI_CSR_SPFIFONE_SHIFT)
+#define XCSI_CSR_SLBF_MASK             BIT(XCSI_CSR_SLBF_SHIFT)
+#define XCSI_CSR_RIPCD_MASK            BIT(XCSI_CSR_RIPCD_SHIFT)
+
+#define XCSI_GIER_OFFSET               0x00000020
+#define XCSI_GIER_GIE_SHIFT            0
+#define XCSI_GIER_GIE_MASK             BIT(XCSI_GIER_GIE_SHIFT)
+#define XCSI_GIER_SET                  1
+#define XCSI_GIER_RESET                        0
+
+#define XCSI_ISR_OFFSET                        0x00000024
+#define XCSI_ISR_FR_SHIFT              31
+#define XCSI_ISR_ILC_SHIFT             21
+#define XCSI_ISR_SPFIFOF_SHIFT         20
+#define XCSI_ISR_SPFIFONE_SHIFT                19
+#define XCSI_ISR_SLBF_SHIFT            18
+#define XCSI_ISR_STOP_SHIFT            17
+#define XCSI_ISR_SOTERR_SHIFT          13
+#define XCSI_ISR_SOTSYNCERR_SHIFT      12
+#define XCSI_ISR_ECC2BERR_SHIFT                11
+#define XCSI_ISR_ECC1BERR_SHIFT                10
+#define XCSI_ISR_CRCERR_SHIFT          9
+#define XCSI_ISR_DATAIDERR_SHIFT       8
+#define XCSI_ISR_VC3FSYNCERR_SHIFT     7
+#define XCSI_ISR_VC3FLVLERR_SHIFT      6
+#define XCSI_ISR_VC2FSYNCERR_SHIFT     5
+#define XCSI_ISR_VC2FLVLERR_SHIFT      4
+#define XCSI_ISR_VC1FSYNCERR_SHIFT     3
+#define XCSI_ISR_VC1FLVLERR_SHIFT      2
+#define XCSI_ISR_VC0FSYNCERR_SHIFT     1
+#define XCSI_ISR_VC0FLVLERR_SHIFT      0
+#define XCSI_ISR_FR_MASK               BIT(XCSI_ISR_FR_SHIFT)
+#define XCSI_ISR_ILC_MASK              BIT(XCSI_ISR_ILC_SHIFT)
+#define XCSI_ISR_SPFIFOF_MASK          BIT(XCSI_ISR_SPFIFOF_SHIFT)
+#define XCSI_ISR_SPFIFONE_MASK         BIT(XCSI_ISR_SPFIFONE_SHIFT)
+#define XCSI_ISR_SLBF_MASK             BIT(XCSI_ISR_SLBF_SHIFT)
+#define XCSI_ISR_STOP_MASK             BIT(XCSI_ISR_STOP_SHIFT)
+#define XCSI_ISR_SOTERR_MASK           BIT(XCSI_ISR_SOTERR_SHIFT)
+#define XCSI_ISR_SOTSYNCERR_MASK       BIT(XCSI_ISR_SOTSYNCERR_SHIFT)
+#define XCSI_ISR_ECC2BERR_MASK         BIT(XCSI_ISR_ECC2BERR_SHIFT)
+#define XCSI_ISR_ECC1BERR_MASK         BIT(XCSI_ISR_ECC1BERR_SHIFT)
+#define XCSI_ISR_CRCERR_MASK           BIT(XCSI_ISR_CRCERR_SHIFT)
+#define XCSI_ISR_DATAIDERR_MASK                BIT(XCSI_ISR_DATAIDERR_SHIF=
T)
+#define XCSI_ISR_VC3FSYNCERR_MASK      BIT(XCSI_ISR_VC3FSYNCERR_SHIFT)
+#define XCSI_ISR_VC3FLVLERR_MASK       BIT(XCSI_ISR_VC3FLVLERR_SHIFT)
+#define XCSI_ISR_VC2FSYNCERR_MASK      BIT(XCSI_ISR_VC2FSYNCERR_SHIFT)
+#define XCSI_ISR_VC2FLVLERR_MASK       BIT(XCSI_ISR_VC2FLVLERR_SHIFT)
+#define XCSI_ISR_VC1FSYNCERR_MASK      BIT(XCSI_ISR_VC1FSYNCERR_SHIFT)
+#define XCSI_ISR_VC1FLVLERR_MASK       BIT(XCSI_ISR_VC1FLVLERR_SHIFT)
+#define XCSI_ISR_VC0FSYNCERR_MASK      BIT(XCSI_ISR_VC0FSYNCERR_SHIFT)
+#define XCSI_ISR_VC0FLVLERR_MASK       BIT(XCSI_ISR_VC0FLVLERR_SHIFT)
+#define XCSI_ISR_ALLINTR_MASK          0x803FFFFF
+
+#define XCSI_INTR_PROT_MASK    (XCSI_ISR_VC3FSYNCERR_MASK |    \
+                                XCSI_ISR_VC3FLVLERR_MASK |     \
+                                XCSI_ISR_VC2FSYNCERR_MASK |    \
+                                XCSI_ISR_VC2FLVLERR_MASK |     \
+                                XCSI_ISR_VC1FSYNCERR_MASK |    \
+                                XCSI_ISR_VC1FLVLERR_MASK |     \
+                                XCSI_ISR_VC0FSYNCERR_MASK |    \
+                                XCSI_ISR_VC0FLVLERR_MASK)
+
+#define XCSI_INTR_PKTLVL_MASK  (XCSI_ISR_ECC2BERR_MASK |       \
+                                XCSI_ISR_ECC1BERR_MASK |       \
+                                XCSI_ISR_CRCERR_MASK   |       \
+                                XCSI_ISR_DATAIDERR_MASK)
+
+#define XCSI_INTR_DPHY_MASK    (XCSI_ISR_SOTERR_MASK   |       \
+                                XCSI_ISR_SOTSYNCERR_MASK)
+
+#define XCSI_INTR_SPKT_MASK    (XCSI_ISR_SPFIFOF_MASK |        \
+                                XCSI_ISR_SPFIFONE_MASK)
+
+#define XCSI_INTR_FRAMERCVD_MASK       (XCSI_ISR_FR_MASK)
+
+#define XCSI_INTR_ERR_MASK     (XCSI_ISR_ILC_MASK |    \
+                                XCSI_ISR_SLBF_MASK |   \
+                                XCSI_ISR_STOP_MASK)
+
+#define XCSI_IER_OFFSET                        0x00000028
+#define XCSI_IER_FR_SHIFT              31
+#define XCSI_IER_ILC_SHIFT             21
+#define XCSI_IER_SPFIFOF_SHIFT         20
+#define XCSI_IER_SPFIFONE_SHIFT                19
+#define XCSI_IER_SLBF_SHIFT            18
+#define XCSI_IER_STOP_SHIFT            17
+#define XCSI_IER_SOTERR_SHIFT          13
+#define XCSI_IER_SOTSYNCERR_SHIFT      12
+#define XCSI_IER_ECC2BERR_SHIFT                11
+#define XCSI_IER_ECC1BERR_SHIFT                10
+#define XCSI_IER_CRCERR_SHIFT          9
+#define XCSI_IER_DATAIDERR_SHIFT       8
+#define XCSI_IER_VC3FSYNCERR_SHIFT     7
+#define XCSI_IER_VC3FLVLERR_SHIFT      6
+#define XCSI_IER_VC2FSYNCERR_SHIFT     5
+#define XCSI_IER_VC2FLVLERR_SHIFT      4
+#define XCSI_IER_VC1FSYNCERR_SHIFT     3
+#define XCSI_IER_VC1FLVLERR_SHIFT      2
+#define XCSI_IER_VC0FSYNCERR_SHIFT     1
+#define XCSI_IER_VC0FLVLERR_SHIFT      0
+#define XCSI_IER_FR_MASK               BIT(XCSI_IER_FR_SHIFT)
+#define XCSI_IER_ILC_MASK              BIT(XCSI_IER_ILC_SHIFT)
+#define XCSI_IER_SPFIFOF_MASK          BIT(XCSI_IER_SPFIFOF_SHIFT)
+#define XCSI_IER_SPFIFONE_MASK         BIT(XCSI_IER_SPFIFONE_SHIFT)
+#define XCSI_IER_SLBF_MASK             BIT(XCSI_IER_SLBF_SHIFT)
+#define XCSI_IER_STOP_MASK             BIT(XCSI_IER_STOP_SHIFT)
+#define XCSI_IER_SOTERR_MASK           BIT(XCSI_IER_SOTERR_SHIFT)
+#define XCSI_IER_SOTSYNCERR_MASK       BIT(XCSI_IER_SOTSYNCERR_SHIFT)
+#define XCSI_IER_ECC2BERR_MASK         BIT(XCSI_IER_ECC2BERR_SHIFT)
+#define XCSI_IER_ECC1BERR_MASK         BIT(XCSI_IER_ECC1BERR_SHIFT)
+#define XCSI_IER_CRCERR_MASK           BIT(XCSI_IER_CRCERR_SHIFT)
+#define XCSI_IER_DATAIDERR_MASK                BIT(XCSI_IER_DATAIDERR_SHIF=
T)
+#define XCSI_IER_VC3FSYNCERR_MASK      BIT(XCSI_IER_VC3FSYNCERR_SHIFT)
+#define XCSI_IER_VC3FLVLERR_MASK       BIT(XCSI_IER_VC3FLVLERR_SHIFT)
+#define XCSI_IER_VC2FSYNCERR_MASK      BIT(XCSI_IER_VC2FSYNCERR_SHIFT)
+#define XCSI_IER_VC2FLVLERR_MASK       BIT(XCSI_IER_VC2FLVLERR_SHIFT)
+#define XCSI_IER_VC1FSYNCERR_MASK      BIT(XCSI_IER_VC1FSYNCERR_SHIFT)
+#define XCSI_IER_VC1FLVLERR_MASK       BIT(XCSI_IER_VC1FLVLERR_SHIFT)
+#define XCSI_IER_VC0FSYNCERR_MASK      BIT(XCSI_IER_VC0FSYNCERR_SHIFT)
+#define XCSI_IER_VC0FLVLERR_MASK       BIT(XCSI_IER_VC0FLVLERR_SHIFT)
+#define XCSI_IER_ALLINTR_MASK          0x803FFFFF
+
+#define XCSI_SPKTR_OFFSET              0x00000030
+#define XCSI_SPKTR_DATA_SHIFT          8
+#define XCSI_SPKTR_VC_SHIFT            6
+#define XCSI_SPKTR_DT_SHIFT            0
+#define XCSI_SPKTR_DATA_MASK           0x00FFFF00
+#define XCSI_SPKTR_VC_MASK             0x000000C0
+#define XCSI_SPKTR_DT_MASK             0x0000003F
+
+#define XCSI_CLKINFR_OFFSET            0x0000003C
+#define XCSI_CLKINFR_STOP_SHIFT                1
+#define XCSI_CLKINFR_STOP_MASK         BIT(XCSI_CLKINFR_STOP_SHIFT)
+
+#define XCSI_L0INFR_OFFSET             0x00000040
+#define XCSI_L1INFR_OFFSET             0x00000044
+#define XCSI_L2INFR_OFFSET             0x00000048
+#define XCSI_L3INFR_OFFSET             0x0000004C
+#define XCSI_LXINFR_STOP_SHIFT         5
+#define XCSI_LXINFR_SOTERR_SHIFT       1
+#define XCSI_LXINFR_SOTSYNCERR_SHIFT   0
+#define XCSI_LXINFR_STOP_MASK          BIT(XCSI_LXINFR_STOP_SHIFT)
+#define XCSI_LXINFR_SOTERR_MASK                BIT(XCSI_LXINFR_SOTERR_SHIF=
T)
+#define XCSI_LXINFR_SOTSYNCERR_MASK    BIT(XCSI_LXINFR_SOTSYNCERR_SHIFT)
+
+#define XCSI_VC0INF1R_OFFSET           0x00000060
+#define XCSI_VC1INF1R_OFFSET           0x00000068
+#define XCSI_VC2INF1R_OFFSET           0x00000070
+#define XCSI_VC3INF1R_OFFSET           0x00000078
+#define XCSI_VCXINF1R_LINECOUNT_SHIFT  16
+#define XCSI_VCXINF1R_BYTECOUNT_SHIFT  0
+#define XCSI_VCXINF1R_LINECOUNT_MASK   0xFFFF0000
+#define XCSI_VCXINF1R_BYTECOUNT_MASK   0x0000FFFF
+
+#define XCSI_VC0INF2R_OFFSET           0x00000064
+#define XCSI_VC1INF2R_OFFSET           0x0000006C
+#define XCSI_VC2INF2R_OFFSET           0x00000074
+#define XCSI_VC3INF2R_OFFSET           0x0000007C
+#define XCSI_VCXINF2R_DATATYPE_SHIFT   0
+#define XCSI_VCXINF2R_DATATYPE_MASK    0x0000003F
+
+#define XDPHY_CTRLREG_OFFSET           0x0
+#define XDPHY_CTRLREG_DPHYEN_SHIFT     1
+#define XDPHY_CTRLREG_DPHYEN_MASK      BIT(XDPHY_CTRLREG_DPHYEN_SHIFT)
+
+#define XDPHY_CLKSTATREG_OFFSET                0x18
+#define XDPHY_CLKSTATREG_MODE_SHIFT    0
+#define XDPHY_CLKSTATREG_MODE_MASK     0x3
+#define XDPHY_LOW_POWER_MODE           0x0
+#define XDPHY_HI_SPEED_MODE            0x1
+#define XDPHY_ESC_MODE                 0x2
+
+/*
+ * Interrupt mask
+ */
+#define XCSI_INTR_MASK         (XCSI_ISR_ALLINTR_MASK & ~XCSI_ISR_STOP_MAS=
K)
+/*
+ * Timeout for reset
+ */
+#define XCSI_TIMEOUT_VAL       (1000) /* us */
+
+/*
+ * Max string length for CSI Data type string
+ */
+#define MAX_XIL_CSIDT_STR_LENGTH 64
+
+/*
+ * Maximum number of short packet events per file handle.
+ */
+#define XCSI_MAX_SPKT          (512)
+
+/* Number of media pads */
+#define XILINX_CSI_MEDIA_PADS  (2)
+
+#define XCSI_DEFAULT_WIDTH     (1920)
+#define XCSI_DEFAULT_HEIGHT    (1080)
+
+/*
+ * Macro to return "true" or "false" string if bit is set
+ */
+#define XCSI_GET_BITSET_STR(val, mask) (val) & (mask) ? "true" : "false"
+
+enum csi_datatypes {
+       MIPI_CSI_DT_FRAME_START_CODE =3D 0x00,
+       MIPI_CSI_DT_FRAME_END_CODE,
+       MIPI_CSI_DT_LINE_START_CODE,
+       MIPI_CSI_DT_LINE_END_CODE,
+       MIPI_CSI_DT_SYNC_RSVD_04,
+       MIPI_CSI_DT_SYNC_RSVD_05,
+       MIPI_CSI_DT_SYNC_RSVD_06,
+       MIPI_CSI_DT_SYNC_RSVD_07,
+       MIPI_CSI_DT_GSPKT_08,
+       MIPI_CSI_DT_GSPKT_09,
+       MIPI_CSI_DT_GSPKT_0A,
+       MIPI_CSI_DT_GSPKT_0B,
+       MIPI_CSI_DT_GSPKT_0C,
+       MIPI_CSI_DT_GSPKT_0D,
+       MIPI_CSI_DT_GSPKT_0E,
+       MIPI_CSI_DT_GSPKT_0F,
+       MIPI_CSI_DT_GLPKT_10,
+       MIPI_CSI_DT_GLPKT_11,
+       MIPI_CSI_DT_GLPKT_12,
+       MIPI_CSI_DT_GLPKT_13,
+       MIPI_CSI_DT_GLPKT_14,
+       MIPI_CSI_DT_GLPKT_15,
+       MIPI_CSI_DT_GLPKT_16,
+       MIPI_CSI_DT_GLPKT_17,
+       MIPI_CSI_DT_YUV_420_8B,
+       MIPI_CSI_DT_YUV_420_10B,
+       MIPI_CSI_DT_YUV_420_8B_LEGACY,
+       MIPI_CSI_DT_YUV_RSVD,
+       MIPI_CSI_DT_YUV_420_8B_CSPS,
+       MIPI_CSI_DT_YUV_420_10B_CSPS,
+       MIPI_CSI_DT_YUV_422_8B,
+       MIPI_CSI_DT_YUV_422_10B,
+       MIPI_CSI_DT_RGB_444,
+       MIPI_CSI_DT_RGB_555,
+       MIPI_CSI_DT_RGB_565,
+       MIPI_CSI_DT_RGB_666,
+       MIPI_CSI_DT_RGB_888,
+       MIPI_CSI_DT_RGB_RSVD_25,
+       MIPI_CSI_DT_RGB_RSVD_26,
+       MIPI_CSI_DT_RGB_RSVD_27,
+       MIPI_CSI_DT_RAW_6,
+       MIPI_CSI_DT_RAW_7,
+       MIPI_CSI_DT_RAW_8,
+       MIPI_CSI_DT_RAW_10,
+       MIPI_CSI_DT_RAW_12,
+       MIPI_CSI_DT_RAW_14,
+       MIPI_CSI_DT_RAW_RSVD_2E,
+       MIPI_CSI_DT_RAW_RSVD_2F,
+       MIPI_CSI_DT_USER_30,
+       MIPI_CSI_DT_USER_31,
+       MIPI_CSI_DT_USER_32,
+       MIPI_CSI_DT_USER_33,
+       MIPI_CSI_DT_USER_34,
+       MIPI_CSI_DT_USER_35,
+       MIPI_CSI_DT_USER_36,
+       MIPI_CSI_DT_USER_37,
+       MIPI_CSI_DT_RSVD_38,
+       MIPI_CSI_DT_RSVD_39,
+       MIPI_CSI_DT_RSVD_3A,
+       MIPI_CSI_DT_RSVD_3B,
+       MIPI_CSI_DT_RSVD_3C,
+       MIPI_CSI_DT_RSVD_3D,
+       MIPI_CSI_DT_RSVD_3E,
+       MIPI_CSI_DT_RSVD_3F
+};
+
+/**
+ * struct pixel_format - Data Type to string name structure
+ * @pixelformat: MIPI CSI2 Data type
+ * @pixelformatstr: String name of Data Type
+ */
+struct pixel_format {
+       enum csi_datatypes pixelformat;
+       char pixelformatstr[MAX_XIL_CSIDT_STR_LENGTH];
+};
+
+/**
+ * struct xcsi2rxss_event - Event log structure
+ * @mask: Event mask
+ * @name: Name of the event
+ * @counter: Count number of events
+ */
+struct xcsi2rxss_event {
+       u32 mask;
+       const char * const name;
+       unsigned int counter;
+};
+
+/*
+ * struct xcsi2rxss_core - Core configuration CSI2 Rx Subsystem device str=
ucture
+ * @dev: Platform structure
+ * @iomem: Base address of subsystem
+ * @irq: requested irq number
+ * @dphy_present: Flag for DPHY register interface presence
+ * @dphy_offset: DPHY registers offset
+ * @enable_active_lanes: If number of active lanes can be modified
+ * @max_num_lanes: Maximum number of lanes present
+ * @vfb: Video Format Bridge enabled or not
+ * @ppc: pixels per clock
+ * @vc: Virtual Channel
+ * @axis_tdata_width: AXI Stream data width
+ * @datatype: Data type filter
+ * @pxlformat: String with CSI pixel format from IP
+ * @num_lanes: Number of lanes requested from application
+ * @events: Structure to maintain event logs
+ */
+struct xcsi2rxss_core {
+       struct device *dev;
+       void __iomem *iomem;
+       int irq;
+       u32 dphy_offset;
+       bool dphy_present;
+       bool enable_active_lanes;
+       u32 max_num_lanes;
+       bool vfb;
+       u32 ppc;
+       u32 vc;
+       u32 axis_tdata_width;
+       u32 datatype;
+       const char *pxlformat;
+       u32 num_lanes;
+       struct xcsi2rxss_event *events;
+};
+
+/**
+ * struct xcsi2rxss_state - CSI2 Rx Subsystem device structure
+ * @core: Core structure for MIPI CSI2 Rx Subsystem
+ * @subdev: The v4l2 subdev structure
+ * @ctrl_handler: control handler
+ * @formats: Active V4L2 formats on each pad
+ * @default_format: default V4L2 media bus format
+ * @vip_format: format information corresponding to the active format
+ * @event: Holds the short packet event
+ * @lock: mutex for serializing operations
+ * @pads: media pads
+ * @npads: number of pads
+ * @streaming: Flag for storing streaming state
+ * @suspended: Flag for storing suspended state
+ *
+ * This structure contains the device driver related parameters
+ */
+struct xcsi2rxss_state {
+       struct xcsi2rxss_core core;
+       struct v4l2_subdev subdev;
+       struct v4l2_ctrl_handler ctrl_handler;
+       struct v4l2_mbus_framefmt formats[2];
+       struct v4l2_mbus_framefmt default_format;
+       const struct xvip_video_format *vip_format;
+       struct v4l2_event event;
+       /*
+        * Used to serialize access.
+        */
+       struct mutex lock;
+       struct media_pad pads[XILINX_CSI_MEDIA_PADS];
+       unsigned int npads;
+       bool streaming;
+       bool suspended;
+};
+
+static inline struct xcsi2rxss_state *
+to_xcsi2rxssstate(struct v4l2_subdev *subdev)
+{
+       return container_of(subdev, struct xcsi2rxss_state, subdev);
+}
+
+/*
+ * Register related operations
+ */
+static inline u32 xcsi2rxss_read(struct xcsi2rxss_core *xcsi2rxss,
+                                u32 addr)
+{
+       return ioread32(xcsi2rxss->iomem + addr);
+}
+
+static inline void xcsi2rxss_write(struct xcsi2rxss_core *xcsi2rxss,
+                                  u32 addr, u32 value)
+{
+       iowrite32(value, xcsi2rxss->iomem + addr);
+}
+
+static inline void xcsi2rxss_clr(struct xcsi2rxss_core *xcsi2rxss,
+                                u32 addr, u32 clr)
+{
+       xcsi2rxss_write(xcsi2rxss,
+                       addr,
+                       xcsi2rxss_read(xcsi2rxss, addr) & ~clr);
+}
+
+static inline void xcsi2rxss_set(struct xcsi2rxss_core *xcsi2rxss,
+                                u32 addr, u32 set)
+{
+       xcsi2rxss_write(xcsi2rxss,
+                       addr,
+                       xcsi2rxss_read(xcsi2rxss, addr) | set);
+}
+
+static const struct pixel_format pixel_formats[] =3D {
+       { MIPI_CSI_DT_YUV_420_8B, "YUV420_8bit" },
+       { MIPI_CSI_DT_YUV_420_10B, "YUV420_10bit" },
+       { MIPI_CSI_DT_YUV_420_8B_LEGACY, "Legacy_YUV420_8bit" },
+       { MIPI_CSI_DT_YUV_420_8B_CSPS, "YUV420_8bit_CSPS" },
+       { MIPI_CSI_DT_YUV_420_10B_CSPS, "YUV420_10bit_CSPS" },
+       { MIPI_CSI_DT_YUV_422_8B, "YUV422_8bit" },
+       { MIPI_CSI_DT_YUV_422_10B, "YUV422_10bit" },
+       { MIPI_CSI_DT_RGB_444, "RGB444" },
+       { MIPI_CSI_DT_RGB_555, "RGB555" },
+       { MIPI_CSI_DT_RGB_565, "RGB565" },
+       { MIPI_CSI_DT_RGB_666, "RGB666" },
+       { MIPI_CSI_DT_RGB_888, "RGB888" },
+       { MIPI_CSI_DT_RAW_6, "RAW6" },
+       { MIPI_CSI_DT_RAW_7, "RAW7" },
+       { MIPI_CSI_DT_RAW_8, "RAW8" },
+       { MIPI_CSI_DT_RAW_10, "RAW10" },
+       { MIPI_CSI_DT_RAW_12, "RAW12" },
+       { MIPI_CSI_DT_RAW_14, "RAW14 "}
+};
+
+static struct xcsi2rxss_event xcsi2rxss_events[] =3D {
+       { XCSI_ISR_FR_MASK, "Frame Received", 0 },
+       { XCSI_ISR_ILC_MASK, "Invalid Lane Count Error", 0 },
+       { XCSI_ISR_SPFIFOF_MASK, "Short Packet FIFO OverFlow Error", 0 },
+       { XCSI_ISR_SPFIFONE_MASK, "Short Packet FIFO Not Empty", 0 },
+       { XCSI_ISR_SLBF_MASK, "Streamline Buffer Full Error", 0 },
+       { XCSI_ISR_STOP_MASK, "Lane Stop State", 0 },
+       { XCSI_ISR_SOTERR_MASK, "SOT Error", 0 },
+       { XCSI_ISR_SOTSYNCERR_MASK, "SOT Sync Error", 0 },
+       { XCSI_ISR_ECC2BERR_MASK, "2 Bit ECC Unrecoverable Error", 0 },
+       { XCSI_ISR_ECC1BERR_MASK, "1 Bit ECC Recoverable Error", 0 },
+       { XCSI_ISR_CRCERR_MASK, "CRC Error", 0 },
+       { XCSI_ISR_DATAIDERR_MASK, "Data Id Error", 0 },
+       { XCSI_ISR_VC3FSYNCERR_MASK, "Virtual Channel 3 Frame Sync Error", =
0 },
+       { XCSI_ISR_VC3FLVLERR_MASK, "Virtual Channel 3 Frame Level Error", =
0 },
+       { XCSI_ISR_VC2FSYNCERR_MASK, "Virtual Channel 2 Frame Sync Error", =
0 },
+       { XCSI_ISR_VC2FLVLERR_MASK, "Virtual Channel 2 Frame Level Error", =
0 },
+       { XCSI_ISR_VC1FSYNCERR_MASK, "Virtual Channel 1 Frame Sync Error", =
0 },
+       { XCSI_ISR_VC1FLVLERR_MASK, "Virtual Channel 1 Frame Level Error", =
0 },
+       { XCSI_ISR_VC0FSYNCERR_MASK, "Virtual Channel 0 Frame Sync Error", =
0 },
+       { XCSI_ISR_VC0FLVLERR_MASK, "Virtual Channel 0 Frame Level Error", =
0 }
+};
+
+#define XMIPICSISS_NUM_EVENTS ARRAY_SIZE(xcsi2rxss_events)
+
+/**
+ * xcsi2rxss_clr_and_set - Clear and set the register with a bitmask
+ * @xcsi2rxss: Xilinx MIPI CSI2 Rx Subsystem subdev core struct
+ * @addr: address of register
+ * @clr: bitmask to be cleared
+ * @set: bitmask to be set
+ *
+ * Clear a bit(s) of mask @clr in the register at address @addr, then set
+ * a bit(s) of mask @set in the register after.
+ */
+static void xcsi2rxss_clr_and_set(struct xcsi2rxss_core *xcsi2rxss,
+                                 u32 addr, u32 clr, u32 set)
+{
+       u32 reg;
+
+       reg =3D xcsi2rxss_read(xcsi2rxss, addr);
+       reg &=3D ~clr;
+       reg |=3D set;
+       xcsi2rxss_write(xcsi2rxss, addr, reg);
+}
+
+/**
+ * xcsi2rxss_pxlfmtstrtodt - Convert pixel format string got from dts
+ * to data type.
+ * @pxlfmtstr: String obtained while parsing device node
+ *
+ * This function takes a CSI pixel format string obtained while parsing
+ * device tree node and converts it to data type.
+ *
+ * Eg. "RAW8" string is converted to 0x2A.
+ * Refer to MIPI CSI2 specification for details.
+ *
+ * Return: Equivalent pixel format value from table
+ */
+static u32 xcsi2rxss_pxlfmtstrtodt(const char *pxlfmtstr)
+{
+       u32 i;
+       u32 maxentries =3D ARRAY_SIZE(pixel_formats);
+
+       for (i =3D 0; i < maxentries; i++) {
+               if (!strncmp(pixel_formats[i].pixelformatstr,
+                            pxlfmtstr, MAX_XIL_CSIDT_STR_LENGTH))
+                       return pixel_formats[i].pixelformat;
+       }
+
+       return -EINVAL;
+}
+
+/**
+ * xcsi2rxss_pxlfmtdttostr - Convert pixel format data type to string.
+ * @datatype: MIPI CSI-2 Data Type
+ *
+ * This function takes a CSI pixel format data type and returns a
+ * pointer to the string name.
+ *
+ * Eg. 0x2A returns "RAW8" string.
+ * Refer to MIPI CSI2 specification for details.
+ *
+ * Return: Equivalent pixel format string from table
+ */
+static const char *xcsi2rxss_pxlfmtdttostr(u32 datatype)
+{
+       u32 i;
+       u32 maxentries =3D ARRAY_SIZE(pixel_formats);
+
+       for (i =3D 0; i < maxentries; i++) {
+               if (pixel_formats[i].pixelformat =3D=3D datatype)
+                       return pixel_formats[i].pixelformatstr;
+       }
+
+       return NULL;
+}
+
+/**
+ * xcsi2rxss_enable - Enable or disable the CSI Core
+ * @core: Core Xilinx CSI2 Rx Subsystem structure pointer
+ * @flag: true for enabling, false for disabling
+ *
+ * This function enables/disables the MIPI CSI2 Rx Subsystem core.
+ * After enabling the CSI2 Rx core, the DPHY is enabled in case the
+ * register interface for it is present.
+ */
+static void xcsi2rxss_enable(struct xcsi2rxss_core *core, bool flag)
+{
+       u32 dphyctrlregoffset =3D core->dphy_offset + XDPHY_CTRLREG_OFFSET;
+
+       if (flag) {
+               xcsi2rxss_write(core, XCSI_CCR_OFFSET, XCSI_CCR_COREENB_MAS=
K);
+               if (core->dphy_present)
+                       xcsi2rxss_write(core, dphyctrlregoffset,
+                                       XDPHY_CTRLREG_DPHYEN_MASK);
+       } else {
+               xcsi2rxss_write(core, XCSI_CCR_OFFSET, 0);
+               if (core->dphy_present)
+                       xcsi2rxss_write(core, dphyctrlregoffset, 0);
+       }
+}
+
+/**
+ * xcsi2rxss_interrupts_enable - Enable or disable CSI interrupts
+ * @core: Core Xilinx CSI2 Rx Subsystem structure pointer
+ * @flag: true for enabling, false for disabling
+ *
+ * This function enables/disables the interrupts for the MIPI CSI2
+ * Rx Subsystem.
+ */
+static void xcsi2rxss_interrupts_enable(struct xcsi2rxss_core *core, bool =
flag)
+{
+       if (flag) {
+               xcsi2rxss_clr(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE_MASK);
+               xcsi2rxss_write(core, XCSI_IER_OFFSET, XCSI_INTR_MASK);
+               xcsi2rxss_set(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE_MASK);
+       } else {
+               xcsi2rxss_clr(core, XCSI_IER_OFFSET, XCSI_INTR_MASK);
+               xcsi2rxss_clr(core, XCSI_GIER_OFFSET, XCSI_GIER_GIE_MASK);
+       }
+}
+
+/**
+ * xcsi2rxss_reset - Does a soft reset of the MIPI CSI2 Rx Subsystem
+ * @core: Core Xilinx CSI2 Rx Subsystem structure pointer
+ *
+ * Return: 0 - on success OR -ETIME if reset times out
+ */
+static int xcsi2rxss_reset(struct xcsi2rxss_core *core)
+{
+       u32 timeout =3D XCSI_TIMEOUT_VAL;
+
+       xcsi2rxss_set(core, XCSI_CCR_OFFSET, XCSI_CCR_SOFTRESET_MASK);
+
+       while (xcsi2rxss_read(core, XCSI_CSR_OFFSET) & XCSI_CSR_RIPCD_MASK)=
 {
+               if (timeout =3D=3D 0) {
+                       dev_err(core->dev, "Xilinx CSI2 Rx Subsystem Soft R=
eset Timeout!\n");
+                       return -ETIME;
+               }
+
+               timeout--;
+               udelay(1);
+       }
+
+       xcsi2rxss_clr(core, XCSI_CCR_OFFSET, XCSI_CCR_SOFTRESET_MASK);
+       return 0;
+}
+
+/**
+ * xcsi2rxss_irq_handler - Interrupt handler for CSI-2
+ * @irq: IRQ number
+ * @dev_id: Pointer to device state
+ *
+ * In the interrupt handler, a list of event counters are updated for
+ * corresponding interrupts. This is useful to get status / debug.
+ * If the short packet FIFO not empty or overflow interrupt is received
+ * capture the short packet and notify of event occurrence
+ *
+ * Return: IRQ_HANDLED after handling interrupts
+ */
+static irqreturn_t xcsi2rxss_irq_handler(int irq, void *dev_id)
+{
+       struct xcsi2rxss_state *state =3D (struct xcsi2rxss_state *)dev_id;
+       struct xcsi2rxss_core *core =3D &state->core;
+       u32 status;
+
+       status =3D xcsi2rxss_read(core, XCSI_ISR_OFFSET) & XCSI_INTR_MASK;
+       dev_dbg(core->dev, "interrupt status =3D 0x%08x\n", status);
+
+       if (!status)
+               return IRQ_NONE;
+
+       if (status & XCSI_ISR_SPFIFONE_MASK) {
+               memset(&state->event, 0, sizeof(state->event));
+
+               state->event.type =3D V4L2_EVENT_XLNXCSIRX_SPKT;
+
+               *((u32 *)(&state->event.u.data)) =3D
+                       xcsi2rxss_read(core, XCSI_SPKTR_OFFSET);
+
+               v4l2_subdev_notify_event(&state->subdev, &state->event);
+       }
+
+       if (status & XCSI_ISR_SPFIFOF_MASK) {
+               dev_alert(core->dev, "Short packet FIFO overflowed\n");
+
+               memset(&state->event, 0, sizeof(state->event));
+
+               state->event.type =3D V4L2_EVENT_XLNXCSIRX_SPKT_OVF;
+
+               v4l2_subdev_notify_event(&state->subdev, &state->event);
+       }
+
+       if (status & XCSI_ISR_SLBF_MASK) {
+               dev_alert(core->dev, "Stream Line Buffer Full!\n");
+
+               memset(&state->event, 0, sizeof(state->event));
+
+               state->event.type =3D V4L2_EVENT_XLNXCSIRX_SLBF;
+
+               v4l2_subdev_notify_event(&state->subdev, &state->event);
+       }
+
+       if (status & XCSI_ISR_ALLINTR_MASK) {
+               unsigned int i;
+
+               for (i =3D 0; i < XMIPICSISS_NUM_EVENTS; i++) {
+                       if (!(status & core->events[i].mask))
+                               continue;
+                       core->events[i].counter++;
+                       dev_dbg(core->dev, "%s: %d\n", core->events[i].name=
,
+                               core->events[i].counter);
+               }
+       }
+
+       xcsi2rxss_write(core, XCSI_ISR_OFFSET, status);
+
+       return IRQ_HANDLED;
+}
+
+static void xcsi2rxss_reset_event_counters(struct xcsi2rxss_state *state)
+{
+       u32 i;
+
+       for (i =3D 0; i < XMIPICSISS_NUM_EVENTS; i++)
+               state->core.events[i].counter =3D 0;
+}
+
+/**
+ * xcsi2rxss_log_counters - Print out the event counters.
+ * @state: Pointer to device state
+ *
+ */
+static void xcsi2rxss_log_counters(struct xcsi2rxss_state *state)
+{
+       u32 i;
+
+       for (i =3D 0; i < XMIPICSISS_NUM_EVENTS; i++) {
+               if (state->core.events[i].counter > 0)
+                       v4l2_info(&state->subdev, "%s events: %d\n",
+                                 state->core.events[i].name,
+                                 state->core.events[i].counter);
+       }
+}
+
+/**
+ * xcsi2rxss_log_status - Logs the status of the CSI-2 Receiver
+ * @sd: Pointer to V4L2 subdevice structure
+ *
+ * This function prints the current status of Xilinx MIPI CSI-2
+ *
+ * Return: 0 on success
+ */
+static int xcsi2rxss_log_status(struct v4l2_subdev *sd)
+{
+       struct xcsi2rxss_state *xcsi2rxss =3D to_xcsi2rxssstate(sd);
+       struct xcsi2rxss_core *core =3D &xcsi2rxss->core;
+       u32 reg, data, i;
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       xcsi2rxss_log_counters(xcsi2rxss);
+
+       v4l2_info(sd, "***** Core Status *****\n");
+       data =3D xcsi2rxss_read(core, XCSI_CSR_OFFSET);
+       v4l2_info(sd, "Short Packet FIFO Full =3D %s\n",
+                 XCSI_GET_BITSET_STR(data, XCSI_CSR_SPFIFOFULL_MASK));
+       v4l2_info(sd, "Short Packet FIFO Not Empty =3D %s\n",
+                 XCSI_GET_BITSET_STR(data, XCSI_CSR_SPFIFONE_MASK));
+       v4l2_info(sd, "Stream line buffer full =3D %s\n",
+                 XCSI_GET_BITSET_STR(data, XCSI_CSR_SLBF_MASK));
+       v4l2_info(sd, "Soft reset/Core disable in progress =3D %s\n",
+                 XCSI_GET_BITSET_STR(data, XCSI_CSR_RIPCD_MASK));
+
+       /* Clk & Lane Info  */
+       v4l2_info(sd, "******** Clock Lane Info *********\n");
+       data =3D xcsi2rxss_read(core, XCSI_CLKINFR_OFFSET);
+       v4l2_info(sd, "Clock Lane in Stop State =3D %s\n",
+                 XCSI_GET_BITSET_STR(data, XCSI_CLKINFR_STOP_MASK));
+
+       v4l2_info(sd, "******** Data Lane Info *********\n");
+       v4l2_info(sd, "Lane\tSoT Error\tSoT Sync Error\tStop State\n");
+       reg =3D XCSI_L0INFR_OFFSET;
+       for (i =3D 0; i < 4; i++) {
+               data =3D xcsi2rxss_read(core, reg);
+
+               v4l2_info(sd, "%d\t%s\t\t%s\t\t%s\n",
+                         i,
+                         XCSI_GET_BITSET_STR(data, XCSI_LXINFR_SOTERR_MASK=
),
+                         data & XCSI_LXINFR_SOTSYNCERR_MASK ? "true" : "fa=
lse",
+                         XCSI_GET_BITSET_STR(data, XCSI_LXINFR_STOP_MASK))=
;
+
+               reg +=3D 4;
+       }
+
+       /* Virtual Channel Image Information */
+       v4l2_info(sd, "********** Virtual Channel Info ************\n");
+       v4l2_info(sd, "VC\tLine Count\tByte Count\tData Type\n");
+       reg =3D XCSI_VC0INF1R_OFFSET;
+       for (i =3D 0; i < 4; i++) {
+               u32 line_count, byte_count, data_type;
+               char *datatypestr;
+
+               /* Get line and byte count from VCXINFR1 Register */
+               data =3D xcsi2rxss_read(core, reg);
+               byte_count =3D (data & XCSI_VCXINF1R_BYTECOUNT_MASK) >>
+                               XCSI_VCXINF1R_BYTECOUNT_SHIFT;
+               line_count =3D (data & XCSI_VCXINF1R_LINECOUNT_MASK) >>
+                               XCSI_VCXINF1R_LINECOUNT_SHIFT;
+
+               /* Get data type from VCXINFR2 Register */
+               reg +=3D 4;
+               data =3D xcsi2rxss_read(core, reg);
+               data_type =3D (data & XCSI_VCXINF2R_DATATYPE_MASK) >>
+                               XCSI_VCXINF2R_DATATYPE_SHIFT;
+               datatypestr =3D (char *)xcsi2rxss_pxlfmtdttostr(data_type);
+
+               v4l2_info(sd, "%d\t%d\t\t%d\t\t%s\n",
+                         i, line_count, byte_count, datatypestr);
+
+               /* Move to next pair of VC Info registers */
+               reg +=3D 4;
+       }
+
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return 0;
+}
+
+/*
+ * xcsi2rxss_subscribe_event - Subscribe to the custom short packet
+ * receive event.
+ * @sd: V4L2 Sub device
+ * @fh: V4L2 File Handle
+ * @sub: Subcribe event structure
+ *
+ * There are two types of events to be subscribed.
+ *
+ * First is to register for receiving a short packet.
+ * The short packets received are queued up in a FIFO.
+ * On reception of a short packet, an event will be generated
+ * with the short packet contents copied to its data area.
+ * Application subscribed to this event will poll for POLLPRI.
+ * On getting the event, the app dequeues the event to get the short packe=
t
+ * data.
+ *
+ * Second is to register for Short packet FIFO overflow
+ * In case the rate of receiving short packets is high and
+ * the short packet FIFO overflows, this event will be triggered.
+ *
+ * Return: 0 on success, errors otherwise
+ */
+static int xcsi2rxss_subscribe_event(struct v4l2_subdev *sd,
+                                    struct v4l2_fh *fh,
+                                    struct v4l2_event_subscription *sub)
+{
+       int ret;
+       struct xcsi2rxss_state *xcsi2rxss =3D to_xcsi2rxssstate(sd);
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       switch (sub->type) {
+       case V4L2_EVENT_XLNXCSIRX_SPKT:
+       case V4L2_EVENT_XLNXCSIRX_SPKT_OVF:
+       case V4L2_EVENT_XLNXCSIRX_SLBF:
+               ret =3D v4l2_event_subscribe(fh, sub, XCSI_MAX_SPKT, NULL);
+               break;
+       default:
+               ret =3D -EINVAL;
+       }
+
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return ret;
+}
+
+/**
+ * xcsi2rxss_unsubscribe_event - Unsubscribe from all events registered
+ * @sd: V4L2 Sub device
+ * @fh: V4L2 file handle
+ * @sub: pointer to Event unsubscription structure
+ *
+ * Return: zero on success, else a negative error code.
+ */
+static int xcsi2rxss_unsubscribe_event(struct v4l2_subdev *sd,
+                                      struct v4l2_fh *fh,
+                                      struct v4l2_event_subscription *sub)
+{
+       int ret =3D 0;
+       struct xcsi2rxss_state *xcsi2rxss =3D to_xcsi2rxssstate(sd);
+
+       mutex_lock(&xcsi2rxss->lock);
+       ret =3D v4l2_event_unsubscribe(fh, sub);
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return ret;
+}
+
+/**
+ * xcsi2rxss_s_ctrl - This is used to set the Xilinx MIPI CSI-2 V4L2 contr=
ols
+ * @ctrl: V4L2 control to be set
+ *
+ * This function is used to set the V4L2 controls for the Xilinx MIPI
+ * CSI-2 Rx Subsystem. It is used to set the active lanes in the system.
+ * The event counters can be reset.
+ *
+ * Return: 0 on success, errors otherwise
+ */
+static int xcsi2rxss_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+       int ret =3D 0;
+       u32 timeout =3D XCSI_TIMEOUT_VAL;
+       u32 active_lanes =3D 1;
+
+       struct xcsi2rxss_state *xcsi2rxss =3D
+               container_of(ctrl->handler,
+                            struct xcsi2rxss_state, ctrl_handler);
+       struct xcsi2rxss_core *core =3D &xcsi2rxss->core;
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       switch (ctrl->id) {
+       case V4L2_CID_XILINX_MIPICSISS_ACT_LANES:
+               /*
+                * This will be called only when "Enable Active Lanes" para=
meter
+                * is set in design
+                */
+               xcsi2rxss_clr_and_set(core, XCSI_PCR_OFFSET,
+                                     XCSI_PCR_ACTLANES_MASK, ctrl->val - 1=
);
+
+               /*
+                * If the core is enabled, wait for active lanes to be
+                * set.
+                *
+                * If core is disabled or there is no clock from DPHY Tx
+                * then the read back won't reflect the updated value
+                * as the PPI clock will not be present.
+                */
+
+               if (core->dphy_present) {
+                       u32 dphyclkstatregoffset =3D core->dphy_offset +
+                                                       XDPHY_CLKSTATREG_OF=
FSET;
+
+                       u32 dphyclkstat =3D
+                               xcsi2rxss_read(core, dphyclkstatregoffset) =
&
+                                       XDPHY_CLKSTATREG_MODE_MASK;
+
+                       u32 coreenable =3D
+                               xcsi2rxss_read(core, XCSI_CCR_OFFSET) &
+                                              XCSI_CCR_COREENB_MASK;
+
+                       char lpmstr[] =3D "Low Power";
+                       char hsmstr[] =3D "High Speed";
+                       char esmstr[] =3D "Escape";
+                       char *modestr;
+
+                       switch (dphyclkstat) {
+                       case 0:
+                               modestr =3D lpmstr;
+                               break;
+                       case 1:
+                               modestr =3D hsmstr;
+                               break;
+                       case 2:
+                               modestr =3D esmstr;
+                               break;
+                       default:
+                               modestr =3D NULL;
+                               break;
+                       }
+
+                       dev_dbg(core->dev, "DPHY Clock Lane in %s mode\n",
+                               modestr);
+
+                       if (dphyclkstat =3D=3D XDPHY_HI_SPEED_MODE &&
+                           coreenable) {
+                               /* Wait for core to apply new active lanes =
*/
+                               while (timeout--)
+                                       udelay(1);
+
+                               active_lanes =3D
+                                       xcsi2rxss_read(core, XCSI_PCR_OFFSE=
T);
+                               active_lanes &=3D XCSI_PCR_ACTLANES_MASK;
+                               active_lanes++;
+
+                               if (active_lanes !=3D (u32)ctrl->val) {
+                                       dev_err(core->dev, "Failed to set a=
ctive lanes!\n");
+                                       ret =3D -EAGAIN;
+                               }
+                       }
+               } else {
+                       dev_dbg(core->dev, "No read back as no DPHY present=
.\n");
+               }
+
+               dev_dbg(core->dev, "Set active lanes: requested =3D %d, act=
ive =3D %d\n",
+                       ctrl->val, active_lanes);
+               break;
+       case V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS:
+               xcsi2rxss_reset_event_counters(xcsi2rxss);
+               break;
+       default:
+               break;
+       }
+
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return ret;
+}
+
+/**
+ * xcsi2rxss_g_volatile_ctrl - get the Xilinx MIPI CSI-2 Rx controls
+ * @ctrl: Pointer to V4L2 control
+ *
+ * This is used to get the number of frames received by the Xilinx
+ * MIPI CSI-2 Rx.
+ *
+ * Return: 0 on success, errors otherwise
+ */
+static int xcsi2rxss_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+       int ret =3D 0;
+       struct xcsi2rxss_state *xcsi2rxss =3D
+               container_of(ctrl->handler,
+                            struct xcsi2rxss_state, ctrl_handler);
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       switch (ctrl->id) {
+       case V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER:
+               ctrl->val =3D xcsi2rxss->core.events[0].counter;
+               break;
+       default:
+               ret =3D -EINVAL;
+       }
+
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return ret;
+}
+
+static int xcsi2rxss_start_stream(struct xcsi2rxss_state *xcsi2rxss)
+{
+       int ret;
+
+       xcsi2rxss_enable(&xcsi2rxss->core, true);
+
+       ret =3D xcsi2rxss_reset(&xcsi2rxss->core);
+       if (ret < 0)
+               return ret;
+
+       xcsi2rxss_interrupts_enable(&xcsi2rxss->core, true);
+
+       return 0;
+}
+
+static void xcsi2rxss_stop_stream(struct xcsi2rxss_state *xcsi2rxss)
+{
+       xcsi2rxss_interrupts_enable(&xcsi2rxss->core, false);
+       xcsi2rxss_enable(&xcsi2rxss->core, false);
+}
+
+/**
+ * xcsi2rxss_s_stream - It is used to start/stop the streaming.
+ * @sd: V4L2 Sub device
+ * @enable: Flag (True / False)
+ *
+ * This function controls the start or stop of streaming for the
+ * Xilinx MIPI CSI-2 Rx Subsystem provided the device isn't in
+ * suspended state.
+ *
+ * Return: 0 on success, errors otherwise
+ */
+static int xcsi2rxss_s_stream(struct v4l2_subdev *sd, int enable)
+{
+       int ret =3D 0;
+       struct xcsi2rxss_state *xcsi2rxss =3D to_xcsi2rxssstate(sd);
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       if (xcsi2rxss->suspended) {
+               ret =3D -EBUSY;
+               goto unlock;
+       }
+
+       if (enable) {
+               if (!xcsi2rxss->streaming) {
+                       /* reset the event counters */
+                       xcsi2rxss_reset_event_counters(xcsi2rxss);
+
+                       ret =3D xcsi2rxss_start_stream(xcsi2rxss);
+                       if (ret =3D=3D 0)
+                               xcsi2rxss->streaming =3D true;
+               }
+       } else {
+               if (xcsi2rxss->streaming) {
+                       xcsi2rxss_stop_stream(xcsi2rxss);
+                       xcsi2rxss->streaming =3D false;
+               }
+       }
+unlock:
+       mutex_unlock(&xcsi2rxss->lock);
+       return ret;
+}
+
+static struct v4l2_mbus_framefmt *
+__xcsi2rxss_get_pad_format(struct xcsi2rxss_state *xcsi2rxss,
+                          struct v4l2_subdev_pad_config *cfg,
+                          unsigned int pad, u32 which)
+{
+       switch (which) {
+       case V4L2_SUBDEV_FORMAT_TRY:
+               return v4l2_subdev_get_try_format(&xcsi2rxss->subdev, cfg, =
pad);
+       case V4L2_SUBDEV_FORMAT_ACTIVE:
+               return &xcsi2rxss->formats[pad];
+       default:
+               return NULL;
+       }
+}
+
+/**
+ * xcsi2rxss_get_format - Get the pad format
+ * @sd: Pointer to V4L2 Sub device structure
+ * @cfg: Pointer to sub device pad information structure
+ * @fmt: Pointer to pad level media bus format
+ *
+ * This function is used to get the pad format information.
+ *
+ * Return: 0 on success
+ */
+static int xcsi2rxss_get_format(struct v4l2_subdev *sd,
+                               struct v4l2_subdev_pad_config *cfg,
+                               struct v4l2_subdev_format *fmt)
+{
+       struct xcsi2rxss_state *xcsi2rxss =3D to_xcsi2rxssstate(sd);
+
+       mutex_lock(&xcsi2rxss->lock);
+       fmt->format =3D *__xcsi2rxss_get_pad_format(xcsi2rxss, cfg,
+                                                 fmt->pad, fmt->which);
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return 0;
+}
+
+/**
+ * xcsi2rxss_set_format - This is used to set the pad format
+ * @sd: Pointer to V4L2 Sub device structure
+ * @cfg: Pointer to sub device pad information structure
+ * @fmt: Pointer to pad level media bus format
+ *
+ * This function is used to set the pad format.
+ * Since the pad format is fixed in hardware, it can't be
+ * modified on run time. So when a format set is requested by
+ * application, all parameters except the format type is
+ * saved for the pad and the original pad format is sent
+ * back to the application.
+ *
+ * Return: 0 on success
+ */
+static int xcsi2rxss_set_format(struct v4l2_subdev *sd,
+                               struct v4l2_subdev_pad_config *cfg,
+                               struct v4l2_subdev_format *fmt)
+{
+       struct v4l2_mbus_framefmt *__format;
+       struct xcsi2rxss_state *xcsi2rxss =3D to_xcsi2rxssstate(sd);
+       struct xcsi2rxss_core *core =3D &xcsi2rxss->core;
+       u32 code;
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       /*
+        * Only the format->code parameter matters for CSI as the
+        * CSI format cannot be changed at runtime.
+        * Ensure that format to set is copied to over to CSI pad format
+        */
+       __format =3D __xcsi2rxss_get_pad_format(xcsi2rxss, cfg,
+                                             fmt->pad, fmt->which);
+
+       /* Save the pad format code */
+       code =3D __format->code;
+
+       /* If the bayer pattern to be set is SXXXX8 then only 1x8 type
+        * is supported and core's data type doesn't matter.
+        * In case the bayer pattern being set is SXXX10 then only
+        * 1x10 type are supported and core should be configured for RAW10.
+        * In case the bayer pattern being set is SXXX12 then only
+        * 1x12 type are supported and core should be configured for RAW12.
+        *
+        * Otherwise don't allow change.
+        */
+       if ((fmt->format.code =3D=3D MEDIA_BUS_FMT_SBGGR8_1X8 ||
+            fmt->format.code =3D=3D MEDIA_BUS_FMT_SGBRG8_1X8 ||
+            fmt->format.code =3D=3D MEDIA_BUS_FMT_SGRBG8_1X8 ||
+            fmt->format.code =3D=3D MEDIA_BUS_FMT_SRGGB8_1X8) ||
+            (core->datatype =3D=3D MIPI_CSI_DT_RAW_10 &&
+            (fmt->format.code =3D=3D MEDIA_BUS_FMT_SBGGR10_1X10 ||
+             fmt->format.code =3D=3D MEDIA_BUS_FMT_SGBRG10_1X10 ||
+             fmt->format.code =3D=3D MEDIA_BUS_FMT_SGRBG10_1X10 ||
+             fmt->format.code =3D=3D MEDIA_BUS_FMT_SRGGB10_1X10)) ||
+            (core->datatype =3D=3D MIPI_CSI_DT_RAW_12 &&
+            (fmt->format.code =3D=3D MEDIA_BUS_FMT_SBGGR12_1X12 ||
+             fmt->format.code =3D=3D MEDIA_BUS_FMT_SGBRG12_1X12 ||
+             fmt->format.code =3D=3D MEDIA_BUS_FMT_SGRBG12_1X12 ||
+             fmt->format.code =3D=3D MEDIA_BUS_FMT_SRGGB12_1X12))) {
+               /* Copy over the format to be set */
+               *__format =3D fmt->format;
+       } else {
+               /* Restore the original pad format code */
+               fmt->format.code =3D code;
+               __format->code =3D code;
+       }
+
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return 0;
+}
+
+/**
+ * xcsi2rxss_open - Called on v4l2_open()
+ * @sd: Pointer to V4L2 sub device structure
+ * @fh: Pointer to V4L2 File handle
+ *
+ * This function is called on v4l2_open(). It sets the default format
+ * for both pads.
+ *
+ * Return: 0 on success
+ */
+static int xcsi2rxss_open(struct v4l2_subdev *sd,
+                         struct v4l2_subdev_fh *fh)
+{
+       struct v4l2_mbus_framefmt *format;
+       struct xcsi2rxss_state *xcsi2rxss =3D to_xcsi2rxssstate(sd);
+
+       format =3D v4l2_subdev_get_try_format(sd, fh->pad, 0);
+       *format =3D xcsi2rxss->default_format;
+
+       format =3D v4l2_subdev_get_try_format(sd, fh->pad, 1);
+       *format =3D xcsi2rxss->default_format;
+
+       return 0;
+}
+
+static int xcsi2rxss_close(struct v4l2_subdev *sd,
+                          struct v4l2_subdev_fh *fh)
+{
+       return 0;
+}
+
+/* -----------------------------------------------------------------------=
------
+ * Media Operations
+ */
+
+static const struct media_entity_operations xcsi2rxss_media_ops =3D {
+       .link_validate =3D v4l2_subdev_link_validate
+};
+
+static const struct v4l2_ctrl_ops xcsi2rxss_ctrl_ops =3D {
+       .g_volatile_ctrl =3D xcsi2rxss_g_volatile_ctrl,
+       .s_ctrl =3D xcsi2rxss_s_ctrl
+};
+
+static struct v4l2_ctrl_config xcsi2rxss_ctrls[] =3D {
+       {
+               .ops    =3D &xcsi2rxss_ctrl_ops,
+               .id     =3D V4L2_CID_XILINX_MIPICSISS_ACT_LANES,
+               .name   =3D "MIPI CSI2 Rx Subsystem: Active Lanes",
+               .type   =3D V4L2_CTRL_TYPE_INTEGER,
+               .min    =3D 1,
+               .max    =3D 4,
+               .step   =3D 1,
+               .def    =3D 1,
+       }, {
+               .ops    =3D &xcsi2rxss_ctrl_ops,
+               .id     =3D V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER,
+               .name   =3D "MIPI CSI2 Rx Subsystem: Frames Received Counte=
r",
+               .type   =3D V4L2_CTRL_TYPE_INTEGER,
+               .min    =3D 0,
+               .max    =3D 0xFFFFFFFF,
+               .step   =3D 1,
+               .def    =3D 0,
+               .flags  =3D V4L2_CTRL_FLAG_VOLATILE | V4L2_CTRL_FLAG_READ_O=
NLY,
+       }, {
+               .ops    =3D &xcsi2rxss_ctrl_ops,
+               .id     =3D V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS,
+               .name   =3D "MIPI CSI2 Rx Subsystem: Reset Counters",
+               .type   =3D V4L2_CTRL_TYPE_BUTTON,
+               .min    =3D 0,
+               .max    =3D 1,
+               .step   =3D 1,
+               .def    =3D 0,
+               .flags  =3D V4L2_CTRL_FLAG_WRITE_ONLY,
+       }
+};
+
+static const struct v4l2_subdev_core_ops xcsi2rxss_core_ops =3D {
+       .log_status =3D xcsi2rxss_log_status,
+       .subscribe_event =3D xcsi2rxss_subscribe_event,
+       .unsubscribe_event =3D xcsi2rxss_unsubscribe_event
+};
+
+static struct v4l2_subdev_video_ops xcsi2rxss_video_ops =3D {
+       .s_stream =3D xcsi2rxss_s_stream
+};
+
+static struct v4l2_subdev_pad_ops xcsi2rxss_pad_ops =3D {
+       .get_fmt =3D xcsi2rxss_get_format,
+       .set_fmt =3D xcsi2rxss_set_format,
+};
+
+static struct v4l2_subdev_ops xcsi2rxss_ops =3D {
+       .core =3D &xcsi2rxss_core_ops,
+       .video =3D &xcsi2rxss_video_ops,
+       .pad =3D &xcsi2rxss_pad_ops
+};
+
+static const struct v4l2_subdev_internal_ops xcsi2rxss_internal_ops =3D {
+       .open =3D xcsi2rxss_open,
+       .close =3D xcsi2rxss_close
+};
+
+/* -----------------------------------------------------------------------=
------
+ * Power Management
+ */
+
+/*
+ * xcsi2rxss_pm_suspend - Function called on Power Suspend
+ * @dev: Pointer to device structure
+ *
+ * On power suspend the CSI-2 Core is disabled if the device isn't
+ * in suspended state and is streaming.
+ *
+ * Return: 0 on success
+ */
+static int __maybe_unused xcsi2rxss_pm_suspend(struct device *dev)
+{
+       struct xcsi2rxss_state *xcsi2rxss =3D dev_get_drvdata(dev);
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       if (!xcsi2rxss->suspended && xcsi2rxss->streaming)
+               xcsi2rxss_clr(&xcsi2rxss->core,
+                             XCSI_CCR_OFFSET, XCSI_CCR_COREENB_MASK);
+
+       xcsi2rxss->suspended =3D true;
+
+       mutex_unlock(&xcsi2rxss->lock);
+
+       return 0;
+}
+
+/*
+ * xcsi2rxss_pm_resume - Function called on Power Resume
+ * @dev: Pointer to device structure
+ *
+ * On power resume the CSI-2 Core is enabled when it is in suspended state
+ * and prior to entering suspended state it was streaming.
+ *
+ * Return: 0 on success
+ */
+static int __maybe_unused xcsi2rxss_pm_resume(struct device *dev)
+{
+       struct xcsi2rxss_state *xcsi2rxss =3D dev_get_drvdata(dev);
+
+       mutex_lock(&xcsi2rxss->lock);
+
+       if (xcsi2rxss->suspended && xcsi2rxss->streaming)
+               xcsi2rxss_set(&xcsi2rxss->core,
+                             XCSI_CCR_OFFSET, XCSI_CCR_COREENB_MASK);
+
+       xcsi2rxss->suspended =3D false;
+
+       mutex_unlock(&xcsi2rxss->lock);
+       return 0;
+}
+
+/* -----------------------------------------------------------------------=
------
+ * Platform Device Driver
+ */
+
+static int xcsi2rxss_parse_of(struct xcsi2rxss_state *xcsi2rxss)
+{
+       struct device_node *node =3D xcsi2rxss->core.dev->of_node;
+       struct device_node *ports =3D NULL;
+       struct device_node *port =3D NULL;
+       unsigned int nports =3D 0;
+       struct xcsi2rxss_core *core =3D &xcsi2rxss->core;
+       int ret;
+       bool iic_present;
+
+       core->dphy_present =3D of_property_read_bool(node, "xlnx,dphy-prese=
nt");
+       dev_dbg(core->dev, "DPHY present property =3D %s\n",
+               core->dphy_present ? "Present" : "Absent");
+
+       iic_present =3D of_property_read_bool(node, "xlnx,iic-present");
+       dev_dbg(core->dev, "IIC present property =3D %s\n",
+               iic_present ? "Present" : "Absent");
+
+       if (core->dphy_present) {
+               if (iic_present)
+                       core->dphy_offset =3D 0x20000;
+               else
+                       core->dphy_offset =3D 0x10000;
+       }
+
+       ret =3D of_property_read_u32(node, "xlnx,max-lanes",
+                                  &core->max_num_lanes);
+       if (ret < 0) {
+               dev_err(core->dev, "missing xlnx,max-lanes property\n");
+               return ret;
+       }
+
+       if (core->max_num_lanes > 4 || core->max_num_lanes < 1) {
+               dev_err(core->dev, "%d max lanes : invalid xlnx,max-lanes p=
roperty\n",
+                       core->max_num_lanes);
+               return -EINVAL;
+       }
+
+       ret =3D of_property_read_u32(node, "xlnx,vc", &core->vc);
+       if (ret < 0) {
+               dev_err(core->dev, "missing xlnx,vc property\n");
+               return ret;
+       }
+       if (core->vc > 4) {
+               dev_err(core->dev, "invalid virtual channel property value.=
\n");
+               return -EINVAL;
+       }
+
+       core->enable_active_lanes =3D
+               of_property_read_bool(node, "xlnx,en-active-lanes");
+       dev_dbg(core->dev, "Enable active lanes property =3D %s\n",
+               core->enable_active_lanes ? "Present" : "Absent");
+
+       ret =3D of_property_read_string(node, "xlnx,csi-pxl-format",
+                                     &core->pxlformat);
+       if (ret < 0) {
+               dev_err(core->dev, "missing xlnx,csi-pxl-format property\n"=
);
+               return ret;
+       }
+
+       core->datatype =3D xcsi2rxss_pxlfmtstrtodt(core->pxlformat);
+       if (core->datatype < MIPI_CSI_DT_YUV_420_8B ||
+           core->datatype > MIPI_CSI_DT_RAW_14) {
+               dev_err(core->dev, "Invalid xlnx,csi-pxl-format string\n");
+               return -EINVAL;
+       }
+
+       core->vfb =3D of_property_read_bool(node, "xlnx,vfb");
+       dev_dbg(core->dev, "Video Format Bridge property =3D %s\n",
+               core->vfb ? "Present" : "Absent");
+
+       if (core->vfb) {
+               ret =3D of_property_read_u32(node, "xlnx,ppc", &core->ppc);
+               if (ret < 0 || !(core->ppc =3D=3D 1 || core->ppc =3D=3D 2 |=
|
+                                core->ppc =3D=3D 4)) {
+                       dev_err(core->dev, "Invalid xlnx,ppc property ret =
=3D %d ppc =3D %d\n",
+                               ret, core->ppc);
+                       return -EINVAL;
+               }
+       }
+
+       ports =3D of_get_child_by_name(node, "ports");
+       if (!ports)
+               ports =3D node;
+
+       for_each_child_of_node(ports, port) {
+               int ret;
+               const struct xvip_video_format *format;
+               struct device_node *endpoint;
+               struct v4l2_fwnode_endpoint v4lendpoint;
+
+               if (!port->name || of_node_cmp(port->name, "port"))
+                       continue;
+
+               /*
+                * Currently only a subset of VFB enabled formats present i=
n
+                * xvip are supported in the  driver.
+                *
+                * If the VFB is disabled, the pixels per clock don't matte=
r.
+                * The data width is either 32 or 64 bit as selected in des=
ign.
+                *
+                * For e.g. If Data Type is RGB888, VFB is disabled and
+                * data width is 32 bits.
+                *
+                * Clk Cycle  |  Byte 0  |  Byte 1  |  Byte 2  |  Byte 3
+                * -----------+----------+----------+----------+----------
+                *     1      |     B0   |     G0   |     R0   |     B1
+                *     2      |     G1   |     R1   |     B2   |     G2
+                *     3      |     R2   |     B3   |     G3   |     R3
+                */
+               format =3D xvip_of_get_format(port);
+               if (IS_ERR(format)) {
+                       dev_err(core->dev, "invalid format in DT");
+                       return PTR_ERR(format);
+               }
+
+               if (core->vfb &&
+                   format->vf_code !=3D XVIP_VF_YUV_422 &&
+                   format->vf_code !=3D XVIP_VF_RBG &&
+                   format->vf_code !=3D XVIP_VF_MONO_SENSOR) {
+                       dev_err(core->dev, "Invalid UG934 video format set.=
\n");
+                       return -EINVAL;
+               }
+
+               /* Get and check the format description */
+               if (!xcsi2rxss->vip_format) {
+                       xcsi2rxss->vip_format =3D format;
+               } else if (xcsi2rxss->vip_format !=3D format) {
+                       dev_err(core->dev, "in/out format mismatch in DT");
+                       return -EINVAL;
+               }
+
+               endpoint =3D of_get_next_child(port, NULL);
+               if (!endpoint) {
+                       dev_err(core->dev, "No port at\n");
+                       return -EINVAL;
+               }
+
+               ret =3D v4l2_fwnode_endpoint_parse(of_fwnode_handle(endpoin=
t),
+                                                &v4lendpoint);
+               if (ret) {
+                       of_node_put(endpoint);
+                       return ret;
+               }
+
+               of_node_put(endpoint);
+               dev_dbg(core->dev, "%s : port %d bus type =3D %d\n",
+                       __func__, nports, v4lendpoint.bus_type);
+
+               if (v4lendpoint.bus_type =3D=3D V4L2_MBUS_CSI2) {
+                       dev_dbg(core->dev, "%s : base.port =3D %d base.id =
=3D %d\n",
+                               __func__, v4lendpoint.base.port,
+                               v4lendpoint.base.id);
+
+                       dev_dbg(core->dev, "%s : mipi number lanes =3D %d\n=
",
+                               __func__,
+                               v4lendpoint.bus.mipi_csi2.num_data_lanes);
+               } else {
+                       dev_dbg(core->dev, "%s : Not a CSI2 bus\n", __func_=
_);
+               }
+
+               /* Count the number of ports. */
+               nports++;
+       }
+
+       if (nports !=3D 2) {
+               dev_err(core->dev, "invalid number of ports %u\n", nports);
+               return -EINVAL;
+       }
+       xcsi2rxss->npads =3D nports;
+
+       /*Register interrupt handler */
+       core->irq =3D irq_of_parse_and_map(node, 0);
+
+       ret =3D devm_request_irq(core->dev, core->irq, xcsi2rxss_irq_handle=
r,
+                              IRQF_SHARED, "xilinx-csi2rxss", xcsi2rxss);
+       if (ret) {
+               dev_err(core->dev, "Err =3D %d Interrupt handler reg failed=
!\n",
+                       ret);
+               return ret;
+       }
+
+       return 0;
+}
+
+static int xcsi2rxss_probe(struct platform_device *pdev)
+{
+       struct v4l2_subdev *subdev;
+       struct xcsi2rxss_state *xcsi2rxss;
+       struct resource *res;
+
+       u32 i;
+       int ret;
+       int num_ctrls;
+
+       xcsi2rxss =3D devm_kzalloc(&pdev->dev, sizeof(*xcsi2rxss), GFP_KERN=
EL);
+       if (!xcsi2rxss)
+               return -ENOMEM;
+
+       mutex_init(&xcsi2rxss->lock);
+
+       xcsi2rxss->core.dev =3D &pdev->dev;
+
+       ret =3D xcsi2rxss_parse_of(xcsi2rxss);
+       if (ret < 0)
+               return ret;
+
+       res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+       xcsi2rxss->core.iomem =3D devm_ioremap_resource(xcsi2rxss->core.dev=
, res);
+       if (IS_ERR(xcsi2rxss->core.iomem))
+               return PTR_ERR(xcsi2rxss->core.iomem);
+
+       /*
+        * Reset and initialize the core.
+        */
+       xcsi2rxss_reset(&xcsi2rxss->core);
+
+       xcsi2rxss->core.events =3D  (struct xcsi2rxss_event *)&xcsi2rxss_ev=
ents;
+
+       /* Initialize V4L2 subdevice and media entity */
+       xcsi2rxss->pads[0].flags =3D MEDIA_PAD_FL_SOURCE;
+       xcsi2rxss->pads[1].flags =3D MEDIA_PAD_FL_SINK;
+
+       /* Initialize the default format */
+       memset(&xcsi2rxss->default_format, 0,
+              sizeof(xcsi2rxss->default_format));
+       xcsi2rxss->default_format.code =3D xcsi2rxss->vip_format->code;
+       xcsi2rxss->default_format.field =3D V4L2_FIELD_NONE;
+       xcsi2rxss->default_format.colorspace =3D V4L2_COLORSPACE_SRGB;
+       xcsi2rxss->default_format.width =3D XCSI_DEFAULT_WIDTH;
+       xcsi2rxss->default_format.height =3D XCSI_DEFAULT_HEIGHT;
+
+       xcsi2rxss->formats[0] =3D xcsi2rxss->default_format;
+       xcsi2rxss->formats[1] =3D xcsi2rxss->default_format;
+
+       /* Initialize V4L2 subdevice and media entity */
+       subdev =3D &xcsi2rxss->subdev;
+       v4l2_subdev_init(subdev, &xcsi2rxss_ops);
+
+       subdev->dev =3D &pdev->dev;
+       subdev->internal_ops =3D &xcsi2rxss_internal_ops;
+       strlcpy(subdev->name, dev_name(&pdev->dev), sizeof(subdev->name));
+
+       subdev->flags |=3D V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_D=
EVNODE;
+
+       subdev->entity.ops =3D &xcsi2rxss_media_ops;
+
+       v4l2_set_subdevdata(subdev, xcsi2rxss);
+
+       ret =3D media_entity_pads_init(&subdev->entity, 2, xcsi2rxss->pads)=
;
+       if (ret < 0)
+               goto error;
+
+       /*
+        * In case the Enable Active Lanes config parameter is not set,
+        * dynamic lane reconfiguration is not allowed.
+        * So V4L2_CID_XILINX_MIPICSISS_ACT_LANES ctrl will not be register=
ed.
+        * Accordingly allocate the number of controls
+        */
+       num_ctrls =3D ARRAY_SIZE(xcsi2rxss_ctrls);
+
+       if (!xcsi2rxss->core.enable_active_lanes)
+               num_ctrls--;
+
+       dev_dbg(xcsi2rxss->core.dev, "# of ctrls =3D %d\n", num_ctrls);
+
+       v4l2_ctrl_handler_init(&xcsi2rxss->ctrl_handler, num_ctrls);
+
+       for (i =3D 0; i < ARRAY_SIZE(xcsi2rxss_ctrls); i++) {
+               struct v4l2_ctrl *ctrl;
+
+               if (xcsi2rxss_ctrls[i].id =3D=3D
+                       V4L2_CID_XILINX_MIPICSISS_ACT_LANES) {
+                       if (xcsi2rxss->core.enable_active_lanes) {
+                               xcsi2rxss_ctrls[i].max =3D
+                                       xcsi2rxss->core.max_num_lanes;
+                       } else {
+                               /* Don't register control */
+                               dev_dbg(xcsi2rxss->core.dev,
+                                       "Skip active lane control\n");
+                               continue;
+                       }
+               }
+
+               dev_dbg(xcsi2rxss->core.dev, "%d ctrl =3D 0x%x\n",
+                       i, xcsi2rxss_ctrls[i].id);
+               ctrl =3D v4l2_ctrl_new_custom(&xcsi2rxss->ctrl_handler,
+                                           &xcsi2rxss_ctrls[i], NULL);
+               if (!ctrl) {
+                       dev_err(xcsi2rxss->core.dev, "Failed for %s ctrl\n"=
,
+                               xcsi2rxss_ctrls[i].name);
+                       goto error;
+               }
+       }
+
+       dev_dbg(xcsi2rxss->core.dev, "# v4l2 ctrls registered =3D %d\n", i =
- 1);
+
+       if (xcsi2rxss->ctrl_handler.error) {
+               dev_err(&pdev->dev, "failed to add controls\n");
+               ret =3D xcsi2rxss->ctrl_handler.error;
+               goto error;
+       }
+
+       subdev->ctrl_handler =3D &xcsi2rxss->ctrl_handler;
+
+       ret =3D v4l2_ctrl_handler_setup(&xcsi2rxss->ctrl_handler);
+       if (ret < 0) {
+               dev_err(&pdev->dev, "failed to set controls\n");
+               goto error;
+       }
+
+       platform_set_drvdata(pdev, xcsi2rxss);
+
+       dev_info(xcsi2rxss->core.dev, "Xilinx CSI2 Rx Subsystem device foun=
d!\n");
+
+       ret =3D v4l2_async_register_subdev(subdev);
+       if (ret < 0) {
+               dev_err(&pdev->dev, "failed to register subdev\n");
+               goto error;
+       }
+
+       /* default states for streaming and suspend */
+       xcsi2rxss->streaming =3D false;
+       xcsi2rxss->suspended =3D false;
+       return 0;
+
+error:
+       v4l2_ctrl_handler_free(&xcsi2rxss->ctrl_handler);
+       media_entity_cleanup(&subdev->entity);
+       mutex_destroy(&xcsi2rxss->lock);
+
+       return ret;
+}
+
+static int xcsi2rxss_remove(struct platform_device *pdev)
+{
+       struct xcsi2rxss_state *xcsi2rxss =3D platform_get_drvdata(pdev);
+       struct v4l2_subdev *subdev =3D &xcsi2rxss->subdev;
+
+       v4l2_async_unregister_subdev(subdev);
+       v4l2_ctrl_handler_free(&xcsi2rxss->ctrl_handler);
+       media_entity_cleanup(&subdev->entity);
+       mutex_destroy(&xcsi2rxss->lock);
+
+       return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(xcsi2rxss_pm_ops,
+                        xcsi2rxss_pm_suspend, xcsi2rxss_pm_resume);
+
+static const struct of_device_id xcsi2rxss_of_id_table[] =3D {
+       { .compatible =3D "xlnx,mipi-csi2-rx-subsystem-2.0" },
+       { .compatible =3D "xlnx,mipi-csi2-rx-subsystem-3.0" },
+       { }
+};
+MODULE_DEVICE_TABLE(of, xcsi2rxss_of_id_table);
+
+static struct platform_driver xcsi2rxss_driver =3D {
+       .driver =3D {
+               .name           =3D "xilinx-csi2rxss",
+               .pm             =3D &xcsi2rxss_pm_ops,
+               .of_match_table =3D xcsi2rxss_of_id_table,
+       },
+       .probe                  =3D xcsi2rxss_probe,
+       .remove                 =3D xcsi2rxss_remove,
+};
+module_platform_driver(xcsi2rxss_driver);
+MODULE_AUTHOR("Vishal Sagar <vishal.sagar@xilinx.com>");
+MODULE_DESCRIPTION("Xilinx MIPI CSI2 Rx Subsystem Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/include/uapi/linux/xilinx-csi2rxss.h b/include/uapi/linux/xili=
nx-csi2rxss.h
new file mode 100644
index 0000000..973d5b46
--- /dev/null
+++ b/include/uapi/linux/xilinx-csi2rxss.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+/*
+ * Events from Xilinx MIPI CSI2 Rx Subsystem exposed to V4L2 application.
+ *
+ * Copyright (C) 2016 - 2018 Xilinx, Inc.
+ * Author: Vishal Sagar <vishal.sagar@xilinx.com>
+ */
+#ifndef __UAPI_XILINX_CSI2RXSS_H__
+#define __UAPI_XILINX_CSI2RXSS_H__
+
+#include <linux/videodev2.h>
+
+/*
+ * Events
+ *
+ * V4L2_EVENT_XLNXCSIRX_SPKT: Short packet received
+ * V4L2_EVENT_XLNXCSIRX_SPKT_OVF: Short packet FIFO overflow
+ * V4L2_EVENT_XLNXCSIRX_SLBF: Stream line buffer full
+ */
+#define V4L2_EVENT_XLNXCSIRX_CLASS     (V4L2_EVENT_PRIVATE_START | 0x100)
+#define V4L2_EVENT_XLNXCSIRX_SPKT      (V4L2_EVENT_XLNXCSIRX_CLASS | 0x1)
+#define V4L2_EVENT_XLNXCSIRX_SPKT_OVF  (V4L2_EVENT_XLNXCSIRX_CLASS | 0x2)
+#define V4L2_EVENT_XLNXCSIRX_SLBF      (V4L2_EVENT_XLNXCSIRX_CLASS | 0x3)
+
+#endif /* __UAPI_XILINX_CSI2RXSS_H__ */
diff --git a/include/uapi/linux/xilinx-v4l2-controls.h b/include/uapi/linux=
/xilinx-v4l2-controls.h
index b6441fe..4ca3b44 100644
--- a/include/uapi/linux/xilinx-v4l2-controls.h
+++ b/include/uapi/linux/xilinx-v4l2-controls.h
@@ -71,4 +71,18 @@
 /* Noise level */
 #define V4L2_CID_XILINX_TPG_NOISE_GAIN         (V4L2_CID_XILINX_TPG + 17)

+/*
+ * Xilinx MIPI CSI2 Rx Subsystem
+ */
+
+/* Base ID */
+#define V4L2_CID_XILINX_MIPICSISS              (V4L2_CID_USER_BASE + 0xc08=
0)
+
+/* Active Lanes */
+#define V4L2_CID_XILINX_MIPICSISS_ACT_LANES    (V4L2_CID_XILINX_MIPICSISS =
+ 1)
+/* Frames received since streaming is set */
+#define V4L2_CID_XILINX_MIPICSISS_FRAME_COUNTER        (V4L2_CID_XILINX_MI=
PICSISS + 2)
+/* Reset all event counters */
+#define V4L2_CID_XILINX_MIPICSISS_RESET_COUNTERS (V4L2_CID_XILINX_MIPICSIS=
S + 3)
+
 #endif /* __UAPI_XILINX_V4L2_CONTROLS_H__ */
--
2.7.4

This email and any attachments are intended for the sole use of the named r=
ecipient(s) and contain(s) confidential information that may be proprietary=
, privileged or copyrighted under applicable law. If you are not the intend=
ed recipient, do not read, copy, or forward this email message or any attac=
hments. Delete this email message and any attachments immediately.
