Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34902 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbeHXJjf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Aug 2018 05:39:35 -0400
Received: by mail-lf1-f68.google.com with SMTP id q13-v6so5852723lfc.2
        for <linux-media@vger.kernel.org>; Thu, 23 Aug 2018 23:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <14751117.J1GmkhZxMo@avalon> <Pine.LNX.4.44L0.1808091005210.1549-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1808091005210.1549-100000@iolanthe.rowland.org>
From: Keiichi Watanabe <keiichiw@chromium.org>
Date: Fri, 24 Aug 2018 15:06:14 +0900
Message-ID: <CAD90Vcad9+-9VXkwb93voFK9gEZnhJ-WXwD5=1ugsdOq5e-GOg@mail.gmail.com>
Subject: Re: [RFC PATCH v1] media: uvcvideo: Cache URB header data before processing
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        kieran.bingham@ideasonboard.com,
        Douglas Anderson <dianders@chromium.org>,
        ezequiel@collabora.com, "Matwey V. Kornilov" <matwey@sai.msu.ru>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all.

We performed two types of experiments.

In the first experiment, we compared the performance of uvcvideo by
changing a way of memory allocation, usb_alloc_coherent and kmalloc.
At the same time, we changed conditions by enabling/disabling
asynchronous memory copy suggested by Kieran in [1].

The second experiment is a comparison between dma_unmap/map and dma_sync.
Here, DMA mapping is done manually in uvc handlers. This is similar to
Matwey's patch for pwc.
https://patchwork.kernel.org/patch/10468937/.

Raw data are pasted after descriptions of the experiments.

# Settings
The test device was Jerry Chromebook (RK3288) with Logitech Brio 4K.
We did video capturing at
https://webrtc.github.io/samples/src/content/getusermedia/resolution/
with Full HD resolution in about 30 seconds for each condition.

For logging statistics, I used Kieran's patch [2].

## Exp. 1
Here, we have two parameters, way of memory allocation and
enabling/disabling async memcopy.
So, there were 4 combinations:

A. No Async + usb_alloc_coherent (with my patch caching header data)
   Patch: [3] + [4]
   Since Kieran's async patches are already merged into ChromeOS's
kernel, we disabled it by [3].
   Patch [4] is an updated version of my patch.

B. No Async + kmalloc
   Patch: [3] + [5]
   [5] just adds '#define CONFIG_DMA_NONCOHERENT' at the beginning of
uvc_video.c to use kmalloc.

C. Async + usb_alloc_coherent (with my patch caching header data)
   Patch: [4]

D. Async + kmalloc
   Patch: [5]

## Exp. 2
The conditions of the second experiment are based on condition D,
where URB buffers are allocated by kmalloc and Kieran's asynchronous
patches are enabled.

E. Async + kmalloc + manually unmap/map for each packet
   Patch: [6]
   URB_NO_TRANSFER_DMA_MAP flag is used here. dma_map and dma_unmap
are explicitly called manually in uvc_video.c.

F. Async + kmalloc + manually sync for each packet
   Patch: [7]
   In uvc_video_complete, dma_single_for_cpu is called instead of
dma_unmap_single and dma_map_single.

Note that the elapsed times for E and F cannot be compared with those
for D in a simple way.
This is because we don't measure elapsed time of functions outside of
uvcvideo.c by [2].
For example, while DMA-unmapping for each packet is done before
uvc_video_complete is called at the condition D,
it's done in uvc_video_complete at the condition E.

# References for patches
[1] Asynchronous UVC
https://www.mail-archive.com/linux-media@vger.kernel.org/msg128359.html

[2] Kieran's patch for measuring the performance of uvcvideo.
https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/commit/?h=uvc/async-ml&id=cebbd1b629bbe5f856ec5dc7591478c003f5a944
I used the modified version of it for ChromeOS, but almost same.
http://crrev.com/c/1184597
The main difference is that our patch uses do_div instead of / and %.

[3] Disable asynchronous decoding
http://crrev.com/c/1184658

[4] Cache URB header data before processing
http://crrev.com/c/1179554
This is an updated version of my patch I sent at the begging of this thread.
I applied Kieran's review comments.

[5] Use kmalloc for urb buffer
http://crrev.com/c/1184643

