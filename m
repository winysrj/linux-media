Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62904 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbbFUQC2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jun 2015 12:02:28 -0400
Date: Sun, 21 Jun 2015 18:02:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Daniel Mack <zonque@gmail.com>,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH 4/4] media: pxa_camera: conversion to dmaengine
In-Reply-To: <1426980085-12281-5-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1506201424090.31977@axis700.grange>
References: <1426980085-12281-1-git-send-email-robert.jarzmik@free.fr>
 <1426980085-12281-5-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

On Sun, 22 Mar 2015, Robert Jarzmik wrote:

> From: Robert Jarzmik <robert.jarzmik@intel.com>
> 
> Convert pxa_camera to dmaengine. This removes all DMA registers
> manipulation in favor of the more generic dmaengine API.
> 
> The functional level should be the same as before. The biggest change is
> in the videobuf_sg_splice() function, which splits a videobuf-dma into

As also commented below, I'm not sure "splice" is a good word for 
splitting.

> several scatterlists for 3 planes captures (Y, U, V).

"Several" is actually exactly 3, isn't it?

> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 428 ++++++++++++-------------
>  1 file changed, 211 insertions(+), 217 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 8b39f44..8644022 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -28,6 +28,9 @@
>  #include <linux/clk.h>
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/dma/pxa-dma.h>
>  
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
> @@ -38,7 +41,6 @@
>  
>  #include <linux/videodev2.h>
>  
> -#include <mach/dma.h>
>  #include <linux/platform_data/camera-pxa.h>
>  
>  #define PXA_CAM_VERSION "0.0.6"
> @@ -175,21 +177,16 @@ enum pxa_camera_active_dma {
>  	DMA_V = 0x4,
>  };
>  
> -/* descriptor needed for the PXA DMA engine */
> -struct pxa_cam_dma {
> -	dma_addr_t		sg_dma;
> -	struct pxa_dma_desc	*sg_cpu;
> -	size_t			sg_size;
> -	int			sglen;
> -};
> -
>  /* buffer for one video frame */
>  struct pxa_buffer {
>  	/* common v4l buffer stuff -- must be first */
>  	struct videobuf_buffer		vb;
>  	u32	code;
>  	/* our descriptor lists for Y, U and V channels */
> -	struct pxa_cam_dma		dmas[3];
> +	struct dma_async_tx_descriptor	*descs[3];
> +	dma_cookie_t			cookie[3];
> +	struct scatterlist		*sg[3];
> +	int				sg_len[3];
>  	int				inwork;
>  	enum pxa_camera_active_dma	active_dma;
>  };
> @@ -207,7 +204,7 @@ struct pxa_camera_dev {
>  	void __iomem		*base;
>  
>  	int			channels;
> -	unsigned int		dma_chans[3];
> +	struct dma_chan		*dma_chans[3];
>  
>  	struct pxacamera_platform_data *pdata;
>  	struct resource		*res;
> @@ -222,7 +219,6 @@ struct pxa_camera_dev {
>  	spinlock_t		lock;
>  
>  	struct pxa_buffer	*active;
> -	struct pxa_dma_desc	*sg_tail[3];
>  	struct tasklet_struct	task_eof;
>  
>  	u32			save_cicr[5];
> @@ -259,7 +255,6 @@ static int pxa_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
>  static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>  {
>  	struct soc_camera_device *icd = vq->priv_data;
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
>  	int i;
>  
> @@ -276,41 +271,82 @@ static void free_buffer(struct videobuf_queue *vq, struct pxa_buffer *buf)
>  	if (buf->vb.state == VIDEOBUF_NEEDS_INIT)
>  		return;
>  
> -	for (i = 0; i < ARRAY_SIZE(buf->dmas); i++) {
> -		if (buf->dmas[i].sg_cpu)
> -			dma_free_coherent(ici->v4l2_dev.dev,
> -					  buf->dmas[i].sg_size,
> -					  buf->dmas[i].sg_cpu,
> -					  buf->dmas[i].sg_dma);
> -		buf->dmas[i].sg_cpu = NULL;
> +	for (i = 0; i < 3 && buf->descs[i]; i++) {
> +		async_tx_ack(buf->descs[i]);
> +		dmaengine_tx_release(buf->descs[i]);
> +		kfree(buf->sg[i]);
> +		buf->descs[i] = NULL;
> +		buf->sg[i] = NULL;
> +		buf->sg_len[i] = 0;
>  	}
>  	videobuf_dma_unmap(vq->dev, dma);
>  	videobuf_dma_free(dma);
>  
>  	buf->vb.state = VIDEOBUF_NEEDS_INIT;
> +
> +	dev_dbg(icd->parent, "%s end (vb=0x%p) 0x%08lx %d\n", __func__,
> +		&buf->vb, buf->vb.baddr, buf->vb.bsize);
>  }
>  
> -static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,
> -			       int sg_first_ofs, int size)
> +static struct scatterlist *videobuf_sg_splice(struct scatterlist *sglist,
> +					      int sglen, int offset, int size,
> +					      int *new_sg_len)
>  {
> -	int i, offset, dma_len, xfer_len;
> -	struct scatterlist *sg;
> +	struct scatterlist *sg0, *sg, *sg_first = NULL;
> +	int i, dma_len, dropped_xfer_len, dropped_remain, remain;
> +	int nfirst = -1, nfirst_offset = 0, xfer_len;
>  
> -	offset = sg_first_ofs;
> +	*new_sg_len = 0;
> +	dropped_remain = offset;
> +	remain = size;
>  	for_each_sg(sglist, sg, sglen, i) {

Ok, after something-that-felt-like-hours of looking at this code, I think, 
I understand now, that first you calculate what sg elements have been used 
for offset bytes, which is either 0, or the size of the Y plain, or size 
of Y + U plains.

>  		dma_len = sg_dma_len(sg);
> -
>  		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> -		xfer_len = roundup(min(dma_len - offset, size), 8);
> +		dropped_xfer_len = roundup(min(dma_len, dropped_remain), 8);
> +		if (dropped_remain)
> +			dropped_remain -= dropped_xfer_len;
> +		xfer_len = dma_len - dropped_xfer_len;
> +
> +		if ((nfirst < 0) && (xfer_len > 0)) {

Superfluous parentheses

> +			sg_first = sg;
> +			nfirst = i;
> +			nfirst_offset = dropped_xfer_len;
> +		}
> +		if (xfer_len > 0) {
> +			*new_sg_len = *new_sg_len + 1;

make it

+			(*new_sg_len)++;

> +			remain -= xfer_len;
> +		}
> +		if (remain <= 0)
> +			break;
> +	}
> +	WARN_ON(nfirst >= sglen);
>  
> -		size = max(0, size - xfer_len);
> -		offset = 0;
> -		if (size == 0)
> +	sg0 = kmalloc_array(*new_sg_len, sizeof(struct scatterlist),
> +			    GFP_KERNEL);
> +	if (!sg0)
> +		return NULL;
> +
> +	remain = size;
> +	for_each_sg(sg_first, sg, *new_sg_len, i) {
> +		dma_len = sg_dma_len(sg);
> +		sg0[i] = *sg;
> +
> +		sg0[i].offset = nfirst_offset;
> +		nfirst_offset = 0;
> +
> +		xfer_len = min_t(int, remain, dma_len - sg0[i].offset);
> +		xfer_len = roundup(xfer_len, 8);
> +		sg_dma_len(&sg0[i]) = xfer_len;
> +
> +		remain -= xfer_len;
> +		if (remain <= 0) {
> +			sg_mark_end(&sg0[i]);
>  			break;
> +		}
>  	}
>  
> -	BUG_ON(size != 0);
> -	return i + 1;
> +	return sg0;
> +}
>  static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
>  			       enum pxa_camera_active_dma act_dma);
>  
> @@ -343,93 +379,59 @@ static void pxa_camera_dma_irq_v(void *data)
>   * @channel: dma channel (0 => 'Y', 1 => 'U', 2 => 'V')
>   * @cibr: camera Receive Buffer Register
>   * @size: bytes to transfer
> - * @sg_first: first element of sg_list
> - * @sg_first_ofs: offset in first element of sg_list
> + * @offset: offset in videobuffer of the first byte to transfer
>   *
>   * Prepares the pxa dma descriptors to transfer one camera channel.
> - * Beware sg_first and sg_first_ofs are both input and output parameters.
>   *
> - * Returns 0 or -ENOMEM if no coherent memory is available
> + * Returns 0 if success or -ENOMEM if no memory is available
>   */
>  static int pxa_init_dma_channel(struct pxa_camera_dev *pcdev,
>  				struct pxa_buffer *buf,
>  				struct videobuf_dmabuf *dma, int channel,
> -				int cibr, int size,
> -				struct scatterlist **sg_first, int *sg_first_ofs)
> +				int cibr, int size, int offset)
>  {

Hmm, ok, can you, please, explain, why you have to change this so much? 
IIUC, the functionality, that you're implementing now is rather similar to 
the present one - you split the global videobuf SG list into 3 SG lists 
for YUV formats. Of course, details are different, you don't use 
pxa_dma_desc and all the low-level values directly, you prepare a standard 
SG list for your dmaengine driver. But the splitting is the same, isn't 
it? And the current one seems rather good to me, because it preserves and 
re-uses partially consumed pointers instead of recalculating them every 
time, like you do it in your new version. What's the reason for that? Is 
the current version buggy or the current approach unsuitable for your new 
version?

> -	struct pxa_cam_dma *pxa_dma = &buf->dmas[channel];
> -	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
> -	struct scatterlist *sg;
> -	int i, offset, sglen;
> -	int dma_len = 0, xfer_len = 0;
> -
> -	if (pxa_dma->sg_cpu)
> -		dma_free_coherent(dev, pxa_dma->sg_size,
> -				  pxa_dma->sg_cpu, pxa_dma->sg_dma);
> -
> -	sglen = calculate_dma_sglen(*sg_first, dma->sglen,
> -				    *sg_first_ofs, size);
> -
> -	pxa_dma->sg_size = (sglen + 1) * sizeof(struct pxa_dma_desc);
> -	pxa_dma->sg_cpu = dma_alloc_coherent(dev, pxa_dma->sg_size,
> -					     &pxa_dma->sg_dma, GFP_KERNEL);
> -	if (!pxa_dma->sg_cpu)
> -		return -ENOMEM;
> -
> -	pxa_dma->sglen = sglen;
> -	offset = *sg_first_ofs;
> -
> -	dev_dbg(dev, "DMA: sg_first=%p, sglen=%d, ofs=%d, dma.desc=%x\n",
> -		*sg_first, sglen, *sg_first_ofs, pxa_dma->sg_dma);
> -
> -
> -	for_each_sg(*sg_first, sg, sglen, i) {
> -		dma_len = sg_dma_len(sg);
> -
> -		/* PXA27x Developer's Manual 27.4.4.1: round up to 8 bytes */
> -		xfer_len = roundup(min(dma_len - offset, size), 8);
> -
> -		size = max(0, size - xfer_len);
> -
> -		pxa_dma->sg_cpu[i].dsadr = pcdev->res->start + cibr;
> -		pxa_dma->sg_cpu[i].dtadr = sg_dma_address(sg) + offset;
> -		pxa_dma->sg_cpu[i].dcmd =
> -			DCMD_FLOWSRC | DCMD_BURST8 | DCMD_INCTRGADDR | xfer_len;
> -#ifdef DEBUG
> -		if (!i)
> -			pxa_dma->sg_cpu[i].dcmd |= DCMD_STARTIRQEN;
> -#endif
> -		pxa_dma->sg_cpu[i].ddadr =
> -			pxa_dma->sg_dma + (i + 1) * sizeof(struct pxa_dma_desc);
> -
> -		dev_vdbg(dev, "DMA: desc.%08x->@phys=0x%08x, len=%d\n",
> -			 pxa_dma->sg_dma + i * sizeof(struct pxa_dma_desc),
> -			 sg_dma_address(sg) + offset, xfer_len);
> -		offset = 0;
> -
> -		if (size == 0)
> -			break;
> +	struct dma_chan *dma_chan = pcdev->dma_chans[channel];
> +	struct scatterlist *sg = NULL;

Superfluous initialisation

> +	int sglen;
> +	struct dma_async_tx_descriptor *tx;
> +
> +	sg = videobuf_sg_splice(dma->sglist, dma->sglen, offset, size, &sglen);

Isn't it rather a cut, than a splice function?

> +	if (!sg)
> +		goto fail;
> +
> +	tx = dmaengine_prep_slave_sg(dma_chan, sg, sglen, DMA_DEV_TO_MEM,
> +				     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
> +	if (!tx) {
> +		dev_err(pcdev->soc_host.v4l2_dev.dev,
> +			"dmaengine_prep_slave_sg failed\n");
> +		goto fail;
>  	}
>  
> -	pxa_dma->sg_cpu[sglen].ddadr = DDADR_STOP;
> -	pxa_dma->sg_cpu[sglen].dcmd  = DCMD_FLOWSRC | DCMD_BURST8 | DCMD_ENDIRQEN;
> -
> -	/*
> -	 * Handle 1 special case :
> -	 *  - in 3 planes (YUV422P format), we might finish with xfer_len equal
> -	 *    to dma_len (end on PAGE boundary). In this case, the sg element
> -	 *    for next plane should be the next after the last used to store the
> -	 *    last scatter gather RAM page
> -	 */
> -	if (xfer_len >= dma_len) {
> -		*sg_first_ofs = xfer_len - dma_len;
> -		*sg_first = sg_next(sg);
> -	} else {
> -		*sg_first_ofs = xfer_len;
> -		*sg_first = sg;
> +	tx->callback_param = pcdev;
> +	switch (channel) {
> +	case 0:
> +		tx->callback = pxa_camera_dma_irq_y;
> +		break;
> +	case 1:
> +		tx->callback = pxa_camera_dma_irq_u;
> +		break;
> +	case 2:
> +		tx->callback = pxa_camera_dma_irq_v;
> +		break;
>  	}
>  
> +	buf->descs[channel] = tx;
> +	buf->sg[channel] = sg;
> +	buf->sg_len[channel] = sglen;
>  	return 0;
> +fail:
> +	kfree(sg);
> +
> +	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
> +		"%s (vb=0x%p) dma_tx=%p\n",
> +		__func__, &buf->vb, tx);
> +
> +	return -ENOMEM;
>  }
>  
>  static void pxa_videobuf_set_actdma(struct pxa_camera_dev *pcdev,
> @@ -498,9 +500,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  
>  	if (vb->state == VIDEOBUF_NEEDS_INIT) {
>  		int size = vb->size;
> -		int next_ofs = 0;
>  		struct videobuf_dmabuf *dma = videobuf_to_dma(vb);
> -		struct scatterlist *sg;
>  
>  		ret = videobuf_iolock(vq, vb, NULL);
>  		if (ret)
> @@ -513,11 +513,9 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  			size_y = size;
>  		}
>  
> -		sg = dma->sglist;
> -
>  		/* init DMA for Y channel */
> -		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0, size_y,
> -					   &sg, &next_ofs);
> +		ret = pxa_init_dma_channel(pcdev, buf, dma, 0, CIBR0,
> +					   size_y, 0);
>  		if (ret) {
>  			dev_err(dev, "DMA initialization for Y/RGB failed\n");
>  			goto fail;
> @@ -526,7 +524,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  		/* init DMA for U channel */
>  		if (size_u)
>  			ret = pxa_init_dma_channel(pcdev, buf, dma, 1, CIBR1,
> -						   size_u, &sg, &next_ofs);
> +						   size_u, size_y);
>  		if (ret) {
>  			dev_err(dev, "DMA initialization for U failed\n");
>  			goto fail_u;
> @@ -535,7 +533,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  		/* init DMA for V channel */
>  		if (size_v)
>  			ret = pxa_init_dma_channel(pcdev, buf, dma, 2, CIBR2,
> -						   size_v, &sg, &next_ofs);
> +						   size_v, size_y + size_u);
>  		if (ret) {
>  			dev_err(dev, "DMA initialization for V failed\n");
>  			goto fail_v;
> @@ -550,11 +548,7 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  	return 0;
>  
>  fail_v:
> -	dma_free_coherent(dev, buf->dmas[1].sg_size,
> -			  buf->dmas[1].sg_cpu, buf->dmas[1].sg_dma);
>  fail_u:
> -	dma_free_coherent(dev, buf->dmas[0].sg_size,
> -			  buf->dmas[0].sg_cpu, buf->dmas[0].sg_dma);
>  fail:

You don't need 3 exit labels any more.

>  	free_buffer(vq, buf);
>  out:
> @@ -578,10 +572,8 @@ static void pxa_dma_start_channels(struct pxa_camera_dev *pcdev)
>  
>  	for (i = 0; i < pcdev->channels; i++) {
>  		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
> -			"%s (channel=%d) ddadr=%08x\n", __func__,
> -			i, active->dmas[i].sg_dma);
> -		DDADR(pcdev->dma_chans[i]) = active->dmas[i].sg_dma;
> -		DCSR(pcdev->dma_chans[i]) = DCSR_RUN;
> +			"%s (channel=%d)\n", __func__, i);
> +		dma_async_issue_pending(pcdev->dma_chans[i]);
>  	}
>  }
>  
> @@ -592,7 +584,7 @@ static void pxa_dma_stop_channels(struct pxa_camera_dev *pcdev)
>  	for (i = 0; i < pcdev->channels; i++) {
>  		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
>  			"%s (channel=%d)\n", __func__, i);
> -		DCSR(pcdev->dma_chans[i]) = 0;
> +		dmaengine_terminate_all(pcdev->dma_chans[i]);
>  	}
>  }
>  
> @@ -600,18 +592,12 @@ static void pxa_dma_add_tail_buf(struct pxa_camera_dev *pcdev,
>  				 struct pxa_buffer *buf)
>  {
>  	int i;
> -	struct pxa_dma_desc *buf_last_desc;
>  
>  	for (i = 0; i < pcdev->channels; i++) {
> -		buf_last_desc = buf->dmas[i].sg_cpu + buf->dmas[i].sglen;
> -		buf_last_desc->ddadr = DDADR_STOP;
> -
> -		if (pcdev->sg_tail[i])
> -			/* Link the new buffer to the old tail */
> -			pcdev->sg_tail[i]->ddadr = buf->dmas[i].sg_dma;
> -
> -		/* Update the channel tail */
> -		pcdev->sg_tail[i] = buf_last_desc;
> +		buf->cookie[i] = dmaengine_submit(buf->descs[i]);
> +		dev_dbg(pcdev->soc_host.v4l2_dev.dev,
> +			"%s (channel=%d) : submit vb=%p cookie=%d\n",
> +			__func__, i, buf, buf->descs[i]->cookie);
>  	}
>  }
>  
> @@ -703,8 +689,6 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
>  			      struct videobuf_buffer *vb,
>  			      struct pxa_buffer *buf)
>  {
> -	int i;
> -
>  	/* _init is used to debug races, see comment in pxa_camera_reqbufs() */
>  	list_del_init(&vb->queue);
>  	vb->state = VIDEOBUF_DONE;
> @@ -716,8 +700,6 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
>  
>  	if (list_empty(&pcdev->capture)) {
>  		pxa_camera_stop_capture(pcdev);
> -		for (i = 0; i < pcdev->channels; i++)
> -			pcdev->sg_tail[i] = NULL;
>  		return;
>  	}
>  
> @@ -741,50 +723,41 @@ static void pxa_camera_wakeup(struct pxa_camera_dev *pcdev,
>   *
>   * Context: should only be called within the dma irq handler
>   */
> -static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev)
> +static void pxa_camera_check_link_miss(struct pxa_camera_dev *pcdev,
> +				       dma_cookie_t last_submitted,
> +				       dma_cookie_t last_issued)
>  {
> -	int i, is_dma_stopped = 1;
> +	int is_dma_stopped;
>  
> -	for (i = 0; i < pcdev->channels; i++)
> -		if (DDADR(pcdev->dma_chans[i]) != DDADR_STOP)
> -			is_dma_stopped = 0;
> +	is_dma_stopped = last_submitted > last_issued;

IIUC, actually last_issued should be == last_submitted, right? And your 
dmaengine driver's .device_tx_status() method returns the last "really" 
submitted cookie, so, if that situation occurs, that you submit a transfer 
when DMA is off, your last_buf->cookie[chan] will contain it, as returned 
by dmaengine_submit(), but .device_tx_status() will not return it? Then, 
this comparison "last_submitted > last_issued" isn't a good test, cookies 
can overrun. Maybe just check for unequal? Otherwise I think you'd have to 
find a way to use dma_async_is_complete().

>  	dev_dbg(pcdev->soc_host.v4l2_dev.dev,
> -		"%s : top queued buffer=%p, dma_stopped=%d\n",
> +		"%s : top queued buffer=%p, is_dma_stopped=%d\n",
>  		__func__, pcdev->active, is_dma_stopped);
>  	if (pcdev->active && is_dma_stopped)
>  		pxa_camera_start_capture(pcdev);
>  }
>  
> -static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
> +static void pxa_camera_dma_irq(struct pxa_camera_dev *pcdev,
>  			       enum pxa_camera_active_dma act_dma)
>  {
>  	struct device *dev = pcdev->soc_host.v4l2_dev.dev;
> -	struct pxa_buffer *buf;
> +	struct pxa_buffer *buf, *last_buf;
>  	unsigned long flags;
> -	u32 status, camera_status, overrun;
> +	u32 camera_status, overrun;
> +	int chan;
>  	struct videobuf_buffer *vb;
> +	enum dma_status last_status;
> +	dma_cookie_t last_issued;
>  
>  	spin_lock_irqsave(&pcdev->lock, flags);
>  
> -	status = DCSR(channel);
> -	DCSR(channel) = status;
> -
>  	camera_status = __raw_readl(pcdev->base + CISR);
> +	dev_dbg(dev, "camera dma irq, cisr=0x%x dma=%d\n",
> +		camera_status, act_dma);
>  	overrun = CISR_IFO_0;
>  	if (pcdev->channels == 3)
>  		overrun |= CISR_IFO_1 | CISR_IFO_2;
>  
> -	if (status & DCSR_BUSERR) {
> -		dev_err(dev, "DMA Bus Error IRQ!\n");
> -		goto out;
> -	}
> -
> -	if (!(status & (DCSR_ENDINTR | DCSR_STARTINTR))) {
> -		dev_err(dev, "Unknown DMA IRQ source, status: 0x%08x\n",
> -			status);
> -		goto out;
> -	}
> -
>  	/*
>  	 * pcdev->active should not be NULL in DMA irq handler.
>  	 *
> @@ -804,28 +777,39 @@ static void pxa_camera_dma_irq(int channel, struct pxa_camera_dev *pcdev,
>  	buf = container_of(vb, struct pxa_buffer, vb);
>  	WARN_ON(buf->inwork || list_empty(&vb->queue));
>  
> -	dev_dbg(dev, "%s channel=%d %s%s(vb=0x%p) dma.desc=%x\n",
> -		__func__, channel, status & DCSR_STARTINTR ? "SOF " : "",
> -		status & DCSR_ENDINTR ? "EOF " : "", vb, DDADR(channel));
> -
> -	if (status & DCSR_ENDINTR) {
> -		/*
> -		 * It's normal if the last frame creates an overrun, as there
> -		 * are no more DMA descriptors to fetch from QCI fifos
> -		 */
> -		if (camera_status & overrun &&
> -		    !list_is_last(pcdev->capture.next, &pcdev->capture)) {
> -			dev_dbg(dev, "FIFO overrun! CISR: %x\n",
> -				camera_status);
> -			pxa_camera_stop_capture(pcdev);
> -			pxa_camera_start_capture(pcdev);
> -			goto out;
> -		}
> -		buf->active_dma &= ~act_dma;
> -		if (!buf->active_dma) {
> -			pxa_camera_wakeup(pcdev, vb, buf);
> -			pxa_camera_check_link_miss(pcdev);
> -		}
> +	/*
> +	 * It's normal if the last frame creates an overrun, as there
> +	 * are no more DMA descriptors to fetch from QCI fifos
> +	 */
> +	switch (act_dma) {
> +	case DMA_U:
> +		chan = 1;
> +		break;
> +	case DMA_V:
> +		chan = 2;
> +		break;
> +	default:
> +		chan = 0;
> +		break;
> +	}
> +	last_buf = list_entry(pcdev->capture.prev,
> +			      struct pxa_buffer, vb.queue);
> +	last_status = dma_async_is_tx_complete(pcdev->dma_chans[chan],
> +					       last_buf->cookie[chan],
> +					       NULL, &last_issued);
> +	if (camera_status & overrun &&
> +	    last_status != DMA_COMPLETE) {

Isn't the compiler suggesting parentheses here?

> +		dev_dbg(dev, "FIFO overrun! CISR: %x\n",
> +			camera_status);
> +		pxa_camera_stop_capture(pcdev);
> +		pxa_camera_start_capture(pcdev);
> +		goto out;
> +	}
> +	buf->active_dma &= ~act_dma;
> +	if (!buf->active_dma) {
> +		pxa_camera_wakeup(pcdev, vb, buf);
> +		pxa_camera_check_link_miss(pcdev, last_buf->cookie[chan],
> +					   last_issued);
>  	}
>  
>  out:
> @@ -1012,10 +996,7 @@ static void pxa_camera_clock_stop(struct soc_camera_host *ici)
>  	__raw_writel(0x3ff, pcdev->base + CICR0);
>  
>  	/* Stop DMA engine */
> -	DCSR(pcdev->dma_chans[0]) = 0;
> -	DCSR(pcdev->dma_chans[1]) = 0;
> -	DCSR(pcdev->dma_chans[2]) = 0;
> -
> +	pxa_dma_stop_channels(pcdev);

Isn't calling pxa_dma_stop_channels() in pxa_camera_stop_capture() enough? 
.clock_stop() should only be called after streaming has been stopped. But 
it has been here since forever, so...

>  	pxa_camera_deactivate(pcdev);
>  }
>  
> @@ -1629,10 +1610,6 @@ static int pxa_camera_resume(struct device *dev)
>  	struct pxa_camera_dev *pcdev = ici->priv;
>  	int i = 0, ret = 0;
>  
> -	DRCMR(68) = pcdev->dma_chans[0] | DRCMR_MAPVLD;
> -	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
> -	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
> -

Will resume still work after this? Because of dmaengine resume?

>  	__raw_writel(pcdev->save_cicr[i++] & ~CICR0_ENB, pcdev->base + CICR0);
>  	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR1);
>  	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR2);
> @@ -1738,8 +1715,11 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	struct pxa_camera_dev *pcdev;
>  	struct resource *res;
>  	void __iomem *base;
> +	struct dma_slave_config config;

