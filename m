Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:60872 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933924AbbBCQh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Feb 2015 11:37:56 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Rob Clark <robdclark@gmail.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Tomasz Stanislawski <stanislawski.tomasz@googlemail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	Robin Murphy <robin.murphy@arm.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [Linaro-mm-sig] [RFCv3 2/2] dma-buf: add helpers for sharing attacher constraints with dma-parms
Date: Tue, 03 Feb 2015 17:36:59 +0100
Message-ID: <7233574.nKiRa7HnXU@wuerfel>
In-Reply-To: <CAF6AEGsttiufoqPbDiZfUX2ndbv2XfeZzcfyaf-AcUJgJpgLkA@mail.gmail.com>
References: <1422347154-15258-1-git-send-email-sumit.semwal@linaro.org> <6906596.JU5vQoa1jV@wuerfel> <CAF6AEGsttiufoqPbDiZfUX2ndbv2XfeZzcfyaf-AcUJgJpgLkA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 03 February 2015 11:22:01 Rob Clark wrote:
> On Tue, Feb 3, 2015 at 11:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > I agree for the case you are describing here. From what I understood
> > from Rob was that he is looking at something more like:
> >
> > Fig 3
> > CPU--L1cache--L2cache--Memory--IOMMU---<iobus>--device
> >
> > where the IOMMU controls one or more contexts per device, and is
> > shared across GPU and non-GPU devices. Here, we need to use the
> > dmap-mapping interface to set up the IO page table for any device
> > that is unable to address all of system RAM, and we can use it
> > for purposes like isolation of the devices. There are also cases
> > where using the IOMMU is not optional.
> 
> 
> Actually, just to clarify, the IOMMU instance is specific to the GPU..
> not shared with other devices.  Otherwise managing multiple contexts
> would go quite badly..
> 
> But other devices have their own instance of the same IOMMU.. so same
> driver could be used.

I think from the driver perspective, I'd view those two cases as
identical. Not sure if Russell agrees with that.

	Arnd
