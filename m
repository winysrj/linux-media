Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:58604 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbbARUcR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2015 15:32:17 -0500
Date: Sun, 18 Jan 2015 21:32:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Ian Molton <ian.molton@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	m.chehab@samsung.com, vladimir.barinov@cogentembedded.com,
	magnus.damm@gmail.com, horms@verge.net.au, linux-sh@vger.kernel.org
Subject: Re: [PATCH 2/4] media: rcar_vin: Ensure all in-flight buffers are
 returned to error state before stopping.
In-Reply-To: <53DFF998.1020307@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1501182125390.23540@axis700.grange>
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
 <1404812474-7627-3-git-send-email-ian.molton@codethink.co.uk>
 <53DFF998.1020307@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ian,

Apparently, I wasn't quite right in my reply to patch 1 from this series. 
It seems to be related to this one and to Hans' comment below. Taking it 
into account, it seems you shouldn't remove cancelled active buffers from 
the list without calling vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR) 
for them. So, I think you should modify your patch 1 to either leave those 
buffers on the list and report them "done" here, or call "done" for them 
when removing from the list. I think I'd rather go with the latter option 
to not keep failed buffers on the list and rely, that the vb2 core will 
stop streaming soon. Hans, do you agree?

Thanks
Guennadi

On Mon, 4 Aug 2014, Hans Verkuil wrote:

> On 07/08/2014 11:41 AM, Ian Molton wrote:
> > Videobuf2 complains about buffers that are still marked ACTIVE (in use by the driver) following a call to stop_streaming().
> > 
> > This patch returns all active buffers to state ERROR prior to stopping.
> > 
> > Note: this introduces a (non fatal) race condition as the stream is not guaranteed to be stopped at this point.
> > 
> > Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> > Signed-off-by: William Towle <william.towle@codethink.co.uk>
> > ---
> >  drivers/media/platform/soc_camera/rcar_vin.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> > index 7154500..06ce705 100644
> > --- a/drivers/media/platform/soc_camera/rcar_vin.c
> > +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> > @@ -513,8 +513,14 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
> >  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> >  	struct rcar_vin_priv *priv = ici->priv;
> >  	struct list_head *buf_head, *tmp;
> > +	int i;
> >  
> >  	spin_lock_irq(&priv->lock);
> > +
> > +	for (i = 0; i < vq->num_buffers; ++i)
> > +		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> > +			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
> > +
> >  	list_for_each_safe(buf_head, tmp, &priv->capture)
> >  		list_del_init(buf_head);
> 
> I'm assuming all buffers that are queued to the driver via buf_queue() are
> linked into priv->capture. So you would typically call vb2_buffer_done
> when you are walking that list:
> 
>   	list_for_each_safe(buf_head, tmp, &priv->capture) {
> 		// usually you go from buf_head to the real buffer struct
> 		// containing a vb2_buffer struct
> 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>   		list_del_init(buf_head);
> 	}
> 
> Please use this rather than looking into internal vb2_queue datastructures.
> 
> Regards,
> 
> 	Hans
> 
> >  	spin_unlock_irq(&priv->lock);
> > 
> 
