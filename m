Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44896C169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06E6D2075C
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 17:02:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dycem5Iy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbfBKRCJ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 12:02:09 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:44091 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727117AbfBKRCI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 12:02:08 -0500
Received: by mail-lf1-f66.google.com with SMTP id g2so3041110lfh.11;
        Mon, 11 Feb 2019 09:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhMN5gACQr1+W4A8Ag5wPDh62RaNjK/ZgHm434PrC78=;
        b=Dycem5Iy15XhBFQsCdrlyR70cVYi8iEHdjbiM68ElBqd2AuRvAsNQVBPszRVGhzOes
         4ghWIEDaZJqjwIvPAoy9X2DP7JqHWi80tnUpOlPWlpZ1uM1s61kbY33b7oQI39GLLDGn
         E61Ey9sXAEhgkUTxWs3YjJn/cr2UtlFvIsMQptsivCA4qcu2lBVw1mBwHXi14ZhLqfZT
         llfzt7bn5yuGTsb/KDKH+rY6A+TOjuCAl9E0Djzyw3HMlvO3y65at592q5FsX1KdRYDL
         KORq40gRwIB8Akjia616vJ//3AM1qSrbGnqfQtj9Zf7Jn60umhLieOoHQwDpAo7mMfoP
         LsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhMN5gACQr1+W4A8Ag5wPDh62RaNjK/ZgHm434PrC78=;
        b=otaoBI5wxF8HAarKjPoudnYKco5KDIpo5O2aUlXzN+iZLrU4sdA+csJAauoTSM9o49
         HcdTZtn828YhwMPETdJv1xaTPZ5Q9Dov8JXelru6CbZHSB1JFocwXBpUgPiAZRfLwp8g
         2gMtoA376bANKqV4FqD5SKpYIVkwzejAbeWVicRkGZfMdMoxCbl6LN7ucLKUVlYKbvC9
         GraBu1fnJ+bCXPm9drh5649hn8yHepe6QqlpEq9gu+r5FnGgCLNGzHvwRnQThRL5xV8H
         D9s8MEcFj1Ezjo8QW7F4deRZGA6xHBwdO30r68k+lnQ+xgsW2Iq6Z0T5HRxb9YLJDeMz
         55xg==
X-Gm-Message-State: AHQUAuaGlpia1gFDZ0NEgopHekh93ghGJjp0dySHtm9bZ17PcqXFHCls
        rPDrkbsDz0YH3Bzb8G3LBE77eqwNrSWLUOTxrRw=
X-Google-Smtp-Source: AHgI3IalfbXEC0ubkiPvBEKZp244GmIb+2indUy8ujEZOIJyFGOHcxcPXDTtIiBWV4qDRv6rjSWWM0OTaxXYOKcGqoU=
X-Received: by 2002:ac2:4318:: with SMTP id l24mr631387lfh.75.1549904525499;
 Mon, 11 Feb 2019 09:02:05 -0800 (PST)
MIME-Version: 1.0
References: <20190131030812.GA2174@jordon-HP-15-Notebook-PC>
 <20190131083842.GE28876@rapoport-lnx> <CAFqt6za9xA_8OKiaaHXcO9go+RtPdjLY5Bz_fgQL+DZbermNhA@mail.gmail.com>
 <20190207164739.GX21860@bombadil.infradead.org> <CAFqt6zawBP5Yyy7nfoKz_6ugw8e4MVopvBaeKvaKoXcS-_oSNg@mail.gmail.com>
In-Reply-To: <CAFqt6zawBP5Yyy7nfoKz_6ugw8e4MVopvBaeKvaKoXcS-_oSNg@mail.gmail.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Mon, 11 Feb 2019 22:36:15 +0530
Message-ID: <CAFqt6zYGSn1dA8tdiH16Mq0bzkx5DmpUo+2RUZ0nTPm+nvZS7Q@mail.gmail.com>
Subject: Re: [PATCHv2 1/9] mm: Introduce new vm_insert_range and
 vm_insert_range_buggy API
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        vbabka@suse.cz, Rik van Riel <riel@surriel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        rppt@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com, iamjoonsoo.kim@lge.com, treding@nvidia.com,
        Kees Cook <keescook@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        stefanr@s5r6.in-berlin.de, hjc@rock-chips.com,
        Heiko Stuebner <heiko@sntech.de>, airlied@linux.ie,
        oleksandr_andrushchenko@epam.com, joro@8bytes.org,
        pawel@osciak.com, Kyungmin Park <kyungmin.park@samsung.com>,
        mchehab@kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>,
        linux-arm-kernel@lists.infradead.org,
        linux1394-devel@lists.sourceforge.net,
        dri-devel@lists.freedesktop.org,
        linux-rockchip@lists.infradead.org, xen-devel@lists.xen.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Fri, Feb 8, 2019 at 10:52 AM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> On Thu, Feb 7, 2019 at 10:17 PM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Thu, Feb 07, 2019 at 09:19:47PM +0530, Souptick Joarder wrote:
