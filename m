Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:46862 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750847AbeBHPIn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Feb 2018 10:08:43 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v7 0/2] media: v4l: Add support for the Cadence MIPI-CSI2 RX
Date: Thu,  8 Feb 2018 16:08:28 +0100
Message-Id: <20180208150830.9219-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is the seventh attempt at supporting the MIPI-CSI2 RX block from
Cadence.

This IP block is able to receive CSI data over up to 4 lanes, and
split it to over 4 streams. Those streams are basically the interfaces
to the video grabbers that will perform the capture.

It is able to map streams to both CSI datatypes and virtual channels,
dynamically. This is unclear at this point what the right way to
support it would be, so the driver only uses a static mapping between
the virtual channels and streams, and ignores the data types.

Let me know what you think!
Maxime

Changes from v6:
  - Added Sakari's Acked-by
  - Added Kconfig help
  - Removed the comment in the probe next to the kmalloc

Changes from v5:
  - Use SPDX license header
  - Fix the lane mapping logic and map unused logical lanes only to unused
    physical lanes. Added a comment to explain why.

Changes from v4:
  - Rebased on top of 4.15
  - Fixed a lane mapping issue that prevented the CSI2-RX device to operate
    properly.
  - Reworded the output endpoints documentation in the binding

Changes from v3:
  - Removed stale printk
  - Propagate start/stop functions error code to s_stream
  - Renamed the DT bindings files
  - Clarified the output ports wording in the DT binding doc
  - Added a define for the maximum number of lanes
  - Rebased on top of Sakari's serie
  - Gathered tags based on the reviews

Changes from v2:
  - Added reference counting for the controller initialisation
  - Fixed checkpatch warnings
  - Moved the sensor initialisation after the DPHY configuration
  - Renamed the sensor fields to source for consistency
  - Defined some variables
  - Renamed a few structures variables
  - Added internal and external phy errors messages
  - Reworked the binding slighty by making the external D-PHY optional
  - Moved the notifier registration in the probe function
  - Removed some clocks that are not system clocks
  - Added clocks enabling where needed
  - Added the code to remap the data lanes
  - Changed the memory allocator for the non-devm function, and a
    comment explaining why
  - Reworked the binding wording

Changes from v1:
  - Amended the DT bindings as suggested by Rob
  - Rebase on top of 4.13-rc1 and latest Niklas' serie iteration

Maxime Ripard (2):
  dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
  v4l: cadence: Add Cadence MIPI-CSI2 RX driver

 .../devicetree/bindings/media/cdns,csi2rx.txt      | 100 +++++
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/cadence/Kconfig             |  17 +
 drivers/media/platform/cadence/Makefile            |   1 +
 drivers/media/platform/cadence/cdns-csi2rx.c       | 465 +++++++++++++++++++++
 6 files changed, 586 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2rx.txt
 create mode 100644 drivers/media/platform/cadence/Kconfig
 create mode 100644 drivers/media/platform/cadence/Makefile
 create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c

-- 
2.14.3
