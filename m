Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:50290 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1DROMt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:12:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU) driver
Date: Mon, 18 Apr 2011 16:12:35 +0200
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Andrzej Pietrasiwiecz <andrzej.p@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
References: <1303118804-5575-1-git-send-email-m.szyprowski@samsung.com> <1303118804-5575-3-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1303118804-5575-3-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181612.35833.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 18 April 2011, Marek Szyprowski wrote:
> From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> 
> This patch performs a complete rewrite of sysmmu driver for Samsung platform:
> - simplified the resource management: no more single platform
>   device with 32 resources is needed, better fits into linux driver model,
>   each sysmmu instance has it's own resource definition
> - the new version uses kernel wide common iommu api defined in include/iommu.h
> - cleaned support for sysmmu clocks
> - added support for custom fault handlers and tlb replacement policy

Looks like good progress, but I fear that there is still quite a bit more
work needed here.

> +static int debug;
> +module_param(debug, int, 0644);
> +
> +#define sysmmu_debug(level, fmt, arg...)                                \
> +       do {                                                             \
> +               if (debug >= level)                                      \
> +                       printk(KERN_DEBUG "[%s] " fmt, __func__, ## arg);\
> +       } while (0)

Just use dev_dbg() here, the kernel already has all the infrastructure.

> +
> +#define generic_extract(l, s, entry) \
> +                               ((entry) & l##LPT_##s##_MASK)
> +#define flpt_get_1m(entry)     generic_extract(F, 1M, deref_va(entry))
> +#define flpt_get_16m(entry)    generic_extract(F, 16M, deref_va(entry))
> +#define slpt_get_4k(entry)     generic_extract(S, 4K, deref_va(entry))
> +#define slpt_get_64k(entry)    generic_extract(S, 64K, deref_va(entry))
> +
> +#define generic_entry(l, s, entry) \
> +                               (generic_extract(l, s, entry)  | PAGE_##s)
> +#define flpt_ent_4k_64k(entry) generic_entry(F, 4K_64K, entry)
> +#define flpt_ent_1m(entry)     generic_entry(F, 1M, entry)
> +#define flpt_ent_16m(entry)    generic_entry(F, 16M, entry)
> +#define slpt_ent_4k(entry)     generic_entry(S, 4K, entry)
> +#define slpt_ent_64k(entry)    generic_entry(S, 64K, entry)
> +
> +#define page_4k_64k(entry)     (deref_va(entry) & PAGE_4K_64K)
> +#define page_1m(entry)         (deref_va(entry) & PAGE_1M)
> +#define page_16m(entry)                ((deref_va(entry) & PAGE_16M) == PAGE_16M)
> +#define page_4k(entry)         (deref_va(entry) & PAGE_4K)
> +#define page_64k(entry)                (deref_va(entry) & PAGE_64K)
> +
> +#define generic_pg_offs(l, s, va) \
> +                               (va & ~l##LPT_##s##_MASK)
> +#define pg_offs_1m(va)         generic_pg_offs(F, 1M, va)
> +#define pg_offs_16m(va)                generic_pg_offs(F, 16M, va)
> +#define pg_offs_4k(va)         generic_pg_offs(S, 4K, va)
> +#define pg_offs_64k(va)                generic_pg_offs(S, 64K, va)
> +
> +#define flpt_index(va)         (((va) >> FLPT_IDX_SHIFT) & FLPT_IDX_MASK)
> +
> +#define generic_offset(l, va)  (((va) >> l##LPT_OFFS_SHIFT) & l##LPT_OFFS_MASK)
> +#define flpt_offs(va)          generic_offset(F, va)
> +#define slpt_offs(va)          generic_offset(S, va)
> +
> +#define invalidate_slpt_ent(slpt_va) (deref_va(slpt_va) = 0UL)
> +
> +#define get_irq_callb(cb) \
> +                               (s5p_domain->irq_callb ? \
> +                                       (s5p_domain->irq_callb->cb ? \
> +                                       s5p_domain->irq_callb->cb : \
> +                                       s5p_sysmmu_irq_callb.cb) \
> +                               : s5p_sysmmu_irq_callb.cb)

These macros are really confusing, especially the ones that implicitly
access variables with a specific name. How about converting them into
inline functions?

> +phys_addr_t s5p_iova_to_phys(struct iommu_domain *domain, unsigned long iova)

This should be static.

> +struct device *s5p_sysmmu_get(enum s5p_sysmmu_ip ip)
> +{
> +       struct device *ret = NULL;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&sysmmu_slock, flags);
> +       if (sysmmu_table[ip]) {
> +               try_module_get(THIS_MODULE);
> +               ret = sysmmu_table[ip]->dev;
> +       }
> +       spin_unlock_irqrestore(&sysmmu_slock, flags);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(s5p_sysmmu_get);
> +
> +void s5p_sysmmu_put(void *dev)
> +{
> +       BUG_ON(!dev);
> +       module_put(THIS_MODULE);
> +}
> +EXPORT_SYMBOL_GPL(s5p_sysmmu_put);

These look wrong for a number of reasons:

* try_module_get(THIS_MODULE) makes no sense at all, the idea of the
  try_module_get is to pin down another module that was calling down,
  which I suppose is not needed here.

* This extends the generic IOMMU API in platform specific ways, don't
  do that.

* I think you can do without these functions by including a pointer
  to the iommu structure in dev_archdata, see
  arch/powerpc/include/asm/device.h for an example.

> +void s5p_sysmmu_domain_irq_callb(struct iommu_domain *domain,
> +                           struct s5p_sysmmu_irq_callb *ops, void *priv)
> +{
> +       struct s5p_sysmmu_domain *s5p_domain = domain->priv;
> +       s5p_domain->irq_callb = ops;
> +       s5p_domain->irq_callb_priv = priv;
> +}
> +EXPORT_SYMBOL(s5p_sysmmu_domain_irq_callb);
> +
> +
> +void s5p_sysmmu_domain_tlb_policy(struct iommu_domain *domain, int policy)
> +{
> +       struct s5p_sysmmu_domain *s5p_domain = domain->priv;
> +       s5p_domain->policy = policy;
> +}
> +EXPORT_SYMBOL(s5p_sysmmu_domain_tlb_policy);

More private extensions that should not be here. Better extend the generic
IOMMU API to contain callbacks for these if they are required, and document
them in a generic location.

> +static void s5p_sysmmu_irq_page_fault(struct iommu_domain *domain, int reason,
> +                                     unsigned long addr, void *priv)
> +{
> +       sysmmu_debug(3, "%s: Faulting virtual address: 0x%08lx\n",
> +                    irq_reasons[reason], addr);
> +       BUG();
> +}
> +
> +static void s5p_sysmmu_irq_generic_callb(struct iommu_domain *domain,
> +                                        int reason, unsigned long addr,
> +                                        void *priv)
> +{
> +       sysmmu_debug(3, "%s\n", irq_reasons[reason]);
> +       BUG();
> +}

Why BUG() here? The backtrace of an interrupt handler should be rather
uninteresting, and you just end up in panic() since this is run
from an interrupt handler.

> +static struct s5p_sysmmu_irq_callb s5p_sysmmu_irq_callb = {
> +       .page_fault = s5p_sysmmu_irq_page_fault,
> +       .ar_fault = s5p_sysmmu_irq_generic_callb,
> +       .aw_fault = s5p_sysmmu_irq_generic_callb,
> +       .bus_error = s5p_sysmmu_irq_generic_callb,
> +       .ar_security = s5p_sysmmu_irq_generic_callb,
> +       .ar_prot = s5p_sysmmu_irq_generic_callb,
> +       .aw_security = s5p_sysmmu_irq_generic_callb,
> +       .aw_prot = s5p_sysmmu_irq_generic_callb,
> +};
> +
> +static irqreturn_t s5p_sysmmu_irq(int irq, void *dev_id)
> +{
> +       struct s5p_sysmmu_info *sysmmu = dev_id;
> +       struct s5p_sysmmu_domain *s5p_domain = sysmmu->domain->priv;
> +       unsigned int reg_INT_STATUS;
> +
> +       if (false == sysmmu->enabled)
> +               return IRQ_HANDLED;
> +
> +       reg_INT_STATUS = readl(sysmmu->regs + S5P_INT_STATUS);
> +       if (reg_INT_STATUS & 0xFF) {
> +               S5P_IRQ_CB(cb);
> +               enum s5p_sysmmu_fault reason = 0;
> +               unsigned long fault = 0;
> +               unsigned reg = 0;
> +               cb = NULL;
> +               switch (reg_INT_STATUS & 0xFF) {
> +               case 0x1:
> +                       cb = get_irq_callb(page_fault);
> +                       reason = S5P_SYSMMU_PAGE_FAULT;
> +                       reg = S5P_PAGE_FAULT_ADDR;
> +                       break;
> +               case 0x2:
> +                       cb = get_irq_callb(ar_fault);
> +                       reason = S5P_SYSMMU_AR_FAULT;
> +                       reg = S5P_AR_FAULT_ADDR;
> +                       break;
> +               case 0x4:
> +                       cb = get_irq_callb(aw_fault);
> +                       reason = S5P_SYSMMU_AW_FAULT;
> +                       reg = S5P_AW_FAULT_ADDR;
> +                       break;
> +               case 0x8:
> +                       cb = get_irq_callb(bus_error);
> +                       reason = S5P_SYSMMU_BUS_ERROR;
> +                       /* register common to page fault and bus error */
> +                       reg = S5P_PAGE_FAULT_ADDR;
> +                       break;
> +               case 0x10:
> +                       cb = get_irq_callb(ar_security);
> +                       reason = S5P_SYSMMU_AR_SECURITY;
> +                       reg = S5P_AR_FAULT_ADDR;
> +                       break;
> +               case 0x20:
> +                       cb = get_irq_callb(ar_prot);
> +                       reason = S5P_SYSMMU_AR_PROT;
> +                       reg = S5P_AR_FAULT_ADDR;
> +                       break;
> +               case 0x40:
> +                       cb = get_irq_callb(aw_security);
> +                       reason = S5P_SYSMMU_AW_SECURITY;
> +                       reg = S5P_AW_FAULT_ADDR;
> +                       break;
> +               case 0x80:
> +                       cb = get_irq_callb(aw_prot);
> +                       reason = S5P_SYSMMU_AW_PROT;
> +                       reg = S5P_AW_FAULT_ADDR;
> +                       break;
> +               }
> +               fault = readl(sysmmu->regs + reg);
> +               cb(sysmmu->domain, reason, fault, s5p_domain->irq_callb_priv);
> +               writel(reg_INT_STATUS, sysmmu->regs + S5P_INT_CLEAR);
> +       }
> +       return IRQ_HANDLED;
> +}

I think it would be more readable and more efficient to just use a lookup
table here instead of the long switch/case statement.

> +static int
> +s5p_sysmmu_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +       int ret = 0;
> +       sysmmu_debug(3, "begin\n");
> +
> +       return ret;
> +}
> +
> +static int s5p_sysmmu_resume(struct platform_device *pdev)
> +{
> +       int ret = 0;
> +       sysmmu_debug(3, "begin\n");
> +
> +       return ret;
> +}
> +
> +static int s5p_sysmmu_runtime_suspend(struct device *dev)
> +{
> +       sysmmu_debug(3, "begin\n");
> +       return 0;
> +}
> +
> +static int s5p_sysmmu_runtime_resume(struct device *dev)
> +{
> +       sysmmu_debug(3, "begin\n");
> +       return 0;
> +}

Why even provide these when they don't do anything?

> +static int __init
> +s5p_sysmmu_register(void)
> +{
> +       int ret;
> +
> +       sysmmu_debug(3, "Registering sysmmu driver...\n");
> +
> +       slpt_cache = kmem_cache_create("slpt_cache", 1024, 1024,
> +                                      SLAB_HWCACHE_ALIGN, NULL);
> +       if (!slpt_cache) {
> +               printk(KERN_ERR
> +                       "%s: failed to allocated slpt cache\n", __func__);
> +               return -ENOMEM;
> +       }
> +
> +       ret = platform_driver_register(&s5p_sysmmu_driver);
> +
> +       if (ret) {
> +               printk(KERN_ERR
> +                       "%s: failed to register sysmmu driver\n", __func__);
> +               return -EINVAL;
> +       }
> +
> +       register_iommu(&s5p_sysmmu_ops);
> +
> +       return ret;
> +}

When you register the iommu unconditionally, it becomes impossible for
this driver to coexist with other iommu drivers in the same kernel,
which does against the concept of having a platform driver for this.

It might be better to call the s5p_sysmmu_register function from
the board files and have no platform devices at all if each IOMMU
is always bound to a specific device anyway. 

> diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-samsung/include/plat/devs.h
> index f0da6b7..0ae5dd0 100644
> --- a/arch/arm/plat-samsung/include/plat/devs.h
> +++ b/arch/arm/plat-samsung/include/plat/devs.h
> @@ -142,7 +142,7 @@ extern struct platform_device s5p_device_fimc3;
>  extern struct platform_device s5p_device_mipi_csis0;
>  extern struct platform_device s5p_device_mipi_csis1;
>  
> -extern struct platform_device exynos4_device_sysmmu;
> +extern struct platform_device exynos4_device_sysmmu[];
  
Why is this a global variable? I would expect this to be private to the
implementation.

	Arnd
