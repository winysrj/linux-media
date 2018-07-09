Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:53115 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932923AbeGIOTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 10:19:36 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v5 0/6] media: rcar-vin: Brush endpoint properties
Date: Mon,  9 Jul 2018 16:19:15 +0200
Message-Id: <1531145962-1540-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   based on Niklas', Laurent's and Sakari's comments on v4, here it is a new
version of this series brushing R-Car VIN interface device tree bindings
description.

The interface supports the following configurable properties:
- hsync, vsync and data-enable signal polarities
- field signal polarity during even field
- parallel data bus widht and data shift.

As preferred by Niklas, I have listed the properties in the Gen2 section of the
bindings documentation, and referred to them in the Gen3 one.

The series, as v4 did, does introduce a new properties in 'video-interfaces.txt'
and for this reason the audiance is still a little larger than v3.

Thanks
   j

Jacopo Mondi (6):
  dt-bindings: media: rcar-vin: Align Gen2 and Gen3
  dt-bindings: media: rcar-vin: Describe optional ep properties
  dt-bindings: media: Document data-enable-active property
  media: v4l2-fwnode: parse 'data-enable-active' prop
  dt-bindings: media: rcar-vin: Add 'data-enable-active'
  media: rcar-vin: Handle data-enable polarity

 .../devicetree/bindings/media/rcar_vin.txt         | 29 +++++++++++++++++++---
 .../devicetree/bindings/media/video-interfaces.txt |  2 ++
 drivers/media/platform/rcar-vin/rcar-dma.c         |  5 ++++
 drivers/media/v4l2-core/v4l2-fwnode.c              |  4 +++
 include/media/v4l2-mediabus.h                      |  2 ++
 5 files changed, 38 insertions(+), 4 deletions(-)

--
2.7.4
