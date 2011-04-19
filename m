Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:46298 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab1DSODb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 10:03:31 -0400
Date: Tue, 19 Apr 2011 16:03:27 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU)
	driver
In-reply-to: <201104191449.50824.arnd@arndb.de>
To: 'Arnd Bergmann' <arnd@arndb.de>,
	'Joerg Roedel' <joerg.roedel@amd.com>
Cc: linux-samsung-soc@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Andrzej Pietrasiewicz' <andrzej.p@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <000001cbfe9a$8e64cae0$ab2e60a0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
 <201104181612.35833.arnd@arndb.de>
 <005f01cbfe6b$148a8810$3d9f9830$%szyprowski@samsung.com>
 <201104191449.50824.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Tuesday, April 19, 2011 2:50 PM Arnd Bergmann wrote:

> On Tuesday 19 April 2011, Marek Szyprowski wrote:
> 
> > > These look wrong for a number of reasons:
> > >
> > > * try_module_get(THIS_MODULE) makes no sense at all, the idea of the
> > >   try_module_get is to pin down another module that was calling down,
> > >   which I suppose is not needed here.
> > >
> > > * This extends the generic IOMMU API in platform specific ways, don't
> > >   do that.
> > >
> > > * I think you can do without these functions by including a pointer
> > >   to the iommu structure in dev_archdata, see
> > >   arch/powerpc/include/asm/device.h for an example.
> >
> > We heavily based our solution on the iommu implementation found in
> > arch/arm/mach-msm/{devices-iommu,iommu,iommu_dev}.c
> >
> > The s5p_sysmmu_get/put functions are equivalent for
> msm_iommu_{get,put}_ctx.
> >
> > (snipped)
> 
> Yes, I'm sorry about this. I commented on the early versions of the MSM
> driver, but then did not do another review of the version that actually
> got merged. That should also be fixed, ideally we can come up with a
> way that works for both drivers.

OK, so it looks that we misunderstood the IOMMU API basing on the 
particular implementation.

> > > Why even provide these when they don't do anything?
> >
> > Because they are required by pm_runtime. If no runtime_{suspend,resume}
> > methods are provided, the pm_runtime core will not call proper methods
> > on parent device for pmruntime_{get,put}_sync(). The parent device for
> > each sysmmu platform device is the power domain the sysmmu belongs to.
> >
> > I know this is crazy, but this is the only way it can be handled now
> > with runtime_pm.
> 
> Please don't try to work around kernel features when they don't fit
> what you are doing. The intent of the way that runtime_pm works is
> to make life easier for driver writers, not harder ;-)
> 
> I can see three ways that would be better solutions:
> 
> 1. change the runtime_pm subsystem to allow it to ignore some devices
> in an easy way.
> 
> 2. change the device layout if the sysmmu. If the iommu device is
> a child of the device that it is responsible for, I guess you don't
> have this problem.
> 
> 3. Not represent the iommu as a device at all, just as a property
> of another device.

Ok, we will handle this issue somehow. I consider this a minor issue and I
would like to focus on the IOMMU/dma-mapping APIs first.
 
> > > When you register the iommu unconditionally, it becomes impossible for
> > > this driver to coexist with other iommu drivers in the same kernel,
> > > which does against the concept of having a platform driver for this.
> >
> > > It might be better to call the s5p_sysmmu_register function from
> > > the board files and have no platform devices at all if each IOMMU
> > > is always bound to a specific device anyway.
> >
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

Ok. I understand. IOMMU API is quite nice abstraction of the IOMMU chip.
dma-mapping API is something much more complex that creates the actual
mapping for various sets of the devices. IMHO the right direction will
be to create dma-mapping implementation that will be just a client of
the IOMMU API. What's your opinion?

(snipped)

> > The domain defined in iommu api are quite straightforward. Each domain
> > is just a set of mappings between physical addresses (phys) and io
> addresses
> > (iova).
> >
> > For the drivers the most important are the following functions:
> > iommu_{attach,detach}_device(struct iommu_domain *domain, struct device
> *dev);
> >
> > We assumed that they just assign the domain (mapping) to particular
> instance
> > of iommu. However the driver need to get somehow the pointer to the iommu
> > instance. That's why we added the s5p_sysmmu_{get,put} functions.
> >
> > Now I see that you want to make the clients (drivers) to provide their
> own
> > struct device pointer to the iommu_{attach,detach}_device() function
> instead of
> > giving there a pointer to iommu device. Am I right? We will need some
> kind of
> > mapping between multimedia devices and particular instanced of sysmmu
> > controllers.
> >
> > There will be also some problems with such approach. Mainly we have a
> > multimedia codec module, which have 2 memory controllers (for faster
> transfers)
> > and 2 iommu controllers. How can we handle such case?
> 
> It's not quite how the domains are meant to be used. In the AMD IOMMU
> that the API is based on, any number of devices can share one domain,
> and devices might be able to have mappings in multiple domains.
> 
> The domain really reflects the user, not the device here, which makes more
> sense if you think of virtual machines than of multimedia devices.
>
> I would suggest that you just use a single iommu_domain globally for
> all in-kernel users.

There are cases where having a separate mapping for each device makes sense.
It definitely increases the security and helps to find some bugs in
the drivers.

Getting back to our video codec - it has 2 IOMMU controllers. The codec
hardware is able to address only 256MiB of space. Do you have an idea how
this can be handled with dma-mapping API? The only idea that comes to my
mind is to provide a second, fake 'struct device' and use it for allocations
for the second IOMMU controller.

> > > > diff --git a/arch/arm/plat-samsung/include/plat/devs.h
> b/arch/arm/plat-
> > > samsung/include/plat/devs.h
> > > > index f0da6b7..0ae5dd0 100644
> > > > --- a/arch/arm/plat-samsung/include/plat/devs.h
> > > > +++ b/arch/arm/plat-samsung/include/plat/devs.h
> > > > @@ -142,7 +142,7 @@ extern struct platform_device s5p_device_fimc3;
> > > >  extern struct platform_device s5p_device_mipi_csis0;
> > > >  extern struct platform_device s5p_device_mipi_csis1;
> > > >
> > > > -extern struct platform_device exynos4_device_sysmmu;
> > > > +extern struct platform_device exynos4_device_sysmmu[];
> > >
> > > Why is this a global variable? I would expect this to be private to the
> > > implementation.
> >
> > To allow each board to register only particular instances of sysmmu
> controllers.
> 
> That sounds like an unnecessarily complicated way of doing it. This would
> be another reason to not make each one a device, but have something else
> in struct device take care of it.

Well, having each iommu instantiated as a separate device has some advantages,
but I agree that having it automatically registered together with the
corresponding multimedia (client) device will simplify a lot of things. Same
rules should imho apply to power domain drivers.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
