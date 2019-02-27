Return-Path: <SRS0=SnUM=RC=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED67C43381
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CDAC213A2
	for <linux-media@archiver.kernel.org>; Wed, 27 Feb 2019 15:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbfB0PPX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 27 Feb 2019 10:15:23 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46511 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfB0PPX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Feb 2019 10:15:23 -0500
Received: by mail-lj1-f193.google.com with SMTP id v16so14275668ljg.13
        for <linux-media@vger.kernel.org>; Wed, 27 Feb 2019 07:15:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+knZ4WhmruzNoz3eYtMTh/Z0H8awNg8fiVEsKohVDIA=;
        b=OuAOLwClU+CPQT6eTH/0EJfwr//xjIHfq+RmSt84XBbsl6768qxzYzXt/+JRAl9i9q
         rw2e8Y839NY8BeqOmRS9nvwUlxcowuEhHoPcuBZ7JAGbgupRO9zpT9BZL8Anrwwa7RVT
         JUaBl7cJHgShHrWalDSfdjtyFjLPFXAgf0yobgiVWRiTbh14RCobTLhViyZfzpI6C8lG
         A+1KzCuXO1UI//9iTgh4ctN8T8oUCFJ7ZcrdZS0P23t+sUiyPeQQgsgDWiG0OzUD+WXo
         TU1M33U6dpOIvt6TEmR70vZDu0CRlpOZ/Kwbfk4q9LurKzNURftfjYZK6erjmAQAf5Lg
         6tMg==
X-Gm-Message-State: APjAAAXu3bIiReagXfTqm6ldfPDKeNqWwrPHe1uWKVA4KA9+zv+r2YqX
        EKh7OzhQ1NHyv9F4xz9T4OWt8BKELwH0svt8lVQ=
X-Google-Smtp-Source: AHgI3IY4ds0TG2lYOxPi+C2Oa5gscwXNedkl/vCL+LpXj96fiDU2ZZQhyvGopv1dX0bzU7m3b3coRcKWeUMT13qiIvk=
X-Received: by 2002:a2e:9d85:: with SMTP id c5mr1937662ljj.70.1551280520404;
 Wed, 27 Feb 2019 07:15:20 -0800 (PST)
MIME-Version: 1.0
References: <20190227144710.32427-1-daniel@qtec.com> <20190227144710.32427-2-daniel@qtec.com>
In-Reply-To: <20190227144710.32427-2-daniel@qtec.com>
From:   Ricardo Ribalda Delgado <ricardo@ribalda.com>
Date:   Wed, 27 Feb 2019 16:15:01 +0100
Message-ID: <CAPybu_2wwMOG=2gfkyEY83zjA4nHpu-o_bmv86HFVop17+2_Sw@mail.gmail.com>
Subject: Re: [PATCH 2/2] libv4lconvert: add support for BAYER16
To:     Daniel Gomez <daniel@qtec.com>
Cc:     linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Daniel,

On Wed, Feb 27, 2019 at 3:47 PM Daniel Gomez <daniel@qtec.com> wrote:
>
> Add support for 16 bit Bayer formats:
>         -V4L2_PIX_FMT_SBGGR16
>         -V4L2_PIX_FMT_SGBRG16
>         -V4L2_PIX_FMT_SGRBG16
>         -V4L2_PIX_FMT_SRGGB16
>
> Tested using vivid included in linux v5.0-rc8.
>
> Signed-off-by: Daniel Gomez <daniel@qtec.com>

Signed-off-by: Ricardo Ribalda <ricardo@ribalda.com>

