Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:61403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2AVS72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Jan 2012 13:59:28 -0500
Date: Sun, 22 Jan 2012 19:59:22 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Subject: Re: [PATCH v2] media i.MX27 camera: properly detect frame loss.
In-Reply-To: <Pine.LNX.4.64.1201211827381.16722@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201221939340.1075@axis700.grange>
References: <1326297664-19089-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1201211827381.16722@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A small addendum

On Sun, 22 Jan 2012, Guennadi Liakhovetski wrote:

> Hi Javier
> 
> Please, excuse my curiosity and bear with my lack of understanding :-)
> 
> On Wed, 11 Jan 2012, Javier Martin wrote:
> 
> > As V4L2 specification states, frame_count must also
> > regard lost frames so that the user can handle that
> > case properly.
> > 
> > This patch adds a mechanism to increment the frame
> > counter even when a video buffer is not available
> > and a discard buffer is used.
> > 
> > ---
> > Changes since v1:
> >  - Initialize "frame_count" to -1 instead of using
> >    "firstirq" variable.
> > 
> > Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> > ---
> >  drivers/media/video/mx2_camera.c |   45 ++++++++++++++++++++-----------------
> >  1 files changed, 24 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> > index ca76dd2..68038e7 100644
> > --- a/drivers/media/video/mx2_camera.c
> > +++ b/drivers/media/video/mx2_camera.c
> > @@ -369,7 +369,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
> >  	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
> >  
> >  	pcdev->icd = icd;
> > -	pcdev->frame_count = 0;
> > +	pcdev->frame_count = -1;
> 
> I'm adding a comment above this line:
> 
> +	/* Discard the first frame, begin valid frames with 0 */
> 
> >  
> >  	dev_info(icd->parent, "Camera driver attached to camera %d\n",
> >  		 icd->devnum);
> > @@ -572,6 +572,7 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
> >  	struct soc_camera_host *ici =
> >  		to_soc_camera_host(icd->parent);
> >  	struct mx2_camera_dev *pcdev = ici->priv;
> > +	struct mx2_fmt_cfg *prp = pcdev->emma_prp;
> >  	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
> >  	unsigned long flags;
> >  
> > @@ -584,6 +585,26 @@ static void mx2_videobuf_queue(struct videobuf_queue *vq,
> >  	list_add_tail(&vb->queue, &pcdev->capture);
> >  
> >  	if (mx27_camera_emma(pcdev)) {
> > +		if (prp->cfg.channel == 1) {
> > +			writel(PRP_CNTL_CH1EN |
> > +				PRP_CNTL_CSIEN |
> > +				prp->cfg.in_fmt |
> > +				prp->cfg.out_fmt |
> > +				PRP_CNTL_CH1_LEN |
> > +				PRP_CNTL_CH1BYP |
> > +				PRP_CNTL_CH1_TSKIP(0) |
> > +				PRP_CNTL_IN_TSKIP(0),
> > +				pcdev->base_emma + PRP_CNTL);
> > +		} else {
> > +			writel(PRP_CNTL_CH2EN |
> > +				PRP_CNTL_CSIEN |
> > +				prp->cfg.in_fmt |
> > +				prp->cfg.out_fmt |
> > +				PRP_CNTL_CH2_LEN |
> > +				PRP_CNTL_CH2_TSKIP(0) |
> > +				PRP_CNTL_IN_TSKIP(0),
> > +				pcdev->base_emma + PRP_CNTL);
> > +		}
> 
> Enabling the channel on each QBUF didn't seem like a good idea to me, so,
> I looked a bit further. If you really want to be extremely careful to only
> capture frames, when so requested by the user, don't you have to disable
> channels upom STREAMOFF, i.e., when the last buffer is released by
> .buf_release()? I don't think it makes sense to keep counting buffers, 
> when not streaming - they are not really lost. So, wouldn't something like 
> this not be better:
> 
>  	if (mx27_camera_emma(pcdev)) {
> +		if (pcdev->frame_count < 0)
> +			mx27_camera_emma_channel_enable(prp);
> 
> and then disable in .buf_release() if your queue is empty?

The condition "pcdev->frame_count < 0" is not going to work for you here. 
You have to enable on the first .buf_queue() after each STREAMON. You 
probably will need a new flag for this in your struct mx2_camera_dev.

Thanks
Guennadi

> 
> >  		goto out;
> 
> I think, this goto shall die, and with it the label too.

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
