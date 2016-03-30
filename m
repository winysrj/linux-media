Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60497 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754550AbcC3PkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 11:40:00 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH v2 0/7] mtd: nand: sunxi: add support for DMA operations
Date: Wed, 30 Mar 2016 17:39:47 +0200
Message-Id: <1459352394-22810-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patch series aims at adding support for DMA assisted operations to
the sunxi_nand driver.

The first 3 patches are just reworks in the existing driver preparing
things for DMA ->read/write_page() operations. Those ones are mainly
re-arranging existing functions, and moving some code into dedicated
functions so we can reuse them when adding the read/write_page()
implementation.

Patch 4 is an attempt to generalize some logic that are duplicated in a
lot of places. It provides a generic solution to create an SG table
from a buffer (passed by virtual address) and its length.
This generic implementation tries to take all possible constraints into
account, like:
- vmallocated buffers
- alignement requirement/preference
- maximum DMA transfer length

I may have missed other things (is there a need for a minimum DMA
transfer constraint?), so don't hesitate to point problems or missing
elements in this implementation.
Note that other subsystems doing the same kind of thing (like SPI of V4L)
could use this implementation. This is why I've put the SPI and V4L
maintainers in Cc.

Patch 5 is providing functions to map/unmap buffers for DMA operations
at the MTD level. This will hopefully limit the number of open-coded
implementations we're currently seeing in a lot of NAND drivers.
Of course, it's making use of sg_alloc_table_from_buf(), introduced in
patch 4.

Patch 6 and 7 are patching the sunxi NAND driver and its DT binding doc
to add DMA support.

I'm particularly interested in getting feedbacks on patch 4 and 5.
Is there a reason nobody ever tried to create such generic functions
(at the scatterlist and MTD levels), and if there are, could you detail
them?

Thanks,

Boris

Side note: patches touching the sunxi NAND driver are depending on
this series [1].

[1]https://lkml.org/lkml/2016/3/7/444

Changes since v1:
- reworked sg_alloc_table_from_buf() to avoid splitting contiguous
  vmalloced area
- fixed a bug in the read_dma()
- fixed dma_direction flag in write_dma()

Boris Brezillon (7):
  mtd: nand: sunxi: move some ECC related operations to their own
    functions
  mtd: nand: sunxi: make OOB retrieval optional
  mtd: nand: sunxi: make cur_off parameter optional in extra oob helpers
  scatterlist: add sg_alloc_table_from_buf() helper
  mtd: provide helper to prepare buffers for DMA operations
  mtd: nand: sunxi: add support for DMA assisted operations
  mtd: nand: sunxi: update DT bindings

 .../devicetree/bindings/mtd/sunxi-nand.txt         |   4 +
 drivers/mtd/mtdcore.c                              |  66 +++
 drivers/mtd/nand/sunxi_nand.c                      | 505 ++++++++++++++++++---
 include/linux/mtd/mtd.h                            |  25 +
 include/linux/scatterlist.h                        |  24 +
 lib/scatterlist.c                                  | 161 +++++++
 6 files changed, 720 insertions(+), 65 deletions(-)

-- 
2.5.0

