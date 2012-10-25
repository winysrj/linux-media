Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:26734 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751479Ab2JYVjo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 17:39:44 -0400
Date: Thu, 25 Oct 2012 14:39:35 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to
 include/linux/omap-iommu.h
Message-ID: <20121025213935.GD11928@atomide.com>
References: <20121025001913.2082.31062.stgit@muffinssi.local>
 <1466344.HbU9q5zM1q@avalon>
 <20121025165643.GP11928@atomide.com>
 <1351198976.2hJjhe5gKC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351198976.2hJjhe5gKC@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121025 13:23]:
> Hi Tony,
> 
> On Thursday 25 October 2012 09:56:44 Tony Lindgren wrote:
> > * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121025 01:39]:
> > > I still think you should split this in two files, omap-iommu.h and omap-
> > > iovmm.h. The later would just be arch/arm/plat-omap/include/plat/iovmm.h
> > > moved to include/linux.h.
> > 
> > Can you please explain a bit more why you're thinking a separate
> > omap-iovmm.h is needed in addtion to omap-iommu.h?
> 
> The IOVMM API is layered top of the IOMMU API. It's really a separate API, so 
> two header files make sense. This patch creates a hybrid omap-iommu.h header 
> with mixed definitions, it just doesn't feel right :-) I won't insist for a 
> split though, if you think it's better to have a single header we can keep it 
> that way.

Yes it's true it's a separate layer. But it's still iommu
specific. The functions exported by omap-iovmm.c have iommu_
prefix in the name except for one:

drivers/iommu/omap-iovmm.c:EXPORT_SYMBOL_GPL(omap_find_iovm_area);
drivers/iommu/omap-iovmm.c:EXPORT_SYMBOL_GPL(omap_da_to_va);
drivers/iommu/omap-iovmm.c:EXPORT_SYMBOL_GPL(omap_iommu_vmap);
drivers/iommu/omap-iovmm.c:EXPORT_SYMBOL_GPL(omap_iommu_vunmap);
drivers/iommu/omap-iovmm.c:EXPORT_SYMBOL_GPL(omap_iommu_vmalloc);
drivers/iommu/omap-iovmm.c:EXPORT_SYMBOL_GPL(omap_iommu_vfree);

So it should be OK to keep it all in omap-iommu.h file. Let's 
see hear what..

> > My reasoning for not adding it is that neither intel nor amd needs
> > more than intel-iommu.h and amd-iommu.h. And hopefully the iommu
> > framework will eventually provide the API needed. And I'd rather
> > not be the person introducing this second new file into
> > include/linux :)
> > 
> > Joerg and Ohad, do you have any opinions on this?

..Joerg and Ohad say.

Regards,

Tony
