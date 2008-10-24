Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9O9v5L9002625
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:57:05 -0400
Received: from arroyo.ext.ti.com (arroyo.ext.ti.com [192.94.94.40])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9O9uTEg023539
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:56:46 -0400
From: Hardik Shah <hardik.shah@ti.com>
To: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
	video4linux-list@redhat.com
Date: Fri, 24 Oct 2008 15:22:44 +0530
Message-Id: <1224841964-24576-1-git-send-email-hardik.shah@ti.com>
Cc: 
Subject: [PATCHv2 1/4] OMAP 2/3 DSS Library
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Cleaned up the DSS Library according to open source comments

Removed unused #ifdefs
Removed unused #defines
Minor cleanups done
Removed Architecture specific #ifdefs

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
		Hari Nagalla <hnagalla@ti.com>
		Hardik Shah <hardik.shah@ti.com>
		Manjunath Hadli <mrh@ti.com>
		R Sivaraj <sivaraj@ti.com>
		Vaibhav Hiremath <hvaibhav@ti.com>

---
 arch/arm/plat-omap/Kconfig                 |    7 +
 arch/arm/plat-omap/Makefile                |    2 +-
 arch/arm/plat-omap/include/mach/io.h       |    2 +-
 arch/arm/plat-omap/include/mach/omap-dss.h |  921 ++++++++++++
 arch/arm/plat-omap/omap-dss.c              | 2248 ++++++++++++++++++++++++++++
 5 files changed, 3178 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/mach/omap-dss.h
 create mode 100644 arch/arm/plat-omap/omap-dss.c

diff --git a/arch/arm/plat-omap/Kconfig b/arch/arm/plat-omap/Kconfig
index 960c13f..eb82865 100644
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@ -245,6 +245,13 @@ config OMAP_SERIAL_WAKE
 	  to data on the serial RX line. This allows you to wake the
 	  system from serial console.

+config VIDEO_OMAP_DSSLIB
+	bool "DSS Library support"
+	depends on ARCH_OMAP2 || ARCH_OMAP3
+	default n
+	help
+	  Select this option if you want to have DSS hardware library.
+
 endmenu

 endif
diff --git a/arch/arm/plat-omap/Makefile b/arch/arm/plat-omap/Makefile
index 1259846..2b514d0 100644
--- a/arch/arm/plat-omap/Makefile
+++ b/arch/arm/plat-omap/Makefile
@@ -11,7 +11,7 @@ obj-  :=

 # OCPI interconnect support for 1710, 1610 and 5912
 obj-$(CONFIG_ARCH_OMAP16XX) += ocpi.o
-
+obj-$(CONFIG_VIDEO_OMAP_DSSLIB) += omap-dss.o
 obj-$(CONFIG_OMAP_MCBSP) += mcbsp.o

 obj-$(CONFIG_CPU_FREQ) += cpu-omap.o
diff --git a/arch/arm/plat-omap/include/mach/io.h b/arch/arm/plat-omap/include/mach/io.h
index ea55267..2495656 100644
--- a/arch/arm/plat-omap/include/mach/io.h
+++ b/arch/arm/plat-omap/include/mach/io.h
@@ -142,11 +142,11 @@
 #define OMAP343X_SDRC_VIRT	0xFD000000
 #define OMAP343X_SDRC_SIZE	SZ_1M

-
 #define IO_OFFSET		0x90000000
 #define __IO_ADDRESS(pa)	((pa) + IO_OFFSET)/* Works for L3 and L4 */
 #define __OMAP2_IO_ADDRESS(pa)	((pa) + IO_OFFSET)/* Works for L3 and L4 */
 #define io_v2p(va)		((va) - IO_OFFSET)/* Works for L3 and L4 */
+#define io_p2v(pa)		__IO_ADDRESS(pa)/* Works for L3 and L4 */

 /* DSP */
 #define DSP_MEM_34XX_PHYS	OMAP34XX_DSP_MEM_BASE	/* 0x58000000 */