> > > Just thought to take opinion for documentation before placing it in v3.
> > > Does it looks fine ?
> > >
> > > +/**
> > > + * __vm_insert_range - insert range of kernel pages into user vma
> > > + * @vma: user vma to map to
> > > + * @pages: pointer to array of source kernel pages
> > > + * @num: number of pages in page array
> > > + * @offset: user's requested vm_pgoff
> > > + *
> > > + * This allow drivers to insert range of kernel pages into a user vma.
> > > + *
> > > + * Return: 0 on success and error code otherwise.
> > > + */
> > > +static int __vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> > > +                               unsigned long num, unsigned long offset)
> >
> > For static functions, I prefer to leave off the second '*', ie make it
> > formatted like a docbook comment, but not be processed like a docbook
> > comment.  That avoids cluttering the html with descriptions of internal
> > functions that people can't actually call.
> >
> > > +/**
> > > + * vm_insert_range - insert range of kernel pages starts with non zero offset
> > > + * @vma: user vma to map to
> > > + * @pages: pointer to array of source kernel pages
> > > + * @num: number of pages in page array
> > > + *
> > > + * Maps an object consisting of `num' `pages', catering for the user's
> >
> > Rather than using `num', you should use @num.
> >
> > > + * requested vm_pgoff
> > > + *
> > > + * If we fail to insert any page into the vma, the function will return
> > > + * immediately leaving any previously inserted pages present.  Callers
> > > + * from the mmap handler may immediately return the error as their caller
> > > + * will destroy the vma, removing any successfully inserted pages. Other
> > > + * callers should make their own arrangements for calling unmap_region().
> > > + *
> > > + * Context: Process context. Called by mmap handlers.
> > > + * Return: 0 on success and error code otherwise.
> > > + */
> > > +int vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> > > +                               unsigned long num)
> > >
> > >
> > > +/**
> > > + * vm_insert_range_buggy - insert range of kernel pages starts with zero offset
> > > + * @vma: user vma to map to
> > > + * @pages: pointer to array of source kernel pages
> > > + * @num: number of pages in page array
> > > + *
> > > + * Similar to vm_insert_range(), except that it explicitly sets @vm_pgoff to
> >
> > But vm_pgoff isn't a parameter, so it's misleading to format it as such.
> >
> > > + * 0. This function is intended for the drivers that did not consider
> > > + * @vm_pgoff.
> > > + *
> > > + * Context: Process context. Called by mmap handlers.
> > > + * Return: 0 on success and error code otherwise.
> > > + */
> > > +int vm_insert_range_buggy(struct vm_area_struct *vma, struct page **pages,
> > > +                               unsigned long num)
> >
> > I don't think we should call it 'buggy'.  'zero' would make more sense
> > as a suffix.
>
> suffix can be *zero or zero_offset* whichever suits better.
>
> >
> > Given how this interface has evolved, I'm no longer sure than
> > 'vm_insert_range' makes sense as the name for it.  Is it perhaps
> > 'vm_map_object' or 'vm_map_pages'?
> >
>
> I prefer vm_map_pages. Considering it, both the interface name can be changed
> to *vm_insert_range -> vm_map_pages* and *vm_insert_range_buggy ->
> vm_map_pages_{zero/zero_offset}.
>
> As this is only change in interface name and rest of code remain same
> shall I post it in v3 ( with additional change log mentioned about interface
> name changed) ?
>
> or,
>
> It will be a new patch series ( with carry forward all the Reviewed-by
> / Tested-by on
> vm_insert_range/ vm_insert_range_buggy ) ?

Any suggestion on this minor query ?
