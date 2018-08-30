Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39636 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbeHaCQF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Aug 2018 22:16:05 -0400
Message-ID: <4fc5107f93871599ead017af7ad50f22535a7683.camel@collabora.com>
Subject: Re: [RFC 2/3] USB: core: Add non-coherent buffer allocation helpers
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        "Matwey V . Kornilov" <matwey@sai.msu.ru>,
        Alan Stern <stern@rowland.harvard.edu>, kernel@collabora.com,
        Keiichi Watanabe <keiichiw@chromium.org>
Date: Thu, 30 Aug 2018 19:11:35 -0300
In-Reply-To: <20180830175850.GA11521@infradead.org>
References: <20180830172030.23344-1-ezequiel@collabora.com>
         <20180830172030.23344-3-ezequiel@collabora.com>
         <20180830175850.GA11521@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2018-08-30 at 10:58 -0700, Christoph Hellwig wrote:
> Please don't introduce new DMA_ATTR_NON_CONSISTENT users, it is
> a rather horrible interface, and I plan to kill it off rather sooner
> than later.  I plan to post some patches for a better interface
> that can reuse the normal dma_sync_single_* interfaces for ownership
> transfers.  I can happily include usb in that initial patch set based
> on your work here if that helps.

Please do. Until we have proper allocators that go thru the DMA API,
drivers will have to kmalloc the USB transfer buffers, and have
streaming mappings. Which in turns mean not using IOMMU or CMA.

Regards,
Eze
