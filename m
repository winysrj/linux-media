Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:49882 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751104AbdLDNCi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Dec 2017 08:02:38 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.16 v2] Various fixes all over the place
Message-ID: <a96578cc-7751-1c68-b752-a6ce841a7de0@xs4all.nl>
Date: Mon, 4 Dec 2017 14:02:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the same as the previous version of this pull request (see
https://patchwork.linuxtv.org/patch/45733/), except that the patch
"media: staging/imx: do not return error in link_notify for unknown sources"
from Steve Longerbeam has been dropped.

When going through newer imx patches I noticed that those supersede that
imx patch.

Regards,

	Hans

The following changes since commit 781b045baefdabf7e0bc9f33672ca830d3db9f27:

  media: imx274: Fix error handling, add MAINTAINERS entry (2017-11-30 04:45:12 -0500)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.16a

for you to fetch changes up to ebf1e3656a6455c79063539f59e7cd5d62ceb25e:

  media: exynos4-is: Use PTR_ERR_OR_ZERO() (2017-12-04 13:57:40 +0100)

----------------------------------------------------------------
Arnd Bergmann (5):
      pulse8-cec: print time using time64_t.
      vivid: print time in y2038-safe way
      solo6x10: use ktime_get_ts64() for time sync
      staging: imx: use ktime_t for timestamps
      vivid: use ktime_t for timestamp calculation

Dan Carpenter (1):
      cpia2: Fix a couple off by one bugs

Dean A (1):
      s2255drv: update firmware load.

Geert Uytterhoeven (1):
      media: i2c: adv748x: Restore full DT paths in kernel messages

Greg Kroah-Hartman (1):
      media: usbvision: remove unneeded DRIVER_LICENSE #define

Gustavo A. R. Silva (2):
      staging: media: imx: fix inconsistent IS_ERR and PTR_ERR
      davinci: vpif_capture: add NULL check on devm_kzalloc return value

Hans Verkuil (4):
      vimc: add test_pattern and h/vflip controls to the sensor
      cec: add the adap_monitor_pin_enable op
      cec-core.rst: document the new adap_monitor_pin_enable op
      cec: disable the hardware when unregistered

Jesse Chan (3):
      media: mtk-vcodec: add missing MODULE_LICENSE/DESCRIPTION
      soc_camera: soc_scale_crop: add missing MODULE_DESCRIPTION/AUTHOR/LICENSE
      media: tegra-cec: add missing MODULE_DESCRIPTION/AUTHOR/LICENSE

Loic Poulain (2):
      media: venus: venc: configure entropy mode
      media: venus: venc: Apply inloop deblocking filter

Martin Kepplinger (1):
      media: coda: remove definition of CODA_STD_MJPG

Stanimir Varbanov (1):
      venus: cleanup set_property controls

Vasyl Gomonovych (1):
      media: exynos4-is: Use PTR_ERR_OR_ZERO()

 Documentation/media/kapi/cec-core.rst               | 14 ++++++++++
 drivers/media/cec/cec-adap.c                        | 23 ++++++++++++++++
 drivers/media/cec/cec-api.c                         | 32 ++++++++++++++--------
 drivers/media/cec/cec-core.c                        | 15 ++++++----
 drivers/media/cec/cec-priv.h                        |  2 ++
 drivers/media/i2c/adv748x/adv748x-core.c            | 10 +++----
 drivers/media/pci/solo6x10/solo6x10-core.c          | 17 ++++++------
 drivers/media/platform/coda/coda_regs.h             |  1 -
 drivers/media/platform/davinci/vpif_capture.c       |  2 ++
 drivers/media/platform/exynos4-is/fimc-lite.c       |  5 +---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.c |  3 ++
 drivers/media/platform/qcom/venus/core.h            |  4 +--
 drivers/media/platform/qcom/venus/hfi_cmds.c        | 73 ++-----------------------------------------------
 drivers/media/platform/qcom/venus/hfi_helper.h      |  4 +--
 drivers/media/platform/qcom/venus/venc.c            | 33 ++++++++++++++++++++++
 drivers/media/platform/soc_camera/soc_scale_crop.c  |  4 +++
 drivers/media/platform/tegra-cec/tegra_cec.c        |  5 ++++
 drivers/media/platform/vimc/vimc-common.h           |  5 ++++
 drivers/media/platform/vimc/vimc-sensor.c           | 63 +++++++++++++++++++++++++++++++++++++++++-
 drivers/media/platform/vivid/vivid-core.c           |  2 +-
 drivers/media/platform/vivid/vivid-core.h           |  2 +-
 drivers/media/platform/vivid/vivid-radio-rx.c       | 11 ++++----
 drivers/media/platform/vivid/vivid-radio-tx.c       |  8 ++----
 drivers/media/platform/vivid/vivid-rds-gen.c        |  2 +-
 drivers/media/platform/vivid/vivid-rds-gen.h        |  1 +
 drivers/media/platform/vivid/vivid-vbi-gen.c        |  2 +-
 drivers/media/usb/cpia2/cpia2_v4l.c                 |  4 +--
 drivers/media/usb/pulse8-cec/pulse8-cec.c           |  4 +--
 drivers/media/usb/s2255/s2255drv.c                  | 13 ++++-----
 drivers/media/usb/usbvision/usbvision-video.c       |  3 +-
 drivers/staging/media/imx/imx-media-csi.c           | 10 ++-----
 drivers/staging/media/imx/imx-media-fim.c           | 30 +++++++++++---------
 drivers/staging/media/imx/imx-media.h               |  2 +-
 include/media/cec.h                                 | 13 +++++++++
 34 files changed, 260 insertions(+), 162 deletions(-)