[6] Manually DMA dma_unmap/map for each packet
http://crrev.com/c/1186293

[7] Manually DMA sync for each packet
http://crrev.com/c/1186214

# Results

For the meanings of each value, please see Kieran's patch:
https://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git/commit/?h=uvc/async-ml&id=cebbd1b629bbe5f856ec5dc7591478c003f5a944

## Exp. 1

A. No Async + usb_alloc_coherent (with my patch caching header data)
frames:  1121
packets: 233471
empty:   44729 (19 %)
errors:  34801
invalid: 8017
pts: 1121 early, 986 initial, 1121 ok
scr: 1121 count ok, 111 diff ok
sof: 0 <= sof <= 0, freq 0.000 kHz
bytes 135668717 : duration 32907
FPS: 34.06
URB: 427489/3048 uS/qty: 140.252 avg 2.625 min 660.625 max (uS)
header: 440868/3048 uS/qty: 144.641 avg 0.000 min 674.625 max (uS)
latency: 30703/3048 uS/qty: 10.073 avg 0.875 min 26.541 max (uS)
decode: 396785/3048 uS/qty: 130.179 avg 0.875 min 634.375 max (uS)
raw decode speed: 2.740 Gbits/s
raw URB handling speed: 2.541 Gbits/s
throughput: 32.982 Mbits/s
URB decode CPU usage 1.205779 %

---

B. No Async memcpy + kmalloc
frames:  949
packets: 243665
empty:   47804 (19 %)
errors:  2406
invalid: 1058
pts: 949 early, 927 initial, 860 ok
scr: 949 count ok, 17 diff ok
sof: 0 <= sof <= 0, freq 0.000 kHz
bytes 145563878 : duration 30939
FPS: 30.67
URB: 107265/2448 uS/qty: 43.817 avg 3.791 min 212.042 max (uS)
header: 192608/2448 uS/qty: 78.679 avg 0.000 min 471.625 max (uS)
latency: 24860/2448 uS/qty: 10.155 avg 1.750 min 28.000 max (uS)
decode: 82405/2448 uS/qty: 33.662 avg 1.750 min 186.084 max (uS)
raw decode speed: 14.201 Gbits/s
raw URB handling speed: 10.883 Gbits/s
throughput: 37.638 Mbits/s
URB decode CPU usage 0.266349 %

---

C. Async + usb_alloc_coherent (with my patch caching header data)
frames:  874
packets: 232786
empty:   45594 (19 %)
errors:  46
invalid: 48
pts: 874 early, 873 initial, 874 ok
scr: 874 count ok, 1 diff ok
sof: 0 <= sof <= 0, freq 0.000 kHz
bytes 137989497 : duration 29139
FPS: 29.99
URB: 577349/2301 uS/qty: 250.912 avg 24.208 min 1009.459 max (uS)
header: 50334/2301 uS/qty: 21.874 avg 0.000 min 77.583 max (uS)
latency: 77597/2301 uS/qty: 33.723 avg 15.458 min 172.375 max (uS)
decode: 499751/2301 uS/qty: 217.188 avg 4.084 min 978.542 max (uS)
raw decode speed: 2.212 Gbits/s
raw URB handling speed: 1.913 Gbits/s
throughput: 37.884 Mbits/s
URB decode CPU usage 1.715060 %

---

D. Async memcpy + kmalloc
frames:  870
packets: 231152
empty:   45390 (19 %)
errors:  171
invalid: 160
pts: 870 early, 870 initial, 810 ok
scr: 870 count ok, 0 diff ok
sof: 0 <= sof <= 0, freq 0.000 kHz
bytes 137406842 : duration 29036
FPS: 29.96
URB: 160821/2258 uS/qty: 71.222 avg 15.750 min 985.542 max (uS)
header: 40369/2258 uS/qty: 17.878 avg 0.000 min 56.292 max (uS)
latency: 72411/2258 uS/qty: 32.068 avg 10.792 min 946.459 max (uS)
decode: 88410/2258 uS/qty: 39.154 avg 1.458 min 246.167 max (uS)
raw decode speed: 12.491 Gbits/s
raw URB handling speed: 6.870 Gbits/s
throughput: 37.858 Mbits/s
URB decode CPU usage 0.304485 %

