Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:42576 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753543AbdIDNDj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Sep 2017 09:03:39 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 0/2] media: v4l: Add support for the Cadence MIPI-CSI2 RX
Date: Mon,  4 Sep 2017 15:03:33 +0200
Message-Id: <20170904130335.23280-1-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is an attempt at supporting the MIPI-CSI2 RX block from Cadence.

This IP block is able to receive CSI data over up to 4 lanes, and
split it to over 4 streams. Those streams are basically the interfaces
to the video grabbers that will perform the capture.

It is able to map streams to both CSI datatypes and virtual channels,
dynamically. This is unclear at this point what the right way to
support it would be, so the driver only uses a static mapping between
the virtual channels and streams, and ignores the data types.

This serie depends on the version 5 of the serie "v4l2-async: add subnotifier
registration for subdevices" from Niklas Söderlund.

Let me know what you think!
Maxime

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

 .../devicetree/bindings/media/cdns-csi2rx.txt      |  98 ++++
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/cadence/Kconfig             |  12 +
 drivers/media/platform/cadence/Makefile            |   1 +
 drivers/media/platform/cadence/cdns-csi2rx.c       | 494 +++++++++++++++++++++
 6 files changed, 608 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx.txt
 create mode 100644 drivers/media/platform/cadence/Kconfig
 create mode 100644 drivers/media/platform/cadence/Makefile
 create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c

-- 
2.13.5
