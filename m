Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16355 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab1DSIXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 04:23:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 19 Apr 2011 10:23:36 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU)
	driver
In-reply-to: <201104181612.35833.arnd@arndb.de>
To: 'Arnd Bergmann' <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	'Kukjin Kim' <kgene.kim@samsung.com>
Message-id: <005f01cbfe6b$148a8810$3d9f9830$%szyprowski@samsung.com>
Content-language: pl
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com>
 <1303118804-5575-3-git-send-email-m.szyprowski@samsung.com>
 <201104181612.35833.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Monday, April 18, 2011 4:13 PM Arnd Bergmann wrote:

> On Monday 18 April 2011, Marek Szyprowski wrote:
> > From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> >
> > This patch performs a complete rewrite of sysmmu driver for Samsung
> platform:
> > - simplified the resource management: no more single platform
> >   device with 32 resources is needed, better fits into linux driver model,
> >   each sysmmu instance has it's own resource definition
> > - the new version uses kernel wide common iommu api defined in
> include/iommu.h
> > - cleaned support for sysmmu clocks
> > - added support for custom fault handlers and tlb replacement policy
> 
> Looks like good progress, but I fear that there is still quite a bit more
> work needed here.

Thanks for your comments! I've snipped the minor implementation comments
and focused only on the core iommu API.

(snipped)

> > +struct device *s5p_sysmmu_get(enum s5p_sysmmu_ip ip)
> > +{
> > +       struct device *ret = NULL;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&sysmmu_slock, flags);
> > +       if (sysmmu_table[ip]) {
> > +               try_module_get(THIS_MODULE);
> > +               ret = sysmmu_table[ip]->dev;
> > +       }
> > +       spin_unlock_irqrestore(&sysmmu_slock, flags);
> > +
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(s5p_sysmmu_get);
> > +
> > +void s5p_sysmmu_put(void *dev)
> > +{
> > +       BUG_ON(!dev);
> > +       module_put(THIS_MODULE);
> > +}
> > +EXPORT_SYMBOL_GPL(s5p_sysmmu_put);
> 
> These look wrong for a number of reasons:
> 
> * try_module_get(THIS_MODULE) makes no sense at all, the idea of the
>   try_module_get is to pin down another module that was calling down,
>   which I suppose is not needed here.
> 
> * This extends the generic IOMMU API in platform specific ways, don't
>   do that.
> 
> * I think you can do without these functions by including a pointer
>   to the iommu structure in dev_archdata, see
>   arch/powerpc/include/asm/device.h for an example.

We heavily based our solution on the iommu implementation found in 
arch/arm/mach-msm/{devices-iommu,iommu,iommu_dev}.c

The s5p_sysmmu_get/put functions are equivalent for msm_iommu_{get,put}_ctx.

(snipped)

> > +static int
> > +s5p_sysmmu_suspend(struct platform_device *pdev, pm_message_t state)
> > +{
> > +       int ret = 0;
> > +       sysmmu_debug(3, "begin\n");
> > +
> > +       return ret;
> > +}
> > +
> > +static int s5p_sysmmu_resume(struct platform_device *pdev)
> > +{
> > +       int ret = 0;
> > +       sysmmu_debug(3, "begin\n");
> > +
> > +       return ret;
> > +}
> > +
> > +static int s5p_sysmmu_runtime_suspend(struct device *dev)
> > +{
> > +       sysmmu_debug(3, "begin\n");
> > +       return 0;
> > +}
> > +
> > +static int s5p_sysmmu_runtime_resume(struct device *dev)
> > +{
> > +       sysmmu_debug(3, "begin\n");
> > +       return 0;
> > +}
> 
> Why even provide these when they don't do anything?

Because they are required by pm_runtime. If no runtime_{suspend,resume}
methods are provided, the pm_runtime core will not call proper methods
on parent device for pmruntime_{get,put}_sync(). The parent device for
each sysmmu platform device is the power domain the sysmmu belongs to.

I know this is crazy, but this is the only way it can be handled now
with runtime_pm.

