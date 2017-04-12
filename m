Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46505 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755055AbdDLSWk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:22:40 -0400
Subject: [PATCH 13/14] atomisp: remove xnr3_0_5 and xnr3_0_11
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:22:35 +0100
Message-ID: <149202135313.16615.1966979063050475251.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are not used in the driver so can go away.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    4 -
 .../kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.c  |  155 --------------------
 .../kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.h  |   58 -------
 .../kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_param.h |   50 ------
 .../kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_types.h |   33 ----
 .../kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.c    |  154 --------------------
 .../kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.h    |   59 --------
 .../kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_param.h   |   50 ------
 .../kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_types.h   |   33 ----
 9 files changed, 596 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_types.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_types.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 8780914..f6d01c2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -82,9 +82,7 @@ atomisp-objs += \
 	css2400/isp/kernels/cnr/cnr_1.0/ia_css_cnr.host.o \
 	css2400/isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.o \
 	css2400/isp/kernels/xnr/xnr_1.0/ia_css_xnr_table.host.o \
-	css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.o \
 	css2400/isp/kernels/xnr/xnr_3.0/ia_css_xnr3.host.o \
-	css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.o \
 	css2400/isp/kernels/de/de_1.0/ia_css_de.host.o \
 	css2400/isp/kernels/de/de_2/ia_css_de2.host.o \
 	css2400/isp/kernels/gc/gc_2/ia_css_gc2.host.o \
@@ -328,8 +326,6 @@ INCLUDES += \
 	-I$(atomisp)/css2400/isp/kernels/xnr/ \
 	-I$(atomisp)/css2400/isp/kernels/xnr/xnr_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/xnr/xnr_3.0/ \
-	-I$(atomisp)/css2400/isp/kernels/xnr/xnr3_0_11 \
-	-I$(atomisp)/css2400/isp/kernels/xnr/xnr3_0_5/ \
 	-I$(atomisp)/css2400/isp/kernels/ynr/ \
 	-I$(atomisp)/css2400/isp/kernels/ynr/ynr_1.0/ \
 	-I$(atomisp)/css2400/isp/kernels/ynr/ynr_2/ \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.c
