Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:26917 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752413AbdDLSW0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Apr 2017 14:22:26 -0400
Subject: [PATCH 11/14] atomisp: remove satm kernel
From: Alan Cox <alan@linux.intel.com>
To: greg@kroah.com, linux-media@vger.kernel.org
Date: Wed, 12 Apr 2017 19:22:13 +0100
Message-ID: <149202132616.16615.10431476367740144807.stgit@acox1-desk1.ger.corp.intel.com>
In-Reply-To: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
References: <149202119790.16615.4841216953457109397.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This isn't used so it can go in the bitbucket.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../staging/media/atomisp/pci/atomisp2/Makefile    |    1 -
 .../css2400/isp/kernels/satm/ia_css_satm.host.c    |   27 ---------------
 .../css2400/isp/kernels/satm/ia_css_satm.host.h    |   29 -----------------
 .../css2400/isp/kernels/satm/ia_css_satm_param.h   |   30 -----------------
 .../css2400/isp/kernels/satm/ia_css_satm_types.h   |   35 --------------------
 5 files changed, 122 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.c
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_param.h
 delete mode 100644 drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_types.h

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/Makefile b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
index ab10fc0..8780914 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/Makefile
+++ b/drivers/staging/media/atomisp/pci/atomisp2/Makefile
@@ -80,7 +80,6 @@ atomisp-objs += \
 	css2400/isp/kernels/sdis/sdis_2/ia_css_sdis2.host.o \
 	css2400/isp/kernels/cnr/cnr_2/ia_css_cnr2.host.o \
 	css2400/isp/kernels/cnr/cnr_1.0/ia_css_cnr.host.o \
-	css2400/isp/kernels/satm/ia_css_satm.host.o \
 	css2400/isp/kernels/xnr/xnr_1.0/ia_css_xnr.host.o \
 	css2400/isp/kernels/xnr/xnr_1.0/ia_css_xnr_table.host.o \
 	css2400/isp/kernels/xnr/xnr3_0_5/ia_css_xnr3_0_5.host.o \
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.c
deleted file mode 100644
index d35194b..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.c
+++ /dev/null
@@ -1,27 +0,0 @@
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
-#include "ia_css_satm.host.h"
-
-
-void
-ia_css_satm_init_config(
-	struct sh_css_isp_satm_params *to,
-	const struct ia_css_satm_config *from,
-	unsigned size)
-{
-	(void) size;
-
-	to->params.test_satm = from->params.test_satm;
-}
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.h
deleted file mode 100644
index 807b716..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm.host.h
+++ /dev/null
@@ -1,29 +0,0 @@
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
-#ifndef __IA_CSS_SATM_HOST_H
-#define __IA_CSS_SATM_HOST_H
-
-#include "ia_css_satm_param.h"
-#include "ia_css_satm_types.h"
-
-extern const struct ia_css_satm_config default_satm_config;
-
-void
-ia_css_satm_init_config(
-	struct sh_css_isp_satm_params *to,
-	const struct ia_css_satm_config *from,
-	unsigned size);
-
-#endif /* __IA_CSS_SATM_HOST_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_param.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_param.h
deleted file mode 100644
index 062f79aa4..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_param.h
+++ /dev/null
@@ -1,30 +0,0 @@
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
-#ifndef __IA_CSS_SATM_PARAMS_H
-#define __IA_CSS_SATM_PARAMS_H
-
-#include "type_support.h"
-
-/* SATM parameters on ISP. */
-struct sh_css_satm_params {
-	int32_t test_satm;
-};
-
-/* SATM ISP parameters */
-struct sh_css_isp_satm_params {
-	struct sh_css_satm_params params;
-};
-
-#endif /* __IA_CSS_SATM_PARAMS_H */
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_types.h b/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_types.h
deleted file mode 100644
index 94f10e3..0000000
--- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/isp/kernels/satm/ia_css_satm_types.h
+++ /dev/null
@@ -1,35 +0,0 @@
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
-#ifndef __IA_CSS_SATM_TYPES_H
-#define __IA_CSS_SATM_TYPES_H
-
-/**
- * \brief SATM Parameters
- * \detail Currently SATM paramters are used only for testing purposes
- */
-struct ia_css_satm_params {
-	int test_satm; /**< Test parameter */
-};
-
-/**
- * \brief SATM public paramterers.
- * \details Struct with all paramters for SATM that can be seet from
- * the CSS API. Currenly, only test paramters are defined.
- */
-struct ia_css_satm_config {
-	struct ia_css_satm_params params; /**< SATM paramaters */
-};
-
-#endif /* __IA_CSS_SATM_TYPES_H */
