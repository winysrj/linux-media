Return-Path: <SRS0=gTyh=QH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF00CC169C4
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BB482087F
	for <linux-media@archiver.kernel.org>; Thu, 31 Jan 2019 12:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732743AbfAaMfA (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 31 Jan 2019 07:35:00 -0500
Received: from gloria.sntech.de ([185.11.138.130]:56394 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbfAaMfA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Jan 2019 07:35:00 -0500
Received: from wf0848.dip.tu-dresden.de ([141.76.183.80] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1gpBXj-000441-H7; Thu, 31 Jan 2019 13:34:07 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     Souptick Joarder <jrdr.linux@gmail.com>, hjc@rock-chips.com
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCHv2 1/9] mm: Introduce new vm_insert_range and vm_insert_range_buggy API
Date:   Thu, 31 Jan 2019 13:34:10 +0100
Message-ID: <1572595.mVW1PIlZyR@phil>
In-Reply-To: <CAFqt6zbxyMB3VCzbWo1rPdfKXLVTNx+RY0=guD5CRxD37gJzsA@mail.gmail.com>
References: <20190131030812.GA2174@jordon-HP-15-Notebook-PC> <1701923.z6LKAITQJA@phil> <CAFqt6zbxyMB3VCzbWo1rPdfKXLVTNx+RY0=guD5CRxD37gJzsA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Am Donnerstag, 31. Januar 2019, 13:31:52 CET schrieb Souptick Joarder:
> On Thu, Jan 31, 2019 at 5:37 PM Heiko Stuebner <heiko@sntech.de> wrote:
> >
> > Am Donnerstag, 31. Januar 2019, 04:08:12 CET schrieb Souptick Joarder:
> > > Previouly drivers have their own way of mapping range of
> > > kernel pages/memory into user vma and this was done by
> > > invoking vm_insert_page() within a loop.
> > >
> > > As this pattern is common across different drivers, it can
> > > be generalized by creating new functions and use it across
> > > the drivers.
> > >
> > > vm_insert_range() is the API which could be used to mapped
> > > kernel memory/pages in drivers which has considered vm_pgoff
> > >
> > > vm_insert_range_buggy() is the API which could be used to map
> > > range of kernel memory/pages in drivers which has not considered
> > > vm_pgoff. vm_pgoff is passed default as 0 for those drivers.
> > >
> > > We _could_ then at a later "fix" these drivers which are using
> > > vm_insert_range_buggy() to behave according to the normal vm_pgoff
> > > offsetting simply by removing the _buggy suffix on the function
> > > name and if that causes regressions, it gives us an easy way to revert.
> > >
> > > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> > > Suggested-by: Russell King <linux@armlinux.org.uk>
> > > Suggested-by: Matthew Wilcox <willy@infradead.org>
> >
> > hmm, I'm missing a changelog here between v1 and v2.
> > Nevertheless I managed to test v1 on Rockchip hardware
> > and display is still working, including talking to Lima via prime.
> >
> > So if there aren't any big changes for v2, on Rockchip
> > Tested-by: Heiko Stuebner <heiko@sntech.de>
> 
> Change log is available in [0/9].
> Patch [1/9] & [4/9] have no changes between v1 -> v2.

I never seem to get your cover-letters, so didn't see that, sorry.

But great that there weren't changes then :-)

Heiko


