Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38456 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbeKRAzc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 17 Nov 2018 19:55:32 -0500
Date: Sat, 17 Nov 2018 06:37:42 -0800
From: Matthew Wilcox <willy@infradead.org>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: rppt@linux.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH 1/9] mm: Introduce new vm_insert_range API
Message-ID: <20181117143742.GB7861@bombadil.infradead.org>
References: <20181115154530.GA27872@jordon-HP-15-Notebook-PC>
 <20181116182836.GB17088@rapoport-lnx>
 <CAFqt6zYp0j999WXw9Jus0oZMjADQQkPfso8btv6du6L9CE3PXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFqt6zYp0j999WXw9Jus0oZMjADQQkPfso8btv6du6L9CE3PXA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 17, 2018 at 12:26:38PM +0530, Souptick Joarder wrote:
> On Fri, Nov 16, 2018 at 11:59 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
> > > + * vm_insert_range - insert range of kernel pages into user vma
> > > + * @vma: user vma to map to
> > > + * @addr: target user address of this page
> > > + * @pages: pointer to array of source kernel pages
> > > + * @page_count: no. of pages need to insert into user vma
> > > + *
> > > + * This allows drivers to insert range of kernel pages they've allocated
> > > + * into a user vma. This is a generic function which drivers can use
> > > + * rather than using their own way of mapping range of kernel pages into
> > > + * user vma.
> >
> > Please add the return value and context descriptions.
> >
> 
> Sure I will wait for some time to get additional review comments and
> add all of those requested changes in v2.

You could send your proposed wording now which might remove the need
for a v3 if we end up arguing about the wording.
