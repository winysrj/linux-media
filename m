Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:56092 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751432AbdBFKaG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 05:30:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCHv4 0/9] video/exynos/sti/cec: add HPD state notifier & use in drivers
Date: Mon,  6 Feb 2017 11:29:42 +0100
Message-Id: <20170206102951.12623-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds the hotplug detect notifier code, based on Russell's code:

https://patchwork.kernel.org/patch/9277043/

It adds support for it to the exynos_hdmi drm driver, adds support for
it to the CEC framework and finally adds support to the s5p-cec driver,
which now can be moved out of staging.

Also included is similar code for the STI platform, contributed by
Benjamin Gaignard.

Tested the exynos code with my Odroid U3 exynos4 devboard.

Comments are welcome. I'd like to get this in for the 4.12 kernel as
this is a missing piece needed to integrate CEC drivers.

Daniel, who should merge this? The HPD notifier code is in drivers/video
(correctly, I think), but it is initially only used by CEC drivers which
are in drivers/media (since CEC is part of the media subsystem).

It would be easiest to merge it all through the media subsystem, but in
that case I need Acks from you.

The alternative is to merge the drivers/video and drivers/gpu patches
via you and the others via media. It's a bit painful though due to the
dependencies.

Regards,

	Hans

Changes since v3:
- Added the STI patches
- Split the exynos4 binding patches in one for documentation and one
  for the dts change itself, also use the correct subject and CC to
  the correct mailinglists (I hope :-) )

Changes since v2:
- Split off the dts changes of the s5p-cec patch into a separate patch
- Renamed HPD_NOTIFIERS to HPD_NOTIFIER to be consistent with the name
  of the source.

Changes since v1:

Renamed HDMI notifier to HPD (hotplug detect) notifier since this code is
not HDMI specific, but is interesting for any video source that has to
deal with hotplug detect and EDID/ELD (HDMI, DVI, VGA, DP, ....).
Only the use with CEC adapters is HDMI specific, but the HPD notifier
is more generic.


Benjamin Gaignard (3):
  sti: hdmi: add HPD notifier support
  stih-cec: add HPD notifier support
  arm: sti: update sti-cec for HPD notifier support

Hans Verkuil (6):
  video: add hotplug detect notifier support
  exynos_hdmi: add HPD notifier support
  cec: integrate HPD notifier support
  ARM: dts: exynos: add HDMI controller phandle to exynos4.dtsi
  s5p-cec.txt: document the HDMI controller phandle
  s5p-cec: add hpd-notifier support, move out of staging

 .../devicetree/bindings/media/s5p-cec.txt          |   2 +
 .../devicetree/bindings/media/stih-cec.txt         |   2 +
 arch/arm/boot/dts/exynos4.dtsi                     |   1 +
 arch/arm/boot/dts/stih407-family.dtsi              |  12 --
 arch/arm/boot/dts/stih410.dtsi                     |  13 ++
 drivers/gpu/drm/exynos/Kconfig                     |   1 +
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  23 +++-
 drivers/gpu/drm/sti/Kconfig                        |   1 +
 drivers/gpu/drm/sti/sti_hdmi.c                     |  14 +++
 drivers/gpu/drm/sti/sti_hdmi.h                     |   3 +
 drivers/media/cec/cec-core.c                       |  50 ++++++++
 drivers/media/platform/Kconfig                     |  28 +++++
 drivers/media/platform/Makefile                    |   2 +
 .../media => media/platform}/s5p-cec/Makefile      |   0
 .../platform}/s5p-cec/exynos_hdmi_cec.h            |   0
 .../platform}/s5p-cec/exynos_hdmi_cecctrl.c        |   0
 .../media => media/platform}/s5p-cec/regs-cec.h    |   0
 .../media => media/platform}/s5p-cec/s5p_cec.c     |  35 +++++-
 .../media => media/platform}/s5p-cec/s5p_cec.h     |   3 +
 .../st-cec => media/platform/sti/cec}/Makefile     |   0
 .../st-cec => media/platform/sti/cec}/stih-cec.c   |  31 ++++-
 drivers/staging/media/Kconfig                      |   4 -
 drivers/staging/media/Makefile                     |   2 -
 drivers/staging/media/s5p-cec/Kconfig              |   9 --
 drivers/staging/media/s5p-cec/TODO                 |   7 --
 drivers/staging/media/st-cec/Kconfig               |   8 --
 drivers/staging/media/st-cec/TODO                  |   7 --
 drivers/video/Kconfig                              |   3 +
 drivers/video/Makefile                             |   1 +
 drivers/video/hpd-notifier.c                       | 134 +++++++++++++++++++++
 include/linux/hpd-notifier.h                       | 109 +++++++++++++++++
 include/media/cec.h                                |  15 +++
 32 files changed, 460 insertions(+), 60 deletions(-)
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
 create mode 100644 drivers/video/hpd-notifier.c
 create mode 100644 include/linux/hpd-notifier.h

-- 
2.11.0

