Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11438 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933408AbdCJLfO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 06:35:14 -0500
Subject: [PATCH 7/8] atomisp: remove pdaf kernel
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Fri, 10 Mar 2017 11:35:06 +0000
Message-ID: <148914568828.25309.6149435888083916119.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
References: <148914560647.25309.2276061224604665212.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is not used on either Baytrail or Cherrytrail so can simply be deleted


Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    2 
 .../css2400/isp/kernels/pdaf/ia_css_pdaf.host.c    |   84 --------------------
 .../css2400/isp/kernels/pdaf/ia_css_pdaf.host.h    |   37 ---------
 .../css2400/isp/kernels/pdaf/ia_css_pdaf_param.h   |   62 ---------------
 .../css2400/isp/kernels/pdaf/ia_css_pdaf_types.h   |   54 -------------
 5 files changed, 239 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_types.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index ccde4f3..b8a841e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -97,7 +97,6 @@ atomisp-objs += \
 	./css2400/isp/kernels/crop/crop_1.0/ia_css_crop.host.o \
 	./css2400/isp/kernels/io_ls/bayer_io_ls/ia_css_bayer_io.host.o \
 	./css2400/isp/kernels/aa/aa_2/ia_css_aa2.host.o \
-	./css2400/isp/kernels/pdaf/ia_css_pdaf.host.o \
 	./css2400/isp/kernels/copy_output/copy_output_1.0/ia_css_copy_output.host.o \
 	./css2400/isp/kernels/ob/ob_1.0/ia_css_ob.host.o \
 	./css2400/isp/kernels/ob/ob2/ia_css_ob2.host.o \
@@ -300,7 +299,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/ob/ob2/ \
 	-I$(atomisp)/css2400/isp/kernels/output/ \
 	-I$(atomisp)/css2400/isp/kernels/output/output_1.0/ \
-	-I$(atomisp)/css2400/isp/kernels/pdaf/ \
 	-I$(atomisp)/css2400/isp/kernels/qplane/ \
 	-I$(atomisp)/css2400/isp/kernels/qplane/qplane_2/ \
 	-I$(atomisp)/css2400/isp/kernels/raw_aa_binning/ \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.c