I would do

+	struct dma_slave_config config = {
+		.direction = DMA_DEV_TO_MEM,
+		.src_maxburst = 8,
+	};

and have all other fields initialised to 0 automatically.

> +	dma_cap_mask_t mask;
> +	struct pxad_param params;
>  	int irq;
> -	int err = 0;
> +	int err = 0, i;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	irq = platform_get_irq(pdev, 0);
> @@ -1807,36 +1787,50 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	pcdev->base = base;
>  
>  	/* request dma */
> -	err = pxa_request_dma("CI_Y", DMA_PRIO_HIGH,
> -			      pxa_camera_dma_irq_y, pcdev);
> -	if (err < 0) {
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_SLAVE, mask);

Also DMA_PRIVATE?

> +
> +	params.prio = 0;
> +	params.drcmr = 68;
> +	pcdev->dma_chans[0] =
> +		dma_request_slave_channel_compat(mask, pxad_filter_fn,
> +						 &params, &pdev->dev, "CI_Y");
> +	if (!pcdev->dma_chans[0]) {
>  		dev_err(&pdev->dev, "Can't request DMA for Y\n");
> -		return err;
> +		return -ENODEV;
>  	}
> -	pcdev->dma_chans[0] = err;
> -	dev_dbg(&pdev->dev, "got DMA channel %d\n", pcdev->dma_chans[0]);
>  
> -	err = pxa_request_dma("CI_U", DMA_PRIO_HIGH,
> -			      pxa_camera_dma_irq_u, pcdev);
> -	if (err < 0) {
> -		dev_err(&pdev->dev, "Can't request DMA for U\n");
> +	params.drcmr = 69;
> +	pcdev->dma_chans[1] =
> +		dma_request_slave_channel_compat(mask, pxad_filter_fn,
> +						 &params, &pdev->dev, "CI_U");
> +	if (!pcdev->dma_chans[1]) {
> +		dev_err(&pdev->dev, "Can't request DMA for Y\n");
>  		goto exit_free_dma_y;
>  	}
> -	pcdev->dma_chans[1] = err;
> -	dev_dbg(&pdev->dev, "got DMA channel (U) %d\n", pcdev->dma_chans[1]);
>  
> -	err = pxa_request_dma("CI_V", DMA_PRIO_HIGH,
> -			      pxa_camera_dma_irq_v, pcdev);
> -	if (err < 0) {
> +	params.drcmr = 70;
> +	pcdev->dma_chans[2] =
> +		dma_request_slave_channel_compat(mask, pxad_filter_fn,
> +						 &params, &pdev->dev, "CI_V");
> +	if (!pcdev->dma_chans[2]) {
>  		dev_err(&pdev->dev, "Can't request DMA for V\n");
>  		goto exit_free_dma_u;
>  	}
> -	pcdev->dma_chans[2] = err;
> -	dev_dbg(&pdev->dev, "got DMA channel (V) %d\n", pcdev->dma_chans[2]);
>  
> -	DRCMR(68) = pcdev->dma_chans[0] | DRCMR_MAPVLD;
> -	DRCMR(69) = pcdev->dma_chans[1] | DRCMR_MAPVLD;
> -	DRCMR(70) = pcdev->dma_chans[2] | DRCMR_MAPVLD;
> +	memset(&config, 0, sizeof(config));
> +	config.src_addr_width = 0;
> +	config.src_maxburst = 8;
> +	config.direction = DMA_DEV_TO_MEM;
> +	for (i = 0; i < 3; i++) {
> +		config.src_addr = pcdev->res->start + CIBR0 + i * 8;
> +		err = dmaengine_slave_config(pcdev->dma_chans[i], &config);
> +		if (err < 0) {
> +			dev_err(&pdev->dev, "dma slave config failed: %d\n",
> +				err);
> +			goto exit_free_dma;
> +		}
> +	}
>  
>  	/* request irq */
>  	err = devm_request_irq(&pdev->dev, pcdev->irq, pxa_camera_irq, 0,
> @@ -1860,11 +1854,11 @@ static int pxa_camera_probe(struct platform_device *pdev)
>  	return 0;
>  
>  exit_free_dma:
> -	pxa_free_dma(pcdev->dma_chans[2]);
> +	dma_release_channel(pcdev->dma_chans[2]);
>  exit_free_dma_u:
> -	pxa_free_dma(pcdev->dma_chans[1]);
> +	dma_release_channel(pcdev->dma_chans[1]);
>  exit_free_dma_y:
> -	pxa_free_dma(pcdev->dma_chans[0]);
> +	dma_release_channel(pcdev->dma_chans[0]);
>  	return err;
>  }
>  
> @@ -1874,9 +1868,9 @@ static int pxa_camera_remove(struct platform_device *pdev)
>  	struct pxa_camera_dev *pcdev = container_of(soc_host,
>  					struct pxa_camera_dev, soc_host);
>  
> -	pxa_free_dma(pcdev->dma_chans[0]);
> -	pxa_free_dma(pcdev->dma_chans[1]);
> -	pxa_free_dma(pcdev->dma_chans[2]);
> +	dma_release_channel(pcdev->dma_chans[0]);
> +	dma_release_channel(pcdev->dma_chans[1]);
> +	dma_release_channel(pcdev->dma_chans[2]);
>  
>  	soc_camera_host_unregister(soc_host);
>  
> -- 
> 2.1.4
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
