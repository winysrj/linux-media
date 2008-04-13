Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3DJUUTw026293
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 15:30:30 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3DJUIBe018780
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 15:30:19 -0400
Date: Sun, 13 Apr 2008 21:30:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804132124100.6622@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804042027140.7761@axis700.grange>
	<998e4a820804070417w7cf71869h5f36c2ec18c8584c@mail.gmail.com>
	<Pine.LNX.4.64.0804071322490.5585@axis700.grange>
	<998e4a820804071849s60e883f9ne2d8ad6a2f48bd42@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
	<998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=GB2312
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

On Fri, 11 Apr 2008, ·ëöÎ wrote:

> 2008/4/10 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> > > Thanks,I test it already. if I request 4 buffers,wrong frames will
> > > appear sometimes and get the partially inverted frame sequence too.
> >
> >  can you describe more precisely what you mean by "wrong frames?" Is it the
> >  same problem as what I'm seeing here: misplaced start of frame, i.e., your
> >  frame looks divided into four rectangles?
> 
> The wrong frame is divided two portion,top and bottom. the top is
> right of the bottom.
> 
> >  > I request 2 buffers,there is not wrong frames.But some frames will be
> >  > lost,like 1,2,3,4,7,8,9,10,14,...
> >
> >  This is good. This means those frames had buffer overruns and have been
> >  dropped. Above you mean, that frames 5, 6, 11, 12, and 13 have been
> >  dropped, not that all frames you listed have been dropped?
> 
> yes, the frames 5, 6, 11, 12, and 13 have been dropped. The frames I
> listed is right.

I found the problem with reversed frame order. The same problem led to 
corrupted frames. Please try the patch below on the top of the previous 
one. With it I have no more problems with the test application with any 
number of buffers.

Thanks
Guennadi
---
Guennadi Liakhovetski

--- a/drivers/media/video/pxa_camera.c	2008-04-13 21:18:32.000000000 +0200
+++ b/drivers/media/video/pxa_camera.c	2008-04-13 21:20:04.000000000 +0200
@@ -104,11 +104,6 @@
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
@@ -133,6 +128,7 @@
 	spinlock_t		lock;
 
 	struct pxa_buffer	*active;
+	struct pxa_dma_desc	*sg_tail[3];
 };
 
 static const char *pxa_cam_driver_description = "PXA_Camera";
@@ -146,11 +142,14 @@
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
@@ -298,7 +297,7 @@
 		if (ret)
 			goto fail;
 
-		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+		if (pcdev->channels == 3) {
 			/* FIXME the calculations should be more precise */
 			sglen_y = dma->sglen / 2;
 			sglen_u = sglen_v = dma->sglen / 4 + 1;
@@ -320,7 +319,7 @@
 			goto fail;
 		}
 
-		if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P) {
+		if (pcdev->channels == 3) {
 			/* init DMA for U channel */
 			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, sglen_u,
 						   sglen_y, 0x30, size_u);
@@ -345,7 +344,7 @@
 
 	buf->inwork = 0;
 	buf->active_dma = DMA_Y;
-	if (buf->fmt->fourcc == V4L2_PIX_FMT_YUV422P)
+	if (pcdev->channels == 3)
 		buf->active_dma |= DMA_U | DMA_V;
 
 	return 0;
@@ -373,6 +372,7 @@
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	struct pxa_buffer *active;
 	unsigned long flags;
+	int i;
 
 	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __FUNCTION__,
 		vb, vb->baddr, vb->bsize);
@@ -385,15 +385,11 @@
 
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
@@ -402,7 +398,6 @@
 		struct pxa_cam_dma *buf_dma;
 		struct pxa_cam_dma *act_dma;
 		int nents;
-		int i;
 
 		for (i = 0; i < pcdev->channels; i++) {
 			buf_dma = &buf->dmas[i];
@@ -414,8 +409,8 @@
 
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