----------------------------------------
## Exp. 2

E. Async + kmalloc + manually dma_unmap/map for each packet
frames:  928
packets: 247476
empty:   34060 (13 %)
errors:  16
invalid: 32
pts: 928 early, 928 initial, 163 ok
scr: 928 count ok, 0 diff ok
sof: 0 <= sof <= 0, freq 0.000 kHz
bytes 103315132 : duration 30949
FPS: 29.98
URB: 169873/1876 uS/qty: 90.551 avg 43.750 min 289.917 max (uS)
header: 88962/1876 uS/qty: 47.421 avg 0.000 min 113.750 max (uS)
latency: 109539/1876 uS/qty: 58.389 avg 37.042 min 253.459 max (uS)
decode: 60334/1876 uS/qty: 32.161 avg 2.041 min 124.542 max (uS)
raw decode speed: 13.775 Gbits/s
raw URB handling speed: 4.890 Gbits/s
throughput: 26.705 Mbits/s
URB decode CPU usage 0.194948 %

---

F. Async + kmalloc + manually dma_sync for each packet
frames:  927
packets: 246994
empty:   33997 (13 %)
errors:  226
invalid: 65
pts: 927 early, 927 initial, 560 ok
scr: 927 count ok, 0 diff ok
sof: 0 <= sof <= 0, freq 0.000 kHz
bytes 103017167 : duration 30938
FPS: 29.96
URB: 170630/1868 uS/qty: 91.344 avg 43.167 min 1142.167 max (uS)
header: 86372/1868 uS/qty: 46.237 avg 0.000 min 163.917 max (uS)
latency: 109148/1868 uS/qty: 58.430 avg 35.292 min 1106.583 max (uS)
decode: 61482/1868 uS/qty: 32.913 avg 2.334 min 215.833 max (uS)
raw decode speed: 13.510 Gbits/s
raw URB handling speed: 4.847 Gbits/s
throughput: 26.638 Mbits/s
URB decode CPU usage 0.198726 %

----------------------------------------

I hope this helps.

Best regards,
Keiichi
On Thu, Aug 9, 2018 at 11:12 PM Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Thu, 9 Aug 2018, Laurent Pinchart wrote:
>
> > > >> There is no need to wonder.  "Frequent DMA mapping/Cached memory" is
> > > >> always faster than "No DMA mapping/Uncached memory".
> > > >
> > > > Is it really, doesn't it depend on the CPU access pattern ?
> > >
> > > Well, if your access pattern involves transferring data in from the
> > > device and then throwing it away without reading it, you might get a
> > > different result.  :-)  But assuming you plan to read the data after
> > > transferring it, using uncached memory slows things down so much that
> > > the overhead of DMA mapping/unmapping is negligible by comparison.
> >
> > :-) I suppose it would also depend on the access pattern, if I only need to
> > access part of the buffer, performance figures may vary. In this case however
> > the whole buffer needs to be copied.
> >
> > > The only exception might be if you were talking about very small
> > > amounts of data.  I don't know exactly where the crossover occurs, but
> > > bear in mind that Matwey's tests required ~50 us for mapping/unmapping
> > > and 3000 us for accessing uncached memory.  He didn't say how large the
> > > transfers were, but that's still a pretty big difference.
> >
> > For UVC devices using bulk endpoints data buffers are typically tens of kBs.
> > For devices using isochronous endpoints, that goes down to possibly hundreds
> > of bytes for some buffers. Devices can send less data than the maximum packet
> > size, and mapping/unmapping would still invalidate the cache for the whole
> > buffer. If we keep the mappings around and use the DMA sync API, we could
> > possibly restrict the cache invalidation to the portion of the buffer actually
> > written to.
>
> Furthermore, invalidating a cache is likely to require less overhead
> than using non-cacheable memory.  After the cache has been invalidated,
> it can be repopulated relatively quickly (an entire cache line at a
> time), whereas reading uncached memory requires a slow transaction for
> each individual read operation.
>
> I think adding support to the USB core for
> dma_sync_single_for_{cpu|device} would be a good approach.  In fact, I
> wonder whether using coherent mappings provides any benefit at all.
>
> Alan Stern
>
