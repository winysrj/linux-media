Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:59584 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbbGRXEC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2015 19:04:02 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] media: pxa_camera: conversion to dmaengine
References: <1436120872-24484-1-git-send-email-robert.jarzmik@free.fr>
	<1436120872-24484-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1507121859030.32193@axis700.grange>
	<87y4iljn6y.fsf@belgarion.home>
Date: Sun, 19 Jul 2015 01:00:55 +0200
In-Reply-To: <87y4iljn6y.fsf@belgarion.home> (Robert Jarzmik's message of
	"Sun, 12 Jul 2015 19:33:09 +0200")
Message-ID: <87a8utgjfc.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
>
>>>  		/* init DMA for Y channel */
>>
>> How about taking the loop over the sg list out of pxa_init_dma_channel() 
>> to avoid having to iterate it from the beginning each time? Then you would 
>> be able to split it into channels inside that global loop? Would that 
>> work? Of course you might need to rearrange functions to avoid too deep 
>> code nesting.
>
> Ok, will try that.
> The more I think of it, the more it looks to me like a generic thing : take an
> sglist, and an array of sizes, and split the sglist into several sglists, each
> of the defined size in the array.
>
> Or more code-like speaking :
>   - sglist_split(struct scatterlist *sg_int, size_t *sizes, int nb_sizes,
>                  struct scatterlist **sg_out)
>   - and sg_out is an array of nb_sizes (struct scatterlist *sg)
>
> So I will try that out. Maybe if that works out for pxa_camera, Jens or Russell
> would accept that into lib/scatterlist.c.
Ok, I made the code ... and I hate it.
It's in [1], which is an incremental patch over patch 4/4.

If that's what you had in mind, tell me.

Cheers.

--
Robert

[1] The despised patch
---<8---
commit 43bbb9a4e3ac
Author: Robert Jarzmik <robert.jarzmik@free.fr>
Date:   Tue Jul 14 20:17:51 2015 +0200

    tmp: pxa_camera: working on sg_split
    
    Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 26a66b9ff570..83efd284e976 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -287,64 +287,110 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
 		&buf->vb, buf->vb.baddr, buf->vb.bsize);
 }
 
