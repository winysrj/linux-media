Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:51680 "EHLO
        lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751207AbdFGOqV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Jun 2017 10:46:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: [PATCH 0/9] cec improvements
Date: Wed,  7 Jun 2017 16:46:07 +0200
Message-Id: <20170607144616.15247-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This patch series adds several helper functions to ease writing
drm or media CEC drivers.

It also adds support for the CEC_CAP_NEEDS_HPD capability which is
needed for hardware that turns off the CEC support if the hotplug
detect signal is low. Usually because the HPD is connected to some
'power' or 'active' pin of the CEC hardware.

One of those is the Odroid-U3, so add a 'needs-hpd' property that
tells the driver whether or not CEC is available without HPD.

Regards,

	Hans

Hans Verkuil (9):
  cec: add cec_s_phys_addr_from_edid helper function
  cec: add cec_phys_addr_invalidate() helper function
  cec: add cec_transmit_attempt_done helper function
  stih-cec/vivid/pulse8/rainshadow: use cec_transmit_attempt_done
  cec: add CEC_CAP_NEEDS_HPD
  cec-ioc-adap-g-caps.rst: document CEC_CAP_NEEDS_HPD
  dt-bindings: media/s5p-cec.txt: document needs-hpd property
  s5p_cec: set the CEC_CAP_NEEDS_HPD flag if needed
  ARM: dts: exynos: add needs-hpd to &hdmicec for Odroid-U3

 .../devicetree/bindings/media/s5p-cec.txt          |  6 +++
 Documentation/media/kapi/cec-core.rst              | 18 +++++++
 .../media/uapi/cec/cec-ioc-adap-g-caps.rst         |  8 +++
 arch/arm/boot/dts/exynos4412-odroidu3.dts          |  4 ++
 drivers/media/cec/cec-adap.c                       | 60 +++++++++++++++++++---
 drivers/media/cec/cec-api.c                        |  5 +-
 drivers/media/cec/cec-core.c                       |  1 +
 drivers/media/platform/s5p-cec/s5p_cec.c           |  4 +-
 drivers/media/platform/sti/cec/stih-cec.c          |  9 ++--
 drivers/media/platform/vivid/vivid-cec.c           |  6 +--
 drivers/media/usb/pulse8-cec/pulse8-cec.c          |  9 ++--
 drivers/media/usb/rainshadow-cec/rainshadow-cec.c  |  9 ++--
 include/media/cec.h                                | 29 +++++++++++
 include/uapi/linux/cec.h                           |  2 +
 14 files changed, 142 insertions(+), 28 deletions(-)

-- 
2.11.0
