Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:35266 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754178Ab1HDQUK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2011 12:20:10 -0400
Received: by mail-yx0-f180.google.com with SMTP id 11so1260265yxi.39
        for <linux-media@vger.kernel.org>; Thu, 04 Aug 2011 09:20:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKMK7uG+UVynCQx-0AWXV8KM9Fe5unu0-9exaADTGrpAcMxHng@mail.gmail.com>
References: <4E37C7D7.40301@samsung.com>
	<4E381B73.8050706@codeaurora.org>
	<20E136AF98049A48A90A7417B4343D5E1DF747A563@BUNGLE.Emea.Arm.com>
	<4E396569.30708@codeaurora.org>
	<CAKMK7uECwB70CnAaoTTfG0X5tMTcsYGZvvTaMxHE654bYNJyyQ@mail.gmail.com>
	<CAO8GWq=6djefOgQGWf4fkRryWM2e7qOMA5qeZOGkUVx7VWf-wg@mail.gmail.com>
	<CAKMK7uG+UVynCQx-0AWXV8KM9Fe5unu0-9exaADTGrpAcMxHng@mail.gmail.com>
Date: Thu, 4 Aug 2011 11:19:59 -0500
Message-ID: <CAO8GWqkoq0MT0PDHrP3eRQkVj-W=qWTDyL8vVNrwb9riDWYtFQ@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Buffer sharing proof-of-concept
From: "Clark, Rob" <rob@ti.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jordan Crouse <jcrouse@codeaurora.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 4, 2011 at 7:34 AM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> On Thu, Aug 4, 2011 at 13:14, Clark, Rob <rob@ti.com> wrote:
>> hmm, there would be a dmabuf->private ptr in struct dmabuf.  Normally
>> that should be for private data of the buffer allocator, but I guess
>> it could be (ab)used for under the hood communication between drivers
>> a platform specific way.  It does seem a bit hacky, but at least it
>> does not need to be exposed to userspace.
>
> An idea that just crossed my mind: I think we should seperate two
> kinds of meta-data about a shared piece of data (dmabuf):
> - logical metadata about it's contents, like strides, number of
> dimensions, pixel format/vbo layout, ... Imo that stuff doesn't belong
> into the buffer sharing simply because it's an a) awful mess and b)
> gem doesn't know it. To recap: only userspace knows this stuff and has
> to make sense of the data in the buffer by either setting up correct
> gpu command streams or telling kms what format this thing it needs to
> scan out has.


for sure, I think we've ruled out putting this sort of stuff in
'struct dmabuf'.. (notwithstanding any data stuffed away in a 'void *
priv' on some platform or another)

> - metadata about the physical layout: tiling layout, memory bank
> interleaving, page size for the iommu/contiguous buffer. As far as I
> can tell (i.e. please correct) for embedded systems this just depends
> on the (in)saneness of to iommu/bus/memory controller sitting between
> the ic block and it's data. So it would be great if we could
> completely hide this from drivers (and userspace) an shovel it into
> the dma subsystem (as private data). Unfortunately at least on Intel
> tiling needs to be known by the iommu code, the core gem kernel driver
> code and the userspace drivers. Otoh using tiled buffers for sharing
> is maybe a bit ambitious for the first cut. So maybe we can just
> ignore tiling which largely just leaves handling iommus restrictions
> (or their complete lack) which looks doable.

btw, on intel (or desktop platforms in general), could another device
(say a USB webcam) DMA directly to a tiled buffer via the GART... ie.
assuming you had some way to pre-fault some pages into the GART before
the DMA happened.

I was sort of expecting 'struct dmabuf' to basically just be a
scatterlist and some fxn ptrs, nothing about TILING.. not sure if we
need an fxn ptr to ask the buffer allocator to generate some
pages/addresses that some other DMA engine could write to (so you
could do something like pre-faulting the buffer into some sort of
GART) and again release the pages/addresses when DMA completes.

BR,
-R

>> (Or maybe a better option is just 'rm -rf omx' ;-))
>
> Yeah ;-)
> -Daniel
> --
> Daniel Vetter
> daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
>
