Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34670 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbaJVKDz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:03:55 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 4/5] [media] vivid: add support for contiguous DMA buffers
Date: Wed, 22 Oct 2014 12:03:40 +0200
Message-Id: <1413972221-13669-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To simulate the behaviour of real hardware with such limitations or to
connect vivid to real hardware with such limitations, add an option to
let vivid use the dma-contig allocator instead of vmalloc.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/vivid/Kconfig         |  1 +
 drivers/media/platform/vivid/vivid-core.c    | 30 +++++++++++++++++++++++-----
 drivers/media/platform/vivid/vivid-core.h    |  1 +
 drivers/media/platform/vivid/vivid-vid-cap.c |  4 +++-
 drivers/media/platform/vivid/vivid-vid-out.c |  5 ++++-
 5 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 3bfda25..f48c998 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -4,6 +4,7 @@ config VIDEO_VIVID
 	select FONT_SUPPORT
 	select FONT_8x16
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index c79d60d..4c4fc3d 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -29,6 +29,7 @@
 #include <linux/platform_device.h>
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/videobuf2-vmalloc.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
@@ -107,6 +108,11 @@ MODULE_PARM_DESC(multiplanar, " 0 (default) is alternating single and multiplana
 			      "\t\t    1 is single planar devices,\n"
 			      "\t\t    2 is multiplanar devices");
 
+static unsigned allocators[VIVID_MAX_DEVS];
+module_param_array(allocators, uint, NULL, 0444);
+MODULE_PARM_DESC(allocators, " memory allocator selection, default is 0.\n"
+			     "\t\t    0=vmalloc, 1=dma-contig");
+
 /* Default: video + vbi-cap (raw and sliced) + radio rx + radio tx + sdr + vbi-out + vid-out */
 static unsigned node_types[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 0x1d3d };
 module_param_array(node_types, uint, NULL, 0444);
@@ -640,6 +646,10 @@ static int __init vivid_create_instance(int inst)
 {
 	static const struct v4l2_dv_timings def_dv_timings =
 					V4L2_DV_BT_CEA_1280X720P60;
+	static const struct vb2_mem_ops * const vivid_mem_ops[2] = {
+		&vb2_vmalloc_memops,
+		&vb2_dma_contig_memops,
+	};
 	unsigned in_type_counter[4] = { 0, 0, 0, 0 };
 	unsigned out_type_counter[4] = { 0, 0, 0, 0 };
 	int ccs_cap = ccs_cap_mode[inst];
@@ -650,6 +660,7 @@ static int __init vivid_create_instance(int inst)
 	struct video_device *vfd;
 	struct vb2_queue *q;
 	unsigned node_type = node_types[inst];
+	unsigned allocator = allocators[inst];
 	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
 	int ret;
 	int i;
@@ -1001,6 +1012,15 @@ static int __init vivid_create_instance(int inst)
 	dev->fb_cap.fmt.bytesperline = dev->src_rect.width * tpg_g_twopixelsize(&dev->tpg, 0) / 2;
 	dev->fb_cap.fmt.sizeimage = dev->src_rect.height * dev->fb_cap.fmt.bytesperline;
 
+	/* initialize allocator context */
+	if (allocator == 1) {
+		dev->alloc_ctx = vb2_dma_contig_init_ctx(dev->v4l2_dev.dev);
+		if (IS_ERR(dev->alloc_ctx))
+			goto unreg_dev;
+	} else if (allocator >= ARRAY_SIZE(vivid_mem_ops)) {
+		allocator = 0;
+	}
+
 	/* initialize locks */
 	spin_lock_init(&dev->slock);
 	mutex_init(&dev->mutex);
@@ -1022,7 +1042,7 @@ static int __init vivid_create_instance(int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 
@@ -1040,7 +1060,7 @@ static int __init vivid_create_instance(int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 
@@ -1058,7 +1078,7 @@ static int __init vivid_create_instance(int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 
@@ -1076,7 +1096,7 @@ static int __init vivid_create_instance(int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 
@@ -1093,7 +1113,7 @@ static int __init vivid_create_instance(int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 8;
 
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 811c286..4fefb0d 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -142,6 +142,7 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_radio_tx;
 	struct video_device		sdr_cap_dev;
 	struct v4l2_ctrl_handler	ctrl_hdl_sdr_cap;
+	struct vb2_alloc_ctx		*alloc_ctx;
 	spinlock_t			slock;
 	struct mutex			mutex;
 
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 331c544..04b5fbf 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -151,8 +151,10 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 
 	/*
 	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
+	 * alloc_ctxs array. videobuf2-dma-contig needs a context, though.
 	 */
+	for (p = 0; p < planes; p++)
+		alloc_ctxs[p] = dev->alloc_ctx;
 
 	if (planes == 2)
 		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 69c2dbd..6b8dfd6 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -39,6 +39,7 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 	unsigned planes = dev->fmt_out->planes;
 	unsigned h = dev->fmt_out_rect.height;
 	unsigned size = dev->bytesperline_out[0] * h;
+	unsigned p;
 
 	if (dev->field_out == V4L2_FIELD_ALTERNATE) {
 		/*
@@ -98,8 +99,10 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 
 	/*
 	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
+	 * alloc_ctxs array. videobuf2-dma-contig needs a context, though.
 	 */
+	for (p = 0; p < planes; p++)
+		alloc_ctxs[p] = dev->alloc_ctx;
 
 	if (planes == 2)
 		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
-- 
2.1.1

