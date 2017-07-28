Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:48210 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751071AbdG1Lnx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 07:43:53 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Various fixes
Message-ID: <ff97d2b4-bb23-17e7-de28-1c9c4f0df345@xs4all.nl>
Date: Fri, 28 Jul 2017 13:43:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit da48c948c263c9d87dfc64566b3373a858cc8aa2:

  media: fix warning on v4l2_subdev_call() result interpreted as bool (2017-07-26 13:43:17 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14c

for you to fetch changes up to 82fb31aa8e0dc11da47bc774dddafc14ac801e2c:

  cec: documentation fixes (2017-07-28 13:25:27 +0200)

----------------------------------------------------------------
Arnd Bergmann (5):
      v4l: omap_vout: vrfb: include linux/slab.h
      imx: add VIDEO_V4L2_SUBDEV_API dependency
      media: i2c: add KConfig dependencies
      media: v4l: use WARN_ON(1) instead of __WARN()
      media: v4l: omap_vout: vrfb: initialize DMA flags

Fabio Estevam (2):
      ov7670: Return the real error code
      ov7670: Check the return value from clk_prepare_enable()

Hans Verkuil (1):
      cec: documentation fixes

Hugues Fruchet (2):
      ov9650: fix coding style
      ov9655: fix missing mutex_destroy()

JB Van Puyvelde (1):
      staging: imx: fix non-static declarations

Kuninori Morimoto (1):
      media: ti-vpe: cal: use of_graph_get_remote_endpoint()

Philipp Zabel (1):
      stm32-dcmi: explicitly request exclusive reset control

Steve Longerbeam (1):
      media: imx: prpencvf: enable double write reduction

Tiffany Lin (1):
      mtk-vcodec: fix vp9 decode error

 Documentation/media/uapi/cec/cec-func-close.rst      |  2 +-
 Documentation/media/uapi/cec/cec-func-ioctl.rst      |  2 +-
 Documentation/media/uapi/cec/cec-func-open.rst       |  4 +--
 Documentation/media/uapi/cec/cec-func-poll.rst       |  8 +++---
 Documentation/media/uapi/cec/cec-ioc-adap-g-caps.rst |  2 +-
 Documentation/media/uapi/cec/cec-ioc-dqevent.rst     |  2 +-
 drivers/media/i2c/Kconfig                            |  3 ++-
 drivers/media/i2c/ov7670.c                           |  6 +++--
 drivers/media/i2c/ov9650.c                           | 67 ++++++++++++++++++++++++++++--------------------
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c | 37 ++++++++++++++++++++++++--
 drivers/media/platform/omap/omap_vout_vrfb.c         |  3 ++-
 drivers/media/platform/pxa_camera.c                  |  2 +-
 drivers/media/platform/soc_camera/soc_mediabus.c     |  2 +-
 drivers/media/platform/stm32/stm32-dcmi.c            |  2 +-
 drivers/media/platform/ti-vpe/cal.c                  |  2 +-
 drivers/staging/media/atomisp/i2c/imx/imx.c          | 24 ++++++++---------
 drivers/staging/media/imx/Kconfig                    |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c          | 11 ++++++++
 18 files changed, 120 insertions(+), 60 deletions(-)
