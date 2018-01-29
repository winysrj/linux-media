Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:36632 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751298AbeA2LVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 Jan 2018 06:21:19 -0500
Subject: Re: [RFC PATCH 0/8] [media] Request API, take three
To: Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180126060216.147918-1-acourbot@chromium.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ced425a2-8b66-05c6-367d-46a0a40b1873@xs4all.nl>
Date: Mon, 29 Jan 2018 12:21:08 +0100
MIME-Version: 1.0
In-Reply-To: <20180126060216.147918-1-acourbot@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/26/2018 07:02 AM, Alexandre Courbot wrote:
> Howdy. Here is your bi-weekly request API redesign! ;)
> 
> Again, this is a simple version that only implements the flow of requests,
> without applying controls. The intent is to get an agreement on a base to work
> on, since the previous versions went straight back to the redesign board.
> 
> Highlights of this version:
> 
> * As requested by Hans, request-bound buffers are now passed earlier to drivers,
> as early as the request itself is submitted. Doing it earlier is not be useful
> since the driver would not know the state of the request, and thus cannot do
> anything with the buffer. Drivers are now responsible for applying request
> parameters themselves.
> 
> * As a consequence, there is no such thing as a "request queue" anymore. The
> flow of buffers decides the order in which requests are processed. Individual
> devices of the same pipeline can implement synchronization if needed, but this
> is beyond this first version.
> 
> * VB2 code is still a bit shady. Some of it will interfere with the fences
> series, so I am waiting for the latter to land to do it properly.
> 
> * Requests that are not yet submitted effectively act as fences on the buffers
> they own, resulting in the buffer queue being blocked until the request is
> submitted. An alternate design would be to only block the
> not-submitted-request's buffer and let further buffers pass before it, but since
> buffer order is becoming increasingly important I have decided to just block the
> queue. This is open to discussion though.

I don't think we should mess with the order.

> 
> * Documentation! Also described usecases for codec and simple (i.e. not part of
> a complex pipeline) capture device.

I'll concentrate on reviewing that.

> 
> Still remaining to do:
> 
> * As pointed out by Hans on the previous revision, do not assume that drivers
> using v4l2_fh have a per-handle state. I have not yet found a good way to
> differenciate both usages.

I suspect we need to add a flag or something for this.

> * Integrate Hans' patchset for control handling: as said above, this is futile
> unless we can agree on the basic design, which I hope we can do this time.
> Chrome OS needs this really badly now and will have to move forward no matter
> what, so I hope this will be considered good enough for a common base of work.

I am not sure there is any reason to not move forward with the control handling.
You need this anyway IMHO, regardless of any public API considerations.

> A few thoughts/questions that emerged when writing this patchset:
> 
> * Since requests are exposed as file descriptors, we could easily move the
> MEDIA_REQ_CMD_SUBMIT and MEDIA_REQ_CMD_REININT commands as ioctls on the
> requests themselves, instead of having to perform them on the media device that
> provided the request in the first place. That would add a bit more flexibility
> if/when passing requests around and means the media device only needs to handle
> MEDIA_REQ_CMD_ALLOC. Conceptually speaking, this seems to make sense to me.
> Any comment for/against that?

Makes sense IMHO.

> * For the codec usecase, I have experimented a bit marking CAPTURE buffers with
> the request FD that produced them (vim2m acts that way). This seems to work
> well, however FDs are process-local and could be closed before the CAPTURE
> buffer is dequeued, rendering that information less meaningful, if not
> dangerous.

I don't follow this. Once the fd is passed to the kernel its refcount should be
increased so the data it represents won't be released if userspace closes the fd.

Obviously if userspace closes the fd it cannot do anything with it anymore, but
it shouldn't be 'dangerous' AFAICT.

> Wouldn't it be better/safer to use a global request ID for
> such information instead? That ID would be returned upon MEDIA_REQ_CMD_ALLOC so
> user-space knows which request ID a FD refers to.

I think it is not a good idea to have both an fd and an ID to refer to the
same object. That's going to be very confusing I think.

> * Using the media node to provide requests makes absolute sense for complex
> camera devices, but is tedious for codec devices which work on one node and
> require to protect request/media related code with #ifdef
> CONFIG_MEDIA_CONTROLLER.

Why? They would now depend on MEDIA_CONTROLLER (i.e. they won't appear in the
menuconfig unless MEDIA_CONTROLLER is set). No need for an #ifdef.

 For these devices, the sole role of the media node is
> to produce the request, and that's it (since request submission could be moved
> to the request FD as explained above). That's a modest use that hardly justifies
> bringing in the whole media framework IMHO. With a bit of extra abstraction, it
> should be possible to decouple the base requests from the media controller
> altogether, and propose two kinds of requests implementations: one simpler
> implementation that works directly with a single V4L2 node (useful for codecs),
> and another one that works on a media node and can control all its entities
> (good for camera). This would allow codecs to use the request API without
> forcing the media controller, and would considerably simplify the use-case. Any
> objection to that? IIRC the earlier design documents mentioned this possibility.

I think this is an interesting idea, but I would postpone making a decision on
this until later. We need this MC support regardless, so let's start off with that.

Once that's working we can discuss if we should or should not create a shortcut
for codecs. Trying to decide this now would only confuse the process.

Regards,

	Hans

> 
> Alexandre Courbot (6):
>   media: add request API core and UAPI
>   media: videobuf2: add support for requests
>   media: vb2: add support for requests in QBUF ioctl
>   v4l2: document the request API interface
>   media: vim2m: add media device
>   media: vim2m: add request support
> 
> Hans Verkuil (1):
>   videodev2.h: Add request field to v4l2_buffer
> 
> Laurent Pinchart (1):
>   media: Document the media request API
> 
>  Documentation/media/uapi/mediactl/media-funcs.rst  |   1 +
>  .../media/uapi/mediactl/media-ioc-request-cmd.rst  | 140 ++++++++++
>  Documentation/media/uapi/v4l/buffer.rst            |  10 +-
>  Documentation/media/uapi/v4l/common.rst            |   1 +
>  Documentation/media/uapi/v4l/request-api.rst       | 194 +++++++++++++
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  21 ++
>  drivers/media/Makefile                             |   3 +-
>  drivers/media/media-device.c                       |   7 +
>  drivers/media/media-request-mgr.c                  | 107 +++++++
>  drivers/media/media-request.c                      | 308 +++++++++++++++++++++
>  drivers/media/platform/vim2m.c                     |  55 ++++
>  drivers/media/usb/cpia2/cpia2_v4l.c                |   2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   7 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |  85 +++++-
>  drivers/media/v4l2-core/videobuf2-core.c           | 125 ++++++++-
>  drivers/media/v4l2-core/videobuf2-v4l2.c           |  31 ++-
>  include/media/media-device.h                       |   3 +
>  include/media/media-request-mgr.h                  |  73 +++++
>  include/media/media-request.h                      | 184 ++++++++++++
>  include/media/videobuf2-core.h                     |  15 +-
>  include/media/videobuf2-v4l2.h                     |   2 +
>  include/uapi/linux/media.h                         |  10 +
>  include/uapi/linux/videodev2.h                     |   3 +-
>  23 files changed, 1365 insertions(+), 22 deletions(-)
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-cmd.rst
>  create mode 100644 Documentation/media/uapi/v4l/request-api.rst
>  create mode 100644 drivers/media/media-request-mgr.c
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request-mgr.h
>  create mode 100644 include/media/media-request.h
> 
