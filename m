Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35482 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540AbZIHNFN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Sep 2009 09:05:13 -0400
MIME-Version: 1.0
In-Reply-To: <20090903083600.GA7235@n2100.arm.linux.org.uk>
References: <200908061208.22131.laurent.pinchart@ideasonboard.com>
	 <e06498070908250553h5971102x6da7004495abb911@mail.gmail.com>
	 <20090901132824.GN19719@n2100.arm.linux.org.uk>
	 <200909011543.48439.laurent.pinchart@ideasonboard.com>
	 <20090902151044.GG30183@localhost>
	 <20090903083600.GA7235@n2100.arm.linux.org.uk>
Date: Tue, 8 Sep 2009 09:05:14 -0400
Message-ID: <e06498070909080605sf11681en7ac55ddc024332e4@mail.gmail.com>
Subject: Re: How to efficiently handle DMA and cache on ARMv7 ? (was "Is
	get_user_pages() enough to prevent pages from being swapped out ?")
From: Steven Walter <stevenrwalter@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Imre Deak <imre.deak@nokia.com>,
	ext Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	David Xiao <dxiao@broadcom.com>,
	Ben Dooks <ben-linux@fluff.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	Robin Holt <holt@sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	v4l2_linux <linux-media@vger.kernel.org>,
	"linux-arm-kernel@lists.arm.linux.org.uk"
	<linux-arm-kernel@lists.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 3, 2009 at 4:36 AM, Russell King - ARM
Linux<linux@arm.linux.org.uk> wrote:
> On Wed, Sep 02, 2009 at 06:10:44PM +0300, Imre Deak wrote:
>> To my understanding buffers returned by dma_alloc_*, kmalloc, vmalloc
>> are ok:
>
> For dma_map_*, the only pages/addresses which are valid to pass are
> those returned by get_free_pages() or kmalloc.  Everything else is
> not permitted.
>
> Use of vmalloc'd and dma_alloc_* pages with the dma_map_* APIs is invalid
> use of the DMA API.  See the notes in the DMA-mapping.txt document
> against "dma_map_single".

Actually, DMA-mapping.txt seems to explicitly say that it's allowed to
use pages allocated by vmalloc:

"It is possible to DMA to the _underlying_ memory mapped into a
vmalloc() area, but this requires walking page tables to get the
physical addresses, and then translating each of those pages back to a
kernel address using something like __va()."

>> For user mappings I think you'd have to do an additional flush for
>> the direct mapping, while the user mapping is flushed in dma_map_*.
>
> I will not accept a patch which adds flushing of anything other than
> the kernel direct mapping in the dma_map_* functions, so please find
> a different approach.

What's the concern here?  Just the performance overhead of the checks
and additional flushes?  It seems much more desirable for the
dma_map_* API to take care of potential cache aliases than to require
every driver to manage it for itself.  After all, part of the purpose
of the DMA API is to manage the cache maintenance around DMAs in an
architecture-independent way.
-- 
-Steven Walter <stevenrwalter@gmail.com>
