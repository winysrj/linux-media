Return-Path: <SRS0=1NWX=OQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DE1C07E85
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 21:45:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 091C120837
	for <linux-media@archiver.kernel.org>; Fri,  7 Dec 2018 21:45:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ipmNs0vN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 091C120837
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbeLGVpQ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 7 Dec 2018 16:45:16 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33129 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbeLGVpQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2018 16:45:16 -0500
Received: by mail-lj1-f195.google.com with SMTP id v1-v6so4824937ljd.0;
        Fri, 07 Dec 2018 13:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v6KpxNhJmlXUycYQajdCWj2sFrZIkqlDQLw4h1pTRk8=;
        b=ipmNs0vN037Cl5mH4fVf3ttZCVpQb/9Zld0Lkafz8Hbbo90MYs8acI6L5OpSFJxaW3
         NuFIVq89n+RQB95eqVngvZc1bQPEIb77dxGHnJss6F0qQblkGWQKXumuHBQbh8kw+Pfd
         3/K0hNQprlIJGICL+7alaFrZ3Z2v2TlTjVc5In/VXdKgMGqVOfy4DcESgBnfEpfSkD8Q
         CS+/197PnoXgoa+YJq8kvN+LBSGjUpJ0O93FRXM2PTZARwFtFZf8uWXHjIM8xzvXrila
         K5YT5DJoNt48G/JUUvwx4XDAKl38hLSP20n9jY8+hpjApMF8Sg0qHyrGAn5/iI3/ITQ4
         gxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v6KpxNhJmlXUycYQajdCWj2sFrZIkqlDQLw4h1pTRk8=;
        b=UYiJMP3/0OPJe2/gjpyN0lj7waQv7EKvd5vhkqXXpogtnmdM6ImT9Lz7wnFeqwZRo4
         ZYEDqHYgmfttEv7Gh59VnW73eWlDLj+lapkxKt9lI0+vV9SscycwleDXu7vYC0dY7RvV
         x4S+TA3LgUbrxaE59Yip0l6wgGQGkKh6PtGMk2TA8LpV1a0fzVJTD1QBHWTGL1WyN076
         UPc3CAJZ+9WMUyAJsDiN1mW8231ok3hEbYvCyfATnl4XHK3vbCCv0mN0Iw6PmSpYeMBi
         zxeOKqmTkFT2uyRlPP/jSrhR9e6sSUJTjO4vM9lVcfkJSM8FA/yiN1MmsCcuspZ1HsjH
         uthA==
X-Gm-Message-State: AA+aEWayFOQiqECBqRTJbcnm9ZvzZ2sphXFhgkNKjM0N6apUQQMvzAB2
        DiOS6WuKy6Ns/oHHq8yYvjw2/0JcXgDIEgc2m3I=
X-Google-Smtp-Source: AFSGD/UiO69YGGtyeIa+0dEyKTkhClEazQP+Xrjk9iG9Qx2lN8TS6sOEC5U+Cv+TxQru0RaL3krxiwlEDml8OIL6rbE=
X-Received: by 2002:a2e:9f0b:: with SMTP id u11-v6mr2011980ljk.99.1544219113588;
 Fri, 07 Dec 2018 13:45:13 -0800 (PST)
MIME-Version: 1.0
References: <20181206183945.GA20932@jordon-HP-15-Notebook-PC>
 <53bbc095-c9f5-5d6a-6e50-6e060d17eb68@arm.com> <20181207171116.GA29923@bombadil.infradead.org>
 <CAFqt6zYCWOK-uS85GqCzcgT=+YKn1nBrRPq+M9y6eJjmXEKH+g@mail.gmail.com> <67495f8f-2092-e42d-321e-5216c346513f@arm.com>
In-Reply-To: <67495f8f-2092-e42d-321e-5216c346513f@arm.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Sat, 8 Dec 2018 03:18:49 +0530
Message-ID: <CAFqt6zbuT3mhLCSas=EO38NW+M4KAARKeBpMqDz6xwkVbw=FGA@mail.gmail.com>
Subject: Re: [PATCH v3 1/9] mm: Introduce new vm_insert_range API
To:     robin.murphy@arm.com
Cc:     Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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

On Sat, Dec 8, 2018 at 2:40 AM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2018-12-07 7:28 pm, Souptick Joarder wrote:
> > On Fri, Dec 7, 2018 at 10:41 PM Matthew Wilcox <willy@infradead.org> wrote:
> >>
> >> On Fri, Dec 07, 2018 at 03:34:56PM +0000, Robin Murphy wrote:
> >>>> +int vm_insert_range(struct vm_area_struct *vma, unsigned long addr,
> >>>> +                   struct page **pages, unsigned long page_count)
> >>>> +{
> >>>> +   unsigned long uaddr = addr;
> >>>> +   int ret = 0, i;
> >>>
> >>> Some of the sites being replaced were effectively ensuring that vma and
> >>> pages were mutually compatible as an initial condition - would it be worth
> >>> adding something here for robustness, e.g.:
> >>>
> >>> +     if (page_count != vma_pages(vma))
> >>> +             return -ENXIO;
> >>
> >> I think we want to allow this to be used to populate part of a VMA.
> >> So perhaps:
> >>
> >>          if (page_count > vma_pages(vma))
> >>                  return -ENXIO;
> >
> > Ok, This can be added.
> >
> > I think Patch [2/9] is the only leftover place where this
> > check could be removed.
>
> Right, 9/9 could also have relied on my stricter check here, but since
> it's really testing whether it actually managed to allocate vma_pages()
> worth of pages earlier, Matthew's more lenient version won't help for
> that one.


(Why privcmd_buf_mmap() doesn't clean up and return an error
> as soon as that allocation loop fails, without taking the mutex under
> which it still does a bunch more pointless work to only undo it again,
> is a mind-boggling mystery, but that's not our problem here...)

I think some clean up can be done here in a separate patch.
