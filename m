Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:45710 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749Ab3ADXQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 18:16:03 -0500
Received: by mail-ee0-f53.google.com with SMTP id c50so8165729eek.12
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 15:16:01 -0800 (PST)
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: [PATCH RFC v1 1/2] [media] Add header file defining standard image sizes
Date: Sat,  5 Jan 2013 00:10:22 +0100
Message-Id: <1357341023-3202-2-git-send-email-sylvester.nawrocki@gmail.com>
In-Reply-To: <1357341023-3202-1-git-send-email-sylvester.nawrocki@gmail.com>
References: <1357341023-3202-1-git-send-email-sylvester.nawrocki@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add common header file defining standard image sizes, so we can
avoid redefining those in each driver.

Signed-off-by: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
---
 include/media/image-sizes.h |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 include/media/image-sizes.h

diff --git a/include/media/image-sizes.h b/include/media/image-sizes.h
new file mode 100644
index 0000000..464b69a
--- /dev/null
+++ b/include/media/image-sizes.h
@@ -0,0 +1,34 @@
+/*
+ * Standard image size definitions
+ *
+ * Copyright (C) 2012, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
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
+#define VGA_WIDTH	640
+#define VGA_HEIGHT	480
+
+#define SXGA_WIDTH	1280
+#define SXGA_HEIGHT	1024
+
+#endif /* _IMAGE_SIZES_H */
-- 
1.7.4.1

