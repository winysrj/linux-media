Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbbA1U6f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2015 15:58:35 -0500
Message-ID: <54C899CB.4050705@redhat.com>
Date: Wed, 28 Jan 2015 09:11:55 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Luca Bonissi <lucabon@scarsita.it>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: gspca_vc032x - wrong bytesperline
References: <54C61919.7050508@scarsita.it>
In-Reply-To: <54C61919.7050508@scarsita.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 26-01-15 11:38, Luca Bonissi wrote:
> Hi!
>
> I found a problem on vc032x gspca usb webcam subdriver: "bytesperline" property is wrong for YUYV and YVYU formats.
> With recent v4l-utils library (>=0.9.1), that uses "bytesperline" for pixel format conversion, the result is a wrong jerky image.
>
> Patch tested on my laptop (USB webcam Logitech Orbicam 046d:0892).

Thanks, I've added this patch to my gspca tree, and send a pull-req to
Mauro to get it added to 3.20 .

Regards,

Hans

>
> --- drivers/media/usb/gspca/vc032x.c.orig       2014-08-04 00:25:02.000000000 +0200
> +++ drivers/media/usb/gspca/vc032x.c    2015-01-12 00:28:39.423311693 +0100
> @@ -68,12 +68,12 @@
>
>   static const struct v4l2_pix_format vc0321_mode[] = {
>          {320, 240, V4L2_PIX_FMT_YVYU, V4L2_FIELD_NONE,
> -               .bytesperline = 320,
> +               .bytesperline = 320 * 2,
>                  .sizeimage = 320 * 240 * 2,
>                  .colorspace = V4L2_COLORSPACE_SRGB,
>                  .priv = 1},
>          {640, 480, V4L2_PIX_FMT_YVYU, V4L2_FIELD_NONE,
> -               .bytesperline = 640,
> +               .bytesperline = 640 * 2,
>                  .sizeimage = 640 * 480 * 2,
>                  .colorspace = V4L2_COLORSPACE_SRGB,
>                  .priv = 0},
> @@ -97,12 +97,12 @@
>   };
>   static const struct v4l2_pix_format bi_mode[] = {
>          {320, 240, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
> -               .bytesperline = 320,
> +               .bytesperline = 320 * 2,
>                  .sizeimage = 320 * 240 * 2,
>                  .colorspace = V4L2_COLORSPACE_SRGB,
>                  .priv = 2},
>          {640, 480, V4L2_PIX_FMT_YUYV, V4L2_FIELD_NONE,
> -               .bytesperline = 640,
> +               .bytesperline = 640 * 2,
>                  .sizeimage = 640 * 480 * 2,
>                  .colorspace = V4L2_COLORSPACE_SRGB,
>                  .priv = 1},
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
