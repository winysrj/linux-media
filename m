Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:45475 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZEOSgY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2009 14:36:24 -0400
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id n4FIaLWA022272
	for <linux-media@vger.kernel.org>; Fri, 15 May 2009 13:36:26 -0500
From: m-karicheri2@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/9] ccdc hw device header file for vpfe capture
Date: Fri, 15 May 2009 14:36:19 -0400
Message-Id: <1242412579-11355-1-git-send-email-m-karicheri2@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Muralidharan Karicheri <a0868495@gt516km11.gt.design.ti.com>

CCDC hw device header file

Adds ccdc hw device header for vpfe capture driver

This has comments incorporated from previous review.

Reviewed By "Hans Verkuil".
Reviewed By "Laurent Pinchart".

Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
---
Applies to v4l-dvb repository

 include/media/davinci/ccdc_hw_device.h |  109 ++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 include/media/davinci/ccdc_hw_device.h

diff --git a/include/media/davinci/ccdc_hw_device.h b/include/media/davinci/ccdc_hw_device.h
new file mode 100644
index 0000000..71904f3
--- /dev/null
+++ b/include/media/davinci/ccdc_hw_device.h
@@ -0,0 +1,109 @@
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
+	/* set ccdc base address */
+	void (*set_ccdc_base)(void *base, int size);
+	/* set vpss base address */
+	void (*set_vpss_base)(void *base, int size);
+	void (*enable) (int en);
+	/* Pointer to function to enable or disable ccdc */
+	void (*reset) (void);
+	/* reset sbl. only for 6446 */
+	void (*enable_out_to_sdram) (int en);
+	/* Pointer to function to set hw frame type */
+	int (*set_hw_if_params) (struct vpfe_hw_if_param *param);
+	/* get interface parameters */
+	int (*get_hw_if_params) (struct vpfe_hw_if_param *param);
+	/*
+	 * Pointer to function to set parameters. Used
+	 * for implementing VPFE_S_CCDC_PARAMS
+	 */
+	int (*setparams) (void *params);
+	/*
+	 * Pointer to function to get parameter. Used
+	 * for implementing VPFE_G_CCDC_PARAMS
+	 */
+	int (*getparams) (void *params);
+	/* Pointer to function to configure ccdc */
+	int (*configure) (void);
+	/* enumerate hw pix formats */
+	int (*enum_pix)(enum vpfe_hw_pix_format *hw_pix, int i);
+	/* Pointer to function to set buffer type */
+	int (*set_buftype) (enum ccdc_buftype buf_type);
+	/* Pointer to function to get buffer type */
+	enum ccdc_buftype (*get_buftype) (void);
+	/* Pointer to function to set frame format */
+	int (*set_frame_format) (enum ccdc_frmfmt frm_fmt);
+	/* Pointer to function to get frame format */
+	enum ccdc_frmfmt (*get_frame_format) (void);
+	/* Pointer to function to set buffer type */
+	enum vpfe_hw_pix_format (*get_pixelformat) (void);
+	/* Pointer to function to get pixel format. */
+	int (*set_pixelformat) (enum vpfe_hw_pix_format pixfmt);
+	/* Pointer to function to set image window */
+	int (*set_image_window) (struct v4l2_rect *win);
+	/* Pointer to function to set image window */
+	void (*get_image_window) (struct v4l2_rect *win);
+	/* Pointer to function to get line length */
+	unsigned int (*get_line_length) (void);
+
+	/* Query SoC control IDs */
+	int (*queryctrl)(struct v4l2_queryctrl *qctrl);
+	/* Set SoC control */
+	int (*setcontrol)(struct v4l2_control *ctrl);
+	/* Get SoC control */
+	int (*getcontrol)(struct v4l2_control *ctrl);
+	/* Pointer to function to set frame buffer address */
+	void (*setfbaddr) (unsigned long addr);
+	/* Pointer to function to get field id */
+	int (*getfid) (void);
+};
+
+struct ccdc_hw_device {
+	/* ccdc device name */
+	char name[30];
+	/* module owner */
+	struct module *owner;
+	/* Pointer to initialize function to initialize ccdc device */
+	int (*open) (struct device *dev);
+	/* Pointer to deinitialize function */
+	int (*close) (struct device *dev);
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

