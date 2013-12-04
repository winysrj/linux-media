Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44098 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3LDA4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:35 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 7F4C1366A5
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:40 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 16/25] v4l: omap4iss: Convert hexadecimal constants to lower case
Date: Wed,  4 Dec 2013 01:56:16 +0100
Message-Id: <1386118585-12449-17-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Linux kernel recommends lower case for hexadecimal constants.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_csi2.c   |   4 +-
 drivers/staging/media/omap4iss/iss_csiphy.c |   4 +-
 drivers/staging/media/omap4iss/iss_regs.h   | 458 ++++++++++++++--------------
 3 files changed, 233 insertions(+), 233 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index f8d6472..077545f 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -273,7 +273,7 @@ static void csi2_set_outaddr(struct iss_csi2_device *csi2, u32 addr)
  */
 static inline int is_usr_def_mapping(u32 format_id)
 {
-	return (format_id & 0xF0) == 0x40 ? 1 : 0;
+	return (format_id & 0xf0) == 0x40 ? 1 : 0;
 }
 
 /*
@@ -572,7 +572,7 @@ static int csi2_configure(struct iss_csi2_device *csi2)
 	timing->force_rx_mode = 1;
 	timing->stop_state_16x = 1;
 	timing->stop_state_4x = 1;
-	timing->stop_state_counter = 0x1FF;
+	timing->stop_state_counter = 0x1ff;
 
 	/*
 	 * The CSI2 receiver can't do any format conversion except DPCM
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index 902391a..7c3d55d 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -103,7 +103,7 @@ static void csiphy_dphy_config(struct iss_csiphy *phy)
 	reg = phy->dphy.tclk_term << REGISTER1_TCLK_TERM_SHIFT;
 	reg |= phy->dphy.tclk_miss << REGISTER1_CTRLCLK_DIV_FACTOR_SHIFT;
 	reg |= phy->dphy.tclk_settle << REGISTER1_TCLK_SETTLE_SHIFT;
-	reg |= 0xB8 << REGISTER1_DPHY_HS_SYNC_PATTERN_SHIFT;
+	reg |= 0xb8 << REGISTER1_DPHY_HS_SYNC_PATTERN_SHIFT;
 
 	iss_reg_write(phy->iss, phy->phy_regs, REGISTER1, reg);
 }
@@ -150,7 +150,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
 		/* NOTE: Leave CSIPHY1 config to 0x0: D-PHY mode */
 		/* Enable all lanes for now */
 		cam_rx_ctrl |=
-			0x1F << OMAP4_CAMERARX_CSI21_LANEENABLE_SHIFT;
+			0x1f << OMAP4_CAMERARX_CSI21_LANEENABLE_SHIFT;
 		/* Enable CTRLCLK */
 		cam_rx_ctrl |= OMAP4_CAMERARX_CSI21_CTRLCLKEN_MASK;
 	}
diff --git a/drivers/staging/media/omap4iss/iss_regs.h b/drivers/staging/media/omap4iss/iss_regs.h
index 5995e62..efd0291 100644
--- a/drivers/staging/media/omap4iss/iss_regs.h
+++ b/drivers/staging/media/omap4iss/iss_regs.h
@@ -65,7 +65,7 @@
 #define ISS_CLKSTAT_ISP					(1 << 1)
 #define ISS_CLKSTAT_SIMCOP				(1 << 0)
 
-#define ISS_PM_STATUS					0x8C
+#define ISS_PM_STATUS					0x8c
 #define ISS_PM_STATUS_CBUFF_PM_MASK			(3 << 12)
 #define ISS_PM_STATUS_BTE_PM_MASK			(3 << 10)
 #define ISS_PM_STATUS_SIMCOP_PM_MASK			(3 << 8)
@@ -76,20 +76,20 @@
 
 #define REGISTER0					0x0
 #define REGISTER0_HSCLOCKCONFIG				(1 << 24)
-#define REGISTER0_THS_TERM_MASK				(0xFF << 8)
+#define REGISTER0_THS_TERM_MASK				(0xff << 8)
 #define REGISTER0_THS_TERM_SHIFT			8
-#define REGISTER0_THS_SETTLE_MASK			(0xFF << 0)
+#define REGISTER0_THS_SETTLE_MASK			(0xff << 0)
 #define REGISTER0_THS_SETTLE_SHIFT			0
 
 #define REGISTER1					0x4
 #define REGISTER1_RESET_DONE_CTRLCLK			(1 << 29)
 #define REGISTER1_CLOCK_MISS_DETECTOR_STATUS		(1 << 25)
-#define REGISTER1_TCLK_TERM_MASK			(0x3F << 18)
+#define REGISTER1_TCLK_TERM_MASK			(0x3f << 18)
 #define REGISTER1_TCLK_TERM_SHIFT			18
 #define REGISTER1_DPHY_HS_SYNC_PATTERN_SHIFT		10
 #define REGISTER1_CTRLCLK_DIV_FACTOR_MASK		(0x3 << 8)
 #define REGISTER1_CTRLCLK_DIV_FACTOR_SHIFT		8
-#define REGISTER1_TCLK_SETTLE_MASK			(0xFF << 0)
+#define REGISTER1_TCLK_SETTLE_MASK			(0xff << 0)
 #define REGISTER1_TCLK_SETTLE_SHIFT			0
 
 #define REGISTER2					0x8
@@ -106,7 +106,7 @@
 #define CSI2_SYSSTATUS_RESET_DONE			(1 << 0)
 
 #define CSI2_IRQSTATUS					0x18
-#define CSI2_IRQENABLE					0x1C
+#define CSI2_IRQENABLE					0x1c
 
 /* Shared bits across CSI2_IRQENABLE and IRQSTATUS */
 
@@ -159,7 +159,7 @@
 
 #define CSI2_COMPLEXIO_IRQSTATUS			0x54
 
-#define CSI2_SHORT_PACKET				0x5C
+#define CSI2_SHORT_PACKET				0x5c
 
 #define CSI2_COMPLEXIO_IRQENABLE			0x60
 
@@ -194,18 +194,18 @@
 
 #define CSI2_DBG_P					0x68
 
-#define CSI2_TIMING					0x6C
+#define CSI2_TIMING					0x6c
 #define CSI2_TIMING_FORCE_RX_MODE_IO1			(1 << 15)
 #define CSI2_TIMING_STOP_STATE_X16_IO1			(1 << 14)
 #define CSI2_TIMING_STOP_STATE_X4_IO1			(1 << 13)
-#define CSI2_TIMING_STOP_STATE_COUNTER_IO1_MASK		(0x1FFF << 0)
+#define CSI2_TIMING_STOP_STATE_COUNTER_IO1_MASK		(0x1fff << 0)
 #define CSI2_TIMING_STOP_STATE_COUNTER_IO1_SHIFT	0
 
 #define CSI2_CTX_CTRL1(i)				(0x70 + (0x20 * i))
 #define CSI2_CTX_CTRL1_GENERIC				(1 << 30)
