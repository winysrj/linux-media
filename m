Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36798 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932997AbdABOTQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 2 Jan 2017 09:19:16 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCHv2 0/4] video/exynos/cec: add HPD state notifier & use in s5p-cec
Date: Mon,  2 Jan 2017 15:19:03 +0100
Message-Id: <1483366747-34288-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds the hotplug detect notifier code, based on Russell's code:

https://patchwork.kernel.org/patch/9277043/

It adds support for it to the exynos_hdmi drm driver, adds support for
it to the CEC framework and finally adds support to the s5p-cec driver,
which now can be moved out of staging.

Tested with my Odroid U3 exynos4 devboard.

Comments are welcome. I'd like to get this in for the 4.11 kernel as
this is a missing piece needed to integrate CEC drivers.

Changes since v1:

Renamed HDMI notifier to HPD (hotplug detect) notifier since this code is
not HDMI specific, but is interesting for any video source that has to
deal with hotplug detect and EDID/ELD (HDMI, DVI, VGA, DP, ....).
Only the use with CEC adapters is HDMI specific, but the HPD notifier
is more generic.

Regards,

	Hans

Hans Verkuil (4):
  video: add hotplug detect notifier support
  exynos_hdmi: add HPD notifier support
  cec: integrate HPD notifier support
  s5p-cec: add hpd-notifier support, move out of staging

 .../devicetree/bindings/media/s5p-cec.txt          |   2 +
 arch/arm/boot/dts/exynos4.dtsi                     |   1 +
 drivers/gpu/drm/exynos/Kconfig                     |   1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  24 +++-
 drivers/media/cec/cec-core.c                       |  50 ++++++++
 drivers/media/platform/Kconfig                     |  18 +++
 drivers/media/platform/Makefile                    |   1 +
 .../media => media/platform}/s5p-cec/Makefile      |   0
 .../platform}/s5p-cec/exynos_hdmi_cec.h            |   0
 .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |   0
 .../media => media/platform}/s5p-cec/regs-cec.h    |   0
 .../media => media/platform}/s5p-cec/s5p_cec.c     |  35 +++++-
 .../media => media/platform}/s5p-cec/s5p_cec.h     |   3 +
 drivers/staging/media/Kconfig                      |   2 -
 drivers/staging/media/Makefile                     |   1 -
 drivers/staging/media/s5p-cec/Kconfig              |   9 --
 drivers/staging/media/s5p-cec/TODO                 |   7 --
 drivers/video/Kconfig                              |   3 +
 drivers/video/Makefile                             |   1 +
 drivers/video/hpd-notifier.c                       | 134 +++++++++++++++++++++
 include/linux/hpd-notifier.h                       | 109 +++++++++++++++++
 include/media/cec.h                                |  15 +++
 22 files changed, 389 insertions(+), 27 deletions(-)
 rename drivers/{staging/media => media/platform}/s5p-cec/Makefile (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/exynos_hdmi_cecctrl.c (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/regs-cec.h (100%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.c (89%)
 rename drivers/{staging/media => media/platform}/s5p-cec/s5p_cec.h (97%)
 delete mode 100644 drivers/staging/media/s5p-cec/Kconfig
 delete mode 100644 drivers/staging/media/s5p-cec/TODO
 create mode 100644 drivers/video/hpd-notifier.c
 create mode 100644 include/linux/hpd-notifier.h

-- 
2.8.1

