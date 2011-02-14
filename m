Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58186 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322Ab1BNMV6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-omap@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 08/10] omap3isp: CCDC, preview engine and resizer
Date: Mon, 14 Feb 2011 13:21:35 +0100
Message-Id: <1297686097-9804-9-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The OMAP3 ISP CCDC, preview engine and resizer entities perform image
processing and scaling.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: David Cohen <dacohen@gmail.com>
Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@gmail.com>
Signed-off-by: Tuukka Toivonen <tuukkat76@gmail.com>
Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Signed-off-by: Antti Koskipaa <akoskipa@gmail.com>
Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Signed-off-by: RaniSuneela <r-m@ti.com>
Signed-off-by: Atanas Filipov <afilipov@mm-sol.com>
Signed-off-by: Gjorgji Rosikopulos <grosikopulos@mm-sol.com>
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Nayden Kanchev <nkanchev@mm-sol.com>
Signed-off-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
Signed-off-by: Ilkka Myllyperkio <ilkka.myllyperkio@sofica.fi>
Signed-off-by: Pallavi Kulkarni <p-kulkarni@ti.com>
Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
---
 drivers/media/video/omap3-isp/cfa_coef_table.h     |   61 +
 drivers/media/video/omap3-isp/gamma_table.h        |   90 +
 drivers/media/video/omap3-isp/ispccdc.c            | 2268 ++++++++++++++++++++
 drivers/media/video/omap3-isp/ispccdc.h            |  219 ++
 drivers/media/video/omap3-isp/isppreview.c         | 2113 ++++++++++++++++++
 drivers/media/video/omap3-isp/isppreview.h         |  214 ++
 drivers/media/video/omap3-isp/ispresizer.c         | 1693 +++++++++++++++
 drivers/media/video/omap3-isp/ispresizer.h         |  147 ++
 drivers/media/video/omap3-isp/luma_enhance_table.h |   42 +
 drivers/media/video/omap3-isp/noise_filter_table.h |   30 +
 10 files changed, 6877 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/omap3-isp/cfa_coef_table.h
 create mode 100644 drivers/media/video/omap3-isp/gamma_table.h
 create mode 100644 drivers/media/video/omap3-isp/ispccdc.c
 create mode 100644 drivers/media/video/omap3-isp/ispccdc.h
 create mode 100644 drivers/media/video/omap3-isp/isppreview.c
 create mode 100644 drivers/media/video/omap3-isp/isppreview.h
 create mode 100644 drivers/media/video/omap3-isp/ispresizer.c
 create mode 100644 drivers/media/video/omap3-isp/ispresizer.h
 create mode 100644 drivers/media/video/omap3-isp/luma_enhance_table.h
 create mode 100644 drivers/media/video/omap3-isp/noise_filter_table.h

