Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17A1FC282CB
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 00:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0DB0217D8
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 00:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="DBx5Fdw7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726703AbfBIAUh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 19:20:37 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54129 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfBIAUh (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 19:20:37 -0500
Received: by mail-wm1-f67.google.com with SMTP id d15so6304364wmb.3
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 16:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kUiTcVBO614Bxu+9K5sVMLrOf1cbV+qHsCvJqb4BVqc=;
        b=DBx5Fdw7jtA94c87CWzgxvyclQKUVejUrCNogReTwcLfimSBdPhAmxDoQesUGkh7i7
         LKl2UaqXaawYnfeNunAOm6jF4hElavcREUsHwcwro9g4RJRudYUYOI7zXKEWNPZmzFZW
         W4xH+wN4BzIhU2U9SF8W5qMdXfd/6k4uvX0Nn23t4k9ORCIXtWpmz54fDorkwt6GORjt
         IErmyadQsBAklzZW7RyywxT3bKpwABW2kJY4qgrnYOu8+1Rpr0o6uFP1wwqj5CVUkvN6
         ojguUoVSGD0f5FG31TyPCqp7qtQ9Ixp0EUGNx7VHvQUb2Sj4/1WUNR/t8f18xz07+Z+U
         P6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kUiTcVBO614Bxu+9K5sVMLrOf1cbV+qHsCvJqb4BVqc=;
        b=ShkV0GNXYabJUb5GPrvndnnIp7N/fpIKduhgVYwP9pVX+XzBnbeGFKAHVjHNOWI1f2
         g0g+HQCsh43C7YVjH2UAIfPHtCX1oiC0rz/3/rweHPcsv8EBuJkIR2pxOS46Bndxn7Lb
         eIVbZvtqjdZBsdkd4sCDqVnvMX9OukUTcNA2oGAn+eokwWv1JzYqpkqUurGhvyHk202b
         w8ftRI2g2fQRBufFh1HGMePqaVpO/Jwg4whep9TRkfw7I0P93AECsnPnUAy1NvzQ9HBC
         BOWssYlO8HqnMC7VfMOBxrpZLOkfvrpJxJr4x4Qtb6zLopFsg0qsFLvZ3pc8ubT6xywZ
         KNpg==
X-Gm-Message-State: AHQUAubAGAxMLBNXmwzadWFGkSG5BY3MNCbHfYmzM+iTV6qwuWAP5DJq
        ZT/w+bmnqse/kxG0IpNRY3E4hY0J63Xb0KELizwPfw==
X-Google-Smtp-Source: AHgI3IZQJBzS6NBdpiyTR9poMmuHops/FdJbhnsIA+HUrdkPsjej9DsfHv562oGunM2qKjZH98EdR+D80YPICaPThQY=
X-Received: by 2002:adf:ef0d:: with SMTP id e13mr18349511wro.29.1549671634542;
 Fri, 08 Feb 2019 16:20:34 -0800 (PST)
MIME-Version: 1.0
References: <20190208192844.13930-1-slongerbeam@gmail.com> <20190208192844.13930-4-slongerbeam@gmail.com>
In-Reply-To: <20190208192844.13930-4-slongerbeam@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 8 Feb 2019 16:20:23 -0800
Message-ID: <CAJ+vNU1O9E1Y=tvLvcL=0nrg6STwLxQFqOgfQpqvbTgPi4yo5w@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        "open list:DRM DRIVERS FOR FREESCALE IMX" 
        <dri-devel@lists.freedesktop.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 8, 2019 at 11:28 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
