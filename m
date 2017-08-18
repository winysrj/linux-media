Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47629 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbdHRHUC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 03:20:02 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.14] Various fixes/improvements
Message-ID: <27f6d0c0-721b-784a-4b94-b466a01a68c9@xs4all.nl>
Date: Fri, 18 Aug 2017 09:19:57 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lots of constify stuff, some random other fixes.

The following changes since commit ec0c3ec497cabbf3bfa03a9eb5edcc252190a4e0:

  media: ddbridge: split code into multiple files (2017-08-09 12:17:01 -0400)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.14i

for you to fetch changes up to 6b1672790166600515ff497a3e2733d0b2787815:

  usb: rainshadow-cec: constify serio_device_id (2017-08-18 09:13:43 +0200)

----------------------------------------------------------------
Arvind Yadav (5):
      coda: constify platform_device_id
      davinci: constify platform_device_id
      radio: constify pnp_device_id
      usb: pulse8-cec: constify serio_device_id
      usb: rainshadow-cec: constify serio_device_id

Bhumika Goyal (6):
      tuners: make tda18271_std_map const
      staging: bcm2835-audio: make snd_pcm_hardware const
      cx88: make snd_kcontrol_new const
      solo6x10: make snd_kcontrol_new const
      cx18: Fix incompatible type for argument error
      ivtv: Fix incompatible type for argument error

Fabio Estevam (1):
      coda/imx-vdoa: Check for platform_get_resource() error

Pan Bian (1):
      media: mtk-mdp: use IS_ERR to check return value of of_clk_get

Rob Herring (1):
      media: Convert to using %pOF instead of full_name

 drivers/media/i2c/s5c73m3/s5c73m3-core.c                  |  3 +--
 drivers/media/i2c/s5k5baf.c                               |  7 +++---
 drivers/media/pci/cx18/cx18-alsa-mixer.c                  |  2 +-
 drivers/media/pci/cx88/cx88-alsa.c                        |  2 +-
 drivers/media/pci/ivtv/ivtv-alsa-mixer.c                  |  2 +-
 drivers/media/pci/solo6x10/solo6x10-g723.c                |  2 +-
 drivers/media/platform/am437x/am437x-vpfe.c               |  4 ++--
 drivers/media/platform/atmel/atmel-isc.c                  |  4 ++--
 drivers/media/platform/coda/coda-common.c                 |  2 +-
 drivers/media/platform/coda/imx-vdoa.c                    |  2 ++
 drivers/media/platform/davinci/vpbe_osd.c                 |  2 +-
 drivers/media/platform/davinci/vpbe_venc.c                |  2 +-
 drivers/media/platform/davinci/vpif_capture.c             | 16 ++++++-------
 drivers/media/platform/exynos4-is/fimc-is.c               |  8 +++----
 drivers/media/platform/exynos4-is/fimc-lite.c             |  3 +--
 drivers/media/platform/exynos4-is/media-dev.c             |  8 +++----
 drivers/media/platform/exynos4-is/mipi-csis.c             |  4 ++--
 drivers/media/platform/mtk-mdp/mtk_mdp_comp.c             | 10 ++++-----
 drivers/media/platform/mtk-mdp/mtk_mdp_core.c             |  8 +++----
 drivers/media/platform/omap3isp/isp.c                     |  8 +++----
 drivers/media/platform/pxa_camera.c                       |  2 +-
 drivers/media/platform/rcar-vin/rcar-core.c               |  4 ++--
 drivers/media/platform/soc_camera/soc_camera.c            |  6 ++---
 drivers/media/platform/xilinx/xilinx-vipp.c               | 52 +++++++++++++++++++++----------------------
 drivers/media/radio/radio-cadet.c                         |  2 +-
 drivers/media/radio/radio-gemtek.c                        |  2 +-
 drivers/media/radio/radio-sf16fmr2.c                      |  2 +-
 drivers/media/tuners/tda18271-maps.c                      |  4 ++--
 drivers/media/usb/pulse8-cec/pulse8-cec.c                 |  2 +-
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c         |  2 +-
 drivers/media/v4l2-core/v4l2-clk.c                        |  3 +--
 drivers/staging/vc04_services/bcm2835-audio/bcm2835-pcm.c |  4 ++--
 include/media/v4l2-clk.h                                  |  4 ++--
 33 files changed, 90 insertions(+), 98 deletions(-)
