Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1850 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaILNAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 09:00:39 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 11/14] tw68: only reprogram DMA engine when necessary
Date: Fri, 12 Sep 2014 15:00:00 +0200
Message-Id: <1410526803-25887-12-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new 'new_cookies' flag to determine when the risc program
needs to be regenerated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/tw68/tw68-video.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 13e9650..c69e6a5 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -468,6 +468,9 @@ static int tw68_buf_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, size);
 
+	if (!vb->new_cookies)
+		return 0;
+
 	bpl = (dev->width * dev->fmt->depth) >> 3;
 	switch (dev->field) {
 	case V4L2_FIELD_TOP:
@@ -497,13 +500,15 @@ static int tw68_buf_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void tw68_buf_finish_for_cpu(struct vb2_buffer *vb)
+static void tw68_buf_cleanup(struct vb2_buffer *vb)
 {
 	struct vb2_queue *vq = vb->vb2_queue;
 	struct tw68_dev *dev = vb2_get_drv_priv(vq);
 	struct tw68_buf *buf = container_of(vb, struct tw68_buf, vb);
 
-	pci_free_consistent(dev->pci, buf->size, buf->cpu, buf->dma);
+	if (buf->cpu)
+		pci_free_consistent(dev->pci, buf->size, buf->cpu, buf->dma);
+	buf->cpu = NULL;
 }
 
 static int tw68_start_streaming(struct vb2_queue *q, unsigned int count)
@@ -536,7 +541,7 @@ static struct vb2_ops tw68_video_qops = {
 	.queue_setup	= tw68_queue_setup,
 	.buf_queue	= tw68_buf_queue,
 	.buf_prepare	= tw68_buf_prepare,
-	.buf_finish_for_cpu = tw68_buf_finish_for_cpu,
+	.buf_cleanup	= tw68_buf_cleanup,
 	.start_streaming = tw68_start_streaming,
 	.stop_streaming = tw68_stop_streaming,
 	.wait_prepare	= vb2_ops_wait_prepare,
-- 
2.1.0

