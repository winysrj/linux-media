Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59843 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755681AbZKRKJ6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 05:09:58 -0500
Date: Wed, 18 Nov 2009 11:10:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Mike Rapoport <mike@compulab.co.il>,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 1/3] em-x270: don't use pxa_camera init() callback
In-Reply-To: <1258495463-26029-2-git-send-email-ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0911181107540.5702@axis700.grange>
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it>
 <1258495463-26029-2-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 17 Nov 2009, Antonio Ospite wrote:

> pxa_camera init() is going to be removed.

My nitpick here would be - I would put it the other way round. We do not 
remove .init() in platforms, because it is going to be removed, but rather 
we perform initialisation statically, because we think this is better so, 
and then .init becomes useless and gets removed.

> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>

Thanks
Guennadi

> ---
>  arch/arm/mach-pxa/em-x270.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
> index aec7f42..f71f34c 100644
> --- a/arch/arm/mach-pxa/em-x270.c
> +++ b/arch/arm/mach-pxa/em-x270.c
> @@ -967,7 +967,7 @@ static inline void em_x270_init_gpio_keys(void) {}
>  #if defined(CONFIG_VIDEO_PXA27x) || defined(CONFIG_VIDEO_PXA27x_MODULE)
>  static struct regulator *em_x270_camera_ldo;
>  
> -static int em_x270_sensor_init(struct device *dev)
> +static int em_x270_sensor_init(void)
>  {
>  	int ret;
>  
> @@ -996,7 +996,6 @@ static int em_x270_sensor_init(struct device *dev)
>  }
>  
>  struct pxacamera_platform_data em_x270_camera_platform_data = {
> -	.init	= em_x270_sensor_init,
>  	.flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
>  		PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
>  	.mclk_10khz = 2600,
> @@ -1049,8 +1048,10 @@ static struct platform_device em_x270_camera = {
>  
>  static void  __init em_x270_init_camera(void)
>  {
> -	pxa_set_camera_info(&em_x270_camera_platform_data);
> -	platform_device_register(&em_x270_camera);
> +	if (em_x270_sensor_init() == 0) {
> +		pxa_set_camera_info(&em_x270_camera_platform_data);
> +		platform_device_register(&em_x270_camera);
> +	}
>  }
>  #else
>  static inline void em_x270_init_camera(void) {}
> -- 
> 1.6.5.2
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
