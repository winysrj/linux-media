Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:43120 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdFGRqb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 13:46:31 -0400
Date: Wed, 7 Jun 2017 18:45:12 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 03/12] intel-ipu3: Add DMA API implementation
Message-ID: <20170607184512.0e627965@lxorguk.ukuu.org.uk>
In-Reply-To: <CAAFQd5CLXUsDv6H1C22tc4qjG9e7tm5jtxwYBjV5gx9qrDw50A@mail.gmail.com>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
        <1496695157-19926-4-git-send-email-yong.zhi@intel.com>
        <CAAFQd5CLXUsDv6H1C22tc4qjG9e7tm5jtxwYBjV5gx9qrDw50A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
> > +       dma_addr_t daddr = iommu_iova_to_phys(mmu->domain, dma_handle);
> > +
> > +       clflush_cache_range(phys_to_virt(daddr), size);  
> 
> You might need to consider another IOMMU on the way here. Generally,
> given that daddr is your MMU DMA address (not necessarily CPU physical
> address), you should be able to call
> 
> dma_sync_single_for_cpu(<your pci device>, daddr, size, dir)

Te system IOMMU (if enabled) may be cache coherent - and on x86 would be,
so it doesn't think it needs to do anything for cache synchronization
and the dma_sync won't actually do any work.
 
Alan
