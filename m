Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987D8C10F00
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 03:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63F29218B0
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 03:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iQPociG7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730851AbfCADEr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 28 Feb 2019 22:04:47 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44562 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfCADEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 28 Feb 2019 22:04:47 -0500
Received: by mail-lj1-f194.google.com with SMTP id q128so19037420ljb.11;
        Thu, 28 Feb 2019 19:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BBcKiv8lgJH8WjlVJtIZM3TkArsPsyv5C92UA5FRHXs=;
        b=iQPociG7Uc5+NGDOIle+vglwUmj+yq2QmCj9VMgUhHoIZCRL7CYbzTdn9nD54UxIWa
         ZCimAUSI1ZDDCVwgUVlgfUXUV3Gxw19GcFB/MTvm6MWL5wEAmcsqWcoUYJHsaoFa0gmG
         88APCaas4i5JEA0Wkvk5L/FVWrZbhM16Q2n6aOONpxYUkBVfScT/3fTxKKgqX3aEJ6Vy
         yN4BMSWsQnruY7jzQojL+pg9ED2n7t0rAlK1giNh52mgNBxJ53gpqPqxNSIOyZ9hBx1W
         zUyLZuo4fgsNRYgXQZKxWRfSxvk6WJEb88cOLhnf3GczMIAkyawuUaPaTlF6mL8YZIu0
         ebng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BBcKiv8lgJH8WjlVJtIZM3TkArsPsyv5C92UA5FRHXs=;
        b=g3aNgFIEI4YhPx9lvvcAZ/3/DtEvTuxHrf+sSeceeyf6vK5/asw7ApaxGOXEp1nkDT
         a25fe5dkZ7J8xc9E+/zLAnsChEZWpWYH9CaImxCAyoSL8riLnDwq/VvVoiDPVSZSv5jZ
         l3C2v3uwJ8ZuRH+1E9klS9ztL5GKXGWLEw7OxraB3KAX57FbTcLe6HWdVcxdMVotBWA5
         LTTuzTbYY9ql9j0Gv+rE6IAFe9Fewz09nPEBjTGjdMmO2mNjOBWVokWX4dR+VCGGx2hh
         yhsQ8v81WwKRzenQISU38Yu+eUTcPYxAeTgl+2AdvQgRovdNGmcXVNvgqx7XUDqeMgzw
         V55g==
X-Gm-Message-State: APjAAAUvqXVLpiThZF0wtmkaief9bleghIcL4UML90VagxIoypK4gVhY
        F/uBjjE5pT6oPSRRB5pSExQeZnra12ghnHNtyZU=
X-Google-Smtp-Source: APXvYqyCd7iu4khQZCQlX+dIFbtpcqhXVPN0pDXvkkXbmz0eVXjBorf1v9pnGiAP9OQ/zfB7Tak6Cu7CWTOiIMrR8pU=
X-Received: by 2002:a2e:54f:: with SMTP id 76mr1247303ljf.20.1551409484639;
 Thu, 28 Feb 2019 19:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20190204150142.GA3900@jordon-HP-15-Notebook-PC> <CAFqt6zbWPn4H6ArYEecou0Ri79a6hQcYcBo8ZrjPfkxFJUV-UQ@mail.gmail.com>
In-Reply-To: <CAFqt6zbWPn4H6ArYEecou0Ri79a6hQcYcBo8ZrjPfkxFJUV-UQ@mail.gmail.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Fri, 1 Mar 2019 08:34:33 +0530
Message-ID: <CAFqt6zZ=9-xtHg_vuCQ2E+S91G6jD8CcK=Wr-OjYONO4+SnEmg@mail.gmail.com>
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

On Mon, Feb 11, 2019 at 7:42 AM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> On Mon, Feb 4, 2019 at 8:27 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
> >
> > There is no point to continuing assignment after memory allocation
> > failed, rather throw error immediately.
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
>
> Any comment on this patch ?

If no further comment, can we get this patch in queue for 5.1 ?
>
> > ---
> > v1 -> v2:
> >         Corrected typo in change log.
> >
> >  drivers/media/common/videobuf2/videobuf2-vmalloc.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> > index 6dfbd5b..d3f71e2 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> > @@ -46,16 +46,16 @@ static void *vb2_vmalloc_alloc(struct device *dev, unsigned long attrs,
> >
> >         buf->size = size;
> >         buf->vaddr = vmalloc_user(buf->size);
> > -       buf->dma_dir = dma_dir;
> > -       buf->handler.refcount = &buf->refcount;
> > -       buf->handler.put = vb2_vmalloc_put;
> > -       buf->handler.arg = buf;
> >
> >         if (!buf->vaddr) {
> >                 pr_debug("vmalloc of size %ld failed\n", buf->size);
> >                 kfree(buf);
> >                 return ERR_PTR(-ENOMEM);
> >         }
> > +       buf->dma_dir = dma_dir;
> > +       buf->handler.refcount = &buf->refcount;
> > +       buf->handler.put = vb2_vmalloc_put;
> > +       buf->handler.arg = buf;
> >
> >         refcount_set(&buf->refcount, 1);
> >         return buf;
> > --
> > 1.9.1
> >
