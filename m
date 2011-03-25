Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.9]:64739 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933242Ab1CYIcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 04:32:19 -0400
Date: Fri, 25 Mar 2011 09:32:16 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Pawel Osciak <pawel@osciak.com>
Subject: [PATCH] V4L: sh_mobile_ceu_camera: implement .stop_streaming()
Message-ID: <Pine.LNX.4.64.1103250929460.22824@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The .stop_streaming() videobuf2 operation has to be implemented to
guarantee, that video buffers are not written to after a STREAMOFF.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

for 2.6.40

 drivers/media/video/sh_mobile_ceu_camera.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 61f3701..0a75a4c 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -429,6 +429,26 @@ static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
 	return 0;
 }
 
+static int sh_mobile_ceu_stop_streaming(struct vb2_queue *q)
+{
+	struct soc_camera_device *icd = container_of(q, struct soc_camera_device, vb2_vidq);
+	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	struct list_head *buf_head, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcdev->lock, flags);
+
+	pcdev->active = NULL;
+
+	list_for_each_safe(buf_head, tmp, &pcdev->capture)
+		list_del_init(buf_head);
+
+	spin_unlock_irqrestore(&pcdev->lock, flags);
+
+	return sh_mobile_ceu_soft_reset(pcdev);
+}
+
 static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 	.queue_setup	= sh_mobile_ceu_videobuf_setup,
 	.buf_prepare	= sh_mobile_ceu_videobuf_prepare,
@@ -437,6 +457,7 @@ static struct vb2_ops sh_mobile_ceu_videobuf_ops = {
 	.buf_init	= sh_mobile_ceu_videobuf_init,
 	.wait_prepare	= soc_camera_unlock,
 	.wait_finish	= soc_camera_lock,
+	.stop_streaming	= sh_mobile_ceu_stop_streaming,
 };
 
 static irqreturn_t sh_mobile_ceu_irq(int irq, void *data)
-- 
1.7.2.5

