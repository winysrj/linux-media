Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C49C282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 160212081B
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 06:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XsXyxCUC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfBEGek (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 01:34:40 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43055 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfBEGek (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 01:34:40 -0500
Received: by mail-ot1-f68.google.com with SMTP id a11so3956026otr.10
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 22:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WB2r9DtjxH6hgsQ5yHygEw5AulQ+7DZcuqjKYdK31ew=;
        b=XsXyxCUCZI4DqavWqNMTAWVGx5heqWQT5fKQ4HMkc540zKB4XU+mKWXyTIvzia+SUE
         5RPbLsFKmdFiYuiMxofTa87al5b6w2AmPyE0jvVIln97yXR0sZ0JfwljIh8PIziIQhbw
         e6tevo0H5doeL2a6HLhZSwjOoYRRFpa+aJZXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WB2r9DtjxH6hgsQ5yHygEw5AulQ+7DZcuqjKYdK31ew=;
        b=iuo20NDBZZQPG455bI1QNItpKLDOwkPaAfIB5V2NTDA3x13fAxJZL+Lyq6Uu1YE/i6
         djLw1yN23/H2pyFq1fFreQhltyBfzsqVMJjjCv5j9T3BGJlPZ9vGKczeWW5W/XYGMLRL
         jnbx72h5j6C48QcViG898rzKH/VVI9q0HoIFHkVXjvr3dRHZ3cJQfd4ptcXHhLfVWLfy
         +3Xf9E0TNILQg84nY43kzQOjCS2+R9cA/XnOBGbblBXy+L/5MGFZfxfrjvOfD5cZ4Bmf
         Qawe2iRpFgY6Lfe+dO7sH+65mr0AhvLuXo4Zd7DAn5vTLBKOOyYbvx6DhLIUsJY7C9AC
         iHRQ==
X-Gm-Message-State: AHQUAuaYg0jEb4DAmXfSvzry8WVPNG5RiYsjtdC6jK8W7bWzLEASFu3Z
        Cc2EPq9CCWNKnKj0dek14FUGr6ZMOjs=
X-Google-Smtp-Source: AHgI3IZQ1KTwnAbVmsTBgte0SERAiJCC7v9QjvUDOeI1zhIFnvSpSQfghAwCszRTHrJZSnXQnHH8Lw==
X-Received: by 2002:aca:b542:: with SMTP id e63mr1610112oif.125.1549348478691;
        Mon, 04 Feb 2019 22:34:38 -0800 (PST)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id c23sm7626699otn.21.2019.02.04.22.34.37
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 22:34:37 -0800 (PST)
Received: by mail-ot1-f54.google.com with SMTP id u16so3979874otk.8
        for <linux-media@vger.kernel.org>; Mon, 04 Feb 2019 22:34:37 -0800 (PST)
X-Received: by 2002:aca:5c87:: with SMTP id q129mr1745011oib.189.1549348476877;
 Mon, 04 Feb 2019 22:34:36 -0800 (PST)
MIME-Version: 1.0
References: <7fd6ccf110b7c167a2304ffd482e6c04252c4909.1549028130.git.mchehab+samsung@kernel.org>
In-Reply-To: <7fd6ccf110b7c167a2304ffd482e6c04252c4909.1549028130.git.mchehab+samsung@kernel.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 5 Feb 2019 15:34:25 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Bd4VaAwXnTMVgCTFahda9V6PBm0PVUjc1=VBSUj0Ombw@mail.gmail.com>
Message-ID: <CAAFQd5Bd4VaAwXnTMVgCTFahda9V6PBm0PVUjc1=VBSUj0Ombw@mail.gmail.com>
Subject: Re: [PATCH] media: vim2m: add bayer capture formats
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Anton Leontiev <scileont@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,

On Fri, Feb 1, 2019 at 11:19 PM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> The vim2m device is interesting to simulate a webcam.

Hmm, how would you simulate a webcam with a mem2mem device? The same
process needs to control both OUTPUT and CAPTURE queues, so regular
webcam apps wouldn't work.

Best regards,
Tomasz

> As most
> sensors are arranged using bayer formats, the best is to support
> to output data using those formats.
>
> So, add support for them.
>
> All 4 8-bit bayer formats tested with:
>
>         $ qvidcap -p &
>         $ v4l2-ctl --stream-mmap --stream-out-mmap --stream-to-host localhost --stream-lossless --stream-out-hor-speed 1 -v pixelformat=RGGB
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/platform/vim2m.c | 97 ++++++++++++++++++++++++++++++++--
>  1 file changed, 92 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
> index e31c14c7d37f..6240878def80 100644
> --- a/drivers/media/platform/vim2m.c
> +++ b/drivers/media/platform/vim2m.c
> @@ -82,24 +82,47 @@ static struct platform_device vim2m_pdev = {
>  struct vim2m_fmt {
>         u32     fourcc;
>         int     depth;
> +       /* Types the format can be used for */
> +       u32     types;
>  };
>
>  static struct vim2m_fmt formats[] = {
>         {
>                 .fourcc = V4L2_PIX_FMT_RGB565,  /* rrrrrggg gggbbbbb */
>                 .depth  = 16,
> +               .types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
>         }, {
>                 .fourcc = V4L2_PIX_FMT_RGB565X, /* gggbbbbb rrrrrggg */
>                 .depth  = 16,
> +               .types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
>         }, {
>                 .fourcc = V4L2_PIX_FMT_RGB24,
>                 .depth  = 24,
> +               .types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
>         }, {
>                 .fourcc = V4L2_PIX_FMT_BGR24,
>                 .depth  = 24,
> +               .types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
>         }, {
>                 .fourcc = V4L2_PIX_FMT_YUYV,
>                 .depth  = 16,
> +               .types  = MEM2MEM_CAPTURE | MEM2MEM_OUTPUT,
> +       }, {
> +               .fourcc = V4L2_PIX_FMT_SBGGR8,
> +               .depth  = 8,
> +               .types  = MEM2MEM_CAPTURE,
> +       }, {
> +               .fourcc = V4L2_PIX_FMT_SGBRG8,
> +               .depth  = 8,
> +               .types  = MEM2MEM_CAPTURE,
> +       }, {
> +               .fourcc = V4L2_PIX_FMT_SGRBG8,
> +               .depth  = 8,
> +               .types  = MEM2MEM_CAPTURE,
> +       }, {
> +               .fourcc = V4L2_PIX_FMT_SRGGB8,
> +               .depth  = 8,
> +               .types  = MEM2MEM_CAPTURE,
>         },
>  };
>
> @@ -208,7 +231,7 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
>         (u8)(((__color) > 0xff) ? 0xff : (((__color) < 0) ? 0 : (__color)))
>
>  static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
> -                           u8 **src, u8 **dst, bool reverse)
> +                           u8 **src, u8 **dst, int y, bool reverse)
>  {
>         u8 _r[2], _g[2], _b[2], *r, *g, *b;
>         int i, step;
> @@ -379,7 +402,8 @@ static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
>                         *(*dst)++ = *r++;
>                 }
>                 return;
> -       default: /* V4L2_PIX_FMT_YUYV */
> +       case V4L2_PIX_FMT_YUYV:
> +       default:
>         {
>                 u8 y, y1, u, v;
>
> @@ -399,6 +423,42 @@ static void copy_two_pixels(struct vim2m_fmt *in, struct vim2m_fmt *out,
>                 *(*dst)++ = v;
>                 return;
>         }
> +       case V4L2_PIX_FMT_SBGGR8:
> +               if (!(y & 1)) {
> +                       *(*dst)++ = *b;
> +                       *(*dst)++ = *++g;
> +               } else {
> +                       *(*dst)++ = *g;
> +                       *(*dst)++ = *++r;
> +               }
> +               return;
> +       case V4L2_PIX_FMT_SGBRG8:
> +               if (!(y & 1)) {
> +                       *(*dst)++ = *g;
> +                       *(*dst)++ = *++b;
> +               } else {
> +                       *(*dst)++ = *r;
> +                       *(*dst)++ = *++g;
> +               }
> +               return;
> +       case V4L2_PIX_FMT_SGRBG8:
> +               if (!(y & 1)) {
> +                       *(*dst)++ = *g;
> +                       *(*dst)++ = *++r;
> +               } else {
> +                       *(*dst)++ = *b;
> +                       *(*dst)++ = *++g;
> +               }
> +               return;
> +       case V4L2_PIX_FMT_SRGGB8:
> +               if (!(y & 1)) {
> +                       *(*dst)++ = *r;
> +                       *(*dst)++ = *++g;
> +               } else {
> +                       *(*dst)++ = *g;
> +                       *(*dst)++ = *++b;
> +               }
> +               return;
>         }
>  }
>
> @@ -449,7 +509,7 @@ static int device_process(struct vim2m_ctx *ctx,
>                         p += bytesperline - (q_data_in->fmt->depth >> 3);
>
>                 for (x = 0; x < width >> 1; x++)
> -                       copy_two_pixels(in, out, &p, &p_out,
> +                       copy_two_pixels(in, out, &p, &p_out, y,
>                                         ctx->mode & MEM2MEM_HFLIP);
>         }
>
> @@ -562,11 +622,25 @@ static int vidioc_querycap(struct file *file, void *priv,
>
>  static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
>  {
> +       int i, num;
>         struct vim2m_fmt *fmt;
>
> -       if (f->index < NUM_FORMATS) {
> +       num = 0;
> +
> +       for (i = 0; i < NUM_FORMATS; ++i) {
> +               if (formats[i].types & type) {
> +                       /* index-th format of type type found ? */
> +                       if (num == f->index)
> +                               break;
> +                       /* Correct type but haven't reached our index yet,
> +                        * just increment per-type index */
> +                       ++num;
> +               }
> +       }
> +
> +       if (i < NUM_FORMATS) {
>                 /* Format found */
> -               fmt = &formats[f->index];
> +               fmt = &formats[i];
>                 f->pixelformat = fmt->fourcc;
>                 return 0;
>         }
> @@ -657,6 +731,12 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>                 f->fmt.pix.pixelformat = formats[0].fourcc;
>                 fmt = find_format(f);
>         }
> +       if (!(fmt->types & MEM2MEM_CAPTURE)) {
> +               v4l2_err(&ctx->dev->v4l2_dev,
> +                        "Fourcc format (0x%08x) invalid.\n",
> +                        f->fmt.pix.pixelformat);
> +               return -EINVAL;
> +       }
>         f->fmt.pix.colorspace = ctx->colorspace;
>         f->fmt.pix.xfer_func = ctx->xfer_func;
>         f->fmt.pix.ycbcr_enc = ctx->ycbcr_enc;
> @@ -669,12 +749,19 @@ static int vidioc_try_fmt_vid_out(struct file *file, void *priv,
>                                   struct v4l2_format *f)
>  {
>         struct vim2m_fmt *fmt;
> +       struct vim2m_ctx *ctx = file2ctx(file);
>
>         fmt = find_format(f);
>         if (!fmt) {
>                 f->fmt.pix.pixelformat = formats[0].fourcc;
>                 fmt = find_format(f);
>         }
> +       if (!(fmt->types & MEM2MEM_OUTPUT)) {
> +               v4l2_err(&ctx->dev->v4l2_dev,
> +                        "Fourcc format (0x%08x) invalid.\n",
> +                        f->fmt.pix.pixelformat);
> +               return -EINVAL;
> +       }
>         if (!f->fmt.pix.colorspace)
>                 f->fmt.pix.colorspace = V4L2_COLORSPACE_REC709;
>
> --
> 2.20.1
>
