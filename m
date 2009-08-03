Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35906 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbZHCJRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2009 05:17:20 -0400
Received: by qyk34 with SMTP id 34so2759869qyk.33
        for <linux-media@vger.kernel.org>; Mon, 03 Aug 2009 02:17:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200908031052.59016.marek.vasut@gmail.com>
References: <200908031031.00676.marek.vasut@gmail.com>
	 <200908031052.59016.marek.vasut@gmail.com>
Date: Mon, 3 Aug 2009 14:47:20 +0530
Message-ID: <5d5443650908030217s124c49aeocb7478abc86fd4cc@mail.gmail.com>
Subject: Re: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
From: Trilok Soni <soni.trilok@gmail.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Eric Miao <eric.y.miao@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add linux-media ML.

On Mon, Aug 3, 2009 at 2:22 PM, Marek Vasut<marek.vasut@gmail.com> wrote:
> Dne Po 3. srpna 2009 10:31:00 Marek Vasut napsal(a):
>> Hi!
>>
>> Eric, would you mind applying ?
>
> Argh, lack of sleep caused me to miss one part of the patch, sorry.
>
> >From 11b65f0580db188bd995eff25d35b92c556ad5a4 Mon Sep 17 00:00:00 2001
> From: Marek Vasut <marek.vasut@gmail.com>
> Date: Mon, 3 Aug 2009 10:27:57 +0200
> Subject: [PATCH] Add RGB555X and RGB565X formats to pxa-camera
>
> Those formats are requiered on widely used OmniVision OV96xx cameras.
> Those formats are nothing more then endian-swapped RGB555 and RGB565.
>
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
>  drivers/media/video/pxa_camera.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/media/video/pxa_camera.c
> b/drivers/media/video/pxa_camera.c
> index 46e0d8a..3ebad1f 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -1145,10 +1145,12 @@ static int pxa_camera_set_bus_param(struct
> soc_camera_device *icd, __u32 pixfmt)
>                cicr1 |= CICR1_COLOR_SP_VAL(2);
>                break;
>        case V4L2_PIX_FMT_RGB555:
> +       case V4L2_PIX_FMT_RGB555X:
>                cicr1 |= CICR1_RGB_BPP_VAL(1) | CICR1_RGBT_CONV_VAL(2) |
>                        CICR1_TBIT | CICR1_COLOR_SP_VAL(1);
>                break;
>        case V4L2_PIX_FMT_RGB565:
> +       case V4L2_PIX_FMT_RGB565X:
>                cicr1 |= CICR1_COLOR_SP_VAL(1) | CICR1_RGB_BPP_VAL(2);
>                break;
>        }
> @@ -1222,6 +1224,8 @@ static int required_buswidth(const struct
> soc_camera_data_format *fmt)
>        case V4L2_PIX_FMT_YVYU:
>        case V4L2_PIX_FMT_RGB565:
>        case V4L2_PIX_FMT_RGB555:
> +       case V4L2_PIX_FMT_RGB565X:
> +       case V4L2_PIX_FMT_RGB555X:
>                return 8;
>        default:
>                return fmt->depth;
> @@ -1260,6 +1264,8 @@ static int pxa_camera_get_formats(struct
> soc_camera_device *icd, int idx,
>        case V4L2_PIX_FMT_YVYU:
>        case V4L2_PIX_FMT_RGB565:
>        case V4L2_PIX_FMT_RGB555:
> +       case V4L2_PIX_FMT_RGB565X:
> +       case V4L2_PIX_FMT_RGB555X:
>                formats++;
>                if (xlate) {
>                        xlate->host_fmt = icd->formats + idx;
> --
> 1.6.3.3
>
>
>
> -------------------------------------------------------------------
> List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>



-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
