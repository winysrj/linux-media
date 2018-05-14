Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:37555 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752293AbeENWko (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 18:40:44 -0400
Received: by mail-lf0-f65.google.com with SMTP id r2-v6so20405895lff.4
        for <linux-media@vger.kernel.org>; Mon, 14 May 2018 15:40:43 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: airlied@linux.ie, hans.verkuil@cisco.com, lee.jones@linaro.org,
        olof@lixom.net, seanpaul@google.com
Cc: Neil Armstrong <narmstrong@baylibre.com>, sadolfsson@google.com,
        felixe@google.com, bleung@google.com, darekm@google.com,
        marcheu@chromium.org, fparent@baylibre.com,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] Add ChromeOS EC CEC Support
Date: Tue, 15 May 2018 00:40:34 +0200
Message-Id: <1526337639-3568-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

The new Google "Fizz" Intel-based ChromeOS device is gaining CEC support
throught it's Embedded Controller, to enable the Linux CEC Core to communicate
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

Neil Armstrong (5):
  mfd: cros_ec_dev: Add CEC sub-device registration
  media: cec-notifier: Get notifier by device and connector name
  drm/i915: hdmi: add CEC notifier to intel_hdmi
  mfd: cros-ec: Introduce CEC commands and events definitions.
  media: platform: Add Chrome OS EC CEC driver

 drivers/gpu/drm/i915/intel_drv.h             |   2 +
 drivers/gpu/drm/i915/intel_hdmi.c            |  10 +
 drivers/media/cec/cec-notifier.c             |  30 ++-
 drivers/media/platform/Kconfig               |  11 +
 drivers/media/platform/Makefile              |   2 +
 drivers/media/platform/cros-ec/Makefile      |   1 +
 drivers/media/platform/cros-ec/cros-ec-cec.c | 331 +++++++++++++++++++++++++++
 drivers/mfd/cros_ec_dev.c                    |  16 ++
 drivers/platform/chrome/cros_ec_proto.c      |  42 +++-
 include/linux/mfd/cros_ec.h                  |   2 +-
 include/linux/mfd/cros_ec_commands.h         |  80 +++++++
 include/media/cec-notifier.h                 |  44 +++-
 12 files changed, 556 insertions(+), 15 deletions(-)
 create mode 100644 drivers/media/platform/cros-ec/Makefile
 create mode 100644 drivers/media/platform/cros-ec/cros-ec-cec.c

-- 
2.7.4
