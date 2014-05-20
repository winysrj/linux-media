Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57461 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaETBsK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 May 2014 21:48:10 -0400
Received: by mail-qc0-f174.google.com with SMTP id x13so10191622qcv.19
        for <linux-media@vger.kernel.org>; Mon, 19 May 2014 18:48:09 -0700 (PDT)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com [209.85.192.45])
        by mx.google.com with ESMTPSA id 74sm11927676qgf.32.2014.05.19.18.48.08
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 19 May 2014 18:48:08 -0700 (PDT)
Received: by mail-qg0-f45.google.com with SMTP id z60so9939060qgd.4
        for <linux-media@vger.kernel.org>; Mon, 19 May 2014 18:48:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400241824-18260-2-git-send-email-k.debski@samsung.com>
References: <1400241824-18260-1-git-send-email-k.debski@samsung.com> <1400241824-18260-2-git-send-email-k.debski@samsung.com>
From: Pawel Osciak <posciak@chromium.org>
Date: Tue, 20 May 2014 10:47:27 +0900
Message-ID: <CACHYQ-qQ5AGFvoLbL992GF-C6vUmRToTKm2wut09tskEBEAPCQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] v4l: s5p-mfc: Limit enum_fmt to output formats of
 current version
To: Kamil Debski <k.debski@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Arun Kumar <arun.kk@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,
I like the solution as well. Two suggestions to consider below.

On Fri, May 16, 2014 at 9:03 PM, Kamil Debski <k.debski@samsung.com> wrote:
> MFC versions support a different set of formats, this specially applies
> to the raw YUV formats. This patch changes enum_fmt, so that it only
> reports formats that are supported by the used MFC version.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---

> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> index 9370c34..d5efb10 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
> @@ -223,6 +223,7 @@ struct s5p_mfc_buf_align {
>  struct s5p_mfc_variant {
>         unsigned int version;
>         unsigned int port_num;
> +       u32 version_bit;
>         struct s5p_mfc_buf_size *buf_size;
>         struct s5p_mfc_buf_align *buf_align;
>         char    *fw_name;
> @@ -666,6 +667,7 @@ struct s5p_mfc_fmt {
>         u32 codec_mode;
>         enum s5p_mfc_fmt_type type;
>         u32 num_planes;
> +       u32 versions;
>  };
>
>  /**
> @@ -705,4 +707,9 @@ void set_work_bit_irqsave(struct s5p_mfc_ctx *ctx);
>  #define IS_MFCV6_PLUS(dev)     (dev->variant->version >= 0x60 ? 1 : 0)
>  #define IS_MFCV7_PLUS(dev)     (dev->variant->version >= 0x70 ? 1 : 0)
>
> +#define MFC_V5 BIT(0)
> +#define MFC_V6 BIT(1)
> +#define MFC_V7 BIT(2)

These may be confusing. I'd suggest at least suffixing those macros with _BIT.
Or better yet, please make this into an enum and also make
variant->versions of size BITS_TO_LONGS() with max enum value.

>  /* Get format */
> @@ -384,11 +402,9 @@ static int vidioc_try_fmt(struct file *file, void *priv, struct v4l2_format *f)
>                         mfc_err("Unknown codec\n");
>                         return -EINVAL;
>                 }
> -               if (!IS_MFCV6_PLUS(dev)) {
> -                       if (fmt->fourcc == V4L2_PIX_FMT_VP8) {
> -                               mfc_err("Not supported format.\n");
> -                               return -EINVAL;
> -                       }
> +               if ((dev->variant->version_bit & fmt->versions) == 0) {
> +                       mfc_err("Unsupported format by this MFC version.\n");
> +                       return -EINVAL;

What do you think of moving this check to find_format()? You wouldn't
have to duplicate it across enum_fmt and try_fmt then...
