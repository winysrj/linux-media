Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54771 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbeEPMRF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 08:17:05 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 0/4]  rcar-vin: Add support for digital input on Gen3
Date: Wed, 16 May 2018 14:16:52 +0200
Message-Id: <1526473016-30559-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
   this series add support for 'digital' input to the Gen3 version of rcar-vin
driver.

'Digital' inputs (the terms comes from the existing Gen2 version of the driver)
describe parallel video input sources connected to a VIN instance. So far, the
Gen3-version of the driver (the media-controller compliant one) only supported
CSI-2 inputs.

This series extends the device tree parsing to accept a connection on port@0,
and parses the 'digital' subdevice reusing the Gen-2 functions.

Compared to v1, this series drops all changes to rcar-dma module, as Niklas
sent a proper fix for both crop and compose rectangle managment and field
signal toggling method. This series is thus based on the media master branch
with Niklas' series on top.

Compared to v1 I incorporated Niklas' suggestion to re-use Gen2 functions for
parsing the digital input device nodes, and register one notifier for each VIN
that has an active connection on port@0. The 'group' notifier then only collects
async subdevices for CSI-2 inputs.

A separate series for the VIN4 and HDMI input enabling on Draak board has been
sent to renesas-soc list.

The vin-tests repository patches to automate capture testing have been extended
to support D3 board and capture from HDMI output, and patches have been sent
to Niklas.

Tested capturing HDMI input images on D3 and for backward compatibility on
Salvator-X M3-W too (seems like I didn't break anything there).

Patches for testing on D3 are available at:
git://jmondi.org/linux d3/media-master/driver-v2
git://jmondi.org/linux d3/media-master/dts
git://jmondi.org/linux d3/media-master/test
git://jmondi.org/vin-tests d3

Patches to test on M3-W (based on latest renesas drivers, which includes an
older version of VIN series, but has CSI-2 driver) available at:
git://jmondi.org/linux d3/renesas-drivers/test

Thanks
    j

Jacopo Mondi (4):
  media: rcar-vin: Parse digital input in mc-path
  media: rcar-vin: Handle mc in digital notifier ops
  media: rcar-vin: Handle digital subdev in link_notify
  media: rcar-vin: Add support for R-Car R8A77995 SoC

 drivers/media/platform/rcar-vin/rcar-core.c | 239 ++++++++++++++++++++++------
 drivers/media/platform/rcar-vin/rcar-vin.h  |  15 ++
 2 files changed, 202 insertions(+), 52 deletions(-)

--
2.7.4
