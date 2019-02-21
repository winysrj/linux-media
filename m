Return-Path: <SRS0=PlsX=Q4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024D5C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 02:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7C3A2086C
	for <linux-media@archiver.kernel.org>; Thu, 21 Feb 2019 02:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RRDQaL2Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfBUCgw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 21:36:52 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46991 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfBUCgw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 21:36:52 -0500
Received: by mail-lj1-f194.google.com with SMTP id v16so22592231ljg.13;
        Wed, 20 Feb 2019 18:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IhT33+ZuZhnclLJtzrgLTvsh568OJwgxzHtt6EZoeoE=;
        b=RRDQaL2Yr6th/tcc24ot1sRaI12xLnsOT26YVojzv6FLlBcPV4BZH7qKQYvXQRy0Ml
         xgHyh6bj9Xh4TnWOM//4cBWzFemxAhb+kUIo9tDssoivn0Hz/a7DNF7QkegBx20FAGCg
         YrkJeugdrrurdNvVCq5U1ghRK5uazu7WJejHQMyH1vDR0zb8y17em07zw1XqXQITvj8d
         Uf+f//sKtQqL8efMFlzW9j7KhEfvhhELp4ufj6w5q4pFpnciIRQPovl0FYOKzk9JzEti
         ZDqfX/rsuBnEGNqhZ3nCqJTwA7Q1wucr7yMhsychbrwxfUa5c4tLfu9P7jCmXg/ZYdVn
         gtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IhT33+ZuZhnclLJtzrgLTvsh568OJwgxzHtt6EZoeoE=;
        b=WcnZAOo8xsa14psV/TV4hYQeWmT0NBRhMLiHSIf1bD7EeayWdvr0PFtciuSvlcN0QY
         mK8a+NpZbwovdiaiYUcV9DsFA747uOvdIqf6t9Q1N5bEr2j6vzYi1xv6R7+3NmYFsH4/
         5Xi8gY3Ubcmp72KrBkPbEl7vyd6YpCBUHi7dkT2aBlkLOgP6JDRmonCplKqPkaX4Zz47
         h5YmdEMqNoQqjYvdjnGd1ZQPmgARHKkTpn5XS1ihHmwf0OV6EIZ4puIehT6MFv81n7Xd
         M2R1R36wMq+NMU30WzxNEEDcleEklQnzQR/+e0Zj8estA2de61MuO+zdDvHut20Jms1l
         A+Mw==
X-Gm-Message-State: AHQUAuYRzO1myBpBGnCGjZqCj9QLN8RLqaYEx+lZH/WNtfv8rMMyjlk5
        pQe+s+1Ofm4zccWtpjRewEB6EHph+9/3RyMUOoA=
X-Google-Smtp-Source: AHgI3IahDoLmYSzyXftmcGNCvk1lLmWsiwGhF2S+3m4XfLJICiUO5nC5rltmz2rH5SPgMvCWKXFIHyOjBjhd24YBdDM=
X-Received: by 2002:a2e:9b99:: with SMTP id z25mr13905243lji.106.1550716608824;
 Wed, 20 Feb 2019 18:36:48 -0800 (PST)
MIME-Version: 1.0
References: <20190215024104.GA26331@jordon-HP-15-Notebook-PC>
In-Reply-To: <20190215024104.GA26331@jordon-HP-15-Notebook-PC>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Thu, 21 Feb 2019 08:11:02 +0530
Message-ID: <CAFqt6zbchvoD-MdEF2T52eOPQ2x4gZ4G-72oZkW5f_RiT1nXpA@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] mm: Use vm_map_pages() and vm_map_pages_zero() API
To:     Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Rik van Riel <riel@surriel.com>,
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
        Juergen Gross <jgross@suse.com>
Cc:     linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
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

On Fri, Feb 15, 2019 at 8:06 AM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> Previouly drivers have their own way of mapping range of
> kernel pages/memory into user vma and this was done by
> invoking vm_insert_page() within a loop.
>
> As this pattern is common across different drivers, it can
> be generalized by creating new functions and use it across
> the drivers.
>
> vm_map_pages() is the API which could be used to map
> kernel memory/pages in drivers which has considered vm_pgoff.
>
> vm_map_pages_zero() is the API which could be used to map
> range of kernel memory/pages in drivers which has not considered
> vm_pgoff. vm_pgoff is passed default as 0 for those drivers.
>
> We _could_ then at a later "fix" these drivers which are using
> vm_map_pages_zero() to behave according to the normal vm_pgoff
> offsetting simply by removing the _zero suffix on the function
> name and if that causes regressions, it gives us an easy way to revert.
>
> Tested on Rockchip hardware and display is working fine, including talking
> to Lima via prime.
>
> v1 -> v2:
>         Few Reviewed-by.
>
>         Updated the change log in [8/9]
>
>         In [7/9], vm_pgoff is treated in V4L2 API as a 'cookie'
>         to select a buffer, not as a in-buffer offset by design
>         and it always want to mmap a whole buffer from its beginning.
>         Added additional changes after discussing with Marek and
>         vm_map_pages() could be used instead of vm_map_pages_zero().
>
> v2 -> v3:
>         Corrected the documentation as per review comment.
>
>         As suggested in v2, renaming the interfaces to -
>         *vm_insert_range() -> vm_map_pages()* and
>         *vm_insert_range_buggy() -> vm_map_pages_zero()*.
>         As the interface is renamed, modified the code accordingly,
>         updated the change logs and modified the subject lines to use the
>         new interfaces. There is no other change apart from renaming and
>         using the new interface.
>
>         Patch[1/9] & [4/9], Tested on Rockchip hardware.
>
> v3 -> v4:
>         Fixed build warnings on patch [8/9] reported by kbuild test robot.
>
> Souptick Joarder (9):
>   mm: Introduce new vm_map_pages() and vm_map_pages_zero() API
>   arm: mm: dma-mapping: Convert to use vm_map_pages()
>   drivers/firewire/core-iso.c: Convert to use vm_map_pages_zero()
>   drm/rockchip/rockchip_drm_gem.c: Convert to use vm_map_pages()
>   drm/xen/xen_drm_front_gem.c: Convert to use vm_map_pages()
>   iommu/dma-iommu.c: Convert to use vm_map_pages()
>   videobuf2/videobuf2-dma-sg.c: Convert to use vm_map_pages()
>   xen/gntdev.c: Convert to use vm_map_pages()
>   xen/privcmd-buf.c: Convert to use vm_map_pages_zero()

If no further comment, is it fine to take these patches to -mm
tree for regression ?

>
>  arch/arm/mm/dma-mapping.c                          | 22 ++----
>  drivers/firewire/core-iso.c                        | 15 +---
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c        | 17 +----
>  drivers/gpu/drm/xen/xen_drm_front_gem.c            | 18 ++---
>  drivers/iommu/dma-iommu.c                          | 12 +---
>  drivers/media/common/videobuf2/videobuf2-core.c    |  7 ++
>  .../media/common/videobuf2/videobuf2-dma-contig.c  |  6 --
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c  | 22 ++----
>  drivers/xen/gntdev.c                               | 11 ++-
>  drivers/xen/privcmd-buf.c                          |  8 +--
>  include/linux/mm.h                                 |  4 ++
>  mm/memory.c                                        | 81 ++++++++++++++++++++++
>  mm/nommu.c                                         | 14 ++++
>  13 files changed, 134 insertions(+), 103 deletions(-)
>
> --
> 1.9.1
>
