Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f179.google.com ([209.85.216.179]:34152 "EHLO
	mail-qt0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbcFDXx7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2016 19:53:59 -0400
Received: by mail-qt0-f179.google.com with SMTP id q45so6222924qtq.1
        for <linux-media@vger.kernel.org>; Sat, 04 Jun 2016 16:53:59 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [RESEND/PATCH 2/6] tw686x: Add support for DMA contiguous interlaced frame mode
Date: Sat,  4 Jun 2016 20:47:16 -0300
Message-Id: <1465084040-6112-3-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1465084040-6112-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1465084040-6112-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the driver has the infrastructure to support more
DMA modes, let's add the DMA contiguous interlaced frame mode.

In this mode, the DMA P and B buffers are programmed with
the user-provided buffers. When a P (or B) frame is ready,
a new buffer is dequeued into P (or B).

In addition to interlaced fields, the device can also be
programmed to deliver alternate fields. Only interlaced
mode is supported for now.

Tested-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/pci/tw686x/Kconfig        |  1 +
 drivers/media/pci/tw686x/tw686x-core.c  |  4 +++
 drivers/media/pci/tw686x/tw686x-video.c | 50 +++++++++++++++++++++++++++++++++
 drivers/media/pci/tw686x/tw686x.h       |  1 +
 4 files changed, 56 insertions(+)

diff --git a/drivers/media/pci/tw686x/Kconfig b/drivers/media/pci/tw686x/Kconfig
index fb8536974052..ef8ca85522f8 100644
--- a/drivers/media/pci/tw686x/Kconfig
+++ b/drivers/media/pci/tw686x/Kconfig
@@ -3,6 +3,7 @@ config VIDEO_TW686X
 	depends on PCI && VIDEO_DEV && VIDEO_V4L2 && SND
 	depends on HAS_DMA
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	select SND_PCM
 	help
 	  Support for Intersil/Techwell TW686x-based frame grabber cards.
diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
index 01c06bb59e78..9a7646c0f9f6 100644
--- a/drivers/media/pci/tw686x/tw686x-core.c
+++ b/drivers/media/pci/tw686x/tw686x-core.c
@@ -63,6 +63,8 @@ static const char *dma_mode_name(unsigned int mode)
 	switch (mode) {
 	case TW686X_DMA_MODE_MEMCPY:
 		return "memcpy";
+	case TW686X_DMA_MODE_CONTIG:
+		return "contig";
 	default:
 		return "unknown";
 	}
@@ -77,6 +79,8 @@ static int tw686x_dma_mode_set(const char *val, struct kernel_param *kp)
 {
 	if (!strcasecmp(val, dma_mode_name(TW686X_DMA_MODE_MEMCPY)))
 		dma_mode = TW686X_DMA_MODE_MEMCPY;
+	else if (!strcasecmp(val, dma_mode_name(TW686X_DMA_MODE_CONTIG)))
+		dma_mode = TW686X_DMA_MODE_CONTIG;
 	else
 		return -EINVAL;
 	return 0;
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index c0d2a9bd5414..b5cb385e4cb1 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -19,6 +19,7 @@
 #include <linux/slab.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-event.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 #include "tw686x.h"
 #include "tw686x-regs.h"
@@ -148,6 +149,53 @@ const struct tw686x_dma_ops memcpy_dma_ops = {
 	.field		= V4L2_FIELD_INTERLACED,
 };
 
+static void tw686x_contig_buf_refill(struct tw686x_video_channel *vc,
+				     unsigned int pb)
+{
+	struct tw686x_v4l2_buf *buf;
+
+	while (!list_empty(&vc->vidq_queued)) {
+		u32 reg = pb ? VDMA_B_ADDR[vc->ch] : VDMA_P_ADDR[vc->ch];
+		dma_addr_t phys;
+
+		buf = list_first_entry(&vc->vidq_queued,
+			struct tw686x_v4l2_buf, list);
+		list_del(&buf->list);
+
+		phys = vb2_dma_contig_plane_dma_addr(&buf->vb.vb2_buf, 0);
+		reg_write(vc->dev, reg, phys);
+
+		buf->vb.vb2_buf.state = VB2_BUF_STATE_ACTIVE;
+		vc->curr_bufs[pb] = buf;
+		return;
+	}
+	vc->curr_bufs[pb] = NULL;
+}
+
+static void tw686x_contig_cleanup(struct tw686x_dev *dev)
+{
+	vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+}
+
+static int tw686x_contig_setup(struct tw686x_dev *dev)
+{
+	dev->alloc_ctx = vb2_dma_contig_init_ctx(&dev->pci_dev->dev);
+	if (IS_ERR(dev->alloc_ctx)) {
+		dev_err(&dev->pci_dev->dev, "unable to init DMA context\n");
+		return PTR_ERR(dev->alloc_ctx);
+	}
+	return 0;
+}
+
+const struct tw686x_dma_ops contig_dma_ops = {
+	.setup		= tw686x_contig_setup,
+	.cleanup	= tw686x_contig_cleanup,
+	.buf_refill	= tw686x_contig_buf_refill,
+	.mem_ops	= &vb2_dma_contig_memops,
+	.hw_dma_mode	= TW686X_FRAME_MODE,
+	.field		= V4L2_FIELD_INTERLACED,
+};
+
 static unsigned int tw686x_fields_map(v4l2_std_id std, unsigned int fps)
 {
 	static const unsigned int map[15] = {
@@ -841,6 +889,8 @@ int tw686x_video_init(struct tw686x_dev *dev)
 
 	if (dev->dma_mode == TW686X_DMA_MODE_MEMCPY)
 		dev->dma_ops = &memcpy_dma_ops;
+	else if (dev->dma_mode == TW686X_DMA_MODE_CONTIG)
+		dev->dma_ops = &contig_dma_ops;
 	else
 		return -EINVAL;
 
diff --git a/drivers/media/pci/tw686x/tw686x.h b/drivers/media/pci/tw686x/tw686x.h
index 977ff6e3c1e2..5f4c2131ddac 100644
--- a/drivers/media/pci/tw686x/tw686x.h
+++ b/drivers/media/pci/tw686x/tw686x.h
@@ -33,6 +33,7 @@
 #define TW686X_AUDIO_PERIODS_MAX	TW686X_AUDIO_PAGE_MAX
 
 #define TW686X_DMA_MODE_MEMCPY		0
+#define TW686X_DMA_MODE_CONTIG		1
 
 struct tw686x_format {
 	char *name;
-- 
2.7.0

