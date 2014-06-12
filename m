Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33034 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaFLRGq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 13:06:46 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [RFC PATCH 19/26] [media] imx-ipuv3-csi: Add support for temporarily stopping the stream on sync loss
Date: Thu, 12 Jun 2014 19:06:33 +0200
Message-Id: <1402592800-2925-20-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
References: <1402592800-2925-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch allows to receive sync lock notifications from
the source subdevice and temporarily pauses the stream until
the source can lock onto its signal again.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/imx/imx-ipuv3-csi.c | 160 +++++++++++++++++++++++++++++
 1 file changed, 160 insertions(+)

diff --git a/drivers/media/platform/imx/imx-ipuv3-csi.c b/drivers/media/platform/imx/imx-ipuv3-csi.c
index 0dd40a4..ab22cad 100644
--- a/drivers/media/platform/imx/imx-ipuv3-csi.c
+++ b/drivers/media/platform/imx/imx-ipuv3-csi.c
@@ -17,6 +17,7 @@
 #include <linux/moduleparam.h>
 #include <linux/interrupt.h>
 #include <linux/videodev2.h>
+#include <linux/workqueue.h>
 #include <linux/version.h>
 #include <linux/device.h>
 #include <linux/kernel.h>
@@ -260,6 +261,7 @@ struct ipucsi {
 	struct v4l2_mbus_framefmt	format_mbus[2];
 	struct ipu_media_link		*link;
 	struct v4l2_fh			fh;
+	bool				paused;
 };
 
 static struct ipucsi_buffer *to_ipucsi_vb(struct vb2_buffer *vb)
@@ -443,6 +445,159 @@ static inline void ipucsi_set_inactive_buffer(struct ipucsi *ipucsi,
 	ipu_idmac_select_buffer(ipucsi->ipuch, bufptr);
 }
 
