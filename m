Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:49999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JVQBj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 12:01:39 -0400
Date: Mon, 22 Oct 2012 18:01:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
cc: mchehab@redhat.com, Scott.Jiang.Linux@gmail.com,
	javier.martin@vista-silicon.com, linux-media@vger.kernel.org,
	kernel@pengutronix.de
Subject: Re: [PATCH 3.6.0- 4/5] media/soc_camera: use module_platform_driver
 macro
In-Reply-To: <1349894040-8127-1-git-send-email-srinivas.kandagatla@st.com>
Message-ID: <Pine.LNX.4.64.1210221757240.26216@axis700.grange>
References: <1349894040-8127-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Srinivas

On Wed, 10 Oct 2012, Srinivas KANDAGATLA wrote:

> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch removes some code duplication by using
> module_platform_driver.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Thanks for the patch. It is indeed correct, but an identical patch is 
already upstream: 
http://git.linuxtv.org/media_tree.git/commit/ec0341b3b7817a5e8ebcf26091dde28dce2d7821

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/soc_camera.c |   14 +-------------
>  1 files changed, 1 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 3be9294..d4bfe29 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1585,19 +1585,7 @@ static struct platform_driver __refdata soc_camera_pdrv = {
>  		.owner	= THIS_MODULE,
>  	},
>  };
> -
> -static int __init soc_camera_init(void)
> -{
> -	return platform_driver_register(&soc_camera_pdrv);
> -}
> -
> -static void __exit soc_camera_exit(void)
> -{
> -	platform_driver_unregister(&soc_camera_pdrv);
> -}
> -
> -module_init(soc_camera_init);
> -module_exit(soc_camera_exit);
> +module_platform_driver(soc_camera_pdrv);
>  
>  MODULE_DESCRIPTION("Image capture bus driver");
>  MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
