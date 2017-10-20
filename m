Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:45151 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752576AbdJTVuV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 17:50:21 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC v4 00/17] V4L2 Explicit Synchronization support
Date: Fri, 20 Oct 2017 19:49:55 -0200
Message-Id: <20171020215012.20646-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

Hi,

I renamed this back to RFC as many things are still under
discussion/open but it integrates all comments received on the
previous round[1].

My main goal now is to fit as many use cases as possible into this
Explicit Synchronization implementation, but first I'd like to recap
some detail of the implementation, as some pieces changed since the last
patchset, that means the explanation on previous cover letters aren't
entirely valid anymore.

Explicit Synchronization allows us to control the synchronization of
shared buffers from userspace by passing fences to the kernel and/or
receiving them from it. Fences passed to the kernel are named in-fences
and the kernel should wait them to signal before using the buffer, i.e.,
queueing it to the driver. On the other side, the kernel can create
out-fences for the buffers it queues to the drivers, out-fences signal
when the driver is finished with buffer, that is, the buffer is ready.

Before we talk about more details, lets differentiate ordering concepts,
there is two orthogonal places in the pipeline where buffers may or may
not be ordered. Inside the drivers and inside vb2 core:

* Ordering in the driver: In this RFC to use out-fences v4l2 drivers
  need to guarantee ordering of the buffers inside the driver, that is,
  buffers should become done (think calling vb2_buffer_done() here) in
  the same order they are queued to the driver. Drivers should set
  q->ordered_in_driver to 1 if they can keep ordering. (See patch 08/17)

* Ordering in vb2: Some queues (OUTPUT queues and some m2m devices)
  requires that the order we queue buffers to the driver do not change
  in relation to the order they were queued from userspace. So that is
  marked in the code by q->is_output or q->ordered_in_vb2 and this
  implementation can work with both ordered and not-ordered queues at the
  vb2 level. (See patch 09/17)

The in-fences are communicated at the VIDIOC_QBUF ioctl using the
V4L2_BUF_FLAG_IN_FENCE buffer flag and the fence_fd field. If an
in-fence needs to be passed to the kernel, fence_fd should be set to the
fence file descriptor number and the V4L2_BUF_FLAG_IN_FENCE should be
set as well. If ordered in vb2 needs to be kept we use fence arrays (see
patch 12 and 13)

Out-fence for a given buffer is enabled if the V4L2_BUF_FLAG_OUT_FENCE
flag is passed in the QBUF() call and then communicated to userspace via
the newly created V4L2_EVENT_OUT_FENCE event. The event is queued for
userspace pick up when the buffer is queued to the driver, or if the
queue is ordered both in the driver and vb2 we send the event right
away. (see patch 14 to 16)

Use cases
---------

I believe use cases like camera app preview, photoshoot, video record,
m2m color converters and scalers (with ordered queues) and output
devices are covered by this RFC, but others like synchronized
Audio/Video transmission doesn't seem to benefit too much from fences.
Talking to Nicolas he expressed that fences are not really useful for
such cases because we still need to sync with the Audio side, so may
be we need wait at least for a start of streaming signal or something
like that.  For m2m encoders, we would be in a similar situation
needing to know bytesused beforehand. I want to hear what others think
here.

WIP on V4L2 event
-----------------

As the V4L2 event part is not the crucial part here, the current
changes there to allow install the fence_fd at DQ_EVENT() are to
be considered PoC. Suggestions are welcome. (See patch 4)

Main Changes on v4
-------------------

* Keep ordering in vb2 of buffers queued from userspace with
  in-fence attached. This is necessary for OUTPUT and some m2m
  queues.

* V4L2_EVENT_BUF_QUEUED event was renamed to
  V4L2_EVENT_OUT_FENCE and is only sent when an out-fence
  exists.

* For queues that are both ordered in vb2 and in driver the
  OUT_FENCE event is sent out immediately without waiting for
  the buffer to be queued on the driver

* The out-fence FD is only installed at DQ_EVENT(), but this
  implementation needs improvement. See 'Open Questions'

