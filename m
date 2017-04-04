Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41290 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751092AbdDDLe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 07:34:57 -0400
Date: Tue, 4 Apr 2017 14:34:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: Re: [RFC 00/10] V4L2 explicit synchronization support
Message-ID: <20170404113449.GC3288@valkosipuli.retiisi.org.uk>
References: <20170313192035.29859-1-gustavo@padovan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gustavo,

Thank you for the patchset. Please see my comments below.

On Mon, Mar 13, 2017 at 04:20:25PM -0300, Gustavo Padovan wrote:
> From: Gustavo Padovan <gustavo.padovan@collabora.com>
> 
> Hi,
> 
> This RFC adds support for Explicit Synchronization of shared buffers in V4L2.
> It uses the Sync File Framework[1] as vector to communicate the fences
> between kernel and userspace.
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

Shouldn't you be able to add two fences to the buffer, one in and one out?
I.e. you'd have the buffer passed from another device to a V4L2 device and
on to a third device.

(Or, two fences per a plane, as you elaborated below.)

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
> 
> * Should we have out-fences per-buffer or per-plane? or both? In this RFC, for
> simplicity they are per-buffer, but Mauro and Javier raised the option of
> doing per-plane fences. That could benefit mem2mem and V4L2 <-> GPU operation
> at least on cases when we have Capture hw that releases the Y frame before the
> other frames for example. When using V4L2 per-plane out-fences to communicate
> with KMS they would need to be merged together as currently the DRM Plane
> interface only supports one fence per DRM Plane.
> 
> In-fences should be per-buffer as the DRM only has per-buffer fences, but
> in case of mem2mem operations per-plane fences might be useful?
> 
> So should we have both ways, per-plane and per-buffer, or just one of them
> for now?

The data_offset field is only present in struct v4l2_plane, i.e. it is only
available through using the multi-planar API even if you just have a single
plane.

I'd say it'd be appropriate to have a fence per-plane, but I have no strong
opinion either way at least at the moment.

How otherwise could you make use of this in multi-planar OUTPUT queues? It
may seem like a far-fetched use case but I still wouldn't ignore it in
design.

> 
> * other open topics are how to deal with hw-fences and Request API.
> 
> Comments are welcome!
> 
> Regards,
> 
> Gustavo
> 
> ---
> Gustavo Padovan (9):
>   [media] vb2: add explicit fence user API
>   [media] vb2: split out queueing from vb_core_qbuf()
>   [media] vb2: add in-fence support to QBUF
>   [media] uvc: enable subscriptions to other events
>   [media] vivid: assign the specific device to the vb2_queue->dev
>   [media] v4l: add V4L2_EVENT_BUF_QUEUED event
>   [media] v4l: add support to BUF_QUEUED event
>   [media] vb2: add infrastructure to support out-fences
>   [media] vb2: add out-fence support to QBUF
> 
> Javier Martinez Canillas (1):
>   [media] vb2: add videobuf2 dma-buf fence helpers
> 
>  drivers/media/Kconfig                         |   1 +
>  drivers/media/platform/vivid/vivid-core.c     |  10 +-
>  drivers/media/usb/uvc/uvc_v4l2.c              |   2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   4 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c          |   6 +-
>  drivers/media/v4l2-core/videobuf2-core.c      | 139 ++++++++++++++++++++------
>  drivers/media/v4l2-core/videobuf2-v4l2.c      |  29 +++++-
>  include/media/videobuf2-core.h                |  12 ++-
>  include/media/videobuf2-fence.h               |  49 +++++++++
>  include/uapi/linux/videodev2.h                |  12 ++-
>  10 files changed, 218 insertions(+), 46 deletions(-)
>  create mode 100644 include/media/videobuf2-fence.h
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
