Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49419 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752423AbcLOUPu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 15:15:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com,
        hverkuil@xs4all.nl, sumit.semwal@linaro.org, robdclark@gmail.com,
        daniel.vetter@ffwll.ch, labbott@redhat.com
Subject: Re: [RFC RESEND 04/11] v4l: Unify cache management hint buffer flags
Date: Thu, 15 Dec 2016 22:15:39 +0200
Message-ID: <1519569.UjI4aaJYKi@avalon>
In-Reply-To: <1441972234-8643-5-git-send-email-sakari.ailus@linux.intel.com>
References: <1441972234-8643-1-git-send-email-sakari.ailus@linux.intel.com> <1441972234-8643-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Friday 11 Sep 2015 14:50:27 Sakari Ailus wrote:
> The V4L2_BUF_FLAG_NO_CACHE_INVALIDATE and V4L2_BUF_FLAG_NO_CACHE_CLEAN
> buffer flags are currently not used by the kernel. Replace the definitions
> by a single V4L2_BUF_FLAG_NO_CACHE_SYNC flag to be used by further
> patches.
> 
> Different cache architectures should not be visible to the user space
> which can make no meaningful use of the differences anyway. In case a
> device can make use of non-coherent memory accesses, the necessary cache
> operations depend on the CPU architecture and the buffer type, not the
> requests of the user. The cache operation itself may be skipped on the
> user's request which was the purpose of the two flags.
> 
> On ARM the invalidate and clean are separate operations whereas on
> x86(-64) the two are a single operation (flush). Whether the hardware uses
> the buffer for reading (V4L2_BUF_TYPE_*_OUTPUT*) or writing
> (V4L2_BUF_TYPE_*CAPTURE*) already defines the required cache operation
> (clean and invalidate, respectively). No user input is required.

We need to perform the following operations.

	| QBUF		| DQBUF
-----------------------------------------------
CAPTURE	| Invalidate	| Invalidate (*)
OUTPUT	| Clean		| -

(*) for systems using speculative pre-fetching only.

The following optimizations are possible:

1. CAPTURE, the CPU has not written to the buffer before QBUF

Cache invalidation can be skipped at QBUF time, but becomes required at DQBUF 
time on all systems, regardless of whether they use speculative prefetching.

2. CAPTURE, the CPU will not read from the buffer after DQBUF

Cache invalidation can be skipped at DQBUF time.

3. CAPTURE, combination of (1) and (2)

Cache invalidation can be skipped at both QBUF and DQBUF time.

4. OUTPUT, the CPU has not written to the buffer before QBUF

Cache clean can be skipped at QBUF time.


A single flag can cover all cases, provided we keep track of the flag being 
set at QBUF time to force cache invalidation at DQBUF time for case (1) if the 
flag isn't set at DQBUF time.

One issue is that cache invalidation at DQBUF time for CAPTURE buffers isn't 
fully under the control of videobuf. We can instruct the DMA mapping API to 
skip cache handling, but we can't ask it to force cache invalidation in the 
sync_for_cpu operation for non speculative prefetching systems. On ARM32 the 
implementation currently always invalidates the cache in 
__dma_page_dev_to_cpu() for CAPTURE buffers so we're currently safe, but 
there's a FIXME comment that might lead to someone fixing the implementation 
in the future. I believe we'll have to fix this in the DMA mapping level, 
userspace shouldn't be affected.

Feel free to capture (part of) this explanation in the commit message to 
clarify your last paragraph.

> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
>  Documentation/DocBook/media/v4l/io.xml | 25 +++++++++++--------------
>  include/trace/events/v4l2.h            |  3 +--
>  include/uapi/linux/videodev2.h         |  7 +++++--
>  3 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml
> b/Documentation/DocBook/media/v4l/io.xml index 7bbc2a4..4facd63 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -1112,21 +1112,18 @@ application. Drivers set or clear this flag when the
> linkend="vidioc-qbuf">VIDIOC_DQBUF</link> ioctl is called.</entry> </row>
>  	  <row>
> -	    
<entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
> +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_SYNC</constant></entry>
>  	    <entry>0x00000800</entry>
> -	    <entry>Caches do not have to be invalidated for this buffer.
> -Typically applications shall use this flag if the data captured in the
> buffer -is not going to be touched by the CPU, instead the buffer will,
> probably, be -passed on to a DMA-capable hardware unit for further
> processing or output. -</entry>
> -	  </row>
> -	  <row>
> -	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
> -	    <entry>0x00001000</entry>
> -	    <entry>Caches do not have to be cleaned for this buffer.
> -Typically applications shall use this flag for output buffers if the data
> -in this buffer has not been created by the CPU but by some DMA-capable
> unit, -in which case caches have not been used.</entry>
> +	    <entry>Do not perform CPU cache synchronisation operations
> +	    when the buffer is queued or dequeued. The user is
> +	    responsible for the correct use of this flag. It should be
> +	    only used when the buffer is not accessed using the CPU,
> +	    e.g. the buffer is written to by a hardware block and then
> +	    read by another one, in which case the flag should be set
> +	    in both <link linkend="vidioc-qbuf">VIDIOC_DQBUF</link>
> +	    and <link linkend="vidioc-qbuf">VIDIOC_QBUF</link> IOCTLs.

I'd like to word this differently. As explained above, there can be cases 
where the flag would only be set in either QBUF or DQBUF. I would prefer 
documenting the flag as a hint for the kernel that userspace has not written 
to the buffer before QBUF (when the flag is set for VIDIOC_QBUF) or will not 
read from the buffer after DQBUF (when the flag is set for VIDIOC_DQBUF) and 
that the kernel is free to perform the appropriate cache optimizations 
(without any guarantee).

> +	    The flag has no effect on some devices / architectures.
> +	    </entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_BUF_FLAG_LAST</constant></entry>

[snip]

-- 
Regards,

Laurent Pinchart

