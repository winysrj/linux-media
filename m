Return-path: <mchehab@pedra>
Received: from tango.tkos.co.il ([62.219.50.35]:50051 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab0KJMPC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Nov 2010 07:15:02 -0500
Date: Wed, 10 Nov 2010 14:14:45 +0200
From: Baruch Siach <baruch@tkos.co.il>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] mx2_camera: fix pixel clock polarity configuration
Message-ID: <20101110121445.GF26776@jasper.tkos.co.il>
References: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a54ec7e539912fd6009803cffa331b028fdb9a67.1288162873.git.baruch@tkos.co.il>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi linux-media,

On Wed, Oct 27, 2010 at 09:03:52AM +0200, Baruch Siach wrote:
> When SOCAM_PCLK_SAMPLE_FALLING, just leave CSICR1_REDGE unset, otherwise we get
> the inverted behaviour.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>

Trying my luck again. Now adding Guennadi to Cc.

This is a real bug fix, BTW.

baruch

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

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
