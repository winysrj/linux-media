Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:39202 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387605AbeKWT3S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Nov 2018 14:29:18 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21 v2] mem2mem, venus and vb2 fixes/improvements
Message-ID: <76f3c0b7-63ee-50d0-d56c-fc403d4ba5e0@xs4all.nl>
Date: Fri, 23 Nov 2018 09:45:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Fixed my SoB mess)

The following changes since commit fbe57dde7126d1b2712ab5ea93fb9d15f89de708:

  media: ov7740: constify structures stored in fields of v4l2_subdev_ops structure (2018-11-06 07:17:02 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21e2

for you to fetch changes up to 67a4b0da269c44e3efb59ec471566d48268bd23d:

  videobuf2-v4l2: drop WARN_ON in vb2_warn_zero_bytesused() (2018-11-23 09:44:43 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Ezequiel Garcia (4):
      mem2mem: Require capture and output mutexes to match
      v4l2-ioctl.c: Simplify locking for m2m devices
      v4l2-mem2mem: Avoid calling .device_run in v4l2_m2m_job_finish
      media: cedrus: Get rid of interrupt bottom-half

Hans Verkuil (1):
      videobuf2-v4l2: drop WARN_ON in vb2_warn_zero_bytesused()

John Sheu (1):
      media: vb2: Allow reqbufs(0) with "in use" MMAP buffers

Sakari Ailus (1):
      v4l2-mem2mem: Simplify exiting the function in __v4l2_m2m_try_schedule

Stanimir Varbanov (1):
      venus: firmware: register separate platform_device for firmware loader

vgarodia@codeaurora.org (4):
      venus: firmware: add routine to reset ARM9
      venus: firmware: move load firmware in a separate function
      venus: firmware: add no TZ boot and shutdown routine
      dt-bindings: media: Document bindings for venus firmware device

 Documentation/devicetree/bindings/media/qcom,venus.txt |  14 ++-
 Documentation/media/uapi/v4l/vidioc-reqbufs.rst        |  17 +++-
 drivers/media/common/videobuf2/videobuf2-core.c        |   8 +-
 drivers/media/common/videobuf2/videobuf2-v4l2.c        |   3 +-
 drivers/media/platform/qcom/venus/core.c               |  24 +++--
 drivers/media/platform/qcom/venus/core.h               |   6 ++
 drivers/media/platform/qcom/venus/firmware.c           | 235 +++++++++++++++++++++++++++++++++++++++++++-----
 drivers/media/platform/qcom/venus/firmware.h           |  17 +++-
 drivers/media/platform/qcom/venus/hfi_venus.c          |  13 +--
 drivers/media/platform/qcom/venus/hfi_venus_io.h       |   8 ++
 drivers/media/v4l2-core/v4l2-ioctl.c                   |  47 +---------
 drivers/media/v4l2-core/v4l2-mem2mem.c                 |  66 +++++++++-----
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c         |  26 ++----
 include/uapi/linux/videodev2.h                         |   1 +
 14 files changed, 344 insertions(+), 141 deletions(-)
