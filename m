Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42899 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S933008Ab0HEUan (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Aug 2010 16:30:43 -0400
Date: Thu, 5 Aug 2010 22:30:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>,
	Teresa Gamez <T.Gamez@phytec.de>
Subject: Re: [PATCH 5/5] mx2_camera: add informative camera clock frequency
 printout
In-Reply-To: <1280828276-483-6-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008052228280.26127@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-6-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Aug 2010, Michael Grzeschik wrote:

> ported mx27_camera to 2.6.33.2

Sorry, do not understand what this description has to do with the contents 
- adding a printk to a driver? I don't think this is something critical 
enough to be handled urgently now for 2.6.36, right?

Thanks
Guennadi

> Signed-off-by: Teresa Gamez <T.Gamez@phytec.de>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mx2_camera.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 7f27492..fb1b1cb 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1360,6 +1360,9 @@ static int __devinit mx2_camera_probe(struct platform_device *pdev)
>  			goto exit_dma_free;
>  	}
>  
> +	dev_info(&pdev->dev, "Camera clock frequency: %ld\n",
> +			clk_get_rate(pcdev->clk_csi));
> +
>  	INIT_LIST_HEAD(&pcdev->capture);
>  	INIT_LIST_HEAD(&pcdev->active_bufs);
>  	spin_lock_init(&pcdev->lock);
> -- 
> 1.7.1
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
