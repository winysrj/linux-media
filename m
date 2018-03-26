Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49034 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752048AbeCZVLO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:11:14 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Arnd Bergmann <arnd@arndb.de>, devel@driverdev.osuosl.org
Subject: [PATCH 10/18] media: staging: atomisp: Get rid of *default.host.[ch]
Date: Mon, 26 Mar 2018 17:10:43 -0400
Message-Id: <fe20b562d983a5fd6fafb6fc3557b6410e935ad7.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
In-Reply-To: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
References: <8548f74ae86b66d041e7505549453fba9fb9e63d.1522098456.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are a number of files at atomisp that aren't used anywhere,
called as "*default.host.[ch]":

	css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.[ch]
	css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.[ch]
	css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.[ch]
	css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.[ch]

Remove them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |  4 -
 .../css2400/isp/kernels/bnlm/ia_css_bnlm.host.h    |  1 -
 .../isp/kernels/bnlm/ia_css_bnlm_default.host.c    | 71 ----------------
 .../isp/kernels/bnlm/ia_css_bnlm_default.host.h    | 22 -----
 .../css2400/isp/kernels/dpc2/ia_css_dpc2.host.h    |  1 -
 .../isp/kernels/dpc2/ia_css_dpc2_default.host.c    | 26 ------
 .../isp/kernels/dpc2/ia_css_dpc2_default.host.h    | 23 ------
 .../isp/kernels/eed1_8/ia_css_eed1_8.host.h        |  1 -
 .../kernels/eed1_8/ia_css_eed1_8_default.host.c    | 94 ----------------------
 .../kernels/eed1_8/ia_css_eed1_8_default.host.h    | 22 -----
 .../isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h      |  1 -
 .../kernels/tdf/tdf_1.0/ia_css_tdf_default.host.c  | 36 ---------
 .../kernels/tdf/tdf_1.0/ia_css_tdf_default.host.h  | 23 ------
 13 files changed, 325 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index 83f816faba1b..7fead5fc9a7d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -59,17 +59,14 @@ atomisp-objs += \
 	css2400/isp/kernels/bnr/bnr_1.0/ia_css_bnr.host.o \
 	css2400/isp/kernels/bnr/bnr2_2/ia_css_bnr2_2.host.o \
 	css2400/isp/kernels/dpc2/ia_css_dpc2.host.o \
-	css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.o \
 	css2400/isp/kernels/fc/fc_1.0/ia_css_formats.host.o \
 	css2400/isp/kernels/ctc/ctc_1.0/ia_css_ctc.host.o \
 	css2400/isp/kernels/ctc/ctc_1.0/ia_css_ctc_table.host.o \
 	css2400/isp/kernels/ctc/ctc2/ia_css_ctc2.host.o \
 	css2400/isp/kernels/ctc/ctc1_5/ia_css_ctc1_5.host.o \
 	css2400/isp/kernels/bh/bh_2/ia_css_bh.host.o \
-	css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.o \
 	css2400/isp/kernels/bnlm/ia_css_bnlm.host.o \
 	css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.o \
-	css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.o \
 	css2400/isp/kernels/dvs/dvs_1.0/ia_css_dvs.host.o \
 	css2400/isp/kernels/anr/anr_1.0/ia_css_anr.host.o \
 	css2400/isp/kernels/anr/anr_2/ia_css_anr2_table.host.o \
@@ -96,7 +93,6 @@ atomisp-objs += \
 	css2400/isp/kernels/ob/ob2/ia_css_ob2.host.o \
 	css2400/isp/kernels/iterator/iterator_1.0/ia_css_iterator.host.o \
 	css2400/isp/kernels/wb/wb_1.0/ia_css_wb.host.o \
-	css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.o \
 	css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.o \
 	css2400/isp/kernels/sc/sc_1.0/ia_css_sc.host.o \
 	css2400/isp/kernels/ipu2_io_ls/bayer_io_ls/ia_css_bayer_io.host.o \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm.host.h
index b99c0644ab38..675f6e539b3f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm.host.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm.host.h
@@ -17,7 +17,6 @@
 
 #include "ia_css_bnlm_types.h"
 #include "ia_css_bnlm_param.h"
