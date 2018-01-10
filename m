Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37891 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751932AbeAJSD0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Jan 2018 13:03:26 -0500
From: Christoph Hellwig <hch@lst.de>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kong Lai <kong.lai@tundra.com>, linux-pci@vger.kernel.org,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: remove pci_dma_* abuses and workarounds V2
Date: Wed, 10 Jan 2018 19:03:18 +0100
Message-Id: <20180110180322.30186-1-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Back before the dawn of time pci_dma_* with a NULL pci_dev argument
was used for all kinds of things, e.g. dma mapping for non-PCI
devices.  All this has been long removed, but it turns out we
still care for a NULL pci_dev in the wrappers, and we still have
two odd USB drivers that use pci_dma_alloc_consistent for allocating
memory while ignoring the dma_addr_t entirely, and a network driver
mixing the already wrong usage of dma_* with a NULL device with a
single call to pci_free_consistent.

This series switches the two usb drivers to use plain kzalloc, the
net driver to properly use the dma API and then removes the handling
of the NULL pci_dev in the pci_dma_* wrappers.

Changes since V1:
 - remove allocation failure printks
 - use kcalloc
 - fix tsi108_eth
 - improve changelogs
