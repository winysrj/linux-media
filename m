Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f175.google.com ([209.85.213.175]:35362 "EHLO
        mail-yb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbdFHHhF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 03:37:05 -0400
Received: by mail-yb0-f175.google.com with SMTP id f192so7778605yba.2
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 00:37:05 -0700 (PDT)
Received: from mail-yw0-f178.google.com (mail-yw0-f178.google.com. [209.85.161.178])
        by smtp.gmail.com with ESMTPSA id i138sm1769103ywg.67.2017.06.08.00.37.03
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Jun 2017 00:37:03 -0700 (PDT)
Received: by mail-yw0-f178.google.com with SMTP id 63so10426126ywr.0
        for <linux-media@vger.kernel.org>; Thu, 08 Jun 2017 00:37:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170607215951.GA21034@kekkonen.localdomain>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-3-git-send-email-yong.zhi@intel.com> <CAAFQd5BZGVBdbN-8L+pvAf4AkBkB9UFy7_mmMpusFUMxDugQDw@mail.gmail.com>
 <20170607215951.GA21034@kekkonen.localdomain>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 8 Jun 2017 16:36:42 +0900
Message-ID: <CAAFQd5C1GQKXcgxMJ8TeGf5Zr+4yHV9Eto3f7KYENnCcdKiPkA@mail.gmail.com>
Subject: Re: [PATCH 02/12] intel-ipu3: mmu: implement driver
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thu, Jun 8, 2017 at 6:59 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> Hi Tomasz,
>
> On Tue, Jun 06, 2017 at 07:13:19PM +0900, Tomasz Figa wrote:
>> Hi Yong, Tuukka,
>>
>> +CC IOMMU ML and Joerg. (Technically you should resend this patch
>> including them.)
>
> Thanks!
>
>>
>> On Tue, Jun 6, 2017 at 5:39 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> ...
>> > diff --git a/drivers/media/pci/intel/ipu3/Kconfig b/drivers/media/pci/intel/ipu3/Kconfig
>> > index 2a895d6..ab2edcb 100644
>> > --- a/drivers/media/pci/intel/ipu3/Kconfig
>> > +++ b/drivers/media/pci/intel/ipu3/Kconfig
>> > @@ -15,3 +15,14 @@ config VIDEO_IPU3_CIO2
>> >         Say Y or M here if you have a Skylake/Kaby Lake SoC with MIPI CSI-2
>> >         connected camera.
>> >         The module will be called ipu3-cio2.
>> > +
>> > +config INTEL_IPU3_MMU
>> > +       tristate "Intel ipu3-mmu driver"
>> > +       select IOMMU_API
>> > +       select IOMMU_IOVA
>> > +       ---help---
>> > +         For IPU3, this option enables its MMU driver to translate its internal
>> > +         virtual address to 39 bits wide physical address for 64GBytes space access.
>> > +
>> > +         Say Y here if you have Skylake/Kaby Lake SoC with IPU3.
>> > +         Say N if un-sure.
>>
>> Is the MMU optional? I.e. can you still use the IPU3 without the MMU
>> driver? If no, then it doesn't make sense to flood the user with
>> meaningless choice and the driver could simply be selected by other
>> IPU3 drivers.
>
> There are other IPUs that contain the same hardware, so they would
> presumably use the same driver.

My question was slightly different. I was wondering if one can use the
IPU3 without the MMU, i.e. if the implication "if IPU3 then IPU3_MMU"
exists.

>
>>
>> And the other way around, is the IPU3 MMU driver useful for anything
>> else than IPU3? If no (but yes for the above), then it should depend
>> on some other IPU3 drivers being enabled, as otherwise it would just
>> confuse the user.
>
> Very likely not.
>
> For now I think it'd be fine to have the driver separate from the rest of
> the IPU3 but without a separate Kconfig option.

Yeah, I'm not questioning the need for this to be a separate driver.
:) I just want to avoid adding Kconfig option, in case there is no
practical choice (i.e. IPU3 requires IPU3_MMU and IPU3_MMU is useful
without IPU3).

>
>>
>> > diff --git a/drivers/media/pci/intel/ipu3/Makefile b/drivers/media/pci/intel/ipu3/Makefile
>> > index 20186e3..2b669df 100644
>> > --- a/drivers/media/pci/intel/ipu3/Makefile
>> > +++ b/drivers/media/pci/intel/ipu3/Makefile
>> > @@ -1 +1,2 @@
>> >  obj-$(CONFIG_VIDEO_IPU3_CIO2) += ipu3-cio2.o
>> > +obj-$(CONFIG_INTEL_IPU3_MMU) += ipu3-mmu.o
>> > diff --git a/drivers/media/pci/intel/ipu3/ipu3-mmu.c b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
>> > new file mode 100644
>> > index 0000000..a9fb116
>> > --- /dev/null
>> > +++ b/drivers/media/pci/intel/ipu3/ipu3-mmu.c
>
> ...
>
>> > +/**
>> > + * ipu3_mmu_alloc_page_table - get page to fill entries with dummy defaults
>> > + * @d: mapping domain to be worked on
>> > + * @l1: True for L1 page table, false for L2 page table.
>> > + *
>> > + * Index of L1 page table points to L2 tbl
>> > + *
>> > + * Return: Pointer to allocated page table
>> > + * or NULL on failure.
>> > + */
>> > +static uint32_t *ipu3_mmu_alloc_page_table(struct ipu3_mmu_domain *d, bool l1)
>> > +{
>> > +       uint32_t *pt = (uint32_t *)__get_free_page(GFP_KERNEL);
>>
>> Style: I believe u32 is preferred in the kernel.
>
> There are some 30000 users of uint32_t alone in the kernel. I'd say it
> should be fine. (I'm not trying saying it'd be more common than u32
> though.)

Okay, checked the CodingStyle again and they are generally okay,
except userspace headers, where __u* ones should be used.

>
>> > +               DMA_BIT_MASK(IPU3_MMU_ADDRESS_BITS);
>> > +       mmu_dom->domain.geometry.force_aperture = true;
>> > +
>> > +       ptr = (void *)__get_free_page(GFP_KERNEL);
>> > +       if (!ptr)
>> > +               goto fail_get_page;
>> > +       mmu_dom->dummy_page = virt_to_phys(ptr) >> IPU3_MMU_PAGE_SHIFT;
>>
>> Is virt_to_phys() correct here? I'm not an expert on x86 systems, but
>> since this is a PCI device, there might be some other memory mapping
>> involved.
>
> In theory yes --- if the IPU3 were behind an IOMMU managed by the Linux
> kernel.

Doesn't the VT-d IOMMU actually allow such configuration? (Disclaimer:
I don't know too much about x86 and am reasoning based on few high
level hardware overviews.)

> That kind of configuration wouldn't make much sense

It would make sense from security perspective (the main system IOMMU
is likely more trusted that one of some peripheral device).

It would also make sense from stability perspective. Given that the
IPU3 PCI device seems to be non-coherent, the system IOMMU (which I
believe is coherent) would catch any kinds of device memory reads or
writes due to some device cache management issues, instead of possibly
overwriting some kernel memory not belonging to the driver anymore.

I agree, though, that it might not be the typical configuration one uses.

> and any
> attempt to use such a configuration would probably fall apart with
> the assumption of single dma_ops, too.

There is no such assumption AFAIK. dma_ops is specified per struct
device. The IPU3 PCI device would have the x86 IOMMU dma_ops, while
the IPU3 custom-bus device would have the IPU3 MMU dma_ops (just as in
current code).

Best regards,
Tomasz
