Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36566 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964971AbdACOzI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 3 Jan 2017 09:55:08 -0500
Received: by mail-wm0-f48.google.com with SMTP id c85so201194678wmi.1
        for <linux-media@vger.kernel.org>; Tue, 03 Jan 2017 06:55:07 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: linux@armlinux.org.uk, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 0/3] video/sti/cec: add HPD notifier support
Date: Tue,  3 Jan 2017 15:54:54 +0100
Message-Id: <1483455297-2286-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series following what Hans is doing on exynos to support
hotplug detect notifier code.

It add support of HPD in sti_hdmi drm driver and stih-cec driver which
move out of staging.

Those patches should be applied on top of Hans branch exynos4-cec.

I have tested hdmi notifier by pluging/unpluging HDMI cable and check
the value of the physical address with "cec-ctl --tuner".
"cec-compliance -A" is also functional.

version 2:
- use HPD notifier instead of HDMI notifier
- move stih-cec out of staging
- rebase code on top of git://linuxtv.org/hverkuil/media_tree.git exynos4-cec
  branch
- split DT modifications in a separate patch

Regards,
Benjamin

Benjamin Gaignard (3):
  sti: hdmi: add HPD notifier support
  stih-cec: add HPD notifier support
  arm: sti: update sti-cec for HPD notifier support

 .../devicetree/bindings/media/stih-cec.txt         |   2 +
 arch/arm/boot/dts/stih407-family.dtsi              |  12 -
 arch/arm/boot/dts/stih410.dtsi                     |  13 +
 drivers/gpu/drm/sti/Kconfig                        |   1 +
 drivers/gpu/drm/sti/sti_hdmi.c                     |  14 +
 drivers/gpu/drm/sti/sti_hdmi.h                     |   3 +
 drivers/media/platform/Kconfig                     |  10 +
 drivers/media/platform/Makefile                    |   1 +
 drivers/media/platform/sti/cec/Makefile            |   1 +
 drivers/media/platform/sti/cec/stih-cec.c          | 404 +++++++++++++++++++++
 drivers/staging/media/Kconfig                      |   2 -
 drivers/staging/media/Makefile                     |   1 -
 drivers/staging/media/st-cec/Kconfig               |   8 -
 drivers/staging/media/st-cec/Makefile              |   1 -
 drivers/staging/media/st-cec/TODO                  |   7 -
 drivers/staging/media/st-cec/stih-cec.c            | 379 -------------------
 16 files changed, 449 insertions(+), 410 deletions(-)
 create mode 100644 drivers/media/platform/sti/cec/Makefile
 create mode 100644 drivers/media/platform/sti/cec/stih-cec.c
 delete mode 100644 drivers/staging/media/st-cec/Kconfig
 delete mode 100644 drivers/staging/media/st-cec/Makefile
 delete mode 100644 drivers/staging/media/st-cec/TODO
 delete mode 100644 drivers/staging/media/st-cec/stih-cec.c

-- 
1.9.1

