Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62661 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWWWO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 17:22:14 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so4217060eek.5
        for <linux-media@vger.kernel.org>; Wed, 23 Jan 2013 14:22:13 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sylvester.nawrocki@gmail.com
Subject: [PATCH RFC v3 1/6] [media] Add header file defining standard image sizes
Date: Wed, 23 Jan 2013 23:21:56 +0100
Message-Id: <1358979721-17473-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1358979721-17473-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add common header file defining standard image sizes, so we can
avoid redefining those in each driver.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---

Changes since v2:
 - the file rename image-sizes.h -> v4l2-image-sizes.h
---
 include/media/v4l2-image-sizes.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 include/media/v4l2-image-sizes.h

diff --git a/include/media/v4l2-image-sizes.h b/include/media/v4l2-image-sizes.h
new file mode 100644
index 0000000..10daf92
--- /dev/null
+++ b/include/media/v4l2-image-sizes.h
@@ -0,0 +1,34 @@
+/*
+ * Standard image size definitions
+ *
+ * Copyright (C) 2013, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _IMAGE_SIZES_H
+#define _IMAGE_SIZES_H
+
+#define CIF_WIDTH	352
+#define CIF_HEIGHT	288
+
+#define QCIF_WIDTH	176
+#define QCIF_HEIGHT	144
+
+#define QQCIF_WIDTH	88
+#define QQCIF_HEIGHT	72
+
+#define QQVGA_WIDTH	160
+#define QQVGA_HEIGHT	120
+
+#define QVGA_WIDTH	320
+#define QVGA_HEIGHT	240
+
+#define SXGA_WIDTH	1280
+#define SXGA_HEIGHT	1024
+
+#define VGA_WIDTH	640
+#define VGA_HEIGHT	480
+
+#endif /* _IMAGE_SIZES_H */
-- 
1.7.4.1

