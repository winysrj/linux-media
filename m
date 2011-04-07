Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:55610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1DGLIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 07:08:12 -0400
Date: Thu, 7 Apr 2011 13:08:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Teresa=20G=C3=A1mez?= <t.gamez@phytec.de>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] mt9v022: fix pixel clock
In-Reply-To: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
Message-ID: <Pine.LNX.4.64.1104071303001.26842@axis700.grange>
References: <1302098515-12176-1-git-send-email-t.gamez@phytec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 6 Apr 2011, Teresa Gámez wrote:

> Measurements show that the setup of the pixel clock is not correct.
> The 'Invert Pixel Clock' bit has to be set to 1 for falling edge
> and not for rising.

Doesn't seem correct to me. The mt9v022 datasheet says:

<quote>
Invert pixel clock. When set, LINE_VALID,
FRAME_VALID, and DOUT is set up to the rising edge
of pixel clock, PIXCLK. When clear, they are set up to
the falling edge of PIXCLK.
</quote>

and this works for present mt9v022 configurations, which include at least 
two boards: PXA270-based arch/arm/mach-pxa/pcm990-baseboard.c and i.MX31 
based arch/arm/mach-mx3/mach-pcm037.c. If this is different for your 
board, maybe you have to set the SOCAM_SENSOR_INVERT_PCLK flag in your 
"struct soc_camera_link" instance.

Thanks
Guennadi

> Signed-off-by: Teresa Gámez <t.gamez@phytec.de>
> ---
>  drivers/media/video/mt9v022.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
> index 6a784c8..dec2a69 100644
> --- a/drivers/media/video/mt9v022.c
> +++ b/drivers/media/video/mt9v022.c
> @@ -228,7 +228,7 @@ static int mt9v022_set_bus_param(struct soc_camera_device *icd,
>  
>  	flags = soc_camera_apply_sensor_flags(icl, flags);
>  
> -	if (flags & SOCAM_PCLK_SAMPLE_RISING)
> +	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
>  		pixclk |= 0x10;
>  
>  	if (!(flags & SOCAM_HSYNC_ACTIVE_HIGH))
> -- 
> 1.7.0.4
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
