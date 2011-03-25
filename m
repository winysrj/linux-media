Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:53606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab1CYIcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 04:32:53 -0400
Date: Fri, 25 Mar 2011 09:32:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] V4L: mx3_camera: implement .stop_streaming()
Message-ID: <Pine.LNX.4.64.1103250932210.22824@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The .stop_streaming() videobuf2 operation has to be implemented to
guarantee, that video buffers are not written to after a STREAMOFF.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx3_camera.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 502e2a4..8630c0c 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -400,6 +400,35 @@ static int mx3_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
+static int mx3_stop_streaming(struct vb2_queue *q)
+{
+	struct soc_camera_device *icd = soc_camera_from_vb2q(q);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct mx3_camera_dev *mx3_cam = ici->priv;
+	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
+	struct dma_chan *chan;
+	struct mx3_camera_buffer *buf, *tmp;
+	unsigned long flags;
+
+	if (ichan) {
+		chan = &ichan->dma_chan;
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+	}
+
+	spin_lock_irqsave(&mx3_cam->lock, flags);
+
+	mx3_cam->active = NULL;
+
+	list_for_each_entry_safe(buf, tmp, &mx3_cam->capture, queue) {
+		buf->state = CSI_BUF_NEEDS_INIT;
+		list_del_init(&buf->queue);
+	}
+
+	spin_unlock_irqrestore(&mx3_cam->lock, flags);
+
+	return 0;
+}
+
 static struct vb2_ops mx3_videobuf_ops = {
 	.queue_setup	= mx3_videobuf_setup,
 	.buf_prepare	= mx3_videobuf_prepare,
@@ -408,6 +437,7 @@ static struct vb2_ops mx3_videobuf_ops = {
 	.buf_init	= mx3_videobuf_init,
 	.wait_prepare	= soc_camera_unlock,
 	.wait_finish	= soc_camera_lock,
+	.stop_streaming	= mx3_stop_streaming,
 };
 
 static int mx3_camera_init_videobuf(struct vb2_queue *q,
-- 
1.7.2.5