deleted file mode 100644
index 7e86bc8..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.c
+++ /dev/null
@@ -1,155 +0,0 @@
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
-#include "type_support.h"
-#include "math_support.h"
-#include "sh_css_defs.h"
-#include "assert_support.h"
-#include "ia_css_xnr3_0_11.host.h"
-
-/*
- * XNR 3.0.11 division look-up table
- */
-#define XNR3_0_11_LOOK_UP_TABLE_POINTS 16
-
-static const int16_t x[XNR3_0_11_LOOK_UP_TABLE_POINTS] = {
-512, 637, 782, 952, 1147, 1372, 1627, 1917, 2242,
-2597, 2992, 3427, 3907, 4432, 5007, 5632};
-
-static const int16_t a[XNR3_0_11_LOOK_UP_TABLE_POINTS] = {
--6587, -4309, -2886, -1970, -1362, -7710, -5508,
--4008, -2931, -2219, -1676, -1280, -999, -769, -616, 0};
-
-static const int16_t b[XNR3_0_11_LOOK_UP_TABLE_POINTS] = {
-4096, 3292, 2682, 2203, 1828, 1529, 1289, 1094,
-935, 808, 701, 612, 537, 473, 419, 372};
-
-static const int16_t c[XNR3_0_11_LOOK_UP_TABLE_POINTS] = {
-1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
-
-
-/*
- * Default kernel parameters (weights). In general, default is bypass mode or as close
- * to the ineffective values as possible. Due to the chroma down+upsampling,
- * perfect bypass mode is not possible for xnr3.
- */
-const struct ia_css_xnr3_0_11_config default_xnr3_0_11_config = {
-	7, 7, 7, 7, 7, 2 };
-
-
-/* (void) = ia_css_xnr3_0_11_vmem_encode(*to, *from)
- * -----------------------------------------------
- * VMEM Encode Function to translate UV parameters from userspace into ISP space
-*/
-void
-ia_css_xnr3_0_11_vmem_encode(
-	struct sh_css_isp_xnr3_0_11_vmem_params *to,
-	const struct ia_css_xnr3_0_11_config *from,
-	unsigned size)
-{
-	unsigned i, j, base;
-	const unsigned total_blocks = 4;
-	const unsigned shuffle_block = 16;
-
-	(void)from;
-	(void)size;
-
-	/* Init */
-	for (i = 0; i < ISP_VEC_NELEMS; i++) {
-		to->x[0][i] = 0;
-		to->a[0][i] = 0;
-		to->b[0][i] = 0;
-		to->c[0][i] = 0;
-	}
-
-
-	/* Constraints on "x":
-	 * - values should be greater or equal to 0.
-	 * - values should be ascending.
-	 */
-	assert(x[0] >= 0);
-
-	for (j = 1; j < XNR3_0_11_LOOK_UP_TABLE_POINTS; j++) {
-		assert(x[j] >= 0);
-		assert(x[j] > x[j-1]);
-
-	}
-
-
-	/* The implementation of the calulating 1/x is based on the availability
-	 * of the OP_vec_shuffle16 operation.
-	 * A 64 element vector is split up in 4 blocks of 16 element. Each array is copied to
-	 * a vector 4 times, (starting at 0, 16, 32 and 48). All array elements are copied or
-	 * initialised as described in the KFS. The remaining elements of a vector are set to 0.
-	 */
-	/* TODO: guard this code with above assumptions */
-	for(i = 0; i < total_blocks; i++) {
-		base = shuffle_block * i;
-
-		for (j = 0; j < XNR3_0_11_LOOK_UP_TABLE_POINTS; j++) {
-			to->x[0][base + j] = x[j];
-			to->a[0][base + j] = a[j];
-			to->b[0][base + j] = b[j];
-			to->c[0][base + j] = c[j];
-		}
-	}
-
-}
-
-
-
-/* (void) = ia_css_xnr3_0_11_encode(*to, *from)
- * -----------------------------------------------
- * DMEM Encode Function to translate UV parameters from userspace into ISP space
- */
-void
-ia_css_xnr3_0_11_encode(
-	struct sh_css_isp_xnr3_0_11_params *to,
-	const struct ia_css_xnr3_0_11_config *from,
-	unsigned size)
-{
-	int kernel_size = XNR_FILTER_SIZE;
-	/* The adjust factor is the next power of 2
-	   w.r.t. the kernel size*/
-	int adjust_factor = ceil_pow2(kernel_size);
-
-	int32_t weight_y0 = from->weight_y0;
-	int32_t weight_y1 = from->weight_y1;
-	int32_t weight_u0 = from->weight_u0;
-	int32_t weight_u1 = from->weight_u1;
-	int32_t weight_v0 = from->weight_v0;
-	int32_t weight_v1 = from->weight_v1;
-
-	(void)size;
-
-	to->weight_y0 = weight_y0;
-	to->weight_u0 = weight_u0;
-	to->weight_v0 = weight_v0;
-	to->weight_ydiff = (weight_y1 - weight_y0) * adjust_factor / kernel_size;
-	to->weight_udiff = (weight_u1 - weight_u0) * adjust_factor / kernel_size;
-	to->weight_vdiff = (weight_v1 - weight_v0) * adjust_factor / kernel_size;
-}
-
-/* (void) = ia_css_xnr3_0_11_debug_dtrace(*config, level)
- * -----------------------------------------------
- * Dummy Function added as the tool expects it
- */
-void
-ia_css_xnr3_0_11_debug_dtrace(
-	const struct ia_css_xnr3_0_11_config *config,
-	unsigned level)
-{
-	(void)config;
-	(void)level;
-}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.h
deleted file mode 100644
index 8e8b85f..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11.host.h
+++ /dev/null
@@ -1,58 +0,0 @@
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
-#ifndef __IA_CSS_XNR3_0_11_HOST_H
-#define __IA_CSS_XNR3_0_11_HOST_H
-
-#include "ia_css_xnr3_0_11_param.h"
-#include "ia_css_xnr3_0_11_types.h"
-
-/*
- * Default kernel parameters (weights). In general, default is bypass mode or as close
- * to the ineffective values as possible. Due to the chroma down+upsampling,
- * perfect bypass mode is not possible for xnr3.
- */
-extern const struct ia_css_xnr3_0_11_config default_xnr3_0_11_config;
-
-
-/* (void) = ia_css_xnr3_0_11_vmem_encode(*to, *from)
- * -----------------------------------------------
- * VMEM Encode Function to translate UV parameters from userspace into ISP space
-*/
-void
-ia_css_xnr3_0_11_vmem_encode(
-	struct sh_css_isp_xnr3_0_11_vmem_params *to,
-	const struct ia_css_xnr3_0_11_config *from,
-	unsigned size);
-
-/* (void) = ia_css_xnr3_0_11_encode(*to, *from)
- * -----------------------------------------------
- * DMEM Encode Function to translate UV parameters from userspace into ISP space
- */
-void
-ia_css_xnr3_0_11_encode(
-	struct sh_css_isp_xnr3_0_11_params *to,
-	const struct ia_css_xnr3_0_11_config *from,
-	unsigned size);
-
-/* (void) = ia_css_xnr3_0_11_debug_dtrace(*config, level)
- * -----------------------------------------------
- * Dummy Function added as the tool expects it
- */
-void
-ia_css_xnr3_0_11_debug_dtrace(
-	const struct ia_css_xnr3_0_11_config *config,
-	unsigned level);
-
-#endif /* __IA_CSS_XNR3_0_11_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_param.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_param.h
deleted file mode 100644
index a28cfd4..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_param.h
+++ /dev/null
@@ -1,50 +0,0 @@
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
-#ifndef __IA_CSS_XNR3_0_11_PARAM_H
-#define __IA_CSS_XNR3_0_11_PARAM_H
-
-#include "type_support.h"
-#include "vmem.h" /* needed for VMEM_ARRAY */
-
-/* XNR3.0.11 filter size */
-#define XNR_FILTER_SIZE             11
-
-/*
- * STRUCT sh_css_isp_xnr3_0_11_vmem_params
- * -----------------------------------------------
- * XNR3.0.11 ISP VMEM parameters
- */
-struct sh_css_isp_xnr3_0_11_vmem_params {
-	VMEM_ARRAY(x, ISP_VEC_NELEMS);
-	VMEM_ARRAY(a, ISP_VEC_NELEMS);
-	VMEM_ARRAY(b, ISP_VEC_NELEMS);
-	VMEM_ARRAY(c, ISP_VEC_NELEMS);
-};
-
- /*
- * STRUCT sh_css_isp_xnr3_0_11_params
- * -----------------------------------------------
- * XNR3.0.11 ISP parameters
- */
-struct sh_css_isp_xnr3_0_11_params {
-	int32_t weight_y0;
-	int32_t weight_u0;
-	int32_t weight_v0;
-	int32_t weight_ydiff;
-	int32_t weight_udiff;
-	int32_t weight_vdiff;
-};
-
-#endif  /*__IA_CSS_XNR3_0_11_PARAM_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_types.h
deleted file mode 100644
index b6bf449..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_11/ia_css_xnr3_0_11_types.h
+++ /dev/null
@@ -1,33 +0,0 @@
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
-#ifndef __IA_CSS_XNR3_0_11_TYPES_H
-#define __IA_CSS_XNR3_0_11_TYPES_H
-
- /*
- * STRUCT ia_css_xnr3_0_11_config
- * -----------------------------------------------
- * Struct with all parameters for the XNR3.0.11 kernel that can be set
- * from the CSS API
- */
-struct ia_css_xnr3_0_11_config {
-	int32_t weight_y0;     /**< Weight for Y range similarity in dark area */
-	int32_t weight_y1;     /**< Weight for Y range similarity in bright area */
-	int32_t weight_u0;     /**< Weight for U range similarity in dark area */
-	int32_t weight_u1;     /**< Weight for U range similarity in bright area */
-	int32_t weight_v0;     /**< Weight for V range similarity in dark area */
-	int32_t weight_v1;     /**< Weight for V range similarity in bright area */
-};
-
-#endif /* __IA_CSS_XNR3_0_11_TYPES_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.c
deleted file mode 100644
index d29b314..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.c
+++ /dev/null
@@ -1,154 +0,0 @@
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
-#include "type_support.h"
-#include "math_support.h"
-#include "sh_css_defs.h"
-#include "assert_support.h"
-#include "ia_css_xnr3_0_5.host.h"
-
-/*
- * XNR 3.0.5 division look-up table
- */
-#define XNR3_0_5_LOOK_UP_TABLE_POINTS 16
-
-static const int16_t x[XNR3_0_5_LOOK_UP_TABLE_POINTS] = {
-1024, 1164, 1320, 1492, 1680, 1884, 2108, 2352,
-2616, 2900, 3208, 3540, 3896, 4276, 4684, 5120};
-
-static const int16_t a[XNR3_0_5_LOOK_UP_TABLE_POINTS] = {
--7213, -5580, -4371, -3421, -2722, -2159, -6950, -5585,
--4529, -3697, -3010, -2485, -2070, -1727, -1428, 0};
-
-static const int16_t b[XNR3_0_5_LOOK_UP_TABLE_POINTS] = {
-4096, 3603, 3178, 2811, 2497, 2226, 1990, 1783,
-1603, 1446, 1307, 1185, 1077, 981, 895, 819};
-
-static const int16_t c[XNR3_0_5_LOOK_UP_TABLE_POINTS] = {
-1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
-
-/*
- * Default kernel parameters(weights). In general, default is bypass mode or as close
- * to the ineffective values as possible. Due to the chroma down+upsampling,
- * perfect bypass mode is not possible for xnr3.
- */
-const struct ia_css_xnr3_0_5_config default_xnr3_0_5_config = {
-	8191, 8191, 8191, 8191, 8191, 8191 };
-
-
-/* (void) = ia_css_xnr3_0_5_vmem_encode(*to, *from)
- * -----------------------------------------------
- * VMEM Encode Function to translate UV parameters from userspace into ISP space
-*/
-void
-ia_css_xnr3_0_5_vmem_encode(
-	struct sh_css_isp_xnr3_0_5_vmem_params *to,
-	const struct ia_css_xnr3_0_5_config *from,
-	unsigned size)
-{
-	unsigned i, j, base;
-	const unsigned total_blocks = 4;
-	const unsigned shuffle_block = 16;
-
-	(void)from;
-	(void)size;
-
-	/* Init */
-	for (i = 0; i < ISP_VEC_NELEMS; i++) {
-		to->x[0][i] = 0;
-		to->a[0][i] = 0;
-		to->b[0][i] = 0;
-		to->c[0][i] = 0;
-	}
-
-
-	/* Constraints on "x":
-	 * - values should be greater or equal to 0.
-	 * - values should be ascending.
-	 */
-	assert(x[0] >= 0);
-
-	for (j = 1; j < XNR3_0_5_LOOK_UP_TABLE_POINTS; j++) {
-		assert(x[j] >= 0);
-		assert(x[j] > x[j-1]);
-
-	}
-
-
-	/* The implementation of the calulating 1/x is based on the availability
-	 * of the OP_vec_shuffle16 operation.
-	 * A 64 element vector is split up in 4 blocks of 16 element. Each array is copied to
-	 * a vector 4 times, (starting at 0, 16, 32 and 48). All array elements are copied or
-	 * initialised as described in the KFS. The remaining elements of a vector are set to 0.
-	 */
-	/* TODO: guard this code with above assumptions */
-	for(i = 0; i < total_blocks; i++) {
-		base = shuffle_block * i;
-
-		for (j = 0; j < XNR3_0_5_LOOK_UP_TABLE_POINTS; j++) {
-			to->x[0][base + j] = x[j];
-			to->a[0][base + j] = a[j];
-			to->b[0][base + j] = b[j];
-			to->c[0][base + j] = c[j];
-		}
-	}
-
-}
-
-
-
-/* (void) = ia_css_xnr3_0_5_encode(*to, *from)
- * -----------------------------------------------
- * DMEM Encode Function to translate UV parameters from userspace into ISP space
- */
-void
-ia_css_xnr3_0_5_encode(
-	struct sh_css_isp_xnr3_0_5_params *to,
-	const struct ia_css_xnr3_0_5_config *from,
-	unsigned size)
-{
-	int kernel_size = XNR_FILTER_SIZE;
-	/* The adjust factor is the next power of 2
-	   w.r.t. the kernel size*/
-	int adjust_factor = ceil_pow2(kernel_size);
-
-	int32_t weight_y0 = from->weight_y0;
-	int32_t weight_y1 = from->weight_y1;
-	int32_t weight_u0 = from->weight_u0;
-	int32_t weight_u1 = from->weight_u1;
-	int32_t weight_v0 = from->weight_v0;
-	int32_t weight_v1 = from->weight_v1;
-
-	(void)size;
-
-	to->weight_y0 = weight_y0;
-	to->weight_u0 = weight_u0;
-	to->weight_v0 = weight_v0;
-	to->weight_ydiff = (weight_y1 - weight_y0) * adjust_factor / kernel_size;
-	to->weight_udiff = (weight_u1 - weight_u0) * adjust_factor / kernel_size;
-	to->weight_vdiff = (weight_v1 - weight_v0) * adjust_factor / kernel_size;
-}
-
-/* (void) = ia_css_xnr3_0_5_debug_dtrace(*config, level)
- * -----------------------------------------------
- * Dummy Function added as the tool expects it
- */
-void
-ia_css_xnr3_0_5_debug_dtrace(
-	const struct ia_css_xnr3_0_5_config *config,
-	unsigned level)
-{
-	(void)config;
-	(void)level;
-}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.h
deleted file mode 100644
index 69817a6..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.h
+++ /dev/null
@@ -1,59 +0,0 @@
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
-#ifndef __IA_CSS_XNR3_0_5_HOST_H
-#define __IA_CSS_XNR3_0_5_HOST_H
-
-#include "ia_css_xnr3_0_5_param.h"
-#include "ia_css_xnr3_0_5_types.h"
-
-/*
- * Default kernel parameters (weights). In general, default is bypass mode or as close
- * to the ineffective values as possible. Due to the chroma down+upsampling,
- * perfect bypass mode is not possible for xnr3.
-*/
-extern const struct ia_css_xnr3_0_5_config default_xnr3_0_5_config;
-
-
-
-/* (void) = ia_css_xnr3_0_5_vmem_encode(*to, *from)
- * -----------------------------------------------
- * VMEM Encode Function to translate UV parameters from userspace into ISP space
-*/
-void
-ia_css_xnr3_0_5_vmem_encode(
-	struct sh_css_isp_xnr3_0_5_vmem_params *to,
-	const struct ia_css_xnr3_0_5_config *from,
-	unsigned size);
-
-/* (void) = ia_css_xnr3_0_5_encode(*to, *from)
- * -----------------------------------------------
- * DMEM Encode Function to translate UV parameters from userspace into ISP space
-*/
-void
-ia_css_xnr3_0_5_encode(
-	struct sh_css_isp_xnr3_0_5_params *to,
-	const struct ia_css_xnr3_0_5_config *from,
-	unsigned size);
-
-/* (void) = ia_css_xnr3_0_5_debug_dtrace(*config, level)
- * -----------------------------------------------
- * Dummy Function added as the tool expects it
- */
-void
-ia_css_xnr3_0_5_debug_dtrace(
-	const struct ia_css_xnr3_0_5_config *config,
-	unsigned level);
-
-#endif /* __IA_CSS_XNR3_0_5_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_param.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_param.h
deleted file mode 100644
index fc1d9cc..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_param.h
+++ /dev/null
@@ -1,50 +0,0 @@
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
-#ifndef __IA_CSS_XNR3_0_5_PARAM_H
-#define __IA_CSS_XNR3_0_5_PARAM_H
-
-#include "type_support.h"
-#include "vmem.h" /* needed for VMEM_ARRAY */
-
-/* XNR3.0.5 filter size */
-#define XNR_FILTER_SIZE             5
-
-/*
- * STRUCT sh_css_isp_xnr3_0_5_vmem_params
- * -----------------------------------------------
- * XNR3.0.5 ISP VMEM parameters
- */
-struct sh_css_isp_xnr3_0_5_vmem_params {
-	VMEM_ARRAY(x, ISP_VEC_NELEMS);
-	VMEM_ARRAY(a, ISP_VEC_NELEMS);
-	VMEM_ARRAY(b, ISP_VEC_NELEMS);
-	VMEM_ARRAY(c, ISP_VEC_NELEMS);
-};
-
-/*
- * STRUCT sh_css_isp_xnr3_0_5_params
- * -----------------------------------------------
- * XNR3.0.5 ISP parameters
- */
-struct sh_css_isp_xnr3_0_5_params {
-	int32_t weight_y0;
-	int32_t weight_u0;
-	int32_t weight_v0;
-	int32_t weight_ydiff;
-	int32_t weight_udiff;
-	int32_t weight_vdiff;
-};
-
-#endif  /*__IA_CSS_XNR3_0_5_PARAM_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_types.h
deleted file mode 100644
index ba7c81e..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5_types.h
+++ /dev/null
@@ -1,33 +0,0 @@
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
-#ifndef __IA_CSS_XNR3_0_5_TYPES_H
-#define __IA_CSS_XNR3_0_5_TYPES_H
-
-/*
- * STRUCT ia_css_xnr3_0_5_config
- * -----------------------------------------------
- * Struct with all parameters for the XNR3.0.5 kernel that can be set
- * from the CSS API
-*/
-struct ia_css_xnr3_0_5_config {
-	int32_t weight_y0;     /**< Weight for Y range similarity in dark area */
-	int32_t weight_y1;     /**< Weight for Y range similarity in bright area */
-	int32_t weight_u0;     /**< Weight for U range similarity in dark area */
-	int32_t weight_u1;     /**< Weight for U range similarity in bright area */
-	int32_t weight_v0;     /**< Weight for V range similarity in dark area */
-	int32_t weight_v1;     /**< Weight for V range similarity in bright area */
-};
-
-#endif /* __IA_CSS_XNR3_0_5_TYPES_H */
