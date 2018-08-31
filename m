Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34686 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeHaJ4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 31 Aug 2018 05:56:36 -0400
Date: Thu, 30 Aug 2018 22:50:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ezequiel Garcia <ezequiel@collabora.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Matwey V . Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        Keiichi Watanabe <keiichiw@chromium.org>
Subject: Re: [RFC 2/3] USB: core: Add non-coherent buffer allocation helpers
Message-ID: <20180831055047.GA9140@infradead.org>
References: <20180830172030.23344-1-ezequiel@collabora.com>
 <20180830172030.23344-3-ezequiel@collabora.com>
 <20180830175850.GA11521@infradead.org>
 <4fc5107f93871599ead017af7ad50f22535a7683.camel@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4fc5107f93871599ead017af7ad50f22535a7683.camel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 30, 2018 at 07:11:35PM -0300, Ezequiel Garcia wrote:
> On Thu, 2018-08-30 at 10:58 -0700, Christoph Hellwig wrote:
> > Please don't introduce new DMA_ATTR_NON_CONSISTENT users, it is
> > a rather horrible interface, and I plan to kill it off rather sooner
> > than later.  I plan to post some patches for a better interface
> > that can reuse the normal dma_sync_single_* interfaces for ownership
> > transfers.  I can happily include usb in that initial patch set based
> > on your work here if that helps.
> 
> Please do. Until we have proper allocators that go thru the DMA API,
> drivers will have to kmalloc the USB transfer buffers, and have
> streaming mappings. Which in turns mean not using IOMMU or CMA.

dma_map_page will of course use the iommu.