-#define CSI2_CTX_CTRL1_TRANSCODE			(0xF << 24)
-#define CSI2_CTX_CTRL1_FEC_NUMBER_MASK			(0xFF << 16)
-#define CSI2_CTX_CTRL1_COUNT_MASK			(0xFF << 8)
+#define CSI2_CTX_CTRL1_TRANSCODE			(0xf << 24)
+#define CSI2_CTX_CTRL1_FEC_NUMBER_MASK			(0xff << 16)
+#define CSI2_CTX_CTRL1_COUNT_MASK			(0xff << 8)
 #define CSI2_CTX_CTRL1_COUNT_SHIFT			8
 #define CSI2_CTX_CTRL1_EOF_EN				(1 << 7)
 #define CSI2_CTX_CTRL1_EOL_EN				(1 << 6)
@@ -221,14 +221,14 @@
 #define CSI2_CTX_CTRL2_VIRTUAL_ID_MASK			(3 << 11)
 #define CSI2_CTX_CTRL2_VIRTUAL_ID_SHIFT			11
 #define CSI2_CTX_CTRL2_DPCM_PRED			(1 << 10)
-#define CSI2_CTX_CTRL2_FORMAT_MASK			(0x3FF << 0)
+#define CSI2_CTX_CTRL2_FORMAT_MASK			(0x3ff << 0)
 #define CSI2_CTX_CTRL2_FORMAT_SHIFT			0
 
 #define CSI2_CTX_DAT_OFST(i)				(0x78 + (0x20 * i))
-#define CSI2_CTX_DAT_OFST_MASK				(0xFFF << 5)
+#define CSI2_CTX_DAT_OFST_MASK				(0xfff << 5)
 
-#define CSI2_CTX_PING_ADDR(i)				(0x7C + (0x20 * i))
-#define CSI2_CTX_PING_ADDR_MASK				0xFFFFFFE0
+#define CSI2_CTX_PING_ADDR(i)				(0x7c + (0x20 * i))
+#define CSI2_CTX_PING_ADDR_MASK				0xffffffe0
 
 #define CSI2_CTX_PONG_ADDR(i)				(0x80 + (0x20 * i))
 #define CSI2_CTX_PONG_ADDR_MASK				CSI2_CTX_PING_ADDR_MASK
@@ -236,7 +236,7 @@
 #define CSI2_CTX_IRQENABLE(i)				(0x84 + (0x20 * i))
 #define CSI2_CTX_IRQSTATUS(i)				(0x88 + (0x20 * i))
 
-#define CSI2_CTX_CTRL3(i)				(0x8C + (0x20 * i))
+#define CSI2_CTX_CTRL3(i)				(0x8c + (0x20 * i))
 #define CSI2_CTX_CTRL3_ALPHA_SHIFT			5
 #define CSI2_CTX_CTRL3_ALPHA_MASK			\
 		(0x3fff << CSI2_CTX_CTRL3_ALPHA_SHIFT)
@@ -253,7 +253,7 @@
 
 /* ISS BTE */
 #define BTE_CTRL					(0x0030)
-#define BTE_CTRL_BW_LIMITER_MASK			(0x3FF << 22)
+#define BTE_CTRL_BW_LIMITER_MASK			(0x3ff << 22)
 #define BTE_CTRL_BW_LIMITER_SHIFT			22
 
 /* ISS ISP_SYS1 */
@@ -266,7 +266,7 @@
 #define ISP5_SYSCONFIG_SOFTRESET			(1 << 1)
 
 #define ISP5_IRQSTATUS(i)				(0x0028 + (0x10 * (i)))
-#define ISP5_IRQENABLE_SET(i)				(0x002C + (0x10 * (i)))
+#define ISP5_IRQENABLE_SET(i)				(0x002c + (0x10 * (i)))
 #define ISP5_IRQENABLE_CLR(i)				(0x0030 + (0x10 * (i)))
 
 /* Bits shared for ISP5_IRQ* registers */
@@ -296,7 +296,7 @@
 #define ISP5_IRQ_IPIPE_INT_REG				(1 << 4)
 #define ISP5_IRQ_ISIF_INT(i)				(1 << (i))
 
-#define ISP5_CTRL					(0x006C)
+#define ISP5_CTRL					(0x006c)
 #define ISP5_CTRL_MSTANDBY				(1 << 24)
 #define ISP5_CTRL_VD_PULSE_EXT				(1 << 23)
 #define ISP5_CTRL_MSTANDBY_WAIT				(1 << 20)
@@ -327,25 +327,25 @@
 #define ISIF_MODESET_VDPOL				(1 << 2)
 
 #define ISIF_SPH					(0x0018)
-#define ISIF_SPH_MASK					(0x7FFF)
+#define ISIF_SPH_MASK					(0x7fff)
 
-#define ISIF_LNH					(0x001C)
-#define ISIF_LNH_MASK					(0x7FFF)
+#define ISIF_LNH					(0x001c)
+#define ISIF_LNH_MASK					(0x7fff)
 
 #define ISIF_LNV					(0x0028)
-#define ISIF_LNV_MASK					(0x7FFF)
+#define ISIF_LNV_MASK					(0x7fff)
 
 #define ISIF_HSIZE					(0x0034)
 #define ISIF_HSIZE_ADCR					(1 << 12)
-#define ISIF_HSIZE_HSIZE_MASK				(0xFFF)
+#define ISIF_HSIZE_HSIZE_MASK				(0xfff)
 
-#define ISIF_CADU					(0x003C)
-#define ISIF_CADU_MASK					(0x7FF)
+#define ISIF_CADU					(0x003c)
+#define ISIF_CADU_MASK					(0x7ff)
 
 #define ISIF_CADL					(0x0040)
-#define ISIF_CADL_MASK					(0xFFFF)
+#define ISIF_CADL_MASK					(0xffff)
 
-#define ISIF_CCOLP					(0x004C)
+#define ISIF_CCOLP					(0x004c)
 #define ISIF_CCOLP_CP0_F0_R				(0 << 6)
 #define ISIF_CCOLP_CP0_F0_GR				(1 << 6)
 #define ISIF_CCOLP_CP0_F0_B				(3 << 6)
@@ -367,7 +367,7 @@
 #define ISIF_VDINT_MASK					(0x7fff)
 
 #define ISIF_CGAMMAWD					(0x0080)
-#define ISIF_CGAMMAWD_GWDI_MASK				(0xF << 1)
+#define ISIF_CGAMMAWD_GWDI_MASK				(0xf << 1)
 #define ISIF_CGAMMAWD_GWDI(bpp)				((16 - (bpp)) << 1)
 
 #define ISIF_CCDCFG					(0x0088)
