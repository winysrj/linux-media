Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39280 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeGMH7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Jul 2018 03:59:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id h10-v6so24099328wre.6
        for <linux-media@vger.kernel.org>; Fri, 13 Jul 2018 00:46:23 -0700 (PDT)
Date: Fri, 13 Jul 2018 08:46:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Neil Armstrong <narmstrong@baylibre.com>
Cc: airlied@linux.ie, hans.verkuil@cisco.com, olof@lixom.net,
        seanpaul@google.com, sadolfsson@google.com, felixe@google.com,
        bleung@google.com, darekm@google.com, marcheu@chromium.org,
        fparent@baylibre.com, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, eballetbo@gmail.com
Subject: [GIT PULL] Immutable branch between MFD and DRM/i915, Media and
 Platform due for the v4.19 merge window
Message-ID: <20180713074620.GW4641@dell>
References: <1530716901-30164-1-git-send-email-narmstrong@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1530716901-30164-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enjoy!

The following changes since commit ce397d215ccd07b8ae3f71db689aedb85d56ab40:

  Linux 4.18-rc1 (2018-06-17 08:04:49 +0900)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git ib-mfd-i915-media-platform-v4.19

for you to fetch changes up to cd70de2d356ee692477276bd5d6bc88c71a48733:

  media: platform: Add ChromeOS EC CEC driver (2018-07-13 08:44:46 +0100)

----------------------------------------------------------------
Immutable branch between MFD and DRM/i915, Media and Platform due for the v4.19 merge window

----------------------------------------------------------------
Neil Armstrong (6):
      media: cec-notifier: Get notifier by device and connector name
      drm/i915: hdmi: add CEC notifier to intel_hdmi
      mfd: cros-ec: Increase maximum mkbp event size
      mfd: cros-ec: Introduce CEC commands and events definitions.
      mfd: cros_ec_dev: Add CEC sub-device registration
      media: platform: Add ChromeOS EC CEC driver

 drivers/gpu/drm/i915/Kconfig                     |   1 +
 drivers/gpu/drm/i915/intel_display.h             |  24 ++
 drivers/gpu/drm/i915/intel_drv.h                 |   2 +
 drivers/gpu/drm/i915/intel_hdmi.c                |  13 +
 drivers/media/cec/cec-notifier.c                 |  11 +-
 drivers/media/platform/Kconfig                   |  11 +
 drivers/media/platform/Makefile                  |   2 +
 drivers/media/platform/cros-ec-cec/Makefile      |   1 +
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c | 347 +++++++++++++++++++++++
 drivers/mfd/cros_ec_dev.c                        |  16 ++
 drivers/platform/chrome/cros_ec_proto.c          |  40 ++-
 include/linux/mfd/cros_ec.h                      |   2 +-
 include/linux/mfd/cros_ec_commands.h             |  97 +++++++
 include/media/cec-notifier.h                     |  27 +-
 14 files changed, 578 insertions(+), 16 deletions(-)
 create mode 100644 drivers/media/platform/cros-ec-cec/Makefile
 create mode 100644 drivers/media/platform/cros-ec-cec/cros-ec-cec.c

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
