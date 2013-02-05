Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057Ab3BEWtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 17:49:05 -0500
Date: Tue, 5 Feb 2013 20:48:53 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org,
	Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: Re: [PATCH] em28xx: overhaul em28xx_capture_area_set()
Message-ID: <20130205204853.28037d69@redhat.com>
In-Reply-To: <1358688407-5146-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1358688407-5146-1-git-send-email-fschaefer.oss@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 Jan 2013 14:26:47 +0100
Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:

> - move the bit shifting of width+height values inside the function
> - fix the debug message format and output values
> - add comment about the size limit (e.g. EM277x supports >2MPix)
> - make void, because error checking is incomplete and we never check the
>   returned value (we would continue anyway)
> 
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
> ---
>  drivers/media/usb/em28xx/em28xx-core.c |   22 ++++++++++++----------
>  1 Datei geändert, 12 Zeilen hinzugefügt(+), 10 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx-core.c b/drivers/media/usb/em28xx/em28xx-core.c
> index 210859a..f516a63 100644
> --- a/drivers/media/usb/em28xx/em28xx-core.c
> +++ b/drivers/media/usb/em28xx/em28xx-core.c
> @@ -733,22 +733,24 @@ static int em28xx_accumulator_set(struct em28xx *dev, u8 xmin, u8 xmax,
>  	return em28xx_write_regs(dev, EM28XX_R2B_YMAX, &ymax, 1);
>  }
>  
> -static int em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
> +static void em28xx_capture_area_set(struct em28xx *dev, u8 hstart, u8 vstart,
>  				   u16 width, u16 height)
>  {
> -	u8 cwidth = width;
> -	u8 cheight = height;
> -	u8 overflow = (height >> 7 & 0x02) | (width >> 8 & 0x01);
> +	u8 cwidth = width >> 2;
> +	u8 cheight = height >> 2;
> +	u8 overflow = (height >> 9 & 0x02) | (width >> 10 & 0x01);

Hmm.. why did you change the above overflow bits? That change doesn't
sound right to me. Ok, I don't have the datasheets, so I might be
wrong, but if is there a bug there, please submit the bug fix into a
separate patch, clearly explaining why such change is needed.

> +	/* NOTE: size limit: 2047x1023 = 2MPix */
>  
> -	em28xx_coredbg("em28xx Area Set: (%d,%d)\n",
> -			(width | (overflow & 2) << 7),
> -			(height | (overflow & 1) << 8));
> +	em28xx_coredbg("capture area set to (%d,%d): %dx%d\n",
> +		       hstart, vstart,
> +		       ((overflow & 2) << 9 | cwidth << 2),
> +		       ((overflow & 1) << 10 | cheight << 2));
>  
>  	em28xx_write_regs(dev, EM28XX_R1C_HSTART, &hstart, 1);
>  	em28xx_write_regs(dev, EM28XX_R1D_VSTART, &vstart, 1);
>  	em28xx_write_regs(dev, EM28XX_R1E_CWIDTH, &cwidth, 1);
>  	em28xx_write_regs(dev, EM28XX_R1F_CHEIGHT, &cheight, 1);
> -	return em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
> +	em28xx_write_regs(dev, EM28XX_R1B_OFLOW, &overflow, 1);
>  }
>  
>  static int em28xx_scaler_set(struct em28xx *dev, u16 h, u16 v)
> @@ -801,9 +803,9 @@ int em28xx_resolution_set(struct em28xx *dev)
>  	   it out, we end up with the same format as the rest of the VBI
>  	   region */
>  	if (em28xx_vbi_supported(dev) == 1)
> -		em28xx_capture_area_set(dev, 0, 2, width >> 2, height >> 2);
> +		em28xx_capture_area_set(dev, 0, 2, width, height);
>  	else
> -		em28xx_capture_area_set(dev, 0, 0, width >> 2, height >> 2);
> +		em28xx_capture_area_set(dev, 0, 0, width, height);
>  
>  	return em28xx_scaler_set(dev, dev->hscale, dev->vscale);
>  }


-- 

Cheers,
Mauro
