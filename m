Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:50283 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab2AYKQD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 05:16:03 -0500
Date: Wed, 25 Jan 2012 11:16:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, baruch@tkos.co.il
Subject: Re: [PATCH 1/4] media i.MX27 camera: migrate driver to videobuf2
In-Reply-To: <Pine.LNX.4.64.1201241819240.27814@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201251113130.18778@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
 <1327059392-29240-2-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1201241819240.27814@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 25 Jan 2012, Guennadi Liakhovetski wrote:

> This patch seems incomplete to me? On the one hand you're saying, you only 
> work with i.MX27, but you've left
> 
> static void mx27_camera_frame_done(struct mx2_camera_dev *pcdev, int state)
> {
> 	struct videobuf_buffer *vb;
> 
> TBH, I don't understand how you've tested this patch: it doesn't compile 
> for me for i.MX27. And to use EMMA CONFIG_MACH_MX27 has to be on too, 
> right? Confused...

Ok, got it, I missed Sascha's patch, removing legacy i.MX27 DMA support. 
Will schedule it for the next window.

Thanks
Guennadi

> 
> On Fri, 20 Jan 2012, Javier Martin wrote:
> 
> > 
> > Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> > ---
> >  drivers/media/video/mx2_camera.c |  277 ++++++++++++++++++--------------------
> >  1 files changed, 128 insertions(+), 149 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > index 68038e7..290ac9d 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> 
> [snip]
> 
> > @@ -256,13 +257,25 @@ struct mx2_camera_dev {
> >  	size_t			discard_size;
> >  	struct mx2_fmt_cfg	*emma_prp;
> >  	u32			frame_count;
> > +	struct vb2_alloc_ctx	*alloc_ctx;
> > +};
> > +
> > +enum mx2_buffer_state {
> > +	MX2_STATE_NEEDS_INIT = 0,
> > +	MX2_STATE_PREPARED   = 1,
> > +	MX2_STATE_QUEUED     = 2,
> > +	MX2_STATE_ACTIVE     = 3,
> > +	MX2_STATE_DONE       = 4,
> > +	MX2_STATE_ERROR      = 5,
> > +	MX2_STATE_IDLE       = 6,
> 
> Are the numerical values important? If not - please, drop. And actually, 
> you don't need most of these states, I wouldn't be surprised, if you 
> didn't need them at all. You might want to revise them in a future patch.
> 
> [snip]
> 
> > @@ -467,59 +479,47 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
> >  /*
> >   *  Videobuf operations
> >   */
> > -static int mx2_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
> > -			      unsigned int *size)
> > +static int mx2_videobuf_setup(struct vb2_queue *vq,
> > +			const struct v4l2_format *fmt,
> > +			unsigned int *count, unsigned int *num_planes,
> > +			unsigned int sizes[], void *alloc_ctxs[])
> >  {
> > -	struct soc_camera_device *icd = vq->priv_data;
> > +	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> > +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> > +	struct mx2_camera_dev *pcdev = ici->priv;
> >  	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> >  			icd->current_fmt->host_fmt);
> 
> You choose not to support VIDIOC_CREATE_BUFS? You have to at least return 
> an error if fmt != NULL. Or consider supporting it - look at mx3_camera.c 
> or sh_mobile_ceu_camera.c (btw, atmel-isi.c has to be fixed with this 
> respect too). If you decide to support it, you'll also have to drop 
> .buf_prepare() (see, e.g., 07f92448045a23d27dbc3ece3abcb6bafc618d43)
> 
> [snip]
> 
> > @@ -529,46 +529,34 @@ static int mx2_videobuf_prepare(struct videobuf_queue *vq,
> >  	 * This can be useful if you want to see if we actually fill
> >  	 * the buffer with something
> >  	 */
> > -	memset((void *)vb->baddr, 0xaa, vb->bsize);
> > +	memset((void *)vb2_plane_vaddr(vb, 0),
> > +	       0xaa, vb2_get_plane_payload(vb, 0));
> >  #endif
> >  
> > -	if (buf->code	!= icd->current_fmt->code ||
> > -	    vb->width	!= icd->user_width ||
> > -	    vb->height	!= icd->user_height ||
> > -	    vb->field	!= field) {
> > +	if (buf->code	!= icd->current_fmt->code) {
> >  		buf->code	= icd->current_fmt->code;
> > -		vb->width	= icd->user_width;
> > -		vb->height	= icd->user_height;
> > -		vb->field	= field;
> > -		vb->state	= VIDEOBUF_NEEDS_INIT;
> > +		buf->state	= MX2_STATE_NEEDS_INIT;
> 
> This looks broken or most likely redundant to me. The check for a changed 
> code was there to reallocate the buffer, doesn't seem to make much sense 
> now.
> 
> [snip]
> 
> > @@ -686,10 +673,10 @@ static void mx2_videobuf_release(struct videobuf_queue *vq,
> >  	 * types.
> >  	 */
> >  	spin_lock_irqsave(&pcdev->lock, flags);
> > -	if (vb->state == VIDEOBUF_QUEUED) {
> > -		list_del(&vb->queue);
> > -		vb->state = VIDEOBUF_ERROR;
> > -	} else if (cpu_is_mx25() && vb->state == VIDEOBUF_ACTIVE) {
> > +	if (buf->state == MX2_STATE_QUEUED || buf->state == MX2_STATE_ACTIVE) {
> > +		list_del_init(&buf->queue);
> > +		buf->state = MX2_STATE_NEEDS_INIT;
> > +	} else if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
> 
> This doesn't look right. You already have " || buf->state == 
> MX2_STATE_ACTIVE" above, so, this latter condition is never entered?
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
