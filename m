Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:51002 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753836AbeBGO0q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Feb 2018 09:26:46 -0500
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
Subject: [PATCH v3 0/2] media: v4l: Add support for the Cadence MIPI-CSI2 TX controller
Date: Wed,  7 Feb 2018 15:26:41 +0100
Message-Id: <20180207142643.15746-1-maxime.ripard@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is an attempt at supporting the MIPI-CSI2 TX block from Cadence.

This IP block is able to receive 4 video streams and stream them over
a MIPI-CSI2 link using up to 4 lanes. Those streams are basically the
interfaces to controllers generating some video signals, like a camera
or a pattern generator.

It is able to map input streams to CSI2 virtual channels and datatypes
dynamically. The streaming devices choose their virtual channels
through an additional signal that is transparent to the CSI2-TX. The
datatypes however are yet another additional input signal, and can be
mapped to any CSI2 datatypes.

Since v4l2 doesn't really allow for that setup at the moment, this
preliminary version is a rather dumb one in order to start the
discussion on how to address this properly.

Let me know what you think!
Maxime

Changes from v2:
  - Use SPDX license header
  - Use the lane mapping from DT

Changes from v1:
  - Add a subdev notifier and start our downstream subdevice in
    s_stream  
  - Based the decision to enable the stream or not on the link state
    instead of whether a format was being set on the pad
  - Put the controller back in reset when stopping the pipeline
  - Clarified the enpoints number in the DT binding
  - Added a default format for the pads
  - Added some missing const
  - Added more explicit comments
  - Rebased on 4.15

Maxime Ripard (2):
  dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindings
  v4l: cadence: Add Cadence MIPI-CSI2 TX driver

 .../devicetree/bindings/media/cdns,csi2tx.txt      |  98 ++++
 drivers/media/platform/cadence/Kconfig             |   6 +
 drivers/media/platform/cadence/Makefile            |   1 +
 drivers/media/platform/cadence/cdns-csi2tx.c       | 582 +++++++++++++++++++++
 4 files changed, 687 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
 create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c

-- 
2.14.3