* Refactor slightly event subscription for v4l2 driver, now
  there is a v4l2_event_subscribe_v4l2() that will subscribe for
  event that all devices need.

* Protect dma_fence_remove_callback() with the fence lock.

Only the most important changes are detailed here, for a full
list of them, see each individual patch.

Open Questions
--------------

* synchronized Audio/Video transmission and m2m encoders use
  cases discussed above

* V4L2 event: Improve solution to install the fd and figure how
  to clean up a event if userspace don't pick it up.

Test tool
---------

Test tool I've been using can be found at:
https://git.collabora.com/cgit/user/padovan/v4l2-test.git/

Regards,

Gustavo

--
[1] https://lkml.org/lkml/2017/9/7/489

Gustavo Padovan (16):
  [media] v4l: create v4l2_event_subscribe_v4l2()
  [media] v4l: use v4l2_subscribe_event_v4l2() on vtables
  [media] v4l: use v4l2_subscribe_event_v4l2() on drivers
  WIP: [media] v4l2: add v4l2_event_queue_fh_with_cb()
  [media] v4l: add V4L2_EVENT_OUT_FENCE event
  [media] vb2: add .send_out_fence() to notify userspace of out_fence_fd
  [media] vivid: assign the specific device to the vb2_queue->dev
  [media] vb2: add 'ordered_in_driver' property to queues
  [media] vb2: add 'ordered_in_vb2' property to queues
  [media] vivid: mark vivid queues as ordered_in_driver
  [media] vb2: check earlier if stream can be started
  [media] vb2: add explicit fence user API
  [media] vb2: add in-fence support to QBUF
  [media] vb2: add infrastructure to support out-fences
  [media] vb2: add out-fence support to QBUF
  [media] v4l: Document explicit synchronization behaviour

