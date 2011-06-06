Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:50283 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1FFJKq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 05:10:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: [RFC 0/6] iommu: generic api migration and grouping
Date: Mon, 6 Jun 2011 11:10:30 +0200
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	laurent.pinchart@ideasonboard.com, Hiroshi.DOYU@nokia.com,
	davidb@codeaurora.org, Joerg.Roedel@amd.com,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	David Woodhouse <dwmw2@infradead.org>,
	anil.s.keshavamurthy@intel.com
References: <1307053663-24572-1-git-send-email-ohad@wizery.com> <201106031753.16095.arnd@arndb.de> <BANLkTim2pDu25ZudZ7ZzOwka0V1sYEhDKw@mail.gmail.com>
In-Reply-To: <BANLkTim2pDu25ZudZ7ZzOwka0V1sYEhDKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106061110.30601.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 05 June 2011, Ohad Ben-Cohen wrote:
> > As far as I can tell, once we have that in
> > place, we you can migrate omap3isp from iovmm to dma-mapping and
> > remove iovmm.
> 
> Sounds like a plan.
> 
> I'd still prefer us to take small steps here, and not gate the omap
> iommu cleanups with Marek's generic dma_map_ops work though. Let's go
> forward and migrate omap's iommu to the generic iommu API, so new code
> will be able to use it (e.g. the long coming virtio-based IPC/AMP
> framework).

Yes, of course. That's what I meant. Moving over omap to the IOMMU API
is required anyway, so there is no point delaying that.

> We'll migrate iovmm/omap3isp just enough so they don't break, but once
> the generic dma_map_ops work materializes, we'd be able to complete
> the migration, remove iovmm, and decouple omap3isp from omap-specific
> iommu APIs for good.

Ok, great!

	Arnd
