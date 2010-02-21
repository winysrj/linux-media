Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0BUTpM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Feb 2010 14:45:12 -0500
Message-ID: <4B818D72.5040302@redhat.com>
Date: Sun, 21 Feb 2010 20:45:54 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Richard Hirst <richard@sleepie.demon.co.uk>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4lconvert_rotate90() leaves bytesperline wrong
References: <4B80757B.5070804@sleepie.demon.co.uk>
In-Reply-To: <4B80757B.5070804@sleepie.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch, but this has been long fixed
(in pretty much the same way, the v4lconvert_fixup_fmt() call
  was put inside the v4lconvert_rotate90 function).

Regards,

Hans


On 02/21/2010 12:51 AM, Richard Hirst wrote:
> I have a cheap webcam (ID 093a:262a Pixart Imaging, Inc.), and Ubuntu
> 9.10 64 bit, Skype 2.1.0.81, and lib32v4l-0 version 0.6.0-1. I start
> skype with LD_PRELOAD=/usr/lib32/libv4l/v4l1compat.so, and the video
> image is garbled. I believe the problem is that the webcam image starts
> off at 480x640 and skype asks for YU12 at 320x240 for a test image. This
> results in v4lconvert_rotate90() being called to rotate the image, and
> then v4lconvert_reduceandcrop_yuv420() being called to down-size the
> image from 640x480 to 320x240. Unfortunately
> v4lconvert_reduceandcrop_yuv420() relies on
> src_fmt->fmt.pix.bytesperline for the source image, and that is still
> 480 (should be 640, since the image has been rotated).
>
> This fixes it for me:
>
> --- ori/libv4lconvert/libv4lconvert.c 2010-02-20 22:44:28.000000000 +0000
> +++ libv4l-0.6.0/libv4lconvert/libv4lconvert.c 2010-02-20
> 23:01:12.000000000 +0000
> @@ -1088,8 +1088,10 @@
> v4lprocessing_processing(data->processing, convert2_dest, &my_src_fmt);
> }
>
> - if (rotate90)
> + if (rotate90) {
> v4lconvert_rotate90(rotate90_src, rotate90_dest, &my_src_fmt);
> + v4lconvert_fixup_fmt(&my_src_fmt);
> + }
>
> if (hflip || vflip)
> v4lconvert_flip(flip_src, flip_dest, &my_src_fmt, hflip, vflip);
>
>
>
> I didn't look closely at the latest source, so it is possible this
> already fixed some other way.
>
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
