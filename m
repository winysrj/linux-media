Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:37544 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751987AbcIINV4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Sep 2016 09:21:56 -0400
From: Vincent Abriou <vincent.abriou@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Vincent Abriou <vincent.abriou@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] [media] vivid: support for contiguous DMA buffers
Date: Fri, 9 Sep 2016 15:21:33 +0200
Message-ID: <1473427293-22502-1-git-send-email-vincent.abriou@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It allow to simulate the behavior of hardware with such limitations or
to connect vivid to real hardware with such limitations.

Add the "allocator" module parameter option to let vivid use the
dma-contig instead of vmalloc.

Tested on X86 and ARM configuration.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Vincent Abriou <vincent.abriou@st.com>

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>

---
 Documentation/media/v4l-drivers/vivid.rst |  8 ++++++++
 drivers/media/platform/vivid/Kconfig      |  1 +
 drivers/media/platform/vivid/vivid-core.c | 32 ++++++++++++++++++++++++++-----
 3 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/v4l-drivers/vivid.rst b/Documentation/media/v4l-drivers/vivid.rst
index c8cf371..3e44b22 100644
--- a/Documentation/media/v4l-drivers/vivid.rst
+++ b/Documentation/media/v4l-drivers/vivid.rst
@@ -263,6 +263,14 @@ all configurable using the following module options:
 	removed. Unless overridden by ccs_cap_mode and/or ccs_out_mode the
 	will default to enabling crop, compose and scaling.
 
+- allocators:
+
+	memory allocator selection, default is 0. It specifies the way buffers
+	will be allocated.
+
+		- 0: vmalloc
+		- 1: dma-contig
+
 Taken together, all these module options allow you to precisely customize
 the driver behavior and test your application with all sorts of permutations.
 It is also very suitable to emulate hardware that is not yet available, e.g.
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 8e6918c..ee57562 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -8,6 +8,7 @@ config VIDEO_VIVID
 	select FB_CFB_IMAGEBLIT
 	select MEDIA_CEC_EDID
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	select VIDEO_V4L2_TPG
 	default n
 	---help---
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index 741460a..deca868 100644
--- a/drivers/media/platform/vivid/vivid-core.c
+++ b/drivers/media/platform/vivid/vivid-core.c
@@ -30,6 +30,7 @@
 #include <linux/videodev2.h>
 #include <linux/v4l2-dv-timings.h>
 #include <media/videobuf2-vmalloc.h>
+#include <media/videobuf2-dma-contig.h>
 #include <media/v4l2-dv-timings.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-fh.h>
@@ -151,6 +152,12 @@ static bool no_error_inj;
 module_param(no_error_inj, bool, 0444);
 MODULE_PARM_DESC(no_error_inj, " if set disable the error injecting controls");
 
+static unsigned allocators[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 0 };
+module_param_array(allocators, uint, NULL, 0444);
+MODULE_PARM_DESC(allocators, " memory allocator selection, default is 0.\n"
+			     "\t\t    0 == vmalloc\n"
+			     "\t\t    1 == dma-contig");
+
 static struct vivid_dev *vivid_devs[VIVID_MAX_DEVS];
 
 const struct v4l2_rect vivid_min_rect = {
@@ -636,6 +643,10 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
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
@@ -646,6 +657,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	struct video_device *vfd;
 	struct vb2_queue *q;
 	unsigned node_type = node_types[inst];
+	unsigned allocator = allocators[inst];
 	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
 	int ret;
 	int i;
@@ -1036,6 +1048,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	if (!dev->cec_workqueue)
 		goto unreg_dev;
 
+	if (allocator == 1)
+		dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
+	else if (allocator >= ARRAY_SIZE(vivid_mem_ops))
+		allocator = 0;
+
 	/* start creating the vb2 queues */
 	if (dev->has_vid_cap) {
 		/* initialize vid_cap queue */
@@ -1046,10 +1063,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
+		q->dev = dev->v4l2_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1065,10 +1083,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
+		q->dev = dev->v4l2_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1084,10 +1103,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
+		q->dev = dev->v4l2_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1103,10 +1123,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
+		q->dev = dev->v4l2_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
@@ -1121,10 +1142,11 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = vivid_mem_ops[allocator];
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 8;
 		q->lock = &dev->mutex;
+		q->dev = dev->v4l2_dev.dev;
 
 		ret = vb2_queue_init(q);
 		if (ret)
-- 
1.9.1