+int ipucsi_resume_stream(struct ipucsi *ipucsi)
+{
+	struct ipucsi_buffer *buf;
+	struct vb2_buffer *vb;
+	unsigned long flags;
+	dma_addr_t eba;
+
+	if (!ipucsi->paused)
+		return 0;
+
+	spin_lock_irqsave(&ipucsi->lock, flags);
+
+	if (list_empty(&ipucsi->capture)) {
+		spin_unlock_irqrestore(&ipucsi->lock, flags);
+		return -EAGAIN;
+	}
+
+	buf = list_first_entry(&ipucsi->capture, struct ipucsi_buffer, queue);
+	vb = &buf->vb;
+
+	ipu_idmac_set_double_buffer(ipucsi->ipuch, 1);
+
+	eba = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (ipucsi->ilo < 0)
+		eba -= ipucsi->ilo;
+
+	ipu_cpmem_set_buffer(ipu_get_cpmem(ipucsi->ipuch), 0, eba);
+
+	ipu_idmac_select_buffer(ipucsi->ipuch, 0);
+
+	/*
+	 * Point the inactive buffer address to the next queued buffer,
+	 * if available. Otherwise, prepare to reuse the currently active
+	 * buffer, unless ipucsi_videobuf_queue gets called in time.
+	 */
+	if (!list_is_singular(&ipucsi->capture)) {
+		buf = list_entry(ipucsi->capture.next->next,
+				 struct ipucsi_buffer, queue);
+		vb = &buf->vb;
+	}
+
+	eba = vb2_dma_contig_plane_dma_addr(vb, 0);
+	if (ipucsi->ilo < 0)
+		eba -= ipucsi->ilo;
+
+	ipu_cpmem_set_buffer(ipu_get_cpmem(ipucsi->ipuch), 1, eba);
+
+	ipu_idmac_select_buffer(ipucsi->ipuch, 1);
+
+	spin_unlock_irqrestore(&ipucsi->lock, flags);
+
+	ipu_smfc_enable(ipucsi->ipu);
+	ipu_idmac_enable_channel(ipucsi->ipuch);
+	ipu_csi_enable(ipucsi->ipu, ipucsi->id);
+
+	ipucsi->active = buf;
+	ipucsi->paused = false;
+
+	return 0;
+}
+
+static void ipucsi_clear_buffer(struct vb2_buffer *vb, u32 fourcc)
+{
+	u32 black, *p, *end;
+
+	switch (fourcc) {
+	case V4L2_PIX_FMT_UYVY:
+		black = 0x00800080;
+		break;
+	case V4L2_PIX_FMT_YUYV:
+		black = 0x80008000;
+		break;
+	default:
+		black = 0x00000000;
+		break;
+	}
+
+	p = vb2_plane_vaddr(vb, 0);
+	end = p + vb2_plane_size(vb, 0) / 4;
+
+	while (p < end)
+		*p++ = black;
+}
+
+int ipucsi_pause_stream(struct ipucsi *ipucsi)
+{
+	unsigned long flags;
+
+	if (ipucsi->paused)
+		return 0;
+
+	ipu_csi_disable(ipucsi->ipu, ipucsi->id);
+	ipu_idmac_disable_channel(ipucsi->ipuch);
+	ipu_smfc_disable(ipucsi->ipu);
+
+	ipucsi->paused = true;
+
+	/*
+	 * If there is a previously active frame, clear it to black and mark
+	 * it as done to hand it off to userspace, unless the list is singular
+	 */
+
+	spin_lock_irqsave(&ipucsi->lock, flags);
+
+	if (ipucsi->active && !list_is_singular(&ipucsi->capture)) {
+		struct ipucsi_buffer *buf = ipucsi->active;
+
+		ipucsi->active = NULL;
+		list_del_init(&buf->queue);
+
+		spin_unlock_irqrestore(&ipucsi->lock, flags);
+
+		ipucsi_clear_buffer(&buf->vb,
+				    ipucsi->format.fmt.pix.pixelformat);
+
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
+
+		spin_lock_irqsave(&ipucsi->lock, flags);
+	}
+
+	spin_unlock_irqrestore(&ipucsi->lock, flags);
+
+	return 0;
+}
+
+static void ipucsi_v4l2_dev_notify(struct v4l2_subdev *sd,
+				   unsigned int notification, void *arg)
+{
+	if (sd == NULL)
+		return;
+
+	if (notification == V4L2_SUBDEV_SYNC_LOCK_NOTIFY) {
+		struct media_entity_graph graph;
+		struct media_entity *entity;
+		struct ipucsi *ipucsi;
+		bool lock = *(bool *)arg;
+
+		/* Find the CSI (first subdevice entity of the graph) */
+		media_entity_graph_walk_start(&graph, &sd->entity);
+		while ((entity = media_entity_graph_walk_next(&graph)) &&
+		       media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV);
+		if (!entity)
+			return;
+		sd = media_entity_to_v4l2_subdev(entity);
+		ipucsi = container_of(sd, struct ipucsi, subdev);
+
+		if (lock)
+			ipucsi_resume_stream(ipucsi);
+		else
+			ipucsi_pause_stream(ipucsi);
+	}
+}
+
 static irqreturn_t ipucsi_new_frame_handler(int irq, void *context)
 {
 	struct ipucsi *ipucsi = context;
@@ -735,6 +890,8 @@ static int ipucsi_videobuf_start_streaming(struct vb2_queue *vq, unsigned int co
 	ipu_smfc_enable(ipucsi->ipu);
 	ipu_csi_enable(ipucsi->ipu, ipucsi->id);
 
+	ipucsi->paused = false;
+
 	ret = v4l2_media_subdev_s_stream(&ipucsi->subdev.entity, 1);
 	if (ret)
 		goto free_irq;
@@ -758,6 +915,8 @@ static int ipucsi_videobuf_stop_streaming(struct vb2_queue *vq)
 	ipu_idmac_disable_channel(ipucsi->ipuch);
 	ipu_smfc_disable(ipucsi->ipu);
 
+	ipucsi->paused = false;
+
 	spin_lock_irqsave(&ipucsi->lock, flags);
 	while (!list_empty(&ipucsi->capture)) {
 		struct ipucsi_buffer *buf = list_entry(ipucsi->capture.next,
@@ -1437,6 +1596,7 @@ static int ipucsi_probe(struct platform_device *pdev)
 	ipucsi->ipu = ipu;
 	ipucsi->dev = &pdev->dev;
 	ipucsi->v4l2_dev = ipu_media_get_v4l2_dev();
+	ipucsi->v4l2_dev->notify = ipucsi_v4l2_dev_notify;
 	if (!ipucsi->v4l2_dev)
 		return -EPROBE_DEFER;
 
-- 
2.0.0.rc2

