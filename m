Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60864 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756072AbZCLRCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 13:02:08 -0400
Date: Thu, 12 Mar 2009 18:02:19 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
To: Philippe =?utf-8?q?R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH] mt9t031 bugfix
In-Reply-To: <200903061037.51684.philippe.retornaz@epfl.ch>
Message-ID: <Pine.LNX.4.64.0903121754130.4896@axis700.grange>
References: <200903061037.51684.philippe.retornaz@epfl.ch>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 6 Mar 2009, Philippe Rétornaz wrote:

> - The video device is not allocated when mt9t031_init() is called, don't use 
> it in debug printk.
> 
> - The clock polarity is inverted in mt9t031_set_bus_param(), use the correct 
> one.
> 
> 
> Signed-off-by: Philippe Rétornaz <philippe.retornaz@epfl.ch>
> 
> ---
> 
> diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
> index acc1fa9..d846110 100644
> --- a/drivers/media/video/mt9t031.c
> +++ b/drivers/media/video/mt9t031.c
> @@ -144,8 +144,6 @@ static int mt9t031_init(struct soc_camera_device *icd)
>  	int ret;
>  
>  	/* Disable chip output, synchronous option update */
> -	dev_dbg(icd->vdev->parent, "%s\n", __func__);
> -
>  	ret = reg_write(icd, MT9T031_RESET, 1);
>  	if (ret >= 0)
>  		ret = reg_write(icd, MT9T031_RESET, 0);
> @@ -186,9 +184,9 @@ static int mt9t031_set_bus_param(struct soc_camera_device *icd,
>  		return -EINVAL;
>  
>  	if (flags & SOCAM_PCLK_SAMPLE_FALLING)
> -		reg_set(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
> -	else
>  		reg_clear(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);
> +	else
> +		reg_set(icd, MT9T031_PIXEL_CLOCK_CONTROL, 0x8000);

Why do you think this is the correct one? According to the "Pin 
Description" Table (Table 3 on page 8 in my copy), indeed, it says

<quote>
Pixel clock: pixel data outputs are valid during falling edge of this 
clock.
</quote>

which _probably_ should refer to the default configuration, which is 
R10=0, i.e., non-inverted pixclk. In this case you are right. However, in 
Figure "Pixel Color Pattern Detail (Top Right Corner)" (Figure 5 on page 
10) you see the first pixel green in a red row, and this is what I seem to 
be getting with the current driver, after applying your patch I'm getting 
a red pixel at the start. Are you basing your patch only on Table 3 or you 
verified it practically somehow?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
