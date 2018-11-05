Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:43641 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728122AbeKEUik (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2018 15:38:40 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH 0/6] media: rcar-vin: Add support for R-Car E3
Date: Mon,  5 Nov 2018 12:19:05 +0100
Message-Id: <1541416751-19810-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
    this series add support for the R-Car E3 R8A77990 SoC to the rcar-vin
and rcar-csi2 driver.

Nothing new compared to v2, except for the last two patches, which updates
PHTW tables to the latest SoC manual revision, and add a SoC-specific number
of CSI-2 channels to handle the E3 case properly, as this is the only SoC
in mainline with a number of CSI-2 channels < 4.

Most patches are already reviewed-by and acked-by, so I expect this to
be easy to have accepted.

Tested on E3 Ebisu board capturing frames from the HDMI input in different
resolutions (up to 1280x800). Testing requires Niklas' series to allow using
a numer of data lanes < 4 for ADV748x, PFC and DTS updates.

A branch for testing is available at:
git://jmondi.org/linux ebisu/v4.20-rc1/test

Thanks
   j

Jacopo Mondi (6):
  media: dt-bindings: rcar-vin: Add R8A77990 support
  media: rcar-vin: Add support for R-Car R8A77990
  media: dt-bindings: rcar-csi2: Add R8A77990
  media: rcar-csi2: Add R8A77990 support
  media: rcar: rcar-csi2: Update V3M/E3 PHTW tables
  media: rcar-csi2: Handle per-SoC number of channels

 .../devicetree/bindings/media/rcar_vin.txt         |  1 +
 .../bindings/media/renesas,rcar-csi2.txt           |  1 +
 drivers/media/platform/rcar-vin/rcar-core.c        | 20 +++++
 drivers/media/platform/rcar-vin/rcar-csi2.c        | 95 ++++++++++++++--------
 4 files changed, 82 insertions(+), 35 deletions(-)

--
2.7.4