diff --git a/arch/arm/plat-omap/include/mach/omap-dss.h b/arch/arm/plat-omap/include/mach/omap-dss.h
new file mode 100644
index 0000000..d9a33bd
--- /dev/null
+++ b/arch/arm/plat-omap/include/mach/omap-dss.h
@@ -0,0 +1,921 @@
+/*
+ * arch/arm/plat-omap/include/mach/omap-dss.h
+ *
+ * Copyright (C) 2004-2005 Texas Instruments.
+ * Copyright (C) 2006 Texas Instruments.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+
+ * Leveraged from original Linux 2.6 framebuffer driver for OMAP24xx
+ * Author: Andy Lowe (source@mvista.com)
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ *
+ */
+
+#ifndef	__ASM_ARCH_OMAP_DISP_H
+#define	__ASM_ARCH_OMAP_DISP_H
+
+/* 16 bit uses LDRH/STRH, base +/- offset_8 */
+typedef struct {
+	volatile u16 offset[256];
+} __regbase16;
+#define __REGV16(vaddr)		(((__regbase16 *)((vaddr)&~0xff)) \
+					->offset[((vaddr)&0xff)>>1])
+#define __REG16(paddr)		 __REGV16(io_p2v(paddr))
+
+/* 8/32 bit uses LDR/STR, base +/- offset_12 */
+typedef struct {
+	volatile u8 offset[4096];
+} __regbase8;
+#define __REGV8(vaddr)		(((__regbase8  *)((vaddr)&~4095)) \
+					->offset[((vaddr)&4095)>>0])
+#define __REG8(paddr)		 __REGV8(io_p2v(paddr))
+
+typedef struct {
+	volatile u32 offset[4096];
+} __regbase32;
+#define __REGV32(vaddr)		(((__regbase32 *)((vaddr)&~4095)) \
+					->offset[((vaddr)&4095)>>2])
+#define __REG32(paddr)		__REGV32(io_p2v(paddr))
+
+/*physical memory map definitions */
+	/* display subsystem */
+#define DSS_REG_BASE			0x48050000
+#define DSS_REG_SIZE			0x00001000
+	/* DSS */
+#define DSS_REG_OFFSET			0x00000000
+	/* display controller */
+#define DISPC_REG_OFFSET		0x00000400
+	/* remote framebuffer interface */
+#define RFBI_REG_OFFSET			0x00000800
+	/* video encoder */
+#define VENC_REG_OFFSET			0x00000C00
+
+/* display subsystem register offsets */
+#define DSS_REVISION			0x000
+#define DSS_SYSCONFIG			0x010
+#define DSS_SYSSTATUS			0x014
+#define DSS_CONTROL			0x040
+#define DSS_SDI_CONTROL			0x044
+#define DSS_PLL_CONTROL			0x048
+#define DSS_PSA_LCD_REG_1		0x050
+#define DSS_PSA_LCD_REG_2		0x054
+#define DSS_PSA_VIDEO_REG		0x058
+#define DSS_STATUS			0x05C
+
+/* display controller register offsets */
+#define DISPC_REVISION			0x000
+#define DISPC_SYSCONFIG			0x010
+#define DISPC_SYSSTATUS			0x014
+#define DISPC_IRQSTATUS			0x018
+#define DISPC_IRQENABLE			0x01C
+#define DISPC_CONTROL			0x040
+#define DISPC_CONFIG			0x044
+#define DISPC_CAPABLE			0x048
+#define DISPC_DEFAULT_COLOR0		0x04C
+#define DISPC_DEFAULT_COLOR1		0x050
+#define DISPC_TRANS_COLOR0		0x054
+#define DISPC_TRANS_COLOR1		0x058
+#define DISPC_LINE_STATUS		0x05C
+#define DISPC_LINE_NUMBER		0x060
+#define DISPC_TIMING_H			0x064
+#define DISPC_TIMING_V			0x068
+#define DISPC_POL_FREQ			0x06C
+#define DISPC_DIVISOR			0x070
+#define DISPC_GLOBAL_ALPHA		0x074
+#define DISPC_SIZE_DIG			0x078
+#define DISPC_SIZE_LCD			0x07C
+#define DISPC_GFX_BA0			0x080
+#define DISPC_GFX_BA1			0x084
+#define DISPC_GFX_POSITION		0x088
+#define DISPC_GFX_SIZE			0x08C
+#define DISPC_GFX_ATTRIBUTES		0x0A0
+#define DISPC_GFX_FIFO_THRESHOLD	0x0A4
+#define DISPC_GFX_FIFO_SIZE		0x0A8
+#define DISPC_GFX_ROW_INC		0x0AC
+#define DISPC_GFX_PIXEL_INC		0x0B0
+#define DISPC_GFX_WINDOW_SKIP		0x0B4
+#define DISPC_GFX_TABLE_BA		0x0B8
+
+#define RFBI_SYSCONFIG			0x010
+
+/* The registers for the video pipelines are parameterized by the video pipeline
+ * index: n=0 for VID1 and n=1 for VID2.
+ */
+#define DISPC_VID_BA0(n)		(0x0BC + (n)*0x90)
+#define DISPC_VID_BA1(n)		(0x0C0 + (n)*0x90)
+#define DISPC_VID_POSITION(n)		(0x0C4 + (n)*0x90)
+#define DISPC_VID_SIZE(n)		(0x0C8 + (n)*0x90)
+#define DISPC_VID_ATTRIBUTES(n)		(0x0CC + (n)*0x90)
+#define DISPC_VID_FIFO_THRESHOLD(n)	(0x0D0 + (n)*0x90)
+#define DISPC_VID_FIFO_SIZE(n)		(0x0D4 + (n)*0x90)
+#define DISPC_VID_ROW_INC(n)		(0x0D8 + (n)*0x90)
+#define DISPC_VID_PIXEL_INC(n)		(0x0DC + (n)*0x90)
+#define DISPC_VID_FIR(n)		(0x0E0 + (n)*0x90)
+#define DISPC_VID_PICTURE_SIZE(n)	(0x0E4 + (n)*0x90)
+#define DISPC_VID_ACCU0(n)		(0x0E8 + (n)*0x90)
+#define DISPC_VID_ACCU1(n)		(0x0EC + (n)*0x90)
+
+/* The FIR coefficients are parameterized by the video pipeline index n = {0, 1}
+ * and the coefficient index i = {0, 1, 2, 3, 4, 5, 6, 7}.
+ */
+#define DISPC_VID_FIR_COEF_H(n, i)	(0x0F0 + (i)*0x8 + (n)*0x90)
+#define DISPC_VID_FIR_COEF_HV(n, i)	(0x0F4 + (i)*0x8 + (n)*0x90)
+#define DISPC_VID_FIR_COEF_V(n, i)	(0x1E0 + (i)*0x4 + (n)*0x20)
+#define DISPC_VID_CONV_COEF0(n)		(0x130 + (n)*0x90)
+#define DISPC_VID_CONV_COEF1(n)		(0x134 + (n)*0x90)
+#define DISPC_VID_CONV_COEF2(n)		(0x138 + (n)*0x90)
+#define DISPC_VID_CONV_COEF3(n)		(0x13C + (n)*0x90)
+#define DISPC_VID_CONV_COEF4(n)		(0x140 + (n)*0x90)
+
+#define DISPC_DATA_CYCLE1		0x1D4
+#define DISPC_DATA_CYCLE2		0x1D8
+#define DISPC_DATA_CYCLE3		0x1DC
+
+#define DISPC_CPR_R			0x220
+#define DISPC_CPR_G			0x224
+#define DISPC_CPR_B			0x228
+
+/* bit fields within selected registers */
+#define DSS_CONTROL_VENC_OUT				(1 << 6)
+#define DSS_CONTROL_TV_REF				(1 << 5)
+#define DSS_CONTROL_DAC_DEMEN				(1 << 4)
+#define DSS_CONTROL_VENC_CLOCK_4X_ENABLE		(1 << 3)
+#define DSS_CONTROL_VENC_CLOCK_MODE			(1 << 2)
+#define DSS_CONTROL_CLK					(1 << 0)
+#define DSS_CONTROL_APLL_CLK				1
+#define DSS_CONTROL_DPLL_CLK				0
+#define DSS_SYSCONFIG_SOFTRESET				(1 <<  1)
+#define DSS_SYSSTATUS_RESETDONE				(1 <<  0)
+#define DSS_SYSCONFIG_SIDLEMODE				(3 <<  3)
+#define DSS_SYSCONFIG_SIDLEMODE_FIDLE			(0 <<  3)
+#define DSS_SYSCONFIG_SIDLEMODE_NIDLE			(1 <<  3)
+#define DSS_SYSCONFIG_SIDLEMODE_SIDLE			(2 <<  3)
+#define DSS_SYSCONFIG_SOFTRESET				(1 <<  1)
+#define DSS_SYSCONFIG_AUTOIDLE				(1 <<  0)
+
+#define DISPC_REVISION_MAJOR				(15 << 4)
+#define DISPC_REVISION_MAJOR_SHIFT			4
+#define DISPC_REVISION_MINOR				(15 << 0)
+#define DISPC_REVISION_MINOR_SHIFT			0
+
+#define DISPC_SYSCONFIG_MIDLEMODE			(3 << 12)
+#define DISPC_SYSCONFIG_MIDLEMODE_FSTANDBY		(0 << 12)
+#define DISPC_SYSCONFIG_MIDLEMODE_NSTANDBY		(1 << 12)
+#define DISPC_SYSCONFIG_MIDLEMODE_SSTANDBY		(2 << 12)
+#define DISPC_SYSCONFIG_SIDLEMODE			(3 <<  3)
+#define DISPC_SYSCONFIG_SIDLEMODE_FIDLE			(0 <<  3)
+#define DISPC_SYSCONFIG_SIDLEMODE_NIDLE			(1 <<  3)
+#define DISPC_SYSCONFIG_SIDLEMODE_SIDLE			(2 <<  3)
+#define DISPC_SYSCONFIG_SOFTRESET			(1 <<  1)
+#define DISPC_SYSCONFIG_AUTOIDLE			(1 <<  0)
+#define DISPC_SYSCONFIG_CLKACTIVITY			(2 <<  8)
+#define DISPC_SYSCONFIG_ENABLE_WKUP			(1 <<  2)
+
+#define DISPC_SYSSTATUS_RESETDONE			(1 << 0)
+
+#define DISPC_IRQSTATUS_SYNCLOSTDIGITAL			(1 << 15)
+#define DISPC_IRQSTATUS_SYNCLOST			(1 << 14)
+#define DISPC_IRQSTATUS_VID2ENDWINDOW			(1 << 13)
+#define DISPC_IRQSTATUS_VID2FIFOUNDERFLOW		(1 << 12)
+#define DISPC_IRQSTATUS_VID1ENDWINDOW			(1 << 11)
+#define DISPC_IRQSTATUS_VID1FIFOUNDERFLOW		(1 << 10)
+#define DISPC_IRQSTATUS_OCPERROR			(1 <<  9)
+#define DISPC_IRQSTATUS_PALETTEGAMMALOADING		(1 <<  8)
+#define DISPC_IRQSTATUS_GFXENDWINDOW			(1 <<  7)
+#define DISPC_IRQSTATUS_GFXFIFOUNDERFLOW		(1 <<  6)
+#define DISPC_IRQSTATUS_PROGRAMMEDLINENUMBER		(1 <<  5)
+#define DISPC_IRQSTATUS_ACBIASCOUNTSTATUS		(1 <<  4)
+#define DISPC_IRQSTATUS_EVSYNC_ODD			(1 <<  3)
+#define DISPC_IRQSTATUS_EVSYNC_EVEN			(1 <<  2)
+#define DISPC_IRQSTATUS_VSYNC				(1 <<  1)
+#define DISPC_IRQSTATUS_FRAMEDONE			(1 <<  0)
+
+#define DISPC_IRQENABLE_SYNCLOSTDIGITAL (1 << 15)
+#define DISPC_IRQENABLE_SYNCLOST			(1 << 14)
+#define DISPC_IRQENABLE_VID2ENDWINDOW			(1 << 13)
+#define DISPC_IRQENABLE_VID2FIFOUNDERFLOW		(1 << 12)
+#define DISPC_IRQENABLE_VID1ENDWINDOW			(1 << 11)
+#define DISPC_IRQENABLE_VID1FIFOUNDERFLOW		(1 << 10)
+#define DISPC_IRQENABLE_OCPERROR			(1 <<  9)
+#define DISPC_IRQENABLE_PALETTEGAMMALOADING		(1 <<  8)
+#define DISPC_IRQENABLE_GFXENDWINDOW			(1 <<  7)
+#define DISPC_IRQENABLE_GFXFIFOUNDERFLOW		(1 <<  6)
+#define DISPC_IRQENABLE_PROGRAMMEDLINENUMBER		(1 <<  5)
+#define DISPC_IRQENABLE_ACBIASCOUNTSTATUS		(1 <<  4)
+#define DISPC_IRQENABLE_EVSYNC_ODD			(1 <<  3)
+#define DISPC_IRQENABLE_EVSYNC_EVEN			(1 <<  2)
+#define DISPC_IRQENABLE_VSYNC				(1 <<  1)
+#define DISPC_IRQENABLE_FRAMEDONE			(1 <<  0)
+
+#define DISPC_CONTROL_TDMUNUSEDBITS			(3 << 25)
+#define DISPC_CONTROL_TDMUNUSEDBITS_LOWLEVEL		(0 << 25)
+#define DISPC_CONTROL_TDMUNUSEDBITS_HIGHLEVEL		(1 << 25)
+#define DISPC_CONTROL_TDMUNUSEDBITS_UNCHANGED		(2 << 25)
+#define DISPC_CONTROL_TDMCYCLEFORMAT			(3 << 23)
+#define DISPC_CONTROL_TDMCYCLEFORMAT_1CYCPERPIX		(0 << 23)
+#define DISPC_CONTROL_TDMCYCLEFORMAT_2CYCPERPIX		(1 << 23)
+#define DISPC_CONTROL_TDMCYCLEFORMAT_3CYCPERPIX		(2 << 23)
+#define DISPC_CONTROL_TDMCYCLEFORMAT_3CYCPER2PIX	(3 << 23)
+#define DISPC_CONTROL_TDMPARALLELMODE			(3 << 21)
+#define DISPC_CONTROL_TDMPARALLELMODE_8BPARAINT		(0 << 21)
+#define DISPC_CONTROL_TDMPARALLELMODE_9BPARAINT		(1 << 21)
+#define DISPC_CONTROL_TDMPARALLELMODE_12BPARAINT	(2 << 21)
+#define DISPC_CONTROL_TDMPARALLELMODE_16BPARAINT	(3 << 21)
+#define DISPC_CONTROL_TDMENABLE				(1 << 20)
+#define DISPC_CONTROL_HT				(7 << 17)
+#define DISPC_CONTROL_HT_SHIFT				17
+#define DISPC_CONTROL_GPOUT1				(1 << 16)
+#define DISPC_CONTROL_GPOUT0				(1 << 15)
+#define DISPC_CONTROL_GPIN1				(1 << 14)
+#define DISPC_CONTROL_GPIN0				(1 << 13)
+#define DISPC_CONTROL_OVERLAYOPTIMIZATION		(1 << 12)
+#define DISPC_CONTROL_RFBIMODE				(1 << 11)
+#define DISPC_CONTROL_SECURE				(1 << 10)
+#define DISPC_CONTROL_TFTDATALINES			(3 <<  8)
+#define DISPC_CONTROL_TFTDATALINES_OALSB12B		(0 <<  8)
+#define DISPC_CONTROL_TFTDATALINES_OALSB16B		(1 <<  8)
+#define DISPC_CONTROL_TFTDATALINES_OALSB18B		(2 <<  8)
+#define DISPC_CONTROL_TFTDATALINES_OALSB24B		(3 <<  8)
+#define DISPC_CONTROL_TFTDITHERENABLE			(1 <<  7)
+#define DISPC_CONTROL_GODIGITAL				(1 <<  6)
+#define DISPC_CONTROL_GOLCD				(1 <<  5)
+#define DISPC_CONTROL_M8B				(1 <<  4)
+#define DISPC_CONTROL_STNTFT				(1 <<  3)
+#define DISPC_CONTROL_MONOCOLOR				(1 <<  2)
+#define DISPC_CONTROL_DIGITALENABLE			(1 <<  1)
+#define DISPC_CONTROL_LCDENABLE				(1 <<  0)
+
+#define DISPC_CONFIG_TVALPHAENABLE			(1 << 19)
+#define DISPC_CONFIG_LCDALPHAENABLE			(1 << 18)
+#define DISPC_CONFIG_FIFOMERGE				(1 << 14)
+#define DISPC_CONFIG_TCKDIGSELECTION			(1 << 13)
+#define DISPC_CONFIG_TCKDIGENABLE			(1 << 12)
+#define DISPC_CONFIG_TCKLCDSELECTION			(1 << 11)
+#define DISPC_CONFIG_TCKLCDENABLE			(1 << 10)
+#define DISPC_CONFIG_FUNCGATED				(1 <<  9)
+#define DISPC_CONFIG_ACBIASGATED			(1 <<  8)
+#define DISPC_CONFIG_VSYNCGATED				(1 <<  7)
+#define DISPC_CONFIG_HSYNCGATED				(1 <<  6)
+#define DISPC_CONFIG_PIXELCLOCKGATED			(1 <<  5)
+#define DISPC_CONFIG_PIXELDATAGATED			(1 <<  4)
+#define DISPC_CONFIG_PALETTEGAMMATABLE			(1 <<  3)
+#define DISPC_CONFIG_LOADMODE_FRDATLEFR			(1 <<  2)
+#define DISPC_CONFIG_LOADMODE_PGTABUSETB		(1 <<  1)
+#define DISPC_CONFIG_PIXELGATED				(1 <<  0)
+
+#define DISPC_CAPABLE_GFXGAMMATABLECAPABLE		(1 <<  9)
+#define DISPC_CAPABLE_GFXLAYERCAPABLE			(1 <<  8)
+#define DISPC_CAPABLE_GFXTRANSDSTCAPABLE		(1 <<  7)
+#define DISPC_CAPABLE_STNDITHERINGCAPABLE		(1 <<  6)
+#define DISPC_CAPABLE_TFTDITHERINGCAPABLE		(1 <<  5)
+#define DISPC_CAPABLE_VIDTRANSSRCCAPABLE		(1 <<  4)
+#define DISPC_CAPABLE_VIDLAYERCAPABLE			(1 <<  3)
+#define DISPC_CAPABLE_VIDVERTFIRCAPABLE			(1 <<  2)
+#define DISPC_CAPABLE_VIDHORFIRCAPABLE			(1 <<  1)
+#define DISPC_CAPABLE_VIDCAPABLE			(1 <<  0)
+
+#define DISPC_POL_FREQ_ONOFF_SHIFT                      17
+#define DISPC_POL_FREQ_ONOFF				(1 << 17)
+#define DISPC_POL_FREQ_RF				(1 << 16)
+#define DISPC_POL_FREQ_IEO				(1 << 15)
+#define DISPC_POL_FREQ_IPC_SHIFT                        14
+#define DISPC_POL_FREQ_IPC				(1 << 14)
+#define DISPC_POL_FREQ_IHS				(1 << 13)
+#define DISPC_POL_FREQ_IVS				(1 << 12)
+#define DISPC_POL_FREQ_ACBI				(15 << 8)
+#define DISPC_POL_FREQ_ACBI_SHIFT			8
+#define DISPC_POL_FREQ_ACB				0xFF
+#define DISPC_POL_FREQ_ACB_SHIFT			0
+
+#define DISPC_TIMING_H_HBP				(0xFF << 20)
+#define DISPC_TIMING_H_HBP_SHIFT			20
+#define DISPC_TIMING_H_HFP				(0xFF << 8)
+#define DISPC_TIMING_H_HFP_SHIFT			8
+#define DISPC_TIMING_H_HSW				(0x3F << 0)
+#define DISPC_TIMING_H_HSW_SHIFT			0
+
+#define DISPC_TIMING_V_VBP				(0xFF << 20)
+#define DISPC_TIMING_V_VBP_SHIFT			20
+#define DISPC_TIMING_V_VFP				(0xFF << 8)
+#define DISPC_TIMING_V_VFP_SHIFT			8
+#define DISPC_TIMING_V_VSW				(0x3F << 0)
+#define DISPC_TIMING_V_VSW_SHIFT			0
+
+#define DISPC_DIVISOR_LCD				(0xFF << 16)
+#define DISPC_DIVISOR_LCD_SHIFT				16
+#define DISPC_DIVISOR_PCD				0xFF
+#define DISPC_DIVISOR_PCD_SHIFT				0
+
+#define DISPC_GLOBAL_ALPHA_VID2_GALPHA	(0xFF << 16)
+#define DISPC_GLOBAL_ALPHA_VID2_GALPHA_SHIFT		16
+#define DISPC_GLOBAL_ALPHA_GFX_GALPHA	0xFF
+#define DISPC_GLOBAL_ALPHA_GFX_GALPHA_SHIFT		0
+
+#define DISPC_SIZE_LCD_LPP				(0x7FF << 16)
+#define DISPC_SIZE_LCD_LPP_SHIFT			16
+#define DISPC_SIZE_LCD_PPL				0x7FF
+#define DISPC_SIZE_LCD_PPL_SHIFT			0
+
+#define DISPC_SIZE_DIG_LPP				(0x7FF << 16)
+#define DISPC_SIZE_DIG_LPP_SHIFT			16
+#define DISPC_SIZE_DIG_PPL				0x7FF
+#define DISPC_SIZE_DIG_PPL_SHIFT			0
+
+#define DISPC_GFX_POSITION_GFXPOSY			(0x7FF << 16)
+#define DISPC_GFX_POSITION_GFXPOSY_SHIFT		16
+#define DISPC_GFX_POSITION_GFXPOSX			0x7FF
+#define DISPC_GFX_POSITION_GFXPOSX_SHIFT		0
+
+#define DISPC_GFX_SIZE_GFXSIZEY				(0x7FF << 16)
+#define DISPC_GFX_SIZE_GFXSIZEY_SHIFT			16
+#define DISPC_GFX_SIZE_GFXSIZEX				0x7FF
+#define DISPC_GFX_SIZE_GFXSIZEX_SHIFT			0
+
+#define DISPC_GFX_ATTRIBUTES_GFXENDIANNESS		(1 << 10)
+#define DISPC_GFX_ATTRIBUTES_GFXNIBBLEMODE		(1 <<  9)
+#define DISPC_GFX_ATTRIBUTES_GFXCHANNELOUT		(1 <<  8)
+#define DISPC_GFX_ATTRIBUTES_GFXBURSTSIZE		(3 <<  6)
+#define DISPC_GFX_ATTRIBUTES_GFXBURSTSIZE_BURST4X32	(0 <<  6)
+#define DISPC_GFX_ATTRIBUTES_GFXBURSTSIZE_BURST8X32	(1 <<  6)
+#define DISPC_GFX_ATTRIBUTES_GFXBURSTSIZE_BURST16X32	(2 <<  6)
+#define DISPC_GFX_ATTRIBUTES_GFXREPLICATIONENABLE	(1 <<  5)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT			(15 << 1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_BITMAP1		(0 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_BITMAP2		(1 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_BITMAP4		(2 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_BITMAP8		(3 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_RGB12		(4 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_RGB16		(6 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_RGB24		(8 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_ARGB32		(12 <<  1)
+#define DISPC_GFX_ATTRIBUTES_GFXFORMAT_RGBA32		(13 <<  1)
+#define DISPC_GFX_ATTRIBUTES_ENABLE			(1 <<  0)
+#define DISPC_GFX_ATTRIBUTES_GFXREPEN			5
+
+#define DISPC_GFX_FIFO_THRESHOLD_HIGH			(0xFFF << 16)
+#define DISPC_GFX_FIFO_THRESHOLD_HIGH_SHIFT		16
+#define DISPC_GFX_FIFO_THRESHOLD_LOW			0xFFF
+#define DISPC_GFX_FIFO_THRESHOLD_LOW_SHIFT		0
+
+#define DISPC_VID_POSITION_VIDPOSY			(0x7FF << 16)
+#define DISPC_VID_POSITION_VIDPOSY_SHIFT		16
+#define DISPC_VID_POSITION_VIDPOSX			0x7FF
+#define DISPC_VID_POSITION_VIDPOSX_SHIFT		0
+
+#define DISPC_VID_SIZE_VIDSIZEY				(0x7FF << 16)
+#define DISPC_VID_SIZE_VIDSIZEY_SHIFT			16
+#define DISPC_VID_SIZE_VIDSIZEX				0x7FF
+#define DISPC_VID_SIZE_VIDSIZEX_SHIFT			0
+
+#define DISPC_VID_ATTRIBUTES_VIDVERTICALTAPS		(1 << 21)
+#define DISPC_VID_ATTRIBUTES_VIDROWREPEATENABLE		(1 << 18)
+#define DISPC_VID_ATTRIBUTES_VIDENDIANNESS		(1 << 17)
+#define DISPC_VID_ATTRIBUTES_VIDCHANNELOUT		(1 << 16)
+#define DISPC_VID_ATTRIBUTES_VIDBURSTSIZE		(3 << 14)
+#define DISPC_VID_ATTRIBUTES_VIDBURSTSIZE_BURST4X32	(0 << 14)
+#define DISPC_VID_ATTRIBUTES_VIDBURSTSIZE_BURST8X32	(1 << 14)
+#define DISPC_VID_ATTRIBUTES_VIDBURSTSIZE_BURST16X32	(2 << 14)
+#define DISPC_VID_ATTRIBUTES_VIDROTATION(n)		((n) << 12)
+#define DISPC_VID_ATTRIBUTES_VIDFULLRANGE		(1 << 11)
+#define DISPC_VID_ATTRIBUTES_VIDREPLICATIONENABLE	(1 << 10)
+#define DISPC_VID_ATTRIBUTES_VIDCOLORCONVENABLE		(1 <<  9)
+#define DISPC_VID_ATTRIBUTES_VIDVRESIZECONF		(1 <<  8)
+#define DISPC_VID_ATTRIBUTES_VIDHRESIZECONF		(1 <<  7)
+#define DISPC_VID_ATTRIBUTES_VIDRESIZEENABLE_VRESIZE	(1 <<  6)
+#define DISPC_VID_ATTRIBUTES_VIDRESIZEENABLE_HRESIZE	(1 <<  5)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT			(15 << 1)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT_RGB16		(6  << 1)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT_RGB24            (8  << 1)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT_RGB24P           (9  << 1)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT_YUV2		(10 << 1)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT_UYVY		(11 << 1)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT_ARGB32		(12 << 1)
+#define DISPC_VID_ATTRIBUTES_VIDFORMAT_RGBA32		(13 << 1)
+#define DISPC_VID_ATTRIBUTES_ENABLE			(1 <<  0)
+
+#define DISPC_VID_PICTURE_SIZE_VIDORGSIZEY		(0x7FF << 16)
+#define DISPC_VID_PICTURE_SIZE_VIDORGSIZEY_SHIFT	16
+#define DISPC_VID_PICTURE_SIZE_VIDORGSIZEX		0x7FF
+#define DISPC_VID_PICTURE_SIZE_VIDORGSIZEX_SHIFT	0
+
+#define DISPC_VID_ATTRIBUTES_VIDROT			12
+#define DISPC_VID_ATTRIBUTES_VIDROWREPEAT		18
+
+/*RFBI Sysconfig values */
+#define RFBI_SYSCONFIG_SIDLEMODE_SIDLE			(2 << 3)
+
+/* VENC register offsets */
+#define VENC_F_CONTROL				0x0008
+#define VENC_VIDOUT_CTRL			0x0010
+#define VENC_SYNC_CONTROL			0x0014
+#define VENC_LLEN				0x001C
+#define VENC_FLENS				0x0020
+#define VENC_HFLTR_CTRL				0x0024
+#define VENC_CC_CARR_WSS_CARR			0x0028
+#define VENC_C_PHASE				0x002C
+#define VENC_GAIN_U				0x0030
+#define VENC_GAIN_V				0x0034
+#define VENC_GAIN_Y				0x0038
+#define VENC_BLACK_LEVEL			0x003C
+#define VENC_BLANK_LEVEL			0x0040
+#define VENC_X_COLOR				0x0044
+#define VENC_M_CONTROL				0x0048
+#define VENC_BSTAMP_WSS_DATA			0x004C
+#define VENC_S_CARR				0x0050
+#define VENC_LINE21				0x0054
+#define VENC_LN_SEL				0x0058
+#define VENC_L21_WC_CTL				0x005C
+#define VENC_HTRIGGER_VTRIGGER			0x0060
+#define VENC_SAVID_EAVID			0x0064
+#define VENC_FLEN_FAL				0x0068
+#define VENC_LAL_PHASE_RESET			0x006C
+#define VENC_HS_INT_START_STOP_X		0x0070
+#define VENC_HS_EXT_START_STOP_X		0x0074
+#define VENC_VS_INT_START_X			0x0078
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y	0x007C
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X	0x0080
+#define VENC_VS_EXT_STOP_X_VS_EXT_START_Y	0x0084
+#define VENC_VS_EXT_STOP_Y			0x0088
+#define VENC_AVID_START_STOP_X			0x0090
+#define VENC_AVID_START_STOP_Y			0x0094
+#define VENC_FID_INT_START_X_FID_INT_START_Y	0x00A0
+#define VENC_FID_INT_OFFSET_Y_FID_EXT_START_X	0x00A4
+#define VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y	0x00A8
+#define VENC_TVDETGP_INT_START_STOP_X		0x00B0
+#define VENC_TVDETGP_INT_START_STOP_Y		0x00B4
+#define VENC_GEN_CTRL				0x00B8
+#define VENC_DAC_TST				0x00C4
+#define VENC_DAC				0x00C8
+
+/* VENC bit fields */
+#define VENC_FCONTROL_RESET			(1<<8)
+
+/* Rotation using VRFB */
+#define SMS_ROT_VIRT_BASE(context, degree)	(0x70000000 		\
+						| 0x4000000 * (context)	\
+						| 0x1000000 * (degree/90))
+#define	SMS_IMAGEHEIGHT_OFFSET			16
+#define	SMS_IMAGEWIDTH_OFFSET			0
+#define	SMS_PH_OFFSET				8
+#define	SMS_PW_OFFSET				4
+#define	SMS_PS_OFFSET				0
+
+#define SMS_PHYS        OMAP343X_SMS_BASE	/* 0x6C000000 */
+#define SMS_VIRT        (SMS_PHYS + IO_OFFSET)	/* 0xFC000000 */
+#define SMS_SIZE        SZ_1M
+
+#define SDRC_PHYS       OMAP343X_SDRC_BASE	/* 0x6D000000 */
+#define SDRC_VIRT       (SDRC_PHYS + IO_OFFSET)	/* 0xFD000000 */
+#define SDRC_SIZE       SZ_1M
+
+#define GPMC_PHYS       OMAP34XX_GPMC_BASE	/* 0x6E000000 */
+#define GPMC_VIRT       (GPMC_PHYS + IO_OFFSET)	/* 0xFE000000 */
+#define GPMC_SIZE       SZ_1M
+
+#define OMAP_SMS_BASE	SMS_PHYS
+
+#define	SMS_ROT0_PHYSICAL_BA(context)	__REG32(OMAP_SMS_BASE + 0x188 \
+						+ 0x10 * context)
+#define	SMS_ROT_CONTROL(context)	__REG32(OMAP_SMS_BASE + 0x180 \
+						+ 0x10 * context)
+#define	SMS_ROT0_SIZE(context)		__REG32(OMAP_SMS_BASE + 0x184 \
+						+ 0x10 * context)
+#define DSI_PROTO_ENG_REG_BASE		0x4804FC00
+#define DSI_PLL_CONTROLLER_REG_BASE	0x4804FF00
+
+/* DSI PHY registers */
+#define DSI_CLK_CTRL		0x54
+
+/* DSI PLL registers */
+#define DSI_PLL_CONTROL		0x00
+#define DSI_PLL_STATUS		0x04
+#define DSI_PLL_GO		0x08
+#define DSI_PLL_CONFIGURATION1	0x0C
+#define DSI_PLL_CONFIGURATION2	0x10
+
+/* Structure to store and restore the DSS registers */
+struct omap_dispc_regs {
+	u32 revision;		/* 0x000 */
+	u32 res1[3];
+	u32 sysconfig;		/* 0x010 */
+	u32 sysstatus;		/* 0x014 */
+	u32 irqstatus;		/* 0x018 */
+	u32 irqenable;		/* 0x01C */
+	u32 res2[8];
+	u32 control;		/* 0x040 */
+	u32 config;		/* 0x044 */
+	u32 capable;		/* 0x048 */
+	u32 default_color0;	/* 0x04C */
+	u32 default_color1;	/* 0x050 */
+	u32 trans_color0;	/* 0x054 */
+	u32 trans_color1;	/* 0x058 */
+	u32 line_status;	/* 0x05C */
+	u32 line_number;	/* 0x060 */
+	u32 timing_h;		/* 0x064 */
+	u32 timing_v;		/* 0x068 */
+	u32 pol_freq;		/* 0x06C */
+	u32 divisor;		/* 0x070 */
+	u32 global_alpha;	/* 0x074 */
+	u32 size_dig;		/* 0x078 */
+	u32 size_lcd;		/* 0x07C */
+	u32 gfx_ba0;		/* 0x080 */
+	u32 gfx_ba1;		/* 0x084 */
+	u32 gfx_position;	/* 0x088 */
+	u32 gfx_size;		/* 0x08C */
+	u32 res4[4];
+	u32 gfx_attributes;	/* 0x0A0 */
+	u32 gfx_fifo_threshold;	/* 0x0A4 */
+	u32 gfx_fifo_size;	/* 0x0A8 */
+	u32 gfx_row_inc;	/* 0x0AC */
+	u32 gfx_pixel_inc;	/* 0x0B0 */
+	u32 gfx_window_skip;	/* 0x0B4 */
+	u32 gfx_table_ba;	/* 0x0B8 */
+	u32 vid1_ba0;		/* 0x0BC */
+	u32 vid1_ba1;		/* 0x0C0 */
+	u32 vid1_position;	/* 0x0C4 */
+	u32 vid1_size;		/* 0x0C8 */
+	u32 vid1_attributes;	/* 0x0CC */
+	u32 vid1_fifo_threshold;	/* 0x0D0 */
+	u32 vid1_fifo_size;	/* 0x0D4 */
+	u32 vid1_row_inc;	/* 0x0D8 */
+	u32 vid1_pixel_inc;	/* 0x0DC */
+	u32 vid1_fir;		/* 0x0E0 */
+	u32 vid1_picture_size;	/* 0x0E4 */
+	u32 vid1_accu0;		/* 0x0E8 */
+	u32 vid1_accu1;		/* 0x0EC */
+	u32 vid1_fir_coef_h0;	/* 0x0F0 */
+	u32 vid1_fir_coef_hv0;	/* 0x0F4 */
+	u32 vid1_fir_coef_h1;	/* 0x0F8 */
+	u32 vid1_fir_coef_hv1;	/* 0x0FC */
+	u32 vid1_fir_coef_h2;	/* 0x100 */
+	u32 vid1_fir_coef_hv2;	/* 0x104 */
+	u32 vid1_fir_coef_h3;	/* 0x108 */
+	u32 vid1_fir_coef_hv3;	/* 0x10C */
+	u32 vid1_fir_coef_h4;	/* 0x110 */
+	u32 vid1_fir_coef_hv4;	/* 0x114 */
+	u32 vid1_fir_coef_h5;	/* 0x118 */
+	u32 vid1_fir_coef_hv5;	/* 0x11C */
+	u32 vid1_fir_coef_h6;	/* 0x120 */
+	u32 vid1_fir_coef_hv6;	/* 0x124 */
+	u32 vid1_fir_coef_h7;	/* 0x128 */
+	u32 vid1_fir_coef_hv7;	/* 0x12C */
+	u32 vid1_conv_coef0;	/* 0x130 */
+	u32 vid1_conv_coef1;	/* 0x134 */
+	u32 vid1_conv_coef2;	/* 0x138 */
+	u32 vid1_conv_coef3;	/* 0x13C */
+	u32 vid1_conv_coef4;	/* 0x140 */
+	u32 res5[2];
+	u32 vid2_ba0;		/* 0x14C */
+	u32 vid2_ba1;		/* 0x150 */
+	u32 vid2_position;	/* 0x154 */
+	u32 vid2_size;		/* 0x158 */
+	u32 vid2_attributes;	/* 0x15C */
+	u32 vid2_fifo_threshold;	/* 0x160 */
+	u32 vid2_fifo_size;	/* 0x164 */
+	u32 vid2_row_inc;	/* 0x168 */
+	u32 vid2_pixel_inc;	/* 0x16C */
+	u32 vid2_fir;		/* 0x170 */
+	u32 vid2_picture_size;	/* 0x174 */
+	u32 vid2_accu0;		/* 0x178 */
+	u32 vid2_accu1;		/* 0x17C */
+	u32 vid2_fir_coef_h0;	/* 0x180 */
+	u32 vid2_fir_coef_hv0;	/* 0x184 */
+	u32 vid2_fir_coef_h1;	/* 0x188 */
+	u32 vid2_fir_coef_hv1;	/* 0x18C */
+	u32 vid2_fir_coef_h2;	/* 0x190 */
+	u32 vid2_fir_coef_hv2;	/* 0x194 */
+	u32 vid2_fir_coef_h3;	/* 0x198 */
+	u32 vid2_fir_coef_hv3;	/* 0x19C */
+	u32 vid2_fir_coef_h4;	/* 0x1A0 */
+	u32 vid2_fir_coef_hv4;	/* 0x1A4 */
+	u32 vid2_fir_coef_h5;	/* 0x1A8 */
+	u32 vid2_fir_coef_hv5;	/* 0x1AC */
+	u32 vid2_fir_coef_h6;	/* 0x1B0 */
+	u32 vid2_fir_coef_hv6;	/* 0x1B4 */
+	u32 vid2_fir_coef_h7;	/* 0x1B8 */
+	u32 vid2_fir_coef_hv7;	/* 0x1BC */
+	u32 vid2_conv_coef0;	/* 0x1C0 */
+	u32 vid2_conv_coef1;	/* 0x1C4 */
+	u32 vid2_conv_coef2;	/* 0x1C8 */
+	u32 vid2_conv_coef3;	/* 0x1CC */
+	u32 vid2_conv_coef4;	/* 0x1D0 */
+	u32 data_cycle1;	/* 0x1D4 */
+	u32 data_cycle2;	/* 0x1D8 */
+	u32 data_cycle3;	/* 0x1DC */
+	u32 vid1_fir_coef_v0;	/* 0x1E0 */
+	u32 vid1_fir_coef_v1;	/* 0x1E4 */
+	u32 vid1_fir_coef_v2;	/* 0x1E8 */
+	u32 vid1_fir_coef_v3;	/* 0x1EC */
+	u32 vid1_fir_coef_v4;	/* 0x1F0 */
+	u32 vid1_fir_coef_v5;	/* 0x1F4 */
+	u32 vid1_fir_coef_v6;	/* 0x1F8 */
+	u32 vid1_fir_coef_v7;	/* 0x1FC */
+	u32 vid2_fir_coef_v0;	/* 0x200 */
+	u32 vid2_fir_coef_v1;	/* 0x204 */
+	u32 vid2_fir_coef_v2;	/* 0x208 */
+	u32 vid2_fir_coef_v3;	/* 0x20C */
+	u32 vid2_fir_coef_v4;	/* 0x210 */
+	u32 vid2_fir_coef_v5;	/* 0x214 */
+	u32 vid2_fir_coef_v6;	/* 0x218 */
+	u32 vid2_fir_coef_v7;	/* 0x21C */
+	u32 cpr_coef_r;		/* 0x220 */
+	u32 cpr_coef_g;		/* 0x224 */
+	u32 cpr_coef_b;		/* 0x228 */
+	u32 gfx_preload;	/* 0x22C */
+	u32 vid1_preload;	/* 0x230 */
+	u32 vid2_preload;	/* 0x234 */
+};
+
+/* WARN: read-only registers omitted! */
+struct omap_dss_regs {
+	u32 sysconfig;
+	u32 control;
+	u32 sdi_control;
+	u32 pll_control;
+	struct omap_dispc_regs dispc;
+};
+
+struct tvlcd_status_t {
+	int ltype;
+	int output_dev;
+	int status;
+};
+
+/* color space conversion matrices */
+const static short int cc_bt601[3][3] = { {298, 409, 0},
+{298, -208, -100},
+{298, 0, 517}
+};
+const static short int cc_bt709[3][3] = { {298, 459, 0},
+{298, -137, -55},
+{298, 0, 541}
+};
+const static short int cc_bt601_full[3][3] = { {256, 351, 0},
+{256, -179, -86},
+{256, 0, 443}
+};
+
+/*----------- following are exposed values and APIs -------------------------*/
+
+#define OMAP_GRAPHICS		0
+#define OMAP_VIDEO1		1
+#define OMAP_VIDEO2		2
+#define OMAP_DSS_GENERIC	3
+#define OMAP_DSS_DISPC_GENERIC	4
+#define DSS_CTX_NUMBER		(OMAP_DSS_DISPC_GENERIC + 1)
+
+#define OMAP_OUTPUT_LCD	4
+#define OMAP_OUTPUT_TV		5
+
+#define OMAP_DMA_0		0
+#define OMAP_DMA_1		1
+
+/* Dithering enable/disable */
+#define DITHERING_ON		28
+#define DITHERING_OFF		29
+
+/* TVOUT Definitions */
+enum omap_tvstandard {
+	PAL_BDGHI = 0,
+	PAL_NC,
+	PAL_N,
+	PAL_M,
+	PAL_60,
+	NTSC_M,
+	NTSC_J,
+	NTSC_443,
+};
+
+/* TV ref ON/OFF */
+#define TVREF_ON		30
+#define TVREF_OFF		31
+
+/* LCD data lines configuration */
+#define LCD_DATA_LINE_12BIT     32
+#define LCD_DATA_LINE_16BIT     33
+#define LCD_DATA_LINE_18BIT     34
+#define LCD_DATA_LINE_24BIT     35
+
+/* transparent color key types */
+#define OMAP_GFX_DESTINATION 	100
+#define OMAP_VIDEO_SOURCE	101
+
+/* SDRAM page size parameters used for VRFB settings */
+#define PAGE_WIDTH_EXP		5	/* page width = 1 << PAGE_WIDTH_EXP */
+#define PAGE_HEIGHT_EXP		5	/* page height = 1 << PAGE_HEIGHT_EXP */
+
+/* 2048 x 2048 is max res supported by OMAP display controller */
+#define MAX_PIXELS_PER_LINE	2048
+#define MAX_LINES		2048
+
+#define TV_OFF		   	0
+#define TV_ON		   	1
+#define LCD_OFF			0
+#define LCD_ON			1
+
+/* States needed for TV-LCD on the fly */
+#define TVLCD_STOP		1
+#define TVLCD_CONTINUE		2
+
+/* VRFB offset computation parameters */
+#define SIDE_H          1
+#define SIDE_W          0
+
+/* Color Conversion macros */
+#define FULL_COLOR_RANGE 	1
+#define CC_BT601	 	0
+#define CC_BT709		2
+#define CC_BT601_FULL		3
+
+/* GFX FIFO thresholds */
+#define RMODE_GFX_FIFO_HIGH_THRES       0x3FC
+#define RMODE_GFX_FIFO_LOW_THRES        0x3BC
+
+/* Data structures to communicate between HAL and driver files. */
+struct omap_video_params {
+	int video_layer;
+	unsigned long vid_position;
+	unsigned long vid_size;
+	unsigned long vid_picture_size;
+};
+struct omap_scaling_params {
+	int video_layer;
+	int win_height;
+	int win_width;
+	int crop_height;
+	int crop_width;
+	int flicker_filter;
+};
+struct omap_dma_params {
+	int video_layer;
+	int dma_num;
+	int row_inc_value;
+	int pixel_inc_value;
+};
+
+/* Color conversion matrix  */
+extern short int current_colorconv_values[2][3][3];
+
+/* Encoders and Outputs specific Definitions*/
+#define MAX_CHANNEL             2	/* No of Overlays */
+#define MAX_CHAR                20
+#define MAX_ENCODER_DEVICE      3
+#define MAX_MODE		10
+#define MAX_OUTPUT		3
+
+struct omap_encoder_device;
+
+struct omap_enc_output_ops {
+	int count;
+	char *(*enumoutput) (int index, void *data);
+	int (*setoutput) (int index, char *mode_name, void *data);
+	int (*getoutput) (void *data);
+};
+
+struct omap_enc_mode_ops {
+	int (*setmode) (char *mode_name, void *data);
+	char *(*getmode) (void *data);
+};
+
+struct omap_encoder_device {
+	u8 name[MAX_CHAR];
+	int channel_id;
+	struct omap_enc_output_ops *output_ops;
+	struct omap_enc_mode_ops *mode_ops;
+	int current_output;
+	int no_outputs;
+	int (*initialize) (void *data);
+	int (*deinitialize) (void *data);
+};
+
+struct channel_obj {
+	int channel_no;
+	int num_encoders;
+	struct omap_encoder_device *enc_devices[MAX_ENCODER_DEVICE];
+	int current_encoder;
+	int current_mode;
+};
+
+struct omap_mode_info {
+	char name[MAX_CHAR];
+	u32 width, height;
+	u32 clk_rate;
+	u32 clk_div;
+	u16 hfp, hbp, hsw;
+	u16 vfp, vbp, vsw;
+	void *priv_data;
+};
+struct omap_output_info {
+	char name[MAX_CHAR];
+	void *mode;
+	u8 no_modes;
+	u8 current_mode;
+	int data_lines;
+};
+
+/* input layer APIs */
+int omap_disp_request_layer(int ltype);
+void omap_disp_release_layer(int ltype);
+void omap_disp_disable_layer(int ltype);
+void omap_disp_enable_layer(int ltype);
+int omap_disp_reg_sync_bit(int output_dev);
+
+/* output device APIs */
+void omap_disp_get_panel_size(int output_dev, int *witdth, int *height);
+void omap_disp_set_panel_size(int output_dev, int witdth, int height);
+void omap_disp_disable_output_dev(int output_dev);
+void omap_disp_enable_output_dev(int output_dev);
+void omap_disp_set_dssfclk(void);
+void omap_disp_set_tvref(int tvref_state);
+int omap_disp_get_vrfb_offset(u32, u32, int);
+
+/* connection of input layers to output devices */
+int omap_disp_get_output_dev(int ltype);
+void omap_disp_set_dma_params(int ltype, int output_dev,
+			       u32 ba0, u32 ba1, u32 row_inc, u32 pix_inc);
+
+/* DSS power management */
+void omap_disp_get_dss(void);
+void omap_disp_put_dss(void);
+
+/* Color conversion */
+void omap_disp_set_default_colorconv(int ltype, int color_space);
+void omap_disp_set_colorconv(int v, int full_range_conversion);
+/* background color */
+void omap_disp_set_bg_color(int output_dev, int color);
+void omap_disp_get_bg_color(int output_dev, int *color);
+
+/* transparent color key */
+void omap_disp_set_colorkey(int output_dev, int key_type, int key_val);
+void omap_disp_get_colorkey(int output_dev, int *key_type, int *key_val);
+void omap_disp_enable_colorkey(int output_dev);
+void omap_disp_disable_colorkey(int output_dev);
+
+/* alpha blending */
+int omap_disp_get_alphablend(int output_dev);
+void omap_disp_set_alphablend(int output_dev, int value);
+unsigned char omap_disp_get_global_alphablend_value(int ltype);
+void omap_disp_set_global_alphablend_value(int ltype, int value);
+
+/* rotation APIs */
+int omap_disp_set_vrfb(int context, u32 phy_addr,
+			u32 width, u32 height, u32 bytes_per_pixel);
+
+/* display controller register synchronization */
+void omap_disp_reg_sync(int output_dev);
+int omap_disp_reg_sync_done(int output_dev);
+
+/* disable LCD and TV outputs and sync with next frame */
+void omap_disp_disable(unsigned long timeout_ticks);
+
+/* interrupt handling */
+typedef void (*omap_disp_isr_t) (void *arg, struct pt_regs *regs,
+				  u32 irqstatus);
+int omap_disp_register_isr(omap_disp_isr_t isr, void *arg,
+			    unsigned int mask);
+int omap_disp_unregister_isr(omap_disp_isr_t isr);
+int omap_disp_irqenable(omap_disp_isr_t isr, unsigned int mask);
+int omap_disp_irqdisable(omap_disp_isr_t isr, unsigned int mask);
+void omap_disp_save_initstate(int layer);
+
+/* clk functions */
+void omap_disp_put_all_clks(void);
+void omap_disp_get_all_clks(void);
+void omap_disp_start_video_layer(int);
+void omap_disp_set_addr(int ltype, u32 lcd_phys_addr, u32 tv_phys_addr_f0,
+			 u32 tv_phys_addr_f1);
+
+/* Video parameters functions */
+void omap_disp_set_vidattributes(unsigned int video_layer,
+				  unsigned int vid_attributes);
+void omap_disp_set_fifothreshold(unsigned int video_layer);
+void omap_disp_set_scaling(struct omap_scaling_params *scale_params);
+void omap_disp_set_vid_params(struct omap_video_params *vid_params);
+void set_dma_layer_parameters(int dma_num, int video_layer,
+			      int row_inc_value, int pixel_inc_value);
+void omap_disp_set_row_pix_inc_values(int video_layer, int row_inc_value,
+				       int pixel_inc_value);
+void set_crop_layer_parameters(int video_layer, int cropwidth,
+			       int cropheight);
+void omap_set_crop_layer_parameters(int video_layer, int cropwidth,
+				     int cropheight);
+
+/* Output and Standard releated functions */
+int omap_disp_set_mode(int ch_no, char *buffer);
+char *omap_disp_get_mode(int ch_no);
+int omap_disp_set_output(int ch_no, int index);
+int omap_disp_get_output(int ch_no, int *index);
+int omap_disp_enum_output(int ch_no, int index, char *name);
+
+/* Register/Unregister encoders */
+int omap_register_encoder(struct omap_encoder_device
+			   *encoder);
+int omap_unregister_encoder(struct omap_encoder_device
+			     *encoder);
+
+/*------------------ end of exposed values and APIs -------------------------*/
+
+#endif				/* __ASM_ARCH_OMAP_DISP_H */
diff --git a/arch/arm/plat-omap/omap-dss.c b/arch/arm/plat-omap/omap-dss.c
new file mode 100644
index 0000000..e9947e4
--- /dev/null
+++ b/arch/arm/plat-omap/omap-dss.c
@@ -0,0 +1,2248 @@
+/*
+ * arch/arm/plat-omap/omap-dss.c
+ *
+ * Copyright (C) 2005-2006 Texas Instruments, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ *
+ * THIS PACKAGE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
+ * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
+ * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ * Leveraged code from the OMAP24xx camera driver
+ * Video-for-Linux (Version 2) camera capture driver for
+ * the OMAP24xx camera controller.
+ *
+ * Author: Andy Lowe (source@mvista.com)
+ * Copyright (C) 2004 MontaVista Software, Inc.
+ *
+ * History:
+ * 20-APR-2006  Khasim		Modified VRFB based Rotation equations,
+ *				The image data is always read from 0 degree
+ *				view and written to the virtual space of desired
+ *				rotation angle
+ * MAY-2008	Brijesh J.	Added and Modified the interface for supporting
+ *		Hari N.		dynamic registering and de-registering of the
+ *		Hardik S.	the encoders to the overlay manager of DSS.
+ *		Vaibhav H.
+ */
+
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/err.h>
+#include <asm/system.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <mach/hardware.h>
+#include <mach/omap-dss.h>
+#include <asm/mach-types.h>
+#include <mach/clock.h>
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DEBUGP printk
+#else
+#define DEBUGP(fmt, a...)
+#endif
+
+/* usage count for DSS power management */
+static int disp_usage;
+static spinlock_t dss_lock;
+short int current_colorconv_values[2][3][3];
+EXPORT_SYMBOL(current_colorconv_values);
+static struct omap_dss_regs dss_ctx;
+
+static struct clk *dss1f_scale;
+static struct clk *dss1f, *dss1i;
+static int m_clk_rate = 24000000 * 4;
+
+struct omap_disp_dma_params {
+	u32 ba0;
+	u32 ba1;
+	int row_inc;
+	int pix_inc;
+};
+
+static struct layer_t {
+	int output_dev;
+	int in_use;
+	int ctx_valid;
+
+	/* one set of dma parameters each for LCD and TV */
+	struct omap_disp_dma_params dma[2];
+
+	int size_x;
+	int size_y;
+} layer[DSS_CTX_NUMBER] = {
+	{
+	.ctx_valid = 0,}, {
+	.ctx_valid = 0,}, {
+	.ctx_valid = 0,}, {
+	.ctx_valid = 0,}, {
+.ctx_valid = 0,},};
+
+#define MAX_ISR_NR   8
+static int omap_disp_irq;
+static struct {
+	omap_disp_isr_t isr;
+	void *arg;
+	unsigned int mask;
+} registered_isr[MAX_ISR_NR];
+
+/* Required function delcalarations */
+static void omap_disp_restore_ctx(int ltype);
+static void disp_save_ctx(int ltype);
+
+/*
+ * Modes and Encoders supported by DSS
+ */
+struct channel_obj channels[] = {
+	{0, 0, {NULL, NULL, NULL}, 0, 0},
+	{0, 0, {NULL, NULL, NULL}, 0, 3}
+};
+
+/* This mode structure lists all the modes supported by DSS
+ */
+struct omap_mode_info modes[] = {
+	{"ntsc_m", 720, 482, 0, 0, 0, 0, 0, 0, 0, 0, NULL},
+	{"ntsc_j", 720, 482, 0, 0, 0, 0, 0, 0, 0, 0, NULL},
+	{"ntsc_443", 720, 482, 0, 0, 0, 0, 0, 0, 0, 0, NULL},
+	{"pal_bdghi", 720, 574, 0, 0, 0, 0, 0, 0, 0, 0, NULL},
+	{"pal_nc", 720, 574, 0, 0, 0, 0, 0, 0, 0, 0, NULL},
+	{"pal_n", 720, 574, 0, 0, 0, 0, 0, 0, 0, 0, NULL},
+	{"pal_m", 720, 482, 0, 0, 0, 0, 0, 0, 0, 0, NULL},
+	{"pal_60", 720, 482, 0, 0, 0, 0, 0, 0, 0, 0, NULL}
+};
+
+/*
+ * DSS register I/O routines
+ */
+static inline u32 dss_reg_in(u32 offset)
+{
+	return omap_readl(DSS_REG_BASE + DSS_REG_OFFSET + offset);
+}
+static inline u32 dss_reg_out(u32 offset, u32 val)
+{
+	omap_writel(val, DSS_REG_BASE + DSS_REG_OFFSET + offset);
+	return val;
+}
+static inline u32 dss_reg_merge(u32 offset, u32 val, u32 mask)
+{
+	u32 addr = DSS_REG_BASE + DSS_REG_OFFSET + offset;
+	u32 new_val = (omap_readl(addr) & ~mask) | (val & mask);
+
+	omap_writel(new_val, addr);
+	return new_val;
+}
+
+/*
+ * Display controller register I/O routines
+ */
+static inline u32 dispc_reg_in(u32 offset)
+{
+	return omap_readl(DSS_REG_BASE + DISPC_REG_OFFSET + offset);
+}
+static inline u32 dispc_reg_out(u32 offset, u32 val)
+{
+	omap_writel(val, DSS_REG_BASE + DISPC_REG_OFFSET + offset);
+	return val;
+}
+static inline u32 dispc_reg_merge(u32 offset, u32 val, u32 mask)
+{
+	u32 addr = DSS_REG_BASE + DISPC_REG_OFFSET + offset;
+	u32 new_val = (omap_readl(addr) & ~mask) | (val & mask);
+
+	omap_writel(new_val, addr);
+	return new_val;
+}
+
+/*---------------------------------------------------------------------------*/
+/* Local Helper Functions */
+
+/* DSS Interrupt master service routine. */
+static irqreturn_t
+omap_disp_master_isr(int irq, void *arg, struct pt_regs *regs)
+{
+	unsigned long dispc_irqstatus = dispc_reg_in(DISPC_IRQSTATUS);
+	int i;
+
+	for (i = 0; i < MAX_ISR_NR; i++) {
+		if (registered_isr[i].isr == NULL)
+			continue;
+		if (registered_isr[i].mask & dispc_irqstatus)
+			registered_isr[i].isr(registered_isr[i].arg, regs,
+					      dispc_irqstatus);
+	}
+	/* ack the interrupt */
+	dispc_reg_out(DISPC_IRQSTATUS, dispc_irqstatus);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Sync Lost interrupt handler
+ */
+static void
+disp_synclost_isr(void *arg, struct pt_regs *regs, u32 irqstatus)
+{
+	u32 i;
+
+	struct omap_encoder_device *enc_dev;
+	i = 0;
+	printk(KERN_WARNING "Sync Lost %x\n",
+	       dispc_reg_in(DISPC_IRQSTATUS));
+	arg = NULL;
+	regs = NULL;
+
+	/*
+	 * Disable and Clear all the interrupts before we start
+	 */
+	dispc_reg_out(DISPC_IRQENABLE, 0x00000000);
+	dispc_reg_out(DISPC_IRQSTATUS, 0x0000FFFF);
+
+	/* disable the display controller */
+	omap_disp_disable(HZ / 2);
+
+	/*
+	 * Update the state of the display controller.
+	 */
+	dss_ctx.dispc.sysconfig &= ~DISPC_SYSCONFIG_SOFTRESET;
+	dss_ctx.dispc.control &= ~(DISPC_CONTROL_GODIGITAL);
+
+	dispc_reg_out(DISPC_SYSCONFIG, DISPC_SYSCONFIG_SOFTRESET);
+	while (!(dispc_reg_in(DISPC_SYSSTATUS) & DISPC_SYSSTATUS_RESETDONE)) {
+		udelay(100);
+		if (i++ > 5) {
+			printk(KERN_WARNING
+			       "Failed to soft reset the DSS !! \n");
+			break;
+		}
+	}
+
+	/* Configure the encoders for the default standard */
+	for (i = 0; i < ARRAY_SIZE(channels); i++) {
+		enc_dev = channels[i].enc_devices[channels[i].
+			current_encoder];
+		if (enc_dev && enc_dev->mode_ops->setmode)
+			enc_dev->mode_ops->setmode(modes[channels[i].
+				current_mode].name, enc_dev);
+	}
+	/* Restore the registers */
+	omap_disp_restore_ctx(OMAP_DSS_DISPC_GENERIC);
+	omap_disp_restore_ctx(OMAP_GRAPHICS);
+	omap_disp_restore_ctx(OMAP_VIDEO1);
+	omap_disp_restore_ctx(OMAP_VIDEO2);
+
+	/* enable the display controller */
+	if (layer[OMAP_DSS_DISPC_GENERIC].ctx_valid)
+		dispc_reg_out(DISPC_CONTROL, dss_ctx.dispc.control);
+
+	omap_disp_reg_sync(OMAP_OUTPUT_TV);
+
+}
+
+/*
+ * Save the DSS state before doing a GO LCD/DIGITAL
+ */
+static void disp_save_ctx(int ltype)
+{
+	int v1 = 0, v2 = 1;
+	struct omap_dispc_regs *dispc = &dss_ctx.dispc;
+
+	switch (ltype) {
+	case OMAP_DSS_GENERIC:
+		dss_ctx.sysconfig = dss_reg_in(DSS_SYSCONFIG);
+		dss_ctx.control = dss_reg_in(DSS_CONTROL);
+		if (cpu_is_omap34xx()) {
+			dss_ctx.sdi_control = dss_reg_in(DSS_SDI_CONTROL);
+			dss_ctx.pll_control = dss_reg_in(DSS_PLL_CONTROL);
+		}
+		break;
+
+	case OMAP_DSS_DISPC_GENERIC:
+		dispc->revision = dispc_reg_in(DISPC_REVISION);
+		dispc->sysconfig = dispc_reg_in(DISPC_SYSCONFIG);
+		dispc->sysstatus = dispc_reg_in(DISPC_SYSSTATUS);
+		dispc->irqstatus = dispc_reg_in(DISPC_IRQSTATUS);
+		dispc->irqenable = dispc_reg_in(DISPC_IRQENABLE);
+		dispc->control = dispc_reg_in(DISPC_CONTROL);
+		dispc->config = dispc_reg_in(DISPC_CONFIG);
+		dispc->capable = dispc_reg_in(DISPC_CAPABLE);
+		dispc->default_color0 = dispc_reg_in(DISPC_DEFAULT_COLOR0);
+		dispc->default_color1 = dispc_reg_in(DISPC_DEFAULT_COLOR1);
+		dispc->trans_color0 = dispc_reg_in(DISPC_TRANS_COLOR0);
+		dispc->trans_color1 = dispc_reg_in(DISPC_TRANS_COLOR1);
+		dispc->line_status = dispc_reg_in(DISPC_LINE_STATUS);
+		dispc->line_number = dispc_reg_in(DISPC_LINE_NUMBER);
+		dispc->data_cycle1 = dispc_reg_in(DISPC_DATA_CYCLE1);
+		dispc->data_cycle2 = dispc_reg_in(DISPC_DATA_CYCLE2);
+		dispc->data_cycle3 = dispc_reg_in(DISPC_DATA_CYCLE3);
+		dispc->timing_h = dispc_reg_in(DISPC_TIMING_H);
+		dispc->timing_v = dispc_reg_in(DISPC_TIMING_V);
+		dispc->pol_freq = dispc_reg_in(DISPC_POL_FREQ);
+		dispc->divisor = dispc_reg_in(DISPC_DIVISOR);
+		dispc->global_alpha = dispc_reg_in(DISPC_GLOBAL_ALPHA);
+		dispc->size_lcd = dispc_reg_in(DISPC_SIZE_LCD);
+		dispc->size_dig = dispc_reg_in(DISPC_SIZE_DIG);
+
+	case OMAP_VIDEO1:
+		dispc->vid1_ba0 = dispc_reg_in(DISPC_VID_BA0(v1));
+		dispc->vid1_ba1 = dispc_reg_in(DISPC_VID_BA0(v1));
+		dispc->vid1_position =
+		    dispc_reg_in(DISPC_VID_POSITION(v1));
+		dispc->vid1_size = dispc_reg_in(DISPC_VID_SIZE(v1));
+		dispc->vid1_attributes =
+		    dispc_reg_in(DISPC_VID_ATTRIBUTES(v1));
+		dispc->vid1_fifo_size =
+		    dispc_reg_in(DISPC_VID_FIFO_SIZE(v1));
+		dispc->vid1_fifo_threshold =
+		    dispc_reg_in(DISPC_VID_FIFO_THRESHOLD(v1));
+		dispc->vid1_row_inc = dispc_reg_in(DISPC_VID_ROW_INC(v1));
+		dispc->vid1_pixel_inc =
+		    dispc_reg_in(DISPC_VID_PIXEL_INC(v1));
+		dispc->vid1_fir = dispc_reg_in(DISPC_VID_FIR(v1));
+		dispc->vid1_accu0 = dispc_reg_in(DISPC_VID_ACCU0(v1));
+		dispc->vid1_accu1 = dispc_reg_in(DISPC_VID_ACCU1(v1));
+		dispc->vid1_picture_size =
+		    dispc_reg_in(DISPC_VID_PICTURE_SIZE(v1));
+		dispc->vid1_fir_coef_h0 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 0));
+		dispc->vid1_fir_coef_h1 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 1));
+		dispc->vid1_fir_coef_h2 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 2));
+		dispc->vid1_fir_coef_h3 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 3));
+		dispc->vid1_fir_coef_h4 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 4));
+		dispc->vid1_fir_coef_h5 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 5));
+		dispc->vid1_fir_coef_h6 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 6));
+		dispc->vid1_fir_coef_h7 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v1, 7));
+		dispc->vid1_fir_coef_hv0 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 0));
+		dispc->vid1_fir_coef_hv1 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 1));
+		dispc->vid1_fir_coef_hv2 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 2));
+		dispc->vid1_fir_coef_hv3 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 3));
+		dispc->vid1_fir_coef_hv4 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 4));
+		dispc->vid1_fir_coef_hv5 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 5));
+		dispc->vid1_fir_coef_hv6 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 6));
+		dispc->vid1_fir_coef_hv7 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v1, 7));
+		dispc->vid1_conv_coef0 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF0(v1));
+		dispc->vid1_conv_coef1 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF1(v1));
+		dispc->vid1_conv_coef2 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF2(v1));
+		dispc->vid1_conv_coef3 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF3(v1));
+		dispc->vid1_conv_coef4 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF4(v1));
+		break;
+
+	case OMAP_VIDEO2:
+		dispc->vid2_ba0 = dispc_reg_in(DISPC_VID_BA0(v2));
+		dispc->vid2_ba1 = dispc_reg_in(DISPC_VID_BA1(v2));
+		dispc->vid2_position =
+		    dispc_reg_in(DISPC_VID_POSITION(v2));
+		dispc->vid2_size = dispc_reg_in(DISPC_VID_SIZE(v2));
+		dispc->vid2_attributes =
+		    dispc_reg_in(DISPC_VID_ATTRIBUTES(v2));
+		dispc->vid2_fifo_size =
+		    dispc_reg_in(DISPC_VID_FIFO_SIZE(v2));
+		dispc->vid2_fifo_threshold =
+		    dispc_reg_in(DISPC_VID_FIFO_THRESHOLD(v2));
+		dispc->vid2_row_inc = dispc_reg_in(DISPC_VID_ROW_INC(v2));
+		dispc->vid2_pixel_inc =
+		    dispc_reg_in(DISPC_VID_PIXEL_INC(v2));
+		dispc->vid2_fir = dispc_reg_in(DISPC_VID_FIR(v2));
+		dispc->vid2_accu0 = dispc_reg_in(DISPC_VID_ACCU0(v2));
+		dispc->vid2_accu1 = dispc_reg_in(DISPC_VID_ACCU1(v2));
+		dispc->vid2_picture_size =
+		    dispc_reg_in(DISPC_VID_PICTURE_SIZE(v2));
+		dispc->vid2_fir_coef_h0 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 0));
+		dispc->vid2_fir_coef_h1 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 1));
+		dispc->vid2_fir_coef_h2 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 2));
+		dispc->vid2_fir_coef_h3 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 3));
+		dispc->vid2_fir_coef_h4 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 4));
+		dispc->vid2_fir_coef_h5 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 5));
+		dispc->vid2_fir_coef_h6 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 6));
+		dispc->vid2_fir_coef_h7 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_H(v2, 7));
+		dispc->vid2_fir_coef_hv0 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 0));
+		dispc->vid2_fir_coef_hv1 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 1));
+		dispc->vid2_fir_coef_hv2 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 2));
+		dispc->vid2_fir_coef_hv3 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 3));
+		dispc->vid2_fir_coef_hv4 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 4));
+		dispc->vid2_fir_coef_hv5 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 5));
+		dispc->vid2_fir_coef_hv6 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 6));
+		dispc->vid2_fir_coef_hv7 =
+		    dispc_reg_in(DISPC_VID_FIR_COEF_HV(v2, 7));
+		dispc->vid2_conv_coef0 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF0(v2));
+		dispc->vid2_conv_coef1 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF1(v2));
+		dispc->vid2_conv_coef2 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF2(v2));
+		dispc->vid2_conv_coef3 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF3(v2));
+		dispc->vid2_conv_coef4 =
+		    dispc_reg_in(DISPC_VID_CONV_COEF4(v2));
+		break;
+	}
+	layer[ltype].ctx_valid = 1;
+}
+
+void config_disp_clocks(int sleep_state)
+{
+	struct device *dev = NULL;
+
+	static int start = 1;
+	/*int (*clk_onoff)(struct clk *clk) = NULL; */
+	if (start) {
+
+		omap_disp_set_dssfclk();
+
+		dss1i = clk_get(dev, "dss_ick");
+		dss1f =
+		    clk_get(dev, cpu_is_omap34xx() ?
+				    "dss1_alwon_fck" : "dss1_fck");
+		if (IS_ERR(dss1i) || IS_ERR(dss1f)) {
+			printk(KERN_WARNING
+			       "Could not get DSS clocks  \n");
+			return;
+		}
+		start = 0;
+	}
+	if (sleep_state == 1) {
+		clk_disable(dss1i);
+		clk_disable(dss1f);
+	} else {
+		if (clk_enable(dss1i) != 0) {
+			printk(KERN_WARNING "Unable to enable DSS ICLK\n");
+			return;
+		}
+		if (clk_enable(dss1f) != 0) {
+			printk(KERN_WARNING "Unable to enable DSS FCLK\n");
+			return;
+		}
+	}
+}
+
+/* This function turns on/off the clocks needed for TV-out.
+ *  - 2430SDP: Controls the dss_54m_fck
+ *  - 3430SDP: Controls the dss_tv_fck
+ *  - 3430LAB: Controls both dss_tv_fck and dss_96m_fck.
+ *             By default Labrador turns off the 96MHz DAC clock for
+ *             power saving reasons.
+ */
+static void disp_ll_config_tv_clocks(int sleep_state)
+{
+	static int start = 1;
+	static struct clk *tv_clk;
+	static int disabled;
+	static int enabled;
+
+	if (start) {
+		if (machine_is_omap_2430sdp())
+			tv_clk = clk_get(NULL, "dss_54m_fck");
+		else if (machine_is_omap_3430sdp() || machine_is_omap3evm())
+			tv_clk = clk_get(NULL, "dss_tv_fck");
+
+		if (IS_ERR(tv_clk)) {
+			printk(KERN_WARNING "\n UNABLE to get dss TV fclk \n");
+			return;
+		}
+		start = 0;
+	}
+
+	if (sleep_state == 1) {
+		if (disabled == 0) {
+			clk_disable(tv_clk);
+			disabled = 1;
+		}
+		enabled = 0;
+	} else {
+		if (enabled == 0) {
+			if (clk_enable(tv_clk) != 0) {
+				printk(KERN_WARNING
+				       "\n UNABLE to enable dss TV fclk \n");
+				return;
+			}
+			enabled = 1;
+		}
+		disabled = 0;
+	}
+}
+
+/* Function used to find the VRFB Alignement */
+static inline u32 pages_per_side(u32 img_side, u32 page_exp)
+{
+	/*  page_side = 2 ^ page_exp
+	 * (page_side - 1) is added for rounding up
+	 */
+	return (u32) (img_side + (1 << page_exp) - 1) >> page_exp;
+}
+
+/* Update the color conversion matrix */
+static void update_colorconv_mtx(int v, const short int mtx[3][3])
+{
+	int i, j;
+	for (i = 0; i < 3; i++)
+		for (j = 0; j < 3; j++)
+			current_colorconv_values[v][i][j] = mtx[i][j];
+}
+
+/* Write the horizontal and vertical resizing coefficients to the display
+ * controller registers.  Each coefficient is a signed 8-bit integer in the
+ * range [-128, 127] except for the middle coefficient (vc[1][i] and hc[3][i])
+ * which is an unsigned 8-bit integer in the range [0, 255].  The first index of
+ * the matrix is the coefficient number (0 to 2 vertical or 0 to 4 horizontal)
+ * and the second index is the phase (0 to 7).
+ */
+void disp_set_resize(int v, short int *vc, short int *hc, int v_scale_dir)
+{
+	int i;
+	unsigned long reg;
+
+	for (i = 0; i < 8; i++) {
+		reg = (*(hc + (8 * 0) + i) & 0xff) |
+		    ((*(hc + (8 * 1) + i) & 0xff) << 8) |
+		    ((*(hc + (8 * 2) + i) & 0xff) << 16) |
+		    ((*(hc + (8 * 3) + i) & 0xff) << 24);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v, i), reg);
+
+		if (!v_scale_dir) {
+			reg = (*(hc + (8 * 4) + i) & 0xff) |
+			    ((*(vc + (1 * 8) + i) & 0xff) << 8) |
+			    ((*(vc + (8 * 2) + i) & 0xff) << 16) |
+			    ((*(vc + (3 * 8) + i) & 0xff) << 24);
+			dispc_reg_out(DISPC_VID_FIR_COEF_HV(v, i), reg);
+
+			reg = (*(vc + (8 * 0) + i) & 0xff) |
+				((*(vc + (4 * 8) + i) & 0xff) << 8);
+			dispc_reg_out(DISPC_VID_FIR_COEF_V(v, i), reg);
+		} else {
+			reg = (*(hc + (8 * 4) + i) & 0xff) |
+				((*(vc + (0 * 8) + i) & 0xff) << 8) |
+				((*(vc + (8 * 1) + i) & 0xff) << 16)|
+				((*(vc + (2 * 8) + i) & 0xff) << 24);
+			dispc_reg_out(DISPC_VID_FIR_COEF_HV(v, i), reg);
+		}
+	}
+}
+
+/* Configure the panel size in the DSS according
+ * to the mode selected in decoder
+ */
+int disp_set_dss_mode(int ch_no, int mode_index)
+{
+	struct omap_dispc_regs *dispc = &dss_ctx.dispc;
+	struct omap_mode_info *mode = NULL;
+	u32 size;
+
+	dispc->control = dispc_reg_in(DISPC_CONTROL);
+
+	mode = &modes[mode_index];
+
+	if (ch_no == 1) {
+		size = ((mode->width - 1) << DISPC_SIZE_DIG_PPL_SHIFT) &
+		    DISPC_SIZE_DIG_PPL;
+		size |= (((mode->height >> 1) - 1) << DISPC_SIZE_DIG_LPP_SHIFT)
+			& DISPC_SIZE_DIG_LPP;
+
+		dispc->size_dig = size;
+		dispc_reg_out(DISPC_SIZE_DIG, dispc->size_dig);
+	}
+
+	/* enable the display controller */
+	if (layer[OMAP_DSS_DISPC_GENERIC].ctx_valid)
+		dispc_reg_out(DISPC_CONTROL, dss_ctx.dispc.control);
+
+	omap_disp_reg_sync(OMAP_OUTPUT_TV);
+
+	dispc->size_dig = dispc_reg_in(DISPC_SIZE_DIG);
+
+	return 0;
+}
+
+/* Set the DSS register according to the output selected
+ */
+int disp_set_dss_output(int ch_no, char *buffer)
+{
+	/* Only supported output is S-Video */
+	if (ch_no == 1) {
+		/* Composite and S-Video Related Changes needs to be
+		   done here */
+	}
+	return 0;
+}
+
+/*---------------------------------------------------------------------------*/
+/* Exported Functions */
+
+/* Register the encoder with the DSS */
+int omap_register_encoder(struct omap_encoder_device
+			   *encoder)
+{
+	struct channel_obj *channel = &channels[encoder->channel_id];
+	int err = -EINVAL;
+	struct omap_encoder_device *enc_dev;
+
+	if (channel == NULL)
+		err = -EINVAL;
+	if (channel->num_encoders < MAX_ENCODER_DEVICE) {
+		channel->enc_devices[channel->num_encoders++] = encoder;
+		err = 0;
+	}
+	enc_dev = channel->enc_devices[channel->current_encoder];
+	if (channel->current_encoder == ((channel->num_encoders) - 1))
+		err = enc_dev->initialize(enc_dev);
+	return err;
+}
+EXPORT_SYMBOL(omap_register_encoder);
+/* omap_unregister_decoder : This function will be called by the decoder
+ * driver to un-register its functionalities.
+ */
+int omap_unregister_encoder(struct omap_encoder_device
+			     *encoder)
+{
+	int i, j = 0, err = 0;
+	struct channel_obj *channel = &channels[encoder->channel_id];
+
+	for (i = 0; i < channel->num_encoders; i++) {
+		if (encoder == channel->enc_devices[i]) {
+			if (channel->enc_devices[channel->current_encoder] ==
+			    encoder)
+				return -EBUSY;
+			channel->enc_devices[i] = NULL;
+			for (j = i; j < channel->num_encoders - 1; j++)
+				channel->enc_devices[j] =
+				    channel->enc_devices[j + 1];
+			channel->num_encoders--;
+			break;
+		}
+	}
+	return err;
+}
+EXPORT_SYMBOL(omap_unregister_encoder);
+
+/* Exported function to select the Mode in
+ * the current selected encoder
+ */
+int omap_disp_set_mode(int ch_no, char *buffer)
+{
+	struct omap_encoder_device *enc_dev = NULL;
+	struct omap_mode_info *mode;
+	int i;
+
+	if (ch_no >= MAX_CHANNEL || ch_no < 0)
+		return -EINVAL;
+
+	if (channels[ch_no].num_encoders <= 0)
+		return -EINVAL;
+	/* Check whether the mode is supported by DSS or not */
+	for (i = 0; i < ARRAY_SIZE(modes); i++) {
+		mode = &modes[i];
+		if (!(strcmp(mode->name, buffer)))
+			break;
+	}
+
+	if (i == ARRAY_SIZE(modes))
+		return -EINVAL;
+	/* Get the handle of the current encoder device */
+	enc_dev =
+	    channels[ch_no].enc_devices[channels[ch_no].current_encoder];
+	/* Set the mode in current encoder device  */
+	if (enc_dev->mode_ops->setmode)
+		if (enc_dev->mode_ops->setmode(buffer, enc_dev))
+			return -EINVAL;
+	/* Set the mode in DSS */
+	disp_set_dss_mode(ch_no, i);
+	channels[ch_no].current_mode = i;
+
+	return 0;
+}
+EXPORT_SYMBOL(omap_disp_set_mode);
+
+/* Exported function to Get the current selected mode */
+char *omap_disp_get_mode(int ch_no)
+{
+	struct omap_encoder_device *enc_dev;
+
+	if (channels[ch_no].num_encoders <= 0)
+		return NULL;
+	/* Get the handle of the current encoder device */
+	enc_dev =
+	    channels[ch_no].enc_devices[channels[ch_no].current_encoder];
+	/* Set the mode in current encoder device  */
+	if (enc_dev->mode_ops->getmode)
+		return enc_dev->mode_ops->getmode(enc_dev);
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(omap_disp_get_mode);
+
+/* Exported Function to enumerate all the outputs supported by DSS */
+int omap_disp_enum_output(int ch_no, int index, char *name)
+{
+	struct omap_encoder_device *enc_dev = NULL;
+	int index_count = 0;
+	int i, j;
+	char *str;
+
+	if (channels[ch_no].num_encoders <= 0)
+		return -EINVAL;
+	/* Reach the encoder from the list of encoders */
+	for (i = 0; i < channels[ch_no].num_encoders; i++) {
+		enc_dev = channels[ch_no].enc_devices[i];
+		index_count += enc_dev->no_outputs;
+		if (index_count > index)
+			break;
+	}
+	if (i == channels[ch_no].num_encoders)
+		return -EINVAL;
+
+	/* Get the output index number of the encoder; */
+	for (j = 0; j < i; j++) {
+		enc_dev = channels[ch_no].enc_devices[j];
+		index = index - enc_dev->no_outputs;
+	}
+
+	if (enc_dev->output_ops->enumoutput) {
+		str = enc_dev->output_ops->enumoutput(index, enc_dev);
+		strcpy(name, str);
+		return 0;
+	} else
+		return -EINVAL;
+}
+EXPORT_SYMBOL(omap_disp_enum_output);
+
+/* Exported function to set the particular output of the DSS
+ * It will iterate through all the encoders for setting the
+ * output
+ */
+int omap_disp_set_output(int ch_no, int index)
+{
+	struct omap_encoder_device *enc_dev = NULL, *prev_enc_dev = NULL;
+	int i, j, index_count = 0;
+	char mode_name[25], *str;
+
+	if (ch_no >= MAX_CHANNEL || ch_no < 0)
+		return -EINVAL;
+
+	/* Find the encoder for the requested output */
+	for (i = 0; i < channels[ch_no].num_encoders; i++) {
+		enc_dev = channels[ch_no].enc_devices[i];
+		index_count += enc_dev->no_outputs;
+		if (index_count > index)
+			break;
+	}
+
+	if (i == channels[ch_no].num_encoders)
+		return -EINVAL;
+	/* Find the index number of the encoder output */
+	for (j = 0; j < i; j++) {
+		enc_dev = channels[ch_no].enc_devices[j];
+		index = index - enc_dev->no_outputs;
+	}
+
+	/* Get the previous encoder device and de-initialize it */
+	prev_enc_dev =
+	    channels[ch_no].enc_devices[channels[ch_no].current_encoder];
+
+	if (prev_enc_dev->deinitialize)
+		prev_enc_dev->deinitialize(enc_dev);
+
+	/* Set the new encoder as the current encoder */
+	channels[ch_no].current_encoder = i;
+
+	str = enc_dev->output_ops->enumoutput(index, enc_dev);
+	disp_set_dss_output(ch_no, str);
+
+	/* Initialize the new encoder */
+	if (enc_dev->initialize)
+		enc_dev->initialize(enc_dev);
+	/* Set the output of the new encoder */
+	if (enc_dev->output_ops->setoutput)
+		if ((enc_dev->output_ops->setoutput(index, mode_name, enc_dev) <
+		     0))
+			return -EINVAL;
+
+	/* Set the DSS panel size according to the mode set in the
+	 * encoder for the selected output
+	 */
+	for (i = 0; i < ARRAY_SIZE(modes); i++) {
+		if (!(strcmp(modes[i].name, mode_name))) {
+			disp_set_dss_mode(ch_no, i);
+			channels[ch_no].current_mode = i;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(omap_disp_set_output);
+
+/* Exported Function to get the output of DSS */
+int omap_disp_get_output(int ch_no, int *index)
+{
+	struct omap_encoder_device *enc_dev;
+	int i;
+	int enc_index = 0;
+
+	if (channels[ch_no].num_encoders <= 0)
+		return -EINVAL;
+	enc_dev =
+	    channels[ch_no].enc_devices[channels[ch_no].current_encoder];
+
+	for (i = 0; i < channels[ch_no].current_encoder; i++) {
+		 enc_index +=
+			channels[ch_no].enc_devices[i]->no_outputs;
+	}
+	enc_index += enc_dev->current_output;
+	*index = enc_index;
+
+	if (enc_dev->output_ops->getoutput)
+		return enc_dev->output_ops->getoutput(enc_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL(omap_disp_get_output);
+/*---------------------------------------------------------------------------*/
+/* Exported Functions */
+/*
+ * Functions for setting video attributes
+ */
+void omap_disp_set_vidattributes(unsigned int video_layer,
+				  unsigned int vid_attributes)
+{
+	dispc_reg_out(DISPC_VID_ATTRIBUTES(video_layer), vid_attributes);
+}
+EXPORT_SYMBOL(omap_disp_set_vidattributes);
+
+/* Function for setting the DMS threshold */
+void omap_disp_set_fifothreshold(unsigned int video_layer)
+{
+	/* Set FIFO threshold to 0xFF (high) and 0xFF -
+	 *(16x4bytes) = 0xC0 (low)
+	 * dispc_reg_out(DISPC_VID_FIFO_THRESHOLD(v),0x00FF00C0);
+	 */
+	dispc_reg_out(DISPC_VID_FIFO_THRESHOLD(video_layer), 0x03FC03BC);
+}
+EXPORT_SYMBOL(omap_disp_set_fifothreshold);
+
+/* Set the scaling parameters */
+void omap_disp_set_scaling(struct omap_scaling_params *scale_params)
+{
+	unsigned long firvinc, firhinc;
+	int v_scale_dir = 0;
+
+	/* horizontal upscale resizing matrix */
+	const static short int hc_u[5][8] =
+	{ { 0, 0, -1, -2, -9, -5, -2, -1 },
+	{ 0, -8, -11, -11, 73, 51, 30, 13 },
+	{ 128, 124, 112, 95, 73, 95, 112, 124 },
+	{ 0, 13, 30, 51, -9, -11, -11, -8 },
+	{ 0, -1, -2, -5, 0, -2, 1, 0 }
+	};
+	/* Vertical upscale resizing matrix */
+	const static short int vc_u[3][8] =
+	{ { 0, 2, 5, 7, 64, 32, 12, 3 },
+	{ 128, 123, 111, 89, 64, 89, 111, 123 },
+	{ 0, 3, 12, 32, 0, 7, 5, 2 }
+	  };
+	/* Vertical downscale resizing matrix */
+	const static short int vc_d[3][8] =
+	    { { 36, 31, 27, 23, 55, 50, 45, 40 },
+	{ 56, 57, 56, 55, 55, 55, 56, 57 },
+	{ 36, 40, 45, 50, 18, 23, 27, 31 }
+	};
+	/* horizontal down scale resizing matrix */
+	const static short int hc_d[5][8] =
+	    { { 0, -2, -5, -7, 17, 12, 8, 4 },
+	{ 36, 31, 27, 22, 51, 48, 44, 40 },
+	{ 56, 55, 54,  53,  52,  53, 54, 55 },
+	{ 36, 40, 44, 48, 17, 22, 27, 31},
+	{ 0, 4, 8, -12, -9, -7, -5, -2 }
+	};
+
+	short int *vc = (short int *) vc_u;
+	short int *hc = (short int *) hc_u;
+
+	if (scale_params->win_width < scale_params->crop_width)
+		hc = (short int *) hc_d;
+	if (scale_params->win_height < scale_params->crop_height
+	    || scale_params->flicker_filter == 1) {
+		vc = (short int *) vc_d;
+		v_scale_dir = 1;
+	}
+	disp_set_resize(scale_params->video_layer, vc, hc, v_scale_dir);
+
+	dispc_reg_out(DISPC_VID_ACCU0(scale_params->video_layer), 0);
+	if (scale_params->flicker_filter == 1)
+		dispc_reg_out(DISPC_VID_ACCU1(scale_params->video_layer),
+			      0x01000000);
+	else
+		dispc_reg_out(DISPC_VID_ACCU1(scale_params->video_layer),
+			      0);
+	firhinc = (1024 * (scale_params->crop_width - 1))
+	    / (scale_params->win_width - 1);
+	if (firhinc < 1)
+		firhinc = 1;
+	else if (firhinc > 2047)
+		firhinc = 2047;
+	firvinc = (1024 * (scale_params->crop_height - 1))
+	    / (scale_params->win_height - 1);
+	if (firvinc < 1)
+		firvinc = 1;
+	else if (firvinc > 2047)
+		firvinc = 2047;
+
+	if (scale_params->flicker_filter == 0)
+		dispc_reg_out(DISPC_VID_FIR(scale_params->video_layer),
+			      firhinc | (firvinc << 16));
+	else
+		dispc_reg_out(DISPC_VID_FIR(scale_params->video_layer),
+			      0x08000000);
+}
+EXPORT_SYMBOL(omap_disp_set_scaling);
+
+/* Set the video parameters */
+void omap_disp_set_vid_params(struct omap_video_params *vid_params)
+{
+	dispc_reg_out(DISPC_VID_SIZE(vid_params->video_layer),
+		      vid_params->vid_size);
+	dispc_reg_out(DISPC_VID_PICTURE_SIZE(vid_params->video_layer),
+		      vid_params->vid_picture_size);
+	dispc_reg_out(DISPC_VID_POSITION(vid_params->video_layer),
+		      vid_params->vid_position);
+}
+EXPORT_SYMBOL(omap_disp_set_vid_params);
+
+/* Set the row increment and pixel increment values */
+void omap_disp_set_row_pix_inc_values(int video_layer, int row_inc_value,
+				       int pixel_inc_value)
+{
+	dispc_reg_out(DISPC_VID_ROW_INC(video_layer), row_inc_value);
+	dispc_reg_out(DISPC_VID_PIXEL_INC(video_layer), pixel_inc_value);
+}
+EXPORT_SYMBOL(omap_disp_set_row_pix_inc_values);
+
+/* Set the cropping parameters in the software structure */
+void omap_set_crop_layer_parameters(int video_layer, int cropwidth,
+				     int cropheight)
+{
+	layer[video_layer].size_x = cropwidth;
+	layer[video_layer].size_y = cropheight;
+}
+EXPORT_SYMBOL(omap_set_crop_layer_parameters);
+
+/* Write the color space conversion coefficients to the display controller
+ * registers.  Each coefficient is a signed 11-bit integer in the range
+ * [-1024, 1023].  The matrix coefficients are:
+ *	[ RY  RCr  RCb ]
+ *	[ GY  GCr  GCb ]
+ *	[ BY  BCr  BCb ]
+ */
+
+void omap_disp_set_colorconv(int v, int full_range_conversion)
+{
+	unsigned long ccreg;
+	short int mtx[3][3];
+	int i, j;
+	for (i = 0; i < 3; i++)
+		for (j = 0; j < 3; j++)
+			mtx[i][j] = current_colorconv_values[v][i][j];
+	ccreg = (mtx[0][0] & 0x7ff) | ((mtx[0][1] & 0x7ff) << 16);
+	dispc_reg_out(DISPC_VID_CONV_COEF0(v), ccreg);
+	ccreg = (mtx[0][2] & 0x7ff) | ((mtx[1][0] & 0x7ff) << 16);
+	dispc_reg_out(DISPC_VID_CONV_COEF1(v), ccreg);
+	ccreg = (mtx[1][1] & 0x7ff) | ((mtx[1][2] & 0x7ff) << 16);
+	dispc_reg_out(DISPC_VID_CONV_COEF2(v), ccreg);
+	ccreg = (mtx[2][0] & 0x7ff) | ((mtx[2][1] & 0x7ff) << 16);
+	dispc_reg_out(DISPC_VID_CONV_COEF3(v), ccreg);
+	ccreg = mtx[2][2] & 0x7ff;
+	dispc_reg_out(DISPC_VID_CONV_COEF4(v), ccreg);
+
+	if (full_range_conversion) {
+		dispc_reg_merge(DISPC_VID_ATTRIBUTES(v),
+				DISPC_VID_ATTRIBUTES_VIDFULLRANGE,
+				DISPC_VID_ATTRIBUTES_VIDFULLRANGE);
+	}
+
+}
+EXPORT_SYMBOL(omap_disp_set_colorconv);
+
+void omap_disp_set_default_colorconv(int ltype, int color_space)
+{
+	int v;
+
+	if (ltype == OMAP_VIDEO1)
+		v = 0;
+	else if (ltype == OMAP_VIDEO2)
+		v = 1;
+	else
+		return;
+
+	switch (color_space) {
+	case CC_BT601:
+		/* luma (Y) range lower limit is 16, BT.601 standard */
+		update_colorconv_mtx(v, cc_bt601);
+		omap_disp_set_colorconv(v, !FULL_COLOR_RANGE);
+		break;
+	case CC_BT709:
+		/* luma (Y) range lower limit is 16, BT.709 standard */
+		update_colorconv_mtx(v, cc_bt709);
+		omap_disp_set_colorconv(v, !FULL_COLOR_RANGE);
+		break;
+	case CC_BT601_FULL:
+		/* full luma (Y) range, assume BT.601 standard */
+		update_colorconv_mtx(v, cc_bt601_full);
+		omap_disp_set_colorconv(v, FULL_COLOR_RANGE);
+		break;
+	}
+}
+EXPORT_SYMBOL(omap_disp_set_default_colorconv);
+
+void omap_disp_get_panel_size(int output_dev, int *width, int *height)
+{
+	unsigned long size;
+
+	if (output_dev == OMAP_OUTPUT_TV) {
+		size = dispc_reg_in(DISPC_SIZE_DIG);
+		*width = 1 + ((size & DISPC_SIZE_DIG_PPL)>>
+				DISPC_SIZE_DIG_PPL_SHIFT);
+		*height = 1 + ((size & DISPC_SIZE_DIG_LPP) >>
+				DISPC_SIZE_DIG_LPP_SHIFT);
+		*height = *height << 1;
+	}
+}
+EXPORT_SYMBOL(omap_disp_get_panel_size);
+
+void omap_disp_set_panel_size(int output_dev, int width, int height)
+{
+	unsigned long size;
+
+	if (output_dev == OMAP_OUTPUT_TV) {
+		height = height >> 1;
+		size = ((width - 1) << DISPC_SIZE_DIG_PPL_SHIFT) &
+			DISPC_SIZE_DIG_PPL;
+		size |= ((height - 1) << DISPC_SIZE_DIG_LPP_SHIFT)&
+			DISPC_SIZE_DIG_LPP;
+		dispc_reg_out(DISPC_SIZE_DIG, size);
+	}
+}
+EXPORT_SYMBOL(omap_disp_set_panel_size);
+
+/* Turn off the video1, or video2 layer. */
+void omap_disp_disable_layer(int ltype)
+{
+	unsigned long attributes;
+	int digital, v;
+
+	if (ltype == OMAP_VIDEO1)
+		v = 0;
+	else if (ltype == OMAP_VIDEO2)
+		v = 1;
+	else
+		return;
+
+	attributes = dispc_reg_merge(DISPC_VID_ATTRIBUTES(v), 0,
+				     DISPC_VID_ATTRIBUTES_ENABLE);
+	digital = attributes & DISPC_VID_ATTRIBUTES_VIDCHANNELOUT;
+
+	if (digital) {
+		/* digital output */
+		dispc_reg_merge(DISPC_CONTROL, DISPC_CONTROL_GODIGITAL,
+				DISPC_CONTROL_GODIGITAL);
+	}
+	dispc_reg_merge(DISPC_CONTROL, 0,
+			DISPC_CONTROL_OVERLAYOPTIMIZATION);
+}
+EXPORT_SYMBOL(omap_disp_disable_layer);
+
+/* Turn on the GFX, or video1, or video2 layer. */
+void omap_disp_enable_layer(int ltype)
+{
+	unsigned long attributes;
+	int digital, v;
+
+	if (ltype == OMAP_VIDEO1)
+		v = 0;
+	else if (ltype == OMAP_VIDEO2)
+		v = 1;
+	else
+		return;
+
+	attributes = dispc_reg_merge(DISPC_VID_ATTRIBUTES(v),
+				     DISPC_VID_ATTRIBUTES_ENABLE,
+				     DISPC_VID_ATTRIBUTES_ENABLE);
+	digital = attributes & DISPC_VID_ATTRIBUTES_VIDCHANNELOUT;
+
+	if (digital) {
+		/* digital output */
+		dispc_reg_merge(DISPC_CONTROL, DISPC_CONTROL_GODIGITAL,
+				DISPC_CONTROL_GODIGITAL);
+	}
+}
+EXPORT_SYMBOL(omap_disp_enable_layer);
+
+void omap_disp_save_initstate(int ltype)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dss_lock, flags);
+	disp_save_ctx(ltype);
+	spin_unlock_irqrestore(&dss_lock, flags);
+}
+EXPORT_SYMBOL(omap_disp_save_initstate);
+
+/*
+ *  NOte, that VENC registers are not restored here
+ *  Note, that DISPC_CONTROL register is not restored here
+ */
+static void omap_disp_restore_ctx(int ltype)
+{
+	int v1 = 0, v2 = 1;
+	struct omap_dispc_regs *dispc = &dss_ctx.dispc;
+
+	if (layer[ltype].ctx_valid == 0)
+		return;
+
+	switch (ltype) {
+	case OMAP_DSS_GENERIC:
+		dss_reg_out(DSS_SYSCONFIG, dss_ctx.sysconfig);
+		dss_reg_out(DSS_CONTROL, dss_ctx.control);
+		if (cpu_is_omap34xx()) {
+			dss_reg_out(DSS_SDI_CONTROL, dss_ctx.sdi_control);
+			dss_reg_out(DSS_PLL_CONTROL, dss_ctx.pll_control);
+		}
+		break;
+
+	case OMAP_DSS_DISPC_GENERIC:
+		dispc_reg_out(DISPC_SYSCONFIG, dispc->sysconfig);
+		dispc_reg_out(DISPC_IRQENABLE, dispc->irqenable);
+		dispc_reg_out(DISPC_CONFIG, dispc->config);
+		dispc_reg_out(DISPC_DEFAULT_COLOR0, dispc->default_color0);
+		dispc_reg_out(DISPC_DEFAULT_COLOR1, dispc->default_color1);
+		dispc_reg_out(DISPC_TRANS_COLOR0, dispc->trans_color0);
+		dispc_reg_out(DISPC_TRANS_COLOR1, dispc->trans_color1);
+		dispc_reg_out(DISPC_LINE_NUMBER, dispc->line_number);
+		dispc_reg_out(DISPC_DATA_CYCLE1, dispc->data_cycle1);
+		dispc_reg_out(DISPC_DATA_CYCLE2, dispc->data_cycle2);
+		dispc_reg_out(DISPC_DATA_CYCLE3, dispc->data_cycle3);
+		dispc_reg_out(DISPC_TIMING_H, dispc->timing_h);
+		dispc_reg_out(DISPC_TIMING_V, dispc->timing_v);
+		dispc_reg_out(DISPC_POL_FREQ, dispc->pol_freq);
+		dispc_reg_out(DISPC_DIVISOR, dispc->divisor);
+		dispc_reg_out(DISPC_GLOBAL_ALPHA, dispc->global_alpha);
+		dispc_reg_out(DISPC_SIZE_LCD, dispc->size_lcd);
+		dispc_reg_out(DISPC_SIZE_DIG, dispc->size_dig);
+		break;
+
+	case OMAP_GRAPHICS:
+		dispc_reg_out(DISPC_GFX_BA0, dispc->gfx_ba0);
+		dispc_reg_out(DISPC_GFX_BA1, dispc->gfx_ba1);
+		dispc_reg_out(DISPC_GFX_POSITION, dispc->gfx_position);
+		dispc_reg_out(DISPC_GFX_SIZE, dispc->gfx_size);
+		dispc_reg_out(DISPC_GFX_ATTRIBUTES, dispc->gfx_attributes);
+		dispc_reg_out(DISPC_GFX_FIFO_SIZE, dispc->gfx_fifo_size);
+		dispc_reg_out(DISPC_GFX_FIFO_THRESHOLD,
+			      dispc->gfx_fifo_threshold);
+		dispc_reg_out(DISPC_GFX_ROW_INC, dispc->gfx_row_inc);
+		dispc_reg_out(DISPC_GFX_PIXEL_INC, dispc->gfx_pixel_inc);
+		dispc_reg_out(DISPC_GFX_WINDOW_SKIP,
+			      dispc->gfx_window_skip);
+		dispc_reg_out(DISPC_GFX_TABLE_BA, dispc->gfx_table_ba);
+		break;
+
+	case OMAP_VIDEO1:
+		dispc_reg_out(DISPC_VID_BA0(v1), dispc->vid1_ba0);
+		dispc_reg_out(DISPC_VID_BA1(v1), dispc->vid1_ba1);
+		dispc_reg_out(DISPC_VID_POSITION(v1),
+			      dispc->vid1_position);
+		dispc_reg_out(DISPC_VID_SIZE(v1), dispc->vid1_size);
+		dispc_reg_out(DISPC_VID_ATTRIBUTES(v1),
+			      dispc->vid1_attributes);
+		dispc_reg_out(DISPC_VID_FIFO_THRESHOLD(v1),
+			      dispc->vid1_fifo_threshold);
+		dispc_reg_out(DISPC_VID_ROW_INC(v1), dispc->vid1_row_inc);
+		dispc_reg_out(DISPC_VID_PIXEL_INC(v1),
+			      dispc->vid1_pixel_inc);
+		dispc_reg_out(DISPC_VID_FIR(v1), dispc->vid1_fir);
+		dispc_reg_out(DISPC_VID_ACCU0(v1), dispc->vid1_accu0);
+		dispc_reg_out(DISPC_VID_ACCU1(v1), dispc->vid1_accu1);
+		dispc_reg_out(DISPC_VID_PICTURE_SIZE(v1),
+			      dispc->vid1_picture_size);
+
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 0),
+			      dispc->vid1_fir_coef_h0);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 1),
+			      dispc->vid1_fir_coef_h1);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 2),
+			      dispc->vid1_fir_coef_h2);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 3),
+			      dispc->vid1_fir_coef_h3);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 4),
+			      dispc->vid1_fir_coef_h4);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 5),
+			      dispc->vid1_fir_coef_h5);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 6),
+			      dispc->vid1_fir_coef_h6);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v1, 7),
+			      dispc->vid1_fir_coef_h7);
+
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 0),
+			      dispc->vid1_fir_coef_hv0);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 1),
+			      dispc->vid1_fir_coef_hv1);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 2),
+			      dispc->vid1_fir_coef_hv2);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 3),
+			      dispc->vid1_fir_coef_hv3);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 4),
+			      dispc->vid1_fir_coef_hv4);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 5),
+			      dispc->vid1_fir_coef_hv5);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 6),
+			      dispc->vid1_fir_coef_hv6);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v1, 7),
+			      dispc->vid1_fir_coef_hv7);
+
+		dispc_reg_out(DISPC_VID_CONV_COEF0(v1),
+			      dispc->vid1_conv_coef0);
+		dispc_reg_out(DISPC_VID_CONV_COEF1(v1),
+			      dispc->vid1_conv_coef1);
+		dispc_reg_out(DISPC_VID_CONV_COEF2(v1),
+			      dispc->vid1_conv_coef2);
+		dispc_reg_out(DISPC_VID_CONV_COEF3(v1),
+			      dispc->vid1_conv_coef3);
+		dispc_reg_out(DISPC_VID_CONV_COEF4(v1),
+			      dispc->vid1_conv_coef4);
+		break;
+
+	case OMAP_VIDEO2:
+		dispc_reg_out(DISPC_VID_BA0(v2), dispc->vid2_ba0);
+		dispc_reg_out(DISPC_VID_BA1(v2), dispc->vid2_ba1);
+		dispc_reg_out(DISPC_VID_POSITION(v2),
+			      dispc->vid2_position);
+		dispc_reg_out(DISPC_VID_SIZE(v2), dispc->vid2_size);
+		dispc_reg_out(DISPC_VID_ATTRIBUTES(v2),
+			      dispc->vid2_attributes);
+		dispc_reg_out(DISPC_VID_FIFO_THRESHOLD(v2),
+			      dispc->vid2_fifo_threshold);
+		dispc_reg_out(DISPC_VID_ROW_INC(v2), dispc->vid2_row_inc);
+		dispc_reg_out(DISPC_VID_PIXEL_INC(v2),
+			      dispc->vid2_pixel_inc);
+		dispc_reg_out(DISPC_VID_FIR(v2), dispc->vid2_fir);
+		dispc_reg_out(DISPC_VID_ACCU0(v2), dispc->vid2_accu0);
+		dispc_reg_out(DISPC_VID_ACCU1(v2), dispc->vid2_accu1);
+		dispc_reg_out(DISPC_VID_PICTURE_SIZE(v2),
+			      dispc->vid2_picture_size);
+
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 0),
+			      dispc->vid2_fir_coef_h0);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 1),
+			      dispc->vid2_fir_coef_h1);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 2),
+			      dispc->vid2_fir_coef_h2);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 3),
+			      dispc->vid2_fir_coef_h3);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 4),
+			      dispc->vid2_fir_coef_h4);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 5),
+			      dispc->vid2_fir_coef_h5);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 6),
+			      dispc->vid2_fir_coef_h6);
+		dispc_reg_out(DISPC_VID_FIR_COEF_H(v2, 7),
+			      dispc->vid2_fir_coef_h7);
+
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 0),
+			      dispc->vid2_fir_coef_hv0);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 1),
+			      dispc->vid2_fir_coef_hv1);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 2),
+			      dispc->vid2_fir_coef_hv2);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 3),
+			      dispc->vid2_fir_coef_hv3);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 4),
+			      dispc->vid2_fir_coef_hv4);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 5),
+			      dispc->vid2_fir_coef_hv5);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 6),
+			      dispc->vid2_fir_coef_hv6);
+		dispc_reg_out(DISPC_VID_FIR_COEF_HV(v2, 7),
+			      dispc->vid2_fir_coef_hv7);
+
+		dispc_reg_out(DISPC_VID_CONV_COEF0(v2),
+			      dispc->vid2_conv_coef0);
+		dispc_reg_out(DISPC_VID_CONV_COEF1(v2),
+			      dispc->vid2_conv_coef1);
+		dispc_reg_out(DISPC_VID_CONV_COEF2(v2),
+			      dispc->vid2_conv_coef2);
+		dispc_reg_out(DISPC_VID_CONV_COEF3(v2),
+			      dispc->vid2_conv_coef3);
+		dispc_reg_out(DISPC_VID_CONV_COEF4(v2),
+			      dispc->vid2_conv_coef4);
+		break;
+	}
+}
+
+int omap_disp_get_vrfb_offset(u32 img_len, u32 bytes_per_pixel, int side)
+{
+	int page_width_exp, page_height_exp, pixel_size_exp, offset = 0;
+
+	/* Maximum supported is 4 bytes (RGB32) */
+	if (bytes_per_pixel > 4)
+		return -EINVAL;
+
+	page_width_exp = PAGE_WIDTH_EXP;
+	page_height_exp = PAGE_HEIGHT_EXP;
+	pixel_size_exp = bytes_per_pixel >> 1;
+
+	if (side == SIDE_W) {
+		offset = ((1 << page_width_exp) *
+		(pages_per_side(img_len * bytes_per_pixel, page_width_exp)))
+		>> pixel_size_exp;	/* in pixels */
+	} else {
+		offset = (1 << page_height_exp) *
+		    (pages_per_side(img_len, page_height_exp));
+	}
+
+	return offset;
+}
+EXPORT_SYMBOL(omap_disp_get_vrfb_offset);
+
+void
+omap_disp_set_addr(int ltype, u32 lcd_phys_addr, u32 tv_phys_addr_f0,
+		    u32 tv_phys_addr_f1)
+{
+	int v;
+	v = (ltype == OMAP_VIDEO1) ? 0 : 1;
+	layer[ltype].dma[0].ba0 = lcd_phys_addr;
+	layer[ltype].dma[0].ba1 = lcd_phys_addr;
+
+	/*
+	 * Store BA0 BA1 for TV, BA1 points to the alternate row
+	 */
+	layer[ltype].dma[1].ba0 = tv_phys_addr_f0;
+	layer[ltype].dma[1].ba1 = tv_phys_addr_f1;
+
+	dispc_reg_out(DISPC_VID_BA0(v), tv_phys_addr_f0);
+
+	if (omap_disp_get_output_dev(ltype) == OMAP_OUTPUT_TV) {
+		dispc_reg_out(DISPC_VID_BA0(v), layer[ltype].dma[1].ba0);
+		dispc_reg_out(DISPC_VID_BA1(v), layer[ltype].dma[1].ba1);
+		dispc_reg_merge(DISPC_VID_ATTRIBUTES(v),
+				DISPC_VID_ATTRIBUTES_ENABLE,
+				DISPC_VID_ATTRIBUTES_ENABLE);
+		dispc_reg_merge(DISPC_CONTROL, DISPC_CONTROL_GODIGITAL,
+				DISPC_CONTROL_GODIGITAL);
+	}
+}
+EXPORT_SYMBOL(omap_disp_set_addr);
+
+void omap_disp_start_video_layer(int ltype)
+{
+
+	if (ltype != OMAP_VIDEO1 && ltype != OMAP_VIDEO2)
+		return;
+
+	/* Enable the Video layer and set the Go Bit */
+	omap_disp_enable_layer(ltype);
+}
+EXPORT_SYMBOL(omap_disp_start_video_layer);
+
+/* Many display controller registers are shadowed. Setting the GO bit causes
+ * changes to these registers to take effect in hardware.
+ */
+void omap_disp_reg_sync(int output_dev)
+{
+	unsigned long timeout;
+	if (output_dev == OMAP_OUTPUT_LCD)
+		dispc_reg_merge(DISPC_CONTROL, DISPC_CONTROL_GOLCD,
+				DISPC_CONTROL_GOLCD);
+	else
+		dispc_reg_merge(DISPC_CONTROL, DISPC_CONTROL_GODIGITAL,
+				DISPC_CONTROL_GODIGITAL);
+
+	timeout = HZ / 3;
+	timeout += jiffies;
+	while (omap_disp_reg_sync_bit(output_dev) &&
+			time_before(jiffies, timeout)) {
+		if ((!in_interrupt()) && (!irqs_disabled())) {
+			set_current_state(TASK_INTERRUPTIBLE);
+			schedule_timeout(10);
+
+		}
+	}
+}
+EXPORT_SYMBOL(omap_disp_reg_sync);
+
+/* This function provides the status of the GO bit. After the GO bit is set
+ * through software, register changes take affect at the next VFP (vertical
+ * front porch) or EVSYNC. Per the specs, no further register changes
+ * must be done until the GO bit is reset by hardware. This function allows
+ * drivers to poll the status of the GO bit, and wait until it is reset if they
+ * wish to.
+ */
+int omap_disp_reg_sync_done(int output_dev)
+{
+	u32 control = dispc_reg_in(DISPC_CONTROL);
+
+	if (output_dev == OMAP_OUTPUT_LCD)
+		return ~(control & DISPC_CONTROL_GOLCD);
+	else
+		return ~(control & DISPC_CONTROL_GODIGITAL);
+}
+EXPORT_SYMBOL(omap_disp_reg_sync_done);
+
+void omap_disp_disable(unsigned long timeout_ticks)
+{
+	unsigned long timeout;
+
+	if (dispc_reg_in(DISPC_CONTROL)
+	    & (DISPC_CONTROL_DIGITALENABLE | DISPC_CONTROL_LCDENABLE)) {
+		/* disable the display controller */
+		dispc_reg_merge(DISPC_CONTROL, 0,
+				DISPC_CONTROL_DIGITALENABLE |
+				DISPC_CONTROL_LCDENABLE);
+
+		/* wait for any frame in progress to complete */
+		dispc_reg_out(DISPC_IRQSTATUS, DISPC_IRQSTATUS_FRAMEDONE);
+		timeout = jiffies + timeout_ticks;
+		while (!(dispc_reg_in(DISPC_IRQSTATUS)
+			 & DISPC_IRQSTATUS_FRAMEDONE)
+		       && time_before(jiffies, timeout)) {
+			int a_ctx = (in_atomic() || irqs_disabled()
+				     || in_interrupt());
+			if (!a_ctx) {
+				set_current_state(TASK_INTERRUPTIBLE);
+				schedule_timeout(1);
+			} else
+				udelay(100);
+		}
+		disp_ll_config_tv_clocks(1);
+	}
+
+	return;
+}
+EXPORT_SYMBOL(omap_disp_disable);
+
+/*
+ * Set the DSS Functional clock
+ * The DSS clock should be 4 times the Panel's Pixel clock
+ * For TV the Pixel clock required is 13.5Mhz
+ * For LCD the Pixel clock is 6Mhz
+ */
+void omap_disp_set_dssfclk(void)
+{
+	/* TODO set the LCD pixel clock rate based on the LCD configuration */
+	static int TV_pixel_clk = 14000000;	/* rounded 13.5 to 14 */
+	u32 ask_clkrate = 0, sup_clkrate = 0, tgt_clkrate = 0, i;
+
+	/*ask_clkrate = LCD_pixel_clk * 4; */
+	ask_clkrate = m_clk_rate;
+
+	if (ask_clkrate < (TV_pixel_clk * 4))
+		ask_clkrate = TV_pixel_clk * 4;
+
+	tgt_clkrate = ask_clkrate;
+
+	sup_clkrate = clk_round_rate(dss1f_scale, ask_clkrate);
+	if (system_rev < OMAP3430_REV_ES2_0) {
+		if (clk_get_rate(dss1f_scale) == 96000000) {
+			/*96M already, dont do anything for ES 1.0 */
+			return;
+		}
+	} else {
+		for (i = 1; i <= 20; i++) {
+			sup_clkrate =
+			    clk_round_rate(dss1f_scale, ask_clkrate);
+			if (sup_clkrate >= tgt_clkrate)
+				break;
+			ask_clkrate = ask_clkrate + 1000000;
+		}
+		if (clk_set_rate(dss1f_scale, sup_clkrate) == -EINVAL)
+			printk(KERN_ERR "Unable to set the DSS"
+			       "functional clock to %d\n", sup_clkrate);
+	}
+	return;
+}
+EXPORT_SYMBOL(omap_disp_set_dssfclk);
+
+/* This function must be called by any driver that needs to use the display
+ * controller before calling any routine that accesses the display controller
+ * registers. It increments the count of the number of users of the display
+ * controller, and turns the clocks ON only when required.
+ */
+void omap_disp_get_all_clks(void)
+{
+	u32 idle_dispc;
+
+	struct omap_encoder_device *enc_dev;
+	spin_lock(&dss_lock);
+	if (disp_usage == 0) {
+		/* turn on DSS clock */
+		config_disp_clocks(0);
+		omap_disp_set_tvref(TVREF_ON);
+		disp_ll_config_tv_clocks(0);
+
+		/* Set the TV standard first */
+		if (channels[1].num_encoders > 0) {
+			enc_dev =
+			    channels[1].enc_devices[channels[1]
+						.current_encoder];
+			if (enc_dev && enc_dev->mode_ops->setmode)
+				enc_dev->mode_ops->setmode
+					(modes[channels[1].current_mode].name,
+					 enc_dev);
+		}
+		/* restore dss context */
+		omap_disp_restore_ctx(OMAP_DSS_GENERIC);
+		omap_disp_restore_ctx(OMAP_DSS_DISPC_GENERIC);
+		omap_disp_restore_ctx(OMAP_GRAPHICS);
+		omap_disp_restore_ctx(OMAP_VIDEO1);
+		omap_disp_restore_ctx(OMAP_VIDEO2);
+
+		/* Set smart idle, autoidle for Display controller */
+		idle_dispc = dispc_reg_in(DISPC_SYSCONFIG);
+		idle_dispc &= ~(DISPC_SYSCONFIG_MIDLEMODE |
+				DISPC_SYSCONFIG_SIDLEMODE);
+
+		idle_dispc |= DISPC_SYSCONFIG_MIDLEMODE_NSTANDBY |
+		    DISPC_SYSCONFIG_SIDLEMODE_NIDLE;
+
+		dispc_reg_out(DISPC_SYSCONFIG, idle_dispc);
+
+		dispc_reg_out(DISPC_CONTROL, dss_ctx.dispc.control);
+
+	} else {
+		/* enable the TV clocks, since we are not if they are */
+		omap_disp_set_tvref(TVREF_ON);
+		disp_ll_config_tv_clocks(0);
+		enc_dev =
+		    channels[1].enc_devices[channels[1].current_encoder];
+		if (enc_dev && enc_dev->mode_ops->setmode) {
+		/* Set the default standard to ntsc_m */
+			enc_dev->mode_ops->setmode
+				(modes[channels[1].current_mode].name,
+				 enc_dev);
+		}
+	}
+	disp_usage++;
+	spin_unlock(&dss_lock);
+}
+EXPORT_SYMBOL(omap_disp_get_all_clks);
+
+/* This function must be called by a driver when it not going to use the
+ * display controller anymore. E.g., when a driver suspends, it must call
+ * omap_disp_put_dss. When it wakes up, it must call omap_disp_get_dss again.
+ * It decrements the count of the number of users of the display
+ * controller, and turns the clocks OFF when not required.
+ */
+void omap_disp_put_all_clks(void)
+{
+	 u32 idle_dss;
+
+	spin_lock(&dss_lock);
+	if (disp_usage == 0) {
+		printk(KERN_ERR
+		       "trying to put DSS when usage count is zero\n");
+		spin_unlock(&dss_lock);
+		return;
+	}
+
+	disp_usage--;
+
+	if (disp_usage == 0) {
+
+		/* save dss context */
+		disp_save_ctx(OMAP_DSS_GENERIC);
+		disp_save_ctx(OMAP_DSS_DISPC_GENERIC);
+		disp_save_ctx(OMAP_GRAPHICS);
+		disp_save_ctx(OMAP_VIDEO1);
+		disp_save_ctx(OMAP_VIDEO2);
+
+		idle_dss = dispc_reg_in(DISPC_SYSCONFIG);
+		idle_dss &= ~(DISPC_SYSCONFIG_MIDLEMODE |
+				DISPC_SYSCONFIG_SIDLEMODE);
+		idle_dss |= DISPC_SYSCONFIG_MIDLEMODE_SSTANDBY |
+				DISPC_SYSCONFIG_SIDLEMODE_SIDLE;
+		dispc_reg_out(DISPC_SYSCONFIG, idle_dss);
+
+		omap_disp_disable(HZ / 2);
+		/* turn off TV clocks */
+		disp_ll_config_tv_clocks(1);
+		omap_disp_set_tvref(TVREF_OFF);
+		mdelay(4);
+
+		config_disp_clocks(1);
+	}
+	spin_unlock(&dss_lock);
+}
+EXPORT_SYMBOL(omap_disp_put_all_clks);
+
+/* This function must be called by any driver that needs to use the display
+ * controller before calling any routine that accesses the display controller
+ * registers. It increments the count of the number of users of the display
+ * controller, and turns the clocks ON only when required.
+ */
+void omap_disp_get_dss(void)
+{
+	u32 idle_dispc;
+	u32 i;
+
+	struct omap_encoder_device *enc_dev;
+	unsigned int panel_width, panel_height, size = 0;
+	struct omap_dispc_regs *dispc = &dss_ctx.dispc;
+	struct channel_obj *channel = &channels[1];
+
+	spin_lock(&dss_lock);
+	if (disp_usage == 0) {
+		/* turn on DSS clock */
+		config_disp_clocks(0);
+
+		omap_disp_set_tvref(TVREF_ON);
+		disp_ll_config_tv_clocks(0);
+
+		/* Set the current mode for all the channels and
+		 * Set the panel size accordingly
+		 */
+		for (i = 0; i < ARRAY_SIZE(channels); i++) {
+			enc_dev =
+				channels[i].enc_devices[channels[i].
+						current_encoder];
+			if (enc_dev && enc_dev->mode_ops->setmode) {
+				enc_dev->mode_ops->setmode
+					(modes[channels[i].current_mode].name,
+					 enc_dev);
+				panel_width =
+					modes[channel->current_mode].width;
+				panel_height =
+					modes[channel->current_mode].height;
+				if (i == i) {
+					panel_height = panel_height>>1;
+					size = ((panel_width - 1) <<
+						DISPC_SIZE_DIG_PPL_SHIFT) &
+						DISPC_SIZE_DIG_PPL;
+					size |= ((panel_height - 1) <<
+						DISPC_SIZE_DIG_LPP_SHIFT) &
+						DISPC_SIZE_DIG_LPP;
+					dispc->size_dig = (size);
+				}
+			}
+		}
+		/* restore dss context */
+		omap_disp_restore_ctx(OMAP_DSS_GENERIC);
+		omap_disp_restore_ctx(OMAP_DSS_DISPC_GENERIC);
+		omap_disp_restore_ctx(OMAP_GRAPHICS);
+		omap_disp_restore_ctx(OMAP_VIDEO1);
+		omap_disp_restore_ctx(OMAP_VIDEO2);
+
+		/* Set smart idle, autoidle for Display controller */
+		idle_dispc = dispc_reg_in(DISPC_SYSCONFIG);
+		idle_dispc &= ~(DISPC_SYSCONFIG_MIDLEMODE |
+				DISPC_SYSCONFIG_SIDLEMODE);
+
+		idle_dispc |= DISPC_SYSCONFIG_MIDLEMODE_NSTANDBY |
+		    DISPC_SYSCONFIG_SIDLEMODE_NIDLE;
+
+		dispc_reg_out(DISPC_SYSCONFIG, idle_dispc);
+
+		dispc_reg_out(DISPC_CONTROL, dss_ctx.dispc.control);
+
+	}
+	disp_usage++;
+	spin_unlock(&dss_lock);
+}
+EXPORT_SYMBOL(omap_disp_get_dss);
+
+/* This function must be called by a driver when it not going to use the
+ * display controller anymore. E.g., when a driver suspends, it must call
+ * omap_disp_put_dss. When it wakes up, it must call omap_disp_get_dss again.
+ * It decrements the count of the number of users of the display
+ * controller, and turns the clocks OFF when not required.
+ */
+void omap_disp_put_dss(void)
+{
+	u32 idle_dss;
+
+	spin_lock(&dss_lock);
+	if (disp_usage == 0) {
+		printk(KERN_ERR
+		       "trying to put DSS when usage count is zero\n");
+		spin_unlock(&dss_lock);
+		return;
+	}
+
+	disp_usage--;
+
+	if (disp_usage == 0) {
+
+		/* save dss context */
+		disp_save_ctx(OMAP_DSS_GENERIC);
+		disp_save_ctx(OMAP_DSS_DISPC_GENERIC);
+		disp_save_ctx(OMAP_GRAPHICS);
+		disp_save_ctx(OMAP_VIDEO1);
+		disp_save_ctx(OMAP_VIDEO2);
+
+		idle_dss = dispc_reg_in(DISPC_SYSCONFIG);
+		idle_dss &= ~(DISPC_SYSCONFIG_MIDLEMODE |
+			DISPC_SYSCONFIG_SIDLEMODE);
+		idle_dss |= DISPC_SYSCONFIG_MIDLEMODE_SSTANDBY |
+			DISPC_SYSCONFIG_SIDLEMODE_SIDLE;
+		dispc_reg_out(DISPC_SYSCONFIG, idle_dss);
+
+		omap_disp_disable(HZ / 2);
+		disp_ll_config_tv_clocks(1);
+		omap_disp_set_tvref(TVREF_OFF);
+		mdelay(4);
+		config_disp_clocks(1);
+	}
+	spin_unlock(&dss_lock);
+}
+EXPORT_SYMBOL(omap_disp_put_dss);
+
+/* This function must be called by any driver that wishes to use a particular
+ * display pipeline (layer).
+ */
+int omap_disp_request_layer(int ltype)
+{
+	int ret;
+	ret = 0;
+
+	spin_lock(&dss_lock);
+	if (!layer[ltype].in_use) {
+		layer[ltype].in_use = 1;
+		ret = 1;
+	}
+	spin_unlock(&dss_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(omap_disp_request_layer);
+
+/* This function must be called by a driver when it is done using a particular
+ * display pipeline (layer).
+ */
+void omap_disp_release_layer(int ltype)
+{
+	spin_lock(&dss_lock);
+	layer[ltype].in_use = 0;
+	layer[ltype].ctx_valid = 0;
+	spin_unlock(&dss_lock);
+}
+EXPORT_SYMBOL(omap_disp_release_layer);
+
+/* Used to enable LCDENABLE or DIGITALENABLE of the display controller.
+ */
+void omap_disp_enable_output_dev(int output_dev)
+{
+	if (output_dev == OMAP_OUTPUT_LCD) {
+		dispc_reg_merge(DISPC_CONTROL, DISPC_CONTROL_LCDENABLE,
+				DISPC_CONTROL_LCDENABLE);
+	} else if (output_dev == OMAP_OUTPUT_TV) {
+		dispc_reg_merge(DISPC_CONTROL, DISPC_CONTROL_DIGITALENABLE,
+				DISPC_CONTROL_DIGITALENABLE);
+	}
+}
+EXPORT_SYMBOL(omap_disp_enable_output_dev);
+
+/* Used to disable LCDENABLE or DIGITALENABLE of the display controller.
+ */
+void omap_disp_disable_output_dev(int output_dev)
+{
+	if (output_dev == OMAP_OUTPUT_LCD) {
+		dispc_reg_merge(DISPC_CONTROL, ~DISPC_CONTROL_LCDENABLE,
+				DISPC_CONTROL_LCDENABLE);
+	} else if (output_dev == OMAP_OUTPUT_TV) {
+		dispc_reg_merge(DISPC_CONTROL,
+				~DISPC_CONTROL_DIGITALENABLE,
+				DISPC_CONTROL_DIGITALENABLE);
+	}
+}
+EXPORT_SYMBOL(omap_disp_disable_output_dev);
+
+int omap_disp_get_output_dev(int ltype)
+{
+	return layer[ltype].output_dev;
+}
+EXPORT_SYMBOL(omap_disp_get_output_dev);
+
+/* Used to save the DMA parameter settings for a particular layer to be
+ * displayed on a particular output device. These values help the
+ * omap_disp_set_output_dev() function to dynamically switch the output of a
+ * layer to any output device.
+ */
+void
+omap_disp_set_dma_params(int ltype, int output_dev,
+			  u32 ba0, u32 ba1, u32 row_inc, u32 pix_inc)
+{
+	struct omap_disp_dma_params *dma;
+
+	if (output_dev == OMAP_OUTPUT_LCD)
+		dma = &layer[ltype].dma[0];
+	else
+		dma = &layer[ltype].dma[1];
+
+	dma->ba0 = ba0;
+	dma->ba1 = ba1;
+	dma->row_inc = row_inc;
+	dma->pix_inc = pix_inc;
+}
+EXPORT_SYMBOL(omap_disp_set_dma_params);
+
+/* Sets the background color */
+void omap_disp_set_bg_color(int output_dev, int color)
+{
+	if (output_dev == OMAP_OUTPUT_TV)
+		dispc_reg_out(DISPC_DEFAULT_COLOR1, color);
+
+	omap_disp_reg_sync(output_dev);
+}
+EXPORT_SYMBOL(omap_disp_set_bg_color);
+
+/* Returns the current background color */
+void omap_disp_get_bg_color(int output_dev, int *color)
+{
+	if (output_dev == OMAP_OUTPUT_TV)
+		*color = dispc_reg_in(DISPC_DEFAULT_COLOR1);
+}
+EXPORT_SYMBOL(omap_disp_get_bg_color);
+
+/* Turn on/off the TV reference voltage from OMAP */
+void omap_disp_set_tvref(int tvref_state)
+{
+	switch (tvref_state) {
+	case TVREF_ON:
+		dss_reg_out(DSS_CONTROL, (dss_reg_in(DSS_CONTROL)
+					  | DSS_CONTROL_TV_REF));
+		break;
+	case TVREF_OFF:
+		dss_reg_out(DSS_CONTROL, (dss_reg_in(DSS_CONTROL) &
+					  ~(DSS_CONTROL_TV_REF)));
+		break;
+	}
+}
+EXPORT_SYMBOL(omap_disp_set_tvref);
+
+/* Sets the SMS settings for rotation using the VRFB.
+ */
+int
+omap_disp_set_vrfb(int context, u32 phy_addr,
+		    u32 width, u32 height, u32 bytes_per_pixel)
+{
+	int page_width_exp, page_height_exp, pixel_size_exp;
+
+	if (bytes_per_pixel > 4)
+		return -EINVAL;
+
+	page_width_exp = PAGE_WIDTH_EXP;
+	page_height_exp = PAGE_HEIGHT_EXP;
+	pixel_size_exp = bytes_per_pixel >> 1;
+
+	width = ((1 << page_width_exp) *
+		(pages_per_side(width * bytes_per_pixel, page_width_exp))) >>
+		pixel_size_exp;
+
+	height = (1 << page_height_exp) *
+		(pages_per_side(height, page_height_exp));
+
+	SMS_ROT0_PHYSICAL_BA(context) = phy_addr;
+	SMS_ROT0_SIZE(context) = 0;
+	SMS_ROT0_SIZE(context) |= (width << SMS_IMAGEWIDTH_OFFSET)
+		| (height << SMS_IMAGEHEIGHT_OFFSET);
+	SMS_ROT_CONTROL(context) = 0;
+
+	SMS_ROT_CONTROL(context) |= pixel_size_exp << SMS_PS_OFFSET
+		| (page_width_exp - pixel_size_exp) << SMS_PW_OFFSET
+		| page_height_exp << SMS_PH_OFFSET;
+
+	return 0;
+}
+EXPORT_SYMBOL(omap_disp_set_vrfb);
+
+/* Sets the transparency color key type and value.
+*/
+void omap_disp_set_colorkey(int output_dev, int key_type, int key_val)
+{
+	if (output_dev == OMAP_OUTPUT_TV) {
+		if (key_type == OMAP_VIDEO_SOURCE)
+			dispc_reg_merge(DISPC_CONFIG,
+					DISPC_CONFIG_TCKDIGSELECTION,
+					DISPC_CONFIG_TCKDIGSELECTION);
+		else
+			dispc_reg_merge(DISPC_CONFIG, 0,
+					DISPC_CONFIG_TCKDIGSELECTION);
+		dispc_reg_out(DISPC_TRANS_COLOR1, key_val);
+	}
+
+	omap_disp_reg_sync(output_dev);
+}
+EXPORT_SYMBOL(omap_disp_set_colorkey);
+
+/* Returns the current transparency color key type and value.
+*/
+void omap_disp_get_colorkey(int output_dev, int *key_type, int *key_val)
+{
+
+	if (output_dev == OMAP_OUTPUT_TV) {
+		if (dispc_reg_in(DISPC_CONFIG) &
+		    DISPC_CONFIG_TCKDIGSELECTION)
+			*key_type = OMAP_VIDEO_SOURCE;
+		else
+			*key_type = OMAP_GFX_DESTINATION;
+		*key_val = dispc_reg_in(DISPC_TRANS_COLOR1);
+	}
+}
+EXPORT_SYMBOL(omap_disp_get_colorkey);
+
+void omap_disp_enable_colorkey(int output_dev)
+{
+
+	if (output_dev == OMAP_OUTPUT_TV)
+		dispc_reg_merge(DISPC_CONFIG, DISPC_CONFIG_TCKDIGENABLE,
+				DISPC_CONFIG_TCKDIGENABLE);
+
+	omap_disp_reg_sync(output_dev);
+}
+EXPORT_SYMBOL(omap_disp_enable_colorkey);
+
+void omap_disp_disable_colorkey(int output_dev)
+{
+	if (output_dev == OMAP_OUTPUT_TV)
+		dispc_reg_merge(DISPC_CONFIG, ~DISPC_CONFIG_TCKDIGENABLE,
+				DISPC_CONFIG_TCKDIGENABLE);
+
+	omap_disp_reg_sync(output_dev);
+}
+EXPORT_SYMBOL(omap_disp_disable_colorkey);
+
+void omap_disp_set_alphablend(int output_dev, int value)
+{
+
+	if (output_dev == OMAP_OUTPUT_TV) {
+		if (value)
+			dispc_reg_merge(DISPC_CONFIG,
+					DISPC_CONFIG_TVALPHAENABLE,
+					DISPC_CONFIG_TVALPHAENABLE);
+		else
+			dispc_reg_merge(DISPC_CONFIG,
+					~DISPC_CONFIG_TVALPHAENABLE,
+					DISPC_CONFIG_TVALPHAENABLE);
+	}
+	omap_disp_reg_sync(output_dev);
+}
+EXPORT_SYMBOL(omap_disp_set_alphablend);
+
+void omap_disp_set_global_alphablend_value(int ltype, int value)
+{
+	u32  alpha_value;
+	alpha_value = 0;
+
+	if (ltype == OMAP_VIDEO2) {
+		alpha_value = dispc_reg_in(DISPC_GLOBAL_ALPHA);
+		alpha_value &= (~DISPC_GLOBAL_ALPHA_VID2_GALPHA);
+		alpha_value |= (value <<
+				DISPC_GLOBAL_ALPHA_VID2_GALPHA_SHIFT);
+		dispc_reg_out(DISPC_GLOBAL_ALPHA, alpha_value);
+
+	}
+	omap_disp_reg_sync(OMAP_OUTPUT_TV);
+}
+EXPORT_SYMBOL(omap_disp_set_global_alphablend_value);
+
+unsigned char omap_disp_get_global_alphablend_value(int ltype)
+{
+	u32  alpha_value;
+	alpha_value = 0;
+
+	if (ltype == OMAP_VIDEO2) {
+		alpha_value = dispc_reg_in(DISPC_GLOBAL_ALPHA);
+		alpha_value &= (DISPC_GLOBAL_ALPHA_VID2_GALPHA);
+		alpha_value = alpha_value >>
+				DISPC_GLOBAL_ALPHA_VID2_GALPHA_SHIFT;
+	}
+	return (unsigned char) alpha_value;
+}
+EXPORT_SYMBOL(omap_disp_get_global_alphablend_value);
+
+int omap_disp_get_alphablend(int output_dev)
+{
+
+	if (output_dev == OMAP_OUTPUT_TV) {
+		if (dispc_reg_in(DISPC_CONFIG) & 0x00080000)
+			return 1;
+		else
+			return 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(omap_disp_get_alphablend);
+
+int omap_disp_reg_sync_bit(int output_dev)
+{
+	u32 control = dispc_reg_in(DISPC_CONTROL);
+
+	if (output_dev == OMAP_OUTPUT_LCD)
+		return (control & DISPC_CONTROL_GOLCD) >> 5;
+	else
+		return (control & DISPC_CONTROL_GODIGITAL) >> 6;
+}
+EXPORT_SYMBOL(omap_disp_reg_sync_bit);
+
+/*
+ * Enables an IRQ in DSPC_IRQENABLE.
+ */
+int omap_disp_irqenable(omap_disp_isr_t isr, unsigned int mask)
+{
+	int i;
+	unsigned long flags;
+
+	if (omap_disp_irq == 0 || mask == 0)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dss_lock, flags);
+	for (i = 0; i < MAX_ISR_NR; i++) {
+		if (registered_isr[i].isr == isr) {
+			registered_isr[i].mask |= mask;
+			dispc_reg_out(DISPC_IRQENABLE,
+				      dispc_reg_in(DISPC_IRQENABLE) |
+				      mask);
+			spin_unlock_irqrestore(&dss_lock, flags);
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(&dss_lock, flags);
+	return -EBUSY;
+}
+EXPORT_SYMBOL(omap_disp_irqenable);
+
+/*
+ * Disables an IRQ in DISPC_IRQENABLE,
+ * The IRQ will be active if any other ISR is still using the same.
+ * mask : should contain '0' for irq to be disable and rest should be '1'.
+ */
+int omap_disp_irqdisable(omap_disp_isr_t isr, unsigned int mask)
+{
+	int i;
+	unsigned long flags;
+	unsigned int new_mask;
+	new_mask = 0;
+
+	if (omap_disp_irq == 0)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dss_lock, flags);
+	for (i = 0; i < MAX_ISR_NR; i++)
+		if (registered_isr[i].isr == isr)
+			break;
+
+	if (i == MAX_ISR_NR) {
+		spin_unlock_irqrestore(&dss_lock, flags);
+		return -EINVAL;
+	}
+
+	registered_isr[i].mask &= mask;
+
+	/* disable an IRQ if every one wishes to do so */
+	for (i = 0; i < MAX_ISR_NR; i++)
+		new_mask |= registered_isr[i].mask;
+
+	dispc_reg_out(DISPC_IRQENABLE, new_mask);
+	spin_unlock_irqrestore(&dss_lock, flags);
+	return -EBUSY;
+}
+EXPORT_SYMBOL(omap_disp_irqdisable);
+
+/* Display controller interrupts are handled first by this display library.
+ * Drivers that need to use certain interrupts should register their ISRs and
+ * interrupt enable mask with the display library.
+ */
+int
+omap_disp_register_isr(omap_disp_isr_t isr, void *arg, unsigned int mask)
+{
+	int i;
+	unsigned long flags;
+
+	if (omap_disp_irq == 0 || isr == 0 || arg == 0)
+		return -EINVAL;
+
+	/* Clear all the interrupt, so that you dont get an immediate
+	 * interrupt
+	 */
+	dispc_reg_out(DISPC_IRQSTATUS, 0xFFFFFFFF);
+	spin_lock_irqsave(&dss_lock, flags);
+	for (i = 0; i < MAX_ISR_NR; i++) {
+		if (registered_isr[i].isr == NULL) {
+			registered_isr[i].isr = isr;
+			registered_isr[i].arg = arg;
+			registered_isr[i].mask = mask;
+
+			/* Clear previous interrupts if any */
+			dispc_reg_out(DISPC_IRQSTATUS, mask);
+			dispc_reg_out(DISPC_IRQENABLE,
+				      dispc_reg_in(DISPC_IRQENABLE) |
+				      mask);
+			spin_unlock_irqrestore(&dss_lock, flags);
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(&dss_lock, flags);
+	return -EBUSY;
+}
+EXPORT_SYMBOL(omap_disp_register_isr);
+
+int omap_disp_unregister_isr(omap_disp_isr_t isr)
+{
+	int i, j;
+	unsigned long flags;
+	unsigned int new_mask;
+
+	new_mask = 0;
+	if (omap_disp_irq == 0)
+		return -EINVAL;
+
+	spin_lock_irqsave(&dss_lock, flags);
+	for (i = 0; i < MAX_ISR_NR; i++) {
+		if (registered_isr[i].isr == isr) {
+			registered_isr[i].isr = NULL;
+			registered_isr[i].arg = NULL;
+			registered_isr[i].mask = 0;
+
+			/* The interrupt may no longer be valid, re-set
+			 * the IRQENABLE */
+			for (j = 0; j < MAX_ISR_NR; j++)
+				new_mask |= registered_isr[j].mask;
+
+			dispc_reg_out(DISPC_IRQENABLE, new_mask);
+			spin_unlock_irqrestore(&dss_lock, flags);
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(&dss_lock, flags);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(omap_disp_unregister_isr);
+
+int __init omap_disp_init(void)
+{
+	int rev, i;
+	u32 dss_control;
+
+	spin_lock_init(&dss_lock);
+
+	/* Required for scale call */
+	dss1f_scale =
+	    clk_get(NULL, cpu_is_omap34xx() ?
+			    "dss1_alwon_fck" : "dss1_fck");
+	if (IS_ERR(dss1f_scale)) {
+		printk(KERN_WARNING "Could not get DSS1 FCLK\n");
+		return PTR_ERR(dss1f_scale);
+	}
+
+	omap_disp_get_all_clks();
+
+	/* disable the display controller */
+	omap_disp_disable(HZ / 5);
+
+	rev = dss_reg_in(DSS_REVISION);
+	printk(KERN_INFO "OMAP Display hardware version %d.%d\n",
+	       (rev & DISPC_REVISION_MAJOR) >> DISPC_REVISION_MAJOR_SHIFT,
+	       (rev & DISPC_REVISION_MINOR) >> DISPC_REVISION_MINOR_SHIFT);
+
+	/* enable DAC_DEMEN and VENC_4X_CLOCK in DSS for TV operation */
+	dss_control = dss_reg_in(DSS_CONTROL);
+
+	if (cpu_is_omap242x())
+		dss_control |= (DSS_CONTROL_DAC_DEMEN |
+			DSS_CONTROL_VENC_CLOCK_4X_ENABLE);
+	if ((machine_is_omap_3430sdp()) || (machine_is_omap3evm()))
+		/* enabling S-video connector for 3430 SDP */
+		dss_control |= (DSS_CONTROL_DAC_DEMEN | DSS_CONTROL_TV_REF |
+			DSS_CONTROL_VENC_CLOCK_4X_ENABLE |
+			DSS_CONTROL_VENC_OUT);
+
+	dss_control &= ~DSS_CONTROL_VENC_CLOCK_MODE;
+	dss_reg_out(DSS_CONTROL, dss_control);
+
+	/* By default, all layers go to LCD */
+	layer[OMAP_GRAPHICS].output_dev = OMAP_OUTPUT_TV;
+	layer[OMAP_VIDEO1].output_dev = OMAP_OUTPUT_TV;
+	layer[OMAP_VIDEO2].output_dev = OMAP_OUTPUT_TV;
+
+	/*
+	 * Set the default color conversion parameters for Video pipelines
+	 * by default the color space is set to JPEG
+	 */
+
+	update_colorconv_mtx(0, cc_bt601_full);
+	omap_disp_set_colorconv(0, FULL_COLOR_RANGE);
+
+	update_colorconv_mtx(1, cc_bt601_full);
+	omap_disp_set_colorconv(1, FULL_COLOR_RANGE);
+
+	/* Disable the Alpha blending for both TV and LCD
+	 * Also set the global alpha value for both
+	 * graphics and video2 pipeline to 255(Completely Opaque)
+	 */
+	omap_disp_set_alphablend(OMAP_OUTPUT_TV, 0);
+
+	omap_disp_set_global_alphablend_value(OMAP_VIDEO2, 0xFF);
+
+	omap_disp_set_bg_color(OMAP_OUTPUT_TV, 0x000000);
+
+	if (request_irq(INT_24XX_DSS_IRQ, (void *) omap_disp_master_isr,
+			IRQF_SHARED, "OMAP Display", registered_isr)) {
+		printk(KERN_WARNING "omap_disp: request_irq failed\n");
+		omap_disp_irq = 0;
+	} else {
+		omap_disp_irq = 1;
+		for (i = 0; i < MAX_ISR_NR; i++) {
+			registered_isr[i].isr = NULL;
+			registered_isr[i].mask = 0;
+		}
+		/* Clear all the pending interrupts, if any */
+		dispc_reg_out(DISPC_IRQSTATUS, 0xFFFFFFFF);
+		omap_disp_register_isr(disp_synclost_isr, layer,
+					DISPC_IRQSTATUS_SYNCLOST);
+	}
+
+	omap_disp_register_isr(disp_synclost_isr, layer,
+				DISPC_IRQSTATUS_SYNCLOST);
+	omap_disp_put_all_clks();
+
+	return 0;
+
+}
+
+/* Start before devices */
+subsys_initcall(omap_disp_init);
--
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
