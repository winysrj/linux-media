Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:44328 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753396AbdJTVvI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:51:08 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [RFC v4 14/17] [media] vb2: add videobuf2 dma-buf fence helpers
Date: Fri, 20 Oct 2017 19:50:09 -0200
Message-Id: <20171020215012.20646-15-gustavo@padovan.org>
In-Reply-To: <20171020215012.20646-1-gustavo@padovan.org>
References: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Javier Martinez Canillas <javier@osg.samsung.com>

Add a videobuf2-fence.h header file that contains different helpers
for DMA buffer sharing explicit fence support in videobuf2.

v2:	- use fence context provided by the caller in vb2_fence_alloc()

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-fence.h | 48 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)
 create mode 100644 include/media/videobuf2-fence.h

diff --git a/include/media/videobuf2-fence.h b/include/media/videobuf2-fence.h
new file mode 100644
index 000000000000..b49cc1bf6bb4
--- /dev/null
+++ b/include/media/videobuf2-fence.h
@@ -0,0 +1,48 @@
+/*
+ * videobuf2-fence.h - DMA buffer sharing fence helpers for videobuf 2
+ *
+ * Copyright (C) 2016 Samsung Electronics
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/dma-fence.h>
+#include <linux/slab.h>
+
+static DEFINE_SPINLOCK(vb2_fence_lock);
+
+static inline const char *vb2_fence_get_driver_name(struct dma_fence *fence)
+{
+	return "vb2_fence";
+}
+
+static inline const char *vb2_fence_get_timeline_name(struct dma_fence *fence)
+{
+	return "vb2_fence_timeline";
+}
+
+static inline bool vb2_fence_enable_signaling(struct dma_fence *fence)
+{
+	return true;
+}
+
+static const struct dma_fence_ops vb2_fence_ops = {
+	.get_driver_name = vb2_fence_get_driver_name,
+	.get_timeline_name = vb2_fence_get_timeline_name,
+	.enable_signaling = vb2_fence_enable_signaling,
+	.wait = dma_fence_default_wait,
+};
+
+static inline struct dma_fence *vb2_fence_alloc(u64 context)
+{
+	struct dma_fence *vb2_fence = kzalloc(sizeof(*vb2_fence), GFP_KERNEL);
+
+	if (!vb2_fence)
+		return NULL;
+
+	dma_fence_init(vb2_fence, &vb2_fence_ops, &vb2_fence_lock, context, 1);
+
+	return vb2_fence;
+}
-- 
2.13.6
