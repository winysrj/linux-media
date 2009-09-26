Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:54037 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZIZULP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Sep 2009 16:11:15 -0400
Subject: Re: [PATCH] cx25840 6.5MHz carrier detection fixes
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	hverkuil@xs4all.nl
Cc: linux-media@vger.kernel.org
In-Reply-To: <20090925211621.GA15452@moon>
References: <20090925211621.GA15452@moon>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 16:12:59 -0400
Message-Id: <1253995979.3156.31.camel@palomino.walls.org>
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

I would like a little more time to look at your patch.

However, in the mean time, could you test the DK vs. L autodetection,
without your patch, using the cx25840 firmware in

http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20070217.tar.gz

?

The MD5 sum of that firmware is:

$ md5sum /lib/firmware/v4l-cx25840.fw 
99836e41ccb28c7b373e87686f93712a  /lib/firmware/v4l-cx25840.fw

The cx25840 firmware in

http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20080701.tar.gz
http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware.tar.gz

is probably wrong to use for the CX2584[0123] chips as it it actually
CX23148 A/V core firmware - very similar but not the same.


Hans or Axel,

Could one of you put the correct v4l-cx25840.fw image found in 

http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware-20070217.tar.gz

in the archive at:

http://dl.ivtvdriver.org/ivtv/firmware/ivtv-firmware.tar.gz

?

The v4l-cx25840.fw image currently in that archive, which is actually
for the CX23418, is not good to use with CX2584[0123].


Regards,
Andy


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