-static struct scatterlist *videobuf_sg_cut(struct scatterlist *sglist,
-					   int sglen, int offset, int size,
-					   int *new_sg_len)
+
+struct sg_splitter {
+	struct scatterlist *in_sg0;
+	int nents;
+	off_t skip_sg0;
+	size_t len_last_sg;
+	struct scatterlist *out_sg;
+};
+
+static struct sg_splitter *
+sg_calculate_split(struct scatterlist *in, off_t skip,
+		   const size_t *sizes, int nb_splits, gfp_t gfp_mask)
 {
-	struct scatterlist *sg0, *sg, *sg_first = NULL;
-	int i, dma_len, dropped_xfer_len, dropped_remain, remain;
-	int nfirst = -1, nfirst_offset = 0, xfer_len;
-
-	*new_sg_len = 0;
-	dropped_remain = offset;
-	remain = size;
-	for_each_sg(sglist, sg, sglen, i) {
-		dma_len = sg_dma_len(sg);
-		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
-		dropped_xfer_len = roundup(min(dma_len, dropped_remain), 8);
-		if (dropped_remain)
-			dropped_remain -= dropped_xfer_len;
-		xfer_len = dma_len - dropped_xfer_len;
-
-		if (nfirst < 0 && xfer_len > 0) {
-			sg_first = sg;
-			nfirst = i;
-			nfirst_offset = dropped_xfer_len;
+	int i, nents;
+	size_t size, len;
+	struct sg_splitter *splitters, *curr;
+	struct scatterlist *sg;
+
+	splitters = kcalloc(nb_splits, sizeof(*splitters), gfp_mask);
+	if (!splitters)
+		return NULL;
+
+	nents = 0;
+	size = *sizes;
+	curr = splitters;
+	for_each_sg(in, sg, sg_nents(in), i) {
+		if (skip > sg_dma_len(sg)) {
+			skip -= sg_dma_len(sg);
+			continue;
+		}
+		len = min_t(size_t, size, sg_dma_len(sg) - skip);
+		if (!curr->in_sg0) {
+			curr->in_sg0 = sg;
+			curr->skip_sg0 = sg_dma_len(sg) - len;
 		}
-		if (xfer_len > 0) {
-			(*new_sg_len)++;
-			remain -= xfer_len;
+		size -= len;
+		nents++;
+		if (!size) {
+			curr->nents = nents;
+			curr->len_last_sg = len;
+			nents = 0;
+			size = *(++sizes);
+
+			if (!--nb_splits)
+				break;
+
+			if (len < curr->len_last_sg) {
+				(splitters + 1)->in_sg0 = sg;
+				(splitters + 1)->skip_sg0 = 0;
+			}
+			curr++;
 		}
-		if (remain <= 0)
-			break;
 	}
-	WARN_ON(nfirst >= sglen);
 
-	sg0 = kmalloc_array(*new_sg_len, sizeof(struct scatterlist),
-			    GFP_KERNEL);
-	if (!sg0)
-		return NULL;
+	return splitters;
+}
 
-	remain = size;
-	for_each_sg(sg_first, sg, *new_sg_len, i) {
-		dma_len = sg_dma_len(sg);
-		sg0[i] = *sg;
+static int sg_split(struct scatterlist *in, const int nb_splits,
+		    const size_t *split_sizes, struct scatterlist **out,
+		    gfp_t gfp_mask)
+{
+	int i, j;
+	struct scatterlist *in_sg, *out_sg;
+	struct sg_splitter *splitters, *split;
 
-		sg0[i].offset = nfirst_offset;
-		nfirst_offset = 0;
+	splitters = sg_calculate_split(in, 0, split_sizes, nb_splits, gfp_mask);
+	if (!splitters)
+		return -ENOMEM;
 
-		xfer_len = min_t(int, remain, dma_len - sg0[i].offset);
-		xfer_len = roundup(xfer_len, 8);
-		sg_dma_len(&sg0[i]) = xfer_len;
+	for (i = 0; i < nb_splits; i++) {
+		(splitters + i)->out_sg =
+			kmalloc_array((splitters + i)->nents,
+				      sizeof(struct scatterlist), gfp_mask);
+		if (!(splitters + i)->out_sg)
+			goto err;
+	}
 
-		remain -= xfer_len;
-		if (remain <= 0) {
-			sg_mark_end(&sg0[i]);
-			break;
+	for (i = 0; i < nb_splits; i++) {
+		split = splitters + i;
+		in_sg = split->in_sg0;
+		out_sg = split->out_sg;
+		out[i] = out_sg;
+		for (j = 0; j < split->nents; j++) {
+			out_sg[j] = *in_sg;
+			if (!j) {
+				out_sg[j].offset = split->skip_sg0;
+				sg_dma_len(&out_sg[j]) -= split->skip_sg0;
+			} else {
+				out_sg[j].offset = 0;
+			}
+			in_sg = sg_next(in_sg);
 		}
+		sg_dma_len(out_sg + split->nents - 1) = split->len_last_sg;
+		sg_mark_end(out_sg + split->nents - 1);
 	}
 
-	return sg0;
+	kfree(splitters);
+	return 0;
+
+err:
+	for (i = 0; i < nb_splits; i++)
+		kfree((splitters + i)->out_sg);
+	kfree(splitters);
+	return -ENOMEM;
 }
 
 static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
@@ -391,14 +437,11 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 				int cibr, int size, int offset)
 {
 	struct dma_chan *dma_chan = pcdev->dma_chans[channel];
-	struct scatterlist *sg;
+	struct scatterlist *sg = buf->sg[channel];
 	int sglen;
 	struct dma_async_tx_descriptor *tx;
 
-	sg = videobuf_sg_cut(dma->sglist, dma->sglen, offset, size, &sglen);
-	if (!sg)
-		goto fail;
-
+	sglen = sg_nents(sg);
 	tx = dmaengine_prep_slave_sg(dma_chan, sg, sglen, DMA_DEV_TO_MEM,
 				     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
 	if (!tx) {
@@ -421,7 +464,6 @@ static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
 	}
 
 	buf->descs[channel] = tx;
-	buf->sg[channel] = sg;
 	buf->sg_len[channel] = sglen;
 	return 0;
 fail:
@@ -458,6 +500,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 	struct pxa_buffer *buf = container_of(vb, struct pxa_buffer, vb);
 	int ret;
 	int size_y, size_u = 0, size_v = 0;
+	size_t sizes[3];
 
 	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
 		vb, vb->baddr, vb->bsize);
@@ -513,6 +556,16 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
 			size_y = size;
 		}
 
+		sizes[0] = size_y;
+		sizes[1] = size_u;
+		sizes[2] = size_v;
+		ret = sg_split(dma->sglist, pcdev->channels, sizes, buf->sg,
+			       GFP_KERNEL);
+		if (ret) {
+			dev_err(dev, "sg_split failed: %d\n", ret);
+			goto fail;
+		}
+
 		/* init DMA for Y channel */
 		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0,
 					   size_y, 0);
