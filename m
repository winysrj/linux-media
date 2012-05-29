Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42375 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2E2JVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 05:21:47 -0400
Date: Tue, 29 May 2012 11:21:42 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 08/15] video: mx2_emmaprp: Use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20120529092142.GK30400@pengutronix.de>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
 <1337987696-31728-8-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337987696-31728-8-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2012 at 08:14:49PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Prepare the clock before enabling it.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: <linux-media@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

> ---
>  drivers/media/video/mx2_emmaprp.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_emmaprp.c b/drivers/media/video/mx2_emmaprp.c
> index 0bd5815..b364557 100644
> --- a/drivers/media/video/mx2_emmaprp.c
> +++ b/drivers/media/video/mx2_emmaprp.c
> @@ -800,7 +800,7 @@ static int emmaprp_open(struct file *file)
>  		return ret;
>  	}
>  
> -	clk_enable(pcdev->clk_emma);
> +	clk_prepare_enable(pcdev->clk_emma);
>  	ctx->q_data[V4L2_M2M_SRC].fmt = &formats[1];
>  	ctx->q_data[V4L2_M2M_DST].fmt = &formats[0];
>  
> @@ -816,7 +816,7 @@ static int emmaprp_release(struct file *file)
>  
>  	dprintk(pcdev, "Releasing instance %p\n", ctx);
>  
> -	clk_disable(pcdev->clk_emma);
> +	clk_disable_unprepare(pcdev->clk_emma);
>  	v4l2_m2m_ctx_release(ctx->m2m_ctx);
>  	kfree(ctx);
>  
> -- 
> 1.7.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
