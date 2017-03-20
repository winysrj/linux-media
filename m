Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20525 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755445AbdCTOid (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 10:38:33 -0400
Subject: [PATCH 01/24] atomisp: remove the iefd2 kernel
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Mon, 20 Mar 2017 14:38:13 +0000
Message-ID: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While this is included and the headers pulled in nothing actually uses this
functionality in the driver, so remove it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    3 
 .../ia_css_isp_params.c                            |    1 
 .../ia_css_isp_states.h                            |    1 
 .../ia_css_isp_params.c                            |    1 
 .../ia_css_isp_states.h                            |    1 
 .../ia_css_isp_params.c                            |    1 
 .../ia_css_isp_states.h                            |    1 
 .../isp/kernels/iefd2_6/ia_css_iefd2_6.host.c      |  200 --------------------
 .../isp/kernels/iefd2_6/ia_css_iefd2_6.host.h      |   46 -----
 .../kernels/iefd2_6/ia_css_iefd2_6_default.host.c  |  144 --------------
 .../kernels/iefd2_6/ia_css_iefd2_6_default.host.h  |   23 --
 .../isp/kernels/iefd2_6/ia_css_iefd2_6_param.h     |   83 --------
 .../isp/kernels/iefd2_6/ia_css_iefd2_6_state.h     |   32 ---
 .../isp/kernels/iefd2_6/ia_css_iefd2_6_types.h     |  164 ----------------
 14 files changed, 701 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_state.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_types.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index f538e56..162bcbf 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -56,8 +56,6 @@ atomisp-objs += \
 	css2400/isp/kernels/macc/macc_1.0/ia_css_macc.host.o \
 	css2400/isp/kernels/macc/macc_1.0/ia_css_macc_table.host.o \
 	css2400/isp/kernels/csc/csc_1.0/ia_css_csc.host.o \
-	css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.o \
-	css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.o \
 	css2400/isp/kernels/bnr/bnr_1.0/ia_css_bnr.host.o \
 	css2400/isp/kernels/bnr/bnr2_2/ia_css_bnr2_2.host.o \
 	css2400/isp/kernels/dpc2/ia_css_dpc2.host.o \
@@ -274,7 +272,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/gc/gc_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/gc/gc_2/ \
 	-I$(atomisp)/css2400/isp/kernels/hdr/ \
-	-I$(atomisp)/css2400/isp/kernels/iefd2_6/ \
 	-I$(atomisp)/css2400/isp/kernels/io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/io_ls/bayer_io_ls/ \
 	-I$(atomisp)/css2400/isp/kernels/io_ls/common/ \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
index 744e56e..8a35750 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_params.c
@@ -51,7 +51,6 @@
 #include "isp/kernels/ynr/ynr_2/ia_css_ynr2.host.h"
 #include "isp/kernels/fc/fc_1.0/ia_css_formats.host.h"
 #include "isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h"
-#include "isp/kernels/iefd2_6/ia_css_iefd2_6.host.h"
 #include "isp/kernels/dpc2/ia_css_dpc2.host.h"
 #include "isp/kernels/eed1_8/ia_css_eed1_8.host.h"
 #include "isp/kernels/bnlm/ia_css_bnlm.host.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h
index d658a00..939dc36 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2400_system/hive_isp_css_2400_system_generated/ia_css_isp_states.h
@@ -22,7 +22,6 @@
 #include "isp/kernels/ref/ref_1.0/ia_css_ref.host.h"
 #include "isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.h"
 #include "isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.h"
-#include "isp/kernels/iefd2_6/ia_css_iefd2_6.host.h"
 #include "isp/kernels/dpc2/ia_css_dpc2.host.h"
 #include "isp/kernels/eed1_8/ia_css_eed1_8.host.h"
 /* Generated code: do not edit or commmit. */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
index fcc37d1..2672137 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_params.c
@@ -52,7 +52,6 @@
 #include "isp/kernels/ynr/ynr_2/ia_css_ynr2.host.h"
 #include "isp/kernels/fc/fc_1.0/ia_css_formats.host.h"
 #include "isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h"
-#include "isp/kernels/iefd2_6/ia_css_iefd2_6.host.h"
 #include "isp/kernels/dpc2/ia_css_dpc2.host.h"
 #include "isp/kernels/eed1_8/ia_css_eed1_8.host.h"
 #include "isp/kernels/bnlm/ia_css_bnlm.host.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h
index d658a00..939dc36 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_csi2p_system/hive_isp_css_2401_system_csi2p_generated/ia_css_isp_states.h
@@ -22,7 +22,6 @@
 #include "isp/kernels/ref/ref_1.0/ia_css_ref.host.h"
 #include "isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.h"
 #include "isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.h"
-#include "isp/kernels/iefd2_6/ia_css_iefd2_6.host.h"
 #include "isp/kernels/dpc2/ia_css_dpc2.host.h"
 #include "isp/kernels/eed1_8/ia_css_eed1_8.host.h"
 /* Generated code: do not edit or commmit. */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
index fcc37d1..2672137 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_params.c
@@ -52,7 +52,6 @@
 #include "isp/kernels/ynr/ynr_2/ia_css_ynr2.host.h"
 #include "isp/kernels/fc/fc_1.0/ia_css_formats.host.h"
 #include "isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h"
-#include "isp/kernels/iefd2_6/ia_css_iefd2_6.host.h"
 #include "isp/kernels/dpc2/ia_css_dpc2.host.h"
 #include "isp/kernels/eed1_8/ia_css_eed1_8.host.h"
 #include "isp/kernels/bnlm/ia_css_bnlm.host.h"
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h
index d658a00..939dc36 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/css_2401_system/hive_isp_css_2401_system_generated/ia_css_isp_states.h
@@ -22,7 +22,6 @@
 #include "isp/kernels/ref/ref_1.0/ia_css_ref.host.h"
 #include "isp/kernels/tnr/tnr_1.0/ia_css_tnr.host.h"
 #include "isp/kernels/ynr/ynr_1.0/ia_css_ynr.host.h"
-#include "isp/kernels/iefd2_6/ia_css_iefd2_6.host.h"
 #include "isp/kernels/dpc2/ia_css_dpc2.host.h"
 #include "isp/kernels/eed1_8/ia_css_eed1_8.host.h"
 /* Generated code: do not edit or commmit. */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.c
deleted file mode 100644
index 270f423..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.c
+++ /dev/null
@@ -1,200 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef IA_CSS_NO_DEBUG
-#include "ia_css_debug.h"
-#endif
-#include "ia_css_iefd2_6.host.h"
-
-/* Copy parameters to VMEM
- */
-void
-ia_css_iefd2_6_vmem_encode(
-	struct iefd2_6_vmem_params *to,
-	const struct ia_css_iefd2_6_config *from,
-	size_t size)
-{
-	const unsigned total_blocks = 4;
-	const unsigned shuffle_block = 16;
-	unsigned i, j, base;
-	(void)size;
-
-	/* For configurable units parameters are copied to vmem. Per CU 3 arrays are copied:
-	 * x containing the x coordinates
-	 * a containing the slopes
-	 * b containing the intercept values.
-	 *
-	 * A 64 element vector is split up in 4 blocks of 16 element. Each array is copied to
-	 * a vector 4 times, (starting at 0, 16, 32 and 48). All array elements are copied or
-	 * initialised as described in the KFS. The remaining elements of a vector are set to 0.
-	 */
-	/* first init the vectors */
-	for(i = 0; i < total_blocks*shuffle_block; i++) {
-		to->e_cued_x[0][i] = 0;
-		to->e_cued_a[0][i] = 0;
-		to->e_cued_b[0][i] = 0;
-
-		to->e_cu_dir_x[0][i] = 0;
-		to->e_cu_dir_a[0][i] = 0;
-		to->e_cu_dir_b[0][i] = 0;
-
-		to->e_cu_non_dir_x[0][i] = 0;
-		to->e_cu_non_dir_a[0][i] = 0;
-		to->e_cu_non_dir_b[0][i] = 0;
-
-		to->e_curad_x[0][i] = 0;
-		to->e_curad_a[0][i] = 0;
-		to->e_curad_b[0][i] = 0;
-	}
-
-	/* Copy all data */
-	for(i = 0; i < total_blocks; i++) {
-		base = shuffle_block*i;
-
-
-		to->e_cued_x[0][base] = 0;
-		to->e_cued_a[0][base] = 0;
-		to->e_cued_b[0][base] = from->cu_ed_slopes_b[0];
-
-		to->e_cu_dir_x[0][base] = 0;
-		to->e_cu_dir_a[0][base] = 0;
-		to->e_cu_dir_b[0][base] = from->cu_dir_sharp_slopes_b[0];
-
-		to->e_cu_non_dir_x[0][base] = 0;
-		to->e_cu_non_dir_a[0][base] = 0;
-		to->e_cu_non_dir_b[0][base] = from->cu_non_dir_sharp_slopes_b[0];
-
-		to->e_curad_x[0][base] = 0;
-		to->e_curad_a[0][base] = 0;
-		to->e_curad_b[0][base] = from->cu_radial_slopes_b[0];
-
-		for (j = 1; j < 4; j++) {
-			to->e_cu_dir_a[0][base+j] = from->cu_dir_sharp_slopes_a[j-1];
-			to->e_cu_dir_b[0][base+j] = from->cu_dir_sharp_slopes_b[j-1];
-			to->e_cu_non_dir_a[0][base+j] = from->cu_non_dir_sharp_slopes_a[j-1];
-			to->e_cu_non_dir_b[0][base+j] = from->cu_non_dir_sharp_slopes_b[j-1];
-		}
-
-		for (j = 1; j < 5; j++) {
-			to->e_cu_dir_x[0][base+j] = from->cu_dir_sharp_points_x[j-1];
-			to->e_cu_non_dir_x[0][base+j] = from->cu_non_dir_sharp_points_x[j-1];
-		}
-
-
-		for (j = 1; j < 6; j++) {
-			to->e_cued_x[0][base+j] = from->cu_ed_points_x[j-1];
-			to->e_cued_a[0][base+j] = from->cu_ed_slopes_a[j-1];
-			to->e_cued_b[0][base+j] = from->cu_ed_slopes_b[j-1];
-		}
-		to->e_cued_x[0][base+6] = from->cu_ed_points_x[5];
-
-		for (j = 1; j < 6; j++) {
-			to->e_curad_x[0][base+j] = from->cu_radial_points_x[j-1];
-			to->e_curad_a[0][base+j] = from->cu_radial_slopes_a[j-1];
-			to->e_curad_b[0][base+j] = from->cu_radial_slopes_b[j-1];
-		}
-		to->e_curad_x[0][base+6] = from->cu_radial_points_x[5];
-
-		/* Init asrrnd_lut */
-		to->asrrnd_lut[0][base] = 8192;
-		to->asrrnd_lut[0][base+1] = 4096;
-		to->asrrnd_lut[0][base+2] = 2048;
-		to->asrrnd_lut[0][base+3] = 1024;
-		to->asrrnd_lut[0][base+4] = 512;
-		to->asrrnd_lut[0][base+5] = 256;
-		to->asrrnd_lut[0][base+6] = 128;
-		to->asrrnd_lut[0][base+7] = 64;
-		to->asrrnd_lut[0][base+8] = 32;
-	}
-
-}
-
-void
-ia_css_iefd2_6_encode(
-	struct iefd2_6_dmem_params *to,
-	const struct ia_css_iefd2_6_config *from,
-	size_t size)
-{
-	(void)size;
-
-	/* Copy parameters to dmem, as described in the KFS
-	 */
-	to->horver_diag_coeff		= from->horver_diag_coeff;
-	to->ed_horver_diag_coeff	= from->ed_horver_diag_coeff;
-	to->dir_smooth_enable		= from->dir_smooth_enable;
-	to->dir_metric_update		= from->dir_metric_update;
-	to->unsharp_c00			= from->unsharp_c00;
-	to->unsharp_c01			= from->unsharp_c01;
-	to->unsharp_c02			= from->unsharp_c02;
-	to->unsharp_c11			= from->unsharp_c11;
-	to->unsharp_c12			= from->unsharp_c12;
-	to->unsharp_c22			= from->unsharp_c22;
-	to->unsharp_weight		= from->unsharp_weight;
-	to->unsharp_amount		= from->unsharp_amount;
-	to->cu_dir_sharp_pow		= from->cu_dir_sharp_pow;
-	to->cu_dir_sharp_pow_bright	= from->cu_dir_sharp_pow_bright;
-	to->cu_non_dir_sharp_pow	= from->cu_non_dir_sharp_pow;
-	to->cu_non_dir_sharp_pow_bright	= from->cu_non_dir_sharp_pow_bright;
-	to->dir_far_sharp_weight	= from->dir_far_sharp_weight;
-	to->rad_cu_dir_sharp_x1		= from->rad_cu_dir_sharp_x1;
-	to->rad_cu_non_dir_sharp_x1	= from->rad_cu_non_dir_sharp_x1;
-	to->rad_dir_far_sharp_weight	= from->rad_dir_far_sharp_weight;
-	to->sharp_nega_lmt_txt		= from->sharp_nega_lmt_txt;
-	to->sharp_posi_lmt_txt		= from->sharp_posi_lmt_txt;
-	to->sharp_nega_lmt_dir		= from->sharp_nega_lmt_dir;
-	to->sharp_posi_lmt_dir		= from->sharp_posi_lmt_dir;
-	to->clamp_stitch		= from->clamp_stitch;
-	to->rad_enable			= from->rad_enable;
-	to->rad_x_origin		= from->rad_x_origin;
-	to->rad_y_origin		= from->rad_y_origin;
-	to->rad_nf			= from->rad_nf;
-	to->rad_inv_r2			= from->rad_inv_r2;
-	to->vssnlm_enable		= from->vssnlm_enable;
-	to->vssnlm_x0			= from->vssnlm_x0;
-	to->vssnlm_x1			= from->vssnlm_x1;
-	to->vssnlm_x2			= from->vssnlm_x2;
-	to->vssnlm_y1			= from->vssnlm_y1;
-	to->vssnlm_y2			= from->vssnlm_y2;
-	to->vssnlm_y3			= from->vssnlm_y3;
-
-	/* Setup for configurable units */
-	to->e_cued2_a		= from->cu_ed2_slopes_a;
-	to->e_cu_vssnlm_a	= from->cu_vssnlm_slopes_a;
-	to->e_cued2_x1		= from->cu_ed2_points_x[0];
-	to->e_cued2_x_diff	= from->cu_ed2_points_x[1] - from->cu_ed2_points_x[0];
-	to->e_cu_vssnlm_x1	= from->cu_vssnlm_points_x[0];
-	to->e_cu_vssnlm_x_diff  = from->cu_vssnlm_points_x[1] - from->cu_vssnlm_points_x[0];
-}
-
-/* TODO: AM: This needs a proper implementation. */
-void
-ia_css_init_iefd2_6_state(
-	void *state,
-	size_t size)
-{
-	(void)state;
-	(void)size;
-}
-
-#ifndef IA_CSS_NO_DEBUG
-/* TODO: AM: This needs a proper implementation. */
-void
-ia_css_iefd2_6_debug_dtrace(
-	const struct ia_css_iefd2_6_config *config,
-	unsigned level)
-{
-	(void)config;
-	(void)level;
-}
-#endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.h
deleted file mode 100644
index 580d51fe..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6.host.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef __IA_CSS_IEFD2_6_HOST_H
-#define __IA_CSS_IEFD2_6_HOST_H
-
-#include "ia_css_iefd2_6_types.h"
-#include "ia_css_iefd2_6_param.h"
-#include "ia_css_iefd2_6_default.host.h"
-
-void
-ia_css_iefd2_6_vmem_encode(
-	struct iefd2_6_vmem_params *to,
-	const struct ia_css_iefd2_6_config *from,
-	size_t size);
-
-void
-ia_css_iefd2_6_encode(
-	struct iefd2_6_dmem_params *to,
-	const struct ia_css_iefd2_6_config *from,
-	size_t size);
-
-void
-ia_css_init_iefd2_6_state(
-	void *state,
-	size_t size);
-
-#ifndef IA_CSS_NO_DEBUG
-void
-ia_css_iefd2_6_debug_dtrace(
-	const struct ia_css_iefd2_6_config *config, unsigned level)
-;
-#endif
-
-#endif /* __IA_CSS_IEFD2_6_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.c
deleted file mode 100644
index b43ffd8..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.c
+++ /dev/null
@@ -1,144 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#include "ia_css_iefd2_6_types.h"
-
-const struct ia_css_iefd2_6_config default_iefd2_6_config = {
-	.horver_diag_coeff = 45,
-	.ed_horver_diag_coeff = 64,
-	.dir_smooth_enable = true,
-	.dir_metric_update = 16,
-	.unsharp_c00 = 60,
-	.unsharp_c01 = 30,
-	.unsharp_c02 = 16,
-	.unsharp_c11 = 1,
-	.unsharp_c12 = 2,
-	.unsharp_c22 = 0,
-	.unsharp_weight = 32,
-	.unsharp_amount = 128,
-	.cu_dir_sharp_pow = 20,
-	.cu_dir_sharp_pow_bright = 20,
-	.cu_non_dir_sharp_pow = 24,
-	.cu_non_dir_sharp_pow_bright = 24,
-	.dir_far_sharp_weight = 2,
-	.rad_cu_dir_sharp_x1 = 0,
-	.rad_cu_non_dir_sharp_x1 = 128,
-	.rad_dir_far_sharp_weight = 8,
-	.sharp_nega_lmt_txt = 1024,
-	.sharp_posi_lmt_txt = 1024,
-	.sharp_nega_lmt_dir = 128,
-	.sharp_posi_lmt_dir = 128,
-	.clamp_stitch = 0,
-	.rad_enable = true,
-	.rad_x_origin = 0,
-	.rad_y_origin = 0,
-	.rad_nf = 7,
-	.rad_inv_r2 = 157,
-	.vssnlm_enable = true,
-	.vssnlm_x0 = 24,
-	.vssnlm_x1 = 96,
-	.vssnlm_x2 = 172,
-	.vssnlm_y1 = 1,
-	.vssnlm_y2 = 3,
-	.vssnlm_y3 = 8,
-	.cu_ed_points_x = {
-		0,
-		256,
-		656,
-		2456,
-		3272,
-		4095
-		},
-	.cu_ed_slopes_a = {
-		4,
-		160,
-		0,
-		0,
-		0
-		},
-	.cu_ed_slopes_b = {
-		0,
-		9,
-		510,
-		511,
-		511
-		},
-	.cu_ed2_points_x = {
-		218,
-		308
-		},
-	.cu_ed2_slopes_a = 11,
-	.cu_ed2_slopes_b = 0,
-	.cu_dir_sharp_points_x = {
-		247,
-		298,
-		342,
-		448
-		},
-	.cu_dir_sharp_slopes_a = {
-		14,
-		4,
-		0
-		},
-	.cu_dir_sharp_slopes_b = {
-		1,
-		46,
-		58
-		},
-	.cu_non_dir_sharp_points_x = {
-		26,
-		45,
-		81,
-		500
-		},
-	.cu_non_dir_sharp_slopes_a = {
-		39,
-		7,
-		0
-		},
-	.cu_non_dir_sharp_slopes_b = {
-		1,
-		47,
-		63
-		},
-	.cu_radial_points_x = {
-		50,
-		86,
-		142,
-		189,
-		224,
-		255
-		},
-	.cu_radial_slopes_a = {
-		713,
-		278,
-		295,
-		286,
-		-1
-		},
-	.cu_radial_slopes_b = {
-		1,
-		101,
-		162,
-		216,
-		255
-		},
-	.cu_vssnlm_points_x = {
-		100,
-		141
-		},
-	.cu_vssnlm_slopes_a = 25,
-	.cu_vssnlm_slopes_b = 0
-};
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.h
deleted file mode 100644
index 38f06de..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_default.host.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef __IA_CSS_IEFD2_6_DEFAULT_HOST_H
-#define __IA_CSS_IEFD2_6_DEFAULT_HOST_H
-
-#include "ia_css_iefd2_6_types.h"
-
-extern const struct ia_css_iefd2_6_config default_iefd2_6_config;
-
-#endif /* __IA_CSS_IEFD2_6_DEFAULT_HOST_H */
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_param.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_param.h
deleted file mode 100644
index 3079096..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_param.h
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef __IA_CSS_IEFD2_6_PARAM_H
-#define __IA_CSS_IEFD2_6_PARAM_H
-
-#include "type_support.h"
-#include "vmem.h" /* needed for VMEM_ARRAY */
-
-struct iefd2_6_vmem_params {
-	VMEM_ARRAY(e_cued_x, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cued_a, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cued_b, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cu_dir_x, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cu_dir_a, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cu_dir_b, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cu_non_dir_x, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cu_non_dir_a, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_cu_non_dir_b, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_curad_x, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_curad_a, ISP_VEC_NELEMS);
-	VMEM_ARRAY(e_curad_b, ISP_VEC_NELEMS);
-	VMEM_ARRAY(asrrnd_lut, ISP_VEC_NELEMS);
-};
-
-struct iefd2_6_dmem_params {
-	int32_t horver_diag_coeff;
-	int32_t ed_horver_diag_coeff;
-	bool dir_smooth_enable;
-	int32_t dir_metric_update;
-	int32_t unsharp_c00;
-	int32_t unsharp_c01;
-	int32_t unsharp_c02;
-	int32_t unsharp_c11;
-	int32_t unsharp_c12;
-	int32_t unsharp_c22;
-	int32_t unsharp_weight;
-	int32_t unsharp_amount;
-	int32_t cu_dir_sharp_pow;
-	int32_t cu_dir_sharp_pow_bright;
-	int32_t cu_non_dir_sharp_pow;
-	int32_t cu_non_dir_sharp_pow_bright;
-	int32_t dir_far_sharp_weight;
-	int32_t rad_cu_dir_sharp_x1;
-	int32_t rad_cu_non_dir_sharp_x1;
-	int32_t rad_dir_far_sharp_weight;
-	int32_t sharp_nega_lmt_txt;
-	int32_t sharp_posi_lmt_txt;
-	int32_t sharp_nega_lmt_dir;
-	int32_t sharp_posi_lmt_dir;
-	int32_t clamp_stitch;
-	bool rad_enable;
-	int32_t rad_x_origin;
-	int32_t rad_y_origin;
-	int32_t rad_nf;
-	int32_t rad_inv_r2;
-	bool vssnlm_enable;
-	int32_t vssnlm_x0;
-	int32_t vssnlm_x1;
-	int32_t vssnlm_x2;
-	int32_t vssnlm_y1;
-	int32_t vssnlm_y2;
-	int32_t vssnlm_y3;
-	int32_t e_cued2_a;
-	int32_t e_cued2_x1;
-	int32_t e_cued2_x_diff;
-	int32_t e_cu_vssnlm_a;
-	int32_t e_cu_vssnlm_x1;
-	int32_t e_cu_vssnlm_x_diff;
-};
-
-#endif /* __IA_CSS_IEFD2_6_PARAM_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_state.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_state.h
deleted file mode 100644
index 0915f14..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_state.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef _IA_CSS_IEFD2_6_STATE_H
-#define _IA_CSS_IEFD2_6_STATE_H
-
-#include "type_support.h"
-#include "vmem.h" /* for VMEM_ARRAY*/
-#include "iefd2_6_vssnlm.isp.h"
-#include "iefd2_6.isp.h"
-
-struct iefd2_6_vmem_state {
-	/* State buffers required for main IEFD2_6 */
-	VMEM_ARRAY(iefd2_6_input_lines[IEFD2_6_STATE_INPUT_BUFFER_HEIGHT], IEFD2_6_STATE_INPUT_BUFFER_WIDTH*ISP_NWAY);
-	/* State buffers required for VSSNLM sub-kernel */
-	VMEM_ARRAY(vssnlm_input_y[VSSNLM_STATE_INPUT_BUFFER_HEIGHT], VSSNLM_STATE_INPUT_BUFFER_WIDTH*ISP_NWAY);
-	VMEM_ARRAY(vssnlm_input_diff_grad[1], VSSNLM_STATE_INPUT_BUFFER_WIDTH*ISP_NWAY);
-};
-
-#endif /* _IA_CSS_IEFD2_6_STATE_H */
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_types.h
deleted file mode 100644
index b0eadab..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/iefd2_6/ia_css_iefd2_6_types.h
+++ /dev/null
@@ -1,164 +0,0 @@
-/*
- * Support for Intel Camera Imaging ISP subsystem.
- * Copyright (c) 2015, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- */
-
-#ifndef __IA_CSS_IEFD2_6_TYPES_H
-#define __IA_CSS_IEFD2_6_TYPES_H
-
-/** @file
-* CSS-API header file for Image Enhancement Filter directed algorithm parameters.
-*/
-
-#include "type_support.h"
-
-/** Image Enhancement Filter directed configuration
- *
- * ISP2.6.1: IEFd2_6 is used.
- */
-
-struct ia_css_iefd2_6_config {
-	int32_t horver_diag_coeff;	   /**< Coefficient that compensates for different
-						distance for vertical/horizontal and
-						diagonal gradient calculation (~1/sqrt(2)).
-						u1.6, [0,64], default 45, ineffective 0 */
-	int32_t ed_horver_diag_coeff;	   /**< Radial Coefficient that compensates for
-						different distance for vertical/horizontal
-						and diagonal gradient calculation (~1/sqrt(2)).
-						u1.6, [0,64], default 64, ineffective 0 */
-	bool dir_smooth_enable;		   /**< Enable smooth best direction with second best.
-						bool, [false, true], default true, ineffective false */
-	int32_t dir_metric_update;	   /**< Update coefficient for direction metric.
-						u1.4, [0,31], default 16, ineffective 0 */
-	int32_t unsharp_c00;		   /**< Unsharp Mask filter coefs 0,0 (center).
-						s0.8, [-256,255], default 60, ineffective 255 */
-	int32_t unsharp_c01;		   /**< Unsharp Mask filter coefs 0,1.
-						s0.8, [-256,255], default 30, ineffective 0 */
-	int32_t unsharp_c02;		   /**< Unsharp Mask filter coefs 0,2.
-						s0.8, [-256,255], default 16, ineffective 0 */
-	int32_t unsharp_c11;		   /**< Unsharp Mask filter coefs 1,1.
-						s0.8, [-256,255], default 1, ineffective 0 */
-	int32_t unsharp_c12;		   /**< Unsharp Mask filter coefs 1,2.
-						s1.8, [-512,511], default 2, ineffective 0 */
-	int32_t unsharp_c22;		   /**< Unsharp Mask filter coefs 2,2.
-						s0.8, [-256,255], default 0, ineffective 0 */
-	int32_t unsharp_weight;		   /**< Unsharp Mask blending weight.
-						u1.12, [0,4096], default 32, ineffective 0 */
-	int32_t unsharp_amount;		   /**< Unsharp Mask amount.
-						u3.6, [0,511], default 128, ineffective 0 */
-	int32_t cu_dir_sharp_pow;	   /**< Power of cu_dir_sharp (power of direct sharpening).
-						u2.4, [0,63], default 20, ineffective 0 */
-	int32_t cu_dir_sharp_pow_bright;   /**< Power of cu_dir_sharp (power of direct sharpening) for
-						Bright.
-						u2.4, [0,63], default 20, ineffective 0 */
-	int32_t cu_non_dir_sharp_pow;	   /**< Power of cu_non_dir_sharp (power of unsharp mask).
-						u2.4, [0,63], default 24, ineffective 0 */
-	int32_t cu_non_dir_sharp_pow_bright;	   /**< Power of cu_non_dir_sharp (power of unsharp mask)
-							for Bright.
-							u2.4, [0,63], default 24, ineffective 0 */
-	int32_t dir_far_sharp_weight;	   /**< Weight of wide direct sharpening.
-						u1.12, [0,4096], default 2, ineffective 0 */
-	int32_t rad_cu_dir_sharp_x1;	   /**< X1point of cu_dir_sharp for radial/corner point.
-						u9.0, [0,511], default 0, ineffective 0 */
-	int32_t rad_cu_non_dir_sharp_x1;   /**< X1 point for cu_non_dir_sharp for radial/corner point.
-						u9.0, [0,511], default 128, ineffective 0 */
-	int32_t rad_dir_far_sharp_weight;  /**< Weight of wide direct sharpening.
-						u1.12, [0,4096], default 8, ineffective 0 */
-	int32_t sharp_nega_lmt_txt;	   /**< Sharpening limit for negative overshoots for texture.
-						u13.0, [0,8191], default 1024, ineffective 0 */
-	int32_t sharp_posi_lmt_txt;	   /**< Sharpening limit for positive overshoots for texture.
-						u13.0, [0,8191], default 1024, ineffective 0 */
-	int32_t sharp_nega_lmt_dir;	   /**< Sharpening limit for negative overshoots for direction
-						(edge).
-						u13.0, [0,8191], default 128, ineffective 0 */
-	int32_t sharp_posi_lmt_dir;	   /**< Sharpening limit for positive overshoots for direction
-						(edge).
-						u13.0, [0,8191], default 128, ineffective 0 */
-	int32_t clamp_stitch;		   /**< Slope to stitch between clamped and unclamped edge values.
-						u6.0, [0,63], default 0, ineffective 0 */
-	bool rad_enable;		   /**< Enable bit to update radial dependent parameters.
-						bool, [false,true], default true, ineffective false */
-	int32_t rad_x_origin;		   /**< Initial x coord. for radius computation.
-						s13.0, [-8192,8191], default 0, ineffective 0 */
-	int32_t rad_y_origin;		   /**< Initial y coord. for radius computation.
-						s13.0, [-8192,8191], default 0, ineffective 0 */
-	int32_t rad_nf;			   /**< Radial. R^2 normalization factor is scale down by
-						2^-(15+scale).
-						u4.0, [0,15], default 7, ineffective 0 */
-	int32_t rad_inv_r2;		   /**< Radial R^-2 normelized to (0.5..1).
-						u(8-m_rad_NF).m_rad_NF, [0,255], default 157,
-						ineffective 0 */
-	bool vssnlm_enable;		   /**< Enable bit to use VSSNLM output filter.
-						bool, [false, true], default true, ineffective false */
-	int32_t vssnlm_x0;		   /**< Vssnlm LUT x0.
-						u8.0, [0,255], default 24, ineffective 0 */
-	int32_t vssnlm_x1;		   /**< Vssnlm LUT x1.
-						u8.0, [0,255], default 96, ineffective 0 */
-	int32_t vssnlm_x2;		   /**< Vssnlm LUT x2.
-						u8.0, [0,255], default 172, ineffective 0 */
-	int32_t vssnlm_y1;		   /**< Vssnlm LUT y1.
-						u4.0, [0,8], default 1, ineffective 8 */
-	int32_t vssnlm_y2;		   /**< Vssnlm LUT y2.
-						u4.0, [0,8], default 3, ineffective 8 */
-	int32_t vssnlm_y3;		   /**< Vssnlm LUT y3.
-						u4.0, [0,8], default 8, ineffective 8 */
-	int32_t cu_ed_points_x[6];	   /**< PointsX of config unit ED.
-						u0.12, [0,4095], default 0,256,656,2456,3272,4095,
-						ineffective 0,0,0,0,0,0 */
-	int32_t cu_ed_slopes_a[5];	   /**< SlopesA of config unit ED.
-						s6.7, [-8192, 8191], default 4,160,0,0,0,
-						ineffective 0,0,0,0,0 */
-	int32_t cu_ed_slopes_b[5];	   /**< SlopesB of config unit ED.
-						u0.9, [0,511], default 0,9,510,511,511,
-						ineffective 0,0,0,0,0 */
-	int32_t cu_ed2_points_x[2];	   /**< PointsX of config unit ED2..
-						u0.9, [0,511], default 218,308, ineffective 0,0 */
-	int32_t cu_ed2_slopes_a;	   /**< SlopesA of config unit ED2.
-						s7,4, [-1024, 1024]. default 11, ineffective 0 */
-	int32_t cu_ed2_slopes_b;	   /**< SlopesB of config unit ED2.
-						u1.6, [0,0], default 0, ineffective 0 */
-	int32_t cu_dir_sharp_points_x[4];  /**< PointsX of config unit DirSharp.
-						u0.9, [0,511], default 247,298,342,448,
-						ineffective 0,0,0,0 */
-	int32_t cu_dir_sharp_slopes_a[3];  /**< SlopesA of config unit DirSharp
-						s7,4, [0,511], default 14,4,0, ineffective 0,0,0 */
-	int32_t cu_dir_sharp_slopes_b[3];  /**< SlopesB of config unit DirSharp.
-						u1.6, [0,64], default 1,46,58, ineffective 0,0,0 */
-	int32_t cu_non_dir_sharp_points_x[4];	   /**< PointsX of config unit NonDirSharp.
-							u0.9, [0,511], default 26,45,81,500,
-							ineffective 0,0,0,0 */
-	int32_t cu_non_dir_sharp_slopes_a[3];	   /**< SlopesA of config unit NonDirSharp.
-							s7.4, [-1024, 1024], default 39,7,0,
-							ineffective 0,0,0 */
-	int32_t cu_non_dir_sharp_slopes_b[3];	   /**< SlopesB of config unit NonDirSharp.
-							u1.6, [0,64], default 1,47,63,
-							ineffective 0,0,0 */
-	int32_t cu_radial_points_x[6];	   /**< PointsX of Config Unit Radial.
-						u0.8, [0,255], default 50,86,142,189,224,255,
-						ineffective 0,0,0,0,0,0 */
-	int32_t cu_radial_slopes_a[5];	   /**< SlopesA of Config Unit Radial.
-						s5.8, [-8192, 8191], default 713,278,295,286,-1,
-						ineffective 0,0,0,0,0 */
-	int32_t cu_radial_slopes_b[5];	   /**< SlopesB of Config Unit Radial.
-						u0.8, [0,255], default 1,101,162,216,255,
-						ineffective 0,0,0,0,0 */
-	int32_t cu_vssnlm_points_x[2];	   /**< PointsX of config unit VSSNLM.
-						u0.9, [0,511], default 100,141, ineffective 0,0 */
-	int32_t cu_vssnlm_slopes_a;	   /**< SlopesA of config unit VSSNLM.
-						s7.4, [-1024,1024], default 25, ineffective 0 */
-	int32_t cu_vssnlm_slopes_b;	   /**< SlopesB of config unit VSSNLM.
-						u1.6, [0,0], default 0, ineffective 0 */
-};
-
-
-#endif /* __IA_CSS_IEFD2_6_TYPES_H */
-
