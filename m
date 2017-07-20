Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43256 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965487AbdGTWJH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 18:09:07 -0400
Date: Fri, 21 Jul 2017 01:09:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Yong Zhi <yong.zhi@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        jian.xu.zheng@intel.com, rajmohan.mani@intel.com,
        hyungwoo.yang@intel.com, jerry.w.hu@intel.com,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Tomasz Figa <tfiga@chromium.org>
Subject: Re: [PATCH v3 03/12] intel-ipu3: Add DMA API implementation
Message-ID: <20170720220904.icclurhemtkk7sx7@valkosipuli.retiisi.org.uk>
References: <1500433978-2350-1-git-send-email-yong.zhi@intel.com>
 <CAK8P3a0Muca-NB0+yuotTHEixhx8jG9Dytsd_wE9=SfNdGSGBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0Muca-NB0+yuotTHEixhx8jG9Dytsd_wE9=SfNdGSGBg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arnd,

On Wed, Jul 19, 2017 at 09:24:41AM +0200, Arnd Bergmann wrote:
> On Wed, Jul 19, 2017 at 5:12 AM, Yong Zhi <yong.zhi@intel.com> wrote:
> > From: Tomasz Figa <tfiga@chromium.org>
> >
> > This patch adds support for the IPU3 DMA mapping API.
> >
> > Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > Signed-off-by: Yong Zhi <yong.zhi@intel.com>
> 
> This needs some explanation on why you decided to go down the
> route of adding your own dma_map_ops. It's not obvious at all,
> and and I'm still concerned that this complicates things more than
> it helps.

There are a few considerations here --- they could be documented in the
patch commit message

- The device has its own MMU. The default x86 DMA ops assume there isn't.

- As this is an image signal processor device, the buffers are typically
  large (often in the range of tens of MB) and they do not need to be
  physically contiguous. The current implementation of e.g.
  drivers/iommu/intel-iommu.c allocate memory using alloc_pages() which is
  unfeasible for such single allocations. Neither CMA is needed.

  Also other IOMMU implementations have their own DMA ops currently.

I agree it'd be nice to unify these in the long run but I don't think this
stands apart from the rest currently --- except that the MMU is only used
by a single PCI device, the same which it is contained in.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
