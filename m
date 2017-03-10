Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28007 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933408AbdCJLek (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:34:40 -0500
Subject: [PATCH 5/8] atomisp: eliminate intel_mid_pm.h
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:34:27 +0000
Message-ID: <148914565834.25309.17445812420921994793.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
References: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We can do this because the only thing it is used for is identifying the
platform for power management purposes. The driver only supports Baytrail
and Cherrytrail and both of those always need the IPU to be power managed
directly not via PCI D3 states.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/include/linux/intel_mid_pm.h     |  233 --------------------
 .../media/atomisp/pci/atomisp2/atomisp_v4l2.c      |   33 +--
 2 files changed, 10 insertions(+), 256 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/include/linux/intel_mid_pm.h

diff --git a/drivers/staging/media/atomisp/include/linux/intel_mid_pm.h b/drivers/staging/media/atomisp/include/linux/intel_mid_pm.h
deleted file mode 100644
index 82f8b57..0000000
--- a/drivers/staging/media/atomisp/include/linux/intel_mid_pm.h
+++ /dev/null
@@ -1,233 +0,0 @@
-/*
- * intel_mid_pm.h
- * Copyright (c) 2010, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- */
-#include <linux/errno.h>
-
-#ifndef INTEL_MID_PM_H
-#define INTEL_MID_PM_H
-
-#include "../asm/intel-mid.h"
-#include <linux/init.h>
-#include <linux/pci.h>
-
-
-/* Chip ID of Intel Atom SOC*/
-#define INTEL_ATOM_MRST 0x26
-#define INTEL_ATOM_MFLD 0x27
-#define INTEL_ATOM_CLV 0x35
-#define INTEL_ATOM_MRFLD 0x4a
-#define INTEL_ATOM_BYT 0x37
-#define INTEL_ATOM_MOORFLD 0x5a
-#define INTEL_ATOM_CHT 0x4c
-
-static inline int platform_is(u8 model)
-{
-	return boot_cpu_data.x86_model == model;
-}
-
-/* Register Type definitions */
-#define OSPM_REG_TYPE          0x0
-#define APM_REG_TYPE           0x1
-#define OSPM_MAX_POWER_ISLANDS 16
-#define OSPM_ISLAND_UP         0x0
-#define OSPM_ISLAND_DOWN       0x1
-/*Soft reset*/
-#define OSPM_ISLAND_SR         0x2
-
-/* North complex power islands definitions for APM block*/
-#define APM_GRAPHICS_ISLAND    0x1
-#define APM_VIDEO_DEC_ISLAND   0x2
-#define APM_VIDEO_ENC_ISLAND   0x4
-#define APM_GL3_CACHE_ISLAND   0x8
-#define APM_ISP_ISLAND         0x10
-#define APM_IPH_ISLAND         0x20
-
-/* North complex power islands definitions for OSPM block*/
-#define OSPM_DISPLAY_A_ISLAND  0x2
-#define OSPM_DISPLAY_B_ISLAND  0x80
-#define OSPM_DISPLAY_C_ISLAND  0x100
-#define OSPM_MIPI_ISLAND       0x200
-
-/* North Complex power islands definitions for Tangier */
-#define TNG_ISP_ISLAND		0x1
-/* North Complex Register definitions for Tangier */
-#define	ISP_SS_PM0		0x39
-
-#define C4_STATE_IDX	3
-#define C6_STATE_IDX	4
-#define S0I1_STATE_IDX  5
-#define LPMP3_STATE_IDX 6
-#define S0I3_STATE_IDX  7
-
-#define C4_HINT	(0x30)
-#define C6_HINT	(0x52)
-
-#define CSTATE_EXIT_LATENCY_C1	 1
-#define CSTATE_EXIT_LATENCY_C2	 20
-#define CSTATE_EXIT_LATENCY_C4	 100
-#define CSTATE_EXIT_LATENCY_C6	 140
-#define CSTATE_EXIT_LATENCY_C7	 1200
-
-/* Since entry latency is substantial
- * put exit_latency = entry+exit latency
- */
-#ifdef CONFIG_REMOVEME_INTEL_ATOM_MRFLD_POWER
-#define CSTATE_EXIT_LATENCY_S0i1 1200
-#define CSTATE_EXIT_LATENCY_S0i2 2000
-#define CSTATE_EXIT_LATENCY_S0i3 10000
-#else
-#define CSTATE_EXIT_LATENCY_LPMP3 1040
-#define CSTATE_EXIT_LATENCY_S0i1 1040
-#define CSTATE_EXIT_LATENCY_S0i3 2800
-#endif
-#define BYT_S0I1_STATE         0x60
-#define BYT_S0I2_STATE         0x62
-#define BYT_LPMP3_STATE        0x62
-#define BYT_S0I3_STATE         0x64
-
-enum s3_parts {
-	PROC_FRZ,
-	DEV_SUS,
-	NB_CPU_OFF,
-	NB_CPU_ON,
-	DEV_RES,
-	PROC_UNFRZ,
-	MAX_S3_PARTS
-};
-
-#ifdef CONFIG_ATOM_SOC_POWER
-#define LOG_PMU_EVENTS
-
-/* Error codes for pmu */
-#define	PMU_SUCCESS			0
-#define PMU_FAILED			-1
-#define PMU_BUSY_STATUS			0
-#define PMU_MODE_ID			1
-#define	SET_MODE			1
-#define	SET_AOAC_S0i1			2
-#define	SET_AOAC_S0i3			3
-#define	SET_LPAUDIO			4
-#define	SET_AOAC_S0i2			7
-
-#ifdef CONFIG_REMOVEME_INTEL_ATOM_MRFLD_POWER
-#define MID_S0I1_STATE         0x60
-#define MID_S0I2_STATE         0x62
-#define MID_LPMP3_STATE        0x62
-#define MID_S0I3_STATE         0x64
-#else
-#define MID_S0I1_STATE         0x1
-#define MID_LPMP3_STATE        0x3
-#define MID_S0I2_STATE         0x7
-#define MID_S0I3_STATE         0x7
-#endif
-
-#define MID_S0IX_STATE         0xf
-#define MID_S3_STATE           0x1f
-#define MID_FAST_ON_OFF_STATE  0x3f
-
-/* combinations */
-#define MID_LPI1_STATE         0x1f
-#define MID_LPI3_STATE         0x7f
-#define MID_I1I3_STATE         0xff
-
-#define REMOVE_LP_FROM_LPIX    4
-
-/* Power number for MID_POWER */
-#define C0_POWER_USAGE         450
-#define C6_POWER_USAGE         200
-#define LPMP3_POWER_USAGE      130
-#define S0I1_POWER_USAGE       50
-#define S0I3_POWER_USAGE       31
-
-extern unsigned int enable_s3;
-extern unsigned int enable_s0ix;
-
-extern void pmu_s0ix_demotion_stat(int req_state, int grant_state);
-extern unsigned int pmu_get_new_cstate(unsigned int cstate, int *index);
-extern int get_target_platform_state(unsigned long *eax);
-extern int mid_s0ix_enter(int);
-extern int pmu_set_devices_in_d0i0(void);
-extern int pmu_pci_set_power_state(struct pci_dev *pdev, pci_power_t state);
-extern pci_power_t pmu_pci_choose_state(struct pci_dev *pdev);
-
-extern void time_stamp_in_suspend_flow(int mark, bool start);
-extern void time_stamp_for_sleep_state_latency(int sleep_state,
-						bool start, bool entry);
-extern int mid_state_to_sys_state(int mid_state);
-extern void pmu_power_off(void);
-extern void pmu_set_s0ix_complete(void);
-extern bool pmu_is_s0ix_in_progress(void);
-extern int pmu_nc_set_power_state
-	(int islands, int state_type, int reg_type);
-extern int pmu_nc_get_power_state(int island, int reg_type);
-extern int pmu_set_emmc_to_d0i0_atomic(void);
-
-#ifdef LOG_PMU_EVENTS
-extern void pmu_log_ipc(u32 command);
-extern void pmu_log_ipc_irq(void);
-#else
-static inline void pmu_log_ipc(u32 command) { return; };
-static inline void pmu_log_ipc_irq(void) { return; };
-#endif
-extern void dump_nc_power_history(void);
-
-extern bool mid_pmu_is_wake_source(u32 lss_number);
-
-extern void (*nc_report_power_state) (u32, int);
-#else
-
-/*
- * If CONFIG_ATOM_SOC_POWER is not defined
- * fall back to C6
- */
-
-#define MID_S0I1_STATE         C6_HINT
-#define MID_LPMP3_STATE        C6_HINT
-#define MID_S0I3_STATE         C6_HINT
-#define MID_S3_STATE           C6_HINT
-#define MID_FAST_ON_OFF_STATE  C6_HINT
-
-/* Power usage unknown if MID_POWER not defined */
-#define C0_POWER_USAGE         0
-#define C6_POWER_USAGE         0
-#define LPMP3_POWER_USAGE      0
-#define S0I1_POWER_USAGE       0
-#define S0I3_POWER_USAGE       0
-
-#define TEMP_DTS_ID     43
-
-static inline int pmu_nc_set_power_state
-	(int islands, int state_type, int reg_type) { return 0; }
-static inline int pmu_nc_get_power_state(int island, int reg_type) { return 0; }
-
-static inline void pmu_set_s0ix_complete(void) { return; }
-static inline bool pmu_is_s0ix_in_progress(void) { return false; };
-static inline unsigned int pmu_get_new_cstate
-			(unsigned int cstate, int *index) { return cstate; };
-
-/*returns function not implemented*/
-static inline void time_stamp_in_suspend_flow(int mark, bool start) {}
-static inline void time_stamp_for_sleep_state_latency(int sleep_state,
-					bool start, bool entry) {}
-static inline int mid_state_to_sys_state(int mid_state) { return 0; }
-
-static inline int pmu_set_devices_in_d0i0(void) { return 0; }
-static inline void pmu_log_ipc(u32 command) { return; };
-static inline void pmu_log_ipc_irq(void) { return; };
-static inline int pmu_set_emmc_to_d0i0_atomic(void) { return -ENOSYS; }
-static inline void pmu_power_off(void) { return; }
-static inline bool mid_pmu_is_wake_source(u32 lss_number) { return false; }
-#endif /* #ifdef CONFIG_ATOM_SOC_POWER */
-
-#endif /* #ifndef INTEL_MID_PM_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 46cdb0f..97103b4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -1,7 +1,7 @@
 /*
  * Support for Medifield PNW Camera Imaging ISP subsystem.
  *
- * Copyright (c) 2010 Intel Corporation. All Rights Reserved.
+ * Copyright (c) 2010-2017 Intel Corporation. All Rights Reserved.
  *
  * Copyright (c) 2010 Silicon Hive www.siliconhive.com.
  *
@@ -27,7 +27,6 @@
 #include <linux/timer.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include "../../include/linux/intel_mid_pm.h"
 
 #include "../../include/linux/atomisp_gmin_platform.h"
 
@@ -47,15 +46,11 @@
 #include "hrt/hive_isp_css_mm_hrt.h"
 
 #include "device_access.h"
-#include "../../include/linux/intel_mid_pm.h"
 #include <asm/intel-mid.h>
 
 /* G-Min addition: pull this in from intel_mid_pm.h */
 #define CSTATE_EXIT_LATENCY_C1  1
 
-/* Moorefield lacks PCI PM, BYT advertises it but it's broken, use PUNIT */
-#define ATOMISP_INTERNAL_PM	(IS_MOFD || IS_BYT || IS_CHT)
-
 #ifdef ISP2401
 static uint skip_fwload = 0;
 module_param(skip_fwload, uint, 0644);
@@ -526,8 +521,7 @@ int atomisp_runtime_suspend(struct device *dev)
 	if (ret)
 		return ret;
 	pm_qos_update_request(&isp->pm_qos, PM_QOS_DEFAULT_VALUE);
-	if (ATOMISP_INTERNAL_PM)
-		ret = atomisp_mrfld_power_down(isp);
+	ret = atomisp_mrfld_power_down(isp);
 
 	return ret;
 }
