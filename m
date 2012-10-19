Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:32216 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751820Ab2JSQOk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Oct 2012 12:14:40 -0400
Date: Fri, 19 Oct 2012 09:14:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to
 include/linux/omap-iommu.h
Message-ID: <20121019161430.GC4730@atomide.com>
References: <20121018202707.11834.1438.stgit@muffinssi.local>
 <20121018202842.11834.14375.stgit@muffinssi.local>
 <2071397.IU49JkAq1T@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2071397.IU49JkAq1T@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121019 02:41]:
> 
> Nitpicking, please keep the headers sorted alphabetically, here and in all 
> locations below (especially the OMAP3 ISP driver).
> 
> (OK, there's already one misplaced #include, but let's not make it worse :-))

Sure I'll check that.
 
> I plan to push cleanup patches for the staging tidspbridge driver that get rid 
> of the local register definitions and use plat/iommu.h instead. That's 
> obviously an interim solution as in the long run the driver should use the 
> IOMMU API, but in the meantime it's a step in the right direction. Would it 
> then make sense to move all those definitions to include/linux/omap-iommu.h, 
> not just the ones used by the OMAP3 ISP driver ?

Well these patches are just intended to fix the platform data interface
between core ARM code and iommu. At this point I really don't want to
get involved in the iommu framework.

What you are asking should be coordinated with Joerg and Ohad. Ideally
the iommu framework would provide the API to the drivers to use, and there
would not be any need to have include/linux/omap-iommu.h.

If you ask me, I would just rip out the code that's not following the
iommu API immediately and have it resubmitted in a sane way :)
 
> Shouldn't this header be split in include/linux/omap-iommu.h and 
> include/linux/omap-iovmm.h ? I would also move all the hardware IOVMF flags to 
> include/linux/omap-iovmm.h, not just the two currently used by the OMAP3 ISP 
> driver. The software flags can be kept in drivers/iommu/omap-iovmm.c.

I just fixed up things to follow what's being done with the iommu
framework currently. Probably keeping only omap-iommu.h available is
the best way to go until the iommu framework provides the interfaces,
but again that's up to Joerg and Ohad.
 
> > +extern void omap_iommu_save_ctx(struct device *dev);
> > +extern void omap_iommu_restore_ctx(struct device *dev);
> 
> Do we really need to prefix functions with 'extern' ?

Yes since they are exported, I just moved them. Again, this is something
that should be handled eventually via the iommu framework using runtime PM
and not be exported at all. Again, I would just rip out that code
if you ask me and replace it with comments until fixed.

Regards,

Tony
