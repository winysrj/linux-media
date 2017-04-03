Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:58069
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751489AbdDCLQS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 07:16:18 -0400
Date: Mon, 3 Apr 2017 08:16:10 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC 00/10] V4L2 explicit synchronization support
Message-ID: <20170403081610.16a2a3fc@vento.lan>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

Em Mon, 13 Mar 2017 16:20:25 -0300
Gustavo Padovan <gustavo@padovan.org> escreveu:

> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Hi,
> 
> This RFC adds support for Explicit Synchronization of shared buffers in V4L2.
> It uses the Sync File Framework[1] as vector to communicate the fences
> between kernel and userspace.

Thanks for your work!

I looked on your patchset, and I didn't notice anything really weird
there. So, instead on reviewing patch per patch, I prefer to discuss
about the requirements and API, as depending on it, the code base will
change a lot.

I'd like to do some tests with it on devices with mem2mem drivers.
My plan is to use an Exynos board for such thing, but I guess that
the DRM driver for it currently doesn't. I'm seeing internally if someone
could be sure that Exynos driver upstream will become ready for such
tests.

Javier wrote some patches last year meant to implement implicit
fences support. What we noticed is that, while his mechanism worked
fine for pure capture and pure output devices, when we added a mem2mem
device, on a DMABUF+fences pipeline, e. g.:

	sensor -> [m2m] -> DRM

End everything using fences/DMABUF, the fences mechanism caused dead
locks on existing userspace apps.

A m2m device has both capture and output devnodes. Both should be
queued/dequeued. The capture queue is synchronized internally at the
driver with the output buffer[1].

[1] The names here are counter-intuitive: "capture" is a devnode
where userspace receives a video stream; "output" is a devnode where
userspace feeds a video stream.

The problem is that adding implicit fences changed the behavior of
the ioctls, causing gstreamer to wait forever for buffers to be ready.

I suspect that, even with explicit fences, the behavior of Q/DQ
will be incompatible with the current behavior (or will require some
dirty hacks to make it identical). 

So, IMHO, the best would be to use a new set of ioctls, when fences are
used (like VIDIOC_QFENCE/DQFENCE).

> 
> I'm sending this to start the discussion on the best approach to implement
> Explicit Synchronization, please check the TODO/OPEN section below.
> 
> Explicit Synchronization allows us to control the synchronization of
> shared buffers from userspace by passing fences to the kernel and/or 
> receiving them from the the kernel.
> 
> Fences passed to the kernel are named in-fences and the kernel should wait
> them to signal before using the buffer. On the other side, the kernel creates
> out-fences for every buffer it receives from userspace. This fence is sent back
> to userspace and it will signal when the capture, for example, has finished.
> 
> Signalling an out-fence in V4L2 would mean that the job on the buffer is done
> and the buffer can be used by other drivers.
> 
> Current RFC implementation
> --------------------------
> 
> The current implementation is not intended to be more than a PoC to start
> the discussion on how Explicit Synchronization should be supported in V4L2.
> 
> The first patch proposes an userspace API for fences, then on patch 2
> we prepare to the addition of in-fences in patch 3, by introducing the
> infrastructure on vb2 to wait on an in-fence signal before queueing the buffer
> in the driver.
> 
> Patch 4 fix uvc v4l2 event handling and patch 5 configure q->dev for vivid
> drivers to enable to subscribe and dequeue events on it.
> 
> Patches 6-7 enables support to notify BUF_QUEUED events, i.e., let userspace
> know that particular buffer was enqueued in the driver. This is needed,
> because we return the out-fence fd as an out argument in QBUF, but at the time
> it returns we don't know to which buffer the fence will be attached thus
> the BUF_QUEUED event tells which buffer is associated to the fence received in
> QBUF by userspace.
> 
> Patches 8 and 9 add more fence infrastructure to support out-fences and finally
> patch 10 adds support to out-fences.
> 
> TODO/OPEN:
> ----------
> 
> * For this first implementation we will keep the ordering of the buffers queued
> in videobuf2, that means we will only enqueue buffer whose fence was signalled
> if that buffer is the first one in the queue. Otherwise it has to wait until it
> is the first one. This is not implmented yet. Later we could create a flag to
> allow unordered queing in the drivers from vb2 if needed.

The V4L2 spec doesn't warrant that the buffers will be dequeued at the
queue order.

In practice, however, most drivers will not reorder. Yet, mem2mem codec 
drivers may reorder the buffers at the output, as the luminance information
(Y) usually comes first on JPEG/MPEG-like formats.

> * Should we have out-fences per-buffer or per-plane? or both? In this RFC, for
> simplicity they are per-buffer, but Mauro and Javier raised the option of
> doing per-plane fences. That could benefit mem2mem and V4L2 <-> GPU operation
> at least on cases when we have Capture hw that releases the Y frame before the
> other frames for example. When using V4L2 per-plane out-fences to communicate
> with KMS they would need to be merged together as currently the DRM Plane
> interface only supports one fence per DRM Plane.

That's another advantage of using a new set of ioctls for queues: with that,
queuing/dequeing per plane will be easier. On codec drivers, doing it per
plane could bring performance improvements.

> In-fences should be per-buffer as the DRM only has per-buffer fences, but
> in case of mem2mem operations per-plane fences might be useful?
> 
> So should we have both ways, per-plane and per-buffer, or just one of them
> for now?

The API should be flexible enough to support both usecases. We could
implement just per-buffer in the beginning, but, on such case, we
should deploy an API that will allow to later add per-plane fences
without breaking userspace.

So, I prefer that, on multiplane fences, we have one fence per plane,
even if, at the first implementation, all fences will be released
at the same time, when the buffer is fully filled. That would allow
us to later improve it, without changing userspace.

> * other open topics are how to deal with hw-fences and Request API.

Let's not mix issues here. Request API is already complex enough
without explicit fences. The same is true for explicit fences: it is 
also complex to add support for it with multi-planes and a not
ordered DQ. 

So, my suggestion here is to not delay Request API due to fences,
nor to delay fences due to Request API, letting them to be merged
on different Kernel releases. When both features got added, someone
can work on a patchset that would allow using Request API with fences.

-- 
Thanks,
Mauro
