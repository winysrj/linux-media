Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10777 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbaE2Ola (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 May 2014 10:41:30 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [PATCH v3 2/3] smiapp: Add driver-specific test pattern menu item definitions
Date: Thu, 29 May 2014 17:40:47 +0300
Message-Id: <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add numeric definitions for menu items used in the smiapp driver's test
pattern menu.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 include/uapi/linux/smiapp.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)
 create mode 100644 include/uapi/linux/smiapp.h

diff --git a/include/uapi/linux/smiapp.h b/include/uapi/linux/smiapp.h
new file mode 100644
index 0000000..53938f4
--- /dev/null
+++ b/include/uapi/linux/smiapp.h
@@ -0,0 +1,29 @@
+/*
+ * include/uapi/linux/smiapp.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2014 Intel Corporation
+ * Contact: Sakari Ailus <sakari.ailus@iki.fi>
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
+ */
+
+#ifndef __UAPI_LINUX_SMIAPP_H_
+#define __UAPI_LINUX_SMIAPP_H_
+
+#define V4L2_SMIAPP_TEST_PATTERN_MODE_DISABLED			0
+#define V4L2_SMIAPP_TEST_PATTERN_MODE_SOLID_COLOUR		1
+#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS		2
+#define V4L2_SMIAPP_TEST_PATTERN_MODE_COLOUR_BARS_GREY		3
+#define V4L2_SMIAPP_TEST_PATTERN_MODE_PN9			4
+
+#endif /* __UAPI_LINUX_SMIAPP_H_ */
-- 
1.8.3.2

