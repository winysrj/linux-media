Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2312BC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:39:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD33620657
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 11:39:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DayZQjEB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfAQLj6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 06:39:58 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37716 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfAQLj6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 06:39:58 -0500
Received: by mail-lj1-f194.google.com with SMTP id t18-v6so8310953ljd.4;
        Thu, 17 Jan 2019 03:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RqoIkotrN3l6oMAC+JrcBK/f6kX7mxLOSugmUX8akyw=;
        b=DayZQjEBT5kOQpoGi2VFE+Lz9tTTebqwjWOtbR16+0ebGzGyTuopZskDO46rrePAbK
         BFC5JdciMoAWC9h7PJlZzQQ0ky6VS3J8892IWikOgujLnSbBE6TgeASgyluAhMvzn9D2
         AYZH+Gl/sQpeZAldKkNZ98b2mgEIDv9JueHq6yx86dBIzzP45DzORgxhjZF4+fiRweno
         imcNTDVw0ARgn2BvsyYZg+T/7ACPSpZZ8XovYCZ/Du+R1YTGAjk3caOSZqw9uj8li7fm
         FChxRc6CELYunH8+CjDkMxH72RK/c1lod6sd10VCbMjLbrqxbBpFigRZfKC1GoznVbl6
         K85w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RqoIkotrN3l6oMAC+JrcBK/f6kX7mxLOSugmUX8akyw=;
        b=pSoiHgyPrYHx972x9TXuhmIeGXw3qoXz2D59JhY5mX5GEnXc5bbi770kNnW1BKNzd1
         mPk3JC92zlXMatnLrQUIRp4JtcM5HcSXARSGPJd+kg3ziw65jLK3HzQUONsD5V+y3pnO
         MDEuRDFOoUAJ6+ojkVFoztZaO/5o1zRc6czYaYBVqif+jvQLC+Or+GsjOVOAZqU79N73
         IsikI69xLcMWhqF3jT3Qw1o/o/Tzq2Hc9Rs80O/CYeirIU3T3+V3wina34EWcvw2p8bF
         yd8KDYOHk8TEPu9QMfjPAK5weT3bJzARMN8Dntl2G9vuizuTui0kTlAM9H6XTCcx33B6
         3B2Q==
X-Gm-Message-State: AJcUukeNpa7iNi3sPQ810ajBtdvRuemSUgeGHaeK2xOHpqPQngtM+tYN
        5oPmk8b6yEo/EAgnu9xnjEEps0FgSeDBmWz3QUY=
X-Google-Smtp-Source: ALg8bN4WjU3s0OSm/9YpUIQbO/Oo9A2A0MpGOiCgVD3iwev/FuzOnJlIV0vd6Lqn9vdpZcStOiDXH1xYeeYzkvOhrDc=
X-Received: by 2002:a2e:4601:: with SMTP id t1-v6mr9974371lja.111.1547725195689;
 Thu, 17 Jan 2019 03:39:55 -0800 (PST)
MIME-Version: 1.0
References: <20190111150541.GA2670@jordon-HP-15-Notebook-PC>
In-Reply-To: <20190111150541.GA2670@jordon-HP-15-Notebook-PC>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Thu, 17 Jan 2019 17:09:43 +0530
Message-ID: <CAFqt6zYxCxzGjv3ea+dYQHcmt2P849ZgaVSH=b05m9P4=MTBEA@mail.gmail.com>
Subject: Re: [PATCH 0/9] Use vm_insert_range and vm_insert_range_buggy
To:     Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, Jan 11, 2019 at 8:31 PM Souptick Joarder <jrdr.linux@gmail.com> wrote:
>
> Previouly drivers have their own way of mapping range of
> kernel pages/memory into user vma and this was done by
> invoking vm_insert_page() within a loop.
>
> As this pattern is common across different drivers, it can
> be generalized by creating new functions and use it across
> the drivers.
>
> vm_insert_range() is the API which could be used to mapped
> kernel memory/pages in drivers which has considered vm_pgoff
>
> vm_insert_range_buggy() is the API which could be used to map
> range of kernel memory/pages in drivers which has not considered
> vm_pgoff. vm_pgoff is passed default as 0 for those drivers.
>
> We _could_ then at a later "fix" these drivers which are using
> vm_insert_range_buggy() to behave according to the normal vm_pgoff
> offsetting simply by removing the _buggy suffix on the function
> name and if that causes regressions, it gives us an easy way to revert.
>
> There is an existing bug in [7/9], where user passed length is not
> verified against object_count. For any value of length > object_count
> it will end up overrun page array which could lead to a potential bug.
> This is fixed as part of these conversion.
>
> Souptick Joarder (9):
>   mm: Introduce new vm_insert_range and vm_insert_range_buggy API
>   arch/arm/mm/dma-mapping.c: Convert to use vm_insert_range
>   drivers/firewire/core-iso.c: Convert to use vm_insert_range_buggy
>   drm/rockchip/rockchip_drm_gem.c: Convert to use vm_insert_range
>   drm/xen/xen_drm_front_gem.c: Convert to use vm_insert_range
>   iommu/dma-iommu.c: Convert to use vm_insert_range
>   videobuf2/videobuf2-dma-sg.c: Convert to use vm_insert_range_buggy
>   xen/gntdev.c: Convert to use vm_insert_range
>   xen/privcmd-buf.c: Convert to use vm_insert_range_buggy

Any further comment on these patches ?

>
>  arch/arm/mm/dma-mapping.c                         | 22 ++----
>  drivers/firewire/core-iso.c                       | 15 +----
>  drivers/gpu/drm/rockchip/rockchip_drm_gem.c       | 17 +----
>  drivers/gpu/drm/xen/xen_drm_front_gem.c           | 18 ++---
>  drivers/iommu/dma-iommu.c                         | 12 +---
>  drivers/media/common/videobuf2/videobuf2-dma-sg.c | 22 ++----
>  drivers/xen/gntdev.c                              | 16 ++---
>  drivers/xen/privcmd-buf.c                         |  8 +--
>  include/linux/mm.h                                |  4 ++
>  mm/memory.c                                       | 81 +++++++++++++++++++++++
>  mm/nommu.c                                        | 14 ++++
>  11 files changed, 129 insertions(+), 100 deletions(-)
>
> --
> 1.9.1
>
