Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:41064 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756924Ab0HCSVz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Aug 2010 14:21:55 -0400
Date: Tue, 3 Aug 2010 20:22:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Michael Grzeschik <m.grzeschik@pengutronix.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	baruch@tkos.co.il, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] mx2_camera: change to register and probe
In-Reply-To: <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1008032016340.10845@axis700.grange>
References: <1280828276-483-1-git-send-email-m.grzeschik@pengutronix.de>
 <1280828276-483-2-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 3 Aug 2010, Michael Grzeschik wrote:

> change this driver back to register and probe, since some platforms
> first have to initialize an already registered power regulator to switch
> on the camera.

Sorry, don't see a difference. Can you give an example of two call 
sequences, where this change changes the behaviour?

Thanks
Guennadi

> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> ---
>  drivers/media/video/mx2_camera.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 98c93fa..c77a673 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -1491,13 +1491,15 @@ static struct platform_driver mx2_camera_driver = {
>  	.driver 	= {
>  		.name	= MX2_CAM_DRV_NAME,
>  	},
> +
> +	.probe          = mx2_camera_probe,
>  	.remove		= __devexit_p(mx2_camera_remove),
>  };
>  
>  
>  static int __init mx2_camera_init(void)
>  {
> -	return platform_driver_probe(&mx2_camera_driver, &mx2_camera_probe);
> +	return platform_driver_register(&mx2_camera_driver);
>  }
>  
>  static void __exit mx2_camera_exit(void)
> -- 
> 1.7.1
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
