Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:53657 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbeK2UqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 15:46:13 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.21] Various fixes/enhancements
Message-ID: <ecf764bb-52c1-3c34-f7a7-029d6ac6a945@xs4all.nl>
Date: Thu, 29 Nov 2018 10:41:23 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 708d75fe1c7c6e9abc5381b6fcc32b49830383d0:

  media: dvb-pll: don't re-validate tuner frequencies (2018-11-23 12:27:18 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git tags/br-v4.21g

for you to fetch changes up to e5b4ae2f474785d61653e8fcb762427ee537e156:

  vicodec: move the GREY format to the end of the list (2018-11-29 10:09:18 +0100)

----------------------------------------------------------------
Tag branch

----------------------------------------------------------------
Alexey Khoroshilov (1):
      DaVinci-VPBE: fix error handling in vpbe_initialize()

Arnd Bergmann (1):
      media: i2c: TDA1997x: select CONFIG_HDMI

Colin Ian King (4):
      exynos4-is: fix spelling mistake ACTURATOR -> ACTUATOR
      media: dib0700: fix spelling mistake "Amplifyer" -> "Amplifier"
      media: em28xx: fix spelling mistake, "Cinnergy" -> "Cinergy"
      tda7432: fix spelling mistake "maximium" -> "maximum"

Hans Verkuil (3):
      vivid: fix smatch warnings
      vivid: add req_validate error injection
      vicodec: move the GREY format to the end of the list

Jasmin Jessich (1):
      media: adv7604 added include of linux/interrupt.h

Jonas Karlman (1):
      media: v4l: Fix MPEG-2 slice Intra DC Precision validation

Michael Tretter (2):
      v4l2-pci-skeleton: replace vb2_buffer with vb2_v4l2_buffer
      v4l2-pci-skeleton: depend on CONFIG_SAMPLES

Sakari Ailus (1):
      v4l: ioctl: Allow drivers to fill in the format description

Tim Harvey (1):
      media: adv7180: add g_skip_frames support

Todor Tomov (1):
      media: camss: Take in account sensor skip frames

Tomasz Figa (1):
      media: mtk-vcodec: Remove VA from encoder frame buffers

 Documentation/media/v4l-drivers/em28xx-cardlist.rst |  2 +-
 drivers/media/i2c/Kconfig                           |  1 +
 drivers/media/i2c/adv7180.c                         | 15 +++++++++++++++
 drivers/media/i2c/adv7604.c                         |  1 +
 drivers/media/i2c/tda7432.c                         |  4 ++--
 drivers/media/platform/davinci/vpbe.c               |  7 +++++--
 drivers/media/platform/exynos4-is/fimc-is-errno.c   |  4 ++--
 drivers/media/platform/exynos4-is/fimc-is-errno.h   |  2 +-
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c  |  6 +-----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_util.h |  5 +++++
 drivers/media/platform/mtk-vcodec/venc_drv_if.h     |  2 +-
 drivers/media/platform/qcom/camss/camss-vfe.c       | 23 ++++++++++++++++++-----
 drivers/media/platform/qcom/camss/camss.c           |  2 +-
 drivers/media/platform/qcom/camss/camss.h           |  1 +
 drivers/media/platform/vicodec/codec-v4l2-fwht.c    |  3 +--
 drivers/media/platform/vivid/vivid-core.c           | 37 ++++++++++++++++++++++++++++++-------
 drivers/media/platform/vivid/vivid-core.h           |  2 ++
 drivers/media/platform/vivid/vivid-ctrls.c          | 16 ++++++++++++++++
 drivers/media/usb/dvb-usb/dib0700_devices.c         |  2 +-
 drivers/media/usb/em28xx/em28xx-cards.c             |  2 +-
 drivers/media/v4l2-core/Kconfig                     |  1 +
 drivers/media/v4l2-core/v4l2-ctrls.c                |  3 ++-
 drivers/media/v4l2-core/v4l2-ioctl.c                |  2 +-
 samples/v4l/v4l2-pci-skeleton.c                     | 11 ++++++-----
 24 files changed, 116 insertions(+), 38 deletions(-)
