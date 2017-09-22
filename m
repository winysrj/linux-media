Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:59887 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752302AbdIVLrQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 07:47:16 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/2] media: v4l: Add support for the Cadence MIPI-CSI2 TX controller
Date: Fri, 22 Sep 2017 13:47:01 +0200
Message-Id: <20170922114703.30511-1-maxime.ripard@free-electrons.com>
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

This serie depends on the version 14 of the serie "Unified fwnode
endpoint parser, async sub-device notifier support, N9 flash DTS" by
Sakari Ailus

Let me know what you think!
Maxime

Maxime Ripard (2):
  dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindings
  v4l: cadence: Add Cadence MIPI-CSI2 TX driver

 .../devicetree/bindings/media/cdns,csi2tx.txt      |  97 +++++
 drivers/media/platform/cadence/Kconfig             |   6 +
 drivers/media/platform/cadence/Makefile            |   1 +
 drivers/media/platform/cadence/cdns-csi2tx.c       | 479 +++++++++++++++++++++
 4 files changed, 583 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
 create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c

-- 
2.13.5