Javier Martinez Canillas (1):
  [media] vb2: add videobuf2 dma-buf fence helpers

 Documentation/media/uapi/v4l/buffer.rst            |  15 ++
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |  23 ++
 Documentation/media/uapi/v4l/vidioc-qbuf.rst       |  31 +++
 Documentation/media/videodev2.h.rst.exceptions     |   1 +
 drivers/media/common/saa7146/saa7146_video.c       |   4 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c          |   2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              |   4 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c             |   2 +-
 drivers/media/pci/cx18/cx18-ioctl.c                |   2 +-
 drivers/media/pci/cx23885/cx23885-video.c          |   2 +-
 drivers/media/pci/cx25821/cx25821-video.c          |   2 +-
 drivers/media/pci/cx88/cx88-blackbird.c            |   2 +-
 drivers/media/pci/cx88/cx88-video.c                |   4 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c                |   2 +-
 drivers/media/pci/meye/meye.c                      |   2 +-
 drivers/media/pci/saa7134/saa7134-empress.c        |   2 +-
 drivers/media/pci/saa7134/saa7134-video.c          |   4 +-
 drivers/media/pci/saa7164/saa7164-encoder.c        |   2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2.c         |   2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |   2 +-
 drivers/media/pci/tw5864/tw5864-video.c            |   2 +-
 drivers/media/pci/tw68/tw68-video.c                |   2 +-
 drivers/media/pci/tw686x/tw686x-video.c            |   2 +-
 drivers/media/pci/zoran/zoran_driver.c             |   2 +-
 drivers/media/platform/am437x/am437x-vpfe.c        |   2 +-
 drivers/media/platform/atmel/atmel-isc.c           |   2 +-
 drivers/media/platform/atmel/atmel-isi.c           |   2 +-
 drivers/media/platform/coda/coda-common.c          |   2 +-
 drivers/media/platform/fsl-viu.c                   |   2 +-
 drivers/media/platform/marvell-ccic/mcam-core.c    |   2 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       |   2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |   2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   2 +-
 drivers/media/platform/pxa_camera.c                |   2 +-
 drivers/media/platform/qcom/venus/vdec.c           |   4 +-
 drivers/media/platform/qcom/venus/venc.c           |   2 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c        |   2 +-
 drivers/media/platform/rcar_drif.c                 |   2 +-
 drivers/media/platform/rcar_fdp1.c                 |   2 +-
 drivers/media/platform/rcar_jpu.c                  |   2 +-
 drivers/media/platform/s3c-camif/camif-capture.c   |   2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      |   2 +-
 drivers/media/platform/sti/hva/hva-v4l2.c          |   2 +-
 drivers/media/platform/stm32/stm32-dcmi.c          |   2 +-
 drivers/media/platform/ti-vpe/cal.c                |   2 +-
 drivers/media/platform/ti-vpe/vpe.c                |   2 +-
 drivers/media/platform/vim2m.c                     |   2 +-
 drivers/media/platform/vivid/vivid-core.c          |  15 +-
 drivers/media/platform/vivid/vivid-vid-out.c       |   2 +-
 drivers/media/radio/dsbr100.c                      |   2 +-
 drivers/media/radio/radio-cadet.c                  |   2 +-
 drivers/media/radio/radio-isa.c                    |   2 +-
 drivers/media/radio/radio-keene.c                  |   2 +-
 drivers/media/radio/radio-ma901.c                  |   2 +-
 drivers/media/radio/radio-miropcm20.c              |   2 +-
 drivers/media/radio/radio-mr800.c                  |   2 +-
 drivers/media/radio/radio-sf16fmi.c                |   2 +-
 drivers/media/radio/radio-si476x.c                 |   2 +-
 drivers/media/radio/radio-tea5764.c                |   2 +-
 drivers/media/radio/radio-tea5777.c                |   2 +-
 drivers/media/radio/radio-timb.c                   |   2 +-
 drivers/media/radio/si470x/radio-si470x-common.c   |   2 +-
 drivers/media/radio/si4713/radio-platform-si4713.c |   2 +-
 drivers/media/radio/si4713/radio-usb-si4713.c      |   2 +-
 drivers/media/radio/tea575x.c                      |   2 +-
 drivers/media/usb/airspy/airspy.c                  |   2 +-
 drivers/media/usb/au0828/au0828-video.c            |   2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                |   4 +-
 drivers/media/usb/cx231xx/cx231xx-417.c            |   2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c          |   4 +-
 drivers/media/usb/em28xx/em28xx-video.c            |   4 +-
 drivers/media/usb/go7007/go7007-v4l2.c             |   2 +-
 drivers/media/usb/gspca/gspca.c                    |   2 +-
 drivers/media/usb/hackrf/hackrf.c                  |   2 +-
 drivers/media/usb/hdpvr/hdpvr-video.c              |   2 +-
 drivers/media/usb/msi2500/msi2500.c                |   2 +-
 drivers/media/usb/pwc/pwc-v4l.c                    |   2 +-
 drivers/media/usb/s2255/s2255drv.c                 |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c            |   2 +-
 drivers/media/usb/stkwebcam/stk-webcam.c           |   2 +-
 drivers/media/usb/tm6000/tm6000-video.c            |   4 +-
 drivers/media/usb/usbvision/usbvision-video.c      |   4 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |   2 +-
 drivers/media/usb/zr364xx/zr364xx.c                |   2 +-
 drivers/media/v4l2-core/Kconfig                    |   1 +
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |   4 +-
 drivers/media/v4l2-core/v4l2-event.c               |  45 +++-
 drivers/media/v4l2-core/videobuf2-core.c           | 239 +++++++++++++++++++--
 drivers/media/v4l2-core/videobuf2-v4l2.c           |  84 +++++++-
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  |   2 +-
 include/media/v4l2-event.h                         |  15 ++
 include/media/videobuf2-core.h                     |  49 ++++-
 include/media/videobuf2-fence.h                    |  48 +++++
 include/uapi/linux/videodev2.h                     |  16 +-
 samples/v4l/v4l2-pci-skeleton.c                    |   2 +-
 95 files changed, 643 insertions(+), 125 deletions(-)
 create mode 100644 include/media/videobuf2-fence.h

-- 
2.13.6
