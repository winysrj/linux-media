Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45845 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2AZUSA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 15:18:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 1/8] soc_camera: Use soc_camera_device::sizeimage to compute buffer sizes
Date: Thu, 26 Jan 2012 21:18:08 +0100
Cc: linux-media@vger.kernel.org
References: <1327504351-24413-1-git-send-email-laurent.pinchart@ideasonboard.com> <1327504351-24413-2-git-send-email-laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1201252217450.18778@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1201252217450.18778@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201262118.09750.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Thursday 26 January 2012 16:21:00 Guennadi Liakhovetski wrote:
> Hi Laurent
> 
> Thanks for the patches. This one looks good mostly, a couple of questions
> though:
> 
> On Wed, 25 Jan 2012, Laurent Pinchart wrote:
> > Instead of computing the buffer size manually in the videobuf queue
> > setup and buffer prepare callbacks, use the previously negotiated
> > soc_camera_device::sizeimage value.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/atmel-isi.c            |   17 +++--------------
> >  drivers/media/video/mx1_camera.c           |   14 ++------------
> >  drivers/media/video/mx2_camera.c           |   14 ++------------
> >  drivers/media/video/mx3_camera.c           |   20 +++++++++-----------
> >  drivers/media/video/omap1_camera.c         |   14 ++------------
> >  drivers/media/video/pxa_camera.c           |   14 ++------------
> >  drivers/media/video/sh_mobile_ceu_camera.c |   25
> >  +++++++++---------------- 7 files changed, 29 insertions(+), 89
> >  deletions(-)
> 
> [snip]
> 
> > diff --git a/drivers/media/video/mx2_camera.c
> > b/drivers/media/video/mx2_camera.c index a803d9e..e9b228d 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> > @@ -433,15 +433,10 @@ static int mx2_videobuf_setup(struct videobuf_queue
> > *vq, unsigned int *count,
> > 
> >  			      unsigned int *size)
> >  
> >  {
> >  
> >  	struct soc_camera_device *icd = vq->priv_data;
> > 
> > -	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> > -			icd->current_fmt->host_fmt);
> > 
> >  	dev_dbg(icd->parent, "count=%d, size=%d\n", *count, *size);
> > 
> > -	if (bytes_per_line < 0)
> > -		return bytes_per_line;
> > -
> > -	*size = bytes_per_line * icd->user_height;
> > +	*size = icd->sizeimage;
> > 
> >  	if (0 == *count)
> >  	
> >  		*count = 32;
> 
> I think, there is a bug in mx2_camera_try_fmt(), which also would affect
> these your calculations. On i.MX25 they restrict the image size based on
> maximum supported number of bytes. In such a case they recalculate
> .bytesperline, but they fail to update .sizeimage. The fix seems to be
> trivial, please add it, then your calculations should be fine.

Indeed. I'll add a patch for that, and I'll also modify mx2_camera_try_fmt() 
to use the new soc_mbus_image_size() function.

> > @@ -476,16 +471,11 @@ static int mx2_videobuf_prepare(struct
> > videobuf_queue *vq,
> > 
> >  {
> >  
> >  	struct soc_camera_device *icd = vq->priv_data;
> >  	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
> > 
> > -	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> > -			icd->current_fmt->host_fmt);
> > 
> >  	int ret = 0;
> >  	
> >  	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> >  	
> >  		vb, vb->baddr, vb->bsize);
> > 
> > -	if (bytes_per_line < 0)
> > -		return bytes_per_line;
> > -
> > 
> >  #ifdef DEBUG
> >  
> >  	/*
> >  	
> >  	 * This can be useful if you want to see if we actually fill
> > 
> > @@ -505,7 +495,7 @@ static int mx2_videobuf_prepare(struct videobuf_queue
> > *vq,
> > 
> >  		vb->state	= VIDEOBUF_NEEDS_INIT;
> >  	
> >  	}
> > 
> > -	vb->size = bytes_per_line * vb->height;
> > +	vb->size = icd->sizeimage;
> > 
> >  	if (vb->baddr && vb->bsize < vb->size) {
> >  	
> >  		ret = -EINVAL;
> >  		goto out;
> > 
> > diff --git a/drivers/media/video/mx3_camera.c
> > b/drivers/media/video/mx3_camera.c index f96f92f..da45a89 100644
> > --- a/drivers/media/video/mx3_camera.c
> > +++ b/drivers/media/video/mx3_camera.c
> > @@ -199,8 +199,6 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
> > 
> >  	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> >  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> >  	struct mx3_camera_dev *mx3_cam = ici->priv;
> > 
> > -	int bytes_per_line;
> > -	unsigned int height;
> > 
> >  	if (!mx3_cam->idmac_channel[0])
> >  	
> >  		return -EINVAL;
> > 
> > @@ -208,21 +206,21 @@ static int mx3_videobuf_setup(struct vb2_queue *vq,
> > 
> >  	if (fmt) {
> >  	
> >  		const struct soc_camera_format_xlate *xlate =
> >  		soc_camera_xlate_by_fourcc(icd,
> >  		
> >  								fmt->fmt.pix.pixelformat);
> > 
> > +		int bytes_per_line;
> > +
> > 
> >  		if (!xlate)
> >  		
> >  			return -EINVAL;
> > 
> > +
> > 
> >  		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
> >  		
> >  							 xlate->host_fmt);
> > 
> > -		height = fmt->fmt.pix.height;
> > +		if (bytes_per_line < 0)
> > +			return bytes_per_line;
> > +
> > +		sizes[0] = bytes_per_line * fmt->fmt.pix.height;
> > 
> >  	} else {
> >  	
> >  		/* Called from VIDIOC_REQBUFS or in compatibility mode */
> > 
> > -		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> > -						icd->current_fmt->host_fmt);
> > -		height = icd->user_height;
> > +		sizes[0] = icd->sizeimage;
> > 
> >  	}
> > 
> > -	if (bytes_per_line < 0)
> > -		return bytes_per_line;
> > -
> > -	sizes[0] = bytes_per_line * height;
> > 
> >  	alloc_ctxs[0] = mx3_cam->alloc_ctx;
> > 
> > @@ -274,7 +272,7 @@ static void mx3_videobuf_queue(struct vb2_buffer *vb)
> > 
> >  	BUG_ON(bytes_per_line <= 0);
> > 
> > -	new_size = bytes_per_line * icd->user_height;
> > +	new_size = icd->sizeimage;
> 
> Don't you think, you could eliminate bytes_per_line too and just use
> icd->bytesperline here too?

