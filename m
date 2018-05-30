Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.socionext.com ([202.248.49.38]:35847 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968808AbeE3JJv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 05:09:51 -0400
From: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        linux-media@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
Subject: [PATCH 2/8] media: uniphier: add headers of HSC MPEG2-TS I/O driver
Date: Wed, 30 May 2018 18:09:40 +0900
Message-Id: <20180530090946.1635-3-suzuki.katsuhiro@socionext.com>
In-Reply-To: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
References: <20180530090946.1635-1-suzuki.katsuhiro@socionext.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds register definitions of  HSC (High speed Stream
Controller) driver for Socionext UniPhier SoCs. The HSC enables to
input and output MPEG2-TS stream from/to outer world of SoC.

Signed-off-by: Katsuhiro Suzuki <suzuki.katsuhiro@socionext.com>
---
 drivers/media/platform/Kconfig            |   1 +
 drivers/media/platform/Makefile           |   2 +
 drivers/media/platform/uniphier/Kconfig   |   9 +
 drivers/media/platform/uniphier/Makefile  |   1 +
 drivers/media/platform/uniphier/hsc-reg.h | 491 ++++++++++++++++++++++
 drivers/media/platform/uniphier/hsc.h     | 480 +++++++++++++++++++++
 6 files changed, 984 insertions(+)
 create mode 100644 drivers/media/platform/uniphier/Kconfig
 create mode 100644 drivers/media/platform/uniphier/Makefile
 create mode 100644 drivers/media/platform/uniphier/hsc-reg.h
 create mode 100644 drivers/media/platform/uniphier/hsc.h

diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
index 2728376b04b5..289ab4dfd30e 100644
--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -525,6 +525,7 @@ menuconfig DVB_PLATFORM_DRIVERS
 
 if DVB_PLATFORM_DRIVERS
 source "drivers/media/platform/sti/c8sectpfe/Kconfig"
+source "drivers/media/platform/uniphier/Kconfig"
 endif #DVB_PLATFORM_DRIVERS
 
 menuconfig CEC_PLATFORM_DRIVERS
diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
index 04bc1502a30e..08d5052119ef 100644
--- a/drivers/media/platform/Makefile
+++ b/drivers/media/platform/Makefile
@@ -93,3 +93,5 @@ obj-$(CONFIG_VIDEO_QCOM_CAMSS)		+= qcom/camss-8x16/
 obj-$(CONFIG_VIDEO_QCOM_VENUS)		+= qcom/venus/
 
 obj-y					+= meson/
+
+obj-$(CONFIG_DVB_UNIPHIER)		+= uniphier/
diff --git a/drivers/media/platform/uniphier/Kconfig b/drivers/media/platform/uniphier/Kconfig
new file mode 100644
index 000000000000..1b4543ec1e3c
--- /dev/null
+++ b/drivers/media/platform/uniphier/Kconfig
@@ -0,0 +1,9 @@
+# SPDX-License-Identifier: GPL-2.0
+config DVB_UNIPHIER
+	tristate "Socionext UniPhier Frontend"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
+	depends on ARCH_UNIPHIER
+	help
+	  Driver for UniPhier frontend for MPEG2-TS input/output,
+	  demux and descramble.
+	  Say Y when you want to support this frontend.
diff --git a/drivers/media/platform/uniphier/Makefile b/drivers/media/platform/uniphier/Makefile
new file mode 100644
index 000000000000..f66554cd5c45
--- /dev/null
+++ b/drivers/media/platform/uniphier/Makefile
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0
diff --git a/drivers/media/platform/uniphier/hsc-reg.h b/drivers/media/platform/uniphier/hsc-reg.h
new file mode 100644
index 000000000000..5f0a9b86cf49
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc-reg.h
@@ -0,0 +1,491 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+ *
+ * Copyright (c) 2018 Socionext Inc.
+ */
+
+#ifndef DVB_UNIPHIER_HSC_REG_H__
+#define DVB_UNIPHIER_HSC_REG_H__
+
+/*
+ * CH_0 : CIP-R8, W9
+ * CH_1 : CIP-R10,W11
+ * CH_2 : CIP-R12,W13
+ * CH_3 : CIP-R14,W15
+ * CH_4 : CIP-R16,W17
+ */
+enum HSC_CIP_FILE_NO {
+	HSC_CIP_FILE_NO_0 = 0x0,
+	HSC_CIP_FILE_NO_1,
+	HSC_CIP_FILE_NO_2,
+	HSC_CIP_FILE_NO_3,
+	HSC_CIP_FILE_NO_4,
+	HSC_CIP_FILE_NO_END,
+	HSC_CIP_FILE_NO_DISABLE,
+};
+
+#define HSC_CIP_FILE_TO_CIPR(i)       ((i) * 2 + 0)
+#define HSC_CIP_FILE_TO_CIPW(i)       ((i) * 2 + 1)
+#define HSC_CIP_FILE_TO_CIPR_DMCH(i)  (HSC_CIP_FILE_TO_CIPR(i) + 8)
+#define HSC_CIP_FILE_TO_CIPW_DMCH(i)  (HSC_CIP_FILE_TO_CIPW(i) + 8)
+
+/* RAM Address */
+#define FLT_PATN_RAM_TOP_ADDR           0x0a000
+#define FLT_MASK_RAM_TOP_ADDR           0x0b000
+#define SHARE_MEMORY_0_NORMAL           0x10000
+#define SHARE_MEMORY_1_NORMAL           0x11000
+#define SHARE_MEMORY_2_NORMAL           0x12000
+#define SHARE_MEMORY_3_NORMAL           0x13000
+#define SHARE_MEMORY_4_NORMAL           0x14000
+#define SHARE_MEMORY_5_NORMAL           0x15000
+#define SHARE_MEMORY_6_NORMAL           0x16000
+#define SHARE_MEMORY_7_NORMAL           0x17000
+
+/* RAM size */
+#define FLT_PATN_RAM_SIZE               0x0800
+#define FLT_MASK_RAM_SIZE               0x0800
+#define FLT_PIDPATTERN_SIZE             0x0160
+#define SHARE_MEMORY_0_SIZE             0x1000
+#define SHARE_MEMORY_1_SIZE             0x1000
+#define SHARE_MEMORY_2_SIZE             0x1000
+#define SHARE_MEMORY_3_SIZE             0x1000
+#define SHARE_MEMORY_4_SIZE             0x1000
+#define SHARE_MEMORY_5_SIZE             0x1000
+#define SHARE_MEMORY_6_SIZE             0x1000
+#define SHARE_MEMORY_7_SIZE             0x1000
+
+/* CIP SPU Stream */
+#define CIP_S_ID             0x14c0
+#define CIP_S_MODE           0x14c4
+#define CIP_S_CTRL           0x14c8
+#define CIP_S_SIZE           0x14cc
+#define CIP_S_BASE           0x14f8
+#define CIP_DEBUG            0x14fc
+
+/* CIP SPU HDC */
+#define HDC_CTRL             0x1520
+#define HDC_PTS              0x1524
+#define HDC_STAT             0x1528
+#define HDC_SPN_STAT         0x152c
+#define HDC_SPN              0x1530
+#define HDC_PATTERN          0x1534
+#define HDC_RESULT           0x1538
+#define HDC_RESULT_POS       0x153c
+
+/* CIP SPU File */
+#define CIP_F_ID             0x1540
+#define CIP_F_MODE           0x1544
+#define CIP_F_CTRL           0x1548
+#define CIP_F_SKIP           0x154c
+#define CIP_F_PAYLOAD        0x1560
+#define CIP_F_AUX0           0x156c
+#define CIP_F_AUX1           0x1570
+#define CIP_F_AUX2           0x1574
+#define CIP_F_REMAIN         0x1578
+#define CIP_F_EPNVERIFY1     0x157c
+#define CIP_F_EPNVERIFY2     0x1580
+#define CIP_F_EPNCNT         0x1584
+#define CIP_F_PKTCNT         0x1588
+#define CIP_F_STAT           0x1590
+#define CIP_F_SIZE           0x1594
+#define CIP_F_IBUF           0x1598
+#define CIP_F_OBUF           0x159c
+#define CIP_F_BASE           0x15b8
+#define CIP_F_BASEDIVX       0x15bc
+
+/* FLT1 SPU, FLT2 HOST */
+#define FLT_CTRL1            0x15c0
+#define FLT_CTRL2            0x15c4
+#define FLT_CTRL3            0x15c8
+#define FLT_CTRL4            0x15cc
+#define FLT_STATUS           0x15d0
+#define FLT_INTENABLE        0x15d4
+#define FLT_INTSTATUS        0x15d8
+#define FLT_LINE(i)          (0x15e0 + (i) * 0x04)
+#define FLT_LENMODE          0x15f8
+#define FLT_LEN              0x15fc
+#define FLT_TRNUM            0x1600
+#define FLT_COUNT1           0x1604
+#define FLT_COUNT2           0x1608
+#define FLT_BUFCOUNT         0x160c
+#define FLT_INBUF(i)         (0x1610 + (i) * 0x04)
+#define FLT_CRC              0x1624
+#define FLT_CRCCALC          0x1628
+#define FLT_SECNUM           0x1630
+#define FLT_COMP             0x1634
+#define FLT_SWACE            0x163c
+
+#define FLT_ATR(i)           (0x1d00 + (i) * 0x04)
+#define FLT_PIDNUM           0x1d24
+
+/* SBC1, 2 */
+#define SBC_ACE_DMA_EN                0x6000
+#define SBC_DMAPARAM21                0x6004
+#define SBC_ACE_INTREN                0x6008
+#define SBC_ACE_INTRST                0x600c
+#define SBC_DMA_STATUS0               0x6010
+#define SBC_DMA_STATUS1               0x6014
+#define SBC_DMAPARAMA(i)              (0x6018 + (i) * 0x04)
+#define   SBC_DMAPARAMA_OFFSET_MASK     GENMASK(31, 29)
+#define   SBC_DMAPARAMA_LOOPADDR_MASK   GENMASK(28, 23)
+#define   SBC_DMAPARAMA_COUNT_MASK      GENMASK(7, 0)
+#define SBC_DMAPARAMB(i)              (0x6038 + (i) * 0x04)
+
+#define SBC_INTRENABLE0               0x60a0
+#define SBC_INTRSTATUS0               0x60a4
+#define SBC_INTRENABLE1               0x60a8
+#define SBC_INTRSTATUS1               0x60ac
+
+#define SBC_CONFIG0                   0x60c0
+#define SBC_PARREGION0                0x60c4
+#define SBC_PARREGION1                0x60c8
+
+/* IOB1, 2, 3 */
+#define IOB_PKTCNT                    0x1740
+#define IOB_PKTCNTRST                 0x1744
+#define IOB_PKTCNTST                  0x1744
+#define IOB_DUMMY_ENABLE              0x1748
+#define IOB_FORMATCHANGE_EN           0x174c
+#define IOB_UASSIST0                  0x1750
+#define IOB_UASSIST1                  0x1754
+#define IOB_URESERVE(i)               (0x1758 + (i) * 0x4)
+#define IOB_PCRRECEN                  IOB_URESERVE(2)
+#define IOB_UPARTIAL(i)               (0x1768 + (i) * 0x4)
+#define IOB_SPUINTREN                 0x1778
+
+#define IOB_HSCREV                    0x1a00
+#define IOB_SECCLK(i)                 (0x1a08 + (i) * 0x6c)
+#define IOB_SECTIMEH(i)               (0x1a0c + (i) * 0x6c)
+#define IOB_SECTIMEL(i)               (0x1a10 + (i) * 0x6c)
+#define IOB_RESET0                    0x1a14
+#define   IOB_RESET0_APCORE             BIT(20)
+#define IOB_RESET1                    0x1a18
+#define IOB_CLKSTOP                   0x1a1c
+#define IOB_DEBUG                     0x1a20
+#define   IOB_DEBUG_SPUHALT             BIT(0)
+#define IOB_INTREN(i)                 (0x1a24 + (i) * 0x8)
+#define IOB_INTRST(i)                 (0x1a28 + (i) * 0x8)
+#define IOB_INTREN0                   0x1a24
+#define IOB_INTRST0                   0x1a28
+#define IOB_INTREN0_1                 0x1a2c
+#define IOB_INTRST0_1                 0x1a30
+#define IOB_INTREN0_2                 0x1a34
+#define IOB_INTRST0_2                 0x1a38
+#define IOB_INTREN1                   0x1a3c
+#define IOB_INTRST1                   0x1a40
+#define IOB_INTREN1_1                 0x1a44
+#define IOB_INTRST1_1                 0x1a48
+#define IOB_INTREN2                   0x1a4c
+#define IOB_INTRST2                   0x1a50
+#define   INTR2_DRV                     BIT(31)
+#define   INTR2_CIP_FRMT(i)             BIT((i) + 16)
+#define   INTR2_CIP_NORMAL              BIT(16)
+#define   INTR2_SEC_CLK_A               BIT(15)
+#define   INTR2_SEC_CLK_S               BIT(14)
+#define   INTR2_MBC_CIP_W(i)            BIT((i) + 9)
+#define   INTR2_MBC_CIP_R(i)            BIT((i) + 4)
+#define   INTR2_CIP_AUTH_A              BIT(1)
+#define   INTR2_CIP_AUTH_S              BIT(0)
+#define IOB_INTREN3                   0x1a54
+#define IOB_INTRST3                   0x1a58
+#define   INTR3_DRV                     BIT(31)
+#define   INTR3_CIP_FRMT(i)             BIT((i) + 16)
+#define   INTR3_SEC_CLK_A               BIT(15)
+#define   INTR3_SEC_CLK_S               BIT(14)
+#define   INTR3_MBC_CIP_W(i)            BIT((i) + 9)
+#define   INTR3_MBC_CIP_R(i)            BIT((i) + 4)
+#define   INTR3_CIP_AUTH_A              BIT(1)
+#define   INTR3_CIP_AUTH_S              BIT(0)
+#define IOB_INTREN4                   0x1a5c
+#define IOB_INTRST4                   0x1a60
+#define IOB_CGCTRL                    0x1a64
+#define IOB_VCXOCTL                   0x1a68
+#define IOB_IO_ATTRIBUTE              0x1a6c
+
+#define IOB_MONDAT                    0x5000
+#define IOB_MONDAT2                   0x5004
+#define IOB_TESTMODE                  0x5008
+#define IOB_TESTMODE2                 0x500c
+#define IOB_DEBUGTCERT                0x5010
+
+/* MBC1-7 Common */
+#define CDMBC_STRT(i)                (0x2300 + ((i) - 1) * 0x4)
+#define CDMBC_PERFCNFG               0x230c
+#define CDMBC_STAT(i)                (0x2320 + (i) * 0x4)
+#define CDMBC_PARTRESET(i)           (0x234c + (i) * 0x4)
+#define CDMBC_MONNUM                 0x2358
+#define CDMBC_MONDAT                 0x235c
+#define CDMBC_PRC0CHIE0              0x2380
+#define CDMBC_PRC0RBIE0              0x2384
+#define CDMBC_PRC1CHIE0              0x2388
+#define CDMBC_PRC2CHIE0              0x2390
+#define CDMBC_PRC2RBIE0              0x2394
+#define CDMBC_SOFTFLRQ               0x239c
+#define CDMBC_TDSTRT                 0x23a0
+
+#define INTR_MBC_CH_END              BIT(15)
+#define INTR_MBC_CH_STOP             BIT(13)
+#define INTR_MBC_CH_ADDR             BIT(6)
+#define INTR_MBC_CH_IWDONE           BIT(3)
+#define INTR_MBC_CH_WDONE            BIT(1)
+
+/* MBC
+ * i: channel number
+ *    1- 3: Record0,1,2
+ *   19-21: Record3,4,5
+ */
+#define CDMBC_CHTDCTRLH(i)            (((i) < 19) ? \
+					(0x23a4 + ((i) - 1) * 0x20) : \
+					(0x23b4 + ((i) - 19) * 0x20))
+#define   CDMBC_CHTDCTRLH_STREM_MASK    GENMASK(20, 16)
+#define   CDMBC_CHTDCTRLH_NOT_FLT       BIT(7)
+#define   CDMBC_CHTDCTRLH_ALL_EN        BIT(6)
+#define CDMBC_CHTDCTRLU(i)            (((i) < 19) ? \
+					(0x23a8 + ((i) - 1) * 0x20) : \
+					(0x23b8 + ((i) - 19) * 0x20))
+
+#define CDMBC_TDSTAT                  0x23f8
+#define CDMBC_TDIR                    0x23fc
+#define CDMBC_REPRATECTRL             0x2400
+#define CDMBC_ATRIBUTE0               0x24e8
+#define CDMBC_ATRIBUTE1               0x24ec
+#define CDMBC_ATRIBUTE2               0x24f0
+#define CDMBC_ATRIBUTE3               0x24f4
+#define CDMBC_ATRIBUTE4               0x24f8
+#define CDMBC_CIPMODE(i)              (0x24fc + (i) * 0x4)
+#define   CDMBC_CIPMODE_PUSH            BIT(0)
+#define CDMBC_CIPPRIORITY(i)          (0x2510 + (i) * 0x4)
+#define   CDMBC_CIPPRIORITY_PRIOR_MASK  GENMASK(1, 0)
+#define CDMBC_CH18ATTRIBUTE           (0x2524)
+
+/* MBC Channel
+ * i: channel number
+ *    0   : Section
+ *    1- 3: Record0,1,2
+ *    4   : Partial
+ *    5- 7: Replay0,1,2
+ *    8-17: Even: CIP-Read
+ *          Odd : CIP-Write
+ *   18   : AM32
+ *   19-21: Record3,4,5
+ *   22-24: Replay3,4,5
+ */
+#define CDMBC_CHCTRL1(i)                  (0x2540 + (i) * 0x50)
+#define   CDMBC_CHCTRL1_LINKCH1_MASK        GENMASK(12, 10)
+#define   CDMBC_CHCTRL1_STATSEL_MASK        GENMASK(9, 7)
+#define   CDMBC_CHCTRL1_TYPE_INTERMIT       BIT(1)
+#define   CDMBC_CHCTRL1_IND_SIZE_UND        BIT(0)
+#define CDMBC_CHCTRL2(i)                  (0x2544 + (i) * 0x50)
+#define CDMBC_CHDDR(i)                    (0x2548 + (i) * 0x50)
+#define   CDMBC_CHDDR_REG_LOAD_ON           BIT(4)
+#define   CDMBC_CHDDR_AT_CHEN_ON            BIT(3)
+#define   CDMBC_CHDDR_SET_MCB_MASK          GENMASK(2, 1)
+#define   CDMBC_CHDDR_SET_MCB_WR            (0x0 << 1)
+#define   CDMBC_CHDDR_SET_MCB_RD            (0x3 << 1)
+#define   CDMBC_CHDDR_SET_DDR_1             BIT(0)
+#define CDMBC_CHCAUSECTRL(i)              (0x254c + (i) * 0x50)
+#define   CDMBC_CHCAUSECTRL_MODE_MASK       BIT(31)
+#define   CDMBC_CHCAUSECTRL_CSEL2_MASK      GENMASK(20, 12)
+#define   CDMBC_CHCAUSECTRL_CSEL1_MASK      GENMASK(8, 0)
+#define CDMBC_CHSTAT(i)                   (0x2550 + (i) * 0x50)
+#define CDMBC_CHIR(i)                     (0x2554 + (i) * 0x50)
+#define CDMBC_CHIE(i)                     (0x2558 + (i) * 0x50)
+#define CDMBC_CHID(i)                     (0x255c + (i) * 0x50)
+#define   CDMBC_CHI_STOPPED                 BIT(13)
+#define   CDMBC_CHI_TRANSIT                 BIT(6)
+#define   CDMBC_CHI_STARTING                BIT(1)
+#define CDMBC_CHSRCAMODE(i)               (0x2560 + (i) * 0x50)
+#define CDMBC_CHDSTAMODE(i)               (0x2564 + (i) * 0x50)
+#define   CDMBC_CHAMODE_TUNIT_MASK          GENMASK(29, 28)
+#define   CDMBC_CHAMODE_ENDIAN_MASK         GENMASK(17, 16)
+#define   CDMBC_CHAMODE_AUPDT_MASK          GENMASK(5, 4)
+#define   CDMBC_CHAMODE_TYPE_RB             BIT(2)
+#define CDMBC_CHSRCSTRTADRSD(i)           (0x2568 + (i) * 0x50)
+#define CDMBC_CHSRCSTRTADRSU(i)           (0x256c + (i) * 0x50)
+#define CDMBC_CHDSTSTRTADRSD(i)           (0x2570 + (i) * 0x50)
+#define CDMBC_CHDSTSTRTADRSU(i)           (0x2574 + (i) * 0x50)
+#define   CDMBC_CHDSTSTRTADRS_TID_MASK      GENMASK(31, 28)
+#define   CDMBC_CHDSTSTRTADRS_ID1_EN_MASK   BIT(15)
+#define   CDMBC_CHDSTSTRTADRS_KEY_ID1_MASK  GENMASK(12, 8)
+#define   CDMBC_CHDSTSTRTADRS_KEY_ID0_MASK  GENMASK(4, 0)
+#define CDMBC_CHSIZE(i)                   (0x2578 + (i) * 0x50)
+#define CDMBC_CHIRADRSD(i)                (0x2580 + (i) * 0x50)
+#define CDMBC_CHIRADRSU(i)                (0x2584 + (i) * 0x50)
+#define CDMBC_CHDST1STUSIZE(i)            (0x258C + (i) * 0x50)
+
+/* MBC DMA
+ * i: channel number
+ *    5- 7: Replay0,1,2
+ *    8-17: Even: CIP-Read
+ *          Odd : CIP-Write
+ *   22-24: Replay3-5
+ */
+static inline int HSC_IT_INT(int i)
+{
+	if (i > 21)
+		return i - 9;
+
+	return i - 5;
+}
+
+#define CDMBC_ITCTRL(i)              (0x3000 + HSC_IT_INT(i) * 0x20)
+#define CDMBC_ITSTEPS(i)             (0x3018 + HSC_IT_INT(i) * 0x20)
+
+/* MBC Ring buffer
+ * i: channel number
+ *    0   : Section (RB0)
+ *    1- 3: Record0,1,2 (RB1-3)
+ *    5- 7: Replay0,1,2 (RB4-6)
+ *    8-17: Even: CIP-Read
+ *          Odd : CIP-Write (RB7-16)
+ *   19-21: Record3-4 (RB17-19)
+ *   22-24: Replay3-4 (RB20-22)
+ */
+static inline int HSC_INT(int i)
+{
+	if (i > 18)
+		return i - 2;
+	if (i > 4)
+		return i - 1;
+
+	return i;
+}
+
+#define CDMBC_RBBGNADRS(i)           (0x3200 + HSC_INT(i) * 0x40)
+#define CDMBC_RBBGNADRSD(i)          (0x3200 + HSC_INT(i) * 0x40)
+#define CDMBC_RBBGNADRSU(i)          (0x3204 + HSC_INT(i) * 0x40)
+#define CDMBC_RBENDADRS(i)           (0x3208 + HSC_INT(i) * 0x40)
+#define CDMBC_RBENDADRSD(i)          (0x3208 + HSC_INT(i) * 0x40)
+#define CDMBC_RBENDADRSU(i)          (0x320C + HSC_INT(i) * 0x40)
+#define CDMBC_RBIR(i)                (0x3214 + HSC_INT(i) * 0x40)
+#define CDMBC_RBIE(i)                (0x3218 + HSC_INT(i) * 0x40)
+#define CDMBC_RBID(i)                (0x321c + HSC_INT(i) * 0x40)
+#define CDMBC_RBRDPTR(i)             (0x3220 + HSC_INT(i) * 0x40)
+#define CDMBC_RBRDPTRD(i)            (0x3220 + HSC_INT(i) * 0x40)
+#define CDMBC_RBRDPTRU(i)            (0x3224 + HSC_INT(i) * 0x40)
+#define CDMBC_RBWRPTR(i)             (0x3228 + HSC_INT(i) * 0x40)
+#define CDMBC_RBWRPTRD(i)            (0x3228 + HSC_INT(i) * 0x40)
+#define CDMBC_RBWRPTRU(i)            (0x322C + HSC_INT(i) * 0x40)
+#define CDMBC_RBERRCNFG(i)           (0x3238 + HSC_INT(i) * 0x40)
+
+/* MBC Rate */
+#define CDMBC_RCNMSKCYC(i)           (MBC6_TOP_ADDR + 0x000 + (i) * 0x04)
+
+/* MBC Address Transfer */
+#define CDMBC_CHPSIZE(i)             (0x3c00 + ((i) - 1) * 0x48)
+#define CDMBC_CHATCTRL(i)            (0x3c04 + ((i) - 1) * 0x48)
+#define CDMBC_CHBTPAGE(i, j)         (0x3c08 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHBTPAGED(i, j)        (0x3c08 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHBTPAGEU(i, j)        (0x3c0C + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHATPAGE(i, j)         (0x3c10 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHATPAGED(i, j)        (0x3c10 + ((i) - 1) * 0x48 + (j) * 0x10)
+#define CDMBC_CHATPAGEU(i, j)        (0x3c14 + ((i) - 1) * 0x48 + (j) * 0x10)
+
+/* CSS */
+#define CSS_PTSOCONFIG                   0x1c00
+#define CSS_PTSISIGNALPOL                0x1c04
+#define CSS_SIGNALPOLCH(i)               (0x1c08 + (i) * 0x4)
+#define CSS_OUTPUTENABLE                 0x1c10
+#define CSS_OUTPUTCTRL(i)                (0x1c14 + (i) * 0x4)
+#define CSS_STSOCONFIG                   0x1c2c
+#define CSS_STSOSIGNALPOL                0x1c30
+#define CSS_DMDSIGNALPOL                 0x1c34
+#define CSS_PTSOSIGNALPOL                0x1c38
+#define CSS_PF0CONFIG                    0x1c3c
+#define CSS_PF1CONFIG                    0x1c40
+#define CSS_PFINTENABLE                  0x1c44
+#define CSS_PFINTSTATUS                  0x1c48
+#define CSS_AVOUTPUTCTRL(i)              (0x1c4c + (i) * 0x4)
+#define CSS_DPCTRL(i)                    (0x1c54 + (i) * 0x4)
+#define   CSS_DPCTRL_DPSEL_MASK            GENMASK(22, 0)
+#define   CSS_DPCTRL_DPSEL_PLAY5           BIT(15)
+#define   CSS_DPCTRL_DPSEL_PLAY4           BIT(14)
+#define   CSS_DPCTRL_DPSEL_PLAY3           BIT(13)
+#define   CSS_DPCTRL_DPSEL_PLAY2           BIT(12)
+#define   CSS_DPCTRL_DPSEL_PLAY1           BIT(11)
+#define   CSS_DPCTRL_DPSEL_PLAY0           BIT(10)
+#define   CSS_DPCTRL_DPSEL_TSI4            BIT(4)
+#define   CSS_DPCTRL_DPSEL_TSI3            BIT(3)
+#define   CSS_DPCTRL_DPSEL_TSI2            BIT(2)
+#define   CSS_DPCTRL_DPSEL_TSI1            BIT(1)
+#define   CSS_DPCTRL_DPSEL_TSI0            BIT(0)
+
+/* TSI */
+#define TSI_SYNCCNTROL(i)                (0x7100 + (i) * 0x70)
+#define   TSI_SYNCCNTROL_FRAME_MASK        GENMASK(18, 16)
+#define   TSI_SYNCCNTROL_FRAME_EXTSYNC1    (0x0 << 16)
+#define   TSI_SYNCCNTROL_FRAME_EXTSYNC2    (0x1 << 16)
+#define TSI_CONFIG(i)                    (0x7104 + (i) * 0x70)
+#define   TSI_CONFIG_ATSMD_MASK            GENMASK(22, 21)
+#define   TSI_CONFIG_ATSMD_PCRPLL0         (0x0 << 21)
+#define   TSI_CONFIG_ATSMD_PCRPLL1         (0x1 << 21)
+#define   TSI_CONFIG_ATSMD_DPLL            (0x3 << 21)
+#define   TSI_CONFIG_ATSADD_ON             BIT(20)
+#define   TSI_CONFIG_STCMD_MASK            GENMASK(7, 6)
+#define   TSI_CONFIG_STCMD_PCRPLL0         (0x0 << 6)
+#define   TSI_CONFIG_STCMD_PCRPLL1         (0x1 << 6)
+#define   TSI_CONFIG_STCMD_DPLL            (0x3 << 6)
+#define   TSI_CONFIG_CHEN_START            BIT(0)
+#define TSI_RATEUPLMT(i)                 (0x7108 + (i) * 0x70)
+#define TSI_RATELOWLMT(i)                (0x710c + (i) * 0x70)
+#define TSI_CNTINTR(i)                   (0x7110 + (i) * 0x70)
+#define TSI_INTREN(i)                    (0x7114 + (i) * 0x70)
+#define   TSI_INTR_NTP                     BIT(13)
+#define   TSI_INTR_NTPCNT                  BIT(12)
+#define   TSI_INTR_PKTEND                  BIT(11)
+#define   TSI_INTR_PCR                     BIT(9)
+#define   TSI_INTR_LOAD                    BIT(8)
+#define   TSI_INTR_SERR                    BIT(7)
+#define   TSI_INTR_SOF                     BIT(6)
+#define   TSI_INTR_TOF                     BIT(5)
+#define   TSI_INTR_UL                      BIT(4)
+#define   TSI_INTR_LL                      BIT(3)
+#define   TSI_INTR_CNT                     BIT(2)
+#define   TSI_INTR_LOST                    BIT(1)
+#define   TSI_INTR_LOCK                    BIT(0)
+#define TSI_SYNCSTATUS(i)                (0x7118 + (i) * 0x70)
+#define   TSI_STAT_PKTST_ERR               BIT(21)
+#define   TSI_STAT_LARGE_ERR               BIT(20)
+#define   TSI_STAT_SMALL_ERR               BIT(19)
+#define   TSI_STAT_LOCK                    BIT(18)
+#define   TSI_STAT_SYNC                    BIT(17)
+#define   TSI_STAT_SEARCH                  BIT(16)
+#define TSI_PCRPID(i)                    (0x711c + (i) * 0x70)
+#define TSI_PCRCTRL(i)                   (0x7120 + (i) * 0x70)
+#define TSI_STCBASE(i)                   (0x7124 + (i) * 0x70)
+#define TSI_STCEXT(i)                    (0x7128 + (i) * 0x70)
+#define TSI_CURSTC1(i)                   (0x712c + (i) * 0x70)
+#define TSI_CURSTCBASE(i)                (0x712c + (i) * 0x70)
+#define TSI_CURSTC2(i)                   (0x7130 + (i) * 0x70)
+#define TSI_CURSTCEXT(i)                 (0x7130 + (i) * 0x70)
+#define TSI_STC2BASE(i)                  (0x7134 + (i) * 0x70)
+#define TSI_STC2EXT(i)                   (0x7138 + (i) * 0x70)
+#define TSI_PCRBASE(i)                   (0x713c + (i) * 0x70)
+#define TSI_PCREXT(i)                    (0x7140 + (i) * 0x70)
+#define TSI_TIMESTAMP(i)                 (0x7144 + (i) * 0x70)
+#define TSI_CNTCTRL0(i)                  (0x7148 + (i) * 0x70)
+#define TSI_CNTCTRL1(i)                  (0x714c + (i) * 0x70)
+#define TSI_DEBUG(i)                     (0x7150 + (i) * 0x70)
+
+#define TSI_STCCMPCTRL                   0x7000
+#define VCXOSTCBASE(i)                   (0x7010 + (i) * 0x18)
+#define VCXOSTCEXT(i)                    (0x7014 + (i) * 0x18)
+#define VCXOCURSTC1(i)                   (0x7018 + (i) * 0x18)
+#define VCXOCURSTC2(i)                   (0x701c + (i) * 0x18)
+#define VCXOSTC2BASE(i)                  (0x7020 + (i) * 0x18)
+#define VCXOSTC2EXT(i)                   (0x7024 + (i) * 0x18)
+
+/* UCODE DL */
+#define UCODE_REVISION_AM                0x10fd0
+#define CIP_UCODEADDR_AM1                0x10fd4
+#define CIP_UCODEADDR_AM0                0x10fd8
+#define CORRECTATS_CTRL                  0x10fdc
+#define UCODE_REVISION                   0x10fe0
+#define AM_UCODE_IGPGCTRL                0x10fe4
+#define REPDPLLCTRLEN                    0x10fe8
+#define UCODE_DLADDR1                    0x10fec
+#define UCODE_DLADDR0                    0x10ff0
+#define UCODE_ERRLOGCTRL                 0x10ff4
+
+#endif /* DVB_UNIPHIER_HSC_REG_H__ */
diff --git a/drivers/media/platform/uniphier/hsc.h b/drivers/media/platform/uniphier/hsc.h
new file mode 100644
index 000000000000..ad57fea58675
--- /dev/null
+++ b/drivers/media/platform/uniphier/hsc.h
@@ -0,0 +1,480 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Socionext UniPhier DVB driver for High-speed Stream Controller (HSC).
+ *
+ * Copyright (c) 2018 Socionext Inc.
+ */
+
+#ifndef DVB_UNIPHIER_HSC_H__
+#define DVB_UNIPHIER_HSC_H__
+
+#include <linux/gpio/consumer.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+#include <media/dmxdev.h>
+#include <media/dvbdev.h>
+#include <media/dvb_demux.h>
+#include <media/dvb_frontend.h>
+
+enum HSC_CORE {
+	HSC_CORE_0,
+	HSC_CORE_1,
+	HSC_CORE_2,
+};
+
+enum HSC_UCODE {
+	HSC_UCODE_SPU_0,
+	HSC_UCODE_SPU_1,
+	HSC_UCODE_ACE,
+};
+
+enum HSC_INTR_IOB {
+	HSC_INTR_IOB_0,
+	HSC_INTR_IOB_0_1,
+	HSC_INTR_IOB_0_2,
+	HSC_INTR_IOB_1,
+	HSC_INTR_IOB_1_1,
+	HSC_INTR_IOB_2,
+	HSC_INTR_IOB_3,
+	HSC_INTR_IOB_4,
+	HSC_INTR_IOB_5,
+	HSC_INTR_IOB_5_1,
+	HSC_INTR_IOB_5_2,
+	HSC_INTR_IOB_6,
+	HSC_INTR_IOB_6_1,
+	HSC_INTR_IOB_7,
+	HSC_INTR_IOB_8,
+	HSC_INTR_IOB_9,
+
+	HSC_INTR_IOB_NUM,
+};
+
+enum HSC_DPLL {
+	HSC_DPLL0,
+	HSC_DPLL1,
+	HSC_DPLL2,
+	HSC_DPLL3,
+
+	HSC_DPLL_NUM,
+};
+
+enum HSC_DPLL_SRC {
+	HSC_DPLL_SRC_NONE = -1,
+	HSC_DPLL_SRC_TSI0 = 0x00,
+	HSC_DPLL_SRC_TSI1,
+	HSC_DPLL_SRC_TSI2,
+	HSC_DPLL_SRC_TSI3,
+	HSC_DPLL_SRC_TSI4,
+	HSC_DPLL_SRC_TSI5,
+	HSC_DPLL_SRC_TSI6,
+	HSC_DPLL_SRC_TSI7,
+	HSC_DPLL_SRC_TSI8,
+	HSC_DPLL_SRC_TSI9,
+	HSC_DPLL_SRC_REP0 = 0x0a,
+	HSC_DPLL_SRC_REP1,
+	HSC_DPLL_SRC_REP2,
+	HSC_DPLL_SRC_REP3,
+	HSC_DPLL_SRC_REP4,
+	HSC_DPLL_SRC_REP5,
+
+	HSC_DPLL_SRC_NUM,
+};
+
+/* Port to send to CSS */
+enum HSC_CSS_IN {
+	HSC_CSS_IN_1394_0 = 0x00,
+	HSC_CSS_IN_1394_1,
+	HSC_CSS_IN_1394_2,
+	HSC_CSS_IN_1394_3,
+	HSC_CSS_IN_DMD0 = 0x04,
+	HSC_CSS_IN_DMD1,
+	HSC_CSS_IN_SRLTS0 = 0x06,
+	HSC_CSS_IN_SRLTS1,
+	HSC_CSS_IN_SRLTS2,
+	HSC_CSS_IN_SRLTS3,
+	HSC_CSS_IN_SRLTS4,
+	HSC_CSS_IN_SRLTS5,
+	HSC_CSS_IN_SRLTS6,
+	HSC_CSS_IN_SRLTS7,
+	HSC_CSS_IN_PARTS0 = 0x10,
+	HSC_CSS_IN_PARTS1,
+	HSC_CSS_IN_PARTS2,
+	HSC_CSS_IN_PARTS3,
+	HSC_CSS_IN_TSO0 = 0x18,
+	HSC_CSS_IN_TSO1,
+	HSC_CSS_IN_TSO2,
+	HSC_CSS_IN_TSO3,
+	HSC_CSS_IN_ENCORDER0_IN = 0x1c,
+	HSC_CSS_IN_ENCORDER1_IN,
+
+	HSC_CSS_IN_NUM,
+};
+
+/* Port to receive from CSS */
+enum HSC_CSS_OUT {
+	HSC_CSS_OUT_SRLTS0 = 0x00,
+	HSC_CSS_OUT_SRLTS1,
+	HSC_CSS_OUT_SRLTS2,
+	HSC_CSS_OUT_SRLTS3,
+	HSC_CSS_OUT_TSI0 = 0x04,
+	HSC_CSS_OUT_TSI1,
+	HSC_CSS_OUT_TSI2,
+	HSC_CSS_OUT_TSI3,
+	HSC_CSS_OUT_TSI4,
+	HSC_CSS_OUT_TSI5,
+	HSC_CSS_OUT_TSI6,
+	HSC_CSS_OUT_TSI7,
+	HSC_CSS_OUT_TSI8,
+	HSC_CSS_OUT_TSI9,
+	HSC_CSS_OUT_PARTS0 = 0x10,
+	HSC_CSS_OUT_PARTS1,
+	HSC_CSS_OUT_PKTFF0 = 0x14,
+	HSC_CSS_OUT_PKTFF1,
+};
+
+/* TS input interface */
+enum HSC_TS_IN {
+	HSC_TSI0,
+	HSC_TSI1,
+	HSC_TSI2,
+	HSC_TSI3,
+	HSC_TSI4,
+	HSC_TSI5,
+	HSC_TSI6,
+	HSC_TSI7,
+	HSC_TSI8,
+	HSC_TSI9,
+
+	HSC_TS_IN_NUM,
+};
+
+/* TS output interface */
+enum HSC_TS_OUT {
+	HSC_TS_OUT0,
+	HSC_TS_OUT1,
+	HSC_TS_OUT2,
+	HSC_TS_OUT3,
+	HSC_TS_OUT4,
+	HSC_TS_OUT5,
+	HSC_TS_OUT6,
+	HSC_TS_OUT7,
+	HSC_TS_OUT8,
+	HSC_TS_OUT9,
+
+	HSC_TS_OUT_NUM,
+};
+
+/* DMA to read from memory (Replay DMA) */
+enum HSC_DMA_IN {
+	HSC_DMA_IN0,
+	HSC_DMA_IN1,
+	HSC_DMA_IN2,
+	HSC_DMA_IN3,
+	HSC_DMA_IN4,
+	HSC_DMA_IN5,
+	HSC_DMA_IN6,
+	HSC_DMA_IN7,
+	HSC_DMA_IN8,
+	HSC_DMA_IN9,
+
+	HSC_DMA_IN_NUM,
+};
+
+/* DMA to write to memory (Record DMA) */
+enum HSC_DMA_OUT {
+	HSC_DMA_OUT0,
+	HSC_DMA_OUT1,
+	HSC_DMA_OUT2,
+	HSC_DMA_OUT3,
+	HSC_DMA_OUT4,
+	HSC_DMA_OUT5,
+	HSC_DMA_OUT6,
+	HSC_DMA_OUT7,
+	HSC_DMA_OUT8,
+	HSC_DMA_OUT9,
+
+	HSC_DMA_OUT_NUM,
+};
+
+enum HSC_TSIF_FMT {
+	HSC_TSIF_MPEG2_TS,
+	HSC_TSIF_MPEG2_TS_ATS,
+};
+
+#define HSC_STREAM_IF_NUM    2
+
+#define HSC_DMAIF_TS_BUFSIZE    (192 * 1024 * 5)
+
+#define HSC_MBC_DMCH_REC0       1
+#define HSC_MBC_DMCH_REC1       2
+#define HSC_MBC_DMCH_REC2       3
+#define HSC_MBC_DMCH_REP0       5
+#define HSC_MBC_DMCH_REP1       6
+#define HSC_MBC_DMCH_REP2       7
+#define HSC_MBC_DMCH_CIP0_R     8
+#define HSC_MBC_DMCH_CIP0_W     9
+#define HSC_MBC_DMCH_CIP1_R    10
+#define HSC_MBC_DMCH_CIP1_W    11
+#define HSC_MBC_DMCH_CIP2_R    12
+#define HSC_MBC_DMCH_CIP2_W    13
+#define HSC_MBC_DMCH_CIP3_R    14
+#define HSC_MBC_DMCH_CIP3_W    15
+#define HSC_MBC_DMCH_CIP4_R    16
+#define HSC_MBC_DMCH_CIP4_W    17
+#define HSC_MBC_DMCH_REC3      19
+#define HSC_MBC_DMCH_REC4      20
+#define HSC_MBC_DMCH_REC5      21
+#define HSC_MBC_DMCH_REP3      22
+#define HSC_MBC_DMCH_REP4      23
+#define HSC_MBC_DMCH_REP5      24
+
+struct hsc_ucode_buf {
+	void *buf_code;
+	dma_addr_t phys_code;
+	size_t size_code;
+	void *buf_data;
+	dma_addr_t phys_data;
+	size_t size_data;
+};
+
+struct hsc_spec_ucode {
+	const char *name_code;
+	const char *name_data;
+};
+
+struct hsc_spec_init_ram {
+	u32 addr;
+	size_t size;
+	u32 pattern;
+};
+
+struct hsc_css_pol {
+	int valid;
+	u32 reg;
+	int sft_sync;
+	int sft_val;
+	int sft_clk;
+};
+
+struct hsc_css_sel {
+	int valid;
+	u32 reg;
+	u32 mask;
+};
+
+struct hsc_spec_css_in {
+	struct hsc_css_pol pol;
+};
+
+struct hsc_spec_css_out {
+	struct hsc_css_pol pol;
+	struct hsc_css_sel sel;
+};
+
+struct hsc_cmn_intr {
+	int valid;
+	u32 reg;
+	int sft_intr;
+};
+
+struct hsc_spec_ts {
+	struct hsc_cmn_intr intr;
+};
+
+struct hsc_dma_en {
+	int valid;
+	u32 reg;
+	int sft_toggle;
+};
+
+struct hsc_spec_dma {
+	int dma_ch;
+	struct hsc_dma_en en;
+	struct hsc_cmn_intr intr;
+};
+
+struct hsc_spec {
+	const struct hsc_spec_ucode ucode_spu;
+	const struct hsc_spec_ucode ucode_ace;
+	const struct hsc_spec_init_ram *init_rams;
+	size_t num_init_rams;
+	const struct hsc_spec_css_in *css_in;
+	size_t num_css_in;
+	const struct hsc_spec_css_out *css_out;
+	size_t num_css_out;
+	const struct hsc_spec_ts *ts_in;
+	size_t num_ts_in;
+	const struct hsc_spec_dma *dma_in;
+	size_t num_dma_in;
+	const struct hsc_spec_dma *dma_out;
+	size_t num_dma_out;
+};
+
+struct hsc_tsif {
+	struct hsc_chip *chip;
+
+	struct dvb_adapter adapter;
+	struct dvb_demux demux;
+	struct dmxdev dmxdev;
+	struct dvb_frontend *fe;
+	int valid_adapter;
+	int valid_demux;
+	int valid_dmxdev;
+	int valid_fe;
+
+	enum HSC_CSS_IN css_in;
+	enum HSC_CSS_OUT css_out;
+	enum HSC_TS_IN tsi;
+	enum HSC_DPLL dpll;
+	enum HSC_DPLL_SRC dpll_src;
+	struct hsc_dmaif *dmaif;
+
+	int running;
+	struct delayed_work recover_work;
+	unsigned long recover_delay;
+};
+
+struct hsc_dma_in {
+	struct hsc_chip *chip;
+
+	enum HSC_DMA_IN id;
+	const struct hsc_spec_dma *spec;
+	struct hsc_dma_buf *buf;
+};
+
+struct hsc_dma_out {
+	struct hsc_chip *chip;
+
+	enum HSC_DMA_OUT id;
+	const struct hsc_spec_dma *spec;
+	struct hsc_dma_buf *buf;
+};
+
+struct hsc_dma_buf {
+	void *virt;
+	dma_addr_t phys;
+	u64 size;
+	u64 size_chk;
+	u64 rd_offs;
+	u64 wr_offs;
+	u64 chk_offs;
+};
+
+struct hsc_dmaif {
+	struct hsc_chip *chip;
+
+	struct hsc_dma_buf buf_out;
+	struct hsc_dma_out dma_out;
+
+	struct hsc_tsif *tsif;
+
+	/* guard read/write pointer of DMA buffer from interrupt handler */
+	spinlock_t lock;
+	int running;
+	struct work_struct feed_work;
+};
+
+struct hsc_chip {
+	const struct hsc_spec *spec;
+	short *adapter_nums;
+
+	struct platform_device *pdev;
+	struct regmap *regmap;
+	struct clk *clk_stdmac;
+	struct clk *clk_hsc;
+	struct reset_control *rst_stdmac;
+	struct reset_control *rst_hsc;
+
+	struct hsc_dmaif dmaif[HSC_STREAM_IF_NUM];
+	struct hsc_tsif tsif[HSC_STREAM_IF_NUM];
+
+	struct hsc_ucode_buf ucode_spu;
+	struct hsc_ucode_buf ucode_am;
+};
+
+struct hsc_conf {
+	enum HSC_CSS_IN css_in;
+	enum HSC_CSS_OUT css_out;
+	enum HSC_DPLL dpll;
+	enum HSC_DMA_OUT dma_out;
+};
+
+static inline u32 field_prep(u32 mask, u32 v)
+{
+	int sft = ffs(mask) - 1;
+
+	return (v << sft) & mask;
+}
+
+static inline u32 field_get(u32 mask, u32 v)
+{
+	int sft = ffs(mask) - 1;
+
+	return (v & mask) >> sft;
+}
+
+/* CSS */
+enum HSC_TS_IN hsc_css_out_to_ts_in(enum HSC_CSS_OUT out);
+enum HSC_DPLL_SRC hsc_css_out_to_dpll_src(enum HSC_CSS_OUT out);
+
+int hsc_dpll_get_src(struct hsc_chip *chip, enum HSC_DPLL dpll,
+		     enum HSC_DPLL_SRC *src);
+int hsc_dpll_set_src(struct hsc_chip *chip, enum HSC_DPLL dpll,
+		     enum HSC_DPLL_SRC src);
+int hsc_css_in_get_polarity(struct hsc_chip *chip, enum HSC_CSS_IN in,
+			    bool *sync_bit, bool *val_bit, bool *clk_fall);
+int hsc_css_in_set_polarity(struct hsc_chip *chip, enum HSC_CSS_IN in,
+			    bool sync_bit, bool val_bit, bool clk_fall);
+int hsc_css_out_get_polarity(struct hsc_chip *chip, enum HSC_CSS_OUT out,
+			     bool *sync_bit, bool *val_bit, bool *clk_fall);
+int hsc_css_out_set_polarity(struct hsc_chip *chip, enum HSC_CSS_OUT out,
+			     bool sync_bit, bool val_bit, bool clk_fall);
+int hsc_css_out_get_src(struct hsc_chip *chip, enum HSC_CSS_IN *in,
+			enum HSC_CSS_OUT out, bool *en);
+int hsc_css_out_set_src(struct hsc_chip *chip, enum HSC_CSS_IN in,
+			enum HSC_CSS_OUT out, bool en);
+
+/* TSI */
+const struct hsc_spec_tsi *hsc_ts_in_get_spec(struct hsc_chip *chip,
+					      enum HSC_TS_IN in);
+int hsc_ts_in_set_enable(struct hsc_chip *chip, enum HSC_TS_IN in, bool en);
+int hsc_ts_in_set_dmaparam(struct hsc_chip *chip, enum HSC_TS_IN in,
+			   enum HSC_TSIF_FMT ifmt);
+
+/* DMA */
+u64 hsc_rb_cnt(struct hsc_dma_buf *buf);
+u64 hsc_rb_cnt_to_end(struct hsc_dma_buf *buf);
+u64 hsc_rb_space(struct hsc_dma_buf *buf);
+u64 hsc_rb_space_to_end(struct hsc_dma_buf *buf);
+int hsc_dma_in_init(struct hsc_dma_in *dma_in, struct hsc_chip *chip,
+		    enum HSC_DMA_IN in, struct hsc_dma_buf *buf);
+void hsc_dma_in_start(struct hsc_dma_in *dma_in, bool en);
+void hsc_dma_in_sync(struct hsc_dma_in *dma_in);
+int hsc_dma_in_get_intr(struct hsc_dma_in *dma_in, u32 *stat);
+void hsc_dma_in_clear_intr(struct hsc_dma_in *dma_in, u32 clear);
+int hsc_dma_out_init(struct hsc_dma_out *dma_out, struct hsc_chip *chip,
+		     enum HSC_DMA_OUT out, struct hsc_dma_buf *buf);
+void hsc_dma_out_set_src_ts_in(struct hsc_dma_out *dma_out,
+			       enum HSC_TS_IN ts_in);
+void hsc_dma_out_start(struct hsc_dma_out *dma_out, bool en);
+void hsc_dma_out_sync(struct hsc_dma_out *dma_out);
+int hsc_dma_out_get_intr(struct hsc_dma_out *dma_out, u32 *stat);
+void hsc_dma_out_clear_intr(struct hsc_dma_out *dma_out, u32 clear);
+
+/* UCODE DL */
+int hsc_ucode_load_all(struct hsc_chip *chip);
+int hsc_ucode_unload_all(struct hsc_chip *chip);
+
+/* For Adapter */
+int hsc_register_dvb(struct hsc_tsif *tsif);
+void hsc_unregister_dvb(struct hsc_tsif *tsif);
+int hsc_tsif_init(struct hsc_tsif *tsif, const struct hsc_conf *conf);
+void hsc_tsif_release(struct hsc_tsif *tsif);
+int hsc_dmaif_init(struct hsc_dmaif *dmaif, const struct hsc_conf *conf);
+void hsc_dmaif_release(struct hsc_dmaif *dmaif);
+extern const struct hsc_spec uniphier_hsc_ld11_spec;
+extern const struct hsc_spec uniphier_hsc_ld20_spec;
+
+#endif /* DVB_UNIPHIER_HSC_H__ */
-- 
2.17.0