@@ -412,7 +412,7 @@
 #define IPIPE_SRC_FMT_RAW2STATS				(2 << 0)
 #define IPIPE_SRC_FMT_YUV2YUV				(3 << 0)
 
-#define IPIPE_SRC_COL					(0x000C)
+#define IPIPE_SRC_COL					(0x000c)
 #define IPIPE_SRC_COL_OO_R				(0 << 6)
 #define IPIPE_SRC_COL_OO_GR				(1 << 6)
 #define IPIPE_SRC_COL_OO_B				(3 << 6)
@@ -431,16 +431,16 @@
 #define IPIPE_SRC_COL_EE_GB				(2 << 0)
 
 #define IPIPE_SRC_VPS					(0x0010)
-#define IPIPE_SRC_VPS_MASK				(0xFFFF)
+#define IPIPE_SRC_VPS_MASK				(0xffff)
 
 #define IPIPE_SRC_VSZ					(0x0014)
-#define IPIPE_SRC_VSZ_MASK				(0x1FFF)
+#define IPIPE_SRC_VSZ_MASK				(0x1fff)
 
 #define IPIPE_SRC_HPS					(0x0018)
-#define IPIPE_SRC_HPS_MASK				(0xFFFF)
+#define IPIPE_SRC_HPS_MASK				(0xffff)
 
-#define IPIPE_SRC_HSZ					(0x001C)
-#define IPIPE_SRC_HSZ_MASK				(0x1FFE)
+#define IPIPE_SRC_HSZ					(0x001c)
+#define IPIPE_SRC_HSZ_MASK				(0x1ffe)
 
 #define IPIPE_SEL_SBU					(0x0020)
 
@@ -449,7 +449,7 @@
 #define IPIPE_GCK_MMR					(0x0028)
 #define IPIPE_GCK_MMR_REG				(1 << 0)
 
-#define IPIPE_GCK_PIX					(0x002C)
+#define IPIPE_GCK_PIX					(0x002c)
 #define IPIPE_GCK_PIX_G3				(1 << 3)
 #define IPIPE_GCK_PIX_G2				(1 << 2)
 #define IPIPE_GCK_PIX_G1				(1 << 1)
@@ -457,277 +457,277 @@
 
 #define IPIPE_DPC_LUT_EN				(0x0034)
 #define IPIPE_DPC_LUT_SEL				(0x0038)
-#define IPIPE_DPC_LUT_ADR				(0x003C)
+#define IPIPE_DPC_LUT_ADR				(0x003c)
 #define IPIPE_DPC_LUT_SIZ				(0x0040)
 
 #define IPIPE_DPC_OTF_EN				(0x0044)
 #define IPIPE_DPC_OTF_TYP				(0x0048)
-#define IPIPE_DPC_OTF_2_D_THR_R				(0x004C)
+#define IPIPE_DPC_OTF_2_D_THR_R				(0x004c)
 #define IPIPE_DPC_OTF_2_D_THR_GR			(0x0050)
 #define IPIPE_DPC_OTF_2_D_THR_GB			(0x0054)
 #define IPIPE_DPC_OTF_2_D_THR_B				(0x0058)
-#define IPIPE_DPC_OTF_2_C_THR_R				(0x005C)
+#define IPIPE_DPC_OTF_2_C_THR_R				(0x005c)
 #define IPIPE_DPC_OTF_2_C_THR_GR			(0x0060)
 #define IPIPE_DPC_OTF_2_C_THR_GB			(0x0064)
 #define IPIPE_DPC_OTF_2_C_THR_B				(0x0068)
-#define IPIPE_DPC_OTF_3_SHF				(0x006C)
+#define IPIPE_DPC_OTF_3_SHF				(0x006c)
 #define IPIPE_DPC_OTF_3_D_THR				(0x0070)
 #define IPIPE_DPC_OTF_3_D_SPL				(0x0074)
 #define IPIPE_DPC_OTF_3_D_MIN				(0x0078)
-#define IPIPE_DPC_OTF_3_D_MAX				(0x007C)
+#define IPIPE_DPC_OTF_3_D_MAX				(0x007c)
 #define IPIPE_DPC_OTF_3_C_THR				(0x0080)
 #define IPIPE_DPC_OTF_3_C_SLP				(0x0084)
 #define IPIPE_DPC_OTF_3_C_MIN				(0x0088)
-#define IPIPE_DPC_OTF_3_C_MAX				(0x008C)
+#define IPIPE_DPC_OTF_3_C_MAX				(0x008c)
 
 #define IPIPE_LSC_VOFT					(0x0090)
 #define IPIPE_LSC_VA2					(0x0094)
 #define IPIPE_LSC_VA1					(0x0098)
-#define IPIPE_LSC_VS					(0x009C)
-#define IPIPE_LSC_HOFT					(0x00A0)
-#define IPIPE_LSC_HA2					(0x00A4)
-#define IPIPE_LSC_HA1					(0x00A8)
-#define IPIPE_LSC_HS					(0x00AC)
-#define IPIPE_LSC_GAN_R					(0x00B0)
-#define IPIPE_LSC_GAN_GR				(0x00B4)
-#define IPIPE_LSC_GAN_GB				(0x00B8)
-#define IPIPE_LSC_GAN_B					(0x00BC)
-#define IPIPE_LSC_OFT_R					(0x00C0)
-#define IPIPE_LSC_OFT_GR				(0x00C4)
-#define IPIPE_LSC_OFT_GB				(0x00C8)
-#define IPIPE_LSC_OFT_B					(0x00CC)
-#define IPIPE_LSC_SHF					(0x00D0)
-#define IPIPE_LSC_MAX					(0x00D4)
-
-#define IPIPE_D2F_1ST_EN				(0x00D8)
-#define IPIPE_D2F_1ST_TYP				(0x00DC)
-#define IPIPE_D2F_1ST_THR_00				(0x00E0)
-#define IPIPE_D2F_1ST_THR_01				(0x00E4)
-#define IPIPE_D2F_1ST_THR_02				(0x00E8)
-#define IPIPE_D2F_1ST_THR_03				(0x00EC)
-#define IPIPE_D2F_1ST_THR_04				(0x00F0)
-#define IPIPE_D2F_1ST_THR_05				(0x00F4)
-#define IPIPE_D2F_1ST_THR_06				(0x00F8)
-#define IPIPE_D2F_1ST_THR_07				(0x00FC)
+#define IPIPE_LSC_VS					(0x009c)
+#define IPIPE_LSC_HOFT					(0x00a0)
+#define IPIPE_LSC_HA2					(0x00a4)
+#define IPIPE_LSC_HA1					(0x00a8)
+#define IPIPE_LSC_HS					(0x00ac)
+#define IPIPE_LSC_GAN_R					(0x00b0)
+#define IPIPE_LSC_GAN_GR				(0x00b4)
+#define IPIPE_LSC_GAN_GB				(0x00b8)
+#define IPIPE_LSC_GAN_B					(0x00bc)
+#define IPIPE_LSC_OFT_R					(0x00c0)
+#define IPIPE_LSC_OFT_GR				(0x00c4)
+#define IPIPE_LSC_OFT_GB				(0x00c8)
+#define IPIPE_LSC_OFT_B					(0x00cc)
+#define IPIPE_LSC_SHF					(0x00d0)
+#define IPIPE_LSC_MAX					(0x00d4)
+
+#define IPIPE_D2F_1ST_EN				(0x00d8)
+#define IPIPE_D2F_1ST_TYP				(0x00dc)
+#define IPIPE_D2F_1ST_THR_00				(0x00e0)
+#define IPIPE_D2F_1ST_THR_01				(0x00e4)
+#define IPIPE_D2F_1ST_THR_02				(0x00e8)
+#define IPIPE_D2F_1ST_THR_03				(0x00ec)
+#define IPIPE_D2F_1ST_THR_04				(0x00f0)
+#define IPIPE_D2F_1ST_THR_05				(0x00f4)
+#define IPIPE_D2F_1ST_THR_06				(0x00f8)
+#define IPIPE_D2F_1ST_THR_07				(0x00fc)
 #define IPIPE_D2F_1ST_STR_00				(0x0100)
 #define IPIPE_D2F_1ST_STR_01				(0x0104)
 #define IPIPE_D2F_1ST_STR_02				(0x0108)
