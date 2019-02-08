Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A90C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 134512084D
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:24:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="0+QEHfOw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfBHQYs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:24:48 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34396 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfBHQYr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 11:24:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id z15so4239321wrn.1
        for <linux-media@vger.kernel.org>; Fri, 08 Feb 2019 08:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gRB9eVUyeN72O+6cZqkUBflHLrbFQcOWtsgfTHQ9lJ0=;
        b=0+QEHfOw+quX515EYGZoTt2MgPppdtjvA3dOT+q0N53tg9h0qI/LeVn2teGDWGjPVv
         g54ijHe0yZbQ0SRrNeI4hqAWsCTlMd2AG2/eErPfe5HAYQ1FNCgkFJYSfdDekpdDYzEe
         OpIbTyhhIMd9Df3hHf84GIzZWAnGMFmdXXfRz13xdHHlMqsxX1z2gK0dJRNSajupgUzo
         ZBdjGt15N4BQqW5KJ75tj4Rk8fUqGA4ZiyO55pasyYbjKXJS/1UFrx2uRkw0PWGEX/yi
         +fFiEv15JCoz39LZ/BYCmpH2XH6if0hFoHt1Hc0tyN12G/jjJLVTmw8MXUW+Mzezdx9r
         lfFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gRB9eVUyeN72O+6cZqkUBflHLrbFQcOWtsgfTHQ9lJ0=;
        b=fbCnkHdtZQUbOvl3pA0dBtiTura4H4gC/RwDLZD7y4wKKNTGziZS4HQuzEe0JYTZGl
         HEmIaZr1L8vEvL+Eni8Mfiq5iVYO7r9Ha2QztLDUKIuPWMJjt2WdNl/ebK0mvqskJ8rd
         D+aBbbIA0727DEPy3HHhFrPO8ogRt2ifni4sVf7xK6gLVNmvzdloovk1/2ES815lDlBR
         4+13uT2i9btHCnit4veDPLTiisd9sq03eRA074+OpfN7L552fDPKFJBnnUd/38zf5Yoj
         4AjQ+HaJPx/X+dB6izgFHy/cToqmbouUDf0As/kgWYWjfNb3ME9uUuwhZcWuOPEWs8Zk
         hMuQ==
X-Gm-Message-State: AHQUAubgWTMlB9T/Pj+xwPRv/NDe7DiUE6h1vM61EGLPhElQT/KPP9py
        Dow3GWNLDtGvceYWwFcClMP6GP8LAMfRttTFzGeZWQ==
X-Google-Smtp-Source: AHgI3IaLH0Q5R2toI+Y1LiO31TYnLeUL/JfxdbIblFZSfco7o23ph/E8F2EvxlNU0MP7RY4iPhG8ZwWSULwfUYazdpw=
X-Received: by 2002:a5d:690d:: with SMTP id t13mr1113412wru.135.1549643085429;
 Fri, 08 Feb 2019 08:24:45 -0800 (PST)
MIME-Version: 1.0
References: <20190203194744.11546-1-slongerbeam@gmail.com> <20190203194744.11546-3-slongerbeam@gmail.com>
In-Reply-To: <20190203194744.11546-3-slongerbeam@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Fri, 8 Feb 2019 08:24:34 -0800
Message-ID: <CAJ+vNU0dP+muS7h=8SaHBk1uTEiQT4JpeHKEDG_+VJXAc20Bew@mail.gmail.com>
Subject: Re: [PATCH 2/3] gpu: ipu-v3: ipu-ic: Add support for BT.709 encoding
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

On Sun, Feb 3, 2019 at 11:48 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
> Pass v4l2 encoding enum to the ipu_ic task init functions, and add
> support for the BT.709 encoding and inverse encoding matrices.
>
> Reported-by: Tim Harvey <tharvey@gateworks.com>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/gpu/ipu-v3/ipu-ic.c                 | 67 ++++++++++++++++++---
>  drivers/gpu/ipu-v3/ipu-image-convert.c      |  1 +
>  drivers/staging/media/imx/imx-ic-prpencvf.c |  4 +-
>  include/video/imx-ipu-v3.h                  |  5 +-
>  4 files changed, 67 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/gpu/ipu-v3/ipu-ic.c b/drivers/gpu/ipu-v3/ipu-ic.c
> index 35ae86ff0585..63362b4fff81 100644
> --- a/drivers/gpu/ipu-v3/ipu-ic.c
> +++ b/drivers/gpu/ipu-v3/ipu-ic.c
> @@ -199,6 +199,23 @@ static const struct ic_csc_params ic_csc_rgb2ycbcr_bt601 = {
>         .scale = 1,
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
>  /* transparent RGB->RGB matrix for graphics combining */
>  static const struct ic_csc_params ic_csc_rgb2rgb = {
>         .coeff = {
> @@ -226,12 +243,31 @@ static const struct ic_csc_params ic_csc_ycbcr2rgb_bt601 = {
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
> @@ -241,10 +277,24 @@ static int init_csc(struct ipu_ic *ic,
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
> +               dev_err(priv->ipu->dev, "Unsupported YCbCr encoding\n");
> +               return -EINVAL;
> +       }
> +

Steve,

This will fail for RGB to RGB with 'Unsupported YCbCr encoding. We
need to account for the RGB->RGB case.

How about something like:

 static int init_csc(struct ipu_ic *ic,
                    enum ipu_color_space inf,
                    enum ipu_color_space outf,
+                   enum v4l2_ycbcr_encoding encoding,
                    int csc_index)
 {
        struct ipu_ic_priv *priv = ic->priv;
-       const struct ic_csc_params *params;
+       const struct ic_csc_params *params = NULL;
        u32 __iomem *base;
        const u16 (*c)[3];
        const u16 *a;
@@ -241,13 +276,18 @@ static int init_csc(struct ipu_ic *ic,
        base = (u32 __iomem *)
                (priv->tpmem_base + ic->reg->tpmem_csc[csc_index]);

-       if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB)
-               params = &ic_csc_ycbcr2rgb_bt601;
-       else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV)
-               params = &ic_csc_rgb2ycbcr_bt601;
+       if (inf == IPUV3_COLORSPACE_YUV && outf == IPUV3_COLORSPACE_RGB) {
+               params = (encoding == V4L2_YCBCR_ENC_601) ?
+                       &ic_csc_ycbcr2rgb_bt601 : &ic_csc_ycbcr2rgb_bt709;
+       }
+       else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_YUV) {
+               params = (encoding == V4L2_YCBCR_ENC_601) ?
+                       &ic_csc_rgb2ycbcr_bt601 : &ic_csc_rgb2ycbcr_bt709;
+       }
        else if (inf == IPUV3_COLORSPACE_RGB && outf == IPUV3_COLORSPACE_RGB)
                params = &ic_csc_rgb2rgb;
-       else {
+
+       if (!params) {
                dev_err(priv->ipu->dev, "Unsupported color space conversion\n");
                return -EINVAL;
        }

Tim
