Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:57724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab1BUIjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 03:39:11 -0500
Date: Mon, 21 Feb 2011 09:38:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	'Sascha Hauer' <s.hauer@pengutronix.de>
Subject: RE: [PATCH 2/4] V4L: mx3_camera: convert to videobuf2
In-Reply-To: <000001cbd19e$1f528210$5df78630$%szyprowski@samsung.com>
Message-ID: <Pine.LNX.4.64.1102210937500.26977@axis700.grange>
References: <Pine.LNX.4.64.1102180857360.1851@axis700.grange>
 <Pine.LNX.4.64.1102180906500.1851@axis700.grange>
 <000001cbd19e$1f528210$5df78630$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Marek

Thanks for your review, I'll update the patch accordingly.

Regards
Guennadi

On Mon, 21 Feb 2011, Marek Szyprowski wrote:

> Hello,
> 
> On Friday, February 18, 2011 9:14 AM Guennadi Liakhovetski wrote:
> 
> > Now that soc-camera supports videobuf API v1 and v2, camera-host drivers
> > can be converted to videobuf2 individually. This patch converts the
> > mx3_camera driver.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > This one is also on git.linuxtv.org already.
> > 
> >  drivers/media/video/mx3_camera.c |  342 ++++++++++++++++----------------------
> >  1 files changed, 143 insertions(+), 199 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> > index b9cb4a4..d61ff0d 100644
> > --- a/drivers/media/video/mx3_camera.c
> > +++ b/drivers/media/video/mx3_camera.c
> > @@ -21,7 +21,7 @@
> > 
> >  #include <media/v4l2-common.h>
> >  #include <media/v4l2-dev.h>
> > -#include <media/videobuf-dma-contig.h>
> > +#include <media/videobuf2-dma-contig.h>
> >  #include <media/soc_camera.h>
> >  #include <media/soc_mediabus.h>
> > 
> > @@ -62,10 +62,16 @@
> > 
> >  #define MAX_VIDEO_MEM 16
> > 
> > +enum csi_buffer_state {
> > +	CSI_BUF_NEEDS_INIT,
> > +	CSI_BUF_PREPARED,
> > +};
> > +
> >  struct mx3_camera_buffer {
> >  	/* common v4l buffer stuff -- must be first */
> > -	struct videobuf_buffer			vb;
> > -	enum v4l2_mbus_pixelcode		code;
> > +	struct vb2_buffer			vb;
> > +	enum csi_buffer_state			state;
> > +	struct list_head			queue;
> > 
> >  	/* One descriptot per scatterlist (per frame) */
> >  	struct dma_async_tx_descriptor		*txd;
> > @@ -108,6 +114,9 @@ struct mx3_camera_dev {
> >  	struct list_head	capture;
> >  	spinlock_t		lock;		/* Protects video buffer lists */
> >  	struct mx3_camera_buffer *active;
> > +	struct vb2_alloc_ctx	*alloc_ctx;
> > +	enum v4l2_field		field;
> > +	int			sequence;
> > 
> >  	/* IDMAC / dmaengine interface */
> >  	struct idmac_channel	*idmac_channel[1];	/* We need one channel */
> > @@ -130,6 +139,11 @@ static void csi_reg_write(struct mx3_camera_dev *mx3, u32 value, off_t reg)
> >  	__raw_writel(value, mx3->base + reg);
> >  }
> > 
> > +static struct mx3_camera_buffer *to_mx3_vb(struct vb2_buffer *vb)
> > +{
> > +	return container_of(vb, struct mx3_camera_buffer, vb);
> > +}
> > +
> >  /* Called from the IPU IDMAC ISR */
> >  static void mx3_cam_dma_done(void *arg)
> >  {
> > @@ -137,20 +151,20 @@ static void mx3_cam_dma_done(void *arg)
> >  	struct dma_chan *chan = desc->txd.chan;
> >  	struct idmac_channel *ichannel = to_idmac_chan(chan);
> >  	struct mx3_camera_dev *mx3_cam = ichannel->client;
> > -	struct videobuf_buffer *vb;
> > 
> >  	dev_dbg(chan->device->dev, "callback cookie %d, active DMA 0x%08x\n",
> >  		desc->txd.cookie, mx3_cam->active ? sg_dma_address(&mx3_cam->active->sg) : 0);
> > 
> >  	spin_lock(&mx3_cam->lock);
> >  	if (mx3_cam->active) {
> > -		vb = &mx3_cam->active->vb;
> > -
> > -		list_del_init(&vb->queue);
> > -		vb->state = VIDEOBUF_DONE;
> > -		do_gettimeofday(&vb->ts);
> > -		vb->field_count++;
> > -		wake_up(&vb->done);
> > +		struct vb2_buffer *vb = &mx3_cam->active->vb;
> > +		struct mx3_camera_buffer *buf = to_mx3_vb(vb);
> > +
> > +		list_del_init(&buf->queue);
> > +		do_gettimeofday(&vb->v4l2_buf.timestamp);
> > +		vb->v4l2_buf.field = mx3_cam->field;
> > +		vb->v4l2_buf.sequence = mx3_cam->sequence++;
> > +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> >  	}
> > 
> >  	if (list_empty(&mx3_cam->capture)) {
> > @@ -165,38 +179,10 @@ static void mx3_cam_dma_done(void *arg)
> >  	}
> > 
> >  	mx3_cam->active = list_entry(mx3_cam->capture.next,
> > -				     struct mx3_camera_buffer, vb.queue);
> > -	mx3_cam->active->vb.state = VIDEOBUF_ACTIVE;
> > +				     struct mx3_camera_buffer, queue);
> >  	spin_unlock(&mx3_cam->lock);
> >  }
> > 
> > -static void free_buffer(struct videobuf_queue *vq, struct mx3_camera_buffer *buf)
> > -{
> > -	struct soc_camera_device *icd = vq->priv_data;
> > -	struct videobuf_buffer *vb = &buf->vb;
> > -	struct dma_async_tx_descriptor *txd = buf->txd;
> > -	struct idmac_channel *ichan;
> > -
> > -	BUG_ON(in_interrupt());
> > -
> > -	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> > -		vb, vb->baddr, vb->bsize);
> > -
> > -	/*
> > -	 * This waits until this buffer is out of danger, i.e., until it is no
> > -	 * longer in STATE_QUEUED or STATE_ACTIVE
> > -	 */
> > -	videobuf_waiton(vq, vb, 0, 0);
> > -	if (txd) {
> > -		ichan = to_idmac_chan(txd->chan);
> > -		async_tx_ack(txd);
> > -	}
> > -	videobuf_dma_contig_free(vq, vb);
> > -	buf->txd = NULL;
> > -
> > -	vb->state = VIDEOBUF_NEEDS_INIT;
> > -}
> > -
> >  /*
> >   * Videobuf operations
> >   */
> > @@ -205,10 +191,11 @@ static void free_buffer(struct videobuf_queue *vq, struct mx3_camera_buffer *buf
> >   * Calculate the __buffer__ (not data) size and number of buffers.
> >   * Called with .vb_lock held
> >   */
> > -static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
> > -			      unsigned int *size)
> > +static int mx3_videobuf_setup(struct vb2_queue *vq,
> > +			unsigned int *count, unsigned int *num_planes,
> > +			unsigned long sizes[], void *alloc_ctxs[])
> >  {
> > -	struct soc_camera_device *icd = vq->priv_data;
> > +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> >  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> >  	struct mx3_camera_dev *mx3_cam = ici->priv;
> >  	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> > @@ -220,104 +207,68 @@ static int mx3_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
> >  	if (!mx3_cam->idmac_channel[0])
> >  		return -EINVAL;
> > 
> > -	*size = bytes_per_line * icd->user_height;
> > +	*num_planes = 1;
> > +
> > +	mx3_cam->sequence = 0;
> > +	sizes[0] = bytes_per_line * icd->user_height;
> > +	alloc_ctxs[0] = mx3_cam->alloc_ctx;
> > 
> >  	if (!*count)
> >  		*count = 32;
> > 
> > -	if (*size * *count > MAX_VIDEO_MEM * 1024 * 1024)
> > -		*count = MAX_VIDEO_MEM * 1024 * 1024 / *size;
> > +	if (sizes[0] * *count > MAX_VIDEO_MEM * 1024 * 1024)
> > +		*count = MAX_VIDEO_MEM * 1024 * 1024 / sizes[0];
> > 
> >  	return 0;
> >  }
> > 
> >  /* Called with .vb_lock held */
> 
> vb_lock has no meaning in vb2, so the above line should be removed imho.
> 
> > -static int mx3_videobuf_prepare(struct videobuf_queue *vq,
> > -		struct videobuf_buffer *vb, enum v4l2_field field)
> > +static int mx3_videobuf_prepare(struct vb2_buffer *vb)
> >  {
> > -	struct soc_camera_device *icd = vq->priv_data;
> > +	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> >  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> >  	struct mx3_camera_dev *mx3_cam = ici->priv;
> > -	struct mx3_camera_buffer *buf =
> > -		container_of(vb, struct mx3_camera_buffer, vb);
> > +	struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
> > +	struct scatterlist *sg;
> > +	struct mx3_camera_buffer *buf;
> >  	size_t new_size;
> > -	int ret;
> >  	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> >  						icd->current_fmt->host_fmt);
> > 
> >  	if (bytes_per_line < 0)
> >  		return bytes_per_line;
> > 
> > -	new_size = bytes_per_line * icd->user_height;
> > +	buf = to_mx3_vb(vb);
> > +	sg = &buf->sg;
> > 
> > -	/*
> > -	 * I think, in buf_prepare you only have to protect global data,
> > -	 * the actual buffer is yours
> > -	 */
> > -
> > -	if (buf->code	!= icd->current_fmt->code ||
> > -	    vb->width	!= icd->user_width ||
> > -	    vb->height	!= icd->user_height ||
> > -	    vb->field	!= field) {
> > -		buf->code	= icd->current_fmt->code;
> > -		vb->width	= icd->user_width;
> > -		vb->height	= icd->user_height;
> > -		vb->field	= field;
> > -		if (vb->state != VIDEOBUF_NEEDS_INIT)
> > -			free_buffer(vq, buf);
> > -	}
> > +	new_size = bytes_per_line * icd->user_height;
> > 
> > -	if (vb->baddr && vb->bsize < new_size) {
> > -		/* User provided buffer, but it is too small */
> > -		ret = -ENOMEM;
> > -		goto out;
> > +	if (vb2_plane_size(vb, 0) < new_size) {
> > +		dev_err(icd->dev.parent, "Buffer too small (%lu < %zu)\n",
> > +			vb2_plane_size(vb, 0), new_size);
> > +		return -ENOBUFS;
> >  	}
> > 
> > -	if (vb->state == VIDEOBUF_NEEDS_INIT) {
> > -		struct idmac_channel *ichan = mx3_cam->idmac_channel[0];
> > -		struct scatterlist *sg = &buf->sg;
> > -
> > -		/*
> > -		 * The total size of video-buffers that will be allocated / mapped.
> > -		 * *size that we calculated in videobuf_setup gets assigned to
> > -		 * vb->bsize, and now we use the same calculation to get vb->size.
> > -		 */
> > -		vb->size = new_size;
> > -
> > -		/* This actually (allocates and) maps buffers */
> > -		ret = videobuf_iolock(vq, vb, NULL);
> > -		if (ret)
> > -			goto fail;
> > -
> > -		/*
> > -		 * We will have to configure the IDMAC channel. It has two slots
> > -		 * for DMA buffers, we shall enter the first two buffers there,
> > -		 * and then submit new buffers in DMA-ready interrupts
> > -		 */
> > -		sg_init_table(sg, 1);
> > -		sg_dma_address(sg)	= videobuf_to_dma_contig(vb);
> > -		sg_dma_len(sg)		= vb->size;
> > +	if (buf->state == CSI_BUF_NEEDS_INIT) {
> > +		sg_dma_address(sg)	= (dma_addr_t)icd->vb2_vidq.mem_ops->cookie(
> > +			vb->planes[0].mem_priv);
> 
> You should use vb2_dma_contig_plane_paddr() function from include/media/videobuf2-dma-contig.h
> instead of hacking with cookie directly:
> 	sg_dma_address(sg) = vb2_dma_contig_plane_paddr(vb, 0);
> 
> Everything else look fine!
> 
> > [snip]
> 
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