-#define IPIPE_D2F_1ST_STR_03				(0x010C)
+#define IPIPE_D2F_1ST_STR_03				(0x010c)
 #define IPIPE_D2F_1ST_STR_04				(0x0110)
 #define IPIPE_D2F_1ST_STR_05				(0x0114)
 #define IPIPE_D2F_1ST_STR_06				(0x0118)
-#define IPIPE_D2F_1ST_STR_07				(0x011C)
+#define IPIPE_D2F_1ST_STR_07				(0x011c)
 #define IPIPE_D2F_1ST_SPR_00				(0x0120)
 #define IPIPE_D2F_1ST_SPR_01				(0x0124)
 #define IPIPE_D2F_1ST_SPR_02				(0x0128)
-#define IPIPE_D2F_1ST_SPR_03				(0x012C)
+#define IPIPE_D2F_1ST_SPR_03				(0x012c)
 #define IPIPE_D2F_1ST_SPR_04				(0x0130)
 #define IPIPE_D2F_1ST_SPR_05				(0x0134)
 #define IPIPE_D2F_1ST_SPR_06				(0x0138)
-#define IPIPE_D2F_1ST_SPR_07				(0x013C)
+#define IPIPE_D2F_1ST_SPR_07				(0x013c)
 #define IPIPE_D2F_1ST_EDG_MIN				(0x0140)
 #define IPIPE_D2F_1ST_EDG_MAX				(0x0144)
 #define IPIPE_D2F_2ND_EN				(0x0148)
-#define IPIPE_D2F_2ND_TYP				(0x014C)
+#define IPIPE_D2F_2ND_TYP				(0x014c)
 #define IPIPE_D2F_2ND_THR00				(0x0150)
 #define IPIPE_D2F_2ND_THR01				(0x0154)
 #define IPIPE_D2F_2ND_THR02				(0x0158)
-#define IPIPE_D2F_2ND_THR03				(0x015C)
+#define IPIPE_D2F_2ND_THR03				(0x015c)
 #define IPIPE_D2F_2ND_THR04				(0x0160)
 #define IPIPE_D2F_2ND_THR05				(0x0164)
 #define IPIPE_D2F_2ND_THR06				(0x0168)
-#define IPIPE_D2F_2ND_THR07				(0x016C)
+#define IPIPE_D2F_2ND_THR07				(0x016c)
 #define IPIPE_D2F_2ND_STR_00				(0x0170)
 #define IPIPE_D2F_2ND_STR_01				(0x0174)
 #define IPIPE_D2F_2ND_STR_02				(0x0178)
-#define IPIPE_D2F_2ND_STR_03				(0x017C)
+#define IPIPE_D2F_2ND_STR_03				(0x017c)
 #define IPIPE_D2F_2ND_STR_04				(0x0180)
 #define IPIPE_D2F_2ND_STR_05				(0x0184)
 #define IPIPE_D2F_2ND_STR_06				(0x0188)
-#define IPIPE_D2F_2ND_STR_07				(0x018C)
+#define IPIPE_D2F_2ND_STR_07				(0x018c)
 #define IPIPE_D2F_2ND_SPR_00				(0x0190)
 #define IPIPE_D2F_2ND_SPR_01				(0x0194)
 #define IPIPE_D2F_2ND_SPR_02				(0x0198)
-#define IPIPE_D2F_2ND_SPR_03				(0x019C)
-#define IPIPE_D2F_2ND_SPR_04				(0x01A0)
-#define IPIPE_D2F_2ND_SPR_05				(0x01A4)
-#define IPIPE_D2F_2ND_SPR_06				(0x01A8)
-#define IPIPE_D2F_2ND_SPR_07				(0x01AC)
-#define IPIPE_D2F_2ND_EDG_MIN				(0x01B0)
-#define IPIPE_D2F_2ND_EDG_MAX				(0x01B4)
-
-#define IPIPE_GIC_EN					(0x01B8)
-#define IPIPE_GIC_TYP					(0x01BC)
-#define IPIPE_GIC_GAN					(0x01C0)
-#define IPIPE_GIC_NFGAIN				(0x01C4)
-#define IPIPE_GIC_THR					(0x01C8)
-#define IPIPE_GIC_SLP					(0x01CC)
-
-#define IPIPE_WB2_OFT_R					(0x01D0)
-#define IPIPE_WB2_OFT_GR				(0x01D4)
-#define IPIPE_WB2_OFT_GB				(0x01D8)
-#define IPIPE_WB2_OFT_B					(0x01DC)
-
-#define IPIPE_WB2_WGN_R					(0x01E0)
-#define IPIPE_WB2_WGN_GR				(0x01E4)
-#define IPIPE_WB2_WGN_GB				(0x01E8)
-#define IPIPE_WB2_WGN_B					(0x01EC)
-
-#define IPIPE_CFA_MODE					(0x01F0)
-#define IPIPE_CFA_2DIR_HPF_THR				(0x01F4)
-#define IPIPE_CFA_2DIR_HPF_SLP				(0x01F8)
-#define IPIPE_CFA_2DIR_MIX_THR				(0x01FC)
+#define IPIPE_D2F_2ND_SPR_03				(0x019c)
+#define IPIPE_D2F_2ND_SPR_04				(0x01a0)
+#define IPIPE_D2F_2ND_SPR_05				(0x01a4)
+#define IPIPE_D2F_2ND_SPR_06				(0x01a8)
+#define IPIPE_D2F_2ND_SPR_07				(0x01ac)
+#define IPIPE_D2F_2ND_EDG_MIN				(0x01b0)
+#define IPIPE_D2F_2ND_EDG_MAX				(0x01b4)
+
+#define IPIPE_GIC_EN					(0x01b8)
+#define IPIPE_GIC_TYP					(0x01bc)
+#define IPIPE_GIC_GAN					(0x01c0)
+#define IPIPE_GIC_NFGAIN				(0x01c4)
+#define IPIPE_GIC_THR					(0x01c8)
+#define IPIPE_GIC_SLP					(0x01cc)
+
+#define IPIPE_WB2_OFT_R					(0x01d0)
+#define IPIPE_WB2_OFT_GR				(0x01d4)
+#define IPIPE_WB2_OFT_GB				(0x01d8)
+#define IPIPE_WB2_OFT_B					(0x01dc)
+
+#define IPIPE_WB2_WGN_R					(0x01e0)
+#define IPIPE_WB2_WGN_GR				(0x01e4)
+#define IPIPE_WB2_WGN_GB				(0x01e8)
+#define IPIPE_WB2_WGN_B					(0x01ec)
+
+#define IPIPE_CFA_MODE					(0x01f0)
+#define IPIPE_CFA_2DIR_HPF_THR				(0x01f4)
+#define IPIPE_CFA_2DIR_HPF_SLP				(0x01f8)
+#define IPIPE_CFA_2DIR_MIX_THR				(0x01fc)
 #define IPIPE_CFA_2DIR_MIX_SLP				(0x0200)
 #define IPIPE_CFA_2DIR_DIR_TRH				(0x0204)
 #define IPIPE_CFA_2DIR_DIR_SLP				(0x0208)
