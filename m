Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.186]:62723 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1EDIRL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 04:17:11 -0400
Date: Wed, 4 May 2011 10:17:06 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?UTF-8?q?Teresa=20G=C3=A1mez?= <t.gamez@phytec.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] mt9v022: fix pixel clock
In-Reply-To: <1302791997-12679-1-git-send-email-t.gamez@phytec.de>
Message-ID: <Pine.LNX.4.64.1105040959130.23196@axis700.grange>
References: <1302791997-12679-1-git-send-email-t.gamez@phytec.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Teresa

I'm adding Mauro to CC, because we were discussing adding these (this one 
and mt9m111) patches to .39.

On Thu, 14 Apr 2011, Teresa Gámez wrote:

> The setup of the pixel clock is done wrong in the mt9v022 driver.
> The 'Invert Pixel Clock' bit has to be set to 1 for falling edge
> and not for rising. This is not clearly described in the data
> sheet.

I finally got round to test your patch on pcm037. But sorry, I cannot 
reproduce your success. What's even worth, your patch, if applied to the 
stock kernel, really messes up Bayer colours for me. With your patch alone 
I cannot select the Bayer filter starting pixel parameter to produce 
correct colours. Without your patch colours do not look very clean, that's 
true, but I always attributed it to some sensor fine-tuning issues. But at 
least they are correct. An easy way to test colours is to point the camera 
at the LED pair on the board - blinking red and constant green next to the 
ethernet port. You once mentioned, that in your BSP you have the 
SOCAM_SENSOR_INVERT_PCLK flag set in your platform data. Maybe you were 
testing with that one? Then yes, of course, you'd have to compensate it by 
inverting the bit in the sensor. In any case, your patch if applied alone, 
seems to break camera on pcm037. Am I missing something?

Thanks
Guennadi

> 
> Tested on pcm037 and pcm027/pcm990.
> 
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

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
