Return-Path: <SRS0=PLMr=QB=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96841C282C2
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 04:56:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B15F21872
	for <linux-media@archiver.kernel.org>; Fri, 25 Jan 2019 04:56:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dly1TwWz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfAYE4D (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 23:56:03 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34766 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfAYE4D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 23:56:03 -0500
Received: by mail-lf1-f67.google.com with SMTP id p6so6039498lfc.1;
        Thu, 24 Jan 2019 20:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C/JMwhxLuu6m6SIs9Oh+wPosmqrDzte6hFP2JULDCc4=;
        b=dly1TwWzlEjzTmbOOZejw9fX4Z4HPWT5IuOLxsP492/+AwlNJDJ1r1Hw844+MFqLXp
         VPYrFSKwQtg4qx/peWt31A9iL4OGiMsVv7Bi+6437vD3jzIE059BlpT4KESCt54C3R3l
         /pX0yRxYNoACe/8TSpHJf9oPgqklqHeYhnqkuQQCVaGVhaHclXUPSZ/zduaMsMzrvaIv
         MxeeQtQE4Kx6dV8Z0B8/5UN0eG3l1HLoUqimDKF+XEVEub3djBjjl6QsKc0/mJPkiolB
         si1xaQ+PVQCz+ei9YecLBva1/JN/7o2tgA3IqKKPvUnHW/Q90kYtaFfUe64r72SjYfMx
         F7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C/JMwhxLuu6m6SIs9Oh+wPosmqrDzte6hFP2JULDCc4=;
        b=ZcL1sH9jO6PXcUaj+QaTiGvYZAGDZbHI+TLsrm1bo34QlFQFIweMcZK6uP6cIv7Hjg
         /VxS9oJ6sQj408pDs3St3IJP9AufLwrNHe9ZJC16l8pPOULgJbne2x+996id/hsSg+OM
         I6v9SOakAEC/6eGvmFL4h86pdGPz4JBjTB0r/aQR3S1hdtt/Dh7Tr576xWzfpgq6/yRW
         WLDS/IOEfwWsWB6xPN9GI1czVrNeD0V6NunbjKvTZOT2BfOYBtNM+AVzxZdyDdFc2oDw
         7/CkuTvPO1rM6ABvUHfG8uURNeH8ml1Jbp57h8N4M59cch8orE/kvCmfoJrKgZ5OzYrk
         VPvA==
X-Gm-Message-State: AJcUukdrXddz8KJ/XSHqPJtwmV8iXDnKhPSOK3eTmqFYEoDUX1+TxI6T
        0T27EETsXUhg0EtqDMleeWLsvb52ylTnm1s2I7s=
X-Google-Smtp-Source: ALg8bN5nylAnfJuxiRtrLidx8KwnXBt11+97csnqsltSxWPg39TTO6I88OX5w6LIgwlc5BaJoVIYmQTwoyDX7Am6ql4=
X-Received: by 2002:a19:645b:: with SMTP id b27mr7194430lfj.14.1548392160400;
 Thu, 24 Jan 2019 20:56:00 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190111150806epcas2p4ecaac58547db019e7dc779349d495f4d@epcas2p4.samsung.com>
 <20190111151154.GA2819@jordon-HP-15-Notebook-PC> <241810e0-2288-c59b-6c21-6d853d9fe84a@samsung.com>
In-Reply-To: <241810e0-2288-c59b-6c21-6d853d9fe84a@samsung.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Fri, 25 Jan 2019 10:25:48 +0530
Message-ID: <CAFqt6zbYHq-pS=rGx+3ncJ7rO-LvL5=iOou21oguKjrc=3qouA@mail.gmail.com>
Subject: Re: [PATCH 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range_buggy
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, pawel@osciak.com,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Marek,

On Tue, Jan 22, 2019 at 8:37 PM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Hi Souptick,
>
> On 2019-01-11 16:11, Souptick Joarder wrote:
> > Convert to use vm_insert_range_buggy to map range of kernel memory
> > to user vma.
> >
> > This driver has ignored vm_pgoff. We could later "fix" these drivers
> > to behave according to the normal vm_pgoff offsetting simply by
> > removing the _buggy suffix on the function name and if that causes
> > regressions, it gives us an easy way to revert.
>
> Just a generic note about videobuf2: videobuf2-dma-sg is ignoring vm_pgof=
f by design. vm_pgoff is used as a 'cookie' to select a buffer to mmap and =
videobuf2-core already checks that. If userspace provides an offset, which =
doesn't match any of the registered 'cookies' (reported to userspace via se=
parate v4l2 ioctl), an error is returned.

Ok, it means once the buf is selected, videobuf2-dma-sg should always
mapped buf->pages[i]
from index 0 ( irrespective of vm_pgoff value). So although we are
replacing the code with
vm_insert_range_buggy(), *_buggy* suffix will mislead others and
should not be used.
And if we replace this code with  vm_insert_range(), this will
introduce bug for *non zero*
value of vm_pgoff.

Please correct me if my understanding is wrong.

So what your opinion about this patch ? Shall I drop this patch from
current series ?
or,
There is any better way to handle this scenario ?


>
> > There is an existing bug inside gem_mmap_obj(), where user passed
> > length is not checked against buf->num_pages. For any value of
> > length > buf->num_pages it will end up overrun buf->pages[i],
> > which could lead to a potential bug.

It is not gem_mmap_obj(), it should be vb2_dma_sg_mmap().
Sorry about it.

What about this issue ? Does it looks like a valid issue ?


> >
> > This has been addressed by passing buf->num_pages as input to
> > vm_insert_range_buggy() and inside this API error condition is
> > checked which will avoid overrun the page boundary.
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > ---
> >  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 22 ++++++---------=
-------
> >  1 file changed, 6 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/driver=
s/media/common/videobuf2/videobuf2-dma-sg.c
> > index 015e737..ef046b4 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > @@ -328,28 +328,18 @@ static unsigned int vb2_dma_sg_num_users(void *bu=
f_priv)
> >  static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
> >  {
> >       struct vb2_dma_sg_buf *buf =3D buf_priv;
> > -     unsigned long uaddr =3D vma->vm_start;
> > -     unsigned long usize =3D vma->vm_end - vma->vm_start;
> > -     int i =3D 0;
> > +     int err;
> >
> >       if (!buf) {
> >               printk(KERN_ERR "No memory to map\n");
> >               return -EINVAL;
> >       }
> >
> > -     do {
> > -             int ret;
> > -
> > -             ret =3D vm_insert_page(vma, uaddr, buf->pages[i++]);
> > -             if (ret) {
> > -                     printk(KERN_ERR "Remapping memory, error: %d\n", =
ret);
> > -                     return ret;
> > -             }
> > -
> > -             uaddr +=3D PAGE_SIZE;
> > -             usize -=3D PAGE_SIZE;
> > -     } while (usize > 0);
> > -
> > +     err =3D vm_insert_range_buggy(vma, buf->pages, buf->num_pages);
> > +     if (err) {
> > +             printk(KERN_ERR "Remapping memory, error: %d\n", err);
> > +             return err;
> > +     }
> >
> >       /*
> >        * Use common vm_area operations to track buffer refcount.
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>
