Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:46955 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaGIIQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jul 2014 04:16:43 -0400
Date: Wed, 9 Jul 2014 10:16:37 +0200
From: Simon Horman <horms@verge.net.au>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Ian Molton <ian.molton@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	g.liakhovetski@gmx.de, m.chehab@samsung.com,
	vladimir.barinov@cogentembedded.com, magnus.damm@gmail.com,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/4] media: rcar_vin: Fix race condition terminating
 stream
Message-ID: <20140709081637.GE5656@verge.net.au>
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk>
 <1404812474-7627-4-git-send-email-ian.molton@codethink.co.uk>
 <53BC17D6.2070607@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BC17D6.2070607@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 08, 2014 at 08:09:58PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 07/08/2014 01:41 PM, Ian Molton wrote:
> 
> >This patch fixes a race condition whereby a frame being captured may generate an
> >  interrupt between requesting capture to halt and freeing buffers.
> 
> >This condition is exposed by the earlier patch that explicitly calls
> >vb2_buffer_done() during stop streaming.
> 
> >The solution is to wait for capture to finish prior to finalising these buffers.
> 
>    Hm, my spell checker trips on "finalising"...

I believe it is a valid spelling of the word in question.

> 
> >Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> >Signed-off-by: William Towle <william.towle@codethink.co.uk>
> >---
> >  drivers/media/platform/soc_camera/rcar_vin.c | 43 ++++++++++++++++++----------
> >  1 file changed, 28 insertions(+), 15 deletions(-)
> 
> >diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> >index 06ce705..aeda4e2 100644
> >--- a/drivers/media/platform/soc_camera/rcar_vin.c
> >+++ b/drivers/media/platform/soc_camera/rcar_vin.c
> [...]
> >@@ -462,7 +485,6 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
> >  	struct rcar_vin_priv *priv = ici->priv;
> >  	unsigned int i;
> >  	int buf_in_use = 0;
> >-
> >  	spin_lock_irq(&priv->lock);
> 
>    This seems like a random whitespace change. This empty should be present.
> 
> [...]
> >@@ -517,12 +527,15 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
> >
> >  	spin_lock_irq(&priv->lock);
> >
> >+	rcar_vin_wait_stop_streaming(priv);
> >+
> >  	for (i = 0; i < vq->num_buffers; ++i)
> >  		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> >  			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
> >
> >  	list_for_each_safe(buf_head, tmp, &priv->capture)
> >  		list_del_init(buf_head);
> >+
> 
>    Also quite a random "drove-by" change.
> 
> >  	spin_unlock_irq(&priv->lock);
> >  }
> 
> WBR, Sergei
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
