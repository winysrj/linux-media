Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9O9wgP8003319
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:58:42 -0400
Received: from devils.ext.ti.com (devils.ext.ti.com [198.47.26.153])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9O9wEZ9024360
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 05:58:25 -0400
From: Hardik Shah <hardik.shah@ti.com>
To: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
	video4linux-list@redhat.com
Date: Fri, 24 Oct 2008 15:23:05 +0530
Message-Id: <1224841985-24605-1-git-send-email-hardik.shah@ti.com>
Cc: 
Subject: [PATCHv2 2/4] OMAP3 EVM TV Encoder Driver
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

Cleaned and Restructured the OMAP DSS TV Encoder according to 
open source comments.

Made TV encoder driver mach specific rather than arch specific.
Removed architecture specific macros.
Removed machine specific macros.
Platform device registration moved to board specific file.
Tested on OMAP3 EVM board

Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
		Hari Nagalla <hnagalla@ti.com>
		Hardik Shah <hardik.shah@ti.com>
		Manjunath Hadli <mrh@ti.com>
		R Sivaraj <sivaraj@ti.com>
		Vaibhav Hiremath <hvaibhav@ti.com>
---
 arch/arm/mach-omap2/Kconfig               |    7 +
 arch/arm/mach-omap2/Makefile              |    1 +
 arch/arm/mach-omap2/board-omap3evm-venc.c |  987 +++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-omap3evm.c      |    5 +
 4 files changed, 1000 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-omap2/board-omap3evm-venc.c

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index b03e253..89ed870 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -141,4 +141,11 @@ config OMAP_TICK_GPTIMER
 	  If CONFIG_OMAP_32K_TIMER is selected, Beagle may require GPTIMER12
 	  due to hardware sensitivity to glitches on the OMAP 32kHz clock
 	  input.
+config VIDEO_OMAP3EVM_TVOUT
+	bool "TV out support on omap3evm board"
+	depends on MACH_OMAP3EVM
+	select VIDEO_OMAP_DSSLIB
+	default y
+	help
+	Select this option if you want to enable TV out on omap3evm board.
 
diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 33de217..3fa2b36 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
 					   hsmmc.o \
 					   usb-musb.o usb-ehci.o \
 					   board-omap3evm-flash.o
+obj-$(CONFIG_VIDEO_OMAP3EVM_TVOUT)		+= board-omap3evm-venc.o
 obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o \
 					   usb-musb.o usb-ehci.o \
 					   hsmmc.o
