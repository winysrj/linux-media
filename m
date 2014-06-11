Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:56047 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaFKGgd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 02:36:33 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: prabhakar.csengg@gmail.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Subject: [PATCH v3.1 2/4] smiapp: Add driver-specific test pattern menu item definitions
Date: Wed, 11 Jun 2014 09:36:28 +0300
Message-Id: <1402468588-27792-1-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
References: <1401374448-30411-3-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add numeric definitions for menu items used in the smiapp driver's test
pattern menu.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
since v3:
- Add Kbuild entry for the header

 include/uapi/linux/Kbuild   |  1 +
 include/uapi/linux/smiapp.h | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)
 create mode 100644 include/uapi/linux/smiapp.h

diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 6929571..a3ee163 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -352,6 +352,7 @@ header-y += serio.h
 header-y += shm.h
 header-y += signal.h
 header-y += signalfd.h
+header-y += smiapp.h
 header-y += snmp.h
 header-y += sock_diag.h
 header-y += socket.h
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

