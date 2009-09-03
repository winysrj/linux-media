Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58217 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbZICIgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Sep 2009 04:36:25 -0400
Date: Thu, 3 Sep 2009 09:36:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Imre Deak <imre.deak@nokia.com>
Cc: ext Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steven Walter <stevenrwalter@gmail.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
Message-ID: <20090903083600.GA7235@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com> <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com> <20090901132824.GN19719@n2100.arm.linux.org.uk> <200909011543.48439.laurent.pinchart@ideasonboard.com> <20090902151044.GG30183@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902151044.GG30183@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 02, 2009 at 06:10:44PM +0300, Imre Deak wrote:
> To my understanding buffers returned by dma_alloc_*, kmalloc, vmalloc
> are ok:

For dma_map_*, the only pages/addresses which are valid to pass are
those returned by get_free_pages() or kmalloc.  Everything else is
not permitted.

Use of vmalloc'd and dma_alloc_* pages with the dma_map_* APIs is invalid
use of the DMA API.  See the notes in the DMA-mapping.txt document
against "dma_map_single".

> For user mappings I think you'd have to do an additional flush for
> the direct mapping, while the user mapping is flushed in dma_map_*.

I will not accept a patch which adds flushing of anything other than
the kernel direct mapping in the dma_map_* functions, so please find
a different approach.
