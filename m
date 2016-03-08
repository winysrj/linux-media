Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59039 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784AbcCHOOr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 09:14:47 -0500
Date: Tue, 8 Mar 2016 19:48:53 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org, Mark Brown <broonie@kernel.org>,
	linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 5/7] mtd: provide helper to prepare buffers for DMA
 operations
Message-ID: <20160308141853.GQ11154@localhost>
References: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
 <1457435715-24740-6-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1457435715-24740-6-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 08, 2016 at 12:15:13PM +0100, Boris Brezillon wrote:
>  
> +#ifdef CONFIG_HAS_DMA

Shouldn't this be CONFIG_DMA_ENGINE as you are preparing these descriptors
for DMA transfer?

-- 
~Vinod