diff --git a/drivers/media/video/omap3-isp/cfa_coef_table.h b/drivers/media/video/omap3-isp/cfa_coef_table.h
new file mode 100644
index 0000000..c60df0e
--- /dev/null
+++ b/drivers/media/video/omap3-isp/cfa_coef_table.h
@@ -0,0 +1,61 @@
+/*
+ * cfa_coef_table.h
+ *
+ * TI OMAP3 ISP - CFA coefficients table
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+244,   0, 247,   0,  12,  27,  36, 247, 250,   0,  27,   0,   4, 250,  12, 244,
+248,   0,   0,   0,   0,  40,   0,   0, 244,  12, 250,   4,   0,  27,   0, 250,
+247,  36,  27,  12,   0, 247,   0, 244,   0,   0,  40,   0,   0,   0,   0, 248,
+244,   0, 247,   0,  12,  27,  36, 247, 250,   0,  27,   0,   4, 250,  12, 244,
+248,   0,   0,   0,   0,  40,   0,   0, 244,  12, 250,   4,   0,  27,   0, 250,
+247,  36,  27,  12,   0, 247,   0, 244,   0,   0,  40,   0,   0,   0,   0, 248,
+244,   0, 247,   0,  12,  27,  36, 247, 250,   0,  27,   0,   4, 250,  12, 244,
+248,   0,   0,   0,   0,  40,   0,   0, 244,  12, 250,   4,   0,  27,   0, 250,
+247,  36,  27,  12,   0, 247,   0, 244,   0,   0,  40,   0,   0,   0,   0, 248,
+  0, 247,   0, 244, 247,  36,  27,  12,   0,  27,   0, 250, 244,  12, 250,   4,
+  0,   0,   0, 248,   0,   0,  40,   0,   4, 250,  12, 244, 250,   0,  27,   0,
+ 12,  27,  36, 247, 244,   0, 247,   0,   0,  40,   0,   0, 248,   0,   0,   0,
+  0, 247,   0, 244, 247,  36,  27,  12,   0,  27,   0, 250, 244,  12, 250,   4,
+  0,   0,   0, 248,   0,   0,  40,   0,   4, 250,  12, 244, 250,   0,  27,   0,
+ 12,  27,  36, 247, 244,   0, 247,   0,   0,  40,   0,   0, 248,   0,   0,   0,
+  0, 247,   0, 244, 247,  36,  27,  12,   0,  27,   0, 250, 244,  12, 250,   4,
+  0,   0,   0, 248,   0,   0,  40,   0,   4, 250,  12, 244, 250,   0,  27,   0,
+ 12,  27,  36, 247, 244,   0, 247,   0,   0,  40,   0,   0, 248,   0,   0,   0,
+  4, 250,  12, 244, 250,   0,  27,   0,  12,  27,  36, 247, 244,   0, 247,   0,
+  0,   0,   0, 248,   0,   0,  40,   0,   0, 247,   0, 244, 247,  36,  27,  12,
+  0,  27,   0, 250, 244,  12, 250,   4,   0,  40,   0,   0, 248,   0,   0,   0,
+  4, 250,  12, 244, 250,   0,  27,   0,  12,  27,  36, 247, 244,   0, 247,   0,
+  0,   0,   0, 248,   0,   0,  40,   0,   0, 247,   0, 244, 247,  36,  27,  12,
+  0,  27,   0, 250, 244,  12, 250,   4,   0,  40,   0,   0, 248,   0,   0,   0,
+  4, 250,  12, 244, 250,   0,  27,   0,  12,  27,  36, 247, 244,   0, 247,   0,
+  0,   0,   0, 248,   0,   0,  40,   0,   0, 247,   0, 244, 247,  36,  27,  12,
+  0,  27,   0, 250, 244,  12, 250,   4,   0,  40,   0,   0, 248,   0,   0,   0,
+244,  12, 250,   4,   0,  27,   0, 250, 247,  36,  27,  12,   0, 247,   0, 244,
+248,   0,   0,   0,   0,  40,   0,   0, 244,   0, 247,   0,  12,  27,  36, 247,
+250,   0,  27,   0,   4, 250,  12, 244,   0,   0,  40,   0,   0,   0,   0, 248,
+244,  12, 250,   4,   0,  27,   0, 250, 247,  36,  27,  12,   0, 247,   0, 244,
+248,   0,   0,   0,   0,  40,   0,   0, 244,   0, 247,   0,  12,  27,  36, 247,
+250,   0,  27,   0,   4, 250,  12, 244,   0,   0,  40,   0,   0,   0,   0, 248,
+244,  12, 250,   4,   0,  27,   0, 250, 247,  36,  27,  12,   0, 247,   0, 244,
+248,   0,   0,   0,   0,  40,   0,   0, 244,   0, 247,   0,  12,  27,  36, 247,
+250,   0,  27,   0,   4, 250,  12, 244,   0,   0,  40,   0,   0,   0,   0, 248
diff --git a/drivers/media/video/omap3-isp/gamma_table.h b/drivers/media/video/omap3-isp/gamma_table.h
new file mode 100644
index 0000000..78deebf
--- /dev/null
+++ b/drivers/media/video/omap3-isp/gamma_table.h
@@ -0,0 +1,90 @@
+/*
+ * gamma_table.h
+ *
+ * TI OMAP3 ISP - Default gamma table for all components
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+  0,   0,   1,   2,   3,   3,   4,   5,   6,   8,  10,  12,  14,  16,  18,  20,
+ 22,  23,  25,  26,  28,  29,  31,  32,  34,  35,  36,  37,  39,  40,  41,  42,
+ 43,  44,  45,  46,  47,  48,  49,  50,  51,  52,  52,  53,  54,  55,  56,  57,
+ 58,  59,  60,  61,  62,  63,  63,  64,  65,  66,  66,  67,  68,  69,  69,  70,
+ 71,  72,  72,  73,  74,  75,  75,  76,  77,  78,  78,  79,  80,  81,  81,  82,
+ 83,  84,  84,  85,  86,  87,  88,  88,  89,  90,  91,  91,  92,  93,  94,  94,
+ 95,  96,  97,  97,  98,  98,  99,  99, 100, 100, 101, 101, 102, 103, 104, 104,
+105, 106, 107, 108, 108, 109, 110, 111, 111, 112, 113, 114, 114, 115, 116, 117,
+117, 118, 119, 119, 120, 120, 121, 121, 122, 122, 123, 123, 124, 124, 125, 125,
+126, 126, 127, 127, 128, 128, 129, 129, 130, 130, 131, 131, 132, 132, 133, 133,
+134, 134, 135, 135, 136, 136, 137, 137, 138, 138, 139, 139, 140, 140, 141, 141,
+142, 142, 143, 143, 144, 144, 145, 145, 146, 146, 147, 147, 148, 148, 149, 149,
+150, 150, 151, 151, 152, 152, 153, 153, 153, 153, 154, 154, 154, 154, 155, 155,
+156, 156, 157, 157, 158, 158, 158, 159, 159, 159, 160, 160, 160, 161, 161, 162,
+162, 163, 163, 164, 164, 164, 164, 165, 165, 165, 165, 166, 166, 167, 167, 168,
+168, 169, 169, 170, 170, 170, 170, 171, 171, 171, 171, 172, 172, 173, 173, 174,
+174, 175, 175, 176, 176, 176, 176, 177, 177, 177, 177, 178, 178, 178, 178, 179,
+179, 179, 179, 180, 180, 180, 180, 181, 181, 181, 181, 182, 182, 182, 182, 183,
+183, 183, 183, 184, 184, 184, 184, 185, 185, 185, 185, 186, 186, 186, 186, 187,
+187, 187, 187, 188, 188, 188, 188, 189, 189, 189, 189, 190, 190, 190, 190, 191,
+191, 191, 191, 192, 192, 192, 192, 193, 193, 193, 193, 194, 194, 194, 194, 195,
+195, 195, 195, 196, 196, 196, 196, 197, 197, 197, 197, 198, 198, 198, 198, 199,
+199, 199, 199, 200, 200, 200, 200, 201, 201, 201, 201, 202, 202, 202, 203, 203,
+203, 203, 204, 204, 204, 204, 205, 205, 205, 205, 206, 206, 206, 206, 207, 207,
+207, 207, 208, 208, 208, 208, 209, 209, 209, 209, 210, 210, 210, 210, 210, 210,
+210, 210, 210, 210, 210, 210, 211, 211, 211, 211, 211, 211, 211, 211, 211, 211,
+211, 212, 212, 212, 212, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213, 213,
+213, 214, 214, 214, 214, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215, 215,
+216, 216, 216, 216, 217, 217, 217, 217, 218, 218, 218, 218, 219, 219, 219, 219,
+219, 219, 219, 219, 219, 219, 219, 219, 220, 220, 220, 220, 221, 221, 221, 221,
+221, 221, 221, 221, 221, 221, 221, 222, 222, 222, 222, 223, 223, 223, 223, 223,
+223, 223, 223, 223, 223, 223, 223, 224, 224, 224, 224, 225, 225, 225, 225, 225,
+225, 225, 225, 225, 225, 225, 225, 225, 225, 225, 225, 225, 225, 225, 226, 226,
+226, 226, 227, 227, 227, 227, 227, 227, 227, 227, 227, 227, 227, 227, 228, 228,
+228, 229, 229, 229, 229, 229, 229, 229, 229, 229, 229, 229, 229, 230, 230, 230,
+230, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 231, 232, 232, 232,
+232, 232, 232, 232, 232, 232, 232, 232, 232, 232, 232, 232, 232, 232, 232, 232,
+233, 233, 233, 233, 234, 234, 234, 234, 234, 234, 234, 234, 234, 234, 234, 235,
+235, 235, 235, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236, 236,
+236, 236, 236, 236, 236, 236, 237, 237, 237, 237, 238, 238, 238, 238, 238, 238,
+238, 238, 238, 238, 238, 238, 238, 238, 238, 238, 238, 238, 238, 238, 238, 238,
+238, 238, 238, 238, 238, 239, 239, 239, 239, 240, 240, 240, 240, 240, 240, 240,
+240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240, 240,
+240, 240, 240, 240, 241, 241, 241, 241, 242, 242, 242, 242, 242, 242, 242, 242,
+242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242, 242,
+242, 242, 243, 243, 243, 243, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244,
+244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244, 244,
+244, 245, 245, 245, 245, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246,
+246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246, 246,
+246, 246, 246, 246, 246, 246, 246, 247, 247, 247, 247, 248, 248, 248, 248, 248,
+248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248, 248,
+248, 248, 248, 248, 248, 248, 249, 249, 249, 249, 250, 250, 250, 250, 250, 250,
+250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250,
+250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250,
+250, 250, 250, 250, 251, 251, 251, 251, 252, 252, 252, 252, 252, 252, 252, 252,
+252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252,
+252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252,
+252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252, 252,
+252, 252, 252, 252, 252, 252, 252, 252, 253, 253, 253, 253, 253, 253, 253, 253,
+253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253,
+253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253,
+253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253, 253,
+253, 254, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
+255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
diff --git a/drivers/media/video/omap3-isp/ispccdc.c b/drivers/media/video/omap3-isp/ispccdc.c
new file mode 100644
index 0000000..5ff9d14
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispccdc.c
@@ -0,0 +1,2268 @@
+/*
+ * ispccdc.c
+ *
+ * TI OMAP3 ISP - CCDC module
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <media/v4l2-event.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispccdc.h"
+
+static struct v4l2_mbus_framefmt *
+__ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which);
+
+static const unsigned int ccdc_fmts[] = {
+	V4L2_MBUS_FMT_Y8_1X8,
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SRGGB10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_SGBRG10_1X10,
+	V4L2_MBUS_FMT_SGRBG12_1X12,
+	V4L2_MBUS_FMT_SRGGB12_1X12,
+	V4L2_MBUS_FMT_SBGGR12_1X12,
+	V4L2_MBUS_FMT_SGBRG12_1X12,
+};
+
+/*
+ * ccdc_print_status - Print current CCDC Module register values.
+ * @ccdc: Pointer to ISP CCDC device.
+ *
+ * Also prints other debug information stored in the CCDC module.
+ */
+#define CCDC_PRINT_REGISTER(isp, name)\
+	dev_dbg(isp->dev, "###CCDC " #name "=0x%08x\n", \
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_##name))
+
+static void ccdc_print_status(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	dev_dbg(isp->dev, "-------------CCDC Register dump-------------\n");
+
+	CCDC_PRINT_REGISTER(isp, PCR);
+	CCDC_PRINT_REGISTER(isp, SYN_MODE);
+	CCDC_PRINT_REGISTER(isp, HD_VD_WID);
+	CCDC_PRINT_REGISTER(isp, PIX_LINES);
+	CCDC_PRINT_REGISTER(isp, HORZ_INFO);
+	CCDC_PRINT_REGISTER(isp, VERT_START);
+	CCDC_PRINT_REGISTER(isp, VERT_LINES);
+	CCDC_PRINT_REGISTER(isp, CULLING);
+	CCDC_PRINT_REGISTER(isp, HSIZE_OFF);
+	CCDC_PRINT_REGISTER(isp, SDOFST);
+	CCDC_PRINT_REGISTER(isp, SDR_ADDR);
+	CCDC_PRINT_REGISTER(isp, CLAMP);
+	CCDC_PRINT_REGISTER(isp, DCSUB);
+	CCDC_PRINT_REGISTER(isp, COLPTN);
+	CCDC_PRINT_REGISTER(isp, BLKCMP);
+	CCDC_PRINT_REGISTER(isp, FPC);
+	CCDC_PRINT_REGISTER(isp, FPC_ADDR);
+	CCDC_PRINT_REGISTER(isp, VDINT);
+	CCDC_PRINT_REGISTER(isp, ALAW);
+	CCDC_PRINT_REGISTER(isp, REC656IF);
+	CCDC_PRINT_REGISTER(isp, CFG);
+	CCDC_PRINT_REGISTER(isp, FMTCFG);
+	CCDC_PRINT_REGISTER(isp, FMT_HORZ);
+	CCDC_PRINT_REGISTER(isp, FMT_VERT);
+	CCDC_PRINT_REGISTER(isp, PRGEVEN0);
+	CCDC_PRINT_REGISTER(isp, PRGEVEN1);
+	CCDC_PRINT_REGISTER(isp, PRGODD0);
+	CCDC_PRINT_REGISTER(isp, PRGODD1);
+	CCDC_PRINT_REGISTER(isp, VP_OUT);
+	CCDC_PRINT_REGISTER(isp, LSC_CONFIG);
+	CCDC_PRINT_REGISTER(isp, LSC_INITIAL);
+	CCDC_PRINT_REGISTER(isp, LSC_TABLE_BASE);
+	CCDC_PRINT_REGISTER(isp, LSC_TABLE_OFFSET);
+
+	dev_dbg(isp->dev, "--------------------------------------------\n");
+}
+
+/*
+ * omap3isp_ccdc_busy - Get busy state of the CCDC.
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+int omap3isp_ccdc_busy(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	return isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PCR) &
+		ISPCCDC_PCR_BUSY;
+}
+
+/* -----------------------------------------------------------------------------
+ * Lens Shading Compensation
+ */
+
+/*
+ * ccdc_lsc_validate_config - Check that LSC configuration is valid.
+ * @ccdc: Pointer to ISP CCDC device.
+ * @lsc_cfg: the LSC configuration to check.
+ *
+ * Returns 0 if the LSC configuration is valid, or -EINVAL if invalid.
+ */
+static int ccdc_lsc_validate_config(struct isp_ccdc_device *ccdc,
+				    struct omap3isp_ccdc_lsc_config *lsc_cfg)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	struct v4l2_mbus_framefmt *format;
+	unsigned int paxel_width, paxel_height;
+	unsigned int paxel_shift_x, paxel_shift_y;
+	unsigned int min_width, min_height, min_size;
+	unsigned int input_width, input_height;
+
+	paxel_shift_x = lsc_cfg->gain_mode_m;
+	paxel_shift_y = lsc_cfg->gain_mode_n;
+
+	if ((paxel_shift_x < 2) || (paxel_shift_x > 6) ||
+	    (paxel_shift_y < 2) || (paxel_shift_y > 6)) {
+		dev_dbg(isp->dev, "CCDC: LSC: Invalid paxel size\n");
+		return -EINVAL;
+	}
+
+	if (lsc_cfg->offset & 3) {
+		dev_dbg(isp->dev, "CCDC: LSC: Offset must be a multiple of "
+			"4\n");
+		return -EINVAL;
+	}
+
+	if ((lsc_cfg->initial_x & 1) || (lsc_cfg->initial_y & 1)) {
+		dev_dbg(isp->dev, "CCDC: LSC: initial_x and y must be even\n");
+		return -EINVAL;
+	}
+
+	format = __ccdc_get_format(ccdc, NULL, CCDC_PAD_SINK,
+				   V4L2_SUBDEV_FORMAT_ACTIVE);
+	input_width = format->width;
+	input_height = format->height;
+
+	/* Calculate minimum bytesize for validation */
+	paxel_width = 1 << paxel_shift_x;
+	min_width = ((input_width + lsc_cfg->initial_x + paxel_width - 1)
+		     >> paxel_shift_x) + 1;
+
+	paxel_height = 1 << paxel_shift_y;
+	min_height = ((input_height + lsc_cfg->initial_y + paxel_height - 1)
+		     >> paxel_shift_y) + 1;
+
+	min_size = 4 * min_width * min_height;
+	if (min_size > lsc_cfg->size) {
+		dev_dbg(isp->dev, "CCDC: LSC: too small table\n");
+		return -EINVAL;
+	}
+	if (lsc_cfg->offset < (min_width * 4)) {
+		dev_dbg(isp->dev, "CCDC: LSC: Offset is too small\n");
+		return -EINVAL;
+	}
+	if ((lsc_cfg->size / lsc_cfg->offset) < min_height) {
+		dev_dbg(isp->dev, "CCDC: LSC: Wrong size/offset combination\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/*
+ * ccdc_lsc_program_table - Program Lens Shading Compensation table address.
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_lsc_program_table(struct isp_ccdc_device *ccdc, u32 addr)
+{
+	isp_reg_writel(to_isp_device(ccdc), addr,
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_TABLE_BASE);
+}
+
+/*
+ * ccdc_lsc_setup_regs - Configures the lens shading compensation module
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_lsc_setup_regs(struct isp_ccdc_device *ccdc,
+				struct omap3isp_ccdc_lsc_config *cfg)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	int reg;
+
+	isp_reg_writel(isp, cfg->offset, OMAP3_ISP_IOMEM_CCDC,
+		       ISPCCDC_LSC_TABLE_OFFSET);
+
+	reg = 0;
+	reg |= cfg->gain_mode_n << ISPCCDC_LSC_GAIN_MODE_N_SHIFT;
+	reg |= cfg->gain_mode_m << ISPCCDC_LSC_GAIN_MODE_M_SHIFT;
+	reg |= cfg->gain_format << ISPCCDC_LSC_GAIN_FORMAT_SHIFT;
+	isp_reg_writel(isp, reg, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG);
+
+	reg = 0;
+	reg &= ~ISPCCDC_LSC_INITIAL_X_MASK;
+	reg |= cfg->initial_x << ISPCCDC_LSC_INITIAL_X_SHIFT;
+	reg &= ~ISPCCDC_LSC_INITIAL_Y_MASK;
+	reg |= cfg->initial_y << ISPCCDC_LSC_INITIAL_Y_SHIFT;
+	isp_reg_writel(isp, reg, OMAP3_ISP_IOMEM_CCDC,
+		       ISPCCDC_LSC_INITIAL);
+}
+
+static int ccdc_lsc_wait_prefetch(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	unsigned int wait;
+
+	isp_reg_writel(isp, IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ,
+		       OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+
+	/* timeout 1 ms */
+	for (wait = 0; wait < 1000; wait++) {
+		if (isp_reg_readl(isp, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS) &
+				  IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ) {
+			isp_reg_writel(isp, IRQ0STATUS_CCDC_LSC_PREF_COMP_IRQ,
+				       OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0STATUS);
+			return 0;
+		}
+
+		rmb();
+		udelay(1);
+	}
+
+	return -ETIMEDOUT;
+}
+
+/*
+ * __ccdc_lsc_enable - Enables/Disables the Lens Shading Compensation module.
+ * @ccdc: Pointer to ISP CCDC device.
+ * @enable: 0 Disables LSC, 1 Enables LSC.
+ */
+static int __ccdc_lsc_enable(struct isp_ccdc_device *ccdc, int enable)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	const struct v4l2_mbus_framefmt *format =
+		__ccdc_get_format(ccdc, NULL, CCDC_PAD_SINK,
+				  V4L2_SUBDEV_FORMAT_ACTIVE);
+
+	if ((format->code != V4L2_MBUS_FMT_SGRBG10_1X10) &&
+	    (format->code != V4L2_MBUS_FMT_SRGGB10_1X10) &&
+	    (format->code != V4L2_MBUS_FMT_SBGGR10_1X10) &&
+	    (format->code != V4L2_MBUS_FMT_SGBRG10_1X10))
+		return -EINVAL;
+
+	if (enable)
+		omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CCDC_LSC_READ);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG,
+			ISPCCDC_LSC_ENABLE, enable ? ISPCCDC_LSC_ENABLE : 0);
+
+	if (enable) {
+		if (ccdc_lsc_wait_prefetch(ccdc) < 0) {
+			isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC,
+				    ISPCCDC_LSC_CONFIG, ISPCCDC_LSC_ENABLE);
+			ccdc->lsc.state = LSC_STATE_STOPPED;
+			dev_warn(to_device(ccdc), "LSC prefecth timeout\n");
+			return -ETIMEDOUT;
+		}
+		ccdc->lsc.state = LSC_STATE_RUNNING;
+	} else {
+		ccdc->lsc.state = LSC_STATE_STOPPING;
+	}
+
+	return 0;
+}
+
+static int ccdc_lsc_busy(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	return isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG) &
+			     ISPCCDC_LSC_BUSY;
+}
+
+/* __ccdc_lsc_configure - Apply a new configuration to the LSC engine
+ * @ccdc: Pointer to ISP CCDC device
+ * @req: New configuration request
+ *
+ * context: in_interrupt()
+ */
+static int __ccdc_lsc_configure(struct isp_ccdc_device *ccdc,
+				struct ispccdc_lsc_config_req *req)
+{
+	if (!req->enable)
+		return -EINVAL;
+
+	if (ccdc_lsc_validate_config(ccdc, &req->config) < 0) {
+		dev_dbg(to_device(ccdc), "Discard LSC configuration\n");
+		return -EINVAL;
+	}
+
+	if (ccdc_lsc_busy(ccdc))
+		return -EBUSY;
+
+	ccdc_lsc_setup_regs(ccdc, &req->config);
+	ccdc_lsc_program_table(ccdc, req->table);
+	return 0;
+}
+
+/*
+ * ccdc_lsc_error_handler - Handle LSC prefetch error scenario.
+ * @ccdc: Pointer to ISP CCDC device.
+ *
+ * Disables LSC, and defers enablement to shadow registers update time.
+ */
+static void ccdc_lsc_error_handler(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	/*
+	 * From OMAP3 TRM: When this event is pending, the module
+	 * goes into transparent mode (output =input). Normal
+	 * operation can be resumed at the start of the next frame
+	 * after:
+	 *  1) Clearing this event
+	 *  2) Disabling the LSC module
+	 *  3) Enabling it
+	 */
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_LSC_CONFIG,
+		    ISPCCDC_LSC_ENABLE);
+	ccdc->lsc.state = LSC_STATE_STOPPED;
+}
+
+static void ccdc_lsc_free_request(struct isp_ccdc_device *ccdc,
+				  struct ispccdc_lsc_config_req *req)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	if (req == NULL)
+		return;
+
+	if (req->iovm)
+		dma_unmap_sg(isp->dev, req->iovm->sgt->sgl,
+			     req->iovm->sgt->nents, DMA_TO_DEVICE);
+	if (req->table)
+		iommu_vfree(isp->iommu, req->table);
+	kfree(req);
+}
+
+static void ccdc_lsc_free_queue(struct isp_ccdc_device *ccdc,
+				struct list_head *queue)
+{
+	struct ispccdc_lsc_config_req *req, *n;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+	list_for_each_entry_safe(req, n, queue, list) {
+		list_del(&req->list);
+		spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+		ccdc_lsc_free_request(ccdc, req);
+		spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+	}
+	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+}
+
+static void ccdc_lsc_free_table_work(struct work_struct *work)
+{
+	struct isp_ccdc_device *ccdc;
+	struct ispccdc_lsc *lsc;
+
+	lsc = container_of(work, struct ispccdc_lsc, table_work);
+	ccdc = container_of(lsc, struct isp_ccdc_device, lsc);
+
+	ccdc_lsc_free_queue(ccdc, &lsc->free_queue);
+}
+
+/*
+ * ccdc_lsc_config - Configure the LSC module from a userspace request
+ *
+ * Store the request LSC configuration in the LSC engine request pointer. The
+ * configuration will be applied to the hardware when the CCDC will be enabled,
+ * or at the next LSC interrupt if the CCDC is already running.
+ */
+static int ccdc_lsc_config(struct isp_ccdc_device *ccdc,
+			   struct omap3isp_ccdc_update_config *config)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	struct ispccdc_lsc_config_req *req;
+	unsigned long flags;
+	void *table;
+	u16 update;
+	int ret;
+
+	update = config->update &
+		 (OMAP3ISP_CCDC_CONFIG_LSC | OMAP3ISP_CCDC_TBL_LSC);
+	if (!update)
+		return 0;
+
+	if (update != (OMAP3ISP_CCDC_CONFIG_LSC | OMAP3ISP_CCDC_TBL_LSC)) {
+		dev_dbg(to_device(ccdc), "%s: Both LSC configuration and table "
+			"need to be supplied\n", __func__);
+		return -EINVAL;
+	}
+
+	req = kzalloc(sizeof(*req), GFP_KERNEL);
+	if (req == NULL)
+		return -ENOMEM;
+
+	if (config->flag & OMAP3ISP_CCDC_CONFIG_LSC) {
+		if (copy_from_user(&req->config, config->lsc_cfg,
+				   sizeof(req->config))) {
+			ret = -EFAULT;
+			goto done;
+		}
+
+		req->enable = 1;
+
+		req->table = iommu_vmalloc(isp->iommu, 0, req->config.size,
+					   IOMMU_FLAG);
+		if (IS_ERR_VALUE(req->table)) {
+			req->table = 0;
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		req->iovm = find_iovm_area(isp->iommu, req->table);
+		if (req->iovm == NULL) {
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		if (!dma_map_sg(isp->dev, req->iovm->sgt->sgl,
+				req->iovm->sgt->nents, DMA_TO_DEVICE)) {
+			ret = -ENOMEM;
+			req->iovm = NULL;
+			goto done;
+		}
+
+		dma_sync_sg_for_cpu(isp->dev, req->iovm->sgt->sgl,
+				    req->iovm->sgt->nents, DMA_TO_DEVICE);
+
+		table = da_to_va(isp->iommu, req->table);
+		if (copy_from_user(table, config->lsc, req->config.size)) {
+			ret = -EFAULT;
+			goto done;
+		}
+
+		dma_sync_sg_for_device(isp->dev, req->iovm->sgt->sgl,
+				       req->iovm->sgt->nents, DMA_TO_DEVICE);
+	}
+
+	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+	if (ccdc->lsc.request) {
+		list_add_tail(&ccdc->lsc.request->list, &ccdc->lsc.free_queue);
+		schedule_work(&ccdc->lsc.table_work);
+	}
+	ccdc->lsc.request = req;
+	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+
+	ret = 0;
+
+done:
+	if (ret < 0)
+		ccdc_lsc_free_request(ccdc, req);
+
+	return ret;
+}
+
+static inline int ccdc_lsc_is_configured(struct isp_ccdc_device *ccdc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+	if (ccdc->lsc.active) {
+		spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+		return 1;
+	}
+	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+	return 0;
+}
+
+static int ccdc_lsc_enable(struct isp_ccdc_device *ccdc)
+{
+	struct ispccdc_lsc *lsc = &ccdc->lsc;
+
+	if (lsc->state != LSC_STATE_STOPPED)
+		return -EINVAL;
+
+	if (lsc->active) {
+		list_add_tail(&lsc->active->list, &lsc->free_queue);
+		lsc->active = NULL;
+	}
+
+	if (__ccdc_lsc_configure(ccdc, lsc->request) < 0) {
+		omap3isp_sbl_disable(to_isp_device(ccdc),
+				OMAP3_ISP_SBL_CCDC_LSC_READ);
+		list_add_tail(&lsc->request->list, &lsc->free_queue);
+		lsc->request = NULL;
+		goto done;
+	}
+
+	lsc->active = lsc->request;
+	lsc->request = NULL;
+	__ccdc_lsc_enable(ccdc, 1);
+
+done:
+	if (!list_empty(&lsc->free_queue))
+		schedule_work(&lsc->table_work);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Parameters configuration
+ */
+
+/*
+ * ccdc_configure_clamp - Configure optical-black or digital clamping
+ * @ccdc: Pointer to ISP CCDC device.
+ *
+ * The CCDC performs either optical-black or digital clamp. Configure and enable
+ * the selected clamp method.
+ */
+static void ccdc_configure_clamp(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	u32 clamp;
+
+	if (ccdc->obclamp) {
+		clamp  = ccdc->clamp.obgain << ISPCCDC_CLAMP_OBGAIN_SHIFT;
+		clamp |= ccdc->clamp.oblen << ISPCCDC_CLAMP_OBSLEN_SHIFT;
+		clamp |= ccdc->clamp.oblines << ISPCCDC_CLAMP_OBSLN_SHIFT;
+		clamp |= ccdc->clamp.obstpixel << ISPCCDC_CLAMP_OBST_SHIFT;
+		isp_reg_writel(isp, clamp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CLAMP);
+	} else {
+		isp_reg_writel(isp, ccdc->clamp.dcsubval,
+			       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_DCSUB);
+	}
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CLAMP,
+			ISPCCDC_CLAMP_CLAMPEN,
+			ccdc->obclamp ? ISPCCDC_CLAMP_CLAMPEN : 0);
+}
+
+/*
+ * ccdc_configure_fpc - Configure Faulty Pixel Correction
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_configure_fpc(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC, ISPCCDC_FPC_FPCEN);
+
+	if (!ccdc->fpc_en)
+		return;
+
+	isp_reg_writel(isp, ccdc->fpc.fpcaddr, OMAP3_ISP_IOMEM_CCDC,
+		       ISPCCDC_FPC_ADDR);
+	/* The FPNUM field must be set before enabling FPC. */
+	isp_reg_writel(isp, (ccdc->fpc.fpnum << ISPCCDC_FPC_FPNUM_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC);
+	isp_reg_writel(isp, (ccdc->fpc.fpnum << ISPCCDC_FPC_FPNUM_SHIFT) |
+		       ISPCCDC_FPC_FPCEN, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FPC);
+}
+
+/*
+ * ccdc_configure_black_comp - Configure Black Level Compensation.
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_configure_black_comp(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	u32 blcomp;
+
+	blcomp  = ccdc->blcomp.b_mg << ISPCCDC_BLKCMP_B_MG_SHIFT;
+	blcomp |= ccdc->blcomp.gb_g << ISPCCDC_BLKCMP_GB_G_SHIFT;
+	blcomp |= ccdc->blcomp.gr_cy << ISPCCDC_BLKCMP_GR_CY_SHIFT;
+	blcomp |= ccdc->blcomp.r_ye << ISPCCDC_BLKCMP_R_YE_SHIFT;
+
+	isp_reg_writel(isp, blcomp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_BLKCMP);
+}
+
+/*
+ * ccdc_configure_lpf - Configure Low-Pass Filter (LPF).
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_configure_lpf(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE,
+			ISPCCDC_SYN_MODE_LPF,
+			ccdc->lpf ? ISPCCDC_SYN_MODE_LPF : 0);
+}
+
+/*
+ * ccdc_configure_alaw - Configure A-law compression.
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_configure_alaw(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	u32 alaw = 0;
+
+	switch (ccdc->syncif.datsz) {
+	case 8:
+		return;
+
+	case 10:
+		alaw = ISPCCDC_ALAW_GWDI_9_0;
+		break;
+	case 11:
+		alaw = ISPCCDC_ALAW_GWDI_10_1;
+		break;
+	case 12:
+		alaw = ISPCCDC_ALAW_GWDI_11_2;
+		break;
+	case 13:
+		alaw = ISPCCDC_ALAW_GWDI_12_3;
+		break;
+	}
+
+	if (ccdc->alaw)
+		alaw |= ISPCCDC_ALAW_CCDTBL;
+
+	isp_reg_writel(isp, alaw, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_ALAW);
+}
+
+/*
+ * ccdc_config_imgattr - Configure sensor image specific attributes.
+ * @ccdc: Pointer to ISP CCDC device.
+ * @colptn: Color pattern of the sensor.
+ */
+static void ccdc_config_imgattr(struct isp_ccdc_device *ccdc, u32 colptn)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	isp_reg_writel(isp, colptn, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_COLPTN);
+}
+
+/*
+ * ccdc_config - Set CCDC configuration from userspace
+ * @ccdc: Pointer to ISP CCDC device.
+ * @userspace_add: Structure containing CCDC configuration sent from userspace.
+ *
+ * Returns 0 if successful, -EINVAL if the pointer to the configuration
+ * structure is null, or the copy_from_user function fails to copy user space
+ * memory to kernel space memory.
+ */
+static int ccdc_config(struct isp_ccdc_device *ccdc,
+		       struct omap3isp_ccdc_update_config *ccdc_struct)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccdc->lock, flags);
+	ccdc->shadow_update = 1;
+	spin_unlock_irqrestore(&ccdc->lock, flags);
+
+	if (OMAP3ISP_CCDC_ALAW & ccdc_struct->update) {
+		ccdc->alaw = !!(OMAP3ISP_CCDC_ALAW & ccdc_struct->flag);
+		ccdc->update |= OMAP3ISP_CCDC_ALAW;
+	}
+
+	if (OMAP3ISP_CCDC_LPF & ccdc_struct->update) {
+		ccdc->lpf = !!(OMAP3ISP_CCDC_LPF & ccdc_struct->flag);
+		ccdc->update |= OMAP3ISP_CCDC_LPF;
+	}
+
+	if (OMAP3ISP_CCDC_BLCLAMP & ccdc_struct->update) {
+		if (copy_from_user(&ccdc->clamp, ccdc_struct->bclamp,
+				   sizeof(ccdc->clamp))) {
+			ccdc->shadow_update = 0;
+			return -EFAULT;
+		}
+
+		ccdc->obclamp = !!(OMAP3ISP_CCDC_BLCLAMP & ccdc_struct->flag);
+		ccdc->update |= OMAP3ISP_CCDC_BLCLAMP;
+	}
+
+	if (OMAP3ISP_CCDC_BCOMP & ccdc_struct->update) {
+		if (copy_from_user(&ccdc->blcomp, ccdc_struct->blcomp,
+				   sizeof(ccdc->blcomp))) {
+			ccdc->shadow_update = 0;
+			return -EFAULT;
+		}
+
+		ccdc->update |= OMAP3ISP_CCDC_BCOMP;
+	}
+
+	ccdc->shadow_update = 0;
+
+	if (OMAP3ISP_CCDC_FPC & ccdc_struct->update) {
+		u32 table_old = 0;
+		u32 table_new;
+		u32 size;
+
+		if (ccdc->state != ISP_PIPELINE_STREAM_STOPPED)
+			return -EBUSY;
+
+		ccdc->fpc_en = !!(OMAP3ISP_CCDC_FPC & ccdc_struct->flag);
+
+		if (ccdc->fpc_en) {
+			if (copy_from_user(&ccdc->fpc, ccdc_struct->fpc,
+					   sizeof(ccdc->fpc)))
+				return -EFAULT;
+
+			/*
+			 * table_new must be 64-bytes aligned, but it's
+			 * already done by iommu_vmalloc().
+			 */
+			size = ccdc->fpc.fpnum * 4;
+			table_new = iommu_vmalloc(isp->iommu, 0, size,
+						  IOMMU_FLAG);
+			if (IS_ERR_VALUE(table_new))
+				return -ENOMEM;
+
+			if (copy_from_user(da_to_va(isp->iommu, table_new),
+					   (__force void __user *)
+					   ccdc->fpc.fpcaddr, size)) {
+				iommu_vfree(isp->iommu, table_new);
+				return -EFAULT;
+			}
+
+			table_old = ccdc->fpc.fpcaddr;
+			ccdc->fpc.fpcaddr = table_new;
+		}
+
+		ccdc_configure_fpc(ccdc);
+		if (table_old != 0)
+			iommu_vfree(isp->iommu, table_old);
+	}
+
+	return ccdc_lsc_config(ccdc, ccdc_struct);
+}
+
+static void ccdc_apply_controls(struct isp_ccdc_device *ccdc)
+{
+	if (ccdc->update & OMAP3ISP_CCDC_ALAW) {
+		ccdc_configure_alaw(ccdc);
+		ccdc->update &= ~OMAP3ISP_CCDC_ALAW;
+	}
+
+	if (ccdc->update & OMAP3ISP_CCDC_LPF) {
+		ccdc_configure_lpf(ccdc);
+		ccdc->update &= ~OMAP3ISP_CCDC_LPF;
+	}
+
+	if (ccdc->update & OMAP3ISP_CCDC_BLCLAMP) {
+		ccdc_configure_clamp(ccdc);
+		ccdc->update &= ~OMAP3ISP_CCDC_BLCLAMP;
+	}
+
+	if (ccdc->update & OMAP3ISP_CCDC_BCOMP) {
+		ccdc_configure_black_comp(ccdc);
+		ccdc->update &= ~OMAP3ISP_CCDC_BCOMP;
+	}
+}
+
+/*
+ * omap3isp_ccdc_restore_context - Restore values of the CCDC module registers
+ * @dev: Pointer to ISP device
+ */
+void omap3isp_ccdc_restore_context(struct isp_device *isp)
+{
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG, ISPCCDC_CFG_VDLC);
+
+	ccdc->update = OMAP3ISP_CCDC_ALAW | OMAP3ISP_CCDC_LPF
+		     | OMAP3ISP_CCDC_BLCLAMP | OMAP3ISP_CCDC_BCOMP;
+	ccdc_apply_controls(ccdc);
+	ccdc_configure_fpc(ccdc);
+}
+
+/* -----------------------------------------------------------------------------
+ * Format- and pipeline-related configuration helpers
+ */
+
+/*
+ * ccdc_config_vp - Configure the Video Port.
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_config_vp(struct isp_ccdc_device *ccdc)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
+	struct isp_device *isp = to_isp_device(ccdc);
+	unsigned long l3_ick = pipe->l3_ick;
+	unsigned int max_div = isp->revision == ISP_REVISION_15_0 ? 64 : 8;
+	unsigned int div = 0;
+	u32 fmtcfg_vp;
+
+	fmtcfg_vp = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG)
+		  & ~(ISPCCDC_FMTCFG_VPIN_MASK | ISPCCDC_FMTCFG_VPIF_FRQ_MASK);
+
+	switch (ccdc->syncif.datsz) {
+	case 8:
+	case 10:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_9_0;
+		break;
+	case 11:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_10_1;
+		break;
+	case 12:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_11_2;
+		break;
+	case 13:
+		fmtcfg_vp |= ISPCCDC_FMTCFG_VPIN_12_3;
+		break;
+	};
+
+	if (pipe->input)
+		div = DIV_ROUND_UP(l3_ick, pipe->max_rate);
+	else if (ccdc->vpcfg.pixelclk)
+		div = l3_ick / ccdc->vpcfg.pixelclk;
+
+	div = clamp(div, 2U, max_div);
+	fmtcfg_vp |= (div - 2) << ISPCCDC_FMTCFG_VPIF_FRQ_SHIFT;
+
+	isp_reg_writel(isp, fmtcfg_vp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG);
+}
+
+/*
+ * ccdc_enable_vp - Enable Video Port.
+ * @ccdc: Pointer to ISP CCDC device.
+ * @enable: 0 Disables VP, 1 Enables VP
+ *
+ * This is needed for outputting image to Preview, H3A and HIST ISP submodules.
+ */
+static void ccdc_enable_vp(struct isp_ccdc_device *ccdc, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMTCFG,
+			ISPCCDC_FMTCFG_VPEN, enable ? ISPCCDC_FMTCFG_VPEN : 0);
+}
+
+/*
+ * ccdc_config_outlineoffset - Configure memory saving output line offset
+ * @ccdc: Pointer to ISP CCDC device.
+ * @offset: Address offset to start a new line. Must be twice the
+ *          Output width and aligned on 32 byte boundary
+ * @oddeven: Specifies the odd/even line pattern to be chosen to store the
+ *           output.
+ * @numlines: Set the value 0-3 for +1-4lines, 4-7 for -1-4lines.
+ *
+ * - Configures the output line offset when stored in memory
+ * - Sets the odd/even line pattern to store the output
+ *    (EVENEVEN (1), ODDEVEN (2), EVENODD (3), ODDODD (4))
+ * - Configures the number of even and odd line fields in case of rearranging
+ * the lines.
+ */
+static void ccdc_config_outlineoffset(struct isp_ccdc_device *ccdc,
+					u32 offset, u8 oddeven, u8 numlines)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	isp_reg_writel(isp, offset & 0xffff,
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HSIZE_OFF);
+
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_FINV);
+
+	isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+		    ISPCCDC_SDOFST_FOFST_4L);
+
+	switch (oddeven) {
+	case EVENEVEN:
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST0_SHIFT);
+		break;
+	case ODDEVEN:
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST1_SHIFT);
+		break;
+	case EVENODD:
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST2_SHIFT);
+		break;
+	case ODDODD:
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDOFST,
+			    (numlines & 0x7) << ISPCCDC_SDOFST_LOFST3_SHIFT);
+		break;
+	default:
+		break;
+	}
+}
+
+/*
+ * ccdc_set_outaddr - Set memory address to save output image
+ * @ccdc: Pointer to ISP CCDC device.
+ * @addr: ISP MMU Mapped 32-bit memory address aligned on 32 byte boundary.
+ *
+ * Sets the memory address where the output will be saved.
+ */
+static void ccdc_set_outaddr(struct isp_ccdc_device *ccdc, u32 addr)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	isp_reg_writel(isp, addr, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SDR_ADDR);
+}
+
+/*
+ * omap3isp_ccdc_max_rate - Calculate maximum input data rate based on the input
+ * @ccdc: Pointer to ISP CCDC device.
+ * @max_rate: Maximum calculated data rate.
+ *
+ * Returns in *max_rate less value between calculated and passed
+ */
+void omap3isp_ccdc_max_rate(struct isp_ccdc_device *ccdc,
+			    unsigned int *max_rate)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
+	unsigned int rate;
+
+	if (pipe == NULL)
+		return;
+
+	/*
+	 * TRM says that for parallel sensors the maximum data rate
+	 * should be 90% form L3/2 clock, otherwise just L3/2.
+	 */
+	if (ccdc->input == CCDC_INPUT_PARALLEL)
+		rate = pipe->l3_ick / 2 * 9 / 10;
+	else
+		rate = pipe->l3_ick / 2;
+
+	*max_rate = min(*max_rate, rate);
+}
+
+/*
+ * ccdc_config_sync_if - Set CCDC sync interface configuration
+ * @ccdc: Pointer to ISP CCDC device.
+ * @syncif: Structure containing the sync parameters like field state, CCDC in
+ *          master/slave mode, raw/yuv data, polarity of data, field, hs, vs
+ *          signals.
+ */
+static void ccdc_config_sync_if(struct isp_ccdc_device *ccdc,
+				struct ispccdc_syncif *syncif)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	u32 syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC,
+				     ISPCCDC_SYN_MODE);
+
+	syn_mode |= ISPCCDC_SYN_MODE_VDHDEN;
+
+	if (syncif->fldstat)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDSTAT;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_FLDSTAT;
+
+	syn_mode &= ~ISPCCDC_SYN_MODE_DATSIZ_MASK;
+	switch (syncif->datsz) {
+	case 8:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_8;
+		break;
+	case 10:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_10;
+		break;
+	case 11:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_11;
+		break;
+	case 12:
+		syn_mode |= ISPCCDC_SYN_MODE_DATSIZ_12;
+		break;
+	};
+
+	if (syncif->fldmode)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDMODE;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_FLDMODE;
+
+	if (syncif->datapol)
+		syn_mode |= ISPCCDC_SYN_MODE_DATAPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_DATAPOL;
+
+	if (syncif->fldpol)
+		syn_mode |= ISPCCDC_SYN_MODE_FLDPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_FLDPOL;
+
+	if (syncif->hdpol)
+		syn_mode |= ISPCCDC_SYN_MODE_HDPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_HDPOL;
+
+	if (syncif->vdpol)
+		syn_mode |= ISPCCDC_SYN_MODE_VDPOL;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_VDPOL;
+
+	if (syncif->ccdc_mastermode) {
+		syn_mode |= ISPCCDC_SYN_MODE_FLDOUT | ISPCCDC_SYN_MODE_VDHDOUT;
+		isp_reg_writel(isp,
+			       syncif->hs_width << ISPCCDC_HD_VD_WID_HDW_SHIFT
+			     | syncif->vs_width << ISPCCDC_HD_VD_WID_VDW_SHIFT,
+			       OMAP3_ISP_IOMEM_CCDC,
+			       ISPCCDC_HD_VD_WID);
+
+		isp_reg_writel(isp,
+			       syncif->ppln << ISPCCDC_PIX_LINES_PPLN_SHIFT
+			     | syncif->hlprf << ISPCCDC_PIX_LINES_HLPRF_SHIFT,
+			       OMAP3_ISP_IOMEM_CCDC,
+			       ISPCCDC_PIX_LINES);
+	} else
+		syn_mode &= ~(ISPCCDC_SYN_MODE_FLDOUT |
+			      ISPCCDC_SYN_MODE_VDHDOUT);
+
+	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+
+	if (!syncif->bt_r656_en)
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_REC656IF,
+			    ISPCCDC_REC656IF_R656ON);
+}
+
+/* CCDC formats descriptions */
+static const u32 ccdc_sgrbg_pattern =
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC0_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP0PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC2_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP0PLC3_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP1PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP1PLC1_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP1PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP1PLC3_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC0_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP2PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC2_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP2PLC3_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP3PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP3PLC1_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP3PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP3PLC3_SHIFT;
+
+static const u32 ccdc_srggb_pattern =
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP0PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC1_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP0PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP0PLC3_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP1PLC0_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP1PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP1PLC2_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP1PLC3_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP2PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC1_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP2PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP2PLC3_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP3PLC0_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP3PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP3PLC2_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP3PLC3_SHIFT;
+
+static const u32 ccdc_sbggr_pattern =
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP0PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP0PLC1_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP0PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP0PLC3_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP1PLC0_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP1PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP1PLC2_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP1PLC3_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP2PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP2PLC1_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP2PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP2PLC3_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP3PLC0_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP3PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP3PLC2_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP3PLC3_SHIFT;
+
+static const u32 ccdc_sgbrg_pattern =
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP0PLC0_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP0PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP0PLC2_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP0PLC3_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP1PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP1PLC1_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP1PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP1PLC3_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP2PLC0_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP2PLC1_SHIFT |
+	ISPCCDC_COLPTN_Gb_G  << ISPCCDC_COLPTN_CP2PLC2_SHIFT |
+	ISPCCDC_COLPTN_B_Mg  << ISPCCDC_COLPTN_CP2PLC3_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP3PLC0_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP3PLC1_SHIFT |
+	ISPCCDC_COLPTN_R_Ye  << ISPCCDC_COLPTN_CP3PLC2_SHIFT |
+	ISPCCDC_COLPTN_Gr_Cy << ISPCCDC_COLPTN_CP3PLC3_SHIFT;
+
+static void ccdc_configure(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+	struct isp_parallel_platform_data *pdata = NULL;
+	struct v4l2_subdev *sensor;
+	struct v4l2_mbus_framefmt *format;
+	struct media_pad *pad;
+	unsigned long flags;
+	u32 syn_mode;
+	u32 ccdc_pattern;
+
+	if (ccdc->input == CCDC_INPUT_PARALLEL) {
+		pad = media_entity_remote_source(&ccdc->pads[CCDC_PAD_SINK]);
+		sensor = media_entity_to_v4l2_subdev(pad->entity);
+		pdata = &((struct isp_v4l2_subdevs_group *)sensor->host_priv)
+			->bus.parallel;
+	}
+
+	omap3isp_configure_bridge(isp, ccdc->input, pdata);
+
+	ccdc->syncif.datsz = pdata ? pdata->width : 10;
+	ccdc_config_sync_if(ccdc, &ccdc->syncif);
+
+	/* CCDC_PAD_SINK */
+	format = &ccdc->formats[CCDC_PAD_SINK];
+
+	syn_mode = isp_reg_readl(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+
+	/* Use the raw, unprocessed data when writing to memory. The H3A and
+	 * histogram modules are still fed with lens shading corrected data.
+	 */
+	syn_mode &= ~ISPCCDC_SYN_MODE_VP2SDR;
+
+	if (ccdc->output & CCDC_OUTPUT_MEMORY)
+		syn_mode |= ISPCCDC_SYN_MODE_WEN;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_WEN;
+
+	if (ccdc->output & CCDC_OUTPUT_RESIZER)
+		syn_mode |= ISPCCDC_SYN_MODE_SDR2RSZ;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_SDR2RSZ;
+
+	/* Use PACK8 mode for 1byte per pixel formats. */
+	if (omap3isp_video_format_info(format->code)->bpp <= 8)
+		syn_mode |= ISPCCDC_SYN_MODE_PACK8;
+	else
+		syn_mode &= ~ISPCCDC_SYN_MODE_PACK8;
+
+	isp_reg_writel(isp, syn_mode, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_SYN_MODE);
+
+	/* Mosaic filter */
+	switch (format->code) {
+	case V4L2_MBUS_FMT_SRGGB10_1X10:
+	case V4L2_MBUS_FMT_SRGGB12_1X12:
+		ccdc_pattern = ccdc_srggb_pattern;
+		break;
+	case V4L2_MBUS_FMT_SBGGR10_1X10:
+	case V4L2_MBUS_FMT_SBGGR12_1X12:
+		ccdc_pattern = ccdc_sbggr_pattern;
+		break;
+	case V4L2_MBUS_FMT_SGBRG10_1X10:
+	case V4L2_MBUS_FMT_SGBRG12_1X12:
+		ccdc_pattern = ccdc_sgbrg_pattern;
+		break;
+	default:
+		/* Use GRBG */
+		ccdc_pattern = ccdc_sgrbg_pattern;
+		break;
+	}
+	ccdc_config_imgattr(ccdc, ccdc_pattern);
+
+	/* Generate VD0 on the last line of the image and VD1 on the
+	 * 2/3 height line.
+	 */
+	isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
+		       ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
+
+	/* CCDC_PAD_SOURCE_OF */
+	format = &ccdc->formats[CCDC_PAD_SOURCE_OF];
+
+	isp_reg_writel(isp, (0 << ISPCCDC_HORZ_INFO_SPH_SHIFT) |
+		       ((format->width - 1) << ISPCCDC_HORZ_INFO_NPH_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_HORZ_INFO);
+	isp_reg_writel(isp, 0 << ISPCCDC_VERT_START_SLV0_SHIFT,
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_START);
+	isp_reg_writel(isp, (format->height - 1)
+			<< ISPCCDC_VERT_LINES_NLV_SHIFT,
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VERT_LINES);
+
+	ccdc_config_outlineoffset(ccdc, ccdc->video_out.bpl_value, 0, 0);
+
+	/* CCDC_PAD_SOURCE_VP */
+	format = &ccdc->formats[CCDC_PAD_SOURCE_VP];
+
+	isp_reg_writel(isp, (0 << ISPCCDC_FMT_HORZ_FMTSPH_SHIFT) |
+		       (format->width << ISPCCDC_FMT_HORZ_FMTLNH_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_HORZ);
+	isp_reg_writel(isp, (0 << ISPCCDC_FMT_VERT_FMTSLV_SHIFT) |
+		       ((format->height + 1) << ISPCCDC_FMT_VERT_FMTLNV_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_FMT_VERT);
+
+	isp_reg_writel(isp, (format->width << ISPCCDC_VP_OUT_HORZ_NUM_SHIFT) |
+		       (format->height << ISPCCDC_VP_OUT_VERT_NUM_SHIFT),
+		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VP_OUT);
+
+	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+	if (ccdc->lsc.request == NULL)
+		goto unlock;
+
+	WARN_ON(ccdc->lsc.active);
+
+	/* Get last good LSC configuration. If it is not supported for
+	 * the current active resolution discard it.
+	 */
+	if (ccdc->lsc.active == NULL &&
+	    __ccdc_lsc_configure(ccdc, ccdc->lsc.request) == 0) {
+		ccdc->lsc.active = ccdc->lsc.request;
+	} else {
+		list_add_tail(&ccdc->lsc.request->list, &ccdc->lsc.free_queue);
+		schedule_work(&ccdc->lsc.table_work);
+	}
+
+	ccdc->lsc.request = NULL;
+
+unlock:
+	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+
+	ccdc_apply_controls(ccdc);
+}
+
+static void __ccdc_enable(struct isp_ccdc_device *ccdc, int enable)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_PCR,
+			ISPCCDC_PCR_EN, enable ? ISPCCDC_PCR_EN : 0);
+}
+
+static int ccdc_disable(struct isp_ccdc_device *ccdc)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&ccdc->lock, flags);
+	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS)
+		ccdc->stopping = CCDC_STOP_REQUEST;
+	spin_unlock_irqrestore(&ccdc->lock, flags);
+
+	ret = wait_event_timeout(ccdc->wait,
+				 ccdc->stopping == CCDC_STOP_FINISHED,
+				 msecs_to_jiffies(2000));
+	if (ret == 0) {
+		ret = -ETIMEDOUT;
+		dev_warn(to_device(ccdc), "CCDC stop timeout!\n");
+	}
+
+	omap3isp_sbl_disable(to_isp_device(ccdc), OMAP3_ISP_SBL_CCDC_LSC_READ);
+
+	mutex_lock(&ccdc->ioctl_lock);
+	ccdc_lsc_free_request(ccdc, ccdc->lsc.request);
+	ccdc->lsc.request = ccdc->lsc.active;
+	ccdc->lsc.active = NULL;
+	cancel_work_sync(&ccdc->lsc.table_work);
+	ccdc_lsc_free_queue(ccdc, &ccdc->lsc.free_queue);
+	mutex_unlock(&ccdc->ioctl_lock);
+
+	ccdc->stopping = CCDC_STOP_NOT_REQUESTED;
+
+	return ret > 0 ? 0 : ret;
+}
+
+static void ccdc_enable(struct isp_ccdc_device *ccdc)
+{
+	if (ccdc_lsc_is_configured(ccdc))
+		__ccdc_lsc_enable(ccdc, 1);
+	__ccdc_enable(ccdc, 1);
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt handling
+ */
+
+/*
+ * ccdc_sbl_busy - Poll idle state of CCDC and related SBL memory write bits
+ * @ccdc: Pointer to ISP CCDC device.
+ *
+ * Returns zero if the CCDC is idle and the image has been written to
+ * memory, too.
+ */
+static int ccdc_sbl_busy(struct isp_ccdc_device *ccdc)
+{
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	return omap3isp_ccdc_busy(ccdc)
+		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_0) &
+		   ISPSBL_CCDC_WR_0_DATA_READY)
+		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_1) &
+		   ISPSBL_CCDC_WR_0_DATA_READY)
+		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_2) &
+		   ISPSBL_CCDC_WR_0_DATA_READY)
+		| (isp_reg_readl(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_CCDC_WR_3) &
+		   ISPSBL_CCDC_WR_0_DATA_READY);
+}
+
+/*
+ * ccdc_sbl_wait_idle - Wait until the CCDC and related SBL are idle
+ * @ccdc: Pointer to ISP CCDC device.
+ * @max_wait: Max retry count in us for wait for idle/busy transition.
+ */
+static int ccdc_sbl_wait_idle(struct isp_ccdc_device *ccdc,
+			      unsigned int max_wait)
+{
+	unsigned int wait = 0;
+
+	if (max_wait == 0)
+		max_wait = 10000; /* 10 ms */
+
+	for (wait = 0; wait <= max_wait; wait++) {
+		if (!ccdc_sbl_busy(ccdc))
+			return 0;
+
+		rmb();
+		udelay(1);
+	}
+
+	return -EBUSY;
+}
+
+/* __ccdc_handle_stopping - Handle CCDC and/or LSC stopping sequence
+ * @ccdc: Pointer to ISP CCDC device.
+ * @event: Pointing which event trigger handler
+ *
+ * Return 1 when the event and stopping request combination is satisfyied,
+ * zero otherwise.
+ */
+static int __ccdc_handle_stopping(struct isp_ccdc_device *ccdc, u32 event)
+{
+	int rval = 0;
+
+	switch ((ccdc->stopping & 3) | event) {
+	case CCDC_STOP_REQUEST | CCDC_EVENT_VD1:
+		if (ccdc->lsc.state != LSC_STATE_STOPPED)
+			__ccdc_lsc_enable(ccdc, 0);
+		__ccdc_enable(ccdc, 0);
+		ccdc->stopping = CCDC_STOP_EXECUTED;
+		return 1;
+
+	case CCDC_STOP_EXECUTED | CCDC_EVENT_VD0:
+		ccdc->stopping |= CCDC_STOP_CCDC_FINISHED;
+		if (ccdc->lsc.state == LSC_STATE_STOPPED)
+			ccdc->stopping |= CCDC_STOP_LSC_FINISHED;
+		rval = 1;
+		break;
+
+	case CCDC_STOP_EXECUTED | CCDC_EVENT_LSC_DONE:
+		ccdc->stopping |= CCDC_STOP_LSC_FINISHED;
+		rval = 1;
+		break;
+
+	case CCDC_STOP_EXECUTED | CCDC_EVENT_VD1:
+		return 1;
+	}
+
+	if (ccdc->stopping == CCDC_STOP_FINISHED) {
+		wake_up(&ccdc->wait);
+		rval = 1;
+	}
+
+	return rval;
+}
+
+static void ccdc_hs_vs_isr(struct isp_ccdc_device *ccdc)
+{
+	struct video_device *vdev = &ccdc->subdev.devnode;
+	struct v4l2_event event;
+
+	memset(&event, 0, sizeof(event));
+	event.type = V4L2_EVENT_OMAP3ISP_HS_VS;
+
+	v4l2_event_queue(vdev, &event);
+}
+
+/*
+ * ccdc_lsc_isr - Handle LSC events
+ * @ccdc: Pointer to ISP CCDC device.
+ * @events: LSC events
+ */
+static void ccdc_lsc_isr(struct isp_ccdc_device *ccdc, u32 events)
+{
+	unsigned long flags;
+
+	if (events & IRQ0STATUS_CCDC_LSC_PREF_ERR_IRQ) {
+		ccdc_lsc_error_handler(ccdc);
+		ccdc->error = 1;
+		dev_dbg(to_device(ccdc), "lsc prefetch error\n");
+	}
+
+	if (!(events & IRQ0STATUS_CCDC_LSC_DONE_IRQ))
+		return;
+
+	/* LSC_DONE interrupt occur, there are two cases
+	 * 1. stopping for reconfiguration
+	 * 2. stopping because of STREAM OFF command
+	 */
+	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+
+	if (ccdc->lsc.state == LSC_STATE_STOPPING)
+		ccdc->lsc.state = LSC_STATE_STOPPED;
+
+	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_LSC_DONE))
+		goto done;
+
+	if (ccdc->lsc.state != LSC_STATE_RECONFIG)
+		goto done;
+
+	/* LSC is in STOPPING state, change to the new state */
+	ccdc->lsc.state = LSC_STATE_STOPPED;
+
+	/* This is an exception. Start of frame and LSC_DONE interrupt
+	 * have been received on the same time. Skip this event and wait
+	 * for better times.
+	 */
+	if (events & IRQ0STATUS_HS_VS_IRQ)
+		goto done;
+
+	/* The LSC engine is stopped at this point. Enable it if there's a
+	 * pending request.
+	 */
+	if (ccdc->lsc.request == NULL)
+		goto done;
+
+	ccdc_lsc_enable(ccdc);
+
+done:
+	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+}
+
+static int ccdc_isr_buffer(struct isp_ccdc_device *ccdc)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&ccdc->subdev.entity);
+	struct isp_device *isp = to_isp_device(ccdc);
+	struct isp_buffer *buffer;
+	int restart = 0;
+
+	/* The CCDC generates VD0 interrupts even when disabled (the datasheet
+	 * doesn't explicitly state if that's supposed to happen or not, so it
+	 * can be considered as a hardware bug or as a feature, but we have to
+	 * deal with it anyway). Disabling the CCDC when no buffer is available
+	 * would thus not be enough, we need to handle the situation explicitly.
+	 */
+	if (list_empty(&ccdc->video_out.dmaqueue))
+		goto done;
+
+	/* We're in continuous mode, and memory writes were disabled due to a
+	 * buffer underrun. Reenable them now that we have a buffer. The buffer
+	 * address has been set in ccdc_video_queue.
+	 */
+	if (ccdc->state == ISP_PIPELINE_STREAM_CONTINUOUS && ccdc->underrun) {
+		restart = 1;
+		ccdc->underrun = 0;
+		goto done;
+	}
+
+	if (ccdc_sbl_wait_idle(ccdc, 1000)) {
+		dev_info(isp->dev, "CCDC won't become idle!\n");
+		goto done;
+	}
+
+	buffer = omap3isp_video_buffer_next(&ccdc->video_out, ccdc->error);
+	if (buffer != NULL) {
+		ccdc_set_outaddr(ccdc, buffer->isp_addr);
+		restart = 1;
+	}
+
+	pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
+
+	if (ccdc->state == ISP_PIPELINE_STREAM_SINGLESHOT &&
+	    isp_pipeline_ready(pipe))
+		omap3isp_pipeline_set_stream(pipe,
+					ISP_PIPELINE_STREAM_SINGLESHOT);
+
+done:
+	ccdc->error = 0;
+	return restart;
+}
+
+/*
+ * ccdc_vd0_isr - Handle VD0 event
+ * @ccdc: Pointer to ISP CCDC device.
+ *
+ * Executes LSC deferred enablement before next frame starts.
+ */
+static void ccdc_vd0_isr(struct isp_ccdc_device *ccdc)
+{
+	unsigned long flags;
+	int restart = 0;
+
+	if (ccdc->output & CCDC_OUTPUT_MEMORY)
+		restart = ccdc_isr_buffer(ccdc);
+
+	spin_lock_irqsave(&ccdc->lock, flags);
+	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD0)) {
+		spin_unlock_irqrestore(&ccdc->lock, flags);
+		return;
+	}
+
+	if (!ccdc->shadow_update)
+		ccdc_apply_controls(ccdc);
+	spin_unlock_irqrestore(&ccdc->lock, flags);
+
+	if (restart)
+		ccdc_enable(ccdc);
+}
+
+/*
+ * ccdc_vd1_isr - Handle VD1 event
+ * @ccdc: Pointer to ISP CCDC device.
+ */
+static void ccdc_vd1_isr(struct isp_ccdc_device *ccdc)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
+
+	/*
+	 * Depending on the CCDC pipeline state, CCDC stopping should be
+	 * handled differently. In SINGLESHOT we emulate an internal CCDC
+	 * stopping because the CCDC hw works only in continuous mode.
+	 * When CONTINUOUS pipeline state is used and the CCDC writes it's
+	 * data to memory the CCDC and LSC are stopped immediately but
+	 * without change the CCDC stopping state machine. The CCDC
+	 * stopping state machine should be used only when user request
+	 * for stopping is received (SINGLESHOT is an exeption).
+	 */
+	switch (ccdc->state) {
+	case ISP_PIPELINE_STREAM_SINGLESHOT:
+		ccdc->stopping = CCDC_STOP_REQUEST;
+		break;
+
+	case ISP_PIPELINE_STREAM_CONTINUOUS:
+		if (ccdc->output & CCDC_OUTPUT_MEMORY) {
+			if (ccdc->lsc.state != LSC_STATE_STOPPED)
+				__ccdc_lsc_enable(ccdc, 0);
+			__ccdc_enable(ccdc, 0);
+		}
+		break;
+
+	case ISP_PIPELINE_STREAM_STOPPED:
+		break;
+	}
+
+	if (__ccdc_handle_stopping(ccdc, CCDC_EVENT_VD1))
+		goto done;
+
+	if (ccdc->lsc.request == NULL)
+		goto done;
+
+	/*
+	 * LSC need to be reconfigured. Stop it here and on next LSC_DONE IRQ
+	 * do the appropriate changes in registers
+	 */
+	if (ccdc->lsc.state == LSC_STATE_RUNNING) {
+		__ccdc_lsc_enable(ccdc, 0);
+		ccdc->lsc.state = LSC_STATE_RECONFIG;
+		goto done;
+	}
+
+	/* LSC has been in STOPPED state, enable it */
+	if (ccdc->lsc.state == LSC_STATE_STOPPED)
+		ccdc_lsc_enable(ccdc);
+
+done:
+	spin_unlock_irqrestore(&ccdc->lsc.req_lock, flags);
+}
+
+/*
+ * omap3isp_ccdc_isr - Configure CCDC during interframe time.
+ * @ccdc: Pointer to ISP CCDC device.
+ * @events: CCDC events
+ */
+int omap3isp_ccdc_isr(struct isp_ccdc_device *ccdc, u32 events)
+{
+	if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED)
+		return 0;
+
+	if (events & IRQ0STATUS_CCDC_VD1_IRQ)
+		ccdc_vd1_isr(ccdc);
+
+	ccdc_lsc_isr(ccdc, events);
+
+	if (events & IRQ0STATUS_CCDC_VD0_IRQ)
+		ccdc_vd0_isr(ccdc);
+
+	if (events & IRQ0STATUS_HS_VS_IRQ)
+		ccdc_hs_vs_isr(ccdc);
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP video operations
+ */
+
+static int ccdc_video_queue(struct isp_video *video, struct isp_buffer *buffer)
+{
+	struct isp_ccdc_device *ccdc = &video->isp->isp_ccdc;
+
+	if (!(ccdc->output & CCDC_OUTPUT_MEMORY))
+		return -ENODEV;
+
+	ccdc_set_outaddr(ccdc, buffer->isp_addr);
+
+	/* We now have a buffer queued on the output, restart the pipeline in
+	 * on the next CCDC interrupt if running in continuous mode (or when
+	 * starting the stream).
+	 */
+	ccdc->underrun = 1;
+
+	return 0;
+}
+
+static const struct isp_video_operations ccdc_video_ops = {
+	.queue = ccdc_video_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+/*
+ * ccdc_ioctl - CCDC module private ioctl's
+ * @sd: ISP CCDC V4L2 subdevice
+ * @cmd: ioctl command
+ * @arg: ioctl argument
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+static long ccdc_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	int ret;
+
+	switch (cmd) {
+	case VIDIOC_OMAP3ISP_CCDC_CFG:
+		mutex_lock(&ccdc->ioctl_lock);
+		ret = ccdc_config(ccdc, arg);
+		mutex_unlock(&ccdc->ioctl_lock);
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return ret;
+}
+
+static int ccdc_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				struct v4l2_event_subscription *sub)
+{
+	if (sub->type != V4L2_EVENT_OMAP3ISP_HS_VS)
+		return -EINVAL;
+
+	return v4l2_event_subscribe(fh, sub);
+}
+
+static int ccdc_unsubscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				  struct v4l2_event_subscription *sub)
+{
+	return v4l2_event_unsubscribe(fh, sub);
+}
+
+/*
+ * ccdc_set_stream - Enable/Disable streaming on the CCDC module
+ * @sd: ISP CCDC V4L2 subdevice
+ * @enable: Enable/disable stream
+ *
+ * When writing to memory, the CCDC hardware can't be enabled without a memory
+ * buffer to write to. As the s_stream operation is called in response to a
+ * STREAMON call without any buffer queued yet, just update the enabled field
+ * and return immediately. The CCDC will be enabled in ccdc_isr_buffer().
+ *
+ * When not writing to memory enable the CCDC immediately.
+ */
+static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct isp_device *isp = to_isp_device(ccdc);
+	int ret = 0;
+
+	if (ccdc->state == ISP_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISP_PIPELINE_STREAM_STOPPED)
+			return 0;
+
+		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_CCDC);
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_CCDC, ISPCCDC_CFG,
+			    ISPCCDC_CFG_VDLC);
+
+		ccdc_configure(ccdc);
+
+		/* TODO: Don't configure the video port if all of its output
+		 * links are inactive.
+		 */
+		ccdc_config_vp(ccdc);
+		ccdc_enable_vp(ccdc, 1);
+		ccdc->error = 0;
+		ccdc_print_status(ccdc);
+	}
+
+	switch (enable) {
+	case ISP_PIPELINE_STREAM_CONTINUOUS:
+		if (ccdc->output & CCDC_OUTPUT_MEMORY)
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
+
+		if (ccdc->underrun || !(ccdc->output & CCDC_OUTPUT_MEMORY))
+			ccdc_enable(ccdc);
+
+		ccdc->underrun = 0;
+		break;
+
+	case ISP_PIPELINE_STREAM_SINGLESHOT:
+		if (ccdc->output & CCDC_OUTPUT_MEMORY &&
+		    ccdc->state != ISP_PIPELINE_STREAM_SINGLESHOT)
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
+
+		ccdc_enable(ccdc);
+		break;
+
+	case ISP_PIPELINE_STREAM_STOPPED:
+		ret = ccdc_disable(ccdc);
+		if (ccdc->output & CCDC_OUTPUT_MEMORY)
+			omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_CCDC_WRITE);
+		omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_CCDC);
+		ccdc->underrun = 0;
+		break;
+	}
+
+	ccdc->state = enable;
+	return ret;
+}
+
+static struct v4l2_mbus_framefmt *
+__ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+		  unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &ccdc->formats[pad];
+}
+
+/*
+ * ccdc_try_format - Try video format on a pad
+ * @ccdc: ISP CCDC device
+ * @fh : V4L2 subdev file handle
+ * @pad: Pad number
+ * @fmt: Format
+ */
+static void
+ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
+		enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+	const struct isp_format_info *info;
+	unsigned int width = fmt->width;
+	unsigned int height = fmt->height;
+	unsigned int i;
+
+	switch (pad) {
+	case CCDC_PAD_SINK:
+		/* TODO: If the CCDC output formatter pad is connected directly
+		 * to the resizer, only YUV formats can be used.
+		 */
+		for (i = 0; i < ARRAY_SIZE(ccdc_fmts); i++) {
+			if (fmt->code == ccdc_fmts[i])
+				break;
+		}
+
+		/* If not found, use SGRBG10 as default */
+		if (i >= ARRAY_SIZE(ccdc_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+
+		/* Clamp the input size. */
+		fmt->width = clamp_t(u32, width, 32, 4096);
+		fmt->height = clamp_t(u32, height, 32, 4096);
+		break;
+
+	case CCDC_PAD_SOURCE_OF:
+		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		/* The data formatter truncates the number of horizontal output
+		 * pixels to a multiple of 16. To avoid clipping data, allow
+		 * callers to request an output size bigger than the input size
+		 * up to the nearest multiple of 16.
+		 */
+		fmt->width = clamp_t(u32, width, 32, (fmt->width + 15) & ~15);
+		fmt->width &= ~15;
+		fmt->height = clamp_t(u32, height, 32, fmt->height);
+		break;
+
+	case CCDC_PAD_SOURCE_VP:
+		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		/* The video port interface truncates the data to 10 bits. */
+		info = omap3isp_video_format_info(fmt->code);
+		fmt->code = info->truncated;
+
+		/* The number of lines that can be clocked out from the video
+		 * port output must be at least one line less than the number
+		 * of input lines.
+		 */
+		fmt->width = clamp_t(u32, width, 32, fmt->width);
+		fmt->height = clamp_t(u32, height, 32, fmt->height - 1);
+		break;
+	}
+
+	/* Data is written to memory unpacked, each 10-bit or 12-bit pixel is
+	 * stored on 2 bytes.
+	 */
+	fmt->colorspace = V4L2_COLORSPACE_SRGB;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+/*
+ * ccdc_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	switch (code->pad) {
+	case CCDC_PAD_SINK:
+		if (code->index >= ARRAY_SIZE(ccdc_fmts))
+			return -EINVAL;
+
+		code->code = ccdc_fmts[code->index];
+		break;
+
+	case CCDC_PAD_SOURCE_OF:
+	case CCDC_PAD_SOURCE_VP:
+		/* No format conversion inside CCDC */
+		if (code->index != 0)
+			return -EINVAL;
+
+		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK,
+					   V4L2_SUBDEV_FORMAT_TRY);
+
+		code->code = format->code;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	ccdc_try_format(ccdc, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	ccdc_try_format(ccdc, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * ccdc_get_format - Retrieve the video format on a pad
+ * @sd : ISP CCDC V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int ccdc_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ccdc_get_format(ccdc, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * ccdc_set_format - Set the video format on a pad
+ * @sd : ISP CCDC V4L2 subdevice
+ * @fh : V4L2 subdev file handle
+ * @fmt: Format
+ *
+ * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
+ * to the format type.
+ */
+static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_format *fmt)
+{
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __ccdc_get_format(ccdc, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	ccdc_try_format(ccdc, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == CCDC_PAD_SINK) {
+		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_OF,
+					   fmt->which);
+		*format = fmt->format;
+		ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_OF, format,
+				fmt->which);
+
+		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_VP,
+					   fmt->which);
+		*format = fmt->format;
+		ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_VP, format,
+				fmt->which);
+	}
+
+	return 0;
+}
+
+/*
+ * ccdc_init_formats - Initialize formats on all pads
+ * @sd: ISP CCDC V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int ccdc_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = CCDC_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	ccdc_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/* V4L2 subdev core operations */
+static const struct v4l2_subdev_core_ops ccdc_v4l2_core_ops = {
+	.ioctl = ccdc_ioctl,
+	.subscribe_event = ccdc_subscribe_event,
+	.unsubscribe_event = ccdc_unsubscribe_event,
+};
+
+/* V4L2 subdev video operations */
+static const struct v4l2_subdev_video_ops ccdc_v4l2_video_ops = {
+	.s_stream = ccdc_set_stream,
+};
+
+/* V4L2 subdev pad operations */
+static const struct v4l2_subdev_pad_ops ccdc_v4l2_pad_ops = {
+	.enum_mbus_code = ccdc_enum_mbus_code,
+	.enum_frame_size = ccdc_enum_frame_size,
+	.get_fmt = ccdc_get_format,
+	.set_fmt = ccdc_set_format,
+};
+
+/* V4L2 subdev operations */
+static const struct v4l2_subdev_ops ccdc_v4l2_ops = {
+	.core = &ccdc_v4l2_core_ops,
+	.video = &ccdc_v4l2_video_ops,
+	.pad = &ccdc_v4l2_pad_ops,
+};
+
+/* V4L2 subdev internal operations */
+static const struct v4l2_subdev_internal_ops ccdc_v4l2_internal_ops = {
+	.open = ccdc_init_formats,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * ccdc_link_setup - Setup CCDC connections
+ * @entity: CCDC media entity
+ * @local: Pad at the local end of the link
+ * @remote: Pad at the remote end of the link
+ * @flags: Link flags
+ *
+ * return -EINVAL or zero on success
+ */
+static int ccdc_link_setup(struct media_entity *entity,
+			   const struct media_pad *local,
+			   const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
+	struct isp_device *isp = to_isp_device(ccdc);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case CCDC_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Read from the sensor (parallel interface), CCP2, CSI2a or
+		 * CSI2c.
+		 */
+		if (!(flags & MEDIA_LNK_FL_ENABLED)) {
+			ccdc->input = CCDC_INPUT_NONE;
+			break;
+		}
+
+		if (ccdc->input != CCDC_INPUT_NONE)
+			return -EBUSY;
+
+		if (remote->entity == &isp->isp_ccp2.subdev.entity)
+			ccdc->input = CCDC_INPUT_CCP2B;
+		else if (remote->entity == &isp->isp_csi2a.subdev.entity)
+			ccdc->input = CCDC_INPUT_CSI2A;
+		else if (remote->entity == &isp->isp_csi2c.subdev.entity)
+			ccdc->input = CCDC_INPUT_CSI2C;
+		else
+			ccdc->input = CCDC_INPUT_PARALLEL;
+
+		break;
+
+	/*
+	 * The ISP core doesn't support pipelines with multiple video outputs.
+	 * Revisit this when it will be implemented, and return -EBUSY for now.
+	 */
+
+	case CCDC_PAD_SOURCE_VP | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Write to preview engine, histogram and H3A. When none of
+		 * those links are active, the video port can be disabled.
+		 */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ccdc->output & ~CCDC_OUTPUT_PREVIEW)
+				return -EBUSY;
+			ccdc->output |= CCDC_OUTPUT_PREVIEW;
+		} else {
+			ccdc->output &= ~CCDC_OUTPUT_PREVIEW;
+		}
+		break;
+
+	case CCDC_PAD_SOURCE_OF | MEDIA_ENT_T_DEVNODE:
+		/* Write to memory */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ccdc->output & ~CCDC_OUTPUT_MEMORY)
+				return -EBUSY;
+			ccdc->output |= CCDC_OUTPUT_MEMORY;
+		} else {
+			ccdc->output &= ~CCDC_OUTPUT_MEMORY;
+		}
+		break;
+
+	case CCDC_PAD_SOURCE_OF | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* Write to resizer */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (ccdc->output & ~CCDC_OUTPUT_RESIZER)
+				return -EBUSY;
+			ccdc->output |= CCDC_OUTPUT_RESIZER;
+		} else {
+			ccdc->output &= ~CCDC_OUTPUT_RESIZER;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations ccdc_media_ops = {
+	.link_setup = ccdc_link_setup,
+};
+
+/*
+ * ccdc_init_entities - Initialize V4L2 subdev and media entity
+ * @ccdc: ISP CCDC module
+ *
+ * Return 0 on success and a negative error code on failure.
+ */
+static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
+{
+	struct v4l2_subdev *sd = &ccdc->subdev;
+	struct media_pad *pads = ccdc->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	ccdc->input = CCDC_INPUT_NONE;
+
+	v4l2_subdev_init(sd, &ccdc_v4l2_ops);
+	sd->internal_ops = &ccdc_v4l2_internal_ops;
+	strlcpy(sd->name, "OMAP3 ISP CCDC", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
+	v4l2_set_subdevdata(sd, ccdc);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sd->nevents = OMAP3ISP_CCDC_NEVENTS;
+
+	pads[CCDC_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[CCDC_PAD_SOURCE_VP].flags = MEDIA_PAD_FL_SOURCE;
+	pads[CCDC_PAD_SOURCE_OF].flags = MEDIA_PAD_FL_SOURCE;
+
+	me->ops = &ccdc_media_ops;
+	ret = media_entity_init(me, CCDC_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	ccdc_init_formats(sd, NULL);
+
+	ccdc->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ccdc->video_out.ops = &ccdc_video_ops;
+	ccdc->video_out.isp = to_isp_device(ccdc);
+	ccdc->video_out.capture_mem = PAGE_ALIGN(4096 * 4096) * 3;
+	ccdc->video_out.bpl_alignment = 32;
+
+	ret = omap3isp_video_init(&ccdc->video_out, "CCDC");
+	if (ret < 0)
+		return ret;
+
+	/* Connect the CCDC subdev to the video node. */
+	ret = media_entity_create_link(&ccdc->subdev.entity, CCDC_PAD_SOURCE_OF,
+			&ccdc->video_out.video.entity, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void omap3isp_ccdc_unregister_entities(struct isp_ccdc_device *ccdc)
+{
+	media_entity_cleanup(&ccdc->subdev.entity);
+
+	v4l2_device_unregister_subdev(&ccdc->subdev);
+	omap3isp_video_unregister(&ccdc->video_out);
+}
+
+int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
+	struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video node. */
+	ret = v4l2_device_register_subdev(vdev, &ccdc->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap3isp_video_register(&ccdc->video_out, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap3isp_ccdc_unregister_entities(ccdc);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP CCDC initialisation and cleanup
+ */
+
+/*
+ * omap3isp_ccdc_init - CCDC module initialization.
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ *
+ * TODO: Get the initialisation values from platform data.
+ *
+ * Return 0 on success or a negative error code otherwise.
+ */
+int omap3isp_ccdc_init(struct isp_device *isp)
+{
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+
+	spin_lock_init(&ccdc->lock);
+	init_waitqueue_head(&ccdc->wait);
+	mutex_init(&ccdc->ioctl_lock);
+
+	ccdc->stopping = CCDC_STOP_NOT_REQUESTED;
+
+	INIT_WORK(&ccdc->lsc.table_work, ccdc_lsc_free_table_work);
+	ccdc->lsc.state = LSC_STATE_STOPPED;
+	INIT_LIST_HEAD(&ccdc->lsc.free_queue);
+	spin_lock_init(&ccdc->lsc.req_lock);
+
+	ccdc->syncif.ccdc_mastermode = 0;
+	ccdc->syncif.datapol = 0;
+	ccdc->syncif.datsz = 0;
+	ccdc->syncif.fldmode = 0;
+	ccdc->syncif.fldout = 0;
+	ccdc->syncif.fldpol = 0;
+	ccdc->syncif.fldstat = 0;
+	ccdc->syncif.hdpol = 0;
+	ccdc->syncif.vdpol = 0;
+
+	ccdc->clamp.oblen = 0;
+	ccdc->clamp.dcsubval = 0;
+
+	ccdc->vpcfg.pixelclk = 0;
+
+	ccdc->update = OMAP3ISP_CCDC_BLCLAMP;
+	ccdc_apply_controls(ccdc);
+
+	return ccdc_init_entities(ccdc);
+}
+
+/*
+ * omap3isp_ccdc_cleanup - CCDC module cleanup.
+ * @dev: Device pointer specific to the OMAP3 ISP.
+ */
+void omap3isp_ccdc_cleanup(struct isp_device *isp)
+{
+	struct isp_ccdc_device *ccdc = &isp->isp_ccdc;
+
+	/* Free LSC requests. As the CCDC is stopped there's no active request,
+	 * so only the pending request and the free queue need to be handled.
+	 */
+	ccdc_lsc_free_request(ccdc, ccdc->lsc.request);
+	cancel_work_sync(&ccdc->lsc.table_work);
+	ccdc_lsc_free_queue(ccdc, &ccdc->lsc.free_queue);
+
+	if (ccdc->fpc.fpcaddr != 0)
+		iommu_vfree(isp->iommu, ccdc->fpc.fpcaddr);
+}
diff --git a/drivers/media/video/omap3-isp/ispccdc.h b/drivers/media/video/omap3-isp/ispccdc.h
new file mode 100644
index 0000000..d403af5
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispccdc.h
@@ -0,0 +1,219 @@
+/*
+ * ispccdc.h
+ *
+ * TI OMAP3 ISP - CCDC module
+ *
+ * Copyright (C) 2009-2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_CCDC_H
+#define OMAP3_ISP_CCDC_H
+
+#include <linux/omap3isp.h>
+#include <linux/workqueue.h>
+
+#include "ispvideo.h"
+
+enum ccdc_input_entity {
+	CCDC_INPUT_NONE,
+	CCDC_INPUT_PARALLEL,
+	CCDC_INPUT_CSI2A,
+	CCDC_INPUT_CCP2B,
+	CCDC_INPUT_CSI2C
+};
+
+#define CCDC_OUTPUT_MEMORY	(1 << 0)
+#define CCDC_OUTPUT_PREVIEW	(1 << 1)
+#define CCDC_OUTPUT_RESIZER	(1 << 2)
+
+#define	OMAP3ISP_CCDC_NEVENTS	16
+
+/*
+ * struct ispccdc_syncif - Structure for Sync Interface between sensor and CCDC
+ * @ccdc_mastermode: Master mode. 1 - Master, 0 - Slave.
+ * @fldstat: Field state. 0 - Odd Field, 1 - Even Field.
+ * @datsz: Data size.
+ * @fldmode: 0 - Progressive, 1 - Interlaced.
+ * @datapol: 0 - Positive, 1 - Negative.
+ * @fldpol: 0 - Positive, 1 - Negative.
+ * @hdpol: 0 - Positive, 1 - Negative.
+ * @vdpol: 0 - Positive, 1 - Negative.
+ * @fldout: 0 - Input, 1 - Output.
+ * @hs_width: Width of the Horizontal Sync pulse, used for HS/VS Output.
+ * @vs_width: Width of the Vertical Sync pulse, used for HS/VS Output.
+ * @ppln: Number of pixels per line, used for HS/VS Output.
+ * @hlprf: Number of half lines per frame, used for HS/VS Output.
+ * @bt_r656_en: 1 - Enable ITU-R BT656 mode, 0 - Sync mode.
+ */
+struct ispccdc_syncif {
+	u8 ccdc_mastermode;
+	u8 fldstat;
+	u8 datsz;
+	u8 fldmode;
+	u8 datapol;
+	u8 fldpol;
+	u8 hdpol;
+	u8 vdpol;
+	u8 fldout;
+	u8 hs_width;
+	u8 vs_width;
+	u8 ppln;
+	u8 hlprf;
+	u8 bt_r656_en;
+};
+
+/*
+ * struct ispccdc_vp - Structure for Video Port parameters
+ * @pixelclk: Input pixel clock in Hz
+ */
+struct ispccdc_vp {
+	unsigned int pixelclk;
+};
+
+enum ispccdc_lsc_state {
+	LSC_STATE_STOPPED = 0,
+	LSC_STATE_STOPPING = 1,
+	LSC_STATE_RUNNING = 2,
+	LSC_STATE_RECONFIG = 3,
+};
+
+struct ispccdc_lsc_config_req {
+	struct list_head list;
+	struct omap3isp_ccdc_lsc_config config;
+	unsigned char enable;
+	u32 table;
+	struct iovm_struct *iovm;
+};
+
+/*
+ * ispccdc_lsc - CCDC LSC parameters
+ * @update_config: Set when user changes config
+ * @request_enable: Whether LSC is requested to be enabled
+ * @config: LSC config set by user
+ * @update_table: Set when user provides a new LSC table to table_new
+ * @table_new: LSC table set by user, ISP address
+ * @table_inuse: LSC table currently in use, ISP address
+ */
+struct ispccdc_lsc {
+	enum ispccdc_lsc_state state;
+	struct work_struct table_work;
+
+	/* LSC queue of configurations */
+	spinlock_t req_lock;
+	struct ispccdc_lsc_config_req *request;	/* requested configuration */
+	struct ispccdc_lsc_config_req *active;	/* active configuration */
+	struct list_head free_queue;	/* configurations for freeing */
+};
+
+#define CCDC_STOP_NOT_REQUESTED		0x00
+#define CCDC_STOP_REQUEST		0x01
+#define CCDC_STOP_EXECUTED		(0x02 | CCDC_STOP_REQUEST)
+#define CCDC_STOP_CCDC_FINISHED		0x04
+#define CCDC_STOP_LSC_FINISHED		0x08
+#define CCDC_STOP_FINISHED		\
+	(CCDC_STOP_EXECUTED | CCDC_STOP_CCDC_FINISHED | CCDC_STOP_LSC_FINISHED)
+
+#define CCDC_EVENT_VD1			0x10
+#define CCDC_EVENT_VD0			0x20
+#define CCDC_EVENT_LSC_DONE		0x40
+
+/* Sink and source CCDC pads */
+#define CCDC_PAD_SINK			0
+#define CCDC_PAD_SOURCE_OF		1
+#define CCDC_PAD_SOURCE_VP		2
+#define CCDC_PADS_NUM			3
+
+/*
+ * struct isp_ccdc_device - Structure for the CCDC module to store its own
+ *			    information
+ * @subdev: V4L2 subdevice
+ * @pads: Sink and source media entity pads
+ * @formats: Active video formats
+ * @input: Active input
+ * @output: Active outputs
+ * @video_out: Output video node
+ * @error: A hardware error occured during capture
+ * @alaw: A-law compression enabled (1) or disabled (0)
+ * @lpf: Low pass filter enabled (1) or disabled (0)
+ * @obclamp: Optical-black clamp enabled (1) or disabled (0)
+ * @fpc_en: Faulty pixels correction enabled (1) or disabled (0)
+ * @blcomp: Black level compensation configuration
+ * @clamp: Optical-black or digital clamp configuration
+ * @fpc: Faulty pixels correction configuration
+ * @lsc: Lens shading compensation configuration
+ * @update: Bitmask of controls to update during the next interrupt
+ * @shadow_update: Controls update in progress by userspace
+ * @syncif: Interface synchronization configuration
+ * @vpcfg: Video port configuration
+ * @underrun: A buffer underrun occured and a new buffer has been queued
+ * @state: Streaming state
+ * @lock: Serializes shadow_update with interrupt handler
+ * @wait: Wait queue used to stop the module
+ * @stopping: Stopping state
+ * @ioctl_lock: Serializes ioctl calls and LSC requests freeing
+ */
+struct isp_ccdc_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[CCDC_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[CCDC_PADS_NUM];
+
+	enum ccdc_input_entity input;
+	unsigned int output;
+	struct isp_video video_out;
+	unsigned int error;
+
+	unsigned int alaw:1,
+		     lpf:1,
+		     obclamp:1,
+		     fpc_en:1;
+	struct omap3isp_ccdc_blcomp blcomp;
+	struct omap3isp_ccdc_bclamp clamp;
+	struct omap3isp_ccdc_fpc fpc;
+	struct ispccdc_lsc lsc;
+	unsigned int update;
+	unsigned int shadow_update;
+
+	struct ispccdc_syncif syncif;
+	struct ispccdc_vp vpcfg;
+
+	unsigned int underrun:1;
+	enum isp_pipeline_stream_state state;
+	spinlock_t lock;
+	wait_queue_head_t wait;
+	unsigned int stopping;
+	struct mutex ioctl_lock;
+};
+
+struct isp_device;
+
+int omap3isp_ccdc_init(struct isp_device *isp);
+void omap3isp_ccdc_cleanup(struct isp_device *isp);
+int omap3isp_ccdc_register_entities(struct isp_ccdc_device *ccdc,
+	struct v4l2_device *vdev);
+void omap3isp_ccdc_unregister_entities(struct isp_ccdc_device *ccdc);
+
+int omap3isp_ccdc_busy(struct isp_ccdc_device *isp_ccdc);
+int omap3isp_ccdc_isr(struct isp_ccdc_device *isp_ccdc, u32 events);
+void omap3isp_ccdc_restore_context(struct isp_device *isp);
+void omap3isp_ccdc_max_rate(struct isp_ccdc_device *ccdc,
+	unsigned int *max_rate);
+
+#endif	/* OMAP3_ISP_CCDC_H */
diff --git a/drivers/media/video/omap3-isp/isppreview.c b/drivers/media/video/omap3-isp/isppreview.c
new file mode 100644
index 0000000..baf9374
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isppreview.c
@@ -0,0 +1,2113 @@
+/*
+ * isppreview.c
+ *
+ * TI OMAP3 ISP driver - Preview module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/device.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/uaccess.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "isppreview.h"
+
+/* Default values in Office Flourescent Light for RGBtoRGB Blending */
+static struct omap3isp_prev_rgbtorgb flr_rgb2rgb = {
+	{	/* RGB-RGB Matrix */
+		{0x01E2, 0x0F30, 0x0FEE},
+		{0x0F9B, 0x01AC, 0x0FB9},
+		{0x0FE0, 0x0EC0, 0x0260}
+	},	/* RGB Offset */
+	{0x0000, 0x0000, 0x0000}
+};
+
+/* Default values in Office Flourescent Light for RGB to YUV Conversion*/
+static struct omap3isp_prev_csc flr_prev_csc = {
+	{	/* CSC Coef Matrix */
+		{66, 129, 25},
+		{-38, -75, 112},
+		{112, -94 , -18}
+	},	/* CSC Offset */
+	{0x0, 0x0, 0x0}
+};
+
+/* Default values in Office Flourescent Light for CFA Gradient*/
+#define FLR_CFA_GRADTHRS_HORZ	0x28
+#define FLR_CFA_GRADTHRS_VERT	0x28
+
+/* Default values in Office Flourescent Light for Chroma Suppression*/
+#define FLR_CSUP_GAIN		0x0D
+#define FLR_CSUP_THRES		0xEB
+
+/* Default values in Office Flourescent Light for Noise Filter*/
+#define FLR_NF_STRGTH		0x03
+
+/* Default values for White Balance */
+#define FLR_WBAL_DGAIN		0x100
+#define FLR_WBAL_COEF		0x20
+
+/* Default values in Office Flourescent Light for Black Adjustment*/
+#define FLR_BLKADJ_BLUE		0x0
+#define FLR_BLKADJ_GREEN	0x0
+#define FLR_BLKADJ_RED		0x0
+
+#define DEF_DETECT_CORRECT_VAL	0xe
+
+#define PREV_MIN_WIDTH		64
+#define PREV_MIN_HEIGHT		8
+#define PREV_MAX_HEIGHT		16384
+
+/*
+ * Coeficient Tables for the submodules in Preview.
+ * Array is initialised with the values from.the tables text file.
+ */
+
+/*
+ * CFA Filter Coefficient Table
+ *
+ */
+static u32 cfa_coef_table[] = {
+#include "cfa_coef_table.h"
+};
+
+/*
+ * Default Gamma Correction Table - All components
+ */
+static u32 gamma_table[] = {
+#include "gamma_table.h"
+};
+
+/*
+ * Noise Filter Threshold table
+ */
+static u32 noise_filter_table[] = {
+#include "noise_filter_table.h"
+};
+
+/*
+ * Luminance Enhancement Table
+ */
+static u32 luma_enhance_table[] = {
+#include "luma_enhance_table.h"
+};
+
+/*
+ * preview_enable_invalaw - Enable/Disable Inverse A-Law module in Preview.
+ * @enable: 1 - Reverse the A-Law done in CCDC.
+ */
+static void
+preview_enable_invalaw(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_WIDTH | ISPPRV_PCR_INVALAW);
+}
+
+/*
+ * preview_enable_drkframe_capture - Enable/Disable of the darkframe capture.
+ * @prev -
+ * @enable: 1 - Enable, 0 - Disable
+ *
+ * NOTE: PRV_WSDR_ADDR and PRV_WADD_OFFSET must be set also
+ * The proccess is applied for each captured frame.
+ */
+static void
+preview_enable_drkframe_capture(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFCAP);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFCAP);
+}
+
+/*
+ * preview_enable_drkframe - Enable/Disable of the darkframe subtract.
+ * @enable: 1 - Acquires memory bandwidth since the pixels in each frame is
+ *          subtracted with the pixels in the current frame.
+ *
+ * The proccess is applied for each captured frame.
+ */
+static void
+preview_enable_drkframe(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DRKFEN);
+}
+
+/*
+ * preview_config_drkf_shadcomp - Configures shift value in shading comp.
+ * @scomp_shtval: 3bit value of shift used in shading compensation.
+ */
+static void
+preview_config_drkf_shadcomp(struct isp_prev_device *prev,
+			     const void *scomp_shtval)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const u32 *shtval = scomp_shtval;
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			ISPPRV_PCR_SCOMP_SFT_MASK,
+			*shtval << ISPPRV_PCR_SCOMP_SFT_SHIFT);
+}
+
+/*
+ * preview_enable_hmed - Enables/Disables of the Horizontal Median Filter.
+ * @enable: 1 - Enables Horizontal Median Filter.
+ */
+static void
+preview_enable_hmed(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_HMEDEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_HMEDEN);
+}
+
+/*
+ * preview_config_hmed - Configures the Horizontal Median Filter.
+ * @prev_hmed: Structure containing the odd and even distance between the
+ *             pixels in the image along with the filter threshold.
+ */
+static void
+preview_config_hmed(struct isp_prev_device *prev, const void *prev_hmed)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_hmed *hmed = prev_hmed;
+
+	isp_reg_writel(isp, (hmed->odddist == 1 ? 0 : ISPPRV_HMED_ODDDIST) |
+		       (hmed->evendist == 1 ? 0 : ISPPRV_HMED_EVENDIST) |
+		       (hmed->thres << ISPPRV_HMED_THRESHOLD_SHIFT),
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_HMED);
+}
+
+/*
+ * preview_config_noisefilter - Configures the Noise Filter.
+ * @prev_nf: Structure containing the noisefilter table, strength to be used
+ *           for the noise filter and the defect correction enable flag.
+ */
+static void
+preview_config_noisefilter(struct isp_prev_device *prev, const void *prev_nf)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_nf *nf = prev_nf;
+	unsigned int i;
+
+	isp_reg_writel(isp, nf->spread, OMAP3_ISP_IOMEM_PREV, ISPPRV_NF);
+	isp_reg_writel(isp, ISPPRV_NF_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_NF_TBL_SIZE; i++) {
+		isp_reg_writel(isp, nf->table[i],
+			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
+	}
+}
+
+/*
+ * preview_config_dcor - Configures the defect correction
+ * @prev_dcor: Structure containing the defect correct thresholds
+ */
+static void
+preview_config_dcor(struct isp_prev_device *prev, const void *prev_dcor)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_dcor *dcor = prev_dcor;
+
+	isp_reg_writel(isp, dcor->detect_correct[0],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR0);
+	isp_reg_writel(isp, dcor->detect_correct[1],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR1);
+	isp_reg_writel(isp, dcor->detect_correct[2],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR2);
+	isp_reg_writel(isp, dcor->detect_correct[3],
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CDC_THR3);
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			ISPPRV_PCR_DCCOUP,
+			dcor->couplet_mode_en ? ISPPRV_PCR_DCCOUP : 0);
+}
+
+/*
+ * preview_config_cfa - Configures the CFA Interpolation parameters.
+ * @prev_cfa: Structure containing the CFA interpolation table, CFA format
+ *            in the image, vertical and horizontal gradient threshold.
+ */
+static void
+preview_config_cfa(struct isp_prev_device *prev, const void *prev_cfa)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_cfa *cfa = prev_cfa;
+	unsigned int i;
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			ISPPRV_PCR_CFAFMT_MASK,
+			cfa->format << ISPPRV_PCR_CFAFMT_SHIFT);
+
+	isp_reg_writel(isp,
+		(cfa->gradthrs_vert << ISPPRV_CFA_GRADTH_VER_SHIFT) |
+		(cfa->gradthrs_horz << ISPPRV_CFA_GRADTH_HOR_SHIFT),
+		OMAP3_ISP_IOMEM_PREV, ISPPRV_CFA);
+
+	isp_reg_writel(isp, ISPPRV_CFA_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+
+	for (i = 0; i < OMAP3ISP_PREV_CFA_TBL_SIZE; i++) {
+		isp_reg_writel(isp, cfa->table[i],
+			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
+	}
+}
+
+/*
+ * preview_config_gammacorrn - Configures the Gamma Correction table values
+ * @gtable: Structure containing the table for red, blue, green gamma table.
+ */
+static void
+preview_config_gammacorrn(struct isp_prev_device *prev, const void *gtable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_gtables *gt = gtable;
+	unsigned int i;
+
+	isp_reg_writel(isp, ISPPRV_REDGAMMA_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
+		isp_reg_writel(isp, gt->red[i], OMAP3_ISP_IOMEM_PREV,
+			       ISPPRV_SET_TBL_DATA);
+
+	isp_reg_writel(isp, ISPPRV_GREENGAMMA_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
+		isp_reg_writel(isp, gt->green[i], OMAP3_ISP_IOMEM_PREV,
+			       ISPPRV_SET_TBL_DATA);
+
+	isp_reg_writel(isp, ISPPRV_BLUEGAMMA_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_GAMMA_TBL_SIZE; i++)
+		isp_reg_writel(isp, gt->blue[i], OMAP3_ISP_IOMEM_PREV,
+			       ISPPRV_SET_TBL_DATA);
+}
+
+/*
+ * preview_config_luma_enhancement - Sets the Luminance Enhancement table.
+ * @ytable: Structure containing the table for Luminance Enhancement table.
+ */
+static void
+preview_config_luma_enhancement(struct isp_prev_device *prev,
+				const void *ytable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_luma *yt = ytable;
+	unsigned int i;
+
+	isp_reg_writel(isp, ISPPRV_YENH_TABLE_ADDR,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_ADDR);
+	for (i = 0; i < OMAP3ISP_PREV_YENH_TBL_SIZE; i++) {
+		isp_reg_writel(isp, yt->table[i],
+			       OMAP3_ISP_IOMEM_PREV, ISPPRV_SET_TBL_DATA);
+	}
+}
+
+/*
+ * preview_config_chroma_suppression - Configures the Chroma Suppression.
+ * @csup: Structure containing the threshold value for suppression
+ *        and the hypass filter enable flag.
+ */
+static void
+preview_config_chroma_suppression(struct isp_prev_device *prev,
+				  const void *csup)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_csup *cs = csup;
+
+	isp_reg_writel(isp,
+		       cs->gain | (cs->thres << ISPPRV_CSUP_THRES_SHIFT) |
+		       (cs->hypf_en << ISPPRV_CSUP_HPYF_SHIFT),
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_CSUP);
+}
+
+/*
+ * preview_enable_noisefilter - Enables/Disables the Noise Filter.
+ * @enable: 1 - Enables the Noise Filter.
+ */
+static void
+preview_enable_noisefilter(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_NFEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_NFEN);
+}
+
+/*
+ * preview_enable_dcor - Enables/Disables the defect correction.
+ * @enable: 1 - Enables the defect correction.
+ */
+static void
+preview_enable_dcor(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DCOREN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_DCOREN);
+}
+
+/*
+ * preview_enable_cfa - Enable/Disable the CFA Interpolation.
+ * @enable: 1 - Enables the CFA.
+ */
+static void
+preview_enable_cfa(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_CFAEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_CFAEN);
+}
+
+/*
+ * preview_enable_gammabypass - Enables/Disables the GammaByPass
+ * @enable: 1 - Bypasses Gamma - 10bit input is cropped to 8MSB.
+ *          0 - Goes through Gamma Correction. input and output is 10bit.
+ */
+static void
+preview_enable_gammabypass(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_GAMMA_BYPASS);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_GAMMA_BYPASS);
+}
+
+/*
+ * preview_enable_luma_enhancement - Enables/Disables Luminance Enhancement
+ * @enable: 1 - Enable the Luminance Enhancement.
+ */
+static void
+preview_enable_luma_enhancement(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_YNENHEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_YNENHEN);
+}
+
+/*
+ * preview_enable_chroma_suppression - Enables/Disables Chrominance Suppr.
+ * @enable: 1 - Enable the Chrominance Suppression.
+ */
+static void
+preview_enable_chroma_suppression(struct isp_prev_device *prev, u8 enable)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	if (enable)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_SUPEN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_SUPEN);
+}
+
+/*
+ * preview_config_whitebalance - Configures the White Balance parameters.
+ * @prev_wbal: Structure containing the digital gain and white balance
+ *             coefficient.
+ *
+ * Coefficient matrix always with default values.
+ */
+static void
+preview_config_whitebalance(struct isp_prev_device *prev, const void *prev_wbal)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_wbal *wbal = prev_wbal;
+	u32 val;
+
+	isp_reg_writel(isp, wbal->dgain, OMAP3_ISP_IOMEM_PREV, ISPPRV_WB_DGAIN);
+
+	val = wbal->coef0 << ISPPRV_WBGAIN_COEF0_SHIFT;
+	val |= wbal->coef1 << ISPPRV_WBGAIN_COEF1_SHIFT;
+	val |= wbal->coef2 << ISPPRV_WBGAIN_COEF2_SHIFT;
+	val |= wbal->coef3 << ISPPRV_WBGAIN_COEF3_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_WBGAIN);
+
+	isp_reg_writel(isp,
+		       ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N0_0_SHIFT |
+		       ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N0_1_SHIFT |
+		       ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N0_2_SHIFT |
+		       ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N0_3_SHIFT |
+		       ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N1_0_SHIFT |
+		       ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N1_1_SHIFT |
+		       ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N1_2_SHIFT |
+		       ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N1_3_SHIFT |
+		       ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N2_0_SHIFT |
+		       ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N2_1_SHIFT |
+		       ISPPRV_WBSEL_COEF0 << ISPPRV_WBSEL_N2_2_SHIFT |
+		       ISPPRV_WBSEL_COEF1 << ISPPRV_WBSEL_N2_3_SHIFT |
+		       ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N3_0_SHIFT |
+		       ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N3_1_SHIFT |
+		       ISPPRV_WBSEL_COEF2 << ISPPRV_WBSEL_N3_2_SHIFT |
+		       ISPPRV_WBSEL_COEF3 << ISPPRV_WBSEL_N3_3_SHIFT,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_WBSEL);
+}
+
+/*
+ * preview_config_blkadj - Configures the Black Adjustment parameters.
+ * @prev_blkadj: Structure containing the black adjustment towards red, green,
+ *               blue.
+ */
+static void
+preview_config_blkadj(struct isp_prev_device *prev, const void *prev_blkadj)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_blkadj *blkadj = prev_blkadj;
+
+	isp_reg_writel(isp, (blkadj->blue << ISPPRV_BLKADJOFF_B_SHIFT) |
+		       (blkadj->green << ISPPRV_BLKADJOFF_G_SHIFT) |
+		       (blkadj->red << ISPPRV_BLKADJOFF_R_SHIFT),
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_BLKADJOFF);
+}
+
+/*
+ * preview_config_rgb_blending - Configures the RGB-RGB Blending matrix.
+ * @rgb2rgb: Structure containing the rgb to rgb blending matrix and the rgb
+ *           offset.
+ */
+static void
+preview_config_rgb_blending(struct isp_prev_device *prev, const void *rgb2rgb)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_rgbtorgb *rgbrgb = rgb2rgb;
+	u32 val;
+
+	val = (rgbrgb->matrix[0][0] & 0xfff) << ISPPRV_RGB_MAT1_MTX_RR_SHIFT;
+	val |= (rgbrgb->matrix[0][1] & 0xfff) << ISPPRV_RGB_MAT1_MTX_GR_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT1);
+
+	val = (rgbrgb->matrix[0][2] & 0xfff) << ISPPRV_RGB_MAT2_MTX_BR_SHIFT;
+	val |= (rgbrgb->matrix[1][0] & 0xfff) << ISPPRV_RGB_MAT2_MTX_RG_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT2);
+
+	val = (rgbrgb->matrix[1][1] & 0xfff) << ISPPRV_RGB_MAT3_MTX_GG_SHIFT;
+	val |= (rgbrgb->matrix[1][2] & 0xfff) << ISPPRV_RGB_MAT3_MTX_BG_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT3);
+
+	val = (rgbrgb->matrix[2][0] & 0xfff) << ISPPRV_RGB_MAT4_MTX_RB_SHIFT;
+	val |= (rgbrgb->matrix[2][1] & 0xfff) << ISPPRV_RGB_MAT4_MTX_GB_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT4);
+
+	val = (rgbrgb->matrix[2][2] & 0xfff) << ISPPRV_RGB_MAT5_MTX_BB_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_MAT5);
+
+	val = (rgbrgb->offset[0] & 0x3ff) << ISPPRV_RGB_OFF1_MTX_OFFR_SHIFT;
+	val |= (rgbrgb->offset[1] & 0x3ff) << ISPPRV_RGB_OFF1_MTX_OFFG_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_OFF1);
+
+	val = (rgbrgb->offset[2] & 0x3ff) << ISPPRV_RGB_OFF2_MTX_OFFB_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_RGB_OFF2);
+}
+
+/*
+ * Configures the RGB-YCbYCr conversion matrix
+ * @prev_csc: Structure containing the RGB to YCbYCr matrix and the
+ *            YCbCr offset.
+ */
+static void
+preview_config_rgb_to_ycbcr(struct isp_prev_device *prev, const void *prev_csc)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_csc *csc = prev_csc;
+	u32 val;
+
+	val = (csc->matrix[0][0] & 0x3ff) << ISPPRV_CSC0_RY_SHIFT;
+	val |= (csc->matrix[0][1] & 0x3ff) << ISPPRV_CSC0_GY_SHIFT;
+	val |= (csc->matrix[0][2] & 0x3ff) << ISPPRV_CSC0_BY_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC0);
+
+	val = (csc->matrix[1][0] & 0x3ff) << ISPPRV_CSC1_RCB_SHIFT;
+	val |= (csc->matrix[1][1] & 0x3ff) << ISPPRV_CSC1_GCB_SHIFT;
+	val |= (csc->matrix[1][2] & 0x3ff) << ISPPRV_CSC1_BCB_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC1);
+
+	val = (csc->matrix[2][0] & 0x3ff) << ISPPRV_CSC2_RCR_SHIFT;
+	val |= (csc->matrix[2][1] & 0x3ff) << ISPPRV_CSC2_GCR_SHIFT;
+	val |= (csc->matrix[2][2] & 0x3ff) << ISPPRV_CSC2_BCR_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC2);
+
+	val = (csc->offset[0] & 0xff) << ISPPRV_CSC_OFFSET_Y_SHIFT;
+	val |= (csc->offset[1] & 0xff) << ISPPRV_CSC_OFFSET_CB_SHIFT;
+	val |= (csc->offset[2] & 0xff) << ISPPRV_CSC_OFFSET_CR_SHIFT;
+	isp_reg_writel(isp, val, OMAP3_ISP_IOMEM_PREV, ISPPRV_CSC_OFFSET);
+}
+
+/*
+ * preview_update_contrast - Updates the contrast.
+ * @contrast: Pointer to hold the current programmed contrast value.
+ *
+ * Value should be programmed before enabling the module.
+ */
+static void
+preview_update_contrast(struct isp_prev_device *prev, u8 contrast)
+{
+	struct prev_params *params = &prev->params;
+
+	if (params->contrast != (contrast * ISPPRV_CONTRAST_UNITS)) {
+		params->contrast = contrast * ISPPRV_CONTRAST_UNITS;
+		prev->update |= PREV_CONTRAST;
+	}
+}
+
+/*
+ * preview_config_contrast - Configures the Contrast.
+ * @params: Contrast value (u8 pointer, U8Q0 format).
+ *
+ * Value should be programmed before enabling the module.
+ */
+static void
+preview_config_contrast(struct isp_prev_device *prev, const void *params)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_CNT_BRT,
+			0xff << ISPPRV_CNT_BRT_CNT_SHIFT,
+			*(u8 *)params << ISPPRV_CNT_BRT_CNT_SHIFT);
+}
+
+/*
+ * preview_update_brightness - Updates the brightness in preview module.
+ * @brightness: Pointer to hold the current programmed brightness value.
+ *
+ */
+static void
+preview_update_brightness(struct isp_prev_device *prev, u8 brightness)
+{
+	struct prev_params *params = &prev->params;
+
+	if (params->brightness != (brightness * ISPPRV_BRIGHT_UNITS)) {
+		params->brightness = brightness * ISPPRV_BRIGHT_UNITS;
+		prev->update |= PREV_BRIGHTNESS;
+	}
+}
+
+/*
+ * preview_config_brightness - Configures the brightness.
+ * @params: Brightness value (u8 pointer, U8Q0 format).
+ */
+static void
+preview_config_brightness(struct isp_prev_device *prev, const void *params)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_CNT_BRT,
+			0xff << ISPPRV_CNT_BRT_BRT_SHIFT,
+			*(u8 *)params << ISPPRV_CNT_BRT_BRT_SHIFT);
+}
+
+/*
+ * preview_config_yc_range - Configures the max and min Y and C values.
+ * @yclimit: Structure containing the range of Y and C values.
+ */
+static void
+preview_config_yc_range(struct isp_prev_device *prev, const void *yclimit)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	const struct omap3isp_prev_yclimit *yc = yclimit;
+
+	isp_reg_writel(isp,
+		       yc->maxC << ISPPRV_SETUP_YC_MAXC_SHIFT |
+		       yc->maxY << ISPPRV_SETUP_YC_MAXY_SHIFT |
+		       yc->minC << ISPPRV_SETUP_YC_MINC_SHIFT |
+		       yc->minY << ISPPRV_SETUP_YC_MINY_SHIFT,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_SETUP_YC);
+}
+
+/* preview parameters update structure */
+struct preview_update {
+	int cfg_bit;
+	int feature_bit;
+	void (*config)(struct isp_prev_device *, const void *);
+	void (*enable)(struct isp_prev_device *, u8);
+};
+
+static struct preview_update update_attrs[] = {
+	{OMAP3ISP_PREV_LUMAENH, PREV_LUMA_ENHANCE,
+		preview_config_luma_enhancement,
+		preview_enable_luma_enhancement},
+	{OMAP3ISP_PREV_INVALAW, PREV_INVERSE_ALAW,
+		NULL,
+		preview_enable_invalaw},
+	{OMAP3ISP_PREV_HRZ_MED, PREV_HORZ_MEDIAN_FILTER,
+		preview_config_hmed,
+		preview_enable_hmed},
+	{OMAP3ISP_PREV_CFA, PREV_CFA,
+		preview_config_cfa,
+		preview_enable_cfa},
+	{OMAP3ISP_PREV_CHROMA_SUPP, PREV_CHROMA_SUPPRESS,
+		preview_config_chroma_suppression,
+		preview_enable_chroma_suppression},
+	{OMAP3ISP_PREV_WB, PREV_WB,
+		preview_config_whitebalance,
+		NULL},
+	{OMAP3ISP_PREV_BLKADJ, PREV_BLKADJ,
+		preview_config_blkadj,
+		NULL},
+	{OMAP3ISP_PREV_RGB2RGB, PREV_RGB2RGB,
+		preview_config_rgb_blending,
+		NULL},
+	{OMAP3ISP_PREV_COLOR_CONV, PREV_COLOR_CONV,
+		preview_config_rgb_to_ycbcr,
+		NULL},
+	{OMAP3ISP_PREV_YC_LIMIT, PREV_YCLIMITS,
+		preview_config_yc_range,
+		NULL},
+	{OMAP3ISP_PREV_DEFECT_COR, PREV_DEFECT_COR,
+		preview_config_dcor,
+		preview_enable_dcor},
+	{OMAP3ISP_PREV_GAMMABYPASS, PREV_GAMMA_BYPASS,
+		NULL,
+		preview_enable_gammabypass},
+	{OMAP3ISP_PREV_DRK_FRM_CAPTURE, PREV_DARK_FRAME_CAPTURE,
+		NULL,
+		preview_enable_drkframe_capture},
+	{OMAP3ISP_PREV_DRK_FRM_SUBTRACT, PREV_DARK_FRAME_SUBTRACT,
+		NULL,
+		preview_enable_drkframe},
+	{OMAP3ISP_PREV_LENS_SHADING, PREV_LENS_SHADING,
+		preview_config_drkf_shadcomp,
+		preview_enable_drkframe},
+	{OMAP3ISP_PREV_NF, PREV_NOISE_FILTER,
+		preview_config_noisefilter,
+		preview_enable_noisefilter},
+	{OMAP3ISP_PREV_GAMMA, PREV_GAMMA,
+		preview_config_gammacorrn,
+		NULL},
+	{-1, PREV_CONTRAST,
+		preview_config_contrast,
+		NULL},
+	{-1, PREV_BRIGHTNESS,
+		preview_config_brightness,
+		NULL},
+};
+
+/*
+ * __preview_get_ptrs - helper function which return pointers to members
+ *                         of params and config structures.
+ * @params - pointer to preview_params structure.
+ * @param - return pointer to appropriate structure field.
+ * @configs - pointer to update config structure.
+ * @config - return pointer to appropriate structure field.
+ * @bit - for which feature to return pointers.
+ * Return size of coresponding prev_params member
+ */
+static u32
+__preview_get_ptrs(struct prev_params *params, void **param,
+		   struct omap3isp_prev_update_config *configs,
+		   void __user **config, u32 bit)
+{
+#define CHKARG(cfgs, cfg, field)				\
+	if (cfgs && cfg) {					\
+		*(cfg) = (cfgs)->field;				\
+	}
+
+	switch (bit) {
+	case PREV_HORZ_MEDIAN_FILTER:
+		*param = &params->hmed;
+		CHKARG(configs, config, hmed)
+		return sizeof(params->hmed);
+	case PREV_NOISE_FILTER:
+		*param = &params->nf;
+		CHKARG(configs, config, nf)
+		return sizeof(params->nf);
+		break;
+	case PREV_CFA:
+		*param = &params->cfa;
+		CHKARG(configs, config, cfa)
+		return sizeof(params->cfa);
+	case PREV_LUMA_ENHANCE:
+		*param = &params->luma;
+		CHKARG(configs, config, luma)
+		return sizeof(params->luma);
+	case PREV_CHROMA_SUPPRESS:
+		*param = &params->csup;
+		CHKARG(configs, config, csup)
+		return sizeof(params->csup);
+	case PREV_DEFECT_COR:
+		*param = &params->dcor;
+		CHKARG(configs, config, dcor)
+		return sizeof(params->dcor);
+	case PREV_BLKADJ:
+		*param = &params->blk_adj;
+		CHKARG(configs, config, blkadj)
+		return sizeof(params->blk_adj);
+	case PREV_YCLIMITS:
+		*param = &params->yclimit;
+		CHKARG(configs, config, yclimit)
+		return sizeof(params->yclimit);
+	case PREV_RGB2RGB:
+		*param = &params->rgb2rgb;
+		CHKARG(configs, config, rgb2rgb)
+		return sizeof(params->rgb2rgb);
+	case PREV_COLOR_CONV:
+		*param = &params->rgb2ycbcr;
+		CHKARG(configs, config, csc)
+		return sizeof(params->rgb2ycbcr);
+	case PREV_WB:
+		*param = &params->wbal;
+		CHKARG(configs, config, wbal)
+		return sizeof(params->wbal);
+	case PREV_GAMMA:
+		*param = &params->gamma;
+		CHKARG(configs, config, gamma)
+		return sizeof(params->gamma);
+	case PREV_CONTRAST:
+		*param = &params->contrast;
+		return 0;
+	case PREV_BRIGHTNESS:
+		*param = &params->brightness;
+		return 0;
+	default:
+		*param = NULL;
+		*config = NULL;
+		break;
+	}
+	return 0;
+}
+
+/*
+ * preview_config - Copy and update local structure with userspace preview
+ *                  configuration.
+ * @prev: ISP preview engine
+ * @cfg: Configuration
+ *
+ * Return zero if success or -EFAULT if the configuration can't be copied from
+ * userspace.
+ */
+static int preview_config(struct isp_prev_device *prev,
+			  struct omap3isp_prev_update_config *cfg)
+{
+	struct prev_params *params;
+	struct preview_update *attr;
+	int i, bit, rval = 0;
+
+	params = &prev->params;
+
+	if (prev->state != ISP_PIPELINE_STREAM_STOPPED) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&prev->lock, flags);
+		prev->shadow_update = 1;
+		spin_unlock_irqrestore(&prev->lock, flags);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
+		attr = &update_attrs[i];
+		bit = 0;
+
+		if (!(cfg->update & attr->cfg_bit))
+			continue;
+
+		bit = cfg->flag & attr->cfg_bit;
+		if (bit) {
+			void *to = NULL, __user *from = NULL;
+			unsigned long sz = 0;
+
+			sz = __preview_get_ptrs(params, &to, cfg, &from,
+						   bit);
+			if (to && from && sz) {
+				if (copy_from_user(to, from, sz)) {
+					rval = -EFAULT;
+					break;
+				}
+			}
+			params->features |= attr->feature_bit;
+		} else {
+			params->features &= ~attr->feature_bit;
+		}
+
+		prev->update |= attr->feature_bit;
+	}
+
+	prev->shadow_update = 0;
+	return rval;
+}
+
+/*
+ * preview_setup_hw - Setup preview registers and/or internal memory
+ * @prev: pointer to preview private structure
+ * Note: can be called from interrupt context
+ * Return none
+ */
+static void preview_setup_hw(struct isp_prev_device *prev)
+{
+	struct prev_params *params = &prev->params;
+	struct preview_update *attr;
+	int i, bit;
+	void *param_ptr;
+
+	for (i = 0; i < ARRAY_SIZE(update_attrs); i++) {
+		attr = &update_attrs[i];
+
+		if (!(prev->update & attr->feature_bit))
+			continue;
+		bit = params->features & attr->feature_bit;
+		if (bit) {
+			if (attr->config) {
+				__preview_get_ptrs(params, &param_ptr, NULL,
+						      NULL, bit);
+				attr->config(prev, param_ptr);
+			}
+			if (attr->enable)
+				attr->enable(prev, 1);
+		} else
+			if (attr->enable)
+				attr->enable(prev, 0);
+
+		prev->update &= ~attr->feature_bit;
+	}
+}
+
+/*
+ * preview_config_ycpos - Configure byte layout of YUV image.
+ * @mode: Indicates the required byte layout.
+ */
+static void
+preview_config_ycpos(struct isp_prev_device *prev,
+		     enum v4l2_mbus_pixelcode pixelcode)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	enum preview_ycpos_mode mode;
+
+	switch (pixelcode) {
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		mode = YCPOS_CrYCbY;
+		break;
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+		mode = YCPOS_YCrYCb;
+		break;
+	default:
+		return;
+	}
+
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			ISPPRV_PCR_YCPOS_CrYCbY,
+			mode << ISPPRV_PCR_YCPOS_SHIFT);
+}
+
+/*
+ * preview_config_averager - Enable / disable / configure averager
+ * @average: Average value to be configured.
+ */
+static void preview_config_averager(struct isp_prev_device *prev, u8 average)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	int reg = 0;
+
+	if (prev->params.cfa.format == OMAP3ISP_CFAFMT_BAYER)
+		reg = ISPPRV_AVE_EVENDIST_2 << ISPPRV_AVE_EVENDIST_SHIFT |
+		      ISPPRV_AVE_ODDDIST_2 << ISPPRV_AVE_ODDDIST_SHIFT |
+		      average;
+	else if (prev->params.cfa.format == OMAP3ISP_CFAFMT_RGBFOVEON)
+		reg = ISPPRV_AVE_EVENDIST_3 << ISPPRV_AVE_EVENDIST_SHIFT |
+		      ISPPRV_AVE_ODDDIST_3 << ISPPRV_AVE_ODDDIST_SHIFT |
+		      average;
+	isp_reg_writel(isp, reg, OMAP3_ISP_IOMEM_PREV, ISPPRV_AVE);
+}
+
+/*
+ * preview_config_input_size - Configure the input frame size
+ *
+ * The preview engine crops several rows and columns internally depending on
+ * which processing blocks are enabled. The driver assumes all those blocks are
+ * enabled when reporting source pad formats to userspace. If this assumption is
+ * not true, rows and columns must be manually cropped at the preview engine
+ * input to avoid overflows at the end of lines and frames.
+ */
+static void preview_config_input_size(struct isp_prev_device *prev)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	struct prev_params *params = &prev->params;
+	struct v4l2_mbus_framefmt *format = &prev->formats[PREV_PAD_SINK];
+	unsigned int sph = 0;
+	unsigned int eph = format->width - 1;
+	unsigned int slv = 0;
+	unsigned int elv = format->height - 1;
+
+	if (prev->input == PREVIEW_INPUT_CCDC) {
+		sph += 2;
+		eph -= 2;
+	}
+
+	/*
+	 * Median filter	4 pixels
+	 * Noise filter		4 pixels, 4 lines
+	 * or faulty pixels correction
+	 * CFA filter		4 pixels, 4 lines in Bayer mode
+	 *				  2 lines in other modes
+	 * Color suppression	2 pixels
+	 * or luma enhancement
+	 * -------------------------------------------------------------
+	 * Maximum total	14 pixels, 8 lines
+	 */
+
+	if (!(params->features & PREV_CFA)) {
+		sph += 2;
+		eph -= 2;
+		slv += 2;
+		elv -= 2;
+	}
+	if (!(params->features & (PREV_DEFECT_COR | PREV_NOISE_FILTER))) {
+		sph += 2;
+		eph -= 2;
+		slv += 2;
+		elv -= 2;
+	}
+	if (!(params->features & PREV_HORZ_MEDIAN_FILTER)) {
+		sph += 2;
+		eph -= 2;
+	}
+	if (!(params->features & (PREV_CHROMA_SUPPRESS | PREV_LUMA_ENHANCE)))
+		sph += 2;
+
+	isp_reg_writel(isp, (sph << ISPPRV_HORZ_INFO_SPH_SHIFT) | eph,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_HORZ_INFO);
+	isp_reg_writel(isp, (slv << ISPPRV_VERT_INFO_SLV_SHIFT) | elv,
+		       OMAP3_ISP_IOMEM_PREV, ISPPRV_VERT_INFO);
+}
+
+/*
+ * preview_config_inlineoffset - Configures the Read address line offset.
+ * @prev: Preview module
+ * @offset: Line offset
+ *
+ * According to the TRM, the line offset must be aligned on a 32 bytes boundary.
+ * However, a hardware bug requires the memory start address to be aligned on a
+ * 64 bytes boundary, so the offset probably should be aligned on 64 bytes as
+ * well.
+ */
+static void
+preview_config_inlineoffset(struct isp_prev_device *prev, u32 offset)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	isp_reg_writel(isp, offset & 0xffff, OMAP3_ISP_IOMEM_PREV,
+		       ISPPRV_RADR_OFFSET);
+}
+
+/*
+ * preview_set_inaddr - Sets memory address of input frame.
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ *
+ * Configures the memory address from which the input frame is to be read.
+ */
+static void preview_set_inaddr(struct isp_prev_device *prev, u32 addr)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	isp_reg_writel(isp, addr, OMAP3_ISP_IOMEM_PREV, ISPPRV_RSDR_ADDR);
+}
+
+/*
+ * preview_config_outlineoffset - Configures the Write address line offset.
+ * @offset: Line Offset for the preview output.
+ *
+ * The offset must be a multiple of 32 bytes.
+ */
+static void preview_config_outlineoffset(struct isp_prev_device *prev,
+				    u32 offset)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	isp_reg_writel(isp, offset & 0xffff, OMAP3_ISP_IOMEM_PREV,
+		       ISPPRV_WADD_OFFSET);
+}
+
+/*
+ * preview_set_outaddr - Sets the memory address to store output frame
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ *
+ * Configures the memory address to which the output frame is written.
+ */
+static void preview_set_outaddr(struct isp_prev_device *prev, u32 addr)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	isp_reg_writel(isp, addr, OMAP3_ISP_IOMEM_PREV, ISPPRV_WSDR_ADDR);
+}
+
+static void preview_adjust_bandwidth(struct isp_prev_device *prev)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&prev->subdev.entity);
+	struct isp_device *isp = to_isp_device(prev);
+	const struct v4l2_mbus_framefmt *ifmt = &prev->formats[PREV_PAD_SINK];
+	unsigned long l3_ick = pipe->l3_ick;
+	struct v4l2_fract *timeperframe;
+	unsigned int cycles_per_frame;
+	unsigned int requests_per_frame;
+	unsigned int cycles_per_request;
+	unsigned int minimum;
+	unsigned int maximum;
+	unsigned int value;
+
+	if (prev->input != PREVIEW_INPUT_MEMORY) {
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_SDR_REQ_EXP,
+			    ISPSBL_SDR_REQ_PRV_EXP_MASK);
+		return;
+	}
+
+	/* Compute the minimum number of cycles per request, based on the
+	 * pipeline maximum data rate. This is an absolute lower bound if we
+	 * don't want SBL overflows, so round the value up.
+	 */
+	cycles_per_request = div_u64((u64)l3_ick / 2 * 256 + pipe->max_rate - 1,
+				     pipe->max_rate);
+	minimum = DIV_ROUND_UP(cycles_per_request, 32);
+
+	/* Compute the maximum number of cycles per request, based on the
+	 * requested frame rate. This is a soft upper bound to achieve a frame
+	 * rate equal or higher than the requested value, so round the value
+	 * down.
+	 */
+	timeperframe = &pipe->max_timeperframe;
+
+	requests_per_frame = DIV_ROUND_UP(ifmt->width * 2, 256) * ifmt->height;
+	cycles_per_frame = div_u64((u64)l3_ick * timeperframe->numerator,
+				   timeperframe->denominator);
+	cycles_per_request = cycles_per_frame / requests_per_frame;
+
+	maximum = cycles_per_request / 32;
+
+	value = max(minimum, maximum);
+
+	dev_dbg(isp->dev, "%s: cycles per request = %u\n", __func__, value);
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_SDR_REQ_EXP,
+			ISPSBL_SDR_REQ_PRV_EXP_MASK,
+			value << ISPSBL_SDR_REQ_PRV_EXP_SHIFT);
+}
+
+/*
+ * omap3isp_preview_busy - Gets busy state of preview module.
+ */
+int omap3isp_preview_busy(struct isp_prev_device *prev)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	return isp_reg_readl(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR)
+		& ISPPRV_PCR_BUSY;
+}
+
+/*
+ * omap3isp_preview_restore_context - Restores the values of preview registers
+ */
+void omap3isp_preview_restore_context(struct isp_device *isp)
+{
+	isp->isp_prev.update = PREV_FEATURES_END - 1;
+	preview_setup_hw(&isp->isp_prev);
+}
+
+/*
+ * preview_print_status - Dump preview module registers to the kernel log
+ */
+#define PREV_PRINT_REGISTER(isp, name)\
+	dev_dbg(isp->dev, "###PRV " #name "=0x%08x\n", \
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_##name))
+
+static void preview_print_status(struct isp_prev_device *prev)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	dev_dbg(isp->dev, "-------------Preview Register dump----------\n");
+
+	PREV_PRINT_REGISTER(isp, PCR);
+	PREV_PRINT_REGISTER(isp, HORZ_INFO);
+	PREV_PRINT_REGISTER(isp, VERT_INFO);
+	PREV_PRINT_REGISTER(isp, RSDR_ADDR);
+	PREV_PRINT_REGISTER(isp, RADR_OFFSET);
+	PREV_PRINT_REGISTER(isp, DSDR_ADDR);
+	PREV_PRINT_REGISTER(isp, DRKF_OFFSET);
+	PREV_PRINT_REGISTER(isp, WSDR_ADDR);
+	PREV_PRINT_REGISTER(isp, WADD_OFFSET);
+	PREV_PRINT_REGISTER(isp, AVE);
+	PREV_PRINT_REGISTER(isp, HMED);
+	PREV_PRINT_REGISTER(isp, NF);
+	PREV_PRINT_REGISTER(isp, WB_DGAIN);
+	PREV_PRINT_REGISTER(isp, WBGAIN);
+	PREV_PRINT_REGISTER(isp, WBSEL);
+	PREV_PRINT_REGISTER(isp, CFA);
+	PREV_PRINT_REGISTER(isp, BLKADJOFF);
+	PREV_PRINT_REGISTER(isp, RGB_MAT1);
+	PREV_PRINT_REGISTER(isp, RGB_MAT2);
+	PREV_PRINT_REGISTER(isp, RGB_MAT3);
+	PREV_PRINT_REGISTER(isp, RGB_MAT4);
+	PREV_PRINT_REGISTER(isp, RGB_MAT5);
+	PREV_PRINT_REGISTER(isp, RGB_OFF1);
+	PREV_PRINT_REGISTER(isp, RGB_OFF2);
+	PREV_PRINT_REGISTER(isp, CSC0);
+	PREV_PRINT_REGISTER(isp, CSC1);
+	PREV_PRINT_REGISTER(isp, CSC2);
+	PREV_PRINT_REGISTER(isp, CSC_OFFSET);
+	PREV_PRINT_REGISTER(isp, CNT_BRT);
+	PREV_PRINT_REGISTER(isp, CSUP);
+	PREV_PRINT_REGISTER(isp, SETUP_YC);
+	PREV_PRINT_REGISTER(isp, SET_TBL_ADDR);
+	PREV_PRINT_REGISTER(isp, CDC_THR0);
+	PREV_PRINT_REGISTER(isp, CDC_THR1);
+	PREV_PRINT_REGISTER(isp, CDC_THR2);
+	PREV_PRINT_REGISTER(isp, CDC_THR3);
+
+	dev_dbg(isp->dev, "--------------------------------------------\n");
+}
+
+/*
+ * preview_init_params - init image processing parameters.
+ * @prev: pointer to previewer private structure
+ * return none
+ */
+static void preview_init_params(struct isp_prev_device *prev)
+{
+	struct prev_params *params = &prev->params;
+	int i = 0;
+
+	/* Init values */
+	params->contrast = ISPPRV_CONTRAST_DEF * ISPPRV_CONTRAST_UNITS;
+	params->brightness = ISPPRV_BRIGHT_DEF * ISPPRV_BRIGHT_UNITS;
+	params->average = NO_AVE;
+	params->cfa.format = OMAP3ISP_CFAFMT_BAYER;
+	memcpy(params->cfa.table, cfa_coef_table,
+	       sizeof(params->cfa.table));
+	params->cfa.gradthrs_horz = FLR_CFA_GRADTHRS_HORZ;
+	params->cfa.gradthrs_vert = FLR_CFA_GRADTHRS_VERT;
+	params->csup.gain = FLR_CSUP_GAIN;
+	params->csup.thres = FLR_CSUP_THRES;
+	params->csup.hypf_en = 0;
+	memcpy(params->luma.table, luma_enhance_table,
+	       sizeof(params->luma.table));
+	params->nf.spread = FLR_NF_STRGTH;
+	memcpy(params->nf.table, noise_filter_table, sizeof(params->nf.table));
+	params->dcor.couplet_mode_en = 1;
+	for (i = 0; i < OMAP3ISP_PREV_DETECT_CORRECT_CHANNELS; i++)
+		params->dcor.detect_correct[i] = DEF_DETECT_CORRECT_VAL;
+	memcpy(params->gamma.blue, gamma_table, sizeof(params->gamma.blue));
+	memcpy(params->gamma.green, gamma_table, sizeof(params->gamma.green));
+	memcpy(params->gamma.red, gamma_table, sizeof(params->gamma.red));
+	params->wbal.dgain = FLR_WBAL_DGAIN;
+	params->wbal.coef0 = FLR_WBAL_COEF;
+	params->wbal.coef1 = FLR_WBAL_COEF;
+	params->wbal.coef2 = FLR_WBAL_COEF;
+	params->wbal.coef3 = FLR_WBAL_COEF;
+	params->blk_adj.red = FLR_BLKADJ_RED;
+	params->blk_adj.green = FLR_BLKADJ_GREEN;
+	params->blk_adj.blue = FLR_BLKADJ_BLUE;
+	params->rgb2rgb = flr_rgb2rgb;
+	params->rgb2ycbcr = flr_prev_csc;
+	params->yclimit.minC = ISPPRV_YC_MIN;
+	params->yclimit.maxC = ISPPRV_YC_MAX;
+	params->yclimit.minY = ISPPRV_YC_MIN;
+	params->yclimit.maxY = ISPPRV_YC_MAX;
+
+	params->features = PREV_CFA | PREV_DEFECT_COR | PREV_NOISE_FILTER
+			 | PREV_GAMMA | PREV_BLKADJ | PREV_YCLIMITS
+			 | PREV_RGB2RGB | PREV_COLOR_CONV | PREV_WB
+			 | PREV_BRIGHTNESS | PREV_CONTRAST;
+
+	prev->update = PREV_FEATURES_END - 1;
+}
+
+/*
+ * preview_max_out_width - Handle previewer hardware ouput limitations
+ * @isp_revision : ISP revision
+ * returns maximum width output for current isp revision
+ */
+static unsigned int preview_max_out_width(struct isp_prev_device *prev)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	switch (isp->revision) {
+	case ISP_REVISION_1_0:
+		return ISPPRV_MAXOUTPUT_WIDTH;
+
+	case ISP_REVISION_2_0:
+	default:
+		return ISPPRV_MAXOUTPUT_WIDTH_ES2;
+
+	case ISP_REVISION_15_0:
+		return ISPPRV_MAXOUTPUT_WIDTH_3630;
+	}
+}
+
+static void preview_configure(struct isp_prev_device *prev)
+{
+	struct isp_device *isp = to_isp_device(prev);
+	struct v4l2_mbus_framefmt *format;
+	unsigned int max_out_width;
+	unsigned int format_avg;
+
+	preview_setup_hw(prev);
+
+	if (prev->output & PREVIEW_OUTPUT_MEMORY)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_SDRPORT);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_SDRPORT);
+
+	if (prev->output & PREVIEW_OUTPUT_RESIZER)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_RSZPORT);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_RSZPORT);
+
+	/* PREV_PAD_SINK */
+	format = &prev->formats[PREV_PAD_SINK];
+
+	preview_adjust_bandwidth(prev);
+
+	preview_config_input_size(prev);
+
+	if (prev->input == PREVIEW_INPUT_CCDC)
+		preview_config_inlineoffset(prev, 0);
+	else
+		preview_config_inlineoffset(prev,
+				ALIGN(format->width, 0x20) * 2);
+
+	/* PREV_PAD_SOURCE */
+	format = &prev->formats[PREV_PAD_SOURCE];
+
+	if (prev->output & PREVIEW_OUTPUT_MEMORY)
+		preview_config_outlineoffset(prev,
+				ALIGN(format->width, 0x10) * 2);
+
+	max_out_width = preview_max_out_width(prev);
+
+	format_avg = fls(DIV_ROUND_UP(format->width, max_out_width) - 1);
+	preview_config_averager(prev, format_avg);
+	preview_config_ycpos(prev, format->code);
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt handling
+ */
+
+static void preview_enable_oneshot(struct isp_prev_device *prev)
+{
+	struct isp_device *isp = to_isp_device(prev);
+
+	/* The PCR.SOURCE bit is automatically reset to 0 when the PCR.ENABLE
+	 * bit is set. As the preview engine is used in single-shot mode, we
+	 * need to set PCR.SOURCE before enabling the preview engine.
+	 */
+	if (prev->input == PREVIEW_INPUT_MEMORY)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+			    ISPPRV_PCR_SOURCE);
+
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_PREV, ISPPRV_PCR,
+		    ISPPRV_PCR_EN | ISPPRV_PCR_ONESHOT);
+}
+
+void omap3isp_preview_isr_frame_sync(struct isp_prev_device *prev)
+{
+	/*
+	 * If ISP_VIDEO_DMAQUEUE_QUEUED is set, DMA queue had an underrun
+	 * condition, the module was paused and now we have a buffer queued
+	 * on the output again. Restart the pipeline if running in continuous
+	 * mode.
+	 */
+	if (prev->state == ISP_PIPELINE_STREAM_CONTINUOUS &&
+	    prev->video_out.dmaqueue_flags & ISP_VIDEO_DMAQUEUE_QUEUED) {
+		preview_enable_oneshot(prev);
+		isp_video_dmaqueue_flags_clr(&prev->video_out);
+	}
+}
+
+static void preview_isr_buffer(struct isp_prev_device *prev)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&prev->subdev.entity);
+	struct isp_buffer *buffer;
+	int restart = 0;
+
+	if (prev->input == PREVIEW_INPUT_MEMORY) {
+		buffer = omap3isp_video_buffer_next(&prev->video_in,
+						    prev->error);
+		if (buffer != NULL)
+			preview_set_inaddr(prev, buffer->isp_addr);
+		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
+	}
+
+	if (prev->output & PREVIEW_OUTPUT_MEMORY) {
+		buffer = omap3isp_video_buffer_next(&prev->video_out,
+						    prev->error);
+		if (buffer != NULL) {
+			preview_set_outaddr(prev, buffer->isp_addr);
+			restart = 1;
+		}
+		pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
+	}
+
+	switch (prev->state) {
+	case ISP_PIPELINE_STREAM_SINGLESHOT:
+		if (isp_pipeline_ready(pipe))
+			omap3isp_pipeline_set_stream(pipe,
+						ISP_PIPELINE_STREAM_SINGLESHOT);
+		break;
+
+	case ISP_PIPELINE_STREAM_CONTINUOUS:
+		/* If an underrun occurs, the video queue operation handler will
+		 * restart the preview engine. Otherwise restart it immediately.
+		 */
+		if (restart)
+			preview_enable_oneshot(prev);
+		break;
+
+	case ISP_PIPELINE_STREAM_STOPPED:
+	default:
+		return;
+	}
+
+	prev->error = 0;
+}
+
+/*
+ * omap3isp_preview_isr - ISP preview engine interrupt handler
+ *
+ * Manage the preview engine video buffers and configure shadowed registers.
+ */
+void omap3isp_preview_isr(struct isp_prev_device *prev)
+{
+	unsigned long flags;
+
+	if (omap3isp_module_sync_is_stopping(&prev->wait, &prev->stopping))
+		return;
+
+	spin_lock_irqsave(&prev->lock, flags);
+	if (prev->shadow_update)
+		goto done;
+
+	preview_setup_hw(prev);
+	preview_config_input_size(prev);
+
+done:
+	spin_unlock_irqrestore(&prev->lock, flags);
+
+	if (prev->input == PREVIEW_INPUT_MEMORY ||
+	    prev->output & PREVIEW_OUTPUT_MEMORY)
+		preview_isr_buffer(prev);
+	else if (prev->state == ISP_PIPELINE_STREAM_CONTINUOUS)
+		preview_enable_oneshot(prev);
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP video operations
+ */
+
+static int preview_video_queue(struct isp_video *video,
+			       struct isp_buffer *buffer)
+{
+	struct isp_prev_device *prev = &video->isp->isp_prev;
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		preview_set_inaddr(prev, buffer->isp_addr);
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		preview_set_outaddr(prev, buffer->isp_addr);
+
+	return 0;
+}
+
+static const struct isp_video_operations preview_video_ops = {
+	.queue = preview_video_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+/*
+ * preview_s_ctrl - Handle set control subdev method
+ * @ctrl: pointer to v4l2 control structure
+ */
+static int preview_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct isp_prev_device *prev =
+		container_of(ctrl->handler, struct isp_prev_device, ctrls);
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		preview_update_brightness(prev, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		preview_update_contrast(prev, ctrl->val);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops preview_ctrl_ops = {
+	.s_ctrl = preview_s_ctrl,
+};
+
+/*
+ * preview_ioctl - Handle preview module private ioctl's
+ * @prev: pointer to preview context structure
+ * @cmd: configuration command
+ * @arg: configuration argument
+ * return -EINVAL or zero on success
+ */
+static long preview_ioctl(struct v4l2_subdev *sd, unsigned int cmd, void *arg)
+{
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+
+	switch (cmd) {
+	case VIDIOC_OMAP3ISP_PRV_CFG:
+		return preview_config(prev, arg);
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
+/*
+ * preview_set_stream - Enable/Disable streaming on preview subdev
+ * @sd    : pointer to v4l2 subdev structure
+ * @enable: 1 == Enable, 0 == Disable
+ * return -EINVAL or zero on sucess
+ */
+static int preview_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+	struct isp_video *video_out = &prev->video_out;
+	struct isp_device *isp = to_isp_device(prev);
+	struct device *dev = to_device(prev);
+	unsigned long flags;
+
+	if (prev->state == ISP_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISP_PIPELINE_STREAM_STOPPED)
+			return 0;
+
+		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_PREVIEW);
+		preview_configure(prev);
+		atomic_set(&prev->stopping, 0);
+		prev->error = 0;
+		preview_print_status(prev);
+	}
+
+	switch (enable) {
+	case ISP_PIPELINE_STREAM_CONTINUOUS:
+		if (prev->output & PREVIEW_OUTPUT_MEMORY)
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_PREVIEW_WRITE);
+
+		if (video_out->dmaqueue_flags & ISP_VIDEO_DMAQUEUE_QUEUED ||
+		    !(prev->output & PREVIEW_OUTPUT_MEMORY))
+			preview_enable_oneshot(prev);
+
+		isp_video_dmaqueue_flags_clr(video_out);
+		break;
+
+	case ISP_PIPELINE_STREAM_SINGLESHOT:
+		if (prev->input == PREVIEW_INPUT_MEMORY)
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_PREVIEW_READ);
+		if (prev->output & PREVIEW_OUTPUT_MEMORY)
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_PREVIEW_WRITE);
+
+		preview_enable_oneshot(prev);
+		break;
+
+	case ISP_PIPELINE_STREAM_STOPPED:
+		if (omap3isp_module_sync_idle(&sd->entity, &prev->wait,
+					      &prev->stopping))
+			dev_dbg(dev, "%s: stop timeout.\n", sd->name);
+		spin_lock_irqsave(&prev->lock, flags);
+		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_READ);
+		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_PREVIEW_WRITE);
+		omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_PREVIEW);
+		spin_unlock_irqrestore(&prev->lock, flags);
+		isp_video_dmaqueue_flags_clr(video_out);
+		break;
+	}
+
+	prev->state = enable;
+	return 0;
+}
+
+static struct v4l2_mbus_framefmt *
+__preview_get_format(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
+		     unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &prev->formats[pad];
+}
+
+/* previewer format descriptions */
+static const unsigned int preview_input_fmts[] = {
+	V4L2_MBUS_FMT_SGRBG10_1X10,
+	V4L2_MBUS_FMT_SRGGB10_1X10,
+	V4L2_MBUS_FMT_SBGGR10_1X10,
+	V4L2_MBUS_FMT_SGBRG10_1X10,
+};
+
+static const unsigned int preview_output_fmts[] = {
+	V4L2_MBUS_FMT_UYVY8_1X16,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+};
+
+/*
+ * preview_try_format - Handle try format by pad subdev method
+ * @prev: ISP preview device
+ * @fh : V4L2 subdev file handle
+ * @pad: pad num
+ * @fmt: pointer to v4l2 format structure
+ */
+static void preview_try_format(struct isp_prev_device *prev,
+			       struct v4l2_subdev_fh *fh, unsigned int pad,
+			       struct v4l2_mbus_framefmt *fmt,
+			       enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+	unsigned int max_out_width;
+	enum v4l2_mbus_pixelcode pixelcode;
+	unsigned int i;
+
+	max_out_width = preview_max_out_width(prev);
+
+	switch (pad) {
+	case PREV_PAD_SINK:
+		/* When reading data from the CCDC, the input size has already
+		 * been mangled by the CCDC output pad so it can be accepted
+		 * as-is.
+		 *
+		 * When reading data from memory, clamp the requested width and
+		 * height. The TRM doesn't specify a minimum input height, make
+		 * sure we got enough lines to enable the noise filter and color
+		 * filter array interpolation.
+		 */
+		if (prev->input == PREVIEW_INPUT_MEMORY) {
+			fmt->width = clamp_t(u32, fmt->width, PREV_MIN_WIDTH,
+					     max_out_width * 8);
+			fmt->height = clamp_t(u32, fmt->height, PREV_MIN_HEIGHT,
+					      PREV_MAX_HEIGHT);
+		}
+
+		fmt->colorspace = V4L2_COLORSPACE_SRGB;
+
+		for (i = 0; i < ARRAY_SIZE(preview_input_fmts); i++) {
+			if (fmt->code == preview_input_fmts[i])
+				break;
+		}
+
+		/* If not found, use SGRBG10 as default */
+		if (i >= ARRAY_SIZE(preview_input_fmts))
+			fmt->code = V4L2_MBUS_FMT_SGRBG10_1X10;
+		break;
+
+	case PREV_PAD_SOURCE:
+		pixelcode = fmt->code;
+		format = __preview_get_format(prev, fh, PREV_PAD_SINK, which);
+		memcpy(fmt, format, sizeof(*fmt));
+
+		/* The preview module output size is configurable through the
+		 * input interface (horizontal and vertical cropping) and the
+		 * averager (horizontal scaling by 1/1, 1/2, 1/4 or 1/8). In
+		 * spite of this, hardcode the output size to the biggest
+		 * possible value for simplicity reasons.
+		 */
+		switch (pixelcode) {
+		case V4L2_MBUS_FMT_YUYV8_1X16:
+		case V4L2_MBUS_FMT_UYVY8_1X16:
+			fmt->code = pixelcode;
+			break;
+
+		default:
+			fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
+			break;
+		}
+
+		/* The TRM states (12.1.4.7.1.2) that 2 pixels must be cropped
+		 * from the left and right sides when the input source is the
+		 * CCDC. This seems not to be needed in practice, investigation
+		 * is required.
+		 */
+		if (prev->input == PREVIEW_INPUT_CCDC)
+			fmt->width -= 4;
+
+		/* The preview module can output a maximum of 3312 pixels
+		 * horizontally due to fixed memory-line sizes. Compute the
+		 * horizontal averaging factor accordingly. Note that the limit
+		 * applies to the noise filter and CFA interpolation blocks, so
+		 * it doesn't take cropping by further blocks into account.
+		 *
+		 * ES 1.0 hardware revision is limited to 1280 pixels
+		 * horizontally.
+		 */
+		fmt->width >>= fls(DIV_ROUND_UP(fmt->width, max_out_width) - 1);
+
+		/* Assume that all blocks are enabled and crop pixels and lines
+		 * accordingly. See preview_config_input_size() for more
+		 * information.
+		 */
+		fmt->width -= 14;
+		fmt->height -= 8;
+
+		fmt->colorspace = V4L2_COLORSPACE_JPEG;
+		break;
+	}
+
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+/*
+ * preview_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh     : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int preview_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	switch (code->pad) {
+	case PREV_PAD_SINK:
+		if (code->index >= ARRAY_SIZE(preview_input_fmts))
+			return -EINVAL;
+
+		code->code = preview_input_fmts[code->index];
+		break;
+	case PREV_PAD_SOURCE:
+		if (code->index >= ARRAY_SIZE(preview_output_fmts))
+			return -EINVAL;
+
+		code->code = preview_output_fmts[code->index];
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int preview_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	preview_try_format(prev, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	preview_try_format(prev, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * preview_get_format - Handle get format by pads subdev method
+ * @sd : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on sucess
+ */
+static int preview_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __preview_get_format(prev, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * preview_set_format - Handle set format by pads subdev method
+ * @sd : pointer to v4l2 subdev structure
+ * @fh : V4L2 subdev file handle
+ * @fmt: pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on success
+ */
+static int preview_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __preview_get_format(prev, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	preview_try_format(prev, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == PREV_PAD_SINK) {
+		format = __preview_get_format(prev, fh, PREV_PAD_SOURCE,
+					      fmt->which);
+		*format = fmt->format;
+		preview_try_format(prev, fh, PREV_PAD_SOURCE, format,
+				   fmt->which);
+	}
+
+	return 0;
+}
+
+/*
+ * preview_init_formats - Initialize formats on all pads
+ * @sd: ISP preview V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int preview_init_formats(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = PREV_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_SGRBG10_1X10;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	preview_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/* subdev core operations */
+static const struct v4l2_subdev_core_ops preview_v4l2_core_ops = {
+	.ioctl = preview_ioctl,
+};
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops preview_v4l2_video_ops = {
+	.s_stream = preview_set_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops preview_v4l2_pad_ops = {
+	.enum_mbus_code = preview_enum_mbus_code,
+	.enum_frame_size = preview_enum_frame_size,
+	.get_fmt = preview_get_format,
+	.set_fmt = preview_set_format,
+};
+
+/* subdev operations */
+static const struct v4l2_subdev_ops preview_v4l2_ops = {
+	.core = &preview_v4l2_core_ops,
+	.video = &preview_v4l2_video_ops,
+	.pad = &preview_v4l2_pad_ops,
+};
+
+/* subdev internal operations */
+static const struct v4l2_subdev_internal_ops preview_v4l2_internal_ops = {
+	.open = preview_init_formats,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * preview_link_setup - Setup previewer connections.
+ * @entity : Pointer to media entity structure
+ * @local  : Pointer to local pad array
+ * @remote : Pointer to remote pad array
+ * @flags  : Link flags
+ * return -EINVAL or zero on success
+ */
+static int preview_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+			      const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case PREV_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+		/* read from memory */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (prev->input == PREVIEW_INPUT_CCDC)
+				return -EBUSY;
+			prev->input = PREVIEW_INPUT_MEMORY;
+		} else {
+			if (prev->input == PREVIEW_INPUT_MEMORY)
+				prev->input = PREVIEW_INPUT_NONE;
+		}
+		break;
+
+	case PREV_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* read from ccdc */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (prev->input == PREVIEW_INPUT_MEMORY)
+				return -EBUSY;
+			prev->input = PREVIEW_INPUT_CCDC;
+		} else {
+			if (prev->input == PREVIEW_INPUT_CCDC)
+				prev->input = PREVIEW_INPUT_NONE;
+		}
+		break;
+
+	/*
+	 * The ISP core doesn't support pipelines with multiple video outputs.
+	 * Revisit this when it will be implemented, and return -EBUSY for now.
+	 */
+
+	case PREV_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		/* write to memory */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (prev->output & ~PREVIEW_OUTPUT_MEMORY)
+				return -EBUSY;
+			prev->output |= PREVIEW_OUTPUT_MEMORY;
+		} else {
+			prev->output &= ~PREVIEW_OUTPUT_MEMORY;
+		}
+		break;
+
+	case PREV_PAD_SOURCE | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* write to resizer */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (prev->output & ~PREVIEW_OUTPUT_RESIZER)
+				return -EBUSY;
+			prev->output |= PREVIEW_OUTPUT_RESIZER;
+		} else {
+			prev->output &= ~PREVIEW_OUTPUT_RESIZER;
+		}
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations preview_media_ops = {
+	.link_setup = preview_link_setup,
+};
+
+/*
+ * review_init_entities - Initialize subdev and media entity.
+ * @prev : Pointer to preview structure
+ * return -ENOMEM or zero on success
+ */
+static int preview_init_entities(struct isp_prev_device *prev)
+{
+	struct v4l2_subdev *sd = &prev->subdev;
+	struct media_pad *pads = prev->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	prev->input = PREVIEW_INPUT_NONE;
+
+	v4l2_subdev_init(sd, &preview_v4l2_ops);
+	sd->internal_ops = &preview_v4l2_internal_ops;
+	strlcpy(sd->name, "OMAP3 ISP preview", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
+	v4l2_set_subdevdata(sd, prev);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	v4l2_ctrl_handler_init(&prev->ctrls, 2);
+	v4l2_ctrl_new_std(&prev->ctrls, &preview_ctrl_ops, V4L2_CID_BRIGHTNESS,
+			  ISPPRV_BRIGHT_LOW, ISPPRV_BRIGHT_HIGH,
+			  ISPPRV_BRIGHT_STEP, ISPPRV_BRIGHT_DEF);
+	v4l2_ctrl_new_std(&prev->ctrls, &preview_ctrl_ops, V4L2_CID_CONTRAST,
+			  ISPPRV_CONTRAST_LOW, ISPPRV_CONTRAST_HIGH,
+			  ISPPRV_CONTRAST_STEP, ISPPRV_CONTRAST_DEF);
+	v4l2_ctrl_handler_setup(&prev->ctrls);
+	sd->ctrl_handler = &prev->ctrls;
+
+	pads[PREV_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[PREV_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+
+	me->ops = &preview_media_ops;
+	ret = media_entity_init(me, PREV_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	preview_init_formats(sd, NULL);
+
+	/* According to the OMAP34xx TRM, video buffers need to be aligned on a
+	 * 32 bytes boundary. However, an undocumented hardware bug requires a
+	 * 64 bytes boundary at the preview engine input.
+	 */
+	prev->video_in.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	prev->video_in.ops = &preview_video_ops;
+	prev->video_in.isp = to_isp_device(prev);
+	prev->video_in.capture_mem = PAGE_ALIGN(4096 * 4096) * 2 * 3;
+	prev->video_in.bpl_alignment = 64;
+	prev->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	prev->video_out.ops = &preview_video_ops;
+	prev->video_out.isp = to_isp_device(prev);
+	prev->video_out.capture_mem = PAGE_ALIGN(4096 * 4096) * 2 * 3;
+	prev->video_out.bpl_alignment = 32;
+
+	ret = omap3isp_video_init(&prev->video_in, "preview");
+	if (ret < 0)
+		return ret;
+
+	ret = omap3isp_video_init(&prev->video_out, "preview");
+	if (ret < 0)
+		return ret;
+
+	/* Connect the video nodes to the previewer subdev. */
+	ret = media_entity_create_link(&prev->video_in.video.entity, 0,
+			&prev->subdev.entity, PREV_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_entity_create_link(&prev->subdev.entity, PREV_PAD_SOURCE,
+			&prev->video_out.video.entity, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void omap3isp_preview_unregister_entities(struct isp_prev_device *prev)
+{
+	media_entity_cleanup(&prev->subdev.entity);
+
+	v4l2_device_unregister_subdev(&prev->subdev);
+	v4l2_ctrl_handler_free(&prev->ctrls);
+	omap3isp_video_unregister(&prev->video_in);
+	omap3isp_video_unregister(&prev->video_out);
+}
+
+int omap3isp_preview_register_entities(struct isp_prev_device *prev,
+	struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video nodes. */
+	ret = v4l2_device_register_subdev(vdev, &prev->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap3isp_video_register(&prev->video_in, vdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap3isp_video_register(&prev->video_out, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap3isp_preview_unregister_entities(prev);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP previewer initialisation and cleanup
+ */
+
+void omap3isp_preview_cleanup(struct isp_device *isp)
+{
+}
+
+/*
+ * isp_preview_init - Previewer initialization.
+ * @dev : Pointer to ISP device
+ * return -ENOMEM or zero on success
+ */
+int omap3isp_preview_init(struct isp_device *isp)
+{
+	struct isp_prev_device *prev = &isp->isp_prev;
+	int ret;
+
+	spin_lock_init(&prev->lock);
+	init_waitqueue_head(&prev->wait);
+	preview_init_params(prev);
+
+	ret = preview_init_entities(prev);
+	if (ret < 0)
+		goto out;
+
+out:
+	if (ret)
+		omap3isp_preview_cleanup(isp);
+
+	return ret;
+}
diff --git a/drivers/media/video/omap3-isp/isppreview.h b/drivers/media/video/omap3-isp/isppreview.h
new file mode 100644
index 0000000..f2d63ca
--- /dev/null
+++ b/drivers/media/video/omap3-isp/isppreview.h
@@ -0,0 +1,214 @@
+/*
+ * isppreview.h
+ *
+ * TI OMAP3 ISP - Preview module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_PREVIEW_H
+#define OMAP3_ISP_PREVIEW_H
+
+#include <linux/omap3isp.h>
+#include <linux/types.h>
+#include <media/v4l2-ctrls.h>
+
+#include "ispvideo.h"
+
+#define ISPPRV_BRIGHT_STEP		0x1
+#define ISPPRV_BRIGHT_DEF		0x0
+#define ISPPRV_BRIGHT_LOW		0x0
+#define ISPPRV_BRIGHT_HIGH		0xFF
+#define ISPPRV_BRIGHT_UNITS		0x1
+
+#define ISPPRV_CONTRAST_STEP		0x1
+#define ISPPRV_CONTRAST_DEF		0x10
+#define ISPPRV_CONTRAST_LOW		0x0
+#define ISPPRV_CONTRAST_HIGH		0xFF
+#define ISPPRV_CONTRAST_UNITS		0x1
+
+#define NO_AVE				0x0
+#define AVE_2_PIX			0x1
+#define AVE_4_PIX			0x2
+#define AVE_8_PIX			0x3
+
+/* Features list */
+#define PREV_LUMA_ENHANCE		OMAP3ISP_PREV_LUMAENH
+#define PREV_INVERSE_ALAW		OMAP3ISP_PREV_INVALAW
+#define PREV_HORZ_MEDIAN_FILTER		OMAP3ISP_PREV_HRZ_MED
+#define PREV_CFA			OMAP3ISP_PREV_CFA
+#define PREV_CHROMA_SUPPRESS		OMAP3ISP_PREV_CHROMA_SUPP
+#define PREV_WB				OMAP3ISP_PREV_WB
+#define PREV_BLKADJ			OMAP3ISP_PREV_BLKADJ
+#define PREV_RGB2RGB			OMAP3ISP_PREV_RGB2RGB
+#define PREV_COLOR_CONV			OMAP3ISP_PREV_COLOR_CONV
+#define PREV_YCLIMITS			OMAP3ISP_PREV_YC_LIMIT
+#define PREV_DEFECT_COR			OMAP3ISP_PREV_DEFECT_COR
+#define PREV_GAMMA_BYPASS		OMAP3ISP_PREV_GAMMABYPASS
+#define PREV_DARK_FRAME_CAPTURE		OMAP3ISP_PREV_DRK_FRM_CAPTURE
+#define PREV_DARK_FRAME_SUBTRACT	OMAP3ISP_PREV_DRK_FRM_SUBTRACT
+#define PREV_LENS_SHADING		OMAP3ISP_PREV_LENS_SHADING
+#define PREV_NOISE_FILTER		OMAP3ISP_PREV_NF
+#define PREV_GAMMA			OMAP3ISP_PREV_GAMMA
+
+#define PREV_CONTRAST			(1 << 17)
+#define PREV_BRIGHTNESS			(1 << 18)
+#define PREV_AVERAGER			(1 << 19)
+#define PREV_FEATURES_END		(1 << 20)
+
+enum preview_input_entity {
+	PREVIEW_INPUT_NONE,
+	PREVIEW_INPUT_CCDC,
+	PREVIEW_INPUT_MEMORY,
+};
+
+#define PREVIEW_OUTPUT_RESIZER		(1 << 1)
+#define PREVIEW_OUTPUT_MEMORY		(1 << 2)
+
+/* Configure byte layout of YUV image */
+enum preview_ycpos_mode {
+	YCPOS_YCrYCb = 0,
+	YCPOS_YCbYCr = 1,
+	YCPOS_CbYCrY = 2,
+	YCPOS_CrYCbY = 3
+};
+
+/*
+ * struct prev_params - Structure for all configuration
+ * @features: Set of features enabled.
+ * @cfa: CFA coefficients.
+ * @csup: Chroma suppression coefficients.
+ * @luma: Luma enhancement coefficients.
+ * @nf: Noise filter coefficients.
+ * @dcor: Noise filter coefficients.
+ * @gamma: Gamma coefficients.
+ * @wbal: White Balance parameters.
+ * @blk_adj: Black adjustment parameters.
+ * @rgb2rgb: RGB blending parameters.
+ * @rgb2ycbcr: RGB to ycbcr parameters.
+ * @hmed: Horizontal median filter.
+ * @yclimit: YC limits parameters.
+ * @average: Downsampling rate for averager.
+ * @contrast: Contrast.
+ * @brightness: Brightness.
+ */
+struct prev_params {
+	u32 features;
+	struct omap3isp_prev_cfa cfa;
+	struct omap3isp_prev_csup csup;
+	struct omap3isp_prev_luma luma;
+	struct omap3isp_prev_nf nf;
+	struct omap3isp_prev_dcor dcor;
+	struct omap3isp_prev_gtables gamma;
+	struct omap3isp_prev_wbal wbal;
+	struct omap3isp_prev_blkadj blk_adj;
+	struct omap3isp_prev_rgbtorgb rgb2rgb;
+	struct omap3isp_prev_csc rgb2ycbcr;
+	struct omap3isp_prev_hmed hmed;
+	struct omap3isp_prev_yclimit yclimit;
+	u8 average;
+	u8 contrast;
+	u8 brightness;
+};
+
+/*
+ * struct isptables_update - Structure for Table Configuration.
+ * @update: Specifies which tables should be updated.
+ * @flag: Specifies which tables should be enabled.
+ * @nf: Pointer to structure for Noise Filter
+ * @lsc: Pointer to LSC gain table. (currently not used)
+ * @gamma: Pointer to gamma correction tables.
+ * @cfa: Pointer to color filter array configuration.
+ * @wbal: Pointer to colour and digital gain configuration.
+ */
+struct isptables_update {
+	u32 update;
+	u32 flag;
+	struct omap3isp_prev_nf *nf;
+	u32 *lsc;
+	struct omap3isp_prev_gtables *gamma;
+	struct omap3isp_prev_cfa *cfa;
+	struct omap3isp_prev_wbal *wbal;
+};
+
+/* Sink and source previewer pads */
+#define PREV_PAD_SINK			0
+#define PREV_PAD_SOURCE			1
+#define PREV_PADS_NUM			2
+
+/*
+ * struct isp_prev_device - Structure for storing ISP Preview module information
+ * @subdev: V4L2 subdevice
+ * @pads: Media entity pads
+ * @formats: Active formats at the subdev pad
+ * @input: Module currently connected to the input pad
+ * @output: Bitmask of the active output
+ * @video_in: Input video entity
+ * @video_out: Output video entity
+ * @error: A hardware error occured during capture
+ * @params: Module configuration data
+ * @shadow_update: If set, update the hardware configured in the next interrupt
+ * @underrun: Whether the preview entity has queued buffers on the output
+ * @state: Current preview pipeline state
+ * @lock: Shadow update lock
+ * @update: Bitmask of the parameters to be updated
+ *
+ * This structure is used to store the OMAP ISP Preview module Information.
+ */
+struct isp_prev_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[PREV_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[PREV_PADS_NUM];
+
+	struct v4l2_ctrl_handler ctrls;
+
+	enum preview_input_entity input;
+	unsigned int output;
+	struct isp_video video_in;
+	struct isp_video video_out;
+	unsigned int error;
+
+	struct prev_params params;
+	unsigned int shadow_update:1;
+	enum isp_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+	spinlock_t lock;
+	u32 update;
+};
+
+struct isp_device;
+
+int omap3isp_preview_init(struct isp_device *isp);
+void omap3isp_preview_cleanup(struct isp_device *isp);
+
+int omap3isp_preview_register_entities(struct isp_prev_device *prv,
+				       struct v4l2_device *vdev);
+void omap3isp_preview_unregister_entities(struct isp_prev_device *prv);
+
+void omap3isp_preview_isr_frame_sync(struct isp_prev_device *prev);
+void omap3isp_preview_isr(struct isp_prev_device *prev);
+
+int omap3isp_preview_busy(struct isp_prev_device *isp_prev);
+
+void omap3isp_preview_restore_context(struct isp_device *isp);
+
+#endif	/* OMAP3_ISP_PREVIEW_H */
diff --git a/drivers/media/video/omap3-isp/ispresizer.c b/drivers/media/video/omap3-isp/ispresizer.c
new file mode 100644
index 0000000..75d39b1
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispresizer.c
@@ -0,0 +1,1693 @@
+/*
+ * ispresizer.c
+ *
+ * TI OMAP3 ISP - Resizer module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/device.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+
+#include "isp.h"
+#include "ispreg.h"
+#include "ispresizer.h"
+
+/*
+ * Resizer Constants
+ */
+#define MIN_RESIZE_VALUE		64
+#define MID_RESIZE_VALUE		512
+#define MAX_RESIZE_VALUE		1024
+
+#define MIN_IN_WIDTH			32
+#define MIN_IN_HEIGHT			32
+#define MAX_IN_WIDTH_MEMORY_MODE	4095
+#define MAX_IN_WIDTH_ONTHEFLY_MODE_ES1	1280
+#define MAX_IN_WIDTH_ONTHEFLY_MODE_ES2	4095
+#define MAX_IN_HEIGHT			4095
+
+#define MIN_OUT_WIDTH			16
+#define MIN_OUT_HEIGHT			2
+#define MAX_OUT_HEIGHT			4095
+
+/*
+ * Resizer Use Constraints
+ * "TRM ES3.1, table 12-46"
+ */
+#define MAX_4TAP_OUT_WIDTH_ES1		1280
+#define MAX_7TAP_OUT_WIDTH_ES1		640
+#define MAX_4TAP_OUT_WIDTH_ES2		3312
+#define MAX_7TAP_OUT_WIDTH_ES2		1650
+#define MAX_4TAP_OUT_WIDTH_3630		4096
+#define MAX_7TAP_OUT_WIDTH_3630		2048
+
+/*
+ * Constants for ratio calculation
+ */
+#define RESIZE_DIVISOR			256
+#define DEFAULT_PHASE			1
+
+/*
+ * Default (and only) configuration of filter coefficients.
+ * 7-tap mode is for scale factors 0.25x to 0.5x.
+ * 4-tap mode is for scale factors 0.5x to 4.0x.
+ * There shouldn't be any reason to recalculate these, EVER.
+ */
+static const struct isprsz_coef filter_coefs = {
+	/* For 8-phase 4-tap horizontal filter: */
+	{
+		0x0000, 0x0100, 0x0000, 0x0000,
+		0x03FA, 0x00F6, 0x0010, 0x0000,
+		0x03F9, 0x00DB, 0x002C, 0x0000,
+		0x03FB, 0x00B3, 0x0053, 0x03FF,
+		0x03FD, 0x0082, 0x0084, 0x03FD,
+		0x03FF, 0x0053, 0x00B3, 0x03FB,
+		0x0000, 0x002C, 0x00DB, 0x03F9,
+		0x0000, 0x0010, 0x00F6, 0x03FA
+	},
+	/* For 8-phase 4-tap vertical filter: */
+	{
+		0x0000, 0x0100, 0x0000, 0x0000,
+		0x03FA, 0x00F6, 0x0010, 0x0000,
+		0x03F9, 0x00DB, 0x002C, 0x0000,
+		0x03FB, 0x00B3, 0x0053, 0x03FF,
+		0x03FD, 0x0082, 0x0084, 0x03FD,
+		0x03FF, 0x0053, 0x00B3, 0x03FB,
+		0x0000, 0x002C, 0x00DB, 0x03F9,
+		0x0000, 0x0010, 0x00F6, 0x03FA
+	},
+	/* For 4-phase 7-tap horizontal filter: */
+	#define DUMMY 0
+	{
+		0x0004, 0x0023, 0x005A, 0x0058, 0x0023, 0x0004, 0x0000, DUMMY,
+		0x0002, 0x0018, 0x004d, 0x0060, 0x0031, 0x0008, 0x0000, DUMMY,
+		0x0001, 0x000f, 0x003f, 0x0062, 0x003f, 0x000f, 0x0001, DUMMY,
+		0x0000, 0x0008, 0x0031, 0x0060, 0x004d, 0x0018, 0x0002, DUMMY
+	},
+	/* For 4-phase 7-tap vertical filter: */
+	{
+		0x0004, 0x0023, 0x005A, 0x0058, 0x0023, 0x0004, 0x0000, DUMMY,
+		0x0002, 0x0018, 0x004d, 0x0060, 0x0031, 0x0008, 0x0000, DUMMY,
+		0x0001, 0x000f, 0x003f, 0x0062, 0x003f, 0x000f, 0x0001, DUMMY,
+		0x0000, 0x0008, 0x0031, 0x0060, 0x004d, 0x0018, 0x0002, DUMMY
+	}
+	/*
+	 * The dummy padding is required in 7-tap mode because of how the
+	 * registers are arranged physically.
+	 */
+	#undef DUMMY
+};
+
+/*
+ * __resizer_get_format - helper function for getting resizer format
+ * @res   : pointer to resizer private structure
+ * @pad   : pad number
+ * @fh    : V4L2 subdev file handle
+ * @which : wanted subdev format
+ * return zero
+ */
+static struct v4l2_mbus_framefmt *
+__resizer_get_format(struct isp_res_device *res, struct v4l2_subdev_fh *fh,
+		     unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(fh, pad);
+	else
+		return &res->formats[pad];
+}
+
+/*
+ * __resizer_get_crop - helper function for getting resizer crop rectangle
+ * @res   : pointer to resizer private structure
+ * @fh    : V4L2 subdev file handle
+ * @which : wanted subdev crop rectangle
+ */
+static struct v4l2_rect *
+__resizer_get_crop(struct isp_res_device *res, struct v4l2_subdev_fh *fh,
+		   enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(fh, RESZ_PAD_SINK);
+	else
+		return &res->crop.request;
+}
+
+/*
+ * resizer_set_filters - Set resizer filters
+ * @res: Device context.
+ * @h_coeff: horizontal coefficient
+ * @v_coeff: vertical coefficient
+ * Return none
+ */
+static void resizer_set_filters(struct isp_res_device *res, const u16 *h_coeff,
+				const u16 *v_coeff)
+{
+	struct isp_device *isp = to_isp_device(res);
+	u32 startaddr_h, startaddr_v, tmp_h, tmp_v;
+	int i;
+
+	startaddr_h = ISPRSZ_HFILT10;
+	startaddr_v = ISPRSZ_VFILT10;
+
+	for (i = 0; i < COEFF_CNT; i += 2) {
+		tmp_h = h_coeff[i] |
+			(h_coeff[i + 1] << ISPRSZ_HFILT_COEF1_SHIFT);
+		tmp_v = v_coeff[i] |
+			(v_coeff[i + 1] << ISPRSZ_VFILT_COEF1_SHIFT);
+		isp_reg_writel(isp, tmp_h, OMAP3_ISP_IOMEM_RESZ, startaddr_h);
+		isp_reg_writel(isp, tmp_v, OMAP3_ISP_IOMEM_RESZ, startaddr_v);
+		startaddr_h += 4;
+		startaddr_v += 4;
+	}
+}
+
+/*
+ * resizer_set_bilinear - Chrominance horizontal algorithm select
+ * @res: Device context.
+ * @type: Filtering interpolation type.
+ *
+ * Filtering that is same as luminance processing is
+ * intended only for downsampling, and bilinear interpolation
+ * is intended only for upsampling.
+ */
+static void resizer_set_bilinear(struct isp_res_device *res,
+				 enum resizer_chroma_algo type)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	if (type == RSZ_BILINEAR)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_CBILIN);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_CBILIN);
+}
+
+/*
+ * resizer_set_ycpos - Luminance and chrominance order
+ * @res: Device context.
+ * @order: order type.
+ */
+static void resizer_set_ycpos(struct isp_res_device *res,
+			      enum v4l2_mbus_pixelcode pixelcode)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	switch (pixelcode) {
+	case V4L2_MBUS_FMT_YUYV8_1X16:
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_YCPOS);
+		break;
+	case V4L2_MBUS_FMT_UYVY8_1X16:
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_YCPOS);
+		break;
+	default:
+		return;
+	}
+}
+
+/*
+ * resizer_set_phase - Setup horizontal and vertical starting phase
+ * @res: Device context.
+ * @h_phase: horizontal phase parameters.
+ * @v_phase: vertical phase parameters.
+ *
+ * Horizontal and vertical phase range is 0 to 7
+ */
+static void resizer_set_phase(struct isp_res_device *res, u32 h_phase,
+			      u32 v_phase)
+{
+	struct isp_device *isp = to_isp_device(res);
+	u32 rgval = 0;
+
+	rgval = isp_reg_readl(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT) &
+	      ~(ISPRSZ_CNT_HSTPH_MASK | ISPRSZ_CNT_VSTPH_MASK);
+	rgval |= (h_phase << ISPRSZ_CNT_HSTPH_SHIFT) & ISPRSZ_CNT_HSTPH_MASK;
+	rgval |= (v_phase << ISPRSZ_CNT_VSTPH_SHIFT) & ISPRSZ_CNT_VSTPH_MASK;
+
+	isp_reg_writel(isp, rgval, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT);
+}
+
+/*
+ * resizer_set_luma - Setup luminance enhancer parameters
+ * @res: Device context.
+ * @luma: Structure for luminance enhancer parameters.
+ *
+ * Algorithm select:
+ *  0x0: Disable
+ *  0x1: [-1  2 -1]/2 high-pass filter
+ *  0x2: [-1 -2  6 -2 -1]/4 high-pass filter
+ *
+ * Maximum gain:
+ *  The data is coded in U4Q4 representation.
+ *
+ * Slope:
+ *  The data is coded in U4Q4 representation.
+ *
+ * Coring offset:
+ *  The data is coded in U8Q0 representation.
+ *
+ * The new luminance value is computed as:
+ *  Y += HPF(Y) x max(GAIN, (HPF(Y) - CORE) x SLOP + 8) >> 4.
+ */
+static void resizer_set_luma(struct isp_res_device *res,
+			     struct resizer_luma_yenh *luma)
+{
+	struct isp_device *isp = to_isp_device(res);
+	u32 rgval = 0;
+
+	rgval  = (luma->algo << ISPRSZ_YENH_ALGO_SHIFT)
+		  & ISPRSZ_YENH_ALGO_MASK;
+	rgval |= (luma->gain << ISPRSZ_YENH_GAIN_SHIFT)
+		  & ISPRSZ_YENH_GAIN_MASK;
+	rgval |= (luma->slope << ISPRSZ_YENH_SLOP_SHIFT)
+		  & ISPRSZ_YENH_SLOP_MASK;
+	rgval |= (luma->core << ISPRSZ_YENH_CORE_SHIFT)
+		  & ISPRSZ_YENH_CORE_MASK;
+
+	isp_reg_writel(isp, rgval, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_YENH);
+}
+
+/*
+ * resizer_set_source - Input source select
+ * @res: Device context.
+ * @source: Input source type
+ *
+ * If this field is set to RESIZER_INPUT_VP, the resizer input is fed from
+ * Preview/CCDC engine, otherwise from memory.
+ */
+static void resizer_set_source(struct isp_res_device *res,
+			       enum resizer_input_entity source)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	if (source == RESIZER_INPUT_MEMORY)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_INPSRC);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_INPSRC);
+}
+
+/*
+ * resizer_set_ratio - Setup horizontal and vertical resizing value
+ * @res: Device context.
+ * @ratio: Structure for ratio parameters.
+ *
+ * Resizing range from 64 to 1024
+ */
+static void resizer_set_ratio(struct isp_res_device *res,
+			      const struct resizer_ratio *ratio)
+{
+	struct isp_device *isp = to_isp_device(res);
+	const u16 *h_filter, *v_filter;
+	u32 rgval = 0;
+
+	rgval = isp_reg_readl(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT) &
+			      ~(ISPRSZ_CNT_HRSZ_MASK | ISPRSZ_CNT_VRSZ_MASK);
+	rgval |= ((ratio->horz - 1) << ISPRSZ_CNT_HRSZ_SHIFT)
+		  & ISPRSZ_CNT_HRSZ_MASK;
+	rgval |= ((ratio->vert - 1) << ISPRSZ_CNT_VRSZ_SHIFT)
+		  & ISPRSZ_CNT_VRSZ_MASK;
+	isp_reg_writel(isp, rgval, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT);
+
+	/* prepare horizontal filter coefficients */
+	if (ratio->horz > MID_RESIZE_VALUE)
+		h_filter = &filter_coefs.h_filter_coef_7tap[0];
+	else
+		h_filter = &filter_coefs.h_filter_coef_4tap[0];
+
+	/* prepare vertical filter coefficients */
+	if (ratio->vert > MID_RESIZE_VALUE)
+		v_filter = &filter_coefs.v_filter_coef_7tap[0];
+	else
+		v_filter = &filter_coefs.v_filter_coef_4tap[0];
+
+	resizer_set_filters(res, h_filter, v_filter);
+}
+
+/*
+ * resizer_set_dst_size - Setup the output height and width
+ * @res: Device context.
+ * @width: Output width.
+ * @height: Output height.
+ *
+ * Width :
+ *  The value must be EVEN.
+ *
+ * Height:
+ *  The number of bytes written to SDRAM must be
+ *  a multiple of 16-bytes if the vertical resizing factor
+ *  is greater than 1x (upsizing)
+ */
+static void resizer_set_output_size(struct isp_res_device *res,
+				    u32 width, u32 height)
+{
+	struct isp_device *isp = to_isp_device(res);
+	u32 rgval = 0;
+
+	dev_dbg(isp->dev, "Output size[w/h]: %dx%d\n", width, height);
+	rgval  = (width << ISPRSZ_OUT_SIZE_HORZ_SHIFT)
+		 & ISPRSZ_OUT_SIZE_HORZ_MASK;
+	rgval |= (height << ISPRSZ_OUT_SIZE_VERT_SHIFT)
+		 & ISPRSZ_OUT_SIZE_VERT_MASK;
+	isp_reg_writel(isp, rgval, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_OUT_SIZE);
+}
+
+/*
+ * resizer_set_output_offset - Setup memory offset for the output lines.
+ * @res: Device context.
+ * @offset: Memory offset.
+ *
+ * The 5 LSBs are forced to be zeros by the hardware to align on a 32-byte
+ * boundary; the 5 LSBs are read-only. For optimal use of SDRAM bandwidth,
+ * the SDRAM line offset must be set on a 256-byte boundary
+ */
+static void resizer_set_output_offset(struct isp_res_device *res, u32 offset)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	isp_reg_writel(isp, offset, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_SDR_OUTOFF);
+}
+
+/*
+ * resizer_set_start - Setup vertical and horizontal start position
+ * @res: Device context.
+ * @left: Horizontal start position.
+ * @top: Vertical start position.
+ *
+ * Vertical start line:
+ *  This field makes sense only when the resizer obtains its input
+ *  from the preview engine/CCDC
+ *
+ * Horizontal start pixel:
+ *  Pixels are coded on 16 bits for YUV and 8 bits for color separate data.
+ *  When the resizer gets its input from SDRAM, this field must be set
+ *  to <= 15 for YUV 16-bit data and <= 31 for 8-bit color separate data
+ */
+static void resizer_set_start(struct isp_res_device *res, u32 left, u32 top)
+{
+	struct isp_device *isp = to_isp_device(res);
+	u32 rgval = 0;
+
+	rgval = (left << ISPRSZ_IN_START_HORZ_ST_SHIFT)
+		& ISPRSZ_IN_START_HORZ_ST_MASK;
+	rgval |= (top << ISPRSZ_IN_START_VERT_ST_SHIFT)
+		 & ISPRSZ_IN_START_VERT_ST_MASK;
+
+	isp_reg_writel(isp, rgval, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_IN_START);
+}
+
+/*
+ * resizer_set_input_size - Setup the input size
+ * @res: Device context.
+ * @width: The range is 0 to 4095 pixels
+ * @height: The range is 0 to 4095 lines
+ */
+static void resizer_set_input_size(struct isp_res_device *res,
+				   u32 width, u32 height)
+{
+	struct isp_device *isp = to_isp_device(res);
+	u32 rgval = 0;
+
+	dev_dbg(isp->dev, "Input size[w/h]: %dx%d\n", width, height);
+
+	rgval = (width << ISPRSZ_IN_SIZE_HORZ_SHIFT)
+		& ISPRSZ_IN_SIZE_HORZ_MASK;
+	rgval |= (height << ISPRSZ_IN_SIZE_VERT_SHIFT)
+		 & ISPRSZ_IN_SIZE_VERT_MASK;
+
+	isp_reg_writel(isp, rgval, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_IN_SIZE);
+}
+
+/*
+ * resizer_set_src_offs - Setup the memory offset for the input lines
+ * @res: Device context.
+ * @offset: Memory offset.
+ *
+ * The 5 LSBs are forced to be zeros by the hardware to align on a 32-byte
+ * boundary; the 5 LSBs are read-only. This field must be programmed to be
+ * 0x0 if the resizer input is from preview engine/CCDC.
+ */
+static void resizer_set_input_offset(struct isp_res_device *res, u32 offset)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	isp_reg_writel(isp, offset, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_SDR_INOFF);
+}
+
+/*
+ * resizer_set_intype - Input type select
+ * @res: Device context.
+ * @type: Pixel format type.
+ */
+static void resizer_set_intype(struct isp_res_device *res,
+			       enum resizer_colors_type type)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	if (type == RSZ_COLOR8)
+		isp_reg_set(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_INPTYP);
+	else
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_CNT,
+			    ISPRSZ_CNT_INPTYP);
+}
+
+/*
+ * __resizer_set_inaddr - Helper function for set input address
+ * @res : pointer to resizer private data structure
+ * @addr: input address
+ * return none
+ */
+static void __resizer_set_inaddr(struct isp_res_device *res, u32 addr)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	isp_reg_writel(isp, addr, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_SDR_INADD);
+}
+
+/*
+ * The data rate at the horizontal resizer output must not exceed half the
+ * functional clock or 100 MP/s, whichever is lower. According to the TRM
+ * there's no similar requirement for the vertical resizer output. However
+ * experience showed that vertical upscaling by 4 leads to SBL overflows (with
+ * data rates at the resizer output exceeding 300 MP/s). Limiting the resizer
+ * output data rate to the functional clock or 200 MP/s, whichever is lower,
+ * seems to get rid of SBL overflows.
+ *
+ * The maximum data rate at the output of the horizontal resizer can thus be
+ * computed with
+ *
+ * max intermediate rate <= L3 clock * input height / output height
+ * max intermediate rate <= L3 clock / 2
+ *
+ * The maximum data rate at the resizer input is then
+ *
+ * max input rate <= max intermediate rate * input width / output width
+ *
+ * where the input width and height are the resizer input crop rectangle size.
+ * The TRM doesn't clearly explain if that's a maximum instant data rate or a
+ * maximum average data rate.
+ */
+void omap3isp_resizer_max_rate(struct isp_res_device *res,
+			       unsigned int *max_rate)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&res->subdev.entity);
+	const struct v4l2_mbus_framefmt *ofmt = &res->formats[RESZ_PAD_SOURCE];
+	unsigned long limit = min(pipe->l3_ick, 200000000UL);
+	unsigned long clock;
+
+	clock = div_u64((u64)limit * res->crop.active.height, ofmt->height);
+	clock = min(clock, limit / 2);
+	*max_rate = div_u64((u64)clock * res->crop.active.width, ofmt->width);
+}
+
+/*
+ * When the resizer processes images from memory, the driver must slow down read
+ * requests on the input to at least comply with the internal data rate
+ * requirements. If the application real-time requirements can cope with slower
+ * processing, the resizer can be slowed down even more to put less pressure on
+ * the overall system.
+ *
+ * When the resizer processes images on the fly (either from the CCDC or the
+ * preview module), the same data rate requirements apply but they can't be
+ * enforced at the resizer level. The image input module (sensor, CCP2 or
+ * preview module) must not provide image data faster than the resizer can
+ * process.
+ *
+ * For live image pipelines, the data rate is set by the frame format, size and
+ * rate. The sensor output frame rate must not exceed the maximum resizer data
+ * rate.
+ *
+ * The resizer slows down read requests by inserting wait cycles in the SBL
+ * requests. The maximum number of 256-byte requests per second can be computed
+ * as (the data rate is multiplied by 2 to convert from pixels per second to
+ * bytes per second)
+ *
+ * request per second = data rate * 2 / 256
+ * cycles per request = cycles per second / requests per second
+ *
+ * The number of cycles per second is controlled by the L3 clock, leading to
+ *
+ * cycles per request = L3 frequency / 2 * 256 / data rate
+ */
+static void resizer_adjust_bandwidth(struct isp_res_device *res)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&res->subdev.entity);
+	struct isp_device *isp = to_isp_device(res);
+	unsigned long l3_ick = pipe->l3_ick;
+	struct v4l2_fract *timeperframe;
+	unsigned int cycles_per_frame;
+	unsigned int requests_per_frame;
+	unsigned int cycles_per_request;
+	unsigned int granularity;
+	unsigned int minimum;
+	unsigned int maximum;
+	unsigned int value;
+
+	if (res->input != RESIZER_INPUT_MEMORY) {
+		isp_reg_clr(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_SDR_REQ_EXP,
+			    ISPSBL_SDR_REQ_RSZ_EXP_MASK);
+		return;
+	}
+
+	switch (isp->revision) {
+	case ISP_REVISION_1_0:
+	case ISP_REVISION_2_0:
+	default:
+		granularity = 1024;
+		break;
+
+	case ISP_REVISION_15_0:
+		granularity = 32;
+		break;
+	}
+
+	/* Compute the minimum number of cycles per request, based on the
+	 * pipeline maximum data rate. This is an absolute lower bound if we
+	 * don't want SBL overflows, so round the value up.
+	 */
+	cycles_per_request = div_u64((u64)l3_ick / 2 * 256 + pipe->max_rate - 1,
+				     pipe->max_rate);
+	minimum = DIV_ROUND_UP(cycles_per_request, granularity);
+
+	/* Compute the maximum number of cycles per request, based on the
+	 * requested frame rate. This is a soft upper bound to achieve a frame
+	 * rate equal or higher than the requested value, so round the value
+	 * down.
+	 */
+	timeperframe = &pipe->max_timeperframe;
+
+	requests_per_frame = DIV_ROUND_UP(res->crop.active.width * 2, 256)
+			   * res->crop.active.height;
+	cycles_per_frame = div_u64((u64)l3_ick * timeperframe->numerator,
+				   timeperframe->denominator);
+	cycles_per_request = cycles_per_frame / requests_per_frame;
+
+	maximum = cycles_per_request / granularity;
+
+	value = max(minimum, maximum);
+
+	dev_dbg(isp->dev, "%s: cycles per request = %u\n", __func__, value);
+	isp_reg_clr_set(isp, OMAP3_ISP_IOMEM_SBL, ISPSBL_SDR_REQ_EXP,
+			ISPSBL_SDR_REQ_RSZ_EXP_MASK,
+			value << ISPSBL_SDR_REQ_RSZ_EXP_SHIFT);
+}
+
+/*
+ * omap3isp_resizer_busy - Checks if ISP resizer is busy.
+ *
+ * Returns busy field from ISPRSZ_PCR register.
+ */
+int omap3isp_resizer_busy(struct isp_res_device *res)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	return isp_reg_readl(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_PCR) &
+			     ISPRSZ_PCR_BUSY;
+}
+
+/*
+ * resizer_set_inaddr - Sets the memory address of the input frame.
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ */
+static void resizer_set_inaddr(struct isp_res_device *res, u32 addr)
+{
+	res->addr_base = addr;
+
+	/* This will handle crop settings in stream off state */
+	if (res->crop_offset)
+		addr += res->crop_offset & ~0x1f;
+
+	__resizer_set_inaddr(res, addr);
+}
+
+/*
+ * Configures the memory address to which the output frame is written.
+ * @addr: 32bit memory address aligned on 32byte boundary.
+ * Note: For SBL efficiency reasons the address should be on a 256-byte
+ * boundary.
+ */
+static void resizer_set_outaddr(struct isp_res_device *res, u32 addr)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	/*
+	 * Set output address. This needs to be in its own function
+	 * because it changes often.
+	 */
+	isp_reg_writel(isp, addr << ISPRSZ_SDR_OUTADD_ADDR_SHIFT,
+		       OMAP3_ISP_IOMEM_RESZ, ISPRSZ_SDR_OUTADD);
+}
+
+/*
+ * resizer_print_status - Prints the values of the resizer module registers.
+ */
+#define RSZ_PRINT_REGISTER(isp, name)\
+	dev_dbg(isp->dev, "###RSZ " #name "=0x%08x\n", \
+		isp_reg_readl(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_##name))
+
+static void resizer_print_status(struct isp_res_device *res)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	dev_dbg(isp->dev, "-------------Resizer Register dump----------\n");
+
+	RSZ_PRINT_REGISTER(isp, PCR);
+	RSZ_PRINT_REGISTER(isp, CNT);
+	RSZ_PRINT_REGISTER(isp, OUT_SIZE);
+	RSZ_PRINT_REGISTER(isp, IN_START);
+	RSZ_PRINT_REGISTER(isp, IN_SIZE);
+	RSZ_PRINT_REGISTER(isp, SDR_INADD);
+	RSZ_PRINT_REGISTER(isp, SDR_INOFF);
+	RSZ_PRINT_REGISTER(isp, SDR_OUTADD);
+	RSZ_PRINT_REGISTER(isp, SDR_OUTOFF);
+	RSZ_PRINT_REGISTER(isp, YENH);
+
+	dev_dbg(isp->dev, "--------------------------------------------\n");
+}
+
+/*
+ * resizer_calc_ratios - Helper function for calculate resizer ratios
+ * @res: pointer to resizer private data structure
+ * @input: input frame size
+ * @output: output frame size
+ * @ratio : return calculated ratios
+ * return none
+ *
+ * The resizer uses a polyphase sample rate converter. The upsampling filter
+ * has a fixed number of phases that depend on the resizing ratio. As the ratio
+ * computation depends on the number of phases, we need to compute a first
+ * approximation and then refine it.
+ *
+ * The input/output/ratio relationship is given by the OMAP34xx TRM:
+ *
+ * - 8-phase, 4-tap mode (RSZ = 64 ~ 512)
+ *	iw = (32 * sph + (ow - 1) * hrsz + 16) >> 8 + 7
+ *	ih = (32 * spv + (oh - 1) * vrsz + 16) >> 8 + 4
+ * - 4-phase, 7-tap mode (RSZ = 513 ~ 1024)
+ *	iw = (64 * sph + (ow - 1) * hrsz + 32) >> 8 + 7
+ *	ih = (64 * spv + (oh - 1) * vrsz + 32) >> 8 + 7
+ *
+ * iw and ih are the input width and height after cropping. Those equations need
+ * to be satisfied exactly for the resizer to work correctly.
+ *
+ * Reverting the equations, we can compute the resizing ratios with
+ *
+ * - 8-phase, 4-tap mode
+ *	hrsz = ((iw - 7) * 256 - 16 - 32 * sph) / (ow - 1)
+ *	vrsz = ((ih - 4) * 256 - 16 - 32 * spv) / (oh - 1)
+ * - 4-phase, 7-tap mode
+ *	hrsz = ((iw - 7) * 256 - 32 - 64 * sph) / (ow - 1)
+ *	vrsz = ((ih - 7) * 256 - 32 - 64 * spv) / (oh - 1)
+ *
+ * The ratios are integer values, and must be rounded down to ensure that the
+ * cropped input size is not bigger than the uncropped input size. As the ratio
+ * in 7-tap mode is always smaller than the ratio in 4-tap mode, we can use the
+ * 7-tap mode equations to compute a ratio approximation.
+ *
+ * We first clamp the output size according to the hardware capabilitie to avoid
+ * auto-cropping the input more than required to satisfy the TRM equations. The
+ * minimum output size is achieved with a scaling factor of 1024. It is thus
+ * computed using the 7-tap equations.
+ *
+ *	min ow = ((iw - 7) * 256 - 32 - 64 * sph) / 1024 + 1
+ *	min oh = ((ih - 7) * 256 - 32 - 64 * spv) / 1024 + 1
+ *
+ * Similarly, the maximum output size is achieved with a scaling factor of 64
+ * and computed using the 4-tap equations.
+ *
+ *	max ow = ((iw - 7) * 256 + 255 - 16 - 32 * sph) / 64 + 1
+ *	max oh = ((ih - 4) * 256 + 255 - 16 - 32 * spv) / 64 + 1
+ *
+ * The additional +255 term compensates for the round down operation performed
+ * by the TRM equations when shifting the value right by 8 bits.
+ *
+ * We then compute and clamp the ratios (x1/4 ~ x4). Clamping the output size to
+ * the maximum value guarantees that the ratio value will never be smaller than
+ * the minimum, but it could still slightly exceed the maximum. Clamping the
+ * ratio will thus result in a resizing factor slightly larger than the
+ * requested value.
+ *
+ * To accomodate that, and make sure the TRM equations are satisfied exactly, we
+ * compute the input crop rectangle as the last step.
+ *
+ * As if the situation wasn't complex enough, the maximum output width depends
+ * on the vertical resizing ratio.  Fortunately, the output height doesn't
+ * depend on the horizontal resizing ratio. We can then start by computing the
+ * output height and the vertical ratio, and then move to computing the output
+ * width and the horizontal ratio.
+ */
+static void resizer_calc_ratios(struct isp_res_device *res,
+				struct v4l2_rect *input,
+				struct v4l2_mbus_framefmt *output,
+				struct resizer_ratio *ratio)
+{
+	struct isp_device *isp = to_isp_device(res);
+	const unsigned int spv = DEFAULT_PHASE;
+	const unsigned int sph = DEFAULT_PHASE;
+	unsigned int upscaled_width;
+	unsigned int upscaled_height;
+	unsigned int min_width;
+	unsigned int min_height;
+	unsigned int max_width;
+	unsigned int max_height;
+	unsigned int width_alignment;
+
+	/*
+	 * Clamp the output height based on the hardware capabilities and
+	 * compute the vertical resizing ratio.
+	 */
+	min_height = ((input->height - 7) * 256 - 32 - 64 * spv) / 1024 + 1;
+	min_height = max_t(unsigned int, min_height, MIN_OUT_HEIGHT);
+	max_height = ((input->height - 4) * 256 + 255 - 16 - 32 * spv) / 64 + 1;
+	max_height = min_t(unsigned int, max_height, MAX_OUT_HEIGHT);
+	output->height = clamp(output->height, min_height, max_height);
+
+	ratio->vert = ((input->height - 7) * 256 - 32 - 64 * spv)
+		    / (output->height - 1);
+	ratio->vert = clamp_t(unsigned int, ratio->vert,
+			      MIN_RESIZE_VALUE, MAX_RESIZE_VALUE);
+
+	if (ratio->vert <= MID_RESIZE_VALUE) {
+		upscaled_height = (output->height - 1) * ratio->vert
+				+ 32 * spv + 16;
+		input->height = (upscaled_height >> 8) + 4;
+	} else {
+		upscaled_height = (output->height - 1) * ratio->vert
+				+ 64 * spv + 32;
+		input->height = (upscaled_height >> 8) + 7;
+	}
+
+	/*
+	 * Compute the minimum and maximum output widths based on the hardware
+	 * capabilities. The maximum depends on the vertical resizing ratio.
+	 */
+	min_width = ((input->width - 7) * 256 - 32 - 64 * sph) / 1024 + 1;
+	min_width = max_t(unsigned int, min_width, MIN_OUT_WIDTH);
+
+	if (ratio->vert <= MID_RESIZE_VALUE) {
+		switch (isp->revision) {
+		case ISP_REVISION_1_0:
+			max_width = MAX_4TAP_OUT_WIDTH_ES1;
+			break;
+
+		case ISP_REVISION_2_0:
+		default:
+			max_width = MAX_4TAP_OUT_WIDTH_ES2;
+			break;
+
+		case ISP_REVISION_15_0:
+			max_width = MAX_4TAP_OUT_WIDTH_3630;
+			break;
+		}
+	} else {
+		switch (isp->revision) {
+		case ISP_REVISION_1_0:
+			max_width = MAX_7TAP_OUT_WIDTH_ES1;
+			break;
+
+		case ISP_REVISION_2_0:
+		default:
+			max_width = MAX_7TAP_OUT_WIDTH_ES2;
+			break;
+
+		case ISP_REVISION_15_0:
+			max_width = MAX_7TAP_OUT_WIDTH_3630;
+			break;
+		}
+	}
+	max_width = min(((input->width - 7) * 256 + 255 - 16 - 32 * sph) / 64
+			+ 1, max_width);
+
+	/*
+	 * The output width must be even, and must be a multiple of 16 bytes
+	 * when upscaling vertically. Clamp the output width to the valid range.
+	 * Take the alignment into account (the maximum width in 7-tap mode on
+	 * ES2 isn't a multiple of 8) and align the result up to make sure it
+	 * won't be smaller than the minimum.
+	 */
+	width_alignment = ratio->vert < 256 ? 8 : 2;
+	output->width = clamp(output->width, min_width,
+			      max_width & ~(width_alignment - 1));
+	output->width = ALIGN(output->width, width_alignment);
+
+	ratio->horz = ((input->width - 7) * 256 - 32 - 64 * sph)
+		    / (output->width - 1);
+	ratio->horz = clamp_t(unsigned int, ratio->horz,
+			      MIN_RESIZE_VALUE, MAX_RESIZE_VALUE);
+
+	if (ratio->horz <= MID_RESIZE_VALUE) {
+		upscaled_width = (output->width - 1) * ratio->horz
+			       + 32 * sph + 16;
+		input->width = (upscaled_width >> 8) + 7;
+	} else {
+		upscaled_width = (output->width - 1) * ratio->horz
+			       + 64 * sph + 32;
+		input->width = (upscaled_width >> 8) + 7;
+	}
+}
+
+/*
+ * resizer_set_crop_params - Setup hardware with cropping parameters
+ * @res : resizer private structure
+ * @crop_rect : current crop rectangle
+ * @ratio : resizer ratios
+ * return none
+ */
+static void resizer_set_crop_params(struct isp_res_device *res,
+				    const struct v4l2_mbus_framefmt *input,
+				    const struct v4l2_mbus_framefmt *output)
+{
+	resizer_set_ratio(res, &res->ratio);
+
+	/* Set chrominance horizontal algorithm */
+	if (res->ratio.horz >= RESIZE_DIVISOR)
+		resizer_set_bilinear(res, RSZ_THE_SAME);
+	else
+		resizer_set_bilinear(res, RSZ_BILINEAR);
+
+	resizer_adjust_bandwidth(res);
+
+	if (res->input == RESIZER_INPUT_MEMORY) {
+		/* Calculate additional offset for crop */
+		res->crop_offset = (res->crop.active.top * input->width +
+				    res->crop.active.left) * 2;
+		/*
+		 * Write lowest 4 bits of horizontal pixel offset (in pixels),
+		 * vertical start must be 0.
+		 */
+		resizer_set_start(res, (res->crop_offset / 2) & 0xf, 0);
+
+		/*
+		 * Set start (read) address for cropping, in bytes.
+		 * Lowest 5 bits must be zero.
+		 */
+		__resizer_set_inaddr(res,
+				res->addr_base + (res->crop_offset & ~0x1f));
+	} else {
+		/*
+		 * Set vertical start line and horizontal starting pixel.
+		 * If the input is from CCDC/PREV, horizontal start field is
+		 * in bytes (twice number of pixels).
+		 */
+		resizer_set_start(res, res->crop.active.left * 2,
+				  res->crop.active.top);
+		/* Input address and offset must be 0 for preview/ccdc input */
+		__resizer_set_inaddr(res, 0);
+		resizer_set_input_offset(res, 0);
+	}
+
+	/* Set the input size */
+	resizer_set_input_size(res, res->crop.active.width,
+			       res->crop.active.height);
+}
+
+static void resizer_configure(struct isp_res_device *res)
+{
+	struct v4l2_mbus_framefmt *informat, *outformat;
+	struct resizer_luma_yenh luma = {0, 0, 0, 0};
+
+	resizer_set_source(res, res->input);
+
+	informat = &res->formats[RESZ_PAD_SINK];
+	outformat = &res->formats[RESZ_PAD_SOURCE];
+
+	/* RESZ_PAD_SINK */
+	if (res->input == RESIZER_INPUT_VP)
+		resizer_set_input_offset(res, 0);
+	else
+		resizer_set_input_offset(res, ALIGN(informat->width, 0x10) * 2);
+
+	/* YUV422 interleaved, default phase, no luma enhancement */
+	resizer_set_intype(res, RSZ_YUV422);
+	resizer_set_ycpos(res, informat->code);
+	resizer_set_phase(res, DEFAULT_PHASE, DEFAULT_PHASE);
+	resizer_set_luma(res, &luma);
+
+	/* RESZ_PAD_SOURCE */
+	resizer_set_output_offset(res, ALIGN(outformat->width * 2, 32));
+	resizer_set_output_size(res, outformat->width, outformat->height);
+
+	resizer_set_crop_params(res, informat, outformat);
+}
+
+/* -----------------------------------------------------------------------------
+ * Interrupt handling
+ */
+
+static void resizer_enable_oneshot(struct isp_res_device *res)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	isp_reg_set(isp, OMAP3_ISP_IOMEM_RESZ, ISPRSZ_PCR,
+		    ISPRSZ_PCR_ENABLE | ISPRSZ_PCR_ONESHOT);
+}
+
+void omap3isp_resizer_isr_frame_sync(struct isp_res_device *res)
+{
+	/*
+	 * If ISP_VIDEO_DMAQUEUE_QUEUED is set, DMA queue had an underrun
+	 * condition, the module was paused and now we have a buffer queued
+	 * on the output again. Restart the pipeline if running in continuous
+	 * mode.
+	 */
+	if (res->state == ISP_PIPELINE_STREAM_CONTINUOUS &&
+	    res->video_out.dmaqueue_flags & ISP_VIDEO_DMAQUEUE_QUEUED) {
+		resizer_enable_oneshot(res);
+		isp_video_dmaqueue_flags_clr(&res->video_out);
+	}
+}
+
+static void resizer_isr_buffer(struct isp_res_device *res)
+{
+	struct isp_pipeline *pipe = to_isp_pipeline(&res->subdev.entity);
+	struct isp_buffer *buffer;
+	int restart = 0;
+
+	if (res->state == ISP_PIPELINE_STREAM_STOPPED)
+		return;
+
+	/* Complete the output buffer and, if reading from memory, the input
+	 * buffer.
+	 */
+	buffer = omap3isp_video_buffer_next(&res->video_out, res->error);
+	if (buffer != NULL) {
+		resizer_set_outaddr(res, buffer->isp_addr);
+		restart = 1;
+	}
+
+	pipe->state |= ISP_PIPELINE_IDLE_OUTPUT;
+
+	if (res->input == RESIZER_INPUT_MEMORY) {
+		buffer = omap3isp_video_buffer_next(&res->video_in, 0);
+		if (buffer != NULL)
+			resizer_set_inaddr(res, buffer->isp_addr);
+		pipe->state |= ISP_PIPELINE_IDLE_INPUT;
+	}
+
+	if (res->state == ISP_PIPELINE_STREAM_SINGLESHOT) {
+		if (isp_pipeline_ready(pipe))
+			omap3isp_pipeline_set_stream(pipe,
+						ISP_PIPELINE_STREAM_SINGLESHOT);
+	} else {
+		/* If an underrun occurs, the video queue operation handler will
+		 * restart the resizer. Otherwise restart it immediately.
+		 */
+		if (restart)
+			resizer_enable_oneshot(res);
+	}
+
+	res->error = 0;
+}
+
+/*
+ * omap3isp_resizer_isr - ISP resizer interrupt handler
+ *
+ * Manage the resizer video buffers and configure shadowed and busy-locked
+ * registers.
+ */
+void omap3isp_resizer_isr(struct isp_res_device *res)
+{
+	struct v4l2_mbus_framefmt *informat, *outformat;
+
+	if (omap3isp_module_sync_is_stopping(&res->wait, &res->stopping))
+		return;
+
+	if (res->applycrop) {
+		outformat = __resizer_get_format(res, NULL, RESZ_PAD_SOURCE,
+					      V4L2_SUBDEV_FORMAT_ACTIVE);
+		informat = __resizer_get_format(res, NULL, RESZ_PAD_SINK,
+					      V4L2_SUBDEV_FORMAT_ACTIVE);
+		resizer_set_crop_params(res, informat, outformat);
+		res->applycrop = 0;
+	}
+
+	resizer_isr_buffer(res);
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP video operations
+ */
+
+static int resizer_video_queue(struct isp_video *video,
+			       struct isp_buffer *buffer)
+{
+	struct isp_res_device *res = &video->isp->isp_res;
+
+	if (video->type == V4L2_BUF_TYPE_VIDEO_OUTPUT)
+		resizer_set_inaddr(res, buffer->isp_addr);
+
+	/*
+	 * We now have a buffer queued on the output. Despite what the
+	 * TRM says, the resizer can't be restarted immediately.
+	 * Enabling it in one shot mode in the middle of a frame (or at
+	 * least asynchronously to the frame) results in the output
+	 * being shifted randomly left/right and up/down, as if the
+	 * hardware didn't synchronize itself to the beginning of the
+	 * frame correctly.
+	 *
+	 * Restart the resizer on the next sync interrupt if running in
+	 * continuous mode or when starting the stream.
+	 */
+	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		resizer_set_outaddr(res, buffer->isp_addr);
+
+	return 0;
+}
+
+static const struct isp_video_operations resizer_video_ops = {
+	.queue = resizer_video_queue,
+};
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev operations
+ */
+
+/*
+ * resizer_set_stream - Enable/Disable streaming on resizer subdev
+ * @sd: ISP resizer V4L2 subdev
+ * @enable: 1 == Enable, 0 == Disable
+ *
+ * The resizer hardware can't be enabled without a memory buffer to write to.
+ * As the s_stream operation is called in response to a STREAMON call without
+ * any buffer queued yet, just update the state field and return immediately.
+ * The resizer will be enabled in resizer_video_queue().
+ */
+static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct isp_video *video_out = &res->video_out;
+	struct isp_device *isp = to_isp_device(res);
+	struct device *dev = to_device(res);
+
+	if (res->state == ISP_PIPELINE_STREAM_STOPPED) {
+		if (enable == ISP_PIPELINE_STREAM_STOPPED)
+			return 0;
+
+		omap3isp_subclk_enable(isp, OMAP3_ISP_SUBCLK_RESIZER);
+		resizer_configure(res);
+		res->error = 0;
+		resizer_print_status(res);
+	}
+
+	switch (enable) {
+	case ISP_PIPELINE_STREAM_CONTINUOUS:
+		omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_RESIZER_WRITE);
+		if (video_out->dmaqueue_flags & ISP_VIDEO_DMAQUEUE_QUEUED) {
+			resizer_enable_oneshot(res);
+			isp_video_dmaqueue_flags_clr(video_out);
+		}
+		break;
+
+	case ISP_PIPELINE_STREAM_SINGLESHOT:
+		if (res->input == RESIZER_INPUT_MEMORY)
+			omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_RESIZER_READ);
+		omap3isp_sbl_enable(isp, OMAP3_ISP_SBL_RESIZER_WRITE);
+
+		resizer_enable_oneshot(res);
+		break;
+
+	case ISP_PIPELINE_STREAM_STOPPED:
+		if (omap3isp_module_sync_idle(&sd->entity, &res->wait,
+					      &res->stopping))
+			dev_dbg(dev, "%s: module stop timeout.\n", sd->name);
+		omap3isp_sbl_disable(isp, OMAP3_ISP_SBL_RESIZER_READ |
+				OMAP3_ISP_SBL_RESIZER_WRITE);
+		omap3isp_subclk_disable(isp, OMAP3_ISP_SUBCLK_RESIZER);
+		isp_video_dmaqueue_flags_clr(video_out);
+		break;
+	}
+
+	res->state = enable;
+	return 0;
+}
+
+/*
+ * resizer_g_crop - handle get crop subdev operation
+ * @sd : pointer to v4l2 subdev structure
+ * @pad : subdev pad
+ * @crop : pointer to crop structure
+ * @which : active or try format
+ * return zero
+ */
+static int resizer_g_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_crop *crop)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+	struct resizer_ratio ratio;
+
+	/* Only sink pad has crop capability */
+	if (crop->pad != RESZ_PAD_SINK)
+		return -EINVAL;
+
+	format = __resizer_get_format(res, fh, RESZ_PAD_SOURCE, crop->which);
+	crop->rect = *__resizer_get_crop(res, fh, crop->which);
+	resizer_calc_ratios(res, &crop->rect, format, &ratio);
+
+	return 0;
+}
+
+/*
+ * resizer_try_crop - mangles crop parameters.
+ */
+static void resizer_try_crop(const struct v4l2_mbus_framefmt *sink,
+			     const struct v4l2_mbus_framefmt *source,
+			     struct v4l2_rect *crop)
+{
+	const unsigned int spv = DEFAULT_PHASE;
+	const unsigned int sph = DEFAULT_PHASE;
+
+	/* Crop rectangle is constrained to the output size so that zoom ratio
+	 * cannot exceed +/-4.0.
+	 */
+	unsigned int min_width =
+		((32 * sph + (source->width - 1) * 64 + 16) >> 8) + 7;
+	unsigned int min_height =
+		((32 * spv + (source->height - 1) * 64 + 16) >> 8) + 4;
+	unsigned int max_width =
+		((64 * sph + (source->width - 1) * 1024 + 32) >> 8) + 7;
+	unsigned int max_height =
+		((64 * spv + (source->height - 1) * 1024 + 32) >> 8) + 7;
+
+	crop->width = clamp_t(u32, crop->width, min_width, max_width);
+	crop->height = clamp_t(u32, crop->height, min_height, max_height);
+
+	/* Crop can not go beyond of the input rectangle */
+	crop->left = clamp_t(u32, crop->left, 0, sink->width - MIN_IN_WIDTH);
+	crop->width = clamp_t(u32, crop->width, MIN_IN_WIDTH,
+			      sink->width - crop->left);
+	crop->top = clamp_t(u32, crop->top, 0, sink->height - MIN_IN_HEIGHT);
+	crop->height = clamp_t(u32, crop->height, MIN_IN_HEIGHT,
+			       sink->height - crop->top);
+}
+
+/*
+ * resizer_s_crop - handle set crop subdev operation
+ * @sd : pointer to v4l2 subdev structure
+ * @pad : subdev pad
+ * @crop : pointer to crop structure
+ * @which : active or try format
+ * return -EINVAL or zero when succeed
+ */
+static int resizer_s_crop(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			  struct v4l2_subdev_crop *crop)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct isp_device *isp = to_isp_device(res);
+	struct v4l2_mbus_framefmt *format_sink, *format_source;
+	struct resizer_ratio ratio;
+
+	/* Only sink pad has crop capability */
+	if (crop->pad != RESZ_PAD_SINK)
+		return -EINVAL;
+
+	format_sink = __resizer_get_format(res, fh, RESZ_PAD_SINK,
+					   crop->which);
+	format_source = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
+					     crop->which);
+
+	dev_dbg(isp->dev, "%s: L=%d,T=%d,W=%d,H=%d,which=%d\n", __func__,
+		crop->rect.left, crop->rect.top, crop->rect.width,
+		crop->rect.height, crop->which);
+
+	dev_dbg(isp->dev, "%s: input=%dx%d, output=%dx%d\n", __func__,
+		format_sink->width, format_sink->height,
+		format_source->width, format_source->height);
+
+	resizer_try_crop(format_sink, format_source, &crop->rect);
+	*__resizer_get_crop(res, fh, crop->which) = crop->rect;
+	resizer_calc_ratios(res, &crop->rect, format_source, &ratio);
+
+	if (crop->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
+	res->ratio = ratio;
+	res->crop.active = crop->rect;
+
+	/*
+	 * s_crop can be called while streaming is on. In this case
+	 * the crop values will be set in the next IRQ.
+	 */
+	if (res->state != ISP_PIPELINE_STREAM_STOPPED)
+		res->applycrop = 1;
+
+	return 0;
+}
+
+/* resizer pixel formats */
+static const unsigned int resizer_formats[] = {
+	V4L2_MBUS_FMT_UYVY8_1X16,
+	V4L2_MBUS_FMT_YUYV8_1X16,
+};
+
+static unsigned int resizer_max_in_width(struct isp_res_device *res)
+{
+	struct isp_device *isp = to_isp_device(res);
+
+	if (res->input == RESIZER_INPUT_MEMORY) {
+		return MAX_IN_WIDTH_MEMORY_MODE;
+	} else {
+		if (isp->revision == ISP_REVISION_1_0)
+			return MAX_IN_WIDTH_ONTHEFLY_MODE_ES1;
+		else
+			return MAX_IN_WIDTH_ONTHEFLY_MODE_ES2;
+	}
+}
+
+/*
+ * resizer_try_format - Handle try format by pad subdev method
+ * @res   : ISP resizer device
+ * @fh    : V4L2 subdev file handle
+ * @pad   : pad num
+ * @fmt   : pointer to v4l2 format structure
+ * @which : wanted subdev format
+ */
+static void resizer_try_format(struct isp_res_device *res,
+			       struct v4l2_subdev_fh *fh, unsigned int pad,
+			       struct v4l2_mbus_framefmt *fmt,
+			       enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_mbus_framefmt *format;
+	struct resizer_ratio ratio;
+	struct v4l2_rect crop;
+
+	switch (pad) {
+	case RESZ_PAD_SINK:
+		if (fmt->code != V4L2_MBUS_FMT_YUYV8_1X16 &&
+		    fmt->code != V4L2_MBUS_FMT_UYVY8_1X16)
+			fmt->code = V4L2_MBUS_FMT_YUYV8_1X16;
+
+		fmt->width = clamp_t(u32, fmt->width, MIN_IN_WIDTH,
+				     resizer_max_in_width(res));
+		fmt->height = clamp_t(u32, fmt->height, MIN_IN_HEIGHT,
+				      MAX_IN_HEIGHT);
+		break;
+
+	case RESZ_PAD_SOURCE:
+		format = __resizer_get_format(res, fh, RESZ_PAD_SINK, which);
+		fmt->code = format->code;
+
+		crop = *__resizer_get_crop(res, fh, which);
+		resizer_calc_ratios(res, &crop, fmt, &ratio);
+		break;
+	}
+
+	fmt->colorspace = V4L2_COLORSPACE_JPEG;
+	fmt->field = V4L2_FIELD_NONE;
+}
+
+/*
+ * resizer_enum_mbus_code - Handle pixel format enumeration
+ * @sd     : pointer to v4l2 subdev structure
+ * @fh     : V4L2 subdev file handle
+ * @code   : pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	if (code->pad == RESZ_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(resizer_formats))
+			return -EINVAL;
+
+		code->code = resizer_formats[code->index];
+	} else {
+		if (code->index != 0)
+			return -EINVAL;
+
+		format = __resizer_get_format(res, fh, RESZ_PAD_SINK,
+					      V4L2_SUBDEV_FORMAT_TRY);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+static int resizer_enum_frame_size(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	resizer_try_format(res, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	resizer_try_format(res, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * resizer_get_format - Handle get format by pads subdev method
+ * @sd    : pointer to v4l2 subdev structure
+ * @fh    : V4L2 subdev file handle
+ * @fmt   : pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on sucess
+ */
+static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __resizer_get_format(res, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+	return 0;
+}
+
+/*
+ * resizer_set_format - Handle set format by pads subdev method
+ * @sd    : pointer to v4l2 subdev structure
+ * @fh    : V4L2 subdev file handle
+ * @fmt   : pointer to v4l2 subdev format structure
+ * return -EINVAL or zero on success
+ */
+static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_format *fmt)
+{
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+	struct v4l2_rect *crop;
+
+	format = __resizer_get_format(res, fh, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	resizer_try_format(res, fh, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	if (fmt->pad == RESZ_PAD_SINK) {
+		/* reset crop rectangle */
+		crop = __resizer_get_crop(res, fh, fmt->which);
+		crop->left = 0;
+		crop->top = 0;
+		crop->width = fmt->format.width;
+		crop->height = fmt->format.height;
+
+		/* Propagate the format from sink to source */
+		format = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
+					      fmt->which);
+		*format = fmt->format;
+		resizer_try_format(res, fh, RESZ_PAD_SOURCE, format,
+				   fmt->which);
+	}
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		/* Compute and store the active crop rectangle and resizer
+		 * ratios. format already points to the source pad active
+		 * format.
+		 */
+		res->crop.active = res->crop.request;
+		resizer_calc_ratios(res, &res->crop.active, format,
+				       &res->ratio);
+	}
+
+	return 0;
+}
+
+/*
+ * resizer_init_formats - Initialize formats on all pads
+ * @sd: ISP resizer V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values. If fh is not NULL, try
+ * formats are initialized on the file handle. Otherwise active formats are
+ * initialized on the device.
+ */
+static int resizer_init_formats(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format;
+
+	memset(&format, 0, sizeof(format));
+	format.pad = RESZ_PAD_SINK;
+	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.format.code = V4L2_MBUS_FMT_YUYV8_1X16;
+	format.format.width = 4096;
+	format.format.height = 4096;
+	resizer_set_format(sd, fh, &format);
+
+	return 0;
+}
+
+/* subdev video operations */
+static const struct v4l2_subdev_video_ops resizer_v4l2_video_ops = {
+	.s_stream = resizer_set_stream,
+};
+
+/* subdev pad operations */
+static const struct v4l2_subdev_pad_ops resizer_v4l2_pad_ops = {
+	.enum_mbus_code = resizer_enum_mbus_code,
+	.enum_frame_size = resizer_enum_frame_size,
+	.get_fmt = resizer_get_format,
+	.set_fmt = resizer_set_format,
+	.get_crop = resizer_g_crop,
+	.set_crop = resizer_s_crop,
+};
+
+/* subdev operations */
+static const struct v4l2_subdev_ops resizer_v4l2_ops = {
+	.video = &resizer_v4l2_video_ops,
+	.pad = &resizer_v4l2_pad_ops,
+};
+
+/* subdev internal operations */
+static const struct v4l2_subdev_internal_ops resizer_v4l2_internal_ops = {
+	.open = resizer_init_formats,
+};
+
+/* -----------------------------------------------------------------------------
+ * Media entity operations
+ */
+
+/*
+ * resizer_link_setup - Setup resizer connections.
+ * @entity : Pointer to media entity structure
+ * @local  : Pointer to local pad array
+ * @remote : Pointer to remote pad array
+ * @flags  : Link flags
+ * return -EINVAL or zero on success
+ */
+static int resizer_link_setup(struct media_entity *entity,
+			      const struct media_pad *local,
+			      const struct media_pad *remote, u32 flags)
+{
+	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(entity);
+	struct isp_res_device *res = v4l2_get_subdevdata(sd);
+
+	switch (local->index | media_entity_type(remote->entity)) {
+	case RESZ_PAD_SINK | MEDIA_ENT_T_DEVNODE:
+		/* read from memory */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (res->input == RESIZER_INPUT_VP)
+				return -EBUSY;
+			res->input = RESIZER_INPUT_MEMORY;
+		} else {
+			if (res->input == RESIZER_INPUT_MEMORY)
+				res->input = RESIZER_INPUT_NONE;
+		}
+		break;
+
+	case RESZ_PAD_SINK | MEDIA_ENT_T_V4L2_SUBDEV:
+		/* read from ccdc or previewer */
+		if (flags & MEDIA_LNK_FL_ENABLED) {
+			if (res->input == RESIZER_INPUT_MEMORY)
+				return -EBUSY;
+			res->input = RESIZER_INPUT_VP;
+		} else {
+			if (res->input == RESIZER_INPUT_VP)
+				res->input = RESIZER_INPUT_NONE;
+		}
+		break;
+
+	case RESZ_PAD_SOURCE | MEDIA_ENT_T_DEVNODE:
+		/* resizer always write to memory */
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* media operations */
+static const struct media_entity_operations resizer_media_ops = {
+	.link_setup = resizer_link_setup,
+};
+
+/*
+ * resizer_init_entities - Initialize resizer subdev and media entity.
+ * @res : Pointer to resizer device structure
+ * return -ENOMEM or zero on success
+ */
+static int resizer_init_entities(struct isp_res_device *res)
+{
+	struct v4l2_subdev *sd = &res->subdev;
+	struct media_pad *pads = res->pads;
+	struct media_entity *me = &sd->entity;
+	int ret;
+
+	res->input = RESIZER_INPUT_NONE;
+
+	v4l2_subdev_init(sd, &resizer_v4l2_ops);
+	sd->internal_ops = &resizer_v4l2_internal_ops;
+	strlcpy(sd->name, "OMAP3 ISP resizer", sizeof(sd->name));
+	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
+	v4l2_set_subdevdata(sd, res);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	pads[RESZ_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[RESZ_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+
+	me->ops = &resizer_media_ops;
+	ret = media_entity_init(me, RESZ_PADS_NUM, pads, 0);
+	if (ret < 0)
+		return ret;
+
+	resizer_init_formats(sd, NULL);
+
+	res->video_in.type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
+	res->video_in.ops = &resizer_video_ops;
+	res->video_in.isp = to_isp_device(res);
+	res->video_in.capture_mem = PAGE_ALIGN(4096 * 4096) * 2 * 3;
+	res->video_in.bpl_alignment = 32;
+	res->video_out.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	res->video_out.ops = &resizer_video_ops;
+	res->video_out.isp = to_isp_device(res);
+	res->video_out.capture_mem = PAGE_ALIGN(4096 * 4096) * 2 * 3;
+	res->video_out.bpl_alignment = 32;
+
+	ret = omap3isp_video_init(&res->video_in, "resizer");
+	if (ret < 0)
+		return ret;
+
+	ret = omap3isp_video_init(&res->video_out, "resizer");
+	if (ret < 0)
+		return ret;
+
+	/* Connect the video nodes to the resizer subdev. */
+	ret = media_entity_create_link(&res->video_in.video.entity, 0,
+			&res->subdev.entity, RESZ_PAD_SINK, 0);
+	if (ret < 0)
+		return ret;
+
+	ret = media_entity_create_link(&res->subdev.entity, RESZ_PAD_SOURCE,
+			&res->video_out.video.entity, 0, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+void omap3isp_resizer_unregister_entities(struct isp_res_device *res)
+{
+	media_entity_cleanup(&res->subdev.entity);
+
+	v4l2_device_unregister_subdev(&res->subdev);
+	omap3isp_video_unregister(&res->video_in);
+	omap3isp_video_unregister(&res->video_out);
+}
+
+int omap3isp_resizer_register_entities(struct isp_res_device *res,
+				       struct v4l2_device *vdev)
+{
+	int ret;
+
+	/* Register the subdev and video nodes. */
+	ret = v4l2_device_register_subdev(vdev, &res->subdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap3isp_video_register(&res->video_in, vdev);
+	if (ret < 0)
+		goto error;
+
+	ret = omap3isp_video_register(&res->video_out, vdev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
+	omap3isp_resizer_unregister_entities(res);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * ISP resizer initialization and cleanup
+ */
+
+void omap3isp_resizer_cleanup(struct isp_device *isp)
+{
+}
+
+/*
+ * isp_resizer_init - Resizer initialization.
+ * @isp : Pointer to ISP device
+ * return -ENOMEM or zero on success
+ */
+int omap3isp_resizer_init(struct isp_device *isp)
+{
+	struct isp_res_device *res = &isp->isp_res;
+	int ret;
+
+	init_waitqueue_head(&res->wait);
+	atomic_set(&res->stopping, 0);
+	ret = resizer_init_entities(res);
+	if (ret < 0)
+		goto out;
+
+out:
+	if (ret)
+		omap3isp_resizer_cleanup(isp);
+
+	return ret;
+}
diff --git a/drivers/media/video/omap3-isp/ispresizer.h b/drivers/media/video/omap3-isp/ispresizer.h
new file mode 100644
index 0000000..76abc2e
--- /dev/null
+++ b/drivers/media/video/omap3-isp/ispresizer.h
@@ -0,0 +1,147 @@
+/*
+ * ispresizer.h
+ *
+ * TI OMAP3 ISP - Resizer module
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef OMAP3_ISP_RESIZER_H
+#define OMAP3_ISP_RESIZER_H
+
+#include <linux/types.h>
+
+/*
+ * Constants for filter coefficents count
+ */
+#define COEFF_CNT		32
+
+/*
+ * struct isprsz_coef - Structure for resizer filter coeffcients.
+ * @h_filter_coef_4tap: Horizontal filter coefficients for 8-phase/4-tap
+ *			mode (.5x-4x)
+ * @v_filter_coef_4tap: Vertical filter coefficients for 8-phase/4-tap
+ *			mode (.5x-4x)
+ * @h_filter_coef_7tap: Horizontal filter coefficients for 4-phase/7-tap
+ *			mode (.25x-.5x)
+ * @v_filter_coef_7tap: Vertical filter coefficients for 4-phase/7-tap
+ *			mode (.25x-.5x)
+ */
+struct isprsz_coef {
+	u16 h_filter_coef_4tap[32];
+	u16 v_filter_coef_4tap[32];
+	/* Every 8th value is a dummy value in the following arrays: */
+	u16 h_filter_coef_7tap[32];
+	u16 v_filter_coef_7tap[32];
+};
+
+/* Chrominance horizontal algorithm */
+enum resizer_chroma_algo {
+	RSZ_THE_SAME = 0,	/* Chrominance the same as Luminance */
+	RSZ_BILINEAR = 1,	/* Chrominance uses bilinear interpolation */
+};
+
+/* Resizer input type select */
+enum resizer_colors_type {
+	RSZ_YUV422 = 0,		/* YUV422 color is interleaved */
+	RSZ_COLOR8 = 1,		/* Color separate data on 8 bits */
+};
+
+/*
+ * Structure for horizontal and vertical resizing value
+ */
+struct resizer_ratio {
+	u32 horz;
+	u32 vert;
+};
+
+/*
+ * Structure for luminance enhancer parameters.
+ */
+struct resizer_luma_yenh {
+	u8 algo;		/* algorithm select. */
+	u8 gain;		/* maximum gain. */
+	u8 slope;		/* slope. */
+	u8 core;		/* core offset. */
+};
+
+enum resizer_input_entity {
+	RESIZER_INPUT_NONE,
+	RESIZER_INPUT_VP,	/* input video port - prev or ccdc */
+	RESIZER_INPUT_MEMORY,
+};
+
+/* Sink and source resizer pads */
+#define RESZ_PAD_SINK			0
+#define RESZ_PAD_SOURCE			1
+#define RESZ_PADS_NUM			2
+
+/*
+ * struct isp_res_device - OMAP3 ISP resizer module
+ * @crop.request: Crop rectangle requested by the user
+ * @crop.active: Active crop rectangle (based on hardware requirements)
+ */
+struct isp_res_device {
+	struct v4l2_subdev subdev;
+	struct media_pad pads[RESZ_PADS_NUM];
+	struct v4l2_mbus_framefmt formats[RESZ_PADS_NUM];
+
+	enum resizer_input_entity input;
+	struct isp_video video_in;
+	struct isp_video video_out;
+	unsigned int error;
+
+	u32 addr_base;   /* stored source buffer address in memory mode */
+	u32 crop_offset; /* additional offset for crop in memory mode */
+	struct resizer_ratio ratio;
+	int pm_state;
+	unsigned int applycrop:1;
+	enum isp_pipeline_stream_state state;
+	wait_queue_head_t wait;
+	atomic_t stopping;
+
+	struct {
+		struct v4l2_rect request;
+		struct v4l2_rect active;
+	} crop;
+};
+
+struct isp_device;
+
+int omap3isp_resizer_init(struct isp_device *isp);
+void omap3isp_resizer_cleanup(struct isp_device *isp);
+
+int omap3isp_resizer_register_entities(struct isp_res_device *res,
+				       struct v4l2_device *vdev);
+void omap3isp_resizer_unregister_entities(struct isp_res_device *res);
+void omap3isp_resizer_isr_frame_sync(struct isp_res_device *res);
+void omap3isp_resizer_isr(struct isp_res_device *isp_res);
+
+void omap3isp_resizer_max_rate(struct isp_res_device *res,
+			       unsigned int *max_rate);
+
+void omap3isp_resizer_suspend(struct isp_res_device *isp_res);
+
+void omap3isp_resizer_resume(struct isp_res_device *isp_res);
+
+int omap3isp_resizer_busy(struct isp_res_device *isp_res);
+
+#endif	/* OMAP3_ISP_RESIZER_H */
diff --git a/drivers/media/video/omap3-isp/luma_enhance_table.h b/drivers/media/video/omap3-isp/luma_enhance_table.h
new file mode 100644
index 0000000..098b45e
--- /dev/null
+++ b/drivers/media/video/omap3-isp/luma_enhance_table.h
@@ -0,0 +1,42 @@
+/*
+ * luma_enhance_table.h
+ *
+ * TI OMAP3 ISP - Luminance enhancement table
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+1047552, 1047552, 1047552, 1047552, 1047552, 1047552, 1047552, 1047552,
+1047552, 1047552, 1047552, 1047552, 1047552, 1047552, 1047552, 1047552,
+1047552, 1047552, 1047552, 1047552, 1047552, 1047552, 1047552, 1047552,
+1047552, 1047552, 1047552, 1047552, 1048575, 1047551, 1046527, 1045503,
+1044479, 1043455, 1042431, 1041407, 1040383, 1039359, 1038335, 1037311,
+1036287, 1035263, 1034239, 1033215, 1032191, 1031167, 1030143, 1028096,
+1028096, 1028096, 1028096, 1028096, 1028096, 1028096, 1028096, 1028096,
+1028096, 1028100, 1032196, 1036292, 1040388, 1044484,       0,       0,
+      0,       5,    5125,   10245,   15365,   20485,   25605,   30720,
+  30720,   30720,   30720,   30720,   30720,   30720,   30720,   30720,
+  30720,   30720,   31743,   30719,   29695,   28671,   27647,   26623,
+  25599,   24575,   23551,   22527,   21503,   20479,   19455,   18431,
+  17407,   16383,   15359,   14335,   13311,   12287,   11263,   10239,
+   9215,    8191,    7167,    6143,    5119,    4095,    3071,    1024,
+   1024,    1024,    1024,    1024,    1024,    1024,    1024,    1024,
+   1024,    1024,    1024,    1024,    1024,    1024,    1024,    1024
diff --git a/drivers/media/video/omap3-isp/noise_filter_table.h b/drivers/media/video/omap3-isp/noise_filter_table.h
new file mode 100644
index 0000000..c22768d
--- /dev/null
+++ b/drivers/media/video/omap3-isp/noise_filter_table.h
@@ -0,0 +1,30 @@
+/*
+ * noise_filter_table.h
+ *
+ * TI OMAP3 ISP - Noise filter table
+ *
+ * Copyright (C) 2010 Nokia Corporation
+ * Copyright (C) 2009 Texas Instruments, Inc.
+ *
+ * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *	     Sakari Ailus <sakari.ailus@iki.fi>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,
+16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,
+31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31,
+31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31, 31 
-- 
1.7.3.4

