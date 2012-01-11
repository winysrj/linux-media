Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:53553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab2AKI27 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jan 2012 03:28:59 -0500
Date: Wed, 11 Jan 2012 09:28:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] drivers: video: mx3_camera: Convert mx3_camera to use
 module_platform_driver()
In-Reply-To: <1326250708-17643-1-git-send-email-festevam@gmail.com>
Message-ID: <Pine.LNX.4.64.1201110928280.1191@axis700.grange>
References: <1326250708-17643-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 11 Jan 2012, Fabio Estevam wrote:

> Using module_platform_driver makes the code smaller and simpler.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Isn't this covered by this:

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/43200

Thanks
Guennadi

> ---
>  drivers/media/video/mx3_camera.c |   14 +-------------
>  1 files changed, 1 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index f44323f..7452277 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -1286,19 +1286,7 @@ static struct platform_driver mx3_camera_driver = {
>  	.remove		= __devexit_p(mx3_camera_remove),
>  };
>  
> -
> -static int __init mx3_camera_init(void)
> -{
> -	return platform_driver_register(&mx3_camera_driver);
> -}
> -
> -static void __exit mx3_camera_exit(void)
> -{
> -	platform_driver_unregister(&mx3_camera_driver);
> -}
> -
> -module_init(mx3_camera_init);
> -module_exit(mx3_camera_exit);
> +module_platform_driver(mx3_camera_driver);
>  
>  MODULE_DESCRIPTION("i.MX3x SoC Camera Host driver");
>  MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
> -- 
> 1.7.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
