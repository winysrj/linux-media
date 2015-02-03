Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:50426 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965747AbbBCQWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 11:22:03 -0500
MIME-Version: 1.0
In-Reply-To: <6906596.JU5vQoa1jV@wuerfel>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
	<3783167.LiVXgA35gN@wuerfel>
	<20150203155404.GV8656@n2100.arm.linux.org.uk>
	<6906596.JU5vQoa1jV@wuerfel>
Date: Tue, 3 Feb 2015 11:22:01 -0500
Message-ID: <CAF6AEGsttiufoqPbDiZfUX2ndbv2XfeZzcfyaf-AcUJgJpgLkA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFCv3 2/2] dma-buf: add helpers for sharing
 attacher constraints with dma-parms
From: Rob Clark <robdclark@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 3, 2015 at 11:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> I agree for the case you are describing here. From what I understood
> from Rob was that he is looking at something more like:
>
> Fig 3
> CPU--L1cache--L2cache--Memory--IOMMU---<iobus>--device
>
> where the IOMMU controls one or more contexts per device, and is
> shared across GPU and non-GPU devices. Here, we need to use the
> dmap-mapping interface to set up the IO page table for any device
> that is unable to address all of system RAM, and we can use it
> for purposes like isolation of the devices. There are also cases
> where using the IOMMU is not optional.


Actually, just to clarify, the IOMMU instance is specific to the GPU..
not shared with other devices.  Otherwise managing multiple contexts
would go quite badly..

But other devices have their own instance of the same IOMMU.. so same
driver could be used.

BR,
-R
