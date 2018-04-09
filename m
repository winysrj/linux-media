Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:43303 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751270AbeDIOUc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 10:20:32 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [RFCv11 PATCH 00/29] Request API
Date: Mon,  9 Apr 2018 16:19:57 +0200
Message-Id: <20180409142026.19369-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

This is a cleaned up version of the v10 series (never posted to
the list since it was messy).

The main changes compared to v9 are in the control framework which
is (hopefully!) now in sync with the RFC. Specifically, when queueing
a request it will 'chain' itself correctly with the previously queued
request. Control values that were not explicitly set in the request
will get the value from the first request in the queue that sets it,
or the hardware value if no request in the queue ever touches it.

However, I have not yet had the opportunity to test this in
v4l2-compliance!

Sakari: I did not have the time to incorporate your comments. I'll
probably wait until I have more feedback and then post a new series
next week.

Other changes:

- various request state checks were missing (i.e. you could set
  a control in a queued request).

- a new cancel op was added to handle the corner case where a
  request was queued but never reached the driver since STREAMOFF
  was called before the buffers were ever queued in the driver.

- various random fixes.

- added the patch "videobuf2-v4l2: export request_fd" as requested
  by Sakari.

- changed some inconsistent error codes.

This has been tested with vim2m and vivid using v4l2-compliance.
The v4l-utils repo supporting requests is here:
https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request

TODO/Remarks:

1) missing prototype documentation in media-requests.c/h. Some
   is documented, but not everything.

2) No VIDIOC_REQUEST_ALLOC 'shortcut' ioctl. Sorry, I just ran out
   of time. Alexandre, Tomasz, feel free to add it back (it should
   be quite easy to do) and post a patch. I'll add it to my patch
   series. As mentioned before: whether or not we actually want this
   has not been decided yet.

3) vim2m: the media topology is a bit bogus, this needs to be fixed
   (i.e. a proper HW entity should be added). But for now it is
   good enough for testing.

4) I think this should slide in fairly easy after the fence support
   is merged. I made sure the request API changes in public headers
   did not clash with the changes made by the fence API.

5) I did not verify the Request API documentation patch. I did update
   it with the new buffer flags and 'which' value, but it probably is
   out of date in places.

6) More testing. I think I have fairly good coverage in v4l2-compliance,
   but no doubt I've missed a few test cases.

7) debugfs: it would be really useful to expose the number of request
   and request objects in debugfs to simplify debugging. Esp. to make
   sure everything is freed correctly.

8) Review copyright/authorship lines. I'm not sure if everything is
   correct. Alexandre, Sakari, if you see something that is not
   right in this respect, just let me know!

9) The req_queue op should likely be split into a req_validate and
   a req_queue op (based on a discussion on the ML with Sakari).
   That avoids a race condition.

Everything seemed to slip nicely into place while working on this,
so I hope this is finally an implementation that we can proceed to
upstream and build upon for complex camera pipelines in the future.

This patch series is also available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv11

Regards,

	Hans


Alexandre Courbot (3):
  videodev2.h: add request_fd field to v4l2_ext_controls
  Documentation: v4l: document request API
  media: vim2m: add media device

