Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56404 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbbBCWHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 17:07:03 -0500
Received: by mail-ig0-f176.google.com with SMTP id hl2so30364175igb.3
        for <linux-media@vger.kernel.org>; Tue, 03 Feb 2015 14:07:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3327782.QV7DJfvifL@wuerfel>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org>
	<7233574.nKiRa7HnXU@wuerfel>
	<20150203200435.GX14009@phenom.ffwll.local>
	<3327782.QV7DJfvifL@wuerfel>
Date: Tue, 3 Feb 2015 23:07:01 +0100
Message-ID: <CAKMK7uGfXZsuRgGg+=0pLG3y7O3sc5Cgj2ci9pWu32SxB7jS8w@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [RFCv3 2/2] dma-buf: add helpers for sharing
 attacher constraints with dma-parms
From: Daniel Vetter <daniel@ffwll.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Robin Murphy <robin.murphy@arm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Rob Clark <robdclark@gmail.com>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 3, 2015 at 10:42 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> Again assuming I'm not confused can't we just solve this by pushing the
>> dma api abstraction down one layer for just the gpu, and let it use its
>> private iommmu directly? Steps for binding a buffer would be:
>> 1. dma_map_sg
>> 2. Noodle the dma_addr_t out of the sg table and feed those into a 2nd
>> level mapping set up through the iommu api for the gpu-private mmu.
>
> If you want to do that, you run into the problem of telling the driver
> core about it. We associate the device with an iommu in the device
> tree, describing there how it is wired up.
>
> The driver core creates a platform_device for this and checks if it
> an iommu mapping is required or wanted for the device, which is then
> set up. When the device driver wants to create its own iommu mapping,
> this conflicts with the one that is already there. We can't just
> skip the iommu setup for all devices because it may be needed sometimes,
> and I don't really want to see hacks where the driver core knows which
> devices are GPUs and skips the mapping for them, which would be a
> layering violation.

I don't think you get a choice but to make gpus a special case.
There's a bunch of cases why the iommu private to the gpu is special:
- If there's gpu-private iommu at all you have a nice security
problem, and you must scan your cmd stream to make sure no gpu access
goes to arbitrary system memory. We kinda consider isolation between
clients optional, but isolation to everything else is mandatory. And
scanning the cmd stream in software has such big implications on the
design of your driver that you essentially need 2 different drivers.
Even if the IP block otherwise matches.
- If your iommu supports multiple address space then the gpu must
know. We've already covered this case.

So trying to wedge the dma api between the gpu and its private iommu
is imo the layering violation here. Imo the dma api only should
control an iommu for the gpu if:
- the iommu is shared (so can't be used for isolation and you need the
full blwon cmd scanner)
- it's a 2nd level iommu (e.g. what we have on i915) and there is
another private iommu.

Note that with private I only mean no other device can use it, I don't
mean whether it's on the same IP block or not (we even have an iommu
abstraction in i915 because the pagetable walkers are pretty much
separate from everything else and evolve mostly independently).
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
