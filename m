Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:54667 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbbARUQK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Jan 2015 15:16:10 -0500
Date: Sun, 18 Jan 2015 21:16:04 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Hutchings <ben.hutchings@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 1/5] media: rcar_vin: Dont aggressively retire buffers
In-Reply-To: <1418914152.22813.14.camel@xylophone.i.decadent.org.uk>
Message-ID: <Pine.LNX.4.64.1501182114400.23540@axis700.grange>
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk>
 <1418914152.22813.14.camel@xylophone.i.decadent.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

Sorry for a long delay. The patch looks good to me, although I'll extend 
it a bit by also removing the comment above the deleted loop - it's no 
longer relevant.

Thanks
Guennadi

On Thu, 18 Dec 2014, Ben Hutchings wrote:

> From: Ian Molton <ian.molton@codethink.co.uk>
> 
> rcar_vin_videobuf_release() is called once per buffer from the buf_cleanup hook.
> 
> There is no need to look up the queue and free all buffers at this point.
> 
> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/rcar_vin.c |   12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 8d8438b..773de53 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -496,17 +496,11 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>  		 * to release could be any of the current buffers in use, so
>  		 * release all buffers that are in use by HW
>  		 */
> -		for (i = 0; i < MAX_BUFFER_NUM; i++) {
> -			if (priv->queue_buf[i]) {
> -				vb2_buffer_done(priv->queue_buf[i],
> -					VB2_BUF_STATE_ERROR);
> -				priv->queue_buf[i] = NULL;
> -			}
> -		}
> -	} else {
> -		list_del_init(to_buf_list(vb));
> +		priv->queue_buf[i] = NULL;
>  	}
>  
> +	list_del_init(to_buf_list(vb));
> +
>  	spin_unlock_irq(&priv->lock);
>  }
>  
> -- 
> 1.7.10.4
> 
> 
> 
> 
