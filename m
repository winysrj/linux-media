Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42355 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2E2JUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 05:20:52 -0400
Date: Tue, 29 May 2012 11:20:30 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, shawn.guo@freescale.com,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 06/15] video: mx1_camera: Use
 clk_prepare_enable/clk_disable_unprepare
Message-ID: <20120529092030.GI30400@pengutronix.de>
References: <1337987696-31728-1-git-send-email-festevam@gmail.com>
 <1337987696-31728-6-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337987696-31728-6-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 25, 2012 at 08:14:47PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Prepare the clock before enabling it.
> 
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: <linux-media@vger.kernel.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


> ---
>  drivers/media/video/mx1_camera.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
> index 4296a83..dc58084 100644
> --- a/drivers/media/video/mx1_camera.c
> +++ b/drivers/media/video/mx1_camera.c
> @@ -402,7 +402,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
>  
>  	dev_dbg(pcdev->icd->parent, "Activate device\n");
>  
> -	clk_enable(pcdev->clk);
> +	clk_prepare_enable(pcdev->clk);
>  
>  	/* enable CSI before doing anything else */
>  	__raw_writel(csicr1, pcdev->base + CSICR1);
> @@ -421,7 +421,7 @@ static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
>  	/* Disable all CSI interface */
>  	__raw_writel(0x00, pcdev->base + CSICR1);
>  
> -	clk_disable(pcdev->clk);
> +	clk_disable_unprepare(pcdev->clk);
>  }
>  
>  /*
> -- 
> 1.7.1
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
