Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:34756 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756009AbdIGSnU (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Sep 2017 14:43:20 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH v3 12/15] [media] vb2: add videobuf2 dma-buf fence helpers
Date: Thu,  7 Sep 2017 15:42:23 -0300
Message-Id: <20170907184226.27482-13-gustavo@padovan.org>
In-Reply-To: <20170907184226.27482-1-gustavo@padovan.org>
References: <20170907184226.27482-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Javier Martinez Canillas <javier@osg.samsung.com>

Add a videobuf2-fence.h header file that contains different helpers
for DMA buffer sharing explicit fence support in videobuf2.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 include/media/videobuf2-fence.h | 49 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 include/media/videobuf2-fence.h

diff --git a/include/media/videobuf2-fence.h b/include/media/videobuf2-fence.h
new file mode 100644
index 000000000000..ed5612ca03d6
--- /dev/null
+++ b/include/media/videobuf2-fence.h
@@ -0,0 +1,49 @@
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
+static inline struct dma_fence *vb2_fence_alloc(void)
+{
+	struct dma_fence *vb2_fence = kzalloc(sizeof(*vb2_fence), GFP_KERNEL);
+
+	if (!vb2_fence)
+		return NULL;
+
+	dma_fence_init(vb2_fence, &vb2_fence_ops, &vb2_fence_lock,
+		       dma_fence_context_alloc(1), 1);
+
+	return vb2_fence;
+}
-- 
2.13.5