deleted file mode 100644
index 79ddef6..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.c
+++ /dev/null
@@ -1,84 +0,0 @@
-#ifdef ISP2600
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
-#include "ia_css_types.h"
-#include "sh_css_defs.h"
-#include "sh_css_frac.h"
-#include "ia_css_pdaf.host.h"
-
-const struct ia_css_pdaf_config default_pdaf_config;
-
-void
-ia_css_pdaf_dmem_encode(
-		struct isp_pdaf_dmem_params *to,
-		const struct ia_css_pdaf_config *from,
-		unsigned size)
-{
-	(void)size;
-	to->frm_length = from->frm_length;
-	to->frm_width  = from->frm_width;
-
-	to->ext_cfg_l_data.num_valid_patterns = from->ext_cfg_data.l_pixel_grid.num_valid_patterns;
-
-	to->ext_cfg_r_data.num_valid_patterns = from->ext_cfg_data.r_pixel_grid.num_valid_patterns;
-
-	to->stats_calc_data.num_valid_elm = from->stats_calc_cfg_data.num_valid_elm;
-}
-
-void
-ia_css_pdaf_vmem_encode(
-		struct isp_pdaf_vmem_params *to,
-		const struct ia_css_pdaf_config *from,
-		unsigned size)
-{
-
-	unsigned int i;
-	(void)size;
-	/* Initialize left pixel grid */
-	for ( i=0 ; i < from->ext_cfg_data.l_pixel_grid.num_valid_patterns ; i++) {
-
-		to->ext_cfg_l_data.y_offset[0][i] = from->ext_cfg_data.l_pixel_grid.y_offset[i];
-		to->ext_cfg_l_data.x_offset[0][i] = from->ext_cfg_data.l_pixel_grid.x_offset[i];
-		to->ext_cfg_l_data.y_step_size[0][i] = from->ext_cfg_data.l_pixel_grid.y_step_size[i];
-		to->ext_cfg_l_data.x_step_size[0][i] = from->ext_cfg_data.l_pixel_grid.x_step_size[i];
-	}
-
-	for ( ; i < ISP_NWAY ; i++) {
-
-		to->ext_cfg_l_data.y_offset[0][i] = PDAF_INVALID_VAL;
-		to->ext_cfg_l_data.x_offset[0][i] = PDAF_INVALID_VAL;
-		to->ext_cfg_l_data.y_step_size[0][i] = PDAF_INVALID_VAL;
-		to->ext_cfg_l_data.x_step_size[0][i] = PDAF_INVALID_VAL;
-	}
-
-	/* Initialize left pixel grid */
-
-	for ( i=0 ; i < from->ext_cfg_data.r_pixel_grid.num_valid_patterns ; i++) {
-
-		to->ext_cfg_r_data.y_offset[0][i] = from->ext_cfg_data.r_pixel_grid.y_offset[i];
-		to->ext_cfg_r_data.x_offset[0][i] = from->ext_cfg_data.r_pixel_grid.x_offset[i];
-		to->ext_cfg_r_data.y_step_size[0][i] = from->ext_cfg_data.r_pixel_grid.y_step_size[i];
-		to->ext_cfg_r_data.x_step_size[0][i] = from->ext_cfg_data.r_pixel_grid.x_step_size[i];
-	}
-
-	for ( ; i < ISP_NWAY ; i++) {
-
-		to->ext_cfg_r_data.y_offset[0][i] = PDAF_INVALID_VAL;
-		to->ext_cfg_r_data.x_offset[0][i] = PDAF_INVALID_VAL;
-		to->ext_cfg_r_data.y_step_size[0][i] = PDAF_INVALID_VAL;
-		to->ext_cfg_r_data.x_step_size[0][i] = PDAF_INVALID_VAL;
-	}
-}
-#endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.h
deleted file mode 100644
index e0e9155..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf.host.h
+++ /dev/null
@@ -1,37 +0,0 @@
-#ifndef ISP2401
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
-#ifndef __IA_CSS_PDAF_HOST_H
-#define __IA_CSS_PDAF_HOST_H
-
-#include "ia_css_pdaf_types.h"
-#include "ia_css_pdaf_param.h"
-
-extern const struct ia_css_pdaf_config default_pdaf_config;
-
-void
-ia_css_pdaf_dmem_encode(
-		struct isp_pdaf_dmem_params *to,
-		const struct ia_css_pdaf_config *from,
-		unsigned size);
-
-void
-ia_css_pdaf_vmem_encode(
-		struct isp_pdaf_vmem_params *to,
-		const struct ia_css_pdaf_config *from,
-		unsigned size);
-
-#endif /* __IA_CSS_PDAF_HOST_H */
-#endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_param.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_param.h
deleted file mode 100644
index 8535c9f..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_param.h
+++ /dev/null
@@ -1,62 +0,0 @@
-#ifndef ISP2401
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
-#ifndef __IA_CSS_PDAF_PARAM_H
-#define __IA_CSS_PDAF_PARAM_H
-
-#define PDAF_INVALID_VAL 0x7FFF
-#include "vmem.h"
-
-struct isp_stats_calc_dmem_params {
-
-	uint16_t num_valid_elm;
-};
-/*
- * Extraction configuration parameters
- */
-
-struct isp_extraction_dmem_params {
-
-	uint8_t num_valid_patterns;
-};
-
-struct isp_extraction_vmem_params {
-
-	VMEM_ARRAY(y_step_size, ISP_VEC_NELEMS);
-	VMEM_ARRAY(y_offset, ISP_VEC_NELEMS);
-	VMEM_ARRAY(x_step_size, ISP_VEC_NELEMS);
-	VMEM_ARRAY(x_offset, ISP_VEC_NELEMS);
-};
-
-/*
- * PDAF configuration parameters
- */
-struct isp_pdaf_vmem_params {
-
-	struct isp_extraction_vmem_params ext_cfg_l_data;
-	struct isp_extraction_vmem_params ext_cfg_r_data;
-};
-
-struct isp_pdaf_dmem_params {
-
-	uint16_t frm_length;
-	uint16_t frm_width;
-	struct isp_stats_calc_dmem_params stats_calc_data;
-	struct isp_extraction_dmem_params ext_cfg_l_data;
-	struct isp_extraction_dmem_params ext_cfg_r_data;
-};
-
-#endif /* __IA_CSS_PDAF_PARAM_H */
-#endif
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_types.h
deleted file mode 100644
index 3e42877..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/pdaf/ia_css_pdaf_types.h
+++ /dev/null
@@ -1,54 +0,0 @@
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
-#ifndef __IA_CSS_PDAF_TYPES_H
-#define __IA_CSS_PDAF_TYPES_H
-
-#include "type_support.h"
-#include "isp2600_config.h"
-/*
- * Header file for PDAF parameters
- * These parameters shall be filled by host/driver
- * and will be converted to ISP parameters in encode
- * function.
- */
-
-struct ia_css_statistics_calc_config {
-
-	uint16_t num_valid_elm;
-};
-struct ia_css_pixel_grid_config {
-
-	uint8_t num_valid_patterns;
-	int16_t y_step_size[ISP_NWAY];
-	int16_t y_offset[ISP_NWAY];
-	int16_t x_step_size[ISP_NWAY];
-	int16_t x_offset[ISP_NWAY];
-};
-
-struct ia_css_extraction_config {
-
-	struct ia_css_pixel_grid_config l_pixel_grid;	/* Left PDAF pixel grid */
-	struct ia_css_pixel_grid_config r_pixel_grid;	/* Right PDAF pixel grid */
-};
-
-struct ia_css_pdaf_config {
-
-	uint16_t frm_length;
-	uint16_t frm_width;
-	struct ia_css_extraction_config ext_cfg_data;
-	struct ia_css_statistics_calc_config stats_calc_cfg_data;
-};
-
-#endif /* __IA_CSS_PDAF_TYPES_H */
