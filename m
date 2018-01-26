Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:45646 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeAZGCl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Jan 2018 01:02:41 -0500
Received: by mail-pg0-f47.google.com with SMTP id m136so6609416pga.12
        for <linux-media@vger.kernel.org>; Thu, 25 Jan 2018 22:02:41 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFC PATCH 0/8] [media] Request API, take three
Date: Fri, 26 Jan 2018 15:02:08 +0900
Message-Id: <20180126060216.147918-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Howdy. Here is your bi-weekly request API redesign! ;)

Again, this is a simple version that only implements the flow of requests,
without applying controls. The intent is to get an agreement on a base to work
on, since the previous versions went straight back to the redesign board.

Highlights of this version:

* As requested by Hans, request-bound buffers are now passed earlier to drivers,
as early as the request itself is submitted. Doing it earlier is not be useful
since the driver would not know the state of the request, and thus cannot do
anything with the buffer. Drivers are now responsible for applying request
parameters themselves.

* As a consequence, there is no such thing as a "request queue" anymore. The
flow of buffers decides the order in which requests are processed. Individual
devices of the same pipeline can implement synchronization if needed, but this
is beyond this first version.

* VB2 code is still a bit shady. Some of it will interfere with the fences
series, so I am waiting for the latter to land to do it properly.

* Requests that are not yet submitted effectively act as fences on the buffers
they own, resulting in the buffer queue being blocked until the request is
submitted. An alternate design would be to only block the
not-submitted-request's buffer and let further buffers pass before it, but since
buffer order is becoming increasingly important I have decided to just block the
queue. This is open to discussion though.

* Documentation! Also described usecases for codec and simple (i.e. not part of
a complex pipeline) capture device.

Still remaining to do:

* As pointed out by Hans on the previous revision, do not assume that drivers
using v4l2_fh have a per-handle state. I have not yet found a good way to
differenciate both usages.

* Integrate Hans' patchset for control handling: as said above, this is futile
unless we can agree on the basic design, which I hope we can do this time.
Chrome OS needs this really badly now and will have to move forward no matter
what, so I hope this will be considered good enough for a common base of work.

A few thoughts/questions that emerged when writing this patchset:

* Since requests are exposed as file descriptors, we could easily move the
MEDIA_REQ_CMD_SUBMIT and MEDIA_REQ_CMD_REININT commands as ioctls on the
requests themselves, instead of having to perform them on the media device that
provided the request in the first place. That would add a bit more flexibility
if/when passing requests around and means the media device only needs to handle
MEDIA_REQ_CMD_ALLOC. Conceptually speaking, this seems to make sense to me.
Any comment for/against that?

* For the codec usecase, I have experimented a bit marking CAPTURE buffers with
the request FD that produced them (vim2m acts that way). This seems to work
well, however FDs are process-local and could be closed before the CAPTURE
buffer is dequeued, rendering that information less meaningful, if not
dangerous. Wouldn't it be better/safer to use a global request ID for
such information instead? That ID would be returned upon MEDIA_REQ_CMD_ALLOC so
user-space knows which request ID a FD refers to.

* Using the media node to provide requests makes absolute sense for complex
camera devices, but is tedious for codec devices which work on one node and
require to protect request/media related code with #ifdef
CONFIG_MEDIA_CONTROLLER. For these devices, the sole role of the media node is
to produce the request, and that's it (since request submission could be moved
to the request FD as explained above). That's a modest use that hardly justifies
bringing in the whole media framework IMHO. With a bit of extra abstraction, it
should be possible to decouple the base requests from the media controller
altogether, and propose two kinds of requests implementations: one simpler
implementation that works directly with a single V4L2 node (useful for codecs),
and another one that works on a media node and can control all its entities
(good for camera). This would allow codecs to use the request API without
forcing the media controller, and would considerably simplify the use-case. Any
objection to that? IIRC the earlier design documents mentioned this possibility.

Alexandre Courbot (6):
  media: add request API core and UAPI
  media: videobuf2: add support for requests
  media: vb2: add support for requests in QBUF ioctl
  v4l2: document the request API interface
  media: vim2m: add media device
  media: vim2m: add request support

Hans Verkuil (1):
  videodev2.h: Add request field to v4l2_buffer

Laurent Pinchart (1):
  media: Document the media request API

 Documentation/media/uapi/mediactl/media-funcs.rst  |   1 +
 .../media/uapi/mediactl/media-ioc-request-cmd.rst  | 140 ++++++++++
 Documentation/media/uapi/v4l/buffer.rst            |  10 +-
 Documentation/media/uapi/v4l/common.rst            |   1 +
 Documentation/media/uapi/v4l/request-api.rst       | 194 +++++++++++++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  21 ++
 drivers/media/Makefile                             |   3 +-
 drivers/media/media-device.c                       |   7 +
 drivers/media/media-request-mgr.c                  | 107 +++++++
 drivers/media/media-request.c                      | 308 +++++++++++++++++++++
 drivers/media/platform/vim2m.c                     |  55 ++++
 drivers/media/usb/cpia2/cpia2_v4l.c                |   2 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   7 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  85 +++++-
 drivers/media/v4l2-core/videobuf2-core.c           | 125 ++++++++-
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  31 ++-
 include/media/media-device.h                       |   3 +
 include/media/media-request-mgr.h                  |  73 +++++
 include/media/media-request.h                      | 184 ++++++++++++
 include/media/videobuf2-core.h                     |  15 +-
 include/media/videobuf2-v4l2.h                     |   2 +
 include/uapi/linux/media.h                         |  10 +
 include/uapi/linux/videodev2.h                     |   3 +-
 23 files changed, 1365 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-cmd.rst
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 drivers/media/media-request-mgr.c
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request-mgr.h
 create mode 100644 include/media/media-request.h

-- 
2.16.0.rc1.238.g530d649a79-goog
