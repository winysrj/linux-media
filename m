Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:46007 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752293AbdHBSlO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 14:41:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv3 0/4] dw-hdmi CEC support
Date: Wed,  2 Aug 2017 20:41:04 +0200
Message-Id: <20170802184108.7913-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Russell's v2 cover letter:

------------------
Hi,

This series adds dw-hdmi CEC support.  This is done in four stages:

1. Add cec-notifier support
2. Fix up the clkdis register support, as this register contains a
   clock disable bit for the CEC module.
3. Add the driver.
4. Remove definitions that are not required from dw-hdmi.h

The CEC driver has been updated to use the register accessors in the
main driver - it would be nice if it was possible to use the regmap
support directly, but there's some knowledge private to the main
driver that's required to correctly access the registers.  (I don't
understand why the register stride isn't part of regmap.)

 drivers/gpu/drm/bridge/synopsys/Kconfig       |  10 +
 drivers/gpu/drm/bridge/synopsys/Makefile      |   1 +
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c | 326 ++++++++++++++++++++++++++
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h |  19 ++
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c     |  93 +++++++-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.h     |  46 +---
 6 files changed, 437 insertions(+), 58 deletions(-)

v2 - fix selection of CEC_NOTIFIER in Kconfig
------------------

Changes in this v3:

- add missing cec_notifier_put to remove()
- some checkpatch unsigned -> unsigned int changes
- cec_transmit_done is replaced by the newer cec_transmit_attempt_done
- added missing CEC_CAP_PASSTHROUGH

Regards,

	Hans

Russell King (4):
  drm/bridge: dw-hdmi: add cec notifier support
  drm/bridge: dw-hdmi: add better clock disable control
  drm/bridge: dw-hdmi: add cec driver
  drm/bridge: dw-hdmi: remove CEC engine register definitions

 drivers/gpu/drm/bridge/synopsys/Kconfig       |  10 +
 drivers/gpu/drm/bridge/synopsys/Makefile      |   1 +
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c | 327 ++++++++++++++++++++++++++
 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h |  19 ++
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.c     |  96 +++++++-
 drivers/gpu/drm/bridge/synopsys/dw-hdmi.h     |  46 +---
 6 files changed, 441 insertions(+), 58 deletions(-)
 create mode 100644 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.c
 create mode 100644 drivers/gpu/drm/bridge/synopsys/dw-hdmi-cec.h

-- 
2.13.2