diff --git a/arch/arm/mach-omap2/board-omap3evm-venc.c b/arch/arm/mach-omap2/board-omap3evm-venc.c
new file mode 100644
index 0000000..ccfb9d6
--- /dev/null
+++ b/arch/arm/mach-omap2/board-omap3evm-venc.c
@@ -0,0 +1,987 @@
+/*
+ * arch/arm/mach-omap2/board-omap3evm-venc.c
+ *
+ * This is tv encoder file present on DSS hardware of omap SoCs.  This encoder
+ * will register itself to the display library.
+ *
+ *  Copyright (C) 2008 Texas Instruments.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
+ * whether express or implied; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Author:  Brijesh(brijesh.j@ti.com)
+ *
+ * History:
+ *	AUG-2008  Brijesh J.	Created for TV encoder of DSS.  It will
+ *		  Hari N.    	register itself with DSS library along with its
+ *		  Hardik S.	capabilities and function pointers.
+ *		  Vaibhav H.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/io.h>
+#include <mach/omap-dss.h>
+#include <linux/i2c/twl4030.h>
+#ifdef CONFIG_PM
+#include <linux/notifier.h>
+#include <linux/pm.h>
+#endif
+#include <linux/platform_device.h>
+
+#define OMAP_TV_DRIVER			"omap3evm_tv"
+#define ENCODER_NAME			"TV_ENCODER"
+
+#define ENABLE_VDAC_DEDICATED		0x03
+#define ENABLE_VDAC_DEV_GRP		0x20
+#define ENABLE_VPLL2_DEV_GRP		0xE0
+
+/* Typical encoder values for different TV tests */
+#define VENC_HFLTR_CTRL_EN			0x00000000
+#define VENC_X_COLOR_VAL			0x00000000
+
+#define VENC_LINE21_VAL				0x00000000
+#define VENC_LN_SEL_VAL				0x00000015
+#define VENC_HTRIGGER_VTRIGGER_VAL		0x00000000
+#define VENC_LN_SEL_VAL_PAL_BDGHI		0x01290015
+
+#define VENC_TVDETGP_INT_START_STOP_X_VAL	0x00140001
+#define VENC_TVDETGP_INT_START_STOP_Y_VAL	0x00010001
+#define VENC_GEN_CTRL_VAL			0x00FF0000
+#define VENC_GEN_CTRL_PAL_VAL			0x00F90000
+
+/* DAC enable and in normal operation */
+#define VENC_DAC_ENABLE				0x0000000D
+
+/*Values that are same for NTSC, PAL-M AND PAL-60 */
+#define F_CONTROL_GEN				0x00000000
+#define SYNC_CONTROL_GEN			0x00001040
+#define VENC_LLEN_GEN				0x00000359
+#define VENC_FLENS_GEN                  	0x0000020C
+#define VENC_C_PHASE_GEN                	0x00000000
+#define VENC_CC_CARR_WSS_CARR_GEN       	0x000025ed
+#define VENC_L21_WC_CTL_GEN             	0x00170000
+#define VENC_SAVID_EAVID_GEN            	0x069300F4
+#define VENC_FLEN_FAL_GEN             		0x0016020C
+#define VENC_HS_EXT_START_STOP_X_GEN    	0x000F0359
+#define VENC_VS_INT_START_X_GEN         	0x01A00000
+#define VENC_VS_EXT_STOP_X_VS_EXT_START_Y_GEN   0x020D01AC
+#define VENC_VS_EXT_STOP_Y_GEN			0x00000006
+#define VENC_FID_INT_START_X_FID_INT_START_Y_GEN  0x0001008A
+#define VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_GEN 0x01AC0106
+#define VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_GEN 0x01060006
+
+/* Values that are same for PAL-BDGHI, PAL-N, PAL-NC */
+
+#define VENC_LLEN_PAL				0x0000035F
+#define VENC_FLENS_PAL				0x00000270
+
+#define VENC_LLEN_PAL_M				0x00000359
+#define VENC_FLENS_PAL_M			0x0000020C
+
+#define VENC_C_PHASE_PAL		       	0x000000F0 /* N */
+#define VENC_C_PHASE_PAL_BDGHI			0x00000000
+#define VENC_C_PHASE_PAL_NC		       	0x00000000
+
+#define VENC_CC_CARR_WSS_CARR_PAL		0x000025ED
+
+#define VENC_L21_WC_CTL_PAL			0x00000000
+#define VENC_L21_WC_CTL_PAL_BDGHI		0x0000F603
+
+#define VENC_SAVID_EAVID_PAL			0x06A70108
+#define VENC_FLEN_FAL_PAL			0x00170270
+#define VENC_FLEN_FAL_PAL_BDGHI			0x00180270
+#define VENC_HS_EXT_START_STOP_X_PAL		0x000F035F
+#define VENC_VS_INT_START_X_PAL			0x01A70000
+#define VENC_VS_EXT_STOP_Y_PAL			0x00000005
+#define VENC_VS_EXT_STOP_Y_PAL_BDGHI		0x00000025
+#define VENC_VS_EXT_STOP_X_VS_EXT_START_Y_PAL	0x027101AF
+#define VENC_VS_EXT_STOP_X_VS_EXT_START_Y_PAL_BDGHI	0x000101AF
+
+#define VENC_GAIN_U_PAL_BDGHI			0x00000130
+#define VENC_CC_CARR_WSS_CARR_PAL_BDGHI		0x2F7225ED
+
+#define VENC_GAIN_U_PAL_N			0x000000FD
+#define VENC_GAIN_U_PAL_NC			0x00000130
+#define VENC_GAIN_U_PAL_M			0x00000140
+#define VENC_GAIN_U_PAL_60			0x00000140
+
+#define VENC_GAIN_V_PAL_BDGHI			0x000001B0
+
+#define VENC_GAIN_V_PAL_N			0x00000165
+#define VENC_GAIN_V_PAL_NC			0x000001B0
+#define VENC_GAIN_V_PAL_M			0x00000190
+#define VENC_GAIN_V_PAL_60			0x00000190
+
+#define VENC_GAIN_Y_PAL_BDGHI			0x000001B0
+#define VENC_GAIN_Y_PAL_N			0x00000177
+#define VENC_GAIN_Y_PAL_NC			0x000001B0
+#define VENC_GAIN_Y_PAL_M			0x000001C0
+#define VENC_GAIN_Y_PAL_60			0x000001C0
+
+#define VENC_BLACK_LEVEL_PAL_BDGHI		0x0000003B
+
+#define VENC_BLANK_LEVEL_PAL_BDGHI		0x0000003B
+#define VENC_BLACK_LEVEL_PAL_NC			0x00000063
+#define VENC_BLANK_LEVEL_PAL_NC			0x00000063
+
+#define VENC_BLACK_LEVEL_PAL_N			0x00000060
+#define VENC_BLANK_LEVEL_PAL_N			0x00000053
+
+#define VENC_BLACK_LEVEL_PAL_M			0x00000069
+#define VENC_BLANK_LEVEL_PAL_M			0x0000005C
+
+#define VENC_BLACK_LEVEL_PAL_60			0x00000069
+#define VENC_BLANK_LEVEL_PAL_60			0x0000005C
+
+#define VENC_M_CONTROL_PAL			0x00000002
+#define VENC_M_CONTROL_PAL_M			0x00000003
+#define VENC_M_CONTROL_PAL_60			0x00000003
+
+#define VENC_BSTAMP_WSS_DATA_PAL_BDGHI		0x00000043
+
+#define VENC_BSTAMP_WSS_DATA_PAL_N		0x00000038
+#define VENC_BSTAMP_WSS_DATA_PAL_M		0x0000003F
+#define VENC_BSTAMP_WSS_DATA_PAL_NC		0x00000041
+#define VENC_BSTAMP_WSS_DATA_PAL_60		0x0000003F
+
+#define VENC_S_CARR_PAL_M			0x21E6EFE3
+#define VENC_S_CARR_PAL_NC			0x21E6EFE3
+#define VENC_S_CARR_PAL_BDGHI			0x2A098ACB
+#define VENC_S_CARR_PAL_60			0x2A098ACB
+
+#define VENC_LAL_PHASE_RESET_PAL		0x00040136 /* BDGHI & N */
+#define VENC_LAL_PHASE_RESET_PAL_NC		0x00040135
+#define VENC_LAL_PHASE_RESET_PAL_2		0x00040107 /* PAL-M & PAL-60 */
+
+#define VENC_HS_INT_START_STOP_X_PAL		0x00920358 /* BDGHI & N */
+#define VENC_HS_INT_START_STOP_X_NC		0x00880358
+#define VENC_HS_INT_START_STOP_X_PAL_2		0x007e034e /* PAL-M & PAL-60 */
+
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL	0x000601A7
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL_2	0x020901a0 /* PAL-M & PAL-60*/
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL_NC 0x026F01A7
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL_BDGHI	0x000001A7
+
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL	0x01AF0036
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL_2	0x01ac0022 /* PAL-M & PAL-60 */
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL_NC 0x01AF002E
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL_BDGHI	0x01AF0000
+
+#define VENC_AVID_START_STOP_X_PAL		0x03530082 /* BDGHI & N */
+#define VENC_AVID_START_STOP_X_PAL_NC		0x03530083
+#define VENC_AVID_START_STOP_X_PAL_2		0x03530082 /* PAL-M & PAL-60 */
+
+#define VENC_AVID_START_STOP_Y_PAL		0x0270002E
+#define VENC_AVID_START_STOP_Y_PAL_2		0x0270002E /* PAL-M & PAL-60 */
+#define VENC_AVID_START_STOP_Y_PAL_NC		0x026E002E
+#define VENC_AVID_START_STOP_Y_PAL_BDGHI	0x026C002E
+#define VENC_FID_INT_START_X_FID_INT_START_Y_PAL 0x0005008A
+
+#define VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_PAL 0x002E0138
+#define VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_PAL_BDGHI	0x01380001
+
+#define VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_PAL 0x01380005
+
+/* NTSC */
+
+#define VENC_CC_CARR_WSS_CARR_GEN_NTSC_M	0x043F2631
+#define VENC_X_COLOR_VAL_NTSC_M			0x00000007
+#define VENC_LN_SEL_VAL_NTSC_M			0x01310011
+#define VENC_L21_WC_CTL_GEN_NTSC_M		0x0000F003
+#define VENC_HS_INT_START_STOP_X_NTSC_M		0x008E0350
+#define VENC_AVID_START_STOP_Y_NTSC_M		0x02060024
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y_NTSC_M 0x020701A0
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X_NTSC_M 0x01AC0024
+#define VENC_AVID_START_STOP_X_NTSC_M		0x03480078
+#define VENC_GAIN_U_NTSC_M			0x00000102
+#define VENC_GAIN_U_NTSC_J			0x00000100
+#define VENC_GAIN_U_NTSC_443			0x00000140
+
+#define VENC_GAIN_V_NTSC_M			0x0000016C
+#define VENC_GAIN_V_NTSC_J			0x0000016D
+#define VENC_GAIN_V_NTSC_443			0x00000190
+
+#define VENC_GAIN_Y_NTSC_M			0x0000012F
+#define VENC_GAIN_Y_NTSC_J			0x00000196
+#define VENC_GAIN_Y_NTSC_443			0x000001C0
+
+#define VENC_BLACK_LEVEL_NTSC_443		0x00000069
+#define VENC_BLANK_LEVEL_NTSC_443		0x0000005C
+
+#define VENC_BLACK_LEVEL_NTSC_M			0x00000043
+#define VENC_BLANK_LEVEL_NTSC_M			0x00000038
+
+#define VENC_BLACK_LEVEL_NTSC_J			0x00000053
+#define VENC_BLANK_LEVEL_NTSC_J			0x00000053
+
+#define VENC_M_CONTROL_NTSC			0x00000001
+
+#define VENC_BSTAMP_WSS_DATA_NTSC		0x00000038
+#define VENC_BSTAMP_WSS_DATA_NTSC_443		0x0000003F
+
+#define VENC_S_CARR_NTSC_443			0x2A098ACB
+#define VENC_S_CARR_NTSC			0x21F07C1F
+
+#define VENC_HTRIGGER_VTRIGGER_VAL		0x00000000
+
+#define VENC_FLEN_FAL_NTSC			0x0001020C
+
+#define VENC_LAL_PHASE_RESET_NTSC		0x00060107
+
+#define VENC_HS_INT_START_STOP_X_NTSC		0x007E034E
+
+#define VENC_HS_INT_START_STOP_X_443		0x007e034e
+
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y_NTSC	0x020901A0
+#define VENC_VS_INT_STOP_X_VS_INT_START_Y_NTSC_443 0x020901a0
+
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X_NTSC	0x01AC0022
+#define VENC_VS_INT_STOP_Y_VS_EXT_START_X_NTSC_443 0x01ac0022
+
+#define VENC_AVID_START_STOP_X_NTSC		0x032000A0
+#define VENC_AVID_START_STOP_X_NTSC_443		0x03480079
+
+#define VENC_AVID_START_STOP_Y_NTSC		0x02060026
+#define VENC_AVID_START_STOP_Y_NTSC_443		0x02040024
+
+#define VENC_TVDETGP_INT_START_STOP_X_GEN	0x00140001
+#define VENC_TVDETGP_INT_START_STOP_Y_GEN	0x00010001
+
+struct tv_standard_config{
+	u8 std_name[25];
+	u32 venc_llen;
+	u32 venc_flens;
+	u32 venc_hfltr_ctrl;
+	u32 venc_cc_carr_wss_carr;
+	u32 venc_c_phase;
+	u32 venc_gain_u;
+	u32 venc_gain_v;
+	u32 venc_gain_y;
+	u32 venc_black_level;
+	u32 venc_blank_level;
+	u32 venc_x_color;
+	u32 venc_m_control;
+	u32 venc_bstamp_wss_data;
+	u32 venc_s_carr;
+	u32 venc_line21;
+	u32 venc_ln_sel;
+	u32 venc_l21_wc_ctl;
+	u32 venc_htrigger_vtrigger;
+	u32 venc_savid_eavid;
+	u32 venc_flen_fal;
+	u32 venc_lal_phase_reset;
+	u32 venc_hs_int_start_stop_x;
+	u32 venc_hs_ext_start_stop_x;
+	u32 venc_vs_int_start_x;
+	u32 venc_vs_int_stop_x_vs_int_start_y;
+	u32 venc_vs_int_stop_y_vs_ext_start_x;
+	u32 venc_vs_ext_stop_x_vs_ext_start_y;
+	u32 venc_vs_ext_stop_y;
+	u32 venc_avid_start_stop_x;
+	u32 venc_avid_start_stop_y;
+	u32 venc_fid_int_start_x_fid_int_start_y;
+	u32 venc_fid_int_offset_y_fid_ext_start_x;
+	u32 venc_fid_ext_start_y_fid_ext_offset_y;
+	u32 venc_tvdetgp_int_start_stop_x;
+	u32 venc_tvdetgp_int_start_stop_y;
+	u32 venc_gen_ctrl;
+	u32 venc_dac_tst;
+};
+
+struct tv_standard_config tv_standards[] = {
+	{
+		"pal_bdghi",
+		VENC_LLEN_PAL,
+		VENC_FLENS_PAL,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_PAL_BDGHI,
+		VENC_C_PHASE_PAL_BDGHI,
+		VENC_GAIN_U_PAL_BDGHI,
+		VENC_GAIN_V_PAL_BDGHI,
+		VENC_GAIN_Y_PAL_BDGHI,
+		VENC_BLACK_LEVEL_PAL_BDGHI,
+		VENC_BLANK_LEVEL_PAL_BDGHI,
+		VENC_X_COLOR_VAL_NTSC_M,
+		VENC_M_CONTROL_PAL,
+		VENC_BSTAMP_WSS_DATA_PAL_M,
+		VENC_S_CARR_PAL_BDGHI,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL_PAL_BDGHI,
+		VENC_L21_WC_CTL_PAL,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_PAL,
+		VENC_FLEN_FAL_PAL_BDGHI,
+		VENC_LAL_PHASE_RESET_PAL_NC,
+		VENC_HS_INT_START_STOP_X_NC,
+		VENC_HS_EXT_START_STOP_X_PAL,
+		VENC_VS_INT_START_X_PAL,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL_BDGHI,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL_BDGHI,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_PAL_BDGHI,
+		VENC_VS_EXT_STOP_Y_PAL,
+		VENC_AVID_START_STOP_X_PAL_NC,
+		VENC_AVID_START_STOP_Y_PAL_BDGHI,
+		VENC_FID_INT_START_X_FID_INT_START_Y_GEN,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_PAL,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_PAL_BDGHI,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_PAL_VAL,
+		VENC_DAC_ENABLE
+	},
+
+	{
+		"pal_n",
+		VENC_LLEN_PAL,
+		VENC_FLENS_PAL,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_PAL,
+		VENC_C_PHASE_PAL,
+		VENC_GAIN_U_PAL_N,
+		VENC_GAIN_V_PAL_N,
+		VENC_GAIN_Y_PAL_N,
+		VENC_BLACK_LEVEL_PAL_N,
+		VENC_BLANK_LEVEL_PAL_N,
+		VENC_X_COLOR_VAL,
+		VENC_M_CONTROL_PAL,
+		VENC_BSTAMP_WSS_DATA_PAL_BDGHI,
+		VENC_S_CARR_PAL_BDGHI,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL,
+		VENC_L21_WC_CTL_PAL,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_PAL,
+		VENC_FLEN_FAL_PAL,
+		VENC_LAL_PHASE_RESET_PAL,
+		VENC_HS_INT_START_STOP_X_PAL,
+		VENC_HS_EXT_START_STOP_X_PAL,
+		VENC_VS_INT_START_X_PAL,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_PAL,
+		VENC_VS_EXT_STOP_Y_PAL,
+		VENC_AVID_START_STOP_X_PAL,
+		VENC_AVID_START_STOP_Y_PAL,
+		VENC_FID_INT_START_X_FID_INT_START_Y_PAL,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_PAL,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_PAL,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_PAL_VAL,
+		VENC_DAC_ENABLE
+	},
+
+	{
+		"pal_nc",
+		VENC_LLEN_PAL,
+		VENC_FLENS_PAL,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_PAL,
+		VENC_C_PHASE_PAL,
+		VENC_GAIN_U_PAL_NC,
+		VENC_GAIN_V_PAL_NC,
+		VENC_GAIN_Y_PAL_NC,
+		VENC_BLACK_LEVEL_PAL_NC,
+		VENC_BLANK_LEVEL_PAL_NC,
+		VENC_X_COLOR_VAL,
+		VENC_M_CONTROL_PAL,
+		VENC_BSTAMP_WSS_DATA_PAL_NC,
+		VENC_S_CARR_PAL_NC,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL,
+		VENC_L21_WC_CTL_PAL,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_PAL,
+		VENC_FLEN_FAL_PAL,
+		VENC_LAL_PHASE_RESET_PAL_NC,
+		VENC_HS_INT_START_STOP_X_NC,
+		VENC_HS_EXT_START_STOP_X_PAL,
+		VENC_VS_INT_START_X_PAL,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL_NC,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL_NC,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_PAL,
+		VENC_VS_EXT_STOP_Y_PAL,
+		VENC_AVID_START_STOP_X_PAL_NC,
+		VENC_AVID_START_STOP_Y_PAL_NC,
+		VENC_FID_INT_START_X_FID_INT_START_Y_PAL,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_PAL,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_PAL,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_PAL_VAL,
+		VENC_DAC_ENABLE
+	},
+
+	{
+		"pal_m",
+		VENC_LLEN_PAL_M,
+		VENC_FLENS_PAL_M,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_GEN,
+		VENC_C_PHASE_GEN,
+		VENC_GAIN_U_PAL_M,
+		VENC_GAIN_V_PAL_M,
+		VENC_GAIN_Y_PAL_M,
+		VENC_BLACK_LEVEL_PAL_M,
+		VENC_BLANK_LEVEL_PAL_M,
+		VENC_X_COLOR_VAL,
+		VENC_M_CONTROL_PAL_M,
+		VENC_BSTAMP_WSS_DATA_PAL_M,
+		VENC_S_CARR_PAL_M,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL,
+		VENC_L21_WC_CTL_GEN,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_GEN,
+		VENC_FLEN_FAL_GEN,
+		VENC_LAL_PHASE_RESET_PAL_2,
+		VENC_HS_INT_START_STOP_X_PAL_2,
+		VENC_HS_EXT_START_STOP_X_GEN,
+		VENC_VS_INT_START_X_GEN,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL_2,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL_2,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_GEN,
+		VENC_VS_EXT_STOP_Y_GEN,
+		VENC_AVID_START_STOP_X_PAL_2,
+		VENC_AVID_START_STOP_Y_PAL_2,
+		VENC_FID_INT_START_X_FID_INT_START_Y_GEN,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_GEN,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_GEN,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_VAL,
+		VENC_DAC_ENABLE
+	},
+
+	{
+		"pal_60",
+		VENC_LLEN_GEN,
+		VENC_FLENS_GEN,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_GEN,
+		VENC_C_PHASE_GEN,
+		VENC_GAIN_U_PAL_60,
+		VENC_GAIN_V_PAL_60,
+		VENC_GAIN_Y_PAL_60,
+		VENC_BLACK_LEVEL_PAL_60,
+		VENC_BLANK_LEVEL_PAL_60,
+		VENC_X_COLOR_VAL,
+		VENC_M_CONTROL_PAL_60,
+		VENC_BSTAMP_WSS_DATA_PAL_60,
+		VENC_S_CARR_PAL_60,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL,
+		VENC_L21_WC_CTL_GEN,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_GEN,
+		VENC_FLEN_FAL_GEN,
+		VENC_LAL_PHASE_RESET_PAL_2,
+		VENC_HS_INT_START_STOP_X_PAL_2,
+		VENC_HS_EXT_START_STOP_X_GEN,
+		VENC_VS_INT_START_X_GEN,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_PAL_2,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_PAL_2,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_GEN,
+		VENC_VS_EXT_STOP_Y_GEN,
+		VENC_AVID_START_STOP_X_PAL_2,
+		VENC_AVID_START_STOP_Y_PAL_2,
+		VENC_FID_INT_START_X_FID_INT_START_Y_GEN,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_GEN,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_GEN,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_VAL,
+		VENC_DAC_ENABLE
+	},
+
+	{
+		"ntsc_m",
+		VENC_LLEN_GEN,
+		VENC_FLENS_GEN,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_GEN_NTSC_M,
+		VENC_C_PHASE_GEN,
+		VENC_GAIN_U_NTSC_M,
+		VENC_GAIN_V_NTSC_M,
+		VENC_GAIN_Y_NTSC_M,
+		VENC_BLACK_LEVEL_NTSC_M,
+		VENC_BLANK_LEVEL_NTSC_M,
+		VENC_X_COLOR_VAL_NTSC_M,
+		VENC_M_CONTROL_NTSC,
+		VENC_BSTAMP_WSS_DATA_NTSC,
+		VENC_S_CARR_NTSC,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL_NTSC_M,
+		VENC_L21_WC_CTL_GEN_NTSC_M,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_GEN,
+		VENC_FLEN_FAL_GEN,
+		VENC_LAL_PHASE_RESET_NTSC,
+		VENC_HS_INT_START_STOP_X_NTSC_M,
+		VENC_HS_EXT_START_STOP_X_GEN,
+		VENC_VS_INT_START_X_GEN,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_NTSC_M,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_NTSC_M,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_GEN,
+		VENC_VS_EXT_STOP_Y_GEN,
+		VENC_AVID_START_STOP_X_NTSC_M,
+		VENC_AVID_START_STOP_Y_NTSC_M,
+		VENC_FID_INT_START_X_FID_INT_START_Y_GEN,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_GEN,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_GEN,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_PAL_VAL,
+		VENC_DAC_ENABLE
+	},
+
+	{
+		"ntsc_443",
+		VENC_LLEN_GEN,
+		VENC_FLENS_GEN,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_GEN,
+		VENC_C_PHASE_GEN,
+		VENC_GAIN_U_NTSC_443,
+		VENC_GAIN_V_NTSC_443,
+		VENC_GAIN_Y_NTSC_443,
+		VENC_BLACK_LEVEL_NTSC_443,
+		VENC_BLANK_LEVEL_NTSC_443,
+		VENC_X_COLOR_VAL,
+		VENC_M_CONTROL_NTSC,
+		VENC_BSTAMP_WSS_DATA_NTSC_443,
+		VENC_S_CARR_NTSC_443,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL,
+		VENC_L21_WC_CTL_GEN,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_GEN,
+		VENC_FLEN_FAL_GEN,
+		VENC_LAL_PHASE_RESET_NTSC,
+		VENC_HS_INT_START_STOP_X_443,
+		VENC_HS_EXT_START_STOP_X_GEN,
+		VENC_VS_INT_START_X_GEN,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_NTSC_443,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_NTSC_443,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_GEN,
+		VENC_VS_EXT_STOP_Y_GEN,
+		VENC_AVID_START_STOP_X_NTSC_443,
+		VENC_AVID_START_STOP_Y_NTSC_443,
+		VENC_FID_INT_START_X_FID_INT_START_Y_GEN,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_GEN,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_GEN,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_VAL,
+		VENC_DAC_ENABLE
+	},
+
+	{
+		"ntsc_j",
+		VENC_LLEN_GEN,
+		VENC_FLENS_GEN,
+		VENC_HFLTR_CTRL_EN,
+		VENC_CC_CARR_WSS_CARR_GEN,
+		VENC_C_PHASE_GEN,
+		VENC_GAIN_U_NTSC_J,
+		VENC_GAIN_V_NTSC_J,
+		VENC_GAIN_Y_NTSC_J,
+		VENC_BLACK_LEVEL_NTSC_J,
+		VENC_BLANK_LEVEL_NTSC_J,
+		VENC_X_COLOR_VAL,
+		VENC_M_CONTROL_NTSC,
+		VENC_BSTAMP_WSS_DATA_NTSC,
+		VENC_S_CARR_NTSC,
+		VENC_LINE21_VAL,
+		VENC_LN_SEL_VAL,
+		VENC_L21_WC_CTL_GEN,
+		VENC_HTRIGGER_VTRIGGER_VAL,
+		VENC_SAVID_EAVID_GEN,
+		VENC_FLEN_FAL_GEN,
+		VENC_LAL_PHASE_RESET_NTSC,
+		VENC_HS_INT_START_STOP_X_NTSC,
+		VENC_HS_EXT_START_STOP_X_GEN,
+		VENC_VS_INT_START_X_GEN,
+		VENC_VS_INT_STOP_X_VS_INT_START_Y_NTSC,
+		VENC_VS_INT_STOP_Y_VS_EXT_START_X_NTSC,
+		VENC_VS_EXT_STOP_X_VS_EXT_START_Y_GEN,
+		VENC_VS_EXT_STOP_Y_GEN,
+		VENC_AVID_START_STOP_X_NTSC,
+		VENC_AVID_START_STOP_Y_NTSC,
+		VENC_FID_INT_START_X_FID_INT_START_Y_GEN,
+		VENC_FID_INT_OFFSET_Y_FID_EXT_START_X_GEN,
+		VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y_GEN,
+		VENC_TVDETGP_INT_START_STOP_X_GEN,
+		VENC_TVDETGP_INT_START_STOP_Y_GEN,
+		VENC_GEN_CTRL_VAL,
+		VENC_DAC_ENABLE
+	}
+};
+
+/*
+ * Initialization/Deinitialization function declaration
+ */
+static int tv_initialize(void *data);
+static int tv_deinitialize(void *data);
+
+/*
+ * Standard get/set function declaration
+ */
+static int omap_venc_setstd(char *mode_name, void *data);
+static char *omap_venc_getstd(void *data);
+
+/*
+ * Output set/get/enum function declaration
+ */
+static int omap_venc_setoutput(int index, char *mode_name, void *data);
+static char *omap_venc_enumoutput(int index, void *data);
+
+struct omap_output_info outputs[] = {
+	{"SVIDEO", (void *)tv_standards, ARRAY_SIZE(tv_standards), 5,
+	 0}
+};
+
+#define OMAP_VENC_NO_OUTPUTS 1
+static struct omap_enc_output_ops outputs_ops = {
+	.count = OMAP_VENC_NO_OUTPUTS,
+	.enumoutput = omap_venc_enumoutput,
+	.setoutput = omap_venc_setoutput,
+	.getoutput = NULL,
+};
+
+static struct omap_enc_mode_ops standards_ops = {
+	.setmode = omap_venc_setstd,
+	.getmode = omap_venc_getstd,
+};
+
+struct omap_encoder_device tv_enc = {
+	.name = ENCODER_NAME,
+	.channel_id = 1,
+	.current_output = 0,
+	.no_outputs = 1,
+	.initialize = tv_initialize,
+	.deinitialize = tv_deinitialize,
+	.output_ops = &outputs_ops,
+	.mode_ops = &standards_ops,
+};
+
+/*
+ * VENC register I/O Routines
+ */
+static inline u32 venc_reg_in(u32 offset)
+{
+	return omap_readl(DSS_REG_BASE + VENC_REG_OFFSET + offset);
+}
+
+static inline u32 venc_reg_out(u32 offset, u32 val)
+{
+	omap_writel(val, DSS_REG_BASE + VENC_REG_OFFSET + offset);
+	return val;
+}
+
+static inline u32 venc_reg_merge(u32 offset, u32 val, u32 mask)
+{
+	u32 addr = DSS_REG_BASE + VENC_REG_OFFSET + offset;
+	u32 new_val = (omap_readl(addr) & ~mask) | (val & mask);
+
+	omap_writel(new_val, addr);
+	return new_val;
+}
+
+int tv_initialize(void *data)
+{
+	return 0;
+}
+
+int tv_deinitialize(void *data)
+{
+	return 0;
+}
+
+static void config_venc(struct tv_standard_config *tvstd)
+{
+	int i;
+
+	i = 0;
+	/*
+	 * Write 1 to the 8th bit of the F_Control register to reset the VENC
+	 */
+	venc_reg_merge(VENC_F_CONTROL, VENC_FCONTROL_RESET,
+			VENC_FCONTROL_RESET);
+	/* wait for reset to complete */
+	while ((venc_reg_in(VENC_F_CONTROL) & VENC_FCONTROL_RESET) ==
+			0x00000100) {
+		udelay(10);
+		if (i++ > 10)
+			break;
+	}
+
+	if (venc_reg_in(VENC_F_CONTROL) & VENC_FCONTROL_RESET) {
+		printk(KERN_WARNING
+				"omap_disp: timeout waiting for venc reset\n");
+		/* remove the reset */
+		venc_reg_merge(VENC_F_CONTROL, (0 << 8),
+				VENC_FCONTROL_RESET);
+	}
+
+	venc_reg_out(VENC_LLEN, tvstd->venc_llen);
+	venc_reg_out(VENC_FLENS, tvstd->venc_flens);
+	venc_reg_out(VENC_HFLTR_CTRL, tvstd->venc_hfltr_ctrl);
+	venc_reg_out(VENC_CC_CARR_WSS_CARR, tvstd->venc_cc_carr_wss_carr);
+	venc_reg_out(VENC_C_PHASE, tvstd->venc_c_phase);
+	venc_reg_out(VENC_GAIN_U, tvstd->venc_gain_u);
+	venc_reg_out(VENC_GAIN_V, tvstd->venc_gain_v);
+	venc_reg_out(VENC_GAIN_Y, tvstd->venc_gain_y);
+	venc_reg_out(VENC_BLACK_LEVEL, tvstd->venc_black_level);
+	venc_reg_out(VENC_BLANK_LEVEL, tvstd->venc_blank_level);
+	venc_reg_out(VENC_X_COLOR, tvstd->venc_x_color);
+	venc_reg_out(VENC_M_CONTROL, tvstd->venc_m_control);
+	venc_reg_out(VENC_BSTAMP_WSS_DATA, tvstd->venc_bstamp_wss_data);
+	venc_reg_out(VENC_S_CARR, tvstd->venc_s_carr);
+	venc_reg_out(VENC_LINE21, tvstd->venc_line21);
+	venc_reg_out(VENC_LN_SEL, tvstd->venc_ln_sel);
+	venc_reg_out(VENC_L21_WC_CTL, tvstd->venc_l21_wc_ctl);
+	venc_reg_out(VENC_HTRIGGER_VTRIGGER,
+			tvstd->venc_htrigger_vtrigger);
+	venc_reg_out(VENC_SAVID_EAVID, tvstd->venc_savid_eavid);
+	venc_reg_out(VENC_FLEN_FAL, tvstd->venc_flen_fal);
+	venc_reg_out(VENC_LAL_PHASE_RESET, tvstd->venc_lal_phase_reset);
+	venc_reg_out(VENC_HS_INT_START_STOP_X,
+			tvstd->venc_hs_int_start_stop_x);
+	venc_reg_out(VENC_HS_EXT_START_STOP_X,
+			tvstd->venc_hs_ext_start_stop_x);
+	venc_reg_out(VENC_VS_INT_START_X, tvstd->venc_vs_int_start_x);
+	venc_reg_out(VENC_VS_INT_STOP_X_VS_INT_START_Y,
+			tvstd->venc_vs_int_stop_x_vs_int_start_y);
+	venc_reg_out(VENC_VS_INT_STOP_Y_VS_EXT_START_X,
+			tvstd->venc_vs_int_stop_y_vs_ext_start_x);
+	venc_reg_out(VENC_VS_EXT_STOP_X_VS_EXT_START_Y,
+			tvstd->venc_vs_ext_stop_x_vs_ext_start_y);
+	venc_reg_out(VENC_VS_EXT_STOP_Y, tvstd->venc_vs_ext_stop_y);
+	venc_reg_out(VENC_AVID_START_STOP_X,
+			tvstd->venc_avid_start_stop_x);
+	venc_reg_out(VENC_AVID_START_STOP_Y,
+			tvstd->venc_avid_start_stop_y);
+	venc_reg_out(VENC_FID_INT_START_X_FID_INT_START_Y,
+			tvstd->venc_fid_int_start_x_fid_int_start_y);
+	venc_reg_out(VENC_FID_INT_OFFSET_Y_FID_EXT_START_X,
+			tvstd->venc_fid_int_offset_y_fid_ext_start_x);
+	venc_reg_out(VENC_FID_EXT_START_Y_FID_EXT_OFFSET_Y,
+			tvstd->venc_fid_ext_start_y_fid_ext_offset_y);
+	venc_reg_out(VENC_TVDETGP_INT_START_STOP_X,
+			tvstd->venc_tvdetgp_int_start_stop_x);
+	venc_reg_out(VENC_TVDETGP_INT_START_STOP_Y,
+			tvstd->venc_tvdetgp_int_start_stop_y);
+	venc_reg_out(VENC_GEN_CTRL, tvstd->venc_gen_ctrl);
+	venc_reg_out(VENC_DAC_TST, tvstd->venc_dac_tst);
+	venc_reg_out(VENC_DAC, venc_reg_in(VENC_DAC));
+	venc_reg_out(VENC_F_CONTROL, F_CONTROL_GEN);
+	venc_reg_out(VENC_SYNC_CONTROL, SYNC_CONTROL_GEN);
+}
+
+int omap_venc_setstd(char *mode_name, void *data)
+{
+	int i;
+	struct omap_encoder_device *enc_dev;
+
+	enc_dev = (struct omap_encoder_device *) data;
+
+	if (!mode_name)
+		return -1;
+	for (i = 0; i < ARRAY_SIZE(tv_standards); i++) {
+		if (!(strcmp(tv_standards[i].std_name, mode_name))) {
+			outputs[enc_dev->current_output].current_mode = i;
+			config_venc(&tv_standards[i]);
+			return 0;
+		}
+	}
+	return -1;
+
+}
+
+char *omap_venc_getstd(void *data)
+{
+	int mode_index;
+	struct omap_encoder_device *enc_dev =
+			(struct omap_encoder_device *) data;
+
+	mode_index = outputs[enc_dev->current_output].current_mode;
+	return tv_standards[mode_index].std_name;
+}
+
+int omap_venc_setoutput(int index, char *mode_name, void *data)
+{
+	struct omap_encoder_device *enc_dev =
+			(struct omap_encoder_device *)data;
+	u32 current_mode;
+
+	enc_dev->current_output = index;
+	current_mode = outputs[enc_dev->current_output].current_mode;
+	config_venc(&tv_standards[current_mode]);
+	strcpy(mode_name, tv_standards[current_mode].std_name);
+
+	return 0;
+}
+
+char *omap_venc_enumoutput(int index, void *data)
+{
+	return outputs[index].name;
+}
+
+static int tv_in_use;
+
+static void tvout_off(struct work_struct *work);
+static void tvout_on(struct work_struct *work);
+
+DECLARE_WORK(work_q_tvout_on, tvout_on);
+DECLARE_WORK(work_q_tvout_off, tvout_off);
+
+static void power_tv(int level)
+{
+	switch (level) {
+	case TV_OFF:
+		if (!in_interrupt())
+			tvout_off(NULL);
+		else
+			schedule_work(&work_q_tvout_off);
+		break;
+	default:
+		if (!in_interrupt())
+			tvout_on(NULL);
+		else
+			schedule_work(&work_q_tvout_on);
+		break;
+	}
+}
+
+static void tvout_off(struct work_struct *work)
+{
+	omap_disp_set_tvref(TVREF_OFF);
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x00,
+			     TWL4030_VDAC_DEDICATED);
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x00,
+			     TWL4030_VDAC_DEV_GRP);
+}
+
+static void tvout_on(struct work_struct *work)
+{
+	omap_disp_set_tvref(TVREF_ON);
+
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+			     ENABLE_VDAC_DEDICATED,
+			     TWL4030_VDAC_DEDICATED);
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+			     ENABLE_VDAC_DEV_GRP, TWL4030_VDAC_DEV_GRP);
+}
+
+static int tv_init(void)
+{
+	omap_disp_get_all_clks();
+	power_tv(TV_ON);
+	omap_disp_enable_output_dev(OMAP_OUTPUT_TV);
+	omap_disp_put_all_clks();
+	tv_in_use = 1;
+	if (omap_register_encoder(&tv_enc))
+		return -1;
+
+	return 0;
+}
+
+static int tv_exit(void)
+{
+	if (!tv_in_use)
+		return 0;
+
+	omap_disp_get_all_clks();
+	omap_disp_disable_output_dev(OMAP_OUTPUT_TV);
+	power_tv(TV_OFF);
+	omap_disp_put_all_clks();
+	tv_in_use = 0;
+	return 0;
+}
+
+static int __init tv_probe(struct platform_device *odev);
+#ifdef CONFIG_PM
+static int tv_suspend(struct platform_device *odev, pm_message_t state);
+static int tv_resume(struct platform_device *odev);
+#endif
+
+static struct platform_driver omap_tv_driver = {
+	.driver = {
+		   .name = OMAP_TV_DRIVER,
+		   },
+	.probe = tv_probe,
+#ifdef CONFIG_PM
+	.suspend = tv_suspend,
+	.resume = tv_resume,
+#endif
+};
+
+static int __init tv_probe(struct platform_device *odev)
+{
+	return tv_init();
+}
+#ifdef CONFIG_PM
+static int tv_suspend(struct platform_device *odev, pm_message_t state)
+{
+	if (!tv_in_use)
+		return 0;
+
+	/* TODO-- need to delink DSS and TV clocks.. For now, TV is put to
+	 * off in fb_blank and put_dss */
+
+	tv_in_use = 0;
+
+	return 0;
+}
+
+static int tv_resume(struct platform_device *odev)
+{
+	if (tv_in_use)
+		return 0;
+
+	/* TODO-- need to delink DSS and TV clocks.. For now, TV is put to
+	 * on in fb_blank and get_dss */
+	tv_in_use = 1;
+	return 0;
+}
+
+#endif				/* CONFIG_PM */
+
+static int __init omap_tv_init(void)
+{
+	/* Register the driver with LDM */
+	printk("Platform driver register called\n");
+	if (platform_driver_register(&omap_tv_driver)) {
+		printk(KERN_ERR ": failed to register omap_tv driver\n");
+		return -ENODEV;
+	}
+	return 0;
+
+}
+
+device_initcall(omap_tv_init);
+
+static void __exit
+omap_tv_exit(void)
+{
+
+	tv_exit();
+	platform_driver_unregister(&omap_tv_driver);
+}
+module_exit(omap_tv_exit);
+
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 3538067..3f268d9 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -88,6 +88,10 @@ static inline void __init omap3evm_init_smc911x(void)
 static struct omap_uart_config omap3_evm_uart_config __initdata = {
 	.enabled_uarts	= ((1 << 0) | (1 << 1) | (1 << 2)),
 };
+static struct platform_device omap3evm_tv_device = {
+	.name = "omap3evm_tv",
+	.id = -1,
+};
 
 static struct twl4030_gpio_platform_data omap3evm_gpio_data = {
 	.gpio_base	= OMAP_MAX_GPIO_LINES,
@@ -231,6 +235,7 @@ static struct omap_board_config_kernel omap3_evm_config[] __initdata = {
 static struct platform_device *omap3_evm_devices[] __initdata = {
 	&omap3_evm_lcd_device,
 	&omap3evm_smc911x_device,
+	&omap3evm_tv_device,
 };
 
 static void __init omap3_evm_init(void)
-- 
1.5.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
