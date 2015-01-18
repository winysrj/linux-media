Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:65139 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbbARUer (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2015 15:34:47 -0500
Date: Sun, 18 Jan 2015 21:34:41 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 3/5] media: rcar_vin: Fix race condition terminating
 stream
In-Reply-To: <549311A9.8050909@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1501182134110.23540@axis700.grange>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
 <1418914186.22813.16.camel@xylophone.i.decadent.org.uk>
 <549311A9.8050909@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Dec 2014, Sergei Shtylyov wrote:

> Hello.
> 
> On 12/18/2014 05:49 PM, Ben Hutchings wrote:
> 
> > From: Ian Molton <ian.molton@codethink.co.uk>
> 
> > This patch fixes a race condition whereby a frame being captured may
> > generate an
> >   interrupt between requesting capture to halt and freeing buffers.
> 
>    No need for the leading space.
> 
> > This condition is exposed by the earlier patch that explicitly calls
> > vb2_buffer_done() during stop streaming.
> 
>    Hm, perhaps for the sake of bisection, these 2 patches need to be merged?

+1. Please, don't introduce a bug in one patch to fix it in a later one.

Thanks
Guennadi

> 
> > The solution is to wait for capture to finish prior to finalising these
> > buffers.
> 
> > Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> > Signed-off-by: William Towle <william.towle@codethink.co.uk>
> > ---
> >   drivers/media/platform/soc_camera/rcar_vin.c |   43
> > +++++++++++++++++---------
> >   1 file changed, 28 insertions(+), 15 deletions(-)
> 
> > diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> > b/drivers/media/platform/soc_camera/rcar_vin.c
> > index 7069176..b234e57 100644
> > --- a/drivers/media/platform/soc_camera/rcar_vin.c
> > +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> [...]
> > @@ -465,7 +488,6 @@ static void rcar_vin_videobuf_release(struct vb2_buffer
> > *vb)
> >   	struct rcar_vin_priv *priv = ici->priv;
> >   	unsigned int i;
> >   	int buf_in_use = 0;
> > -
> 
>    Unrelated white space change. Moreover, there should be an empty line after
> declarations.
> 
> >   	spin_lock_irq(&priv->lock);
> > 
> >   	/* Is the buffer in use by the VIN hardware? */
> [...]
> > @@ -520,12 +530,15 @@ static void rcar_vin_stop_streaming(struct vb2_queue
> > *vq)
> > 
> >   	spin_lock_irq(&priv->lock);
> > 
> > +	rcar_vin_wait_stop_streaming(priv);
> > +
> >   	for (i = 0; i < vq->num_buffers; ++i)
> >   		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> >   			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
> > 
> >   	list_for_each_safe(buf_head, tmp, &priv->capture)
> >   		list_del_init(buf_head);
> > +
> 
>    Also seems like unrelated whitespace cleanup.
> 
> >   	spin_unlock_irq(&priv->lock);
> >   }
> 
> WBR, Sergei
> 
