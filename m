Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52657
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752875AbdBCJ4K (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 04:56:10 -0500
Date: Fri, 3 Feb 2017 07:55:55 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Tabrez khan <khan.tabrez21@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:bcm2048 : Add parentheses around  variable x
Message-ID: <20170203075555.3038fb36@vento.lan>
In-Reply-To: <1480758266-6160-1-git-send-email-khan.tabrez21@gmail.com>
References: <1480758266-6160-1-git-send-email-khan.tabrez21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  3 Dec 2016 15:14:26 +0530
Tabrez khan <khan.tabrez21@gmail.com> escreveu:

> Add parentheses around variable x for the readability purpose.
> 
> This warning was found using checkpatch.pl.
> 
> Signed-off-by: Tabrez khan <khan.tabrez21@gmail.com>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 4d9bd02..2f28dd0 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -185,7 +185,7 @@
>  #define v4l2_to_dev(f)	((f * BCM2048_FREQV4L2_MULTI) / BCM2048_FREQDEV_UNIT)
>  
>  #define msb(x)                  ((u8)((u16)x >> 8))
> -#define lsb(x)                  ((u8)((u16)x &  0x00FF))
> +#define lsb(x)                  ((u8)((u16)(x) &  0x00FF))

If you're willing to do that, you should do on all macros. Also,
plese remove the extra space before the hexa value.

>  #define compose_u16(msb, lsb)	(((u16)msb << 8) | lsb)
>  
>  #define BCM2048_DEFAULT_POWERING_DELAY	20



Thanks,
Mauro
