Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35552 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752246AbdHNImK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Aug 2017 04:42:10 -0400
Received: by mail-wr0-f170.google.com with SMTP id k71so32187450wrc.2
        for <linux-media@vger.kernel.org>; Mon, 14 Aug 2017 01:42:10 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [RFC PATCH] media: vb2: add bidirectional flag in vb2_queue
Date: Mon, 14 Aug 2017 11:41:55 +0300
Message-Id: <20170814084155.10770-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This RFC patch is intended to give to the drivers a choice to change
the default behavior of the v4l2-core DMA mapping direction from
DMA_TO/FROM_DEVICE (depending on the buffer type CAPTURE or OUTPUT)
to DMA_BIDIRECTIONAL during queue_init time.

Initially the issue with DMA mapping direction has been found in
Venus encoder driver where the firmware side of the driver adds few
lines padding on bottom of the image buffer, and the consequence was
triggering of IOMMU protection faults. 

Probably other drivers could also has a benefit of this feature (hint)
in the future.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/v4l2-core/videobuf2-core.c |  3 +++
 include/media/videobuf2-core.h           | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 14f83cecfa92..17d07fda4cdc 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -200,6 +200,9 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
 	int plane;
 	int ret = -ENOMEM;
 
+	if (q->bidirectional)
+		dma_dir = DMA_BIDIRECTIONAL;
+
 	/*
 	 * Allocate memory for all planes in this buffer
 	 * NOTE: mmapped areas should be page aligned
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index cb97c224be73..0b6e88e1aa79 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -427,6 +427,16 @@ struct vb2_buf_ops {
  * @dev:	device to use for the default allocation context if the driver
  *		doesn't fill in the @alloc_devs array.
  * @dma_attrs:	DMA attributes to use for the DMA.
+ * @bidirectional: when this flag is set the DMA direction for the buffers of
+ *		this queue will be overridden with DMA_BIDIRECTIONAL direction.
+ *		This is useful in cases where the hardware (firmware) writes to
+ *		a buffer which is mapped as read (DMA_TO_DEVICE), or reads from
+ *		buffer which is mapped for write (DMA_FROM_DEVICE) in order
+ *		to satisfy some internal hardware restrictions or adds a padding
+ *		needed by the processing algorithm. In case the DMA mapping is
+ *		not bidirectional but the hardware (firmware) trying to access
+ *		the buffer (in the opposite direction) this could lead to an
+ *		IOMMU protection faults.
  * @fileio_read_once:		report EOF after reading the first buffer
  * @fileio_write_immediately:	queue buffer after each write() call
  * @allow_zero_bytesused:	allow bytesused == 0 to be passed to the driver
@@ -495,6 +505,7 @@ struct vb2_queue {
 	unsigned int			io_modes;
 	struct device			*dev;
 	unsigned long			dma_attrs;
+	unsigned			bidirectional:1;
 	unsigned			fileio_read_once:1;
 	unsigned			fileio_write_immediately:1;
 	unsigned			allow_zero_bytesused:1;
-- 
2.11.0
