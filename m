Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:36460 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752936AbeC1Nuh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Mar 2018 09:50:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@google.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Gustavo Padovan <gustavo@padovan.org>
Subject: [RFCv9 PATCH 00/29] Request API
Date: Wed, 28 Mar 2018 15:50:01 +0200
Message-Id: <20180328135030.7116-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Hi all,

This patch series is an attempt to pick the best parts of
Alexandre's RFCv4:

https://lkml.org/lkml/2018/2/19/872

and Sakari's RFCv2:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg128170.html

and based on the RFCv2 of the Request public API proposal:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg128098.html

together with my own ideas.

I've no idea what version to give this series, so I just went with
v9 since that's the version of my internal git branch.

This has been tested with vim2m and vivid using v4l2-compliance.
The v4l-utils repo supporting requests is here:
https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request

The goal is to use request and request objects as implemented in
Sakari's RFCv2, together with the vb2 and control framework
support as implemented in Alexandre's RFCv4. In addition, I tried
hard to minimize the impact of requests to drivers.

TODO/Remarks:

1) missing prototype documentation in media-requests.c/h. Some
   is documented, but not everything.

2) improve the control handler implementation: currently this just
   clones the driver's control handler when a request object is
   created. And only standard controls can be contained in a request.
   I probably need another day of work to get this done properly by
   chaining control handlers as they are queued.

   The control patches are also a bit messy, so that needs to be
   cleaned up as well. I hope I can spend some time on this next
   week after Easter as this is the main TODO item. I expect I'll
   need 1-2 days of work to finished this.

   That said, the current implementation should be OK for stateless
   codecs.

3) No VIDIOC_REQUEST_ALLOC 'shortcut' ioctl. Sorry, I just ran out
   of time. Alexandre, Tomasz, feel free to add it back (it should
   be quite easy to do) and post a patch. I'll add it to my patch
   series. As mentioned before: whether or not we actually want this
   has not been decided yet.

4) vim2m: the media topology is a bit bogus, this needs to be fixed
   (i.e. a proper HW entity should be added). But for now it is
   good enough for testing.

5) I think this should slide in fairly easy after the fence support
   is merged. I made sure the request API changes in public headers
   did not clash with the changes made by the fence API.

6) I did not verify the Request API documentation patch. I did update
   it with the new buffer flags and 'which' value, but it probably is
   out of date in places.

7) More testing. I think I have fairly good coverage in v4l2-compliance,
   but no doubt I've missed a few test cases.

8) debugfs: it would be really useful to expose the number of request
   and request objects in debugfs to simplify debugging. Esp. to make
   sure everything is freed correctly.

9) Review copyright/authorship lines. I'm not sure if everything is
   correct. Alexandre, Sakari, if you see something that is not
   right in this respect, just let me know!

Everything seemed to slip nicely into place while working on this,
so I hope this is finally an implementation that we can proceed to
upstream and build upon for complex camera pipelines in the future.

This patch series is also available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv9

Regards,

	Hans

Alexandre Courbot (4):
  v4l2-ctrls: do not clone non-standard controls
  videodev2.h: add request_fd field to v4l2_ext_controls
  Documentation: v4l: document request API
  media: vim2m: add media device

Hans Verkuil (25):
  v4l2-device.h: always expose mdev
  uapi/linux/media.h: add request API
  media-request: allocate media requests
  media-request: core request support
  media-request: add request ioctls
  media-request: add media_request_find
  media-request: add media_request_object_find
  v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
  v4l2-ctrls: prepare internal structs for request API
  v4l2-ctrls: alloc memory for p_req
  v4l2-ctrls: use ref in helper instead of ctrl
  v4l2-ctrls: support g/s_ext_ctrls for requests
  v4l2-ctrls: add core request API
  v4l2-ctrls: integrate with requests
  videodev2.h: Add request_fd field to v4l2_buffer
  vb2: store userspace data in vb2_v4l2_buffer
  videobuf2-core: embed media_request_object
  videobuf2-core: integrate with media requests
  videobuf2-v4l2: integrate with media requests
  videobuf2-core: add vb2_core_request_has_buffers
  videobuf2-v4l2: add vb2_request_queue helper
  vim2m: use workqueue
  vim2m: support requests
  vivid: add mc
  vivid: add request support

 Documentation/media/uapi/v4l/buffer.rst            |  19 +-
 Documentation/media/uapi/v4l/common.rst            |   1 +
 Documentation/media/uapi/v4l/request-api.rst       | 199 ++++++++++
 Documentation/media/uapi/v4l/user-func.rst         |   1 +
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |  22 +-
 .../media/uapi/v4l/vidioc-new-request.rst          |  64 +++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |   8 +
 drivers/media/Makefile                             |   3 +-
 drivers/media/common/videobuf2/videobuf2-core.c    | 143 +++++--
 drivers/media/common/videobuf2/videobuf2-v4l2.c    | 440 +++++++++++++--------
 drivers/media/dvb-core/dvb_vb2.c                   |   5 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   5 +-
 drivers/media/media-device.c                       |  14 +
 drivers/media/media-request.c                      | 439 ++++++++++++++++++++
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
 drivers/media/platform/vivid/vivid-core.c          |  68 ++++
 drivers/media/platform/vivid/vivid-core.h          |   8 +
 drivers/media/platform/vivid/vivid-ctrls.c         |  46 +--
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
 drivers/media/v4l2-core/v4l2-ctrls.c               | 388 ++++++++++++++++--
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
 include/media/media-request.h                      | 204 ++++++++++
 include/media/v4l2-ctrls.h                         |  37 +-
 include/media/v4l2-device.h                        |   4 +-
 include/media/videobuf2-core.h                     |  25 +-
 include/media/videobuf2-v4l2.h                     |  17 +-
 include/uapi/linux/media.h                         |   8 +
 include/uapi/linux/videodev2.h                     |  14 +-
 66 files changed, 2131 insertions(+), 319 deletions(-)
 create mode 100644 Documentation/media/uapi/v4l/request-api.rst
 create mode 100644 Documentation/media/uapi/v4l/vidioc-new-request.rst
 create mode 100644 drivers/media/media-request.c
 create mode 100644 include/media/media-request.h

-- 
2.16.1
