Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45590 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaJVLu2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 07:50:28 -0400
Message-ID: <1413978623.3107.6.camel@pengutronix.de>
Subject: Re: [PATCH 4/5] [media] vivid: add support for contiguous DMA
 buffers
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Date: Wed, 22 Oct 2014 13:50:23 +0200
In-Reply-To: <5447839E.4090309@cisco.com>
References: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
	 <1413972221-13669-5-git-send-email-p.zabel@pengutronix.de>
	 <5447839E.4090309@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mittwoch, den 22.10.2014, 12:14 +0200 schrieb Hans Verkuil:
[...]
> > diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
> > index 331c544..04b5fbf 100644
> > --- a/drivers/media/platform/vivid/vivid-vid-cap.c
> > +++ b/drivers/media/platform/vivid/vivid-vid-cap.c
> > @@ -151,8 +151,10 @@ static int vid_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
> >
> >   	/*
> >   	 * videobuf2-vmalloc allocator is context-less so no need to set
> > -	 * alloc_ctxs array.
> > +	 * alloc_ctxs array. videobuf2-dma-contig needs a context, though.
> >   	 */
> > +	for (p = 0; p < planes; p++)
> > +		alloc_ctxs[p] = dev->alloc_ctx;
> >
> >   	if (planes == 2)
> >   		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
> > diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
> > index 69c2dbd..6b8dfd6 100644
> > --- a/drivers/media/platform/vivid/vivid-vid-out.c
> > +++ b/drivers/media/platform/vivid/vivid-vid-out.c
> > @@ -39,6 +39,7 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
> >   	unsigned planes = dev->fmt_out->planes;
> >   	unsigned h = dev->fmt_out_rect.height;
> >   	unsigned size = dev->bytesperline_out[0] * h;
> > +	unsigned p;
> >
> >   	if (dev->field_out == V4L2_FIELD_ALTERNATE) {
> >   		/*
> > @@ -98,8 +99,10 @@ static int vid_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
> >
> >   	/*
> >   	 * videobuf2-vmalloc allocator is context-less so no need to set
> > -	 * alloc_ctxs array.
> > +	 * alloc_ctxs array. videobuf2-dma-contig needs a context, though.
> >   	 */
> > +	for (p = 0; p < planes; p++)
> > +		alloc_ctxs[p] = dev->alloc_ctx;
> >
> >   	if (planes == 2)
> >   		dprintk(dev, 1, "%s, count=%d, sizes=%u, %u\n", __func__,
> >
> 
> This is not sufficient. alloc_ctxs should be filled in for all device types in the
> queue_setup op, so also for vbi cap/out and sdr cap. Without that these devices
> would fail.

Thanks, I'll add the following changes to the next version:

diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index 8c5d661..ac6ee15 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -196,6 +196,7 @@ static int sdr_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 {
 	/* 2 = max 16-bit sample returned */
 	sizes[0] = SDR_CAP_SAMPLES_PER_BUF * 2;
+	alloc_ctxs[0] = dev->alloc_ctx;
 	*nplanes = 1;
 	return 0;
 }
diff --git a/drivers/media/platform/vivid/vivid-vbi-cap.c b/drivers/media/platform/vivid/vivid-vbi-cap.c
index 2166d0b..27a636f 100644
--- a/drivers/media/platform/vivid/vivid-vbi-cap.c
+++ b/drivers/media/platform/vivid/vivid-vbi-cap.c
@@ -149,6 +149,7 @@ static int vbi_cap_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 		return -EINVAL;
 
 	sizes[0] = size;
+	alloc_ctxs[0] = dev->alloc_ctx;
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
diff --git a/drivers/media/platform/vivid/vivid-vbi-out.c b/drivers/media/platform/vivid/vivid-vbi-out.c
index 9d00a07..5912ed8 100644
--- a/drivers/media/platform/vivid/vivid-vbi-out.c
+++ b/drivers/media/platform/vivid/vivid-vbi-out.c
@@ -41,6 +41,7 @@ static int vbi_out_queue_setup(struct vb2_queue *vq, const struct v4l2_format *f
 		return -EINVAL;
 
 	sizes[0] = size;
+	alloc_ctxs[0] = dev->alloc_ctx;
 
 	if (vq->num_buffers + *nbuffers < 2)
 		*nbuffers = 2 - vq->num_buffers;
-- 
2.1.1

regards
Philipp


