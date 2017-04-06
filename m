Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:58177 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752932AbdDFIfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Apr 2017 04:35:23 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.12] video/sti/cec: add CEC notifier & use in sti
 driver + 2 fixes
Message-ID: <e40af084-219f-3320-ecf7-56443fcf0fa4@xs4all.nl>
Date: Thu, 6 Apr 2017 10:35:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series adds the CEC physical address notifier code, based on
Russell's code:

https://patchwork.kernel.org/patch/9277043/

It adds support for it to the sti drm driver, adds support for
it to the CEC framework and finally adds support to the stih-cec driver,
which now can be moved out of staging.

Here is Daniel's email to allow this to be pulled through the media subsystem:

http://www.spinics.net/lists/dri-devel/msg137128.html

Note: the v6 patch series included exynos support as well. But I am still
waiting for an Ack from the exynos4 drm maintainer so I decided to get this
in first and handle the exynos4 patch series later.

This pull request contains the v6 patch series:

http://www.spinics.net/lists/dri-devel/msg137320.html

and the v6.1 patch for "media: add CEC notifier support":

https://patchwork.linuxtv.org/patch/40654/

And two CEC fixes:

https://patchwork.linuxtv.org/patch/40599/
https://patchwork.linuxtv.org/patch/40582/

Regards,

	Hans

The following changes since commit 2f65ec0567f77b75f459c98426053a3787af356a:

  [media] s5p-g2d: Fix error handling (2017-04-05 16:37:15 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git cec-not

for you to fetch changes up to 5e2ed407a549b6ec349d3581653835782785dfcb:

  cec: fix confusing CEC_CAP_RC and IS_REACHABLE(CONFIG_RC_CORE) code (2017-04-06 10:32:49 +0200)

----------------------------------------------------------------
Benjamin Gaignard (4):
      sti: hdmi: add CEC notifier support
      stih-cec.txt: document new hdmi phandle
      stih-cec: add CEC notifier support
      ARM: dts: STiH410: update sti-cec for CEC notifier support

Hans Verkuil (3):
      media: add CEC notifier support
      cec: integrate CEC notifier support
      cec: fix confusing CEC_CAP_RC and IS_REACHABLE(CONFIG_RC_CORE) code

Lee Jones (1):
      cec: Fix runtime BUG when (CONFIG_RC_CORE && !CEC_CAP_RC)

 Documentation/devicetree/bindings/media/stih-cec.txt                |   2 +
 MAINTAINERS                                                         |   4 +-
 arch/arm/boot/dts/stih407-family.dtsi                               |  12 ---
 arch/arm/boot/dts/stih410.dtsi                                      |  13 ++++
 drivers/gpu/drm/sti/sti_hdmi.c                                      |  11 +++
 drivers/gpu/drm/sti/sti_hdmi.h                                      |   3 +
 drivers/media/Kconfig                                               |   4 +
 drivers/media/Makefile                                              |   4 +
 drivers/media/cec-notifier.c                                        | 129 ++++++++++++++++++++++++++++++++
 drivers/media/cec/cec-core.c                                        |  32 +++++++-
 drivers/media/platform/Kconfig                                      |  18 +++++
 drivers/media/platform/Makefile                                     |   1 +
 drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile   |   0
 drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c |  31 +++++++-
 drivers/staging/media/Kconfig                                       |   2 -
 drivers/staging/media/Makefile                                      |   1 -
 drivers/staging/media/st-cec/Kconfig                                |   8 --
 drivers/staging/media/st-cec/TODO                                   |   7 --
 include/media/cec-notifier.h                                        | 111 +++++++++++++++++++++++++++
 include/media/cec.h                                                 |  10 +++
 20 files changed, 365 insertions(+), 38 deletions(-)
 create mode 100644 drivers/media/cec-notifier.c
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/Makefile (100%)
 rename drivers/{staging/media/st-cec => media/platform/sti/cec}/stih-cec.c (93%)
 delete mode 100644 drivers/staging/media/st-cec/Kconfig
 delete mode 100644 drivers/staging/media/st-cec/TODO
 create mode 100644 include/media/cec-notifier.h