@@ -538,11 +532,9 @@ int atomisp_runtime_resume(struct device *dev)
 		dev_get_drvdata(dev);
 	int ret;
 
-	if (ATOMISP_INTERNAL_PM) {
-		ret = atomisp_mrfld_power_up(isp);
-		if (ret)
+	ret = atomisp_mrfld_power_up(isp);
+	if (ret)
 			return ret;
-	}
 
 	pm_qos_update_request(&isp->pm_qos, isp->max_isr_latency);
 	if (isp->sw_contex.power_state == ATOM_ISP_POWER_DOWN) {
@@ -597,8 +589,7 @@ static int atomisp_suspend(struct device *dev)
 		return ret;
 	}
 	pm_qos_update_request(&isp->pm_qos, PM_QOS_DEFAULT_VALUE);
-	if (ATOMISP_INTERNAL_PM)
-		ret = atomisp_mrfld_power_down(isp);
+	ret = atomisp_mrfld_power_down(isp);
 
 	return ret;
 }
@@ -609,11 +600,9 @@ static int atomisp_resume(struct device *dev)
 		dev_get_drvdata(dev);
 	int ret;
 
-	if (ATOMISP_INTERNAL_PM) {
-		ret = atomisp_mrfld_power_up(isp);
-		if (ret)
-			return ret;
-	}
+	ret = atomisp_mrfld_power_up(isp);
+	if (ret)
+		return ret;
 
 	pm_qos_update_request(&isp->pm_qos, isp->max_isr_latency);
 
@@ -1545,10 +1534,8 @@ static int atomisp_pci_probe(struct pci_dev *dev,
 	atomisp_ospm_dphy_down(isp);
 
 	/* Address later when we worry about the ...field chips */
-	if (ATOMISP_INTERNAL_PM) {
-		if (atomisp_mrfld_power_down(isp))
-			dev_err(&dev->dev, "Failed to switch off ISP\n");
-	}
+	if (atomisp_mrfld_power_down(isp))
+		dev_err(&dev->dev, "Failed to switch off ISP\n");
 	pci_dev_put(isp->pci_root);
 	return err;
 }
