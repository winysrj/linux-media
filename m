Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34336 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbeFEXek (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 19:34:40 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v1 0/4] GMSL Drivers
Date: Wed,  6 Jun 2018 00:34:31 +0100
Message-Id: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
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

Anyway, now that Niklas' VIN and CSI-2 drivers are accepted, a public v1
of these drivers gets the ball rolling and out in the open at last, and
establishes a baseline for continued development.

The patches are based upon Niklas' V4L2 Mux series [0], which is itself
based upon Sakari's VC work [1].

[0] git://git.ragnatech.se/linux/ v4l2/mux
[1] git://linuxtv.org/sailus/media_tree.git vc

The series along with the associated platform support for the
Renesas R-Car Salvator-X, and Eagle-V3M can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kbingham/rcar.git gmsl/v1

Kieran Bingham (4):
  media: dt-bindings: max9286: add device tree binding
  media: i2c: Add MAX9286 driver
  media: dt-bindings: rdacm20: add device tree binding
  media: i2c: Add RDACM20 driver

 .../devicetree/bindings/media/i2c/max9286.txt |   75 ++
 .../devicetree/bindings/media/i2c/rdacm20.txt |   31 +
 .../devicetree/bindings/vendor-prefixes.txt   |    1 +
 MAINTAINERS                                   |   20 +
 drivers/media/i2c/Kconfig                     |   22 +
 drivers/media/i2c/Makefile                    |    2 +
 drivers/media/i2c/max9286.c                   | 1185 +++++++++++++++++
 drivers/media/i2c/rdacm20-ov10635.h           |  953 +++++++++++++
 drivers/media/i2c/rdacm20.c                   |  635 +++++++++
 9 files changed, 2924 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/max9286.txt
 create mode 100644 Documentation/devicetree/bindings/media/i2c/rdacm20.txt
 create mode 100644 drivers/media/i2c/max9286.c
 create mode 100644 drivers/media/i2c/rdacm20-ov10635.h
 create mode 100644 drivers/media/i2c/rdacm20.c

-- 
2.17.0
