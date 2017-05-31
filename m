Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44236 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751000AbdEaNHi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 09:07:38 -0400
Date: Wed, 31 May 2017 16:07:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-media@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <pawel@osciak.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH RFC] v4l2-core: Use kvmalloc() for potentially big
 allocations
Message-ID: <20170531130729.GH1019@valkosipuli.retiisi.org.uk>
References: <CGME20170531065846epcas5p4d4cf5a7cb2bb86fe4e9d9151fc83a896@epcas5p4.samsung.com>
 <20170531065837.30346-1-tfiga@chromium.org>
 <d10f7660-f9d0-198a-f7ed-bc789fe53acc@samsung.com>
 <CAAFQd5AzqZJsnhojEve0uNButxTSn3O573hf6DiNgQ792i6xdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAFQd5AzqZJsnhojEve0uNButxTSn3O573hf6DiNgQ792i6xdw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wed, May 31, 2017 at 09:46:05PM +0900, Tomasz Figa wrote:
> On Wed, May 31, 2017 at 9:09 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> > Hi Tomasz,
> >
> >
> > On 2017-05-31 08:58, Tomasz Figa wrote:
> >>
> >> There are multiple places where arrays or otherwise variable sized
> >> buffer are allocated through V4L2 core code, including things like
> >> controls, memory pages, staging buffers for ioctls and so on. Such
> >> allocations can potentially require an order > 0 allocation from the
> >> page allocator, which is not guaranteed to be fulfilled and is likely to
> >> fail on a system with severe memory fragmentation (e.g. a system with
> >> very long uptime).
> >>
> >> Since the memory being allocated is intended to be used by the CPU
> >> exclusively, we can consider using vmalloc() as a fallback and this is
> >> exactly what the recently merged kvmalloc() helpers do. A kmalloc() call
> >> is still attempted, even for order > 0 allocations, but it is done
> >> with __GFP_NORETRY and __GFP_NOWARN, with expectation of failing if
> >> requested memory is not available instantly. Only then the vmalloc()
> >> fallback is used. This should give us fast and more reliable allocations
> >> even on systems with higher memory pressure and/or more fragmentation,
> >> while still retaining the same performance level on systems not
> >> suffering from such conditions.
> >>
> >> While at it, replace explicit array size calculations on changed
> >> allocations with kvmalloc_array().
> >>
> >> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> >> ---
> >>   drivers/media/v4l2-core/v4l2-async.c       |  4 ++--
> >>   drivers/media/v4l2-core/v4l2-ctrls.c       | 25
> >> +++++++++++++------------
> >>   drivers/media/v4l2-core/v4l2-event.c       |  8 +++++---
> >>   drivers/media/v4l2-core/v4l2-ioctl.c       |  6 +++---
> >>   drivers/media/v4l2-core/v4l2-subdev.c      |  7 ++++---
> >>   drivers/media/v4l2-core/videobuf2-dma-sg.c |  8 ++++----
> >
> >
> > For vb2:
> > Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Thanks!
> 
> >
> > There are also a few vmalloc calls in old videobuf (v1) framework, which
> > might be converted to kvmalloc if you have a few spare minutes to take
> > a look.
> 
> I was intending to convert those as well, but on the other hand I
> concluded that it's some very old code, which might be difficult to
> test and likely to introduce some long undiscovered regressions. If
> it's desired to update those as well, I can include those changes in
> the non-RFC version.

I think it's better to leave videobuf1 as-is. I'd rather like to see it
removed instead.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
