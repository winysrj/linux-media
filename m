Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36536 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751445AbdFHQrE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Jun 2017 12:47:04 -0400
Date: Thu, 8 Jun 2017 19:47:00 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>,
        Yong Zhi <yong.zhi@intel.com>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Zheng, Jian Xu" <jian.xu.zheng@intel.com>,
        "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        "Toivonen, Tuukka" <tuukka.toivonen@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 03/12] intel-ipu3: Add DMA API implementation
Message-ID: <20170608164659.GI1019@valkosipuli.retiisi.org.uk>
References: <1496695157-19926-1-git-send-email-yong.zhi@intel.com>
 <1496695157-19926-4-git-send-email-yong.zhi@intel.com>
 <CAAFQd5CLXUsDv6H1C22tc4qjG9e7tm5jtxwYBjV5gx9qrDw50A@mail.gmail.com>
 <20170607184512.0e627965@lxorguk.ukuu.org.uk>
 <CAAFQd5BYk6ErzaLgVp+sL2sQg1FzFjDu4tg_b3KBCAM7=39icw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5BYk6ErzaLgVp+sL2sQg1FzFjDu4tg_b3KBCAM7=39icw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz and Alan,

On Thu, Jun 08, 2017 at 11:55:18AM +0900, Tomasz Figa wrote:
> Hi Alan,
> 
> On Thu, Jun 8, 2017 at 2:45 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:
> >> > +       struct ipu3_mmu *mmu = to_ipu3_mmu(dev);
> >> > +       dma_addr_t daddr = iommu_iova_to_phys(mmu->domain, dma_handle);
> >> > +
> >> > +       clflush_cache_range(phys_to_virt(daddr), size);
> >>
> >> You might need to consider another IOMMU on the way here. Generally,
> >> given that daddr is your MMU DMA address (not necessarily CPU physical
> >> address), you should be able to call
> >>
> >> dma_sync_single_for_cpu(<your pci device>, daddr, size, dir)
> >
> > Te system IOMMU (if enabled) may be cache coherent - and on x86 would be,
> > so it doesn't think it needs to do anything for cache synchronization
> > and the dma_sync won't actually do any work.
> 
> I'm not very familiar with x86, but typically I found coherency to be
> an attribute of the DMA master (i.e. if it is connected to a coherent
> memory port).
> 
> Looking at all the IPU3 code, it looks like the whole PCI device is
> non-coherent for some reason (e.g. you can see implicit cache flushes
> for page tables). So I would have expected that a non-coherent variant
> of x86 dma_ops is used for the PCI struct device, which would do cache
> maintenance in its dma_sync_* ops.

It can actually do both --- in most cases.

The MMU page tables are an exception so they will still need an explicit
flush.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
