Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:34626 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751433AbdFHCzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 22:55:41 -0400
Received: by mail-yw0-f169.google.com with SMTP id e142so1137888ywa.1
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 19:55:40 -0700 (PDT)
Received: from mail-yb0-f174.google.com (mail-yb0-f174.google.com. [209.85.213.174])
        by smtp.gmail.com with ESMTPSA id l124sm2061384ywb.58.2017.06.07.19.55.38
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2017 19:55:39 -0700 (PDT)
Received: by mail-yb0-f174.google.com with SMTP id 4so6851106ybl.1
        for <linux-media@vger.kernel.org>; Wed, 07 Jun 2017 19:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170607184512.0e627965@lxorguk.ukuu.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-4-git-send-email-yong.zhi@intel.com> <CAAFQd5CLXUsDv6H1C22tc4qjG9e7tm5jtxwYBjV5gx9qrDw50A@mail.gmail.com>
 <20170607184512.0e627965@lxorguk.ukuu.org.uk>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 8 Jun 2017 11:55:18 +0900
Message-ID: <CAAFQd5BYk6ErzaLgVp+sL2sQg1FzFjDu4tg_b3KBCAM7=39icw@mail.gmail.com>
Subject: Re: [PATCH 03/12] intel-ipu3: Add DMA API implementation
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Thu, Jun 8, 2017 at 2:45 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
>> > +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
>> > +       dma_addr_t daddr = iommu_iova_to_phys(mmu->domain, dma_handle);
>> > +
>> > +       clflush_cache_range(phys_to_virt(daddr), size);
>>
>> You might need to consider another IOMMU on the way here. Generally,
>> given that daddr is your MMU DMA address (not necessarily CPU physical
>> address), you should be able to call
>>
>> dma_sync_single_for_cpu(<your pci device>, daddr, size, dir)
>
> Te system IOMMU (if enabled) may be cache coherent - and on x86 would be,
> so it doesn't think it needs to do anything for cache synchronization
> and the dma_sync won't actually do any work.

I'm not very familiar with x86, but typically I found coherency to be
an attribute of the DMA master (i.e. if it is connected to a coherent
memory port).

Looking at all the IPU3 code, it looks like the whole PCI device is
non-coherent for some reason (e.g. you can see implicit cache flushes
for page tables). So I would have expected that a non-coherent variant
of x86 dma_ops is used for the PCI struct device, which would do cache
maintenance in its dma_sync_* ops.

Best regards,
Tomasz
