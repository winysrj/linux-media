Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:53934 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752609AbcIBMtz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 2 Sep 2016 08:49:55 -0400
From: Vincent Abriou <vincent.abriou@st.com>
To: <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        Vincent Abriou <vincent.abriou@st.com>
Subject: [PATCH] [media] vivid: allow usage of vb2_dma_contig_memops through module param
Date: Fri, 2 Sep 2016 14:49:47 +0200
Message-ID: <1472820587-30882-1-git-send-email-vincent.abriou@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow dma contiguous buffer allocation.
The buffers generated by vivid could then be imported by drm/kms driver.

Signed-off-by: Vincent Abriou <vincent.abriou@st.com>
---
 Documentation/video4linux/vivid.txt          |  5 +++++
 drivers/media/platform/vivid/Kconfig         |  1 +
 drivers/media/platform/vivid/vivid-core.c    | 28 +++++++++++++++++++++++-----
 drivers/media/platform/vivid/vivid-core.h    |  1 +
 drivers/media/platform/vivid/vivid-sdr-cap.c |  4 ++++
 drivers/media/platform/vivid/vivid-vbi-cap.c |  2 ++
 drivers/media/platform/vivid/vivid-vbi-out.c |  2 ++
 drivers/media/platform/vivid/vivid-vid-cap.c |  5 +----
 drivers/media/platform/vivid/vivid-vid-out.c |  5 +----
 9 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/Documentation/video4linux/vivid.txt b/Documentation/video4linux/vivid.txt
index e35d376..5e978f7 100644
--- a/Documentation/video4linux/vivid.txt
+++ b/Documentation/video4linux/vivid.txt
@@ -243,6 +243,11 @@ no_error_inj: if set disable the error injecting controls. This option is
 	removed. Unless overridden by ccs_cap_mode and/or ccs_out_mode the
 	will default to enabling crop, compose and scaling.
 
+mem_ops_type: vb2 mem_ops type, default is 0. It specifies the way buffer will
+	be allocated.
+		0: vb2_vmalloc_memops
+		1: vb2_dma_contig_memops
+
 Taken together, all these module options allow you to precisely customize
 the driver behavior and test your application with all sorts of permutations.
 It is also very suitable to emulate hardware that is not yet available, e.g.
diff --git a/drivers/media/platform/vivid/Kconfig b/drivers/media/platform/vivid/Kconfig
index 0885e93..bc3b140 100644
--- a/drivers/media/platform/vivid/Kconfig
+++ b/drivers/media/platform/vivid/Kconfig
@@ -7,6 +7,7 @@ config VIDEO_VIVID
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
 	select VIDEOBUF2_VMALLOC
+	select VIDEOBUF2_DMA_CONTIG
 	default n
 	---help---
 	  Enables a virtual video driver. This driver emulates a webcam,
diff --git a/drivers/media/platform/vivid/vivid-core.c b/drivers/media/platform/vivid/vivid-core.c
index ec125bec..28be8a1 100644
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
@@ -150,6 +151,12 @@ static bool no_error_inj;
 module_param(no_error_inj, bool, 0444);
 MODULE_PARM_DESC(no_error_inj, " if set disable the error injecting controls");
 
