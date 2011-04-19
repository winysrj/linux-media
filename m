Return-path: <mchehab@pedra>
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:16262
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab1DSNwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 09:52:05 -0400
Date: Tue, 19 Apr 2011 15:50:03 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU
 (IOMMU) driver
Message-ID: <20110419135003.GR2192@amd.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
 <201104181612.35833.arnd@arndb.de>
 <005f01cbfe6b$148a8810$3d9f9830$%szyprowski@samsung.com>
 <201104191449.50824.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201104191449.50824.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Apr 19, 2011 at 08:49:50AM -0400, Arnd Bergmann wrote:
> (adding Joerg to Cc)
> 
> On Tuesday 19 April 2011, Marek Szyprowski wrote:
> 
> > > * This extends the generic IOMMU API in platform specific ways, don't
> > >   do that.

This is certainly not a good idea. Please Cc me on IOMMU-API changes in
the future to that I can have a look at it. This is also a good way to
prevent misunderstandings (which I found some in this mail).

> > Ok, it looks I don't fully get how this iommu.h should be used. It looks
> > that there can be only one instance of iommu ops registered in the system,
> > so only one iommu driver can be activated. You are right that the iommu
> > driver has to be registered on first probe().
> 
> That is a limitation of the current implementation. We might want to
> change that anyway, e.g. to handle the mali IOMMU along with yours.
> I believe the reason for allowing only one IOMMU type so far has been
> that nobody required more than one. As I mentioned, the IOMMU API is
> rather new and has not been ported to much variety of hardware, unlike
> the dma-mapping API, which does support multiple different IOMMUs
> in a single system.

The current IOMMU-API interface is very simple. It delegates the
selection of the particular IOMMU device to the IOMMU driver. Handle
this selection above the IOMMU driver is a complex thing to do. We will
need some kind of generic IOMMU support in the device-core and
attach IOMMUs to device sub-trees.

A simpler and less intrusive solution is to implement some wrapper code
which dispatches the IOMMU-API calls to the IOMMU driver implementation
required for that device.

> > I think it might be beneficial to describe a bit more our hardware 
> > (Exynos4 platform). There are a number of multimedia blocks. Each has it's
> > own IOMMU controller. Each IOMMU controller has his own set of hardware
> > registers and irq. There is also a GPU unit (Mali) which has it's own
> > IOMMU hardware, incompatible with the SYSMMU, so right now it is ignored.
> > 
> > The multimedia blocks are modeled as platform devices and are independent
> > of platform type (same multimedia blocks can be found on other Samsung
> > machines, like for example s5pv210/s5pc110), see arch/arm/plat-s5p/dev-*.c
> > and arch/arm/plat-samsung/dev-*.c.

Question: Does every platform device has a different type of IOMMU? Or
are the IOMMUs on all of these platform devices similar enough to be
handled by a single driver?

> > The domain defined in iommu api are quite straightforward. Each domain 
> > is just a set of mappings between physical addresses (phys) and io addresses
> > (iova).

Each domain represents an address space. In the AMD IOMMU this is
basically a page-table.

> > For the drivers the most important are the following functions:
> > iommu_{attach,detach}_device(struct iommu_domain *domain, struct device *dev);

Right, and each driver can allocate its own domains.

> > We assumed that they just assign the domain (mapping) to particular instance
> > of iommu. However the driver need to get somehow the pointer to the iommu 
> > instance. That's why we added the s5p_sysmmu_{get,put} functions.

The functions attach a specific device to an IOMMU domain (== address
space). These devices might be behind different IOMMUs and it is the
responsibility of the IOMMU driver to setup everything correctly.

> It's not quite how the domains are meant to be used. In the AMD IOMMU
> that the API is based on, any number of devices can share one domain,
> and devices might be able to have mappings in multiple domains.

Yes, any number of devices can be assigned to one domain, but each
device only belongs to one domain at each point in time. But it is
possible to detach a device from one domain and attach it to another.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