-#define IPIPE_CFA_2DIR_NDWT				(0x020C)
+#define IPIPE_CFA_2DIR_NDWT				(0x020c)
 #define IPIPE_CFA_MONO_HUE_FRA				(0x0210)
 #define IPIPE_CFA_MONO_EDG_THR				(0x0214)
 #define IPIPE_CFA_MONO_THR_MIN				(0x0218)
 
-#define IPIPE_CFA_MONO_THR_SLP				(0x021C)
+#define IPIPE_CFA_MONO_THR_SLP				(0x021c)
 #define IPIPE_CFA_MONO_SLP_MIN				(0x0220)
 #define IPIPE_CFA_MONO_SLP_SLP				(0x0224)
 #define IPIPE_CFA_MONO_LPWT				(0x0228)
 
-#define IPIPE_RGB1_MUL_RR				(0x022C)
+#define IPIPE_RGB1_MUL_RR				(0x022c)
 #define IPIPE_RGB1_MUL_GR				(0x0230)
 #define IPIPE_RGB1_MUL_BR				(0x0234)
 #define IPIPE_RGB1_MUL_RG				(0x0238)
-#define IPIPE_RGB1_MUL_GG				(0x023C)
+#define IPIPE_RGB1_MUL_GG				(0x023c)
 #define IPIPE_RGB1_MUL_BG				(0x0240)
 #define IPIPE_RGB1_MUL_RB				(0x0244)
 #define IPIPE_RGB1_MUL_GB				(0x0248)
-#define IPIPE_RGB1_MUL_BB				(0x024C)
+#define IPIPE_RGB1_MUL_BB				(0x024c)
 #define IPIPE_RGB1_OFT_OR				(0x0250)
 #define IPIPE_RGB1_OFT_OG				(0x0254)
 #define IPIPE_RGB1_OFT_OB				(0x0258)
-#define IPIPE_GMM_CFG					(0x025C)
+#define IPIPE_GMM_CFG					(0x025c)
 #define IPIPE_RGB2_MUL_RR				(0x0260)
 #define IPIPE_RGB2_MUL_GR				(0x0264)
 #define IPIPE_RGB2_MUL_BR				(0x0268)
-#define IPIPE_RGB2_MUL_RG				(0x026C)
+#define IPIPE_RGB2_MUL_RG				(0x026c)
 #define IPIPE_RGB2_MUL_GG				(0x0270)
 #define IPIPE_RGB2_MUL_BG				(0x0274)
 #define IPIPE_RGB2_MUL_RB				(0x0278)
-#define IPIPE_RGB2_MUL_GB				(0x027C)
+#define IPIPE_RGB2_MUL_GB				(0x027c)
 #define IPIPE_RGB2_MUL_BB				(0x0280)
 #define IPIPE_RGB2_OFT_OR				(0x0284)
 #define IPIPE_RGB2_OFT_OG				(0x0288)
-#define IPIPE_RGB2_OFT_OB				(0x028C)
+#define IPIPE_RGB2_OFT_OB				(0x028c)
 
 #define IPIPE_YUV_ADJ					(0x0294)
 #define IPIPE_YUV_MUL_RY				(0x0298)
-#define IPIPE_YUV_MUL_GY				(0x029C)
-#define IPIPE_YUV_MUL_BY				(0x02A0)
-#define IPIPE_YUV_MUL_RCB				(0x02A4)
-#define IPIPE_YUV_MUL_GCB				(0x02A8)
-#define IPIPE_YUV_MUL_BCB				(0x02AC)
-#define IPIPE_YUV_MUL_RCR				(0x02B0)
-#define IPIPE_YUV_MUL_GCR				(0x02B4)
-#define IPIPE_YUV_MUL_BCR				(0x02B8)
-#define IPIPE_YUV_OFT_Y					(0x02BC)
-#define IPIPE_YUV_OFT_CB				(0x02C0)
-#define IPIPE_YUV_OFT_CR				(0x02C4)
-
-#define IPIPE_YUV_PHS					(0x02C8)
+#define IPIPE_YUV_MUL_GY				(0x029c)
+#define IPIPE_YUV_MUL_BY				(0x02a0)
+#define IPIPE_YUV_MUL_RCB				(0x02a4)
+#define IPIPE_YUV_MUL_GCB				(0x02a8)
+#define IPIPE_YUV_MUL_BCB				(0x02ac)
+#define IPIPE_YUV_MUL_RCR				(0x02b0)
+#define IPIPE_YUV_MUL_GCR				(0x02b4)
+#define IPIPE_YUV_MUL_BCR				(0x02b8)
+#define IPIPE_YUV_OFT_Y					(0x02bc)
+#define IPIPE_YUV_OFT_CB				(0x02c0)
+#define IPIPE_YUV_OFT_CR				(0x02c4)
+
+#define IPIPE_YUV_PHS					(0x02c8)
 #define IPIPE_YUV_PHS_LPF				(1 << 1)
 #define IPIPE_YUV_PHS_POS				(1 << 0)
 
