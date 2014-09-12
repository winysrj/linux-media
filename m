Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2154 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaILNAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 09:00:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, m.szyprowski@samsung.com,
	laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 12/14] cx23885: only reprogram DMA engine when necessary
Date: Fri, 12 Sep 2014 15:00:01 +0200
Message-Id: <1410526803-25887-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the new 'new_cookies' flag to determine when the risc program
needs to be regenerated.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   | 4 ++--
 drivers/media/pci/cx23885/cx23885-core.c  | 7 ++++++-
 drivers/media/pci/cx23885/cx23885-dvb.c   | 4 ++--
 drivers/media/pci/cx23885/cx23885-vbi.c   | 7 +++++--
 drivers/media/pci/cx23885/cx23885-video.c | 7 +++++--
 5 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 5d36950..c7f2c54 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1162,7 +1162,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return cx23885_buf_prepare(buf, &dev->ts1);
 }
 
-static void buffer_finish_for_cpu(struct vb2_buffer *vb)
+static void buffer_cleanup(struct vb2_buffer *vb)
 {
 	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx23885_buffer *buf = container_of(vb,
@@ -1224,7 +1224,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 static struct vb2_ops cx23885_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
-	.buf_finish_for_cpu = buffer_finish_for_cpu,
+	.buf_cleanup = buffer_cleanup,
 	.buf_queue    = buffer_queue,
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index e2e5afb..6b2dac0 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -1249,7 +1249,9 @@ void cx23885_free_buffer(struct cx23885_dev *dev, struct cx23885_buffer *buf)
 	struct cx23885_riscmem *risc = &buf->risc;
 
 	BUG_ON(in_interrupt());
-	pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+	if (risc->cpu)
+		pci_free_consistent(dev->pci, risc->size, risc->cpu, risc->dma);
+	risc->cpu = NULL;
 }
 
 static void cx23885_tsport_reg_dump(struct cx23885_tsport *port)
@@ -1459,6 +1461,9 @@ int cx23885_buf_prepare(struct cx23885_buffer *buf, struct cx23885_tsport *port)
 		return -EINVAL;
 	vb2_set_plane_payload(&buf->vb, 0, size);
 
+	if (!buf->vb.new_cookies)
+		return 0;
+
 	cx23885_risc_databuffer(dev->pci, &buf->risc,
 				sgt->sgl,
 				port->ts_packet_size, port->ts_packet_count, 0);
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 77eb034..d8fc87f 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -112,7 +112,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return cx23885_buf_prepare(buf, port);
 }
 
-static void buffer_finish_for_cpu(struct vb2_buffer *vb)
+static void buffer_cleanup(struct vb2_buffer *vb)
 {
 	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
 	struct cx23885_dev *dev = port->dev;
@@ -168,7 +168,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 static struct vb2_ops dvb_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
-	.buf_finish_for_cpu = buffer_finish_for_cpu,
+	.buf_cleanup = buffer_cleanup,
 	.buf_queue    = buffer_queue,
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index d7a69c6..b93626c 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -151,6 +151,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, lines * VBI_LINE_LENGTH * 2);
 
+	if (!vb->new_cookies)
+		return 0;
+
 	cx23885_risc_vbibuffer(dev->pci, &buf->risc,
 			 sgt->sgl,
 			 0, VBI_LINE_LENGTH * lines,
@@ -159,7 +162,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish_for_cpu(struct vb2_buffer *vb)
+static void buffer_cleanup(struct vb2_buffer *vb)
 {
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
@@ -254,7 +257,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 struct vb2_ops cx23885_vbi_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
-	.buf_finish_for_cpu = buffer_finish_for_cpu,
+	.buf_cleanup = buffer_cleanup,
 	.buf_queue    = buffer_queue,
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index d533f4e..ba30fa8 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -342,6 +342,9 @@ static int buffer_prepare(struct vb2_buffer *vb)
 		return -EINVAL;
 	vb2_set_plane_payload(vb, 0, dev->height * buf->bpl);
 
+	if (!vb->new_cookies)
+		return 0;
+
 	switch (dev->field) {
 	case V4L2_FIELD_TOP:
 		cx23885_risc_buffer(dev->pci, &buf->risc,
@@ -407,7 +410,7 @@ static int buffer_prepare(struct vb2_buffer *vb)
 	return 0;
 }
 
-static void buffer_finish_for_cpu(struct vb2_buffer *vb)
+static void buffer_cleanup(struct vb2_buffer *vb)
 {
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
@@ -500,7 +503,7 @@ static void cx23885_stop_streaming(struct vb2_queue *q)
 static struct vb2_ops cx23885_video_qops = {
 	.queue_setup    = queue_setup,
 	.buf_prepare  = buffer_prepare,
-	.buf_finish_for_cpu = buffer_finish_for_cpu,
+	.buf_cleanup = buffer_cleanup,
 	.buf_queue    = buffer_queue,
 	.wait_prepare = vb2_ops_wait_prepare,
 	.wait_finish = vb2_ops_wait_finish,
-- 
2.1.0

