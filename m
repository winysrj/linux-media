Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:45383 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729272AbeKFUTP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Nov 2018 15:19:15 -0500
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        kieran.bingham@ideasonboard.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 0/6] media: rcar-vin: Add support for R-Car E3
Date: Tue,  6 Nov 2018 11:54:21 +0100
Message-Id: <1541501667-28817-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
    this series add support for the R-Car E3 R8A77990 SoC to the rcar-vin
and rcar-csi2 driver.

Compared to v3 (which has been sent out without the 'PATCH v3' subject, sorry
about this) I have updated the PHTW tables to match what the datasheet reports
and I have included a comment from Laurent in patch [6/6].

Single patches changelog in commit messages.

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
 drivers/media/platform/rcar-vin/rcar-csi2.c        | 86 +++++++++++++---------
 4 files changed, 74 insertions(+), 34 deletions(-)

--
2.7.4