-#define IPIPE_YEE_EN					(0x02D4)
-#define IPIPE_YEE_TYP					(0x02D8)
-#define IPIPE_YEE_SHF					(0x02DC)
-#define IPIPE_YEE_MUL_00				(0x02E0)
-#define IPIPE_YEE_MUL_01				(0x02E4)
-#define IPIPE_YEE_MUL_02				(0x02E8)
-#define IPIPE_YEE_MUL_10				(0x02EC)
-#define IPIPE_YEE_MUL_11				(0x02F0)
-#define IPIPE_YEE_MUL_12				(0x02F4)
-#define IPIPE_YEE_MUL_20				(0x02F8)
-#define IPIPE_YEE_MUL_21				(0x02FC)
+#define IPIPE_YEE_EN					(0x02d4)
+#define IPIPE_YEE_TYP					(0x02d8)
+#define IPIPE_YEE_SHF					(0x02dc)
+#define IPIPE_YEE_MUL_00				(0x02e0)
+#define IPIPE_YEE_MUL_01				(0x02e4)
+#define IPIPE_YEE_MUL_02				(0x02e8)
+#define IPIPE_YEE_MUL_10				(0x02ec)
+#define IPIPE_YEE_MUL_11				(0x02f0)
+#define IPIPE_YEE_MUL_12				(0x02f4)
+#define IPIPE_YEE_MUL_20				(0x02f8)
+#define IPIPE_YEE_MUL_21				(0x02fc)
 #define IPIPE_YEE_MUL_22				(0x0300)
 #define IPIPE_YEE_THR					(0x0304)
 #define IPIPE_YEE_E_GAN					(0x0308)
-#define IPIPE_YEE_E_THR_1				(0x030C)
+#define IPIPE_YEE_E_THR_1				(0x030c)
 #define IPIPE_YEE_E_THR_2				(0x0310)
 #define IPIPE_YEE_G_GAN					(0x0314)
 #define IPIPE_YEE_G_OFT					(0x0318)
 
-#define IPIPE_CAR_EN					(0x031C)
+#define IPIPE_CAR_EN					(0x031c)
 #define IPIPE_CAR_TYP					(0x0320)
 #define IPIPE_CAR_SW					(0x0324)
 #define IPIPE_CAR_HPF_TYP				(0x0328)
-#define IPIPE_CAR_HPF_SHF				(0x032C)
+#define IPIPE_CAR_HPF_SHF				(0x032c)
 #define IPIPE_CAR_HPF_THR				(0x0330)
 #define IPIPE_CAR_GN1_GAN				(0x0334)
 #define IPIPE_CAR_GN1_SHF				(0x0338)
-#define IPIPE_CAR_GN1_MIN				(0x033C)
+#define IPIPE_CAR_GN1_MIN				(0x033c)
 #define IPIPE_CAR_GN2_GAN				(0x0340)
 #define IPIPE_CAR_GN2_SHF				(0x0344)
 #define IPIPE_CAR_GN2_MIN				(0x0348)
-#define IPIPE_CGS_EN					(0x034C)
+#define IPIPE_CGS_EN					(0x034c)
 #define IPIPE_CGS_GN1_L_THR				(0x0350)
 #define IPIPE_CGS_GN1_L_GAIN				(0x0354)
 #define IPIPE_CGS_GN1_L_SHF				(0x0358)
-#define IPIPE_CGS_GN1_L_MIN				(0x035C)
+#define IPIPE_CGS_GN1_L_MIN				(0x035c)
 #define IPIPE_CGS_GN1_H_THR				(0x0360)
 #define IPIPE_CGS_GN1_H_GAIN				(0x0364)
 #define IPIPE_CGS_GN1_H_SHF				(0x0368)
-#define IPIPE_CGS_GN1_H_MIN				(0x036C)
+#define IPIPE_CGS_GN1_H_MIN				(0x036c)
 #define IPIPE_CGS_GN2_L_THR				(0x0370)
 #define IPIPE_CGS_GN2_L_GAIN				(0x0374)
 #define IPIPE_CGS_GN2_L_SHF				(0x0378)
-#define IPIPE_CGS_GN2_L_MIN				(0x037C)
+#define IPIPE_CGS_GN2_L_MIN				(0x037c)
 
 #define IPIPE_BOX_EN					(0x0380)
 #define IPIPE_BOX_MODE					(0x0384)
 #define IPIPE_BOX_TYP					(0x0388)
-#define IPIPE_BOX_SHF					(0x038C)
+#define IPIPE_BOX_SHF					(0x038c)
 #define IPIPE_BOX_SDR_SAD_H				(0x0390)
 #define IPIPE_BOX_SDR_SAD_L				(0x0394)
 
-#define IPIPE_HST_EN					(0x039C)
-#define IPIPE_HST_MODE					(0x03A0)
-#define IPIPE_HST_SEL					(0x03A4)
-#define IPIPE_HST_PARA					(0x03A8)
-#define IPIPE_HST_0_VPS					(0x03AC)
-#define IPIPE_HST_0_VSZ					(0x03B0)
-#define IPIPE_HST_0_HPS					(0x03B4)
-#define IPIPE_HST_0_HSZ					(0x03B8)
-#define IPIPE_HST_1_VPS					(0x03BC)
-#define IPIPE_HST_1_VSZ					(0x03C0)
-#define IPIPE_HST_1_HPS					(0x03C4)
-#define IPIPE_HST_1_HSZ					(0x03C8)
-#define IPIPE_HST_2_VPS					(0x03CC)
-#define IPIPE_HST_2_VSZ					(0x03D0)
-#define IPIPE_HST_2_HPS					(0x03D4)
-#define IPIPE_HST_2_HSZ					(0x03D8)
-#define IPIPE_HST_3_VPS					(0x03DC)
-#define IPIPE_HST_3_VSZ					(0x03E0)
-#define IPIPE_HST_3_HPS					(0x03E4)
-#define IPIPE_HST_3_HSZ					(0x03E8)
-#define IPIPE_HST_TBL					(0x03EC)
-#define IPIPE_HST_MUL_R					(0x03F0)
-#define IPIPE_HST_MUL_GR				(0x03F4)
-#define IPIPE_HST_MUL_GB				(0x03F8)
-#define IPIPE_HST_MUL_B					(0x03FC)
+#define IPIPE_HST_EN					(0x039c)
+#define IPIPE_HST_MODE					(0x03a0)
+#define IPIPE_HST_SEL					(0x03a4)
+#define IPIPE_HST_PARA					(0x03a8)
+#define IPIPE_HST_0_VPS					(0x03ac)
+#define IPIPE_HST_0_VSZ					(0x03b0)
+#define IPIPE_HST_0_HPS					(0x03b4)
+#define IPIPE_HST_0_HSZ					(0x03b8)
+#define IPIPE_HST_1_VPS					(0x03bc)
+#define IPIPE_HST_1_VSZ					(0x03c0)
+#define IPIPE_HST_1_HPS					(0x03c4)
+#define IPIPE_HST_1_HSZ					(0x03c8)
+#define IPIPE_HST_2_VPS					(0x03cc)
+#define IPIPE_HST_2_VSZ					(0x03d0)
+#define IPIPE_HST_2_HPS					(0x03d4)
+#define IPIPE_HST_2_HSZ					(0x03d8)
+#define IPIPE_HST_3_VPS					(0x03dc)
+#define IPIPE_HST_3_VSZ					(0x03e0)
+#define IPIPE_HST_3_HPS					(0x03e4)
+#define IPIPE_HST_3_HSZ					(0x03e8)
+#define IPIPE_HST_TBL					(0x03ec)
+#define IPIPE_HST_MUL_R					(0x03f0)
+#define IPIPE_HST_MUL_GR				(0x03f4)
+#define IPIPE_HST_MUL_GB				(0x03f8)
+#define IPIPE_HST_MUL_B					(0x03fc)
 
 #define IPIPE_BSC_EN					(0x0400)
 #define IPIPE_BSC_MODE					(0x0404)
 #define IPIPE_BSC_TYP					(0x0408)
