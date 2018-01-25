Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx01-fr.bfs.de ([193.174.231.67]:32185 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751295AbeAYIxd (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 03:53:33 -0500
Message-ID: <5A69994D.5070802@bfs.de>
Date: Thu, 25 Jan 2018 09:46:05 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
MIME-Version: 1.0
To: =?UTF-8?B?Q2hyaXN0b3BoZXIgRMOtYXogUml2ZXJvcw==?=
        <chrisadr@gentoo.org>
CC: mchehab@kernel.org, hans.verkuil@cisco.com,
        arvind.yadav.cs@gmail.com, dean@sensoray.com,
        keescook@chromium.org, bhumirks@gmail.com,
        sakari.ailus@linux.intel.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH-next] media: s2255drv: Remove unneeded if else blocks
References: <20180124214043.16429-1-chrisadr@gentoo.org>
In-Reply-To: <20180124214043.16429-1-chrisadr@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Am 24.01.2018 22:40, schrieb Christopher Díaz Riveros:
> Given the following definitions from s2255drv.c
> 
>  #define LINE_SZ_4CIFS_NTSC      640
>  #define LINE_SZ_2CIFS_NTSC      640
>  #define LINE_SZ_1CIFS_NTSC      320
> 
> and
> 
>  #define LINE_SZ_4CIFS_PAL       704
>  #define LINE_SZ_2CIFS_PAL       704
>  #define LINE_SZ_1CIFS_PAL       352
> 
> f->fmt.pix.width possible values can be reduced to
> LINE_SZ_4CIFS_NTSC or LINE_SZ_1CIFS_NTSC.
> 
> This patch removes unneeded if else blocks in vidioc_try_fmt_vid_cap
> function.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Christopher Díaz Riveros <chrisadr@gentoo.org>

mmmh, yes and no.
i guess the author tries to document the change from 4->2->1

The whole thing gets more obvoius when you use hex and look at the bits:
704 = 0x2C0 = 001011000000
640 = 0x280 = 001010000000
352 = 0x160 = 000101100000
320 = 0x140 = 000101000000

so they only flip one bit and shift the mask. perhaps you can use that
to simplify the code ?

re
 wh
> ---
>  drivers/media/usb/s2255/s2255drv.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
> index 8c2a86d71e8a..a00a15f55d37 100644
> --- a/drivers/media/usb/s2255/s2255drv.c
> +++ b/drivers/media/usb/s2255/s2255drv.c
> @@ -803,10 +803,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  		}
>  		if (f->fmt.pix.width >= LINE_SZ_4CIFS_NTSC)
>  			f->fmt.pix.width = LINE_SZ_4CIFS_NTSC;
> -		else if (f->fmt.pix.width >= LINE_SZ_2CIFS_NTSC)
> -			f->fmt.pix.width = LINE_SZ_2CIFS_NTSC;
> -		else if (f->fmt.pix.width >= LINE_SZ_1CIFS_NTSC)
> -			f->fmt.pix.width = LINE_SZ_1CIFS_NTSC;
>  		else
>  			f->fmt.pix.width = LINE_SZ_1CIFS_NTSC;
>  	} else {
> @@ -820,10 +816,6 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  		}
>  		if (f->fmt.pix.width >= LINE_SZ_4CIFS_PAL)
>  			f->fmt.pix.width = LINE_SZ_4CIFS_PAL;
> -		else if (f->fmt.pix.width >= LINE_SZ_2CIFS_PAL)
> -			f->fmt.pix.width = LINE_SZ_2CIFS_PAL;
> -		else if (f->fmt.pix.width >= LINE_SZ_1CIFS_PAL)
> -			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
>  		else
>  			f->fmt.pix.width = LINE_SZ_1CIFS_PAL;
>  	}
