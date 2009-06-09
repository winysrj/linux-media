Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:51375 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbZFISxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2009 14:53:44 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id n59IrfjL021040
	for <linux-media@vger.kernel.org>; Tue, 9 Jun 2009 13:53:46 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/10 - v2] ccdc hw device header file for vpfe capture
Date: Tue,  9 Jun 2009 14:53:40 -0400
Message-Id: <1244573620-20739-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

CCDC hw device header file

Adds ccdc hw device header for vpfe capture driver

Incorporated review comments against previous patch

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 drivers/media/video/davinci/ccdc_hw_device.h |  110 ++++++++++++++++++++++++++
 1 files changed, 110 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/davinci/ccdc_hw_device.h

diff --git a/drivers/media/video/davinci/ccdc_hw_device.h b/drivers/media/video/davinci/ccdc_hw_device.h
new file mode 100644
index 0000000..86b9b35
--- /dev/null
+++ b/drivers/media/video/davinci/ccdc_hw_device.h
@@ -0,0 +1,110 @@
+/*
+ * Copyright (C) 2008-2009 Texas Instruments Inc
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ * ccdc device API
+ */
+#ifndef _CCDC_HW_DEVICE_H
+#define _CCDC_HW_DEVICE_H
+
+#ifdef __KERNEL__
+#include <linux/videodev2.h>
+#include <linux/device.h>
+#include <media/davinci/vpfe_types.h>
+#include <media/davinci/ccdc_types.h>
+
+/*
+ * ccdc hw operations
+ */
+struct ccdc_hw_ops {
+	/* Pointer to initialize function to initialize ccdc device */
+	int (*open) (struct device *dev);
+	/* Pointer to deinitialize function */
+	int (*close) (struct device *dev);
+	/* set ccdc base address */
+	void (*set_ccdc_base)(void *base, int size);
+	/* Pointer to function to enable or disable ccdc */
+	void (*enable) (int en);
+	/* reset sbl. only for 6446 */
+	void (*reset) (void);
+	/* enable output to sdram */
+	void (*enable_out_to_sdram) (int en);
+	/* Pointer to function to set hw parameters */
+	int (*set_hw_if_params) (struct vpfe_hw_if_param *param);
+	/* get interface parameters */
+	int (*get_hw_if_params) (struct vpfe_hw_if_param *param);
+	/*
+	 * Pointer to function to set parameters. Used
+	 * for implementing VPFE_S_CCDC_PARAMS
+	 */
+	int (*set_params) (void *params);
+	/*
+	 * Pointer to function to get parameter. Used
+	 * for implementing VPFE_G_CCDC_PARAMS
+	 */
+	int (*get_params) (void *params);
+	/* Pointer to function to configure ccdc */
+	int (*configure) (void);
+
+	/* Pointer to function to set buffer type */
+	int (*set_buftype) (enum ccdc_buftype buf_type);
+	/* Pointer to function to get buffer type */
+	enum ccdc_buftype (*get_buftype) (void);
+	/* Pointer to function to set frame format */
+	int (*set_frame_format) (enum ccdc_frmfmt frm_fmt);
+	/* Pointer to function to get frame format */
+	enum ccdc_frmfmt (*get_frame_format) (void);
+	/* enumerate hw pix formats */
+	int (*enum_pix)(u32 *hw_pix, int i);
+	/* Pointer to function to set buffer type */
+	u32 (*get_pixel_format) (void);
+	/* Pointer to function to get pixel format. */
+	int (*set_pixel_format) (u32 pixfmt);
+	/* Pointer to function to set image window */
+	int (*set_image_window) (struct v4l2_rect *win);
+	/* Pointer to function to set image window */
+	void (*get_image_window) (struct v4l2_rect *win);
+	/* Pointer to function to get line length */
+	unsigned int (*get_line_length) (void);
+
+	/* Query CCDC control IDs */
+	int (*queryctrl)(struct v4l2_queryctrl *qctrl);
+	/* Set CCDC control */
+	int (*set_control)(struct v4l2_control *ctrl);
+	/* Get CCDC control */
+	int (*get_control)(struct v4l2_control *ctrl);
+
+	/* Pointer to function to set frame buffer address */
+	void (*setfbaddr) (unsigned long addr);
+	/* Pointer to function to get field id */
+	int (*getfid) (void);
+};
+
+struct ccdc_hw_device {
+	/* ccdc device name */
+	char name[32];
+	/* module owner */
+	struct module *owner;
+	/* hw ops */
+	struct ccdc_hw_ops hw_ops;
+};
+
+/* Used by CCDC module to register & unregister with vpfe capture driver */
+int vpfe_register_ccdc_device(struct ccdc_hw_device *dev);
+void vpfe_unregister_ccdc_device(struct ccdc_hw_device *dev);
+
+#endif
+#endif
-- 
1.6.0.4

