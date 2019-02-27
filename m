Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64193C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:16:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D3621850
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:16:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbfB0PQS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 10:16:18 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46919 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbfB0PQS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 10:16:18 -0500
Received: by mail-lf1-f67.google.com with SMTP id g12so12747461lfb.13
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 07:16:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/hVPJ33YeSHS7AzHn7J2BCJ2QJQY+3VK8UgP3ebt+Xw=;
        b=AWvDmRrHUISxRw1zJer8oYcF4VLxa6FMLuL6YQlOSpqzySxauu3xU/rVyJ+yrwwlXp
         gb5zM7k5xVeDu4fjDvV3wirllYJcxcm4MyxkkxzBvREZZw0jQYg0U90+BPyIFUsO89+2
         pIVyY6uxVcoOKP1KhV4AHTobkjTm959tUja37Vl6kgoWFfo6B9BcuitEt3XgQo+OJR3C
         QDKs208CmzSfKM7kGbdIGg5a94vghdBshKk4gA9v6mhLVeyquZB1dyk989alARFx4oDo
         WGE6RXCGDcrT5vAnE9IhtEhCUq2QEsRobkNegvx6xk/SFR33seuZCLZdyjzlLrICuZ3d
         QjWg==
X-Gm-Message-State: AHQUAuZNnCEtutbHxOHHx/ybJsM7ZjmUy76/me6+dUEb/KvYvA/OdapO
        ZSUgGSIMPtKEfrTsPTPYLTyGpyesPmQFKT1F027cOed6
X-Google-Smtp-Source: AHgI3IbB81jG2gZBlq/1nLTsNDIbDFl4lDTZGl6/REwq6DoJK/eXggYpJzsiEhBrDhU4bzXLYaNYr7uqtsdqBluywyc=
X-Received: by 2002:a19:7b1c:: with SMTP id w28mr1198525lfc.73.1551280575491;
 Wed, 27 Feb 2019 07:16:15 -0800 (PST)
MIME-Version: 1.0
References: <20190227144710.32427-1-daniel@qtec.com>
In-Reply-To: <20190227144710.32427-1-daniel@qtec.com>
From:   Ricardo Ribalda Delgado <ricardo@ribalda.com>
Date:   Wed, 27 Feb 2019 16:15:58 +0100
Message-ID: <CAPybu_3R9E6WNeei99iMw5FeX97SgVsTzT4M=HqqUNmc72BMNw@mail.gmail.com>
Subject: Re: [PATCH 1/2] libv4lconvert: add support for BAYER10
To:     Daniel Gomez <daniel@qtec.com>
Cc:     linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Daniel,

Thanks for both patches

