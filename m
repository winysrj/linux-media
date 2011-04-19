Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:64065 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1DSO3z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 10:29:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Tue, 19 Apr 2011 16:29:49 +0200
Cc: "'Joerg Roedel'" <joerg.roedel@amd.com>,
	linux-samsung-soc@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>,
	"'Sylwester Nawrocki'" <s.nawrocki@samsung.com>,
	"'Andrzej Pietrasiewicz'" <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <201104191449.50824.arnd@arndb.de> <000001cbfe9a$8e64cae0$ab2e60a0$%szyprowski@samsung.com>
In-Reply-To: <000001cbfe9a$8e64cae0$ab2e60a0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191629.49676.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 19 April 2011, Marek Szyprowski wrote:

> > 
> > 1. change the runtime_pm subsystem to allow it to ignore some devices
> > in an easy way.
> > 
> > 2. change the device layout if the sysmmu. If the iommu device is
> > a child of the device that it is responsible for, I guess you don't
> > have this problem.
> > 
> > 3. Not represent the iommu as a device at all, just as a property
> > of another device.
> 
> Ok, we will handle this issue somehow. I consider this a minor issue and I
> would like to focus on the IOMMU/dma-mapping APIs first.

Yes, agreed.

> > That is a limitation of the current implementation. We might want to
> > change that anyway, e.g. to handle the mali IOMMU along with yours.
> > I believe the reason for allowing only one IOMMU type so far has been
> > that nobody required more than one. As I mentioned, the IOMMU API is
> > rather new and has not been ported to much variety of hardware, unlike
> > the dma-mapping API, which does support multiple different IOMMUs
> > in a single system.
> 
> Ok. I understand. IOMMU API is quite nice abstraction of the IOMMU chip.
> dma-mapping API is something much more complex that creates the actual
> mapping for various sets of the devices. IMHO the right direction will
> be to create dma-mapping implementation that will be just a client of
> the IOMMU API. What's your opinion?
 
Sounds good. I think we should put it into a new drivers/iommu, along
with your specific iommu implementation, and then we can convert the
existing ones over to use that.

Note that this also requires using dma-mapping-common.h, which we currently
don't on ARM.

> > The domain really reflects the user, not the device here, which makes more
> > sense if you think of virtual machines than of multimedia devices.
> >
> > I would suggest that you just use a single iommu_domain globally for
> > all in-kernel users.
> 
> There are cases where having a separate mapping for each device makes sense.
> It definitely increases the security and helps to find some bugs in
> the drivers.
> 
> Getting back to our video codec - it has 2 IOMMU controllers. The codec
> hardware is able to address only 256MiB of space. Do you have an idea how
> this can be handled with dma-mapping API? The only idea that comes to my
> mind is to provide a second, fake 'struct device' and use it for allocations
> for the second IOMMU controller.

Good question. 

How do you even decide which controller to use from the driver?
I would need to understand better what you are trying to do to
give a good recommendation.

	Arnd