+static unsigned mem_ops_type[VIVID_MAX_DEVS] = { [0 ... (VIVID_MAX_DEVS - 1)] = 0 };
+module_param_array(mem_ops_type, uint, NULL, 0444);
+MODULE_PARM_DESC(mem_ops_type, " vb2 mem_ops type, default is 0.\n"
+			      "\t\t    0 == vb2_vmalloc_memops\n"
+			      "\t\t    1 == vb2_dma_contig_memops");
+
 static struct vivid_dev *vivid_devs[VIVID_MAX_DEVS];
 
 const struct v4l2_rect vivid_min_rect = {
@@ -660,6 +667,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	struct video_device *vfd;
 	struct vb2_queue *q;
 	unsigned node_type = node_types[inst];
+	const struct vb2_mem_ops *mem_ops = &vb2_vmalloc_memops;
 	v4l2_std_id tvnorms_cap = 0, tvnorms_out = 0;
 	int ret;
 	int i;
@@ -1025,6 +1033,12 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 	INIT_LIST_HEAD(&dev->vbi_out_active);
 	INIT_LIST_HEAD(&dev->sdr_cap_active);
 
+	if (mem_ops_type[inst] == 1) {
+		mem_ops = &vb2_dma_contig_memops;
+		dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
+		dev->alloc_ctx = vb2_dma_contig_init_ctx(dev->v4l2_dev.dev);
+	}
+
 	/* start creating the vb2 queues */
 	if (dev->has_vid_cap) {
 		/* initialize vid_cap queue */
@@ -1035,7 +1049,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = mem_ops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1054,7 +1068,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vid_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = mem_ops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1073,7 +1087,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = mem_ops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1092,7 +1106,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_vbi_out_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = mem_ops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 2;
 		q->lock = &dev->mutex;
@@ -1110,7 +1124,7 @@ static int vivid_create_instance(struct platform_device *pdev, int inst)
 		q->drv_priv = dev;
 		q->buf_struct_size = sizeof(struct vivid_buffer);
 		q->ops = &vivid_sdr_cap_qops;
-		q->mem_ops = &vb2_vmalloc_memops;
+		q->mem_ops = mem_ops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 		q->min_buffers_needed = 8;
 		q->lock = &dev->mutex;
@@ -1347,6 +1361,9 @@ static int vivid_remove(struct platform_device *pdev)
 		if (!dev)
 			continue;
 
+		if (mem_ops_type[i] == 1)
+			vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
+
 		if (dev->has_vid_cap) {
 			v4l2_info(&dev->v4l2_dev, "unregistering %s\n",
 				video_device_node_name(&dev->vid_cap_dev));
@@ -1388,6 +1405,7 @@ static int vivid_remove(struct platform_device *pdev)
 			unregister_framebuffer(&dev->fb_info);
 			vivid_fb_release_buffers(dev);
 		}
+
 		v4l2_device_put(&dev->v4l2_dev);
 		vivid_devs[i] = NULL;
 	}
diff --git a/drivers/media/platform/vivid/vivid-core.h b/drivers/media/platform/vivid/vivid-core.h
index 751c1ba..2f7d6e8 100644
--- a/drivers/media/platform/vivid/vivid-core.h
+++ b/drivers/media/platform/vivid/vivid-core.h
@@ -157,6 +157,7 @@ struct vivid_dev {
 	struct v4l2_ctrl_handler	ctrl_hdl_sdr_cap;
 	spinlock_t			slock;
 	struct mutex			mutex;
+	struct vb2_alloc_ctx		*alloc_ctx;
 
 	/* capabilities */
 	u32				vid_cap_caps;
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 3d1604c..5ed4d0a 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -217,6 +217,10 @@ static int sdr_cap_queue_setup(struct vb2_queue *vq,
 		       unsigned *nbuffers, unsigned *nplanes,
 		       unsigned sizes[], void *alloc_ctxs[])
 {
+	struct vivid_dev *dev = vb2_get_drv_priv(vq);
+
+	alloc_ctxs[0] = dev->alloc_ctx;
+
 	/* 2 = max 16-bit sample returned */
 	sizes[0] = SDR_CAP_SAMPLES_PER_BUF * 2;
 	*nplanes = 1;
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index cda45a5..736c8fa 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -153,6 +153,8 @@ static int vbi_cap_queue_setup(struct vb2_queue *vq,
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
 
+	alloc_ctxs[0] = dev->alloc_ctx;
+
 	*nplanes = 1;
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 3c5a469..ef2c2f9 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -45,6 +45,8 @@ static int vbi_out_queue_setup(struct vb2_queue *vq,
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
 
+	alloc_ctxs[0] = dev->alloc_ctx;
+
 	*nplanes = 1;
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index b84f081..c76e057 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -144,10 +144,7 @@ static int vid_cap_queue_setup(struct vb2_queue *vq,
 
 	*nplanes = buffers;
 
-	/*
-	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
-	 */
+	alloc_ctxs[0] = dev->alloc_ctx;
 
 	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
 	for (p = 0; p < buffers; p++)
diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
index 64e4d66..35833f1 100644
--- a/drivers/media/platform/vivid/vivid-vid-out.c
+++ b/drivers/media/platform/vivid/vivid-vid-out.c
@@ -86,10 +86,7 @@ static int vid_out_queue_setup(struct vb2_queue *vq,
 
 	*nplanes = planes;
 
-	/*
-	 * videobuf2-vmalloc allocator is context-less so no need to set
-	 * alloc_ctxs array.
-	 */
+	alloc_ctxs[0] = dev->alloc_ctx;
 
 	dprintk(dev, 1, "%s: count=%d\n", __func__, *nbuffers);
 	for (p = 0; p < planes; p++)
-- 
1.9.1

