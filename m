Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753272AbeARAI7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 19:08:59 -0500
Date: Wed, 17 Jan 2018 18:08:56 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kong Lai <kong.lai@tundra.com>, linux-pci@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: remove pci_dma_* abuses and workarounds V2
Message-ID: <20180118000856.GE53542@bhelgaas-glaptop.roam.corp.google.com>
References: <20180110180322.30186-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180110180322.30186-1-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[+cc David]

On Wed, Jan 10, 2018 at 07:03:18PM +0100, Christoph Hellwig wrote:
> Back before the dawn of time pci_dma_* with a NULL pci_dev argument
> was used for all kinds of things, e.g. dma mapping for non-PCI
> devices.  All this has been long removed, but it turns out we
> still care for a NULL pci_dev in the wrappers, and we still have
> two odd USB drivers that use pci_dma_alloc_consistent for allocating
> memory while ignoring the dma_addr_t entirely, and a network driver
> mixing the already wrong usage of dma_* with a NULL device with a
> single call to pci_free_consistent.
> 
> This series switches the two usb drivers to use plain kzalloc, the
> net driver to properly use the dma API and then removes the handling
> of the NULL pci_dev in the pci_dma_* wrappers.
> 
> Changes since V1:
>  - remove allocation failure printks
>  - use kcalloc
>  - fix tsi108_eth
>  - improve changelogs

Applied to pci/dma for v4.16, thanks!
