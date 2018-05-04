Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:60945 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751294AbeEDOI0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 10:08:26 -0400
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Benoit Parrot <bparrot@ti.com>, nm@ti.com,
        Simon Hatliff <hatliff@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v12 0/4] media: v4l: Add support for the Cadence MIPI-CSI2 TX controller
Date: Fri,  4 May 2018 16:08:06 +0200
Message-Id: <20180504140810.29497-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Here is a hopefully final attempt at supporting the MIPI-CSI2 RX and
TX blocks from Cadence.

This is a merged serie of the CSI2-RX and CSI2-TX series I've been
sending for a while now and gathered a significant amount of
Reviewed-by/Acked-by. The merge has been done thanks to Sakari's
suggestion to ease the merge and the dependency between the two
drivers on the MAINTAINERS/Kconfig/Makefile sides.

The CSI2-RX has not received any comment on its previous iteration,
and CSI2-TX received some minor comments from Sakari that have been
fixed in this series. You can have a look at the Changelog below if
needed.

The TX controller is able to receive 4 video streams and stream them over a
MIPI-CSI2 link using up to 4 lanes. Those streams are basically the
interfaces to controllers generating some video signals, like a camera
or a pattern generator.

The RX controller is able to receive CSI data over up to 4 lanes, and
split it to over 4 streams. Those streams are basically the interfaces
to the video grabbers that will perform the capture.

TX is then able to map input streams to CSI2 virtual channels and
datatypes dynamically. The streaming devices choose their virtual
channels through an additional signal that is transparent to the
CSI2-TX. The datatypes however are yet another additional input
signal, and can be mapped to any CSI2 datatypes. RX can do the
opposite, being able to take virtual channel / datatypes and route
them to proper pixel interfaces on demand.

Since v4l2 doesn't really allow for that setup at the moment, this
preliminary version is a rather dumb one in order to start the
discussion on how to address this properly.

Let me know what you think!
Maxime

Changes from v11:
  - Added Makefile license
  - Added Benoit's Acked-by
  - Ignored the CSI2-RX return code on stop, and just log an error
    instead

Changes from CSI2-TX v10:
  - Reword the source pad exception comment
  - Handle the V4L2_SUBDEV_FORMAT_TRY case for get_fmt / set_fmt

Maxime Ripard (4):
  dt-bindings: media: Add Cadence MIPI-CSI2 RX Device Tree bindings
  v4l: cadence: Add Cadence MIPI-CSI2 RX driver
  dt-bindings: media: Add Cadence MIPI-CSI2 TX Device Tree bindings
  v4l: cadence: Add Cadence MIPI-CSI2 TX driver

 .../devicetree/bindings/media/cdns,csi2rx.txt | 100 ++++
 .../devicetree/bindings/media/cdns,csi2tx.txt |  98 +++
 MAINTAINERS                                   |   7 +
 drivers/media/platform/Kconfig                |   1 +
 drivers/media/platform/Makefile               |   1 +
 drivers/media/platform/cadence/Kconfig        |  34 ++
 drivers/media/platform/cadence/Makefile       |   4 +
 drivers/media/platform/cadence/cdns-csi2rx.c  | 498 ++++++++++++++++
 drivers/media/platform/cadence/cdns-csi2tx.c  | 563 ++++++++++++++++++
 9 files changed, 1306 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2rx.txt
 create mode 100644 Documentation/devicetree/bindings/media/cdns,csi2tx.txt
 create mode 100644 drivers/media/platform/cadence/Kconfig
 create mode 100644 drivers/media/platform/cadence/Makefile
 create mode 100644 drivers/media/platform/cadence/cdns-csi2rx.c
 create mode 100644 drivers/media/platform/cadence/cdns-csi2tx.c

-- 
2.17.0
