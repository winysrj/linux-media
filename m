Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:47862 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbeKCAzB (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2018 20:55:01 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, sakari.ailus@iki.fi
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        linux-kernel@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v4 0/4] MAX9286 GMSL Support
Date: Fri,  2 Nov 2018 15:47:19 +0000
Message-Id: <20181102154723.23662-1-kieran.bingham@ideasonboard.com>
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

This series makes use of Sakari's VC developments and is based upon the
most recent rebase of this series by Niklas at:
  git://git.ragnatech.se/linux/ v4l2/mux

Thanks to the VC developments, this driver is capable of streaming from
all 4 input ports simultaneously through the RCar-VIN capture system.

This driver along with the associated platform support for the Renesas
R-Car Salvator-X, and the Eagle-V3M can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git gmsl/v4


Further anticipated work in this area includes supporting the RDACM21
camera, at which point the RDACM20 will be adapted to separate out the
MAX9271 and the OV10635 sensor components.


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
 drivers/media/i2c/max9286.c                   | 1189 +++++++++++++++++
 drivers/media/i2c/rdacm20-ov10635.h           |  953 +++++++++++++
 drivers/media/i2c/rdacm20.c                   |  635 +++++++++
 9 files changed, 3069 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imi,rdacm20.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
 create mode 100644 drivers/media/i2c/max9286.c
 create mode 100644 drivers/media/i2c/rdacm20-ov10635.h
 create mode 100644 drivers/media/i2c/rdacm20.c

-- 
2.17.1
