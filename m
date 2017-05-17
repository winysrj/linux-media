Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753688AbdEQONt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 May 2017 10:13:49 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
        niklas.soderlund@ragnatech.se
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 0/2] ADV748x HDMI/Analog video receiver
Date: Wed, 17 May 2017 15:13:16 +0100
Message-Id: <cover.29a91b9366a11bb7dbf4118ea12b84f2d48a8989.1495029016.git-series.kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

This is a driver for the Analog Devices ADV748x device, and follows on from a
previous posting by Niklas Söderlund [0] of an earlier incarnation of this
driver.

Aside from a few bug fixes, and considerable refactoring this driver:
 - is refactored to multiple object files
 - defines multiple sub devices for the output paths.
 - has independent controls for both HDMI and Analog video paths

 - Specifies 'endpoint' matching instead of 'device' in async framework

These patches are based up on Niklas' pending RVin work [1] and Sakari's fwnode
series [2]

This version sees lots of review comments addressed from previous reviews, and
the removal of the async notifiers to register the AFE/HDMI entities (which was
functional - but overkill)

Updates to the core to support matching will be provided in a separate series

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

(Known) Future Todo's
=====================

Further potential development areas include:
 - ADV7480 Support (No AFE)
 - MHL support (Not present on ADV7482)
 - EDID support
 - CEC Support
 - Configurable I2C addressing
 - Interrupt handling for format changes and hotplug detect.

However, this driver and series is functional without the above, though if
there are mandatory areas which block mainline integration please let me know
and I will prioritise that in development.

References
==========
[0] http://www.mail-archive.com/linux-renesas-soc@vger.kernel.org/msg05196.html
[1] https://git.ragnatech.se/linux rcar-vin-elinux-v7
[2] https://www.mail-archive.com/linux-media@vger.kernel.org/msg111332.html

Kieran Bingham (2):
  v4l: subdev: tolerate null in media_entity_to_v4l2_subdev
  media: i2c: adv748x: add adv748x driver

 Documentation/devicetree/bindings/media/i2c/adv748x.txt |  72 +-
 MAINTAINERS                                             |   6 +-
 drivers/media/i2c/Kconfig                               |  10 +-
 drivers/media/i2c/Makefile                              |   1 +-
 drivers/media/i2c/adv748x/Makefile                      |   7 +-
 drivers/media/i2c/adv748x/adv748x-afe.c                 | 575 +++++++-
 drivers/media/i2c/adv748x/adv748x-core.c                | 711 +++++++++-
 drivers/media/i2c/adv748x/adv748x-csi2.c                | 283 ++++-
 drivers/media/i2c/adv748x/adv748x-hdmi.c                | 647 ++++++++-
 drivers/media/i2c/adv748x/adv748x.h                     | 218 +++-
 include/media/v4l2-subdev.h                             |   2 +-
 11 files changed, 2531 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt
 create mode 100644 drivers/media/i2c/adv748x/Makefile
 create mode 100644 drivers/media/i2c/adv748x/adv748x-afe.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-core.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-csi2.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x-hdmi.c
 create mode 100644 drivers/media/i2c/adv748x/adv748x.h

base-commit: 4db2a777a71b51a864caae16385b60b4b7e9f992
-- 
git-series 0.9.1