-#define IPIPE_BSC_ROW_VCT				(0x040C)
+#define IPIPE_BSC_ROW_VCT				(0x040c)
 #define IPIPE_BSC_ROW_SHF				(0x0410)
 #define IPIPE_BSC_ROW_VPO				(0x0414)
 #define IPIPE_BSC_ROW_VNU				(0x0418)
-#define IPIPE_BSC_ROW_VSKIP				(0x041C)
+#define IPIPE_BSC_ROW_VSKIP				(0x041c)
 #define IPIPE_BSC_ROW_HPO				(0x0420)
 #define IPIPE_BSC_ROW_HNU				(0x0424)
 #define IPIPE_BSC_ROW_HSKIP				(0x0428)
-#define IPIPE_BSC_COL_VCT				(0x042C)
+#define IPIPE_BSC_COL_VCT				(0x042c)
 #define IPIPE_BSC_COL_SHF				(0x0430)
 #define IPIPE_BSC_COL_VPO				(0x0434)
 #define IPIPE_BSC_COL_VNU				(0x0438)
-#define IPIPE_BSC_COL_VSKIP				(0x043C)
+#define IPIPE_BSC_COL_VSKIP				(0x043c)
 #define IPIPE_BSC_COL_HPO				(0x0440)
 #define IPIPE_BSC_COL_HNU				(0x0444)
 #define IPIPE_BSC_COL_HSKIP				(0x0448)
@@ -740,14 +740,14 @@
 #define RSZ_SYSCONFIG_RSZB_CLK_EN			(1 << 9)
 #define RSZ_SYSCONFIG_RSZA_CLK_EN			(1 << 8)
 
-#define RSZ_IN_FIFO_CTRL				(0x000C)
-#define RSZ_IN_FIFO_CTRL_THRLD_LOW_MASK			(0x1FF << 16)
+#define RSZ_IN_FIFO_CTRL				(0x000c)
+#define RSZ_IN_FIFO_CTRL_THRLD_LOW_MASK			(0x1ff << 16)
 #define RSZ_IN_FIFO_CTRL_THRLD_LOW_SHIFT		16
-#define RSZ_IN_FIFO_CTRL_THRLD_HIGH_MASK		(0x1FF << 0)
+#define RSZ_IN_FIFO_CTRL_THRLD_HIGH_MASK		(0x1ff << 0)
 #define RSZ_IN_FIFO_CTRL_THRLD_HIGH_SHIFT		0
 
 #define RSZ_FRACDIV					(0x0008)
-#define RSZ_FRACDIV_MASK				(0xFFFF)
+#define RSZ_FRACDIV_MASK				(0xffff)
 
 #define RSZ_SRC_EN					(0x0020)
 #define RSZ_SRC_EN_SRC_EN				(1 << 0)
@@ -760,80 +760,80 @@
 #define RSZ_SRC_FMT0_BYPASS				(1 << 1)
 #define RSZ_SRC_FMT0_SEL				(1 << 0)
 
-#define RSZ_SRC_FMT1					(0x002C)
+#define RSZ_SRC_FMT1					(0x002c)
 #define RSZ_SRC_FMT1_IN420				(1 << 1)
 
 #define RSZ_SRC_VPS					(0x0030)
 #define RSZ_SRC_VSZ					(0x0034)
 #define RSZ_SRC_HPS					(0x0038)
-#define RSZ_SRC_HSZ					(0x003C)
+#define RSZ_SRC_HSZ					(0x003c)
 #define RSZ_DMA_RZA					(0x0040)
 #define RSZ_DMA_RZB					(0x0044)
 #define RSZ_DMA_STA					(0x0048)
-#define RSZ_GCK_MMR					(0x004C)
+#define RSZ_GCK_MMR					(0x004c)
 #define RSZ_GCK_MMR_MMR					(1 << 0)
 
 #define RSZ_GCK_SDR					(0x0054)
 #define RSZ_GCK_SDR_CORE				(1 << 0)
 
 #define RSZ_IRQ_RZA					(0x0058)
-#define RSZ_IRQ_RZA_MASK				(0x1FFF)
+#define RSZ_IRQ_RZA_MASK				(0x1fff)
 
-#define RSZ_IRQ_RZB					(0x005C)
-#define RSZ_IRQ_RZB_MASK				(0x1FFF)
+#define RSZ_IRQ_RZB					(0x005c)
+#define RSZ_IRQ_RZB_MASK				(0x1fff)
 
 #define RSZ_YUV_Y_MIN					(0x0060)
 #define RSZ_YUV_Y_MAX					(0x0064)
 #define RSZ_YUV_C_MIN					(0x0068)
-#define RSZ_YUV_C_MAX					(0x006C)
+#define RSZ_YUV_C_MAX					(0x006c)
 
 #define RSZ_SEQ						(0x0074)
 #define RSZ_SEQ_HRVB					(1 << 2)
 #define RSZ_SEQ_HRVA					(1 << 0)
 
 #define RZA_EN						(0x0078)
-#define RZA_MODE					(0x007C)
+#define RZA_MODE					(0x007c)
 #define RZA_MODE_ONE_SHOT				(1 << 0)
 
 #define RZA_420						(0x0080)
 #define RZA_I_VPS					(0x0084)
 #define RZA_I_HPS					(0x0088)
-#define RZA_O_VSZ					(0x008C)
+#define RZA_O_VSZ					(0x008c)
 #define RZA_O_HSZ					(0x0090)
 #define RZA_V_PHS_Y					(0x0094)
 #define RZA_V_PHS_C					(0x0098)