On Wed, Feb 27, 2019 at 3:47 PM Daniel Gomez <daniel@qtec.com> wrote:
>
> Add support for 10 bit Bayer formats:
>         -V4L2_PIX_FMT_SBGGR10
>         -V4L2_PIX_FMT_SGBRG10
>         -V4L2_PIX_FMT_SRGGB10
>
> Previous BAYER10 format declared (V4L2_PIX_FMT_SGRBG10) now is grouped
> with the new list without the need of tmp buffer.
>
> Update v4lconvert_10to8 function:
>         - Renaming function name to keep naming convention with the
>         other bayer10p conversion function:
>                 v4lconvert_10to8 -> v4lconvert_bayer10_to_bayer8
>
> Tested using vivid included in linux v5.0-rc8.
>
> Signed-off-by: Daniel Gomez <daniel@qtec.com>
Signed-off-by: Ricardo Ribalda <ricardo@ribalda.com>
> ---
>  lib/libv4lconvert/bayer.c              | 10 ++++
>  lib/libv4lconvert/libv4lconvert-priv.h |  2 +
>  lib/libv4lconvert/libv4lconvert.c      | 65 +++++++++++++++++++-------
>  3 files changed, 59 insertions(+), 18 deletions(-)
>
> diff --git a/lib/libv4lconvert/bayer.c b/lib/libv4lconvert/bayer.c
> index 11af6543..96d26cce 100644
> --- a/lib/libv4lconvert/bayer.c
> +++ b/lib/libv4lconvert/bayer.c
> @@ -632,6 +632,16 @@ void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
>                         !start_with_green, !blue_line);
>  }
>
> +void v4lconvert_bayer10_to_bayer8(void *bayer10,
> +               unsigned char *bayer8, int width, int height)
> +{
> +       int i;
> +       uint16_t *src = bayer10;
> +
> +       for (i = 0; i < width * height; i++)
> +               bayer8[i] = src[i] >> 2;
> +}
> +
>  void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
>                 unsigned char *bayer8, int width, int height)
>  {
> diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
> index 3020a39e..44d2d32e 100644
> --- a/lib/libv4lconvert/libv4lconvert-priv.h
> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
> @@ -264,6 +264,8 @@ void v4lconvert_bayer_to_bgr24(const unsigned char *bayer,
>  void v4lconvert_bayer_to_yuv420(const unsigned char *bayer, unsigned char *yuv,
>                 int width, int height, const unsigned int stride, unsigned int src_pixfmt, int yvu);
>
> +void v4lconvert_bayer10_to_bayer8(void *bayer10,
> +               unsigned char *bayer8, int width, int height);
>
>  void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
>                 unsigned char *bayer8, int width, int height);
> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
> index 6a4c66a8..a8cf856a 100644
> --- a/lib/libv4lconvert/libv4lconvert.c
> +++ b/lib/libv4lconvert/libv4lconvert.c
> @@ -132,11 +132,14 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>         { V4L2_PIX_FMT_SGRBG8,           8,      8,      8,     0 },
>         { V4L2_PIX_FMT_SRGGB8,           8,      8,      8,     0 },
>         { V4L2_PIX_FMT_STV0680,          8,      8,      8,     1 },
> -       { V4L2_PIX_FMT_SGRBG10,         16,      8,      8,     1 },
>         { V4L2_PIX_FMT_SBGGR10P,        10,      8,      8,     1 },
>         { V4L2_PIX_FMT_SGBRG10P,        10,      8,      8,     1 },
>         { V4L2_PIX_FMT_SGRBG10P,        10,      8,      8,     1 },
>         { V4L2_PIX_FMT_SRGGB10P,        10,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SBGGR10,         16,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SGBRG10,         16,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SGRBG10,         16,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SRGGB10,         16,      8,      8,     1 },
>         /* compressed bayer */
>         { V4L2_PIX_FMT_SPCA561,          0,      9,      9,     1 },
>         { V4L2_PIX_FMT_SN9C10X,          0,      9,      9,     1 },
> @@ -695,6 +698,10 @@ static int v4lconvert_processing_needs_double_conversion(
>         case V4L2_PIX_FMT_SGBRG10P:
>         case V4L2_PIX_FMT_SGRBG10P:
>         case V4L2_PIX_FMT_SRGGB10P:
> +       case V4L2_PIX_FMT_SBGGR10:
> +       case V4L2_PIX_FMT_SGBRG10:
> +       case V4L2_PIX_FMT_SGRBG10:
> +       case V4L2_PIX_FMT_SRGGB10:
>         case V4L2_PIX_FMT_STV0680:
>                 return 0;
>         }
> @@ -722,16 +729,6 @@ unsigned char *v4lconvert_alloc_buffer(int needed,
>         return *buf;
>  }
>
> -static void v4lconvert_10to8(void *_src, unsigned char *dst, int width, int height)
> -{
> -       int i;
> -       uint16_t *src = _src;
> -
> -       for (i = 0; i < width * height; i++) {
> -               dst[i] = src[i] >> 2;
> -       }
> -}
> -
>  int v4lconvert_oom_error(struct v4lconvert_data *data)
>  {
>         V4LCONVERT_ERR("could not allocate memory\n");
> @@ -907,8 +904,7 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>  #endif
>         case V4L2_PIX_FMT_SN9C2028:
>         case V4L2_PIX_FMT_SQ905C:
> -       case V4L2_PIX_FMT_STV0680:
> -       case V4L2_PIX_FMT_SGRBG10: { /* Not compressed but needs some shuffling */
> +       case V4L2_PIX_FMT_STV0680: { /* Not compressed but needs some shuffling */
>                 unsigned char *tmpbuf;
>                 struct v4l2_format tmpfmt = *fmt;
>
> @@ -918,11 +914,6 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>                         return v4lconvert_oom_error(data);
>
>                 switch (src_pix_fmt) {
> -               case V4L2_PIX_FMT_SGRBG10:
> -                       v4lconvert_10to8(src, tmpbuf, width, height);
> -                       tmpfmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SGRBG8;
> -                       bytesperline = width;
> -                       break;
>                 case V4L2_PIX_FMT_SPCA561:
>                         v4lconvert_decode_spca561(src, tmpbuf, width, height);
>                         tmpfmt.fmt.pix.pixelformat = V4L2_PIX_FMT_SGBRG8;
> @@ -1023,6 +1014,44 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>                         bytesperline = width;
>                 }
>         }
> +
> +       case V4L2_PIX_FMT_SBGGR10:
> +       case V4L2_PIX_FMT_SGBRG10:
> +       case V4L2_PIX_FMT_SGRBG10:
> +       case V4L2_PIX_FMT_SRGGB10: {
> +               int b10format = 1;
> +
> +               switch (src_pix_fmt) {
> +               case V4L2_PIX_FMT_SBGGR10:
> +                       src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
> +                       break;
> +               case V4L2_PIX_FMT_SGBRG10:
> +                       src_pix_fmt = V4L2_PIX_FMT_SGBRG8;
> +                       break;
> +               case V4L2_PIX_FMT_SGRBG10:
> +                       src_pix_fmt = V4L2_PIX_FMT_SGRBG8;
> +                       break;
> +               case V4L2_PIX_FMT_SRGGB10:
> +                       src_pix_fmt = V4L2_PIX_FMT_SRGGB8;
> +                       break;
> +               default:
> +                       b10format = 0;
> +                       break;
> +               }
> +
> +               if (b10format) {
> +                       if (src_size < (width * height * 2)) {
> +                               V4LCONVERT_ERR
> +                                       ("short raw bayer10 data frame\n");
> +                               errno = EPIPE;
> +                               result = -1;
> +                               break;
> +                       }
> +                       v4lconvert_bayer10_to_bayer8(src, src, width, height);
> +                       bytesperline = width;
> +               }
> +       }
> +
>         /* Fall-through*/
>         case V4L2_PIX_FMT_SBGGR8:
>         case V4L2_PIX_FMT_SGBRG8:
> --
> 2.20.1
>


-- 
Ricardo Ribalda
