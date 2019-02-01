Return-Path: <SRS0=EV+/=QI=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67939C282D8
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 387DE20863
	for <linux-media@archiver.kernel.org>; Fri,  1 Feb 2019 12:38:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GQmlKMug"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729915AbfBAMiS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Feb 2019 07:38:18 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:43077 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfBAMiS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2019 07:38:18 -0500
Received: by mail-lj1-f194.google.com with SMTP id q2-v6so5633836lji.10;
        Fri, 01 Feb 2019 04:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FA5f7YY6n6QegB8E6sgW5d/K980UEuX80JV8baCFznE=;
        b=GQmlKMugZ3bwsuMyb/P7aK4QpswXwaapZ4DsT1fvEZI+8XD1CmbdiMhQQwRT/xvM41
         FyfIcL0N8bcp4jvn7Rwk4vJw0vHXWdS7oie1el+Hqn231IBHDAw6eD5+PSU6PWH0Kbrr
         wm+pUxdv5ycyzateCY5dPVP85pDjE5NPJhuXBBI7CzvL35940bts/64hf3iffhDjUWvh
         aAfcvwWtLCX3818splV9Mc9NtipwQGWQLvOX+l8X2NO6NQvDm+wMZsoF4pTdPcv7ZRCS
         kdZcReWw7MN1tXv1r24u+YCF2/21n4WrFhEUHRDayakh1YVkONA2gIIQdAHiNaJw54K/
         eeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FA5f7YY6n6QegB8E6sgW5d/K980UEuX80JV8baCFznE=;
        b=CU27SZv9uulMGNZEhfX7T1iYgsnrj2e/L4hKysbNZFXG90Sh22HoWV43DFPmpPxITM
         4XfMJ9zIiy3LY+gEzBZWHhi53shQ3njO7a0oGbK5agiKoqFGc2YJGCi0bf48t8WxNL0S
         DDJijDgppN4DEguJ8EIWBEB+ZWlGZQLVcibOgfsOBKgvbdanakXMkKIzKlWz4mGdioy4
         +OmPkmYWcRIB+nUTb2rDJALUEZmT1V0wAiUBUn8qFt4tyaLyX1QlKKwPreTqPlCRR6r0
         iuAMgoXqMHOzfR5WW7HAS+jlfaqO1AC8ul+4uYqFCPxqyGp8MkRPibQEkg+hSwAP/2M6
         JVCA==
X-Gm-Message-State: AJcUukc98Gdxq6L1ZxzMLtdlu//xZ7WYwZ4Nh+DvkvKW7hovQXh7dA0N
        Ji3izTwgcL7hAoOq4t0nv8pUaQfEUKxmmp00e9U=
X-Google-Smtp-Source: ALg8bN63OQuN/I7+5c4lLuO9nn/Jxyf+w53AUJkRrvBxfuBKIIADHNYPuQlrqZkogRtB1XtcmnGCFBz+O8XMsDRzXzM=
X-Received: by 2002:a2e:9849:: with SMTP id e9-v6mr31185303ljj.9.1549024695704;
 Fri, 01 Feb 2019 04:38:15 -0800 (PST)
MIME-Version: 1.0
References: <20190131030812.GA2174@jordon-HP-15-Notebook-PC>
 <1701923.z6LKAITQJA@phil> <CAFqt6zbxyMB3VCzbWo1rPdfKXLVTNx+RY0=guD5CRxD37gJzsA@mail.gmail.com>
 <1572595.mVW1PIlZyR@phil>
In-Reply-To: <1572595.mVW1PIlZyR@phil>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Fri, 1 Feb 2019 18:08:04 +0530
Message-ID: <CAFqt6zbMHG3htSsOwV3SaEEp1rMbFCoDD_3EacDk1hw_a1HJeQ@mail.gmail.com>
Subject: Re: [PATCHv2 1/9] mm: Introduce new vm_insert_range and
 vm_insert_range_buggy API
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     hjc@rock-chips.com, Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        vbabka@suse.cz, Rik van Riel <riel@surriel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        rppt@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        robin.murphy@arm.com, airlied@linux.ie,
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

On Thu, Jan 31, 2019 at 6:04 PM Heiko Stuebner <heiko@sntech.de> wrote:
>
> Am Donnerstag, 31. Januar 2019, 13:31:52 CET schrieb Souptick Joarder:
> > On Thu, Jan 31, 2019 at 5:37 PM Heiko Stuebner <heiko@sntech.de> wrote:
> > >
> > > Am Donnerstag, 31. Januar 2019, 04:08:12 CET schrieb Souptick Joarder:
> > > > Previouly drivers have their own way of mapping range of
> > > > kernel pages/memory into user vma and this was done by
> > > > invoking vm_insert_page() within a loop.
> > > >
> > > > As this pattern is common across different drivers, it can
> > > > be generalized by creating new functions and use it across
> > > > the drivers.
> > > >
> > > > vm_insert_range() is the API which could be used to mapped
> > > > kernel memory/pages in drivers which has considered vm_pgoff
> > > >
> > > > vm_insert_range_buggy() is the API which could be used to map
> > > > range of kernel memory/pages in drivers which has not considered
> > > > vm_pgoff. vm_pgoff is passed default as 0 for those drivers.
> > > >
> > > > We _could_ then at a later "fix" these drivers which are using
> > > > vm_insert_range_buggy() to behave according to the normal vm_pgoff
> > > > offsetting simply by removing the _buggy suffix on the function
> > > > name and if that causes regressions, it gives us an easy way to revert.
> > > >
> > > > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > > > Suggested-by: Russell King <linux@armlinux.org.uk>
> > > > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > >
> > > hmm, I'm missing a changelog here between v1 and v2.
> > > Nevertheless I managed to test v1 on Rockchip hardware
> > > and display is still working, including talking to Lima via prime.
> > >
> > > So if there aren't any big changes for v2, on Rockchip
> > > Tested-by: Heiko Stuebner <heiko@sntech.de>
> >
> > Change log is available in [0/9].
> > Patch [1/9] & [4/9] have no changes between v1 -> v2.
>
> I never seem to get your cover-letters, so didn't see that, sorry.

I added you in sender list for all cover-letters but it didn't reach
your inbox :-)
Thanks for reviewing and validating the patch.

>
> But great that there weren't changes then :-)
>
> Heiko
>
>
