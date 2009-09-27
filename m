Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:39568 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbZI0OyG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Sep 2009 10:54:06 -0400
Subject: Re: [PATCH] cx25840 6.5MHz carrier detection fixes
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090925211621.GA15452@moon>
References: <20090925211621.GA15452@moon>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 10:56:56 -0400
Message-Id: <1254063416.3152.28.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2009-09-26 at 00:16 +0300, Aleksandr V. Piskunov wrote:
> cx25840:
> Disable 6.5MHz carrier autodetection for PAL, always assume its DK.
> Only try to autodetect 6.5MHz carrier for SECAM if user accepts both
> system DK and L.
> 
> Signed-off-by: Aleksandr V. Piskunov <alexandr.v.piskunov@gmail.com>

Aleksandr,

Looks good for CX2584[0123] chips.

It is not right for CX2388[578] or CX2310[12] chips, but the original
code doesn't do the right thing anyway for those chips, AFAICT.  In
those chips auto-detection of DK vs. L for 6.5 MHz sound carriers
doesn't appear to exist, and hence the bit positions and meanings have
changed slightly.  Your fix get us closer to doing the right thing for
those devices.  The rest of the fix for those devices is for another
day...

Reviewed-by: Andy Walls <awalls@radix.net>


> diff --git a/linux/drivers/media/video/cx25840/cx25840-core.c b/linux/drivers/media/video/cx25840/cx25840-core.c
> --- a/linux/drivers/media/video/cx25840/cx25840-core.c
> +++ b/linux/drivers/media/video/cx25840/cx25840-core.c
> @@ -647,13 +647,30 @@
>                 }
>                 cx25840_write(client, 0x80b, 0x00);
>         } else if (std & V4L2_STD_PAL) {
> -               /* Follow tuner change procedure for PAL */
> +               /* Autodetect audio standard and audio system */
>                 cx25840_write(client, 0x808, 0xff);
> -               cx25840_write(client, 0x80b, 0x10);
> +               /* Since system PAL-L is pretty much non-existant and
> +                  not used by any public broadcast network, force
> +                  6.5 MHz carrier to be interpreted as System DK,
> +                  this avoids DK audio detection instability */
> +               cx25840_write(client, 0x80b, 0x00);
>         } else if (std & V4L2_STD_SECAM) {
> -               /* Select autodetect for SECAM */
> +               /* Autodetect audio standard and audio system */
>                 cx25840_write(client, 0x808, 0xff);
> -               cx25840_write(client, 0x80b, 0x10);
> +               /* If only one of SECAM-DK / SECAM-L is required, then force
> +                  6.5MHz carrier, else autodetect it */
> +               if ((std & V4L2_STD_SECAM_DK) &&
> +                   !(std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
> +                       /* 6.5 MHz carrier to be interpreted as System DK */
> +                       cx25840_write(client, 0x80b, 0x00);
> +               } else if (!(std & V4L2_STD_SECAM_DK) &&
> +                          (std & (V4L2_STD_SECAM_L | V4L2_STD_SECAM_LC))) {
> +                       /* 6.5 MHz carrier to be interpreted as System L */
> +                       cx25840_write(client, 0x80b, 0x08);
> +               } else {
> +                       /* 6.5 MHz carrier to be autodetected */
> +                       cx25840_write(client, 0x80b, 0x10);
> +               }
>         }
> 
>         cx25840_and_or(client, 0x810, ~0x01, 0);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