> ---
>  lib/libv4lconvert/bayer.c              |  9 ++++++
>  lib/libv4lconvert/libv4lconvert-priv.h |  3 ++
>  lib/libv4lconvert/libv4lconvert.c      | 45 ++++++++++++++++++++++++++
>  3 files changed, 57 insertions(+)
>
> diff --git a/lib/libv4lconvert/bayer.c b/lib/libv4lconvert/bayer.c
> index 96d26cce..7748e68d 100644
> --- a/lib/libv4lconvert/bayer.c
> +++ b/lib/libv4lconvert/bayer.c
> @@ -662,3 +662,12 @@ void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
>                 bayer8 += 4;
>         }
>  }
> +
> +void v4lconvert_bayer16_to_bayer8(unsigned char *bayer16,
> +               unsigned char *bayer8, int width, int height)
> +{
> +       int i;
> +
> +       for (i = 0; i < width * height; i++)
> +               bayer8[i] = bayer16[2*i+1];
> +}
> diff --git a/lib/libv4lconvert/libv4lconvert-priv.h b/lib/libv4lconvert/libv4lconvert-priv.h
> index 44d2d32e..a8046ce2 100644
> --- a/lib/libv4lconvert/libv4lconvert-priv.h
> +++ b/lib/libv4lconvert/libv4lconvert-priv.h
> @@ -270,6 +270,9 @@ void v4lconvert_bayer10_to_bayer8(void *bayer10,
>  void v4lconvert_bayer10p_to_bayer8(unsigned char *bayer10p,
>                 unsigned char *bayer8, int width, int height);
>
> +void v4lconvert_bayer16_to_bayer8(unsigned char *bayer16,
> +               unsigned char *bayer8, int width, int height);
> +
>  void v4lconvert_hm12_to_rgb24(const unsigned char *src,
>                 unsigned char *dst, int width, int height);
>
> diff --git a/lib/libv4lconvert/libv4lconvert.c b/lib/libv4lconvert/libv4lconvert.c
> index a8cf856a..7dc409f2 100644
> --- a/lib/libv4lconvert/libv4lconvert.c
> +++ b/lib/libv4lconvert/libv4lconvert.c
> @@ -140,6 +140,10 @@ static const struct v4lconvert_pixfmt supported_src_pixfmts[] = {
>         { V4L2_PIX_FMT_SGBRG10,         16,      8,      8,     1 },
>         { V4L2_PIX_FMT_SGRBG10,         16,      8,      8,     1 },
>         { V4L2_PIX_FMT_SRGGB10,         16,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SBGGR16,         16,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SGBRG16,         16,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SGRBG16,         16,      8,      8,     1 },
> +       { V4L2_PIX_FMT_SRGGB16,         16,      8,      8,     1 },
>         /* compressed bayer */
>         { V4L2_PIX_FMT_SPCA561,          0,      9,      9,     1 },
>         { V4L2_PIX_FMT_SN9C10X,          0,      9,      9,     1 },
> @@ -702,6 +706,10 @@ static int v4lconvert_processing_needs_double_conversion(
>         case V4L2_PIX_FMT_SGBRG10:
>         case V4L2_PIX_FMT_SGRBG10:
>         case V4L2_PIX_FMT_SRGGB10:
> +       case V4L2_PIX_FMT_SBGGR16:
> +       case V4L2_PIX_FMT_SGBRG16:
> +       case V4L2_PIX_FMT_SGRBG16:
> +       case V4L2_PIX_FMT_SRGGB16:
>         case V4L2_PIX_FMT_STV0680:
>                 return 0;
>         }
> @@ -1052,6 +1060,43 @@ static int v4lconvert_convert_pixfmt(struct v4lconvert_data *data,
>                 }
>         }
>
> +       case V4L2_PIX_FMT_SBGGR16:
> +       case V4L2_PIX_FMT_SGBRG16:
> +       case V4L2_PIX_FMT_SGRBG16:
> +       case V4L2_PIX_FMT_SRGGB16: {
> +               int b16format = 1;
> +
> +               switch (src_pix_fmt) {
> +               case V4L2_PIX_FMT_SBGGR16:
> +                       src_pix_fmt = V4L2_PIX_FMT_SBGGR8;
> +                       break;
> +               case V4L2_PIX_FMT_SGBRG16:
> +                       src_pix_fmt = V4L2_PIX_FMT_SGBRG8;
> +                       break;
> +               case V4L2_PIX_FMT_SGRBG16:
> +                       src_pix_fmt = V4L2_PIX_FMT_SGRBG8;
> +                       break;
> +               case V4L2_PIX_FMT_SRGGB16:
> +                       src_pix_fmt = V4L2_PIX_FMT_SRGGB8;
> +                       break;
> +               default:
> +                       b16format = 0;
> +                       break;
> +               }
> +
> +               if (b16format) {
> +                       if (src_size < ((width * height * 2))) {
> +                               V4LCONVERT_ERR
> +                                       ("short raw bayer16 data frame\n");
> +                               errno = EPIPE;
> +                               result = -1;
> +                               break;
> +                       }
> +                       v4lconvert_bayer16_to_bayer8(src, src, width, height);
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
