Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:57496 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753328AbeBZOaR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Feb 2018 09:30:17 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.17] Various fixes
Message-ID: <963834fb-9da2-77b5-835a-bff0c02a59cb@xs4all.nl>
Date: Mon, 26 Feb 2018 15:30:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 52e17089d1850774d2ef583cdef2b060b84fca8c:

  media: imx: Don't initialize vars that won't be used (2018-02-26 08:38:57 -0500)

are available in the Git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.17b

for you to fetch changes up to c35d71cf9814a1c0d78356eb0564527318aef440:

  media: ov2685: mark PM functions as __maybe_unused (2018-02-26 15:27:34 +0100)

----------------------------------------------------------------
Arnd Bergmann (3):
      media: i2c: TDA1997x: add CONFIG_SND dependency
      media: ov5695: mark PM functions as __maybe_unused
      media: ov2685: mark PM functions as __maybe_unused

Fabio Estevam (2):
      media: imx-media-internal-sd: Use empty initializer
      media: imx-ic-prpencvf: Use empty initializer to clear all struct members

Hans Verkuil (1):
      imx/Kconfig: add depends on HAS_DMA

Hugues Fruchet (4):
      media: stm32-dcmi: remove redundant capture enable
      media: stm32-dcmi: remove redundant clear of interrupt flags
      media: stm32-dcmi: improve error trace points
      media: stm32-dcmi: add g/s_parm framerate support

Kieran Bingham (1):
      media: i2c: adv748x: Fix cleanup jump on chip identification

Parthiban Nallathambi (1):
      media: imx: capture: reformat line to 80 chars or less

Steve Longerbeam (3):
      media: staging/imx: Implement init_cfg subdev pad op
      media: imx: mipi csi-2: Fix set_fmt try
      media: imx.rst: Fix formatting errors

 Documentation/media/v4l-drivers/imx.rst           | 24 +++++++++++++-----------
 drivers/media/i2c/Kconfig                         |  2 ++
 drivers/media/i2c/adv748x/adv748x-core.c          |  2 +-
 drivers/media/i2c/ov2685.c                        |  4 ++--
 drivers/media/i2c/ov5695.c                        |  4 ++--
 drivers/media/platform/stm32/stm32-dcmi.c         | 40 ++++++++++++++++++++++++++++------------
 drivers/staging/media/imx/Kconfig                 |  1 +
 drivers/staging/media/imx/imx-ic-prp.c            |  1 +
 drivers/staging/media/imx/imx-ic-prpencvf.c       |  3 ++-
 drivers/staging/media/imx/imx-media-capture.c     |  3 ++-
 drivers/staging/media/imx/imx-media-csi.c         |  1 +
 drivers/staging/media/imx/imx-media-internal-sd.c |  2 +-
 drivers/staging/media/imx/imx-media-utils.c       | 29 +++++++++++++++++++++++++++++
 drivers/staging/media/imx/imx-media-vdic.c        |  1 +
 drivers/staging/media/imx/imx-media.h             |  2 ++
 drivers/staging/media/imx/imx6-mipi-csi2.c        | 25 ++++++++++++++++---------
 16 files changed, 104 insertions(+), 40 deletions(-)
