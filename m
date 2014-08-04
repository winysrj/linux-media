Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2916 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbaHDV14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 17:27:56 -0400
Message-ID: <53DFFABC.9000800@xs4all.nl>
Date: Mon, 04 Aug 2014 23:27:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ian Molton <ian.molton@codethink.co.uk>,
	linux-media@vger.kernel.org
CC: linux-kernel@lists.codethink.co.uk, g.liakhovetski@gmx.de,
	m.chehab@samsung.com, vladimir.barinov@cogentembedded.com,
	magnus.damm@gmail.com, horms@verge.net.au, linux-sh@vger.kernel.org
Subject: Re: [PATCH 3/4] media: rcar_vin: Fix race condition terminating stream
References: <1404812474-7627-1-git-send-email-ian.molton@codethink.co.uk> <1404812474-7627-4-git-send-email-ian.molton@codethink.co.uk>
In-Reply-To: <1404812474-7627-4-git-send-email-ian.molton@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/08/2014 11:41 AM, Ian Molton wrote:
> This patch fixes a race condition whereby a frame being captured may generate an
>  interrupt between requesting capture to halt and freeing buffers.
> 
> This condition is exposed by the earlier patch that explicitly calls
> vb2_buffer_done() during stop streaming.
> 
> The solution is to wait for capture to finish prior to finalising these buffers.
> 
> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c | 43 ++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 06ce705..aeda4e2 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -455,6 +455,29 @@ error:
>  	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>  }
>  
> +/*
> + * Wait for capture to stop and all in-flight buffers to be finished with by
> + * the video hardware. This must be called under &priv->lock
> + *
> + */
> +static void rcar_vin_wait_stop_streaming(struct rcar_vin_priv *priv)
> +{
> +	while (priv->state != STOPPED) {
> +
> +		/* issue stop if running */
> +		if (priv->state == RUNNING)
> +			rcar_vin_request_capture_stop(priv);
> +
> +		/* wait until capturing has been stopped */
> +		if (priv->state == STOPPING) {
> +			priv->request_to_stop = true;
> +			spin_unlock_irq(&priv->lock);
> +			wait_for_completion(&priv->capture_stop);
> +			spin_lock_irq(&priv->lock);
> +		}
> +	}
> +}
> +
>  static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>  {
>  	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
> @@ -462,7 +485,6 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>  	struct rcar_vin_priv *priv = ici->priv;
>  	unsigned int i;
>  	int buf_in_use = 0;
> -
>  	spin_lock_irq(&priv->lock);
>  
>  	/* Is the buffer in use by the VIN hardware? */
> @@ -474,20 +496,8 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>  	}
>  
>  	if (buf_in_use) {
> -		while (priv->state != STOPPED) {
> -
> -			/* issue stop if running */
> -			if (priv->state == RUNNING)
> -				rcar_vin_request_capture_stop(priv);
> -
> -			/* wait until capturing has been stopped */
> -			if (priv->state == STOPPING) {
> -				priv->request_to_stop = true;
> -				spin_unlock_irq(&priv->lock);
> -				wait_for_completion(&priv->capture_stop);
> -				spin_lock_irq(&priv->lock);
> -			}
> -		}
> +		rcar_vin_wait_stop_streaming(priv);
> +

Why on earth would videobuf_release call stop_streaming()?

You start streaming in the start_streaming op, not in the buf_queue op. If you
need a certain minimum of buffers before start_streaming can be called, then just
set min_buffers_needed in struct vb2_queue.

And stop streaming happens in stop_streaming. The various vb2 queue ops should just
do what the op name says. That way everything works nicely together and it makes
your driver much easier to understand.

Sorry I am late in reviewing this, but I only now stumbled on these patches.

Regards,

	Hans

>  		/*
>  		 * Capturing has now stopped. The buffer we have been asked
>  		 * to release could be any of the current buffers in use, so
> @@ -517,12 +527,15 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>  
>  	spin_lock_irq(&priv->lock);
>  
> +	rcar_vin_wait_stop_streaming(priv);
> +
>  	for (i = 0; i < vq->num_buffers; ++i)
>  		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
>  			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
>  
>  	list_for_each_safe(buf_head, tmp, &priv->capture)
>  		list_del_init(buf_head);
> +
>  	spin_unlock_irq(&priv->lock);
>  }
>  
> 



