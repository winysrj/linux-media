Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:52703 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392AbbEGGdG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 7 May 2015 02:33:06 -0400
Message-ID: <554B0713.6060003@xs4all.nl>
Date: Thu, 07 May 2015 08:32:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Subject: Re: [PATCH] rcar-vin: use monotonic timestamps
References: <554B058D.2040001@xs4all.nl>
In-Reply-To: <554B058D.2040001@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/2015 08:26 AM, Hans Verkuil wrote:
> Even though the rcar-vin driver tells userspace that it will give a monotonic
> timestamp, it is actually using gettimeofday. Replace this with a proper
> monotonic timestamp.

It was clearly too early in the day for me, but here is my Signed-off-by:

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 35deed8..b64dfea 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -894,7 +894,7 @@ static irqreturn_t rcar_vin_irq(int irq, void *data)
>  
>  		priv->queue_buf[slot]->v4l2_buf.field = priv->field;
>  		priv->queue_buf[slot]->v4l2_buf.sequence = priv->sequence++;
> -		do_gettimeofday(&priv->queue_buf[slot]->v4l2_buf.timestamp);
> +		v4l2_get_timestamp(&priv->queue_buf[slot]->v4l2_buf.timestamp);
>  		vb2_buffer_done(priv->queue_buf[slot], VB2_BUF_STATE_DONE);
>  		priv->queue_buf[slot] = NULL;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

