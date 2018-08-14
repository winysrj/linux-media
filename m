Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58300 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728315AbeHNWt6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 18:49:58 -0400
Date: Tue, 14 Aug 2018 17:01:07 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv18 00/35] Request API
Message-ID: <20180814170107.44d341a7@coco.lan>
In-Reply-To: <20180814142047.93856-1-hverkuil@xs4all.nl>
References: <20180814142047.93856-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 14 Aug 2018 16:20:12 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Hi all,
> 
> This is version 18 of the Request API series. The intention is that
> this will become a topic branch in preparation of merging this for
> 4.20 together with the cedrus staging driver.
> 
> I incorporated Mauro's review comments and a review comment from
> Ezequiel in v18.
> 
> The main change is that I reverted back to a simple int argument for the
> MEDIA_IOC_REQUEST_ALLOC ioctl. Mauro prefers it and I think he is right.
> It was what we had originally as well.
> 
> Besides all the review comments I also fixed a bug. See:
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg134311.html

I'll look on it right now.

> 
> And sparse warned me about a poll prototype change, so the
> media_request_poll() was slightly changed (use of EPOLL* instead of POLL*
> and a __poll_t return type).
> 
> I also split up the old patch 17/34 into three patches: the first just
> moves a function up in the source, the second replaces 'if' statements
> with a switch, and the third is the actual patch that does the real
> work. There is now much less noise in that patch and it should be much easier
> to review.
> 
> Finally the RFC debugfs patch has been dropped from this series.
> 
> This patch series is also available here:
> 
> https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv18
> 
> The patched v4l2-compliance (and rebased to the latest v4l-utils
> as well) is available here:
> 
> https://git.linuxtv.org/hverkuil/v4l-utils.git/log/?h=request
> 
> To avoid having to do a full review again I made a diff between
> v17 and v18 that is much easier to understand. I added it below
> the line (note that the removal of the debugfs patch is not included
> in this diff, it's not useful).

Patchset looks ok. Just not sure about a timestamp change at the
VB2 code. Found one or two nitpicks too. Once addressed, I guess
it is ready for being merged on a topic branch.

If nobody would require major changes, IMO the best would be
to just reply to a v19 patch to the few ones that might require
a respin.

> 
> Regards,
> 
> 	Hans
> 
> Alexandre Courbot (2):
>   Documentation: v4l: document request API
>   videodev2.h: add request_fd field to v4l2_ext_controls
> 
> Hans Verkuil (32):
>   uapi/linux/media.h: add request API
>   media-request: implement media requests
>   media-request: add media_request_get_by_fd
>   media-request: add media_request_object_find
>   v4l2-device.h: add v4l2_device_supports_requests() helper
>   v4l2-dev: lock req_queue_mutex
>   v4l2-ctrls: v4l2_ctrl_add_handler: add from_other_dev
>   v4l2-ctrls: prepare internal structs for request API
>   v4l2-ctrls: alloc memory for p_req
>   v4l2-ctrls: use ref in helper instead of ctrl
>   v4l2-ctrls: add core request support
>   v4l2-ctrls: support g/s_ext_ctrls for requests
>   v4l2-ctrls: add v4l2_ctrl_request_hdl_find/put/ctrl_find functions
>   videobuf2-v4l2: move __fill_v4l2_buffer() function
>   videobuf2-v4l2: replace if by switch in __fill_vb2_buffer()
>   vb2: store userspace data in vb2_v4l2_buffer
>   davinci_vpfe: remove bogus vb2->state check
>   vb2: drop VB2_BUF_STATE_PREPARED, use bool prepared/synced instead
>   videodev2.h: Add request_fd field to v4l2_buffer
>   vb2: add init_buffer buffer op
>   videobuf2-core: embed media_request_object
>   videobuf2-core: integrate with media requests
>   videobuf2-v4l2: integrate with media requests
>   videobuf2-core: add request helper functions
>   videobuf2-v4l2: add vb2_request_queue/validate helpers
>   videobuf2-core: add uses_requests/qbuf flags
>   videobuf2-v4l2: refuse qbuf if queue uses requests or vv.
>   v4l2-mem2mem: add vb2_m2m_request_queue
>   vim2m: use workqueue
>   vim2m: support requests
>   vivid: add mc
>   vivid: add request support
> 
> Sakari Ailus (1):
>   media: doc: Add media-request.h header to documentation build
> 
>  Documentation/media/kapi/mc-core.rst          |   2 +
>  .../media/uapi/mediactl/media-controller.rst  |   1 +
>  .../media/uapi/mediactl/media-funcs.rst       |   6 +
>  .../uapi/mediactl/media-ioc-request-alloc.rst |  65 +++
>  .../uapi/mediactl/media-request-ioc-queue.rst |  82 +++
>  .../mediactl/media-request-ioc-reinit.rst     |  51 ++
>  .../media/uapi/mediactl/request-api.rst       | 245 ++++++++
>  .../uapi/mediactl/request-func-close.rst      |  48 ++
>  .../uapi/mediactl/request-func-ioctl.rst      |  67 +++
>  .../media/uapi/mediactl/request-func-poll.rst |  77 +++
>  Documentation/media/uapi/v4l/buffer.rst       |  21 +-
>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  53 +-
>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  32 +-
>  .../media/videodev2.h.rst.exceptions          |   1 +
>  drivers/media/Makefile                        |   3 +-
>  .../media/common/videobuf2/videobuf2-core.c   | 262 +++++++--
>  .../media/common/videobuf2/videobuf2-v4l2.c   | 508 +++++++++++-----
>  drivers/media/dvb-core/dvb_vb2.c              |   5 +-
>  drivers/media/dvb-frontends/rtl2832_sdr.c     |   5 +-
>  drivers/media/media-device.c                  |  24 +-
>  drivers/media/media-request.c                 | 489 ++++++++++++++++
>  drivers/media/pci/bt8xx/bttv-driver.c         |   2 +-
>  drivers/media/pci/cx23885/cx23885-417.c       |   2 +-
>  drivers/media/pci/cx88/cx88-blackbird.c       |   2 +-
>  drivers/media/pci/cx88/cx88-video.c           |   2 +-
>  drivers/media/pci/saa7134/saa7134-empress.c   |   4 +-
>  drivers/media/pci/saa7134/saa7134-video.c     |   2 +-
>  .../media/platform/exynos4-is/fimc-capture.c  |   2 +-
>  drivers/media/platform/omap3isp/ispvideo.c    |   4 +-
>  drivers/media/platform/rcar-vin/rcar-core.c   |   2 +-
>  drivers/media/platform/rcar_drif.c            |   2 +-
>  .../media/platform/s3c-camif/camif-capture.c  |   4 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   4 +-
>  drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   4 +-
>  .../media/platform/soc_camera/soc_camera.c    |   7 +-
>  drivers/media/platform/vim2m.c                |  49 +-
>  drivers/media/platform/vivid/vivid-core.c     |  69 +++
>  drivers/media/platform/vivid/vivid-core.h     |   8 +
>  drivers/media/platform/vivid/vivid-ctrls.c    |  46 +-
>  .../media/platform/vivid/vivid-kthread-cap.c  |  12 +
>  .../media/platform/vivid/vivid-kthread-out.c  |  12 +
>  drivers/media/platform/vivid/vivid-sdr-cap.c  |  16 +
>  drivers/media/platform/vivid/vivid-vbi-cap.c  |  10 +
>  drivers/media/platform/vivid/vivid-vbi-out.c  |  10 +
>  drivers/media/platform/vivid/vivid-vid-cap.c  |  10 +
>  drivers/media/platform/vivid/vivid-vid-out.c  |  10 +
>  drivers/media/usb/cpia2/cpia2_v4l.c           |   2 +-
>  drivers/media/usb/cx231xx/cx231xx-417.c       |   2 +-
>  drivers/media/usb/cx231xx/cx231xx-video.c     |   4 +-
>  drivers/media/usb/msi2500/msi2500.c           |   2 +-
>  drivers/media/usb/tm6000/tm6000-video.c       |   2 +-
>  drivers/media/usb/uvc/uvc_queue.c             |   5 +-
>  drivers/media/usb/uvc/uvc_v4l2.c              |   3 +-
>  drivers/media/usb/uvc/uvcvideo.h              |   1 +
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  14 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 541 +++++++++++++++++-
>  drivers/media/v4l2-core/v4l2-dev.c            |  18 +-
>  drivers/media/v4l2-core/v4l2-device.c         |   3 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c          |  44 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c        |  67 ++-
>  drivers/media/v4l2-core/v4l2-subdev.c         |   9 +-
>  .../staging/media/davinci_vpfe/vpfe_video.c   |   7 +-
>  drivers/staging/media/imx/imx-media-dev.c     |   2 +-
>  drivers/staging/media/imx/imx-media-fim.c     |   2 +-
>  drivers/staging/media/omap4iss/iss_video.c    |   3 +-
>  drivers/usb/gadget/function/uvc_queue.c       |   2 +-
>  include/media/media-device.h                  |  29 +
>  include/media/media-request.h                 | 386 +++++++++++++
>  include/media/v4l2-ctrls.h                    | 123 +++-
>  include/media/v4l2-device.h                   |  11 +
>  include/media/v4l2-mem2mem.h                  |   4 +
>  include/media/videobuf2-core.h                |  62 +-
>  include/media/videobuf2-v4l2.h                |  20 +-
>  include/uapi/linux/media.h                    |   8 +
>  include/uapi/linux/videodev2.h                |  14 +-
>  75 files changed, 3369 insertions(+), 363 deletions(-)
>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-api.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-func-close.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-func-ioctl.rst
>  create mode 100644 Documentation/media/uapi/mediactl/request-func-poll.rst
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
> 



Thanks,
Mauro
