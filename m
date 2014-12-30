Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43621 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751683AbaL3NOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 08:14:44 -0500
Date: Tue, 30 Dec 2014 15:14:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 2/5] media: rcar_vin: Ensure all in-flight buffers
 are returned to error state before stopping.
Message-ID: <20141230131440.GM17565@valkosipuli.retiisi.org.uk>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
 <1418914173.22813.15.camel@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418914173.22813.15.camel@xylophone.i.decadent.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

On Thu, Dec 18, 2014 at 02:49:33PM +0000, Ben Hutchings wrote:
> From: Ian Molton <ian.molton@codethink.co.uk>
> 
> Videobuf2 complains about buffers that are still marked ACTIVE (in use by the driver) following a call to stop_streaming().
> 
> This patch returns all active buffers to state ERROR prior to stopping.
> 
> Note: this introduces a (non fatal) race condition as the stream is not guaranteed to be stopped at this point.
> 
> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 773de53..7069176 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -516,8 +516,14 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct rcar_vin_priv *priv = ici->priv;
>  	struct list_head *buf_head, *tmp;
> +	int i;
>  
>  	spin_lock_irq(&priv->lock);
> +
> +	for (i = 0; i < vq->num_buffers; ++i)
> +		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> +			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
> +
>  	list_for_each_safe(buf_head, tmp, &priv->capture)
>  		list_del_init(buf_head);
>  	spin_unlock_irq(&priv->lock);

I'd use the driver's own queued buffer list to access the queued buffers,
you alread loop over that just below your own change.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
