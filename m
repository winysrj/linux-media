Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41685 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933121AbdKBORj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Nov 2017 10:17:39 -0400
Subject: Re: [PATCH] media: s5p-mfc: Add support for V4L2_MEMORY_DMABUF type
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Marian Mihailescu <mihailescu2m@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        JaeChul Lee <jcsing.lee@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <6c8f740e-c084-ece9-d189-50e151f95390@samsung.com>
Date: Thu, 02 Nov 2017 15:17:34 +0100
MIME-version: 1.0
In-reply-to: <acd3bfd1-991d-4f39-603c-5d07b90ebb98@math.uni-bielefeld.de>
Content-type: text/plain; charset="utf-8"; format="flowed"
Content-transfer-encoding: 7bit
Content-language: en-US
References: <CGME20171020101455eucas1p1ad826b685fab9d93bb5f12b2b27096c6@eucas1p1.samsung.com>
        <20171020101433.30119-1-m.szyprowski@samsung.com>
        <acd3bfd1-991d-4f39-603c-5d07b90ebb98@math.uni-bielefeld.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tobias,

On 2017-10-20 15:59, Tobias Jakobi wrote:
> Hey Marek and others,
>
> just wanted to point out that I've also played around with Seung-Woo' patch for
> a while. However this patch alone is very much incomplete.
>
> In particular this is missing:
> - At least v5 MFC hw needs source buffers to be also writable, so dma mapping
> needs to be setup bidirectional.
> - Like with mmap, all buffers need to be setup before decoding can begin. This
> is due to how MFC hw gets initialized. dmabufs that are added later are not
> going to be used before MFC hw isn't reinitialized.
> - Removing dmabufs, or replacing them seems to be impossible with the current
> code architecture.

Right. Those are limitations of the hardware and in next version of this 
patch I will
add checks for them.

> I had extended samsung-utils with some C++ app to test stuff when I was looking
> into this. You can find the code here:
> https://github.com/tobiasjakobi/samsung-utils/tree/devel/v4l2-mfc-drm-direct
>
> Now here is what happens. I allocate N buffer objects in DRM land to be used as
> destination for the MFC decoder. The BOs are exported, so that I can then use
> them in V4L2 space. I have to queue n (with n < N) buffers before I can start
> the MFC engine.

According to my knowledge of the MFC HW, if you want to use N buffers 
with MFC,
you have to queue all N buffers to initialize the HW. Otherwise, HW will 
produce
video data only to the n buffer queued on stream on.

> If I do start the engine at that point (n buffers queued), I soon get an IOMMU
> pagefault. I need to queue all N buffers before anything works at all. Queueing
> a buffer the first time also registers it, and this has to happen before the MFC
> hw is initialized.
>
> In particular I can't just allocate more buffers from DRM and use them here
> _after_ decoding has started.
>
> To me it looks like the MFC code was never written with dmabuf in mind. It's
> centered around a static memory setup that is fixed before decoding begins.

That's true, but still, using it with DMA-bufs might be convenient in 
some cases,
even with the above limitations. The IOMMU fault can be mitigated by 
enabling
bidirectional flag on OUTPUT queue. This is a bit strange, but that's 
how the
hardware behaves. From my research it looks that it happens only in case 
of MFCv5,
higher versions don't modify source stream.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
