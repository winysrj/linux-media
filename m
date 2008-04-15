Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FDg3m3019606
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 09:42:03 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3FDfpp7023343
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 09:41:52 -0400
Date: Tue, 15 Apr 2008 15:41:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <Pine.LNX.4.64.0804151537180.6851@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] pxa-camera: fix DMA sg-list coalescing for more than 2
 buffers
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Currently the pxa-camera driver has a bug, visible when the user requests 
more than 2 video buffers. When the third buffer is queued, it is not 
appended to the DMA-descriptor list of the second buffer, but is again 
appended to the first buffer. Fix it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

---

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 1dcfd91..7cc8e9b 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -102,11 +102,6 @@ struct pxa_buffer {
 	enum pxa_camera_active_dma active_dma;
 };
 
-struct pxa_framebuffer_queue {
-	dma_addr_t		sg_last_dma;
-	struct pxa_dma_desc	*sg_last_cpu;
-};
-
 struct pxa_camera_dev {
 	struct device		*dev;
 	/* PXA27x is only supposed to handle one camera on its Quick Capture
@@ -131,6 +126,7 @@ struct pxa_camera_dev {
 	spinlock_t		lock;
 
 	struct pxa_buffer	*active;
+	struct pxa_dma_desc	*sg_tail[3];
 };
 
 static const char *pxa_cam_driver_description = "PXA_Camera";
@@ -144,11 +140,14 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
 			      unsigned int *size)
 {
 	struct soc_camera_device *icd = vq->priv_data;
+	struct soc_camera_host *ici =
+		to_soc_camera_host(icd->dev.parent);
+	struct pxa_camera_dev *pcdev = ici->priv;
 
 	dev_dbg(&icd->dev, "count=%d, size=%d\n", *count, *size);
 
 	/* planar capture requires Y, U and V buffers to be page aligned */
-	if (icd->current_fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+	if (pcdev->channels == 3) {
 		*size = PAGE_ALIGN(icd->width * icd->height); /* Y pages */
 		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* U pages */
 		*size += PAGE_ALIGN(icd->width * icd->height / 2); /* V pages */
@@ -296,7 +295,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 		if (ret)
 			goto fail;
 
-		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+		if (pcdev->channels == 3) {
 			/* FIXME the calculations should be more precise */
 			sglen_y = dma->sglen / 2;
 			sglen_u = sglen_v = dma->sglen / 4 + 1;
@@ -318,7 +317,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 			goto fail;
 		}
 
-		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+		if (pcdev->channels == 3) {
 			/* init DMA for U channel */
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, sglen_u,
 						   sglen_y, 0x30, size_u);
@@ -343,7 +342,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 
 	buf->inwork = 0;
 	buf->active_dma = DMA_Y;
-	if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
+	if (pcdev->channels == 3)
 		buf->active_dma |= DMA_U | DMA_V;
 
 	return 0;
@@ -371,6 +370,7 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	struct pxa_buffer *active;
 	unsigned long flags;
+	int i;
 
 	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -383,15 +383,11 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 
 	if (!active) {
 		CIFR |= CIFR_RESET_F;
-		DDADR(pcdev->dma_chans[0]) = buf->dmas[0].sg_dma;
-		DCSR(pcdev->dma_chans[0]) = DCSR_RUN;
-
-		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
-			DDADR(pcdev->dma_chans[1]) = buf->dmas[1].sg_dma;
-			DCSR(pcdev->dma_chans[1]) = DCSR_RUN;
 
-			DDADR(pcdev->dma_chans[2]) = buf->dmas[2].sg_dma;
-			DCSR(pcdev->dma_chans[2]) = DCSR_RUN;
+		for (i = 0; i < pcdev->channels; i++) {
+			DDADR(pcdev->dma_chans[i]) = buf->dmas[i].sg_dma;
+			DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
+			pcdev->sg_tail[i] = buf->dmas[i].sg_cpu + buf->dmas[i].sglen - 1;
 		}
 
 		pcdev->active = buf;
@@ -400,7 +396,6 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 		struct pxa_cam_dma *buf_dma;
 		struct pxa_cam_dma *act_dma;
 		int nents;
-		int i;
 
 		for (i = 0; i < pcdev->channels; i++) {
 			buf_dma = &buf->dmas[i];
@@ -412,8 +407,8 @@ static void pxa_videobuf_queue(struct videobuf_queue *vq,
 
 			/* Add the descriptors we just initialized to
 			   the currently running chain */
-			act_dma->sg_cpu[act_dma->sglen - 1].ddadr =
-				buf_dma->sg_dma;
+			pcdev->sg_tail[i]->ddadr = buf_dma->sg_dma;
+			pcdev->sg_tail[i] = buf_dma->sg_cpu + buf_dma->sglen - 1;
 
 			/* Setup a dummy descriptor with the DMA engines current
 			 * state

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
