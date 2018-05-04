Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53954 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751756AbeEDUHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 May 2018 16:07:39 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v9 00/15] V4L2 Explicit Synchronization
Date: Fri,  4 May 2018 17:05:57 -0300
Message-Id: <20180504200612.8763-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Gustavo has asked to me to take care of the final
issues with this series.

I'm working on adding some fences tests to v4l2-compliance,
which I'll be posting shortly.

So, here's a new version of the "video4linux meet fences"
series. This new round hopefully addresses all the feedback
received in v8.

There are some additional changes:

 * Removed the vb2_ops_is_unordered callback,
   and instead use a simpler unordered bitfield.
   After inspecting the code, I really saw no reason
   for having a callback. Please correct me if I missed
   anything.

 * Reworked the out-fence setup in vb2_core_qbuf,
   which results in getting rid of the sync_file
   state. After inspecting the code, it became apparent
   that the sync_file wasn't meant to be part of the
   buffer state. The resulting code is simpler.

 * Avoid returning fence file descriptors anywhere
   but in the QBUF result. Also, fixed the documentation
   to be clear about this.

Worth mentioning, I've decided to drop the is-signaled
flag suggested by Hans. It'll be easier to review and
merge if we keep this simple. We can always add stuff
later.

Gustavo Padovan (15):
  xilinx: regroup caps on querycap
  hackrf: group device capabilities
  omap3isp: group device capabilities
  vb2: move vb2_ops functions to videobuf2-core.[ch]
  vb2: add unordered vb2_queue property for drivers
  v4l: add unordered flag to format description ioctl
  v4l: mark unordered formats
  cobalt: set queue as unordered
  vb2: mark codec drivers as unordered
  vb2: add explicit fence user API
  vb2: add in-fence support to QBUF
  vb2: add out-fence support to QBUF
  v4l: introduce the fences capability
  v4l: Add V4L2_CAP_FENCES to drivers
  v4l: Document explicit synchronization behavior

 Documentation/media/uapi/v4l/buffer.rst            |  45 +++-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   7 +
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  54 +++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  12 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   3 +
 drivers/media/common/videobuf2/videobuf2-core.c    | 298 +++++++++++++++++++--
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |  66 +++--
 drivers/media/dvb-core/dvb_vb2.c                   |   2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   2 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   1 +
 drivers/media/platform/omap3isp/ispvideo.c         |  10 +-
 drivers/media/platform/qcom/venus/venc.c           |   2 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   2 +
 drivers/media/platform/xilinx/xilinx-dma.c         |  10 +-
 drivers/media/usb/hackrf/hackrf.c                  |  11 +-
 drivers/media/v4l2-core/Kconfig                    |  33 +++
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  63 +++--
 include/media/v4l2-fh.h                            |   2 -
 include/media/videobuf2-core.h                     |  49 +++-
 include/media/videobuf2-v4l2.h                     |  18 --
 include/uapi/linux/videodev2.h                     |  10 +-
 23 files changed, 590 insertions(+), 115 deletions(-)

-- 
2.16.3
