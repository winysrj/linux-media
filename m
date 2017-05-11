Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932712AbdEKR1O (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 13:27:14 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        sakari.ailus@iki.fi
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 0/4] RFC: ADV748x HDMI/Analog video receiver
Date: Thu, 11 May 2017 18:21:19 +0100
Message-Id: <cover.5d2526b759f71c06d51df279c3d5885aca476fb6.1494523203.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

This is an RFC for the Analog Devices ADV748x driver, and follows on from a
previous posting by Niklas Söderlund [0] of an earlier incarnation of this
driver.

Aside from a few bug fixes, and considerable refactoring this driver:
 - is refactored to multiple object files
 - defines multiple sub devices for the output paths.
 - has independent controls for both HDMI and Analog video paths

 - Specifies 'endpoint' matching instead of 'device' in async framework

These patches are based up on Niklas' pending RVin work [1] and Sakari's fwnode
series [2]

TLDR:
 This series uses the fwnode for the 'endpoint' as a matching for the async
 notifier framework.  If accepted, I propose changing all async notifier users
 to use this method of matching, rather than the fwnode of the root device node

ADV748x
=======
The ADV7481 and ADV7482 support two video pipelines which can run independently
of each other, with each pipeline terminating in a CSI-2 output: TXA (4-Lane)
and TXB (1-Lane)

The ADV7480 (Not yet included here), ADV7481, and ADV7482 are all derivatives,
with the following features

            Analog   HDMI  MHL  4-Lane  1-Lane
              In      In         CSI     CSI
 ADV7480               X    X     X
 ADV7481      X        X    X     X       X
 ADV7482      X        X          X       X

Implementation
==============

This RFC creates 4 entities. AFE (CVBS/Analog In), HDMI, TXA and TXB.  At probe
time, the DT is parsed to identify the endpoints for each of these nodes, and
those are used for async matching of the CSI2 (TXA/TXB) entities in the master
driver. The HDMI and AFE entities are then registered after a successful
registration of both the CSI2 entities.

(Known) Todo's
==============

Further potential development areas include:
 - ADV7480 Support (No AFE)
 - MHL support (Not present on ADV7482)
 - EDID support
 - CEC Support
 - Configurable I2C addressing
 - Interrupt handling for format changes and hotplug detect.
 - Entity locking, rather than global state locking
   - Including making sure the I2C paths are serialised correctly!

However, this driver and series is functional without the above, though if
there are mandatory areas which block mainline integration please let me know
and I will prioritise that in development.

I appreciate that there are still some 'rough edges' in the driver, which is
still under development, but all comments are welcome.

Discussion Topics
=================

Async Subdev endpoint matching

   This series sets the subdevice fwnode in adv748x_csi2_probe() as the handle
   to the endpoint for the specific port used to map the phandles.

   This differs to the standard/default use of the device fwnode.

   This change is required as we have 2 CSI entities which must be matched
   based on their endpoint and port from the same device-tree device.

   The RVin driver is thus modified not to register it's notifier to look for
   phandle endpoint, rather than the endpoints port parent.

   This is a critical change, and if deemed the 'correct' way forward, I would
   propose changing all users of the async framework to use this matching.

References
==========
[0] http://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg05196.html
[1] https://git.ragnatech.se/linux rcar-vin-elinux-v7
[2] https://www.mail-archive.com/linux-media@vger.kernel.org/msg111332.html

Kieran Bingham (4):
  media: i2c: adv748x: add adv748x driver
  arm64: dts: r8a7795: salvator-x: enable VIN, CSI and ADV7482
  arm64: dts: r8a7796: salvator-x: enable VIN, CSI and ADV7482
  rcar-csi2: Map to fwnode endpoints rather than port parents

 Documentation/devicetree/bindings/media/i2c/adv748x.txt |  63 +-
 MAINTAINERS                                             |   6 +-
 arch/arm64/boot/dts/renesas/r8a7795-salvator-x.dts      | 147 ++-
 arch/arm64/boot/dts/renesas/r8a7796-salvator-x.dts      | 147 ++-
 drivers/media/i2c/Kconfig                               |  10 +-
 drivers/media/i2c/Makefile                              |   1 +-
 drivers/media/i2c/adv748x/Makefile                      |   7 +-
 drivers/media/i2c/adv748x/adv748x-afe.c                 | 599 ++++++++-
 drivers/media/i2c/adv748x/adv748x-core.c                | 698 +++++++++-
 drivers/media/i2c/adv748x/adv748x-csi2.c                | 373 +++++-
 drivers/media/i2c/adv748x/adv748x-hdmi.c                | 671 +++++++++-
 drivers/media/i2c/adv748x/adv748x.h                     | 201 +++-
 drivers/media/platform/rcar-vin/rcar-csi2.c             |  14 +-
 13 files changed, 2926 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
 create mode 100644 drivers/media/i2c/adv748x/Makefile
 create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x.h

base-commit: 00b01d855fcd0c40279ddc0f91488a02b14d633e
-- 
git-series 0.9.1
