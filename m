Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8788EC282C2
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 02:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55D112084D
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 02:13:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RghgrD1u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfBKCM5 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 10 Feb 2019 21:12:57 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42668 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbfBKCM5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 10 Feb 2019 21:12:57 -0500
Received: by mail-lj1-f195.google.com with SMTP id l7-v6so855821ljg.9;
        Sun, 10 Feb 2019 18:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ciPCuSl6u+1eD109Y9vQu8wnQ7q5IxHOml7/mnvQ78s=;
        b=RghgrD1usGSjVEYMffSka+wsxuF0CcHVv7ocr3Ghq3v34nvHjnuZPDIkimE9U3nm6z
         UjhCi6teL2ll7E8KW/BDI0lao5X9H/TZvn0n6WMmZ5GEmBzJjV1+ujMVDT/BaaxIoo1Q
         aTGH74ZZOg5XZ1ZXnKV8BroBsntjo2qfst/jIRLtAVfwYApgnLjn7qGuI0m3gY1jiCgf
         uxp/ctpYvfFGbZ10/7+z65jL4OJAD1MceAfvhKJFBp260SB1kMqVL/BFwx3hsveekCN2
         JUYAx9ZTvd2T55W9/Lq55rsY6NId6IKmHzidksLqqYlWVUgdLMfSyrfLy705c/IP0xag
         9yOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ciPCuSl6u+1eD109Y9vQu8wnQ7q5IxHOml7/mnvQ78s=;
        b=gogDltZThEXyLIp3pc2QCQKrueVp6J5w/j3MjRggXulLi6yuYoREYhSP555TVdgXIr
         ZSFMa37d43fhFtkzfc/sepAqCpf7+3nBFwnJSUZD007qp0KX0Ese0c/wdBpODcCNykT2
         ZUmm8C4O92O+Xj/njSNWK6bVkVUCQ0fldElkypvxb1F8jOXTaAVmH5my0J/WccuBtRSX
         myS3iV6g4hb47TxCss42LIQF37Xo0XZfN72Op4bQuHLLoRIeJKZHZcy0/r1oEV1UiVKz
         80VrsDYxk0C0HvT1JZzpWd15Kqita/XpPZMEoGmtKA2KUlxDeMDggq/CN5oRVn2y4r0H
         Cdhw==
X-Gm-Message-State: AHQUAubfqbwH+1wHicT7njXnEpjoYG3UpZFT3ysbqt1HmiFFqKGIz44/
        bJb1o8hAjFO1nctDmQphsl4M+2eAlnc6RUCnRe8=
X-Google-Smtp-Source: AHgI3IanpNOlgRw5Ip/OUHLh5mzBTRa0tbLj9r063HlBbk1Cip60djDdw+KKPF3yMAQ99ItD3rtuKMS3FWeIYtlrt6c=
X-Received: by 2002:a2e:9059:: with SMTP id n25-v6mr19730682ljg.155.1549851175632;
 Sun, 10 Feb 2019 18:12:55 -0800 (PST)
MIME-Version: 1.0
References: <20190204150142.GA3900@jordon-HP-15-Notebook-PC>
In-Reply-To: <20190204150142.GA3900@jordon-HP-15-Notebook-PC>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Mon, 11 Feb 2019 07:42:47 +0530
Message-ID: <CAFqt6zbWPn4H6ArYEecou0Ri79a6hQcYcBo8ZrjPfkxFJUV-UQ@mail.gmail.com>
Subject: Re: [PATCHv2] media: videobuf2: Return error after allocation failure
To:     pawel@osciak.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 4, 2019 at 8:27 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> There is no point to continuing assignment after memory allocation
> failed, rather throw error immediately.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Any comment on this patch ?

> ---
> v1 -> v2:
>         Corrected typo in change log.
>
>  drivers/media/common/videobuf2/videobuf2-vmalloc.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> index 6dfbd5b..d3f71e2 100644
> --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> @@ -46,16 +46,16 @@ static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
>
>         buf->size = size;
>         buf->vaddr = vmalloc_user(buf->size);
> -       buf->dma_dir = dma_dir;
> -       buf->handler.refcount = &buf->refcount;
> -       buf->handler.put = vb2_vmalloc_put;
> -       buf->handler.arg = buf;
>
>         if (!buf->vaddr) {
>                 pr_debug("vmalloc of size %ld failed\n", buf->size);
>                 kfree(buf);
>                 return ERR_PTR(-ENOMEM);
>         }
> +       buf->dma_dir = dma_dir;
> +       buf->handler.refcount = &buf->refcount;
> +       buf->handler.put = vb2_vmalloc_put;
> +       buf->handler.arg = buf;
>
>         refcount_set(&buf->refcount, 1);
>         return buf;
> --
> 1.9.1
>
