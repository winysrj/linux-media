Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39910 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725748AbeJJEQW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 Oct 2018 00:16:22 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        sakari.ailus@iki.fi
Cc: Jacopo Mondi <jacopo@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v3 0/4] MAX9286 GMSL Support
Date: Tue,  9 Oct 2018 21:57:22 +0100
Message-Id: <20181009205726.7664-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series provides a pair of drivers for GMSL cameras on the R-Car
ADAS platforms.

These drivers originate from Cogent Embedded, and have been refactored
to split the MAX9286 away from the RDACM20 drivers which were once very
tightly coupled.

This posting is the culmination of ~100 changesets spread across Jacopo,
Niklas, Laurent and myself - thus they contain all of our SoB tags.

Although this device is capable of handling up to 4 streams, this is not
possible until the VC work comes through from Sakari and as such - this
driver is only functional on a *single* stream.

This driver along with the associated platform support for the Renesas
R-Car Salvator-X, and the Eagle-V3M can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git gmsl/v3

---
v2:
 - Add Jacopo's dt-binding patches
 - Fix MAINTAINERS entries
 - Add imi vendor prefix to Jacopo's patches
 - Remove VC support

v3:
  MAX9286:
    - Initialise notifier with v4l2_async_notifier_init
    - Update for new mbus csi2 format V4L2_MBUS_CSI2_DPHY
  RDACM20:
    - Use new V4L2_MBUS_CSI2_DPHY bus type
    - Remove 'always zero' error print
    - Fix module description
  Bindings:
    - Fixes from Laurent's review comments on V2


Jacopo Mondi (1):
  dt-bindings: media: i2c: Add bindings for IMI RDACM20

Kieran Bingham (2):
  media: i2c: Add MAX9286 driver
  media: i2c: Add RDACM20 driver

Laurent Pinchart (1):
  dt-bindings: media: i2c: Add bindings for Maxim Integrated MAX9286

 .../bindings/media/i2c/imi,rdacm20.txt        |   65 +
 .../bindings/media/i2c/maxim,max9286.txt      |  182 +++
 .../devicetree/bindings/vendor-prefixes.txt   |    1 +
 MAINTAINERS                                   |   20 +
 drivers/media/i2c/Kconfig                     |   22 +
 drivers/media/i2c/Makefile                    |    2 +
 drivers/media/i2c/max9286.c                   | 1136 +++++++++++++++++
 drivers/media/i2c/rdacm20-ov10635.h           |  953 ++++++++++++++
 drivers/media/i2c/rdacm20.c                   |  635 +++++++++
 9 files changed, 3016 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imi,rdacm20.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
 create mode 100644 drivers/media/i2c/max9286.c
 create mode 100644 drivers/media/i2c/rdacm20-ov10635.h
 create mode 100644 drivers/media/i2c/rdacm20.c

-- 
2.17.1