-#define RZA_V_DIF					(0x009C)
-#define RZA_V_TYP					(0x00A0)
-#define RZA_V_LPF					(0x00A4)
-#define RZA_H_PHS					(0x00A8)
-#define RZA_H_DIF					(0x00B0)
-#define RZA_H_TYP					(0x00B4)
-#define RZA_H_LPF					(0x00B8)
-#define RZA_DWN_EN					(0x00BC)
-#define RZA_SDR_Y_BAD_H					(0x00D0)
-#define RZA_SDR_Y_BAD_L					(0x00D4)
-#define RZA_SDR_Y_SAD_H					(0x00D8)
-#define RZA_SDR_Y_SAD_L					(0x00DC)
-#define RZA_SDR_Y_OFT					(0x00E0)
-#define RZA_SDR_Y_PTR_S					(0x00E4)
-#define RZA_SDR_Y_PTR_E					(0x00E8)
-#define RZA_SDR_C_BAD_H					(0x00EC)
-#define RZA_SDR_C_BAD_L					(0x00F0)
-#define RZA_SDR_C_SAD_H					(0x00F4)
-#define RZA_SDR_C_SAD_L					(0x00F8)
-#define RZA_SDR_C_OFT					(0x00FC)
+#define RZA_V_DIF					(0x009c)
+#define RZA_V_TYP					(0x00a0)
+#define RZA_V_LPF					(0x00a4)
+#define RZA_H_PHS					(0x00a8)
+#define RZA_H_DIF					(0x00b0)
+#define RZA_H_TYP					(0x00b4)
+#define RZA_H_LPF					(0x00b8)
+#define RZA_DWN_EN					(0x00bc)
+#define RZA_SDR_Y_BAD_H					(0x00d0)
+#define RZA_SDR_Y_BAD_L					(0x00d4)
+#define RZA_SDR_Y_SAD_H					(0x00d8)
+#define RZA_SDR_Y_SAD_L					(0x00dc)
+#define RZA_SDR_Y_OFT					(0x00e0)
+#define RZA_SDR_Y_PTR_S					(0x00e4)
+#define RZA_SDR_Y_PTR_E					(0x00e8)
+#define RZA_SDR_C_BAD_H					(0x00ec)
+#define RZA_SDR_C_BAD_L					(0x00f0)
+#define RZA_SDR_C_SAD_H					(0x00f4)
+#define RZA_SDR_C_SAD_L					(0x00f8)
+#define RZA_SDR_C_OFT					(0x00fc)
 #define RZA_SDR_C_PTR_S					(0x0100)
 #define RZA_SDR_C_PTR_E					(0x0104)
 
 #define RZB_EN						(0x0108)
-#define RZB_MODE					(0x010C)
+#define RZB_MODE					(0x010c)
 #define RZB_420						(0x0110)
 #define RZB_I_VPS					(0x0114)
 #define RZB_I_HPS					(0x0118)
-#define RZB_O_VSZ					(0x011C)
+#define RZB_O_VSZ					(0x011c)
 #define RZB_O_HSZ					(0x0120)
 
-#define RZB_V_DIF					(0x012C)
+#define RZB_V_DIF					(0x012c)
 #define RZB_V_TYP					(0x0130)
 #define RZB_V_LPF					(0x0134)
 
@@ -844,11 +844,11 @@
 #define RZB_SDR_Y_BAD_H					(0x0160)
 #define RZB_SDR_Y_BAD_L					(0x0164)
 #define RZB_SDR_Y_SAD_H					(0x0168)
-#define RZB_SDR_Y_SAD_L					(0x016C)
+#define RZB_SDR_Y_SAD_L					(0x016c)
 #define RZB_SDR_Y_OFT					(0x0170)
 #define RZB_SDR_Y_PTR_S					(0x0174)
 #define RZB_SDR_Y_PTR_E					(0x0178)
-#define RZB_SDR_C_BAD_H					(0x017C)
+#define RZB_SDR_C_BAD_H					(0x017c)
 #define RZB_SDR_C_BAD_L					(0x0180)
 #define RZB_SDR_C_SAD_H					(0x0184)
 #define RZB_SDR_C_SAD_L					(0x0188)
@@ -862,38 +862,38 @@
 #define RSZ_420_CEN					(1 << 1)
 #define RSZ_420_YEN					(1 << 0)
 
-#define RSZ_I_VPS_MASK					(0x1FFF)
+#define RSZ_I_VPS_MASK					(0x1fff)
 
-#define RSZ_I_HPS_MASK					(0x1FFF)
+#define RSZ_I_HPS_MASK					(0x1fff)
 
-#define RSZ_O_VSZ_MASK					(0x1FFF)
+#define RSZ_O_VSZ_MASK					(0x1fff)
 
-#define RSZ_O_HSZ_MASK					(0x1FFE)
+#define RSZ_O_HSZ_MASK					(0x1ffe)
 
-#define RSZ_V_PHS_Y_MASK				(0x3FFF)
+#define RSZ_V_PHS_Y_MASK				(0x3fff)
 
-#define RSZ_V_PHS_C_MASK				(0x3FFF)
+#define RSZ_V_PHS_C_MASK				(0x3fff)
 
-#define RSZ_V_DIF_MASK					(0x3FFF)
+#define RSZ_V_DIF_MASK					(0x3fff)
 
 #define RSZ_V_TYP_C					(1 << 1)
 #define RSZ_V_TYP_Y					(1 << 0)
 
-#define RSZ_V_LPF_C_MASK				(0x3F << 6)
+#define RSZ_V_LPF_C_MASK				(0x3f << 6)
 #define RSZ_V_LPF_C_SHIFT				6
-#define RSZ_V_LPF_Y_MASK				(0x3F << 0)
+#define RSZ_V_LPF_Y_MASK				(0x3f << 0)
 #define RSZ_V_LPF_Y_SHIFT				0
 
-#define RSZ_H_PHS_MASK					(0x3FFF)
+#define RSZ_H_PHS_MASK					(0x3fff)
 
-#define RSZ_H_DIF_MASK					(0x3FFF)
+#define RSZ_H_DIF_MASK					(0x3fff)
 
 #define RSZ_H_TYP_C					(1 << 1)
 #define RSZ_H_TYP_Y					(1 << 0)
 
-#define RSZ_H_LPF_C_MASK				(0x3F << 6)
+#define RSZ_H_LPF_C_MASK				(0x3f << 6)
 #define RSZ_H_LPF_C_SHIFT				6
-#define RSZ_H_LPF_Y_MASK				(0x3F << 0)
+#define RSZ_H_LPF_Y_MASK				(0x3f << 0)
 #define RSZ_H_LPF_Y_SHIFT				0
 
 #define RSZ_DWN_EN_DWN_EN				(1 << 0)
-- 
1.8.3.2

