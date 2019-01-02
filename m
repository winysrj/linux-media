Return-Path: <SRS0=KeAI=PK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A14C43387
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 11:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECDE6218D3
	for <linux-media@archiver.kernel.org>; Wed,  2 Jan 2019 11:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="oFMR64yZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfABLQX (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 2 Jan 2019 06:16:23 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53814 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfABLQX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2019 06:16:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iWNPHFJGDvose4o0gtMoXuzRhPa2haLDUxTB7E2ViRQ=; b=oFMR64yZIMtPJ157W43PZ8Vut
        yYFCtJFNWvRsoncQ1rYgSaJyrmYmg/QKnw5zRaY4ZrQ/4LSkx1TpNFgB18/udd7tHBwebjuq/dhdP
        9pSIFhqyT9La6sPKPvziV3Fdgc/GIvzf4vQh/QYFXAgKMowyqmKgSyi0+Tu5zQfQfbLSk=;
Received: from n2100.armlinux.org.uk ([2002:4e20:1eda:1:214:fdff:fe10:4f86]:41072)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1geeVC-0008Av-Qf; Wed, 02 Jan 2019 11:15:58 +0000
Received: from linux by n2100.armlinux.org.uk with local (Exim 4.90_1)
        (envelope-from <linux@n2100.armlinux.org.uk>)
        id 1geeV9-00015W-73; Wed, 02 Jan 2019 11:15:55 +0000
Date:   Wed, 2 Jan 2019 11:15:54 +0000
From:   Russell King - ARM Linux <linux@armlinux.org.uk>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>, pawel@osciak.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, mchehab@kernel.org,
        robin.murphy@arm.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v5 7/9] videobuf2/videobuf2-dma-sg.c: Convert to use
 vm_insert_range
Message-ID: <20190102111553.GG26090@n2100.armlinux.org.uk>
References: <20181224132658.GA22166@jordon-HP-15-Notebook-PC>
 <CAFqt6zZU6c3MyVQpCegntu1ZxtFri=HMwZJ3xg+tCxRARo3zMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqt6zZU6c3MyVQpCegntu1ZxtFri=HMwZJ3xg+tCxRARo3zMA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 02, 2019 at 04:23:15PM +0530, Souptick Joarder wrote:
> On Mon, Dec 24, 2018 at 6:53 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
> >
> > Convert to use vm_insert_range to map range of kernel memory
> > to user vma.
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > Reviewed-by: Matthew Wilcox <willy@infradead.org>
> > Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > ---
> >  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 23 +++++++----------------
> >  1 file changed, 7 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > index 015e737..898adef 100644
> > --- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > +++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
> > @@ -328,28 +328,19 @@ static unsigned int vb2_dma_sg_num_users(void *buf_priv)
> >  static int vb2_dma_sg_mmap(void *buf_priv, struct vm_area_struct *vma)
> >  {
> >         struct vb2_dma_sg_buf *buf = buf_priv;
> > -       unsigned long uaddr = vma->vm_start;
> > -       unsigned long usize = vma->vm_end - vma->vm_start;
> > -       int i = 0;
> > +       unsigned long page_count = vma_pages(vma);
> > +       int err;
> >
> >         if (!buf) {
> >                 printk(KERN_ERR "No memory to map\n");
> >                 return -EINVAL;
> >         }
> >
> > -       do {
> > -               int ret;
> > -
> > -               ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
> > -               if (ret) {
> > -                       printk(KERN_ERR "Remapping memory, error: %d\n", ret);
> > -                       return ret;
> > -               }
> > -
> > -               uaddr += PAGE_SIZE;
> > -               usize -= PAGE_SIZE;
> > -       } while (usize > 0);
> > -
> > +       err = vm_insert_range(vma, vma->vm_start, buf->pages, page_count);
> > +       if (err) {
> > +               printk(KERN_ERR "Remapping memory, error: %d\n", err);
> > +               return err;
> > +       }
> >
> 
> Looking into the original code -
> drivers/media/common/videobuf2/videobuf2-dma-sg.c
> 
> Inside vb2_dma_sg_alloc(),
>            ...
>            buf->num_pages = size >> PAGE_SHIFT;
>            buf->dma_sgt = &buf->sg_table;
> 
>            buf->pages = kvmalloc_array(buf->num_pages, sizeof(struct page *),
>                                                        GFP_KERNEL | __GFP_ZERO);
>            ...
> 
> buf->pages has index upto  *buf->num_pages*.
> 
> now inside vb2_dma_sg_mmap(),
> 
>            unsigned long usize = vma->vm_end - vma->vm_start;
>            int i = 0;
>            ...
>            do {
>                  int ret;
> 
>                  ret = vm_insert_page(vma, uaddr, buf->pages[i++]);
>                  if (ret) {
>                            printk(KERN_ERR "Remapping memory, error:
> %d\n", ret);
>                            return ret;
>                  }
> 
>                 uaddr += PAGE_SIZE;
>                 usize -= PAGE_SIZE;
>            } while (usize > 0);
>            ...
> is it possible for any value of  *i  > (buf->num_pages)*,
> buf->pages[i] is going to overrun the page boundary ?

Yes it is, and you've found an array-overrun condition that is
triggerable from userspace - potentially non-root userspace too.
Depending on what it can cause to be mapped without oopsing the
kernel, it could be very serious.  At best, it'll oops the kernel.
At worst, it could expose pages of memory that userspace should
not have access to.

This is why I've been saying that we need a helper that takes the
_object_ and the user request, and does all the checking internally,
so these kinds of checks do not get overlooked.

A good API is one that helpers authors avoid bugs.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
