Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40932 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729474AbeKTBdf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 20:33:35 -0500
MIME-Version: 1.0
References: <20181115154530.GA27872@jordon-HP-15-Notebook-PC>
 <20181116182836.GB17088@rapoport-lnx> <CAFqt6zYp0j999WXw9Jus0oZMjADQQkPfso8btv6du6L9CE3PXA@mail.gmail.com>
 <20181117143742.GB7861@bombadil.infradead.org>
In-Reply-To: <20181117143742.GB7861@bombadil.infradead.org>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Mon, 19 Nov 2018 20:43:09 +0530
Message-ID: <CAFqt6zbOWX5LUTWwoGDJsGdf+pTR6N1yTPVxyr1W3-6Fte39ww@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm: Introduce new vm_insert_range API
To: Matthew Wilcox <willy@infradead.org>, rppt@linux.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
List-ID: <linux-media.vger.kernel.org>

Hi Mike,

On Sat, Nov 17, 2018 at 8:07 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Sat, Nov 17, 2018 at 12:26:38PM +0530, Souptick Joarder wrote:
> > On Fri, Nov 16, 2018 at 11:59 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
> > > > + * vm_insert_range - insert range of kernel pages into user vma
> > > > + * @vma: user vma to map to
> > > > + * @addr: target user address of this page
> > > > + * @pages: pointer to array of source kernel pages
> > > > + * @page_count: no. of pages need to insert into user vma
> > > > + *
> > > > + * This allows drivers to insert range of kernel pages they've allocated
> > > > + * into a user vma. This is a generic function which drivers can use
> > > > + * rather than using their own way of mapping range of kernel pages into
> > > > + * user vma.
> > >
> > > Please add the return value and context descriptions.
> > >
> >
> > Sure I will wait for some time to get additional review comments and
> > add all of those requested changes in v2.
>
> You could send your proposed wording now which might remove the need
> for a v3 if we end up arguing about the wording.

Does this description looks good ?

/**
 * vm_insert_range - insert range of kernel pages into user vma
 * @vma: user vma to map to
 * @addr: target user address of this page
 * @pages: pointer to array of source kernel pages
 * @page_count: number of pages need to insert into user vma
 *
 * This allows drivers to insert range of kernel pages they've allocated
 * into a user vma. This is a generic function which drivers can use
 * rather than using their own way of mapping range of kernel pages into
 * user vma.
 *
 * Context - Process context. Called by mmap handlers.
 * Return - int error value
 * 0                    - OK
 * -EINVAL              - Invalid argument
 * -ENOMEM              - No memory
 * -EFAULT              - Bad address
 * -EBUSY               - Device or resource busy
 */
