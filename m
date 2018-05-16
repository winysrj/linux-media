Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:54079 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbeEPQco (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 12:32:44 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/6] media: rcar-vin: Brush endpoint properties
Date: Wed, 16 May 2018 18:32:26 +0200
Message-Id: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series touches the bindings and the driver handling endpoint
properties for digital subdevices of the R-Car VIN driver.

The first patch simply documents what are the endpoint properties supported
at the moment, then the second one extends them with 'data-active'.

As the VIN hardware allows to use HSYNC as data enable signal when the CLCKENB
pin is left unconnected, the 'data-active' property presence determinates
if HSYNC has to be used or not as data enable signal. As a consequence, when
running with embedded synchronism, and there is not HSYNC signal, it becomes
mandatory to specify 'data-active' polarity in DTS.

To address this, all Gen-2 boards featuring a composite video input and
running with embedded synchronization, now need that property to be specified
in DTS. Before adding it, remove un-used properties as 'pclk-sample' and
'bus-width' from the Gen-2 bindings, as they are not parsed by the VIN driver
and only confuse users.

Niklas, as you already know I don't have any Gen2 board. Could you give this
a spin on Koelsch if you like the series?

Thanks
   j

Jacopo Mondi (6):
  dt-bindings: media: rcar-vin: Describe optional ep properties
  dt-bindings: media: rcar-vin: Document data-active
  media: rcar-vin: Handle data-active property
  media: rcar-vin: Handle CLOCKENB pin polarity
  ARM: dts: rcar-gen2: Remove unused VIN properties
  ARM: dts: rcar-gen2: Add 'data-active' property

 Documentation/devicetree/bindings/media/rcar_vin.txt | 18 +++++++++++++++++-
 arch/arm/boot/dts/r8a7790-lager.dts                  |  4 +---
 arch/arm/boot/dts/r8a7791-koelsch.dts                |  4 +---
 arch/arm/boot/dts/r8a7791-porter.dts                 |  2 +-
 arch/arm/boot/dts/r8a7793-gose.dts                   |  4 +---
 arch/arm/boot/dts/r8a7794-alt.dts                    |  2 +-
 arch/arm/boot/dts/r8a7794-silk.dts                   |  2 +-
 drivers/media/platform/rcar-vin/rcar-core.c          | 10 ++++++++--
 drivers/media/platform/rcar-vin/rcar-dma.c           | 11 +++++++++++
 9 files changed, 42 insertions(+), 15 deletions(-)

--
2.7.4
