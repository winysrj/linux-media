Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44268 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753065AbeEURBa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:01:30 -0400
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
Subject: [PATCH v10 00/16] V4L2 Explicit Synchronization
Date: Mon, 21 May 2018 13:59:30 -0300
Message-Id: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

The most relevant change for this round is that all the work
done in the fence callback is now moved to a workqueue,
that runs with the queue lock held.
 
Although this introduces some latency, it is however needed
to take the vb2_queue mutex and safely call vb2 ops.

Given the fence callback can be called fully asynchronously,
and given it needs to be associated with a vb2_buffer,
we now need to refcount vb2_buffer. This allows to safely "attach"
the vb2_buffer to the fence callback.

To prevent annoying deadlocks, and because the fence callback
is called with the fence spinlock, it's best to avoid calling
dma_fence_put in the fence callback itself. So the fence is now
put in the DQBUF operation (or in cancel paths).

Hopefully, I took care of all the feedback provided by
Hans and Brian on v9. Please let me know if you guys catch
anything else.

Thanks!

Changes from v9:

 * Move fence callback to workqueue, and call vb2_start_streaming if needed.
 * Refcount vb2_buffer.
 * Check return of get_unused_fd.
 * Increase seqno for out-fences that reuse the context.
 * Go back to is_unordered callback.
 * Mark unordered formats in cobalt driver.
 * Improve CAP_FENCES check.
 * Minor documentation changes.

Ezequiel Garcia (1):
  videobuf2: Make struct vb2_buffer refcounted

Gustavo Padovan (15):
  xilinx: regroup caps on querycap
  hackrf: group device capabilities
  omap3isp: group device capabilities
  vb2: move vb2_ops functions to videobuf2-core.[ch]
  vb2: add is_unordered callback for drivers
  v4l: add unordered flag to format description ioctl
  v4l: mark unordered formats
  cobalt: add .is_unordered() for cobalt
  vb2: mark codec drivers as unordered
  vb2: add explicit fence user API
  vb2: add in-fence support to QBUF
  vb2: add out-fence support to QBUF
  v4l: introduce the fences capability
  v4l: Add V4L2_CAP_FENCES to drivers
  v4l: Document explicit synchronization behavior

 Documentation/media/uapi/v4l/buffer.rst            |  48 ++-
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst   |   7 +
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  53 ++-
 Documentation/media/uapi/v4l/vidioc-querybuf.rst   |  12 +-
 Documentation/media/uapi/v4l/vidioc-querycap.rst   |   3 +
 drivers/media/common/videobuf2/Kconfig             |   1 +
 drivers/media/common/videobuf2/videobuf2-core.c    | 376 ++++++++++++++++++---
 drivers/media/common/videobuf2/videobuf2-v4l2.c    |  65 +++-
 drivers/media/dvb-core/dvb_vb2.c                   |   2 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   4 +
 drivers/media/platform/coda/coda-common.c          |   1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c        |   3 +-
 drivers/media/platform/m2m-deinterlace.c           |   3 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   3 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   1 +
 .../media/platform/mtk-vcodec/mtk_vcodec_dec_drv.c |   2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   1 +
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |   3 +-
 drivers/media/platform/mx2_emmaprp.c               |   3 +-
 drivers/media/platform/omap3isp/ispvideo.c         |  10 +-
 drivers/media/platform/qcom/venus/vdec.c           |   4 +-
 drivers/media/platform/qcom/venus/venc.c           |   4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   1 +
 drivers/media/platform/sh_veu.c                    |   3 +-
 drivers/media/platform/xilinx/xilinx-dma.c         |  10 +-
 drivers/media/usb/hackrf/hackrf.c                  |  11 +-
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/media/v4l2-core/v4l2-ioctl.c               |  98 +++++-
 include/media/videobuf2-core.h                     |  76 ++++-
 include/media/videobuf2-v4l2.h                     |  18 -
 include/uapi/linux/videodev2.h                     |  10 +-
 32 files changed, 708 insertions(+), 133 deletions(-)

-- 
2.16.3
