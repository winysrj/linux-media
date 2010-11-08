Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.23]:52485 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754792Ab0KHVUn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Nov 2010 16:20:43 -0500
Date: Mon, 8 Nov 2010 22:20:33 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] SoC Camera: ov6650: minor cleanups
In-Reply-To: <201011021714.37544.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1011082219580.29934@axis700.grange>
References: <201011021714.37544.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Janusz

On Tue, 2 Nov 2010, Janusz Krzysztofik wrote:

> This is a followup patch that addresses two minor issues left in the recently 
> added ov6650 sensor driver, as I've promised to the subsystem maintainer:
> - remove a pair of extra brackets,
> - drop useless case for not possible v4l2_mbus_pixelcode enum value of 0.
> 
> Created against linux-2.6.37-rc1.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Applied together with other your 3 patches and pushed for 2.6.37-rc2.

Thanks
Guennadi

> ---
> 
>  drivers/media/video/ov6650.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> --- linux-2.6.37-rc1/drivers/media/video/ov6650.c.orig	2010-11-01 22:41:59.000000000 +0100
> +++ linux-2.6.37-rc1/drivers/media/video/ov6650.c	2010-11-02 16:56:49.000000000 +0100
> @@ -754,7 +754,7 @@ static int ov6650_g_fmt(struct v4l2_subd
>  
>  static bool is_unscaled_ok(int width, int height, struct v4l2_rect *rect)
>  {
> -	return (width > rect->width >> 1 || height > rect->height >> 1);
> +	return width > rect->width >> 1 || height > rect->height >> 1;
>  }
>  
>  static u8 to_clkrc(struct v4l2_fract *timeperframe,
> @@ -840,8 +840,6 @@ static int ov6650_s_fmt(struct v4l2_subd
>  		coma_mask |= COMA_BW | COMA_BYTE_SWAP | COMA_WORD_SWAP;
>  		coma_set |= COMA_RAW_RGB | COMA_RGB;
>  		break;
> -	case 0:
> -		break;
>  	default:
>  		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
>  		return -EINVAL;
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
