Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:52081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932447Ab0J0Vhi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Oct 2010 17:37:38 -0400
Date: Wed, 27 Oct 2010 23:37:33 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH] mx2_camera: fix pixel clock polarity configuration
In-Reply-To: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il>
Message-ID: <Pine.LNX.4.64.1010272336290.13615@axis700.grange>
References: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 27 Oct 2010, Baruch Siach wrote:

> When SOCAM_PCLK_SAMPLE_FALLING, just leave CSICR1_REDGE unset, otherwise we get
> the inverted behaviour.

Seems logical to me, that if this is true, then you need the inverse:

	if (!(common_flags & SOCAM_PCLK_SAMPLE_FALLING))
		csicr1 |= CSICR1_INV_PCLK;

Thanks
Guennadi

> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/media/video/mx2_camera.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 3ea2ec0..02f144f 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -811,8 +811,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd,
>  
>  	if (common_flags & SOCAM_PCLK_SAMPLE_RISING)
>  		csicr1 |= CSICR1_REDGE;
> -	if (common_flags & SOCAM_PCLK_SAMPLE_FALLING)
> -		csicr1 |= CSICR1_INV_PCLK;
>  	if (common_flags & SOCAM_VSYNC_ACTIVE_HIGH)
>  		csicr1 |= CSICR1_SOF_POL;
>  	if (common_flags & SOCAM_HSYNC_ACTIVE_HIGH)
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
