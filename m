Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E4A4C169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7062D2087F
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:32:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rm0itLub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732190AbfAaMcH (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:32:07 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35351 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbfAaMcG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 07:32:06 -0500
Received: by mail-lj1-f194.google.com with SMTP id x85-v6so2540279ljb.2;
        Thu, 31 Jan 2019 04:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUni9/6Z2lGMVz53wyw6zTg0RWZ4vyfLf6KBzYMBEmg=;
        b=rm0itLubnrxxq4PPU48BdkkmPOHGmoawlXX7TkirV4StzYrvbOIna0ghZQS2MZ2t76
         XhmHBOPccSIjpVoDYvh6YrtIBr5eW0+bdYyC3OkQ7c8WSywe3qd9fTk75H03Iczx/vz+
         ica0fn1RP61+8A8QOUdr2YeGNhb1x8j06LH67rCa56PhTSaWcsKMzCFrGAKWvu8izLO1
         r9n/88H88jlojH/9LggBml0yrFb/uQsNo2A7e1JgfSAEKysdVB90p+WDPw0Udz+KvqR8
         XIGDjJcmERRAXarrPQcdwF9vNp/LZDRJsdhZkxzMTILaiGDq0d2CfYCAzuog8UhXWLuy
         RKDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUni9/6Z2lGMVz53wyw6zTg0RWZ4vyfLf6KBzYMBEmg=;
        b=iradGg92hxKqEHmn88wBud8z2RoWFNAj8xWqqGm1VlsFN+phEhW7P9VwPFMFUtf3/8
         7RAsLWBHnK08V/kcbWXfJUaKUL8YI2/TjF+cowbcTo1qaKghw/6JwMCMbU1NanArP1mt
         PKap5e2W92UdkQMjsLYN0HUt4VfCJ+TN+IfsmxMMADNIBHSsWHVon0swsovK1nOvjIPY
         guxgBomJEAR4ha05PoLL2C1dRO5OvWP12TyzZTryXvcdypiipCx5yBikD+9dj31iihHv
         643LCdTj00iQ7J5wchVfJTdnNr9Zfa6O7lki3zGpdUC1rAh4a0hmHPp50z6MYH7MFV52
         EpxQ==
X-Gm-Message-State: AJcUukfJu8Latky48oPVuh3YDnzGGfNVokjL08yhbsKAlX9RgE2OBmyF
        LNqYiqd3ezPJlw58rVePa9HRqBoWFb6XMZftKGo=
X-Google-Smtp-Source: AHgI3IYqaijPCAbpcAfqB4K9ZTYxFfKIZ7xmxN6niWa1cYJjdCHW8ay1HiYLvHZ4e1NWitw9Tq+lwpQUU40Nwq+GS9I=
X-Received: by 2002:a2e:5703:: with SMTP id l3-v6mr16102340ljb.106.1548937924232;
 Thu, 31 Jan 2019 04:32:04 -0800 (PST)
MIME-Version: 1.0
References: <20190131030812.GA2174@jordon-HP-15-Notebook-PC> <1701923.z6LKAITQJA@phil>
In-Reply-To: <1701923.z6LKAITQJA@phil>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Thu, 31 Jan 2019 18:01:52 +0530
Message-ID: <CAFqt6zbxyMB3VCzbWo1rPdfKXLVTNx+RY0=guD5CRxD37gJzsA@mail.gmail.com>
Subject: Re: [PATCHv2 1/9] mm: Introduce new vm_insert_range and
 vm_insert_range_buggy API
To:     Heiko Stuebner <heiko@sntech.de>
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
        stefanr@s5r6.in-berlin.de, hjc@rock-chips.com, airlied@linux.ie,
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

On Thu, Jan 31, 2019 at 5:37 PM Heiko Stuebner <heiko@sntech.de> wrote:
>
> Am Donnerstag, 31. Januar 2019, 04:08:12 CET schrieb Souptick Joarder:
> > Previouly drivers have their own way of mapping range of
> > kernel pages/memory into user vma and this was done by
> > invoking vm_insert_page() within a loop.
> >
> > As this pattern is common across different drivers, it can
> > be generalized by creating new functions and use it across
> > the drivers.
> >
> > vm_insert_range() is the API which could be used to mapped
> > kernel memory/pages in drivers which has considered vm_pgoff
> >
> > vm_insert_range_buggy() is the API which could be used to map
> > range of kernel memory/pages in drivers which has not considered
> > vm_pgoff. vm_pgoff is passed default as 0 for those drivers.
> >
> > We _could_ then at a later "fix" these drivers which are using
> > vm_insert_range_buggy() to behave according to the normal vm_pgoff
> > offsetting simply by removing the _buggy suffix on the function
> > name and if that causes regressions, it gives us an easy way to revert.
> >
> > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > Suggested-by: Russell King <linux@armlinux.org.uk>
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
>
> hmm, I'm missing a changelog here between v1 and v2.
> Nevertheless I managed to test v1 on Rockchip hardware
> and display is still working, including talking to Lima via prime.
>
> So if there aren't any big changes for v2, on Rockchip
> Tested-by: Heiko Stuebner <heiko@sntech.de>

Change log is available in [0/9].
Patch [1/9] & [4/9] have no changes between v1 -> v2.
