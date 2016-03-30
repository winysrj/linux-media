Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:42817 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753480AbcC3SSf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Mar 2016 14:18:35 -0400
Date: Wed, 30 Mar 2016 20:18:31 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mark Brown <broonie@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
	Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH v2 4/7] scatterlist: add sg_alloc_table_from_buf()
 helper
Message-ID: <20160330201831.38e1d6bd@bbrezillon>
In-Reply-To: <20160330165143.GI2350@sirena.org.uk>
References: <1459352394-22810-1-git-send-email-boris.brezillon@free-electrons.com>
	<1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
	<20160330165143.GI2350@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 30 Mar 2016 09:51:43 -0700
Mark Brown <broonie@kernel.org> wrote:

> On Wed, Mar 30, 2016 at 05:39:51PM +0200, Boris Brezillon wrote:
> > sg_alloc_table_from_buf() provides an easy solution to create an sg_table
> > from a virtual address pointer. This function takes care of dealing with
> > vmallocated buffers, buffer alignment, or DMA engine limitations (maximum
> > DMA transfer size).
> 
> This seems nice.  Should we also have a further helper on top of this
> which will get constraints from a dmaengine, it seems like it'd be a
> common need?

Yep, we could create a wrapper extracting dma_slave caps info,
converting it to sg_constraints and calling sg_alloc_table_from_buf().
But let's try to get this function accepted first, and I'll send another
patch providing this wrapper.

BTW, do you see other things that should be added in sg_constraints?

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
