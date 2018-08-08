Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33470 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbeHHTQk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 8 Aug 2018 15:16:40 -0400
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: [PATCH v2 0/4] GMSL Drivers
Date: Wed,  8 Aug 2018 17:55:55 +0100
Message-Id: <20180808165559.29957-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series provides an early release of a pair of drivers for GMSL
cameras on the R-Car ADAS platforms.

These drivers originate from Cogent Embedded, and have been refactored
to split the MAX9286 away from the RDACM20 drivers which were once very
tightly coupled.

This posting is the culmination of ~100 changesets spread across Jacopo,
Niklas, Laurent, and myself - thus they contain all of our SoB tags
currently. This may be better suited to be Co-Author tags or such, along
with the original Cogent developer - I'm not sure. But it has certainly
been a considerable effort to get this far. And of course there are
still a few TODO's scattered throughout.

The previous posting of this driver set required Sakari's VC patchset to
function. This post removes this dependancy at the cost of supporting
only the first camera on the MAX9286.

Reducing this functionality could therefore allow integration into the
mainline now, and we can add the VC support in as it arrives.


This driver along with the associated platform support for the Renesas
R-Car Salvator-X, and Eagle-V3M can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git gmsl/v2

---
v2:
 - Add Jacopo's dt-binding patches
 - Fix MAINTAINERS entries
 - Add imi vendor prefix to Jacopo's patches
 - Remove VC support
 

Jacopo Mondi (1):
  dt-bindings: media: i2c: Add bindings for IMI RDACM20

Kieran Bingham (2):
  media: i2c: Add MAX9286 driver
  media: i2c: Add RDACM20 driver

Laurent Pinchart (1):
  dt-bindings: media: i2c: Add bindings for Maxim Integrated MAX9286

 .../bindings/media/i2c/imi,rdacm20.txt        |   62 +
 .../bindings/media/i2c/maxim,max9286.txt      |  180 +++
 .../devicetree/bindings/vendor-prefixes.txt   |    1 +
 MAINTAINERS                                   |   20 +
 drivers/media/i2c/Kconfig                     |   22 +
 drivers/media/i2c/Makefile                    |    2 +
 drivers/media/i2c/max9286.c                   | 1132 +++++++++++++++++
 drivers/media/i2c/rdacm20-ov10635.h           |  953 ++++++++++++++
 drivers/media/i2c/rdacm20.c                   |  635 +++++++++
 9 files changed, 3007 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/imi,rdacm20.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/maxim,max9286.txt
 create mode 100644 drivers/media/i2c/max9286.c
 create mode 100644 drivers/media/i2c/rdacm20-ov10635.h
 create mode 100644 drivers/media/i2c/rdacm20.c

-- 
2.17.1
