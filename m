Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:35760 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965Ab0ESDOn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:14:43 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:13:48 +0800
Subject: [PATCH v3 06/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895D9D@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 4c1c3d6692bb55f372d588a8217f2c75bf2bbb84 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:46:39 +0800
Subject: [PATCH 06/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which setup the sensor specic information for ISP.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 .../video/mrstisp/include/mrst_sensor_common.h     |  378 ++++++++++++++++++++
 .../media/video/mrstisp/include/mrstisp_snr_conf.h |   31 ++
 drivers/media/video/mrstisp/mrstisp_snr_conf.c     |  143 ++++++++
 3 files changed, 552 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/mrst_sensor_common.h
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp_snr_conf.h
 create mode 100644 drivers/media/video/mrstisp/mrstisp_snr_conf.c

diff --git a/drivers/media/video/mrstisp/include/mrst_sensor_common.h b/drivers/media/video/mrstisp/include/mrst_sensor_common.h
new file mode 100644
index 0000000..ca0da2f
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrst_sensor_common.h
@@ -0,0 +1,378 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef _SENSOR_FMT_COMMON_H
+#define _SENSOR_FMT_COMMON_H
+#include <media/v4l2-subdev.h>
+
+/*
+ * sensor capabilities struct: a struct member may have 0, 1 or several bits
+ * set according to the capabilities of the sensor. All struct members must be
+ * unsigned int and no padding is allowed. Thus, access to the fields is also
+ * possible by means of a field of unsigned int values. Indicees for the
+ * field-like access are given below.
+ */
+struct ci_sensor_caps{
+       unsigned int bus_width;
+       unsigned int mode;
+       unsigned int field_inv;
+       unsigned int field_sel;
+       unsigned int ycseq;
+       unsigned int conv422;
+       unsigned int bpat;
+       unsigned int hpol;
+       unsigned int vpol;
+       unsigned int edge;
+       unsigned int bls;
+       unsigned int gamma;
+       unsigned int cconv;
+       unsigned int res;
+       unsigned int dwn_sz;
+       unsigned int blc;
+       unsigned int agc;
+       unsigned int awb;
+       unsigned int aec;
+       unsigned int cie_profile;
+       unsigned int flicker_freq;
+       unsigned int smia_mode;
+       unsigned int mipi_mode;
+       unsigned int type;
+       char name[32];
+
+       struct v4l2_subdev sd;
+};
+
+#define ci_sensor_config       ci_sensor_caps
+
+#define SENSOR_BPAT_RGRGGBGB       0x00000001
+#define SENSOR_BPAT_GRGRBGBG       0x00000002
+#define SENSOR_BPAT_GBGBRGRG       0x00000004
+#define SENSOR_BPAT_BGBGGRGR       0x00000008
+
+#define SENSOR_BLC_AUTO            0x00000001
+#define SENSOR_BLC_OFF             0x00000002
+
+#define SENSOR_AGC_AUTO            0x00000001
+#define SENSOR_AGC_OFF             0x00000002
+
+#define SENSOR_AWB_AUTO            0x00000001
+#define SENSOR_AWB_OFF             0x00000002
+
+#define SENSOR_AEC_AUTO            0x00000001
+#define SENSOR_AEC_OFF             0x00000002
+
+/* turns on/off additional black lines at frame start */
+#define SENSOR_BLS_OFF             0x00000001
+#define SENSOR_BLS_TWO_LINES       0x00000002
+#define SENSOR_BLS_FOUR_LINES      0x00000004
+
+/* turns on/off gamma correction in the sensor ISP */
+#define SENSOR_GAMMA_ON            0x00000001
+#define SENSOR_GAMMA_OFF           0x00000002
+
+/* 88x72 */
+#define SENSOR_RES_QQCIF           0x00000001
+/* 160x120 */
+#define SENSOR_RES_QQVGA           0x00000002
+/* 176x144 */
+#define SENSOR_RES_QCIF            0x00000004
+/* 320x240 */
+#define SENSOR_RES_QVGA            0x00000008
+/* 352x288 */
+#define SENSOR_RES_CIF             0x00000010
+/* 640x480 */
+#define SENSOR_RES_VGA             0x00000020
+/* 800x600 */
+#define SENSOR_RES_SVGA            0x00000040
+/* 1024x768 */
+#define SENSOR_RES_XGA             0x00000080
+/* 1280x960 max. resolution of OV9640 (QuadVGA) */
+#define SENSOR_RES_XGA_PLUS        0x00000100
+/* 1280x1024 */
+#define SENSOR_RES_SXGA            0x00000200
+/* 1600x1200 */
+#define SENSOR_RES_UXGA            0x00000400
+/* 2048x1536 */
+#define SENSOR_RES_QXGA            0x00000800
+#define SENSOR_RES_QXGA_PLUS       0x00001000
+#define SENSOR_RES_RAWMAX          0x00002000
+/* 4080x1024 */
+#define SENSOR_RES_YUV_HMAX        0x00004000
+/* 1024x4080 */
+#define SENSOR_RES_YUV_VMAX        0x00008000
+/* 720x480 */
+#define SENSOR_RES_L_AFM           0x00020000
+/* 128x96 */
+#define SENSOR_RES_M_AFM           0x00040000
+/* 64x32 */
+#define SENSOR_RES_S_AFM           0x00080000
+/* 352x240 */
+#define SENSOR_RES_BP1             0x00100000
+/* 2586x2048, quadruple SXGA, 5,3 Mpix */
+#define SENSOR_RES_QSXGA           0x00200000
+/* 2600x2048, max. resolution of M5, 5,32 Mpix */
+#define SENSOR_RES_QSXGA_PLUS      0x00400000
+/* 2600x1950 */
+#define SENSOR_RES_QSXGA_PLUS2     0x00800000
+/* 2686x2048,  5.30M */
+#define SENSOR_RES_QSXGA_PLUS3     0x01000000
+/* 3200x2048,  6.56M */
+#define SENSOR_RES_WQSXGA          0x02000000
+/* 3200x2400,  7.68M */
+#define SENSOR_RES_QUXGA           0x04000000
+/* 3840x2400,  9.22M */
+#define SENSOR_RES_WQUXGA          0x08000000
+/* 4096x3072, 12.59M */
+#define SENSOR_RES_HXGA            0x10000000
+#define SENSOR_RES_1080P                  0x20000000
+/* 1280x720 */
+#define SENSOR_RES_720P        0x40000000
+
+/* FIXME 1304x980*/
+#define SENSOR_RES_VGA_PLUS    0x80000000
+#define VGA_PLUS_SIZE_H                (1304)
+#define VGA_PLUS_SIZE_V                (980)
+#define QSXGA_PLUS4_SIZE_H     (2592)
+#define QSXGA_PLUS4_SIZE_V     (1944)
+#define RES_1080P_SIZE_H       (1920)
+#define RES_1080P_SIZE_V       (1080)
+#define RES_720P_SIZE_H        (1280)
+#define RES_720P_SIZE_V        (720)
+#define QQCIF_SIZE_H              (88)
+#define QQCIF_SIZE_V              (72)
+#define QQVGA_SIZE_H             (160)
+#define QQVGA_SIZE_V             (120)
+#define QCIF_SIZE_H              (176)
+#define QCIF_SIZE_V              (144)
+#define QVGA_SIZE_H              (320)
+#define QVGA_SIZE_V              (240)
+#define CIF_SIZE_H               (352)
+#define CIF_SIZE_V               (288)
+#define VGA_SIZE_H               (640)
+#define VGA_SIZE_V               (480)
+#define SVGA_SIZE_H              (800)
+#define SVGA_SIZE_V              (600)
+#define XGA_SIZE_H              (1024)
+#define XGA_SIZE_V               (768)
+#define XGA_PLUS_SIZE_H         (1280)
+#define XGA_PLUS_SIZE_V          (960)
+#define SXGA_SIZE_H             (1280)
+#define SXGA_SIZE_V             (1024)
+#define QSVGA_SIZE_H            (1600)
+#define QSVGA_SIZE_V            (1200)
+#define UXGA_SIZE_H             (1600)
+#define UXGA_SIZE_V             (1200)
+#define QXGA_SIZE_H             (2048)
+#define QXGA_SIZE_V             (1536)
+#define QXGA_PLUS_SIZE_H        (2592)
+#define QXGA_PLUS_SIZE_V        (1944)
+#define RAWMAX_SIZE_H           (4096)
+#define RAWMAX_SIZE_V           (2048)
+#define YUV_HMAX_SIZE_H         (4080)
+#define YUV_HMAX_SIZE_V         (1024)
+#define YUV_VMAX_SIZE_H         (1024)
+#define YUV_VMAX_SIZE_V         (4080)
+#define BP1_SIZE_H               (352)
+#define BP1_SIZE_V               (240)
+#define L_AFM_SIZE_H             (720)
+#define L_AFM_SIZE_V             (480)
+#define M_AFM_SIZE_H             (128)
+#define M_AFM_SIZE_V              (96)
+#define S_AFM_SIZE_H              (64)
+#define S_AFM_SIZE_V              (32)
+#define QSXGA_SIZE_H            (2560)
+#define QSXGA_SIZE_V            (2048)
+#define QSXGA_MINUS_SIZE_V      (1920)
+#define QSXGA_PLUS_SIZE_H       (2600)
+#define QSXGA_PLUS_SIZE_V       (2048)
+#define QSXGA_PLUS2_SIZE_H      (2600)
+#define QSXGA_PLUS2_SIZE_V      (1950)
+#define QUXGA_SIZE_H            (3200)
+#define QUXGA_SIZE_V            (2400)
+#define SIZE_H_2500             (2500)
+#define QSXGA_PLUS3_SIZE_H      (2686)
+#define QSXGA_PLUS3_SIZE_V      (2048)
+#define QSXGA_PLUS4_SIZE_V      (1944)
+#define WQSXGA_SIZE_H           (3200)
+#define WQSXGA_SIZE_V           (2048)
+#define WQUXGA_SIZE_H           (3200)
+#define WQUXGA_SIZE_V           (2400)
+#define HXGA_SIZE_H             (4096)
+#define HXGA_SIZE_V             (3072)
+
+static inline int ci_sensor_res2size(unsigned int res, unsigned short *h_size,
+                      unsigned short *v_size)
+{
+       unsigned short hsize;
+       unsigned short vsize;
+       int err = 0;
+
+       switch (res) {
+       case SENSOR_RES_QQCIF:
+               hsize = QQCIF_SIZE_H;
+               vsize = QQCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QQVGA:
+               hsize = QQVGA_SIZE_H;
+               vsize = QQVGA_SIZE_V;
+               break;
+       case SENSOR_RES_QCIF:
+               hsize = QCIF_SIZE_H;
+               vsize = QCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QVGA:
+               hsize = QVGA_SIZE_H;
+               vsize = QVGA_SIZE_V;
+               break;
+       case SENSOR_RES_CIF:
+               hsize = CIF_SIZE_H;
+               vsize = CIF_SIZE_V;
+               break;
+       case SENSOR_RES_VGA:
+               hsize = VGA_SIZE_H;
+               vsize = VGA_SIZE_V;
+               break;
+       case SENSOR_RES_SVGA:
+               hsize = SVGA_SIZE_H;
+               vsize = SVGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA:
+               hsize = XGA_SIZE_H;
+               vsize = XGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA_PLUS:
+               hsize = XGA_PLUS_SIZE_H;
+               vsize = XGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_SXGA:
+               hsize = SXGA_SIZE_H;
+               vsize = SXGA_SIZE_V;
+               break;
+       case SENSOR_RES_UXGA:
+               hsize = UXGA_SIZE_H;
+               vsize = UXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QXGA:
+               hsize = QXGA_SIZE_H;
+               vsize = QXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA:
+               hsize = QSXGA_SIZE_H;
+               vsize = QSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS:
+               hsize = QSXGA_PLUS_SIZE_H;
+               vsize = QSXGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS2:
+               hsize = QSXGA_PLUS2_SIZE_H;
+               vsize = QSXGA_PLUS2_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS3:
+               hsize = QSXGA_PLUS3_SIZE_H;
+               vsize = QSXGA_PLUS3_SIZE_V;
+               break;
+       case SENSOR_RES_WQSXGA:
+               hsize = WQSXGA_SIZE_H;
+               vsize = WQSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QUXGA:
+               hsize = QUXGA_SIZE_H;
+               vsize = QUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_WQUXGA:
+               hsize = WQUXGA_SIZE_H;
+               vsize = WQUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_HXGA:
+               hsize = HXGA_SIZE_H;
+               vsize = HXGA_SIZE_V;
+               break;
+       case SENSOR_RES_RAWMAX:
+               hsize = RAWMAX_SIZE_H;
+               vsize = RAWMAX_SIZE_V;
+               break;
+       case SENSOR_RES_YUV_HMAX:
+               hsize = YUV_HMAX_SIZE_H;
+               vsize = YUV_HMAX_SIZE_V;
+               break;
+       case SENSOR_RES_YUV_VMAX:
+               hsize = YUV_VMAX_SIZE_H;
+               vsize = YUV_VMAX_SIZE_V;
+               break;
+       case SENSOR_RES_BP1:
+               hsize = BP1_SIZE_H;
+               vsize = BP1_SIZE_V;
+               break;
+       case SENSOR_RES_L_AFM:
+               hsize = L_AFM_SIZE_H;
+               vsize = L_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_M_AFM:
+               hsize = M_AFM_SIZE_H;
+               vsize = M_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_S_AFM:
+               hsize = S_AFM_SIZE_H;
+               vsize = S_AFM_SIZE_V;
+               break;
+
+       case SENSOR_RES_QXGA_PLUS:
+               hsize = QXGA_PLUS_SIZE_H;
+               vsize = QXGA_PLUS_SIZE_V;
+               break;
+
+       case SENSOR_RES_1080P:
+               hsize = RES_1080P_SIZE_H;
+               vsize = 1080;
+               break;
+
+       case SENSOR_RES_720P:
+               hsize = RES_720P_SIZE_H;
+               vsize = RES_720P_SIZE_V;
+               break;
+
+       case SENSOR_RES_VGA_PLUS:
+               hsize = VGA_PLUS_SIZE_H;
+               vsize = VGA_PLUS_SIZE_V;
+               break;
+
+       default:
+               hsize = 0;
+               vsize = 0;
+               err = -1;
+               printk(KERN_ERR "ci_sensor_res2size: Resolution 0x%08x"
+                      "unknown\n", res);
+               break;
+       }
+
+       if (h_size != NULL)
+               *h_size = hsize;
+       if (v_size != NULL)
+               *v_size = vsize;
+
+       return err;
+}
+#endif
diff --git a/drivers/media/video/mrstisp/include/mrstisp_snr_conf.h b/drivers/media/video/mrstisp/include/mrstisp_snr_conf.h
new file mode 100644
index 0000000..5380235
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp_snr_conf.h
@@ -0,0 +1,31 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#ifndef _MRSTISP_SNR_CONF_H_
+#define _MRSTISP_SNR_CONF_H_
+
+int mrstisp_snr_conf_init(struct ci_sensor_config *info);
+
+#endif
diff --git a/drivers/media/video/mrstisp/mrstisp_snr_conf.c b/drivers/media/video/mrstisp/mrstisp_snr_conf.c
new file mode 100644
index 0000000..f4f3c8c
--- /dev/null
+++ b/drivers/media/video/mrstisp/mrstisp_snr_conf.c
@@ -0,0 +1,143 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging ISP subsystem.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * Copyright (c) Silicon Image 2008  www.siliconimage.com
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include "mrstisp_stdinc.h"
+
+static void mrstisp_ov5630_conf_init(struct ci_sensor_config *info)
+{
+       info->mode = SENSOR_MODE_BAYER;
+       info->res = SENSOR_RES_QXGA_PLUS;
+       info->type = SENSOR_TYPE_RAW;
+       info->bls = SENSOR_BLS_OFF;
+       info->gamma = SENSOR_GAMMA_OFF;
+       info->cconv = SENSOR_CCONV_OFF;
+       info->blc = SENSOR_BLC_AUTO;
+       info->agc = SENSOR_AGC_AUTO;
+       info->awb = SENSOR_AWB_AUTO;
+       info->aec = SENSOR_AEC_AUTO;
+       info->bus_width = SENSOR_BUSWIDTH_10BIT_ZZ;
+       info->ycseq = SENSOR_YCSEQ_YCBYCR;
+       info->conv422 = SENSOR_CONV422_COSITED;
+       info->bpat = SENSOR_BPAT_BGBGGRGR;
+       info->field_inv = SENSOR_FIELDINV_NOSWAP;
+       info->field_sel = SENSOR_FIELDSEL_BOTH;
+       info->hpol = SENSOR_HPOL_REFPOS;
+       info->vpol = SENSOR_VPOL_NEG;
+       info->edge = SENSOR_EDGE_RISING;
+       info->flicker_freq = SENSOR_FLICKER_100;
+       info->cie_profile = SENSOR_CIEPROF_F11;
+}
+
+static void mrstisp_s5k4e1_conf_init(struct ci_sensor_config *info)
+{
+       info->mode = SENSOR_MODE_MIPI;
+       info->res = SENSOR_RES_QXGA_PLUS;
+       info->type = SENSOR_TYPE_RAW;
+       info->bls = SENSOR_BLS_OFF;
+       info->gamma = SENSOR_GAMMA_OFF;
+       info->cconv = SENSOR_CCONV_OFF;
+       info->blc = SENSOR_BLC_AUTO;
+       info->agc = SENSOR_AGC_OFF;
+       info->awb = SENSOR_AWB_OFF;
+       info->aec = SENSOR_AEC_OFF;
+       info->bus_width = SENSOR_BUSWIDTH_12BIT;
+       info->ycseq = SENSOR_YCSEQ_YCBYCR;
+       info->conv422 = SENSOR_CONV422_COSITED;
+       info->bpat = SENSOR_BPAT_GRGRBGBG;
+       info->field_inv = SENSOR_FIELDINV_NOSWAP;
+       info->field_sel = SENSOR_FIELDSEL_BOTH;
+       info->hpol = SENSOR_HPOL_REFPOS;
+       info->vpol = SENSOR_VPOL_NEG;
+       info->edge = SENSOR_EDGE_RISING;
+       info->flicker_freq = SENSOR_FLICKER_100;
+       info->cie_profile = SENSOR_CIEPROF_F11;
+       info->mipi_mode = SENSOR_MIPI_MODE_RAW_10;
+}
+
+static void mrstisp_ov2650_conf_init(struct ci_sensor_config *info)
+{
+       info->mode = SENSOR_MODE_BT601;
+       info->res = SENSOR_RES_UXGA;
+       info->type = SENSOR_TYPE_SOC;
+       info->bls = SENSOR_BLS_OFF;
+       info->gamma = SENSOR_GAMMA_ON;
+       info->cconv = SENSOR_CCONV_ON;
+       info->blc = SENSOR_BLC_AUTO;
+       info->agc = SENSOR_AGC_AUTO;
+       info->awb = SENSOR_AWB_AUTO;
+       info->aec = SENSOR_AEC_AUTO;
+       info->bus_width = SENSOR_BUSWIDTH_8BIT_ZZ;
+       info->ycseq = SENSOR_YCSEQ_YCBYCR;
+       info->conv422 = SENSOR_CONV422_COSITED;
+       info->bpat = SENSOR_BPAT_BGBGGRGR;
+       info->field_inv = SENSOR_FIELDINV_NOSWAP;
+       info->field_sel = SENSOR_FIELDSEL_BOTH;
+       info->hpol = SENSOR_HPOL_REFPOS;
+       info->vpol = SENSOR_VPOL_POS;
+       info->edge = SENSOR_EDGE_RISING;
+       info->flicker_freq = SENSOR_FLICKER_100;
+       info->cie_profile = 0;
+}
+
+static void mrstisp_ov9665_conf_init(struct ci_sensor_config *info)
+{
+       info->mode = SENSOR_MODE_BT601;
+       info->res = SENSOR_RES_SXGA;
+       info->type = SENSOR_TYPE_SOC;
+       info->bls = SENSOR_BLS_OFF;
+       info->gamma = SENSOR_GAMMA_ON;
+       info->cconv = SENSOR_CCONV_ON;
+       info->blc = SENSOR_BLC_AUTO;
+       info->agc = SENSOR_AGC_AUTO;
+       info->awb = SENSOR_AWB_AUTO;
+       info->aec = SENSOR_AEC_AUTO;
+       info->bus_width = SENSOR_BUSWIDTH_8BIT_ZZ;
+       info->ycseq = SENSOR_YCSEQ_YCBYCR;
+       info->conv422 = SENSOR_CONV422_COSITED;
+       info->bpat = SENSOR_BPAT_GRGRBGBG;
+       info->field_inv = SENSOR_FIELDINV_NOSWAP;
+       info->field_sel = SENSOR_FIELDSEL_BOTH;
+       info->hpol = SENSOR_HPOL_REFPOS;
+       info->vpol = SENSOR_VPOL_POS;
+       info->edge = SENSOR_EDGE_FALLING;
+       info->flicker_freq = SENSOR_FLICKER_100;
+       info->cie_profile = 0;
+}
+
+int mrstisp_snr_conf_init(struct ci_sensor_config *info)
+{
+       char *name = info->name;
+
+       if (!strcmp(name, "ov5630"))
+               mrstisp_ov5630_conf_init(info);
+       else if (!strcmp(name, "s5k4e1"))
+               mrstisp_s5k4e1_conf_init(info);
+       else if (!strcmp(name, "ov2650"))
+               mrstisp_ov2650_conf_init(info);
+       else if (!strcmp(name, "ov9665"))
+               mrstisp_ov9665_conf_init(info);
+
+       return CI_STATUS_SUCCESS;
+}
--
1.6.3.2

