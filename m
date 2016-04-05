Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:55980 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938AbcDEHL4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 03:11:56 -0400
Subject: Re: [PATCH v2 4/7] scatterlist: add sg_alloc_table_from_buf() helper
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Mark Brown <broonie@kernel.org>
References: <1459352394-22810-1-git-send-email-boris.brezillon@free-electrons.com>
 <1459352394-22810-5-git-send-email-boris.brezillon@free-electrons.com>
 <20160330165143.GI2350@sirena.org.uk> <20160330201831.38e1d6bd@bbrezillon>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
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
From: Dave Gordon <david.s.gordon@intel.com>
Message-ID: <57036534.7010800@intel.com>
Date: Tue, 5 Apr 2016 08:11:48 +0100
MIME-Version: 1.0
In-Reply-To: <20160330201831.38e1d6bd@bbrezillon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30/03/16 19:18, Boris Brezillon wrote:
> On Wed, 30 Mar 2016 09:51:43 -0700
> Mark Brown <broonie@kernel.org> wrote:
>
>> On Wed, Mar 30, 2016 at 05:39:51PM +0200, Boris Brezillon wrote:
>>> sg_alloc_table_from_buf() provides an easy solution to create an sg_table
>>> from a virtual address pointer. This function takes care of dealing with
>>> vmallocated buffers, buffer alignment, or DMA engine limitations (maximum
>>> DMA transfer size).
>>
>> This seems nice.  Should we also have a further helper on top of this
>> which will get constraints from a dmaengine, it seems like it'd be a
>> common need?
>
> Yep, we could create a wrapper extracting dma_slave caps info,
> converting it to sg_constraints and calling sg_alloc_table_from_buf().
> But let's try to get this function accepted first, and I'll send another
> patch providing this wrapper.
>
> BTW, do you see other things that should be added in sg_constraints?
>

You could compare with the things Solaris uses to describe the 
restrictions on a DMA binding ...

http://docs.oracle.com/cd/E23824_01/html/821-1478/ddi-dma-attr-9s.html#REFMAN9Sddi-dma-attr-9s

.Dave.
