Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f48.google.com ([209.85.160.48]:39337 "EHLO
        mail-pl0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbeBTEol (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 23:44:41 -0500
Received: by mail-pl0-f48.google.com with SMTP id s13so6839244plq.6
        for <linux-media@vger.kernel.org>; Mon, 19 Feb 2018 20:44:41 -0800 (PST)
From: Alexandre Courbot <acourbot@chromium.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Gustavo Padovan <gustavo.padovan@collabora.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Subject: [RFCv4 00/21] Request API
Date: Tue, 20 Feb 2018 13:44:04 +0900
Message-Id: <20180220044425.169493-1-acourbot@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everyone,

And thanks for all the feedback on the previous version! I have tried to address as much as possible, which results in (another) almost rewrite. But I think the behavior and structure are converging to something satisfying and usable.

Besides the buffer queuing behavior that has been fixed, some of the big design changes undertaken are that the media controller framework is not a requirement anymore (although it can still be used in exactly the same way as before), and that ioctls related to requests are now performed directly on the request FD.

As discussed with Sakari, the fact that request entities were in fact media entities was a bit limiting, so I created a request_entity type that can be embedded into any structure we want to control with requests. This is what allows drivers to support requests without the media controller: simple V4L2 drivers can use the V4L2 implementation that allows to control a single video device (as opposed to the whole pipeline under a media controller). Media controllers can still, of course, use a more complex implementation and control their whole pipeline, but bringing that complexity to simple drivers seemed overreached to me.

Independently of the request implementation, request entities can store their own data, in a way that makes sense regarding their type (that would be v4l2_request_entity_data for V4L2 devices, but can be another data type for media controllers topology).

The entity data lookup is also performed on these request_entities, working effectively like the data store Sakari proposed, but retaining a base type for data lookup.

Patches are organized as follows:

Patch 1 provides the base request support, not tied to either media or v4l2.

Patches 2 to 8 are the control rework done by Hans, with an extra workaround for a bug discovered while working on vivid (see commit message for details).

Patch 9 adds request support to V4L2 in the form of entity data for v4l2 devices to be used in requests, and a request manager capable of producing simple requests for video devices. Maybe this should be split into different files, but since the code is not that big I have kept it under the same file.

Patches 10 to 13 add request support to vb2-core and vb2-v4l2.

Patches 14 and 15 add support for the request_fd field in G/S/TRY_EXT_CTRLS ioctls.

Patch 16 allows requests to be allocated from a supporting V4L2 video device node.

Patches 17 and 19 add request support to mem2mem and vim2m. Patch 18 documents usage of requests with V4L2 devices.

Patch 20 adds support to the vivid capture device.

Finally, 21 is a WIP patch implementing request support for media controller nodes. Requests allocated that way are of a different, broader nature than V4L2 requests, and will be able to control any device managed by the controller. To allow this, request_entity is embedded into media_entity, so that media entities can be upcasted as in the previous version.

Phew! That was quite long, sorry about that. As usual, simple programs demonstrating requests on vim2m and vivid are available:

https://gist.github.com/Gnurou/34c35f1f8e278dad454b51578d239a42
https://gist.github.com/Gnurou/5052e6ab41e7c55164b75d2970bc5a04

If things are starting to look ok, I would like to move on to the next step and implement support in v4l2-ctl. Maybe also start submitting an actual codec driver once the control work is completed. And of course, it may be good time to think about how pipeline configuration would work. The current design should make this question orthogonal to getting support in for simple V4L2 devices.

Looking forward to your feedback!

Changes since RFC v3:
* Buffer queuing is now performed as soon as the request is queued, allowing drivers to see them early.
* Request refcounting is done using the file * structure instead of a kref
* Requests can now be used independently of a media controller, to avoid having to pull it for simple codec drivers. For such drivers, the device node can allocate requests that are exclusive to this device only. Media controller nodes can still allocate requests that control their topology as well as the devices under them.
* Consequently, media_request is now its own module since it can be used independently of media.ko.
* SUBMIT/REINIT request ioctls are now performed on the request FD instead of the media device. This means that device/media controller node's business with requests is limited to allocating them.
* Got rid of request IDs.
* Only allow one buffer to be queued to each queue of request entities.
* The request FD that produced a CAPTURE buffer is not returned to user-space anymore.
* Added requests support for the Vivid video capture device.
* Let drivers decide individually whether their entities should be per file handle or global to the device, solving the question we had about this in previous RFCs. Vim2m provides an example of per-context entities, while vivid gives an example of a global request entity.
* Improved documentation.

Issues remaining with this version:
* Vivid support exposed what seems to be a limitation in the current controls cloning implementation. See patch 8 (which works the issue around) for details.
* Media controller implementation of requests is still incomplete. I plan to complete and exert it on an actual camera driver sometime soon.


Alexandre Courbot (14):
  media: add request API core and UAPI
  [WAR] v4l2-ctrls: do not clone non-standard controls
  v4l2: add request API support
  media: v4l2_fh: add request entity field
  media: videobuf2: add support for requests
  media: videobuf2-v4l2: support for requests
  videodev2.h: add request_fd field to v4l2_ext_controls
  v4l2-ctrls: support requests in EXT_CTRLS ioctls
  v4l2: video_device: support for creating requests
  media: mem2mem: support for requests
  Documentation: v4l: document request API
  media: vim2m: add request support
  media: vivid: add request support for the video capture device
  [WIP] media: media-device: support for creating requests

Hans Verkuil (7):
  v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
  v4l2-ctrls: prepare internal structs for request API
  v4l2-ctrls: add core request API
  v4l2-ctrls: use ref in helper instead of ctrl
  v4l2-ctrls: support g/s_ext_ctrls for requests
  v4l2-ctrls: add v4l2_ctrl_request_setup
  videodev2.h: Add request_fd field to v4l2_buffer

 Documentation/ioctl/ioctl-number.txt          |   1 +
 Documentation/media/uapi/v4l/buffer.rst       |   9 +-
 Documentation/media/uapi/v4l/common.rst       |   1 +
 Documentation/media/uapi/v4l/request-api.rst  | 199 ++++++++++
 Documentation/media/uapi/v4l/user-func.rst    |   1 +
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  16 +-
 .../media/uapi/v4l/vidioc-new-request.rst     |  64 ++++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst  |   7 +
 drivers/media/Kconfig                         |   3 +
 drivers/media/Makefile                        |   6 +
 .../media/common/videobuf2/videobuf2-core.c   |   3 +
 .../media/common/videobuf2/videobuf2-v4l2.c   | 131 ++++++-
 drivers/media/dvb-frontends/rtl2832_sdr.c     |   5 +-
 drivers/media/media-device.c                  |  11 +
 drivers/media/media-request.c                 | 341 +++++++++++++++++
 drivers/media/pci/bt8xx/bttv-driver.c         |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c       |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c       |   2 +-
 drivers/media/pci/cx88/cx88-video.c           |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c   |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c     |   2 +-
 drivers/media/platform/Kconfig                |   1 +
 .../media/platform/exynos4-is/fimc-capture.c  |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c    |   2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c   |   3 +-
 drivers/media/platform/rcar_drif.c            |   2 +-
 .../media/platform/soc_camera/soc_camera.c    |   3 +-
 drivers/media/platform/vim2m.c                |  75 ++++
 drivers/media/platform/vivid/Kconfig          |   1 +
 drivers/media/platform/vivid/vivid-core.c     |  63 +++-
 drivers/media/platform/vivid/vivid-core.h     |   3 +
 drivers/media/platform/vivid/vivid-ctrls.c    |  46 +--
 .../media/platform/vivid/vivid-kthread-cap.c  |  17 +
 drivers/media/usb/cpia2/cpia2_v4l.c           |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c       |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     |   4 +-
 drivers/media/usb/msi2500/msi2500.c           |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c       |   2 +-
 drivers/media/v4l2-core/Makefile              |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   9 +-
 drivers/media/v4l2-core/v4l2-ctrls.c          | 341 +++++++++++++++--
 drivers/media/v4l2-core/v4l2-dev.c            |   2 +
 drivers/media/v4l2-core/v4l2-device.c         |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  37 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |   3 +-
 drivers/media/v4l2-core/v4l2-request.c        | 178 +++++++++
 drivers/media/v4l2-core/v4l2-subdev.c         |   2 +-
 drivers/staging/media/imx/imx-media-dev.c     |   2 +-
 drivers/staging/media/imx/imx-media-fim.c     |   2 +-
 include/media/mc-request.h                    |  33 ++
 include/media/media-device.h                  |   1 +
 include/media/media-entity.h                  |   5 +
 include/media/media-request.h                 | 349 ++++++++++++++++++
 include/media/v4l2-ctrls.h                    |  20 +-
 include/media/v4l2-dev.h                      |   2 +
 include/media/v4l2-fh.h                       |   3 +
 include/media/v4l2-request.h                  | 159 ++++++++
 include/media/videobuf2-core.h                |   4 +
 include/media/videobuf2-v4l2.h                |  59 +++
 include/uapi/linux/media-request.h            |  37 ++
 include/uapi/linux/media.h                    |   2 +
 include/uapi/linux/videodev2.h                |   9 +-
 62 files changed, 2217 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 Documentation/media/uapi/v4l/vidioc-new-request.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 drivers/media/v4l2-core/v4l2-request.c
 create mode 100644 include/media/mc-request.h
 create mode 100644 include/media/media-request.h
 create mode 100644 include/media/v4l2-request.h
 create mode 100644 include/uapi/linux/media-request.h

-- 
2.16.1.291.g4437f3f132-goog
