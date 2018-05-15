Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37864 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754044AbeEOOma (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 10:42:30 -0400
Received: by mail-qt0-f196.google.com with SMTP id q13-v6so556847qtp.4
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 07:42:29 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] Add ChromeOS EC CEC Support
Date: Tue, 15 May 2018 16:42:17 +0200
Message-Id: <1526395342-15481-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

The new Google "Fizz" Intel-based ChromeOS device is gaining CEC support
through it's Embedded Controller, to enable the Linux CEC Core to communicate
with it and get the CEC Physical Address from the correct HDMI Connector, the
following must be added/changed:
- Add the CEC sub-device registration in the ChromeOS EC MFD Driver
- Add the CEC related commands and events definitions into the EC MFD driver
- Add a way to get a CEC notifier with it's (optional) connector name
- Add the CEC notifier to the i915 HDMI driver
- Add the proper ChromeOS EC CEC Driver

The CEC notifier with the connector name is the tricky point, since even on
Device-Tree platforms, there is no way to distinguish between multiple HDMI
connectors from the same DRM driver. The solution I implemented is pretty
simple and only adds an optional connector name to eventually distinguish
an HDMI connector notifier from another if they share the same device.

Feel free to comment this patchset !

Changes since v1:
 - Added cec_notifier_put to intel_hdmi
 - Fixed all small reported issues on the EC CEC driver
 - Moved the cec_notifier_get out of the #if .. #else .. #endif

Changes since RFC:
 - Moved CEC sub-device registration after CEC commands and events definitions patch
 - Removed get_notifier_get_byname
 - Added CEC_CORE select into i915 Kconfig
 - Removed CEC driver fallback if notifier is not configured on HW, added explicit warn
 - Fixed CEC core return type on error
 - Moved to cros-ec-cec media platform directory
 - Use bus_find_device() to find the pci i915 device instead of get_notifier_get_byname()
 - Fix Logical Address setup
 - Added comment about HW support
 - Removed memset of msg structures

Neil Armstrong (5):
  media: cec-notifier: Get notifier by device and connector name
  drm/i915: hdmi: add CEC notifier to intel_hdmi
  mfd: cros-ec: Introduce CEC commands and events definitions.
  mfd: cros_ec_dev: Add CEC sub-device registration
  media: platform: Add Chrome OS EC CEC driver

 drivers/gpu/drm/i915/Kconfig                     |   1 +
 drivers/gpu/drm/i915/intel_drv.h                 |   2 +
 drivers/gpu/drm/i915/intel_hdmi.c                |  12 +
 drivers/media/cec/cec-notifier.c                 |  11 +-
 drivers/media/platform/Kconfig                   |  11 +
 drivers/media/platform/Makefile                  |   2 +
 drivers/media/platform/cros-ec-cec/Makefile      |   1 +
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c | 335 +++++++++++++++++++++++
 drivers/mfd/cros_ec_dev.c                        |  16 ++
 drivers/platform/chrome/cros_ec_proto.c          |  42 ++-
 include/linux/mfd/cros_ec.h                      |   2 +-
 include/linux/mfd/cros_ec_commands.h             |  80 ++++++
 include/media/cec-notifier.h                     |  27 +-
 13 files changed, 526 insertions(+), 16 deletions(-)
 create mode 100644 drivers/media/platform/cros-ec-cec/Makefile
 create mode 100644 drivers/media/platform/cros-ec-cec/cros-ec-cec.c

-- 
2.7.4
