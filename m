Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38489 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752574AbdBQKrC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Feb 2017 05:47:02 -0500
Received: by mail-wm0-f41.google.com with SMTP id r141so7234823wmg.1
        for <linux-media@vger.kernel.org>; Fri, 17 Feb 2017 02:47:01 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: hverkuil@xs4all.nl
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux@armlinux.org.uk, krzk@kernel.org, javier@osg.samsung.com,
        hans.verkuil@cisco.com, dri-devel@lists.freedesktop.org,
        daniel.vetter@intel.com, m.szyprowski@samsung.com,
        linux-media@vger.kernel.org, robh@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 0/3] video/sti/cec: add HPD notifier support
Date: Fri, 17 Feb 2017 11:46:49 +0100
Message-Id: <1487328412-8305-1-git-send-email-benjamin.gaignard@linaro.org>
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

version 3:
- change hdmi phandle from "st,hdmi-handle" to "hdmi-handle"
- fix typo in bindings

version 2:
- use HPD notifier instead of HDMI notifier
- move stih-cec out of staging
- rebase code on top of git://linuxtv.org/hverkuil/media_tree.git exynos4-cec
  branch
- split DT modifications in a separate patch

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
