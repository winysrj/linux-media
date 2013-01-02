Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62922 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab3ABIQX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 03:16:23 -0500
Date: Wed, 2 Jan 2013 09:16:21 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jonathan Corbet <corbet@lwn.net>
cc: Albert Wang <twang13@marvell.com>, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH V3 09/15] [media] marvell-ccic: add get_mcam function
 for marvell-ccic driver
In-Reply-To: <20121216092440.110ecf5f@hpe.lwn.net>
Message-ID: <Pine.LNX.4.64.1301020914590.7829@axis700.grange>
References: <1355565484-15791-1-git-send-email-twang13@marvell.com>
 <1355565484-15791-10-git-send-email-twang13@marvell.com>
 <20121216092440.110ecf5f@hpe.lwn.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 16 Dec 2012, Jonathan Corbet wrote:

> On Sat, 15 Dec 2012 17:57:58 +0800
> Albert Wang <twang13@marvell.com> wrote:
> 
> > This patch adds get_mcam() inline function which is prepared for
> > adding soc_camera support in marvell-ccic driver
> 
> Time for a bikeshed moment: "get" generally is understood to mean
> incrementing a reference count in kernel code.  Can it have a name like
> vbq_to_mcam() instead?
> 
> Also:
> 
> > @@ -1073,14 +1073,17 @@ static int mcam_vb_queue_setup(struct vb2_queue *vq,
> >  static void mcam_vb_buf_queue(struct vb2_buffer *vb)
> >  {
> >  	struct mcam_vb_buffer *mvb = vb_to_mvb(vb);
> > -	struct mcam_camera *cam = vb2_get_drv_priv(vb->vb2_queue);
> > +	struct mcam_camera *cam = get_mcam(vb->vb2_queue);
> >  	struct v4l2_pix_format *fmt = &cam->pix_format;
> >  	unsigned long flags;
> >  	int start;
> >  	dma_addr_t dma_handle;
> > +	unsigned long size;
> >  	u32 pixel_count = fmt->width * fmt->height;
> >  
> >  	spin_lock_irqsave(&cam->dev_lock, flags);
> > +	size = vb2_plane_size(vb, 0);
> > +	vb2_set_plane_payload(vb, 0, size);
> >  	dma_handle = vb2_dma_contig_plane_dma_addr(vb, 0);
> >  	BUG_ON(!dma_handle);
> >  	start = (cam->state == S_BUFWAIT) && !list_empty(&cam->buffers);
> 
> There is an unrelated change here that belongs in a separate patch.

Right, agree.

Thanks
Guennadi

> > @@ -1138,9 +1141,12 @@ static void mcam_vb_wait_finish(struct vb2_queue *vq)
> >   */
> >  static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
> >  {
> > -	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> > +	struct mcam_camera *cam = get_mcam(vq);
> >  	unsigned int frame;
> >  
> > +	if (count < 2)
> > +		return -EINVAL;
> > +
> 
> Here too - unrelated change.
> 
> >  	if (cam->state != S_IDLE) {
> >  		INIT_LIST_HEAD(&cam->buffers);
> >  		return -EINVAL;
> > @@ -1170,7 +1176,7 @@ static int mcam_vb_start_streaming(struct vb2_queue *vq, unsigned int count)
> >  
> >  static int mcam_vb_stop_streaming(struct vb2_queue *vq)
> >  {
> > -	struct mcam_camera *cam = vb2_get_drv_priv(vq);
> > +	struct mcam_camera *cam = get_mcam(vq);
> >  	unsigned long flags;
> >  
> >  	if (cam->state == S_BUFWAIT) {
> > @@ -1181,6 +1187,7 @@ static int mcam_vb_stop_streaming(struct vb2_queue *vq)
> >  	if (cam->state != S_STREAMING)
> >  		return -EINVAL;
> >  	mcam_ctlr_stop_dma(cam);
> > +	cam->state = S_IDLE;
> 
> ...and also here ...
> 
> jon
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
