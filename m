Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:34523 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752007AbcKNPW5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 10:22:57 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org
Subject: [RFCv2 PATCH 0/5] CEC drivers for iMX6 and TDA9950
Date: Mon, 14 Nov 2016 16:22:43 +0100
Message-Id: <1479136968-24477-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series is an update to this RFC series from Russell:

https://lists.freedesktop.org/archives/dri-devel/2016-August/115733.html

I have not seen any updates to this, so I hope that that series is still
the latest version.

The main problem with that original series was that the notifier didn't
store the state, so if a CEC driver registered with the notifier, then
it wouldn't be informed of the current state.

The hdmi-notifier code has been changed to a per-HDMI-device and refcounted
block_notifier that stores the state and will report the current state
upon registration.

The other four patches have been adapted to the new notifier code, but
no other changes were made.

It has *only* been compile-tested. I might be able to verify it next week
with an actual i.MX6 device, but it will take time to set that up.

If someone has a ready-to-test setup, then I would very much appreciate
it if this series can be tested.

The patches are also available in my branch:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=cec-notifiers

It is on top of my patch series that moves CEC out of staging. This
is planned for 4.10.

Regards,

	Hans

Hans Verkuil (1):
  video: add HDMI state notifier support

Russell King (4):
  drm/bridge: dw_hdmi: remove CEC engine register definitions
  drm/bridge: dw_hdmi: add HDMI notifier support
  drm/bridge: add dw-hdmi cec driver using Hans Verkuil's CEC code
  drm/i2c: add tda998x/tda9950 CEC driver

 drivers/gpu/drm/bridge/Kconfig            |   8 +
 drivers/gpu/drm/bridge/Makefile           |   1 +
 drivers/gpu/drm/bridge/dw-hdmi-cec.c      | 346 ++++++++++++++++++++
 drivers/gpu/drm/bridge/dw-hdmi.c          |  89 +++++-
 drivers/gpu/drm/bridge/dw-hdmi.h          |  45 ---
 drivers/gpu/drm/i2c/Kconfig               |   5 +
 drivers/gpu/drm/i2c/Makefile              |   1 +
 drivers/gpu/drm/i2c/tda9950.c             | 516 ++++++++++++++++++++++++++++++
 drivers/video/Kconfig                     |   3 +
 drivers/video/Makefile                    |   1 +
 drivers/video/hdmi-notifier.c             | 136 ++++++++
 include/linux/hdmi-notifier.h             |  43 +++
 include/linux/platform_data/dw_hdmi-cec.h |  16 +
 include/linux/platform_data/tda9950.h     |  15 +
 14 files changed, 1168 insertions(+), 57 deletions(-)
 create mode 100644 drivers/gpu/drm/bridge/dw-hdmi-cec.c
 create mode 100644 drivers/gpu/drm/i2c/tda9950.c
 create mode 100644 drivers/video/hdmi-notifier.c
 create mode 100644 include/linux/hdmi-notifier.h
 create mode 100644 include/linux/platform_data/dw_hdmi-cec.h
 create mode 100644 include/linux/platform_data/tda9950.h

-- 
2.8.1

