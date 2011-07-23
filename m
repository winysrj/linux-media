Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45706 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1GWFtC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 01:49:02 -0400
Date: Sat, 23 Jul 2011 08:48:57 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Pawel Osciak' <pawel@osciak.com>
Subject: Re: [PATCH 1/2] videobuf2: Add a non-coherent contiguous DMA mode
Message-ID: <20110723054857.GK29320@valkosipuli.localdomain>
References: <1310675711-39744-1-git-send-email-corbet@lwn.net>
 <1310675711-39744-2-git-send-email-corbet@lwn.net>
 <000001cc42b5$40c025f0$c24071d0$%szyprowski@samsung.com>
 <20110715083003.79802a49@bike.lwn.net>
 <00cb01cc4518$55c0c490$01424db0$%szyprowski@samsung.com>
 <20110722135547.5a0b38db@bike.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722135547.5a0b38db@bike.lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jonathan,

On Fri, Jul 22, 2011 at 01:55:47PM -0600, Jonathan Corbet wrote:
> > >  You *can't* do the mapping at allocation time...
> > 
> > Could you elaborate why you can't create the mapping at allocation time? 
> > DMA-mapping api requires the following call sequence:
> > dma_map_single()
> > ...
> > dma_sync_single_for_cpu()
> > dma_sync_single_for_device()
> > ...
> > dma_unmap_single()
> > 
> > I see no problem to call dma_map_single() on buffer creation and 
> > dma_unmap_single() on release. dma_sync_single_for_{device,cpu} can
> > be used on buffer_{prepare,finish}.
> 
> Yes, it could be done that way.  I guess I've always, rightly or wrongly,
> seen streaming mappings as transient things that aren't meant to be kept
> around for long periods of time.  Especially if they might, somehow, be
> taking up limited resources like IOMMU slots.  But I honestly have no idea
> whether it's better to keep a set of mappings around and use the sync
> functions, or whether it's better to remake them each time.

Creating IOMMU mappings (and removing them) usually takes considerable
amount of time but usually consume practically no resources, so they are
kept while the buffers are pinned to system memory.

Do you have hardware which has limitations on IOMMU mappings?

For example, the OMA 3 IOMMU can be used to map the whole system memory (if
you need it) and it does page tabe walking, too.

-- 
Sakari Ailus
sakari.ailus@iki.fi
