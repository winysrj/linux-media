Return-Path: <SRS0=uIFo=QO=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8521CC282C2
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 16:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A1062175B
	for <linux-media@archiver.kernel.org>; Thu,  7 Feb 2019 16:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GjiAT/gI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfBGQDD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Feb 2019 11:03:03 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46751 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfBGQDD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2019 11:03:03 -0500
Received: by mail-lj1-f193.google.com with SMTP id v15-v6so267541ljh.13;
        Thu, 07 Feb 2019 08:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XbhO6aTIpP/xPNM6je9v7tcpC/w9vjx4259+gRxRQwc=;
        b=GjiAT/gIsh5Mq6FaeJOcXRPVS+aPNNLKdv+19jCUnMwmRGIdhLqn3qDw/4sBtvN8Hh
         ju5PXYuad3zjRdl4YnH6xybt7cBkrbmeOnKARIuUOVU23QxAGpMC+Hdo6To4YYz20SdN
         KcTwZZWk54YH7U7nqUwLwSjiM9GATvQyhZUXP3zIoYmhVtPcGhqivpfFt5hrHNrlLnxo
         tIyWz8GH0zeVk4l5jxYZ+30lNxdS11GYkmxBwZke/ifmkSt1cGDnrqxpSjof3u8Ym6Qe
         fsNkAS4OqyhqNSBKMi847x/GuItYvXS/zeCBaX1OV5BcJ5lVqZztpXRUYwokbPHyzTQT
         Yr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XbhO6aTIpP/xPNM6je9v7tcpC/w9vjx4259+gRxRQwc=;
        b=dJCMO7DFrj/7ZWcVeZp/R/NDb54hpPlQ28PjSMsY8ufZATd+ULl+iYEaWYp2EX8kdR
         I4/yjNB3h9qIqNx9OupBUggnYuMqxkyBuemH5+hfNpxcWdmO3kyeliz/lMHz9HL/2xgV
         fLrw4QDJIcdLH8ghEDy4e49X6Df9hNEJWUeXZi1l0X/8YTvDJ6wc1Ctr07EvufUWsbvF
         aNTxqcgQDXQXTQ67qQ6KSakcnpBIDjXIC8HJ8VFoH0+1y1yXT6BSzsIRCtk2NppDKaqD
         bziCZz1xrlyaz6ZuBdIuvP1cZ0+t1XXrCq+KNQ+1UzZNERF6CwQvvYNfREKH9nR5CL/5
         cq9g==
X-Gm-Message-State: AHQUAub+W0EgHrE3WIMhaSVGOeHVvG1avIqNtyrJu/xLaIKO2p2w/h3h
        mKQX+W0SkFfdgszxMMVhBacmmMqD9sDmA+t1J8Y=
X-Google-Smtp-Source: AHgI3IaLErP6UQHRoJXwjaGn0+byhpg0FJEkJj8lu4LnRPheskg9h3w2v7B+w3vp6ap3L+ni8MOMEGmZGFdfVJFI55k=
X-Received: by 2002:a2e:858e:: with SMTP id b14-v6mr2729099lji.43.1549555380735;
 Thu, 07 Feb 2019 08:03:00 -0800 (PST)
MIME-Version: 1.0
References: <20190131030812.GA2174@jordon-HP-15-Notebook-PC>
 <20190131083842.GE28876@rapoport-lnx> <CAFqt6za9xA_8OKiaaHXcO9go+RtPdjLY5Bz_fgQL+DZbermNhA@mail.gmail.com>
 <20190207155700.GA8040@rapoport-lnx>
In-Reply-To: <20190207155700.GA8040@rapoport-lnx>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Thu, 7 Feb 2019 21:37:08 +0530
Message-ID: <CAFqt6zbE0JD09ibp3jZ0rr5xp52SEK+Pi6pGMQwSp_=d0edy7g@mail.gmail.com>
Subject: Re: [PATCHv2 1/9] mm: Introduce new vm_insert_range and
 vm_insert_range_buggy API
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
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

On Thu, Feb 7, 2019 at 9:27 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> Hi Souptick,
>
> On Thu, Feb 07, 2019 at 09:19:47PM +0530, Souptick Joarder wrote:
> > Hi Mike,
> >
> > Just thought to take opinion for documentation before placing it in v3.
> > Does it looks fine ?
>
> Overall looks good to me. Several minor points below.

Thanks Mike. Noted.
Shall I consider it as *Reviewed-by:* with below changes ?

>
> > +/**
> > + * __vm_insert_range - insert range of kernel pages into user vma
> > + * @vma: user vma to map to
> > + * @pages: pointer to array of source kernel pages
> > + * @num: number of pages in page array
> > + * @offset: user's requested vm_pgoff
> > + *
> > + * This allow drivers to insert range of kernel pages into a user vma.
>
>           allows
> > + *
> > + * Return: 0 on success and error code otherwise.
> > + */
> > +static int __vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> > +                               unsigned long num, unsigned long offset)
> >
> >
> > +/**
> > + * vm_insert_range - insert range of kernel pages starts with non zero offset
> > + * @vma: user vma to map to
> > + * @pages: pointer to array of source kernel pages
> > + * @num: number of pages in page array
> > + *
> > + * Maps an object consisting of `num' `pages', catering for the user's
>                                    @num pages
> > + * requested vm_pgoff
> > + *
> > + * If we fail to insert any page into the vma, the function will return
> > + * immediately leaving any previously inserted pages present.  Callers
> > + * from the mmap handler may immediately return the error as their caller
> > + * will destroy the vma, removing any successfully inserted pages. Other
> > + * callers should make their own arrangements for calling unmap_region().
> > + *
> > + * Context: Process context. Called by mmap handlers.
> > + * Return: 0 on success and error code otherwise.
> > + */
> > +int vm_insert_range(struct vm_area_struct *vma, struct page **pages,
> > +                               unsigned long num)
> >
> >
> > +/**
> > + * vm_insert_range_buggy - insert range of kernel pages starts with zero offset
> > + * @vma: user vma to map to
> > + * @pages: pointer to array of source kernel pages
> > + * @num: number of pages in page array
> > + *
> > + * Similar to vm_insert_range(), except that it explicitly sets @vm_pgoff to
>
>                                                                   the offset
>
> > + * 0. This function is intended for the drivers that did not consider
> > + * @vm_pgoff.
> > + *
> > + * Context: Process context. Called by mmap handlers.
> > + * Return: 0 on success and error code otherwise.
> > + */
> > +int vm_insert_range_buggy(struct vm_area_struct *vma, struct page **pages,
> > +                               unsigned long num)
> >
>
> --
> Sincerely yours,
> Mike.
>
