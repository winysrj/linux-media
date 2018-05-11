Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay12.mail.gandi.net ([217.70.178.232]:43113 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbeEKJ7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 05:59:49 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/5] rcar-vin: Add support for digital input on Gen3
Date: Fri, 11 May 2018 11:59:36 +0200
Message-Id: <1526032781-14319-1-git-send-email-jacopo+renesas@jmondi.org>
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
and parses the 'digital' subdevice, as implemented in patches [2/5] and [3/5].

The series has been tested on D3 Draak platform, which has an HDMI decoder
connected to the parallel input of VIN4. To have capture operations working
properly two additional patches have been added to the series.
[4/5] is a general fix which should imo be included regardless of this series.
[5/5] won't please Niklas, as it discards buffer overflow protection for
the digital capture operations. As explained in the commit message, I had to
fall back to use field toggling on VSYNC input to have images correctly
captured. A possible protection against buffer overflow may be enabling
interrupt for the FIFO overflow and stop capture at that point, but this have to
be discussed later.

A separate series for the VIN4 and HDMI input enabling on Draak board has been
sent to renesas-soc list.

The vin-tests repository patches to automate capture testing have been extended
to support D3 board and capture from HDMI output, and patches have been sent
to Niklas.

The series is based on the media-master tree, where VIN patches have been
recently merged.

Tested capturing HDMI input images on D3 and for backward compatibility on
Salvator-X M3-W too (seems like I didn't break anything there).

Patches for testing on D3 are available at:
git://jmondi.org/linux d3/media-master/driver
git://jmondi.org/linux d3/media-master/dts
git://jmondi.org/linux d3/media-master/test
git://jmondi.org/vin-tests d3

Patches to test on M3-W (based on latest renesas drivers, which includes an
older version of VIN series, but has CSI-2 driver) available at:
git://jmondi.org/linux d3/renesas-drivers/test

Thanks
    j

Jacopo Mondi (5):
  media: rcar-vin: Add support for R-Car R8A77995 SoC
  media: rcar-vin: Add digital input subdevice parsing
  media: rcar-vin: [un]bind and link digital subdevice
  media: rcar-vin: Do not use crop if not configured
  media: rcar-vin: Use FTEV for digital input

 drivers/media/platform/rcar-vin/rcar-core.c | 315 +++++++++++++++++++++++-----
 drivers/media/platform/rcar-vin/rcar-dma.c  |  33 ++-
 drivers/media/platform/rcar-vin/rcar-vin.h  |  13 ++
 3 files changed, 305 insertions(+), 56 deletions(-)

--
2.7.4
