Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50481 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaLRRlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Dec 2014 12:41:00 -0500
Received: by mail-lb0-f177.google.com with SMTP id b6so1338633lbj.22
        for <linux-media@vger.kernel.org>; Thu, 18 Dec 2014 09:40:59 -0800 (PST)
Message-ID: <549311A9.8050909@cogentembedded.com>
Date: Thu, 18 Dec 2014 20:40:57 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Ben Hutchings <ben.hutchings@codethink.co.uk>,
	linux-media@vger.kernel.org
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-kernel@codethink.co.uk,
	William Towle <william.towle@codethink.co.uk>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 3/5] media: rcar_vin: Fix race condition terminating
 stream
References: <1418914070.22813.13.camel@xylophone.i.decadent.org.uk> <1418914186.22813.16.camel@xylophone.i.decadent.org.uk>
In-Reply-To: <1418914186.22813.16.camel@xylophone.i.decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 12/18/2014 05:49 PM, Ben Hutchings wrote:

> From: Ian Molton <ian.molton@codethink.co.uk>

> This patch fixes a race condition whereby a frame being captured may generate an
>   interrupt between requesting capture to halt and freeing buffers.

    No need for the leading space.

> This condition is exposed by the earlier patch that explicitly calls
> vb2_buffer_done() during stop streaming.

    Hm, perhaps for the sake of bisection, these 2 patches need to be merged?

> The solution is to wait for capture to finish prior to finalising these buffers.

> Signed-off-by: Ian Molton <ian.molton@codethink.co.uk>
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> ---
>   drivers/media/platform/soc_camera/rcar_vin.c |   43 +++++++++++++++++---------
>   1 file changed, 28 insertions(+), 15 deletions(-)

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 7069176..b234e57 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
[...]
> @@ -465,7 +488,6 @@ static void rcar_vin_videobuf_release(struct vb2_buffer *vb)
>   	struct rcar_vin_priv *priv = ici->priv;
>   	unsigned int i;
>   	int buf_in_use = 0;
> -

    Unrelated white space change. Moreover, there should be an empty line 
after declarations.

>   	spin_lock_irq(&priv->lock);
>
>   	/* Is the buffer in use by the VIN hardware? */
[...]
> @@ -520,12 +530,15 @@ static void rcar_vin_stop_streaming(struct vb2_queue *vq)
>
>   	spin_lock_irq(&priv->lock);
>
> +	rcar_vin_wait_stop_streaming(priv);
> +
>   	for (i = 0; i < vq->num_buffers; ++i)
>   		if (vq->bufs[i]->state == VB2_BUF_STATE_ACTIVE)
>   			vb2_buffer_done(vq->bufs[i], VB2_BUF_STATE_ERROR);
>
>   	list_for_each_safe(buf_head, tmp, &priv->capture)
>   		list_del_init(buf_head);
> +

    Also seems like unrelated whitespace cleanup.

>   	spin_unlock_irq(&priv->lock);
>   }

WBR, Sergei

