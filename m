Return-Path: <SRS0=XPZo=QL=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3695CC169C4
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 02:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED9E82083B
	for <linux-media@archiver.kernel.org>; Mon,  4 Feb 2019 02:03:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ESoUPn4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfBDCDs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 21:03:48 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:38745 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfBDCDs (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2019 21:03:48 -0500
Received: by mail-lj1-f195.google.com with SMTP id c19-v6so10284365lja.5;
        Sun, 03 Feb 2019 18:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Gncej+KcUYuYj1aFvSCSQuzMHP7ZhTohfMMS6cAUBGE=;
        b=ESoUPn4taaRm8lQk52gOmZYbr/rGaM6LeWHh4R44bV6qY6qjNYS+3naQLdps0GkOcZ
         C9QuvOwaklrgkmFQ9/I3EOAK7XXyuspK2THe/T3HdE7g5gjxf4V7I4dpQBNqqKGOH3Gq
         C+GpQEI5sbqQBqZe/UtECaBi6xODiI8ukv1eAcdVqhgKqlf+N63iPEvmBxrQqQXK+8xP
         bPSCmX0IyjZSJOFI/EQKKlok2CkSjn+1wMvh51Ev7dtJ0a5qvxsoRI98SHfxH0dp8OAl
         bxPpKErTamzGqlJ8RmWtzQpf8N6pq19bICxhwaZ/K083rmIwfhVSTEdIMLVKeitCSpe8
         5zpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Gncej+KcUYuYj1aFvSCSQuzMHP7ZhTohfMMS6cAUBGE=;
        b=bFP2AYE18BTqxQsKo9eXLLsKTmNNdeQjpHJbUFmp7t9Utuj34JDg7203egZi6JIG2e
         TlmyKnvaUjuyprFbFaCJdDINb0ULaWlGgqm71TxD1WbsG/BzzcvX0a8msP3DWEAmvq5t
         qaFeXlR5dEAUh4HFIqnDsKZfXhI1qU9eO4zivUwdVpt7IDpJf8B1J2RiiEBfvvBv97ii
         xihggtJ4pMJOSpHp+ns54yGr6o6S6aG/2LZVK5LYGPms0/ZE2dFlmJ3UcPY3vSKzhHjD
         BKH7KrXLwVjOBDt3XhZ6eF+VmsTUnepcXe4gWZDVY2pXJ3R38nji4Qptb1AR1+IRqEZZ
         VfXQ==
X-Gm-Message-State: AJcUukdfoKiADbiN+GcVlkjdC4yFYLDmLWtyCuluAjuzTOx4ljrq9+Gd
        ZVVekuxpCJjhrxiEIOEn4dKY0axY0PhssJrScHQ=
X-Google-Smtp-Source: ALg8bN4F4uZCG3X+K2T25QC8fAvFVxv00Py50e0mUzbbxZKdQCaQ0RUhG8yRz4edH7vyCfMTAAiAkz7oj3Vwt8HH4/Q=
X-Received: by 2002:a05:651c:14e:: with SMTP id c14mr39042574ljd.20.1549245825736;
 Sun, 03 Feb 2019 18:03:45 -0800 (PST)
MIME-Version: 1.0
References: <20190203133608.GA26010@jordon-HP-15-Notebook-PC> <22f10cf289b8115fa9e60f89edc24ec2cf0f676d.camel@ndufresne.ca>
In-Reply-To: <22f10cf289b8115fa9e60f89edc24ec2cf0f676d.camel@ndufresne.ca>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Mon, 4 Feb 2019 07:33:37 +0530
Message-ID: <CAFqt6zYZ4y3jPAHaRxdx1pBngo7NoOHnNzZhU_5D5tvKxejUDw@mail.gmail.com>
Subject: Re: [PATCH] media: videobuf2: Return error after allocation failure
To:     Nicolas Dufresne <nicolas@ndufresne.ca>
Cc:     pawel@osciak.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sabyasachi Gupta <sabyasachi.linux@gmail.com>,
        Brajeswar Ghosh <brajeswar.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Mon, Feb 4, 2019 at 3:25 AM Nicolas Dufresne <nicolas@ndufresne.ca> wrot=
e:
>
> Le dimanche 03 f=C3=A9vrier 2019 =C3=A0 19:06 +0530, Souptick Joarder a =
=C3=A9crit :
> > There is no point to continuing assignemnt after memory allocation
>
> assignemnt -> assignment.

Ah, type.
>
> > failed, rather throw error immediately.
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > ---
> >  drivers/media/common/videobuf2/videobuf2-vmalloc.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/common/videobuf2/videobuf2-vmalloc.c b/drive=
rs/media/common/videobuf2/videobuf2-vmalloc.c
> > index 6dfbd5b..d3f71e2 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-vmalloc.c
> > @@ -46,16 +46,16 @@ static void *vb2_vmalloc_alloc(struct device *dev, =
unsigned long attrs,
> >
> >       buf->size =3D size;
> >       buf->vaddr =3D vmalloc_user(buf->size);
> > -     buf->dma_dir =3D dma_dir;
> > -     buf->handler.refcount =3D &buf->refcount;
> > -     buf->handler.put =3D vb2_vmalloc_put;
> > -     buf->handler.arg =3D buf;
> >
> >       if (!buf->vaddr) {
> >               pr_debug("vmalloc of size %ld failed\n", buf->size);
> >               kfree(buf);
> >               return ERR_PTR(-ENOMEM);
> >       }
> > +     buf->dma_dir =3D dma_dir;
> > +     buf->handler.refcount =3D &buf->refcount;
> > +     buf->handler.put =3D vb2_vmalloc_put;
> > +     buf->handler.arg =3D buf;
> >
> >       refcount_set(&buf->refcount, 1);
> >       return buf;
>
