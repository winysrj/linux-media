Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46715 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294AbaGWP3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 11:29:35 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 7/8] [media] coda: move H.264 helper function into separate file
Date: Wed, 23 Jul 2014 17:28:44 +0200
Message-Id: <1406129325-10771-8-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
References: <1406129325-10771-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently there is only the coda_h264_padding function, but
we will have to add more H.264 specific helpers later.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda/Makefile      |  2 +-
 drivers/media/platform/coda/coda-common.c | 22 -------------------
 drivers/media/platform/coda/coda-h264.c   | 36 +++++++++++++++++++++++++++++++
 drivers/media/platform/coda/coda.h        |  2 ++
 4 files changed, 39 insertions(+), 23 deletions(-)
 create mode 100644 drivers/media/platform/coda/coda-h264.c

diff --git a/drivers/media/platform/coda/Makefile b/drivers/media/platform/coda/Makefile
index 13d9ad6..0e59fbd 100644
--- a/drivers/media/platform/coda/Makefile
+++ b/drivers/media/platform/coda/Makefile
@@ -1,3 +1,3 @@
-coda-objs := coda-common.o
+coda-objs := coda-common.o coda-h264.o
 
 obj-$(CONFIG_VIDEO_CODA) += coda.o
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index df0470e..5226dea 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -72,10 +72,6 @@ struct coda_fmt {
 	u32 fourcc;
 };
 
-static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
-			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80 };
-static const u8 coda_filler_size[8] = { 0, 7, 14, 13, 12, 11, 10, 9 };
-
 void coda_write(struct coda_dev *dev, u32 data, u32 reg)
 {
 	v4l2_dbg(1, coda_debug, &dev->v4l2_dev,
@@ -1629,24 +1625,6 @@ static int coda_alloc_framebuffers(struct coda_ctx *ctx, struct coda_q_data *q_d
 	return 0;
 }
 
-static int coda_h264_padding(int size, char *p)
-{
-	int nal_size;
-	int diff;
-
-	diff = size - (size & ~0x7);
-	if (diff == 0)
-		return 0;
-
-	nal_size = coda_filler_size[diff];
-	memcpy(p, coda_filler_nal, nal_size);
-
-	/* Add rbsp stop bit and trailing at the end */
-	*(p + nal_size - 1) = 0x80;
-
-	return nal_size;
-}
-
 static phys_addr_t coda_iram_alloc(struct coda_iram_info *iram, size_t size)
 {
 	phys_addr_t ret;
diff --git a/drivers/media/platform/coda/coda-h264.c b/drivers/media/platform/coda/coda-h264.c
new file mode 100644
index 0000000..0b2fdbe
--- /dev/null
+++ b/drivers/media/platform/coda/coda-h264.c
@@ -0,0 +1,36 @@
+/*
+ * Coda multi-standard codec IP - H.264 helper functions
+ *
+ * Copyright (C) 2012 Vista Silicon S.L.
+ *    Javier Martin, <javier.martin@vista-silicon.com>
+ *    Xavier Duret
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+
+static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
+			0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x80 };
+static const u8 coda_filler_size[8] = { 0, 7, 14, 13, 12, 11, 10, 9 };
+
+int coda_h264_padding(int size, char *p)
+{
+	int nal_size;
+	int diff;
+
+	diff = size - (size & ~0x7);
+	if (diff == 0)
+		return 0;
+
+	nal_size = coda_filler_size[diff];
+	memcpy(p, coda_filler_nal, nal_size);
+
+	/* Add rbsp stop bit and trailing at the end */
+	*(p + nal_size - 1) = 0x80;
+
+	return nal_size;
+}
diff --git a/drivers/media/platform/coda/coda.h b/drivers/media/platform/coda/coda.h
index c98270c..84e0829 100644
--- a/drivers/media/platform/coda/coda.h
+++ b/drivers/media/platform/coda/coda.h
@@ -227,3 +227,5 @@ struct coda_ctx {
 	int				display_idx;
 	struct dentry			*debugfs_entry;
 };
+
+int coda_h264_padding(int size, char *p);
-- 
2.0.1

