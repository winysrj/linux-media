Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:44612 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751734AbdGCMk3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 08:40:29 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Neil Webb <neilw@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/2] media: v4l: Add support for the Cadence MIPI-CSI2RX
Date: Mon,  3 Jul 2017 14:40:21 +0200
Message-Id: <20170703124023.28352-1-maxime.ripard@free-electrons.com>
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

This serie depends on the patch "v4l: async: add subnotifier
registration for subdevices" from Niklas Söderlund.

Let me know what you think!
Maxime

Maxime Ripard (2):
  dt-bindings: media: Add Cadence MIPI-CSI2RX Device Tree bindings
  v4l: cadence: Add Cadence MIPI-CSI2 RX driver

 .../devicetree/bindings/media/cdns-csi2rx.txt      |  87 ++++
 drivers/media/platform/Kconfig                     |   1 +
 drivers/media/platform/Makefile                    |   2 +
 drivers/media/platform/cadence/Kconfig             |  12 +
 drivers/media/platform/cadence/Makefile            |   1 +
 drivers/media/platform/cadence/cdns-csi2rx.c       | 440 +++++++++++++++++++++
 6 files changed, 543 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns-csi2rx.txt
 create mode 100644 drivers/media/platform/cadence/Kconfig
 create mode 100644 drivers/media/platform/cadence/Makefile
 create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c

-- 
2.13.0