> > +static int __init
> > +s5p_sysmmu_register(void)
> > +{
> > +       int ret;
> > +
> > +       sysmmu_debug(3, "Registering sysmmu driver...\n");
> > +
> > +       slpt_cache = kmem_cache_create("slpt_cache", 1024, 1024,
> > +                                      SLAB_HWCACHE_ALIGN, NULL);
> > +       if (!slpt_cache) {
> > +               printk(KERN_ERR
> > +                       "%s: failed to allocated slpt cache\n",
> __func__);
> > +               return -ENOMEM;
> > +       }
> > +
> > +       ret = platform_driver_register(&s5p_sysmmu_driver);
> > +
> > +       if (ret) {
> > +               printk(KERN_ERR
> > +                       "%s: failed to register sysmmu driver\n",
> __func__);
> > +               return -EINVAL;
> > +       }
> > +
> > +       register_iommu(&s5p_sysmmu_ops);
> > +
> > +       return ret;
> > +}
> 
> When you register the iommu unconditionally, it becomes impossible for
> this driver to coexist with other iommu drivers in the same kernel,
> which does against the concept of having a platform driver for this.

> It might be better to call the s5p_sysmmu_register function from
> the board files and have no platform devices at all if each IOMMU
> is always bound to a specific device anyway.

Ok, it looks I don't fully get how this iommu.h should be used. It looks
that there can be only one instance of iommu ops registered in the system,
so only one iommu driver can be activated. You are right that the iommu
driver has to be registered on first probe().

I think it might be beneficial to describe a bit more our hardware 
(Exynos4 platform). There are a number of multimedia blocks. Each has it's
own IOMMU controller. Each IOMMU controller has his own set of hardware
registers and irq. There is also a GPU unit (Mali) which has it's own
IOMMU hardware, incompatible with the SYSMMU, so right now it is ignored.

The multimedia blocks are modeled as platform devices and are independent
of platform type (same multimedia blocks can be found on other Samsung
machines, like for example s5pv210/s5pc110), see arch/arm/plat-s5p/dev-*.c
and arch/arm/plat-samsung/dev-*.c.

Platform driver data defined in the above files are registered by each
board startup code, usually by platform_add_devices(), for more details
please check arch/arm/mach-s5pv210/mach-goni.c. There is
struct platform_device *goni_devices[] array which get registered in the
last line in goni_machine_init() function.

For IOMMU controllers on Exynos4 we created an array of platform devices:
extern struct platform_device exynos4_device_sysmmu[];

Now the board startup code registers only these sysmmu controllers
(instances) that are required on the particular board. See "[PATCH 7/7]
ARM: EXYNOS4: enable FIMC on Universal_C210":
@@ -613,6 +616,15 @@ static struct platform_device *universal_devices[]
__initdata = {
        &s3c_device_hsmmc2,
        &s3c_device_hsmmc3,
        &s3c_device_i2c5,
+       &s5p_device_fimc0,
+       &s5p_device_fimc1,
+       &s5p_device_fimc2,
+       &s5p_device_fimc3,
+       &exynos4_device_pd[PD_CAM],
+       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC0],
+       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC1],
+       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC2],
+       &exynos4_device_sysmmu[S5P_SYSMMU_FIMC3],

We need to map the above structure into linux/iommu.h api.

The domain defined in iommu api are quite straightforward. Each domain 
is just a set of mappings between physical addresses (phys) and io addresses
(iova).

For the drivers the most important are the following functions:
iommu_{attach,detach}_device(struct iommu_domain *domain, struct device *dev);

We assumed that they just assign the domain (mapping) to particular instance
of iommu. However the driver need to get somehow the pointer to the iommu 
instance. That's why we added the s5p_sysmmu_{get,put} functions. 

Now I see that you want to make the clients (drivers) to provide their own
struct device pointer to the iommu_{attach,detach}_device() function instead of
giving there a pointer to iommu device. Am I right? We will need some kind of
mapping between multimedia devices and particular instanced of sysmmu
controllers.

There will be also some problems with such approach. Mainly we have a
multimedia codec module, which have 2 memory controllers (for faster transfers)
and 2 iommu controllers. How can we handle such case?

> > diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-
> samsung/include/plat/devs.h
> > index f0da6b7..0ae5dd0 100644
> > --- a/arch/arm/plat-samsung/include/plat/devs.h
> > +++ b/arch/arm/plat-samsung/include/plat/devs.h
> > @@ -142,7 +142,7 @@ extern struct platform_device s5p_device_fimc3;
> >  extern struct platform_device s5p_device_mipi_csis0;
> >  extern struct platform_device s5p_device_mipi_csis1;
> >
> > -extern struct platform_device exynos4_device_sysmmu;
> > +extern struct platform_device exynos4_device_sysmmu[];
> 
> Why is this a global variable? I would expect this to be private to the
> implementation.

To allow each board to register only particular instances of sysmmu controllers.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
