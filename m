Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC02C64EB1
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 19:24:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 612CB208E7
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 19:24:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZtJu/QZl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 612CB208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbeLGTYw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 14:24:52 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:36037 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbeLGTYw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 14:24:52 -0500
Received: by mail-lj1-f196.google.com with SMTP id g11-v6so4505625ljk.3;
        Fri, 07 Dec 2018 11:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9e2Wbzrvdn8hVT2tBhxVO0pp+kL6y3jwcx1ShpPzbP4=;
        b=ZtJu/QZlyw3bilEm8S9OjKcAaFKDl8uywXIJPv9AXBWu7HUv1lNYCsoq8HAKttktyj
         ssHKnjWFm75vcL1BkZR6S/HWT1LqZybi7PHlkHL5Gvyu1SX4Uv1WAY8o1yT5uIo9VnZY
         vpOujufXZQzDptqRH68QItFYzJLEfbo/l0kXvHSgZyTb5d9yGcnluZTEBxPSiF6Wi/i4
         D6LdrFTq9B6gKKkFc0wmIOsj7KboFS7ojG0/UP5B4tBFQo0EL188h8Sw6mlpJOBVvYHm
         xlWaL+qNVtOLh6aLFsUD9mklVCrvNKlMW5i3EgHUUglppRWtsj4/Ahh5Kyf5lDmFczee
         iefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9e2Wbzrvdn8hVT2tBhxVO0pp+kL6y3jwcx1ShpPzbP4=;
        b=kJ72Wy4R5gGZMb2FARKL2KHZXNA2Ad2+BdgsezZtjkQlscUaAA6kn+u/H0NxjCQP4h
         0Efp3DTuCvoH1c2rmfHtcgDBRuBqAgaF6Zjjy/Pk8moKrQUvDVdh1htkXa1oZ1PzETfX
         PQpj4zDNg80e6bBUVBDYiieTrrB23BDVM7/IJfZGg7yB6oLCQ9ZJpxQHZN+fPnqQV6rK
         mFerVGN7FmXpeU719Fl0Cykp9JIXrRbUb6doIaps7r4c0Yqpzq50OMVXl9VDRPPqyDl8
         zp8SPY5Ku3ZZz/cjK6neou34VG9hIrRvBOmLOnHHQ5a2v8SItdmQ5E6141jUoLk9Km9q
         2CKA==
X-Gm-Message-State: AA+aEWb9banlCA8CB5patTNbo/JJM7ah6vY1PzgVDJsdlbOdT/zTdIn8
        oc66UBVxF2oIdqnxAnbFmfhK+QXGovaZGXvGPGE=
X-Google-Smtp-Source: AFSGD/XIzVoTRj76yRnUtycSWUcaUvahf5IXbuO2knQ2ryaj0PDXh4XL9bWH40gRgXnet7zbl7DHlrkXUU8kk86yIgw=
X-Received: by 2002:a2e:9181:: with SMTP id f1-v6mr2058524ljg.64.1544210689938;
 Fri, 07 Dec 2018 11:24:49 -0800 (PST)
MIME-Version: 1.0
References: <20181206183945.GA20932@jordon-HP-15-Notebook-PC>
 <53bbc095-c9f5-5d6a-6e50-6e060d17eb68@arm.com> <20181207171116.GA29923@bombadil.infradead.org>
In-Reply-To: <20181207171116.GA29923@bombadil.infradead.org>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Sat, 8 Dec 2018 00:58:26 +0530
Message-ID: <CAFqt6zYCWOK-uS85GqCzcgT=+YKn1nBrRPq+M9y6eJjmXEKH+g@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] mm: Introduce new vm_insert_range API
To:     Matthew Wilcox <willy@infradead.org>
Cc:     robin.murphy@arm.com, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        vbabka@suse.cz, Rik van Riel <riel@surriel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        rppt@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        iamjoonsoo.kim@lge.com, treding@nvidia.com,
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

On Fri, Dec 7, 2018 at 10:41 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Dec 07, 2018 at 03:34:56PM +0000, Robin Murphy wrote:
> > > +int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
> > > +                   struct page **pages, unsigned long page_count)
> > > +{
> > > +   unsigned long uaddr = addr;
> > > +   int ret = 0, i;
> >
> > Some of the sites being replaced were effectively ensuring that vma and
> > pages were mutually compatible as an initial condition - would it be worth
> > adding something here for robustness, e.g.:
> >
> > +     if (page_count != vma_pages(vma))
> > +             return -ENXIO;
>
> I think we want to allow this to be used to populate part of a VMA.
> So perhaps:
>
>         if (page_count > vma_pages(vma))
>                 return -ENXIO;

Ok, This can be added.

I think Patch [2/9] is the only leftover place where this
check could be removed.