Sure. That's why the next patch does just that :-)

> >  	if (vb2_plane_size(vb, 0) < new_size) {
> >  	
> >  		dev_err(icd->parent, "Buffer #%d too small (%lu < %zu)\n",
> 
> [snip]
> 
> > diff --git a/drivers/media/video/sh_mobile_ceu_camera.c
> > b/drivers/media/video/sh_mobile_ceu_camera.c index c51decf..f4eb9e1
> > 100644
> > --- a/drivers/media/video/sh_mobile_ceu_camera.c
> > +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> > @@ -206,27 +206,25 @@ static int sh_mobile_ceu_videobuf_setup(struct
> > vb2_queue *vq,
> > 
> >  	struct soc_camera_device *icd = container_of(vq, struct
> >  	soc_camera_device, vb2_vidq); struct soc_camera_host *ici =
> >  	to_soc_camera_host(icd->parent); struct sh_mobile_ceu_dev *pcdev =
> >  	ici->priv;
> > 
> > -	int bytes_per_line;
> > -	unsigned int height;
> > 
> >  	if (fmt) {
> >  	
> >  		const struct soc_camera_format_xlate *xlate =
> >  		soc_camera_xlate_by_fourcc(icd,
> >  		
> >  								fmt->fmt.pix.pixelformat);
> > 
> > +		int bytes_per_line;
> > +
> > 
> >  		if (!xlate)
> >  		
> >  			return -EINVAL;
> > 
> > +
> > 
> >  		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
> >  		
> >  							 xlate->host_fmt);
> > 
> > -		height = fmt->fmt.pix.height;
> > +		if (bytes_per_line < 0)
> > +			return bytes_per_line;
> > +
> > +		sizes[0] = bytes_per_line * fmt->fmt.pix.height;
> > 
> >  	} else {
> >  	
> >  		/* Called from VIDIOC_REQBUFS or in compatibility mode */
> > 
> > -		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> > -						icd->current_fmt->host_fmt);
> > -		height = icd->user_height;
> > +		sizes[0] = icd->sizeimage;
> > 
> >  	}
> > 
> > -	if (bytes_per_line < 0)
> > -		return bytes_per_line;
> > -
> > -	sizes[0] = bytes_per_line * height;
> > 
> >  	alloc_ctxs[0] = pcdev->alloc_ctx;
> > 
> > @@ -373,13 +371,8 @@ static void sh_mobile_ceu_videobuf_queue(struct
> > vb2_buffer *vb)
> > 
> >  	struct sh_mobile_ceu_dev *pcdev = ici->priv;
> >  	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
> >  	unsigned long size;
> > 
> > -	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> > -						icd->current_fmt->host_fmt);
> > -
> > -	if (bytes_per_line < 0)
> > -		goto error;
> > 
> > -	size = icd->user_height * bytes_per_line;
> > +	size = icd->sizeimage;
> > 
> >  	if (vb2_plane_size(vb, 0) < size) {
> >  	
> >  		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
> 
> Looks like sh_mobile_ceu_set_rect() can also be simplified, since there
> bytes_per_line is calculated for data-fetch mode, for which the
> ->bytesperline can also be used?

Is sh_mobile_ceu_set_rect() guaranteed to be called after try_fmt(), with the 
->bytesperline value set to the correct value for the current format ?

-- 
Regards,

Laurent Pinchart
