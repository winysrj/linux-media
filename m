Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33490 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbeJMWyn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 13 Oct 2018 18:54:43 -0400
From: Christoph Hellwig <hch@lst.de>
To: linux-pm@vger.kernel.org, linux-tegra@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Cc: linux-kernel@vger.kernel.org
Subject: remove bogus GFP_DMA32 flags for dma allocations
Date: Sat, 13 Oct 2018 17:16:59 +0200
Message-Id: <20181013151707.32210-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dma_alloc_* internally selects the zone to allocate from based on the
DMA mask.  Remove all explicit uses of GFP_DMA32 with dma_alloc_*.