-#include "ia_css_bnlm_default.host.h"
 
 void
 ia_css_bnlm_vmem_encode(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.c
deleted file mode 100644
index e2eb88c0f123..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.c
+++ /dev/null
@@ -1,71 +0,0 @@
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
-#include "ia_css_bnlm_types.h"
-
-const struct ia_css_bnlm_config default_bnlm_config = {
-
-	.rad_enable = true,
-	.rad_x_origin = 0,
-	.rad_y_origin = 0,
-	.avg_min_th = 127,
-	.max_min_th = 2047,
-
-	.exp_coeff_a = 6048,
-	.exp_coeff_b = 7828,
-	.exp_coeff_c = 0,
-	.exp_exponent = 3,
-
-	.nl_th = {2252, 2251, 2250},
-	.match_quality_max_idx = {2, 3, 3, 1},
-
-	.mu_root_lut_thr = {
-		26, 56, 128, 216, 462, 626, 932, 1108, 1480, 1564, 1824, 1896, 2368, 3428, 4560},
-	.mu_root_lut_val = {
-		384, 320, 320, 264, 248, 240, 224, 192, 192, 160, 160, 160, 136, 130, 96, 80},
-	.sad_norm_lut_thr = {
-		236, 328, 470, 774, 964, 1486, 2294, 3244, 4844, 6524, 6524, 6524, 6524, 6524, 6524},
-	.sad_norm_lut_val = {
-		8064, 7680, 7168, 6144, 5120, 3840, 2560, 2304, 1984, 1792, 1792, 1792, 1792, 1792, 1792, 1792},
-	.sig_detail_lut_thr = {
-		2936, 3354, 3943, 4896, 5230, 5682, 5996, 7299, 7299, 7299, 7299, 7299, 7299, 7299, 7299},
-	.sig_detail_lut_val = {
-		8191, 7680, 7168, 6144, 5120, 4608, 4224, 4032, 4032, 4032, 4032, 4032, 4032, 4032, 4032, 4032},
-	.sig_rad_lut_thr = {
-		18, 19, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20},
-	.sig_rad_lut_val = {
-		2560, 7168, 8188, 8188, 8188, 8188, 8188, 8188, 8188, 8188, 8188, 8188, 8188, 8188, 8188, 8188},
-	.rad_pow_lut_thr = {
-		0, 7013, 7013, 7013, 7013, 7013, 7013, 7013, 7013, 7013, 7013, 7013, 7013, 7013, 7013},
-	.rad_pow_lut_val = {
-		8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191},
-	.nl_0_lut_thr = {
-		1072, 7000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000, 8000},
-	.nl_0_lut_val = {
-		2560, 3072, 5120, 5120, 5120, 5120, 5120, 5120, 5120, 5120, 5120, 5120, 5120, 5120, 5120, 5120},
-	.nl_1_lut_thr = {
-		624, 3224, 3392, 7424, 7424, 7424, 7424, 7424, 7424, 7424, 7424, 7424, 7424, 7424, 7424},
-	.nl_1_lut_val = {
-		3584, 4608, 5120, 6144, 6144, 6144, 6144, 6144, 6144, 6144, 6144, 6144, 6144, 6144, 6144, 6144},
-	.nl_2_lut_thr = {
-		745, 2896, 3720, 6535, 7696, 8040, 8040, 8040, 8040, 8040, 8040, 8040, 8040, 8040, 8040},
-	.nl_2_lut_val = {
-		3584, 4608, 6144, 7168, 7936, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191},
-	.nl_3_lut_thr = {
-		4848, 4984, 5872, 6000, 6517, 6960, 7944, 8088, 8161, 8161, 8161, 8161, 8161, 8161, 8161},
-	.nl_3_lut_val = {
-		3072, 4104, 4608, 5120, 6144, 7168, 7680, 8128, 8191, 8191, 8191, 8191, 8191, 8191, 8191, 8191},
-
-};
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.h
deleted file mode 100644
index f18c8070abba..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/bnlm/ia_css_bnlm_default.host.h
+++ /dev/null
@@ -1,22 +0,0 @@
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
-#ifndef __IA_CSS_BNLM_DEFAULT_HOST_H
-#define __IA_CSS_BNLM_DEFAULT_HOST_H
-
-#include "ia_css_bnlm_types.h"
-extern const struct ia_css_bnlm_config default_bnlm_config;
-
-#endif /* __IA_CSS_BNLM_DEFAULT_HOST_H */
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2.host.h
index 641564b4af8e..38d10a5237c6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2.host.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2.host.h
@@ -17,7 +17,6 @@
 
 #include "ia_css_dpc2_types.h"
 #include "ia_css_dpc2_param.h"
-#include "ia_css_dpc2_default.host.h"
 
 void
 ia_css_dpc2_encode(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.c
deleted file mode 100644
index c102601cc635..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.c
+++ /dev/null
@@ -1,26 +0,0 @@
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
-#include "ia_css_dpc2_types.h"
-
-const struct ia_css_dpc2_config default_dpc2_config = {
-	.metric1 = 1638,
-	.metric2 =  128,
-	.metric3 = 1638,
-	.wb_gain_gr = 512,
-	.wb_gain_r  = 512,
-	.wb_gain_b  = 512,
-	.wb_gain_gb = 512
-};
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.h
deleted file mode 100644
index a1527ce3eddc..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/dpc2/ia_css_dpc2_default.host.h
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
-#ifndef __IA_CSS_DPC2_DEFAULT_HOST_H
-#define __IA_CSS_DPC2_DEFAULT_HOST_H
-
-#include "ia_css_dpc2_types.h"
-
-extern const struct ia_css_dpc2_config default_dpc2_config;
-
-#endif /* __IA_CSS_DPC2_DEFAULT_HOST_H */
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.h
index 355ff13273b0..fff932c1364e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8.host.h
@@ -17,7 +17,6 @@
 
 #include "ia_css_eed1_8_types.h"
 #include "ia_css_eed1_8_param.h"
-#include "ia_css_eed1_8_default.host.h"
 
 void
 ia_css_eed1_8_vmem_encode(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.c
deleted file mode 100644
index 3622719dafa5..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.c
+++ /dev/null
@@ -1,94 +0,0 @@
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
-#include "ia_css_eed1_8_types.h"
-
-/* The default values for the kernel parameters are based on
- * ISP261 CSS API public parameter list_all.xlsx from 12-09-2014
- * The parameter list is available on the ISP261 sharepoint
- */
-
-/* Default kernel parameters. */
-const struct ia_css_eed1_8_config default_eed1_8_config = {
-	.rbzp_strength = 5489,
-	.fcstrength = 6554,
-	.fcthres_0 = 0,
-	.fcthres_1 = 0,
-	.fc_sat_coef = 8191,
-	.fc_coring_prm = 128,
-	.aerel_thres0 = 0,
-	.aerel_gain0 = 8191,
-	.aerel_thres1 = 16,
-	.aerel_gain1 = 20,
-	.derel_thres0 = 1229,
-	.derel_gain0 = 1,
-	.derel_thres1 = 819,
-	.derel_gain1 = 1,
-	.coring_pos0 = 0,
-	.coring_pos1 = 0,
-	.coring_neg0 = 0,
-	.coring_neg1 = 0,
-	.gain_exp = 2,
-	.gain_pos0 = 6144,
-	.gain_pos1 = 2048,
-	.gain_neg0 = 2048,
-	.gain_neg1 = 6144,
-	.pos_margin0 = 1475,
-	.pos_margin1 = 1475,
-	.neg_margin0 = 1475,
-	.neg_margin1 = 1475,
-	.dew_enhance_seg_x = {
-		0,
-		64,
-		272,
-		688,
-		1376,
-		2400,
-		3840,
-		5744,
-		8191
-		},
-	.dew_enhance_seg_y = {
-		0,
-		144,
-		480,
-		1040,
-		1852,
-		2945,
-		4357,
-		6094,
-		8191
-		},
-	.dew_enhance_seg_slope = {
-		4608,
-		3308,
-		2757,
-		2417,
-		2186,
-		8033,
-		7473,
-		7020
-		},
-	.dew_enhance_seg_exp = {
-		2,
-		2,
-		2,
-		2,
-		2,
-		0,
-		0,
-		0
-		},
-	.dedgew_max = 6144
-};
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.h
deleted file mode 100644
index 782f739ca8b5..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/eed1_8/ia_css_eed1_8_default.host.h
+++ /dev/null
@@ -1,22 +0,0 @@
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
-#ifndef __IA_CSS_EED1_8_DEFAULT_HOST_H
-#define __IA_CSS_EED1_8_DEFAULT_HOST_H
-
-#include "ia_css_eed1_8_types.h"
-
-extern const struct ia_css_eed1_8_config default_eed1_8_config;
-
-#endif /* __IA_CSS_EED1_8_DEFAULT_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h
index 1b3e759e41a3..bd628a18e839 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf.host.h
@@ -17,7 +17,6 @@
 
 #include "ia_css_tdf_types.h"
 #include "ia_css_tdf_param.h"
-#include "ia_css_tdf_default.host.h"
 
 void
 ia_css_tdf_vmem_encode(
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.c
deleted file mode 100644
index 9bb42daf070d..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.c
+++ /dev/null
@@ -1,36 +0,0 @@
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
-#include "ia_css_tdf_types.h"
-
-const struct ia_css_tdf_config default_tdf_config = {
-	.thres_flat_table = {0},
-	.thres_detail_table = {0},
-	.epsilon_0 = 4095,
-	.epsilon_1 = 5733,
-	.eps_scale_text = 409,
-	.eps_scale_edge = 3686,
-	.sepa_flat = 1294,
-	.sepa_edge = 4095,
-	.blend_flat = 819,
-	.blend_text = 819,
-	.blend_edge = 8191,
-	.shading_gain = 1024,
-	.shading_base_gain = 8191,
-	.local_y_gain = 0,
-	.local_y_base_gain = 2047,
-	.rad_x_origin = 0,
-	.rad_y_origin = 0
-};
-
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.h
deleted file mode 100644
index cd8fb70e5a87..000000000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/tdf/tdf_1.0/ia_css_tdf_default.host.h
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
-#ifndef __IA_CSS_TDF_DEFAULT_HOST_H
-#define __IA_CSS_TDF_DEFAULT_HOST_H
-
-#include "ia_css_tdf_types.h"
-
-extern const struct ia_css_tdf_config default_tdf_config;
-
-#endif /* __IA_CSS_TDF_DEFAULT_HOST_H */
-
-- 
2.14.3
