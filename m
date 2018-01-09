Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38298 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754821AbeAIUjq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 15:39:46 -0500
From: Christoph Hellwig <hch@lst.de>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: remove pci_dma_* abuses and workarounds
Date: Tue,  9 Jan 2018 21:39:36 +0100
Message-Id: <20180109203939.5930-1-hch@lst.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Back before the dawn of time pci_dma_* with a NULL pci_dev argument
was used for all kinds of things, e.g. dma mapping for non-PCI
devices.  All this has been long removed, but it turns out we
still care for a NULL pci_dev in the wrappers, and we still have
two odd USB drivers that use pci_dma_alloc_consistent for allocating
memory while ignoring the dma_addr_t entirely.

This series switches the two drivers to use plain kzalloc and then
removes the handling of the NULL pci_dev in the pci_dma_* wrappers.
