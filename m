Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:41848 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750906AbaGJKPe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 06:15:34 -0400
Date: Thu, 10 Jul 2014 11:15:23 +0100
From: Ian Molton <ian.molton@codethink.co.uk>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	g.liakhovetski@gmx.de, m.chehab@samsung.com,
	vladimir.barinov@cogentembedded.com, magnus.damm@gmail.com,
	horms@verge.net.au, linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/4] media: rcar_vin: Fix race condition terminating
 stream
Message-Id: <20140710111523.17ae9078e53001c18bdf6eac@codethink.co.uk>
In-Reply-To: <53BC17D6.2070607@cogentembedded.com>
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
	<1404812474-7627-4-git-send-email-ian.molton@codethink.co.uk>
	<53BC17D6.2070607@cogentembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 08 Jul 2014 20:09:58 +0400
Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:

> Hello.

Hi,

> > Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> > Signed-off-by: William Towle <william.towle@codethink.co.uk>
> > ---
> >   drivers/media/platform/soc_camera/rcar_vin.c | 43 ++++++++++++++++++----------
> >   1 file changed, 28 insertions(+), 15 deletions(-)
> 
> > diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> > index 06ce705..aeda4e2 100644
> > --- a/drivers/media/platform/soc_camera/rcar_vin.c
> > +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> [...]
> > @@ -462,7 +485,6 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
> >   	struct rcar_vin_priv *priv = ici->priv;
> >   	unsigned int i;
> >   	int buf_in_use = 0;
> > -
> >   	spin_lock_irq(&priv->lock);
> 
>     This seems like a random whitespace change. This empty should be present.

Agreed.

> [...]
> > @@ -517,12 +527,15 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
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
>     Also quite a random "drove-by" change.

Agreed.

Any further comments? If not, I can re-spin this ready for upstreaming.


-- 
Ian Molton <ian.molton@codethink.co.uk>
