Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26293 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab0GOJKv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jul 2010 05:10:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 15 Jul 2010 11:10:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 03/10 v2] ARM: Samsung: Add platform definitions for local
 FIMC/FIMD fifo path
In-reply-to: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	linux-media@vger.kernel.org, ben-linux@fluff.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1279185041-6004-4-git-send-email-s.nawrocki@samsung.com>
References: <1279185041-6004-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Marek Szyprowski <m.szyprowski@samsung.com>

Add a common s3c_fifo_link structure that describes a local path link
between 2 multimedia devices (like FIMC and FrameBuffer).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 arch/arm/plat-samsung/include/plat/fifo.h |   37 +++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-samsung/include/plat/fifo.h

diff --git a/arch/arm/plat-samsung/include/plat/fifo.h b/arch/arm/plat-samsung/include/plat/fifo.h
new file mode 100644
index 0000000..84d242b
--- /dev/null
+++ b/arch/arm/plat-samsung/include/plat/fifo.h
@@ -0,0 +1,37 @@
+/*
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef FIFO_H_
+#define FIFO_H_
+
+#include <linux/device.h>
+#include <media/v4l2-subdev.h>
+
+/*
+ * The multimedia devices contained in Samsung S3C/S5P SoC series
+ * like framebuffer, camera interface or tv scaler can transfer data
+ * directly between each other through hardware fifo channels.
+ * s3c_fifo_link data structure is an abstraction for such links,
+ * it allows to define V4L2 device drivers hierarchy according to
+ * the hardware structure. Fifo links are mostly unidirectional, exclusive
+ * data buses. To control data transfer in fifo mode synchronization is
+ * is required between drivers at both ends of the fifo channel
+ * (master_dev, slave_dev). s3c_fifo_link:sub_dev is intended  to export
+ * in a consistent way all the functionality of the slave device required
+ * at master device driver to enable transfer through fifo channel.
+ * master_dev and slave_dev is to be setup by the platform code whilst
+ * sub_dev entry will mostly be initlized during slave_dev probe().
+ */
+struct s3c_fifo_link {
+	struct device		*master_dev;
+	struct device		*slave_dev;
+	struct v4l2_subdev	*sub_dev;
+};
+
+#endif /* FIFO_H_ */
+
-- 
1.7.0.4

