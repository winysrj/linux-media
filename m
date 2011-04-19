Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:62284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab1DSMuC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 08:50:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Tue, 19 Apr 2011 14:49:50 +0200
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	"'Kyungmin Park'" <kyungmin.park@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"'Kukjin Kim'" <kgene.kim@samsung.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <201104181612.35833.arnd@arndb.de> <005f01cbfe6b$148a8810$3d9f9830$%szyprowski@samsung.com>
In-Reply-To: <005f01cbfe6b$148a8810$3d9f9830$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191449.50824.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

(adding Joerg to Cc)

On Tuesday 19 April 2011, Marek Szyprowski wrote:

> > These look wrong for a number of reasons:
> > 
> > * try_module_get(THIS_MODULE) makes no sense at all, the idea of the
> >   try_module_get is to pin down another module that was calling down,
> >   which I suppose is not needed here.
> > 
> > * This extends the generic IOMMU API in platform specific ways, don't
> >   do that.
> > 
> > * I think you can do without these functions by including a pointer
> >   to the iommu structure in dev_archdata, see
> >   arch/powerpc/include/asm/device.h for an example.
> 
> We heavily based our solution on the iommu implementation found in 
> arch/arm/mach-msm/{devices-iommu,iommu,iommu_dev}.c
> 
> The s5p_sysmmu_get/put functions are equivalent for msm_iommu_{get,put}_ctx.
> 
> (snipped)

Yes, I'm sorry about this. I commented on the early versions of the MSM
driver, but then did not do another review of the version that actually
got merged. That should also be fixed, ideally we can come up with a
way that works for both drivers.

> > Why even provide these when they don't do anything?
> 
> Because they are required by pm_runtime. If no runtime_{suspend,resume}
> methods are provided, the pm_runtime core will not call proper methods
> on parent device for pmruntime_{get,put}_sync(). The parent device for
> each sysmmu platform device is the power domain the sysmmu belongs to.
> 
> I know this is crazy, but this is the only way it can be handled now
> with runtime_pm.

Please don't try to work around kernel features when they don't fit
what you are doing. The intent of the way that runtime_pm works is
to make life easier for driver writers, not harder ;-)

I can see three ways that would be better solutions:

1. change the runtime_pm subsystem to allow it to ignore some devices
in an easy way.

2. change the device layout if the sysmmu. If the iommu device is
a child of the device that it is responsible for, I guess you don't
have this problem.

3. Not represent the iommu as a device at all, just as a property
of another device.

> > When you register the iommu unconditionally, it becomes impossible for
> > this driver to coexist with other iommu drivers in the same kernel,
> > which does against the concept of having a platform driver for this.
> 
> > It might be better to call the s5p_sysmmu_register function from
> > the board files and have no platform devices at all if each IOMMU
> > is always bound to a specific device anyway.
> 
> Ok, it looks I don't fully get how this iommu.h should be used. It looks
> that there can be only one instance of iommu ops registered in the system,
> so only one iommu driver can be activated. You are right that the iommu
> driver has to be registered on first probe().

That is a limitation of the current implementation. We might want to
change that anyway, e.g. to handle the mali IOMMU along with yours.
I believe the reason for allowing only one IOMMU type so far has been
that nobody required more than one. As I mentioned, the IOMMU API is
rather new and has not been ported to much variety of hardware, unlike
the dma-mapping API, which does support multiple different IOMMUs
in a single system.

> I think it might be beneficial to describe a bit more our hardware 
> (Exynos4 platform). There are a number of multimedia blocks. Each has it's
> own IOMMU controller. Each IOMMU controller has his own set of hardware
> registers and irq. There is also a GPU unit (Mali) which has it's own
> IOMMU hardware, incompatible with the SYSMMU, so right now it is ignored.
> 
> The multimedia blocks are modeled as platform devices and are independent
> of platform type (same multimedia blocks can be found on other Samsung
> machines, like for example s5pv210/s5pc110), see arch/arm/plat-s5p/dev-*.c
> and arch/arm/plat-samsung/dev-*.c.
> 
> Platform driver data defined in the above files are registered by each
> board startup code, usually by platform_add_devices(), for more details
> please check arch/arm/mach-s5pv210/mach-goni.c. There is
> struct platform_device *goni_devices[] array which get registered in the
> last line in goni_machine_init() function.
> 
> For IOMMU controllers on Exynos4 we created an array of platform devices:
> extern struct platform_device exynos4_device_sysmmu[];
> 
> Now the board startup code registers only these sysmmu controllers
> (instances) that are required on the particular board. See "[PATCH 7/7]
> ARM: EXYNOS4: enable FIMC on Universal_C210":
> @@ -613,6 +616,15 @@ static struct platform_device *universal_devices[]
> __initdata = {
>         &s3c_device_hsmmc2,
>         &s3c_device_hsmmc3,
>         &s3c_device_i2c5,
> +       &s5p_device_fimc0,
> +       &s5p_device_fimc1,
> +       &s5p_device_fimc2,
> +       &s5p_device_fimc3,
> +       &exynos4_device_pd[PD_CAM],
> +       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC0],
> +       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC1],
> +       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC2],
> +       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC3],
> 
> We need to map the above structure into linux/iommu.h api.

Thanks for the background information.

> The domain defined in iommu api are quite straightforward. Each domain 
> is just a set of mappings between physical addresses (phys) and io addresses
> (iova).
> 
> For the drivers the most important are the following functions:
> iommu_{attach,detach}_device(struct iommu_domain *domain, struct device *dev);
> 
> We assumed that they just assign the domain (mapping) to particular instance
> of iommu. However the driver need to get somehow the pointer to the iommu 
> instance. That's why we added the s5p_sysmmu_{get,put} functions. 
> 
> Now I see that you want to make the clients (drivers) to provide their own
> struct device pointer to the iommu_{attach,detach}_device() function instead of
> giving there a pointer to iommu device. Am I right? We will need some kind of
> mapping between multimedia devices and particular instanced of sysmmu
> controllers.
> 
> There will be also some problems with such approach. Mainly we have a
> multimedia codec module, which have 2 memory controllers (for faster transfers)
> and 2 iommu controllers. How can we handle such case?

It's not quite how the domains are meant to be used. In the AMD IOMMU
that the API is based on, any number of devices can share one domain,
and devices might be able to have mappings in multiple domains.

The domain really reflects the user, not the device here, which makes more
sense if you think of virtual machines than of multimedia devices.

I would suggest that you just use a single iommu_domain globally for
all in-kernel users.

> > > diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-
> > samsung/include/plat/devs.h
> > > index f0da6b7..0ae5dd0 100644
> > > --- a/arch/arm/plat-samsung/include/plat/devs.h
> > > +++ b/arch/arm/plat-samsung/include/plat/devs.h
> > > @@ -142,7 +142,7 @@ extern struct platform_device s5p_device_fimc3;
> > >  extern struct platform_device s5p_device_mipi_csis0;
> > >  extern struct platform_device s5p_device_mipi_csis1;
> > >
> > > -extern struct platform_device exynos4_device_sysmmu;
> > > +extern struct platform_device exynos4_device_sysmmu[];
> > 
> > Why is this a global variable? I would expect this to be private to the
> > implementation.
> 
> To allow each board to register only particular instances of sysmmu controllers.

That sounds like an unnecessarily complicated way of doing it. This would
be another reason to not make each one a device, but have something else
in struct device take care of it.

	Arnd
