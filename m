Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34422 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570Ab0ESDLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 23:11:23 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 19 May 2010 11:10:11 +0800
Subject: [PATCH v3 04/10] V4L2 ISP driver patchset for Intel Moorestown
 Camera Imaging Subsystem
Message-ID: <33AB447FBD802F4E932063B962385B351E895D94@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 68aa3138cafdb98027116227498bcf67492b82d6 Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Tue, 18 May 2010 15:43:04 +0800
Subject: [PATCH 04/10] This patch is a part of v4l2 ISP patchset for Intel Moorestown camera imaging
 subsystem support which control the ISP JPEG encoder setting.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstisp/include/mrstisp_jpe.h |  416 +++++++++++++++
 drivers/media/video/mrstisp/mrstisp_jpe.c         |  569 +++++++++++++++++++++
 2 files changed, 985 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstisp/include/mrstisp_jpe.h
 create mode 100644 drivers/media/video/mrstisp/mrstisp_jpe.c

diff --git a/drivers/media/video/mrstisp/include/mrstisp_jpe.h b/drivers/media/video/mrstisp/include/mrstisp_jpe.h
new file mode 100644
index 0000000..634c715
--- /dev/null
+++ b/drivers/media/video/mrstisp/include/mrstisp_jpe.h
@@ -0,0 +1,416 @@
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
+#include "mrstisp.h"
+
+/* DC luma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_dc_luma_table_annex_k[] = {
+       0x00, 0x01, 0x05, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+       0x08, 0x09, 0x0a, 0x0b
+};
+
+/* DC chroma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_dc_chroma_table_annex_k[] = {
+       0x00, 0x03, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
+       0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+       0x08, 0x09, 0x0a, 0x0b
+};
+
+/* AC luma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_ac_luma_table_annex_k[] = {
+       0x00, 0x02, 0x01, 0x03, 0x03, 0x02, 0x04, 0x03,
+       0x05, 0x05, 0x04, 0x04, 0x00, 0x00, 0x01, 0x7d,
+       0x01, 0x02, 0x03, 0x00, 0x04, 0x11, 0x05, 0x12,
+       0x21, 0x31, 0x41, 0x06, 0x13, 0x51, 0x61, 0x07,
+       0x22, 0x71, 0x14, 0x32, 0x81, 0x91, 0xa1, 0x08,
+       0x23, 0x42, 0xb1, 0xc1, 0x15, 0x52, 0xd1, 0xf0,
+       0x24, 0x33, 0x62, 0x72, 0x82, 0x09, 0x0a, 0x16,
+       0x17, 0x18, 0x19, 0x1a, 0x25, 0x26, 0x27, 0x28,
+       0x29, 0x2a, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,
+       0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48, 0x49,
+       0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59,
+       0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68, 0x69,
+       0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78, 0x79,
+       0x7a, 0x83, 0x84, 0x85, 0x86, 0x87, 0x88, 0x89,
+       0x8a, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98,
+       0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7,
+       0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4, 0xb5, 0xb6,
+       0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3, 0xc4, 0xc5,
+       0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2, 0xd3, 0xd4,
+       0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda, 0xe1, 0xe2,
+       0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9, 0xea,
+       0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+       0xf9, 0xfa
+};
+
+/* AC Chroma table according to ISO/IEC 10918-1 annex K */
+static const u8 ci_isp_ac_chroma_table_annex_k[] = {
+       0x00, 0x02, 0x01, 0x02, 0x04, 0x04, 0x03, 0x04,
+       0x07, 0x05, 0x04, 0x04, 0x00, 0x01, 0x02, 0x77,
+       0x00, 0x01, 0x02, 0x03, 0x11, 0x04, 0x05, 0x21,
+       0x31, 0x06, 0x12, 0x41, 0x51, 0x07, 0x61, 0x71,
+       0x13, 0x22, 0x32, 0x81, 0x08, 0x14, 0x42, 0x91,
+       0xa1, 0xb1, 0xc1, 0x09, 0x23, 0x33, 0x52, 0xf0,
+       0x15, 0x62, 0x72, 0xd1, 0x0a, 0x16, 0x24, 0x34,
+       0xe1, 0x25, 0xf1, 0x17, 0x18, 0x19, 0x1a, 0x26,
+       0x27, 0x28, 0x29, 0x2a, 0x35, 0x36, 0x37, 0x38,
+       0x39, 0x3a, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
+       0x49, 0x4a, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58,
+       0x59, 0x5a, 0x63, 0x64, 0x65, 0x66, 0x67, 0x68,
+       0x69, 0x6a, 0x73, 0x74, 0x75, 0x76, 0x77, 0x78,
+       0x79, 0x7a, 0x82, 0x83, 0x84, 0x85, 0x86, 0x87,
+       0x88, 0x89, 0x8a, 0x92, 0x93, 0x94, 0x95, 0x96,
+       0x97, 0x98, 0x99, 0x9a, 0xa2, 0xa3, 0xa4, 0xa5,
+       0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xb2, 0xb3, 0xb4,
+       0xb5, 0xb6, 0xb7, 0xb8, 0xb9, 0xba, 0xc2, 0xc3,
+       0xc4, 0xc5, 0xc6, 0xc7, 0xc8, 0xc9, 0xca, 0xd2,
+       0xd3, 0xd4, 0xd5, 0xd6, 0xd7, 0xd8, 0xd9, 0xda,
+       0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7, 0xe8, 0xe9,
+       0xea, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7, 0xf8,
+       0xf9, 0xfa
+};
+
+/* luma quantization table 75% quality setting */
+static const u8 ci_isp_yq_table75_per_cent[] = {
+       0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07,
+       0x07, 0x07, 0x09, 0x09, 0x08, 0x0a, 0x0c, 0x14,
+       0x0d, 0x0c, 0x0b, 0x0b, 0x0c, 0x19, 0x12, 0x13,
+       0x0f, 0x14, 0x1d, 0x1a, 0x1f, 0x1e, 0x1d, 0x1a,
+       0x1c, 0x1c, 0x20, 0x24, 0x2e, 0x27, 0x20, 0x22,
+       0x2c, 0x23, 0x1c, 0x1c, 0x28, 0x37, 0x29, 0x2c,
+       0x30, 0x31, 0x34, 0x34, 0x34, 0x1f, 0x27, 0x39,
+       0x3d, 0x38, 0x32, 0x3c, 0x2e, 0x33, 0x34, 0x32
+};
+
+/* chroma quantization table 75% quality setting */
+static const u8 ci_isp_uv_qtable75_per_cent[] = {
+       0x09, 0x09, 0x09, 0x0c, 0x0b, 0x0c, 0x18, 0x0d,
+       0x0d, 0x18, 0x32, 0x21, 0x1c, 0x21, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32,
+       0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32, 0x32
+};
+
+/*
+ * luma quantization table very low compression(about factor 2)
+ */
+static const u8 ci_isp_yq_table_low_comp1[] = {
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/*
+ * chroma quantization table very low compression
+ * (about factor 2)
+ */
+static const u8 ci_isp_uv_qtable_low_comp1[] = {
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/*
+ * The jpg Quantization Tables were parsed by jpeg_parser from
+ * jpg images generated by Jasc PaintShopPro.
+ *
+ */
+
+/* 01% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table01_per_cent[] = {
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x01, 0x01, 0x02, 0x02, 0x01, 0x01,
+       0x02, 0x01, 0x01, 0x01, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x01, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable01_per_cent[] = {
+       0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
+       0x01, 0x01, 0x02, 0x01, 0x01, 0x01, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02,
+       0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02
+};
+
+/* 20% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table20_per_cent[] = {
+       0x06, 0x04, 0x05, 0x06, 0x05, 0x04, 0x06, 0x06,
+       0x05, 0x06, 0x07, 0x07, 0x06, 0x08, 0x0a, 0x10,
+       0x0a, 0x0a, 0x09, 0x09, 0x0a, 0x14, 0x0e, 0x0f,
+       0x0c, 0x10, 0x17, 0x14, 0x18, 0x18, 0x17, 0x14,
+       0x16, 0x16, 0x1a, 0x1d, 0x25, 0x1f, 0x1a, 0x1b,
+       0x23, 0x1c, 0x16, 0x16, 0x20, 0x2c, 0x20, 0x23,
+       0x26, 0x27, 0x29, 0x2a, 0x29, 0x19, 0x1f, 0x2d,
+       0x30, 0x2d, 0x28, 0x30, 0x25, 0x28, 0x29, 0x28
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable20_per_cent[] = {
+       0x07, 0x07, 0x07, 0x0a, 0x08, 0x0a, 0x13, 0x0a,
+       0x0a, 0x13, 0x28, 0x1a, 0x16, 0x1a, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28,
+       0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28, 0x28
+};
+
+/* 30% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table30_per_cent[] = {
+       0x0a, 0x07, 0x07, 0x08, 0x07, 0x06, 0x0a, 0x08,
+       0x08, 0x08, 0x0b, 0x0a, 0x0a, 0x0b, 0x0e, 0x18,
+       0x10, 0x0e, 0x0d, 0x0d, 0x0e, 0x1d, 0x15, 0x16,
+       0x11, 0x18, 0x23, 0x1f, 0x25, 0x24, 0x22, 0x1f,
+       0x22, 0x21, 0x26, 0x2b, 0x37, 0x2f, 0x26, 0x29,
+       0x34, 0x29, 0x21, 0x22, 0x30, 0x41, 0x31, 0x34,
+       0x39, 0x3b, 0x3e, 0x3e, 0x3e, 0x25, 0x2e, 0x44,
+       0x49, 0x43, 0x3c, 0x48, 0x37, 0x3d, 0x3e, 0x3b
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable30_per_cent[] = {
+       0x0a, 0x0b, 0x0b, 0x0e, 0x0d, 0x0e, 0x1c, 0x10,
+       0x10, 0x1c, 0x3b, 0x28, 0x22, 0x28, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b,
+       0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b, 0x3b
+};
+
+
+/* 40% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table40_per_cent[] = {
+       0x0d, 0x09, 0x0a, 0x0b, 0x0a, 0x08, 0x0d, 0x0b,
+       0x0a, 0x0b, 0x0e, 0x0e, 0x0d, 0x0f, 0x13, 0x20,
+       0x15, 0x13, 0x12, 0x12, 0x13, 0x27, 0x1c, 0x1e,
+       0x17, 0x20, 0x2e, 0x29, 0x31, 0x30, 0x2e, 0x29,
+       0x2d, 0x2c, 0x33, 0x3a, 0x4a, 0x3e, 0x33, 0x36,
+       0x46, 0x37, 0x2c, 0x2d, 0x40, 0x57, 0x41, 0x46,
+       0x4c, 0x4e, 0x52, 0x53, 0x52, 0x32, 0x3e, 0x5a,
+       0x61, 0x5a, 0x50, 0x60, 0x4a, 0x51, 0x52, 0x4f
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable40_per_cent[] = {
+       0x0e, 0x0e, 0x0e, 0x13, 0x11, 0x13, 0x26, 0x15,
+       0x15, 0x26, 0x4f, 0x35, 0x2d, 0x35, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f,
+       0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f, 0x4f
+};
+
+/* 50% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table50_per_cent[] = {
+       0x10, 0x0b, 0x0c, 0x0e, 0x0c, 0x0a, 0x10, 0x0e,
+       0x0d, 0x0e, 0x12, 0x11, 0x10, 0x13, 0x18, 0x28,
+       0x1a, 0x18, 0x16, 0x16, 0x18, 0x31, 0x23, 0x25,
+       0x1d, 0x28, 0x3a, 0x33, 0x3d, 0x3c, 0x39, 0x33,
+       0x38, 0x37, 0x40, 0x48, 0x5c, 0x4e, 0x40, 0x44,
+       0x57, 0x45, 0x37, 0x38, 0x50, 0x6d, 0x51, 0x57,
+       0x5f, 0x62, 0x67, 0x68, 0x67, 0x3e, 0x4d, 0x71,
+       0x79, 0x70, 0x64, 0x78, 0x5c, 0x65, 0x67, 0x63
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable50_per_cent[] = {
+       0x11, 0x12, 0x12, 0x18, 0x15, 0x18, 0x2f, 0x1a,
+       0x1a, 0x2f, 0x63, 0x42, 0x38, 0x42, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63,
+       0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63, 0x63
+};
+
+/* 60% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table60_per_cent[] = {
+       0x14, 0x0e, 0x0f, 0x12, 0x0f, 0x0d, 0x14, 0x12,
+       0x10, 0x12, 0x17, 0x15, 0x14, 0x18, 0x1e, 0x32,
+       0x21, 0x1e, 0x1c, 0x1c, 0x1e, 0x3d, 0x2c, 0x2e,
+       0x24, 0x32, 0x49, 0x40, 0x4c, 0x4b, 0x47, 0x40,
+       0x46, 0x45, 0x50, 0x5a, 0x73, 0x62, 0x50, 0x55,
+       0x6d, 0x56, 0x45, 0x46, 0x64, 0x88, 0x65, 0x6d,
+       0x77, 0x7b, 0x81, 0x82, 0x81, 0x4e, 0x60, 0x8d,
+       0x97, 0x8c, 0x7d, 0x96, 0x73, 0x7e, 0x81, 0x7c
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable60_per_cent[] = {
+       0x15, 0x17, 0x17, 0x1e, 0x1a, 0x1e, 0x3b, 0x21,
+       0x21, 0x3b, 0x7c, 0x53, 0x46, 0x53, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c,
+       0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c, 0x7c
+};
+
+/* 70% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table70_per_cent[] = {
+       0x1b, 0x12, 0x14, 0x17, 0x14, 0x11, 0x1b, 0x17,
+       0x16, 0x17, 0x1e, 0x1c, 0x1b, 0x20, 0x28, 0x42,
+       0x2b, 0x28, 0x25, 0x25, 0x28, 0x51, 0x3a, 0x3d,
+       0x30, 0x42, 0x60, 0x55, 0x65, 0x64, 0x5f, 0x55,
+       0x5d, 0x5b, 0x6a, 0x78, 0x99, 0x81, 0x6a, 0x71,
+       0x90, 0x73, 0x5b, 0x5d, 0x85, 0xb5, 0x86, 0x90,
+       0x9e, 0xa3, 0xab, 0xad, 0xab, 0x67, 0x80, 0xbc,
+       0xc9, 0xba, 0xa6, 0xc7, 0x99, 0xa8, 0xab, 0xa4
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable70_per_cent[] = {
+       0x1c, 0x1e, 0x1e, 0x28, 0x23, 0x28, 0x4e, 0x2b,
+       0x2b, 0x4e, 0xa4, 0x6e, 0x5d, 0x6e, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4,
+       0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4, 0xa4
+};
+
+/* 80% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table80_per_cent[] = {
+       0x28, 0x1c, 0x1e, 0x23, 0x1e, 0x19, 0x28, 0x23,
+       0x21, 0x23, 0x2d, 0x2b, 0x28, 0x30, 0x3c, 0x64,
+       0x41, 0x3c, 0x37, 0x37, 0x3c, 0x7b, 0x58, 0x5d,
+       0x49, 0x64, 0x91, 0x80, 0x99, 0x96, 0x8f, 0x80,
+       0x8c, 0x8a, 0xa0, 0xb4, 0xe6, 0xc3, 0xa0, 0xaa,
+       0xda, 0xad, 0x8a, 0x8c, 0xc8, 0xff, 0xcb, 0xda,
+       0xee, 0xf5, 0xff, 0xff, 0xff, 0x9b, 0xc1, 0xff,
+       0xff, 0xff, 0xfa, 0xff, 0xe6, 0xfd, 0xff, 0xf8
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable80_per_cent[] = {
+       0x2b, 0x2d, 0x2d, 0x3c, 0x35, 0x3c, 0x76, 0x41,
+       0x41, 0x76, 0xf8, 0xa5, 0x8c, 0xa5, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8,
+       0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8, 0xf8
+};
+
+/* 90% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table90_per_cent[] = {
+       0x50, 0x37, 0x3c, 0x46, 0x3c, 0x32, 0x50, 0x46,
+       0x41, 0x46, 0x5a, 0x55, 0x50, 0x5f, 0x78, 0xc8,
+       0x82, 0x78, 0x6e, 0x6e, 0x78, 0xf5, 0xaf, 0xb9,
+       0x91, 0xc8, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable90_per_cent[] = {
+       0x55, 0x5a, 0x5a, 0x78, 0x69, 0x78, 0xeb, 0x82,
+       0x82, 0xeb, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+/* 99% */
+/* luma quantization table */
+static const u8 ci_isp_yq_table99_per_cent[] = {
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+/* chroma quantization table */
+static const u8 ci_isp_uv_qtable99_per_cent[] = {
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
+       0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
+};
+
+int ci_isp_wait_for_vsyncHelper(void);
+void ci_isp_jpe_set_tables(u8 compression_ratio);
+void ci_isp_jpe_select_tables(void);
+void ci_isp_jpe_set_config(u16 hsize, u16 vsize, int jpe_scale);
+int ci_isp_jpe_generate_header(struct mrst_isp_device *intel, u8 header_mode);
+void ci_isp_jpe_prep_enc(enum ci_isp_jpe_enc_mode jpe_enc_mode);
+int ci_isp_jpe_wait_for_header_gen_done(struct mrst_isp_device *intel);
+int ci_isp_jpe_wait_for_encode_done(struct mrst_isp_device *intel);
+
diff --git a/drivers/media/video/mrstisp/mrstisp_jpe.c b/drivers/media/video/mrstisp/mrstisp_jpe.c
new file mode 100644
index 0000000..c042e06
--- /dev/null
+++ b/drivers/media/video/mrstisp/mrstisp_jpe.c
@@ -0,0 +1,569 @@
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
+int ci_isp_jpe_init_ex(u16 hsize, u16 vsize, u8 compression_ratio, u8 jpe_scale)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       /*
+        * Reset JPEG-Encoder. In contrast to other software resets
+        * this triggers the modules asynchronous reset resulting
+        * in loss of all data.
+        */
+
+       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_JPEG_SOFT_RST, ON);
+       REG_SET_SLICE(mrv_reg->vi_ircl, MRV_VI_JPEG_SOFT_RST, OFF);
+
+       /* set configuration for the Jpeg capturing */
+       ci_isp_jpe_set_config(hsize, vsize, jpe_scale);
+
+       /*
+        * Sleep a while before setting up tables because of the 400
+        * clock cycles required to initialize the table RAM after a
+        * reset was issued. On FPGA we are running with only 30MHz,
+        * so at least 13us are required.
+        */
+
+
+       /*
+        * Note: this func is called when holding spin lock,
+        * so can not change to msleep.
+        */
+       mdelay(15);
+
+       /* program tables */
+       ci_isp_jpe_set_tables(compression_ratio);
+
+       /* choose tables */
+       ci_isp_jpe_select_tables();
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * initialization of JPEG encoder
+ */
+int ci_isp_jpe_init(u32 resolution, u8 compression_ratio, int jpe_scale)
+{
+       u16 hsize = 0;
+       u16 vsize = 0;
+
+       switch (resolution) {
+       case SENSOR_RES_BP1:
+               /* 352; */
+               hsize = BP1_SIZE_H;
+               /* 240; */
+               vsize = BP1_SIZE_V;
+               break;
+       case SENSOR_RES_S_AFM:
+               /* 64; */
+               hsize = S_AFM_SIZE_H;
+               /* 32; */
+               vsize = S_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_M_AFM:
+               /* 128; */
+               hsize = M_AFM_SIZE_H;
+               /* 96; */
+               vsize = M_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_L_AFM:
+               /* 720; */
+               hsize = L_AFM_SIZE_H;
+               /* 480; */
+               vsize = L_AFM_SIZE_V;
+               break;
+       case SENSOR_RES_QQCIF:
+               /* 88; */
+               hsize = QQCIF_SIZE_H;
+               /* 72; */
+               vsize = QQCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QQVGA:
+               /* 160; */
+               hsize = QQVGA_SIZE_H;
+               /* 120; */
+               vsize = QQVGA_SIZE_V;
+               break;
+       case SENSOR_RES_QCIF:
+               /* 176; */
+               hsize = QCIF_SIZE_H;
+               /* 144; */
+               vsize = QCIF_SIZE_V;
+               break;
+       case SENSOR_RES_QVGA:
+               /* 320; */
+               hsize = QVGA_SIZE_H;
+               /* 240; */
+               vsize = QVGA_SIZE_V;
+               break;
+       case SENSOR_RES_CIF:
+               /* 352; */
+               hsize = CIF_SIZE_H;
+               /* 288; */
+               vsize = CIF_SIZE_V;
+               break;
+       case SENSOR_RES_VGA:
+               /* 640; */
+               hsize = VGA_SIZE_H;
+               /* 480; */
+               vsize = VGA_SIZE_V;
+               break;
+       case SENSOR_RES_SVGA:
+               /* 800; */
+               hsize = SVGA_SIZE_H;
+               /* 600; */
+               vsize = SVGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA:
+               /* 1024; */
+               hsize = XGA_SIZE_H;
+               /* 768; */
+               vsize = XGA_SIZE_V;
+               break;
+       case SENSOR_RES_XGA_PLUS:
+               /* 1280; */
+               hsize = XGA_PLUS_SIZE_H;
+               /* 960; */
+               vsize = XGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_SXGA:
+               /* 1280; */
+               hsize = SXGA_SIZE_H;
+               /* 1024; */
+               vsize = SXGA_SIZE_V;
+               break;
+       case SENSOR_RES_UXGA:
+               /* 1600; */
+               hsize = UXGA_SIZE_H;
+               /* 1200; */
+               vsize = UXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QXGA:
+               /* 2048; */
+               hsize = QXGA_SIZE_H;
+               /* 1536; */
+               vsize = QXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA:
+               /* 2586; */
+               hsize = QSXGA_SIZE_H;
+               /* 2048; */
+               vsize = QSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS:
+               /* 2600; */
+               hsize = QSXGA_PLUS_SIZE_H;
+               /* 2048; */
+               vsize = QSXGA_PLUS_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS2:
+               /* 2600; */
+               hsize = QSXGA_PLUS2_SIZE_H;
+               /* 1950; */
+               vsize = QSXGA_PLUS2_SIZE_V;
+               break;
+       case SENSOR_RES_QSXGA_PLUS3:
+               /* 2686; */
+               hsize = QSXGA_PLUS3_SIZE_H;
+               /* 2048; */
+               vsize = QSXGA_PLUS3_SIZE_V;
+               break;
+       case SENSOR_RES_WQSXGA:
+               /* 3200 */
+               hsize = WQSXGA_SIZE_H;
+               /* 2048 */
+               vsize = WQSXGA_SIZE_V;
+               break;
+       case SENSOR_RES_QUXGA:
+               /* 3200 */
+               hsize = QUXGA_SIZE_H;
+               /* 2400 */
+               vsize = QUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_WQUXGA:
+               /* 3840 */
+               hsize = WQUXGA_SIZE_H;
+               /* 2400 */
+               vsize = WQUXGA_SIZE_V;
+               break;
+       case SENSOR_RES_HXGA:
+               /* 4096 */
+               hsize = HXGA_SIZE_H;
+               /* 3072 */
+               vsize = HXGA_SIZE_V;
+               break;
+       default:
+               eprintk("resolution not supported");
+               return CI_STATUS_NOTSUPP;
+       }
+
+       return ci_isp_jpe_init_ex(hsize, vsize, compression_ratio, jpe_scale);
+}
+
+void ci_isp_jpe_set_tables(u8 compression_ratio)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       /* required because auto-increment register */
+       u32 jpe_table_data = 0;
+
+       u8 idx, size;
+       const u8 *yqtable = NULL;
+       const u8 *uvqtable = NULL;
+
+       switch (compression_ratio) {
+       case CI_ISP_JPEG_LOW_COMPRESSION:
+               yqtable = ci_isp_yq_table_low_comp1;
+               uvqtable = ci_isp_uv_qtable_low_comp1;
+               break;
+       case CI_ISP_JPEG_01_PERCENT:
+               yqtable = ci_isp_yq_table01_per_cent;
+               uvqtable = ci_isp_uv_qtable01_per_cent;
+               break;
+       case CI_ISP_JPEG_20_PERCENT:
+               yqtable = ci_isp_yq_table20_per_cent;
+               uvqtable = ci_isp_uv_qtable20_per_cent;
+               break;
+       case CI_ISP_JPEG_30_PERCENT:
+               yqtable = ci_isp_yq_table30_per_cent;
+               uvqtable = ci_isp_uv_qtable30_per_cent;
+               break;
+       case CI_ISP_JPEG_40_PERCENT:
+               yqtable = ci_isp_yq_table40_per_cent;
+               uvqtable = ci_isp_uv_qtable40_per_cent;
+               break;
+       case CI_ISP_JPEG_50_PERCENT:
+               yqtable = ci_isp_yq_table50_per_cent;
+               uvqtable = ci_isp_uv_qtable50_per_cent;
+               break;
+       case CI_ISP_JPEG_60_PERCENT:
+               yqtable = ci_isp_yq_table60_per_cent;
+               uvqtable = ci_isp_uv_qtable60_per_cent;
+               break;
+       case CI_ISP_JPEG_70_PERCENT:
+               yqtable = ci_isp_yq_table70_per_cent;
+               uvqtable = ci_isp_uv_qtable70_per_cent;
+               break;
+       case CI_ISP_JPEG_80_PERCENT:
+               yqtable = ci_isp_yq_table80_per_cent;
+               uvqtable = ci_isp_uv_qtable80_per_cent;
+               break;
+       case CI_ISP_JPEG_90_PERCENT:
+               yqtable = ci_isp_yq_table90_per_cent;
+               uvqtable = ci_isp_uv_qtable90_per_cent;
+               break;
+       case CI_ISP_JPEG_99_PERCENT:
+               yqtable = ci_isp_yq_table99_per_cent;
+               uvqtable = ci_isp_uv_qtable99_per_cent;
+               break;
+       case CI_ISP_JPEG_HIGH_COMPRESSION:
+       default:
+               /*
+                * in the case an unknown value is set,
+                * use CI_JPEG_HIGH_COMPRESSION
+                */
+               yqtable = ci_isp_yq_table75_per_cent;
+               uvqtable = ci_isp_uv_qtable75_per_cent;
+               break;
+       }
+
+       /* Y q-table 0 programming */
+
+       /* all possible assigned tables have same size */
+       size = sizeof(ci_isp_yq_table75_per_cent)/
+               sizeof(ci_isp_yq_table75_per_cent[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+                     MRV_JPE_TABLE_ID_QUANT0);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                             yqtable[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                             yqtable[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* U/V q-table 0 programming */
+
+       /* all possible assigned tables have same size */
+       size = sizeof(ci_isp_uv_qtable75_per_cent) /
+               sizeof(ci_isp_uv_qtable75_per_cent[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+                     MRV_JPE_TABLE_ID_QUANT1);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                             uvqtable[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                             uvqtable[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* Y AC-table 0 programming */
+
+       size = sizeof(ci_isp_ac_luma_table_annex_k) /
+               sizeof(ci_isp_ac_luma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+                     MRV_JPE_TABLE_ID_VLC_AC0);
+       REG_SET_SLICE(mrv_reg->jpe_tac0_len, MRV_JPE_TAC0_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                             ci_isp_ac_luma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                             ci_isp_ac_luma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* U/V AC-table 1 programming */
+
+       size = sizeof(ci_isp_ac_chroma_table_annex_k) /
+               sizeof(ci_isp_ac_chroma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+                     MRV_JPE_TABLE_ID_VLC_AC1);
+       REG_SET_SLICE(mrv_reg->jpe_tac1_len, MRV_JPE_TAC1_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                             ci_isp_ac_chroma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                             ci_isp_ac_chroma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* Y DC-table 0 programming */
+
+       size = sizeof(ci_isp_dc_luma_table_annex_k) /
+               sizeof(ci_isp_dc_luma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+                     MRV_JPE_TABLE_ID_VLC_DC0);
+       REG_SET_SLICE(mrv_reg->jpe_tdc0_len, MRV_JPE_TDC0_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                             ci_isp_dc_luma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                             ci_isp_dc_luma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+
+       /* U/V DC-table 1 programming */
+
+       size = sizeof(ci_isp_dc_chroma_table_annex_k) /
+               sizeof(ci_isp_dc_chroma_table_annex_k[0]);
+       REG_SET_SLICE(mrv_reg->jpe_table_id, MRV_JPE_TABLE_ID,
+                     MRV_JPE_TABLE_ID_VLC_DC1);
+       REG_SET_SLICE(mrv_reg->jpe_tdc1_len, MRV_JPE_TDC1_LEN, size);
+       for (idx = 0; idx < (size - 1); idx += 2) {
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_H,
+                             ci_isp_dc_chroma_table_annex_k[idx]);
+               REG_SET_SLICE(jpe_table_data, MRV_JPE_TABLE_WDATA_L,
+                             ci_isp_dc_chroma_table_annex_k[idx + 1]);
+               /* auto-increment register! */
+               REG_WRITE(mrv_reg->jpe_table_data, jpe_table_data);
+       }
+}
+
+/*
+ * selects tables to be used by encoder
+ */
+void ci_isp_jpe_select_tables(void)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       /* selects quantization table for Y */
+       REG_SET_SLICE(mrv_reg->jpe_tq_y_select, MRV_JPE_TQ0_SELECT,
+                     MRV_JPE_TQ_SELECT_TAB0);
+       /* selects quantization table for U */
+       REG_SET_SLICE(mrv_reg->jpe_tq_u_select, MRV_JPE_TQ1_SELECT,
+                     MRV_JPE_TQ_SELECT_TAB1);
+       /* selects quantization table for V */
+       REG_SET_SLICE(mrv_reg->jpe_tq_v_select, MRV_JPE_TQ2_SELECT,
+                     MRV_JPE_TQ_SELECT_TAB1);
+       /* selects Huffman DC table */
+       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
+                     MRV_JPE_DC_TABLE_SELECT_Y, 0);
+       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
+                     MRV_JPE_DC_TABLE_SELECT_U, 1);
+       REG_SET_SLICE(mrv_reg->jpe_dc_table_select,
+                     MRV_JPE_DC_TABLE_SELECT_V, 1);
+       /* selects Huffman AC table */
+       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
+                     MRV_JPE_AC_TABLE_SELECT_Y, 0);
+       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
+                     MRV_JPE_AC_TABLE_SELECT_U, 1);
+       REG_SET_SLICE(mrv_reg->jpe_ac_table_select,
+                     MRV_JPE_AC_TABLE_SELECT_V, 1);
+}
+
+/*
+ * configure JPEG encoder
+ */
+void ci_isp_jpe_set_config(u16 hsize, u16 vsize, int jpe_scale)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       /* JPEG image size */
+
+       REG_SET_SLICE(mrv_reg->jpe_enc_hsize, MRV_JPE_ENC_HSIZE, hsize);
+       REG_SET_SLICE(mrv_reg->jpe_enc_vsize, MRV_JPE_ENC_VSIZE, vsize);
+
+       if (jpe_scale) {
+               /* upscaling of BT601 color space to full range 0..255 */
+               REG_SET_SLICE(mrv_reg->jpe_y_scale_en, MRV_JPE_Y_SCALE_EN,
+                             ENABLE);
+               REG_SET_SLICE(mrv_reg->jpe_cbcr_scale_en,
+                             MRV_JPE_CBCR_SCALE_EN, ENABLE);
+       } else {
+               /* bypass scaler */
+               REG_SET_SLICE(mrv_reg->jpe_y_scale_en,
+                             MRV_JPE_Y_SCALE_EN, DISABLE);
+               REG_SET_SLICE(mrv_reg->jpe_cbcr_scale_en,
+                             MRV_JPE_CBCR_SCALE_EN, DISABLE);
+       }
+
+       /* picture format YUV 422 */
+       REG_SET_SLICE(mrv_reg->jpe_pic_format, MRV_JPE_ENC_PIC_FORMAT,
+                     MRV_JPE_ENC_PIC_FORMAT_422);
+       REG_SET_SLICE(mrv_reg->jpe_table_flush, MRV_JPE_TABLE_FLUSH, 0);
+}
+
+int ci_isp_jpe_generate_header(struct mrst_isp_device *intel, u8 header_mode)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       WARN_ON(!((header_mode == MRV_JPE_HEADER_MODE_JFIF)
+           || (header_mode == MRV_JPE_HEADER_MODE_NO)));
+
+       /* clear jpeg gen_header_done interrupt */
+       /* since we poll them later to detect command completion */
+
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_GEN_HEADER_DONE, 1);
+       REG_SET_SLICE(mrv_reg->jpe_header_mode, MRV_JPE_HEADER_MODE,
+                     header_mode);
+
+       /* start header generation */
+       REG_SET_SLICE(mrv_reg->jpe_gen_header, MRV_JPE_GEN_HEADER, ON);
+
+       return ci_isp_jpe_wait_for_header_gen_done(intel);
+}
+
+void ci_isp_jpe_prep_enc(enum ci_isp_jpe_enc_mode jpe_enc_mode)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       u32 jpe_encode = REG_READ(mrv_reg->jpe_encode);
+
+       /* clear jpeg encode_done interrupt */
+       /* since we poll them later to detect command completion */
+
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ENCODE_DONE, 1);
+       REG_SET_SLICE(jpe_encode, MRV_JPE_ENCODE, ON);
+
+       switch (jpe_enc_mode) {
+       case CI_ISP_JPE_LARGE_CONT_MODE:
+               /* motion JPEG with header generation */
+               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
+                   MRV_JPE_CONT_MODE_HEADER);
+               break;
+       case CI_ISP_JPE_SHORT_CONT_MODE:
+               /* motion JPEG only first frame with header */
+               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
+                   MRV_JPE_CONT_MODE_NEXT);
+               break;
+       default:
+               /* single shot JPEG */
+               REG_SET_SLICE(jpe_encode, MRV_JPE_CONT_MODE,
+                   MRV_JPE_CONT_MODE_STOP);
+               break;
+       }
+
+       REG_WRITE(mrv_reg->jpe_encode, jpe_encode);
+       REG_SET_SLICE(mrv_reg->jpe_init, MRV_JPE_JP_INIT, 1);
+}
+
+/*
+ * wait until JPG Header is generated (MRV_JPGINT_GEN_HEADER_DONE
+ *              interrupt occurs)
+ *              waiting for JPG Header to be generated
+ */
+int ci_isp_jpe_wait_for_header_gen_done(struct mrst_isp_device *intel)
+{
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+
+       mrst_timer_start();
+
+       while (!REG_GET_SLICE(mrv_reg->jpe_status_ris,
+                              MRV_JPE_GEN_HEADER_DONE)) {
+               if (mrst_get_micro_sec() > 2000000) {
+                       mrst_timer_stop();
+                       eprintk("timeout");
+                       return CI_STATUS_FAILURE;
+               }
+       }
+
+       mrst_timer_stop();
+
+       return CI_STATUS_SUCCESS;
+}
+
+/*
+ * wait until JPG Encoder is done  (MRV_JPGINT_ENCODE_DONE
+ * interrupt occurs) waiting for the JPG Encoder to be done
+ */
+int ci_isp_jpe_wait_for_encode_done(struct mrst_isp_device *intel)
+{
+#if 0
+       int ret = 0;
+       INIT_COMPLETION(intel->jpe_complete);
+       ret = wait_for_completion_interruptible_timeout(&intel->jpe_complete,
+                                                       100 * HZ);
+       if ((ret == 0) | (intel->irq_stat == IRQ_JPE_ERROR)) {
+               eprintk("timeout");
+               return CI_STATUS_FAILURE;
+       }
+
+       return CI_STATUS_SUCCESS;
+#endif
+       struct isp_register *mrv_reg = (struct isp_register *) MEM_MRV_REG_BASE;
+       mrst_timer_start();
+
+       while (!REG_GET_SLICE(mrv_reg->jpe_status_ris,
+                             MRV_JPE_ENCODE_DONE)) {
+               if (mrst_get_micro_sec() > 200000) {
+                       mrst_timer_stop();
+                       eprintk("timeout");
+                       return CI_STATUS_FAILURE;
+               }
+       }
+
+       mrst_timer_stop();
+
+       /* clear jpeg encode_done interrupt */
+       REG_SET_SLICE(mrv_reg->jpe_status_icr, MRV_JPE_ENCODE_DONE, 1);
+
+       return CI_STATUS_SUCCESS;
+}
--
1.6.3.2

