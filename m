Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58297
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750919AbdFHQ0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Jun 2017 12:26:18 -0400
Date: Thu, 8 Jun 2017 13:26:09 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] v4l2-core: Use kvmalloc() for potentially big
 allocations
Message-ID: <20170608132609.0a4748ec@vento.lan>
In-Reply-To: <20170531130729.GH1019@valkosipuli.retiisi.org.uk>
References: <CGME20170531065846epcas5p4d4cf5a7cb2bb86fe4e9d9151fc83a896@epcas5p4.samsung.com>
        <20170531065837.30346-1-tfiga@chromium.org>
        <d10f7660-f9d0-198a-f7ed-bc789fe53acc@samsung.com>
        <CAAFQd5AzqZJsnhojEve0uNButxTSn3O573hf6DiNgQ792i6xdw@mail.gmail.com>
        <20170531130729.GH1019@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 31 May 2017 16:07:29 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Tomasz,
> 
> On Wed, May 31, 2017 at 09:46:05PM +0900, Tomasz Figa wrote:
> > On Wed, May 31, 2017 at 9:09 PM, Marek Szyprowski
> > <m.szyprowski@samsung.com> wrote:  
> > > Hi Tomasz,
> > >
> > >
> > > On 2017-05-31 08:58, Tomasz Figa wrote:  
> > >>
> > >> There are multiple places where arrays or otherwise variable sized
> > >> buffer are allocated through V4L2 core code, including things like
> > >> controls, memory pages, staging buffers for ioctls and so on. Such
> > >> allocations can potentially require an order > 0 allocation from the
> > >> page allocator, which is not guaranteed to be fulfilled and is likely to
> > >> fail on a system with severe memory fragmentation (e.g. a system with
> > >> very long uptime).
> > >>
> > >> Since the memory being allocated is intended to be used by the CPU
> > >> exclusively, we can consider using vmalloc() as a fallback and this is
> > >> exactly what the recently merged kvmalloc() helpers do. A kmalloc() call
> > >> is still attempted, even for order > 0 allocations, but it is done
> > >> with __GFP_NORETRY and __GFP_NOWARN, with expectation of failing if
> > >> requested memory is not available instantly. Only then the vmalloc()
> > >> fallback is used. This should give us fast and more reliable allocations
> > >> even on systems with higher memory pressure and/or more fragmentation,
> > >> while still retaining the same performance level on systems not
> > >> suffering from such conditions.
> > >>
> > >> While at it, replace explicit array size calculations on changed
> > >> allocations with kvmalloc_array().
> > >>
> > >> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > >> ---
> > >>   drivers/media/v4l2-core/v4l2-async.c       |  4 ++--
> > >>   drivers/media/v4l2-core/v4l2-ctrls.c       | 25
> > >> +++++++++++++------------
> > >>   drivers/media/v4l2-core/v4l2-event.c       |  8 +++++---
> > >>   drivers/media/v4l2-core/v4l2-ioctl.c       |  6 +++---
> > >>   drivers/media/v4l2-core/v4l2-subdev.c      |  7 ++++---
> > >>   drivers/media/v4l2-core/videobuf2-dma-sg.c |  8 ++++----  
> > >
> > >
> > > For vb2:
> > > Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>  
> > 
> > Thanks!
> >   
> > >
> > > There are also a few vmalloc calls in old videobuf (v1) framework, which
> > > might be converted to kvmalloc if you have a few spare minutes to take
> > > a look.  
> > 
> > I was intending to convert those as well, but on the other hand I
> > concluded that it's some very old code, which might be difficult to
> > test and likely to introduce some long undiscovered regressions. If
> > it's desired to update those as well, I can include those changes in
> > the non-RFC version.  
> 
> I think it's better to leave videobuf1 as-is. I'd rather like to see it
> removed instead.

Agreed.

There aren't much VB drivers anymore:

$ git grep -l VIDEOBUF_ |grep Kconfig
drivers/media/common/saa7146/Kconfig
drivers/media/pci/bt8xx/Kconfig
drivers/media/pci/cx18/Kconfig
drivers/media/platform/Kconfig
drivers/media/platform/davinci/Kconfig
drivers/media/platform/omap/Kconfig
drivers/media/usb/cx231xx/Kconfig
drivers/media/usb/tm6000/Kconfig
drivers/media/usb/zr364xx/Kconfig
drivers/media/v4l2-core/Kconfig
drivers/staging/media/atomisp/pci/Kconfig

(at platform/Kconfig, there are two drivers: via-camera and viu)

Not sure how easy/hard would be to convert those remaining ones.


Thanks,
Mauro
