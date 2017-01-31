Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:4175 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751274AbdAaQcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 11:32:23 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v5 06/10] [media] st-delta: add memory allocator helper functions
Date: Tue, 31 Jan 2017 17:30:29 +0100
Message-ID: <1485880233-666-7-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1485880233-666-1-git-send-email-hugues.fruchet@st.com>
References: <1485880233-666-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Helper functions used by decoder back-ends to allocate
physically contiguous memory required by hardware video
decoder.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/platform/sti/delta/Makefile    |  2 +-
 drivers/media/platform/sti/delta/delta-mem.c | 51 ++++++++++++++++++++++++++++
 drivers/media/platform/sti/delta/delta-mem.h | 14 ++++++++
 drivers/media/platform/sti/delta/delta.h     |  8 +++++
 4 files changed, 74 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.c
 create mode 100644 drivers/media/platform/sti/delta/delta-mem.h

diff --git a/drivers/media/platform/sti/delta/Makefile b/drivers/media/platform/sti/delta/Makefile
index 07ba7ad..cbfb1b5 100644
--- a/drivers/media/platform/sti/delta/Makefile
+++ b/drivers/media/platform/sti/delta/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_VIDEO_STI_DELTA) := st-delta.o
-st-delta-y := delta-v4l2.o
+st-delta-y := delta-v4l2.o delta-mem.o
diff --git a/drivers/media/platform/sti/delta/delta-mem.c b/drivers/media/platform/sti/delta/delta-mem.c
new file mode 100644
index 0000000..d7b53d3
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mem.c
@@ -0,0 +1,51 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include "delta.h"
+#include "delta-mem.h"
+
+int hw_alloc(struct delta_ctx *ctx, u32 size, const char *name,
+	     struct delta_buf *buf)
+{
+	struct delta_dev *delta = ctx->dev;
+	dma_addr_t dma_addr;
+	void *addr;
+	unsigned long attrs = DMA_ATTR_WRITE_COMBINE;
+
+	addr = dma_alloc_attrs(delta->dev, size, &dma_addr,
+			       GFP_KERNEL | __GFP_NOWARN, attrs);
+	if (!addr) {
+		dev_err(delta->dev,
+			"%s hw_alloc:dma_alloc_coherent failed for %s (size=%d)\n",
+			ctx->name, name, size);
+		ctx->sys_errors++;
+		return -ENOMEM;
+	}
+
+	buf->size = size;
+	buf->paddr = dma_addr;
+	buf->vaddr = addr;
+	buf->name = name;
+	buf->attrs = attrs;
+
+	dev_dbg(delta->dev,
+		"%s allocate %d bytes of HW memory @(virt=0x%p, phy=0x%pad): %s\n",
+		ctx->name, size, buf->vaddr, &buf->paddr, buf->name);
+
+	return 0;
+}
+
+void hw_free(struct delta_ctx *ctx, struct delta_buf *buf)
+{
+	struct delta_dev *delta = ctx->dev;
+
+	dev_dbg(delta->dev,
+		"%s     free %d bytes of HW memory @(virt=0x%p, phy=0x%pad): %s\n",
+		ctx->name, buf->size, buf->vaddr, &buf->paddr, buf->name);
+
+	dma_free_attrs(delta->dev, buf->size,
+		       buf->vaddr, buf->paddr, buf->attrs);
+}
diff --git a/drivers/media/platform/sti/delta/delta-mem.h b/drivers/media/platform/sti/delta/delta-mem.h
new file mode 100644
index 0000000..f8ca109
--- /dev/null
+++ b/drivers/media/platform/sti/delta/delta-mem.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) STMicroelectronics SA 2015
+ * Author: Hugues Fruchet <hugues.fruchet@st.com> for STMicroelectronics.
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#ifndef DELTA_MEM_H
+#define DELTA_MEM_H
+
+int hw_alloc(struct delta_ctx *ctx, u32 size, const char *name,
+	     struct delta_buf *buf);
+void hw_free(struct delta_ctx *ctx, struct delta_buf *buf);
+
+#endif /* DELTA_MEM_H */
diff --git a/drivers/media/platform/sti/delta/delta.h b/drivers/media/platform/sti/delta/delta.h
index 74a4240..9e26525 100644
--- a/drivers/media/platform/sti/delta/delta.h
+++ b/drivers/media/platform/sti/delta/delta.h
@@ -191,6 +191,14 @@ struct delta_dts {
 	u64 val;
 };
 
+struct delta_buf {
+	u32 size;
+	void *vaddr;
+	dma_addr_t paddr;
+	const char *name;
+	unsigned long attrs;
+};
+
 struct delta_ctx;
 
 /*
-- 
1.9.1

