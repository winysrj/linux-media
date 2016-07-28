Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59236 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbcG1UqX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2016 16:46:23 -0400
Date: Thu, 28 Jul 2016 15:46:16 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Peter Chen <peter.chen@nxp.com>
CC: <mchehab@kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] media: platform: ti-vpe: call of_node_put on
 non-null pointer
Message-ID: <20160728204616.GE1806@ti.com>
References: <1468575186-24961-1-git-send-email-peter.chen@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1468575186-24961-1-git-send-email-peter.chen@nxp.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Peter Chen <peter.chen@nxp.com> wrote on Fri [2016-Jul-15 17:33:06 +0800]:
> It should call of_node_put on non-null poiner.

Good catch, thanks.

Acked-by: Benoit Parrot <bparrot@ti.com>

> 
> Cc: linux-media@vger.kernel.org
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Peter Chen <peter.chen@nxp.com>
> ---
>  drivers/media/platform/ti-vpe/cal.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
> index 82001e6..00c3e97 100644
> --- a/drivers/media/platform/ti-vpe/cal.c
> +++ b/drivers/media/platform/ti-vpe/cal.c
> @@ -1761,13 +1761,13 @@ static int of_cal_create_instance(struct cal_ctx *ctx, int inst)
>  	}
>  
>  cleanup_exit:
> -	if (!remote_ep)
> +	if (remote_ep)
>  		of_node_put(remote_ep);
> -	if (!sensor_node)
> +	if (sensor_node)
>  		of_node_put(sensor_node);
> -	if (!ep_node)
> +	if (ep_node)
>  		of_node_put(ep_node);
> -	if (!port)
> +	if (port)
>  		of_node_put(port);
>  
>  	return ret;
> -- 
> 1.9.1
> 
