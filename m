Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54297 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbbARVX2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2015 16:23:28 -0500
Date: Sun, 18 Jan 2015 22:23:13 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 5/5] media: rcar_vin: move buffer management to
 .stop_streaming handler
In-Reply-To: <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>
Message-ID: <Pine.LNX.4.64.1501182141400.23540@axis700.grange>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
 <1418914215.22813.18.camel@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Dec 2014, Ben Hutchings wrote:

> From: William Towle <william.towle@codethink.co.uk>
> 
> Move the buffer state test in the .buf_cleanup handler into
> .stop_streaming so that a) the vb2_queue API is not subverted, and
> b) tracking of active-state buffers via priv->queue_buf[] is handled
> as early as is possible

Huh... Sorry, patches 1, 2, 3, and 5 of this series look like a strange 
way to get from the present state to the destination. They all have to be 
merged IMHO. 

Further, looking at vb2, I don't think active buffers should ever stay 
active until .buf_cleanup() is called. I think rcar_vin's 
.stop_streaming() should stop the hardware, wait until it's stopped, then 
walk all queued buffers and return errors for them, while removing them 
from the list at the same time. Then I don't think a .buf_cleanup() method 
is needed there at all.

Thanks
Guennadi

> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   36 ++++++++++----------------
>  1 file changed, 14 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 20dbedf..bf60074 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -486,28 +486,8 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>  	struct soc_camera_device *icd = soc_camera_from_vb2q(vb->vb2_queue);
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct rcar_vin_priv *priv = ici->priv;
> -	unsigned int i;
> -	int buf_in_use = 0;
> -	spin_lock_irq(&priv->lock);
> -
> -	/* Is the buffer in use by the VIN hardware? */
> -	for (i = 0; i < MAX_BUFFER_NUM; i++) {
> -		if (priv->queue_buf[i] == vb) {
> -			buf_in_use = 1;
> -			break;
> -		}
> -	}
>  
> -	if (buf_in_use) {
> -		rcar_vin_wait_stop_streaming(priv);
> -
> -		/*
> -		 * Capturing has now stopped. The buffer we have been asked
> -		 * to release could be any of the current buffers in use, so
> -		 * release all buffers that are in use by HW
> -		 */
> -		priv->queue_buf[i] = NULL;
> -	}
> +	spin_lock_irq(&priv->lock);
>  
>  	list_del_init(to_buf_list(vb));
>  
> @@ -533,8 +513,20 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>  	rcar_vin_wait_stop_streaming(priv);
>  
>  	for (i = 0; i < vq->num_buffers; ++i)
> -		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
> +		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE) {
> +			int j;
> +
> +			/*  Is this a buffer we have told the
> +			 *  hardware about? Update the associated
> +			 *  list, if so
> +			 */
> +			for (j = 0; j < MAX_BUFFER_NUM; j++) {
> +				if (priv->queue_buf[j] == vq->bufs[i]) {
> +					priv->queue_buf[j] = NULL;
> +				}
> +			}
>  			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
> +		}
>  
>  	list_for_each_safe(buf_head, tmp, &priv->capture)
>  		list_del_init(buf_head);
> -- 
> 1.7.10.4
> 
> 
> 
