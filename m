Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59357 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2I3REN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Sep 2012 13:04:13 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so1035057qad.19
        for <linux-media@vger.kernel.org>; Sun, 30 Sep 2012 10:04:12 -0700 (PDT)
Date: Sun, 30 Sep 2012 13:04:09 -0400
From: Ido Yariv <ido@wizery.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] iommu/omap: Merge iommu2.h into iommu.h
Message-ID: <20120930170408.GA5745@NoteStation.RenaNet>
References: <1348204448-30855-1-git-send-email-ido@wizery.com>
 <1348204448-30855-2-git-send-email-ido@wizery.com>
 <20120927195313.GO4840@atomide.com>
 <20120927195526.GP4840@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927195526.GP4840@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 27, 2012 at 12:55:26PM -0700, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [120927 12:54]:
> > Hi Ido,
> > 
> > * Ido Yariv <ido@wizery.com> [120920 22:15]:
> > > Since iommu is not currently supported on OMAP1, merge plat/iommu2.h into
> > > iommu.h so only one file would have to move to platform_data/ as part of the
> > > single zImage effort.
> > 
> > Looks like you need patch 2.5/3 in this series too that
> > makes some of the things defined in iommu.h local.
> > 
> > We should only have platform data in include/linux/platform_data,
> > so things that are private to drivers should be defined in the
> > driver, and things that are private to arch/arm/mach-omap2 should
> > defined locally there.
> > 
> > Based on a quick grepping of files, looks like these should be
> > defined in omap-iommu.c driver and not in the platform_data header:
> > 
> > struct iotlb_lock
> > struct iotlb_lock
> > dev_to_omap_iommu
> > various register defines
> > omap_iommu_arch_version
> > omap_iotlb_cr_to_e
> > omap_iopgtable_store_entry
> > omap_iommu_save_ctx
> > omap_iommu_restore_ctx
> > omap_foreach_iommu_device
> > omap_iommu_dump_ctx
> > omap_dump_tlb_entries
> 
> And looks like while at it, you can also move plat/iopgtable.h
> and put it in some drivers/iommu/*.h file that's shared by
> omap-iommu*.c and omap-iovmm.c drivers ;)

Sure thing, I'll post a v2 shortly.

Thanks,
Ido.
