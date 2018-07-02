Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56338 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933423AbeGBJfM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jul 2018 05:35:12 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.19] Various fixes
Message-ID: <c5bb5c97-9e6c-75b5-bfa3-c4507693d86e@xs4all.nl>
Date: Mon, 2 Jul 2018 11:35:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The usual 'various fixes'. A bunch of coda fixes, and I cherry-picked from
Ezequiel's https://www.spinics.net/lists/linux-media/msg136223.html patch
series.

Regards,

	Hans

The following changes since commit 3c4a737267e89aafa6308c6c456d2ebea3fcd085:

  media: ov5640: fix frame interval enumeration (2018-06-28 09:24:38 -0400)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.19f

for you to fetch changes up to bf40e3b08f4b7f5f49ffe28f94a2a505017df5c2:

  media: fsl-viu: fix error handling in viu_of_probe() (2018-07-02 10:56:01 +0200)

----------------------------------------------------------------
Alexey Khoroshilov (1):
      media: fsl-viu: fix error handling in viu_of_probe()

Ezequiel Garcia (8):
      sta2x11: Add video_device and vb2_queue locks
      mtk-mdp: Add locks for capture and output vb2_queues
      s5p-g2d: Implement wait_prepare and wait_finish
      staging: bcm2835-camera: Provide lock for vb2_queue
      davinci_vpfe: Add video_device and vb2_queue locks
      mx_emmaprp: Implement wait_prepare and wait_finish
      m2m-deinterlace: Implement wait_prepare and wait_finish
      stk1160: Set the vb2_queue lock before calling vb2_queue_init

Hans Verkuil (2):
      v4l2-ioctl.c: use correct vb2_queue lock for m2m devices
      vivid: fix gain when autogain is on

Philipp Zabel (8):
      media: coda: fix encoder source stride
      media: coda: add read-only h.264 decoder profile/level controls
      media: coda: fix reorder detection for unknown levels
      media: coda: clear hold flag on streamoff
      media: coda: jpeg: allow non-JPEG colorspace
      media: coda: jpeg: only queue two buffers into the bitstream for JPEG on CODA7541
      media: coda: jpeg: explicitly disable thumbnails in SEQ_INIT
      media: coda: mark CODA960 firmware version 2.1.9 as supported

Steve Longerbeam (1):
      media: v4l2-ctrls: Fix CID base conflict between MAX217X and IMX

 drivers/media/pci/sta2x11/sta2x11_vip.c                       |   6 +++
 drivers/media/platform/coda/coda-bit.c                        |  38 +++++--------
 drivers/media/platform/coda/coda-common.c                     | 118 +++++++++++++++++++++++++++++++++++++++--
 drivers/media/platform/coda/coda.h                            |   2 +
 drivers/media/platform/coda/coda_regs.h                       |   1 +
 drivers/media/platform/fsl-viu.c                              |  38 +++++++------
 drivers/media/platform/m2m-deinterlace.c                      |   4 ++
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c                  |  20 ++-----
 drivers/media/platform/mx2_emmaprp.c                          |   4 ++
 drivers/media/platform/s5p-g2d/g2d.c                          |   2 +
 drivers/media/platform/vivid/vivid-ctrls.c                    |   2 +-
 drivers/media/usb/stk1160/stk1160-v4l.c                       |   2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                          |  56 ++++++++++++++++++-
 drivers/staging/media/davinci_vpfe/vpfe_video.c               |   6 ++-
 drivers/staging/media/davinci_vpfe/vpfe_video.h               |   2 +-
 drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c |  24 ++-------
 include/uapi/linux/v4l2-controls.h                            |   2 +-
 17 files changed, 242 insertions(+), 85 deletions(-)
