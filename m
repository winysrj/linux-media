Return-path: <linux-media-owner@vger.kernel.org>
Received: from compulab.co.il ([67.18.134.219]:53528 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbZKRGek (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Nov 2009 01:34:40 -0500
Message-ID: <4B039576.3020105@compulab.co.il>
Date: Wed, 18 Nov 2009 08:34:30 +0200
From: Mike Rapoport <mike@compulab.co.il>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Juergen Beisert <j.beisert@pengutronix.de>,
	Robert Jarzmik <robert.jarzmik@free.fr>
Subject: Re: [PATCH 1/3] em-x270: don't use pxa_camera init() callback
References: <1258495463-26029-1-git-send-email-ospite@studenti.unina.it> <1258495463-26029-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1258495463-26029-2-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Antonio Ospite wrote:
> pxa_camera init() is going to be removed.
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>  arch/arm/mach-pxa/em-x270.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)

Acked-by: Mike Rapoport <mike@compulab.co.il>

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

-- 
Sincerely yours,
Mike.

