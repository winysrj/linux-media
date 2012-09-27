Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:17729 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753585Ab2I0Tx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 15:53:26 -0400
Date: Thu, 27 Sep 2012 12:53:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ido Yariv <ido@wizery.com>
Cc: Russell King <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] iommu/omap: Merge iommu2.h into iommu.h
Message-ID: <20120927195313.GO4840@atomide.com>
References: <1348204448-30855-1-git-send-email-ido@wizery.com>
 <1348204448-30855-2-git-send-email-ido@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348204448-30855-2-git-send-email-ido@wizery.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ido,

* Ido Yariv <ido@wizery.com> [120920 22:15]:
> Since iommu is not currently supported on OMAP1, merge plat/iommu2.h into
> iommu.h so only one file would have to move to platform_data/ as part of the
> single zImage effort.

Looks like you need patch 2.5/3 in this series too that
makes some of the things defined in iommu.h local.

We should only have platform data in include/linux/platform_data,
so things that are private to drivers should be defined in the
driver, and things that are private to arch/arm/mach-omap2 should
defined locally there.

Based on a quick grepping of files, looks like these should be
defined in omap-iommu.c driver and not in the platform_data header:

struct iotlb_lock
struct iotlb_lock
dev_to_omap_iommu
various register defines
omap_iommu_arch_version
omap_iotlb_cr_to_e
omap_iopgtable_store_entry
omap_iommu_save_ctx
omap_iommu_restore_ctx
omap_foreach_iommu_device
omap_iommu_dump_ctx
omap_dump_tlb_entries

Regards,

Tony
