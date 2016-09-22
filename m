Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:37207
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbcIVJr6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 05:47:58 -0400
Date: Thu, 22 Sep 2016 06:47:52 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL for v4.7-rc8] media fixes
Message-ID: <20160922064752.5d05a0bd@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-7

For:

- several fixes for new drivers added for Kernel 4.8 addition
  (cec core, pulse8 cec driver and Mediatek vcodec);
- a regression fix for cx23885 and saa7134 drivers;
- an important fix for rcar-fcp, making rcar_fcp_enable()
  return 0 on success.

Thanks!
Mauro

---


The following changes since commit fa8410b355251fd30341662a40ac6b22d3e38468:

  Linux 4.8-rc3 (2016-08-21 16:14:10 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media tags/media/v4.8-7

for you to fetch changes up to d8feef9bd447381952a33e6284241006f394c080:

  [media] cx23885/saa7134: assign q->dev to the PCI device (2016-09-19 12:38:05 -0300)

----------------------------------------------------------------
media fixes for v4.8-rc8

----------------------------------------------------------------
Geert Uytterhoeven (1):
      [media] rcar-fcp: Make sure rcar_fcp_enable() returns 0 on success

Hans Verkuil (17):
      [media] cec: rename cec_devnode fhs_lock to just lock
      [media] cec: improve locking
      [media] cec-funcs.h: fix typo: && should be &
      [media] cec-funcs.h: add reply argument for Record On/Off
      [media] cec: improve dqevent documentation
      [media] cec: add CEC_LOG_ADDRS_FL_ALLOW_UNREG_FALLBACK flag
      [media] cec: set unclaimed addresses to CEC_LOG_ADDR_INVALID
      [media] cec: add item to TODO
      [media] cec: ignore messages when log_addr_mask == 0
      [media] mtk-vcodec: add HAS_DMA dependency
      [media] pulse8-cec: set correct Signal Free Time
      [media] pulse8-cec: fix error handling
      [media] cec-edid: check for IEEE identifier
      [media] cec-funcs.h: add missing vendor-specific messages
      [media] cec: don't Feature Abort broadcast msgs when unregistered
      [media] cec: fix ioctl return code when not registered
      [media] cx23885/saa7134: assign q->dev to the PCI device

Tiffany Lin (7):
      [media] vcodec:mediatek:code refine for v4l2 Encoder driver
      [media] vcodec:mediatek: Fix fops_vcodec_release flow for V4L2 Encoder
      [media] vcodec:mediatek: Fix visible_height larger than coded_height issue in s_fmt_out
      [media] vcodec:mediatek: Add timestamp and timecode copy for V4L2 Encoder
      [media] vcodec:mediatek: change H264 profile default to profile high
      [media] vcodec:mediatek: Refine H264 encoder driver
      [media] vcodec:mediatek: Refine VP8 encoder driver

 .../media/uapi/cec/cec-ioc-adap-g-log-addrs.rst    | 21 +++++-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst   |  8 ++-
 drivers/media/cec-edid.c                           |  5 +-
 drivers/media/pci/cx23885/cx23885-417.c            |  1 +
 drivers/media/pci/saa7134/saa7134-dvb.c            |  1 +
 drivers/media/pci/saa7134/saa7134-empress.c        |  1 +
 drivers/media/platform/Kconfig                     |  2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_drv.h |  1 -
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 42 +++++++-----
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |  6 +-
 .../media/platform/mtk-vcodec/mtk_vcodec_intr.h    |  1 -
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  | 16 ++---
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   | 16 ++---
 drivers/media/platform/rcar-fcp.c                  |  8 ++-
 drivers/staging/media/cec/TODO                     |  1 +
 drivers/staging/media/cec/cec-adap.c               | 26 +++++---
 drivers/staging/media/cec/cec-api.c                | 12 ++--
 drivers/staging/media/cec/cec-core.c               | 27 ++++----
 drivers/staging/media/pulse8-cec/pulse8-cec.c      | 10 +--
 include/linux/cec-funcs.h                          | 78 +++++++++++++++++++++-
 include/linux/cec.h                                |  5 +-
 include/media/cec.h                                |  2 +-
 22 files changed, 212 insertions(+), 78 deletions(-)