> Pass v4l2 encoding enum to the ipu_ic task init functions, and add
> support for the BT.709 encoding and inverse encoding matrices.
>
> Reported-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
> Changes in v2:
> - only return "Unsupported YCbCr encoding" error if inf != outf,
>   since if inf == outf, the identity matrix can be used. Reported
>   by Tim Harvey.
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c                 | 71 +++++++++++++++++++--
>  drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
>  drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
>  include/video/imx-ipu-v3.h                  |  5 +-
>  4 files changed, 71 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index e459615a49a1..0d57ca7ba18e 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -212,6 +212,23 @@ static const struct ic_csc_params ic_csc_identity = {
>         .scale = 2,
>  };
>
> +/*
> + * BT.709 encoding from RGB full range to YUV limited range:
> + *
> + * Y = R *  .2126 + G *  .7152 + B *  .0722;
> + * U = R * -.1146 + G * -.3854 + B *  .5000 + 128.;
> + * V = R *  .5000 + G * -.4542 + B * -.0458 + 128.;
> + */
> +static const struct ic_csc_params ic_csc_rgb2ycbcr_bt709 = {
> +       .coeff = {
> +               { 54, 183, 18 },
> +               { 483, 413, 128 },
> +               { 128, 396, 500 },
> +       },
> +       .offset = { 0, 512, 512 },
> +       .scale = 1,
> +};
> +
>  /*
>   * Inverse BT.601 encoding from YUV limited range to RGB full range:
>   *
> @@ -229,12 +246,31 @@ static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
>         .scale = 2,
>  };
>
> +/*
> + * Inverse BT.709 encoding from YUV limited range to RGB full range:
> + *
> + * R = (1. * (Y - 16)) + (1.5748 * (Cr - 128));
> + * G = (1. * (Y - 16)) - (0.1873 * (Cb - 128)) - (0.4681 * (Cr - 128));
> + * B = (1. * (Y - 16)) + (1.8556 * (Cb - 128);
> + */
> +static const struct ic_csc_params ic_csc_ycbcr2rgb_bt709 = {
> +       .coeff = {
> +               { 128, 0, 202 },
> +               { 128, 488, 452 },
> +               { 128, 238, 0 },
> +       },
> +       .offset = { -435, 136, -507 },
> +       .scale = 2,
> +};
> +
>  static int init_csc(struct ipu_ic *ic,
>                     enum ipu_color_space inf,
>                     enum ipu_color_space outf,
> +                   enum v4l2_ycbcr_encoding encoding,
>                     int csc_index)
>  {
>         struct ipu_ic_priv *priv = ic->priv;
> +       const struct ic_csc_params *params_rgb2yuv, *params_yuv2rgb;
>         const struct ic_csc_params *params;
>         u32 __iomem *base;
>         const u16 (*c)[3];
> @@ -244,12 +280,30 @@ static int init_csc(struct ipu_ic *ic,
>         base = (u32 __iomem *)
>                 (priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);
>
> +       switch (encoding) {
> +       case V4L2_YCBCR_ENC_601:
> +               params_rgb2yuv =  &ic_csc_rgb2ycbcr_bt601;
> +               params_yuv2rgb = &ic_csc_ycbcr2rgb_bt601;
> +               break;
> +       case V4L2_YCBCR_ENC_709:
> +               params_rgb2yuv =  &ic_csc_rgb2ycbcr_bt709;
> +               params_yuv2rgb = &ic_csc_ycbcr2rgb_bt709;
> +               break;
> +       default:
> +               if (inf != outf) {
> +                       dev_err(priv->ipu->dev,
> +                               "Unsupported YCbCr encoding\n");
> +                       return -EINVAL;
> +               }
> +               break;
> +       }
> +
>         if (inf == outf)
>                 params = &ic_csc_identity;
>         else if (inf == IPUV3_COLORSPACE_YUV)
> -               params = &ic_csc_ycbcr2rgb_bt601;
> +               params = &ic_csc_ycbcr2rgb;


Steve,

compile issue...

params = params_yuv2rgb;

>         else
> -               params = &ic_csc_rgb2ycbcr_bt601;
> +               params = &ic_csc_rgb2ycbcr;

params = params_rgb2yuv;

But, I'm still failing when using the mem2mem element (gst-launch-1.0
v4l2src device=/dev/video4 ! v4l2video8convert
output-io-mode=dmabuf-import ! fbdevsink) with 'Unsupported YCbCr
encoding' because of inf=IPU_COLORSPACE_YCBCR outf=IPU_COLORSPACE_RGB
and a seemingly unset encoding being passed in.

It looks like maybe something in the mem2mem driver isn't defaulting
encoding. The call path is (v4l2_m2m_streamon -> device_run ->
ipu_image_convert_queue -> convert_start -> ipu_ic_task_init_rsc ->
init_csc).

Tim
