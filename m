Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:35482 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751539AbdFIMLP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Jun 2017 08:11:15 -0400
Received: by mail-yb0-f176.google.com with SMTP id f192so15326284yba.2
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 05:11:14 -0700 (PDT)
Received: from mail-yw0-f175.google.com (mail-yw0-f175.google.com. [209.85.161.175])
        by smtp.gmail.com with ESMTPSA id u10sm270040ywa.53.2017.06.09.05.11.13
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2017 05:11:13 -0700 (PDT)
Received: by mail-yw0-f175.google.com with SMTP id e142so12427963ywa.1
        for <linux-media@vger.kernel.org>; Fri, 09 Jun 2017 05:11:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2207008.so7vZvfgDl@ttoivone-desk1>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <CAAFQd5BZGVBdbN-8L+pvAf4AkBkB9UFy7_mmMpusFUMxDugQDw@mail.gmail.com>
 <CAAFQd5CdV4ZfAYHH7DBBfOY=c4_Lwnuf8COs=JUKRSjp1VTn7Q@mail.gmail.com> <2207008.so7vZvfgDl@ttoivone-desk1>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 9 Jun 2017 21:10:52 +0900
Message-ID: <CAAFQd5Aw1DuhGK0d-uK5jr6_6np10pO8X6ArrymeF1MnwTG4qQ@mail.gmail.com>
Subject: Re: [PATCH 02/12] intel-ipu3: mmu: implement driver
To: Tuukka Toivonen <tuukka.toivonen@intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 9, 2017 at 5:26 PM, Tuukka Toivonen
<tuukka.toivonen@intel.com> wrote:
> Hi Tomasz,
>
> Couple of small comments below.
>
> On Wednesday, June 07, 2017 17:35:13 Tomasz Figa wrote:
>> >> +static void ipu3_mmu_domain_free(struct iommu_domain *dom)
>> >> +{
>> >> +       struct ipu3_mmu_domain *mmu_dom =
>> >> +               container_of(dom, struct ipu3_mmu_domain, domain);
>> >> +       uint32_t l1_idx;
>> >> +
>> >> +       for (l1_idx = 0; l1_idx < IPU3_MMU_L1PT_PTES; l1_idx++)
>> >> +               if (mmu_dom->pgtbl[l1_idx] != mmu_dom-
>>dummy_l2_tbl)
>> >> +                       free_page((unsigned long)
>> >> +                                 TBL_VIRT_ADDR(mmu_dom-
>>pgtbl[l1_idx]));
>> >> +
>> >> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom-
>>dummy_page));
>> >> +       free_page((unsigned long)TBL_VIRT_ADDR(mmu_dom-
>>dummy_l2_tbl));
>>
>> I might be overly paranoid, but reading back kernel virtual pointers
>> from device accessible memory doesn't seem safe to me. Other drivers
>> keep kernel pointers of page tables in a dedicated array (it's only 8K
>> of memory, but much better safety).
>
> They are accessible only to the IPU3 IOMMU, which can access whole
> system memory anyway and always does a read-only access to the MMU
> tables. So, I wouldn't worry too much, although extra copy for safety
> wouldn't necessarily harm too much.

Fair enough. Thanks for explanation.

>
> <...>
>
>> >> +       ipu3_mmu_tlb_invalidate(mmu_dom->mmu->base);
>> >> +
>> >> +       return unmapped << IPU3_MMU_PAGE_SHIFT;
>> >> +}
>> >> +
>> >> +static phys_addr_t ipu3_mmu_iova_to_phys(struct iommu_domain
> *domain,
>> >> +                                        dma_addr_t iova)
>> >> +{
>> >> +       struct ipu3_mmu_domain *d =
>> >> +               container_of(domain, struct ipu3_mmu_domain,
> domain);
>> >> +       uint32_t *l2_pt = TBL_VIRT_ADDR(d->pgtbl[iova >>
> IPU3_MMU_L1PT_SHIFT]);
>> >> +
>> >> +       return (phys_addr_t)l2_pt[(iova & IPU3_MMU_L2PT_MASK)
>> >> +                               >> IPU3_MMU_L2PT_SHIFT] <<
> IPU3_MMU_PAGE_SHIFT;
>>
>> Could we avoid this TBL_VIRT_ADDR() here too? The memory cost to store
>> the page table CPU pointers is really small, but safety seems much
>> better. Moreover, it should make it possible to use the VT-d IOMMU to
>> further secure the system.
>
> IPU3 doesn't support VT-d and can't be enabled while VT-d is on.

Got it. Thanks.

Best regards,
Tomasz
