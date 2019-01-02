Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E791C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 15:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D724D2171F
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 15:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="umkUwBVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbfABPsr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 10:48:47 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:43286 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfABPsr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 10:48:47 -0500
Received: by mail-lj1-f193.google.com with SMTP id q2-v6so27324796lji.10;
        Wed, 02 Jan 2019 07:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IJHL/z8fAJRE9Iyf8aCknufDky6L83+nNxnmSNmWUL0=;
        b=umkUwBVIN/yYk5VwfS+MFZuorx2FzrD4Ze8CM4JeoYDHkxfZVPYebJlrJjnTp31bzJ
         AHyYuoq0NXSLLnJ4Re5PjaIZin8goaV7udqBZlTV1dFLZjHnDPcocwxp89M9MBSmKiU4
         4EFxApWVdmqBEDoxVHxbdHxO+6zwE6Az5P4Rq6Tl+48rQPsUn/xFZVOSSCbcbbbO1XNi
         RZ69pUN3T8cFQelu1sY+YuZokaNt/BIufx9VkrqbfrDKtJ3fjqWHOY8NJORHNkjryw/4
         swnyr/5PaEMVABHNSCWzKb+7OQJq0uN7GaBYc9b41jzAsNZ2exlajrGZheN08nXSq0SX
         M3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IJHL/z8fAJRE9Iyf8aCknufDky6L83+nNxnmSNmWUL0=;
        b=LrDA593DZ+2wRmC9jmyXTGa2DukxpLif1IBpuc77GUjxF5SSeDSeTvDf10hu6xrndu
         /YnKIk1MLcbZl7RgQyf7v4aNUrV7k1F7ios0nSZXXY4pNmjQ89TdhMfL4HLcIaiuYaSo
         W0n0XMF4eD7e1be8ttHpGf70zh6MQNDVU4dljDwvoikr/m5feKE3haUt9XvPG7i/Lu6M
         mmAWXTeiFSYeY3QzE6dWFXYwY00XHWkofOtT8mk2KGb+vwc4jXytx0+KGrS1On+8CaQz
         pT11u2wEKvhenUEK5af8Hc0JEEkzs9HX3BxBQnwNvRSObFU+w21mrVSPoWtTR1ChPKI7
         1ySw==
X-Gm-Message-State: AJcUukfhjcnxcaFoE+Yw6BN4vW0pWIe4sVWLEHLZg5JK6yh6OreIRLjA
        7ivBx7X55bjOhwuGgAN6/FhQ03D0gk5ITZaDFEs=
X-Google-Smtp-Source: ALg8bN6ZMhgMMSVTgm4KwPh+JHX95y+LJ/UlD3B0Q2we2PeXB5w2/dx1ar5vX/RQEzZ8FO+3P2kJNezF7K/5a/X45JI=
X-Received: by 2002:a2e:9c52:: with SMTP id t18-v6mr20634319ljj.149.1546444124257;
 Wed, 02 Jan 2019 07:48:44 -0800 (PST)
MIME-Version: 1.0
References: <20181224132658.GA22166@jordon-HP-15-Notebook-PC>
 <CAFqt6zZU6c3MyVQpCegntu1ZxtFri=HMwZJ3xg+tCxRARo3zMA@mail.gmail.com> <20190102111553.GG26090@n2100.armlinux.org.uk>
In-Reply-To: <20190102111553.GG26090@n2100.armlinux.org.uk>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 2 Jan 2019 21:22:34 +0530
Message-ID: <CAFqt6zadJ-4xh256BqzALnGY31nDAU=5XwUaSaz5OcJuOc7Bfg@mail.gmail.com>
Subject: Re: [PATCH v5 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range
To:     Russell King - ARM Linux <linux@armlinux.org.uk>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, pawel@osciak.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        robin.murphy@arm.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 2, 2019 at 4:46 PM Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jan 02, 2019 at 04:23:15PM +0530, Souptick Joarder wrote:
> > On Mon, Dec 24, 2018 at 6:53 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
> > >
> > > Convert to use vm_insert_range to map range of kernel memory
> > > to user vma.
> > >
> > > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > > Reviewed-by: Matthew Wilcox <willy@infradead.org>
> > > Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > > ---
> > >  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 +++++++----------------
> > >  1 file changed, 7 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > index 015e737..898adef 100644
> > > --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > > @@ -328,28 +328,19 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
> > >  static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
> > >  {
> > >         struct vb2_dma_sg_buf *buf = buf_priv;
> > > -       unsigned long uaddr = vma->vm_start;
> > > -       unsigned long usize = vma->vm_end - vma->vm_start;
> > > -       int i = 0;
> > > +       unsigned long page_count = vma_pages(vma);
> > > +       int err;
> > >
> > >         if (!buf) {
> > >                 printk(KERN_ERR "No memory to map\n");
> > >                 return -EINVAL;
> > >         }
> > >
> > > -       do {
> > > -               int ret;
> > > -
> > > -               ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
> > > -               if (ret) {
> > > -                       printk(KERN_ERR "Remapping memory, error: %d\n", ret);
> > > -                       return ret;
> > > -               }
> > > -
> > > -               uaddr += PAGE_SIZE;
> > > -               usize -= PAGE_SIZE;
> > > -       } while (usize > 0);
> > > -
> > > +       err = vm_insert_range(vma, vma->vm_start, buf->pages, page_count);
> > > +       if (err) {
> > > +               printk(KERN_ERR "Remapping memory, error: %d\n", err);
> > > +               return err;
> > > +       }
> > >
> >
> > Looking into the original code -
> > drivers/media/common/videobuf2/videobuf2-dma-sg.c
> >
> > Inside vb2_dma_sg_alloc(),
> >            ...
> >            buf->num_pages = size >> PAGE_SHIFT;
> >            buf->dma_sgt = &buf->sg_table;
> >
> >            buf->pages = kvmalloc_array(buf->num_pages, sizeof(struct page *),
> >                                                        GFP_KERNEL | __GFP_ZERO);
> >            ...
> >
> > buf->pages has index upto  *buf->num_pages*.
> >
> > now inside vb2_dma_sg_mmap(),
> >
> >            unsigned long usize = vma->vm_end - vma->vm_start;
> >            int i = 0;
> >            ...
> >            do {
> >                  int ret;
> >
> >                  ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
> >                  if (ret) {
> >                            printk(KERN_ERR "Remapping memory, error:
> > %d\n", ret);
> >                            return ret;
> >                  }
> >
> >                 uaddr += PAGE_SIZE;
> >                 usize -= PAGE_SIZE;
> >            } while (usize > 0);
> >            ...
> > is it possible for any value of  *i  > (buf->num_pages)*,
> > buf->pages[i] is going to overrun the page boundary ?
>
> Yes it is, and you've found an array-overrun condition that is
> triggerable from userspace - potentially non-root userspace too.
> Depending on what it can cause to be mapped without oopsing the
> kernel, it could be very serious.  At best, it'll oops the kernel.
> At worst, it could expose pages of memory that userspace should
> not have access to.
>
> This is why I've been saying that we need a helper that takes the
> _object_ and the user request, and does all the checking internally,
> so these kinds of checks do not get overlooked.

ok, while replacing this code with the suggested vm_insert_range_buggy(),
we could fixed this issue.


>
> A good API is one that helpers authors avoid bugs.
>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
