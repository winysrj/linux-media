Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52084 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751694AbdFII1B (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Jun 2017 04:27:01 -0400
From: Tuukka Toivonen <tuukka.toivonen@intel.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 02/12] intel-ipu3: mmu: implement driver
Date: Fri, 09 Jun 2017 11:26:53 +0300
Message-ID: <2207008.so7vZvfgDl@ttoivone-desk1>
In-Reply-To: <CAAFQd5CdV4ZfAYHH7DBBfOY=c4_Lwnuf8COs=JUKRSjp1VTn7Q@mail.gmail.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com> <CAAFQd5BZGVBdbN-8L+pvAf4AkBkB9UFy7_mmMpusFUMxDugQDw@mail.gmail.com> <CAAFQd5CdV4ZfAYHH7DBBfOY=c4_Lwnuf8COs=JUKRSjp1VTn7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Couple of small comments below.

On Wednesday, June 07, 2017 17:35:13 Tomasz Figa wrote:
> >> +static void ipu3_mmu_domain_free(struct iommu_domain *dom)
> >> +{
> >> +       struct ipu3_mmu_domain *mmu_dom =
> >> +               container_of(dom, struct ipu3_mmu_domain, domain);
> >> +       uint32_t l1_idx;
> >> +
> >> +       for (l1_idx = 0; l1_idx < IPU3_MMU_L1PT_PTES; l1_idx++)
> >> +               if (mmu_dom->pgtbl[l1_idx] != mmu_dom-
>dummy_l2_tbl)
> >> +                       free_page((unsigned long)
> >> +                                 TBL_VIRT_ADDR(mmu_dom-
>pgtbl[l1_idx]));
> >> +
> >> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom-
>dummy_page));
> >> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom-
>dummy_l2_tbl));
> 
> I might be overly paranoid, but reading back kernel virtual pointers
> from device accessible memory doesn't seem safe to me. Other drivers
> keep kernel pointers of page tables in a dedicated array (it's only 8K
> of memory, but much better safety).

They are accessible only to the IPU3 IOMMU, which can access whole 
system memory anyway and always does a read-only access to the MMU 
tables. So, I wouldn't worry too much, although extra copy for safety 
wouldn't necessarily harm too much.

<...>

> >> +       ipu3_mmu_tlb_invalidate(mmu_dom->mmu->base);
> >> +
> >> +       return unmapped << IPU3_MMU_PAGE_SHIFT;
> >> +}
> >> +
> >> +static phys_addr_t ipu3_mmu_iova_to_phys(struct iommu_domain 
*domain,
> >> +                                        dma_addr_t iova)
> >> +{
> >> +       struct ipu3_mmu_domain *d =
> >> +               container_of(domain, struct ipu3_mmu_domain, 
domain);
> >> +       uint32_t *l2_pt = TBL_VIRT_ADDR(d->pgtbl[iova >> 
IPU3_MMU_L1PT_SHIFT]);
> >> +
> >> +       return (phys_addr_t)l2_pt[(iova & IPU3_MMU_L2PT_MASK)
> >> +                               >> IPU3_MMU_L2PT_SHIFT] << 
IPU3_MMU_PAGE_SHIFT;
> 
> Could we avoid this TBL_VIRT_ADDR() here too? The memory cost to store
> the page table CPU pointers is really small, but safety seems much
> better. Moreover, it should make it possible to use the VT-d IOMMU to
> further secure the system.

IPU3 doesn't support VT-d and can't be enabled while VT-d is on.

Regards,
- Tuukka
