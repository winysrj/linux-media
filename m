Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:59063 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751126AbdDHO24 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Apr 2017 10:28:56 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12 (v2)] video/exynos/sti/cec: add CEC notifier &
 use in drivers + 2 fixes
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Message-ID: <cbd426a6-7a0b-1bfb-53fe-a5055e412937@xs4all.nl>
Date: Sat, 8 Apr 2017 16:28:49 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the CEC physical address notifier code, based on
Russell's code:

https://patchwork.kernel.org/patch/9277043/

It adds support for it to the exynos4 and sti drm driver, adds support for
it to the CEC framework and finally adds support to the s5p-cec and stih-cec
drivers, which now can be moved out of staging.

Here is Daniel's email to allow this to be pulled through the media subsystem:

http://www.spinics.net/lists/dri-devel/msg137128.html

This pull request contains the v6 patch series:

http://www.spinics.net/lists/dri-devel/msg137320.html

and the v6.1 patch for "media: add CEC notifier support":

https://patchwork.linuxtv.org/patch/40654/

And two CEC fixes:

https://patchwork.linuxtv.org/patch/40599/
https://patchwork.linuxtv.org/patch/40582/

Regards,

	Hans

Changes since the previous (now superseded) pull request:

- added the exynos4/s5p-cec driver. Andrzej Hajda added his Reviewed-by tag
  to the exynos4 drm driver, so this is now good to go in as well.


The following changes since commit 2f65ec0567f77b75f459c98426053a3787af356a:

  [media] s5p-g2d: Fix error handling (2017-04-05 16:37:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-not

for you to fetch changes up to 4daddcf63addef9a5ccab0822af9873278c87ce1:

  cec: fix confusing CEC_CAP_RC and IS_REACHABLE(CONFIG_RC_CORE) code (2017-04-08 16:22:45 +0200)

----------------------------------------------------------------
Benjamin Gaignard (4):
      sti: hdmi: add CEC notifier support
      stih-cec.txt: document new hdmi phandle
      stih-cec: add CEC notifier support
      ARM: dts: STiH410: update sti-cec for CEC notifier support

Hans Verkuil (7):
      media: add CEC notifier support
      cec: integrate CEC notifier support
      exynos_hdmi: add CEC notifier support
      ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
      s5p-cec.txt: document the HDMI controller phandle
      s5p-cec: add cec-notifier support, move out of staging
      cec: fix confusing CEC_CAP_RC and IS_REACHABLE(CONFIG_RC_CORE) code

Lee Jones (1):
      cec: Fix runtime BUG when (CONFIG_RC_CORE && !CEC_CAP_RC)

 Documentation/devicetree/bindings/media/s5p-cec.txt                  |   2 +
 Documentation/devicetree/bindings/media/stih-cec.txt                 |   2 +
 MAINTAINERS                                                          |   4 +-
 arch/arm/boot/dts/exynos4.dtsi                                       |   1 +
 arch/arm/boot/dts/stih407-family.dtsi                                |  12 ---
 arch/arm/boot/dts/stih410.dtsi                                       |  13 ++++
 drivers/gpu/drm/exynos/exynos_hdmi.c                                 |  19 ++++-
 drivers/gpu/drm/sti/sti_hdmi.c                                       |  11 +++
 drivers/gpu/drm/sti/sti_hdmi.h                                       |   3 +
 drivers/media/Kconfig                                                |   4 +
 drivers/media/Makefile                                               |   4 +
 drivers/media/cec-notifier.c                                         | 129 +++++++++++++++++++++++++++++++
 drivers/media/cec/cec-core.c                                         |  32 +++++++-
 drivers/media/platform/Kconfig                                       |  28 +++++++
 drivers/media/platform/Makefile                                      |   2 +
 drivers/{staging/media => media/platform}/s5p-cec/Makefile           |   0
 drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h  |   0
 .../{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c  |   0
 drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h         |   0
 drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c          |  35 +++++++--
 drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h          |   3 +
 drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile    |   0
 drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c  |  31 +++++++-
 drivers/staging/media/Kconfig                                        |   4 -
 drivers/staging/media/Makefile                                       |   2 -
 drivers/staging/media/s5p-cec/Kconfig                                |   9 ---
 drivers/staging/media/s5p-cec/TODO                                   |   7 --
 drivers/staging/media/st-cec/Kconfig                                 |   8 --
 drivers/staging/media/st-cec/TODO                                    |   7 --
 include/media/cec-notifier.h                                         | 111 ++++++++++++++++++++++++++
 include/media/cec.h                                                  |  10 +++
 31 files changed, 429 insertions(+), 64 deletions(-)
 create mode 100644 drivers/media/cec-notifier.c
 rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (89%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile (100%)
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c (93%)
 delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
 delete mode 100644 drivers/staging/media/s5p-cec/TODO
 delete mode 100644 drivers/staging/media/st-cec/Kconfig
 delete mode 100644 drivers/staging/media/st-cec/TODO
 create mode 100644 include/media/cec-notifier.h