Hans Verkuil (26):
  v4l2-device.h: always expose mdev
  uapi/linux/media.h: add request API
  media-request: allocate media requests
  media-request: core request support
  media-request: add request ioctls
  media-request: add media_request_find
  media-request: add media_request_object_find
  videodev2.h: add V4L2_CTRL_FLAG_IN_REQUEST
  v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
  v4l2-ctrls: prepare internal structs for request API
  v4l2-ctrls: alloc memory for p_req
  v4l2-ctrls: use ref in helper instead of ctrl
  v4l2-ctrls: add core request support
  v4l2-ctrls: support g/s_ext_ctrls for requests
  videodev2.h: Add request_fd field to v4l2_buffer
  vb2: store userspace data in vb2_v4l2_buffer
  videobuf2-core: embed media_request_object
  videobuf2-core: integrate with media requests
  videobuf2-v4l2: integrate with media requests
  videobuf2-core: add vb2_core_request_has_buffers
  videobuf2-v4l2: add vb2_request_queue helper
  videobuf2-v4l2: export request_fd
  vim2m: use workqueue
  vim2m: support requests
  vivid: add mc
  vivid: add request support

 Documentation/media/uapi/v4l/buffer.rst            |  19 +-
 Documentation/media/uapi/v4l/common.rst            |   1 +
 Documentation/media/uapi/v4l/request-api.rst       | 199 +++++++++
 Documentation/media/uapi/v4l/user-func.rst         |   1 +
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  22 +-
 .../media/uapi/v4l/vidioc-new-request.rst          |  64 +++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |   8 +
 drivers/media/Makefile                             |   3 +-
 drivers/media/common/videobuf2/videobuf2-core.c    | 152 +++++--
 drivers/media/common/videobuf2/videobuf2-v4l2.c    | 449 ++++++++++++-------
 drivers/media/dvb-core/dvb_vb2.c                   |   5 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   5 +-
 drivers/media/media-device.c                       |  14 +
 drivers/media/media-request.c                      | 454 +++++++++++++++++++
 drivers/media/pci/bt8xx/bttv-driver.c              |   2 +-
 drivers/media/pci/cx23885/cx23885-417.c            |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   2 +-
 drivers/media/pci/cx88/cx88-video.c                |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |   4 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c   |   2 +-
 drivers/media/platform/omap3isp/ispvideo.c         |   4 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   3 +-
 drivers/media/platform/rcar_drif.c                 |   2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   4 +-
 drivers/media/platform/soc_camera/soc_camera.c     |   7 +-
 drivers/media/platform/vim2m.c                     |  83 +++-
 drivers/media/platform/vivid/vivid-core.c          |  68 +++
 drivers/media/platform/vivid/vivid-core.h          |   8 +
 drivers/media/platform/vivid/vivid-ctrls.c         |  46 +-
 drivers/media/platform/vivid/vivid-kthread-cap.c   |  12 +
 drivers/media/platform/vivid/vivid-kthread-out.c   |  12 +
 drivers/media/platform/vivid/vivid-sdr-cap.c       |   8 +
 drivers/media/platform/vivid/vivid-vbi-cap.c       |   2 +
 drivers/media/platform/vivid/vivid-vbi-out.c       |   2 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |   2 +
 drivers/media/platform/vivid/vivid-vid-out.c       |   2 +
 drivers/media/usb/cpia2/cpia2_v4l.c                |   2 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/msi2500/msi2500.c                |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   2 +-
 drivers/media/usb/uvc/uvc_queue.c                  |   5 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   3 +-
 drivers/media/usb/uvc/uvcvideo.h                   |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  14 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               | 480 +++++++++++++++++++--
 drivers/media/v4l2-core/v4l2-device.c              |   3 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  22 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c             |   7 +-
 drivers/media/v4l2-core/v4l2-subdev.c              |   9 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |   3 +-
 drivers/staging/media/imx/imx-media-dev.c          |   2 +-
 drivers/staging/media/imx/imx-media-fim.c          |   2 +-
 drivers/staging/media/omap4iss/iss_video.c         |   3 +-
 drivers/usb/gadget/function/uvc_queue.c            |   2 +-
 include/media/media-device.h                       |  13 +
 include/media/media-request.h                      | 213 +++++++++
 include/media/v4l2-ctrls.h                         |  45 +-
 include/media/v4l2-device.h                        |   4 +-
 include/media/videobuf2-core.h                     |  25 +-
 include/media/videobuf2-v4l2.h                     |  19 +-
 include/uapi/linux/media.h                         |   8 +
 include/uapi/linux/videodev2.h                     |  15 +-
 66 files changed, 2277 insertions(+), 318 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 Documentation/media/uapi/v4l/vidioc-new-request.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.16.3
